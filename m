Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8353112E2
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 21:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhBETMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 14:12:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:28083 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhBETLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:11:47 -0500
IronPort-SDR: JE23ZEkTyX9gPKY9KsLK9VO290YXO4+DKyqAIyABlr9Sy8VehfdGTLF8KBZ3xtyw54Nzf55RaL
 GPr1sh61Uu2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="180711290"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="180711290"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:26 -0800
IronPort-SDR: Om8GKkssz7UQJLGclVUqC/LDznlBmDjdX81FaT4VhRBZZthQgojDW/RqWmut9YlU5uBE+h2UjM
 qFPCjaLp2RrA==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="394011012"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:25 -0800
Subject: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration and
 helper functions
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        jgg@mellanox.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 05 Feb 2021 13:53:24 -0700
Message-ID: <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
---
 drivers/dma/idxd/device.c       |    1 
 drivers/dma/idxd/idxd.h         |    7 
 drivers/dma/idxd/init.c         |    2 
 drivers/vfio/mdev/idxd/Makefile |    2 
 drivers/vfio/mdev/idxd/mdev.c   | 1006 +++++++++++++++++++++++++++++++++++++++
 drivers/vfio/mdev/idxd/mdev.h   |  115 ++++
 drivers/vfio/mdev/idxd/vdev.c   |   75 +++
 drivers/vfio/mdev/idxd/vdev.h   |   19 +
 8 files changed, 1218 insertions(+), 9 deletions(-)
 create mode 100644 drivers/vfio/mdev/idxd/mdev.h
 create mode 100644 drivers/vfio/mdev/idxd/vdev.c
 create mode 100644 drivers/vfio/mdev/idxd/vdev.h

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 2491b27c8125..89fa2bbe6ebf 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -265,6 +265,7 @@ int idxd_wq_disable(struct idxd_wq *wq)
 	dev_dbg(dev, "WQ %d disabled\n", wq->id);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(idxd_wq_disable);
 
 void idxd_wq_drain(struct idxd_wq *wq)
 {
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index f02c96164515..a271942df2be 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -133,6 +133,7 @@ struct idxd_wq {
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
 	bool ats_dis;
+	struct list_head vdcm_list;
 };
 
 struct idxd_engine {
@@ -165,6 +166,7 @@ enum idxd_device_flag {
 	IDXD_FLAG_CMD_RUNNING,
 	IDXD_FLAG_PASID_ENABLED,
 	IDXD_FLAG_IMS_SUPPORTED,
+	IDXD_FLAG_MDEV_ENABLED,
 };
 
 struct idxd_device {
@@ -275,6 +277,11 @@ static inline bool device_swq_supported(struct idxd_device *idxd)
 	return (support_enqcmd && device_pasid_enabled(idxd));
 }
 
+static inline bool device_mdev_enabled(struct idxd_device *idxd)
+{
+	return test_bit(IDXD_FLAG_MDEV_ENABLED, &idxd->flags);
+}
+
 enum idxd_portal_prot {
 	IDXD_PORTAL_UNLIMITED = 0,
 	IDXD_PORTAL_LIMITED,
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index fd57f39e4b7d..cc3b757d300f 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -215,7 +215,6 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 
 	for (i = 0; i < idxd->max_wqs; i++) {
 		struct idxd_wq *wq = &idxd->wqs[i];
-		int rc;
 
 		wq->id = i;
 		wq->idxd = idxd;
@@ -227,6 +226,7 @@ static int idxd_setup_internals(struct idxd_device *idxd)
 		if (!wq->wqcfg)
 			return -ENOMEM;
 		init_completion(&wq->wq_dead);
+		INIT_LIST_HEAD(&wq->vdcm_list);
 	}
 
 	for (i = 0; i < idxd->max_engines; i++) {
diff --git a/drivers/vfio/mdev/idxd/Makefile b/drivers/vfio/mdev/idxd/Makefile
index e8f45cb96117..27a08621d120 100644
--- a/drivers/vfio/mdev/idxd/Makefile
+++ b/drivers/vfio/mdev/idxd/Makefile
@@ -1,4 +1,4 @@
 ccflags-y += -I$(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE=IDXD
 
 obj-$(CONFIG_VFIO_MDEV_IDXD) += idxd_mdev.o
-idxd_mdev-y := mdev.o
+idxd_mdev-y := mdev.o vdev.o
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 8b9a6adeb606..384ba5d6bc2b 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -1,27 +1,1017 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2020 Intel Corporation. All rights rsvd. */
+/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/device.h>
-#include <linux/auxiliary_bus.h>
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
+#include <linux/irqchip/irq-ims-msi.h>
 #include <uapi/linux/idxd.h>
 #include "registers.h"
 #include "idxd.h"
+#include "../../vfio/pci/vfio_pci_private.h"
+#include "mdev.h"
+#include "vdev.h"
 
-static int idxd_mdev_host_init(struct idxd_device *idxd)
+static u64 idxd_pci_config[] = {
+	0x0010000000008086ULL,
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
+static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags, unsigned int index,
+			      unsigned int start, unsigned int count, void *data);
+
+static int idxd_mdev_get_pasid(struct mdev_device *mdev, u32 *pasid)
+{
+	struct vfio_group *vfio_group;
+	struct iommu_domain *iommu_domain;
+	struct device *dev = mdev_dev(mdev);
+	struct device *iommu_device = mdev_get_iommu_device(dev);
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	int mdev_pasid;
+
+	if (!vidxd->vdev.vfio_group) {
+		dev_warn(dev, "Missing vfio_group.\n");
+		return -EINVAL;
+	}
+
+	vfio_group = vidxd->vdev.vfio_group;
+
+	iommu_domain = vfio_group_iommu_domain(vfio_group);
+	if (IS_ERR_OR_NULL(iommu_domain))
+		goto err;
+
+	mdev_pasid = iommu_aux_get_pasid(iommu_domain, iommu_device);
+	if (mdev_pasid < 0)
+		goto err;
+
+	*pasid = (u32)mdev_pasid;
+	return 0;
+
+ err:
+	vfio_group_put_external_user(vfio_group);
+	vidxd->vdev.vfio_group = NULL;
+	return -EFAULT;
+}
+
+static inline void reset_vconfig(struct vdcm_idxd *vidxd)
+{
+	u16 *devid = (u16 *)(vidxd->cfg + PCI_DEVICE_ID);
+	struct idxd_device *idxd = vidxd->idxd;
+
+	memset(vidxd->cfg, 0, VIDXD_MAX_CFG_SPACE_SZ);
+	memcpy(vidxd->cfg, idxd_pci_config, sizeof(idxd_pci_config));
+
+	if (idxd->type == IDXD_TYPE_DSA)
+		*devid = PCI_DEVICE_ID_INTEL_DSA_SPR0;
+	else if (idxd->type == IDXD_TYPE_IAX)
+		*devid = PCI_DEVICE_ID_INTEL_IAX_SPR0;
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
+static void idxd_vdcm_release(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "vdcm_idxd_release %d\n", vidxd->type->type);
+	mutex_lock(&vidxd->dev_lock);
+	if (!vidxd->refcount)
+		goto out;
+
+	idxd_vdcm_set_irqs(vidxd, VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
+			   VFIO_PCI_MSIX_IRQ_INDEX, 0, 0, NULL);
+
+	vidxd_free_ims_entries(vidxd);
+	if (vidxd->vdev.vfio_group) {
+		vfio_group_put_external_user(vidxd->vdev.vfio_group);
+		vidxd->vdev.vfio_group = NULL;
+	}
+
+	/* Re-initialize the VIDXD to a pristine state for re-use */
+	idxd_vdcm_init(vidxd);
+	vidxd->refcount--;
+
+ out:
+	mutex_unlock(&vidxd->dev_lock);
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
+	idxd_vdcm_init(vidxd);
+	mutex_lock(&wq->wq_lock);
+	idxd_wq_get(wq);
+	mutex_unlock(&wq->wq_lock);
+
+	for (i = 0; i < VIDXD_MAX_MSIX_ENTRIES; i++) {
+		vidxd->irq_entries[i].vidxd = vidxd;
+		vidxd->irq_entries[i].id = i;
+	}
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
+static int idxd_vdcm_open(struct mdev_device *mdev)
+{
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	int rc = -EINVAL;
+	struct vdcm_idxd_type *type = vidxd->type;
+	struct device *dev = mdev_dev(mdev);
+	struct vfio_group *vfio_group;
+
+	dev_dbg(dev, "%s: type: %d\n", __func__, type->type);
+
+	mutex_lock(&vidxd->dev_lock);
+	if (vidxd->refcount)
+		goto out;
+
+	vfio_group = vfio_group_get_external_user_from_dev(dev);
+	if (IS_ERR_OR_NULL(vfio_group))
+		return -EFAULT;
+	vidxd->vdev.vfio_group = vfio_group;
+
+	/* allocate and setup IMS entries */
+	rc = vidxd_setup_ims_entries(vidxd);
+	if (rc < 0)
+		goto ims_fail;
+
+	vidxd->refcount++;
+	mutex_unlock(&vidxd->dev_lock);
+
+	return rc;
+
+ ims_fail:
+	vfio_group_put_external_user(vfio_group);
+	vidxd->vdev.vfio_group = NULL;
+ out:
+	mutex_unlock(&vidxd->dev_lock);
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
 {
-	/* FIXME: Fill in later */
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
 	return 0;
 }
 
-static int idxd_mdev_host_release(struct idxd_device *idxd)
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
 {
-	/* FIXME: Fill in later */
+	/*
+	 * Even though the number of MSIX vectors supported are not tied to number of
+	 * wqs being exported, the current design is to allow 1 vector per WQ for guest.
+	 * So here we end up with num of wqs plus 1 that handles the misc interrupts.
+	 */
+	if (type == VFIO_PCI_MSI_IRQ_INDEX || type == VFIO_PCI_MSIX_IRQ_INDEX)
+		return VIDXD_MAX_MSIX_VECS;
+
 	return 0;
 }
 
+static irqreturn_t idxd_guest_wq_completion(int irq, void *data)
+{
+	struct ims_irq_entry *irq_entry = data;
+
+	vidxd_send_interrupt(irq_entry);
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
+		u32 auxval;
+
+		irq_entry = &vidxd->irq_entries[index];
+		if (irq_entry->irq_set) {
+			free_irq(irq_entry->irq, irq_entry);
+			irq_entry->irq_set = false;
+		}
+
+		auxval = ims_ctrl_pasid_aux(0, false);
+		rc = irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
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
+	if (vidxd->vdev.msix_trigger[index])
+		return 0;
+
+	dev_dbg(dev, "enable MSIX trigger %d\n", index);
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		dev_warn(dev, "eventfd_ctx_fdget failed %d\n", index);
+		return PTR_ERR(trigger);
+	}
+
+	if (index) {
+		u32 pasid;
+		u32 auxval;
+
+		irq_entry = &vidxd->irq_entries[index];
+		rc = idxd_mdev_get_pasid(mdev, &pasid);
+		if (rc < 0)
+			return rc;
+
+		/*
+		 * Program and enable the pasid field in the IMS entry. The programmed pasid and
+		 * enabled field is checked against the  pasid and enable field for the work queue
+		 * configuration and the pasid for the descriptor. A mismatch will result in blocked
+		 * IMS interrupt.
+		 */
+		auxval = ims_ctrl_pasid_aux(pasid, true);
+		rc = irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
+		if (rc < 0)
+			return rc;
+
+		rc = request_irq(irq_entry->irq, idxd_guest_wq_completion, 0, "idxd-ims",
+				 irq_entry);
+		if (rc) {
+			dev_warn(dev, "failed to request ims irq\n");
+			eventfd_ctx_put(trigger);
+			auxval = ims_ctrl_pasid_aux(0, false);
+			irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
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
+			/* Unlimited portal */
+			sparse->areas[0].offset = 0;
+			sparse->areas[0].size = PAGE_SIZE;
+
+			/* Limited portal */
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
+		info.flags = VFIO_IRQ_INFO_EVENTFD;
+
+		switch (info.index) {
+		case VFIO_PCI_INTX_IRQ_INDEX:
+			info.flags |= (VFIO_IRQ_INFO_MASKABLE | VFIO_IRQ_INFO_AUTOMASKED);
+			break;
+		case VFIO_PCI_MSI_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
+		case VFIO_PCI_REQ_IRQ_INDEX:
+			info.flags |= VFIO_IRQ_INFO_NORESIZE;
+			break;
+		case VFIO_PCI_ERR_IRQ_INDEX:
+			info.flags |= VFIO_IRQ_INFO_NORESIZE;
+			if (pci_is_pcie(vidxd->idxd->pdev))
+				break;
+			fallthrough;
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
+	if (!test_bit(IDXD_FLAG_IMS_SUPPORTED, &idxd->flags))
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
+
 static int idxd_mdev_aux_probe(struct auxiliary_device *auxdev,
 			       const struct auxiliary_device_id *id)
 {
@@ -34,6 +1024,7 @@ static int idxd_mdev_aux_probe(struct auxiliary_device *auxdev,
 		return rc;
 	}
 
+	set_bit(IDXD_FLAG_MDEV_ENABLED, &idxd->flags);
 	return 0;
 }
 
@@ -41,6 +1032,7 @@ static void idxd_mdev_aux_remove(struct auxiliary_device *auxdev)
 {
 	struct idxd_device *idxd = dev_get_drvdata(&auxdev->dev);
 
+	clear_bit(IDXD_FLAG_MDEV_ENABLED, &idxd->flags);
 	idxd_mdev_host_release(idxd);
 }
 
@@ -70,6 +1062,6 @@ static void idxd_mdev_auxdev_drv_unregister(struct idxd_mdev_aux_drv *drv)
 }
 
 module_driver(idxd_mdev_aux_drv, idxd_mdev_auxdev_drv_register, idxd_mdev_auxdev_drv_unregister);
-
+MODULE_IMPORT_NS(IDXD);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
new file mode 100644
index 000000000000..7ca50f054714
--- /dev/null
+++ b/drivers/vfio/mdev/idxd/mdev.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2020 Intel Corporation. All rights rsvd. */
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
+#define VIDXD_BAR2_SIZE  0x2000
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
+	bool irq_set;
+	int id;
+	int irq;
+};
+
+struct idxd_vdev {
+	struct mdev_device *mdev;
+	struct vfio_group *vfio_group;
+	struct eventfd_ctx *msix_trigger[VIDXD_MAX_MSIX_ENTRIES];
+};
+
+struct vdcm_idxd {
+	struct idxd_device *idxd;
+	struct idxd_wq *wq;
+	struct idxd_vdev vdev;
+	struct vdcm_idxd_type *type;
+	int num_wqs;
+	struct ims_irq_entry irq_entries[VIDXD_MAX_MSIX_ENTRIES];
+
+	/* For VM use case */
+	u64 bar_val[VIDXD_MAX_BARS];
+	u64 bar_size[VIDXD_MAX_BARS];
+	u8 cfg[VIDXD_MAX_CFG_SPACE_SZ];
+	u8 bar0[VIDXD_MAX_MMIO_SPACE_SZ];
+	struct list_head list;
+	struct mutex dev_lock; /* lock for vidxd resources */
+
+	int refcount;
+};
+
+static inline struct vdcm_idxd *to_vidxd(struct idxd_vdev *vdev)
+{
+	return container_of(vdev, struct vdcm_idxd, vdev);
+}
+
+#define IDXD_MDEV_NAME_LEN 64
+
+enum idxd_mdev_type {
+	IDXD_MDEV_TYPE_DSA_1_DWQ = 0,
+	IDXD_MDEV_TYPE_IAX_1_DWQ,
+};
+
+#define IDXD_MDEV_TYPES 2
+
+struct vdcm_idxd_type {
+	char *name;
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
+		val = *(u64 *)buf;
+		break;
+	case 4:
+		val = *(u32 *)buf;
+		break;
+	case 2:
+		val = *(u16 *)buf;
+		break;
+	case 1:
+		val = *(u8 *)buf;
+		break;
+	}
+
+	return val;
+}
+
+#endif
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
new file mode 100644
index 000000000000..766753a2ec53
--- /dev/null
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -0,0 +1,75 @@
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
+int vidxd_send_interrupt(struct ims_irq_entry *iie)
+{
+	/* PLACE HOLDER */
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
+
+int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
+{
+	/* PLACEHOLDER */
+	return 0;
+}
+
+void vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
+{
+	/* PLACEHOLDER */
+}
diff --git a/drivers/vfio/mdev/idxd/vdev.h b/drivers/vfio/mdev/idxd/vdev.h
new file mode 100644
index 000000000000..cc2ba6ccff7b
--- /dev/null
+++ b/drivers/vfio/mdev/idxd/vdev.h
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
+int vidxd_send_interrupt(struct ims_irq_entry *iie);
+int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd);
+void vidxd_free_ims_entries(struct vdcm_idxd *vidxd);
+
+#endif


