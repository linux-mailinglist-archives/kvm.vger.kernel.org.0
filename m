Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5AF168D6B
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgBVICb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:02:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:63018 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgBVIB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:01:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547665"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2020 00:01:56 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3.1 05/22] hw/pci: add pci_device_setup_iommu
Date:   Sat, 22 Feb 2020 00:07:06 -0800
Message-Id: <1582358843-51931-6-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HostIOMMUContext was introduced to provide an explicit way for vIOMMU
emulators call into pass-through components (e.g. VFIO). vIOMMU needs
to get the HostIOMMUContext before using it. This patch adds a new
callback in PCIDevice, which would be set by pass-through components,
and be used by vIOMMU emulators to get HostIOMMUContext.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Liu, Yi L <yi.l.liu@intel.com>
---
 hw/pci/pci.c         | 10 ++++++++++
 include/hw/pci/pci.h |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index e1ed667..3166cc3 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2695,6 +2695,16 @@ void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque)
     bus->iommu_opaque = opaque;
 }
 
+void pci_device_setup_iommu(PCIDevice *dev, PCIHostIOMMUFunc fn)
+{
+    dev->host_iommu_fn = fn;
+}
+
+void pci_device_unset_iommu(PCIDevice *dev)
+{
+    dev->host_iommu_fn = NULL;
+}
+
 static void pci_dev_get_w64(PCIBus *b, PCIDevice *dev, void *opaque)
 {
     Range *range = opaque;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index 2acd832..e44eefb 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -8,6 +8,7 @@
 #include "hw/isa/isa.h"
 
 #include "hw/pci/pcie.h"
+#include "hw/iommu/host_iommu_context.h"
 
 extern bool pci_available;
 
@@ -248,6 +249,7 @@ typedef void (*MSIVectorReleaseNotifier)(PCIDevice *dev, unsigned int vector);
 typedef void (*MSIVectorPollNotifier)(PCIDevice *dev,
                                       unsigned int vector_start,
                                       unsigned int vector_end);
+typedef HostIOMMUContext *(*PCIHostIOMMUFunc)(PCIDevice *);
 
 enum PCIReqIDType {
     PCI_REQ_ID_INVALID = 0,
@@ -356,6 +358,8 @@ struct PCIDevice {
 
     /* ID of standby device in net_failover pair */
     char *failover_pair_id;
+    /* Callback to get host iommu context */
+    PCIHostIOMMUFunc host_iommu_fn;
 };
 
 void pci_register_bar(PCIDevice *pci_dev, int region_num,
@@ -488,6 +492,8 @@ typedef AddressSpace *(*PCIIOMMUFunc)(PCIBus *, void *, int);
 
 AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
 void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque);
+void pci_device_setup_iommu(PCIDevice *dev, PCIHostIOMMUFunc fn);
+void pci_device_unset_iommu(PCIDevice *dev);
 
 static inline void
 pci_set_byte(uint8_t *config, uint8_t val)
-- 
2.7.4

