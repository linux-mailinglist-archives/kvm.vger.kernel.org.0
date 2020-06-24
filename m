Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B54C206F57
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 10:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389065AbgFXItY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 04:49:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:1313 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388758AbgFXItG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 04:49:06 -0400
IronPort-SDR: qIUddvJuuKUSQ4hPOUkAkzGDM7d4kJqj2x4ONeWHRoX4t/5ns23NuBSSydgwpkGQmdUMT5Uits
 YeomXqylye1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="162484872"
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="162484872"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 01:48:56 -0700
IronPort-SDR: 07bEmCiGFRvzyqlaclakKOX8fXkYsNBYeuDamlaPpJpZ0vOq5Qu5BZrPnTb0tgMj2nqsvX6eE0
 6I3yAsYyDUZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,274,1589266800"; 
   d="scan'208";a="275624502"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga003.jf.intel.com with ESMTP; 24 Jun 2020 01:48:55 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/14] vfio: Add PASID allocation/free support
Date:   Wed, 24 Jun 2020 01:55:17 -0700
Message-Id: <1592988927-48009-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
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
VT-d) requires system-wide managed PASIDs cross all devices, regardless
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
v1 -> v2:
*) added in v2, split from the pasid alloc/free support of v1
---
 drivers/vfio/Kconfig      |   5 ++
 drivers/vfio/Makefile     |   1 +
 drivers/vfio/vfio_pasid.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h      |  28 +++++++++
 4 files changed, 185 insertions(+)
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
index 0000000..dd5b6d1
--- /dev/null
+++ b/drivers/vfio/vfio_pasid.c
@@ -0,0 +1,151 @@
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
+		 " Set the quota for max number of PASIDs that an application is allowed to request (default 1000)");
+
+struct vfio_mm_token {
+	unsigned long long val;
+};
+
+struct vfio_mm {
+	struct kref		kref;
+	struct vfio_mm_token	token;
+	int			ioasid_sid;
+	int			pasid_quota;
+	struct list_head	next;
+};
+
+static struct vfio_pasid {
+	struct mutex		vfio_mm_lock;
+	struct list_head	vfio_mm_list;
+} vfio_pasid;
+
+/* called with vfio.vfio_mm_lock held */
+static void vfio_mm_release(struct kref *kref)
+{
+	struct vfio_mm *vmm = container_of(kref, struct vfio_mm, kref);
+
+	list_del(&vmm->next);
+	mutex_unlock(&vfio_pasid.vfio_mm_lock);
+	ioasid_free_set(vmm->ioasid_sid, true);
+	kfree(vmm);
+}
+
+void vfio_mm_put(struct vfio_mm *vmm)
+{
+	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_pasid.vfio_mm_lock);
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
+	unsigned long long val = (unsigned long long) mm;
+	int ret;
+
+	mutex_lock(&vfio_pasid.vfio_mm_lock);
+	/* Search existing vfio_mm with current mm pointer */
+	list_for_each_entry(vmm, &vfio_pasid.vfio_mm_list, next) {
+		if (vmm->token.val == val) {
+			vfio_mm_get(vmm);
+			goto out;
+		}
+	}
+
+	vmm = kzalloc(sizeof(*vmm), GFP_KERNEL);
+	if (!vmm)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * IOASID core provides a 'IOASID set' concept to track all
+	 * PASIDs associated with a token. Here we use mm_struct as
+	 * the token and create a IOASID set per mm_struct. All the
+	 * containers of the process share the same IOASID set.
+	 */
+	ret = ioasid_alloc_set((struct ioasid_set *) mm, pasid_quota,
+			       &vmm->ioasid_sid);
+	if (ret) {
+		kfree(vmm);
+		return ERR_PTR(ret);
+	}
+
+	kref_init(&vmm->kref);
+	vmm->token.val = (unsigned long long) mm;
+	vmm->pasid_quota = pasid_quota;
+
+	list_add(&vmm->next, &vfio_pasid.vfio_mm_list);
+out:
+	mutex_unlock(&vfio_pasid.vfio_mm_lock);
+	mmput(mm);
+	return vmm;
+}
+
+int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max)
+{
+	ioasid_t pasid;
+
+	pasid = ioasid_alloc(vmm->ioasid_sid, min, max, NULL);
+
+	return (pasid == INVALID_IOASID) ? -ENOSPC : pasid;
+}
+
+void vfio_pasid_free_range(struct vfio_mm *vmm,
+			    ioasid_t min, ioasid_t max)
+{
+	ioasid_t pasid = min;
+
+	if (min > max)
+		return;
+
+	/*
+	 * IOASID core will notify PASID users (e.g. IOMMU driver) to
+	 * teardown necessary structures depending on the to-be-freed
+	 * PASID.
+	 */
+	for (; pasid <= max; pasid++)
+		ioasid_free(pasid);
+}
+
+static int __init vfio_pasid_init(void)
+{
+	mutex_init(&vfio_pasid.vfio_mm_lock);
+	INIT_LIST_HEAD(&vfio_pasid.vfio_mm_list);
+	return 0;
+}
+
+static void __exit vfio_pasid_exit(void)
+{
+	WARN_ON(!list_empty(&vfio_pasid.vfio_mm_list));
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
index 38d3c6a..74e077d 100644
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
+					ioasid_t min, ioasid_t max);
+#else
+static inline struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)
+{
+	return NULL;
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

