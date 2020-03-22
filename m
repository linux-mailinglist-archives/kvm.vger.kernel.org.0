Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB8918E8CE
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgCVMal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:30:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:40469 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbgCVMak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:30:40 -0400
IronPort-SDR: ez2RlTlv8sC0XXXhG20TOqGFzkAKymKWBOTyv8HK69a292QyZyAZ1cymEpUQaQc95EHHcKH6+G
 rvglv/7UzLkg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:30:38 -0700
IronPort-SDR: H29lmoJWSzJddgAHQ9mMrPiWN94pHNnpkZ2KKd6kAyKq80d5LvOvyCXTspSEDo+FvnJWyu46Ol
 1eXZYJbm0lpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="239664367"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2020 05:30:37 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [PATCH v1 06/22] hw/pci: introduce pci_device_set/unset_iommu_context()
Date:   Sun, 22 Mar 2020 05:36:03 -0700
Message-Id: <1584880579-12178-7-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds pci_device_set/unset_iommu_context() to set/unset
host_iommu_context for a given device. New callback is added in
PCIIOMMUOps. As such, vIOMMU could make use of host IOMMU capability.
e.g setup nested translation.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/pci/pci.c         | 49 ++++++++++++++++++++++++++++++++++++++++++++-----
 include/hw/pci/pci.h | 10 ++++++++++
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index aa9025c..8642ea8 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2638,7 +2638,8 @@ static void pci_device_class_base_init(ObjectClass *klass, void *data)
     }
 }
 
-AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
+static void pci_device_get_iommu_bus_devfn(PCIDevice *dev,
+                              PCIBus **pbus, uint8_t *pdevfn)
 {
     PCIBus *bus = pci_get_bus(dev);
     PCIBus *iommu_bus = bus;
@@ -2683,14 +2684,52 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
 
         iommu_bus = parent_bus;
     }
-    if (iommu_bus && iommu_bus->iommu_ops &&
-                     iommu_bus->iommu_ops->get_address_space) {
-        return iommu_bus->iommu_ops->get_address_space(bus,
-                                 iommu_bus->iommu_opaque, devfn);
+    *pbus = iommu_bus;
+    *pdevfn = devfn;
+}
+
+AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
+{
+    PCIBus *bus;
+    uint8_t devfn;
+
+    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
+    if (bus && bus->iommu_ops &&
+                     bus->iommu_ops->get_address_space) {
+        return bus->iommu_ops->get_address_space(bus,
+                                bus->iommu_opaque, devfn);
     }
     return &address_space_memory;
 }
 
+int pci_device_set_iommu_context(PCIDevice *dev,
+                                 HostIOMMUContext *host_icx)
+{
+    PCIBus *bus;
+    uint8_t devfn;
+
+    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
+    if (bus && bus->iommu_ops &&
+                    bus->iommu_ops->set_iommu_context) {
+        return bus->iommu_ops->set_iommu_context(bus,
+                              bus->iommu_opaque, devfn, host_icx);
+    }
+    return -ENOENT;
+}
+
+void pci_device_unset_iommu_context(PCIDevice *dev)
+{
+    PCIBus *bus;
+    uint8_t devfn;
+
+    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
+    if (bus && bus->iommu_ops &&
+                    bus->iommu_ops->unset_iommu_context) {
+        bus->iommu_ops->unset_iommu_context(bus,
+                                 bus->iommu_opaque, devfn);
+    }
+}
+
 void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *ops, void *opaque)
 {
     bus->iommu_ops = ops;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index ffe192d..6fca2a0 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -9,6 +9,8 @@
 
 #include "hw/pci/pcie.h"
 
+#include "hw/iommu/host_iommu_context.h"
+
 extern bool pci_available;
 
 /* PCI bus */
@@ -489,9 +491,17 @@ typedef struct PCIIOMMUOps PCIIOMMUOps;
 struct PCIIOMMUOps {
     AddressSpace * (*get_address_space)(PCIBus *bus,
                                 void *opaque, int32_t devfn);
+    int (*set_iommu_context)(PCIBus *bus, void *opaque,
+                             int32_t devfn,
+                             HostIOMMUContext *host_icx);
+    void (*unset_iommu_context)(PCIBus *bus, void *opaque,
+                                int32_t devfn);
 };
 
 AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
+int pci_device_set_iommu_context(PCIDevice *dev,
+                                 HostIOMMUContext *host_icx);
+void pci_device_unset_iommu_context(PCIDevice *dev);
 void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *iommu_ops, void *opaque);
 
 static inline void
-- 
2.7.4

