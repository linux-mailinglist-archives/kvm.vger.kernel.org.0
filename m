Return-Path: <kvm+bounces-66833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B40FACE95E7
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:26:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 23E0630039CB
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F382E2F0E;
	Tue, 30 Dec 2025 10:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RcJ0ploy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQIq3j9r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4832E9729
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089774; cv=none; b=F8n8o5TdROrtOvD8nxwa+MGl6f452CTYtWN2SoimRyUplB1jS2ZSVGIHLkfHSDg3PLDZSlxgYg5xTXSVkqPLqBRKzFOJAyHXKJ/69s0ASJ5fiHfJT8j+VzvXIEcpnZPFMaxte2AQJ9MEDRVJ7fP4NK4Vvg1QUsqeYPUMdeNFOic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089774; c=relaxed/simple;
	bh=N4HR0a5dn05GuDoktJG7BnG9Lq/5EUgyVWUyfL7k7BY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5t9i1HUuJgOpL71f8kZKHUJjlB63L61EIE4rOXe2URIVgZVVUTFiaI4ToUqCUvDn0ml7NnVzH+VW4rBW+JuWcML9yffW5mz7QqTOEY+BVc0JtnZ+kKDfXIRPwZ0FSq15Bsm7dXJtfpO29ZuouVKYGEFLd4WA0ZP9zQK29ypPco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RcJ0ploy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQIq3j9r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5P8nBFllNyVQLFQFLwvEGLPOI82khKcPXA1snN92gfM=;
	b=RcJ0ploymHq1vUdXzVoEnkbM+zTGziork6HDMTeWoVQdoaBkfjt8hHkt5NAGaWQ5lh7OvP
	uFzyeQSmftpAU32VQJI9HRkyScODsAUMg4Ll/sGzQ7B75yszp6+giWGV7M9X1KcMgQnOsT
	9NeM6FsHee7DzELhQKftuBHyQijsMMo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-ZfAbQWxhNRC4EZxZO0nEyQ-1; Tue, 30 Dec 2025 05:16:08 -0500
X-MC-Unique: ZfAbQWxhNRC4EZxZO0nEyQ-1
X-Mimecast-MFC-AGG-ID: ZfAbQWxhNRC4EZxZO0nEyQ_1767089768
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fcb6b2ebso5739124f8f.2
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089767; x=1767694567; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5P8nBFllNyVQLFQFLwvEGLPOI82khKcPXA1snN92gfM=;
        b=BQIq3j9rguJWyrvd0HjPJXDNX+NtKpiHoktjQ29KrPuk2LNpuwJpCc9WXELU8o7gNm
         Jb1EOjk1yaT9PsO1B2M8gfgNnJAxvHZG+N7/4B+h/UwegvZFOQX8D6kM2j9s8xRWcTpM
         0nVTeZVfJmIKk4C5/OplOmF7GDLe/WK4CGK6SgD7uPojWxMLwmbEwHX4A7ao9OQp+x2n
         ao7u0hEVzvtDO4P24+hzhy93IJZLc8wLn6O0iguKMLX4lXYMQjs0Uer4FLR+Pzof99lP
         Z+iTthyfW4pkHSfY829nZaRdtzGJXbwyxiVIRWEymLLBJLvbP8ubz8MVqXrDVuTi8z9B
         3OBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089767; x=1767694567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5P8nBFllNyVQLFQFLwvEGLPOI82khKcPXA1snN92gfM=;
        b=WWw94jM/qPkNXi148/D6H9IF17NPLN4jpnAUl9KAuppWuI3o73H81UpRi2648NimJx
         GELHHSwlZDWusdMpI1Wn2SURwBnaQcabz52b2PG9sCtSo/wZGEtFVw3SncwxZOvF+Ot+
         HM4ktVxlSQ5dsbxbOXsrg/CAKOLCNPR2bjJJqCjMFrDb0NZKdgHtLdK2EoKLVEV6RjOW
         6r954nhGo7BilO0xY/iGLi6tK3BXH3BnYmlxjcX2HzsbqPBEk2AECmRsZDJF0j97JUnY
         fL4OFD3pTLkL7FClX3yjmt4zTcTnbZrJd5rILjqi6RgEjW5AbQdtfJX2+LVMcWY063EV
         vCjw==
X-Forwarded-Encrypted: i=1; AJvYcCV4ksLkNwVSpNrqy5IGa/Rh/q9i3HsGnLl0JRXboqUaqJWanH+0MN4o+qN2kLH4pvFHUQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLdlXzaVtxX84nzB/HUV1O0adQmaxXHHPxAVou7kemFrDgOWUl
	60bbXyqsQi3FyPv97RUe1dbn6OXm7TIzmCIHjWemwHJWxxHRGxsyTsabyu/uvY1KRjRXPnmTHtb
	kbZFovR488X+dtZNb8Q8iJrT0lmiF7qWmKPyr2c8EE+OE6rY6NiAImA==
X-Gm-Gg: AY/fxX61zbFviFKnYCLX7Z79+FMIm/BikrDDbPtf2Jq/VLbUBccclg+00miLDRmHZsY
	dSgsYYk83BhafZRy82OhRS9j2tMwO7CMsHuE7z02P7zh+T8UxyEY/GZBWotTZj7GFL7iOdDfTub
	KMMEPNI+yG81KIQm/604CFlFBPa7zy/YyfyNF2M7TUzzF6u0fcTIXvVrwbztxo3Cft7UeRs0XLZ
	tSCurLEU9ywlKBuK9QeTV1DV4wG2YksS2oFBwM1CZ44fh4E0J9HLXdzw7X+gP8sk0wQMl6Bnsg2
	9GnWjGdmCZUBTkdo2MyL/EJeJiHi/COg0m/No0iCBMPPcHa3pMV2jqNAdxgVZx8OOUavpVs1flb
	dIhIRp+PFXbJoBb5vEgWNneOGV3Ajgn/NsA==
X-Received: by 2002:a5d:5f54:0:b0:431:2b2:9628 with SMTP id ffacd0b85a97d-4324e506ba3mr39259957f8f.52.1767089767431;
        Tue, 30 Dec 2025 02:16:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtsdMUlb1wS6GR5OayFkymlWIYaYAnUxOGKY8jeZK45Dwg0ymMw4lZ1+63FGBt0jVsyojNrA==
X-Received: by 2002:a5d:5f54:0:b0:431:2b2:9628 with SMTP id ffacd0b85a97d-4324e506ba3mr39259899f8f.52.1767089766895;
        Tue, 30 Dec 2025 02:16:06 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa477bsm67834948f8f.36.2025.12.30.02.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:06 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:03 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 06/13] virtio: add virtqueue_add_inbuf_cache_clean API
Message-ID: <e5a7240e7c8e590c4745a76c4ab4d76f7f8bd88c.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Add virtqueue_add_inbuf_cache_clean() for passing DMA_ATTR_CPU_CACHE_CLEAN
to virtqueue operations. This suppresses DMA debug cacheline overlap
warnings for buffers where proper cache management is ensured by the
caller.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_ring.c | 72 ++++++++++++++++++++++++++----------
 include/linux/virtio.h       |  5 +++
 2 files changed, 58 insertions(+), 19 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 1832ea7982a6..19a4a8cd22f9 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -382,7 +382,7 @@ static int vring_mapping_error(const struct vring_virtqueue *vq,
 /* Map one sg entry. */
 static int vring_map_one_sg(const struct vring_virtqueue *vq, struct scatterlist *sg,
 			    enum dma_data_direction direction, dma_addr_t *addr,
-			    u32 *len, bool premapped)
+			    u32 *len, bool premapped, unsigned long attr)
 {
 	if (premapped) {
 		*addr = sg_dma_address(sg);
@@ -410,7 +410,7 @@ static int vring_map_one_sg(const struct vring_virtqueue *vq, struct scatterlist
 	 */
 	*addr = virtqueue_map_page_attrs(&vq->vq, sg_page(sg),
 					 sg->offset, sg->length,
-					 direction, 0);
+					 direction, attr);
 
 	if (vring_mapping_error(vq, *addr))
 		return -ENOMEM;
@@ -539,7 +539,8 @@ static inline int virtqueue_add_split(struct vring_virtqueue *vq,
 				      void *data,
 				      void *ctx,
 				      bool premapped,
-				      gfp_t gfp)
+				      gfp_t gfp,
+				      unsigned long attr)
 {
 	struct vring_desc_extra *extra;
 	struct scatterlist *sg;
@@ -605,7 +606,8 @@ static inline int virtqueue_add_split(struct vring_virtqueue *vq,
 			dma_addr_t addr;
 			u32 len;
 
-			if (vring_map_one_sg(vq, sg, DMA_TO_DEVICE, &addr, &len, premapped))
+			if (vring_map_one_sg(vq, sg, DMA_TO_DEVICE, &addr, &len,
+					     premapped, attr))
 				goto unmap_release;
 
 			prev = i;
@@ -622,7 +624,8 @@ static inline int virtqueue_add_split(struct vring_virtqueue *vq,
 			dma_addr_t addr;
 			u32 len;
 
-			if (vring_map_one_sg(vq, sg, DMA_FROM_DEVICE, &addr, &len, premapped))
+			if (vring_map_one_sg(vq, sg, DMA_FROM_DEVICE, &addr, &len,
+					     premapped, attr))
 				goto unmap_release;
 
 			prev = i;
@@ -1315,7 +1318,8 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 					 unsigned int in_sgs,
 					 void *data,
 					 bool premapped,
-					 gfp_t gfp)
+					 gfp_t gfp,
+					 unsigned long attr)
 {
 	struct vring_desc_extra *extra;
 	struct vring_packed_desc *desc;
@@ -1346,7 +1350,7 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
 			if (vring_map_one_sg(vq, sg, n < out_sgs ?
 					     DMA_TO_DEVICE : DMA_FROM_DEVICE,
-					     &addr, &len, premapped))
+					     &addr, &len, premapped, attr))
 				goto unmap_release;
 
 			desc[i].flags = cpu_to_le16(n < out_sgs ?
@@ -1441,7 +1445,8 @@ static inline int virtqueue_add_packed(struct vring_virtqueue *vq,
 				       void *data,
 				       void *ctx,
 				       bool premapped,
-				       gfp_t gfp)
+				       gfp_t gfp,
+				       unsigned long attr)
 {
 	struct vring_packed_desc *desc;
 	struct scatterlist *sg;
@@ -1466,7 +1471,7 @@ static inline int virtqueue_add_packed(struct vring_virtqueue *vq,
 
 	if (virtqueue_use_indirect(vq, total_sg)) {
 		err = virtqueue_add_indirect_packed(vq, sgs, total_sg, out_sgs,
-						    in_sgs, data, premapped, gfp);
+						    in_sgs, data, premapped, gfp, attr);
 		if (err != -ENOMEM) {
 			END_USE(vq);
 			return err;
@@ -1502,7 +1507,7 @@ static inline int virtqueue_add_packed(struct vring_virtqueue *vq,
 
 			if (vring_map_one_sg(vq, sg, n < out_sgs ?
 					     DMA_TO_DEVICE : DMA_FROM_DEVICE,
-					     &addr, &len, premapped))
+					     &addr, &len, premapped, attr))
 				goto unmap_release;
 
 			flags = cpu_to_le16(vq->packed.avail_used_flags |
@@ -2244,14 +2249,17 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 				void *data,
 				void *ctx,
 				bool premapped,
-				gfp_t gfp)
+				gfp_t gfp,
+				unsigned long attr)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
 	return vq->packed_ring ? virtqueue_add_packed(vq, sgs, total_sg,
-					out_sgs, in_sgs, data, ctx, premapped, gfp) :
+					out_sgs, in_sgs, data, ctx, premapped, gfp,
+					attr) :
 				 virtqueue_add_split(vq, sgs, total_sg,
-					out_sgs, in_sgs, data, ctx, premapped, gfp);
+					out_sgs, in_sgs, data, ctx, premapped, gfp,
+					attr);
 }
 
 /**
@@ -2289,7 +2297,7 @@ int virtqueue_add_sgs(struct virtqueue *_vq,
 			total_sg++;
 	}
 	return virtqueue_add(_vq, sgs, total_sg, out_sgs, in_sgs,
-			     data, NULL, false, gfp);
+			     data, NULL, false, gfp, 0);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_sgs);
 
@@ -2311,7 +2319,7 @@ int virtqueue_add_outbuf(struct virtqueue *vq,
 			 void *data,
 			 gfp_t gfp)
 {
-	return virtqueue_add(vq, &sg, num, 1, 0, data, NULL, false, gfp);
+	return virtqueue_add(vq, &sg, num, 1, 0, data, NULL, false, gfp, 0);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_outbuf);
 
@@ -2334,7 +2342,7 @@ int virtqueue_add_outbuf_premapped(struct virtqueue *vq,
 				   void *data,
 				   gfp_t gfp)
 {
-	return virtqueue_add(vq, &sg, num, 1, 0, data, NULL, true, gfp);
+	return virtqueue_add(vq, &sg, num, 1, 0, data, NULL, true, gfp, 0);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_outbuf_premapped);
 
@@ -2356,10 +2364,36 @@ int virtqueue_add_inbuf(struct virtqueue *vq,
 			void *data,
 			gfp_t gfp)
 {
-	return virtqueue_add(vq, &sg, num, 0, 1, data, NULL, false, gfp);
+	return virtqueue_add(vq, &sg, num, 0, 1, data, NULL, false, gfp, 0);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_inbuf);
 
+/**
+ * virtqueue_add_inbuf_cache_clean - expose input buffers with cache clean hint
+ * @vq: the struct virtqueue we're talking about.
+ * @sg: scatterlist (must be well-formed and terminated!)
+ * @num: the number of entries in @sg writable by other side
+ * @data: the token identifying the buffer.
+ * @gfp: how to do memory allocations (if necessary).
+ *
+ * Adds DMA_ATTR_CPU_CACHE_CLEAN attribute to suppress overlapping cacheline
+ * warnings in DMA debug builds. Has no effect in production builds.
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ *
+ * Returns zero or a negative error (ie. ENOSPC, ENOMEM, EIO).
+ */
+int virtqueue_add_inbuf_cache_clean(struct virtqueue *vq,
+				    struct scatterlist *sg, unsigned int num,
+				    void *data,
+				    gfp_t gfp)
+{
+	return virtqueue_add(vq, &sg, num, 0, 1, data, NULL, false, gfp,
+			     DMA_ATTR_CPU_CACHE_CLEAN);
+}
+EXPORT_SYMBOL_GPL(virtqueue_add_inbuf_cache_clean);
+
 /**
  * virtqueue_add_inbuf_ctx - expose input buffers to other end
  * @vq: the struct virtqueue we're talking about.
@@ -2380,7 +2414,7 @@ int virtqueue_add_inbuf_ctx(struct virtqueue *vq,
 			void *ctx,
 			gfp_t gfp)
 {
-	return virtqueue_add(vq, &sg, num, 0, 1, data, ctx, false, gfp);
+	return virtqueue_add(vq, &sg, num, 0, 1, data, ctx, false, gfp, 0);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_inbuf_ctx);
 
@@ -2405,7 +2439,7 @@ int virtqueue_add_inbuf_premapped(struct virtqueue *vq,
 				  void *ctx,
 				  gfp_t gfp)
 {
-	return virtqueue_add(vq, &sg, num, 0, 1, data, ctx, true, gfp);
+	return virtqueue_add(vq, &sg, num, 0, 1, data, ctx, true, gfp, 0);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_inbuf_premapped);
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 3626eb694728..63bb05ece8c5 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -62,6 +62,11 @@ int virtqueue_add_inbuf(struct virtqueue *vq,
 			void *data,
 			gfp_t gfp);
 
+int virtqueue_add_inbuf_cache_clean(struct virtqueue *vq,
+				    struct scatterlist sg[], unsigned int num,
+				    void *data,
+				    gfp_t gfp);
+
 int virtqueue_add_inbuf_ctx(struct virtqueue *vq,
 			    struct scatterlist sg[], unsigned int num,
 			    void *data,
-- 
MST


