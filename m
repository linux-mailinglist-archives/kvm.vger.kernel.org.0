Return-Path: <kvm+bounces-37346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5649AA29150
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 15:48:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CE96188AC78
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 14:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18290158218;
	Wed,  5 Feb 2025 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqB0Z4Dj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248C0157465;
	Wed,  5 Feb 2025 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766501; cv=none; b=DiPic0FYwtiV45/3a4RdGrElEyUXv+LuToTT19TO3Lv8fLuEGXiZKDKTqa1QRIpHM5UmWY9khh0bdu8wJIvZUqhdh+WV2RRWyVfbvTFcGgN79JJGQT1YnV9NORcwfdWeSfhDY8I/mKnJCWFIA4EYxttVzOs7/Tyus2JJW4JgPzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766501; c=relaxed/simple;
	bh=1NtzYG/HNM1opZyJkrQLiGTX/MtRD6ibirQ0ZeaHPIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKrK5P7yvI+xeaN7MG7LPgn/mGM84ckR0laab2W0QSDVZL77tqJiWWnmxs+nHo7drXNst0XHJM4znvmb91o8ih8V7+kvnNNLgkCQ8GUdFdi1VlIphRutv9OIQJ0I0WkrDk8I5oUYQdKMgq8aGw42tvAy3M2oe6Y7UofkWStgO8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqB0Z4Dj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62643C4CED1;
	Wed,  5 Feb 2025 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738766499;
	bh=1NtzYG/HNM1opZyJkrQLiGTX/MtRD6ibirQ0ZeaHPIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqB0Z4DjEdA/HUDgteh5YGGZ5z4ZjMVTJeiuwcegETFy6m2clnnhRDEI/E8sIIDkD
	 4LqMLN923PSxMWj9Zw2gfYTotq/dSAAyG2ivF4LR34K4KTS9rZrKTnr+KX8/FOev8Y
	 /0Tz9BRAeRHdlGancpLzubdfvOZkjPVIYZFN2Jx3m4wWHsxaqDkocvMp899aetcJ52
	 EjKwTQVs3nzt0z6lZzCRkdnOYGChwEOWCtNJl2jiHpnrH4wDj3wsMUWdOIbvB/fZp2
	 g66/J0WurN1mcKKcLv8pwU6LQCWc6i8VBfF9pRgQlfMQcvUwOJxSQNXT3KIjdBgQIw
	 e8r02sHsq5Djw==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
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
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v7 12/17] RDMA/umem: Store ODP access mask information in PFN
Date: Wed,  5 Feb 2025 16:40:32 +0200
Message-ID: <8b6d2d95cc7e35740ae1c73f37b8ea11d0d70d32.1738765879.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1738765879.git.leonro@nvidia.com>
References: <cover.1738765879.git.leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

As a preparation to remove dma_list, store access mask in PFN pointer
and not in dma_addr_t.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/umem_odp.c   | 103 +++++++++++----------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   1 +
 drivers/infiniband/hw/mlx5/odp.c     |  37 +++++-----
 include/rdma/ib_umem_odp.h           |  14 +---
 4 files changed, 64 insertions(+), 91 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index e9fa22d31c23..e1a5a567efb3 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -296,22 +296,11 @@ EXPORT_SYMBOL(ib_umem_odp_release);
 static int ib_umem_odp_map_dma_single_page(
 		struct ib_umem_odp *umem_odp,
 		unsigned int dma_index,
-		struct page *page,
-		u64 access_mask)
+		struct page *page)
 {
 	struct ib_device *dev = umem_odp->umem.ibdev;
 	dma_addr_t *dma_addr = &umem_odp->dma_list[dma_index];
 
-	if (*dma_addr) {
-		/*
-		 * If the page is already dma mapped it means it went through
-		 * a non-invalidating trasition, like read-only to writable.
-		 * Resync the flags.
-		 */
-		*dma_addr = (*dma_addr & ODP_DMA_ADDR_MASK) | access_mask;
-		return 0;
-	}
-
 	*dma_addr = ib_dma_map_page(dev, page, 0, 1 << umem_odp->page_shift,
 				    DMA_BIDIRECTIONAL);
 	if (ib_dma_mapping_error(dev, *dma_addr)) {
@@ -319,7 +308,6 @@ static int ib_umem_odp_map_dma_single_page(
 		return -EFAULT;
 	}
 	umem_odp->npages++;
-	*dma_addr |= access_mask;
 	return 0;
 }
 
@@ -355,9 +343,6 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	struct hmm_range range = {};
 	unsigned long timeout;
 
-	if (access_mask == 0)
-		return -EINVAL;
-
 	if (user_virt < ib_umem_start(umem_odp) ||
 	    user_virt + bcnt > ib_umem_end(umem_odp))
 		return -EFAULT;
@@ -383,7 +368,7 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	if (fault) {
 		range.default_flags = HMM_PFN_REQ_FAULT;
 
-		if (access_mask & ODP_WRITE_ALLOWED_BIT)
+		if (access_mask & HMM_PFN_WRITE)
 			range.default_flags |= HMM_PFN_REQ_WRITE;
 	}
 
@@ -415,22 +400,17 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	for (pfn_index = 0; pfn_index < num_pfns;
 		pfn_index += 1 << (page_shift - PAGE_SHIFT), dma_index++) {
 
-		if (fault) {
-			/*
-			 * Since we asked for hmm_range_fault() to populate
-			 * pages it shouldn't return an error entry on success.
-			 */
-			WARN_ON(range.hmm_pfns[pfn_index] & HMM_PFN_ERROR);
-			WARN_ON(!(range.hmm_pfns[pfn_index] & HMM_PFN_VALID));
-		} else {
-			if (!(range.hmm_pfns[pfn_index] & HMM_PFN_VALID)) {
-				WARN_ON(umem_odp->dma_list[dma_index]);
-				continue;
-			}
-			access_mask = ODP_READ_ALLOWED_BIT;
-			if (range.hmm_pfns[pfn_index] & HMM_PFN_WRITE)
-				access_mask |= ODP_WRITE_ALLOWED_BIT;
-		}
+		/*
+		 * Since we asked for hmm_range_fault() to populate
+		 * pages it shouldn't return an error entry on success.
+		 */
+		WARN_ON(fault && range.hmm_pfns[pfn_index] & HMM_PFN_ERROR);
+		WARN_ON(fault && !(range.hmm_pfns[pfn_index] & HMM_PFN_VALID));
+		if (!(range.hmm_pfns[pfn_index] & HMM_PFN_VALID))
+			continue;
+
+		if (range.hmm_pfns[pfn_index] & HMM_PFN_DMA_MAPPED)
+			continue;
 
 		hmm_order = hmm_pfn_to_map_order(range.hmm_pfns[pfn_index]);
 		/* If a hugepage was detected and ODP wasn't set for, the umem
@@ -445,13 +425,14 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 		}
 
 		ret = ib_umem_odp_map_dma_single_page(
-				umem_odp, dma_index, hmm_pfn_to_page(range.hmm_pfns[pfn_index]),
-				access_mask);
+			umem_odp, dma_index,
+			hmm_pfn_to_page(range.hmm_pfns[pfn_index]));
 		if (ret < 0) {
 			ibdev_dbg(umem_odp->umem.ibdev,
 				  "ib_umem_odp_map_dma_single_page failed with error %d\n", ret);
 			break;
 		}
+		range.hmm_pfns[pfn_index] |= HMM_PFN_DMA_MAPPED;
 	}
 	/* upon success lock should stay on hold for the callee */
 	if (!ret)
@@ -471,7 +452,6 @@ EXPORT_SYMBOL(ib_umem_odp_map_dma_and_lock);
 void ib_umem_odp_unmap_dma_pages(struct ib_umem_odp *umem_odp, u64 virt,
 				 u64 bound)
 {
-	dma_addr_t dma_addr;
 	dma_addr_t dma;
 	int idx;
 	u64 addr;
@@ -482,34 +462,37 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem_odp *umem_odp, u64 virt,
 	virt = max_t(u64, virt, ib_umem_start(umem_odp));
 	bound = min_t(u64, bound, ib_umem_end(umem_odp));
 	for (addr = virt; addr < bound; addr += BIT(umem_odp->page_shift)) {
+		unsigned long pfn_idx = (addr - ib_umem_start(umem_odp)) >>
+					PAGE_SHIFT;
+		struct page *page =
+			hmm_pfn_to_page(umem_odp->pfn_list[pfn_idx]);
+
 		idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
 		dma = umem_odp->dma_list[idx];
 
-		/* The access flags guaranteed a valid DMA address in case was NULL */
-		if (dma) {
-			unsigned long pfn_idx = (addr - ib_umem_start(umem_odp)) >> PAGE_SHIFT;
-			struct page *page = hmm_pfn_to_page(umem_odp->pfn_list[pfn_idx]);
-
-			dma_addr = dma & ODP_DMA_ADDR_MASK;
-			ib_dma_unmap_page(dev, dma_addr,
-					  BIT(umem_odp->page_shift),
-					  DMA_BIDIRECTIONAL);
-			if (dma & ODP_WRITE_ALLOWED_BIT) {
-				struct page *head_page = compound_head(page);
-				/*
-				 * set_page_dirty prefers being called with
-				 * the page lock. However, MMU notifiers are
-				 * called sometimes with and sometimes without
-				 * the lock. We rely on the umem_mutex instead
-				 * to prevent other mmu notifiers from
-				 * continuing and allowing the page mapping to
-				 * be removed.
-				 */
-				set_page_dirty(head_page);
-			}
-			umem_odp->dma_list[idx] = 0;
-			umem_odp->npages--;
+		if (!(umem_odp->pfn_list[pfn_idx] & HMM_PFN_VALID))
+			goto clear;
+		if (!(umem_odp->pfn_list[pfn_idx] & HMM_PFN_DMA_MAPPED))
+			goto clear;
+
+		ib_dma_unmap_page(dev, dma, BIT(umem_odp->page_shift),
+				  DMA_BIDIRECTIONAL);
+		if (umem_odp->pfn_list[pfn_idx] & HMM_PFN_WRITE) {
+			struct page *head_page = compound_head(page);
+			/*
+			 * set_page_dirty prefers being called with
+			 * the page lock. However, MMU notifiers are
+			 * called sometimes with and sometimes without
+			 * the lock. We rely on the umem_mutex instead
+			 * to prevent other mmu notifiers from
+			 * continuing and allowing the page mapping to
+			 * be removed.
+			 */
+			set_page_dirty(head_page);
 		}
+		umem_odp->npages--;
+clear:
+		umem_odp->pfn_list[pfn_idx] &= ~HMM_PFN_FLAGS;
 	}
 }
 EXPORT_SYMBOL(ib_umem_odp_unmap_dma_pages);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 974a45c92fbb..53a06a7142ea 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -336,6 +336,7 @@ struct mlx5_ib_flow_db {
 #define MLX5_IB_UPD_XLT_PD	      BIT(4)
 #define MLX5_IB_UPD_XLT_ACCESS	      BIT(5)
 #define MLX5_IB_UPD_XLT_INDIRECT      BIT(6)
+#define MLX5_IB_UPD_XLT_DOWNGRADE     BIT(7)
 
 /* Private QP creation flags to be passed in ib_qp_init_attr.create_flags.
  *
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index f1e23583e6c0..dcfdf644cfe2 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -34,6 +34,7 @@
 #include <linux/kernel.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-resv.h>
+#include <linux/hmm.h>
 
 #include "mlx5_ib.h"
 #include "cmd.h"
@@ -158,22 +159,12 @@ static void populate_klm(struct mlx5_klm *pklm, size_t idx, size_t nentries,
 	}
 }
 
-static u64 umem_dma_to_mtt(dma_addr_t umem_dma)
-{
-	u64 mtt_entry = umem_dma & ODP_DMA_ADDR_MASK;
-
-	if (umem_dma & ODP_READ_ALLOWED_BIT)
-		mtt_entry |= MLX5_IB_MTT_READ;
-	if (umem_dma & ODP_WRITE_ALLOWED_BIT)
-		mtt_entry |= MLX5_IB_MTT_WRITE;
-
-	return mtt_entry;
-}
-
 static void populate_mtt(__be64 *pas, size_t idx, size_t nentries,
 			 struct mlx5_ib_mr *mr, int flags)
 {
 	struct ib_umem_odp *odp = to_ib_umem_odp(mr->umem);
+	bool downgrade = flags & MLX5_IB_UPD_XLT_DOWNGRADE;
+	unsigned long pfn;
 	dma_addr_t pa;
 	size_t i;
 
@@ -181,8 +172,17 @@ static void populate_mtt(__be64 *pas, size_t idx, size_t nentries,
 		return;
 
 	for (i = 0; i < nentries; i++) {
+		pfn = odp->pfn_list[idx + i];
+		if (!(pfn & HMM_PFN_VALID))
+			/* ODP initialization */
+			continue;
+
 		pa = odp->dma_list[idx + i];
-		pas[i] = cpu_to_be64(umem_dma_to_mtt(pa));
+		pa |= MLX5_IB_MTT_READ;
+		if ((pfn & HMM_PFN_WRITE) && !downgrade)
+			pa |= MLX5_IB_MTT_WRITE;
+
+		pas[i] = cpu_to_be64(pa);
 	}
 }
 
@@ -302,8 +302,7 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
 		 * estimate the cost of another UMR vs. the cost of bigger
 		 * UMR.
 		 */
-		if (umem_odp->dma_list[idx] &
-		    (ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT)) {
+		if (umem_odp->pfn_list[idx] & HMM_PFN_VALID) {
 			if (!in_block) {
 				blk_start_idx = idx;
 				in_block = 1;
@@ -684,7 +683,7 @@ static int pagefault_real_mr(struct mlx5_ib_mr *mr, struct ib_umem_odp *odp,
 {
 	int page_shift, ret, np;
 	bool downgrade = flags & MLX5_PF_FLAGS_DOWNGRADE;
-	u64 access_mask;
+	u64 access_mask = 0;
 	u64 start_idx;
 	bool fault = !(flags & MLX5_PF_FLAGS_SNAPSHOT);
 	u32 xlt_flags = MLX5_IB_UPD_XLT_ATOMIC;
@@ -692,12 +691,14 @@ static int pagefault_real_mr(struct mlx5_ib_mr *mr, struct ib_umem_odp *odp,
 	if (flags & MLX5_PF_FLAGS_ENABLE)
 		xlt_flags |= MLX5_IB_UPD_XLT_ENABLE;
 
+	if (flags & MLX5_PF_FLAGS_DOWNGRADE)
+		xlt_flags |= MLX5_IB_UPD_XLT_DOWNGRADE;
+
 	page_shift = odp->page_shift;
 	start_idx = (user_va - ib_umem_start(odp)) >> page_shift;
-	access_mask = ODP_READ_ALLOWED_BIT;
 
 	if (odp->umem.writable && !downgrade)
-		access_mask |= ODP_WRITE_ALLOWED_BIT;
+		access_mask |= HMM_PFN_WRITE;
 
 	np = ib_umem_odp_map_dma_and_lock(odp, user_va, bcnt, access_mask, fault);
 	if (np < 0)
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 0844c1d05ac6..a345c26a745d 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -8,6 +8,7 @@
 
 #include <rdma/ib_umem.h>
 #include <rdma/ib_verbs.h>
+#include <linux/hmm.h>
 
 struct ib_umem_odp {
 	struct ib_umem umem;
@@ -67,19 +68,6 @@ static inline size_t ib_umem_odp_num_pages(struct ib_umem_odp *umem_odp)
 	       umem_odp->page_shift;
 }
 
-/*
- * The lower 2 bits of the DMA address signal the R/W permissions for
- * the entry. To upgrade the permissions, provide the appropriate
- * bitmask to the map_dma_pages function.
- *
- * Be aware that upgrading a mapped address might result in change of
- * the DMA address for the page.
- */
-#define ODP_READ_ALLOWED_BIT  (1<<0ULL)
-#define ODP_WRITE_ALLOWED_BIT (1<<1ULL)
-
-#define ODP_DMA_ADDR_MASK (~(ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT))
-
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 
 struct ib_umem_odp *
-- 
2.48.1


