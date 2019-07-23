Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C22771C83
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 18:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388786AbfGWQIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 12:08:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2740 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388777AbfGWQIg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 12:08:36 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2C1734A5F9A2A176738C;
        Wed, 24 Jul 2019 00:08:34 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.202.227.237) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 00:08:25 +0800
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <alex.williamson@redhat.com>, <eric.auger@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, <xuwei5@hisilicon.com>,
        <kevin.tian@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 3/6] vfio/type1: Update iova list on detach
Date:   Tue, 23 Jul 2019 17:06:34 +0100
Message-ID: <20190723160637.8384-4-shameerali.kolothum.thodi@huawei.com>
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

Get a copy of iova list on _group_detach and try to update the list.
On success replace the current one with the copy. Leave the list as
it is if update fails.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
v7 --> v8
  -Fixed possible invalid holes in iova list if there are no more
   reserved regions in vfio_iommu_resv_refresh().
  -Handled iommu_get_group_resv_regions() err case in
   vfio_iommu_resv_refresh()
  -Tidy up of iova_copy list fail case.
---
 drivers/vfio/vfio_iommu_type1.c | 94 +++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a3c9794ccf83..7005a8cfca1b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1867,12 +1867,93 @@ static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
 	WARN_ON(iommu->notifier.head);
 }
 
+/*
+ * Called when a domain is removed in detach. It is possible that
+ * the removed domain decided the iova aperture window. Modify the
+ * iova aperture with the smallest window among existing domains.
+ */
+static void vfio_iommu_aper_expand(struct vfio_iommu *iommu,
+				   struct list_head *iova_copy)
+{
+	struct vfio_domain *domain;
+	struct iommu_domain_geometry geo;
+	struct vfio_iova *node;
+	dma_addr_t start = 0;
+	dma_addr_t end = (dma_addr_t)~0;
+
+	if (list_empty(iova_copy))
+		return;
+
+	list_for_each_entry(domain, &iommu->domain_list, next) {
+		iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY,
+				      &geo);
+		if (geo.aperture_start > start)
+			start = geo.aperture_start;
+		if (geo.aperture_end < end)
+			end = geo.aperture_end;
+	}
+
+	/* Modify aperture limits. The new aper is either same or bigger */
+	node = list_first_entry(iova_copy, struct vfio_iova, list);
+	node->start = start;
+	node = list_last_entry(iova_copy, struct vfio_iova, list);
+	node->end = end;
+}
+
+/*
+ * Called when a group is detached. The reserved regions for that
+ * group can be part of valid iova now. But since reserved regions
+ * may be duplicated among groups, populate the iova valid regions
+ * list again.
+ */
+static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
+				   struct list_head *iova_copy)
+{
+	struct vfio_domain *d;
+	struct vfio_group *g;
+	struct vfio_iova *node;
+	dma_addr_t start, end;
+	LIST_HEAD(resv_regions);
+	int ret;
+
+	if (list_empty(iova_copy))
+		return -EINVAL;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		list_for_each_entry(g, &d->group_list, next) {
+			ret = iommu_get_group_resv_regions(g->iommu_group,
+							   &resv_regions);
+			if (ret)
+				goto done;
+		}
+	}
+
+	node = list_first_entry(iova_copy, struct vfio_iova, list);
+	start = node->start;
+	node = list_last_entry(iova_copy, struct vfio_iova, list);
+	end = node->end;
+
+	/* purge the iova list and create new one */
+	vfio_iommu_iova_free(iova_copy);
+
+	ret = vfio_iommu_aper_resize(iova_copy, start, end);
+	if (ret)
+		goto done;
+
+	/* Exclude current reserved regions from iova ranges */
+	ret = vfio_iommu_resv_exclude(iova_copy, &resv_regions);
+done:
+	vfio_iommu_resv_free(&resv_regions);
+	return ret;
+}
+
 static void vfio_iommu_type1_detach_group(void *iommu_data,
 					  struct iommu_group *iommu_group)
 {
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_domain *domain;
 	struct vfio_group *group;
+	LIST_HEAD(iova_copy);
 
 	mutex_lock(&iommu->lock);
 
@@ -1895,6 +1976,13 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		}
 	}
 
+	/*
+	 * Get a copy of iova list. This will be used to update
+	 * and to replace the current one later. Please note that
+	 * we will leave the original list as it is if update fails.
+	 */
+	vfio_iommu_iova_get_copy(iommu, &iova_copy);
+
 	list_for_each_entry(domain, &iommu->domain_list, next) {
 		group = find_iommu_group(domain, iommu_group);
 		if (!group)
@@ -1920,10 +2008,16 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			iommu_domain_free(domain->domain);
 			list_del(&domain->next);
 			kfree(domain);
+			vfio_iommu_aper_expand(iommu, &iova_copy);
 		}
 		break;
 	}
 
+	if (!vfio_iommu_resv_refresh(iommu, &iova_copy))
+		vfio_iommu_iova_insert_copy(iommu, &iova_copy);
+	else
+		vfio_iommu_iova_free(&iova_copy);
+
 detach_group_done:
 	mutex_unlock(&iommu->lock);
 }
-- 
2.17.1


