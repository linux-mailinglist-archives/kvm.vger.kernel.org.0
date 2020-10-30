Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CA729FCF0
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 06:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgJ3FFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 01:05:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:5284 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgJ3FFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 01:05:18 -0400
IronPort-SDR: ofJOcxAEqW0WvP/D0dqXVwPWv5kLqmdIg6rEEXiJbnXehLrhiUWYk/6uTyja+hHsZN9QpU2Fma
 iFAIGTAxMjhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="230196561"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="230196561"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 22:05:17 -0700
IronPort-SDR: c0LjjbkhtGJE0422erJnF8lBxfFhbe9z+5t6K5lZqzHttYEVLedTcAg8wTIB/OYKcZQirgv8Ln
 C3q1J4KYWivA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="425261567"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2020 22:05:14 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 4/5] iommu/vt-d: Add iommu_ops support for subdevice bus
Date:   Fri, 30 Oct 2020 12:58:08 +0800
Message-Id: <20201030045809.957927-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030045809.957927-1-baolu.lu@linux.intel.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu_ops will only take effect when INTEL_IOMMU_SCALABLE_IOV kernel
option is selected. It applies to any device passthrough framework which
implements an underlying bus for the subdevices.

- Subdevice probe:
  When a subdevice is created and added to the bus, iommu_probe_device()
  will be called, where the device will be probed by the iommu core. An
  iommu group will be allocated and the device will be added to it. The
  default domain won't be allocated since there's no use case of using a
  subdevice in the host kernel at this time being. However, it's pretty
  easy to add this support later.

- Domain alloc/free/map/unmap/iova_to_phys operations:
  For such ops, we just reuse those for PCI/PCIe devices.

- Domain attach/detach operations:
  It depends on whether the parent device supports IOMMU_DEV_FEAT_AUX
  feature. If so, the domain will be attached to the parent device as an
  aux-domain; Otherwise, it will be attached to the parent as a primary
  domain.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/Kconfig  |  13 ++++
 drivers/iommu/intel/Makefile |   1 +
 drivers/iommu/intel/iommu.c  |   5 ++
 drivers/iommu/intel/siov.c   | 119 +++++++++++++++++++++++++++++++++++
 include/linux/intel-iommu.h  |   4 ++
 5 files changed, 142 insertions(+)
 create mode 100644 drivers/iommu/intel/siov.c

diff --git a/drivers/iommu/intel/Kconfig b/drivers/iommu/intel/Kconfig
index 28a3d1596c76..94edc332f558 100644
--- a/drivers/iommu/intel/Kconfig
+++ b/drivers/iommu/intel/Kconfig
@@ -86,3 +86,16 @@ config INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON
 	  is not selected, scalable mode support could also be enabled by
 	  passing intel_iommu=sm_on to the kernel. If not sure, please use
 	  the default value.
+
+config INTEL_IOMMU_SCALABLE_IOV
+	bool "Support for Intel Scalable I/O Virtualization"
+	depends on INTEL_IOMMU
+	select VFIO
+	select VFIO_MDEV
+	select VFIO_MDEV_DEVICE
+	help
+	  Intel Scalable I/O virtualization (SIOV) is a hardware-assisted
+	  PCIe subdevices virtualization. With each subdevice tagged with
+	  an unique ID(PCI/PASID) the VT-d hardware could identify, hence
+	  isolate DMA transactions from different subdevices on a same PCIe
+	  device. Selecting this option will enable the support.
diff --git a/drivers/iommu/intel/Makefile b/drivers/iommu/intel/Makefile
index fb8e1e8c8029..f216385d5d59 100644
--- a/drivers/iommu/intel/Makefile
+++ b/drivers/iommu/intel/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_INTEL_IOMMU) += iommu.o pasid.o
 obj-$(CONFIG_INTEL_IOMMU) += trace.o
 obj-$(CONFIG_INTEL_IOMMU_DEBUGFS) += debugfs.o
 obj-$(CONFIG_INTEL_IOMMU_SVM) += svm.o
+obj-$(CONFIG_INTEL_IOMMU_SCALABLE_IOV) += siov.o
 obj-$(CONFIG_IRQ_REMAP) += irq_remapping.o
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 1454fe74f3ba..dafd8069c2af 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4298,6 +4298,11 @@ int __init intel_iommu_init(void)
 	up_read(&dmar_global_lock);
 
 	bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
+
+#ifdef CONFIG_INTEL_IOMMU_SCALABLE_IOV
+	intel_siov_init();
+#endif /* CONFIG_INTEL_IOMMU_SCALABLE_IOV */
+
 	if (si_domain && !hw_pass_through)
 		register_memory_notifier(&intel_iommu_memory_nb);
 	cpuhp_setup_state(CPUHP_IOMMU_INTEL_DEAD, "iommu/intel:dead", NULL,
diff --git a/drivers/iommu/intel/siov.c b/drivers/iommu/intel/siov.c
new file mode 100644
index 000000000000..b9470e7ab3d6
--- /dev/null
+++ b/drivers/iommu/intel/siov.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * siov.c - Intel Scalable I/O virtualization support
+ *
+ * Copyright (C) 2020 Intel Corporation
+ *
+ * Author: Lu Baolu <baolu.lu@linux.intel.com>
+ */
+
+#define pr_fmt(fmt)	"DMAR: " fmt
+
+#include <linux/intel-iommu.h>
+#include <linux/iommu.h>
+#include <linux/mdev.h>
+#include <linux/pci.h>
+
+static struct device *subdev_lookup_parent(struct device *dev)
+{
+	if (dev->bus == &mdev_bus_type)
+		return mdev_parent_dev(mdev_from_dev(dev));
+
+	return NULL;
+}
+
+static struct iommu_domain *siov_iommu_domain_alloc(unsigned int type)
+{
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
+
+	return intel_iommu_domain_alloc(type);
+}
+
+static int siov_iommu_attach_device(struct iommu_domain *domain,
+				    struct device *dev)
+{
+	struct device *parent;
+
+	parent = subdev_lookup_parent(dev);
+	if (!parent || !dev_is_pci(parent))
+		return -ENODEV;
+
+	if (iommu_dev_feature_enabled(parent, IOMMU_DEV_FEAT_AUX))
+		return intel_iommu_aux_attach_device(domain, parent);
+	else
+		return intel_iommu_attach_device(domain, parent);
+}
+
+static void siov_iommu_detach_device(struct iommu_domain *domain,
+				     struct device *dev)
+{
+	struct device *parent;
+
+	parent = subdev_lookup_parent(dev);
+	if (WARN_ON_ONCE(!parent || !dev_is_pci(parent)))
+		return;
+
+	if (iommu_dev_feature_enabled(parent, IOMMU_DEV_FEAT_AUX))
+		intel_iommu_aux_detach_device(domain, parent);
+	else
+		intel_iommu_detach_device(domain, parent);
+}
+
+static struct iommu_device *siov_iommu_probe_device(struct device *dev)
+{
+	struct intel_iommu *iommu;
+	struct device *parent;
+
+	parent = subdev_lookup_parent(dev);
+	if (!parent || !dev_is_pci(parent))
+		return ERR_PTR(-EINVAL);
+
+	iommu = device_to_iommu(parent, NULL, NULL);
+	if (!iommu)
+		return ERR_PTR(-ENODEV);
+
+	return &iommu->iommu;
+}
+
+static void siov_iommu_release_device(struct device *dev)
+{
+}
+
+static void
+siov_iommu_get_resv_regions(struct device *dev, struct list_head *head)
+{
+	struct device *parent;
+
+	parent = subdev_lookup_parent(dev);
+	if (!parent || !dev_is_pci(parent))
+		return;
+
+	intel_iommu_get_resv_regions(parent, head);
+}
+
+static const struct iommu_ops siov_iommu_ops = {
+	.capable		= intel_iommu_capable,
+	.domain_alloc		= siov_iommu_domain_alloc,
+	.domain_free		= intel_iommu_domain_free,
+	.attach_dev		= siov_iommu_attach_device,
+	.detach_dev		= siov_iommu_detach_device,
+	.map			= intel_iommu_map,
+	.unmap			= intel_iommu_unmap,
+	.iova_to_phys		= intel_iommu_iova_to_phys,
+	.probe_device		= siov_iommu_probe_device,
+	.release_device		= siov_iommu_release_device,
+	.get_resv_regions	= siov_iommu_get_resv_regions,
+	.put_resv_regions	= generic_iommu_put_resv_regions,
+	.device_group		= generic_device_group,
+	.pgsize_bitmap		= (~0xFFFUL),
+};
+
+void intel_siov_init(void)
+{
+	if (!scalable_mode_support() || !iommu_pasid_support())
+		return;
+
+	bus_set_iommu(&mdev_bus_type, &siov_iommu_ops);
+	pr_info("Intel(R) Scalable I/O Virtualization supported\n");
+}
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index d3928ba87986..b790efa5509f 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -787,6 +787,10 @@ size_t intel_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova);
 void intel_iommu_get_resv_regions(struct device *device, struct list_head *head);
 
+#ifdef CONFIG_INTEL_IOMMU_SCALABLE_IOV
+void intel_siov_init(void);
+#endif /* INTEL_IOMMU_SCALABLE_IOV */
+
 #ifdef CONFIG_INTEL_IOMMU_SVM
 extern void intel_svm_check(struct intel_iommu *iommu);
 extern int intel_svm_enable_prq(struct intel_iommu *iommu);
-- 
2.25.1

