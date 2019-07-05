Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACEC6105F
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfGFLTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbfGFLTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355046"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:28 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 14/18] hw/pci: add flush_pasid_iotlb() in PCIPASIDOps
Date:   Fri,  5 Jul 2019 19:01:47 +0800
Message-Id: <1562324511-2910-15-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds flush_pasid_iotlb() in PCIPASIDOps for passing guest
PASID-based iotlb flush operation to host via vfio interface.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/pci/pci.c         | 15 +++++++++++++++
 include/hw/pci/pci.h |  4 ++++
 2 files changed, 19 insertions(+)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index 2229229..cf92bed 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2706,6 +2706,21 @@ void pci_device_unbind_gpasid(PCIBus *bus, int32_t devfn,
     }
 }
 
+void pci_device_flush_pasid_iotlb(PCIBus *bus, int32_t devfn,
+                            struct iommu_cache_invalidate_info *info)
+{
+    PCIDevice *dev;
+
+    if (!bus) {
+        return;
+    }
+
+    dev = bus->devices[devfn];
+    if (dev && dev->pasid_ops) {
+        dev->pasid_ops->flush_pasid_iotlb(bus, devfn, info);
+    }
+}
+
 static void pci_dev_get_w64(PCIBus *b, PCIDevice *dev, void *opaque)
 {
     Range *range = opaque;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index 8d849e6..77e6bb1 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -272,6 +272,8 @@ struct PCIPASIDOps {
                             struct gpasid_bind_data *g_bind_data);
     void (*unbind_gpasid)(PCIBus *bus, int32_t devfn,
                             struct gpasid_bind_data *g_bind_data);
+    void (*flush_pasid_iotlb)(PCIBus *bus, int32_t devfn,
+                            struct iommu_cache_invalidate_info *info);
 };
 
 struct PCIDevice {
@@ -506,6 +508,8 @@ void pci_device_bind_gpasid(PCIBus *bus, int32_t devfn,
                             struct gpasid_bind_data *g_bind_data);
 void pci_device_unbind_gpasid(PCIBus *bus, int32_t devfn,
                             struct gpasid_bind_data *g_bind_data);
+void pci_device_flush_pasid_iotlb(PCIBus *bus, int32_t devfn,
+                            struct iommu_cache_invalidate_info *info);
 
 static inline void
 pci_set_byte(uint8_t *config, uint8_t val)
-- 
2.7.4

