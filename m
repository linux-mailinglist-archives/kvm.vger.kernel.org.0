Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C287C3763F6
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 12:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhEGKiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 06:38:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:18353 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbhEGKiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 06:38:02 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fc6JH41l6zCr63;
        Fri,  7 May 2021 18:34:23 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 18:36:51 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Tian Kevin <kevin.tian@intel.com>
CC:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH v2 2/3] vfio/iommu_type1: Optimize dirty bitmap population based on iommu HWDBM
Date:   Fri, 7 May 2021 18:36:07 +0800
Message-ID: <20210507103608.39440-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210507103608.39440-1-zhukeqian1@huawei.com>
References: <20210507103608.39440-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kunkun Jiang <jiangkunkun@huawei.com>

In the past if vfio_iommu is not of pinned_page_dirty_scope and
vfio_dma is iommu_mapped, we populate full dirty bitmap for this
vfio_dma. Now we can try to get dirty log from iommu before make
the lousy decision.

The new dirty bitmap population policy:

In detail, if all vfio_group are of pinned_page_dirty_scope, the
dirty bitmap population is not affected. If there are vfio_groups
not of pinned_page_dirty_scope and all domains support HWDBM, we
can try to get dirty log from IOMMU. Otherwise, lead to full dirty
bitmap.

Consider DMA and group hotplug:

Start dirty log for newly added DMA range, and stop dirty log for
DMA range going to remove.
If a domain don't support HWDBM at start, but can support it after
hotplug some groups (attach a first group with HWDBM or detach all
groups without HWDBM). If a domain support HWDBM at start, but do
not support it after hotplug some groups (attach a group without
HWDBM or detach all groups without HWDBM). So our policy is that
switch dirty log for domains dynamically.

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 180 ++++++++++++++++++++++++++++++--
 1 file changed, 172 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 146aaf95589c..12fe1cf9113e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1200,6 +1200,46 @@ static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
 	}
 }
 
+static int vfio_iommu_dirty_log_clear(struct vfio_iommu *iommu,
+				      dma_addr_t start_iova, size_t size,
+				      unsigned long *bitmap_buffer,
+				      dma_addr_t base_iova,
+				      unsigned long pgshift)
+{
+	struct vfio_domain *d;
+	int ret = 0;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_clear_dirty_log(d->domain, start_iova, size,
+					    bitmap_buffer, base_iova, pgshift);
+		if (ret) {
+			pr_warn("vfio_iommu dirty log clear failed!\n");
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int vfio_iommu_dirty_log_sync(struct vfio_iommu *iommu,
+				     struct vfio_dma *dma,
+				     unsigned long pgshift)
+{
+	struct vfio_domain *d;
+	int ret = 0;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_sync_dirty_log(d->domain, dma->iova, dma->size,
+					   dma->bitmap, dma->iova, pgshift);
+		if (ret) {
+			pr_warn("vfio_iommu dirty log sync failed!\n");
+			break;
+		}
+	}
+
+	return ret;
+}
+
 static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 			      struct vfio_dma *dma, dma_addr_t base_iova,
 			      size_t pgsize)
@@ -1210,13 +1250,24 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	unsigned long copy_offset = bit_offset / BITS_PER_LONG;
 	unsigned long shift = bit_offset % BITS_PER_LONG;
 	unsigned long leftover;
+	bool iommu_hwdbm_dirty = false;
+	int ret;
 
-	/*
-	 * mark all pages dirty if any IOMMU capable device is not able
-	 * to report dirty pages and all pages are pinned and mapped.
-	 */
-	if (iommu->num_non_pinned_groups && dma->iommu_mapped)
+	if (!iommu->num_non_pinned_groups || !dma->iommu_mapped) {
+		/* nothing to do */
+	} else if (!iommu->num_non_hwdbm_domains) {
+		/* try to get dirty log from IOMMU */
+		iommu_hwdbm_dirty = true;
+		ret = vfio_iommu_dirty_log_sync(iommu, dma, pgshift);
+		if (ret)
+			return ret;
+	} else {
+		/*
+		 * mark all pages dirty if any IOMMU capable device is not able
+		 * to report dirty pages and all pages are pinned and mapped.
+		 */
 		bitmap_set(dma->bitmap, 0, nbits);
+	}
 
 	if (shift) {
 		bitmap_shift_left(dma->bitmap, dma->bitmap, shift,
@@ -1234,6 +1285,11 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 			 DIRTY_BITMAP_BYTES(nbits + shift)))
 		return -EFAULT;
 
+	/* Recover the bitmap if it'll be used to clear hardware dirty log */
+	if (shift && iommu_hwdbm_dirty)
+		bitmap_shift_right(dma->bitmap, dma->bitmap, shift,
+				   nbits + shift);
+
 	return 0;
 }
 
@@ -1272,6 +1328,16 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		if (ret)
 			return ret;
 
+		/* Clear iommu dirty log to re-enable dirty log tracking */
+		if (iommu->num_non_pinned_groups && dma->iommu_mapped &&
+		    !iommu->num_non_hwdbm_domains) {
+			ret = vfio_iommu_dirty_log_clear(iommu,	dma->iova,
+					dma->size, dma->bitmap, dma->iova,
+					pgshift);
+			if (ret)
+				return ret;
+		}
+
 		/*
 		 * Re-populate bitmap to include all pinned pages which are
 		 * considered as dirty but exclude pages which are unpinned and
@@ -1292,6 +1358,22 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
 	return 0;
 }
 
+static void vfio_dma_dirty_log_switch(struct vfio_iommu *iommu,
+				      struct vfio_dma *dma, bool enable)
+{
+	struct vfio_domain *d;
+
+	if (!dma->iommu_mapped)
+		return;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		if (!d->iommu_hwdbm)
+			continue;
+		WARN_ON(iommu_switch_dirty_log(d->domain, enable, dma->iova,
+					       dma->size, d->prot | dma->prot));
+	}
+}
+
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			     struct vfio_iommu_type1_dma_unmap *unmap,
 			     struct vfio_bitmap *bitmap)
@@ -1444,6 +1526,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 				break;
 		}
 
+		/* Stop log for removed dma */
+		if (iommu->dirty_page_tracking)
+			vfio_dma_dirty_log_switch(iommu, dma, false);
+
 		unmapped += dma->size;
 		n = rb_next(n);
 		vfio_remove_dma(iommu, dma);
@@ -1675,8 +1761,13 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 
 	if (!ret && iommu->dirty_page_tracking) {
 		ret = vfio_dma_bitmap_alloc(dma, pgsize);
-		if (ret)
+		if (ret) {
 			vfio_remove_dma(iommu, dma);
+			goto out_unlock;
+		}
+
+		/* Start dirty log for newly added dma */
+		vfio_dma_dirty_log_switch(iommu, dma, true);
 	}
 
 out_unlock:
@@ -2240,6 +2331,21 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
+static void vfio_domain_dirty_log_switch(struct vfio_iommu *iommu,
+					 struct vfio_domain *d, bool enable)
+{
+	struct rb_node *n;
+	struct vfio_dma *dma;
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		dma = rb_entry(n, struct vfio_dma, node);
+		if (!dma->iommu_mapped)
+			continue;
+		WARN_ON(iommu_switch_dirty_log(d->domain, enable, dma->iova,
+					       dma->size, d->prot | dma->prot));
+	}
+}
+
 /*
  * Called after a new group is added to the iommu_domain, or an old group is
  * removed from the iommu_domain. Update the HWDBM status of vfio_domain and
@@ -2251,13 +2357,48 @@ static void vfio_iommu_update_hwdbm(struct vfio_iommu *iommu,
 {
 	bool old_hwdbm = domain->iommu_hwdbm;
 	bool new_hwdbm = iommu_support_dirty_log(domain->domain);
+	bool singular = list_is_singular(&domain->group_list);
+	bool num_non_hwdbm_zeroed = false;
+	bool log_enabled, should_enable;
 
 	if (old_hwdbm && !new_hwdbm && attach) {
 		iommu->num_non_hwdbm_domains++;
 	} else if (!old_hwdbm && new_hwdbm && !attach) {
 		iommu->num_non_hwdbm_domains--;
+		if (!iommu->num_non_hwdbm_domains)
+			num_non_hwdbm_zeroed = true;
 	}
 	domain->iommu_hwdbm = new_hwdbm;
+
+	if (!iommu->dirty_page_tracking)
+		return;
+
+	/*
+	 * When switch the dirty policy from full dirty to iommu hwdbm, we must
+	 * populate full dirty now to avoid losing dirty.
+	 */
+	if (iommu->num_non_pinned_groups && num_non_hwdbm_zeroed)
+		vfio_iommu_populate_bitmap_full(iommu);
+
+	/*
+	 * The vfio_domain can switch dirty log tracking dynamically due to
+	 * group attach/detach. The basic idea is to convert current dirty log
+	 * status to desired dirty log status.
+	 *
+	 * If old_hwdbm is true then dirty log has been enabled. One exception
+	 * is that this is the first group attached to a domain.
+	 *
+	 * If new_hwdbm is true then dirty log should be enabled. One exception
+	 * is that this is the last group detached from a domain.
+	 */
+	log_enabled = old_hwdbm && !(attach && singular);
+	should_enable = new_hwdbm && !(!attach && singular);
+
+	/* Switch dirty log tracking when status changed */
+	if (should_enable && !log_enabled)
+		vfio_domain_dirty_log_switch(iommu, domain, true);
+	else if (!should_enable && log_enabled)
+		vfio_domain_dirty_log_switch(iommu, domain, false);
 }
 
 static int vfio_iommu_type1_attach_group(void *iommu_data,
@@ -2664,7 +2805,11 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	 */
 	if (update_dirty_scope) {
 		iommu->num_non_pinned_groups--;
-		if (iommu->dirty_page_tracking)
+		/*
+		 * When switch the dirty policy from full dirty to pinned scope,
+		 * we must populate full dirty now to avoid losing dirty.
+		 */
+		if (iommu->dirty_page_tracking && iommu->num_non_hwdbm_domains)
 			vfio_iommu_populate_bitmap_full(iommu);
 	}
 	mutex_unlock(&iommu->lock);
@@ -3008,6 +3153,22 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 			-EFAULT : 0;
 }
 
+static void vfio_iommu_dirty_log_switch(struct vfio_iommu *iommu, bool enable)
+{
+	struct vfio_domain *d;
+
+	/*
+	 * We enable dirty log tracking for these vfio_domains that support
+	 * HWDBM. Even if all iommu domains don't support HWDBM for now. They
+	 * may support it after detach some groups.
+	 */
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		if (!d->iommu_hwdbm)
+			continue;
+		vfio_domain_dirty_log_switch(iommu, d, enable);
+	}
+}
+
 static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 					unsigned long arg)
 {
@@ -3040,8 +3201,10 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		pgsize = 1 << __ffs(iommu->pgsize_bitmap);
 		if (!iommu->dirty_page_tracking) {
 			ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
-			if (!ret)
+			if (!ret) {
 				iommu->dirty_page_tracking = true;
+				vfio_iommu_dirty_log_switch(iommu, true);
+			}
 		}
 		mutex_unlock(&iommu->lock);
 		return ret;
@@ -3050,6 +3213,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		if (iommu->dirty_page_tracking) {
 			iommu->dirty_page_tracking = false;
 			vfio_dma_bitmap_free_all(iommu);
+			vfio_iommu_dirty_log_switch(iommu, false);
 		}
 		mutex_unlock(&iommu->lock);
 		return 0;
-- 
2.19.1

