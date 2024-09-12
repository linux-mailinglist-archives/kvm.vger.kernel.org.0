Return-Path: <kvm+bounces-26700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7349767B3
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:24:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D98FB24444
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0F21BDA83;
	Thu, 12 Sep 2024 11:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xr8vEFr1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22571BD4E7;
	Thu, 12 Sep 2024 11:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139834; cv=none; b=gTsX02G95J/YpN0gChPOC6laKg0f7TozW1O/n9nX2e31uTrtQASUvGmh/DVO1gFtnYmgYgh2zn1DEIsg1bK7TGlHvH6d1rameBKxpQr3XzpR6Cqb666BgNX5dC7MZPdQopHeuIs1AsXN4AF5ZoKfwrwKmF0uqFOKQsMo2+hml34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139834; c=relaxed/simple;
	bh=6/tc2ugkTwWAFbLVbxAp24kBUNCe2t7dWg8SzqJRz7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAVyB+rBx9Rkbo/cpOIjX4j/3FoB6Mv+W9XObe+zenwFFWeUcfRm95xarM9SzlYBk7w2tICF9cZWuFaujdCUjOk+T8+xgva5fVp0+dMo0HLZ5QPlNRsmlM3AeXS1UwXdZHdSvo9oOsNPqhaqdRbsCvI2Ty1LsWNqcY9qmPlUw88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xr8vEFr1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A2FC4CEC3;
	Thu, 12 Sep 2024 11:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139833;
	bh=6/tc2ugkTwWAFbLVbxAp24kBUNCe2t7dWg8SzqJRz7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xr8vEFr1DBAnFhLFzCX/ZunFrp1xgq07DQNQ6E4SLge/45rmHGLi/xIM/74GFsJFy
	 DblrLX/Paxj097l/XVrGmAEAGjBmNAPhhYMAYhI75lkR60W7Rv92gMkz81H6ZIwBGw
	 AAFtnY/3JoE6a4DOYz8fqOV3WqwNG8ugzOPPEA6BL4yTXDI2WsJ0p569Ke0Qjc6Tls
	 Y9acUkiss7PZkIFREINyhR2/pEWITABWRwwBwbuLSAd2W41RsvHksDG9Lln6FB6B97
	 ukDvlvhuUGueTTORLCsLbcVzFqp9H/eO2Wg7hI+EmTp+BvHdbdrfwpoJ1hqzhrJUKG
	 FYCii5JzIKsAQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 18/21] nvme-pci: remove optimizations for single DMA entry
Date: Thu, 12 Sep 2024 14:15:53 +0300
Message-ID: <875d92e2c453649e9d95080f27e631f196270008.1726138681.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1726138681.git.leon@kernel.org>
References: <cover.1726138681.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Future patches will remove SG table allocation from the NVMe PCI
code, which these single DMA entries tried to optimize. As a
preparation, let's remove them to unify the DMA mapping code.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 69 -----------------------------------------
 1 file changed, 69 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6cd9395ba9ec..a9a66f184138 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -233,7 +233,6 @@ struct nvme_iod {
 	bool aborted;
 	s8 nr_allocations;	/* PRP list pool allocations. 0 means small
 				   pool in use */
-	unsigned int dma_len;	/* length of single DMA segment mapping */
 	dma_addr_t first_dma;
 	dma_addr_t meta_dma;
 	struct sg_table sgt;
@@ -541,12 +540,6 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
-	if (iod->dma_len) {
-		dma_unmap_page(dev->dev, iod->first_dma, iod->dma_len,
-			       rq_dma_dir(req));
-		return;
-	}
-
 	WARN_ON_ONCE(!iod->sgt.nents);
 
 	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
@@ -696,11 +689,6 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 	/* setting the transfer type as SGL */
 	cmd->flags = NVME_CMD_SGL_METABUF;
 
-	if (entries == 1) {
-		nvme_pci_sgl_set_data(&cmd->dptr.sgl, sg);
-		return BLK_STS_OK;
-	}
-
 	if (entries <= (256 / sizeof(struct nvme_sgl_desc))) {
 		pool = dev->prp_small_pool;
 		iod->nr_allocations = 0;
@@ -727,45 +715,6 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 	return BLK_STS_OK;
 }
 
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
-
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
 static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 		struct nvme_command *cmnd)
 {
@@ -773,24 +722,6 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 	blk_status_t ret = BLK_STS_RESOURCE;
 	int rc;
 
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
 	iod->sgt.sgl = mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
 	if (!iod->sgt.sgl)
 		return BLK_STS_RESOURCE;
-- 
2.46.0


