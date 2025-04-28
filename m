Return-Path: <kvm+bounces-44556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AEEB7A9EC46
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 11:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 187977A8A3F
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D96276058;
	Mon, 28 Apr 2025 09:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFvZcReR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536FC27511E;
	Mon, 28 Apr 2025 09:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832245; cv=none; b=Monumwci/s9iCNb3/0DnVqgvtmWeoixuoUaC0OiLvPi4U3DB6PC1v9ZuIVFQgffyG0d8CjY9MpPqKs8IqAui5OmQ/0cEqSWmTepAXwKgoEHn7NCbDmBTVCbpleKXFuLqtw9yS+x2xX1IqhvyxquCSTptArDmz6boPYsLUMbwmcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832245; c=relaxed/simple;
	bh=9rhHvPOzSHQlA2XuEjZ/1K4qwc/mwIdcZSmcRZVSrto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkDA4CY7Cv3canHvVIN8ZJO4tJeVrGQBaWvYVd8kpYvpEzotIhn48bu25USU5sV5dHM4c2IIwk28TSB5Vmr64eDng3dMd/5eR82gYjkUvbFdC0jWpoCO4P4T9ZpMGPy/89V1SF7ZsyVWqvx3EWjaTMRaynHXciATJ71DJXOGGaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFvZcReR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4383DC4CEEF;
	Mon, 28 Apr 2025 09:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745832244;
	bh=9rhHvPOzSHQlA2XuEjZ/1K4qwc/mwIdcZSmcRZVSrto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFvZcReRnyppSyxP/Et+YkgbD8FvTtrDWn1JdHg7l/xqdHYtSk6JWl3oO9nEx6jwa
	 JEsC7HRJ1d1OOFKf25ixMoKQIIUzMBTE0oGipToJh69rbiUwq0ibxu+66zm190YNSf
	 wqjB5H2EZFN7yAL1/fKwW1IbFfUZbCfKpERzezPpRpqh5qHk3yxxOUcl63VsLg/CFU
	 C9K72jzKe/+LGntR5KzPj3x4r+5JRCeliq5IDo6uoqnGn2ci3O6WYU9Tx1QPsJBq23
	 BzPAsJOss5n1uGOuAc5eiBpKyH/R+T/DpVhbmlTDpoJHE4yVQimeHBs5q0A7NWMrIy
	 SucdN/ukBTvrw==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
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
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH v10 20/24] blk-mq: add scatterlist-less DMA mapping helpers
Date: Mon, 28 Apr 2025 12:22:26 +0300
Message-ID: <0ecf38e2b83f8ed60cdc3b9be56012654f284751.1745831017.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1745831017.git.leon@kernel.org>
References: <cover.1745831017.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Add a new blk_rq_dma_map / blk_rq_dma_unmap pair that does away with
the wasteful scatterlist structure.  Instead it uses the mapping iterator
to either add segments to the IOVA for IOMMU operations, or just maps
them one by one for the direct mapping.  For the IOMMU case instead of
a scatterlist with an entry for each segment, only a single [dma_addr,len]
pair needs to be stored for processing a request, and for the direct
mapping the per-segment allocation shrinks from
[page,offset,len,dma_addr,dma_len] to just [dma_addr,len].

The major downside of this API is that the IOVA collapsing only works
when the driver sets a virt_boundary that matches the IOMMU granule.

Note that struct blk_dma_vec, struct blk_dma_mapping and blk_rq_dma_unmap
aren't really block specific, but for they are kept with the only mapping
routine to keep things simple.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-merge.c          | 163 +++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq-dma.h |  63 ++++++++++++++
 2 files changed, 226 insertions(+)
 create mode 100644 include/linux/blk-mq-dma.h

diff --git a/block/blk-merge.c b/block/blk-merge.c
index d9691e900cc6..5e2e6db60fda 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -7,6 +7,8 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blk-integrity.h>
+#include <linux/blk-mq-dma.h>
+#include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
 #include <linux/part_stat.h>
 #include <linux/blk-cgroup.h>
@@ -535,6 +537,167 @@ static bool blk_map_iter_next(struct request *req,
 	return true;
 }
 
+/*
+ * The IOVA-based DMA API wants to be able to coalesce at the minimal IOMMU page
+ * size granularity (which is guaranteed to be <= PAGE_SIZE and usually 4k), so
+ * we need to ensure our segments are aligned to this as well.
+ *
+ * Note that there is no point in using the slightly more complicated IOVA based
+ * path for single segment mappings.
+ */
+static inline bool blk_can_dma_map_iova(struct request *req,
+		struct device *dma_dev)
+{
+	return !((queue_virt_boundary(req->q) + 1) &
+		dma_get_merge_boundary(dma_dev));
+}
+
+static bool blk_dma_map_bus(struct request *req, struct device *dma_dev,
+		struct blk_dma_iter *iter, struct phys_vec *vec)
+{
+	iter->addr = pci_p2pdma_bus_addr_map(&iter->p2pdma, vec->paddr);
+	iter->len = vec->len;
+	return true;
+}
+
+static bool blk_dma_map_direct(struct request *req, struct device *dma_dev,
+		struct blk_dma_iter *iter, struct phys_vec *vec)
+{
+	iter->addr = dma_map_page(dma_dev, phys_to_page(vec->paddr),
+			offset_in_page(vec->paddr), vec->len, rq_dma_dir(req));
+	if (dma_mapping_error(dma_dev, iter->addr)) {
+		iter->status = BLK_STS_RESOURCE;
+		return false;
+	}
+	iter->len = vec->len;
+	return true;
+}
+
+static bool blk_rq_dma_map_iova(struct request *req, struct device *dma_dev,
+		struct dma_iova_state *state, struct blk_dma_iter *iter,
+		struct phys_vec *vec)
+{
+	enum dma_data_direction dir = rq_dma_dir(req);
+	unsigned int mapped = 0;
+	int error = 0;
+
+	iter->addr = state->addr;
+	iter->len = dma_iova_size(state);
+
+	do {
+		error = dma_iova_link(dma_dev, state, vec->paddr, mapped,
+				vec->len, dir, 0);
+		if (error)
+			break;
+		mapped += vec->len;
+	} while (blk_map_iter_next(req, &iter->iter, vec));
+
+	error = dma_iova_sync(dma_dev, state, 0, mapped);
+	if (error) {
+		iter->status = errno_to_blk_status(error);
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * blk_rq_dma_map_iter_start - map the first DMA segment for a request
+ * @req:	request to map
+ * @dma_dev:	device to map to
+ * @state:	DMA IOVA state
+ * @iter:	block layer DMA iterator
+ *
+ * Start DMA mapping @req to @dma_dev.  @state and @iter are provided by the
+ * caller and don't need to be initialized.  @state needs to be stored for use
+ * at unmap time, @iter is only needed at map time.
+ *
+ * Returns %false if there is no segment to map, including due to an error, or
+ * %true ft it did map a segment.
+ *
+ * If a segment was mapped, the DMA address for it is returned in @iter.addr and
+ * the length in @iter.len.  If no segment was mapped the status code is
+ * returned in @iter.status.
+ *
+ * The caller can call blk_rq_dma_map_coalesce() to check if further segments
+ * need to be mapped after this, or go straight to blk_rq_dma_map_iter_next()
+ * to try to map the following segments.
+ */
+bool blk_rq_dma_map_iter_start(struct request *req, struct device *dma_dev,
+		struct dma_iova_state *state, struct blk_dma_iter *iter)
+{
+	unsigned int total_len = blk_rq_payload_bytes(req);
+	struct phys_vec vec;
+
+	iter->iter.bio = req->bio;
+	iter->iter.iter = req->bio->bi_iter;
+	memset(&iter->p2pdma, 0, sizeof(iter->p2pdma));
+	iter->status = BLK_STS_OK;
+
+	/*
+	 * Grab the first segment ASAP because we'll need it to check for P2P
+	 * transfers.
+	 */
+	if (!blk_map_iter_next(req, &iter->iter, &vec))
+		return false;
+
+	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && (req->cmd_flags & REQ_P2PDMA)) {
+		switch (pci_p2pdma_state(&iter->p2pdma, dma_dev,
+					 phys_to_page(vec.paddr))) {
+		case PCI_P2PDMA_MAP_BUS_ADDR:
+			return blk_dma_map_bus(req, dma_dev, iter, &vec);
+		case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
+			/*
+			 * P2P transfers through the host bridge are treated the
+			 * same as non-P2P transfers below and during unmap.
+			 */
+			req->cmd_flags &= ~REQ_P2PDMA;
+			break;
+		default:
+			iter->status = BLK_STS_INVAL;
+			return false;
+		}
+	}
+
+	if (blk_can_dma_map_iova(req, dma_dev) &&
+	    dma_iova_try_alloc(dma_dev, state, vec.paddr, total_len))
+		return blk_rq_dma_map_iova(req, dma_dev, state, iter, &vec);
+	return blk_dma_map_direct(req, dma_dev, iter, &vec);
+}
+EXPORT_SYMBOL_GPL(blk_rq_dma_map_iter_start);
+
+/**
+ * blk_rq_dma_map_iter_next - map the next DMA segment for a request
+ * @req:	request to map
+ * @dma_dev:	device to map to
+ * @state:	DMA IOVA state
+ * @iter:	block layer DMA iterator
+ *
+ * Iterate to the next mapping after a previous call to
+ * blk_rq_dma_map_iter_start().  See there for a detailed description of the
+ * arguments.
+ *
+ * Returns %false if there is no segment to map, including due to an error, or
+ * %true ft it did map a segment.
+ *
+ * If a segment was mapped, the DMA address for it is returned in @iter.addr and
+ * the length in @iter.len.  If no segment was mapped the status code is
+ * returned in @iter.status.
+ */
+bool blk_rq_dma_map_iter_next(struct request *req, struct device *dma_dev,
+		struct dma_iova_state *state, struct blk_dma_iter *iter)
+{
+	struct phys_vec vec;
+
+	if (!blk_map_iter_next(req, &iter->iter, &vec))
+		return false;
+
+	if (iter->p2pdma.map == PCI_P2PDMA_MAP_BUS_ADDR)
+		return blk_dma_map_bus(req, dma_dev, iter, &vec);
+	return blk_dma_map_direct(req, dma_dev, iter, &vec);
+}
+EXPORT_SYMBOL_GPL(blk_rq_dma_map_iter_next);
+
 static inline struct scatterlist *blk_next_sg(struct scatterlist **sg,
 		struct scatterlist *sglist)
 {
diff --git a/include/linux/blk-mq-dma.h b/include/linux/blk-mq-dma.h
new file mode 100644
index 000000000000..6d85b4bedcba
--- /dev/null
+++ b/include/linux/blk-mq-dma.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef BLK_MQ_DMA_H
+#define BLK_MQ_DMA_H
+
+#include <linux/blk-mq.h>
+#include <linux/pci-p2pdma.h>
+
+struct blk_dma_iter {
+	/* Output address range for this iteration */
+	dma_addr_t			addr;
+	u32				len;
+
+	/* Status code. Only valid when blk_rq_dma_map_iter_* returned false */
+	blk_status_t			status;
+
+	/* Internal to blk_rq_dma_map_iter_* */
+	struct req_iterator		iter;
+	struct pci_p2pdma_map_state	p2pdma;
+};
+
+bool blk_rq_dma_map_iter_start(struct request *req, struct device *dma_dev,
+		struct dma_iova_state *state, struct blk_dma_iter *iter);
+bool blk_rq_dma_map_iter_next(struct request *req, struct device *dma_dev,
+		struct dma_iova_state *state, struct blk_dma_iter *iter);
+
+/**
+ * blk_rq_dma_map_coalesce - were all segments coalesced?
+ * @state: DMA state to check
+ *
+ * Returns true if blk_rq_dma_map_iter_start coalesced all segments into a
+ * single DMA range.
+ */
+static inline bool blk_rq_dma_map_coalesce(struct dma_iova_state *state)
+{
+	return dma_use_iova(state);
+}
+
+/**
+ * blk_rq_dma_unmap - try to DMA unmap a request
+ * @req:	request to unmap
+ * @dma_dev:	device to unmap from
+ * @state:	DMA IOVA state
+ * @mapped_len: number of bytes to unmap
+ *
+ * Returns %false if the callers need to manually unmap every DMA segment
+ * mapped using @iter or %true if no work is left to be done.
+ */
+static inline bool blk_rq_dma_unmap(struct request *req, struct device *dma_dev,
+		struct dma_iova_state *state, size_t mapped_len)
+{
+	if (req->cmd_flags & REQ_P2PDMA)
+		return true;
+
+	if (dma_use_iova(state)) {
+		dma_iova_destroy(dma_dev, state, mapped_len, rq_dma_dir(req),
+				 0);
+		return true;
+	}
+
+	return !dma_need_unmap(dma_dev);
+}
+
+#endif /* BLK_MQ_DMA_H */
-- 
2.49.0


