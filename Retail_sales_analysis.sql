-- Create Table
create table Retail_sales(
	transactions_id	INT primary key,
	sale_date date,
	sale_time time,
	customer_id INT,
	gender Varchar(15),
	age	int,
	category Varchar(15),
	quantiy	int,
	price_per_unit float,	
	cogs float,
	total_sale float

);

select count(*) from Retail_sales

select * from Retail_sales

select count(distinct(customer_id)) from Retail_sales

-- Data Cleaning
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

select distinct category from Retail_sales

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from Retail_sales
where sale_date = '2022-11-05' 

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

select * from Retail_sales
where category = 'Clothing' and quantity >= 4 and to_char(sale_date, 'YYYY-MM') = '2022-11'

select * from Retail_sales
where category = 'Clothing' and quantity >= 4 and EXTRACT(MONTH FROM sale_date) = 11 AND EXTRACT(YEAR FROM sale_date) = 2022;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select Category , sum(total_sale) 
from Retail_sales
group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select Category , round(Avg(age),2) umar
from Retail_sales
group by 1
having Category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select transactions_id , total_sale
from Retail_sales
where total_sale > 1000

select count(transactions_id)
from Retail_sales
where total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select gender , count(transactions_id)
from Retail_sales
group by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
select 
	EXTRACT(YEAR FROM sale_date) as year , 
	EXTRACT(MONTH FROM sale_date) as month , 
	AVG(total_sale) as avg_sale,
	rank() over(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
from Retail_sales
group by 1 , 2
) as t1
where  rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id , sum(total_sale)
from Retail_sales
group by 1
order by sum(total_sale) desc
limit 5 ;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category , count(DISTINCT customer_id)
from Retail_sales
group by 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift