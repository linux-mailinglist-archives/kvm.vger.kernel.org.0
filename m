Return-Path: <kvm+bounces-44563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BCCA9EC96
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 11:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D21C03AFB88
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0547727CB18;
	Mon, 28 Apr 2025 09:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTlAXiAg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C5264616;
	Mon, 28 Apr 2025 09:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832265; cv=none; b=MGlpPj2yCodwFgeG/bp2TA/GsmTf73RaNkG98V244AgUT/rA69cxdgs97HAg5iAqmfVa+AI65+P58IYZ1uPfE43S6vBRIBliPUUDuKseTWzOg0Jq1ldHvMAL0L+Htxxlrkh7iqNLaAjQD0xCMoOK820ZztAb39DCRijNMKIDL7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832265; c=relaxed/simple;
	bh=9vP4KAaf7eHx9mt8ZdGXz9CUCxSxRLWpwXr/m0S1xfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLnc96NaCHGMzaxIZK2E3U56GwLJBJGZC5uEq8JASUtyMKXGzJjmga5lH0FxogTjme/d7Bee6IF1gZWq4aBDIzFdd9GZ7VjS0Hh5cw0Vu9NBcjRnqOErXvdotuzJAGBqGQFFzYbE8d8R2IAWnpBSNH+7/ysJGcfrAzrqLWqa5oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTlAXiAg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA21AC4CEE4;
	Mon, 28 Apr 2025 09:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745832264;
	bh=9vP4KAaf7eHx9mt8ZdGXz9CUCxSxRLWpwXr/m0S1xfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTlAXiAgqfXWqTa/ZRpoyze2KOjtuLs8Hmwqw1wFHLtj0zOYR6v52T4Fnt0GZdS7p
	 V+B2eZtFyDfV6P98uiromPF4qPW+Y6flq/8OxlmrwHybt0FqXw8rKHLpAT+Fn6nUDD
	 PPPN0fuxUud8EjyFn9neTKQ4svCvuxVUC/eFsXE8FGBk0AaL1NgDEF9MMf44YdOST4
	 TRsBkkxdFmLTUbzLi6WHSD+ibWRgIv/IPX8AmztCQB7y5PuI6/H1NV/wSeSQtuBrzq
	 azRv+KaqDurKP1ubcGlPWrYwHgQSS9I/RA2EeWuyaXsfMiF4FN7zSgLXTKYptxvI8U
	 x7KLvin4isKfg==
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
	Nitesh Shetty <nj.shetty@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH v10 23/24] nvme-pci: convert to blk_rq_dma_map
Date: Mon, 28 Apr 2025 12:22:29 +0300
Message-ID: <007e00134d49160d5edab94a72c35b7b91429b09.1745831017.git.leon@kernel.org>
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

Use the blk_rq_dma_map API to DMA map requests instead of
scatterlists.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jens Axboe <axboe@kernel.dk>
[ Leon: squashed optimization patch from Kanchan ]
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
[ Leon: rewrote original patch due to rebases and addition of metadata support ]
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 593 ++++++++++++++++++++++------------------
 1 file changed, 329 insertions(+), 264 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 270fb5146b5b..eb835425b496 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -7,7 +7,7 @@
 #include <linux/acpi.h>
 #include <linux/async.h>
 #include <linux/blkdev.h>
-#include <linux/blk-mq.h>
+#include <linux/blk-mq-dma.h>
 #include <linux/blk-integrity.h>
 #include <linux/dmi.h>
 #include <linux/init.h>
@@ -26,7 +26,6 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/sed-opal.h>
-#include <linux/pci-p2pdma.h>
 
 #include "trace.h"
 #include "nvme.h"
@@ -144,9 +143,6 @@ struct nvme_dev {
 	bool hmb;
 	struct sg_table *hmb_sgt;
 
-	mempool_t *iod_mempool;
-	mempool_t *iod_meta_mempool;
-
 	/* shadow doorbell buffer support: */
 	__le32 *dbbuf_dbs;
 	dma_addr_t dbbuf_dbs_dma_addr;
@@ -222,6 +218,7 @@ struct nvme_queue {
 
 enum {
 	IOD_LARGE_DESCRIPTORS = 1 << 0, /* uses the full page sized descriptor pool */
+	IOD_SINGLE_SEGMENT = 1 << 1, /* single segment dma mapping */
 };
 
 /*
@@ -233,11 +230,11 @@ struct nvme_iod {
 	bool aborted;
 	u8 nr_descriptors;	/* # of PRP/SGL descriptors */
 	u8 flags;
-	unsigned int dma_len;	/* length of single DMA segment mapping */
-	dma_addr_t first_dma;
+	unsigned int total_len; /* length of the entire transfer */
+	unsigned int total_meta_len; /* length of the entire metadata transfer */
 	dma_addr_t meta_dma;
-	struct sg_table sgt;
-	struct sg_table meta_sgt;
+	struct dma_iova_state dma_state;
+	struct dma_iova_state dma_meta_state;
 	void *meta_list;
 	void *descriptors[NVME_MAX_NR_DESCRIPTORS];
 };
@@ -546,9 +543,14 @@ static void nvme_free_descriptors(struct nvme_dev *dev, struct request *req)
 {
 	const int last_prp = NVME_CTRL_PAGE_SIZE / sizeof(__le64) - 1;
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	dma_addr_t dma_addr = iod->first_dma;
+	dma_addr_t dma_addr;
 	int i;
 
+	if (iod->cmd.common.flags & NVME_CMD_SGL_METABUF)
+		dma_addr = le64_to_cpu(iod->cmd.common.dptr.sgl.addr);
+	else
+		dma_addr = le64_to_cpu(iod->cmd.common.dptr.prp2);
+
 	if (iod->nr_descriptors == 1) {
 		dma_pool_free(nvme_dma_pool(dev, iod), iod->descriptors[0],
 				dma_addr);
@@ -564,67 +566,182 @@ static void nvme_free_descriptors(struct nvme_dev *dev, struct request *req)
 	}
 }
 
+static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	enum dma_data_direction dir = rq_dma_dir(req);
+	int length = iod->total_len;
+	dma_addr_t dma_addr;
+	int i, desc;
+	__le64 *prp_list;
+	u32 dma_len;
+
+	dma_addr = le64_to_cpu(iod->cmd.common.dptr.prp1);
+	dma_len = min_t(u32, length,
+		NVME_CTRL_PAGE_SIZE - (dma_addr & (NVME_CTRL_PAGE_SIZE - 1)));
+	length -= dma_len;
+	if (!length) {
+		dma_unmap_page(dev->dev, dma_addr, dma_len, dir);
+		return;
+	}
+
+	if (length <= NVME_CTRL_PAGE_SIZE) {
+		dma_unmap_page(dev->dev, dma_addr, dma_len, dir);
+		dma_addr = le64_to_cpu(iod->cmd.common.dptr.prp2);
+		dma_unmap_page(dev->dev, dma_addr, length, dir);
+		return;
+	}
+
+	i = 0;
+	desc = 0;
+	prp_list = iod->descriptors[desc];
+	do {
+		dma_unmap_page(dev->dev, dma_addr, dma_len, dir);
+		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
+			prp_list = iod->descriptors[++desc];
+			i = 0;
+		}
+
+		dma_addr = le64_to_cpu(prp_list[i++]);
+		dma_len = min(length, NVME_CTRL_PAGE_SIZE);
+		length -= dma_len;
+	} while (length);
+}
+
+
+static void nvme_free_sgls(struct nvme_dev *dev, struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	dma_addr_t sqe_dma_addr = le64_to_cpu(iod->cmd.common.dptr.sgl.addr);
+	unsigned int sqe_dma_len = le32_to_cpu(iod->cmd.common.dptr.sgl.length);
+	struct nvme_sgl_desc *sg_list = iod->descriptors[0];
+	enum dma_data_direction dir = rq_dma_dir(req);
+
+	if (iod->nr_descriptors) {
+		unsigned int nr_entries = sqe_dma_len / sizeof(*sg_list), i;
+
+		for (i = 0; i < nr_entries; i++)
+			dma_unmap_page(dev->dev, le64_to_cpu(sg_list[i].addr),
+				le32_to_cpu(sg_list[i].length), dir);
+	} else {
+		dma_unmap_page(dev->dev, sqe_dma_addr, sqe_dma_len, dir);
+	}
+}
+
 static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	dma_addr_t dma_addr;
 
-	if (iod->dma_len) {
-		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
-			       rq_dma_dir(req));
+	if (iod->flags & IOD_SINGLE_SEGMENT) {
+		if (iod->cmd.common.flags &
+		    (NVME_CMD_SGL_METABUF | NVME_CMD_SGL_METASEG))
+			dma_addr = le64_to_cpu(iod->cmd.common.dptr.sgl.addr);
+		else
+			dma_addr = le64_to_cpu(iod->cmd.common.dptr.prp1);
+		dma_unmap_page(dev->dev, dma_addr, iod->total_len,
+				rq_dma_dir(req));
 		return;
 	}
 
-	WARN_ON_ONCE(!iod->sgt.nents);
+	if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_state, iod->total_len)) {
+		if (iod->cmd.common.flags & NVME_CMD_SGL_METABUF)
+			nvme_free_sgls(dev, req);
+		else
+			nvme_free_prps(dev, req);
+	}
 
-	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
-	nvme_free_descriptors(dev, req);
-	mempool_free(iod->sgt.sgl, dev->iod_mempool);
+	if (iod->nr_descriptors)
+		nvme_free_descriptors(dev, req);
 }
 
-static void nvme_print_sgl(struct scatterlist *sgl, int nents)
+static bool nvme_try_setup_prp_simple(struct nvme_dev *dev, struct request *req,
+				      struct nvme_rw_command *cmnd,
+				      struct blk_dma_iter *iter)
 {
-	int i;
-	struct scatterlist *sg;
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio_vec bv = req_bvec(req);
+	unsigned int first_prp_len;
+
+	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && (req->cmd_flags & REQ_P2PDMA))
+		return false;
+
+	if ((bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1)) + bv.bv_len >
+	    NVME_CTRL_PAGE_SIZE * 2)
+		return false;
 
-	for_each_sg(sgl, sg, nents, i) {
-		dma_addr_t phys = sg_phys(sg);
-		pr_warn("sg[%d] phys_addr:%pad offset:%d length:%d "
-			"dma_address:%pad dma_length:%d\n",
-			i, &phys, sg->offset, sg->length, &sg_dma_address(sg),
-			sg_dma_len(sg));
+	iter->addr = dma_map_bvec(dev->dev, &bv, rq_dma_dir(req), 0);
+	if (dma_mapping_error(dev->dev, iter->addr)) {
+		iter->status = BLK_STS_RESOURCE;
+		return true;
 	}
+	iod->total_len = bv.bv_len;
+	cmnd->dptr.prp1 = cpu_to_le64(iter->addr);
+
+	first_prp_len = NVME_CTRL_PAGE_SIZE -
+			(bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1));
+	if (bv.bv_len > first_prp_len)
+		cmnd->dptr.prp2 = cpu_to_le64(iter->addr + first_prp_len);
+	else
+		cmnd->dptr.prp2 = 0;
+
+	iter->status = BLK_STS_OK;
+	iod->flags |= IOD_SINGLE_SEGMENT;
+	return true;
 }
 
 static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
-		struct request *req, struct nvme_rw_command *cmnd)
+					struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	int length = blk_rq_payload_bytes(req);
-	struct scatterlist *sg = iod->sgt.sgl;
-	int dma_len = sg_dma_len(sg);
-	u64 dma_addr = sg_dma_address(sg);
-	int offset = dma_addr & (NVME_CTRL_PAGE_SIZE - 1);
+	struct nvme_rw_command *cmnd = &iod->cmd.rw;
+	unsigned int length = blk_rq_payload_bytes(req);
+	struct blk_dma_iter iter;
+	dma_addr_t prp1_dma, prp2_dma = 0;
+	unsigned int prp_len, i;
 	__le64 *prp_list;
-	dma_addr_t prp_dma;
-	int i;
+	unsigned int nr_segments = blk_rq_nr_phys_segments(req);
 
-	length -= (NVME_CTRL_PAGE_SIZE - offset);
-	if (length <= 0) {
-		iod->first_dma = 0;
-		goto done;
+	if (nr_segments == 1) {
+		if (nvme_try_setup_prp_simple(dev, req, cmnd, &iter))
+			return iter.status;
 	}
 
-	dma_len -= (NVME_CTRL_PAGE_SIZE - offset);
-	if (dma_len) {
-		dma_addr += (NVME_CTRL_PAGE_SIZE - offset);
-	} else {
-		sg = sg_next(sg);
-		dma_addr = sg_dma_address(sg);
-		dma_len = sg_dma_len(sg);
+	if (!blk_rq_dma_map_iter_start(req, dev->dev, &iod->dma_state, &iter))
+		return iter.status;
+
+	/*
+	 * PRP1 always points to the start of the DMA transfers.
+	 *
+	 * This is the only PRP (except for the list entries) that could be
+	 * non-aligned.
+	 */
+	prp1_dma = iter.addr;
+	prp_len = min(length, NVME_CTRL_PAGE_SIZE -
+			(iter.addr & (NVME_CTRL_PAGE_SIZE - 1)));
+	iod->total_len += prp_len;
+	iter.addr += prp_len;
+	iter.len -= prp_len;
+	length -= prp_len;
+	if (!length)
+		goto done;
+
+	if (!iter.len) {
+		if (!blk_rq_dma_map_iter_next(req, dev->dev, &iod->dma_state,
+				&iter)) {
+			if (WARN_ON_ONCE(!iter.status))
+				goto bad_sgl;
+			goto done;
+		}
 	}
 
+	/*
+	 * PRP2 is usually a list, but can point to data if all data to be
+	 * transferred fits into PRP1 + PRP2:
+	 */
 	if (length <= NVME_CTRL_PAGE_SIZE) {
-		iod->first_dma = dma_addr;
+		prp2_dma = iter.addr;
+		iod->total_len += length;
 		goto done;
 	}
 
@@ -633,58 +750,83 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 		iod->flags |= IOD_LARGE_DESCRIPTORS;
 
 	prp_list = dma_pool_alloc(nvme_dma_pool(dev, iod), GFP_ATOMIC,
-			&prp_dma);
-	if (!prp_list)
-		return BLK_STS_RESOURCE;
+			&prp2_dma);
+	if (!prp_list) {
+		iter.status = BLK_STS_RESOURCE;
+		goto done;
+	}
 	iod->descriptors[iod->nr_descriptors++] = prp_list;
-	iod->first_dma = prp_dma;
+
 	i = 0;
 	for (;;) {
+		prp_list[i++] = cpu_to_le64(iter.addr);
+		prp_len = min(length, NVME_CTRL_PAGE_SIZE);
+		if (WARN_ON_ONCE(iter.len < prp_len))
+			goto bad_sgl;
+
+		iod->total_len += prp_len;
+		iter.addr += prp_len;
+		iter.len -= prp_len;
+		length -= prp_len;
+		if (!length)
+			break;
+
+		if (iter.len == 0) {
+			if (!blk_rq_dma_map_iter_next(req, dev->dev,
+					&iod->dma_state, &iter)) {
+				if (WARN_ON_ONCE(!iter.status))
+					goto bad_sgl;
+				goto done;
+			}
+		}
+
+		/*
+		 * If we've filled the entire descriptor, allocate a new that is
+		 * pointed to be the last entry in the previous PRP list.  To
+		 * accommodate for that move the last actual entry to the new
+		 * descriptor.
+		 */
 		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
 			__le64 *old_prp_list = prp_list;
+			dma_addr_t prp_list_dma;
 
 			prp_list = dma_pool_alloc(dev->prp_page_pool,
-					GFP_ATOMIC, &prp_dma);
-			if (!prp_list)
-				goto free_prps;
+					GFP_ATOMIC, &prp_list_dma);
+			if (!prp_list) {
+				iter.status = BLK_STS_RESOURCE;
+				goto done;
+			}
 			iod->descriptors[iod->nr_descriptors++] = prp_list;
+
 			prp_list[0] = old_prp_list[i - 1];
-			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
+			old_prp_list[i - 1] = cpu_to_le64(prp_list_dma);
 			i = 1;
 		}
-		prp_list[i++] = cpu_to_le64(dma_addr);
-		dma_len -= NVME_CTRL_PAGE_SIZE;
-		dma_addr += NVME_CTRL_PAGE_SIZE;
-		length -= NVME_CTRL_PAGE_SIZE;
-		if (length <= 0)
-			break;
-		if (dma_len > 0)
-			continue;
-		if (unlikely(dma_len < 0))
-			goto bad_sgl;
-		sg = sg_next(sg);
-		dma_addr = sg_dma_address(sg);
-		dma_len = sg_dma_len(sg);
 	}
+
 done:
-	cmnd->dptr.prp1 = cpu_to_le64(sg_dma_address(iod->sgt.sgl));
-	cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma);
-	return BLK_STS_OK;
-free_prps:
-	nvme_free_descriptors(dev, req);
-	return BLK_STS_RESOURCE;
+	/*
+	 * nvme_unmap_data uses the DPT field in the SQE to tear down the
+	 * mapping, so initialize it even for failures.
+	 */
+	cmnd->dptr.prp1 = cpu_to_le64(prp1_dma);
+	cmnd->dptr.prp2 = cpu_to_le64(prp2_dma);
+	if (unlikely(iter.status))
+		nvme_unmap_data(dev, req);
+	return iter.status;
+
 bad_sgl:
-	WARN(DO_ONCE(nvme_print_sgl, iod->sgt.sgl, iod->sgt.nents),
-			"Invalid SGL for payload:%d nents:%d\n",
-			blk_rq_payload_bytes(req), iod->sgt.nents);
+	dev_err_once(dev->dev,
+		"Incorrectly formed request for payload:%d nents:%d\n",
+		blk_rq_payload_bytes(req), blk_rq_nr_phys_segments(req));
 	return BLK_STS_IOERR;
 }
 
 static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
-		struct scatterlist *sg)
+		struct blk_dma_iter *iter)
 {
-	sge->addr = cpu_to_le64(sg_dma_address(sg));
-	sge->length = cpu_to_le32(sg_dma_len(sg));
+	sge->addr = cpu_to_le64(iter->addr);
+	sge->length = cpu_to_le32(iter->len);
 	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
 }
 
@@ -696,21 +838,54 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
 	sge->type = NVME_SGL_FMT_LAST_SEG_DESC << 4;
 }
 
+static bool nvme_try_setup_sgl_simple(struct nvme_dev *dev, struct request *req,
+				      struct nvme_rw_command *cmnd,
+				      struct blk_dma_iter *iter)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio_vec bv = req_bvec(req);
+
+	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && (req->cmd_flags & REQ_P2PDMA))
+		return false;
+
+	iter->addr = dma_map_bvec(dev->dev, &bv, rq_dma_dir(req), 0);
+	if (dma_mapping_error(dev->dev, iter->addr)) {
+		iter->status = BLK_STS_RESOURCE;
+		return true;
+	}
+	iod->total_len = bv.bv_len;
+	iter->len = bv.bv_len;
+	nvme_pci_sgl_set_data(&cmnd->dptr.sgl, iter);
+	iter->status = BLK_STS_OK;
+	iod->flags |= IOD_SINGLE_SEGMENT;
+	return true;
+}
+
 static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
-		struct request *req, struct nvme_rw_command *cmd)
+					struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct nvme_rw_command *cmd = &iod->cmd.rw;
+	unsigned int entries = blk_rq_nr_phys_segments(req);
 	struct nvme_sgl_desc *sg_list;
-	struct scatterlist *sg = iod->sgt.sgl;
-	unsigned int entries = iod->sgt.nents;
+	struct blk_dma_iter iter;
 	dma_addr_t sgl_dma;
-	int i = 0;
+	unsigned int mapped = 0;
 
 	/* setting the transfer type as SGL */
 	cmd->flags = NVME_CMD_SGL_METABUF;
 
 	if (entries == 1) {
-		nvme_pci_sgl_set_data(&cmd->dptr.sgl, sg);
+		if (nvme_try_setup_sgl_simple(dev, req, cmd, &iter))
+			return iter.status;
+	}
+
+	if (!blk_rq_dma_map_iter_start(req, dev->dev, &iod->dma_state, &iter))
+		return iter.status;
+
+	if (entries == 1 || blk_rq_dma_map_coalesce(&iod->dma_state)) {
+		nvme_pci_sgl_set_data(&cmd->dptr.sgl, &iter);
+		iod->total_len += iter.len;
 		return BLK_STS_OK;
 	}
 
@@ -721,168 +896,109 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 	if (!sg_list)
 		return BLK_STS_RESOURCE;
 	iod->descriptors[iod->nr_descriptors++] = sg_list;
-	iod->first_dma = sgl_dma;
 
-	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, entries);
 	do {
-		nvme_pci_sgl_set_data(&sg_list[i++], sg);
-		sg = sg_next(sg);
-	} while (--entries > 0);
+		if (WARN_ON_ONCE(mapped == entries)) {
+			iter.status = BLK_STS_IOERR;
+			break;
+		}
+		nvme_pci_sgl_set_data(&sg_list[mapped++], &iter);
+		iod->total_len += iter.len;
+	} while (blk_rq_dma_map_iter_next(req, dev->dev, &iod->dma_state,
+				&iter));
 
-	return BLK_STS_OK;
+	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, mapped);
+	if (unlikely(iter.status))
+		nvme_free_sgls(dev, req);
+	return iter.status;
 }
 
-static blk_status_t nvme_setup_prp_simple(struct nvme_dev *dev,
-		struct request *req, struct nvme_rw_command *cmnd,
-		struct bio_vec *bv)
+static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req)
 {
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	unsigned int offset = bv->bv_offset & (NVME_CTRL_PAGE_SIZE - 1);
-	unsigned int first_prp_len = NVME_CTRL_PAGE_SIZE - offset;
-
-	iod->first_dma = dma_map_bvec(dev->dev, bv, rq_dma_dir(req), 0);
-	if (dma_mapping_error(dev->dev, iod->first_dma))
-		return BLK_STS_RESOURCE;
-	iod->dma_len = bv->bv_len;
-
-	cmnd->dptr.prp1 = cpu_to_le64(iod->first_dma);
-	if (bv->bv_len > first_prp_len)
-		cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma + first_prp_len);
-	else
-		cmnd->dptr.prp2 = 0;
-	return BLK_STS_OK;
+	if (nvme_pci_use_sgls(dev, req, blk_rq_nr_phys_segments(req)))
+		return nvme_pci_setup_sgls(dev, req);
+	return nvme_pci_setup_prps(dev, req);
 }
 
-static blk_status_t nvme_setup_sgl_simple(struct nvme_dev *dev,
-		struct request *req, struct nvme_rw_command *cmnd,
-		struct bio_vec *bv)
+static void nvme_unmap_metadata(struct nvme_dev *dev, struct request *req)
 {
+	unsigned int entries = req->nr_integrity_segments;
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct nvme_sgl_desc *sg_list = iod->meta_list;
+	enum dma_data_direction dir = rq_dma_dir(req);
 
-	iod->first_dma = dma_map_bvec(dev->dev, bv, rq_dma_dir(req), 0);
-	if (dma_mapping_error(dev->dev, iod->first_dma))
-		return BLK_STS_RESOURCE;
-	iod->dma_len = bv->bv_len;
-
-	cmnd->flags = NVME_CMD_SGL_METABUF;
-	cmnd->dptr.sgl.addr = cpu_to_le64(iod->first_dma);
-	cmnd->dptr.sgl.length = cpu_to_le32(iod->dma_len);
-	cmnd->dptr.sgl.type = NVME_SGL_FMT_DATA_DESC << 4;
-	return BLK_STS_OK;
-}
-
-static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
-		struct nvme_command *cmnd)
-{
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	blk_status_t ret = BLK_STS_RESOURCE;
-	int rc;
-
-	if (blk_rq_nr_phys_segments(req) == 1) {
-		struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
-		struct bio_vec bv = req_bvec(req);
-
-		if (!is_pci_p2pdma_page(bv.bv_page)) {
-			if (!nvme_pci_metadata_use_sgls(dev, req) &&
-			    (bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1)) +
-			     bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
-				return nvme_setup_prp_simple(dev, req,
-							     &cmnd->rw, &bv);
-
-			if (nvmeq->qid && sgl_threshold &&
-			    nvme_ctrl_sgl_supported(&dev->ctrl))
-				return nvme_setup_sgl_simple(dev, req,
-							     &cmnd->rw, &bv);
-		}
+	/*
+	 * If the NVME_CMD_SGL_METASEG flag is not set and we're using the
+	 * non-SGL linear meta buffer we know that we have a single input
+	 * segment as well.
+	 *
+	 * Note that it would be nice to always use the linear buffer when
+	 * using IOVA mappings and kernel buffers to avoid the SGL
+	 * indirection, but that's left for a future optimization.
+	 */
+	if (!(iod->cmd.common.flags & NVME_CMD_SGL_METASEG)) {
+		dma_unmap_page(dev->dev, le64_to_cpu(iod->cmd.common.dptr.prp1),
+			       iod->total_len, rq_dma_dir(req));
+		return;
 	}
 
-	iod->dma_len = 0;
-	iod->sgt.sgl = mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
-	if (!iod->sgt.sgl)
-		return BLK_STS_RESOURCE;
-	sg_init_table(iod->sgt.sgl, blk_rq_nr_phys_segments(req));
-	iod->sgt.orig_nents = blk_rq_map_sg(req, iod->sgt.sgl);
-	if (!iod->sgt.orig_nents)
-		goto out_free_sg;
+	if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_meta_state,
+			      iod->total_meta_len)) {
+		unsigned int i;
 
-	rc = dma_map_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req),
-			     DMA_ATTR_NO_WARN);
-	if (rc) {
-		if (rc == -EREMOTEIO)
-			ret = BLK_STS_TARGET;
-		goto out_free_sg;
+		for (i = 0; i < entries; i++)
+			dma_unmap_page(dev->dev, le64_to_cpu(sg_list[i].addr),
+				       le32_to_cpu(sg_list[i].length), dir);
 	}
 
-	if (nvme_pci_use_sgls(dev, req, iod->sgt.nents))
-		ret = nvme_pci_setup_sgls(dev, req, &cmnd->rw);
-	else
-		ret = nvme_pci_setup_prps(dev, req, &cmnd->rw);
-	if (ret != BLK_STS_OK)
-		goto out_unmap_sg;
-	return BLK_STS_OK;
-
-out_unmap_sg:
-	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
-out_free_sg:
-	mempool_free(iod->sgt.sgl, dev->iod_mempool);
-	return ret;
+	dma_pool_free(dev->prp_small_pool, iod->meta_list, iod->meta_dma);
 }
 
 static blk_status_t nvme_pci_setup_meta_sgls(struct nvme_dev *dev,
 					     struct request *req)
 {
+	unsigned int entries = req->nr_integrity_segments;
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct nvme_rw_command *cmnd = &iod->cmd.rw;
+	struct nvme_rw_command *cmd = &iod->cmd.rw;
 	struct nvme_sgl_desc *sg_list;
-	struct scatterlist *sgl, *sg;
-	unsigned int entries;
+	struct blk_dma_iter iter;
+	unsigned int mapped = 0;
 	dma_addr_t sgl_dma;
-	int rc, i;
-
-	iod->meta_sgt.sgl = mempool_alloc(dev->iod_meta_mempool, GFP_ATOMIC);
-	if (!iod->meta_sgt.sgl)
-		return BLK_STS_RESOURCE;
 
-	sg_init_table(iod->meta_sgt.sgl, req->nr_integrity_segments);
-	iod->meta_sgt.orig_nents = blk_rq_map_integrity_sg(req,
-							   iod->meta_sgt.sgl);
-	if (!iod->meta_sgt.orig_nents)
-		goto out_free_sg;
+	cmd->flags = NVME_CMD_SGL_METASEG;
 
-	rc = dma_map_sgtable(dev->dev, &iod->meta_sgt, rq_dma_dir(req),
-			     DMA_ATTR_NO_WARN);
-	if (rc)
-		goto out_free_sg;
+	if (!blk_rq_dma_map_iter_start(req, dev->dev, &iod->dma_meta_state,
+				       &iter))
+		return iter.status;
 
 	sg_list = dma_pool_alloc(dev->prp_small_pool, GFP_ATOMIC, &sgl_dma);
 	if (!sg_list)
-		goto out_unmap_sg;
+		return BLK_STS_RESOURCE;
 
-	entries = iod->meta_sgt.nents;
 	iod->meta_list = sg_list;
 	iod->meta_dma = sgl_dma;
+	cmd->metadata = cpu_to_le64(sgl_dma);
 
-	cmnd->flags = NVME_CMD_SGL_METASEG;
-	cmnd->metadata = cpu_to_le64(sgl_dma);
-
-	sgl = iod->meta_sgt.sgl;
-	if (entries == 1) {
-		nvme_pci_sgl_set_data(sg_list, sgl);
+	if (entries == 1 || blk_rq_dma_map_coalesce(&iod->dma_meta_state)) {
+		nvme_pci_sgl_set_data(sg_list, &iter);
+		iod->total_meta_len += iter.len;
 		return BLK_STS_OK;
 	}
 
-	sgl_dma += sizeof(*sg_list);
-	nvme_pci_sgl_set_seg(sg_list, sgl_dma, entries);
-	for_each_sg(sgl, sg, entries, i)
-		nvme_pci_sgl_set_data(&sg_list[i + 1], sg);
-
-	return BLK_STS_OK;
+	do {
+		if (WARN_ON_ONCE(mapped == entries)) {
+			iter.status = BLK_STS_IOERR;
+			break;
+		}
+		nvme_pci_sgl_set_data(&sg_list[mapped++], &iter);
+		iod->total_len += iter.len;
+	} while (blk_rq_dma_map_iter_next(req, dev->dev, &iod->dma_meta_state,
+				 &iter));
 
-out_unmap_sg:
-	dma_unmap_sgtable(dev->dev, &iod->meta_sgt, rq_dma_dir(req), 0);
-out_free_sg:
-	mempool_free(iod->meta_sgt.sgl, dev->iod_meta_mempool);
-	return BLK_STS_RESOURCE;
+	nvme_pci_sgl_set_seg(sg_list, sgl_dma, mapped);
+	if (unlikely(iter.status))
+		nvme_unmap_metadata(dev, req);
+	return iter.status;
 }
 
 static blk_status_t nvme_pci_setup_meta_mptr(struct nvme_dev *dev,
@@ -914,15 +1030,15 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	iod->aborted = false;
 	iod->nr_descriptors = 0;
 	iod->flags = 0;
-	iod->sgt.nents = 0;
-	iod->meta_sgt.nents = 0;
+	iod->total_len = 0;
+	iod->total_meta_len = 0;
 
 	ret = nvme_setup_cmd(req->q->queuedata, req);
 	if (ret)
 		return ret;
 
 	if (blk_rq_nr_phys_segments(req)) {
-		ret = nvme_map_data(dev, req, &iod->cmd);
+		ret = nvme_map_data(dev, req);
 		if (ret)
 			goto out_free_cmd;
 	}
@@ -1026,23 +1142,6 @@ static void nvme_queue_rqs(struct rq_list *rqlist)
 	*rqlist = requeue_list;
 }
 
-static __always_inline void nvme_unmap_metadata(struct nvme_dev *dev,
-						struct request *req)
-{
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-
-	if (!iod->meta_sgt.nents) {
-		dma_unmap_page(dev->dev, iod->meta_dma,
-			       rq_integrity_vec(req).bv_len,
-			       rq_dma_dir(req));
-		return;
-	}
-
-	dma_pool_free(dev->prp_small_pool, iod->meta_list, iod->meta_dma);
-	dma_unmap_sgtable(dev->dev, &iod->meta_sgt, rq_dma_dir(req), 0);
-	mempool_free(iod->meta_sgt.sgl, dev->iod_meta_mempool);
-}
-
 static __always_inline void nvme_pci_unmap_rq(struct request *req)
 {
 	struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
@@ -2860,31 +2959,6 @@ static void nvme_release_prp_pools(struct nvme_dev *dev)
 	dma_pool_destroy(dev->prp_small_pool);
 }
 
-static int nvme_pci_alloc_iod_mempool(struct nvme_dev *dev)
-{
-	size_t meta_size = sizeof(struct scatterlist) * (NVME_MAX_META_SEGS + 1);
-	size_t alloc_size = sizeof(struct scatterlist) * NVME_MAX_SEGS;
-
-	dev->iod_mempool = mempool_create_node(1,
-			mempool_kmalloc, mempool_kfree,
-			(void *)alloc_size, GFP_KERNEL,
-			dev_to_node(dev->dev));
-	if (!dev->iod_mempool)
-		return -ENOMEM;
-
-	dev->iod_meta_mempool = mempool_create_node(1,
-			mempool_kmalloc, mempool_kfree,
-			(void *)meta_size, GFP_KERNEL,
-			dev_to_node(dev->dev));
-	if (!dev->iod_meta_mempool)
-		goto free;
-
-	return 0;
-free:
-	mempool_destroy(dev->iod_mempool);
-	return -ENOMEM;
-}
-
 static void nvme_free_tagset(struct nvme_dev *dev)
 {
 	if (dev->tagset.tags)
@@ -3253,15 +3327,11 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (result)
 		goto out_dev_unmap;
 
-	result = nvme_pci_alloc_iod_mempool(dev);
-	if (result)
-		goto out_release_prp_pools;
-
 	dev_info(dev->ctrl.device, "pci function %s\n", dev_name(&pdev->dev));
 
 	result = nvme_pci_enable(dev);
 	if (result)
-		goto out_release_iod_mempool;
+		goto out_release_prp_pools;
 
 	result = nvme_alloc_admin_tag_set(&dev->ctrl, &dev->admin_tagset,
 				&nvme_mq_admin_ops, sizeof(struct nvme_iod));
@@ -3328,9 +3398,6 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	nvme_dev_remove_admin(dev);
 	nvme_dbbuf_dma_free(dev);
 	nvme_free_queues(dev, 0);
-out_release_iod_mempool:
-	mempool_destroy(dev->iod_mempool);
-	mempool_destroy(dev->iod_meta_mempool);
 out_release_prp_pools:
 	nvme_release_prp_pools(dev);
 out_dev_unmap:
@@ -3395,8 +3462,6 @@ static void nvme_remove(struct pci_dev *pdev)
 	nvme_dev_remove_admin(dev);
 	nvme_dbbuf_dma_free(dev);
 	nvme_free_queues(dev, 0);
-	mempool_destroy(dev->iod_mempool);
-	mempool_destroy(dev->iod_meta_mempool);
 	nvme_release_prp_pools(dev);
 	nvme_dev_unmap(dev);
 	nvme_uninit_ctrl(&dev->ctrl);
-- 
2.49.0


