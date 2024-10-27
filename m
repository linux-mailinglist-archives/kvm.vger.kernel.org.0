Return-Path: <kvm+bounces-29785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB1A69B1E94
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB238281BE5
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C9A1D90BD;
	Sun, 27 Oct 2024 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8n4IOYj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677AC17C7CC;
	Sun, 27 Oct 2024 14:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038973; cv=none; b=RP3GQy6A5KOmZ9x1GtEUCna/XNYIwYkHMz+d11m4CeVhLmawiZexHj3f9XDrZdVtJez6N16/2y1py9no4m+So9O+FdfMN1ewOtBGjvNIn8ZWLf39yDDbz5RVT18xTLesyzCIEtQUJCV3DEzx+XwvFiUmbWtP6wSSbC/DMR0qNw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038973; c=relaxed/simple;
	bh=xs6fvM8ovmipSkvK4QHs63+5zfVZxbyL5606zTIt2PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7hdKp8AQhw5gXTcJeGFeInoQb0350EupQnutVKR2U2gWMfUTbFAIoQmMHvb6QL9bjy5B8Xs01YGfA50NhgYXlG7SO/PKtYwNL9QjV7WSCclfXxSGldGEQiOqPZOgRMSzVEKdudj/l5lmpgc3S98td31KoQznAHgR/mm2Yc7hAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8n4IOYj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334A2C4CEE5;
	Sun, 27 Oct 2024 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730038973;
	bh=xs6fvM8ovmipSkvK4QHs63+5zfVZxbyL5606zTIt2PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8n4IOYjkU+t+CyiP5M3EN8uu0+Fhy6+/w3iTz0Q2atQ8SbLeJALE1g9BoSjijj8S
	 PhFXdSulUwQafrHIn9TUpPBoI8HneaOXwC+JJ/0p97sfDVhUC3RNK3PE04HkzCC/4J
	 cWhbJk1wzm2NbKHYjlRlEPHMWjX6NITYLwV/dH6J33RTjaJ7fOIVz0CcVhtzsLzNex
	 /phptkTCnClXhaWaw4eIffed64MThYl7FGZrLdyzju3U2a2z40qKT8ylqHMywRXe7K
	 zG/3VBzIUTnaCnNjKwQ0rxt3cmXGFfMIET1vHtTft+96gIQ+u7gpzegw5AhZuk1QEm
	 Ay7ibRcVje6YQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/7] block: don't merge different kinds of P2P transfers in a single bio
Date: Sun, 27 Oct 2024 16:21:55 +0200
Message-ID: <34d44537a65aba6ede215a8ad882aeee028b423a.1730037261.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730037261.git.leon@kernel.org>
References: <cover.1730037261.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

To get out of the dma mapping helpers having to check every segment for
it's P2P status, ensure that bios either contain P2P transfers or non-P2P
transfers, and that a P2P bio only contains ranges from a single device.

This means we do the page zone access in the bio add path where it should
be still page hot, and will only have do the fairly expensive P2P topology
lookup once per bio down in the dma mapping path, and only for already
marked bios.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/bio.c               | 36 +++++++++++++++++++++++++++++-------
 block/blk-map.c           | 32 ++++++++++++++++++++++++--------
 include/linux/blk_types.h |  2 ++
 3 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2d3bc8bfb071..943a6d78cb3e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -928,8 +928,6 @@ static bool bvec_try_merge_page(struct bio_vec *bv, struct page *page,
 		return false;
 	if (xen_domain() && !xen_biovec_phys_mergeable(bv, page))
 		return false;
-	if (!zone_device_pages_have_same_pgmap(bv->bv_page, page))
-		return false;
 
 	*same_page = ((vec_end_addr & PAGE_MASK) == ((page_addr + off) &
 		     PAGE_MASK));
@@ -993,6 +991,14 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 	if (bio->bi_vcnt > 0) {
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
+		/*
+		 * When doing ZONE_DEVICE-based P2P transfers, all pages in a
+		 * bio must be P2P pages from the same device.
+		 */
+		if ((bio->bi_opf & REQ_P2PDMA) &&
+		    !zone_device_pages_have_same_pgmap(bv->bv_page, page))
+			return 0;
+
 		if (bvec_try_merge_hw_page(q, bv, page, len, offset,
 				same_page)) {
 			bio->bi_iter.bi_size += len;
@@ -1009,6 +1015,9 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 		 */
 		if (bvec_gap_to_prev(&q->limits, bv, offset))
 			return 0;
+	} else {
+		if (is_pci_p2pdma_page(page))
+			bio->bi_opf |= REQ_P2PDMA | REQ_NOMERGE;
 	}
 
 	bvec_set_page(&bio->bi_io_vec[bio->bi_vcnt], page, len, offset);
@@ -1133,11 +1142,24 @@ static int bio_add_page_int(struct bio *bio, struct page *page,
 	if (bio->bi_iter.bi_size > UINT_MAX - len)
 		return 0;
 
-	if (bio->bi_vcnt > 0 &&
-	    bvec_try_merge_page(&bio->bi_io_vec[bio->bi_vcnt - 1],
-				page, len, offset, same_page)) {
-		bio->bi_iter.bi_size += len;
-		return len;
+	if (bio->bi_vcnt > 0) {
+		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+		/*
+		 * When doing ZONE_DEVICE-based P2P transfers, all pages in a
+		 * bio must be P2P pages from the same device.
+		 */
+		if ((bio->bi_opf & REQ_P2PDMA) &&
+		    !zone_device_pages_have_same_pgmap(bv->bv_page, page))
+			return 0;
+
+		if (bvec_try_merge_page(bv, page, len, offset, same_page)) {
+			bio->bi_iter.bi_size += len;
+			return len;
+		}
+	} else {
+		if (is_pci_p2pdma_page(page))
+			bio->bi_opf |= REQ_P2PDMA | REQ_NOMERGE;
 	}
 
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
diff --git a/block/blk-map.c b/block/blk-map.c
index 0e1167b23934..03192b1ca6ea 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -568,6 +568,7 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
 	const struct queue_limits *lim = &q->limits;
 	unsigned int nsegs = 0, bytes = 0;
 	struct bio *bio;
+	int error;
 	size_t i;
 
 	if (!nr_iter || (nr_iter >> SECTOR_SHIFT) > queue_max_hw_sectors(q))
@@ -588,15 +589,30 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
 	for (i = 0; i < nr_segs; i++) {
 		struct bio_vec *bv = &bvecs[i];
 
-		/*
-		 * If the queue doesn't support SG gaps and adding this
-		 * offset would create a gap, fallback to copy.
-		 */
-		if (bvprvp && bvec_gap_to_prev(lim, bvprvp, bv->bv_offset)) {
-			blk_mq_map_bio_put(bio);
-			return -EREMOTEIO;
+		error = -EREMOTEIO;
+		if (bvprvp) {
+			/*
+			 * If the queue doesn't support SG gaps and adding this
+			 * offset would create a gap, fallback to copy.
+			 */
+			if (bvec_gap_to_prev(lim, bvprvp, bv->bv_offset))
+				goto put_bio;
+
+			/*
+			 * When doing ZONE_DEVICE-based P2P transfers, all pages
+			 * in a bio must be P2P pages, and from the same device.
+			 */
+			if ((bio->bi_opf & REQ_P2PDMA) &&
+			    zone_device_pages_have_same_pgmap(bvprvp->bv_page,
+					bv->bv_page))
+				goto put_bio;
+		} else {
+			if (is_pci_p2pdma_page(bv->bv_page))
+				bio->bi_opf |= REQ_P2PDMA | REQ_NOMERGE;
 		}
+
 		/* check full condition */
+		error = -EINVAL;
 		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
 			goto put_bio;
 		if (bytes + bv->bv_len > nr_iter)
@@ -611,7 +627,7 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
 	return 0;
 put_bio:
 	blk_mq_map_bio_put(bio);
-	return -EINVAL;
+	return error;
 }
 
 /**
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index dce7615c35e7..94cf146e8ce6 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -378,6 +378,7 @@ enum req_flag_bits {
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
 	__REQ_ATOMIC,		/* for atomic write operations */
+	__REQ_P2PDMA,		/* contains P2P DMA pages */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -410,6 +411,7 @@ enum req_flag_bits {
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
+#define REQ_P2PDMA	(__force blk_opf_t)(1ULL << __REQ_P2PDMA)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
-- 
2.46.2


