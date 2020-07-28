Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AF52302B3
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgG1GWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:22:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:26364 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgG1GU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:20:58 -0400
IronPort-SDR: //r0q/NllgPyW0ORSMJacjD+w4fmOLryXjRSRS0WxYYsmSwuqQbTrt7N5JQQ1cPLYLvvbuFWiO
 FGZUn6cf5Peg==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="212681240"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="212681240"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:20:55 -0700
IronPort-SDR: nuQnlEfIrF2AQiWfbCcHy4kaJYmq05uSpqDunSLT+Hyq0ncxNSQxbsdWvGMJcHoW3xzx18f/n/
 cj3L587aEu1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="320274395"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 27 Jul 2020 23:20:55 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 05/15] vfio: Add PASID allocation/free support
Date:   Mon, 27 Jul 2020 23:27:34 -0700
Message-Id: <1595917664-33276-6-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shared Virtual Addressing (a.k.a Shared Virtual Memory) allows sharing
multiple process virtual address spaces with the device for simplified
programming model. PASID is used to tag an virtual address space in DMA
requests and to identify the related translation structure in IOMMU. When
a PASID-capable device is assigned to a VM, we want the same capability
of using PASID to tag guest process virtual address spaces to achieve
virtual SVA (vSVA).

PASID management for guest is vendor specific. Some vendors (e.g. Intel
VT-d) requires system-wide managed PASIDs across all devices, regardless
of whether a device is used by host or assigned to guest. Other vendors
(e.g. ARM SMMU) may allow PASIDs managed per-device thus could be fully
delegated to the guest for assigned devices.

For system-wide managed PASIDs, this patch introduces a vfio module to
handle explicit PASID alloc/free requests from guest. Allocated PASIDs
are associated to a process (or, mm_struct) in IOASID core. A vfio_mm
object is introduced to track mm_struct. Multiple VFIO containers within
a process share the same vfio_mm object.

A quota mechanism is provided to prevent malicious user from exhausting
available PASIDs. Currently the quota is a global parameter applied to
all VFIO devices. In the future per-device quota might be supported too.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
v5 -> v6:
*) address comments from Eric. Add vfio_unlink_pasid() to be consistent
   with vfio_unlink_dma(). Add a comment in vfio_pasid_exit().

v4 -> v5:
*) address comments from Eric Auger.
*) address the comments from Alex on the pasid free range support. Added
   per vfio_mm pasid r-b tree.
   https://lore.kernel.org/kvm/20200709082751.320742ab@x1.home/

v3 -> v4:
*) fix lock leam in vfio_mm_get_from_task()
*) drop pasid_quota field in struct vfio_mm
*) vfio_mm_get_from_task() returns ERR_PTR(-ENOTTY) when !CONFIG_VFIO_PASID

v1 -> v2:
*) added in v2, split from the pasid alloc/free support of v1
---
 drivers/vfio/Kconfig      |   5 +
 drivers/vfio/Makefile     |   1 +
 drivers/vfio/vfio_pasid.c | 248 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h      |  28 ++++++
 4 files changed, 282 insertions(+)
 create mode 100644 drivers/vfio/vfio_pasid.c

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index fd17db9..3d8a108 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -19,6 +19,11 @@ config VFIO_VIRQFD
 	depends on VFIO && EVENTFD
 	default n
 
+config VFIO_PASID
+	tristate
+	depends on IOASID && VFIO
+	default n
+
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index de67c47..bb836a3 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -3,6 +3,7 @@ vfio_virqfd-y := virqfd.o
 
 obj-$(CONFIG_VFIO) += vfio.o
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
+obj-$(CONFIG_VFIO_PASID) += vfio_pasid.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
 obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
new file mode 100644
index 0000000..befcf29
--- /dev/null
+++ b/drivers/vfio/vfio_pasid.c
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ *     Author: Liu Yi L <yi.l.liu@intel.com>
+ *
+ */
+
+#include <linux/vfio.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/sched/mm.h>
+
+#define DRIVER_VERSION  "0.1"
+#define DRIVER_AUTHOR   "Liu Yi L <yi.l.liu@intel.com>"
+#define DRIVER_DESC     "PASID management for VFIO bus drivers"
+
+#define VFIO_DEFAULT_PASID_QUOTA	1000
+static int pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
+module_param_named(pasid_quota, pasid_quota, uint, 0444);
+MODULE_PARM_DESC(pasid_quota,
+		 "Set the quota for max number of PASIDs that an application is allowed to request (default 1000)");
+
+struct vfio_mm_token {
+	unsigned long long val;
+};
+
+struct vfio_mm {
+	struct kref		kref;
+	int			ioasid_sid;
+	struct mutex		pasid_lock;
+	struct rb_root		pasid_list;
+	struct list_head	next;
+	struct vfio_mm_token	token;
+};
+
+static struct mutex		vfio_mm_lock;
+static struct list_head		vfio_mm_list;
+
+struct vfio_pasid {
+	struct rb_node		node;
+	ioasid_t		pasid;
+};
+
+static void vfio_remove_all_pasids(struct vfio_mm *vmm);
+
+/* called with vfio.vfio_mm_lock held */
+static void vfio_mm_release(struct kref *kref)
+{
+	struct vfio_mm *vmm = container_of(kref, struct vfio_mm, kref);
+
+	list_del(&vmm->next);
+	mutex_unlock(&vfio_mm_lock);
+	vfio_remove_all_pasids(vmm);
+	ioasid_free_set(vmm->ioasid_sid, true);
+	kfree(vmm);
+}
+
+void vfio_mm_put(struct vfio_mm *vmm)
+{
+	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_mm_lock);
+}
+
+static void vfio_mm_get(struct vfio_mm *vmm)
+{
+	kref_get(&vmm->kref);
+}
+
+struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
+{
+	struct mm_struct *mm = get_task_mm(task);
+	struct vfio_mm *vmm;
+	unsigned long long val = (unsigned long long)mm;
+	int ret;
+
+	mutex_lock(&vfio_mm_lock);
+	/* Search existing vfio_mm with current mm pointer */
+	list_for_each_entry(vmm, &vfio_mm_list, next) {
+		if (vmm->token.val == val) {
+			vfio_mm_get(vmm);
+			goto out;
+		}
+	}
+
+	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
+	if (!vmm) {
+		vmm = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	/*
+	 * IOASID core provides a 'IOASID set' concept to track all
+	 * PASIDs associated with a token. Here we use mm_struct as
+	 * the token and create a IOASID set per mm_struct. All the
+	 * containers of the process share the same IOASID set.
+	 */
+	ret = ioasid_alloc_set((struct ioasid_set *)mm, pasid_quota,
+			       &vmm->ioasid_sid);
+	if (ret) {
+		kfree(vmm);
+		vmm = ERR_PTR(ret);
+		goto out;
+	}
+
+	kref_init(&vmm->kref);
+	vmm->token.val = val;
+	mutex_init(&vmm->pasid_lock);
+	vmm->pasid_list = RB_ROOT;
+
+	list_add(&vmm->next, &vfio_mm_list);
+out:
+	mutex_unlock(&vfio_mm_lock);
+	mmput(mm);
+	return vmm;
+}
+
+/*
+ * Find PASID within @min and @max
+ */
+static struct vfio_pasid *vfio_find_pasid(struct vfio_mm *vmm,
+					  ioasid_t min, ioasid_t max)
+{
+	struct rb_node *node = vmm->pasid_list.rb_node;
+
+	while (node) {
+		struct vfio_pasid *vid = rb_entry(node,
+						struct vfio_pasid, node);
+
+		if (max < vid->pasid)
+			node = node->rb_left;
+		else if (min > vid->pasid)
+			node = node->rb_right;
+		else
+			return vid;
+	}
+
+	return NULL;
+}
+
+static void vfio_link_pasid(struct vfio_mm *vmm, struct vfio_pasid *new)
+{
+	struct rb_node **link = &vmm->pasid_list.rb_node, *parent = NULL;
+	struct vfio_pasid *vid;
+
+	while (*link) {
+		parent = *link;
+		vid = rb_entry(parent, struct vfio_pasid, node);
+
+		if (new->pasid <= vid->pasid)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+
+	rb_link_node(&new->node, parent, link);
+	rb_insert_color(&new->node, &vmm->pasid_list);
+}
+
+static void vfio_unlink_pasid(struct vfio_mm *vmm, struct vfio_pasid *old)
+{
+	rb_erase(&old->node, &vmm->pasid_list);
+}
+
+static void vfio_remove_pasid(struct vfio_mm *vmm, struct vfio_pasid *vid)
+{
+	vfio_unlink_pasid(vmm, vid);
+	ioasid_free(vid->pasid);
+	kfree(vid);
+}
+
+static void vfio_remove_all_pasids(struct vfio_mm *vmm)
+{
+	struct rb_node *node;
+
+	mutex_lock(&vmm->pasid_lock);
+	while ((node = rb_first(&vmm->pasid_list)))
+		vfio_remove_pasid(vmm, rb_entry(node, struct vfio_pasid, node));
+	mutex_unlock(&vmm->pasid_lock);
+}
+
+int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
+{
+	ioasid_t pasid;
+	struct vfio_pasid *vid;
+
+	pasid = ioasid_alloc(vmm->ioasid_sid, min, max, NULL);
+	if (pasid == INVALID_IOASID)
+		return -ENOSPC;
+
+	vid = kzalloc(sizeof(*vid), GFP_KERNEL);
+	if (!vid) {
+		ioasid_free(pasid);
+		return -ENOMEM;
+	}
+
+	vid->pasid = pasid;
+
+	mutex_lock(&vmm->pasid_lock);
+	vfio_link_pasid(vmm, vid);
+	mutex_unlock(&vmm->pasid_lock);
+
+	return pasid;
+}
+
+void vfio_pasid_free_range(struct vfio_mm *vmm,
+			   ioasid_t min, ioasid_t max)
+{
+	struct vfio_pasid *vid = NULL;
+
+	/*
+	 * IOASID core will notify PASID users (e.g. IOMMU driver) to
+	 * teardown necessary structures depending on the to-be-freed
+	 * PASID.
+	 */
+	mutex_lock(&vmm->pasid_lock);
+	while ((vid = vfio_find_pasid(vmm, min, max)) != NULL)
+		vfio_remove_pasid(vmm, vid);
+	mutex_unlock(&vmm->pasid_lock);
+}
+
+static int __init vfio_pasid_init(void)
+{
+	mutex_init(&vfio_mm_lock);
+	INIT_LIST_HEAD(&vfio_mm_list);
+	return 0;
+}
+
+static void __exit vfio_pasid_exit(void)
+{
+	/*
+	 * VFIO_PASID is supposed to be referenced by VFIO_IOMMU_TYPE1
+	 * and may be other module. once vfio_pasid_exit() is triggered,
+	 * that means its user (e.g. VFIO_IOMMU_TYPE1) has been removed.
+	 * All the vfio_mm instances should have been released. If not,
+	 * means there is vfio_mm leak, should be a bug of user module.
+	 * So just warn here.
+	 */
+	WARN_ON(!list_empty(&vfio_mm_list));
+}
+
+module_init(vfio_pasid_init);
+module_exit(vfio_pasid_exit);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 38d3c6a..31472a9 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -97,6 +97,34 @@ extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
 extern void vfio_unregister_iommu_driver(
 				const struct vfio_iommu_driver_ops *ops);
 
+struct vfio_mm;
+#if IS_ENABLED(CONFIG_VFIO_PASID)
+extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task);
+extern void vfio_mm_put(struct vfio_mm *vmm);
+extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
+extern void vfio_pasid_free_range(struct vfio_mm *vmm,
+				  ioasid_t min, ioasid_t max);
+#else
+static inline struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
+{
+	return ERR_PTR(-ENOTTY);
+}
+
+static inline void vfio_mm_put(struct vfio_mm *vmm)
+{
+}
+
+static inline int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
+{
+	return -ENOTTY;
+}
+
+static inline void vfio_pasid_free_range(struct vfio_mm *vmm,
+					  ioasid_t min, ioasid_t max)
+{
+}
+#endif /* CONFIG_VFIO_PASID */
+
 /*
  * External user API
  */
-- 
2.7.4

