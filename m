Return-Path: <kvm+bounces-29791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B18F9B1EB7
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDF24281E8E
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257D11DD0ED;
	Sun, 27 Oct 2024 14:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GU2WiE85"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309CB1DCB0D;
	Sun, 27 Oct 2024 14:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038997; cv=none; b=vCVICtXpRCJn+HQ8Flg846RUiKtiB6BVBxGhsnFcxnltJTx2wzic+CXUNcM2bjfXuSf/lcHmthHSdT8wkBBfhGeyj25fDvbZIfTVJMwOdxVOxYePQ2xGN2OpHRaKxdKobuu6jEpZlMZoIO6azIXFnO1r1OXrZRn375UOC7HQTd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038997; c=relaxed/simple;
	bh=ZAkEvCDpOQpT4FqrkcEPmIofeDg0rb/b5+lEupSm25s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VC74ksCS/CoJ9Wx+FeY81aKcljslT/YyaDwtmUgG+4k2fCpHyI0+aCmLt7kQMEElPcFEfv3ofpF3b7fF02PFmw6E3N1W2t2ItC80aRSzI9BFQ1y2T+Dsgzpc5C6kCmJ0CMlNTbUZYO/gDy9kb6miICcLIsCBWDt9h70g7NNhHIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GU2WiE85; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38793C4CEC3;
	Sun, 27 Oct 2024 14:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730038997;
	bh=ZAkEvCDpOQpT4FqrkcEPmIofeDg0rb/b5+lEupSm25s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GU2WiE85QkyrGZabT77HMzH4RzcXBtUoK7DX8razab6E7GlTeZ2LQTeNI7ZRCEXcF
	 +9yMHm9zDo08nuNcPNZNSsuaYkBUL9ipGLwLInfLmk0HejWEa8WPu1R8UqdKOsPV74
	 Z5wpY7UYyju99OwvD8w7GPbHNbCOK/zLgPk0s2GMr97M3wN8lKofvcDQjgjNlAIopH
	 eIYUU6O634Ehr1WlX/W3GKJbeoFI2GpQCheDt+O+VjGAz5sar3RgcEymVxHQmnOdc4
	 uO+VYU+gZUk1F3VsP3juUi2vi+UCZ40ddUDVpK0TRukr1wrJIDD2IoyIOcFlFa0aTT
	 I1l2OPb8MTV4g==
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
Subject: [RFC PATCH 3/7] blk-mq: add a dma mapping iterator
Date: Sun, 27 Oct 2024 16:21:56 +0200
Message-ID: <9b7c6203fbbae90821f2220dba1bd600e3bd23ba.1730037261.git.leon@kernel.org>
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

blk_rq_map_sg is maze of nested loops.  Untangle it by creating an
iterator that returns [paddr,len] tuples for DMA mapping, and then
implement the DMA logic on top of this.  This not only removes code
at the source level, but also generates nicer binary code:

$ size block/blk-merge.o.*
   text	   data	    bss	    dec	    hex	filename
  10001	    432	      0	  10433	   28c1	block/blk-merge.o.new
  10317	    468	      0	  10785	   2a21	block/blk-merge.o.old

Last but not least it will be used as a building block for a new
DMA mapping helper that doesn't rely on struct scatterlist.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-merge.c | 182 ++++++++++++++++++++--------------------------
 1 file changed, 77 insertions(+), 105 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index ad763ec313b6..b63fd754a5de 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -451,137 +451,109 @@ unsigned int blk_recalc_rq_segments(struct request *rq)
 	return nr_phys_segs;
 }
 
-static inline struct scatterlist *blk_next_sg(struct scatterlist **sg,
-		struct scatterlist *sglist)
+struct phys_vec {
+	phys_addr_t	paddr;
+	u32		len;
+};
+
+static bool blk_map_iter_next(struct request *req,
+		struct req_iterator *iter, struct phys_vec *vec)
 {
-	if (!*sg)
-		return sglist;
+	unsigned int max_size;
+	struct bio_vec bv;
 
 	/*
-	 * If the driver previously mapped a shorter list, we could see a
-	 * termination bit prematurely unless it fully inits the sg table
-	 * on each mapping. We KNOW that there must be more entries here
-	 * or the driver would be buggy, so force clear the termination bit
-	 * to avoid doing a full sg_init_table() in drivers for each command.
+	 * For special payload requests there only is a single segment.  Return
+	 * it now and make sure blk_phys_iter_next stop iterating.
 	 */
-	sg_unmark_end(*sg);
-	return sg_next(*sg);
-}
+	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
+		if (!iter->bio)
+			return false;
+		vec->paddr = bvec_phys(&req->special_vec);
+		vec->len = req->special_vec.bv_len;
+		iter->bio = NULL;
+		return true;
+	}
 
-static unsigned blk_bvec_map_sg(struct request_queue *q,
-		struct bio_vec *bvec, struct scatterlist *sglist,
-		struct scatterlist **sg)
-{
-	unsigned nbytes = bvec->bv_len;
-	unsigned nsegs = 0, total = 0;
+	if (!iter->iter.bi_size)
+		return false;
 
-	while (nbytes > 0) {
-		unsigned offset = bvec->bv_offset + total;
-		unsigned len = get_max_segment_size(&q->limits,
-				bvec_phys(bvec) + total, nbytes);
-		struct page *page = bvec->bv_page;
+	bv = mp_bvec_iter_bvec(iter->bio->bi_io_vec, iter->iter);
+	vec->paddr = bvec_phys(&bv);
+	max_size = get_max_segment_size(&req->q->limits, vec->paddr, UINT_MAX);
+	bv.bv_len = min(bv.bv_len, max_size);
+	bio_advance_iter_single(iter->bio, &iter->iter, bv.bv_len);
 
-		/*
-		 * Unfortunately a fair number of drivers barf on scatterlists
-		 * that have an offset larger than PAGE_SIZE, despite other
-		 * subsystems dealing with that invariant just fine.  For now
-		 * stick to the legacy format where we never present those from
-		 * the block layer, but the code below should be removed once
-		 * these offenders (mostly MMC/SD drivers) are fixed.
-		 */
-		page += (offset >> PAGE_SHIFT);
-		offset &= ~PAGE_MASK;
+	/*
+	 * If we are entirely done with this bi_io_vec entry, check if the next
+	 * one could be merged into it.  This typically happens when moving to
+	 * the next bio, but some callers also don't pack bvecs tight.
+	 */
+	while (!iter->iter.bi_size || !iter->iter.bi_bvec_done) {
+		struct bio_vec next;
+
+		if (!iter->iter.bi_size) {
+			if (!iter->bio->bi_next)
+				break;
+			iter->bio = iter->bio->bi_next;
+			iter->iter = iter->bio->bi_iter;
+		}
 
-		*sg = blk_next_sg(sg, sglist);
-		sg_set_page(*sg, page, len, offset);
+		next = mp_bvec_iter_bvec(iter->bio->bi_io_vec, iter->iter);
+		if (bv.bv_len + next.bv_len > max_size ||
+		    !biovec_phys_mergeable(req->q, &bv, &next))
+			break;
 
-		total += len;
-		nbytes -= len;
-		nsegs++;
+		bv.bv_len += next.bv_len;
+		bio_advance_iter_single(iter->bio, &iter->iter, next.bv_len);
 	}
 
-	return nsegs;
+	vec->len = bv.bv_len;
+	return true;
 }
 
-static inline int __blk_bvec_map_sg(struct bio_vec bv,
-		struct scatterlist *sglist, struct scatterlist **sg)
-{
-	*sg = blk_next_sg(sg, sglist);
-	sg_set_page(*sg, bv.bv_page, bv.bv_len, bv.bv_offset);
-	return 1;
-}
+#define blk_phys_to_page(_paddr) \
+	(pfn_to_page(__phys_to_pfn(_paddr)))
 
-/* only try to merge bvecs into one sg if they are from two bios */
-static inline bool
-__blk_segment_map_sg_merge(struct request_queue *q, struct bio_vec *bvec,
-			   struct bio_vec *bvprv, struct scatterlist **sg)
+static inline struct scatterlist *blk_next_sg(struct scatterlist **sg,
+		struct scatterlist *sglist)
 {
-
-	int nbytes = bvec->bv_len;
-
 	if (!*sg)
-		return false;
-
-	if ((*sg)->length + nbytes > queue_max_segment_size(q))
-		return false;
-
-	if (!biovec_phys_mergeable(q, bvprv, bvec))
-		return false;
-
-	(*sg)->length += nbytes;
-
-	return true;
-}
-
-static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
-			     struct scatterlist *sglist,
-			     struct scatterlist **sg)
-{
-	struct bio_vec bvec, bvprv = { NULL };
-	struct bvec_iter iter;
-	int nsegs = 0;
-	bool new_bio = false;
-
-	for_each_bio(bio) {
-		bio_for_each_bvec(bvec, bio, iter) {
-			/*
-			 * Only try to merge bvecs from two bios given we
-			 * have done bio internal merge when adding pages
-			 * to bio
-			 */
-			if (new_bio &&
-			    __blk_segment_map_sg_merge(q, &bvec, &bvprv, sg))
-				goto next_bvec;
-
-			if (bvec.bv_offset + bvec.bv_len <= PAGE_SIZE)
-				nsegs += __blk_bvec_map_sg(bvec, sglist, sg);
-			else
-				nsegs += blk_bvec_map_sg(q, &bvec, sglist, sg);
- next_bvec:
-			new_bio = false;
-		}
-		if (likely(bio->bi_iter.bi_size)) {
-			bvprv = bvec;
-			new_bio = true;
-		}
-	}
+		return sglist;
 
-	return nsegs;
+	/*
+	 * If the driver previously mapped a shorter list, we could see a
+	 * termination bit prematurely unless it fully inits the sg table
+	 * on each mapping. We KNOW that there must be more entries here
+	 * or the driver would be buggy, so force clear the termination bit
+	 * to avoid doing a full sg_init_table() in drivers for each command.
+	 */
+	sg_unmark_end(*sg);
+	return sg_next(*sg);
 }
 
 /*
- * map a request to scatterlist, return number of sg entries setup. Caller
- * must make sure sg can hold rq->nr_phys_segments entries
+ * Map a request to scatterlist, return number of sg entries setup. Caller
+ * must make sure sg can hold rq->nr_phys_segments entries.
  */
 int __blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		struct scatterlist *sglist, struct scatterlist **last_sg)
 {
+	struct req_iterator iter = {
+		.bio	= rq->bio,
+		.iter	= rq->bio->bi_iter,
+	};
+	struct phys_vec vec;
 	int nsegs = 0;
 
-	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
-		nsegs = __blk_bvec_map_sg(rq->special_vec, sglist, last_sg);
-	else if (rq->bio)
-		nsegs = __blk_bios_map_sg(q, rq->bio, sglist, last_sg);
+	while (blk_map_iter_next(rq, &iter, &vec)) {
+		struct page *page = blk_phys_to_page(vec.paddr);
+		unsigned int offset = offset_in_page(vec.paddr);
+
+		*last_sg = blk_next_sg(last_sg, sglist);
+		sg_set_page(*last_sg, page, vec.len, offset);
+		nsegs++;
+	}
 
 	if (*last_sg)
 		sg_mark_end(*last_sg);
-- 
2.46.2


