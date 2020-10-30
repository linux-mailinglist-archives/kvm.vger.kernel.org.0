Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55A02A0E17
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgJ3SyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:54:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:22685 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgJ3Swb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:31 -0400
IronPort-SDR: FtPUhgjoZyhZ8uNx+YuLP1ppnQwmuxL/Ds4zlUzEJX6YP1e2eDOqdgQTx5m/9rSbZtaK0+1bj3
 /8eg2gLCbb0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="232830042"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="232830042"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:14 -0700
IronPort-SDR: QKAoVBxguYe+lyC5FbPS/L3VDc+dETEG6m/SONP+IC9a5Qrv3k9CIo+ATQuXq7J4gPbCMcKyo0
 gP4CRZBD6kNw==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="335504562"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:13 -0700
Subject: [PATCH v4 12/17] dmaengine: idxd: virtual device commands emulation
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 30 Oct 2020 11:52:12 -0700
Message-ID: <160408393273.912050.10185046057399795762.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/dma/idxd/registers.h |   16 +-
 drivers/dma/idxd/vdev.c      |  427 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 438 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index 5a76fd0ab6ad..17f0d868e5a4 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -119,7 +119,8 @@ union gencfg_reg {
 union genctrl_reg {
 	struct {
 		u32 softerr_int_en:1;
-		u32 rsvd:31;
+		u32 halt_state_int_en:1;
+		u32 rsvd:30;
 	};
 	u32 bits;
 } __packed;
@@ -141,6 +142,8 @@ enum idxd_device_status_state {
 	IDXD_DEVICE_STATE_HALT,
 };
 
+#define IDXD_GENSTATS_MASK		0x03
+
 enum idxd_device_reset_type {
 	IDXD_DEVICE_RESET_SOFTWARE = 0,
 	IDXD_DEVICE_RESET_FLR,
@@ -153,6 +156,7 @@ enum idxd_device_reset_type {
 #define IDXD_INTC_CMD			0x02
 #define IDXD_INTC_OCCUPY			0x04
 #define IDXD_INTC_PERFMON_OVFL		0x08
+#define IDXD_INTC_HALT_STATE		0x10
 
 #define IDXD_CMD_OFFSET			0xa0
 union idxd_command_reg {
@@ -164,6 +168,7 @@ union idxd_command_reg {
 	};
 	u32 bits;
 } __packed;
+#define IDXD_CMD_INT_MASK		0x80000000
 
 enum idxd_cmd {
 	IDXD_CMD_ENABLE_DEVICE = 1,
@@ -227,10 +232,11 @@ enum idxd_cmdsts_err {
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
@@ -351,6 +357,12 @@ union wqcfg {
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
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
index b38bb676e604..6e7f98d0e52f 100644
--- a/drivers/dma/idxd/vdev.c
+++ b/drivers/dma/idxd/vdev.c
@@ -463,17 +463,438 @@ void vidxd_mmio_init(struct vdcm_idxd *vidxd)
 
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
+		vidxd_send_interrupt(vidxd, 0);
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
+	ims_idx = vidxd->irq_entries[vidx - 1].entry->device_msi.hwirq;
+	vidx--; /* MSIX idx 0 is a slow path interrupt */
+	cmdsts = ims_idx << IDXD_CMDSTS_RES_SHIFT;
+	dev_dbg(dev, "int handle %d:%d\n", vidx, ims_idx);
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
+	for (i = 0; i < VIDXD_MAX_MSIX_ENTRIES - 1; i++) {
+		if (vidxd->irq_entries[i].entry->device_msi.hwirq == handle) {
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
+	int wq_pasid;
+	u32 status;
+	int priv;
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
+	wq_pasid = idxd_mdev_get_pasid(mdev);
+	priv = 1;
+
+	if (wq_pasid >= 0) {
+		/* Clear pasid_en, pasid, and priv values */
+		wqcfg->bits[WQCFG_PASID_IDX] &= ~GENMASK(29, 8);
+		wqcfg->priv = priv;
+		wqcfg->pasid_en = 1;
+		wqcfg->pasid = wq_pasid;
+		dev_dbg(dev, "program pasid %d in wq %d\n", wq_pasid, wq->id);
+		spin_lock_irqsave(&idxd->dev_lock, flags);
+		idxd_wq_setup_pasid(wq, wq_pasid);
+		idxd_wq_setup_priv(wq, priv);
+		spin_unlock_irqrestore(&idxd->dev_lock, flags);
+		idxd_wq_enable(wq, &status);
+		if (status) {
+			dev_err(dev, "vidxd enable wq %d failed\n", wq->id);
+			idxd_complete_command(vidxd, status);
+			return;
+		}
+	} else {
+		dev_err(dev, "idxd pasid setup failed wq %d wq_pasid %d\n", wq->id, wq_pasid);
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_PASID_EN);
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


