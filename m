Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5168E38D265
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhEVAVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:21:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:45248 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230478AbhEVAVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:21:34 -0400
IronPort-SDR: u9yCGp7K0GzHsDPNXF0DqAYkhZccbhmVSiE9Dx8NMSvcLNMOcG+38ntPjw8/cmMeBoD4VrHqXs
 bMW7TYxCfQHw==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="188993218"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="188993218"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:43 -0700
IronPort-SDR: Eb8/oGmG+cGzbFFUPLMwo9QQ3/Q57LR7j5KjEN5sYmxbVE4jhbN/OHWHLurAgK0xSig/VuNAGN
 1rAhe+UzdWjQ==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="631991805"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:42 -0700
Subject: [PATCH v6 06/20] vfio/mdev: idxd: add PCI config for read/write for
 mdev
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:19:42 -0700
Message-ID: <162164278223.261970.13253077604552916351.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mediated device will emulate the PCI config access (read/write)
from the guest. Add PCI config read/write functions to support
the config read/write accesses from the guest.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/registers.h    |    4 +
 drivers/vfio/mdev/Kconfig       |    9 +
 drivers/vfio/mdev/Makefile      |    1 
 drivers/vfio/mdev/idxd/Makefile |    4 +
 drivers/vfio/mdev/idxd/mdev.h   |   76 ++++++++++++
 drivers/vfio/mdev/idxd/vdev.c   |  255 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/idxd.h       |    1 
 7 files changed, 350 insertions(+)
 create mode 100644 drivers/vfio/mdev/idxd/Makefile
 create mode 100644 drivers/vfio/mdev/idxd/mdev.h
 create mode 100644 drivers/vfio/mdev/idxd/vdev.c

diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index c970c3f025f0..c699c72bd8d2 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -155,6 +155,7 @@ enum idxd_device_reset_type {
 #define IDXD_INTC_CMD			0x02
 #define IDXD_INTC_OCCUPY			0x04
 #define IDXD_INTC_PERFMON_OVFL		0x08
+#define IDXD_INTC_HALT			0x10
 
 #define IDXD_CMD_OFFSET			0xa0
 union idxd_command_reg {
@@ -279,6 +280,9 @@ union msix_perm {
 	u32 bits;
 } __packed;
 
+#define MSIX_ENTRY_MASK_INT	0x1
+#define MSIX_ENTRY_CTRL_BYTE	12
+
 union group_flags {
 	struct {
 		u32 tc_a:3;
diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
index 82f79d99a7db..57f89457e9a7 100644
--- a/drivers/vfio/mdev/Kconfig
+++ b/drivers/vfio/mdev/Kconfig
@@ -21,3 +21,12 @@ config VFIO_MDEV_IRQS
 	  devices.
 
 	  If you don't know what to do here, say N.
+
+config VFIO_MDEV_IDXD
+	tristate "VFIO Mediated device driver for Intel IDXD"
+	depends on VFIO && VFIO_MDEV && X86_64
+	select VFIO_MDEV_IMS
+	select IMS_MSI_ARRAY
+	default n
+	help
+	  VFIO based mediated device driver for Intel Accelerator Devices driver.
diff --git a/drivers/vfio/mdev/Makefile b/drivers/vfio/mdev/Makefile
index c3f160cae192..7e3f5fae4bf1 100644
--- a/drivers/vfio/mdev/Makefile
+++ b/drivers/vfio/mdev/Makefile
@@ -6,3 +6,4 @@ mdev-$(CONFIG_VFIO_MDEV_IRQS) += mdev_irqs.o
 
 obj-$(CONFIG_VFIO_MDEV) += mdev.o
 
+obj-$(CONFIG_VFIO_MDEV_IDXD) += idxd/
diff --git a/drivers/vfio/mdev/idxd/Makefile b/drivers/vfio/mdev/idxd/Makefile
new file mode 100644
index 000000000000..ccd3bc1c7ab6
--- /dev/null
+++ b/drivers/vfio/mdev/idxd/Makefile
@@ -0,0 +1,4 @@
+ccflags-y += -I$(srctree)/drivers/dma/idxd -DDEFAULT_SYMBOL_NAMESPACE=IDXD
+
+obj-$(CONFIG_VFIO_MDEV_IDXD) += idxd_mdev.o
+idxd_mdev-y := vdev.o
diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
new file mode 100644
index 000000000000..120c2dc29ba7
--- /dev/null
+++ b/drivers/vfio/mdev/idxd/mdev.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2020 Intel Corporation. All rights rsvd. */
+
+#ifndef _IDXD_MDEV_H_
+#define _IDXD_MDEV_H_
+
+/* two 64-bit BARs implemented */
+#define VIDXD_MAX_BARS			2
+#define VIDXD_MAX_CFG_SPACE_SZ		4096
+#define VIDXD_MAX_MMIO_SPACE_SZ		8192
+#define VIDXD_MSIX_TBL_SZ_OFFSET	0x42
+#define VIDXD_CAP_CTRL_SZ		0x100
+#define VIDXD_GRP_CTRL_SZ		0x100
+#define VIDXD_WQ_CTRL_SZ		0x100
+#define VIDXD_WQ_OCPY_INT_SZ		0x20
+#define VIDXD_MSIX_TBL_SZ		0x90
+#define VIDXD_MSIX_PERM_TBL_SZ		0x48
+
+#define VIDXD_MSIX_PERM_OFFSET		0x300
+#define VIDXD_GRPCFG_OFFSET		0x400
+#define VIDXD_WQCFG_OFFSET		0x500
+#define VIDXD_MSIX_TABLE_OFFSET		0x600
+#define VIDXD_MSIX_PBA_OFFSET		0x700
+#define VIDXD_IMS_OFFSET		0x1000
+
+#define VIDXD_BAR0_SIZE			0x2000
+#define VIDXD_BAR2_SIZE			0x2000
+#define VIDXD_MAX_MSIX_VECS		2
+#define VIDXD_MAX_MSIX_ENTRIES		VIDXD_MAX_MSIX_VECS
+#define VIDXD_MAX_WQS			1
+
+struct vdcm_idxd {
+	struct idxd_device *idxd;
+	struct idxd_wq *wq;
+	struct mdev_device *mdev;
+	int num_wqs;
+
+	u64 bar_val[VIDXD_MAX_BARS];
+	u64 bar_size[VIDXD_MAX_BARS];
+	u8 cfg[VIDXD_MAX_CFG_SPACE_SZ];
+	u8 bar0[VIDXD_MAX_MMIO_SPACE_SZ];
+	struct mutex dev_lock; /* lock for vidxd resources */
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
+static inline u8 vidxd_state(struct vdcm_idxd *vidxd)
+{
+	union gensts_reg *gensts = (union gensts_reg *)(vidxd->bar0 + IDXD_GENSTATS_OFFSET);
+
+	return gensts->state;
+}
+
+int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count);
+int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size);
+#endif
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
new file mode 100644
index 000000000000..aca4a1228a97
--- /dev/null
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -0,0 +1,255 @@
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
+#include "mdev.h"
+
+void vidxd_send_interrupt(struct vdcm_idxd *vidxd, int vector)
+{
+	struct mdev_device *mdev = vidxd->mdev;
+	u8 *bar0 = vidxd->bar0;
+	u8 *msix_entry = &bar0[VIDXD_MSIX_TABLE_OFFSET + vector * 0x10];
+	u64 *pba = (u64 *)(bar0 + VIDXD_MSIX_PBA_OFFSET);
+	u8 ctrl;
+
+	ctrl = msix_entry[MSIX_ENTRY_CTRL_BYTE];
+	if (ctrl & MSIX_ENTRY_MASK_INT)
+		set_bit(vector, (unsigned long *)pba);
+	else
+		mdev_msix_send_signal(mdev, vector);
+}
+
+static void vidxd_set_swerr(struct vdcm_idxd *vidxd, unsigned int error)
+{
+	union sw_err_reg *swerr = (union sw_err_reg *)(vidxd->bar0 + IDXD_SWERR_OFFSET);
+
+	if (!swerr->valid) {
+		memset(swerr, 0, sizeof(*swerr));
+		swerr->valid = 1;
+		swerr->error = error;
+	} else if (!swerr->overflow) {
+		swerr->overflow = 1;
+	}
+}
+
+static inline void send_swerr_interrupt(struct vdcm_idxd *vidxd)
+{
+	union genctrl_reg *genctrl = (union genctrl_reg *)(vidxd->bar0 + IDXD_GENCTRL_OFFSET);
+	u32 *intcause = (u32 *)(vidxd->bar0 + IDXD_INTCAUSE_OFFSET);
+
+	if (!genctrl->softerr_int_en)
+		return;
+
+	*intcause |= IDXD_INTC_ERR;
+	vidxd_send_interrupt(vidxd, 0);
+}
+
+static inline void send_halt_interrupt(struct vdcm_idxd *vidxd)
+{
+	union genctrl_reg *genctrl = (union genctrl_reg *)(vidxd->bar0 + IDXD_GENCTRL_OFFSET);
+	u32 *intcause = (u32 *)(vidxd->bar0 + IDXD_INTCAUSE_OFFSET);
+
+	if (!genctrl->halt_int_en)
+		return;
+
+	*intcause |= IDXD_INTC_HALT;
+	vidxd_send_interrupt(vidxd, 0);
+}
+
+static void vidxd_report_pci_error(struct vdcm_idxd *vidxd)
+{
+	union gensts_reg *gensts = (union gensts_reg *)(vidxd->bar0 + IDXD_GENSTATS_OFFSET);
+
+	vidxd_set_swerr(vidxd, DSA_ERR_PCI_CFG);
+	/* set device to halt */
+	gensts->reset_type = IDXD_DEVICE_RESET_FLR;
+	gensts->state = IDXD_DEVICE_STATE_HALT;
+
+	send_halt_interrupt(vidxd);
+}
+
+int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count)
+{
+	u32 offset = pos & 0xfff;
+	struct device *dev = &vidxd->mdev->dev;
+
+	memcpy(buf, &vidxd->cfg[offset], count);
+
+	dev_dbg(dev, "vidxd pci R %d %x %x: %llx\n",
+		vidxd->wq->id, count, offset, get_reg_val(buf, count));
+
+	return 0;
+}
+
+/*
+ * Much of the emulation code has been borrowed from Intel i915 cfg space
+ * emulation code.
+ * drivers/gpu/drm/i915/gvt/cfg_space.c:
+ */
+
+/*
+ * Bitmap for writable bits (RW or RW1C bits, but cannot co-exist in one
+ * byte) byte by byte in standard pci configuration space. (not the full
+ * 256 bytes.)
+ */
+static const u8 pci_cfg_space_rw_bmp[PCI_INTERRUPT_LINE + 4] = {
+	[PCI_COMMAND]		= 0xff, 0x07,
+	[PCI_STATUS]		= 0x00, 0xf9, /* the only one RW1C byte */
+	[PCI_CACHE_LINE_SIZE]	= 0xff,
+	[PCI_BASE_ADDRESS_0 ... PCI_CARDBUS_CIS - 1] = 0xff,
+	[PCI_ROM_ADDRESS]	= 0x01, 0xf8, 0xff, 0xff,
+	[PCI_INTERRUPT_LINE]	= 0xff,
+};
+
+static void _pci_cfg_mem_write(struct vdcm_idxd *vidxd, unsigned int off, u8 *src,
+			       unsigned int bytes)
+{
+	u8 *cfg_base = vidxd->cfg;
+	u8 mask, new, old;
+	int i = 0;
+
+	for (; i < bytes && (off + i < sizeof(pci_cfg_space_rw_bmp)); i++) {
+		mask = pci_cfg_space_rw_bmp[off + i];
+		old = cfg_base[off + i];
+		new = src[i] & mask;
+
+		/**
+		 * The PCI_STATUS high byte has RW1C bits, here
+		 * emulates clear by writing 1 for these bits.
+		 * Writing a 0b to RW1C bits has no effect.
+		 */
+		if (off + i == PCI_STATUS + 1)
+			new = (~new & old) & mask;
+
+		cfg_base[off + i] = (old & ~mask) | new;
+	}
+
+	/* For other configuration space directly copy as it is. */
+	if (i < bytes)
+		memcpy(cfg_base + off + i, src + i, bytes - i);
+}
+
+static inline void _write_pci_bar(struct vdcm_idxd *vidxd, u32 offset, u32 val, bool low)
+{
+	u32 *pval;
+
+	/* BAR offset should be 32 bits algiend */
+	offset = rounddown(offset, 4);
+	pval = (u32 *)(vidxd->cfg + offset);
+
+	if (low) {
+		/*
+		 * only update bit 31 - bit 4,
+		 * leave the bit 3 - bit 0 unchanged.
+		 */
+		*pval = (val & GENMASK(31, 4)) | (*pval & GENMASK(3, 0));
+	} else {
+		*pval = val;
+	}
+}
+
+static int _pci_cfg_bar_write(struct vdcm_idxd *vidxd, unsigned int offset, void *p_data,
+			      unsigned int bytes)
+{
+	u32 new = *(u32 *)(p_data);
+	bool lo = IS_ALIGNED(offset, 8);
+	u64 size;
+	unsigned int bar_id;
+
+	/*
+	 * Power-up software can determine how much address
+	 * space the device requires by writing a value of
+	 * all 1's to the register and then reading the value
+	 * back. The device will return 0's in all don't-care
+	 * address bits.
+	 */
+	if (new == 0xffffffff) {
+		switch (offset) {
+		case PCI_BASE_ADDRESS_0:
+		case PCI_BASE_ADDRESS_1:
+		case PCI_BASE_ADDRESS_2:
+		case PCI_BASE_ADDRESS_3:
+			bar_id = (offset - PCI_BASE_ADDRESS_0) / 8;
+			size = vidxd->bar_size[bar_id];
+			_write_pci_bar(vidxd, offset, size >> (lo ? 0 : 32), lo);
+			break;
+		default:
+			/* Unimplemented BARs */
+			_write_pci_bar(vidxd, offset, 0x0, false);
+		}
+	} else {
+		switch (offset) {
+		case PCI_BASE_ADDRESS_0:
+		case PCI_BASE_ADDRESS_1:
+		case PCI_BASE_ADDRESS_2:
+		case PCI_BASE_ADDRESS_3:
+			_write_pci_bar(vidxd, offset, new, lo);
+			break;
+		default:
+			break;
+		}
+	}
+	return 0;
+}
+
+int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size)
+{
+	struct device *dev = &vidxd->idxd->pdev->dev;
+
+	if (size > 4)
+		return -EINVAL;
+
+	if (pos + size > VIDXD_MAX_CFG_SPACE_SZ)
+		return -EINVAL;
+
+	dev_dbg(dev, "vidxd pci W %d %x %x: %llx\n", vidxd->wq->id, size, pos,
+		get_reg_val(buf, size));
+
+	/* First check if it's PCI_COMMAND */
+	if (IS_ALIGNED(pos, 2) && pos == PCI_COMMAND) {
+		bool new_bme;
+		bool bme;
+
+		if (size > 2)
+			return -EINVAL;
+
+		new_bme = !!(get_reg_val(buf, 2) & PCI_COMMAND_MASTER);
+		bme = !!(vidxd->cfg[pos] & PCI_COMMAND_MASTER);
+		_pci_cfg_mem_write(vidxd, pos, buf, size);
+
+		/* Flag error if turning off BME while device is enabled */
+		if ((bme && !new_bme) && vidxd_state(vidxd) == IDXD_DEVICE_STATE_ENABLED)
+			vidxd_report_pci_error(vidxd);
+		return 0;
+	}
+
+	switch (pos) {
+	case PCI_BASE_ADDRESS_0 ... PCI_BASE_ADDRESS_5:
+		if (!IS_ALIGNED(pos, 4))
+			return -EINVAL;
+		return _pci_cfg_bar_write(vidxd, pos, buf, size);
+
+	default:
+		_pci_cfg_mem_write(vidxd, pos, buf, size);
+	}
+	return 0;
+}
+
+MODULE_LICENSE("GPL v2");
diff --git a/include/uapi/linux/idxd.h b/include/uapi/linux/idxd.h
index e33997b4d750..751f6107217c 100644
--- a/include/uapi/linux/idxd.h
+++ b/include/uapi/linux/idxd.h
@@ -89,6 +89,7 @@ enum dsa_completion_status {
 	DSA_COMP_HW_ERR1,
 	DSA_COMP_HW_ERR_DRB,
 	DSA_COMP_TRANSLATION_FAIL,
+	DSA_ERR_PCI_CFG = 0x51,
 };
 
 enum iax_completion_status {


