Return-Path: <kvm+bounces-29790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B57A9B1EB1
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 15:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF118B218FE
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 14:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1E41DC745;
	Sun, 27 Oct 2024 14:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ptsQ2SUL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3917E8E5;
	Sun, 27 Oct 2024 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730038993; cv=none; b=lQ1elCeqCIiwaxNd6jh/oD0JTNoU8WjfTAkqtsPCF1cZEtZtKszQX7eYiyliKirYtmQE8zhqYQ7RthFSnWMhYn7N9qvsCWZRua9EzN/a1pdgYIjW65wQlkBSFHsmQV1GJN6+im3JIQ0wVSRejrIxs+nQBh2UheCEW3rUlPHqLic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730038993; c=relaxed/simple;
	bh=mGSLC0i0j/C6wQh6DJGfX8WLshJrc4MOVDi7g2OudPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhibGHP1I1D27unYWOHSyixO+s8BWK/qkiYXhjIODHcwQYTvuE7JvhGbVgT6sHd09ObAZrDNYaZlbTVbLkUbFFzpmr2AFit5+kbycJSEGrTgJ92SGV3ZeinuMShY6ykdhc5K30NWK3wQTaoLelx+hdgBePvs9ePlksAW++e57eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ptsQ2SUL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A8FC4CEE6;
	Sun, 27 Oct 2024 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730038993;
	bh=mGSLC0i0j/C6wQh6DJGfX8WLshJrc4MOVDi7g2OudPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptsQ2SULkjspInuBxCoAkFPYY7jouQyTCXw99hTQsjsyguomCiYwPAhX2ulgbDfVD
	 v1Q4Ve/tne6hzcG5k0jykyby4bLlF2mRUXpswpsqXN8vqFQcQg07bdvLO6byu01DcS
	 clbAWWn3zHoII1UOFysYLMz9+H1SG3FiCpfweUYqXrGy9a77XXW0xU2gwgdROT2Nhf
	 ptDji064KNRa3Ddvj171WP7r35qZULRqe1pbNJfHlYsdUXBb5J6BanoovA3bZ4hYG/
	 8HpJLLqa7rP+PaY92IHdwfikA3lXG6yT29ILuWbDlX6DTfEIce6r1dR2MTd142WuMe
	 wmbBQoGCtKJ0Q==
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
Subject: [RFC PATCH 7/7] nvme-pci: convert to blk_rq_dma_map
Date: Sun, 27 Oct 2024 16:22:00 +0200
Message-ID: <6038b47007ae804f0795e5f9d9cbc9c4a63a15b2.1730037261.git.leon@kernel.org>
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

Use the blk_rq_dma_map API to DMA map requests instead of
scatterlists.  This also removes the fast path single segment
code as the blk_rq_dma_map naturally inlines single IOVA
segment mappings into the preallocated structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 382 +++++++++++++++++++++-------------------
 1 file changed, 205 insertions(+), 177 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 79cd65a5f311..f41db1efecb1 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -7,7 +7,7 @@
 #include <linux/acpi.h>
 #include <linux/async.h>
 #include <linux/blkdev.h>
-#include <linux/blk-mq.h>
+#include <linux/blk-mq-dma.h>
 #include <linux/blk-mq-pci.h>
 #include <linux/blk-integrity.h>
 #include <linux/dmi.h>
@@ -27,7 +27,6 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/sed-opal.h>
-#include <linux/pci-p2pdma.h>
 
 #include "trace.h"
 #include "nvme.h"
@@ -227,10 +226,9 @@ struct nvme_iod {
 	bool aborted;
 	u8 nr_descriptors;	/* # of PRP/SGL descriptors */
 	bool large_descriptors;	/* uses the full page sized descriptor pool */
-	unsigned int dma_len;	/* length of single DMA segment mapping */
-	dma_addr_t first_dma;
+	unsigned int total_len;	/* length of the entire transfer */
 	dma_addr_t meta_dma;
-	struct sg_table sgt;
+	struct dma_iova_state dma_state;
 	void *descriptors[NVME_MAX_NR_DESCRIPTORS];
 };
 
@@ -527,9 +525,14 @@ static void nvme_free_descriptors(struct nvme_dev *dev, struct request *req)
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
@@ -545,67 +548,143 @@ static void nvme_free_descriptors(struct nvme_dev *dev, struct request *req)
 	}
 }
 
-static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
+static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-
-	if (iod->dma_len) {
-		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
-			       rq_dma_dir(req));
+	enum dma_data_direction dir = rq_dma_dir(req);
+	int length = iod->total_len;
+	dma_addr_t dma_addr;
+	int prp_len, nprps, i, desc;
+	__le64 *prp_list;
+	dma_addr_t dma_start;
+	u32 dma_len;
+
+	dma_addr = le64_to_cpu(iod->cmd.common.dptr.prp1);
+	prp_len = NVME_CTRL_PAGE_SIZE - (dma_addr & (NVME_CTRL_PAGE_SIZE - 1));
+	prp_len = min(length, prp_len);
+	length -= prp_len;
+	if (!length) {
+		dma_unmap_page(dev->dev, dma_addr, prp_len, dir);
 		return;
 	}
 
-	WARN_ON_ONCE(!iod->sgt.nents);
+	dma_start = dma_addr;
+	dma_len = prp_len;
 
-	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
-	nvme_free_descriptors(dev, req);
-	mempool_free(iod->sgt.sgl, dev->iod_mempool);
+	dma_addr = le64_to_cpu(iod->cmd.common.dptr.prp2);
+	if (length <= NVME_CTRL_PAGE_SIZE) {
+		if (dma_addr != dma_start + dma_len) {
+			dma_unmap_page(dev->dev, dma_start, dma_len, dir);
+			dma_start = dma_addr;
+			dma_len = 0;
+		}
+		dma_len += length;
+		goto done;
+	}
+
+	nprps = DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
+	i = 0;
+	desc = 0;
+	prp_list = iod->descriptors[desc];
+	do {
+		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
+			prp_list = iod->descriptors[++desc];
+			i = 0;
+		}
+
+		dma_addr = le64_to_cpu(prp_list[i++]);
+		if (dma_addr != dma_start + dma_len) {
+			dma_unmap_page(dev->dev, dma_start, dma_len, dir);
+			dma_start = dma_addr;
+			dma_len = 0;
+		}
+		prp_len = min(length, NVME_CTRL_PAGE_SIZE);
+		dma_len += prp_len;
+		length -= prp_len;
+	} while (length);
+done:
+	dma_unmap_page(dev->dev, dma_start, dma_len, dir);
 }
 
-static void nvme_print_sgl(struct scatterlist *sgl, int nents)
+static void nvme_free_sgls(struct nvme_dev *dev, struct request *req)
 {
-	int i;
-	struct scatterlist *sg;
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
+static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
-	for_each_sg(sgl, sg, nents, i) {
-		dma_addr_t phys = sg_phys(sg);
-		pr_warn("sg[%d] phys_addr:%pad offset:%d length:%d "
-			"dma_address:%pad dma_length:%d\n",
-			i, &phys, sg->offset, sg->length, &sg_dma_address(sg),
-			sg_dma_len(sg));
+	if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_state)) {
+		if (iod->cmd.common.flags & NVME_CMD_SGL_METABUF)
+			nvme_free_sgls(dev, req);
+		else
+			nvme_free_prps(dev, req);
 	}
+
+	if (iod->nr_descriptors)
+		nvme_free_descriptors(dev, req);
 }
 
 static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 		struct request *req, struct nvme_rw_command *cmnd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	int length = blk_rq_payload_bytes(req);
-	struct scatterlist *sg = iod->sgt.sgl;
-	int dma_len = sg_dma_len(sg);
-	u64 dma_addr = sg_dma_address(sg);
-	int offset = dma_addr & (NVME_CTRL_PAGE_SIZE - 1);
+	unsigned int length = blk_rq_payload_bytes(req);
+	struct blk_dma_iter iter;
+	dma_addr_t prp1_dma, prp2_dma = 0;
+	unsigned int prp_len, i;
 	__le64 *prp_list;
-	dma_addr_t prp_dma;
-	int i;
 
-	length -= (NVME_CTRL_PAGE_SIZE - offset);
-	if (length <= 0) {
-		iod->first_dma = 0;
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
 		goto done;
-	}
 
-	dma_len -= (NVME_CTRL_PAGE_SIZE - offset);
-	if (dma_len) {
-		dma_addr += (NVME_CTRL_PAGE_SIZE - offset);
-	} else {
-		sg = sg_next(sg);
-		dma_addr = sg_dma_address(sg);
-		dma_len = sg_dma_len(sg);
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
 
@@ -614,58 +693,83 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 		iod->large_descriptors = true;
 
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
 
@@ -681,17 +785,21 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 		struct request *req, struct nvme_rw_command *cmd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
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
 
-	if (entries == 1) {
-		nvme_pci_sgl_set_data(&cmd->dptr.sgl, sg);
+	if (!blk_rq_dma_map_iter_start(req, dev->dev, &iod->dma_state, &iter))
+		return iter.status;
+
+	if (entries == 1 || blk_rq_dma_map_coalesce(&iod->dma_state)) {
+		nvme_pci_sgl_set_data(&cmd->dptr.sgl, &iter);
+		iod->total_len += iter.len;
 		return BLK_STS_OK;
 	}
 
@@ -702,110 +810,30 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 	if (!sg_list)
 		return BLK_STS_RESOURCE;
 	iod->descriptors[iod->nr_descriptors++] = sg_list;
-	iod->first_dma = sgl_dma;
 
-	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, entries);
 	do {
-		nvme_pci_sgl_set_data(&sg_list[i++], sg);
-		sg = sg_next(sg);
-	} while (--entries > 0);
-
-	return BLK_STS_OK;
-}
-
-static blk_status_t nvme_setup_prp_simple(struct nvme_dev *dev,
-		struct request *req, struct nvme_rw_command *cmnd,
-		struct bio_vec *bv)
-{
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
-}
-
-static blk_status_t nvme_setup_sgl_simple(struct nvme_dev *dev,
-		struct request *req, struct nvme_rw_command *cmnd,
-		struct bio_vec *bv)
-{
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+		if (WARN_ON_ONCE(mapped == entries)) {
+			iter.status = BLK_STS_IOERR;
+			break;
+		}
+		nvme_pci_sgl_set_data(&sg_list[mapped++], &iter);
+		iod->total_len += iter.len;
+	} while (blk_rq_dma_map_iter_next(req, dev->dev, &iod->dma_state,
+			&iter));
 
-	iod->first_dma = dma_map_bvec(dev->dev, bv, rq_dma_dir(req), 0);
-	if (dma_mapping_error(dev->dev, iod->first_dma))
-		return BLK_STS_RESOURCE;
-	iod->dma_len = bv->bv_len;
+	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, mapped);
 
-	cmnd->flags = NVME_CMD_SGL_METABUF;
-	cmnd->dptr.sgl.addr = cpu_to_le64(iod->first_dma);
-	cmnd->dptr.sgl.length = cpu_to_le32(iod->dma_len);
-	cmnd->dptr.sgl.type = NVME_SGL_FMT_DATA_DESC << 4;
-	return BLK_STS_OK;
+	if (unlikely(iter.status))
+		nvme_free_sgls(dev, req);
+	return iter.status;
 }
 
 static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		struct nvme_command *cmnd)
 {
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	blk_status_t ret = BLK_STS_RESOURCE;
-	int rc;
-
-	if (blk_rq_nr_phys_segments(req) == 1) {
-		struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
-		struct bio_vec bv = req_bvec(req);
-
-		if (!is_pci_p2pdma_page(bv.bv_page)) {
-			if ((bv.bv_offset & (NVME_CTRL_PAGE_SIZE - 1)) +
-			     bv.bv_len <= NVME_CTRL_PAGE_SIZE * 2)
-				return nvme_setup_prp_simple(dev, req,
-							     &cmnd->rw, &bv);
-
-			if (nvmeq->qid && sgl_threshold &&
-			    nvme_ctrl_sgl_supported(&dev->ctrl))
-				return nvme_setup_sgl_simple(dev, req,
-							     &cmnd->rw, &bv);
-		}
-	}
-
-	iod->dma_len = 0;
-	iod->sgt.sgl = mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
-	if (!iod->sgt.sgl)
-		return BLK_STS_RESOURCE;
-	sg_init_table(iod->sgt.sgl, blk_rq_nr_phys_segments(req));
-	iod->sgt.orig_nents = blk_rq_map_sg(req->q, req, iod->sgt.sgl);
-	if (!iod->sgt.orig_nents)
-		goto out_free_sg;
-
-	rc = dma_map_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req),
-			     DMA_ATTR_NO_WARN);
-	if (rc) {
-		if (rc == -EREMOTEIO)
-			ret = BLK_STS_TARGET;
-		goto out_free_sg;
-	}
-
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
+	if (nvme_pci_use_sgls(dev, req, blk_rq_nr_phys_segments(req)))
+		return nvme_pci_setup_sgls(dev, req, &cmnd->rw);
+	return nvme_pci_setup_prps(dev, req, &cmnd->rw);
 }
 
 static blk_status_t nvme_map_metadata(struct nvme_dev *dev, struct request *req,
@@ -829,7 +857,7 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	iod->aborted = false;
 	iod->nr_descriptors = 0;
 	iod->large_descriptors = false;
-	iod->sgt.nents = 0;
+	iod->total_len = 0;
 
 	ret = nvme_setup_cmd(req->q->queuedata, req);
 	if (ret)
-- 
2.46.2


