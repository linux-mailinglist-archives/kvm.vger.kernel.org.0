Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1FE3347
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502286AbfJXNBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:44 -0400
Received: from mga04.intel.com ([192.55.52.120]:5193 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502269AbfJXNBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156206"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:27 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 07/22] hw/pci: introduce pci_device_iommu_context()
Date:   Thu, 24 Oct 2019 08:34:28 -0400
Message-Id: <1571920483-3382-8-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds pci_device_iommu_context() to get an iommu_context
for a given device. A new callback is added in PCIIOMMUOps. Users
who wants to listen to events issued by vIOMMU could use this new
interface to get an iommu_context and register their own notifiers,
then wait for notifications from vIOMMU. e.g. VFIO is the first user
of it to listen to the PASID_ALLOC/PASID_BIND/CACHE_INV events and
propagate the events to host.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/pci/pci.c         | 16 ++++++++++++++++
 include/hw/pci/pci.h |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index b5ce9ca..4e6af06 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2625,6 +2625,22 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
     return &address_space_memory;
 }
 
+IOMMUContext *pci_device_iommu_context(PCIDevice *dev)
+{
+    PCIBus *bus = pci_get_bus(dev);
+    PCIBus *iommu_bus = bus;
+
+    while (iommu_bus && !iommu_bus->iommu_ops && iommu_bus->parent_dev) {
+        iommu_bus = pci_get_bus(iommu_bus->parent_dev);
+    }
+    if (iommu_bus && iommu_bus->iommu_ops &&
+        iommu_bus->iommu_ops->get_iommu_context) {
+        return iommu_bus->iommu_ops->get_iommu_context(bus,
+                           iommu_bus->iommu_opaque, dev->devfn);
+    }
+    return NULL;
+}
+
 void pci_setup_iommu(PCIBus *bus, const PCIIOMMUOps *ops, void *opaque)
 {
     bus->iommu_ops = ops;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index d9fed8d..ccada47 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -9,6 +9,8 @@
 
 #include "hw/pci/pcie.h"
 
+#include "hw/iommu/iommu.h"
+
 extern bool pci_available;
 
 /* PCI bus */
@@ -484,9 +486,12 @@ typedef struct PCIIOMMUOps PCIIOMMUOps;
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

