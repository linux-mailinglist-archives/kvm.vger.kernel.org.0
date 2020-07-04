Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6E021453D
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 13:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgGDLaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 07:30:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:61336 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbgGDLaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 07:30:19 -0400
IronPort-SDR: L+mT51ezC//y6/hK954BtIIARQEgNfXabELNy7maT63eTUMDZj7An92heZ8+nMCmrYl8vdGNQX
 w/2u/IegAW6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="144760865"
X-IronPort-AV: E=Sophos;i="5.75,311,1589266800"; 
   d="scan'208";a="144760865"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2020 04:30:18 -0700
IronPort-SDR: qcxXHfAFq/qWV4ahS1D+NdWq7nf5fiI0G842UO36qdB2K1UlA6y8SUD/u4ETy2tRw7RUNkkgXj
 cbjxhKoOTnZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,311,1589266800"; 
   d="scan'208";a="266146799"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jul 2020 04:30:18 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        jasowang@redhat.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v7 09/25] hw/pci: introduce pci_device_set/unset_iommu_context()
Date:   Sat,  4 Jul 2020 04:36:33 -0700
Message-Id: <1593862609-36135-10-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593862609-36135-1-git-send-email-yi.l.liu@intel.com>
References: <1593862609-36135-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For nesting IOMMU translation capable platforms, vIOMMUs running on
such system could be implemented upon physical IOMMU nested paging
(VFIO case). vIOMMU advertises such implementation by "want_nested"
attribute to PCIe devices (e.g. VFIO PCI). Once "want_nested" is
satisfied, device (VFIO case) should set HostIOMMUContext to vIOMMU,
thus vIOMMU could manage stage-1 translation. DMAs out from such
devices would be protected through the stage-1 page tables owned by
guest together with stage-2 page tables owned by host.

This patch adds pci_device_set/unset_iommu_context() to set/unset
HostIOMMUContext for a given PCIe device (VFIO case). Caller of set
should fail if set operation failed.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
rfcv5 (v2) -> rfcv6:
*) pci_device_set_iommu_context() returns 0 if callback is not implemented.
---
 hw/pci/pci.c         | 28 ++++++++++++++++++++++++++++
 include/hw/pci/pci.h | 10 ++++++++++
 2 files changed, 38 insertions(+)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index 3c27805..59864c6 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2743,6 +2743,34 @@ int pci_device_get_iommu_attr(PCIDevice *dev, IOMMUAttr attr, void *data)
     return -ENOENT;
 }
 
+int pci_device_set_iommu_context(PCIDevice *dev,
+                                 HostIOMMUContext *iommu_ctx)
+{
+    PCIBus *bus;
+    uint8_t devfn;
+
+    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
+    if (bus && bus->iommu_ops &&
+        bus->iommu_ops->set_iommu_context) {
+        return bus->iommu_ops->set_iommu_context(bus,
+                              bus->iommu_opaque, devfn, iommu_ctx);
+    }
+    return 0;
+}
+
+void pci_device_unset_iommu_context(PCIDevice *dev)
+{
+    PCIBus *bus;
+    uint8_t devfn;
+
+    pci_device_get_iommu_bus_devfn(dev, &bus, &devfn);
+    if (bus && bus->iommu_ops &&
+        bus->iommu_ops->unset_iommu_context) {
+        bus->iommu_ops->unset_iommu_context(bus,
+                                 bus->iommu_opaque, devfn);
+    }
+}
+
 void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *ops, void *opaque)
 {
     bus->iommu_ops = ops;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index f74161b..0647d64 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -9,6 +9,8 @@
 
 #include "hw/pci/pcie.h"
 
+#include "hw/iommu/host_iommu_context.h"
+
 extern bool pci_available;
 
 /* PCI bus */
@@ -495,10 +497,18 @@ struct PCIIOMMUOps {
                                 void *opaque, int32_t devfn);
     int (*get_iommu_attr)(PCIBus *bus, void *opaque, int32_t devfn,
                            IOMMUAttr attr, void *data);
+    int (*set_iommu_context)(PCIBus *bus, void *opaque,
+                             int32_t devfn,
+                             HostIOMMUContext *iommu_ctx);
+    void (*unset_iommu_context)(PCIBus *bus, void *opaque,
+                                int32_t devfn);
 };
 
 AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
 int pci_device_get_iommu_attr(PCIDevice *dev, IOMMUAttr attr, void *data);
+int pci_device_set_iommu_context(PCIDevice *dev,
+                                 HostIOMMUContext *iommu_ctx);
+void pci_device_unset_iommu_context(PCIDevice *dev);
 void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *iommu_ops, void *opaque);
 
 static inline void
-- 
2.7.4

