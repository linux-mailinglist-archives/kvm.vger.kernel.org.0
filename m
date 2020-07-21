Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAF422849B
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgGUQDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:03:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:5400 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbgGUQDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:03:18 -0400
IronPort-SDR: Wc6WvrtmpIkOSEQGxccs/wBUF4miaxIeLrvFXi1mgRITQk7D7vNEqDli02Zpd7sgcorTj7tDUJ
 zqvNZE2sLCZQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="138252542"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="138252542"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:03:16 -0700
IronPort-SDR: Hbgsla0mX8zT2rK5MfR86ylyfD4Ju/rPWb69Nt9MQu6SwF/rW20dS0DGIQMxBh4tbkY4OweNLO
 04fFwpM+jyuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="327914017"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga007.jf.intel.com with ESMTP; 21 Jul 2020 09:03:14 -0700
Subject: [PATCH RFC v2 09/18] dmaengine: idxd: add basic mdev registration
 and helper functions
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, jgg@mellanox.com,
        rafael@kernel.org, dave.hansen@intel.com, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Jul 2020 09:03:14 -0700
Message-ID: <159534739457.28840.11000033925088538164.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a mediated device through the VFIO mediated device framework. The
mdev framework allows creation of an mediated device by the driver with
portion of the device's resources. The driver will emulate the slow path
such as the PCI config space, MMIO bar, and the command registers. The
descriptor submission portal(s) will be mmaped to the guest in order to
submit descriptors directly by the guest kernel or apps. The mediated
device support code in the idxd will be referred to as the Virtual
Device Composition Module (vdcm). Add basic plumbing to fill out the
mdev_parent_ops struct that VFIO mdev requires to support a mediated
device.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/dma/Kconfig       |    6 
 drivers/dma/idxd/Makefile |    4 
 drivers/dma/idxd/idxd.h   |   11 +
 drivers/dma/idxd/ims.c    |   13 +
 drivers/dma/idxd/ims.h    |   10 
 drivers/dma/idxd/init.c   |   11 +
 drivers/dma/idxd/mdev.c   |  980 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/mdev.h   |  118 +++++
 drivers/dma/idxd/vdev.c   |   76 +++
 drivers/dma/idxd/vdev.h   |   19 +
 10 files changed, 1247 insertions(+), 1 deletion(-)
 create mode 100644 drivers/dma/idxd/ims.h
 create mode 100644 drivers/dma/idxd/mdev.c
 create mode 100644 drivers/dma/idxd/mdev.h
 create mode 100644 drivers/dma/idxd/vdev.c
 create mode 100644 drivers/dma/idxd/vdev.h

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 6a908785a5f7..69c1ae72df86 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -306,6 +306,12 @@ config INTEL_IDXD_SVM
 	depends on PCI_PASID
 	depends on PCI_IOV
 
+config INTEL_IDXD_MDEV
+	bool "IDXD VFIO Mediated Device Support"
+	depends on INTEL_IDXD
+	depends on VFIO_MDEV
+	depends on VFIO_MDEV_DEVICE
+
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
 	depends on PCI && X86_64
diff --git a/drivers/dma/idxd/Makefile b/drivers/dma/idxd/Makefile
index d1519b9d1dd0..18622f81eb3f 100644
--- a/drivers/dma/idxd/Makefile
+++ b/drivers/dma/idxd/Makefile
@@ -1,2 +1,4 @@
 obj-$(CONFIG_INTEL_IDXD) += idxd.o
-idxd-y := init.o irq.o device.o sysfs.o submit.o dma.o cdev.o ims.o
+idxd-y := init.o irq.o device.o sysfs.o submit.o dma.o cdev.o
+
+idxd-$(CONFIG_INTEL_IDXD_MDEV) += ims.o mdev.o vdev.o
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 438d6478a3f8..9588872cd273 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -121,6 +121,7 @@ struct idxd_wq {
 	struct sbitmap_queue sbq;
 	struct dma_chan dma_chan;
 	char name[WQ_NAME_SIZE + 1];
+	struct list_head vdcm_list;
 };
 
 struct idxd_engine {
@@ -153,6 +154,7 @@ enum idxd_device_flag {
 	IDXD_FLAG_CMD_RUNNING,
 	IDXD_FLAG_PASID_ENABLED,
 	IDXD_FLAG_SIOV_SUPPORTED,
+	IDXD_FLAG_MDEV_ENABLED,
 };
 
 struct idxd_device {
@@ -245,6 +247,11 @@ static inline bool device_pasid_enabled(struct idxd_device *idxd)
 	return test_bit(IDXD_FLAG_PASID_ENABLED, &idxd->flags);
 }
 
+static inline bool device_mdev_enabled(struct idxd_device *idxd)
+{
+	return test_bit(IDXD_FLAG_MDEV_ENABLED, &idxd->flags);
+}
+
 enum idxd_portal_prot {
 	IDXD_PORTAL_UNLIMITED = 0,
 	IDXD_PORTAL_LIMITED,
@@ -363,4 +370,8 @@ int idxd_cdev_get_major(struct idxd_device *idxd);
 int idxd_wq_add_cdev(struct idxd_wq *wq);
 void idxd_wq_del_cdev(struct idxd_wq *wq);
 
+/* mdev */
+int idxd_mdev_host_init(struct idxd_device *idxd);
+void idxd_mdev_host_release(struct idxd_device *idxd);
+
 #endif
diff --git a/drivers/dma/idxd/ims.c b/drivers/dma/idxd/ims.c
index 5fece66122a2..bffc74c2b305 100644
--- a/drivers/dma/idxd/ims.c
+++ b/drivers/dma/idxd/ims.c
@@ -10,6 +10,19 @@
 #include <uapi/linux/idxd.h>
 #include "registers.h"
 #include "idxd.h"
+#include "mdev.h"
+
+int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
+{
+	/* PLACEHOLDER */
+	return 0;
+}
+
+int vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
+{
+	/* PLACEHOLDER */
+	return 0;
+}
 
 static void idxd_free_ims_index(struct idxd_device *idxd,
 				unsigned long ims_idx)
diff --git a/drivers/dma/idxd/ims.h b/drivers/dma/idxd/ims.h
new file mode 100644
index 000000000000..3d823606e3a3
--- /dev/null
+++ b/drivers/dma/idxd/ims.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
+
+#ifndef _IDXD_IMS_H_
+#define _IDXD_IMS_H_
+
+int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd);
+int vidxd_free_ims_entries(struct vdcm_idxd *vidxd);
+
+#endif
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 3e2c7ac83daf..639ca74ae1f8 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -211,6 +211,7 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 		wq->idxd = idxd;
 		mutex_init(&wq->wq_lock);
 		wq->idxd_cdev.minor = -1;
+		INIT_LIST_HEAD(&wq->vdcm_list);
 	}
 
 	for (i = 0; i < idxd->max_engines; i++) {
@@ -507,6 +508,14 @@ static int idxd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
+	if (IS_ENABLED(CONFIG_INTEL_IDXD_MDEV)) {
+		rc = idxd_mdev_host_init(idxd);
+		if (rc < 0)
+			dev_warn(dev, "VFIO mdev not setup: %d\n", rc);
+		else
+			set_bit(IDXD_FLAG_MDEV_ENABLED, &idxd->flags);
+	}
+
 	rc = idxd_setup_sysfs(idxd);
 	if (rc) {
 		dev_err(dev, "IDXD sysfs setup failed\n");
@@ -581,6 +590,8 @@ static void idxd_remove(struct pci_dev *pdev)
 	dev_dbg(&pdev->dev, "%s called\n", __func__);
 	idxd_cleanup_sysfs(idxd);
 	idxd_shutdown(pdev);
+	if (IS_ENABLED(CONFIG_INTEL_IDXD_MDEV) && device_mdev_enabled(idxd))
+		idxd_mdev_host_release(idxd);
 	if (device_pasid_enabled(idxd))
 		idxd_disable_system_pasid(idxd);
 	mutex_lock(&idxd_idr_lock);
diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
new file mode 100644
index 000000000000..f9cc2909b1cf
--- /dev/null
+++ b/drivers/dma/idxd/mdev.c
@@ -0,0 +1,980 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/sched/task.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/mm.h>
+#include <linux/mmu_context.h>
+#include <linux/vfio.h>
+#include <linux/mdev.h>
+#include <linux/msi.h>
+#include <linux/intel-iommu.h>
+#include <linux/intel-svm.h>
+#include <linux/kvm_host.h>
+#include <linux/eventfd.h>
+#include <linux/circ_buf.h>
+#include <uapi/linux/idxd.h>
+#include "registers.h"
+#include "idxd.h"
+#include "../../vfio/pci/vfio_pci_private.h"
+#include "mdev.h"
+#include "vdev.h"
+#include "ims.h"
+
+static u64 idxd_pci_config[] = {
+	0x001000000b258086ULL,
+	0x0080000008800000ULL,
+	0x000000000000000cULL,
+	0x000000000000000cULL,
+	0x0000000000000000ULL,
+	0x2010808600000000ULL,
+	0x0000004000000000ULL,
+	0x000000ff00000000ULL,
+	0x0000060000015011ULL, /* MSI-X capability, hardcoded 2 entries, Encoded as N-1 */
+	0x0000070000000000ULL,
+	0x0000000000920010ULL, /* PCIe capability */
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+	0x0000000000000000ULL,
+};
+
+static inline void reset_vconfig(struct vdcm_idxd *vidxd)
+{
+	memset(vidxd->cfg, 0, VIDXD_MAX_CFG_SPACE_SZ);
+	memcpy(vidxd->cfg, idxd_pci_config, sizeof(idxd_pci_config));
+}
+
+static inline void reset_vmmio(struct vdcm_idxd *vidxd)
+{
+	memset(&vidxd->bar0, 0, VIDXD_MAX_MMIO_SPACE_SZ);
+}
+
+static void idxd_vdcm_init(struct vdcm_idxd *vidxd)
+{
+	struct idxd_wq *wq = vidxd->wq;
+
+	reset_vconfig(vidxd);
+	reset_vmmio(vidxd);
+
+	vidxd->bar_size[0] = VIDXD_BAR0_SIZE;
+	vidxd->bar_size[1] = VIDXD_BAR2_SIZE;
+
+	vidxd_mmio_init(vidxd);
+
+	if (wq_dedicated(wq) && wq->state == IDXD_WQ_ENABLED)
+		idxd_wq_disable(wq);
+}
+
+static void __idxd_vdcm_release(struct vdcm_idxd *vidxd)
+{
+	int rc;
+	struct device *dev = &vidxd->idxd->pdev->dev;
+
+	mutex_lock(&vidxd->dev_lock);
+	if (atomic_cmpxchg(&vidxd->vdev.released, 0, 1)) {
+		mutex_unlock(&vidxd->dev_lock);
+		return;
+	}
+
+	rc = vfio_unregister_notifier(mdev_dev(vidxd->vdev.mdev),
+				      VFIO_GROUP_NOTIFY,
+				      &vidxd->vdev.group_notifier);
+	if (rc < 0)
+		dev_warn(dev, "vfio_unregister_notifier group failed: %d\n", rc);
+
+	vidxd_free_ims_entries(vidxd);
+	/* Re-initialize the VIDXD to a pristine state for re-use */
+	idxd_vdcm_init(vidxd);
+	mutex_unlock(&vidxd->dev_lock);
+}
+
+static void idxd_vdcm_release(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "vdcm_idxd_release %d\n", vidxd->type->type);
+	__idxd_vdcm_release(vidxd);
+}
+
+static void idxd_vdcm_release_work(struct work_struct *work)
+{
+	struct vdcm_idxd *vidxd = container_of(work, struct vdcm_idxd,
+					       vdev.release_work);
+
+	__idxd_vdcm_release(vidxd);
+}
+
+static struct vdcm_idxd *vdcm_vidxd_create(struct idxd_device *idxd, struct mdev_device *mdev,
+					   struct vdcm_idxd_type *type)
+{
+	struct vdcm_idxd *vidxd;
+	struct idxd_wq *wq = NULL;
+	int i;
+
+	/* PLACEHOLDER, wq matching comes later */
+
+	if (!wq)
+		return ERR_PTR(-ENODEV);
+
+	vidxd = kzalloc(sizeof(*vidxd), GFP_KERNEL);
+	if (!vidxd)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&vidxd->dev_lock);
+	vidxd->idxd = idxd;
+	vidxd->vdev.mdev = mdev;
+	vidxd->wq = wq;
+	mdev_set_drvdata(mdev, vidxd);
+	vidxd->type = type;
+	vidxd->num_wqs = VIDXD_MAX_WQS;
+
+	for (i = 0; i < VIDXD_MAX_MSIX_VECS - 1; i++)
+		vidxd->ims_index[i] = -1;
+
+	INIT_WORK(&vidxd->vdev.release_work, idxd_vdcm_release_work);
+	idxd_vdcm_init(vidxd);
+	mutex_lock(&wq->wq_lock);
+	idxd_wq_get(wq);
+	mutex_unlock(&wq->wq_lock);
+
+	return vidxd;
+}
+
+static struct vdcm_idxd_type idxd_mdev_types[IDXD_MDEV_TYPES];
+
+static struct vdcm_idxd_type *idxd_vdcm_find_vidxd_type(struct device *dev,
+							const char *name)
+{
+	int i;
+	char dev_name[IDXD_MDEV_NAME_LEN];
+
+	for (i = 0; i < IDXD_MDEV_TYPES; i++) {
+		snprintf(dev_name, IDXD_MDEV_NAME_LEN, "idxd-%s",
+			 idxd_mdev_types[i].name);
+
+		if (!strncmp(name, dev_name, IDXD_MDEV_NAME_LEN))
+			return &idxd_mdev_types[i];
+	}
+
+	return NULL;
+}
+
+static int idxd_vdcm_create(struct kobject *kobj, struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd;
+	struct vdcm_idxd_type *type;
+	struct device *dev, *parent;
+	struct idxd_device *idxd;
+	struct idxd_wq *wq;
+
+	parent = mdev_parent_dev(mdev);
+	idxd = dev_get_drvdata(parent);
+	dev = mdev_dev(mdev);
+
+	mdev_set_iommu_device(dev, parent);
+	type = idxd_vdcm_find_vidxd_type(dev, kobject_name(kobj));
+	if (!type) {
+		dev_err(dev, "failed to find type %s to create\n",
+			kobject_name(kobj));
+		return -EINVAL;
+	}
+
+	vidxd = vdcm_vidxd_create(idxd, mdev, type);
+	if (IS_ERR(vidxd)) {
+		dev_err(dev, "failed to create vidxd: %ld\n", PTR_ERR(vidxd));
+		return PTR_ERR(vidxd);
+	}
+
+	wq = vidxd->wq;
+	mutex_lock(&wq->wq_lock);
+	list_add(&vidxd->list, &wq->vdcm_list);
+	mutex_unlock(&wq->wq_lock);
+	dev_dbg(dev, "mdev creation success: %s\n", dev_name(mdev_dev(mdev)));
+
+	return 0;
+}
+
+static int idxd_vdcm_remove(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct idxd_device *idxd = vidxd->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	struct idxd_wq *wq = vidxd->wq;
+
+	dev_dbg(dev, "%s: removing for wq %d\n", __func__, vidxd->wq->id);
+
+	mutex_lock(&wq->wq_lock);
+	list_del(&vidxd->list);
+	idxd_wq_put(wq);
+	mutex_unlock(&wq->wq_lock);
+
+	kfree(vidxd);
+	return 0;
+}
+
+static int idxd_vdcm_group_notifier(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	struct vdcm_idxd *vidxd = container_of(nb, struct vdcm_idxd,
+			vdev.group_notifier);
+
+	/* The only action we care about */
+	if (action == VFIO_GROUP_NOTIFY_SET_KVM)
+		if (!data)
+			schedule_work(&vidxd->vdev.release_work);
+
+	return NOTIFY_OK;
+}
+
+static int idxd_vdcm_open(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	unsigned long events;
+	int rc;
+	struct vdcm_idxd_type *type = vidxd->type;
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "%s: type: %d\n", __func__, type->type);
+
+	mutex_lock(&vidxd->dev_lock);
+	vidxd->vdev.group_notifier.notifier_call = idxd_vdcm_group_notifier;
+	events = VFIO_GROUP_NOTIFY_SET_KVM;
+	rc = vfio_register_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY, &events,
+				    &vidxd->vdev.group_notifier);
+	if (rc < 0) {
+		mutex_unlock(&vidxd->dev_lock);
+		dev_err(dev, "vfio_register_notifier for group failed: %d\n", rc);
+		return rc;
+	}
+
+	/* allocate and setup IMS entries */
+	rc = vidxd_setup_ims_entries(vidxd);
+	if (rc < 0)
+		goto undo_group;
+
+	atomic_set(&vidxd->vdev.released, 0);
+	mutex_unlock(&vidxd->dev_lock);
+
+	return rc;
+
+ undo_group:
+	mutex_unlock(&vidxd->dev_lock);
+	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY, &vidxd->vdev.group_notifier);
+	return rc;
+}
+
+static ssize_t idxd_vdcm_rw(struct mdev_device *mdev, char *buf, size_t count, loff_t *ppos,
+			    enum idxd_vdcm_rw mode)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	struct device *dev = mdev_dev(mdev);
+	int rc = -EINVAL;
+
+	if (index >= VFIO_PCI_NUM_REGIONS) {
+		dev_err(dev, "invalid index: %u\n", index);
+		return -EINVAL;
+	}
+
+	switch (index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+		if (mode == IDXD_VDCM_WRITE)
+			rc = vidxd_cfg_write(vidxd, pos, buf, count);
+		else
+			rc = vidxd_cfg_read(vidxd, pos, buf, count);
+		break;
+	case VFIO_PCI_BAR0_REGION_INDEX:
+	case VFIO_PCI_BAR1_REGION_INDEX:
+		if (mode == IDXD_VDCM_WRITE)
+			rc = vidxd_mmio_write(vidxd, vidxd->bar_val[0] + pos, buf, count);
+		else
+			rc = vidxd_mmio_read(vidxd, vidxd->bar_val[0] + pos, buf, count);
+		break;
+	case VFIO_PCI_BAR2_REGION_INDEX:
+	case VFIO_PCI_BAR3_REGION_INDEX:
+	case VFIO_PCI_BAR4_REGION_INDEX:
+	case VFIO_PCI_BAR5_REGION_INDEX:
+	case VFIO_PCI_VGA_REGION_INDEX:
+	case VFIO_PCI_ROM_REGION_INDEX:
+	default:
+		dev_err(dev, "unsupported region: %u\n", index);
+	}
+
+	return rc == 0 ? count : rc;
+}
+
+static ssize_t idxd_vdcm_read(struct mdev_device *mdev, char __user *buf, size_t count,
+			      loff_t *ppos)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	unsigned int done = 0;
+	int rc;
+
+	mutex_lock(&vidxd->dev_lock);
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(*ppos % 4)) {
+			u32 val;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val, sizeof(val),
+					  ppos, IDXD_VDCM_READ);
+			if (rc <= 0)
+				goto read_err;
+
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+
+			filled = 4;
+		} else if (count >= 2 && !(*ppos % 2)) {
+			u16 val;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val, sizeof(val),
+					  ppos, IDXD_VDCM_READ);
+			if (rc <= 0)
+				goto read_err;
+
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			rc = idxd_vdcm_rw(mdev, &val, sizeof(val), ppos,
+					  IDXD_VDCM_READ);
+			if (rc <= 0)
+				goto read_err;
+
+			if (copy_to_user(buf, &val, sizeof(val)))
+				goto read_err;
+
+			filled = 1;
+		}
+
+		count -= filled;
+		done += filled;
+		*ppos += filled;
+		buf += filled;
+	}
+
+	mutex_unlock(&vidxd->dev_lock);
+	return done;
+
+ read_err:
+	mutex_unlock(&vidxd->dev_lock);
+	return -EFAULT;
+}
+
+static ssize_t idxd_vdcm_write(struct mdev_device *mdev, const char __user *buf, size_t count,
+			       loff_t *ppos)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	unsigned int done = 0;
+	int rc;
+
+	mutex_lock(&vidxd->dev_lock);
+	while (count) {
+		size_t filled;
+
+		if (count >= 4 && !(*ppos % 4)) {
+			u32 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val, sizeof(val),
+					  ppos, IDXD_VDCM_WRITE);
+			if (rc <= 0)
+				goto write_err;
+
+			filled = 4;
+		} else if (count >= 2 && !(*ppos % 2)) {
+			u16 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+
+			rc = idxd_vdcm_rw(mdev, (char *)&val,
+					  sizeof(val), ppos, IDXD_VDCM_WRITE);
+			if (rc <= 0)
+				goto write_err;
+
+			filled = 2;
+		} else {
+			u8 val;
+
+			if (copy_from_user(&val, buf, sizeof(val)))
+				goto write_err;
+
+			rc = idxd_vdcm_rw(mdev, &val, sizeof(val),
+					  ppos, IDXD_VDCM_WRITE);
+			if (rc <= 0)
+				goto write_err;
+
+			filled = 1;
+		}
+
+		count -= filled;
+		done += filled;
+		*ppos += filled;
+		buf += filled;
+	}
+
+	mutex_unlock(&vidxd->dev_lock);
+	return done;
+
+write_err:
+	mutex_unlock(&vidxd->dev_lock);
+	return -EFAULT;
+}
+
+static int check_vma(struct idxd_wq *wq, struct vm_area_struct *vma)
+{
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int idxd_vdcm_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+{
+	unsigned int wq_idx, rc;
+	unsigned long req_size, pgoff = 0, offset;
+	pgprot_t pg_prot;
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct idxd_wq *wq = vidxd->wq;
+	struct idxd_device *idxd = vidxd->idxd;
+	enum idxd_portal_prot virt_portal, phys_portal;
+	phys_addr_t base = pci_resource_start(idxd->pdev, IDXD_WQ_BAR);
+	struct device *dev = mdev_dev(mdev);
+
+	rc = check_vma(wq, vma);
+	if (rc)
+		return rc;
+
+	pg_prot = vma->vm_page_prot;
+	req_size = vma->vm_end - vma->vm_start;
+	vma->vm_flags |= VM_DONTCOPY;
+
+	offset = (vma->vm_pgoff << PAGE_SHIFT) &
+		 ((1ULL << VFIO_PCI_OFFSET_SHIFT) - 1);
+
+	wq_idx = offset >> (PAGE_SHIFT + 2);
+	if (wq_idx >= 1) {
+		dev_err(dev, "mapping invalid wq %d off %lx\n",
+			wq_idx, offset);
+		return -EINVAL;
+	}
+
+	/*
+	 * Check and see if the guest wants to map to the limited or unlimited portal.
+	 * The driver will allow mapping to unlimited portal only if the the wq is a
+	 * dedicated wq. Otherwise, it goes to limited.
+	 */
+	virt_portal = ((offset >> PAGE_SHIFT) & 0x3) == 1;
+	phys_portal = IDXD_PORTAL_LIMITED;
+	if (virt_portal == IDXD_PORTAL_UNLIMITED && wq_dedicated(wq))
+		phys_portal = IDXD_PORTAL_UNLIMITED;
+
+	/* We always map IMS portals to the guest */
+	pgoff = (base + idxd_get_wq_portal_full_offset(wq->id, phys_portal,
+						       IDXD_IRQ_IMS)) >> PAGE_SHIFT;
+
+	dev_dbg(dev, "mmap %lx %lx %lx %lx\n", vma->vm_start, pgoff, req_size,
+		pgprot_val(pg_prot));
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_private_data = mdev;
+	vma->vm_pgoff = pgoff;
+
+	return remap_pfn_range(vma, vma->vm_start, pgoff, req_size, pg_prot);
+}
+
+static int idxd_vdcm_get_irq_count(struct vdcm_idxd *vidxd, int type)
+{
+	/*
+	 * Even though the number of MSIX vectors supported are not tied to number of
+	 * wqs being exported, the current design is to allow 1 vector per WQ for guest.
+	 * So here we end up with num of wqs plus 1 that handles the misc interrupts.
+	 */
+	if (type == VFIO_PCI_MSI_IRQ_INDEX || type == VFIO_PCI_MSIX_IRQ_INDEX)
+		return VIDXD_MAX_MSIX_VECS;
+
+	return 0;
+}
+
+static irqreturn_t idxd_guest_wq_completion(int irq, void *data)
+{
+	struct ims_irq_entry *irq_entry = data;
+	struct vdcm_idxd *vidxd = irq_entry->vidxd;
+	int msix_idx = irq_entry->int_src;
+
+	vidxd_send_interrupt(vidxd, msix_idx + 1);
+	return IRQ_HANDLED;
+}
+
+static int msix_trigger_unregister(struct vdcm_idxd *vidxd, int index)
+{
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct ims_irq_entry *irq_entry;
+	int rc;
+
+	if (!vidxd->vdev.msix_trigger[index])
+		return 0;
+
+	dev_dbg(dev, "disable MSIX trigger %d\n", index);
+	if (index) {
+		irq_entry = &vidxd->irq_entries[index - 1];
+		if (irq_entry->irq_set) {
+			free_irq(irq_entry->irq, irq_entry);
+			irq_entry->irq_set = false;
+		}
+		rc = vidxd_disable_host_ims_pasid(vidxd, index - 1);
+		if (rc)
+			return rc;
+	}
+	eventfd_ctx_put(vidxd->vdev.msix_trigger[index]);
+	vidxd->vdev.msix_trigger[index] = NULL;
+
+	return 0;
+}
+
+static int msix_trigger_register(struct vdcm_idxd *vidxd, u32 fd, int index)
+{
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct ims_irq_entry *irq_entry;
+	struct eventfd_ctx *trigger;
+	int rc;
+
+	rc = msix_trigger_unregister(vidxd, index);
+	if (rc < 0)
+		return rc;
+
+	dev_dbg(dev, "enable MSIX trigger %d\n", index);
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		dev_warn(dev, "eventfd_ctx_fdget failed %d\n", index);
+		return PTR_ERR(trigger);
+	}
+
+	/*
+	 * The MSIX vector 0 is emulated by the mdev. Starting with vector 1
+	 * the interrupt is backed by IMS and needs to be set up, but we
+	 * will be setting up entry 0 of the IMS vectors. So here we pass
+	 * in i - 1 to the host setup and irq_entries.
+	 */
+	if (index) {
+		irq_entry = &vidxd->irq_entries[index - 1];
+		rc = vidxd_enable_host_ims_pasid(vidxd, index - 1);
+		if (rc) {
+			dev_warn(dev, "failed to enable host ims pasid\n");
+			eventfd_ctx_put(trigger);
+			return rc;
+		}
+
+		rc = request_irq(irq_entry->irq, idxd_guest_wq_completion, 0, "idxd-ims", irq_entry);
+		if (rc) {
+			dev_warn(dev, "failed to request ims irq\n");
+			eventfd_ctx_put(trigger);
+			vidxd_disable_host_ims_pasid(vidxd, index - 1);
+			return rc;
+		}
+		irq_entry->irq_set = true;
+	}
+
+	vidxd->vdev.msix_trigger[index] = trigger;
+	return 0;
+}
+
+static int vdcm_idxd_set_msix_trigger(struct vdcm_idxd *vidxd,
+				      unsigned int index, unsigned int start,
+				      unsigned int count, uint32_t flags,
+				      void *data)
+{
+	int i, rc = 0;
+
+	if (count > VIDXD_MAX_MSIX_ENTRIES - 1)
+		count = VIDXD_MAX_MSIX_ENTRIES - 1;
+
+	/*
+	 * The MSIX vector 0 is emulated by the mdev. Starting with vector 1
+	 * the interrupt is backed by IMS and needs to be set up, but we
+	 * will be setting up entry 0 of the IMS vectors. So here we pass
+	 * in i - 1 to the host setup and irq_entries.
+	 */
+	if (count == 0 && (flags & VFIO_IRQ_SET_DATA_NONE)) {
+		/* Disable all MSIX entries */
+		for (i = 0; i < VIDXD_MAX_MSIX_ENTRIES; i++) {
+			rc = msix_trigger_unregister(vidxd, i);
+			if (rc < 0)
+				return rc;
+		}
+		return 0;
+	}
+
+	for (i = 0; i < count; i++) {
+		if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+			u32 fd = *(u32 *)(data + i * sizeof(u32));
+
+			rc = msix_trigger_register(vidxd, fd, i);
+			if (rc < 0)
+				return rc;
+		} else if (flags & VFIO_IRQ_SET_DATA_NONE) {
+			rc = msix_trigger_unregister(vidxd, i);
+			if (rc < 0)
+				return rc;
+		}
+	}
+	return rc;
+}
+
+static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
+			      unsigned int index, unsigned int start,
+			      unsigned int count, void *data)
+{
+	int (*func)(struct vdcm_idxd *vidxd, unsigned int index,
+		    unsigned int start, unsigned int count, uint32_t flags,
+		    void *data) = NULL;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	switch (index) {
+	case VFIO_PCI_INTX_IRQ_INDEX:
+		dev_warn(dev, "intx interrupts not supported.\n");
+		break;
+	case VFIO_PCI_MSI_IRQ_INDEX:
+		dev_dbg(dev, "msi interrupt.\n");
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func = vdcm_idxd_set_msix_trigger;
+			break;
+		}
+		break;
+	case VFIO_PCI_MSIX_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func = vdcm_idxd_set_msix_trigger;
+			break;
+		}
+		break;
+	default:
+		return -ENOTTY;
+	}
+
+	if (!func)
+		return -ENOTTY;
+
+	return func(vidxd, index, start, count, flags, data);
+}
+
+static void vidxd_vdcm_reset(struct vdcm_idxd *vidxd)
+{
+	vidxd_reset(vidxd);
+}
+
+static long idxd_vdcm_ioctl(struct mdev_device *mdev, unsigned int cmd,
+			    unsigned long arg)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	unsigned long minsz;
+	int rc = -EINVAL;
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "vidxd %p ioctl, cmd: %d\n", vidxd, cmd);
+
+	mutex_lock(&vidxd->dev_lock);
+	if (cmd == VFIO_DEVICE_GET_INFO) {
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (info.argsz < minsz) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		info.flags = VFIO_DEVICE_FLAGS_PCI;
+		info.flags |= VFIO_DEVICE_FLAGS_RESET;
+		info.num_regions = VFIO_PCI_NUM_REGIONS;
+		info.num_irqs = VFIO_PCI_NUM_IRQS;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			rc = -EFAULT;
+		else
+			rc = 0;
+		goto out;
+	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		struct vfio_region_info info;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+		struct vfio_region_info_cap_sparse_mmap *sparse = NULL;
+		size_t size;
+		int nr_areas = 1;
+		int cap_type_id = 0;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (info.argsz < minsz) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		switch (info.index) {
+		case VFIO_PCI_CONFIG_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = VIDXD_MAX_CFG_SPACE_SZ;
+			info.flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE;
+			break;
+		case VFIO_PCI_BAR0_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = vidxd->bar_size[info.index];
+			if (!info.size) {
+				info.flags = 0;
+				break;
+			}
+
+			info.flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE;
+			break;
+		case VFIO_PCI_BAR1_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 0;
+			info.flags = 0;
+			break;
+		case VFIO_PCI_BAR2_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.flags = VFIO_REGION_INFO_FLAG_CAPS | VFIO_REGION_INFO_FLAG_MMAP |
+				     VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE;
+			info.size = vidxd->bar_size[1];
+
+			/*
+			 * Every WQ has two areas for unlimited and limited
+			 * MSI-X portals. IMS portals are not reported
+			 */
+			nr_areas = 2;
+
+			size = sizeof(*sparse) + (nr_areas * sizeof(*sparse->areas));
+			sparse = kzalloc(size, GFP_KERNEL);
+			if (!sparse) {
+				rc = -ENOMEM;
+				goto out;
+			}
+
+			sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+			sparse->header.version = 1;
+			sparse->nr_areas = nr_areas;
+			cap_type_id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
+
+			sparse->areas[0].offset = 0;
+			sparse->areas[0].size = PAGE_SIZE;
+
+			sparse->areas[1].offset = PAGE_SIZE;
+			sparse->areas[1].size = PAGE_SIZE;
+			break;
+
+		case VFIO_PCI_BAR3_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 0;
+			info.flags = 0;
+			dev_dbg(dev, "get region info bar:%d\n", info.index);
+			break;
+
+		case VFIO_PCI_ROM_REGION_INDEX:
+		case VFIO_PCI_VGA_REGION_INDEX:
+			dev_dbg(dev, "get region info index:%d\n", info.index);
+			break;
+		default: {
+			if (info.index >= VFIO_PCI_NUM_REGIONS)
+				rc = -EINVAL;
+			else
+				rc = 0;
+			goto out;
+		} /* default */
+		} /* info.index switch */
+
+		if ((info.flags & VFIO_REGION_INFO_FLAG_CAPS) && sparse) {
+			if (cap_type_id == VFIO_REGION_INFO_CAP_SPARSE_MMAP) {
+				rc = vfio_info_add_capability(&caps, &sparse->header,
+							      sizeof(*sparse) + (sparse->nr_areas *
+							      sizeof(*sparse->areas)));
+				kfree(sparse);
+				if (rc)
+					goto out;
+			}
+		}
+
+		if (caps.size) {
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+				info.cap_offset = 0;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg + sizeof(info),
+						 caps.buf, caps.size)) {
+					kfree(caps.buf);
+					rc = -EFAULT;
+					goto out;
+				}
+				info.cap_offset = sizeof(info);
+			}
+
+			kfree(caps.buf);
+		}
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			rc = -EFAULT;
+		else
+			rc = 0;
+		goto out;
+	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
+		struct vfio_irq_info info;
+
+		minsz = offsetofend(struct vfio_irq_info, count);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		switch (info.index) {
+		case VFIO_PCI_MSI_IRQ_INDEX:
+		case VFIO_PCI_MSIX_IRQ_INDEX:
+		default:
+			rc = -EINVAL;
+			goto out;
+		} /* switch(info.index) */
+
+		info.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_NORESIZE;
+		info.count = idxd_vdcm_get_irq_count(vidxd, info.index);
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			rc = -EFAULT;
+		else
+			rc = 0;
+		goto out;
+	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
+		struct vfio_irq_set hdr;
+		u8 *data = NULL;
+		size_t data_size = 0;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz)) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
+			int max = idxd_vdcm_get_irq_count(vidxd, hdr.index);
+
+			rc = vfio_set_irqs_validate_and_prepare(&hdr, max, VFIO_PCI_NUM_IRQS,
+								&data_size);
+			if (rc) {
+				dev_err(dev, "intel:vfio_set_irqs_validate_and_prepare failed\n");
+				rc = -EINVAL;
+				goto out;
+			}
+			if (data_size) {
+				data = memdup_user((void __user *)(arg + minsz), data_size);
+				if (IS_ERR(data)) {
+					rc = PTR_ERR(data);
+					goto out;
+				}
+			}
+		}
+
+		if (!data) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		rc = idxd_vdcm_set_irqs(vidxd, hdr.flags, hdr.index, hdr.start, hdr.count, data);
+		kfree(data);
+		goto out;
+	} else if (cmd == VFIO_DEVICE_RESET) {
+		vidxd_vdcm_reset(vidxd);
+	}
+
+ out:
+	mutex_unlock(&vidxd->dev_lock);
+	return rc;
+}
+
+static const struct mdev_parent_ops idxd_vdcm_ops = {
+	.create			= idxd_vdcm_create,
+	.remove			= idxd_vdcm_remove,
+	.open			= idxd_vdcm_open,
+	.release		= idxd_vdcm_release,
+	.read			= idxd_vdcm_read,
+	.write			= idxd_vdcm_write,
+	.mmap			= idxd_vdcm_mmap,
+	.ioctl			= idxd_vdcm_ioctl,
+};
+
+int idxd_mdev_host_init(struct idxd_device *idxd)
+{
+	struct device *dev = &idxd->pdev->dev;
+	int rc;
+
+	if (!test_bit(IDXD_FLAG_SIOV_SUPPORTED, &idxd->flags))
+		return -EOPNOTSUPP;
+
+	if (iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_AUX)) {
+		rc = iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_AUX);
+		if (rc < 0) {
+			dev_warn(dev, "Failed to enable aux-domain: %d\n", rc);
+			return rc;
+		}
+	} else {
+		dev_warn(dev, "No aux-domain feature.\n");
+		return -EOPNOTSUPP;
+	}
+
+	return mdev_register_device(dev, &idxd_vdcm_ops);
+}
+
+void idxd_mdev_host_release(struct idxd_device *idxd)
+{
+	struct device *dev = &idxd->pdev->dev;
+	int rc;
+
+	mdev_unregister_device(dev);
+	if (iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_AUX)) {
+		rc = iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
+		if (rc < 0)
+			dev_warn(dev, "Failed to disable aux-domain: %d\n",
+				 rc);
+	}
+}
diff --git a/drivers/dma/idxd/mdev.h b/drivers/dma/idxd/mdev.h
new file mode 100644
index 000000000000..328055435cea
--- /dev/null
+++ b/drivers/dma/idxd/mdev.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
+
+#ifndef _IDXD_MDEV_H_
+#define _IDXD_MDEV_H_
+
+/* two 64-bit BARs implemented */
+#define VIDXD_MAX_BARS 2
+#define VIDXD_MAX_CFG_SPACE_SZ 4096
+#define VIDXD_MAX_MMIO_SPACE_SZ 8192
+#define VIDXD_MSIX_TBL_SZ_OFFSET 0x42
+#define VIDXD_CAP_CTRL_SZ 0x100
+#define VIDXD_GRP_CTRL_SZ 0x100
+#define VIDXD_WQ_CTRL_SZ 0x100
+#define VIDXD_WQ_OCPY_INT_SZ 0x20
+#define VIDXD_MSIX_TBL_SZ 0x90
+#define VIDXD_MSIX_PERM_TBL_SZ 0x48
+
+#define VIDXD_MSIX_TABLE_OFFSET 0x600
+#define VIDXD_MSIX_PERM_OFFSET 0x300
+#define VIDXD_GRPCFG_OFFSET 0x400
+#define VIDXD_WQCFG_OFFSET 0x500
+#define VIDXD_IMS_OFFSET 0x1000
+
+#define VIDXD_BAR0_SIZE  0x2000
+#define VIDXD_BAR2_SIZE  0x20000
+#define VIDXD_MAX_MSIX_ENTRIES  (VIDXD_MSIX_TBL_SZ / 0x10)
+#define VIDXD_MAX_WQS	1
+#define VIDXD_MAX_MSIX_VECS	2
+
+#define	VIDXD_ATS_OFFSET 0x100
+#define	VIDXD_PRS_OFFSET 0x110
+#define VIDXD_PASID_OFFSET 0x120
+#define VIDXD_MSIX_PBA_OFFSET 0x700
+
+struct ims_irq_entry {
+	struct vdcm_idxd *vidxd;
+	int int_src;
+	unsigned int irq;
+	bool irq_set;
+};
+
+struct idxd_vdev {
+	struct mdev_device *mdev;
+	struct eventfd_ctx *msix_trigger[VIDXD_MAX_MSIX_ENTRIES];
+	struct notifier_block group_notifier;
+	struct work_struct release_work;
+	atomic_t released;
+};
+
+struct vdcm_idxd {
+	struct idxd_device *idxd;
+	struct idxd_wq *wq;
+	struct idxd_vdev vdev;
+	struct vdcm_idxd_type *type;
+	int num_wqs;
+	u64 ims_index[VIDXD_MAX_MSIX_VECS - 1];
+	struct msix_entry ims_entry;
+	struct ims_irq_entry irq_entries[VIDXD_MAX_WQS];
+
+	/* For VM use case */
+	u64 bar_val[VIDXD_MAX_BARS];
+	u64 bar_size[VIDXD_MAX_BARS];
+	u8 cfg[VIDXD_MAX_CFG_SPACE_SZ];
+	u8 bar0[VIDXD_MAX_MMIO_SPACE_SZ];
+	struct list_head list;
+	struct mutex dev_lock; /* lock for vidxd resources */
+};
+
+static inline struct vdcm_idxd *to_vidxd(struct idxd_vdev *vdev)
+{
+	return container_of(vdev, struct vdcm_idxd, vdev);
+}
+
+#define IDXD_MDEV_NAME_LEN 16
+#define IDXD_MDEV_DESCRIPTION_LEN 64
+
+enum idxd_mdev_type {
+	IDXD_MDEV_TYPE_1_DWQ = 0,
+};
+
+#define IDXD_MDEV_TYPES 1
+
+struct vdcm_idxd_type {
+	char name[IDXD_MDEV_NAME_LEN];
+	char description[IDXD_MDEV_DESCRIPTION_LEN];
+	enum idxd_mdev_type type;
+	unsigned int avail_instance;
+};
+
+enum idxd_vdcm_rw {
+	IDXD_VDCM_READ = 0,
+	IDXD_VDCM_WRITE,
+};
+
+static inline u64 get_reg_val(void *buf, int size)
+{
+	u64 val = 0;
+
+	switch (size) {
+	case 8:
+		val = *(uint64_t *)buf;
+		break;
+	case 4:
+		val = *(uint32_t *)buf;
+		break;
+	case 2:
+		val = *(uint16_t *)buf;
+		break;
+	case 1:
+		val = *(uint8_t *)buf;
+		break;
+	}
+
+	return val;
+}
+
+#endif
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
new file mode 100644
index 000000000000..af421852cc51
--- /dev/null
+++ b/drivers/dma/idxd/vdev.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/sched/task.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/mm.h>
+#include <linux/mmu_context.h>
+#include <linux/vfio.h>
+#include <linux/mdev.h>
+#include <linux/msi.h>
+#include <linux/intel-iommu.h>
+#include <linux/intel-svm.h>
+#include <linux/kvm_host.h>
+#include <linux/eventfd.h>
+#include <uapi/linux/idxd.h>
+#include "registers.h"
+#include "idxd.h"
+#include "../../vfio/pci/vfio_pci_private.h"
+#include "mdev.h"
+#include "vdev.h"
+
+int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx)
+{
+	/* PLACE HOLDER */
+	return 0;
+}
+
+int vidxd_disable_host_ims_pasid(struct vdcm_idxd *vidxd, int ims_idx)
+{
+	/* PLACEHOLDER */
+	return 0;
+}
+
+int vidxd_enable_host_ims_pasid(struct vdcm_idxd *vidxd, int ims_idx)
+{
+	/* PLACEHOLDER */
+	return 0;
+}
+
+int vidxd_mmio_read(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size)
+{
+	/* PLACEHOLDER */
+	return 0;
+}
+
+int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size)
+{
+	/* PLACEHOLDER */
+	return 0;
+}
+
+int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count)
+{
+	/* PLACEHOLDER */
+	return 0;
+}
+
+int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size)
+{
+	/* PLACEHOLDER */
+	return 0;
+}
+
+void vidxd_mmio_init(struct vdcm_idxd *vidxd)
+{
+	/* PLACEHOLDER */
+}
+
+void vidxd_reset(struct vdcm_idxd *vidxd)
+{
+	/* PLACEHOLDER */
+}
diff --git a/drivers/dma/idxd/vdev.h b/drivers/dma/idxd/vdev.h
new file mode 100644
index 000000000000..1a2fdda271e8
--- /dev/null
+++ b/drivers/dma/idxd/vdev.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
+
+#ifndef _IDXD_VDEV_H_
+#define _IDXD_VDEV_H_
+
+#include "mdev.h"
+
+int vidxd_mmio_read(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
+int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
+int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count);
+int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size);
+void vidxd_mmio_init(struct vdcm_idxd *vidxd);
+void vidxd_reset(struct vdcm_idxd *vidxd);
+int vidxd_disable_host_ims_pasid(struct vdcm_idxd *vidxd, int ims_idx);
+int vidxd_enable_host_ims_pasid(struct vdcm_idxd *vidxd, int ims_idx);
+int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx);
+
+#endif

