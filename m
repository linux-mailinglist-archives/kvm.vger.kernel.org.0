Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C79B061058
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfGFLTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfGFLTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355006"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:08 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 07/18] hw/pci: add pci_device_bind/unbind_gpasid
Date:   Fri,  5 Jul 2019 19:01:40 +0800
Message-Id: <1562324511-2910-8-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds two callbacks pci_device_bind/unbind_gpasid() to
PCIPASIDOps. These two callbacks are used to propagate guest pasid
bind/unbind to host. The implementations of the callbacks would be
device passthru modules like vfio.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/pci/pci.c         | 30 ++++++++++++++++++++++++++++++
 include/hw/pci/pci.h |  9 +++++++++
 2 files changed, 39 insertions(+)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index 710f9e9..2229229 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2676,6 +2676,36 @@ int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn,
     return -1;
 }
 
+void pci_device_bind_gpasid(PCIBus *bus, int32_t devfn,
+                                struct gpasid_bind_data *g_bind_data)
+{
+    PCIDevice *dev;
+
+    if (!bus) {
+        return;
+    }
+
+    dev = bus->devices[devfn];
+    if (dev && dev->pasid_ops) {
+        dev->pasid_ops->bind_gpasid(bus, devfn, g_bind_data);
+    }
+}
+
+void pci_device_unbind_gpasid(PCIBus *bus, int32_t devfn,
+                                struct gpasid_bind_data *g_bind_data)
+{
+    PCIDevice *dev;
+
+    if (!bus) {
+        return;
+    }
+
+    dev = bus->devices[devfn];
+    if (dev && dev->pasid_ops) {
+        dev->pasid_ops->unbind_gpasid(bus, devfn, g_bind_data);
+    }
+}
+
 static void pci_dev_get_w64(PCIBus *b, PCIDevice *dev, void *opaque)
 {
     Range *range = opaque;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index 16e5b8e..8d849e6 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -9,6 +9,7 @@
 #include "hw/isa/isa.h"
 
 #include "hw/pci/pcie.h"
+#include <linux/iommu.h>
 
 extern bool pci_available;
 
@@ -267,6 +268,10 @@ struct PCIPASIDOps {
     int (*alloc_pasid)(PCIBus *bus, int32_t devfn,
                          uint32_t min_pasid, uint32_t max_pasid);
     int (*free_pasid)(PCIBus *bus, int32_t devfn, uint32_t pasid);
+    void (*bind_gpasid)(PCIBus *bus, int32_t devfn,
+                            struct gpasid_bind_data *g_bind_data);
+    void (*unbind_gpasid)(PCIBus *bus, int32_t devfn,
+                            struct gpasid_bind_data *g_bind_data);
 };
 
 struct PCIDevice {
@@ -497,6 +502,10 @@ bool pci_device_is_ops_set(PCIBus *bus, int32_t devfn);
 int pci_device_request_pasid_alloc(PCIBus *bus, int32_t devfn,
                                    uint32_t min_pasid, uint32_t max_pasid);
 int pci_device_request_pasid_free(PCIBus *bus, int32_t devfn, uint32_t pasid);
+void pci_device_bind_gpasid(PCIBus *bus, int32_t devfn,
+                            struct gpasid_bind_data *g_bind_data);
+void pci_device_unbind_gpasid(PCIBus *bus, int32_t devfn,
+                            struct gpasid_bind_data *g_bind_data);
 
 static inline void
 pci_set_byte(uint8_t *config, uint8_t val)
-- 
2.7.4

