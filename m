Return-Path: <kvm+bounces-26702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D1379767C0
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2F83281D66
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10881BF31D;
	Thu, 12 Sep 2024 11:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aa4jqYp4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E597C1BE238;
	Thu, 12 Sep 2024 11:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139842; cv=none; b=pbI+iv+jHUHBlf9J0RF99ENzitT2W/4WmrsC5JGd+2S+4PUQsDskCQ0GqhDoIDpObk2m4uVBsZO3DvRjOsv5NMbKfRv8Y7YQTGp9YVRA2AwvB9q7kTEZsWdZ0dHZMMfV6/mrEpCq9OIp+hCWdplnn2Ps5Y9h3j3FXaX80viz5TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139842; c=relaxed/simple;
	bh=lOZJXJxWXIBcVAPdAmMr2ULkiHyK5NnvqvNZOrmoKEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nHD2oJT1AayeJPgENBQ5zE3QB1ALhnVypA2juKIElrqUKVPt8lRT8dMJ2ZgBzkiyBqLcIH4y/SUR7k+id9EfrmJIPjrOeml+uNBGvMzv1W2xLypjajCUx8oLWaU3i2ryuaa/Vv16NDflPuqckCG2fJbk3sB5/nvYgmGraLWaRqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aa4jqYp4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFD2C4CEC3;
	Thu, 12 Sep 2024 11:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139841;
	bh=lOZJXJxWXIBcVAPdAmMr2ULkiHyK5NnvqvNZOrmoKEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aa4jqYp4u1ExCOP7/w9kgMgTLanlFjcSENpCvHwLxZJG24/4JEMDB8WrWR/ZXE8kY
	 Juyav+p0VQovEVj9JAlq+j6aeQwGcbFAnb01BLl/tXzu7uKtwokGJL0ZctSl0LoCs7
	 P3QuWaV5EUXW7Wouq24VW1LbPHzZdmmoKaQGTyPu2gT81+/pLyiftxi0OCxKlymzGX
	 oU3F0T4vwXclQxcMSER6kRBjONpvJzo7+ESdvUT5S/Y5RorNZdQCwAdOoxlqTbphSz
	 Ik8xt5/NptqmHyfH7KdmzxpRq1LwwSbYqDHqX56CkwE+ey2gSFTwy5a0IjjPmgrzgt
	 eRh1dP9PiSeNg==
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
Subject: [RFC v2 20/21] nvme-pci: use new dma API
Date: Thu, 12 Sep 2024 14:15:55 +0300
Message-ID: <dd0782c9fcb73487b60939a11f381411464f0572.1726138681.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1726138681.git.leon@kernel.org>
References: <cover.1726138681.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

This demonstrates how the new DMA API can fit into the NVMe driver and
replace the old DMA APIs.

As this is an RFC, I expect more robust error handling, optimizations,
and in-depth testing for the final version once we agree on DMA API
architecture.

Following is the performance comparision for existing DMA API case
with sg_table and with dma_map, once we have agreement on the new DMA
API design I intend to get similar profiling numbers for new DMA API.

sgl (sg_table + old dma API ) vs no_sgl (iod_dma_map + new DMA API) :-

block size                               IOPS (k) Average of 3

4K
--------------------------------------------------------------
sg-list-fio-perf.bs-4k-1.fio:             68.6
sg-list-fio-perf.bs-4k-2.fio:             68       68.36
sg-list-fio-perf.bs-4k-3.fio:             68.5

no-sg-list-fio-perf.bs-4k-1.fio:          68.7
no-sg-list-fio-perf.bs-4k-2.fio:          68.5     68.43
no-sg-list-fio-perf.bs-4k-3.fio:          68.1

% Change default vs new DMA API =       +0.0975%

8K
--------------------------------------------------------------
sg-list-fio-perf.bs-8k-1.fio:             67
sg-list-fio-perf.bs-8k-2.fio:             67.1     67.03
sg-list-fio-perf.bs-8k-3.fio:             67

no-sg-list-fio-perf.bs-8k-1.fio:          66.7
no-sg-list-fio-perf.bs-8k-2.fio:          66.7     66.7
no-sg-list-fio-perf.bs-8k-3.fio:          66.7

% Change default vs new DMA API =       +0.4993%

16K
--------------------------------------------------------------
sg-list-fio-perf.bs-16k-1.fio:            63.8
sg-list-fio-perf.bs-16k-2.fio:            63.4     63.5
sg-list-fio-perf.bs-16k-3.fio:            63.3

no-sg-list-fio-perf.bs-16k-1.fio:         63.5
no-sg-list-fio-perf.bs-16k-2.fio:         63.4     63.33
no-sg-list-fio-perf.bs-16k-3.fio:         63.1

% Change default vs new DMA API =       -0.2632%

32K
--------------------------------------------------------------
sg-list-fio-perf.bs-32k-1.fio:            59.3
sg-list-fio-perf.bs-32k-2.fio:            59.3     59.36
sg-list-fio-perf.bs-32k-3.fio:            59.5

no-sg-list-fio-perf.bs-32k-1.fio:         59.5
no-sg-list-fio-perf.bs-32k-2.fio:         59.6     59.43
no-sg-list-fio-perf.bs-32k-3.fio:         59.2

% Change default vs new DMA API =       +0.1122%

64K
--------------------------------------------------------------
sg-list-fio-perf.bs-64k-1.fio:            53.7
sg-list-fio-perf.bs-64k-2.fio:            53.4     53.56
sg-list-fio-perf.bs-64k-3.fio:            53.6

no-sg-list-fio-perf.bs-64k-1.fio:         53.5
no-sg-list-fio-perf.bs-64k-2.fio:         53.8     53.63
no-sg-list-fio-perf.bs-64k-3.fio:         53.6

% Change default vs new DMA API =        +0.1246%

128K
--------------------------------------------------------------
sg-list-fio-perf/bs-128k-1.fio:           48
sg-list-fio-perf/bs-128k-2.fio:           46.4     47.13
sg-list-fio-perf/bs-128k-3.fio:           47

no-sg-list-fio-perf/bs-128k-1.fio:        46.6
no-sg-list-fio-perf/bs-128k-2.fio:        47        46.9
no-sg-list-fio-perf/bs-128k-3.fio:        47.1

% Change default vs new DMA API =       −0.495%

256K
--------------------------------------------------------------
sg-list-fio-perf/bs-256k-1.fio:           37
sg-list-fio-perf/bs-256k-2.fio:           41        39.93
sg-list-fio-perf/bs-256k-3.fio:           41.8

no-sg-list-fio-perf/bs-256k-1.fio:        37.5
no-sg-list-fio-perf/bs-256k-2.fio:        41.4      40.5
no-sg-list-fio-perf/bs-256k-3.fio:        42.6

% Change default vs new DMA API =       +1.42%

512K
--------------------------------------------------------------
sg-list-fio-perf/bs-512k-1.fio:           28.5
sg-list-fio-perf/bs-512k-2.fio:           28.2      28.4
sg-list-fio-perf/bs-512k-3.fio:           28.5

no-sg-list-fio-perf/bs-512k-1.fio:        28.7
no-sg-list-fio-perf/bs-512k-2.fio:        28.6      28.7
no-sg-list-fio-perf/bs-512k-3.fio:        28.8

% Change default vs new DMA API =       +1.06%

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 354 ++++++++++++++++++++++++----------------
 1 file changed, 215 insertions(+), 139 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 2b236b1d209e..881cbf2c0cac 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -221,6 +221,12 @@ union nvme_descriptor {
 	__le64			*prp_list;
 };
 
+/* TODO: move to common header */
+struct dma_entry {
+	dma_addr_t addr;
+	unsigned int len;
+};
+
 /*
  * The nvme_iod describes the data in an I/O.
  *
@@ -234,9 +240,11 @@ struct nvme_iod {
 	u8 nr_dmas;
 	s8 nr_allocations;	/* PRP list pool allocations. 0 means small
 				   pool in use */
+	struct dma_iova_state state;
+	struct dma_entry dma;
+	struct dma_entry *map;
 	dma_addr_t first_dma;
 	dma_addr_t meta_dma;
-	struct sg_table sgt;
 	union nvme_descriptor list[NVME_MAX_NR_ALLOCATIONS];
 };
 
@@ -540,10 +548,9 @@ static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
 static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-
-	WARN_ON_ONCE(!iod->sgt.nents);
-
-	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
+	struct req_iterator iter;
+	struct bio_vec bv;
+	int cnt = 0;
 
 	if (iod->nr_allocations == 0)
 		dma_pool_free(dev->prp_small_pool, iod->list[0].sg_list,
@@ -553,20 +560,17 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 			      iod->first_dma);
 	else
 		nvme_free_prps(dev, req);
-	mempool_free(iod->sgt.sgl, dev->iod_mempool);
-}
 
-static void nvme_print_sgl(struct scatterlist *sgl, int nents)
-{
-	int i;
-	struct scatterlist *sg;
-
-	for_each_sg(sgl, sg, nents, i) {
-		dma_addr_t phys = sg_phys(sg);
-		pr_warn("sg[%d] phys_addr:%pad offset:%d length:%d "
-			"dma_address:%pad dma_length:%d\n",
-			i, &phys, sg->offset, sg->length, &sg_dma_address(sg),
-			sg_dma_len(sg));
+	if (iod->map) {
+		rq_for_each_bvec(bv, req, iter) {
+			dma_unmap_page(dev->dev, iod->map[cnt].addr,
+				       iod->map[cnt].len, rq_dma_dir(req));
+			cnt++;
+		}
+		kfree(iod->map);
+	} else {
+		dma_unlink_range(&iod->state);
+		dma_free_iova(&iod->state);
 	}
 }
 
@@ -574,97 +578,63 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 		struct request *req, struct nvme_rw_command *cmnd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct dma_pool *pool;
-	int length = blk_rq_payload_bytes(req);
-	struct scatterlist *sg = iod->sgt.sgl;
-	int dma_len = sg_dma_len(sg);
-	u64 dma_addr = sg_dma_address(sg);
-	int offset = dma_addr & (NVME_CTRL_PAGE_SIZE - 1);
-	__le64 *prp_list;
-	dma_addr_t prp_dma;
-	int nprps, i;
-
-	length -= (NVME_CTRL_PAGE_SIZE - offset);
-	if (length <= 0) {
-		iod->first_dma = 0;
-		goto done;
-	}
-
-	dma_len -= (NVME_CTRL_PAGE_SIZE - offset);
-	if (dma_len) {
-		dma_addr += (NVME_CTRL_PAGE_SIZE - offset);
-	} else {
-		sg = sg_next(sg);
-		dma_addr = sg_dma_address(sg);
-		dma_len = sg_dma_len(sg);
-	}
+	__le64 *prp_list = iod->list[0].prp_list;
+	int i = 0, idx = 0;
+	struct bio_vec bv;
+	struct req_iterator iter;
+	dma_addr_t offset = 0;
 
-	if (length <= NVME_CTRL_PAGE_SIZE) {
-		iod->first_dma = dma_addr;
-		goto done;
+	if (iod->nr_dmas <= 2) {
+		i = iod->nr_dmas;
+		/* We can use the inline PRP/SG list */
+		goto set_addr;
 	}
 
-	nprps = DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
-	if (nprps <= (256 / 8)) {
-		pool = dev->prp_small_pool;
-		iod->nr_allocations = 0;
-	} else {
-		pool = dev->prp_page_pool;
-		iod->nr_allocations = 1;
-	}
+	rq_for_each_bvec(bv, req, iter) {
+		dma_addr_t addr;
 
-	prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
-	if (!prp_list) {
-		iod->nr_allocations = -1;
-		return BLK_STS_RESOURCE;
-	}
-	iod->list[0].prp_list = prp_list;
-	iod->first_dma = prp_dma;
-	i = 0;
-	for (;;) {
-		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
-			__le64 *old_prp_list = prp_list;
-			prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
-			if (!prp_list)
-				goto free_prps;
-			iod->list[iod->nr_allocations++].prp_list = prp_list;
-			prp_list[0] = old_prp_list[i - 1];
-			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
-			i = 1;
+		if (iod->map)
+			offset = 0;
+
+		while (offset < bv.bv_len) {
+			if (iod->map)
+				addr = iod->map[i].addr;
+			else
+				addr = iod->dma.addr;
+
+			prp_list[idx] = cpu_to_le64(addr + offset);
+			offset += NVME_CTRL_PAGE_SIZE;
+			idx++;
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
-	}
-done:
-	cmnd->dptr.prp1 = cpu_to_le64(sg_dma_address(iod->sgt.sgl));
-	cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma);
+		i++;
+	}
+
+set_addr:
+	if (iod->map)
+		cmnd->dptr.prp1 = cpu_to_le64(iod->map[0].addr);
+	else
+		cmnd->dptr.prp1 = cpu_to_le64(iod->dma.addr);
+	if (idx == 1 && i == 1)
+		cmnd->dptr.prp2 = 0;
+	else if (idx == 2 && i == 2)
+		if (iod->map)
+			cmnd->dptr.prp2 =
+				cpu_to_le64((iod->map[0].addr + NVME_CTRL_PAGE_SIZE) &
+					    ~(NVME_CTRL_PAGE_SIZE - 1));
+		else
+			cmnd->dptr.prp2 =
+				cpu_to_le64((iod->dma.addr + NVME_CTRL_PAGE_SIZE) &
+					    ~(NVME_CTRL_PAGE_SIZE - 1));
+	else
+		cmnd->dptr.prp2 = cpu_to_le64(iod->first_dma);
 	return BLK_STS_OK;
-free_prps:
-	nvme_free_prps(dev, req);
-	return BLK_STS_RESOURCE;
-bad_sgl:
-	WARN(DO_ONCE(nvme_print_sgl, iod->sgt.sgl, iod->sgt.nents),
-			"Invalid SGL for payload:%d nents:%d\n",
-			blk_rq_payload_bytes(req), iod->sgt.nents);
-	return BLK_STS_IOERR;
 }
 
-static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
-		struct scatterlist *sg)
+static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge, dma_addr_t addr,
+				  int len)
 {
-	sge->addr = cpu_to_le64(sg_dma_address(sg));
-	sge->length = cpu_to_le32(sg_dma_len(sg));
+	sge->addr = cpu_to_le64(addr);
+	sge->length = cpu_to_le32(len);
 	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
 }
 
@@ -680,17 +650,77 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 		struct request *req, struct nvme_rw_command *cmd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct dma_pool *pool;
-	struct nvme_sgl_desc *sg_list;
-	struct scatterlist *sg = iod->sgt.sgl;
-	unsigned int entries = iod->sgt.nents;
-	dma_addr_t sgl_dma;
-	int i = 0;
+	struct nvme_sgl_desc *sg_list = iod->list[0].sg_list;
+	struct bio_vec bv = req_bvec(req);
+	struct req_iterator iter;
+	int i = 0, idx = 0;
+	dma_addr_t offset = 0;
 
 	/* setting the transfer type as SGL */
 	cmd->flags = NVME_CMD_SGL_METABUF;
 
-	if (entries <= (256 / sizeof(struct nvme_sgl_desc))) {
+	if (iod->nr_dmas <= 1)
+		/* We can use the inline PRP/SG list */
+		goto set_addr;
+
+	rq_for_each_bvec(bv, req, iter) {
+		dma_addr_t addr;
+
+		if (iod->map)
+			offset = 0;
+
+		while (offset < bv.bv_len) {
+			if (iod->map)
+				addr = iod->map[i].addr;
+			else
+				addr = iod->dma.addr;
+
+			nvme_pci_sgl_set_data(&sg_list[idx], addr + offset,
+					      bv.bv_len);
+			offset += NVME_CTRL_PAGE_SIZE;
+			idx++;
+		}
+		i++;
+	}
+
+set_addr:
+	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, iod->first_dma,
+			     blk_rq_nr_phys_segments(req));
+	return BLK_STS_OK;
+}
+
+static void nvme_pci_free_pool(struct nvme_dev *dev, struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+
+	if (iod->nr_allocations == 0)
+		dma_pool_free(dev->prp_small_pool, iod->list[0].sg_list,
+			      iod->first_dma);
+	else if (iod->nr_allocations == 1)
+		dma_pool_free(dev->prp_page_pool, iod->list[0].sg_list,
+			      iod->first_dma);
+	else
+		nvme_free_prps(dev, req);
+}
+
+static blk_status_t nvme_pci_setup_pool(struct nvme_dev *dev,
+					struct request *req, bool is_sgl)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct dma_pool *pool;
+	size_t entry_sz;
+	dma_addr_t addr;
+	u8 entries;
+	void *list;
+
+	if (iod->nr_dmas <= 2)
+		/* Do nothing, we can use the inline PRP/SG list */
+		return BLK_STS_OK;
+
+	/* First DMA address goes to prp1 anyway */
+	entries = iod->nr_dmas - 1;
+	entry_sz = (is_sgl) ? sizeof(struct nvme_sgl_desc) : sizeof(__le64);
+	if (entries <= (256 / entry_sz)) {
 		pool = dev->prp_small_pool;
 		iod->nr_allocations = 0;
 	} else {
@@ -698,21 +728,20 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 		iod->nr_allocations = 1;
 	}
 
-	sg_list = dma_pool_alloc(pool, GFP_ATOMIC, &sgl_dma);
-	if (!sg_list) {
+	/* TBD: allocate mulitple pools and chain them */
+	WARN_ON(entries > 512);
+
+	list = dma_pool_alloc(pool, GFP_ATOMIC, &addr);
+	if (!list) {
 		iod->nr_allocations = -1;
 		return BLK_STS_RESOURCE;
 	}
 
-	iod->list[0].sg_list = sg_list;
-	iod->first_dma = sgl_dma;
-
-	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, entries);
-	do {
-		nvme_pci_sgl_set_data(&sg_list[i++], sg);
-		sg = sg_next(sg);
-	} while (--entries > 0);
-
+	if (is_sgl)
+		iod->list[0].sg_list = list;
+	else
+		iod->list[0].prp_list = list;
+	iod->first_dma = addr;
 	return BLK_STS_OK;
 }
 
@@ -721,36 +750,84 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	blk_status_t ret = BLK_STS_RESOURCE;
-	int rc;
-
-	iod->sgt.sgl = mempool_alloc(dev->iod_mempool, GFP_ATOMIC);
-	if (!iod->sgt.sgl)
+	unsigned short n_segments = blk_rq_nr_phys_segments(req);
+	struct bio_vec bv = req_bvec(req);
+	struct req_iterator iter;
+	dma_addr_t dma_addr;
+	int rc, cnt = 0;
+	bool is_sgl;
+
+	dma_init_iova_state(&iod->state, dev->dev, rq_dma_dir(req));
+	dma_set_iova_state(&iod->state, bv.bv_page, bv.bv_len);
+
+	rc = dma_start_range(&iod->state);
+	if (rc)
 		return BLK_STS_RESOURCE;
-	sg_init_table(iod->sgt.sgl, blk_rq_nr_phys_segments(req));
-	iod->sgt.orig_nents = blk_rq_map_sg(req->q, req, iod->sgt.sgl);
-	if (!iod->sgt.orig_nents)
-		goto out_free_sg;
 
-	rc = dma_map_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req),
-			     DMA_ATTR_NO_WARN);
-	if (rc) {
-		if (rc == -EREMOTEIO)
-			ret = BLK_STS_TARGET;
-		goto out_free_sg;
+	iod->dma.len = 0;
+	iod->dma.addr = 0;
+
+	if (dma_can_use_iova(&iod->state)) {
+		iod->map = NULL;
+		rc = dma_alloc_iova_unaligned(&iod->state, bvec_phys(&bv),
+					      blk_rq_payload_bytes(req));
+		if (rc)
+			return BLK_STS_RESOURCE;
+
+		rq_for_each_bvec(bv, req, iter) {
+			dma_addr = dma_link_range(&iod->state, bvec_phys(&bv),
+						  bv.bv_len);
+			if (dma_mapping_error(dev->dev, dma_addr))
+				goto out_free;
+
+			if (!iod->dma.addr)
+				iod->dma.addr = dma_addr;
+		}
+		WARN_ON(blk_rq_payload_bytes(req) != iod->state.range_size);
+	} else {
+		iod->map = kmalloc_array(n_segments, sizeof(*iod->map),
+					 GFP_ATOMIC);
+		if (!iod->map)
+			return BLK_STS_RESOURCE;
+
+		rq_for_each_bvec(bv, req, iter) {
+			dma_addr = dma_map_bvec(dev->dev, &bv, rq_dma_dir(req), 0);
+			if (dma_mapping_error(dev->dev, dma_addr))
+				goto out_free;
+
+			iod->map[cnt].addr = dma_addr;
+			iod->map[cnt].len = bv.bv_len;
+			cnt++;
+		}
 	}
+	dma_end_range(&iod->state);
 
-	if (nvme_pci_use_sgls(dev, req, iod->sgt.nents))
+	is_sgl = nvme_pci_use_sgls(dev, req, n_segments);
+	ret = nvme_pci_setup_pool(dev, req, is_sgl);
+	if (ret != BLK_STS_OK)
+		goto out_free;
+
+	if (is_sgl)
 		ret = nvme_pci_setup_sgls(dev, req, &cmnd->rw);
 	else
 		ret = nvme_pci_setup_prps(dev, req, &cmnd->rw);
 	if (ret != BLK_STS_OK)
-		goto out_unmap_sg;
+		goto out_free_pool;
+
 	return BLK_STS_OK;
 
-out_unmap_sg:
-	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
-out_free_sg:
-	mempool_free(iod->sgt.sgl, dev->iod_mempool);
+out_free_pool:
+	nvme_pci_free_pool(dev, req);
+out_free:
+	if (iod->map) {
+		while (cnt--)
+			dma_unmap_page(dev->dev, iod->map[cnt].addr,
+				       iod->map[cnt].len, rq_dma_dir(req));
+		kfree(iod->map);
+	} else {
+		dma_unlink_range(&iod->state);
+		dma_free_iova(&iod->state);
+	}
 	return ret;
 }
 
@@ -791,7 +868,6 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 
 	iod->aborted = false;
 	iod->nr_allocations = -1;
-	iod->sgt.nents = 0;
 
 	ret = nvme_setup_cmd(req->q->queuedata, req);
 	if (ret)
-- 
2.46.0


