Return-Path: <kvm+bounces-43644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E71AA93314
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 09:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E2F6461A6B
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 07:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816E22C2AC4;
	Fri, 18 Apr 2025 06:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfQNz03T"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8379B2C2584;
	Fri, 18 Apr 2025 06:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744958972; cv=none; b=PG7Dha+sNJAw3IO469pq1xsZe2C38f80Swt/X4XfqXiYUh1fUXtTEG8KGL+rJJHwK8kpVbnoo7Fo7Fj33ld2pJFPcDldbPAAklvjGKfhV6TtJIqB/CHl198MT7XbKGTxRtkxyfmNQJDjx6ruWkgrMnKfQ6S3wjbDtx0H1H4mhnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744958972; c=relaxed/simple;
	bh=dzm3I2stn/rnoMY31OBCo5UJufKUUvzj9CfHJN76ddI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM2Pu10zvuHNmEU9ZOlKkr2RNO+2BWyDh3zGx2GbCnEUCS1Sjgp2S5LGZk6eTuvahPpH91b3Klnphh9uW/j6vKskGfmffvyFKztKBLHSOfKM4i0gfnNN6HRPJKcoa0/Du705JcAvWGuPtwFKWT7PqHBkwvjuyZ9pN+xeJcnGWNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfQNz03T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7D6C4CEE7;
	Fri, 18 Apr 2025 06:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744958972;
	bh=dzm3I2stn/rnoMY31OBCo5UJufKUUvzj9CfHJN76ddI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfQNz03Tvi7PyDqJbYpw+z8XvAbZOr5h1DMtxBBSyly+tcueyMZVgRedudV7QZNrC
	 M7aTkgvvPoPGE5DQ6HYAPvZ1XN6fzPfHGoFAmWNH6HI0wQg5dlx5QQfm3aIze2KRYj
	 Y0dDyGSeg5+ZItf2TSDkvrcQXRdTMdGo0ciaAKgw4Cpg/x9kpX+jhYao2tUpLSB+x+
	 8Yws7WxwB3DmVTltXoicJecm0PZebq25XhNDK1n2w4LZNOB6EXHI6cOI3L1l3Dx2B0
	 GRFZ3Snhjfwdfi+yZZlGn8Xk6Zn8gZ725i+qogBhq+Dry52dXrd9F8uCXvIuGwih9T
	 phoUVrGO8uNgA==
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
Subject: [PATCH v8 21/24] nvme-pci: remove struct nvme_descriptor
Date: Fri, 18 Apr 2025 09:47:51 +0300
Message-ID: <d7773053d9329a29e823a636c1aa2a3c0030aef3.1744825142.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1744825142.git.leon@kernel.org>
References: <cover.1744825142.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

There is no real point in having a union of two pointer types here, just
use a void pointer as we mix and match types between the arms of the
union between the allocation and freeing side already.

Also rename the nr_allocations field to nr_descriptors to better describe
what it does.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 57 +++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b178d52eac1b..638e759b29ad 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -43,7 +43,7 @@
 #define NVME_MAX_KB_SZ	8192
 #define NVME_MAX_SEGS	128
 #define NVME_MAX_META_SEGS 15
-#define NVME_MAX_NR_ALLOCATIONS	5
+#define NVME_MAX_NR_DESCRIPTORS	5
 
 static int use_threaded_interrupts;
 module_param(use_threaded_interrupts, int, 0444);
@@ -219,30 +219,22 @@ struct nvme_queue {
 	struct completion delete_done;
 };
 
-union nvme_descriptor {
-	struct nvme_sgl_desc	*sg_list;
-	__le64			*prp_list;
-};
-
 /*
  * The nvme_iod describes the data in an I/O.
- *
- * The sg pointer contains the list of PRP/SGL chunk allocations in addition
- * to the actual struct scatterlist.
  */
 struct nvme_iod {
 	struct nvme_request req;
 	struct nvme_command cmd;
 	bool aborted;
-	s8 nr_allocations;	/* PRP list pool allocations. 0 means small
-				   pool in use */
+	/* # of PRP/SGL descriptors: (0 for small pool) */
+	s8 nr_descriptors;
 	unsigned int dma_len;	/* length of single DMA segment mapping */
 	dma_addr_t first_dma;
 	dma_addr_t meta_dma;
 	struct sg_table sgt;
 	struct sg_table meta_sgt;
-	union nvme_descriptor meta_list;
-	union nvme_descriptor list[NVME_MAX_NR_ALLOCATIONS];
+	void *meta_list;
+	void *descriptors[NVME_MAX_NR_DESCRIPTORS];
 };
 
 static inline unsigned int nvme_dbbuf_size(struct nvme_dev *dev)
@@ -544,8 +536,8 @@ static void nvme_free_prps(struct nvme_dev *dev, struct request *req)
 	dma_addr_t dma_addr = iod->first_dma;
 	int i;
 
-	for (i = 0; i < iod->nr_allocations; i++) {
-		__le64 *prp_list = iod->list[i].prp_list;
+	for (i = 0; i < iod->nr_descriptors; i++) {
+		__le64 *prp_list = iod->descriptors[i];
 		dma_addr_t next_dma_addr = le64_to_cpu(prp_list[last_prp]);
 
 		dma_pool_free(dev->prp_page_pool, prp_list, dma_addr);
@@ -567,11 +559,11 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 
 	dma_unmap_sgtable(dev->dev, &iod->sgt, rq_dma_dir(req), 0);
 
-	if (iod->nr_allocations == 0)
-		dma_pool_free(dev->prp_small_pool, iod->list[0].sg_list,
+	if (iod->nr_descriptors == 0)
+		dma_pool_free(dev->prp_small_pool, iod->descriptors[0],
 			      iod->first_dma);
-	else if (iod->nr_allocations == 1)
-		dma_pool_free(dev->prp_page_pool, iod->list[0].sg_list,
+	else if (iod->nr_descriptors == 1)
+		dma_pool_free(dev->prp_page_pool, iod->descriptors[0],
 			      iod->first_dma);
 	else
 		nvme_free_prps(dev, req);
@@ -629,18 +621,18 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 	nprps = DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE);
 	if (nprps <= (256 / 8)) {
 		pool = dev->prp_small_pool;
-		iod->nr_allocations = 0;
+		iod->nr_descriptors = 0;
 	} else {
 		pool = dev->prp_page_pool;
-		iod->nr_allocations = 1;
+		iod->nr_descriptors = 1;
 	}
 
 	prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
 	if (!prp_list) {
-		iod->nr_allocations = -1;
+		iod->nr_descriptors = -1;
 		return BLK_STS_RESOURCE;
 	}
-	iod->list[0].prp_list = prp_list;
+	iod->descriptors[0] = prp_list;
 	iod->first_dma = prp_dma;
 	i = 0;
 	for (;;) {
@@ -649,7 +641,7 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
 			prp_list = dma_pool_alloc(pool, GFP_ATOMIC, &prp_dma);
 			if (!prp_list)
 				goto free_prps;
-			iod->list[iod->nr_allocations++].prp_list = prp_list;
+			iod->descriptors[iod->nr_descriptors++] = prp_list;
 			prp_list[0] = old_prp_list[i - 1];
 			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
 			i = 1;
@@ -719,19 +711,19 @@ static blk_status_t nvme_pci_setup_sgls(struct nvme_dev *dev,
 
 	if (entries <= (256 / sizeof(struct nvme_sgl_desc))) {
 		pool = dev->prp_small_pool;
-		iod->nr_allocations = 0;
+		iod->nr_descriptors = 0;
 	} else {
 		pool = dev->prp_page_pool;
-		iod->nr_allocations = 1;
+		iod->nr_descriptors = 1;
 	}
 
 	sg_list = dma_pool_alloc(pool, GFP_ATOMIC, &sgl_dma);
 	if (!sg_list) {
-		iod->nr_allocations = -1;
+		iod->nr_descriptors = -1;
 		return BLK_STS_RESOURCE;
 	}
 
-	iod->list[0].sg_list = sg_list;
+	iod->descriptors[0] = sg_list;
 	iod->first_dma = sgl_dma;
 
 	nvme_pci_sgl_set_seg(&cmd->dptr.sgl, sgl_dma, entries);
@@ -870,7 +862,7 @@ static blk_status_t nvme_pci_setup_meta_sgls(struct nvme_dev *dev,
 		goto out_unmap_sg;
 
 	entries = iod->meta_sgt.nents;
-	iod->meta_list.sg_list = sg_list;
+	iod->meta_list = sg_list;
 	iod->meta_dma = sgl_dma;
 
 	cmnd->flags = NVME_CMD_SGL_METASEG;
@@ -923,7 +915,7 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	blk_status_t ret;
 
 	iod->aborted = false;
-	iod->nr_allocations = -1;
+	iod->nr_descriptors = -1;
 	iod->sgt.nents = 0;
 	iod->meta_sgt.nents = 0;
 
@@ -1048,8 +1040,7 @@ static __always_inline void nvme_unmap_metadata(struct nvme_dev *dev,
 		return;
 	}
 
-	dma_pool_free(dev->prp_small_pool, iod->meta_list.sg_list,
-		      iod->meta_dma);
+	dma_pool_free(dev->prp_small_pool, iod->meta_list, iod->meta_dma);
 	dma_unmap_sgtable(dev->dev, &iod->meta_sgt, rq_dma_dir(req), 0);
 	mempool_free(iod->meta_sgt.sgl, dev->iod_meta_mempool);
 }
@@ -3801,7 +3792,7 @@ static int __init nvme_init(void)
 	BUILD_BUG_ON(IRQ_AFFINITY_MAX_SETS < 2);
 	BUILD_BUG_ON(NVME_MAX_SEGS > SGES_PER_PAGE);
 	BUILD_BUG_ON(sizeof(struct scatterlist) * NVME_MAX_SEGS > PAGE_SIZE);
-	BUILD_BUG_ON(nvme_pci_npages_prp() > NVME_MAX_NR_ALLOCATIONS);
+	BUILD_BUG_ON(nvme_pci_npages_prp() > NVME_MAX_NR_DESCRIPTORS);
 
 	return pci_register_driver(&nvme_driver);
 }
-- 
2.49.0


