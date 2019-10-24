Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635B7E334E
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502307AbfJXNBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:5208 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502306AbfJXNBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156294"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:49 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 14/22] vfio/pci: add iommu_context notifier for pasid bind/unbind
Date:   Thu, 24 Oct 2019 08:34:35 -0400
Message-Id: <1571920483-3382-15-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds notifier for pasid bind/unbind. VFIO registers this
notifier to listen to the dual-stage translation (a.k.a. nested
translation) configuration changes and propagate to host. Thus vIOMMU
is able to set its translation structures to host.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/pci.c            | 39 +++++++++++++++++++++++++++++++++++++++
 include/hw/iommu/iommu.h | 11 +++++++++++
 2 files changed, 50 insertions(+)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 8721ff6..012b8ed 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2767,6 +2767,41 @@ static void vfio_iommu_pasid_free_notify(IOMMUCTXNotifier *n,
     pasid_req->free_result = ret;
 }
 
+static void vfio_iommu_pasid_bind_notify(IOMMUCTXNotifier *n,
+                                         IOMMUCTXEventData *event_data)
+{
+#ifdef __linux__
+    VFIOIOMMUContext *giommu_ctx = container_of(n, VFIOIOMMUContext, n);
+    VFIOContainer *container = giommu_ctx->container;
+    IOMMUCTXPASIDBindData *pasid_bind =
+                              (IOMMUCTXPASIDBindData *) event_data->data;
+    struct vfio_iommu_type1_bind *bind;
+    struct iommu_gpasid_bind_data *bind_data;
+    unsigned long argsz;
+
+    argsz = sizeof(*bind) + sizeof(*bind_data);
+    bind = g_malloc0(argsz);
+    bind->argsz = argsz;
+    bind->bind_type = VFIO_IOMMU_BIND_GUEST_PASID;
+    bind_data = (struct iommu_gpasid_bind_data *) &bind->data;
+    *bind_data = *pasid_bind->data;
+
+    if (pasid_bind->flag & IOMMU_CTX_BIND_PASID) {
+        if (ioctl(container->fd, VFIO_IOMMU_BIND, bind) != 0) {
+            error_report("%s: pasid (%llu:%llu) bind failed: %d", __func__,
+                         bind_data->gpasid, bind_data->hpasid, -errno);
+        }
+    } else if (pasid_bind->flag & IOMMU_CTX_UNBIND_PASID) {
+        if (ioctl(container->fd, VFIO_IOMMU_UNBIND, bind) != 0) {
+            error_report("%s: pasid (%llu:%llu) unbind failed: %d", __func__,
+                         bind_data->gpasid, bind_data->hpasid, -errno);
+        }
+    }
+
+    g_free(bind);
+#endif
+}
+
 static void vfio_realize(PCIDevice *pdev, Error **errp)
 {
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
@@ -3079,6 +3114,10 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
                                          iommu_context,
                                          vfio_iommu_pasid_free_notify,
                                          IOMMU_CTX_EVENT_PASID_FREE);
+        vfio_register_iommu_ctx_notifier(vdev,
+                                         iommu_context,
+                                         vfio_iommu_pasid_bind_notify,
+                                         IOMMU_CTX_EVENT_PASID_BIND);
     }
 
     return;
diff --git a/include/hw/iommu/iommu.h b/include/hw/iommu/iommu.h
index 4352afd..4f21aa1 100644
--- a/include/hw/iommu/iommu.h
+++ b/include/hw/iommu/iommu.h
@@ -33,6 +33,7 @@ typedef struct IOMMUContext IOMMUContext;
 enum IOMMUCTXEvent {
     IOMMU_CTX_EVENT_PASID_ALLOC,
     IOMMU_CTX_EVENT_PASID_FREE,
+    IOMMU_CTX_EVENT_PASID_BIND,
     IOMMU_CTX_EVENT_NUM,
 };
 typedef enum IOMMUCTXEvent IOMMUCTXEvent;
@@ -50,6 +51,16 @@ union IOMMUCTXPASIDReqDesc {
 };
 typedef union IOMMUCTXPASIDReqDesc IOMMUCTXPASIDReqDesc;
 
+struct IOMMUCTXPASIDBindData {
+#define IOMMU_CTX_BIND_PASID   (1 << 0)
+#define IOMMU_CTX_UNBIND_PASID (1 << 1)
+    uint32_t flag;
+#ifdef __linux__
+    struct iommu_gpasid_bind_data *data;
+#endif
+};
+typedef struct IOMMUCTXPASIDBindData IOMMUCTXPASIDBindData;
+
 struct IOMMUCTXEventData {
     IOMMUCTXEvent event;
     uint64_t length;
-- 
2.7.4

