Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97ED1F6824
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgFKMsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:48:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:58110 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgFKMsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:48:02 -0400
IronPort-SDR: MC4y2TJBqLJD8Xi+0HQk8fMr2O3TUvhXTBUlxAASOOjReL53KuRg2pntjLQXGFGMdNBdDeSJN/
 wBNsW1CBjw1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:47:59 -0700
IronPort-SDR: x2xbRxx64wd7GrPbIBv6itimjchWbdIMqvlUUQAYdM2j36y8y4nWUz/lYQzwN6Y+ocFVQLiXQw
 j+wPmchXXjGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="447911226"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2020 05:47:59 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v6 04/25] hw/pci: introduce pci_device_get_iommu_attr()
Date:   Thu, 11 Jun 2020 05:54:03 -0700
Message-Id: <1591880064-30638-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591880064-30638-1-git-send-email-yi.l.liu@intel.com>
References: <1591880064-30638-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds pci_device_get_iommu_attr() to get vIOMMU attributes.
e.g. if nesting IOMMU wanted.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/pci/pci.c         | 35 ++++++++++++++++++++++++++++++-----
 include/hw/pci/pci.h |  7 +++++++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index e44d2a2..95589b2 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2641,7 +2641,8 @@ static void pci_device_class_base_init(ObjectClass *klass, void *data)
     }
 }
 
-AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
+static void pci_device_get_iommu_bus_devfn(PCIDevice *dev,
+                              PCIBus **pbus, uint8_t *pdevfn)
 {
     PCIBus *bus = pci_get_bus(dev);
     PCIBus *iommu_bus = bus;
@@ -2692,14 +2693,38 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
 
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
+        bus->iommu_ops->get_address_space) {
+        return bus->iommu_ops->get_address_space(bus,
+                                bus->iommu_opaque, devfn);
     }
     return &address_space_memory;
 }
 
+int pci_device_get_iommu_attr(PCIDevice *dev, IOMMUAttr attr, void *data)
+{
+    PCIBus *bus;
+    uint8_t devfn;
+
+    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
+    if (bus && bus->iommu_ops &&
+        bus->iommu_ops->get_iommu_attr) {
+        return bus->iommu_ops->get_iommu_attr(bus, bus->iommu_opaque,
+                                               devfn, attr, data);
+    }
+    return -ENOENT;
+}
+
 void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *ops, void *opaque)
 {
     bus->iommu_ops = ops;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index ffe192d..f262f26 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -485,13 +485,20 @@ void pci_bus_get_w64_range(PCIBus *bus, Range *range);
 
 void pci_device_deassert_intx(PCIDevice *dev);
 
+typedef enum IOMMUAttr {
+    IOMMU_WANT_NESTING,
+} IOMMUAttr;
+
 typedef struct PCIIOMMUOps PCIIOMMUOps;
 struct PCIIOMMUOps {
     AddressSpace * (*get_address_space)(PCIBus *bus,
                                 void *opaque, int32_t devfn);
+    int (*get_iommu_attr)(PCIBus *bus, void *opaque, int32_t devfn,
+                           IOMMUAttr attr, void *data);
 };
 
 AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
+int pci_device_get_iommu_attr(PCIDevice *dev, IOMMUAttr attr, void *data);
 void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *iommu_ops, void *opaque);
 
 static inline void
-- 
2.7.4

