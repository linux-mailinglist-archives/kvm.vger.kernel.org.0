Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7A311301
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 22:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhBETUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 14:20:21 -0500
Received: from mga06.intel.com ([134.134.136.31]:64259 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233625AbhBETMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:12:24 -0500
IronPort-SDR: aHS7M7udBphhDi/cE+F6g9cop7+EqTlEVof6s/vqSscWis+RVl5z9sRvePT2IvLcWaSpXUhOzm
 kw7oLeBs6aQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="242990275"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="242990275"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:59 -0800
IronPort-SDR: RqEkyteHsXTYspbPmte1gpuQohms5CGMkStJvpWer1/ZnLC69pZ/0t444vic6+sm/BZWXOAcsl
 jN+Ct6VQW+eA==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="416374787"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:53:58 -0800
Subject: [PATCH v5 10/14] vfio/mdev: idxd: virtual device commands emulation
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
Date:   Fri, 05 Feb 2021 13:53:57 -0700
Message-ID: <161255843743.339900.10371190228025336137.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add all the helper functions that supports the emulation of the commands
that are submitted to the device command register.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/device.c     |    5 
 drivers/dma/idxd/registers.h  |   16 +
 drivers/vfio/mdev/idxd/mdev.c |    2 
 drivers/vfio/mdev/idxd/mdev.h |    3 
 drivers/vfio/mdev/idxd/vdev.c |  440 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 460 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 245d576ddc43..c5faa23bd8ce 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -242,6 +242,7 @@ int idxd_wq_enable(struct idxd_wq *wq, u32 *status)
 	dev_dbg(dev, "WQ %d enabled\n", wq->id);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(idxd_wq_enable);
 
 int idxd_wq_disable(struct idxd_wq *wq, u32 *status)
 {
@@ -299,6 +300,7 @@ int idxd_wq_drain(struct idxd_wq *wq, u32 *status)
 	dev_dbg(dev, "WQ %d drained\n", wq->id);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(idxd_wq_drain);
 
 int idxd_wq_map_portal(struct idxd_wq *wq)
 {
@@ -351,6 +353,7 @@ int idxd_wq_abort(struct idxd_wq *wq, u32 *status)
 	dev_dbg(dev, "WQ %d aborted\n", wq->id);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(idxd_wq_abort);
 
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid)
 {
@@ -470,6 +473,7 @@ void idxd_wq_setup_pasid(struct idxd_wq *wq, int pasid)
 	wq->wqcfg->pasid = pasid;
 	iowrite32(wq->wqcfg->bits[WQCFG_PASID_IDX], idxd->reg_base + offset);
 }
+EXPORT_SYMBOL_GPL(idxd_wq_setup_pasid);
 
 void idxd_wq_setup_priv(struct idxd_wq *wq, int priv)
 {
@@ -483,6 +487,7 @@ void idxd_wq_setup_priv(struct idxd_wq *wq, int priv)
 	wq->wqcfg->priv = !!priv;
 	iowrite32(wq->wqcfg->bits[WQCFG_PRIV_IDX], idxd->reg_base + offset);
 }
+EXPORT_SYMBOL_GPL(idxd_wq_setup_priv);
 
 /* Device control bits */
 static inline bool idxd_is_enabled(struct idxd_device *idxd)
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index 50ea94259c99..0f985787417c 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -120,7 +120,8 @@ union gencfg_reg {
 union genctrl_reg {
 	struct {
 		u32 softerr_int_en:1;
-		u32 rsvd:31;
+		u32 halt_state_int_en:1;
+		u32 rsvd:30;
 	};
 	u32 bits;
 } __packed;
@@ -142,6 +143,8 @@ enum idxd_device_status_state {
 	IDXD_DEVICE_STATE_HALT,
 };
 
+#define IDXD_GENSTATS_MASK		0x03
+
 enum idxd_device_reset_type {
 	IDXD_DEVICE_RESET_SOFTWARE = 0,
 	IDXD_DEVICE_RESET_FLR,
@@ -154,6 +157,7 @@ enum idxd_device_reset_type {
 #define IDXD_INTC_CMD			0x02
 #define IDXD_INTC_OCCUPY			0x04
 #define IDXD_INTC_PERFMON_OVFL		0x08
+#define IDXD_INTC_HALT_STATE		0x10
 
 #define IDXD_CMD_OFFSET			0xa0
 union idxd_command_reg {
@@ -165,6 +169,7 @@ union idxd_command_reg {
 	};
 	u32 bits;
 } __packed;
+#define IDXD_CMD_INT_MASK		0x80000000
 
 enum idxd_cmd {
 	IDXD_CMD_ENABLE_DEVICE = 1,
@@ -228,10 +233,11 @@ enum idxd_cmdsts_err {
 	/* disable device errors */
 	IDXD_CMDSTS_ERR_DIS_DEV_EN = 0x31,
 	/* disable WQ, drain WQ, abort WQ, reset WQ */
-	IDXD_CMDSTS_ERR_DEV_NOT_EN,
+	IDXD_CMDSTS_ERR_WQ_NOT_EN,
 	/* request interrupt handle */
 	IDXD_CMDSTS_ERR_INVAL_INT_IDX = 0x41,
 	IDXD_CMDSTS_ERR_NO_HANDLE,
+	IDXD_CMDSTS_ERR_INVAL_INT_IDX_RELEASE,
 };
 
 #define IDXD_CMDCAP_OFFSET		0xb0
@@ -353,6 +359,12 @@ union wqcfg {
 	u32 bits[8];
 } __packed;
 
+enum idxd_wq_hw_state {
+	IDXD_WQ_DEV_DISABLED = 0,
+	IDXD_WQ_DEV_ENABLED,
+	IDXD_WQ_DEV_BUSY,
+};
+
 #define WQCFG_PASID_IDX		2
 #define WQCFG_PRIV_IDX		2
 #define WQCFG_MODE_DEDICATED	1
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 67e6b33468cd..7cde707021db 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -52,7 +52,7 @@ static char idxd_iax_1dwq_name[IDXD_MDEV_NAME_LEN];
 static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags, unsigned int index,
 			      unsigned int start, unsigned int count, void *data);
 
-static int idxd_mdev_get_pasid(struct mdev_device *mdev, u32 *pasid)
+int idxd_mdev_get_pasid(struct mdev_device *mdev, u32 *pasid)
 {
 	struct vfio_group *vfio_group;
 	struct iommu_domain *iommu_domain;
diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
index 7ca50f054714..8421b4962ac7 100644
--- a/drivers/vfio/mdev/idxd/mdev.h
+++ b/drivers/vfio/mdev/idxd/mdev.h
@@ -38,6 +38,7 @@ struct ims_irq_entry {
 	bool irq_set;
 	int id;
 	int irq;
+	int ims_idx;
 };
 
 struct idxd_vdev {
@@ -112,4 +113,6 @@ static inline u64 get_reg_val(void *buf, int size)
 	return val;
 }
 
+int idxd_mdev_get_pasid(struct mdev_device *mdev, u32 *pasid);
+
 #endif
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
index 958b09987e5c..766fd98e9eea 100644
--- a/drivers/vfio/mdev/idxd/vdev.c
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -492,17 +492,451 @@ void vidxd_mmio_init(struct vdcm_idxd *vidxd)
 
 static void idxd_complete_command(struct vdcm_idxd *vidxd, enum idxd_cmdsts_err val)
 {
-	/* PLACEHOLDER */
+	u8 *bar0 = vidxd->bar0;
+	u32 *cmd = (u32 *)(bar0 + IDXD_CMD_OFFSET);
+	u32 *cmdsts = (u32 *)(bar0 + IDXD_CMDSTS_OFFSET);
+	u32 *intcause = (u32 *)(bar0 + IDXD_INTCAUSE_OFFSET);
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	*cmdsts = val;
+	dev_dbg(dev, "%s: cmd: %#x  status: %#x\n", __func__, *cmd, val);
+
+	if (*cmd & IDXD_CMD_INT_MASK) {
+		*intcause |= IDXD_INTC_CMD;
+		vidxd_send_interrupt(&vidxd->irq_entries[0]);
+	}
+}
+
+static void vidxd_enable(struct vdcm_idxd *vidxd)
+{
+	u8 *bar0 = vidxd->bar0;
+	union gensts_reg *gensts = (union gensts_reg *)(bar0 + IDXD_GENSTATS_OFFSET);
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	dev_dbg(dev, "%s\n", __func__);
+	if (gensts->state == IDXD_DEVICE_STATE_ENABLED)
+		return idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DEV_ENABLED);
+
+	/* Check PCI configuration */
+	if (!(vidxd->cfg[PCI_COMMAND] & PCI_COMMAND_MASTER))
+		return idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_BUSMASTER_EN);
+
+	gensts->state = IDXD_DEVICE_STATE_ENABLED;
+
+	return idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_disable(struct vdcm_idxd *vidxd)
+{
+	struct idxd_wq *wq;
+	union wqcfg *wqcfg;
+	u8 *bar0 = vidxd->bar0;
+	union gensts_reg *gensts = (union gensts_reg *)(bar0 + IDXD_GENSTATS_OFFSET);
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	u32 status;
+
+	dev_dbg(dev, "%s\n", __func__);
+	if (gensts->state == IDXD_DEVICE_STATE_DISABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DIS_DEV_EN);
+		return;
+	}
+
+	wqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	wq = vidxd->wq;
+
+	/* If it is a DWQ, need to disable the DWQ as well */
+	if (wq_dedicated(wq)) {
+		idxd_wq_disable(wq, &status);
+		if (status) {
+			dev_warn(dev, "vidxd disable (wq disable) failed: %#x\n", status);
+			idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_DIS_DEV_EN);
+			return;
+		}
+	} else {
+		idxd_wq_drain(wq, &status);
+		if (status)
+			dev_warn(dev, "vidxd disable (wq drain) failed: %#x\n", status);
+	}
+
+	wqcfg->wq_state = 0;
+	gensts->state = IDXD_DEVICE_STATE_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_drain_all(struct vdcm_idxd *vidxd)
+{
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct idxd_wq *wq = vidxd->wq;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	idxd_wq_drain(wq, NULL);
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_drain(struct vdcm_idxd *vidxd, int val)
+{
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	u8 *bar0 = vidxd->bar0;
+	union wqcfg *wqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	struct idxd_wq *wq = vidxd->wq;
+	u32 status;
+
+	dev_dbg(dev, "%s\n", __func__);
+	if (wqcfg->wq_state != IDXD_WQ_DEV_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_WQ_NOT_EN);
+		return;
+	}
+
+	idxd_wq_drain(wq, &status);
+	if (status) {
+		dev_dbg(dev, "wq drain failed: %#x\n", status);
+		idxd_complete_command(vidxd, status);
+		return;
+	}
+
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_abort_all(struct vdcm_idxd *vidxd)
+{
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct idxd_wq *wq = vidxd->wq;
+
+	dev_dbg(dev, "%s\n", __func__);
+	idxd_wq_abort(wq, NULL);
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_abort(struct vdcm_idxd *vidxd, int val)
+{
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	u8 *bar0 = vidxd->bar0;
+	union wqcfg *wqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	struct idxd_wq *wq = vidxd->wq;
+	u32 status;
+
+	dev_dbg(dev, "%s\n", __func__);
+	if (wqcfg->wq_state != IDXD_WQ_DEV_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_WQ_NOT_EN);
+		return;
+	}
+
+	idxd_wq_abort(wq, &status);
+	if (status) {
+		dev_dbg(dev, "wq abort failed: %#x\n", status);
+		idxd_complete_command(vidxd, status);
+		return;
+	}
+
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
 }
 
 void vidxd_reset(struct vdcm_idxd *vidxd)
 {
-	/* PLACEHOLDER */
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	u8 *bar0 = vidxd->bar0;
+	union gensts_reg *gensts = (union gensts_reg *)(bar0 + IDXD_GENSTATS_OFFSET);
+	struct idxd_wq *wq;
+
+	dev_dbg(dev, "%s\n", __func__);
+	gensts->state = IDXD_DEVICE_STATE_DRAIN;
+	wq = vidxd->wq;
+
+	if (wq->state == IDXD_WQ_ENABLED) {
+		idxd_wq_abort(wq, NULL);
+		idxd_wq_disable(wq, NULL);
+	}
+
+	vidxd_mmio_init(vidxd);
+	gensts->state = IDXD_DEVICE_STATE_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_reset(struct vdcm_idxd *vidxd, int wq_id_mask)
+{
+	struct idxd_wq *wq;
+	u8 *bar0 = vidxd->bar0;
+	union wqcfg *wqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	u32 status;
+
+	wq = vidxd->wq;
+	dev_dbg(dev, "vidxd reset wq %u:%u\n", 0, wq->id);
+
+	if (wqcfg->wq_state != IDXD_WQ_DEV_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_WQ_NOT_EN);
+		return;
+	}
+
+	idxd_wq_abort(wq, &status);
+	if (status) {
+		dev_dbg(dev, "vidxd reset wq failed to abort: %#x\n", status);
+		idxd_complete_command(vidxd, status);
+		return;
+	}
+
+	idxd_wq_disable(wq, &status);
+	if (status) {
+		dev_dbg(dev, "vidxd reset wq failed to disable: %#x\n", status);
+		idxd_complete_command(vidxd, status);
+		return;
+	}
+
+	wqcfg->wq_state = IDXD_WQ_DEV_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_alloc_int_handle(struct vdcm_idxd *vidxd, int operand)
+{
+	bool ims = !!(operand & CMD_INT_HANDLE_IMS);
+	u32 cmdsts;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	int ims_idx, vidx;
+
+	vidx = operand & GENMASK(15, 0);
+
+	dev_dbg(dev, "allocating int handle for %d\n", vidx);
+
+	/* vidx cannot be 0 since that's emulated and does not require IMS handle */
+	if (vidx <= 0 || vidx >= VIDXD_MAX_MSIX_ENTRIES) {
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
+	ims_idx = vidxd->irq_entries[vidx].ims_idx;
+	cmdsts = ims_idx << IDXD_CMDSTS_RES_SHIFT;
+	dev_dbg(dev, "requested index %d handle %d\n", vidx, ims_idx);
+	idxd_complete_command(vidxd, cmdsts);
+}
+
+static void vidxd_release_int_handle(struct vdcm_idxd *vidxd, int operand)
+{
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	bool ims = !!(operand & CMD_INT_HANDLE_IMS);
+	int handle, i;
+	bool found = false;
+
+	handle = operand & GENMASK(15, 0);
+	dev_dbg(dev, "allocating int handle %d\n", handle);
+
+	if (ims) {
+		dev_warn(dev, "IMS allocation is not implemented yet\n");
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_INVAL_INT_IDX_RELEASE);
+		return;
+	}
+
+	/* IMS backed entry start at 1, 0 is emulated vector */
+	for (i = 1; i < VIDXD_MAX_MSIX_ENTRIES; i++) {
+		if (vidxd->irq_entries[i].ims_idx == handle) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		dev_warn(dev, "Freeing unallocated int handle.\n");
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_INVAL_INT_IDX_RELEASE);
+	}
+
+	dev_dbg(dev, "int handle %d released.\n", handle);
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static void vidxd_wq_enable(struct vdcm_idxd *vidxd, int wq_id)
+{
+	struct idxd_wq *wq;
+	u8 *bar0 = vidxd->bar0;
+	union wq_cap_reg *wqcap;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct idxd_device *idxd;
+	union wqcfg *vwqcfg, *wqcfg;
+	unsigned long flags;
+	u32 status, wq_pasid;
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
+	dev_dbg(dev, "%s: wq %u:%u\n", __func__, wq_id, wq->id);
+
+	vwqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET + wq_id * 32);
+	wqcap = (union wq_cap_reg *)(bar0 + IDXD_WQCAP_OFFSET);
+	wqcfg = wq->wqcfg;
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
+	rc = idxd_mdev_get_pasid(mdev, &wq_pasid);
+	if (rc < 0) {
+		dev_err(dev, "idxd pasid setup failed wq %d: %d\n", wq->id, rc);
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_PASID_EN);
+		return;
+	}
+
+	/* Clear pasid_en, pasid, and priv values */
+	wqcfg->bits[WQCFG_PASID_IDX] &= ~GENMASK(29, 8);
+	wqcfg->priv = priv;
+	wqcfg->pasid_en = 1;
+	wqcfg->pasid = wq_pasid;
+	dev_dbg(dev, "program pasid %d in wq %d\n", wq_pasid, wq->id);
+	spin_lock_irqsave(&idxd->dev_lock, flags);
+	idxd_wq_setup_pasid(wq, wq_pasid);
+	idxd_wq_setup_priv(wq, priv);
+	spin_unlock_irqrestore(&idxd->dev_lock, flags);
+	idxd_wq_enable(wq, &status);
+	if (status) {
+		dev_err(dev, "vidxd enable wq %d failed\n", wq->id);
+		idxd_complete_command(vidxd, status);
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
+	union wqcfg *wqcfg;
+	u8 *bar0 = vidxd->bar0;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	u32 status;
+
+	wq = vidxd->wq;
+
+	dev_dbg(dev, "vidxd disable wq %u:%u\n", 0, wq->id);
+
+	wqcfg = (union wqcfg *)(bar0 + VIDXD_WQCFG_OFFSET);
+	if (wqcfg->wq_state != IDXD_WQ_DEV_ENABLED) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_WQ_NOT_EN);
+		return;
+	}
+
+	/* If it is a DWQ, need to disable the DWQ as well */
+	if (wq_dedicated(wq)) {
+		idxd_wq_disable(wq, &status);
+		if (status) {
+			dev_warn(dev, "vidxd disable wq failed: %#x\n", status);
+			idxd_complete_command(vidxd, status);
+			return;
+		}
+	} else {
+		idxd_wq_drain(wq, &status);
+		if (status) {
+			dev_warn(dev, "vidxd disable drain wq failed: %#x\n", status);
+			idxd_complete_command(vidxd, status);
+			return;
+		}
+	}
+
+	wqcfg->wq_state = IDXD_WQ_DEV_DISABLED;
+	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
+}
+
+static bool command_supported(struct vdcm_idxd *vidxd, u32 cmd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+
+	if (cmd == IDXD_CMD_REQUEST_INT_HANDLE || cmd == IDXD_CMD_RELEASE_INT_HANDLE)
+		return true;
+
+	return !!(idxd->hw.opcap.bits[0] & BIT_ULL(cmd));
 }
 
 void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
 {
-	/* PLACEHOLDER */
+	union idxd_command_reg *reg = (union idxd_command_reg *)(vidxd->bar0 + IDXD_CMD_OFFSET);
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	reg->bits = val;
+
+	dev_dbg(dev, "%s: cmd code: %u reg: %x\n", __func__, reg->cmd, reg->bits);
+
+	if (!command_supported(vidxd, reg->cmd)) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_INVAL_CMD);
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
 }
 
 int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)


