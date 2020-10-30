Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE882A0E04
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbgJ3Swe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:52:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:29382 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgJ3Swa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:30 -0400
IronPort-SDR: MB+ja8NbqjsD28m+jdPYr/8c5zhIloVt7n5ftJZxNbp1amNl4rT/975kcu3GZeD4cPFFhxR2LT
 abxaQhdtkQCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="165153569"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="165153569"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:21 -0700
IronPort-SDR: 8srn9ldgkqzLxGgWXcY3yuJG2bqUVkhuCw8vHEQkPahsbwyj3hpaSnGdbQeL1QfFkSABskFcBn
 vNroNpvCtf0w==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="527210204"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:52:19 -0700
Subject: [PATCH v4 13/17] dmaengine: idxd: ims setup for the vdcm
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
Cc:     Megha Dey <megha.dey@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 30 Oct 2020 11:52:19 -0700
Message-ID: <160408393950.912050.6095700006969517668.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add setup for IMS enabling for the mediated device.

On the actual hardware the MSIX vector 0 is misc interrupt and
handles events such as administrative command completion, error
reporting, performance monitor overflow, and etc. The MSIX vectors
1...N are used for descriptor completion interrupts. On the guest
kernel, the MSIX interrupts are backed by the mediated device through
emulation or IMS vectors. Vector 0 is handled through emulation by
the host vdcm. The vector 1 (and more may be supported later) is
backed by IMS.

IMS can be setup with interrupt handlers via request_irq() just like
MSIX interrupts once the relevant IRQ domain is set.

The msi_domain_alloc_irqs()/msi_domain_free_irqs() APIs can then be
used to allocate interrupts from the above set domain.

Register with the irq bypass manager in order to allow the IMS interrupt be
injected into the guest and bypass the host.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/Kconfig     |    2 ++
 drivers/dma/idxd/idxd.h |    1 +
 drivers/dma/idxd/mdev.c |   26 +++++++++++++++++++++
 drivers/dma/idxd/mdev.h |    1 +
 drivers/dma/idxd/vdev.c |   57 ++++++++++++++++++++++++++++++++++++++---------
 kernel/irq/msi.c        |    2 ++
 6 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index c5970e4a3a2c..b0335a4321f5 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -312,6 +312,8 @@ config INTEL_IDXD_MDEV
 	depends on VFIO_MDEV
 	depends on VFIO_MDEV_DEVICE
 	select PCI_SIOV
+	select IRQ_BYPASS_MANAGER
+	select IMS_MSI_ARRAY
 
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index e616d18b53c0..72c30826f1bb 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -213,6 +213,7 @@ struct idxd_device {
 	struct workqueue_struct *wq;
 	struct work_struct work;
 
+	struct irq_domain *ims_domain;
 	int *int_handles;
 };
 
diff --git a/drivers/dma/idxd/mdev.c b/drivers/dma/idxd/mdev.c
index 91270121dfbc..ed79c85e692e 100644
--- a/drivers/dma/idxd/mdev.c
+++ b/drivers/dma/idxd/mdev.c
@@ -508,8 +508,12 @@ static int msix_trigger_unregister(struct vdcm_idxd *vidxd, int index)
 
 	dev_dbg(dev, "disable MSIX trigger %d\n", index);
 	if (index) {
+		struct irq_bypass_producer *producer;
 		u32 auxval;
 
+		producer = &vidxd->vdev.producer[index - 1];
+		irq_bypass_unregister_producer(producer);
+
 		irq_entry = &vidxd->irq_entries[index - 1];
 		if (irq_entry->irq_set) {
 			free_irq(irq_entry->entry->irq, irq_entry);
@@ -553,9 +557,11 @@ static int msix_trigger_register(struct vdcm_idxd *vidxd, u32 fd, int index)
 	 * in i - 1 to the host setup and irq_entries.
 	 */
 	if (index) {
+		struct irq_bypass_producer *producer;
 		int pasid;
 		u32 auxval;
 
+		producer = &vidxd->vdev.producer[index - 1];
 		irq_entry = &vidxd->irq_entries[index - 1];
 		pasid = idxd_mdev_get_pasid(mdev);
 		if (pasid < 0)
@@ -581,6 +587,14 @@ static int msix_trigger_register(struct vdcm_idxd *vidxd, u32 fd, int index)
 			irq_set_auxdata(irq_entry->entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
 			return rc;
 		}
+
+		producer->token = trigger;
+		producer->irq = irq_entry->entry->irq;
+		rc = irq_bypass_register_producer(producer);
+		if (unlikely(rc))
+			dev_info(dev, "irq bypass producer (token %p) registration failed: %d\n",
+				 producer->token, rc);
+
 		irq_entry->irq_set = true;
 	}
 
@@ -934,6 +948,7 @@ static const struct mdev_parent_ops idxd_vdcm_ops = {
 int idxd_mdev_host_init(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
+	struct ims_array_info ims_info;
 	int rc;
 
 	if (!test_bit(IDXD_FLAG_SIOV_SUPPORTED, &idxd->flags))
@@ -950,6 +965,15 @@ int idxd_mdev_host_init(struct idxd_device *idxd)
 		return -EOPNOTSUPP;
 	}
 
+	ims_info.max_slots = idxd->ims_size;
+	ims_info.slots = idxd->reg_base + idxd->ims_offset;
+	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
+	if (!idxd->ims_domain) {
+		dev_warn(dev, "Fail to acquire IMS domain\n");
+		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
+		return -ENODEV;
+	}
+
 	return mdev_register_device(dev, &idxd_vdcm_ops);
 }
 
@@ -958,6 +982,8 @@ void idxd_mdev_host_release(struct idxd_device *idxd)
 	struct device *dev = &idxd->pdev->dev;
 	int rc;
 
+	irq_domain_remove(idxd->ims_domain);
+
 	mdev_unregister_device(dev);
 	if (iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_AUX)) {
 		rc = iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
diff --git a/drivers/dma/idxd/mdev.h b/drivers/dma/idxd/mdev.h
index b474f2303ba0..266231987331 100644
--- a/drivers/dma/idxd/mdev.h
+++ b/drivers/dma/idxd/mdev.h
@@ -43,6 +43,7 @@ struct ims_irq_entry {
 struct idxd_vdev {
 	struct mdev_device *mdev;
 	struct eventfd_ctx *msix_trigger[VIDXD_MAX_MSIX_ENTRIES];
+	struct irq_bypass_producer producer[VIDXD_MAX_MSIX_ENTRIES];
 };
 
 struct vdcm_idxd {
diff --git a/drivers/dma/idxd/vdev.c b/drivers/dma/idxd/vdev.c
index 6e7f98d0e52f..d61bc17624b9 100644
--- a/drivers/dma/idxd/vdev.c
+++ b/drivers/dma/idxd/vdev.c
@@ -16,6 +16,7 @@
 #include <linux/intel-svm.h>
 #include <linux/kvm_host.h>
 #include <linux/eventfd.h>
+#include <linux/irqchip/irq-ims-msi.h>
 #include <uapi/linux/idxd.h>
 #include "registers.h"
 #include "idxd.h"
@@ -844,6 +845,51 @@ static void vidxd_wq_disable(struct vdcm_idxd *vidxd, int wq_id_mask)
 	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
 }
 
+void vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
+{
+	struct irq_domain *irq_domain;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	int i;
+
+	for (i = 0; i < VIDXD_MAX_MSIX_VECS; i++)
+		vidxd->irq_entries[i].entry = NULL;
+
+	irq_domain = dev_get_msi_domain(dev);
+	if (irq_domain)
+		msi_domain_free_irqs(irq_domain, dev);
+	else
+		dev_warn(dev, "No IMS irq domain.\n");
+}
+
+int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
+{
+	struct irq_domain *irq_domain;
+	struct idxd_device *idxd = vidxd->idxd;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	int vecs = VIDXD_MAX_MSIX_VECS - 1;
+	struct msi_desc *entry;
+	struct ims_irq_entry *irq_entry;
+	int rc, i = 0;
+
+	irq_domain = idxd->ims_domain;
+	dev_set_msi_domain(dev, irq_domain);
+	rc = msi_domain_alloc_irqs(irq_domain, dev, vecs);
+	if (rc < 0)
+		return rc;
+
+	for_each_msi_entry(entry, dev) {
+		irq_entry = &vidxd->irq_entries[i];
+		irq_entry->vidxd = vidxd;
+		irq_entry->entry = entry;
+		irq_entry->id = i;
+		i++;
+	}
+
+	return 0;
+}
+
 void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
 {
 	union idxd_command_reg *reg = (union idxd_command_reg *)(vidxd->bar0 + IDXD_CMD_OFFSET);
@@ -896,14 +942,3 @@ void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
 		break;
 	}
 }
-
-int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
-{
-	/* PLACEHOLDER */
-	return 0;
-}
-
-void vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
-{
-	/* PLACEHOLDER */
-}
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index c7e47c26cd90..89cf60a30803 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -536,6 +536,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 
 	return ops->domain_alloc_irqs(domain, dev, nvec);
 }
+EXPORT_SYMBOL(msi_domain_alloc_irqs);
 
 void __msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 {
@@ -572,6 +573,7 @@ void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 
 	return ops->domain_free_irqs(domain, dev);
 }
+EXPORT_SYMBOL(msi_domain_free_irqs);
 
 /**
  * msi_get_domain_info - Get the MSI interrupt domain info for @domain


