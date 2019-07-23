Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F5571C85
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 18:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388875AbfGWQIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 12:08:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2707 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388853AbfGWQIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 12:08:44 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 20200FD2400338E74217;
        Wed, 24 Jul 2019 00:08:29 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.202.227.237) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 00:08:18 +0800
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <alex.williamson@redhat.com>, <eric.auger@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, <xuwei5@hisilicon.com>,
        <kevin.tian@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 1/6] vfio/type1: Introduce iova list and add iommu aperture validity check
Date:   Tue, 23 Jul 2019 17:06:32 +0100
Message-ID: <20190723160637.8384-2-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20190723160637.8384-1-shameerali.kolothum.thodi@huawei.com>
References: <20190723160637.8384-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.237]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This introduces an iova list that is valid for dma mappings. Make
sure the new iommu aperture window doesn't conflict with the current
one or with any existing dma mappings during attach.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
v7-->v8
 -Addressed suggestions by Eric to update comments.
---
 drivers/vfio/vfio_iommu_type1.c | 184 +++++++++++++++++++++++++++++++-
 1 file changed, 181 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 054391f30fa8..6a69652b406b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -62,6 +62,7 @@ MODULE_PARM_DESC(dma_entry_limit,
 
 struct vfio_iommu {
 	struct list_head	domain_list;
+	struct list_head	iova_list;
 	struct vfio_domain	*external_domain; /* domain for external user */
 	struct mutex		lock;
 	struct rb_root		dma_list;
@@ -97,6 +98,12 @@ struct vfio_group {
 	bool			mdev_group;	/* An mdev group */
 };
 
+struct vfio_iova {
+	struct list_head	list;
+	dma_addr_t		start;
+	dma_addr_t		end;
+};
+
 /*
  * Guest RAM pinning working set or DMA target
  */
@@ -1388,6 +1395,146 @@ static int vfio_mdev_iommu_device(struct device *dev, void *data)
 	return 0;
 }
 
+/*
+ * This is a helper function to insert an address range to iova list.
+ * The list is initially created with a single entry corresponding to
+ * the IOMMU domain geometry to which the device group is attached.
+ * The list aperture gets modified when a new domain is added to the
+ * container if the new aperture doesn't conflict with the current one
+ * or with any existing dma mappings. The list is also modified to
+ * exclude any reserved regions associated with the device group.
+ */
+static int vfio_iommu_iova_insert(struct list_head *head,
+				  dma_addr_t start, dma_addr_t end)
+{
+	struct vfio_iova *region;
+
+	region = kmalloc(sizeof(*region), GFP_KERNEL);
+	if (!region)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&region->list);
+	region->start = start;
+	region->end = end;
+
+	list_add_tail(&region->list, head);
+	return 0;
+}
+
+/*
+ * Check the new iommu aperture conflicts with existing aper or with any
+ * existing dma mappings.
+ */
+static bool vfio_iommu_aper_conflict(struct vfio_iommu *iommu,
+				     dma_addr_t start, dma_addr_t end)
+{
+	struct vfio_iova *first, *last;
+	struct list_head *iova = &iommu->iova_list;
+
+	if (list_empty(iova))
+		return false;
+
+	/* Disjoint sets, return conflict */
+	first = list_first_entry(iova, struct vfio_iova, list);
+	last = list_last_entry(iova, struct vfio_iova, list);
+	if (start > last->end || end < first->start)
+		return true;
+
+	/* Check for any existing dma mappings below the new start */
+	if (start > first->start) {
+		if (vfio_find_dma(iommu, first->start, start - first->start))
+			return true;
+	}
+
+	/* Check for any existing dma mappings beyond the new end */
+	if (end < last->end) {
+		if (vfio_find_dma(iommu, end + 1, last->end - end))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Resize iommu iova aperture window. This is called only if the new
+ * aperture has no conflict with existing aperture and dma mappings.
+ */
+static int vfio_iommu_aper_resize(struct list_head *iova,
+				  dma_addr_t start, dma_addr_t end)
+{
+	struct vfio_iova *node, *next;
+
+	if (list_empty(iova))
+		return vfio_iommu_iova_insert(iova, start, end);
+
+	/* Adjust iova list start */
+	list_for_each_entry_safe(node, next, iova, list) {
+		if (start < node->start)
+			break;
+		if (start >= node->start && start < node->end) {
+			node->start = start;
+			break;
+		}
+		/* Delete nodes before new start */
+		list_del(&node->list);
+		kfree(node);
+	}
+
+	/* Adjust iova list end */
+	list_for_each_entry_safe(node, next, iova, list) {
+		if (end > node->end)
+			continue;
+		if (end > node->start && end <= node->end) {
+			node->end = end;
+			continue;
+		}
+		/* Delete nodes after new end */
+		list_del(&node->list);
+		kfree(node);
+	}
+
+	return 0;
+}
+
+static void vfio_iommu_iova_free(struct list_head *iova)
+{
+	struct vfio_iova *n, *next;
+
+	list_for_each_entry_safe(n, next, iova, list) {
+		list_del(&n->list);
+		kfree(n);
+	}
+}
+
+static int vfio_iommu_iova_get_copy(struct vfio_iommu *iommu,
+				    struct list_head *iova_copy)
+{
+	struct list_head *iova = &iommu->iova_list;
+	struct vfio_iova *n;
+	int ret;
+
+	list_for_each_entry(n, iova, list) {
+		ret = vfio_iommu_iova_insert(iova_copy, n->start, n->end);
+		if (ret)
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	vfio_iommu_iova_free(iova_copy);
+	return ret;
+}
+
+static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
+					struct list_head *iova_copy)
+{
+	struct list_head *iova = &iommu->iova_list;
+
+	vfio_iommu_iova_free(iova);
+
+	list_splice_tail(iova_copy, iova);
+}
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
@@ -1398,6 +1545,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	int ret;
 	bool resv_msi, msi_remap;
 	phys_addr_t resv_msi_base;
+	struct iommu_domain_geometry geo;
+	LIST_HEAD(iova_copy);
 
 	mutex_lock(&iommu->lock);
 
@@ -1474,6 +1623,29 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_domain;
 
+	/* Get aperture info */
+	iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY, &geo);
+
+	if (vfio_iommu_aper_conflict(iommu, geo.aperture_start,
+				     geo.aperture_end)) {
+		ret = -EINVAL;
+		goto out_detach;
+	}
+
+	/*
+	 * We don't want to work on the original iova list as the list
+	 * gets modified and in case of failure we have to retain the
+	 * original list. Get a copy here.
+	 */
+	ret = vfio_iommu_iova_get_copy(iommu, &iova_copy);
+	if (ret)
+		goto out_detach;
+
+	ret = vfio_iommu_aper_resize(&iova_copy, geo.aperture_start,
+				     geo.aperture_end);
+	if (ret)
+		goto out_detach;
+
 	resv_msi = vfio_iommu_has_sw_msi(iommu_group, &resv_msi_base);
 
 	INIT_LIST_HEAD(&domain->group_list);
@@ -1507,8 +1679,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 				list_add(&group->next, &d->group_list);
 				iommu_domain_free(domain->domain);
 				kfree(domain);
-				mutex_unlock(&iommu->lock);
-				return 0;
+				goto done;
 			}
 
 			ret = vfio_iommu_attach_group(domain, group);
@@ -1531,7 +1702,9 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	}
 
 	list_add(&domain->next, &iommu->domain_list);
-
+done:
+	/* Delete the old one and insert new iova list */
+	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
 	mutex_unlock(&iommu->lock);
 
 	return 0;
@@ -1540,6 +1713,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	vfio_iommu_detach_group(domain, group);
 out_domain:
 	iommu_domain_free(domain->domain);
+	vfio_iommu_iova_free(&iova_copy);
 out_free:
 	kfree(domain);
 	kfree(group);
@@ -1679,6 +1853,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	}
 
 	INIT_LIST_HEAD(&iommu->domain_list);
+	INIT_LIST_HEAD(&iommu->iova_list);
 	iommu->dma_list = RB_ROOT;
 	iommu->dma_avail = dma_entry_limit;
 	mutex_init(&iommu->lock);
@@ -1722,6 +1897,9 @@ static void vfio_iommu_type1_release(void *iommu_data)
 		list_del(&domain->next);
 		kfree(domain);
 	}
+
+	vfio_iommu_iova_free(&iommu->iova_list);
+
 	kfree(iommu);
 }
 
-- 
2.17.1


