Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7246161054
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfGFLTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:3888 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbfGFLTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:18:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363354964"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:18:57 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 03/18] hw/pci: introduce PCIPASIDOps to PCIDevice
Date:   Fri,  5 Jul 2019 19:01:36 +0800
Message-Id: <1562324511-2910-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces PCIPASIDOps for PASID related operations in
future usage like virt-SVA. Related discussions can be found in
below links.

https://lists.gnu.org/archive/html/qemu-devel/2018-03/msg00078.html
https://lists.gnu.org/archive/html/qemu-devel/2018-03/msg00940.html

So far, to setup virt-SVA for assigned SVA capable device, needs to
configure host translation structures for specific pasid. (e.g. bind
guest page table to host and enable nested translation in host).
Besides, vIOMMU emulator needs to forward guest's cache invalidation
to host since host nested translation is enabled. e.g. on VT-d, guest
owns 1st level translation table, thus cache invalidation for 1st
level should be propagated to host.

This patch adds two functions: alloc_pasid and free_pasid to support
guest pasid allocation and free. The implementations of the callbacks
would be device passthru modules. Like vfio.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 hw/pci/pci.c         | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/hw/pci/pci.h | 14 ++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index 8076a80..710f9e9 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2626,6 +2626,56 @@ void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque)
     bus->iommu_opaque = opaque;
 }
 
+void pci_setup_pasid_ops(PCIDevice *dev, PCIPASIDOps *ops)
+{
+    assert(ops && !dev->pasid_ops);
+    dev->pasid_ops = ops;
+}
+
+bool pci_device_is_ops_set(PCIBus *bus, int32_t devfn)
+{
+    PCIDevice *dev;
+
+    if (!bus) {
+        return false;
+    }
+
+    dev = bus->devices[devfn];
+    return !!(dev && dev->pasid_ops);
+}
+
+int pci_device_request_pasid_alloc(PCIBus *bus, int32_t devfn,
+                                   uint32_t min_pasid, uint32_t max_pasid)
+{
+    PCIDevice *dev;
+
+    if (!bus) {
+        return -1;
+    }
+
+    dev = bus->devices[devfn];
+    if (dev && dev->pasid_ops && dev->pasid_ops->alloc_pasid) {
+        return dev->pasid_ops->alloc_pasid(bus, devfn, min_pasid, max_pasid);
+    }
+    return -1;
+}
+
+int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn,
+                                  uint32_t pasid)
+{
+    PCIDevice *dev;
+
+    if (!bus) {
+        return -1;
+    }
+
+    dev = bus->devices[devfn];
+    if (dev && dev->pasid_ops && dev->pasid_ops->free_pasid) {
+        return dev->pasid_ops->free_pasid(bus, devfn, pasid);
+    }
+    return -1;
+}
+
 static void pci_dev_get_w64(PCIBus *b, PCIDevice *dev, void *opaque)
 {
     Range *range = opaque;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index d082707..16e5b8e 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -262,6 +262,13 @@ struct PCIReqIDCache {
 };
 typedef struct PCIReqIDCache PCIReqIDCache;
 
+typedef struct PCIPASIDOps PCIPASIDOps;
+struct PCIPASIDOps {
+    int (*alloc_pasid)(PCIBus *bus, int32_t devfn,
+                         uint32_t min_pasid, uint32_t max_pasid);
+    int (*free_pasid)(PCIBus *bus, int32_t devfn, uint32_t pasid);
+};
+
 struct PCIDevice {
     DeviceState qdev;
 
@@ -351,6 +358,7 @@ struct PCIDevice {
     MSIVectorUseNotifier msix_vector_use_notifier;
     MSIVectorReleaseNotifier msix_vector_release_notifier;
     MSIVectorPollNotifier msix_vector_poll_notifier;
+    PCIPASIDOps *pasid_ops;
 };
 
 void pci_register_bar(PCIDevice *pci_dev, int region_num,
@@ -484,6 +492,12 @@ typedef AddressSpace *(*PCIIOMMUFunc)(PCIBus *, void *, int);
 AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
 void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque);
 
+void pci_setup_pasid_ops(PCIDevice *dev, PCIPASIDOps *ops);
+bool pci_device_is_ops_set(PCIBus *bus, int32_t devfn);
+int pci_device_request_pasid_alloc(PCIBus *bus, int32_t devfn,
+                                   uint32_t min_pasid, uint32_t max_pasid);
+int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn, uint32_t pasid);
+
 static inline void
 pci_set_byte(uint8_t *config, uint8_t val)
 {
-- 
2.7.4

