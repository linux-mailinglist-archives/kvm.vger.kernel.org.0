Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB2C307993
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhA1PWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:22:25 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12342 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhA1PSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 10:18:55 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DRPG04PzBz7bL1;
        Thu, 28 Jan 2021 23:16:56 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 23:18:01 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH 09/11] vfio/iommu_type1: Add HWDBM status maintanance
Date:   Thu, 28 Jan 2021 23:17:40 +0800
Message-ID: <20210128151742.18840-10-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210128151742.18840-1-zhukeqian1@huawei.com>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: jiangkunkun <jiangkunkun@huawei.com>

We are going to optimize dirty log tracking based on iommu
HWDBM feature, but the dirty log from iommu is useful only
when all iommu backed groups are connected to iommu with
HWDBM feature. This maintains a counter for this feature.

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4dedaa9128..3b8522ebf955 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -74,6 +74,7 @@ struct vfio_iommu {
 	bool			nesting;
 	bool			dirty_page_tracking;
 	bool			pinned_page_dirty_scope;
+	uint64_t		num_non_hwdbm_groups;
 };
 
 struct vfio_domain {
@@ -102,6 +103,7 @@ struct vfio_group {
 	struct list_head	next;
 	bool			mdev_group;	/* An mdev group */
 	bool			pinned_page_dirty_scope;
+	bool			iommu_hwdbm;	/* Valid for non-mdev group */
 };
 
 struct vfio_iova {
@@ -976,6 +978,27 @@ static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
 	}
 }
 
+static int vfio_dev_has_feature(struct device *dev, void *data)
+{
+	enum iommu_dev_features *feat = data;
+
+	if (!iommu_dev_has_feature(dev, *feat))
+		return -ENODEV;
+
+	return 0;
+}
+
+static bool vfio_group_supports_hwdbm(struct vfio_group *group)
+{
+	enum iommu_dev_features feat = IOMMU_DEV_FEAT_HWDBM;
+
+	if (iommu_group_for_each_dev(group->iommu_group, &feat,
+				     vfio_dev_has_feature))
+		return false;
+
+	return true;
+}
+
 static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 			      struct vfio_dma *dma, dma_addr_t base_iova,
 			      size_t pgsize)
@@ -2189,6 +2212,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 * capable via the page pinning interface.
 	 */
 	iommu->pinned_page_dirty_scope = false;
+
+	/* Update the hwdbm status of group and iommu */
+	group->iommu_hwdbm = vfio_group_supports_hwdbm(group);
+	if (!group->iommu_hwdbm)
+		iommu->num_non_hwdbm_groups++;
+
 	mutex_unlock(&iommu->lock);
 	vfio_iommu_resv_free(&group_resv_regions);
 
@@ -2342,6 +2371,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	struct vfio_domain *domain;
 	struct vfio_group *group;
 	bool update_dirty_scope = false;
+	bool update_iommu_hwdbm = false;
 	LIST_HEAD(iova_copy);
 
 	mutex_lock(&iommu->lock);
@@ -2380,6 +2410,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 
 		vfio_iommu_detach_group(domain, group);
 		update_dirty_scope = !group->pinned_page_dirty_scope;
+		update_iommu_hwdbm = !group->iommu_hwdbm;
 		list_del(&group->next);
 		kfree(group);
 		/*
@@ -2417,6 +2448,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	 */
 	if (update_dirty_scope)
 		update_pinned_page_dirty_scope(iommu);
+	if (update_iommu_hwdbm)
+		iommu->num_non_hwdbm_groups--;
 	mutex_unlock(&iommu->lock);
 }
 
-- 
2.19.1

