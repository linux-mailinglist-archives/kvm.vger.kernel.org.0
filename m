Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6AE311304
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 22:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhBETUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 14:20:36 -0500
Received: from mga06.intel.com ([134.134.136.31]:64265 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233624AbhBETMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 14:12:23 -0500
IronPort-SDR: nSM3jjjnIHSyg+twsxOtU+94OWxV7dMkmlGzwNpS7tY2f5uYUaGb4RFMTheMcoD63hmyP/3cvP
 E28yeMro4nSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="242990281"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="242990281"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:54:05 -0800
IronPort-SDR: PajqOwiDjXskbWiMWCMobc+aQEjlgmErAdbdO33UjwDDoBectEaet4CLZreXZshgOBDvDjUI6J
 VFq2av9VA1zA==
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="357820056"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 12:54:04 -0800
Subject: [PATCH v5 11/14] vfio/mdev: idxd: ims setup for the vdcm
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
Date:   Fri, 05 Feb 2021 13:54:04 -0700
Message-ID: <161255844433.339900.3136365210231233047.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
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

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/idxd.h       |    1 +
 drivers/vfio/mdev/idxd/mdev.c |   12 +++++++++
 drivers/vfio/mdev/idxd/vdev.c |   53 ++++++++++++++++++++++++++++++++---------
 kernel/irq/msi.c              |    2 ++
 4 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 41eee987c9b7..c5ef6ccc9ba6 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -224,6 +224,7 @@ struct idxd_device {
 	struct workqueue_struct *wq;
 	struct work_struct work;
 
+	struct irq_domain *ims_domain;
 	int *int_handles;
 
 	struct auxiliary_device *mdev_auxdev;
diff --git a/drivers/vfio/mdev/idxd/mdev.c b/drivers/vfio/mdev/idxd/mdev.c
index 7cde707021db..8a4af882a47f 100644
--- a/drivers/vfio/mdev/idxd/mdev.c
+++ b/drivers/vfio/mdev/idxd/mdev.c
@@ -1167,6 +1167,7 @@ static int alloc_supported_types(struct idxd_device *idxd)
 int idxd_mdev_host_init(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
+	struct ims_array_info ims_info;
 	int rc;
 
 	if (!test_bit(IDXD_FLAG_IMS_SUPPORTED, &idxd->flags))
@@ -1188,6 +1189,15 @@ int idxd_mdev_host_init(struct idxd_device *idxd)
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
 
@@ -1196,6 +1206,8 @@ void idxd_mdev_host_release(struct idxd_device *idxd)
 	struct device *dev = &idxd->pdev->dev;
 	int rc;
 
+	irq_domain_remove(idxd->ims_domain);
+
 	mdev_unregister_device(dev);
 	if (iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_AUX)) {
 		rc = iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
diff --git a/drivers/vfio/mdev/idxd/vdev.c b/drivers/vfio/mdev/idxd/vdev.c
index 766fd98e9eea..8626438a9e54 100644
--- a/drivers/vfio/mdev/idxd/vdev.c
+++ b/drivers/vfio/mdev/idxd/vdev.c
@@ -16,6 +16,7 @@
 #include <linux/intel-svm.h>
 #include <linux/kvm_host.h>
 #include <linux/eventfd.h>
+#include <linux/irqchip/irq-ims-msi.h>
 #include <uapi/linux/idxd.h>
 #include "registers.h"
 #include "idxd.h"
@@ -871,6 +872,47 @@ static void vidxd_wq_disable(struct vdcm_idxd *vidxd, int wq_id_mask)
 	idxd_complete_command(vidxd, IDXD_CMDSTS_SUCCESS);
 }
 
+void vidxd_free_ims_entries(struct vdcm_idxd *vidxd)
+{
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+
+	msi_domain_free_irqs(dev_get_msi_domain(dev), dev);
+}
+
+int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd)
+{
+	struct irq_domain *irq_domain;
+	struct idxd_device *idxd = vidxd->idxd;
+	struct mdev_device *mdev = vidxd->vdev.mdev;
+	struct device *dev = mdev_dev(mdev);
+	struct msi_desc *entry;
+	struct ims_irq_entry *irq_entry;
+	int rc, i;
+
+	irq_domain = idxd->ims_domain;
+	dev_set_msi_domain(dev, irq_domain);
+
+	/* We are allocate MAX_MSIX - 1 is because vector 0 is emulated and not IMS backed. */
+	rc = msi_domain_alloc_irqs(irq_domain, dev, VIDXD_MAX_MSIX_VECS - 1);
+	if (rc < 0)
+		return rc;
+	/*
+	 * The first MSIX vector on the guest is emulated and not backed by IMS. To make matters
+	 * simple the ims entries include the emulated vector. Here the code starts at index
+	 * 1 to setup all the IMS backed vectors.
+	 */
+	i = 1;
+	for_each_msi_entry(entry, dev) {
+		irq_entry = &vidxd->irq_entries[i];
+		irq_entry->ims_idx = entry->device_msi.hwirq;
+		irq_entry->irq = entry->irq;
+		i++;
+	}
+
+	return 0;
+}
+
 static bool command_supported(struct vdcm_idxd *vidxd, u32 cmd)
 {
 	struct idxd_device *idxd = vidxd->idxd;
@@ -938,14 +980,3 @@ void vidxd_do_command(struct vdcm_idxd *vidxd, u32 val)
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
index d70d92eac322..d95299b4ae79 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -536,6 +536,7 @@ int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 
 	return ops->domain_alloc_irqs(domain, dev, nvec);
 }
+EXPORT_SYMBOL_GPL(msi_domain_alloc_irqs);
 
 void __msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 {
@@ -572,6 +573,7 @@ void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 
 	return ops->domain_free_irqs(domain, dev);
 }
+EXPORT_SYMBOL_GPL(msi_domain_free_irqs);
 
 /**
  * msi_get_domain_info - Get the MSI interrupt domain info for @domain


