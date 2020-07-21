Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426542284B1
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgGUQD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:03:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:35066 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbgGUQD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:03:56 -0400
IronPort-SDR: IkDxihq4sFVhBpu0oUT4xZ3vRJYe2T2oxm+XXugJQ8VEoH7fcVSX/Q57x++x89l7XHo1vwAb6b
 xtFIIl1ZmEHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="235019338"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="235019338"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:03:44 -0700
IronPort-SDR: TbQmM6QJK1TY8Upp2xDxQXhNIQ2dVdqFM8BiRJGD3v9de8WoGxfSkxdKyxfi2hiqj7h5tdPcXU
 HW4+G/zm6bTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="318379937"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008.jf.intel.com with ESMTP; 21 Jul 2020 09:03:40 -0700
Subject: [PATCH RFC v2 13/18] dmaengine: idxd: ims setup for the vdcm
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
Date:   Tue, 21 Jul 2020 09:03:40 -0700
Message-ID: <159534742073.28840.5432268637638647551.stgit@djiang5-desk3.ch.intel.com>
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

Add support for IMS enabling on the mediated device.

On the actual hardware the MSIX vector 0 is misc interrupt and handles
events such as administrative command completion, error reporting,
performance monitor overflow, and etc. The MSIX vectors 1...N
are used for descriptor completion interrupts. On the guest kernel,
the MSIX interrupts are backed by the mediated device through emulation
or IMS vectors. Vector 0 is handled through emulation by the host vdcm.
The vector 1 (and more may be supported later) is backed by IMS. IMS can
be setup with interrupt handlers via request_irq() just like MSIX
interrupts once the relevant IRQ domain is set with
dev_msi_domain_alloc_irqs().

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/dma/Kconfig     |    1 
 drivers/dma/idxd/ims.c  |  142 +++++++++++++++++++++++++++++++++++++++++------
 drivers/dma/idxd/ims.h  |    7 ++
 drivers/dma/idxd/vdev.c |   76 +++++++++++++++++++++----
 4 files changed, 195 insertions(+), 31 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 69c1ae72df86..a19e5dbeab9b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -311,6 +311,7 @@ config INTEL_IDXD_MDEV
 	depends on INTEL_IDXD
 	depends on VFIO_MDEV
 	depends on VFIO_MDEV_DEVICE
+	depends on DEV_MSI
 
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
diff --git a/drivers/dma/idxd/ims.c b/drivers/dma/idxd/ims.c
index bffc74c2b305..f9b7fbcb61df 100644
--- a/drivers/dma/idxd/ims.c
+++ b/drivers/dma/idxd/ims.c
@@ -7,22 +7,13 @@
 #include <linux/device.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/msi.h>
+#include <linux/mdev.h>
 #include <uapi/linux/idxd.h>
 #include "registers.h"
 #include "idxd.h"
 #include "mdev.h"
-
-int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
-{
-	/* PLACEHOLDER */
-	return 0;
-}
-
-int vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
-{
-	/* PLACEHOLDER */
-	return 0;
-}
+#include "ims.h"
+#include "vdev.h"
 
 static void idxd_free_ims_index(struct idxd_device *idxd,
 				unsigned long ims_idx)
@@ -42,21 +33,65 @@ static int idxd_alloc_ims_index(struct idxd_device *idxd)
 
 static unsigned int idxd_ims_irq_mask(struct msi_desc *desc)
 {
-	// Filled out later when VDCM is introduced.
+	int ims_offset;
+	u32 mask_bits;
+	struct device *dev = desc->dev;
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct idxd_device *idxd = vidxd->idxd;
+	void __iomem *base;
+	int ims_id = desc->platform.msi_index;
 
-	return 0;
+	dev_dbg(dev, "idxd irq mask: %d\n", ims_id);
+
+	ims_offset = idxd->ims_offset + vidxd->ims_index[ims_id] * 0x10;
+	base = idxd->reg_base + ims_offset;
+	mask_bits = ioread32(base + IMS_ENTRY_VECTOR_CTRL);
+	mask_bits |= IMS_ENTRY_CTRL_MASKBIT;
+	iowrite32(mask_bits, base + IMS_ENTRY_VECTOR_CTRL);
+
+	return mask_bits;
 }
 
 static unsigned int idxd_ims_irq_unmask(struct msi_desc *desc)
 {
-	// Filled out later when VDCM is introduced.
+	int ims_offset;
+	u32 mask_bits;
+	struct device *dev = desc->dev;
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
+	struct idxd_device *idxd = vidxd->idxd;
+	void __iomem *base;
+	int ims_id = desc->platform.msi_index;
 
-	return 0;
+	dev_dbg(dev, "idxd irq unmask: %d\n", ims_id);
+
+	ims_offset = idxd->ims_offset + vidxd->ims_index[ims_id] * 0x10;
+	base = idxd->reg_base + ims_offset;
+	mask_bits = ioread32(base + IMS_ENTRY_VECTOR_CTRL);
+	mask_bits &= ~IMS_ENTRY_CTRL_MASKBIT;
+	iowrite32(mask_bits, base + IMS_ENTRY_VECTOR_CTRL);
+
+	return mask_bits;
 }
 
 static void idxd_ims_write_msg(struct msi_desc *desc, struct msi_msg *msg)
 {
-	// Filled out later when VDCM is introduced.
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
+	iowrite32(msg->address_lo, base + IMS_ENTRY_LOWER_ADDR);
+	iowrite32(msg->address_hi, base + IMS_ENTRY_UPPER_ADDR);
+	iowrite32(msg->data, base + IMS_ENTRY_DATA);
 }
 
 static struct platform_msi_ops idxd_ims_ops  = {
@@ -64,3 +99,76 @@ static struct platform_msi_ops idxd_ims_ops  = {
 	.irq_unmask		= idxd_ims_irq_unmask,
 	.write_msg		= idxd_ims_write_msg,
 };
+
+int vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	struct ims_irq_entry *irq_entry;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct msi_desc *desc;
+	int i = 0;
+
+	for_each_msi_entry(desc, dev) {
+		irq_entry = &vidxd->irq_entries[i];
+		/*
+		 * When qemu dies unexpectedly, it does not call VFIO_IRQ_SET_DATA_NONE ioctl
+		 * to free up the interrupts. We need to free the interrupts here as clean up
+		 * if they haven't been freed.
+		 */
+		if (irq_entry->irq_set)
+			free_irq(irq_entry->irq, irq_entry);
+		idxd_free_ims_index(idxd, vidxd->ims_index[i]);
+		vidxd->ims_index[i] = -1;
+		memset(irq_entry, 0, sizeof(*irq_entry));
+		i++;
+	}
+
+	dev_msi_domain_free_irqs(dev);
+	return 0;
+}
+
+int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
+{
+	struct idxd_device *idxd = vidxd->idxd;
+	struct ims_irq_entry *irq_entry;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct msi_desc *desc;
+	int err, i = 0;
+	int index;
+
+	/*
+	 * MSIX vec 0 is emulated by the vdcm and does not take up an IMS. The total MSIX vecs used
+	 * by the mdev will be total IMS + 1. vec 0 is used for misc interrupts such as command
+	 * completion, error notification, PMU, etc. The other vectors are used for descriptor
+	 * completion. Thus only the number of IMS vectors need to be allocated, which is
+	 * VIDXD_MAX_MSIX_VECS - 1.
+	 */
+	err = dev_msi_domain_alloc_irqs(dev, VIDXD_MAX_MSIX_VECS - 1, &idxd_ims_ops);
+	if (err < 0) {
+		dev_dbg(dev, "Enabling IMS entry! %d\n", err);
+		return err;
+	}
+
+	i = 0;
+	for_each_msi_entry(desc, dev) {
+		index = idxd_alloc_ims_index(idxd);
+		if (index < 0) {
+			err = index;
+			break;
+		}
+		vidxd->ims_index[i] = index;
+
+		irq_entry = &vidxd->irq_entries[i];
+		irq_entry->vidxd = vidxd;
+		irq_entry->int_src = i;
+		irq_entry->irq = desc->irq;
+		i++;
+	}
+
+	if (err)
+		vidxd_free_ims_entries(vidxd);
+
+	return 0;
+}
diff --git a/drivers/dma/idxd/ims.h b/drivers/dma/idxd/ims.h
index 3d823606e3a3..97826abf1163 100644
--- a/drivers/dma/idxd/ims.h
+++ b/drivers/dma/idxd/ims.h
@@ -4,6 +4,13 @@
 #ifndef _IDXD_IMS_H_
 #define _IDXD_IMS_H_
 
+/* IMS entry format */
+#define IMS_ENTRY_LOWER_ADDR    0  /* Message Address */
+#define IMS_ENTRY_UPPER_ADDR    4  /* Message Upper Address */
+#define IMS_ENTRY_DATA          8  /* Message Data */
+#define IMS_ENTRY_VECTOR_CTRL   12 /* Vector Control */
+#define IMS_ENTRY_CTRL_MASKBIT  0x00000001
+
 int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd);
 int vidxd_free_ims_entries(struct vdcm_idxd *vidxd);
 
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
index df99d0bce5e9..66e59cb02635 100644
--- a/drivers/dma/idxd/vdev.c
+++ b/drivers/dma/idxd/vdev.c
@@ -44,15 +44,75 @@ int vidxd_send_interrupt(struct vdcm_idxd *vidxd, int msix_idx)
 	return rc;
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
+#define IMS_PASID_ENABLE	0x8
 int vidxd_disable_host_ims_pasid(struct vdcm_idxd *vidxd, int ims_idx)
 {
-	/* PLACEHOLDER */
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	unsigned int ims_offset;
+	struct idxd_device *idxd = vidxd->idxd;
+	u32 val;
+
+	/*
+	 * Current implementation limits to 1 WQ for the vdev and therefore
+	 * also only 1 IMS interrupt for that vdev.
+	 */
+	if (ims_idx >= VIDXD_MAX_WQS) {
+		dev_warn(dev, "ims_idx greater than vidxd allowed: %d\n", ims_idx);
+		return -EINVAL;
+	}
+
+	ims_offset = idxd->ims_offset + vidxd->ims_index[ims_idx] * 0x10;
+	val = ioread32(idxd->reg_base + ims_offset + 12);
+	val &= ~IMS_PASID_ENABLE;
+	iowrite32(val, idxd->reg_base + ims_offset + 12);
+
 	return 0;
 }
 
 int vidxd_enable_host_ims_pasid(struct vdcm_idxd *vidxd, int ims_idx)
 {
-	/* PLACEHOLDER */
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	int pasid;
+	unsigned int ims_offset;
+	struct idxd_device *idxd = vidxd->idxd;
+	u32 val;
+
+	/*
+	 * Current implementation limits to 1 WQ for the vdev and therefore
+	 * also only 1 IMS interrupt for that vdev.
+	 */
+	if (ims_idx >= VIDXD_MAX_WQS) {
+		dev_warn(dev, "ims_idx greater than vidxd allowed: %d\n", ims_idx);
+		return -EINVAL;
+	}
+
+	/* Setup the PASID filtering */
+	pasid = idxd_get_mdev_pasid(mdev);
+
+	if (pasid >= 0) {
+		ims_offset = idxd->ims_offset + vidxd->ims_index[ims_idx] * 0x10;
+		val = ioread32(idxd->reg_base + ims_offset + 12);
+		val |= IMS_PASID_ENABLE | (pasid << 12) | (val & 0x7);
+		iowrite32(val, idxd->reg_base + ims_offset + 12);
+	} else {
+		dev_warn(dev, "pasid setup failed for ims entry %lld\n", vidxd->ims_index[ims_idx]);
+		return -ENXIO;
+	}
+
 	return 0;
 }
 
@@ -81,18 +141,6 @@ static void vidxd_report_error(struct vdcm_idxd *vidxd, unsigned int error)
 	}
 }
 
-static int idxd_get_mdev_pasid(struct mdev_device *mdev)
-{
-	struct iommu_domain *domain;
-	struct device *dev = mdev_dev(mdev);
-
-	domain = mdev_get_iommu_domain(dev);
-	if (!domain)
-		return -EINVAL;
-
-	return iommu_aux_get_pasid(domain, dev->parent);
-}
-
 int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size)
 {
 	u32 offset = pos & (vidxd->bar_size[0] - 1);

