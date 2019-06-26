Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B872E56D6D
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 17:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfFZPOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 11:14:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:19114 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728430AbfFZPOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 11:14:04 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7C79BCA769915FB85BF2;
        Wed, 26 Jun 2019 23:13:57 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.202.227.237) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 26 Jun 2019 23:13:49 +0800
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
        <pmorel@linux.vnet.ibm.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, <xuwei5@hisilicon.com>,
        <kevin.tian@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v7 6/6] vfio/type1: remove duplicate retrieval of reserved regions
Date:   Wed, 26 Jun 2019 16:12:48 +0100
Message-ID: <20190626151248.11776-7-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.237]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we now already have the reserved regions list, just pass that into
vfio_iommu_has_sw_msi() fn.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 450081802dcd..43b1e68ebce9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1308,15 +1308,13 @@ static struct vfio_group *find_iommu_group(struct vfio_domain *domain,
 	return NULL;
 }
 
-static bool vfio_iommu_has_sw_msi(struct iommu_group *group, phys_addr_t *base)
+static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
+				  phys_addr_t *base)
 {
-	struct list_head group_resv_regions;
-	struct iommu_resv_region *region, *next;
+	struct iommu_resv_region *region;
 	bool ret = false;
 
-	INIT_LIST_HEAD(&group_resv_regions);
-	iommu_get_group_resv_regions(group, &group_resv_regions);
-	list_for_each_entry(region, &group_resv_regions, list) {
+	list_for_each_entry(region, group_resv_regions, list) {
 		/*
 		 * The presence of any 'real' MSI regions should take
 		 * precedence over the software-managed one if the
@@ -1332,8 +1330,7 @@ static bool vfio_iommu_has_sw_msi(struct iommu_group *group, phys_addr_t *base)
 			ret = true;
 		}
 	}
-	list_for_each_entry_safe(region, next, &group_resv_regions, list)
-		kfree(region);
+
 	return ret;
 }
 
@@ -1774,7 +1771,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (ret)
 		goto out_detach;
 
-	resv_msi = vfio_iommu_has_sw_msi(iommu_group, &resv_msi_base);
+	resv_msi = vfio_iommu_has_sw_msi(&group_resv_regions, &resv_msi_base);
 
 	INIT_LIST_HEAD(&domain->group_list);
 	list_add(&group->next, &domain->group_list);
-- 
2.17.1


