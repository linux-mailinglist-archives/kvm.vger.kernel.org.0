Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B903763F7
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 12:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhEGKiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 06:38:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:18352 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbhEGKiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 06:38:02 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fc6JH4R8yzCr6t;
        Fri,  7 May 2021 18:34:23 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 18:36:50 +0800
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
Subject: [RFC PATCH v2 1/3] vfio/iommu_type1: Add HWDBM status maintenance
Date:   Fri, 7 May 2021 18:36:06 +0800
Message-ID: <20210507103608.39440-2-zhukeqian1@huawei.com>
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

We are going to optimize dirty log tracking based on iommu dirty
log tracking, but the dirty log from iommu is useful only when
all iommu backed domains support it.

This maintains a counter in vfio_iommu, which is used for dirty
bitmap population in next patch.

This also maintains a boolean flag in vfio_domain, which is used
in the policy of switch dirty log in next patch.

Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a0747c35a778..146aaf95589c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -73,6 +73,7 @@ struct vfio_iommu {
 	unsigned int		vaddr_invalid_count;
 	uint64_t		pgsize_bitmap;
 	uint64_t		num_non_pinned_groups;
+	uint64_t		num_non_hwdbm_domains;
 	wait_queue_head_t	vaddr_wait;
 	bool			v2;
 	bool			nesting;
@@ -86,6 +87,7 @@ struct vfio_domain {
 	struct list_head	group_list;
 	int			prot;		/* IOMMU_CACHE */
 	bool			fgsp;		/* Fine-grained super pages */
+	bool			iommu_hwdbm;	/* Hardware dirty management */
 };
 
 struct vfio_dma {
@@ -2238,6 +2240,26 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
+/*
+ * Called after a new group is added to the iommu_domain, or an old group is
+ * removed from the iommu_domain. Update the HWDBM status of vfio_domain and
+ * vfio_iommu.
+ */
+static void vfio_iommu_update_hwdbm(struct vfio_iommu *iommu,
+				    struct vfio_domain *domain,
+				    bool attach)
+{
+	bool old_hwdbm = domain->iommu_hwdbm;
+	bool new_hwdbm = iommu_support_dirty_log(domain->domain);
+
+	if (old_hwdbm && !new_hwdbm && attach) {
+		iommu->num_non_hwdbm_domains++;
+	} else if (!old_hwdbm && new_hwdbm && !attach) {
+		iommu->num_non_hwdbm_domains--;
+	}
+	domain->iommu_hwdbm = new_hwdbm;
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
@@ -2391,6 +2413,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			vfio_iommu_detach_group(domain, group);
 			if (!vfio_iommu_attach_group(d, group)) {
 				list_add(&group->next, &d->group_list);
+				vfio_iommu_update_hwdbm(iommu, d, true);
 				iommu_domain_free(domain->domain);
 				kfree(domain);
 				goto done;
@@ -2417,6 +2440,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	list_add(&domain->next, &iommu->domain_list);
 	vfio_update_pgsize_bitmap(iommu);
+	vfio_iommu_update_hwdbm(iommu, domain, true);
 done:
 	/* Delete the old one and insert new iova list */
 	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
@@ -2599,6 +2623,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			continue;
 
 		vfio_iommu_detach_group(domain, group);
+		vfio_iommu_update_hwdbm(iommu, domain, false);
 		update_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
 		kfree(group);
-- 
2.19.1

