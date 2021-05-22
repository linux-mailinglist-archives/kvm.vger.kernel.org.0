Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D70438D25F
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhEVAVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:21:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:14563 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230307AbhEVAV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:21:26 -0400
IronPort-SDR: xuaaiCVCQHcECNj1GmntMbHu3HHpD3zNeR9LcfPTgL0fViJkAdCupGRuXlNHPvLlrmfb1SKiXq
 qvqJl68HspMw==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="201634347"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="201634347"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:49 -0700
IronPort-SDR: Jd8vnF4rAAbm1EENdjuI99XAByddyCnqpuRv/rEK8ILDHzmZWB0rR1savcn1v7WG1y30t1c2+1
 7m+Teg0QNK+w==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="474752725"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:48 -0700
Subject: [PATCH v6 07/20] vfio/mdev: idxd: Add administrative commands
 emulation for mdev
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:19:48 -0700
Message-ID: <162164278827.261970.17985121038264068736.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Administrative commands are issued to the command register on the
accelerator device. For the mediated device, the MMIO path is emulated.
Add the command emulation support functions for the mdev.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/Makefile       |    2 
 drivers/dma/idxd/device.c       |   81 ++++++++
 drivers/dma/idxd/idxd.h         |    7 +
 drivers/dma/idxd/registers.h    |   12 +
 drivers/vfio/mdev/idxd/Makefile |    2 
 drivers/vfio/mdev/idxd/mdev.c   |   44 ++++
 drivers/vfio/mdev/idxd/mdev.h   |    5 
 drivers/vfio/mdev/idxd/vdev.c   |  406 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 555 insertions(+), 4 deletions(-)
 create mode 100644 drivers/vfio/mdev/idxd/mdev.c

diff --git a/drivers/dma/idxd/Makefile b/drivers/dma/idxd/Makefile
index 6d11558756f8..4d5352b1b5ce 100644
--- a/drivers/dma/idxd/Makefile
+++ b/drivers/dma/idxd/Makefile
@@ -1,3 +1,5 @@
+ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=IDXD
+
 obj-$(CONFIG_INTEL_IDXD) += idxd.o
 idxd-y := init.o irq.o device.o sysfs.o submit.o dma.o cdev.o
 
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 02e9a050b5bb..99542c9cbc47 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -233,6 +233,7 @@ int idxd_wq_enable(struct idxd_wq *wq)
 	dev_dbg(dev, "WQ %d enabled\n", wq->id);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(idxd_wq_enable);
 
 int idxd_wq_disable(struct idxd_wq *wq)
 {
@@ -259,6 +260,7 @@ int idxd_wq_disable(struct idxd_wq *wq)
 	dev_dbg(dev, "WQ %d disabled\n", wq->id);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(idxd_wq_disable);
 
 void idxd_wq_drain(struct idxd_wq *wq)
 {
@@ -329,7 +331,31 @@ void idxd_wqs_unmap_portal(struct idxd_device *idxd)
 	}
 }
 
-int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
+int idxd_wq_abort(struct idxd_wq *wq)
+{
+	struct idxd_device *idxd = wq->idxd;
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand, stat;
+
+	if (wq->state != IDXD_WQ_ENABLED) {
+		dev_dbg(dev, "WQ %d not active\n", wq->id);
+		return -ENXIO;
+	}
+
+	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
+	dev_dbg(dev, "cmd: %u (wq abort) operand: %#x\n", IDXD_CMD_ABORT_WQ, operand);
+	idxd_cmd_exec(idxd, IDXD_CMD_ABORT_WQ, operand, &stat);
+
+	if (stat != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(dev, "WQ abort failed: %#x\n", stat);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(idxd_wq_abort);
+
+int idxd_wq_set_pasid(struct idxd_wq *wq, u32 pasid)
 {
 	struct idxd_device *idxd = wq->idxd;
 	int rc;
@@ -425,6 +451,48 @@ void idxd_wq_quiesce(struct idxd_wq *wq)
 	percpu_ref_exit(&wq->wq_active);
 }
 
+void idxd_wq_setup_pasid(struct idxd_wq *wq, int pasid)
+{
+	struct idxd_device *idxd = wq->idxd;
+	int offset;
+
+	lockdep_assert_held(&idxd->dev_lock);
+
+	/* PASID fields are 8 bytes into the WQCFG register */
+	offset = WQCFG_OFFSET(idxd, wq->id, WQCFG_PASID_IDX);
+	wq->wqcfg->pasid_en = 1;
+	wq->wqcfg->pasid = pasid;
+	iowrite32(wq->wqcfg->bits[WQCFG_PASID_IDX], idxd->reg_base + offset);
+}
+EXPORT_SYMBOL_GPL(idxd_wq_setup_pasid);
+
+void idxd_wq_clear_pasid(struct idxd_wq *wq)
+{
+	struct idxd_device *idxd = wq->idxd;
+	int offset;
+
+	lockdep_assert_held(&idxd->dev_lock);
+	offset = WQCFG_OFFSET(idxd, wq->id, WQCFG_PASID_IDX);
+	wq->wqcfg->pasid = 0;
+	wq->wqcfg->pasid_en = 0;
+	iowrite32(wq->wqcfg->bits[WQCFG_PASID_IDX], idxd->reg_base + offset);
+}
+EXPORT_SYMBOL_GPL(idxd_wq_clear_pasid);
+
+void idxd_wq_setup_priv(struct idxd_wq *wq, int priv)
+{
+	struct idxd_device *idxd = wq->idxd;
+	int offset;
+
+	lockdep_assert_held(&idxd->dev_lock);
+
+	/* priv field is 8 bytes into the WQCFG register */
+	offset = WQCFG_OFFSET(idxd, wq->id, WQCFG_PRIV_IDX);
+	wq->wqcfg->priv = !!priv;
+	iowrite32(wq->wqcfg->bits[WQCFG_PRIV_IDX], idxd->reg_base + offset);
+}
+EXPORT_SYMBOL_GPL(idxd_wq_setup_priv);
+
 /* Device control bits */
 static inline bool idxd_is_enabled(struct idxd_device *idxd)
 {
@@ -613,6 +681,17 @@ void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
 	dev_dbg(dev, "pasid %d drained\n", pasid);
 }
 
+void idxd_device_abort_pasid(struct idxd_device *idxd, int pasid)
+{
+	struct device *dev = &idxd->pdev->dev;
+	u32 operand;
+
+	operand = pasid;
+	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_ABORT_PASID, operand);
+	idxd_cmd_exec(idxd, IDXD_CMD_ABORT_PASID, operand, NULL);
+	dev_dbg(dev, "pasid %d aborted\n", pasid);
+}
+
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
 				   enum idxd_interrupt_type irq_type)
 {
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index e5b90e6970aa..34ffa6dad53a 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -529,6 +529,7 @@ void idxd_device_cleanup(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
 void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
+void idxd_device_abort_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
 				   enum idxd_interrupt_type irq_type);
@@ -546,10 +547,14 @@ void idxd_wq_reset(struct idxd_wq *wq);
 int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
 void idxd_wq_disable_cleanup(struct idxd_wq *wq);
-int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
+int idxd_wq_set_pasid(struct idxd_wq *wq, u32 pasid);
 int idxd_wq_disable_pasid(struct idxd_wq *wq);
 void idxd_wq_quiesce(struct idxd_wq *wq);
 int idxd_wq_init_percpu_ref(struct idxd_wq *wq);
+int idxd_wq_abort(struct idxd_wq *wq);
+void idxd_wq_setup_pasid(struct idxd_wq *wq, int pasid);
+void idxd_wq_clear_pasid(struct idxd_wq *wq);
+void idxd_wq_setup_priv(struct idxd_wq *wq, int priv);
 
 /* submission */
 int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc);
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index c699c72bd8d2..c2d558e37baf 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -167,6 +167,7 @@ union idxd_command_reg {
 	};
 	u32 bits;
 } __packed;
+#define IDXD_CMD_INT_MASK		0x80000000
 
 enum idxd_cmd {
 	IDXD_CMD_ENABLE_DEVICE = 1,
@@ -233,6 +234,7 @@ enum idxd_cmdsts_err {
 	/* request interrupt handle */
 	IDXD_CMDSTS_ERR_INVAL_INT_IDX = 0x41,
 	IDXD_CMDSTS_ERR_NO_HANDLE,
+	IDXD_CMDSTS_ERR_INVAL_INT_IDX_RELEASE,
 };
 
 #define IDXD_CMDCAP_OFFSET		0xb0
@@ -352,8 +354,16 @@ union wqcfg {
 	u32 bits[8];
 } __packed;
 
-#define WQCFG_PASID_IDX                2
+enum idxd_wq_hw_state {
+	IDXD_WQ_DEV_DISABLED = 0,
+	IDXD_WQ_DEV_ENABLED,
+	IDXD_WQ_DEV_BUSY,
+};
 
+#define WQCFG_PASID_IDX		2
+#define WQCFG_PRIV_IDX		2
+#define WQCFG_MODE_DEDICATED	1
+#define WQCFG_MODE_SHARED	0
 /*
  * This macro calculates the offset into the WQCFG register
  * idxd - struct idxd *
diff --git a/drivers/vfio/mdev/idxd/Makefile b/drivers/vfio/mdev/idxd/Makefile
index ccd3bc1c7ab6..27a08621d120 100644
--- a/drivers/vfio/mdev/idxd/Makefile
+++ b/drivers/vfio/mdev/idxd/Makefile
@@ -1,4 +1,4 @@
 ccflags-y += -I$(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE=IDXD
 
 obj-$(CONFIG_VFIO_MDEV_IDXD) += idxd_mdev.o
-idxd_mdev-y := vdev.o
+idxd_mdev-y := mdev.o vdev.o
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
new file mode 100644
index 000000000000..90ff7cedb8b4
--- /dev/null
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2021 Intel Corporation. All rights rsvd. */
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
+#include "mdev.h"
+
+int idxd_mdev_get_pasid(struct mdev_device *mdev, struct vfio_device *vdev, u32 *pasid)
+{
+	struct vfio_group *vfio_group = vdev->group;
+	struct iommu_domain *iommu_domain;
+	struct device *iommu_device = mdev_get_iommu_device(mdev);
+	int rc;
+
+	iommu_domain = vfio_group_iommu_domain(vfio_group);
+	if (IS_ERR_OR_NULL(iommu_domain))
+		return -ENODEV;
+
+	rc = iommu_aux_get_pasid(iommu_domain, iommu_device);
+	if (rc < 0)
+		return -ENODEV;
+
+	*pasid = (u32)rc;
+	return 0;
+}
+
+MODULE_IMPORT_NS(IDXD);
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
index 120c2dc29ba7..e52b50760ee7 100644
--- a/drivers/vfio/mdev/idxd/mdev.h
+++ b/drivers/vfio/mdev/idxd/mdev.h
@@ -30,6 +30,7 @@
 #define VIDXD_MAX_WQS			1
 
 struct vdcm_idxd {
+	struct vfio_device vdev;
 	struct idxd_device *idxd;
 	struct idxd_wq *wq;
 	struct mdev_device *mdev;
@@ -71,6 +72,10 @@ static inline u8 vidxd_state(struct vdcm_idxd *vidxd)
 	return gensts->state;
 }
 
+int idxd_mdev_get_pasid(struct mdev_device *mdev, struct vfio_device *vdev, u32 *pasid);
+
+void vidxd_reset(struct vdcm_idxd *vidxd);
+
 int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count);
 int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size);
 #endif
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
index aca4a1228a97..4ead50947047 100644
--- a/drivers/vfio/mdev/idxd/vdev.c
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -252,4 +252,410 @@ int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsign
 	return 0;
 }
 
+static void idxd_complete_command(struct vdcm_idxd *vidxd, enum idxd_cmdsts_err val)
+{
+	u8 *bar0 = vidxd->bar0;
+	u32 *cmd = (u32 *)(bar0 + IDXD_CMD_OFFSET);
+	u32 *cmdsts = (u32 *)(bar0 + IDXD_CMDSTS_OFFSET);
+	u32 *intcause = (u32 *)(bar0 + IDXD_INTCAUSE_OFFSET);
+	struct device *dev = &vidxd->mdev->dev;
+
+	*cmdsts = val;
+	dev_dbg(dev, "%s: cmd: %#x  status: %#x\n", __func__, *cmd, val);
+
+	if (*cmd & IDXD_CMD_INT_MASK) {
+		*intcause |= IDXD_INTC_CMD;
+		vidxd_send_interrupt(vidxd, 0);
+	}
+}
+
+static void vidxd_enable(struct vdcm_idxd *vidxd)
+{
+	u8 *bar0 = vidxd->bar0;
+	union gensts_reg *gensts = (union gensts_reg *)(bar0 + IDXD_GENSTATS_OFFSET);
+
+	if (gensts->state == IDXD_DEVICE_STATE_ENABLED)
+		return idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_ENABLED);
+
+	/* Check PCI configuration */
+	if (!(vidxd->cfg[PCI_COMMAND] & PCI_COMMAND_MASTER))
+		return idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_BUSMASTER_EN);
+
+	gensts->state = IDXD_DEVICE_STATE_ENABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_disable(struct vdcm_idxd *vidxd)
+{
+	struct idxd_wq *wq;
+	union wqcfg *vwqcfg;
+	u8 *bar0 = vidxd->bar0;
+	union gensts_reg *gensts = (union gensts_reg *)(bar0 + IDXD_GENSTATS_OFFSET);
+	struct mdev_device *mdev = vidxd->mdev;
+	struct device *dev = &mdev->dev;
+	int rc;
+
+	if (gensts->state == IDXD_DEVICE_STATE_DISABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DIS_DEV_EN);
+		return;
+	}
+
+	vwqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	wq = vidxd->wq;
+
+	rc = idxd_wq_disable(wq);
+	if (rc < 0) {
+		dev_warn(dev, "vidxd disable (wq disable) failed.\n");
+		idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+		return;
+	}
+
+	vwqcfg->wq_state = IDXD_WQ_DISABLED;
+	gensts->state = IDXD_DEVICE_STATE_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_drain_all(struct vdcm_idxd *vidxd)
+{
+	struct idxd_wq *wq = vidxd->wq;
+
+	idxd_wq_drain(wq);
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_drain(struct vdcm_idxd *vidxd, int val)
+{
+	u8 *bar0 = vidxd->bar0;
+	union wqcfg *vwqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	struct idxd_wq *wq = vidxd->wq;
+
+	if (vwqcfg->wq_state != IDXD_WQ_DEV_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_NOT_EN);
+		return;
+	}
+
+	idxd_wq_drain(wq);
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_abort_all(struct vdcm_idxd *vidxd)
+{
+	struct idxd_wq *wq = vidxd->wq;
+	int rc;
+
+	rc = idxd_wq_abort(wq);
+	if (rc < 0) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+		return;
+	}
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_abort(struct vdcm_idxd *vidxd, int val)
+{
+	u8 *bar0 = vidxd->bar0;
+	union wqcfg *vwqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	struct idxd_wq *wq = vidxd->wq;
+	int rc;
+
+	if (vwqcfg->wq_state != IDXD_WQ_DEV_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_NOT_EN);
+		return;
+	}
+
+	rc = idxd_wq_abort(wq);
+	if (rc < 0) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+		return;
+	}
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+void vidxd_reset(struct vdcm_idxd *vidxd)
+{
+	u8 *bar0 = vidxd->bar0;
+	union gensts_reg *gensts = (union gensts_reg *)(bar0 + IDXD_GENSTATS_OFFSET);
+	union wqcfg *vwqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	struct idxd_wq *wq;
+	int rc;
+
+	gensts->state = IDXD_DEVICE_STATE_DRAIN;
+	wq = vidxd->wq;
+
+	if (wq->state == IDXD_WQ_ENABLED) {
+		rc = idxd_wq_abort(wq);
+		if (rc < 0) {
+			idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+			return;
+		}
+
+		rc = idxd_wq_disable(wq);
+		if (rc < 0) {
+			idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+			return;
+		}
+	}
+
+	vwqcfg->wq_state = IDXD_WQ_DISABLED;
+	gensts->state = IDXD_DEVICE_STATE_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_reset(struct vdcm_idxd *vidxd, int wq_id_mask)
+{
+	struct idxd_wq *wq;
+	u8 *bar0 = vidxd->bar0;
+	union wqcfg *vwqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	int rc;
+
+	wq = vidxd->wq;
+	if (vwqcfg->wq_state != IDXD_WQ_DEV_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_NOT_EN);
+		return;
+	}
+
+	rc = idxd_wq_abort(wq);
+	if (rc < 0) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+		return;
+	}
+
+	rc = idxd_wq_disable(wq);
+	if (rc < 0) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+		return;
+	}
+
+	vwqcfg->wq_state = IDXD_WQ_DEV_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_alloc_int_handle(struct vdcm_idxd *vidxd, int operand)
+{
+	bool ims = !!(operand & CMD_INT_HANDLE_IMS);
+	u32 cmdsts;
+	struct mdev_device *mdev = vidxd->mdev;
+	struct device *dev = &mdev->dev;
+	int ims_idx, vidx;
+
+	vidx = operand & GENMASK(15, 0);
+
+	/* vidx cannot be 0 since that's emulated and does not require IMS handle */
+	if (vidx <= 0 || vidx >= VIDXD_MAX_MSIX_VECS) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_INVAL_INT_IDX);
+		return;
+	}
+
+	if (ims) {
+		dev_warn(dev, "IMS allocation is not implemented yet\n");
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_NO_HANDLE);
+		return;
+	}
+
+	/*
+	 * The index coming from the guest driver will start at 1. Vector 0 is
+	 * the command interrupt and is emulated by the vdcm. Here we are asking
+	 * for the IMS index that's backing the I/O vectors from the relative
+	 * index to the mdev device. This index would start at 0. So for a
+	 * passed in vidx that is 1, we pass 0 to dev_msi_hwirq() and so forth.
+	 */
+	ims_idx = dev_msi_hwirq(dev, vidx - 1);
+	cmdsts = ims_idx << IDXD_CMDSTS_RES_SHIFT;
+	dev_dbg(dev, "requested index %d handle %d\n", vidx, ims_idx);
+	idxd_complete_command(vidxd, cmdsts);
+}
+
+static void vidxd_release_int_handle(struct vdcm_idxd *vidxd, int operand)
+{
+	struct mdev_device *mdev = vidxd->mdev;
+	struct device *dev = &mdev->dev;
+	bool ims = !!(operand & CMD_INT_HANDLE_IMS);
+	int handle, i;
+	bool found = false;
+
+	handle = operand & GENMASK(15, 0);
+	if (ims) {
+		dev_dbg(dev, "IMS allocation is not implemented yet\n");
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_INVAL_INT_IDX_RELEASE);
+		return;
+	}
+
+	/* IMS backed entry start at 1, 0 is emulated vector */
+	for (i = 1; i < VIDXD_MAX_MSIX_VECS; i++) {
+		if (dev_msi_hwirq(dev, i) == handle) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		dev_dbg(dev, "Freeing unallocated int handle.\n");
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_INVAL_INT_IDX_RELEASE);
+	}
+
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_enable(struct vdcm_idxd *vidxd, int wq_id)
+{
+	struct idxd_wq *wq;
+	u8 *bar0 = vidxd->bar0;
+	union wq_cap_reg *wqcap;
+	struct mdev_device *mdev = vidxd->mdev;
+	struct device *dev = &mdev->dev;
+	struct idxd_device *idxd;
+	union wqcfg *vwqcfg;
+	unsigned long flags;
+	u32 wq_pasid;
+	int priv, rc;
+
+	if (wq_id >= VIDXD_MAX_WQS) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_INVAL_WQIDX);
+		return;
+	}
+
+	idxd = vidxd->idxd;
+	wq = vidxd->wq;
+
+	vwqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET + wq_id * 32);
+	wqcap = (union wq_cap_reg *)(bar0 + IDXD_WQCAP_OFFSET);
+
+	if (vidxd_state(vidxd) != IDXD_DEVICE_STATE_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_NOTEN);
+		return;
+	}
+
+	if (vwqcfg->wq_state != IDXD_WQ_DEV_DISABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_WQ_ENABLED);
+		return;
+	}
+
+	if (wq_dedicated(wq) && wqcap->dedicated_mode == 0) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_WQ_MODE);
+		return;
+	}
+
+	priv = 1;
+	rc = idxd_mdev_get_pasid(mdev, &vidxd->vdev, &wq_pasid);
+	if (rc < 0) {
+		dev_warn(dev, "idxd pasid setup failed wq %d: %d\n", wq->id, rc);
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_PASID_EN);
+		return;
+	}
+
+	dev_dbg(dev, "program pasid %d in wq %d\n", wq_pasid, wq->id);
+	spin_lock_irqsave(&idxd->dev_lock, flags);
+	idxd_wq_setup_pasid(wq, wq_pasid);
+	idxd_wq_setup_priv(wq, priv);
+	spin_unlock_irqrestore(&idxd->dev_lock, flags);
+	rc = idxd_wq_enable(wq);
+	if (rc < 0) {
+		dev_dbg(dev, "vidxd enable wq %d failed\n", wq->id);
+		spin_lock_irqsave(&idxd->dev_lock, flags);
+		idxd_wq_clear_pasid(wq);
+		idxd_wq_setup_priv(wq, 0);
+		spin_unlock_irqrestore(&idxd->dev_lock, flags);
+		idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+		return;
+	}
+
+	vwqcfg->wq_state = IDXD_WQ_DEV_ENABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_disable(struct vdcm_idxd *vidxd, int wq_id_mask)
+{
+	struct idxd_wq *wq;
+	u8 *bar0 = vidxd->bar0;
+	union wqcfg *vwqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	int rc;
+
+	wq = vidxd->wq;
+	if (vwqcfg->wq_state != IDXD_WQ_DEV_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_NOT_EN);
+		return;
+	}
+
+	rc = idxd_wq_disable(wq);
+	if (rc < 0) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+		return;
+	}
+
+	vwqcfg->wq_state = IDXD_WQ_DEV_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static bool command_supported(struct vdcm_idxd *vidxd, u32 cmd)
+{
+	u8 *bar0 = vidxd->bar0;
+	u32 *cmd_cap = (u32 *)(bar0 + IDXD_CMDCAP_OFFSET);
+
+	return !!(*cmd_cap & BIT(cmd));
+}
+
+static void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
+{
+	union idxd_command_reg *reg = (union idxd_command_reg *)(vidxd->bar0 + IDXD_CMD_OFFSET);
+	union gensts_reg *gensts = (union gensts_reg *)(vidxd->bar0 + IDXD_GENSTATS_OFFSET);
+	struct mdev_device *mdev = vidxd->mdev;
+	struct device *dev = &mdev->dev;
+
+	reg->bits = val;
+
+	dev_dbg(dev, "%s: cmd code: %u reg: %x\n", __func__, reg->cmd, reg->bits);
+	if (!command_supported(vidxd, reg->cmd)) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_INVAL_CMD);
+		return;
+	}
+
+	if (gensts->state == IDXD_DEVICE_STATE_HALT) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_HW_ERR);
+		return;
+	}
+
+	switch (reg->cmd) {
+	case IDXD_CMD_ENABLE_DEVICE:
+		vidxd_enable(vidxd);
+		break;
+	case IDXD_CMD_DISABLE_DEVICE:
+		vidxd_disable(vidxd);
+		break;
+	case IDXD_CMD_DRAIN_ALL:
+		vidxd_drain_all(vidxd);
+		break;
+	case IDXD_CMD_ABORT_ALL:
+		vidxd_abort_all(vidxd);
+		break;
+	case IDXD_CMD_RESET_DEVICE:
+		vidxd_reset(vidxd);
+		break;
+	case IDXD_CMD_ENABLE_WQ:
+		vidxd_wq_enable(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_DISABLE_WQ:
+		vidxd_wq_disable(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_DRAIN_WQ:
+		vidxd_wq_drain(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_ABORT_WQ:
+		vidxd_wq_abort(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_RESET_WQ:
+		vidxd_wq_reset(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_REQUEST_INT_HANDLE:
+		vidxd_alloc_int_handle(vidxd, reg->operand);
+		break;
+	case IDXD_CMD_RELEASE_INT_HANDLE:
+		vidxd_release_int_handle(vidxd, reg->operand);
+		break;
+	default:
+		idxd_complete_command(vidxd, IDXD_CMDSTS_INVAL_CMD);
+		break;
+	}
+}
+
+MODULE_IMPORT_NS(IDXD);
 MODULE_LICENSE("GPL v2");


