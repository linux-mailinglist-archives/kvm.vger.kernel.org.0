Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E127714CA46
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgA2MGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:06:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:59025 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgA2MGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:06:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:06:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="222433142"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 29 Jan 2020 04:06:38 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        joro@8bytes.org, ashok.raj@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v3 3/8] vfio: Reclaim PASIDs when application is down
Date:   Wed, 29 Jan 2020 04:11:47 -0800
Message-Id: <1580299912-86084-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

When userspace application is down, kernel should reclaim the PASIDs
allocated for this application to avoid PASID leak. This patch adds
a PASID list in vfio_mm structure to track the allocated PASIDs. The
PASID reclaim will be triggered when last vfio container is released.

Previous discussions:
https://patchwork.kernel.org/patch/11209429/

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.c  | 61 +++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/vfio.h |  6 ++++++
 2 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c43c757..425d60a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2148,15 +2148,31 @@ static struct vfio_mm *vfio_create_mm(struct mm_struct *mm)
 	vmm->pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
 	vmm->pasid_count = 0;
 	mutex_init(&vmm->pasid_lock);
+	INIT_LIST_HEAD(&vmm->pasid_list);
 
 	list_add(&vmm->vfio_next, &vfio.vfio_mm_list);
 
 	return vmm;
 }
 
+static void vfio_mm_reclaim_pasid(struct vfio_mm *vmm)
+{
+	struct pasid_node *pnode, *tmp;
+
+	mutex_lock(&vmm->pasid_lock);
+	list_for_each_entry_safe(pnode, tmp, &vmm->pasid_list, next) {
+		pr_info("%s, reclaim pasid: %u\n", __func__, pnode->pasid);
+		list_del(&pnode->next);
+		ioasid_free(pnode->pasid);
+		kfree(pnode);
+	}
+	mutex_unlock(&vmm->pasid_lock);
+}
+
 static void vfio_mm_unlock_and_free(struct vfio_mm *vmm)
 {
 	mutex_unlock(&vfio.vfio_mm_lock);
+	vfio_mm_reclaim_pasid(vmm);
 	kfree(vmm);
 }
 
@@ -2204,6 +2220,39 @@ struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
 
+/**
+ * Caller should hold vmm->pasid_lock
+ */
+static int vfio_mm_insert_pasid_node(struct vfio_mm *vmm, u32 pasid)
+{
+	struct pasid_node *pnode;
+
+	pnode = kzalloc(sizeof(*pnode), GFP_KERNEL);
+	if (!pnode)
+		return -ENOMEM;
+	pnode->pasid = pasid;
+	list_add(&pnode->next, &vmm->pasid_list);
+
+	return 0;
+}
+
+/**
+ * Caller should hold vmm->pasid_lock
+ */
+static void vfio_mm_remove_pasid_node(struct vfio_mm *vmm, u32 pasid)
+{
+	struct pasid_node *pnode, *tmp;
+
+	list_for_each_entry_safe(pnode, tmp, &vmm->pasid_list, next) {
+		if (pnode->pasid == pasid) {
+			list_del(&pnode->next);
+			kfree(pnode);
+			break;
+		}
+	}
+
+}
+
 int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max)
 {
 	ioasid_t pasid;
@@ -2221,9 +2270,15 @@ int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max)
 		ret = -ENOSPC;
 		goto out_unlock;
 	}
-	vmm->pasid_count++;
 
-	ret = pasid;
+	if (vfio_mm_insert_pasid_node(vmm, pasid)) {
+		ret = -ENOSPC;
+		ioasid_free(pasid);
+	} else {
+		ret = pasid;
+		vmm->pasid_count++;
+	}
+
 out_unlock:
 	mutex_unlock(&vmm->pasid_lock);
 	return ret;
@@ -2243,7 +2298,7 @@ int vfio_mm_pasid_free(struct vfio_mm *vmm, ioasid_t pasid)
 		goto out_unlock;
 	}
 	ioasid_free(pasid);
-
+	vfio_mm_remove_pasid_node(vmm, pasid);
 	vmm->pasid_count--;
 out_unlock:
 	mutex_unlock(&vmm->pasid_lock);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b6c9c8c..a2ea7e0 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -89,12 +89,18 @@ extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 extern void vfio_unregister_iommu_driver(
 				const struct vfio_iommu_driver_ops *ops);
 
+struct pasid_node {
+	u32			pasid;
+	struct list_head	next;
+};
+
 #define VFIO_DEFAULT_PASID_QUOTA	1000
 struct vfio_mm {
 	struct kref			kref;
 	struct mutex			pasid_lock;
 	int				pasid_quota;
 	int				pasid_count;
+	struct list_head		pasid_list;
 	struct mm_struct		*mm;
 	struct list_head		vfio_next;
 };
-- 
2.7.4

