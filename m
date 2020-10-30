Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812482A0E13
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgJ3Swc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:52:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:35177 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgJ3Swa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:30 -0400
IronPort-SDR: Ytvwh/SkQwsTC6yjIfIOxlKUeESPHrt9NJQCnSxUoT1uS10PmFThfmVwgbKe8Vfak9ZKUNscti
 zPlzuT8vuqNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="147936850"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="147936850"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:33 -0700
IronPort-SDR: 9U/h/5H6+ey8Jh7kJdRLLy7240505xw+hKhlUkFhE0eePhaDPi1zHyK3SJuIJpn7uN3e/3LkqQ
 yVWOw30R+9GA==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="525974696"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:32 -0700
Subject: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
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
Date:   Fri, 30 Oct 2020 11:51:32 -0700
Message-ID: <160408389228.912050.10790556040702698268.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Scalable I/O Virtualization (SIOV) enables sharing of I/O devices
across isolated domains through PASID based sub-device partitioning.
Interrupt Message Storage (IMS) enables devices to store the interrupt
messages in a device-specific optimized manner without the scalability
restrictions of the PCIe defined MSI-X capability. IMS is one of the
features supported under SIOV.

Move SIOV detection code from Intel iommu driver code to common PCI. Making
the detection code common allows supported accelerator drivers to query the
PCI core for SIOV and IMS capabilities. The support code will add the
ability to query the PCI DVSEC capabilities for the SIOV cap.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Baolu Lu <baolu.lu@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
---
 drivers/iommu/intel/iommu.c   |   31 ++-----------------------
 drivers/pci/Kconfig           |   15 ++++++++++++
 drivers/pci/Makefile          |    2 ++
 drivers/pci/dvsec.c           |   40 +++++++++++++++++++++++++++++++++
 drivers/pci/siov.c            |   50 +++++++++++++++++++++++++++++++++++++++++
 include/linux/pci-siov.h      |   18 +++++++++++++++
 include/linux/pci.h           |    3 ++
 include/uapi/linux/pci_regs.h |    4 +++
 8 files changed, 134 insertions(+), 29 deletions(-)
 create mode 100644 drivers/pci/dvsec.c
 create mode 100644 drivers/pci/siov.c
 create mode 100644 include/linux/pci-siov.h

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3e77a88b236c..d9335f590b42 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -36,6 +36,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
+#include <linux/pci-siov.h>
 #include <linux/memblock.h>
 #include <linux/dma-map-ops.h>
 #include <linux/dma-direct.h>
@@ -5883,34 +5884,6 @@ static int intel_iommu_disable_auxd(struct device *dev)
 	return 0;
 }
 
-/*
- * A PCI express designated vendor specific extended capability is defined
- * in the section 3.7 of Intel scalable I/O virtualization technical spec
- * for system software and tools to detect endpoint devices supporting the
- * Intel scalable IO virtualization without host driver dependency.
- *
- * Returns the address of the matching extended capability structure within
- * the device's PCI configuration space or 0 if the device does not support
- * it.
- */
-static int siov_find_pci_dvsec(struct pci_dev *pdev)
-{
-	int pos;
-	u16 vendor, id;
-
-	pos = pci_find_next_ext_capability(pdev, 0, 0x23);
-	while (pos) {
-		pci_read_config_word(pdev, pos + 4, &vendor);
-		pci_read_config_word(pdev, pos + 8, &id);
-		if (vendor == PCI_VENDOR_ID_INTEL && id == 5)
-			return pos;
-
-		pos = pci_find_next_ext_capability(pdev, pos, 0x23);
-	}
-
-	return 0;
-}
-
 static bool
 intel_iommu_dev_has_feat(struct device *dev, enum iommu_dev_features feat)
 {
@@ -5925,7 +5898,7 @@ intel_iommu_dev_has_feat(struct device *dev, enum iommu_dev_features feat)
 		if (ret < 0)
 			return false;
 
-		return !!siov_find_pci_dvsec(to_pci_dev(dev));
+		return pci_siov_supported(to_pci_dev(dev));
 	}
 
 	if (feat == IOMMU_DEV_FEAT_SVA) {
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 0c473d75e625..cf7f4d17d8cc 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -161,6 +161,21 @@ config PCI_PASID
 
 	  If unsure, say N.
 
+config PCI_DVSEC
+	bool
+
+config PCI_SIOV
+	select PCI_PASID
+	select PCI_DVSEC
+	bool "PCI SIOV support"
+	help
+	  Scalable I/O Virtualzation enables sharing of I/O devices across isolated
+	  domains through PASID based sub-device partitioning. One of the sub features
+	  supported by SIOV is Inetrrupt Message Storage (IMS). Select this option if
+	  you want to compile the support into your kernel.
+
+	  If unsure, say N.
+
 config PCI_P2PDMA
 	bool "PCI peer-to-peer transfer support"
 	depends on ZONE_DEVICE
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 522d2b974e91..653a1d69b0fc 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -20,6 +20,8 @@ obj-$(CONFIG_PCI_QUIRKS)	+= quirks.o
 obj-$(CONFIG_HOTPLUG_PCI)	+= hotplug/
 obj-$(CONFIG_PCI_MSI)		+= msi.o
 obj-$(CONFIG_PCI_ATS)		+= ats.o
+obj-$(CONFIG_PCI_DVSEC)		+= dvsec.o
+obj-$(CONFIG_PCI_SIOV)		+= siov.o
 obj-$(CONFIG_PCI_IOV)		+= iov.o
 obj-$(CONFIG_PCI_BRIDGE_EMUL)	+= pci-bridge-emul.o
 obj-$(CONFIG_PCI_LABEL)		+= pci-label.o
diff --git a/drivers/pci/dvsec.c b/drivers/pci/dvsec.c
new file mode 100644
index 000000000000..e49b079f0717
--- /dev/null
+++ b/drivers/pci/dvsec.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * PCI DVSEC helper functions
+ * Copyright (C) 2020 Intel Corp.
+ */
+
+#include <linux/export.h>
+#include <linux/pci.h>
+#include <uapi/linux/pci_regs.h>
+#include "pci.h"
+
+/**
+ * pci_find_dvsec - return position of DVSEC with provided vendor and dvsec id
+ * @dev: the PCI device
+ * @vendor: Vendor for the DVSEC
+ * @id: the DVSEC cap id
+ *
+ * Return the offset of DVSEC on success or -ENOTSUPP if not found
+ */
+int pci_find_dvsec(struct pci_dev *dev, u16 vendor, u16 id)
+{
+	u16 dev_vendor, dev_id;
+	int pos;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DVSEC);
+	if (!pos)
+		return -ENOTSUPP;
+
+	while (pos) {
+		pci_read_config_word(dev, pos + PCI_DVSEC_HEADER1, &dev_vendor);
+		pci_read_config_word(dev, pos + PCI_DVSEC_HEADER2, &dev_id);
+		if (dev_vendor == vendor && dev_id == id)
+			return pos;
+
+		pos = pci_find_next_ext_capability(dev, pos, PCI_EXT_CAP_ID_DVSEC);
+	}
+
+	return -ENOTSUPP;
+}
+EXPORT_SYMBOL_GPL(pci_find_dvsec);
diff --git a/drivers/pci/siov.c b/drivers/pci/siov.c
new file mode 100644
index 000000000000..6147e6ae5832
--- /dev/null
+++ b/drivers/pci/siov.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Intel Scalable I/O Virtualization support
+ * Copyright (C) 2020 Intel Corp.
+ */
+
+#include <linux/export.h>
+#include <linux/pci.h>
+#include <linux/pci-siov.h>
+#include <uapi/linux/pci_regs.h>
+#include "pci.h"
+
+/*
+ * A PCI express designated vendor specific extended capability is defined
+ * in the section 3.7 of Intel scalable I/O virtualization technical spec
+ * for system software and tools to detect endpoint devices supporting the
+ * Intel scalable IO virtualization without host driver dependency.
+ */
+
+/**
+ * pci_siov_supported - check if the device can use SIOV
+ * @dev: the PCI device
+ *
+ * Returns true if the device supports SIOV,  false otherwise.
+ */
+bool pci_siov_supported(struct pci_dev *dev)
+{
+	return pci_find_dvsec(dev, PCI_VENDOR_ID_INTEL, PCI_DVSEC_ID_INTEL_SIOV) < 0 ? false : true;
+}
+EXPORT_SYMBOL_GPL(pci_siov_supported);
+
+/**
+ * pci_ims_supported - check if the device can use IMS
+ * @dev: the PCI device
+ *
+ * Returns true if the device supports IMS, false otherwise.
+ */
+bool pci_ims_supported(struct pci_dev *dev)
+{
+	int pos;
+	u32 caps;
+
+	pos = pci_find_dvsec(dev, PCI_VENDOR_ID_INTEL, PCI_DVSEC_ID_INTEL_SIOV);
+	if (pos < 0)
+		return false;
+
+	pci_read_config_dword(dev, pos + PCI_DVSEC_INTEL_SIOV_CAP, &caps);
+	return (caps & PCI_DVSEC_INTEL_SIOV_CAP_IMS) ? true : false;
+}
+EXPORT_SYMBOL_GPL(pci_ims_supported);
diff --git a/include/linux/pci-siov.h b/include/linux/pci-siov.h
new file mode 100644
index 000000000000..a8a4eb5f4634
--- /dev/null
+++ b/include/linux/pci-siov.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef LINUX_PCI_SIOV_H
+#define LINUX_PCI_SIOV_H
+
+#include <linux/pci.h>
+
+#ifdef CONFIG_PCI_SIOV
+/* Scalable I/O Virtualization */
+bool pci_siov_supported(struct pci_dev *dev);
+bool pci_ims_supported(struct pci_dev *dev);
+#else /* CONFIG_PCI_SIOV */
+static inline bool pci_siov_supported(struct pci_dev *d)
+{ return false; }
+static inline bool pci_ims_supported(struct pci_dev *d)
+{ return false; }
+#endif /* CONFIG_PCI_SIOV */
+
+#endif /* LINUX_PCI_SIOV_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 22207a79762c..4710f09b43b1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1070,6 +1070,7 @@ int pci_find_next_ext_capability(struct pci_dev *dev, int pos, int cap);
 int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
 int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
+int pci_find_dvsec(struct pci_dev *dev, u16 vendor, u16 id);
 
 u64 pci_get_dsn(struct pci_dev *dev);
 
@@ -1726,6 +1727,8 @@ static inline int pci_find_next_capability(struct pci_dev *dev, u8 post,
 { return 0; }
 static inline int pci_find_ext_capability(struct pci_dev *dev, int cap)
 { return 0; }
+static inline int pci_find_dvsec(struct pci_dev *dev, u16 vendor, u16 id)
+{ return 0; }
 
 static inline u64 pci_get_dsn(struct pci_dev *dev)
 { return 0; }
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 8f8bd2318c6c..3532528441ef 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1071,6 +1071,10 @@
 #define PCI_DVSEC_HEADER1		0x4 /* Designated Vendor-Specific Header1 */
 #define PCI_DVSEC_HEADER2		0x8 /* Designated Vendor-Specific Header2 */
 
+#define PCI_DVSEC_ID_INTEL_SIOV		0x5
+#define PCI_DVSEC_INTEL_SIOV_CAP	0x14
+#define PCI_DVSEC_INTEL_SIOV_CAP_IMS	0x1
+
 /* Data Link Feature */
 #define PCI_DLF_CAP		0x04	/* Capabilities Register */
 #define  PCI_DLF_EXCHANGE_ENABLE	0x80000000  /* Data Link Feature Exchange Enable */


