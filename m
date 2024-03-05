Return-Path: <kvm+bounces-10968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE3B871D8E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24ACFB220E9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036A85FDB3;
	Tue,  5 Mar 2024 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sE3ROVKU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202D95FB9D;
	Tue,  5 Mar 2024 11:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709637593; cv=none; b=k1WkzQ6/oiggW1rS8slR5Yd/5eJs6MJMt6MmohqN4H2fJ1CeCOAZMEW4G3BHB5c9mr4rhCI689/cck5fTW91LVo7eJf1vbhD81N0lRIKGe+w1CZrWZnKjbtXCoDmmhMTqMPCUO3fBtEHDDH+TWOiv1mUvb8K47SI/bzYMsosxAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709637593; c=relaxed/simple;
	bh=LoE4Mk2h+x4QygNOYAaQkErlcP1J9OkI1WKvPNtdRq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bimzl/tNhIQxJMxi+p2dOyci8myzoJWdibLEEMCcSXvK5MpaDPW4FQ4yN+HLxpug4+1COEVpV/i58D4iItKKjocvw2YT6Ld8Ox0qyIajyV4OC173aULGd/naeuxHfbG2l8gvI3eKTT44oiMZqtz3+GPW9fXer5SDD4u2/NZln2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sE3ROVKU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A093C433C7;
	Tue,  5 Mar 2024 11:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709637592;
	bh=LoE4Mk2h+x4QygNOYAaQkErlcP1J9OkI1WKvPNtdRq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sE3ROVKUx5nlUBmQ1UDC4LListp7vH8VXfLmm9fyCvv8NB4GmDIxkbggaQ4SxXnE0
	 mvNE5IdOjICDtawe/pkNhuWfWOzOpUOcrElvhYVanrDlwvm48luEZXTHbEFagcL5V6
	 9PIU6O93gbKt9Az+UNSvmMcWTf09Bbhsp9Guzd3l+1YIn/eXnyBzk37vfgDnODIwcO
	 eQmXyU8tgclJJntRDMkAHcYVxrMFajV5C64PY/XvgQvQ8LDiJIYbBQ0z5sgP59/5jf
	 U1XvMP/wgNcsfu1tDnnqWg7VxucsOm+cnxMiVPHer4OWILzUKVQBtCzGMihNBlkVJx
	 GRjraaS+NWUHA==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [RFC RESEND 15/16] block: add dma_link_range() based API
Date: Tue,  5 Mar 2024 13:18:46 +0200
Message-ID: <1e52aa392b9c434f55203c9d630dd06fcdb75c32.1709635535.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1709635535.git.leon@kernel.org>
References: <cover.1709635535.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <kch@nvidia.com>

Add two helper functions that are needed to calculate the total DMA
length of the request blk_rq_get_dma_length() and to create DMA
mapping blk_rq_dma_map().

blk_rq_get_dma_length() is used to get the total length of the request,
when driver is allocating IOVA space for this request with the call to
dma_alloc_iova(). This length is then initialized to the iova->size and
passed to allocate iova call chain :-
dma_map_ops->allov_iova()
        iommu_dma_alloc_iova()
                alloc_iova_fast()
                        iova_rcache_get()
                                OR
                        alloc_iova()

blk_rq_dma_map() iterates through bvec list and creates DMA mapping
for each page using iova parameter with the help of dma_link_range().
Note that @iova is allocated & pre-initialized using dma_alloc_iova()
by the caller. After creating a mapping for each page, call into the
callback function @cb provided by the drive with a mapped DMA address
for this page, offset into the iova space (needed at the time of
unlink), length of the mapped page, and page number that is mapped in
this request. Driver is responsible for using this DMA address to
complete the mapping of underlying protocol-specific data structures,
such as NVMe PRPs or NVMe SGLs. This callback approach allows us to
iterate bvec list only once to create bvec to DMA mapping and use that
DMA address in driver to build the protocol-specific data structure,
essentially mapping one bvec page at a time to DMA address and using
that DMA address to create underlying protocol-specific data structures.
Finally, returning the number of linked count.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-merge.c      | 156 +++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |   9 +++
 2 files changed, 165 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2d470cf2173e..63effc8ac1db 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -583,6 +583,162 @@ int __blk_rq_map_sg(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(__blk_rq_map_sg);
 
+static dma_addr_t blk_dma_link_page(struct page *page, unsigned int page_offset,
+				    struct dma_iova_attrs *iova,
+				    dma_addr_t dma_offset)
+{
+	dma_addr_t dma_addr;
+	int ret;
+
+	dma_addr = dma_link_range(page, page_offset, iova, dma_offset);
+	ret = dma_mapping_error(iova->dev, dma_addr);
+	if (ret) {
+		pr_err("dma_mapping_err %d dma_addr 0x%llx dma_offset %llu\n",
+			ret, dma_addr, dma_offset);
+		/* better way ? */
+		dma_addr = 0;
+	}
+	return dma_addr;
+}
+
+/**
+ * blk_rq_dma_map: block layer request to DMA mapping helper.
+ *
+ * @req         : [in] request to be mapped
+ * @cb          : [in] callback to be called for each bvec mapped bvec into
+ *                     underlaying driver.
+ * @cb_data     : [in] callback data to be passed, privete to the underlaying
+ *                     driver.
+ * @iova        : [in] iova to be used to create DMA mapping for this request's
+ *                     bvecs.
+ * Description:
+ * Iterates through bvec list and create dma mapping between each bvec page
+ * using @iova with dma_link_range(). Note that @iova needs to be allocated and
+ * pre-initialized using dma_alloc_iova() by the caller. After creating
+ * a mapping for each page, call into the callback function @cb provided by
+ * driver with mapped dma address for this bvec, offset into iova space, length
+ * of the mapped page, and bvec number that is mapped in this requets. Driver is
+ * responsible for using this dma address to complete the mapping of underlaying
+ * protocol specific data structure, such as NVMe PRPs or NVMe SGLs. This
+ * callback approach allows us to iterate bvec list only once to create bvec to
+ * DMA mapping & use that dma address in the driver to build the protocol
+ * specific data structure, essentially mapping one bvec page at a time to DMA
+ * address and use that DMA address to create underlaying protocol specific
+ * data structure.
+ *
+ * Caller needs to ensure @iova is initialized & allovated with using
+ * dma_alloc_iova().
+ */
+int blk_rq_dma_map(struct request *req, driver_map_cb cb, void *cb_data,
+		   struct dma_iova_attrs *iova)
+{
+	dma_addr_t curr_dma_offset = 0;
+	dma_addr_t prev_dma_addr = 0;
+	dma_addr_t dma_addr;
+	size_t prev_dma_len = 0;
+	struct req_iterator iter;
+	struct bio_vec bv;
+	int linked_cnt = 0;
+
+	rq_for_each_bvec(bv, req, iter) {
+		if (bv.bv_offset + bv.bv_len <= PAGE_SIZE) {
+			curr_dma_offset = prev_dma_addr + prev_dma_len;
+
+			dma_addr = blk_dma_link_page(bv.bv_page, bv.bv_offset,
+						     iova, curr_dma_offset);
+			if (!dma_addr)
+				break;
+
+			cb(cb_data, linked_cnt, dma_addr, curr_dma_offset,
+			   bv.bv_len);
+
+			prev_dma_len = bv.bv_len;
+			prev_dma_addr = dma_addr;
+			linked_cnt++;
+		} else {
+			unsigned nbytes = bv.bv_len;
+			unsigned total = 0;
+			unsigned offset, len;
+
+			while (nbytes > 0) {
+				struct page *page = bv.bv_page;
+
+				offset = bv.bv_offset + total;
+				len = min(get_max_segment_size(&req->q->limits,
+							       page, offset),
+							       nbytes);
+
+				page += (offset >> PAGE_SHIFT);
+				offset &= ~PAGE_MASK;
+
+				curr_dma_offset = prev_dma_addr + prev_dma_len;
+
+				dma_addr = blk_dma_link_page(page, offset,
+							     iova,
+							     curr_dma_offset);
+				if (!dma_addr)
+					break;
+
+				cb(cb_data, linked_cnt, dma_addr,
+				   curr_dma_offset, len);
+
+				total += len;
+				nbytes -= len;
+
+				prev_dma_len = len;
+				prev_dma_addr = dma_addr;
+				linked_cnt++;
+			}
+		}
+	}
+	return linked_cnt;
+}
+EXPORT_SYMBOL_GPL(blk_rq_dma_map);
+
+/*
+ * Calculate total DMA length needed to satisfy this request.
+ */
+size_t blk_rq_get_dma_length(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+	struct bio *bio = rq->bio;
+	unsigned int offset, len;
+	struct bvec_iter iter;
+	size_t dma_length = 0;
+	struct bio_vec bvec;
+
+	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
+		return rq->special_vec.bv_len;
+
+	if (!rq->bio)
+		return 0;
+
+	for_each_bio(bio) {
+		bio_for_each_bvec(bvec, bio, iter) {
+			unsigned int nbytes = bvec.bv_len;
+			unsigned int total = 0;
+
+			if (bvec.bv_offset + bvec.bv_len <= PAGE_SIZE) {
+				dma_length += bvec.bv_len;
+				continue;
+			}
+
+			while (nbytes > 0) {
+				offset = bvec.bv_offset + total;
+				len = min(get_max_segment_size(&q->limits,
+							       bvec.bv_page,
+							       offset), nbytes);
+				total += len;
+				nbytes -= len;
+				dma_length += len;
+			}
+		}
+	}
+
+	return dma_length;
+}
+EXPORT_SYMBOL(blk_rq_get_dma_length);
+
 static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 						  sector_t offset)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 7a8150a5f051..80b9c7f2c3a0 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -8,6 +8,7 @@
 #include <linux/scatterlist.h>
 #include <linux/prefetch.h>
 #include <linux/srcu.h>
+#include <linux/dma-mapping.h>
 
 struct blk_mq_tags;
 struct blk_flush_queue;
@@ -1144,7 +1145,15 @@ static inline int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 
 	return __blk_rq_map_sg(q, rq, sglist, &last_sg);
 }
+
+typedef void (*driver_map_cb)(void *cb_data, u32 cnt, dma_addr_t dma_addr,
+			      dma_addr_t offset, u32 len);
+
+int blk_rq_dma_map(struct request *req, driver_map_cb cb, void *cb_data,
+		   struct dma_iova_attrs *iova);
+
 void blk_dump_rq_flags(struct request *, char *);
+size_t blk_rq_get_dma_length(struct request *rq);
 
 #ifdef CONFIG_BLK_DEV_ZONED
 static inline unsigned int blk_rq_zone_no(struct request *rq)
-- 
2.44.0


