Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907D6E3354
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502311AbfJXNCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:02:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:5208 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502332AbfJXNCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:02:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:02:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156333"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:02:03 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 19/22] vfio/pci: add iommu_context notifier for PASID-based iotlb flush
Date:   Thu, 24 Oct 2019 08:34:40 -0400
Message-Id: <1571920483-3382-20-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds notifier for propagating guest PASID-based iotlb
invalidation to host.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/pci.c            | 29 +++++++++++++++++++++++++++++
 include/hw/iommu/iommu.h |  8 ++++++++
 2 files changed, 37 insertions(+)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 012b8ed..52fe3ed 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2802,6 +2802,31 @@ static void vfio_iommu_pasid_bind_notify(IOMMUCTXNotifier *n,
 #endif
 }
 
+static void vfio_iommu_cache_inv_notify(IOMMUCTXNotifier *n,
+                                        IOMMUCTXEventData *event_data)
+{
+#ifdef __linux__
+    VFIOIOMMUContext *giommu_ctx = container_of(n, VFIOIOMMUContext, n);
+    VFIOContainer *container = giommu_ctx->container;
+    IOMMUCTXCacheInvInfo *inv_info =
+                              (IOMMUCTXCacheInvInfo *) event_data->data;
+    struct vfio_iommu_type1_cache_invalidate *cache_inv;
+    unsigned long argsz;
+
+    argsz = sizeof(*cache_inv);
+    cache_inv = g_malloc0(argsz);
+    cache_inv->argsz = argsz;
+    cache_inv->info = *inv_info->info;
+    cache_inv->flags = 0;
+
+    if (ioctl(container->fd, VFIO_IOMMU_CACHE_INVALIDATE, cache_inv) != 0) {
+        error_report("%s: cache invalidation failed: %d", __func__, -errno);
+    }
+
+    g_free(cache_inv);
+#endif
+}
+
 static void vfio_realize(PCIDevice *pdev, Error **errp)
 {
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
@@ -3118,6 +3143,10 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
                                          iommu_context,
                                          vfio_iommu_pasid_bind_notify,
                                          IOMMU_CTX_EVENT_PASID_BIND);
+        vfio_register_iommu_ctx_notifier(vdev,
+                                         iommu_context,
+                                         vfio_iommu_cache_inv_notify,
+                                         IOMMU_CTX_EVENT_CACHE_INV);
     }
 
     return;
diff --git a/include/hw/iommu/iommu.h b/include/hw/iommu/iommu.h
index 4f21aa1..452f609 100644
--- a/include/hw/iommu/iommu.h
+++ b/include/hw/iommu/iommu.h
@@ -34,6 +34,7 @@ enum IOMMUCTXEvent {
     IOMMU_CTX_EVENT_PASID_ALLOC,
     IOMMU_CTX_EVENT_PASID_FREE,
     IOMMU_CTX_EVENT_PASID_BIND,
+    IOMMU_CTX_EVENT_CACHE_INV,
     IOMMU_CTX_EVENT_NUM,
 };
 typedef enum IOMMUCTXEvent IOMMUCTXEvent;
@@ -61,6 +62,13 @@ struct IOMMUCTXPASIDBindData {
 };
 typedef struct IOMMUCTXPASIDBindData IOMMUCTXPASIDBindData;
 
+struct IOMMUCTXCacheInvInfo {
+#ifdef __linux__
+    struct iommu_cache_invalidate_info *info;
+#endif
+};
+typedef struct IOMMUCTXCacheInvInfo IOMMUCTXCacheInvInfo;
+
 struct IOMMUCTXEventData {
     IOMMUCTXEvent event;
     uint64_t length;
-- 
2.7.4

