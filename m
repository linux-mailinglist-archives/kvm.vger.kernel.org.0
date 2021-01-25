Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F67530208F
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 03:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbhAYCrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Jan 2021 21:47:36 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11435 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbhAYCre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Jan 2021 21:47:34 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DPDkp1PRwzjBfN;
        Mon, 25 Jan 2021 10:45:54 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 10:46:45 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>
CC:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "James Morse" <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: [PATCH] vfio/iommu_type1: Mantainance a counter for non_pinned_groups
Date:   Mon, 25 Jan 2021 10:46:42 +0800
Message-ID: <20210125024642.14604-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With this counter, we never need to traverse all groups to update
pinned_scope of vfio_iommu.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 40 +++++----------------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4dedaa9128..bb4bbcc79101 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -73,7 +73,7 @@ struct vfio_iommu {
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
-	bool			pinned_page_dirty_scope;
+	uint64_t		num_non_pinned_groups;
 };
 
 struct vfio_domain {
@@ -148,7 +148,6 @@ static int put_pfn(unsigned long pfn, int prot);
 static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 					       struct iommu_group *iommu_group);
 
-static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
 /*
  * This code handles mapping and unmapping of user data buffers
  * into DMA'ble space using the IOMMU
@@ -714,7 +713,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
 	if (!group->pinned_page_dirty_scope) {
 		group->pinned_page_dirty_scope = true;
-		update_pinned_page_dirty_scope(iommu);
+		iommu->num_non_pinned_groups--;
 	}
 
 	goto pin_done;
@@ -991,7 +990,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	 * mark all pages dirty if any IOMMU capable device is not able
 	 * to report dirty pages and all pages are pinned and mapped.
 	 */
-	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
+	if (iommu->num_non_pinned_groups && dma->iommu_mapped)
 		bitmap_set(dma->bitmap, 0, nbits);
 
 	if (shift) {
@@ -1622,33 +1621,6 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 	return group;
 }
 
-static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu)
-{
-	struct vfio_domain *domain;
-	struct vfio_group *group;
-
-	list_for_each_entry(domain, &iommu->domain_list, next) {
-		list_for_each_entry(group, &domain->group_list, next) {
-			if (!group->pinned_page_dirty_scope) {
-				iommu->pinned_page_dirty_scope = false;
-				return;
-			}
-		}
-	}
-
-	if (iommu->external_domain) {
-		domain = iommu->external_domain;
-		list_for_each_entry(group, &domain->group_list, next) {
-			if (!group->pinned_page_dirty_scope) {
-				iommu->pinned_page_dirty_scope = false;
-				return;
-			}
-		}
-	}
-
-	iommu->pinned_page_dirty_scope = true;
-}
-
 static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
 				  phys_addr_t *base)
 {
@@ -2057,8 +2029,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			 * addition of a dirty tracking group.
 			 */
 			group->pinned_page_dirty_scope = true;
-			if (!iommu->pinned_page_dirty_scope)
-				update_pinned_page_dirty_scope(iommu);
 			mutex_unlock(&iommu->lock);
 
 			return 0;
@@ -2188,7 +2158,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 * demotes the iommu scope until it declares itself dirty tracking
 	 * capable via the page pinning interface.
 	 */
-	iommu->pinned_page_dirty_scope = false;
+	iommu->num_non_pinned_groups++;
 	mutex_unlock(&iommu->lock);
 	vfio_iommu_resv_free(&group_resv_regions);
 
@@ -2416,7 +2386,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	 * to be promoted.
 	 */
 	if (update_dirty_scope)
-		update_pinned_page_dirty_scope(iommu);
+		iommu->num_non_pinned_groups--;
 	mutex_unlock(&iommu->lock);
 }
 
-- 
2.19.1

