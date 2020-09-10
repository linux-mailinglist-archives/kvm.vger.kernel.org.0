Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EFF2644FF
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 13:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbgIJLCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 07:02:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:21746 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgIJK7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:59:41 -0400
IronPort-SDR: 1ky0HrZTS8ByaeP4UTaHb1p3tPjJqboNSFERVRw7om4PsRWqJywh1AiFnyV4VSBsL4iDd6lpKj
 /yogLl+m92qA==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="138025854"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="138025854"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:54:40 -0700
IronPort-SDR: iZ25jyoEMpNtXQgOp6LiOrZ0DnCiVgf/frtDmaCfxWV7B6PGdTtwbhbK+xhaP8aFcShTJinit7
 jOBd6xopM14A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334140044"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:54:39 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v10 04/25] hw/pci: introduce pci_device_get_iommu_attr()
Date:   Thu, 10 Sep 2020 03:56:17 -0700
Message-Id: <1599735398-6829-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599735398-6829-1-git-send-email-yi.l.liu@intel.com>
References: <1599735398-6829-1-git-send-email-yi.l.liu@intel.com>
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
index 1967746..1886f8e 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2659,7 +2659,8 @@ static void pci_device_class_base_init(ObjectClass *klass, void *data)
     }
 }
 
-AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
+static void pci_device_get_iommu_bus_devfn(PCIDevice *dev,
+                              PCIBus **pbus, uint8_t *pdevfn)
 {
     PCIBus *bus = pci_get_bus(dev);
     PCIBus *iommu_bus = bus;
@@ -2710,14 +2711,38 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
 
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
index 7c46a78..18b51dd 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -487,13 +487,20 @@ void pci_bus_get_w64_range(PCIBus *bus, Range *range);
 
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

