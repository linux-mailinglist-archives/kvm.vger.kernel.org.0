Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047A435DADA
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 11:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbhDMJPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 05:15:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16549 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245281AbhDMJPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 05:15:32 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FKKcg0RjGzPqkx;
        Tue, 13 Apr 2021 17:12:19 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 13 Apr 2021 17:15:02 +0800
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
Subject: [PATCH 1/3] vfio/iommu_type1: Add HWDBM status maintanance
Date:   Tue, 13 Apr 2021 17:14:43 +0800
Message-ID: <20210413091445.7448-2-zhukeqian1@huawei.com>
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

We are going to optimize dirty log tracking based on iommu
HWDBM feature, but the dirty log from iommu is useful only
when all iommu backed groups are with HWDBM feature.

This maintains a counter in vfio_iommu, which is used in
the policy of dirty bitmap population in next patch.

This also maintains a counter in vfio_domain, which is used
in the policy of switch dirty log in next patch.

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 44 +++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 45cbfd4879a5..9cb9ce021b22 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -73,6 +73,7 @@ struct vfio_iommu {
 	unsigned int		vaddr_invalid_count;
 	uint64_t		pgsize_bitmap;
 	uint64_t		num_non_pinned_groups;
+	uint64_t		num_non_hwdbm_groups;
 	wait_queue_head_t	vaddr_wait;
 	bool			v2;
 	bool			nesting;
@@ -85,6 +86,7 @@ struct vfio_domain {
 	struct iommu_domain	*domain;
 	struct list_head	next;
 	struct list_head	group_list;
+	uint64_t		num_non_hwdbm_groups;
 	int			prot;		/* IOMMU_CACHE */
 	bool			fgsp;		/* Fine-grained super pages */
 };
@@ -116,6 +118,7 @@ struct vfio_group {
 	struct list_head	next;
 	bool			mdev_group;	/* An mdev group */
 	bool			pinned_page_dirty_scope;
+	bool			iommu_hwdbm;	/* For iommu-backed group */
 };
 
 struct vfio_iova {
@@ -2252,6 +2255,44 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
+static int vfio_dev_enable_feature(struct device *dev, void *data)
+{
+	enum iommu_dev_features *feat = data;
+
+	if (iommu_dev_feature_enabled(dev, *feat))
+		return 0;
+
+	return iommu_dev_enable_feature(dev, *feat);
+}
+
+static bool vfio_group_supports_hwdbm(struct vfio_group *group)
+{
+	enum iommu_dev_features feat = IOMMU_DEV_FEAT_HWDBM;
+
+	return !iommu_group_for_each_dev(group->iommu_group, &feat,
+					 vfio_dev_enable_feature);
+}
+
+/*
+ * Called after a new group is added to the group_list of domain, or before an
+ * old group is removed from the group_list of domain.
+ */
+static void vfio_iommu_update_hwdbm(struct vfio_iommu *iommu,
+				    struct vfio_domain *domain,
+				    struct vfio_group *group,
+				    bool attach)
+{
+	/* Update the HWDBM status of group, domain and iommu */
+	group->iommu_hwdbm = vfio_group_supports_hwdbm(group);
+	if (!group->iommu_hwdbm && attach) {
+		domain->num_non_hwdbm_groups++;
+		iommu->num_non_hwdbm_groups++;
+	} else if (!group->iommu_hwdbm && !attach) {
+		domain->num_non_hwdbm_groups--;
+		iommu->num_non_hwdbm_groups--;
+	}
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
@@ -2409,6 +2450,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			vfio_iommu_detach_group(domain, group);
 			if (!vfio_iommu_attach_group(d, group)) {
 				list_add(&group->next, &d->group_list);
+				vfio_iommu_update_hwdbm(iommu, d, group, true);
 				iommu_domain_free(domain->domain);
 				kfree(domain);
 				goto done;
@@ -2435,6 +2477,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	list_add(&domain->next, &iommu->domain_list);
 	vfio_update_pgsize_bitmap(iommu);
+	vfio_iommu_update_hwdbm(iommu, domain, group, true);
 done:
 	/* Delete the old one and insert new iova list */
 	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
@@ -2618,6 +2661,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			continue;
 
 		vfio_iommu_detach_group(domain, group);
+		vfio_iommu_update_hwdbm(iommu, domain, group, false);
 		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
 		kfree(group);
-- 
2.19.1

