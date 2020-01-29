Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD60C14CA6A
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgA2MLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:11:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:15944 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgA2MLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:11:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:11:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="314070833"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 04:11:44 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com
Cc:     mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3 04/25] hw/pci: introduce pci_device_iommu_context()
Date:   Wed, 29 Jan 2020 04:16:35 -0800
Message-Id: <1580300216-86172-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

This patch adds pci_device_iommu_context() to get an iommu_context
for a given device. A new callback is added in PCIIOMMUOps. Users
who wants to call into vIOMMU could leaverage it. And further vIOMMU
operation could be done via IOMMUContext.

Note:
Previous version has got Reviewed by from David Gibson and Peter Xu.
But this version has slight changes due to the patch rebase. so I
didn't add reviewed by from you two in case of that you two want to
have one more review. If you two have no objection, I would add your
review by in next version. Thanks.

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
 include/hw/pci/pci.h |  5 +++++
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index e331a5c..d2cd810 100644
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
@@ -2683,14 +2684,38 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
 
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
 
+IOMMUContext *pci_device_iommu_context(PCIDevice *dev)
+{
+    PCIBus *bus;
+    uint8_t devfn;
+
+    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
+    if (bus && bus->iommu_ops &&
+                    bus->iommu_ops->get_iommu_context) {
+        return bus->iommu_ops->get_iommu_context(bus,
+                              bus->iommu_opaque, devfn);
+    }
+    return NULL;
+}
+
 void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *ops, void *opaque)
 {
     bus->iommu_ops = ops;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index dc89aa1..43e2023 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -9,6 +9,8 @@
 
 #include "hw/pci/pcie.h"
 
+#include "hw/iommu/iommu_context.h"
+
 extern bool pci_available;
 
 /* PCI bus */
@@ -488,9 +490,12 @@ typedef struct PCIIOMMUOps PCIIOMMUOps;
 struct PCIIOMMUOps {
     AddressSpace * (*get_address_space)(PCIBus *bus,
                                 void *opaque, int32_t devfn);
+    IOMMUContext * (*get_iommu_context)(PCIBus *bus,
+                                void *opaque, int32_t devfn);
 };
 
 AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
+IOMMUContext *pci_device_iommu_context(PCIDevice *dev);
 void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *iommu_ops, void *opaque);
 
 static inline void
-- 
2.7.4

