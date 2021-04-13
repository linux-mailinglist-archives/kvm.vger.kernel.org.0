Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF2F35DADB
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 11:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245487AbhDMJPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 05:15:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16550 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245376AbhDMJPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 05:15:33 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FKKcg0r0HzPql5;
        Tue, 13 Apr 2021 17:12:19 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 13 Apr 2021 17:15:03 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Tian Kevin <kevin.tian@intel.com>
CC:     Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
        "Joerg Roedel" <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: [PATCH 2/3] vfio/iommu_type1: Optimize dirty bitmap population based on iommu HWDBM
Date:   Tue, 13 Apr 2021 17:14:44 +0800
Message-ID: <20210413091445.7448-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210413091445.7448-1-zhukeqian1@huawei.com>
References: <20210413091445.7448-1-zhukeqian1@huawei.com>
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

The bitmap population:

In detail, if all vfio_group are of pinned_page_dirty_scope, the
dirty bitmap population is not affected. If there are vfio_groups
not of pinned_page_dirty_scope and their domains support HWDBM,
then we can try to get dirty log from IOMMU. Otherwise, lead to
full dirty bitmap.

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
 drivers/vfio/vfio_iommu_type1.c | 166 ++++++++++++++++++++++++++++++--
 1 file changed, 159 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9cb9ce021b22..77950e47f56f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1202,6 +1202,46 @@ static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
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
@@ -1212,13 +1252,22 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	unsigned long copy_offset = bit_offset / BITS_PER_LONG;
 	unsigned long shift = bit_offset % BITS_PER_LONG;
 	unsigned long leftover;
+	int ret;
 
-	/*
-	 * mark all pages dirty if any IOMMU capable device is not able
-	 * to report dirty pages and all pages are pinned and mapped.
-	 */
-	if (iommu->num_non_pinned_groups && dma->iommu_mapped)
+	if (!iommu->num_non_pinned_groups || !dma->iommu_mapped) {
+		/* nothing to do */
+	} else if (!iommu->num_non_hwdbm_groups) {
+		/* try to get dirty log from IOMMU */
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
@@ -1236,6 +1285,12 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 			 DIRTY_BITMAP_BYTES(nbits + shift)))
 		return -EFAULT;
 
+	/* Recover the bitmap if it'll be used to clear hardware dirty log */
+	if (shift && iommu->num_non_pinned_groups && dma->iommu_mapped &&
+	    !iommu->num_non_hwdbm_groups)
+		bitmap_shift_right(dma->bitmap, dma->bitmap, shift,
+				   nbits + shift);
+
 	return 0;
 }
 
@@ -1274,6 +1329,16 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		if (ret)
 			return ret;
 
+		/* Clear iommu dirty log to re-enable dirty log tracking */
+		if (iommu->num_non_pinned_groups && dma->iommu_mapped &&
+		    !iommu->num_non_hwdbm_groups) {
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
@@ -1294,6 +1359,22 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
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
+		if (d->num_non_hwdbm_groups)
+			continue;
+		WARN_ON(iommu_switch_dirty_log(d->domain, enable, dma->iova,
+					       dma->size, d->prot | dma->prot));
+	}
+}
+
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			     struct vfio_iommu_type1_dma_unmap *unmap,
 			     struct vfio_bitmap *bitmap)
@@ -1446,6 +1527,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 				break;
 		}
 
+		/* Stop log for removed dma */
+		if (iommu->dirty_page_tracking)
+			vfio_dma_dirty_log_switch(iommu, dma, false);
+
 		unmapped += dma->size;
 		n = rb_next(n);
 		vfio_remove_dma(iommu, dma);
@@ -1677,8 +1762,13 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 
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
@@ -2273,6 +2363,21 @@ static bool vfio_group_supports_hwdbm(struct vfio_group *group)
 					 vfio_dev_enable_feature);
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
  * Called after a new group is added to the group_list of domain, or before an
  * old group is removed from the group_list of domain.
@@ -2282,6 +2387,10 @@ static void vfio_iommu_update_hwdbm(struct vfio_iommu *iommu,
 				    struct vfio_group *group,
 				    bool attach)
 {
+	uint64_t old_num_non_hwdbm = domain->num_non_hwdbm_groups;
+	bool singular = list_is_singular(&domain->group_list);
+	bool log_enabled, should_enable;
+
 	/* Update the HWDBM status of group, domain and iommu */
 	group->iommu_hwdbm = vfio_group_supports_hwdbm(group);
 	if (!group->iommu_hwdbm && attach) {
@@ -2291,6 +2400,30 @@ static void vfio_iommu_update_hwdbm(struct vfio_iommu *iommu,
 		domain->num_non_hwdbm_groups--;
 		iommu->num_non_hwdbm_groups--;
 	}
+
+	if (!iommu->dirty_page_tracking)
+		return;
+
+	/*
+	 * The vfio_domain can switch dirty log tracking dynamically due to
+	 * group attach/detach. The basic idea is to convert current dirty log
+	 * status to desired dirty log status.
+	 *
+	 * If num_non_hwdbm_groups is zero then dirty log has been enabled. One
+	 * exception is that this is the first group attached to a domain.
+	 *
+	 * If the updated num_non_hwdbm_groups is zero then dirty log should be
+	 * enabled. One exception is that this is the last group detached from
+	 * a domain.
+	 */
+	log_enabled = !old_num_non_hwdbm && !(attach && singular);
+	should_enable = !domain->num_non_hwdbm_groups && !(!attach && singular);
+
+	/* Switch dirty log tracking when status changed */
+	if (should_enable && !log_enabled)
+		vfio_domain_dirty_log_switch(iommu, domain, true);
+	else if (!should_enable && log_enabled)
+		vfio_domain_dirty_log_switch(iommu, domain, false);
 }
 
 static int vfio_iommu_type1_attach_group(void *iommu_data,
@@ -3046,6 +3179,22 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
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
+		if (d->num_non_hwdbm_groups)
+			continue;
+		vfio_domain_dirty_log_switch(iommu, d, enable);
+	}
+}
+
 static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 					unsigned long arg)
 {
@@ -3078,8 +3227,10 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
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
@@ -3088,6 +3239,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 		if (iommu->dirty_page_tracking) {
 			iommu->dirty_page_tracking = false;
 			vfio_dma_bitmap_free_all(iommu);
+			vfio_iommu_dirty_log_switch(iommu, false);
 		}
 		mutex_unlock(&iommu->lock);
 		return 0;
-- 
2.19.1

