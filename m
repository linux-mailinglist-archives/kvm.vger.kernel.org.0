Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E488338D262
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhEVAVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:21:42 -0400
Received: from mga06.intel.com ([134.134.136.31]:50235 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhEVAV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:21:26 -0400
IronPort-SDR: z3Ivjb9gm0NXXq82lehPsnGJsoJ5JLZ27h2uLFcXWugFWBJyZb3/HvAxmZUKHn4NoXnd8E6u9u
 vEhswLWXmVGA==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="262818140"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="262818140"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:02 -0700
IronPort-SDR: T2uzjo7HAO8glCKV/sYwZjVQ5R2W8fIwzRVf1kRQbkcXbbNDzWtDAqPK3gTS8Tq5qgIFREuROQ
 83cTQgKzOGAg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="441312120"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:20:01 -0700
Subject: [PATCH v6 09/20] vfio/mdev: Add mmio read/write support for mdev
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:20:01 -0700
Message-ID: <162164280156.261970.13755411310924589194.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The BAR0 MMIO path for the mdev is emulated. Add read/write support
functions to deal with MMIO access when the guest read/write to
the device. The support functions deals with the BAR0 MMIO region
of the mdev.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/device.c     |    1 
 drivers/dma/idxd/registers.h  |    6 ++
 drivers/vfio/mdev/idxd/mdev.h |    3 +
 drivers/vfio/mdev/idxd/vdev.c |  119 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/idxd.h     |    1 
 5 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 99542c9cbc47..2ea6015e0d53 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -277,6 +277,7 @@ void idxd_wq_drain(struct idxd_wq *wq)
 	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
 	idxd_cmd_exec(idxd, IDXD_CMD_DRAIN_WQ, operand, NULL);
 }
+EXPORT_SYMBOL_GPL(idxd_wq_drain);
 
 void idxd_wq_reset(struct idxd_wq *wq)
 {
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index 8ac2be4e174b..cf3d513a18e0 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -201,7 +201,9 @@ union cmdsts_reg {
 	};
 	u32 bits;
 } __packed;
-#define IDXD_CMDSTS_ACTIVE		0x80000000
+
+#define IDXD_CMDS_ACTIVE_BIT		31
+#define IDXD_CMDSTS_ACTIVE		BIT(IDXD_CMDS_ACTIVE_BIT)
 #define IDXD_CMDSTS_ERR_MASK		0xff
 #define IDXD_CMDSTS_RES_SHIFT		8
 
@@ -285,6 +287,8 @@ union msix_perm {
 	u32 bits;
 } __packed;
 
+#define IDXD_MSIX_PERM_MASK	0xfffff00c
+#define IDXD_MSIX_PERM_IGNORE	0x3
 #define MSIX_ENTRY_MASK_INT	0x1
 #define MSIX_ENTRY_CTRL_BYTE	12
 
diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
index 91cb2662abd6..f696fe38e374 100644
--- a/drivers/vfio/mdev/idxd/mdev.h
+++ b/drivers/vfio/mdev/idxd/mdev.h
@@ -80,4 +80,7 @@ void vidxd_reset(struct vdcm_idxd *vidxd);
 void vidxd_mmio_init(struct vdcm_idxd *vidxd);
 int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count);
 int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size);
+int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
+int vidxd_mmio_read(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
+
 #endif
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
index 78cc2377e637..d2416765ce7e 100644
--- a/drivers/vfio/mdev/idxd/vdev.c
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -42,6 +42,8 @@ static u64 idxd_pci_config[] = {
 	0x0000000000000000ULL,
 };
 
+static void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val);
+
 static void vidxd_reset_config(struct vdcm_idxd *vidxd)
 {
 	u16 *devid = (u16 *)(vidxd->cfg + PCI_DEVICE_ID);
@@ -141,6 +143,123 @@ static void vidxd_report_pci_error(struct vdcm_idxd *vidxd)
 	send_halt_interrupt(vidxd);
 }
 
+static void vidxd_report_swerror(struct vdcm_idxd *vidxd, unsigned int error)
+{
+	vidxd_set_swerr(vidxd, error);
+	send_swerr_interrupt(vidxd);
+}
+
+int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size)
+{
+	u32 offset = pos & (vidxd->bar_size[0] - 1);
+	u8 *bar0 = vidxd->bar0;
+	struct device *dev = &vidxd->mdev->dev;
+
+	dev_dbg(dev, "vidxd mmio W %d %x %x: %llx\n", vidxd->wq->id, size,
+		offset, get_reg_val(buf, size));
+
+	if (((size & (size - 1)) != 0) || (offset & (size - 1)) != 0)
+		return -EINVAL;
+
+	/* If we don't limit this, we potentially can write out of bound */
+	if (size > sizeof(u32))
+		return -EINVAL;
+
+	switch (offset) {
+	case IDXD_GENCFG_OFFSET ... IDXD_GENCFG_OFFSET + 3:
+		/* Write only when device is disabled. */
+		if (vidxd_state(vidxd) == IDXD_DEVICE_STATE_DISABLED) {
+			dev_warn(dev, "Guest writes to unsupported GENCFG register\n");
+			memcpy(bar0 + offset, buf, size);
+		}
+		break;
+
+	case IDXD_GENCTRL_OFFSET:
+		memcpy(bar0 + offset, buf, size);
+		break;
+
+	case IDXD_INTCAUSE_OFFSET:
+		bar0[offset] &= ~(get_reg_val(buf, 1) & GENMASK(4, 0));
+		break;
+
+	case IDXD_CMD_OFFSET: {
+		u32 *cmdsts = (u32 *)(bar0 + IDXD_CMDSTS_OFFSET);
+		u32 val = get_reg_val(buf, size);
+
+		if (size != sizeof(u32))
+			return -EINVAL;
+
+		/* Check and set command in progress */
+		if (test_and_set_bit(IDXD_CMDS_ACTIVE_BIT, (unsigned long *)cmdsts) == 0)
+			vidxd_do_command(vidxd, val);
+		else
+			vidxd_report_swerror(vidxd, DSA_ERR_CMD_REG);
+		break;
+	}
+
+	case IDXD_SWERR_OFFSET:
+		/* W1C */
+		bar0[offset] &= ~(get_reg_val(buf, 1) & GENMASK(1, 0));
+		break;
+
+	case VIDXD_MSIX_TABLE_OFFSET ...  VIDXD_MSIX_TABLE_OFFSET + VIDXD_MSIX_TBL_SZ - 1: {
+		int index = (offset - VIDXD_MSIX_TABLE_OFFSET) / 0x10;
+		u8 *msix_entry = &bar0[VIDXD_MSIX_TABLE_OFFSET + index * 0x10];
+		u64 *pba = (u64 *)(bar0 + VIDXD_MSIX_PBA_OFFSET);
+		u8 ctrl, new_mask;
+		int ims_index, ims_off;
+		u32 ims_ctrl, ims_mask;
+		struct idxd_device *idxd = vidxd->idxd;
+
+		memcpy(bar0 + offset, buf, size);
+		ctrl = msix_entry[MSIX_ENTRY_CTRL_BYTE];
+
+		new_mask = ctrl & MSIX_ENTRY_MASK_INT;
+		if (!new_mask && test_and_clear_bit(index, (unsigned long *)pba))
+			vidxd_send_interrupt(vidxd, index);
+
+		if (index == 0)
+			break;
+
+		ims_index = dev_msi_hwirq(dev, index - 1);
+		ims_off = idxd->ims_offset + ims_index * 16 + sizeof(u64);
+		ims_ctrl = ioread32(idxd->reg_base + ims_off);
+		ims_mask = ims_ctrl & MSIX_ENTRY_MASK_INT;
+
+		if (new_mask == ims_mask)
+			break;
+
+		if (new_mask)
+			ims_ctrl |= MSIX_ENTRY_MASK_INT;
+		else
+			ims_ctrl &= ~MSIX_ENTRY_MASK_INT;
+
+		iowrite32(ims_ctrl, idxd->reg_base + ims_off);
+		/* readback to flush */
+		ims_ctrl = ioread32(idxd->reg_base + ims_off);
+		break;
+	}
+
+	case VIDXD_MSIX_PERM_OFFSET ...  VIDXD_MSIX_PERM_OFFSET + VIDXD_MSIX_PERM_TBL_SZ - 1:
+		memcpy(bar0 + offset, buf, size);
+		break;
+	} /* offset */
+
+	return 0;
+}
+
+int vidxd_mmio_read(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size)
+{
+	u32 offset = pos & (vidxd->bar_size[0] - 1);
+	struct device *dev = &vidxd->mdev->dev;
+
+	memcpy(buf, vidxd->bar0 + offset, size);
+
+	dev_dbg(dev, "vidxd mmio R %d %x %x: %llx\n",
+		vidxd->wq->id, size, offset, get_reg_val(buf, size));
+	return 0;
+}
+
 int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count)
 {
 	u32 offset = pos & 0xfff;
diff --git a/include/uapi/linux/idxd.h b/include/uapi/linux/idxd.h
index 751f6107217c..e8c39849a526 100644
--- a/include/uapi/linux/idxd.h
+++ b/include/uapi/linux/idxd.h
@@ -90,6 +90,7 @@ enum dsa_completion_status {
 	DSA_COMP_HW_ERR_DRB,
 	DSA_COMP_TRANSLATION_FAIL,
 	DSA_ERR_PCI_CFG = 0x51,
+	DSA_ERR_CMD_REG,
 };
 
 enum iax_completion_status {


