Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BB91B335D
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 01:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgDUXe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 19:34:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:36000 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgDUXe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 19:34:58 -0400
IronPort-SDR: nQxz2siVnq6U5jfEJ6lYrNfbk3goRjfrwLQmiMaLDtKbw4+4E+DD7FbAZTyhy3NnMeElgXnYq3
 90vAkjJX5Diw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:34:57 -0700
IronPort-SDR: ZJmjtUUbcxGue18s2Ks9zSrgfRaeub7hlTKbqDKmzcFFNV/DSQhrPt2L2rN1SpJVJ6r9/tWBYA
 mvfERpA1QQBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="429701097"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga005.jf.intel.com with ESMTP; 21 Apr 2020 16:34:56 -0700
Subject: [PATCH RFC 11/15] dmaengine: idxd: add IMS support in base driver
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Apr 2020 16:34:55 -0700
Message-ID: <158751209583.36773.15917761221672315662.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for support of VFIO mediated device for idxd driver, the
enabling for Interrupt Message Store (IMS) interrupts is added for the idxd
base driver. Until now, the maximum number of interrupts a device could
support was 2048 (MSI-X). With IMS, the maximum number of interrupts can be
significantly expanded for guest support. This commit only provides the
support functions in the base driver and not the VFIO mdev code
utilization.

See Intel SIOV spec for more details:
https://software.intel.com/en-us/download/intel-scalable-io-virtualization-technical-specification

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/Kconfig       |    1 
 drivers/dma/idxd/Makefile |    2 -
 drivers/dma/idxd/cdev.c   |    3 +
 drivers/dma/idxd/idxd.h   |   21 ++++-
 drivers/dma/idxd/init.c   |   46 +++++++++++-
 drivers/dma/idxd/mdev.c   |  179 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/mdev.h   |   82 +++++++++++++++++++++
 drivers/dma/idxd/submit.c |    3 +
 drivers/dma/idxd/sysfs.c  |   11 +++
 9 files changed, 340 insertions(+), 8 deletions(-)
 create mode 100644 drivers/dma/idxd/mdev.c
 create mode 100644 drivers/dma/idxd/mdev.h

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 71ea9f24a8f9..9e7d9eafb1f5 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -290,6 +290,7 @@ config INTEL_IDXD
 	select PCI_PRI
 	select PCI_PASID
 	select PCI_IOV
+	select MSI_IMS
 	help
 	  Enable support for the Intel(R) data accelerators present
 	  in Intel Xeon CPU.
diff --git a/drivers/dma/idxd/Makefile b/drivers/dma/idxd/Makefile
index 8978b898d777..308e12869f96 100644
--- a/drivers/dma/idxd/Makefile
+++ b/drivers/dma/idxd/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_INTEL_IDXD) += idxd.o
-idxd-y := init.o irq.o device.o sysfs.o submit.o dma.o cdev.o
+idxd-y := init.o irq.o device.o sysfs.o submit.o dma.o cdev.o mdev.o
diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 27be9250606d..ddd3ce16620d 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -186,7 +186,8 @@ static int idxd_cdev_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_WIPEONFORK;
 	pfn = (base + idxd_get_wq_portal_full_offset(wq->id,
-				IDXD_PORTAL_LIMITED)) >> PAGE_SHIFT;
+				IDXD_PORTAL_LIMITED,
+				IDXD_IRQ_MSIX)) >> PAGE_SHIFT;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_private_data = ctx;
 
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 82a9b6035722..3a942e9c5980 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -172,6 +172,7 @@ struct idxd_device {
 
 	int num_groups;
 
+	u32 ims_offset;
 	u32 msix_perm_offset;
 	u32 wqcfg_offset;
 	u32 grpcfg_offset;
@@ -179,6 +180,7 @@ struct idxd_device {
 
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
+	int ims_size;
 	int max_groups;
 	int max_engines;
 	int max_tokens;
@@ -194,6 +196,9 @@ struct idxd_device {
 	struct idxd_irq_entry *irq_entries;
 
 	struct dma_device dma_dev;
+
+	atomic_t num_allocated_ims;
+	struct sbitmap ims_sbmap;
 };
 
 /* IDXD software descriptor */
@@ -224,15 +229,23 @@ enum idxd_portal_prot {
 	IDXD_PORTAL_LIMITED,
 };
 
-static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot)
+enum idxd_interrupt_type {
+	IDXD_IRQ_MSIX = 0,
+	IDXD_IRQ_IMS,
+};
+
+static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot,
+					    enum idxd_interrupt_type irq_type)
 {
-	return prot * 0x1000;
+	return prot * 0x1000 + irq_type * 0x2000;
 }
 
 static inline int idxd_get_wq_portal_full_offset(int wq_id,
-						 enum idxd_portal_prot prot)
+						 enum idxd_portal_prot prot,
+						 enum idxd_interrupt_type irq_type)
 {
-	return ((wq_id * 4) << PAGE_SHIFT) + idxd_get_wq_portal_offset(prot);
+	return ((wq_id * 4) << PAGE_SHIFT) +
+		idxd_get_wq_portal_offset(prot, irq_type);
 }
 
 static inline void idxd_set_type(struct idxd_device *idxd)
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index c0fd796e9dce..15b3ef73cac3 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -231,10 +231,42 @@ static void idxd_read_table_offsets(struct idxd_device *idxd)
 	idxd->msix_perm_offset = offsets.msix_perm * 0x100;
 	dev_dbg(dev, "IDXD MSIX Permission Offset: %#x\n",
 		idxd->msix_perm_offset);
+	idxd->ims_offset = offsets.ims * 0x100;
+	dev_dbg(dev, "IDXD IMS Offset: %#x\n", idxd->ims_offset);
 	idxd->perfmon_offset = offsets.perfmon * 0x100;
 	dev_dbg(dev, "IDXD Perfmon Offset: %#x\n", idxd->perfmon_offset);
 }
 
+static int device_supports_ims(struct pci_dev *pdev)
+{
+	int dvsec;
+	u16 val16;
+	u32 val32;
+
+	dvsec = pci_find_ext_capability(pdev, 0x23);
+	pci_read_config_word(pdev, dvsec + 0x4, &val16);
+	if (val16 != 0x8086) {
+		dev_dbg(&pdev->dev, "DVSEC vendor id is not Intel\n");
+		return -EOPNOTSUPP;
+	}
+
+	pci_read_config_word(pdev, dvsec + 0x8, &val16);
+	if (val16 != 0x5) {
+		dev_dbg(&pdev->dev, "DVSEC ID is not SIOV\n");
+		return -EOPNOTSUPP;
+	}
+
+	pci_read_config_dword(pdev, dvsec + 0x14, &val32);
+	if (val32 & 0x1) {
+		dev_dbg(&pdev->dev, "IMS supported for device\n");
+		return 0;
+	}
+
+	dev_dbg(&pdev->dev, "IMS unsupported for device\n");
+
+	return -EOPNOTSUPP;
+}
+
 static void idxd_read_caps(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
@@ -247,9 +279,11 @@ static void idxd_read_caps(struct idxd_device *idxd)
 	dev_dbg(dev, "max xfer size: %llu bytes\n", idxd->max_xfer_bytes);
 	idxd->max_batch_size = 1U << idxd->hw.gen_cap.max_batch_shift;
 	dev_dbg(dev, "max batch size: %u\n", idxd->max_batch_size);
+	if (device_supports_ims(idxd->pdev) == 0)
+		idxd->ims_size = idxd->hw.gen_cap.max_ims_mult * 256ULL;
+	dev_dbg(dev, "IMS size: %u\n", idxd->ims_size);
 	if (idxd->hw.gen_cap.config_en)
 		set_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags);
-
 	/* reading group capabilities */
 	idxd->hw.group_cap.bits =
 		ioread64(idxd->reg_base + IDXD_GRPCAP_OFFSET);
@@ -294,6 +328,7 @@ static struct idxd_device *idxd_alloc(struct pci_dev *pdev)
 
 	idxd->pdev = pdev;
 	spin_lock_init(&idxd->dev_lock);
+	atomic_set(&idxd->num_allocated_ims, 0);
 
 	return idxd;
 }
@@ -389,9 +424,18 @@ static int idxd_probe(struct idxd_device *idxd)
 
 	idxd->major = idxd_cdev_get_major(idxd);
 
+	rc = sbitmap_init_node(&idxd->ims_sbmap, idxd->ims_size, -1,
+			       GFP_KERNEL, dev_to_node(dev));
+	if (rc < 0)
+		goto sbitmap_fail;
+
 	dev_dbg(dev, "IDXD device %d probed successfully\n", idxd->id);
 	return 0;
 
+ sbitmap_fail:
+	mutex_lock(&idxd_idr_lock);
+	idr_remove(&idxd_idrs[idxd->type], idxd->id);
+	mutex_unlock(&idxd_idr_lock);
  err_idr_fail:
 	idxd_mask_error_interrupts(idxd);
 	idxd_mask_msix_vectors(idxd);
diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
new file mode 100644
index 000000000000..2cf0cdf149b7
--- /dev/null
+++ b/drivers/dma/idxd/mdev.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/msi.h>
+#include <linux/mdev.h>
+#include <linux/vfio.h>
+#include "../../vfio/pci/vfio_pci_private.h"
+#include <uapi/linux/idxd.h>
+#include "registers.h"
+#include "idxd.h"
+#include "mdev.h"
+
+static void idxd_free_ims_index(struct idxd_device *idxd,
+				unsigned long ims_idx)
+{
+	sbitmap_clear_bit(&idxd->ims_sbmap, ims_idx);
+	atomic_dec(&idxd->num_allocated_ims);
+}
+
+static int vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	struct ims_irq_entry *irq_entry;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct msi_desc *desc;
+	int i = 0;
+	struct platform_msi_group_entry *platform_msi_group;
+
+	for_each_platform_msi_entry_in_group(desc, platform_msi_group, 0, dev) {
+		irq_entry = &vidxd->irq_entries[i];
+		devm_free_irq(dev, desc->irq, irq_entry);
+		i++;
+	}
+
+	platform_msi_domain_free_irqs(dev);
+
+	for (i = 0; i < vidxd->num_wqs; i++)
+		idxd_free_ims_index(idxd, vidxd->ims_index[i]);
+	return 0;
+}
+
+static int idxd_alloc_ims_index(struct idxd_device *idxd)
+{
+	int index;
+
+	index = sbitmap_get(&idxd->ims_sbmap, 0, false);
+	if (index < 0)
+		return -ENOSPC;
+	return index;
+}
+
+static unsigned int idxd_ims_irq_mask(struct msi_desc *desc)
+{
+	int ims_offset;
+	u32 mask_bits = desc->platform.masked;
+	struct device *dev = desc->dev;
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct idxd_device *idxd = vidxd->idxd;
+	void __iomem *base;
+	int ims_id = desc->platform.msi_index;
+
+	dev_dbg(dev, "idxd irq mask: %d\n", ims_id);
+
+	mask_bits |= PCI_MSIX_ENTRY_CTRL_MASKBIT;
+	ims_offset = idxd->ims_offset + vidxd->ims_index[ims_id] * 0x10;
+	base = idxd->reg_base + ims_offset;
+	iowrite32(mask_bits, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
+
+	return mask_bits;
+}
+
+static unsigned int idxd_ims_irq_unmask(struct msi_desc *desc)
+{
+	int ims_offset;
+	u32 mask_bits = desc->platform.masked;
+	struct device *dev = desc->dev;
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct idxd_device *idxd = vidxd->idxd;
+	void __iomem *base;
+	int ims_id = desc->platform.msi_index;
+
+	dev_dbg(dev, "idxd irq unmask: %d\n", ims_id);
+
+	mask_bits &= ~PCI_MSIX_ENTRY_CTRL_MASKBIT;
+	ims_offset = idxd->ims_offset + vidxd->ims_index[ims_id] * 0x10;
+	base = idxd->reg_base + ims_offset;
+	iowrite32(mask_bits, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
+
+	return mask_bits;
+}
+
+static void idxd_ims_write_msg(struct msi_desc *desc, struct msi_msg *msg)
+{
+	int ims_offset;
+	struct device *dev = desc->dev;
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct idxd_device *idxd = vidxd->idxd;
+	void __iomem *base;
+	int ims_id = desc->platform.msi_index;
+
+	dev_dbg(dev, "ims_write: %d %x\n", ims_id, msg->address_lo);
+
+	ims_offset = idxd->ims_offset + vidxd->ims_index[ims_id] * 0x10;
+	base = idxd->reg_base + ims_offset;
+	iowrite32(msg->address_lo, base + PCI_MSIX_ENTRY_LOWER_ADDR);
+	iowrite32(msg->address_hi, base + PCI_MSIX_ENTRY_UPPER_ADDR);
+	iowrite32(msg->data, base + PCI_MSIX_ENTRY_DATA);
+}
+
+static struct platform_msi_ops idxd_ims_ops  = {
+	.irq_mask		= idxd_ims_irq_mask,
+	.irq_unmask		= idxd_ims_irq_unmask,
+	.write_msg		= idxd_ims_write_msg,
+};
+
+static irqreturn_t idxd_guest_wq_completion_interrupt(int irq, void *data)
+{
+	/* send virtual interrupt */
+	return IRQ_HANDLED;
+}
+
+static int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	struct ims_irq_entry *irq_entry;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct msi_desc *desc;
+	int err, i = 0;
+	int group;
+	struct platform_msi_group_entry *platform_msi_group;
+
+	if (!atomic_add_unless(&idxd->num_allocated_ims, vidxd->num_wqs,
+			       idxd->ims_size))
+		return -ENOSPC;
+
+	vidxd->ims_index[0] = idxd_alloc_ims_index(idxd);
+
+	err = platform_msi_domain_alloc_irqs_group(dev, vidxd->num_wqs,
+						   &idxd_ims_ops, &group);
+	if (err < 0) {
+		dev_dbg(dev, "Enabling IMS entry! %d\n", err);
+		return err;
+	}
+
+	i = 0;
+	for_each_platform_msi_entry_in_group(desc, platform_msi_group, group, dev) {
+		irq_entry = &vidxd->irq_entries[i];
+		irq_entry->vidxd = vidxd;
+		irq_entry->int_src = i;
+		err = devm_request_irq(dev, desc->irq,
+				       idxd_guest_wq_completion_interrupt, 0,
+				       "idxd-ims", irq_entry);
+		if (err)
+			break;
+		i++;
+	}
+
+	if (err) {
+		i = 0;
+		for_each_platform_msi_entry_in_group(desc, platform_msi_group, group, dev) {
+			irq_entry = &vidxd->irq_entries[i];
+			devm_free_irq(dev, desc->irq, irq_entry);
+			i++;
+		}
+		platform_msi_domain_free_irqs_group(dev, group);
+	}
+
+	return 0;
+}
diff --git a/drivers/dma/idxd/mdev.h b/drivers/dma/idxd/mdev.h
new file mode 100644
index 000000000000..5b05b6cb2b7b
--- /dev/null
+++ b/drivers/dma/idxd/mdev.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2019 Intel Corporation. All rights rsvd. */
+
+#ifndef _IDXD_MDEV_H_
+#define _IDXD_MDEV_H_
+
+/* two 64-bit BARs implemented */
+#define VIDXD_MAX_BARS 2
+#define VIDXD_MAX_CFG_SPACE_SZ 4096
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
+
+#define	VIDXD_ATS_OFFSET 0x100
+#define	VIDXD_PRS_OFFSET 0x110
+#define VIDXD_PASID_OFFSET 0x120
+#define VIDXD_MSIX_PBA_OFFSET 0x700
+
+struct vdcm_idxd_pci_bar0 {
+	u8 cap_ctrl_regs[VIDXD_CAP_CTRL_SZ];
+	u8 grp_ctrl_regs[VIDXD_GRP_CTRL_SZ];
+	u8 wq_ctrl_regs[VIDXD_WQ_CTRL_SZ];
+	u8 wq_ocpy_int_regs[VIDXD_WQ_OCPY_INT_SZ];
+	u8 msix_table[VIDXD_MSIX_TBL_SZ];
+	u8 msix_perm_table[VIDXD_MSIX_PERM_TBL_SZ];
+	unsigned long msix_pba;
+};
+
+struct ims_irq_entry {
+	struct vdcm_idxd *vidxd;
+	int int_src;
+};
+
+struct idxd_vdev {
+	struct mdev_device *mdev;
+	struct eventfd_ctx *msix_trigger[VIDXD_MAX_MSIX_ENTRIES];
+	struct notifier_block group_notifier;
+	struct kvm *kvm;
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
+	unsigned long handle;
+	u64 ims_index[VIDXD_MAX_WQS];
+	struct msix_entry ims_entry;
+	struct ims_irq_entry irq_entries[VIDXD_MAX_WQS];
+
+	/* For VM use case */
+	u64 bar_val[VIDXD_MAX_BARS];
+	u64 bar_size[VIDXD_MAX_BARS];
+	u8 cfg[VIDXD_MAX_CFG_SPACE_SZ];
+	struct vdcm_idxd_pci_bar0 bar0;
+	struct list_head list;
+};
+
+static inline struct vdcm_idxd *to_vidxd(struct idxd_vdev *vdev)
+{
+	return container_of(vdev, struct vdcm_idxd, vdev);
+}
+
+#endif
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 741bc3aa7267..bdcac933bb28 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -123,7 +123,8 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc,
 		return -EIO;
 
 	portal = wq->portal +
-		 idxd_get_wq_portal_offset(IDXD_PORTAL_UNLIMITED);
+		 idxd_get_wq_portal_offset(IDXD_PORTAL_UNLIMITED,
+					   IDXD_IRQ_MSIX);
 	if (wq_dedicated(wq)) {
 		/*
 		 * The wmb() flushes writes to coherent DMA data before
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 1dd3ade2e438..07bad4f6c7fb 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1282,6 +1282,16 @@ static ssize_t numa_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t ims_size_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct idxd_device *idxd =
+		container_of(dev, struct idxd_device, conf_dev);
+
+	return sprintf(buf, "%u\n", idxd->ims_size);
+}
+static DEVICE_ATTR_RO(ims_size);
+
 static ssize_t max_batch_size_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1467,6 +1477,7 @@ static struct attribute *idxd_device_attributes[] = {
 	&dev_attr_max_work_queues_size.attr,
 	&dev_attr_max_engines.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_ims_size.attr,
 	&dev_attr_max_batch_size.attr,
 	&dev_attr_max_transfer_size.attr,
 	&dev_attr_op_cap.attr,

