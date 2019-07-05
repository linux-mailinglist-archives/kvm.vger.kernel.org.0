Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C085C61060
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfGFLTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:19:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:5514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfGFLTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:19:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:19:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363355053"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:19:31 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 15/18] vfio/pci: adds support for PASID-based iotlb flush
Date:   Fri,  5 Jul 2019 19:01:48 +0800
Message-Id: <1562324511-2910-16-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds support for propagating guest PASID-based iotlb flush
to host via vfio container ioctl.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/pci.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 892b46c..d8b84a5 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2796,11 +2796,34 @@ static void vfio_pci_device_unbind_gpasid(PCIBus *bus, int32_t devfn,
     g_free(bind);
 }
 
+static void vfio_pci_device_flush_pasid_iotlb(PCIBus *bus, int32_t devfn,
+                                struct iommu_cache_invalidate_info *info)
+{
+    PCIDevice *pdev = bus->devices[devfn];
+    VFIOPCIDevice *vdev = DO_UPCAST(VFIOPCIDevice, pdev, pdev);
+    VFIOContainer *container = vdev->vbasedev.group->container;
+    struct vfio_iommu_type1_cache_invalidate cache_inv;
+    unsigned long argsz;
+
+    argsz = sizeof(cache_inv);
+    cache_inv.argsz = argsz;
+    cache_inv.info = *info;
+    cache_inv.flags = 0x0;
+
+    rcu_read_lock();
+    if (ioctl(container->fd, VFIO_IOMMU_CACHE_INVALIDATE, &cache_inv) != 0) {
+        error_report("vfio_pci_device_flush_pasid_iotlb:"
+                     " cache invalidation failed, contanier: %p", container);
+    }
+    rcu_read_unlock();
+}
+
 static PCIPASIDOps vfio_pci_pasid_ops = {
     .alloc_pasid = vfio_pci_device_request_pasid_alloc,
     .free_pasid = vfio_pci_device_request_pasid_free,
     .bind_gpasid = vfio_pci_device_bind_gpasid,
     .unbind_gpasid = vfio_pci_device_unbind_gpasid,
+    .flush_pasid_iotlb = vfio_pci_device_flush_pasid_iotlb,
 };
 
 static void vfio_realize(PCIDevice *pdev, Error **errp)
-- 
2.7.4

