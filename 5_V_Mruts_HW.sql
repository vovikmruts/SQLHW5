use master
go
drop database if exists V_MRUTS
go
create database V_MRUTS
go

use V_MRUTS
go

create table [suppliers] (
	supplierid			integer,
	name				varchar(20),
	rating				integer,
	city				varchar(20),
	constraint supplr_pk PRIMARY KEY (supplierid)
);	

create table [details] (
	detailid			integer,
	name				varchar(20),
	color				varchar(20),
	weight				integer,
	city				varchar(20),
	constraint detail_pk PRIMARY KEY (detailid)
);	

create table [products] (
	productid			integer,
	name				varchar(20),
	city				varchar(20),
	constraint product_pk PRIMARY KEY (productid)
);		

create table [supplies] (
	supplierid			integer,
	detailid			integer,
	productid			integer,
	quantity			integer,
	constraint suppl_supplr_fk FOREIGN KEY (supplierid) REFERENCES suppliers (supplierid),
	constraint suppl_detail_fk FOREIGN KEY (detailid) REFERENCES details (detailid),
	constraint suppl_product_fk FOREIGN KEY (productid) REFERENCES products (productid),
);

---INSERTS------
insert into suppliers(
	supplierid,
	name,
	rating,
	city
)
values
(1, 'Smith', 20, 'London'),
(2, 'Jonth', 10, 'Paris'),
(3, 'Blacke', 30, 'Paris'),
(4, 'Clarck', 20, 'London'),
(5, 'Adams', 30, 'Athens');

insert into details(
	detailid,
	name,
	color,
	weight,
	city
)
values
(1, 'Screw', 'red', 12, 'London'),
(2, 'Bolt', 'green', 17, 'Paris'),
(3, 'Male-screw', 'blue', 17, 'Roma'),
(4, 'Male-screw', 'red', 14, 'London'),
(5, 'Whell', 'blue', 12, 'Paris'),
(6, 'Bloom', 'red', 19, 'London');

insert into products(
	productid,
	name,
	city
)
values
(1, 'HDD', 'Paris'),
(2, 'Perforator', 'Roma'),
(3, 'Reader', 'Athens'),
(4, 'Printer', 'Athens'),
(5, 'FDD', 'London'),
(6, 'Terminal', 'Oslo'),
(7, 'Ribbon', 'London');

insert into supplies(
	supplierid,
	detailid,
	productid,
	quantity
	
)
values
(1, 1, 1, 200),
(1, 1, 4, 700),
(2, 3, 1, 400),
(2, 3, 2, 200),
(2, 3, 3, 200),
(2, 3, 4, 500),
(2, 3, 5, 600),
(2, 3, 6, 400),
(2, 3, 7, 800),
(2, 5, 2, 100),
(3, 3, 1, 200),
(3, 4, 2, 500),
(4, 6, 3, 300),
(4, 6, 7, 300),
(5, 2, 2, 200),
(5, 2, 4, 100),
(5, 5, 5, 500),
(5, 5, 7, 100),
(5, 6, 2, 200),
(5, 1, 4, 100),
(5, 3, 4, 200),
(5, 4, 4, 800),
(5, 5, 4, 400),
(5, 6, 4, 500);


---Tasks------
---[a]------
SELECT DISTINCT productid
FROM products
WHERE productid NOT IN (SELECT productid FROM supplies WHERE supplierid != '3');

INSERT INTO products VALUES (123, 'test for 1', 'Antalya');---Inserting data for test
INSERT INTO supplies VALUES (3, 2, 123, 14),
(3, 1, 123, 24),(3, 3, 123, 15);

---[b]------
SELECT s.supplierid, s.name
FROM suppliers AS s
WHERE s.supplierid IN (
SELECT DISTINCT sss.supplierid FROM supplies AS sss WHERE detailid= 1 AND sss.quantity > (
SELECT AVG(quantity) FROM supplies WHERE detailid = 1 AND productid = sss.productid)
);

---[c]------
SELECT d.detailid, d.name, d.color, d.weight, d.city
FROM details AS d
WHERE detailid IN (
SELECT detailid FROM supplies WHERE productid IN (
SELECT productid FROM products WHERE city = 'London'));

---[d]------
SELECT DISTINCT supplierid, name
FROM suppliers
WHERE supplierid IN (
SELECT supplierid FROM supplies
WHERE detailid IN (
SELECT detailid FROM details WHERE color = 'Red'));

---[e]------
SELECT DISTINCT d.detailid
FROM details AS d
WHERE detailid IN (
SELECT detailid FROM supplies WHERE supplierid = 2);

---[f]------
SELECT p.productid
FROM products AS p
WHERE productid IN (
SELECT s2.productid FROM supplies AS s2 WHERE (
SELECT AVG(quantity) FROM supplies WHERE productid = s2.productid)  > (
SELECT MAX(quantity) FROM supplies WHERE productid = 1)
);


SELECT AVG(quantity) FROM supplies
GROUP BY productid; --- 2 queries for assurance
SELECT MAX(quantity) FROM supplies 
WHERE productid = 1;

---[g]------
SELECT p.productid, p.name
FROM products AS p
WHERE productid NOT IN (SELECT DISTINCT productid FROM supplies);

INSERT INTO products VALUES (334, 'test','test city for task G');




---[CTE]---------
---[a]------
;WITH nat_ETC AS(
SELECT 1 AS frst
UNION ALL
SELECT frst + 1 FROM nat_ETC
WHERE frst < 1000
)
SELECT * FROM nat_ETC
OPTION (MAXRECURSION 1000);

---[b]------
;WITH Fact AS(
   SELECT 1 AS N, CAST(1 AS BIGINT) AS Factorial
   UNION ALL
   SELECT N + 1, (N + 1) * Factorial 
   FROM Fact
   WHERE N < 10
)
SELECT TOP 1 N AS Position, Factorial AS Value FROM Fact
ORDER BY Position DESC;

---[c]------
 ;WITH Fib AS
 (
   SELECT 1 AS prev, 1 AS next, 1 AS Position
   UNION ALL
   SELECT next, next + prev, Position +1 FROM Fib
   WHERE position < 20
 )
 SELECT Position , prev AS Value FROM Fib;
  
---[d]------
DECLARE @BeginPeriod DATETIME = '2013-11-25',
        @EndPeriod DATETIME = '2014-03-05'

;WITH months AS
(
    SELECT DATEADD(month, DATEDIFF(month, 0, '2013-11-25'), 0) AS StartOfMonth, 
           DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, @BeginPeriod) + 1, 0)) AS EndOfMonth
    UNION ALL
    SELECT DATEADD(month, 1, StartOfMonth) AS StartOfMonth, 
           DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, DATEADD(month, 1, StartOfMonth)) + 1, 0)) AS EndOfMonth  
    FROM   months
    WHERE  DATEADD(month, 1, StartOfMonth) <= @EndPeriod
)
SELECT  
    CONVERT(varchar(10), (CASE WHEN StartOfMonth < @BeginPeriod THEN @BeginPeriod ELSE StartOfMonth END), 121) AS StartDate,
    CONVERT(varchar(10), (CASE WHEN EndOfMonth > @EndPeriod THEN @EndPeriod ELSE EndOfMonth END), 121) AS EndDate
FROM months;

---[e]------
SET DATEFIRST 1;
GO
;WITH CTE_DatesTable
AS
(
  SELECT CAST('20190701' as date) AS [date]
  UNION ALL
  SELECT   DATEADD(dd, 1, [date])
  FROM CTE_DatesTable
  WHERE DATEADD(dd, 1, [date]) <= '20190731'
)
SELECT [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday] FROM
(SELECT DayDate = DATEPART(dd,[date]), WeekDayName = DATENAME(dw,[date]), [WeekNumber] = DATEPART(WEEK, [date]) FROM CTE_DatesTable) AS ST
PIVOT
(
MIN(DayDate)
FOR WeekDayName IN ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday])
)
AS PivotTable
OPTION (MAXRECURSION 0);



---GEOGRAPHY------
---[a]------
create table [geography]
(id int not null primary key, name varchar(20), region_id int);

ALTER TABLE [geography]
ADD CONSTRAINT R_GB
FOREIGN KEY (region_id)
REFERENCES [geography]  (id);


insert into [geography] values (1, 'Ukraine', null);
insert into [geography] values (2, 'Lviv', 1);
insert into [geography] values (8, 'Brody', 2);
insert into [geography] values (18, 'Gayi', 8);
insert into [geography] values (9, 'Sambir', 2);
insert into [geography] values (17, 'St.Sambir', 9);
insert into [geography] values (10, 'Striy', 2);
insert into [geography] values (11, 'Drogobych', 2);
insert into [geography] values (15, 'Shidnytsja', 11);
insert into [geography] values (16, 'Truskavets', 11);
insert into [geography] values (12, 'Busk', 2);
insert into [geography] values (13, 'Olesko', 12);
insert into [geography] values (30, 'Lvivska st', 13);
insert into [geography] values (14, 'Verbljany', 12);
insert into [geography] values (3, 'Rivne', 1);
insert into [geography] values (19, 'Dubno', 3);
insert into [geography] values (31, 'Lvivska st', 19);
insert into [geography] values (20, 'Zdolbuniv', 3);
insert into [geography] values (4, 'Ivano-Frankivsk', 1);
insert into [geography] values (21, 'Galych', 4);
insert into [geography] values (32, 'Svobody st', 21);
insert into [geography] values (22, 'Kalush', 4);
insert into [geography] values (23, 'Dolyna', 4);
insert into [geography] values (5, 'Kiyv', 1);
insert into [geography] values (24, 'Boryspil', 5);
insert into [geography] values (25, 'Vasylkiv', 5);
insert into [geography] values (6, 'Sumy', 1);
insert into [geography] values (26, 'Shostka', 6);
insert into [geography] values (27, 'Trostjanets', 6);
insert into [geography] values (7, 'Crimea', 1);
insert into [geography] values (28, 'Yalta', 7);
insert into [geography] values (29, 'Sudack', 7);

---[b]------
;WITH reg_CTE AS (
SELECT region_id, id AS placeid, name, 1 AS PlaceLevel FROM [Geography]
WHERE region_id = '1'
)
SELECT * from reg_CTE;

---[c]------
;WITH reg_CTE AS (
SELECT region_id, id AS Place_ID, name, 0 AS PlaceLevel FROM [Geography]
WHERE region_id  = 4
UNION ALL 
SELECT scnd.region_id, scnd.id, scnd.name, PlaceLevel + 1 FROM reg_CTE AS frst
INNER JOIN [geography] AS scnd ON frst.Place_ID = scnd.region_id 
)
SELECT * from reg_CTE;

---[d]------
;WITH Ukraine AS(
SELECT name, id, region_id, 1 AS level, CAST(name AS VARCHAR(255)) AS Path
FROM geography
WHERE id = 1
UNION ALL
SELECT i.name, i.id, i.region_id, level + 1, CAST(Path + '.' + CAST(i.id AS VARCHAR(255)) AS VARCHAR(255))
FROM geography i
INNER JOIN Ukraine U ON u.id = i.region_id)
SELECT name, id, region_id, level FROM Ukraine ORDER BY Path;

---[e]------
;WITH Lviv AS(
SELECT name, id, region_id, 1 AS level, CAST(name AS VARCHAR(255)) AS Path
FROM geography
WHERE id = 2
UNION ALL
SELECT i.name, i.id, i.region_id, level + 1, CAST(Path + '.' + CAST(i.id AS VARCHAR(255)) AS VARCHAR(255))
FROM geography i
INNER JOIN Lviv l ON l.id = i.region_id)
SELECT name, id, region_id, level FROM Lviv ORDER BY Path;

---[f]------
;WITH Lviv AS(
SELECT name, id, region_id, 1 AS level, CAST(name AS VARCHAR(255)) AS Path
FROM geography
WHERE id = 2
UNION ALL
SELECT i.name, i.id, i.region_id, level + 1, CAST(Path + '/' + CAST(i.name AS VARCHAR(255)) AS VARCHAR(255))
FROM geography i
INNER JOIN Lviv l ON l.id = i.region_id)
SELECT name, level, ('/' + path) AS path FROM Lviv ORDER BY Path; ---In example column 'Level' was named as 'id' by mistake

---[g]------
;WITH Lviv AS(
SELECT name, id, region_id, 1 AS pathlen, CAST(name AS VARCHAR(255)) AS Path
FROM geography
WHERE region_id = 2
UNION ALL
SELECT i.name, i.id, i.region_id, pathlen + 1, CAST(Path + '/' + CAST(i.name AS VARCHAR(255)) AS VARCHAR(255))
FROM geography i
INNER JOIN Lviv l ON l.id = i.region_id)
SELECT name,(SELECT name FROM geography WHERE id = 2) AS center, pathlen, ('/Lviv/' + path) AS path FROM Lviv ORDER BY Path ---Select in second column was wrote just for decreasing number of 'Lviv' in query





---UNION, UNION ALL, EXCEPT, INTERSECT ------
---[a]------
SELECT supplierid, name
FROM suppliers
WHERE city = 'London'
UNION 
SELECT supplierid, name
FROM suppliers
WHERE city = 'Paris';

---[b]------
---AND details
SELECT city
FROM suppliers
INTERSECT
SELECT city
FROM details
ORDER BY city;

---OR details
SELECT DISTINCT city
FROM suppliers
UNION ALL
SELECT DISTINCT city
FROM details
ORDER BY city; ---If need all dublicates in 2 tables: delete DISTINCT

SELECT city
FROM suppliers
UNION
SELECT city
FROM details
ORDER BY city;

---[c]------
SELECT DISTINCT supplierid, name 
FROM suppliers
EXCEPT
SELECT DISTINCT supplierid, name
FROM suppliers
WHERE city = 'London';  ---Using DISTINCT because of mentor`s advice in skype conversation

---[d]------
(
SELECT productid, name, city
FROM products
WHERE city IN ('Paris', 'London')
EXCEPT
SELECT productid, name, city
FROM products
WHERE city IN ('Paris', 'Roma')
)
UNION
(
SELECT productid, name, city
FROM products
WHERE city IN ('Paris', 'Roma')
EXCEPT
SELECT productid, name, city
FROM products
WHERE city IN ('Paris', 'London')
); --- if it`s symmetric difference

SELECT productid, name, city
FROM products
WHERE city IN ('Paris', 'London')
EXCEPT
SELECT productid, name, city
FROM products
WHERE city IN ('Paris', 'Roma'); --- if it`s just A1 - A2

---[e]------
---If option "Not from Paris" is only for second select
SELECT sp.supplierid, sp.detailid, sp.productid
FROM supplies AS sp
INNER JOIN suppliers AS s
ON sp.supplierid = s.supplierid
WHERE s.city = 'London'
UNION
(
SELECT sp.supplierid, sp.detailid, sp.productid
FROM supplies AS sp
INNER JOIN details AS d
ON sp.detailid = d.detailid
INNER JOIN products AS p
ON sp.productid = p.productid
WHERE d.color = 'green' AND p.city != 'Paris' ---If option "Not from Paris" is only for second select
); ---If using second WHERE option


SELECT sp.supplierid, sp.detailid, sp.productid
FROM supplies AS sp
INNER JOIN suppliers AS s
ON sp.supplierid = s.supplierid
WHERE s.city = 'London'
UNION
(
SELECT sp.supplierid, sp.detailid, sp.productid
FROM supplies AS sp
INNER JOIN details AS d
ON sp.detailid = d.detailid
WHERE d.color = 'green'
EXCEPT
SELECT sp.supplierid, sp.detailid, sp.productid
FROM supplies AS sp
INNER JOIN products AS p
ON sp.productid = p.productid
WHERE p.city != 'Paris'
); --- if using except instead of second WHERE option

