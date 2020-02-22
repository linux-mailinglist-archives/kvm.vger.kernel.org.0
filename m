Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE51168D6A
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgBVIC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:02:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:65090 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbgBVIB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:01:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547677"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2020 00:01:57 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3.1 09/22] hw/pci: add pci_device_host_iommu_context()
Date:   Sat, 22 Feb 2020 00:07:10 -0800
Message-Id: <1582358843-51931-10-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds pci_device_host_iommu_context() to expose HostIOMMUContext
to vIOMMU emulators via pci layer.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/pci/pci.c         | 8 ++++++++
 include/hw/pci/pci.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/hw/pci/pci.c b/hw/pci/pci.c
index 3166cc3..288576f 100644
--- a/hw/pci/pci.c
+++ b/hw/pci/pci.c
@@ -2689,6 +2689,14 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev)
     return &address_space_memory;
 }
 
+HostIOMMUContext *pci_device_host_iommu_context(PCIDevice *dev)
+{
+    if (dev && dev->host_iommu_fn) {
+        return dev->host_iommu_fn(dev);
+    }
+    return NULL;
+}
+
 void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque)
 {
     bus->iommu_fn = fn;
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index e44eefb..cb514d0 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -494,6 +494,7 @@ AddressSpace *pci_device_iommu_address_space(PCIDevice *dev);
 void pci_setup_iommu(PCIBus *bus, PCIIOMMUFunc fn, void *opaque);
 void pci_device_setup_iommu(PCIDevice *dev, PCIHostIOMMUFunc fn);
 void pci_device_unset_iommu(PCIDevice *dev);
+HostIOMMUContext *pci_device_host_iommu_context(PCIDevice *dev);
 
 static inline void
 pci_set_byte(uint8_t *config, uint8_t val)
-- 
2.7.4

