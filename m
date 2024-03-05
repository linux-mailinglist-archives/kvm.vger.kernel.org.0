Return-Path: <kvm+bounces-10908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A97871AC9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 677C928304B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 123415E208;
	Tue,  5 Mar 2024 10:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odKrLpzw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FCD54BEB;
	Tue,  5 Mar 2024 10:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709633768; cv=none; b=cm5N/Cz2l839WbW7yPaWvp00mEZ2odrcX7o2arS3p8cyirlImeE/Lo5VxkFE8cdEXFmK2GZoh0fWvENu3kn+QLnN7VE91qGFU2dNSRb/N0jWF3LgjDmYDRQIeyY2XY53bJxA7oytwUUyc/KNtMZT4nnG26I6dKUKzz+BBzSrqIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709633768; c=relaxed/simple;
	bh=aiC62CDa6AOfDDD5eldoWW566/DmWHKZI7ImrxLpIDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7MyGHzHaR0ecnjfLHZUa8bSvG7UomuHac/7Y7l7WL5G/dsNjMZklml1q0mK7Tz9gfoHvoYuvloe1q4XUWbGCuSiFHPk3vH15tEs33PO4D3qoGGLmicaK6CoHbPXLv/SQYOOoYfySyEbTs3m3ainW/mY4JC/3XJodcPpwWqCZfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odKrLpzw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1371BC433B2;
	Tue,  5 Mar 2024 10:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709633767;
	bh=aiC62CDa6AOfDDD5eldoWW566/DmWHKZI7ImrxLpIDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odKrLpzwo1+ckRGRNVfwyJTveQktZ8kd/S5yCucQpqZHcu4+kPj9mCgK/xgfYyPv3
	 I1yxGUXHANUZsFY2/zao6yrw+TC1BO6Ug1tU2XFw43OtQovJo9iqD1Ai4PUuOW2ek4
	 X/9Elu7Uq5ZyXbu6pqOIjh/WRKRxCRaxho9zx8G+nbRwIw8EWxL/eMZEcymmglY26U
	 WQHazEjuKBpCIJbiC5wZCkJazHnRrQozUZyHySSTthx/1IlEePhg78T3ZBxMiNMYg+
	 cr2bSbBp/+udUr2p98mwq716WamQdsJgUH8ZChwuFyRcfal6uhhPyUvWkzAuA7xFxs
	 NQnrJCt3MltQw==
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
Subject: [RFC 08/16] RDMA/umem: Store ODP access mask information in PFN
Date: Tue,  5 Mar 2024 12:15:18 +0200
Message-ID: <88b042d29a28a2866d5bc5ca20bdba4a71bc7aca.1709631413.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <a77609c9c9a09214e38b04133e44eee67fe50ab0.1709631413.git.leon@kernel.org>
References: <a77609c9c9a09214e38b04133e44eee67fe50ab0.1709631413.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

As a preparation to remove of dma_list, store access mask in PFN pointer
and not in dma_addr_t.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/umem_odp.c   | 99 +++++++++++-----------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/odp.c     | 37 ++++++-----
 include/rdma/ib_umem_odp.h           | 13 ----
 4 files changed, 59 insertions(+), 91 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index f69d1233dc82..3619fb78f786 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -310,22 +310,11 @@ EXPORT_SYMBOL(ib_umem_odp_release);
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
@@ -333,7 +322,6 @@ static int ib_umem_odp_map_dma_single_page(
 		return -EFAULT;
 	}
 	umem_odp->npages++;
-	*dma_addr |= access_mask;
 	return 0;
 }
 
@@ -369,9 +357,6 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	struct hmm_range range = {};
 	unsigned long timeout;
 
-	if (access_mask == 0)
-		return -EINVAL;
-
 	if (user_virt < ib_umem_start(umem_odp) ||
 	    user_virt + bcnt > ib_umem_end(umem_odp))
 		return -EFAULT;
@@ -397,7 +382,7 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 	if (fault) {
 		range.default_flags = HMM_PFN_REQ_FAULT;
 
-		if (access_mask & ODP_WRITE_ALLOWED_BIT)
+		if (access_mask & HMM_PFN_WRITE)
 			range.default_flags |= HMM_PFN_REQ_WRITE;
 	}
 
@@ -429,22 +414,17 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
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
+		if (range.hmm_pfns[pfn_index] & HMM_PFN_STICKY)
+			continue;
 
 		hmm_order = hmm_pfn_to_map_order(range.hmm_pfns[pfn_index]);
 		/* If a hugepage was detected and ODP wasn't set for, the umem
@@ -459,13 +439,13 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 		}
 
 		ret = ib_umem_odp_map_dma_single_page(
-				umem_odp, dma_index, hmm_pfn_to_page(range.hmm_pfns[pfn_index]),
-				access_mask);
+				umem_odp, dma_index, hmm_pfn_to_page(range.hmm_pfns[pfn_index]));
 		if (ret < 0) {
 			ibdev_dbg(umem_odp->umem.ibdev,
 				  "ib_umem_odp_map_dma_single_page failed with error %d\n", ret);
 			break;
 		}
+		range.hmm_pfns[pfn_index] |= HMM_PFN_STICKY;
 	}
 	/* upon success lock should stay on hold for the callee */
 	if (!ret)
@@ -485,7 +465,6 @@ EXPORT_SYMBOL(ib_umem_odp_map_dma_and_lock);
 void ib_umem_odp_unmap_dma_pages(struct ib_umem_odp *umem_odp, u64 virt,
 				 u64 bound)
 {
-	dma_addr_t dma_addr;
 	dma_addr_t dma;
 	int idx;
 	u64 addr;
@@ -496,34 +475,34 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem_odp *umem_odp, u64 virt,
 	virt = max_t(u64, virt, ib_umem_start(umem_odp));
 	bound = min_t(u64, bound, ib_umem_end(umem_odp));
 	for (addr = virt; addr < bound; addr += BIT(umem_odp->page_shift)) {
+		unsigned long pfn_idx = (addr - ib_umem_start(umem_odp)) >> PAGE_SHIFT;
+		struct page *page = hmm_pfn_to_page(umem_odp->pfn_list[pfn_idx]);
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
+			continue;
+		if (!(umem_odp->pfn_list[pfn_idx] & HMM_PFN_STICKY))
+			continue;
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
+		umem_odp->pfn_list[pfn_idx] &= ~HMM_PFN_STICKY;
+		umem_odp->npages--;
 	}
 }
 EXPORT_SYMBOL(ib_umem_odp_unmap_dma_pages);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index bbe79b86c717..4f368242680d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -334,6 +334,7 @@ struct mlx5_ib_flow_db {
 #define MLX5_IB_UPD_XLT_PD	      BIT(4)
 #define MLX5_IB_UPD_XLT_ACCESS	      BIT(5)
 #define MLX5_IB_UPD_XLT_INDIRECT      BIT(6)
+#define MLX5_IB_UPD_XLT_DOWNGRADE     BIT(7)
 
 /* Private QP creation flags to be passed in ib_qp_init_attr.create_flags.
  *
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 4a04cbc5b78a..5713fe25f4de 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -34,6 +34,7 @@
 #include <linux/kernel.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-resv.h>
+#include <linux/hmm.h>
 
 #include "mlx5_ib.h"
 #include "cmd.h"
@@ -143,22 +144,12 @@ static void populate_klm(struct mlx5_klm *pklm, size_t idx, size_t nentries,
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
 
@@ -166,8 +157,17 @@ static void populate_mtt(__be64 *pas, size_t idx, size_t nentries,
 		return;
 
 	for (i = 0; i < nentries; i++) {
+		pfn = odp->pfn_list[idx + i];
+		if (!(pfn & HMM_PFN_VALID))
+			/* Initial ODP init */
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
 
@@ -268,8 +268,7 @@ static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
 		 * estimate the cost of another UMR vs. the cost of bigger
 		 * UMR.
 		 */
-		if (umem_odp->dma_list[idx] &
-		    (ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT)) {
+		if (umem_odp->pfn_list[idx] & HMM_PFN_VALID) {
 			if (!in_block) {
 				blk_start_idx = idx;
 				in_block = 1;
@@ -555,7 +554,7 @@ static int pagefault_real_mr(struct mlx5_ib_mr *mr, struct ib_umem_odp *odp,
 {
 	int page_shift, ret, np;
 	bool downgrade = flags & MLX5_PF_FLAGS_DOWNGRADE;
-	u64 access_mask;
+	u64 access_mask = 0;
 	u64 start_idx;
 	bool fault = !(flags & MLX5_PF_FLAGS_SNAPSHOT);
 	u32 xlt_flags = MLX5_IB_UPD_XLT_ATOMIC;
@@ -563,12 +562,14 @@ static int pagefault_real_mr(struct mlx5_ib_mr *mr, struct ib_umem_odp *odp,
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
index bb2d7f2a5b04..095b1297cfb1 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -68,19 +68,6 @@ static inline size_t ib_umem_odp_num_pages(struct ib_umem_odp *umem_odp)
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
2.44.0


