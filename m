Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7B42284A7
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgGUQDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:03:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:23829 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbgGUQDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:03:37 -0400
IronPort-SDR: Cknbz0e0+UpYw6xTUkuI6366IEPi8/I+4AI98lcfA5FaCwAB+P9QpMuIUwMO6XuUz6O7h5EXGA
 htsfCE+5oLyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="149318114"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="149318114"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:03:35 -0700
IronPort-SDR: WwALxcDgIyEIWAy29vnbkFC+MbqzGgPPQTawD8e0X/hOpMDP2Es/UCnriRHAELcViQEE6EMbZ9
 CNMeBEhmGPqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="362407149"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001.jf.intel.com with ESMTP; 21 Jul 2020 09:03:34 -0700
Subject: [PATCH RFC v2 12/18] dmaengine: idxd: virtual device commands
 emulation
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
Date:   Tue, 21 Jul 2020 09:03:34 -0700
Message-ID: <159534741398.28840.9899761904385942767.stgit@djiang5-desk3.ch.intel.com>
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

Add all the helper functions that supports the emulation of the commands
that are submitted to the device command register.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/dma/idxd/registers.h |   16 +-
 drivers/dma/idxd/vdev.c      |  398 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 409 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index f8e4dd10a738..6531a40fad2e 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -115,7 +115,8 @@ union gencfg_reg {
 union genctrl_reg {
 	struct {
 		u32 softerr_int_en:1;
-		u32 rsvd:31;
+		u32 halt_state_int_en:1;
+		u32 rsvd:30;
 	};
 	u32 bits;
 } __packed;
@@ -137,6 +138,8 @@ enum idxd_device_status_state {
 	IDXD_DEVICE_STATE_HALT,
 };
 
+#define IDXD_GENSTATS_MASK		0x03
+
 enum idxd_device_reset_type {
 	IDXD_DEVICE_RESET_SOFTWARE = 0,
 	IDXD_DEVICE_RESET_FLR,
@@ -149,6 +152,7 @@ enum idxd_device_reset_type {
 #define IDXD_INTC_CMD			0x02
 #define IDXD_INTC_OCCUPY			0x04
 #define IDXD_INTC_PERFMON_OVFL		0x08
+#define IDXD_INTC_HALT_STATE		0x10
 
 #define IDXD_CMD_OFFSET			0xa0
 union idxd_command_reg {
@@ -160,6 +164,7 @@ union idxd_command_reg {
 	};
 	u32 bits;
 } __packed;
+#define IDXD_CMD_INT_MASK		0x80000000
 
 enum idxd_cmd {
 	IDXD_CMD_ENABLE_DEVICE = 1,
@@ -217,7 +222,7 @@ enum idxd_cmdsts_err {
 	/* disable device errors */
 	IDXD_CMDSTS_ERR_DIS_DEV_EN = 0x31,
 	/* disable WQ, drain WQ, abort WQ, reset WQ */
-	IDXD_CMDSTS_ERR_DEV_NOT_EN,
+	IDXD_CMDSTS_ERR_WQ_NOT_EN,
 	/* request interrupt handle */
 	IDXD_CMDSTS_ERR_INVAL_INT_IDX = 0x41,
 	IDXD_CMDSTS_ERR_NO_HANDLE,
@@ -353,4 +358,11 @@ union wqcfg {
 #define WQCFG_OFFSET(idxd_dev, n, ofs) ((idxd_dev)->wqcfg_offset +\
 					(n) * sizeof(union wqcfg) +\
 					sizeof(u32) * (ofs))
+
+enum idxd_wq_hw_state {
+	IDXD_WQ_DEV_DISABLED = 0,
+	IDXD_WQ_DEV_ENABLED,
+	IDXD_WQ_DEV_BUSY,
+};
+
 #endif
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
index b4eace02199e..df99d0bce5e9 100644
--- a/drivers/dma/idxd/vdev.c
+++ b/drivers/dma/idxd/vdev.c
@@ -81,6 +81,18 @@ static void vidxd_report_error(struct vdcm_idxd *vidxd, unsigned int error)
 	}
 }
 
+static int idxd_get_mdev_pasid(struct mdev_device *mdev)
+{
+	struct iommu_domain *domain;
+	struct device *dev = mdev_dev(mdev);
+
+	domain = mdev_get_iommu_domain(dev);
+	if (!domain)
+		return -EINVAL;
+
+	return iommu_aux_get_pasid(domain, dev->parent);
+}
+
 int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size)
 {
 	u32 offset = pos & (vidxd->bar_size[0] - 1);
@@ -474,15 +486,395 @@ void vidxd_mmio_init(struct vdcm_idxd *vidxd)
 
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
+static void vidxd_alloc_int_handle(struct vdcm_idxd *vidxd, int vidx)
+{
+	bool ims = (vidx >> 16) & 1;
+	u32 cmdsts;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	vidx = vidx & 0xffff;
+
+	dev_dbg(dev, "allocating int handle for %x\n", vidx);
+
+	if (vidx != 1) {
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_INVAL_INT_IDX);
+		return;
+	}
+
+	if (ims) {
+		dev_warn(dev, "IMS allocation is not implemented yet\n");
+		idxd_complete_command(vidxd, IDXD_CMDSTS_ERR_NO_HANDLE);
+	} else {
+		vidx--; /* MSIX idx 0 is a slow path interrupt */
+		cmdsts = vidxd->ims_index[vidx] << 8;
+		dev_dbg(dev, "int handle %d:%lld\n", vidx, vidxd->ims_index[vidx]);
+		idxd_complete_command(vidxd, cmdsts);
+	}
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
+	wqcfg = &wq->wqcfg;
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
+	wq_pasid = idxd_get_mdev_pasid(mdev);
+	priv = 1;
+
+	if (wq_pasid >= 0) {
+		wqcfg->bits[2] &= ~0x3fffff00;
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
+	default:
+		idxd_complete_command(vidxd, IDXD_CMDSTS_INVAL_CMD);
+		break;
+	}
 }

