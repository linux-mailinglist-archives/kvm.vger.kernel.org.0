Return-Path: <kvm+bounces-10934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4295871B9F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 414FE1F243B5
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD0E874E26;
	Tue,  5 Mar 2024 10:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vQANdiLd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C409074C00;
	Tue,  5 Mar 2024 10:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709634183; cv=none; b=C7J3Wd2/qchNurh3U/mRCtS77AOFK78DoXnPEfS7yjJmKcHwLawdLQ1X4v/ovaF9LBieqg/yxryyCtcIn1TJOBXJPCz13S/Y4/4qoyzU9CGk686tuLb27Yuzc7GcuyYGYuKiVCxV9Y8SV6NxWyn3uE2dwYdxqbzAtR65aX9hS/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709634183; c=relaxed/simple;
	bh=VVD1wxwJfNeGBkq+0kcqb+dcMkI1qAL6P7iY3YcEByk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUkvCsHZPHxhxGaAU94YOl5NxFmoDIUBED0P6sps+H3cH9NPmMQb5ISeevs7oi9nO0o6q+HlLUVdpdL72BTcfnssv5KWFzxpji1r9ZLgrw8f8xUBsJPf2D9dT0IPzUpBiNimi3EQCQu5NPah2A9F5A/Nt7+hC0RK+J60EDfkdYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vQANdiLd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58A6C433B1;
	Tue,  5 Mar 2024 10:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709634183;
	bh=VVD1wxwJfNeGBkq+0kcqb+dcMkI1qAL6P7iY3YcEByk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQANdiLdKD/LN5UWt1nmiQBwgmxKilV24iSvIJ8Yt04vFAY9KNn4dz5rrYG/XAzZW
	 U+bzNGXahJ4XtJdEVSkLE9+qM8rawhAiDhJdsJt3akdI3u+h1Jppo/U0MRD+yCwrlk
	 zXDnXU4ZGmX4iTO0vC1DBUfNUvNdXYvokUyslr+d+FfFT2NBTdiTdM5KPW+Ag2zSAh
	 6sjm2elJoHOhEaMn/O44OMKT/fS/wKWxHotb1pPa/HgbKVHfIrkcQNK+wclKC2YelP
	 G6K/cEnF5WIx80od3JRBvZrSQZYVkdF/nhfa7Rqff1sNX4RLGrXUI7G8RZVBMf95pB
	 GZ20E4vm/o6yg==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
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
	Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [RFC 09/16] RDMA/core: Separate DMA mapping to caching IOVA and page linkage
Date: Tue,  5 Mar 2024 12:22:10 +0200
Message-ID: <22f9bd2e33ca2ec2b3d3bbd4cbac55122991e02f.1709631413.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1709631800.git.leon@kernel.org>
References: <cover.1709631800.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Reuse newly added DMA API to cache IOVA and only link/unlink pages
in fast path.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/umem_odp.c | 57 ++----------------------------
 drivers/infiniband/hw/mlx5/odp.c   | 22 +++++++++++-
 include/rdma/ib_umem_odp.h         |  8 +----
 include/rdma/ib_verbs.h            | 36 +++++++++++++++++++
 4 files changed, 61 insertions(+), 62 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 3619fb78f786..1301009a6b78 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -81,20 +81,13 @@ static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 		if (!umem_odp->pfn_list)
 			return -ENOMEM;
 
-		umem_odp->dma_list = kvcalloc(
-			ndmas, sizeof(*umem_odp->dma_list), GFP_KERNEL);
-		if (!umem_odp->dma_list) {
-			ret = -ENOMEM;
-			goto out_pfn_list;
-		}
 
 		umem_odp->iova.dev = dev->dma_device;
 		umem_odp->iova.size = end - start;
 		umem_odp->iova.dir = DMA_BIDIRECTIONAL;
 		ret = ib_dma_alloc_iova(dev, &umem_odp->iova);
 		if (ret)
-			goto out_dma_list;
-
+			goto out_pfn_list;
 
 		ret = mmu_interval_notifier_insert(&umem_odp->notifier,
 						   umem_odp->umem.owning_mm,
@@ -107,8 +100,6 @@ static inline int ib_init_umem_odp(struct ib_umem_odp *umem_odp,
 
 out_free_iova:
 	ib_dma_free_iova(dev, &umem_odp->iova);
-out_dma_list:
-	kvfree(umem_odp->dma_list);
 out_pfn_list:
 	kvfree(umem_odp->pfn_list);
 	return ret;
@@ -288,7 +279,6 @@ void ib_umem_odp_release(struct ib_umem_odp *umem_odp)
 		mutex_unlock(&umem_odp->umem_mutex);
 		mmu_interval_notifier_remove(&umem_odp->notifier);
 		ib_dma_free_iova(dev, &umem_odp->iova);
-		kvfree(umem_odp->dma_list);
 		kvfree(umem_odp->pfn_list);
 	}
 	put_pid(umem_odp->tgid);
@@ -296,40 +286,10 @@ void ib_umem_odp_release(struct ib_umem_odp *umem_odp)
 }
 EXPORT_SYMBOL(ib_umem_odp_release);
 
-/*
- * Map for DMA and insert a single page into the on-demand paging page tables.
- *
- * @umem: the umem to insert the page to.
- * @dma_index: index in the umem to add the dma to.
- * @page: the page struct to map and add.
- * @access_mask: access permissions needed for this page.
- *
- * The function returns -EFAULT if the DMA mapping operation fails.
- *
- */
-static int ib_umem_odp_map_dma_single_page(
-		struct ib_umem_odp *umem_odp,
-		unsigned int dma_index,
-		struct page *page)
-{
-	struct ib_device *dev = umem_odp->umem.ibdev;
-	dma_addr_t *dma_addr = &umem_odp->dma_list[dma_index];
-
-	*dma_addr = ib_dma_map_page(dev, page, 0, 1 << umem_odp->page_shift,
-				    DMA_BIDIRECTIONAL);
-	if (ib_dma_mapping_error(dev, *dma_addr)) {
-		*dma_addr = 0;
-		return -EFAULT;
-	}
-	umem_odp->npages++;
-	return 0;
-}
-
 /**
  * ib_umem_odp_map_dma_and_lock - DMA map userspace memory in an ODP MR and lock it.
  *
  * Maps the range passed in the argument to DMA addresses.
- * The DMA addresses of the mapped pages is updated in umem_odp->dma_list.
  * Upon success the ODP MR will be locked to let caller complete its device
  * page table update.
  *
@@ -437,15 +397,6 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 				  __func__, hmm_order, page_shift);
 			break;
 		}
-
-		ret = ib_umem_odp_map_dma_single_page(
-				umem_odp, dma_index, hmm_pfn_to_page(range.hmm_pfns[pfn_index]));
-		if (ret < 0) {
-			ibdev_dbg(umem_odp->umem.ibdev,
-				  "ib_umem_odp_map_dma_single_page failed with error %d\n", ret);
-			break;
-		}
-		range.hmm_pfns[pfn_index] |= HMM_PFN_STICKY;
 	}
 	/* upon success lock should stay on hold for the callee */
 	if (!ret)
@@ -465,7 +416,6 @@ EXPORT_SYMBOL(ib_umem_odp_map_dma_and_lock);
 void ib_umem_odp_unmap_dma_pages(struct ib_umem_odp *umem_odp, u64 virt,
 				 u64 bound)
 {
-	dma_addr_t dma;
 	int idx;
 	u64 addr;
 	struct ib_device *dev = umem_odp->umem.ibdev;
@@ -479,15 +429,14 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem_odp *umem_odp, u64 virt,
 		struct page *page = hmm_pfn_to_page(umem_odp->pfn_list[pfn_idx]);
 
 		idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
-		dma = umem_odp->dma_list[idx];
 
 		if (!(umem_odp->pfn_list[pfn_idx] & HMM_PFN_VALID))
 			continue;
 		if (!(umem_odp->pfn_list[pfn_idx] & HMM_PFN_STICKY))
 			continue;
 
-		ib_dma_unmap_page(dev, dma, BIT(umem_odp->page_shift),
-				  DMA_BIDIRECTIONAL);
+		ib_dma_unlink_range(dev, &umem_odp->iova,
+				    idx * (1 << umem_odp->page_shift));
 		if (umem_odp->pfn_list[pfn_idx] & HMM_PFN_WRITE) {
 			struct page *head_page = compound_head(page);
 			/*
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 5713fe25f4de..13d61f1ab40b 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -149,6 +149,7 @@ static void populate_mtt(__be64 *pas, size_t idx, size_t nentries,
 {
 	struct ib_umem_odp *odp = to_ib_umem_odp(mr->umem);
 	bool downgrade = flags & MLX5_IB_UPD_XLT_DOWNGRADE;
+	struct ib_device *dev = odp->umem.ibdev;
 	unsigned long pfn;
 	dma_addr_t pa;
 	size_t i;
@@ -162,12 +163,31 @@ static void populate_mtt(__be64 *pas, size_t idx, size_t nentries,
 			/* Initial ODP init */
 			continue;
 
-		pa = odp->dma_list[idx + i];
+		if (pfn & HMM_PFN_STICKY && odp->iova.addr)
+			/*
+			 * We are in this flow when there is a need to resync flags,
+			 * for example when page was already linked in prefetch call
+			 * with READ flag and now we need to add WRITE flag
+			 *
+			 * This page was already programmed to HW and we don't want/need
+			 * to unlink and link it again just to resync flags.
+			 *
+			 * The DMA address calculation below is based on the fact that
+			 * RDMA UMEM doesn't work with swiotlb.
+			 */
+			pa = odp->iova.addr + (idx + i) * (1 << odp->page_shift);
+		else
+			pa = ib_dma_link_range(dev, hmm_pfn_to_page(pfn), 0, &odp->iova,
+				       (idx + i) * (1 << odp->page_shift));
+		WARN_ON_ONCE(ib_dma_mapping_error(dev, pa));
+
 		pa |= MLX5_IB_MTT_READ;
 		if ((pfn & HMM_PFN_WRITE) && !downgrade)
 			pa |= MLX5_IB_MTT_WRITE;
 
 		pas[i] = cpu_to_be64(pa);
+		odp->pfn_list[idx + i] |= HMM_PFN_STICKY;
+		odp->npages++;
 	}
 }
 
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 095b1297cfb1..a786556c65f9 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -17,15 +17,9 @@ struct ib_umem_odp {
 	/* An array of the pfns included in the on-demand paging umem. */
 	unsigned long *pfn_list;
 
-	/*
-	 * An array with DMA addresses mapped for pfns in pfn_list.
-	 * The lower two bits designate access permissions.
-	 * See ODP_READ_ALLOWED_BIT and ODP_WRITE_ALLOWED_BIT.
-	 */
-	dma_addr_t		*dma_list;
 	struct dma_iova_attrs iova;
 	/*
-	 * The umem_mutex protects the page_list and dma_list fields of an ODP
+	 * The umem_mutex protects the page_list field of an ODP
 	 * umem, allowing only a single thread to map/unmap pages. The mutex
 	 * also protects access to the mmu notifier counters.
 	 */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e71fa19187cc..c9e2bcd5268a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4160,6 +4160,42 @@ static inline void ib_dma_unmap_page(struct ib_device *dev,
 		dma_unmap_page(dev->dma_device, addr, size, direction);
 }
 
+/**
+ * ib_dma_link_range - Link a physical page to DMA address
+ * @dev: The device for which the dma_addr is to be created
+ * @page: The page to be mapped
+ * @offset: The offset within the page
+ * @iova: Preallocated IOVA attributes
+ * @dma_offset: DMA offset
+ */
+static inline dma_addr_t ib_dma_link_range(struct ib_device *dev,
+					   struct page *page,
+					   unsigned long offset,
+					   struct dma_iova_attrs *iova,
+					   dma_addr_t dma_offset)
+{
+	if (ib_uses_virt_dma(dev))
+		return (uintptr_t)(page_address(page) + offset);
+
+	return dma_link_range(page, offset, iova, dma_offset);
+}
+
+/**
+ * ib_dma_unlink_range - Unlink a mapping created by ib_dma_link_page()
+ * @dev: The device for which the DMA address was created
+ * @iova: DMA IOVA properties
+ * @dma_offset: DMA offset
+ */
+static inline void ib_dma_unlink_range(struct ib_device *dev,
+				       struct dma_iova_attrs *iova,
+				       dma_addr_t dma_offset)
+{
+	if (ib_uses_virt_dma(dev))
+		return;
+
+	dma_unlink_range(iova, dma_offset);
+}
+
 int ib_dma_virt_map_sg(struct ib_device *dev, struct scatterlist *sg, int nents);
 static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
 				      struct scatterlist *sg, int nents,
-- 
2.44.0


