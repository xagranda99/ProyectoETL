--1. Mostrar el genero con mas ventas del ultimo anio (mostrar el total) que sean mayores a $25, Mostrar el nombre de la playlist a la que pertenecen, y el total de clientes que ha tenido ese genero.
SELECT p.Name AS NombrePlaylist,
       g.Name AS Genero,
       Sum(it.UnitPrice) AS Total,
       count(DISTINCT c.customerId) AS Clientes
  FROM invoices i
       JOIN
       customers c ON i.customerId = c.customerId
       JOIN
       invoice_items it ON i.invoiceId = it.invoiceId
       JOIN
       tracks t ON it.trackId = t.trackId
       JOIN
       genres g ON t.genreId = g.genreId
       JOIN
       playlist_track pt ON t.trackId = pt.trackId
       JOIN
       playlists p ON pt.playlistId = p.playlistId
 WHERE i.invoiceDate LIKE '2013%'
 GROUP BY 2
 ORDER BY Total DESC;
 
--2. Mostrar todas las pistas y cuantos veces la compraron, mostrar el total en ventas y el nombre de su playlist a la que pertenece. (SOLO VENTAS HECHAS EN USA)
SELECT t.trackId,
       g.Name AS Genero,
       ar.Name AS Artista,
       t.Name AS NombreCancion,
       mt.Name AS TipoMedio,
       count(it.invoiceId) AS VecesComprada,
       sum(it.UnitPrice) AS Ventas,
       i.billingCountry AS Pais
  FROM tracks t
       JOIN
       invoice_items it ON t.trackId = it.trackId
       JOIN
       invoices i ON it.invoiceId = i.invoiceId
       JOIN
       genres g ON t.genreId = g.genreId
       JOIN
       albums al ON t.albumId = al.albumId
       JOIN
       artists ar ON al.artistId = ar.artistId
       JOIN
       media_types mt ON t.mediaTypeId = mt.mediaTypeId
       where i.billingCountry like 'USA'
 GROUP BY i.billingCountry;
 

--3. Mostar el artista con mas canciones, presentar el total de la suma de milisegundos, el total de ingresos que ha tenido y la playlist a la que pertenece
SELECT ar.artistId AS ID,
       ar.Name AS Artista,
       group_concat(DISTINCT g.Name) Generos,
       group_concat(DISTINCT mt.Name) TiposDeMedio,
       count(t.trackId) AS TotalPistas,
       sum(t.Milliseconds) as TotalMilisegundos,
       round(sum(it.UnitPrice),2) AS Ventas
  FROM tracks t
       JOIN
       albums al ON t.albumId = al.albumId
       JOIN
       artists ar ON al.artistId = ar.artistId
       JOIN
       invoice_items it ON t.trackId = it.trackId
       JOIN
       invoices i ON it.invoiceId = i.invoiceId
       JOIN
       genres g ON t.genreId = g.genreId
       JOIN
       media_types mt ON t.mediaTypeId = mt.mediaTypeId
 GROUP BY 1
 ORDER BY TotalPistas DESC;
 
--4. Mostrar los 10 clientes con mayor valor en compras, presentar el empleado asignado, asi como tambien su superior. Indicar la ciudad, de facturacion, y el numero de pistas compradas.

SELECT c.customerId as ID,
       c.FIRSTNAME || ' ' || c.LASTNAME AS Cliente,
       e.FIRSTNAME || ' ' || e.LASTNAME AS EmpleadoAsignado,
       count(DISTINCT g.Name) as Cantidad_Generos_Comprados,
       count(DISTINCT al.Title) as Cantidad_Albums_Comprados,
       round(sum(it.UnitPrice),2) AS Total
  FROM invoices i
       INNER JOIN
       customers c ON i.customerId = c.customerId
       JOIN
       employees e ON c.SupportRepId = e.EmployeeId
       JOIN
       invoice_items it ON i.invoiceId = it.invoiceId
       JOIN
       tracks t ON t.trackId = it.trackId
       JOIN
       genres g ON t.genreId = g.genreId
       JOIN
       albums al ON t.albumId = al.albumId
 GROUP BY 1
 ORDER BY 6 DESC;


--5. Mostrar todas las pistas que fueron compradas al menos una vez, e indicar el genero, el artista, y la factura a la que pertenece. Indicar el precio de la pista y el tipo de medio.
SELECT t.Name AS 'Nombre canción',
       t.UnitPrice AS 'Precio unitario',
       m.Name AS 'Tipo de archivo',
       p.Name AS Playlist,
       art.Name AS Artista,
       g.Name AS Genero,
       v.invoiceId AS 'ID De Factura',
       v.InvoiceDate AS 'Fecha compra',
       v.Total AS Total
  FROM tracks t
       JOIN
       media_types mt ON mt.MediaTypeId = t.MediaTypeId
       JOIN
       media_types AS m ON t.MediaTypeId = m.MediaTypeId
       JOIN
       playlist_track AS pt ON pt.TrackId = t.TrackId
       JOIN
       playlists p ON p.PlaylistId = pt.PlaylistId
       JOIN
       albums ab ON ab.AlbumId = t.AlbumId
       JOIN
       artists art ON art.ArtistId = ab.ArtistId
       JOIN
       genres g ON g.GenreId = t.GenreId
       JOIN
       invoice_items vl ON vl.TrackId = t.TrackId
       JOIN
       invoices v ON v.InvoiceId = vl.InvoiceId
 GROUP BY 7
 ORDER BY 1;

--6.Mostrar el cliente que mas ha comprado al artista AC/DC, Idicar el id, el cliente, el artista, el genero y el valor total
SELECT C.CUSTOMERID AS ID,
       C.FIRSTNAME || ' ' || C.LASTNAME AS Cliente,
       AR.NAME AS Artista,
       g.Name AS Genero,
       SUM(IL.UNITPRICE) AS Precio
  FROM customers C
       JOIN
       invoices I ON C.CUSTOMERID = I.CUSTOMERID
       JOIN
       invoice_items IL ON I.INVOICEID = IL.INVOICEID
       JOIN
       tracks T ON IL.TRACKID = T.TRACKID
       JOIN
       albums AL ON T.ALBUMID = AL.ALBUMID
       JOIN
       genres g ON t.genreId = g.genreId
       JOIN
       artists AR ON AL.ARTISTID = AR.ARTISTID
 WHERE AR.NAME = 'AC/DC'
 GROUP BY 1,
          2,
          3
 ORDER BY 5 DESC
 LIMIT 1;
 --7. Contar cuántas canciones según generos compró el cliente con id = 1, Mostrar el total y adicional el numero de albums de
SELECT G.NAME AS Genero,
       COUNT(T.NAME) AS PistasCompradas,
       count(DISTINCT ar.artistId) AS ArtistasComprados,
       c.FirstName || ' ' || c.LastName AS Cliente,
       e.FirstName || ' ' || e.LastName AS EmpleadoAsignado,
       sum(it.UnitPrice) AS Total
  FROM customers c
       JOIN
       invoices i ON i.CustomerId = c.CustomerId
       JOIN
       invoice_items it ON it.invoiceId = i.invoiceId
       JOIN
       tracks t ON t.trackId = it.trackId
       JOIN
       genres g ON g.genreId = t.genreId
       JOIN
       employees e ON c.SupportRepId = e.EmployeeId
       JOIN
       albums al ON t.albumId = al.albumId
       JOIN
       artists ar ON al.ARTISTID = ar.ARTISTID
 WHERE c.CustomerId = 1
 GROUP BY 1
 ORDER BY 1;

 
--8. ¿Quién está escribiendo MAS CANCIONES DE música rock? Escriba una consulta que devuelva los nombre del artista y el 
--número total de pistas y el tipo de medio
SELECT ar.Name AS NombreArtista,
       g.Name AS NombreGenero,
       COUNT(t.Name) AS CancionesGeneradas,
       count(DISTINCT c.CustomerId) AS NumeroClientes,
       mt.Name AS TipoMedio,
       it.UnitPrice AS Precio_Por_Cancion
  FROM tracks t
       JOIN
       genres g ON t.GenreId = g.GenreId
       JOIN
       albums al ON al.AlbumId = t.AlbumId
       JOIN
       artists ar ON ar.ArtistId = al.ArtistId
       JOIN
       media_types mt ON t.MediaTypeId = mt.MediaTypeId
       JOIN
       invoice_items it ON t.trackId = it.trackId
       JOIN
       invoices i ON it.invoiceId = i.invoiceId
       JOIN
       customers c ON i.customerId = c.customerId
 WHERE g.Name = 'Jazz'
 GROUP BY 1
 ORDER BY 3 DESC;
 
--9. Seleccionar todas las pistas e incluir el conteo de veces comprada, 
--presentar el nombre de la cancion, el precio unitariom el tipo de archivo (MediaType), 
--La playlist, el album, el artista, el genero, y los datos de facutra, mostrar el total de la factura.

SELECT t.Name AS [Nombre canción],
       t.UnitPrice AS [Precio unitario],
       m.Name AS [Tipo de archivo],
       p.Name AS Playlist,
       ab.Title AS Album,
       art.Name AS Artista,
       g.Name AS Genero,
       count(v.InvoiceDate) AS VecesComprada
  FROM tracks t
       LEFT JOIN
       media_types mt ON mt.MediaTypeId = t.MediaTypeId
       LEFT JOIN
       media_types AS m ON t.MediaTypeId = m.MediaTypeId
       LEFT JOIN
       playlist_track AS pt ON pt.TrackId = t.TrackId
       LEFT JOIN
       playlists p ON p.PlaylistId = pt.PlaylistId
       LEFT JOIN
       albums ab ON ab.AlbumId = t.AlbumId
       LEFT JOIN
       artists art ON art.ArtistId = ab.ArtistId
       LEFT JOIN
       genres g ON g.GenreId = t.GenreId
       JOIN
       invoice_items vl ON vl.TrackId = t.TrackId
       JOIN
       invoices v ON v.InvoiceId = vl.InvoiceId
 GROUP BY 1
 ORDER BY 8 DESC;


--10. Cuales son los 5 generos mas vendidos en Alemania?
---------------------------------------------------
SELECT g.Name AS Genero,
       round(sum(it.UnitPrice), 2) AS Total,
       COUNT(DISTINCT ab.albumId) as Albumes,
       count(DISTINCT art.artistId) as Artistas
  FROM tracks t
       INNER JOIN
       genres g ON t.GenreId = g.GenreId
       INNER JOIN
       invoice_items it ON t.TrackId = it.TrackId
       INNER JOIN
       invoices i ON it.InvoiceId = i.InvoiceId
       INNER JOIN
       albums ab ON ab.AlbumId = t.AlbumId
       INNER JOIN
       artists art ON art.ArtistId = ab.ArtistId
 WHERE i.BillingCountry = 'Belgium'
 GROUP BY g.GenreId
 ORDER BY COUNT(t.TrackId) DESC;