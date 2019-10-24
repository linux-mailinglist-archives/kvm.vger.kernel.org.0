Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A20BE3348
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 15:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502293AbfJXNBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 09:01:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:5193 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502266AbfJXNBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 09:01:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 06:01:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="210156239"
Received: from iov.bj.intel.com ([10.238.145.67])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2019 06:01:33 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid alloc/free
Date:   Thu, 24 Oct 2019 08:34:30 -0400
Message-Id: <1571920483-3382-10-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds pasid alloc/free notifiers for vfio-pci. It is
supposed to be fired by vIOMMU. VFIO then sends PASID allocation
or free request to host.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/common.c         |  9 ++++++
 hw/vfio/pci.c            | 81 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/hw/iommu/iommu.h | 15 +++++++++
 3 files changed, 105 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index d418527..e6ad21c 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1436,6 +1436,7 @@ static void vfio_disconnect_container(VFIOGroup *group)
     if (QLIST_EMPTY(&container->group_list)) {
         VFIOAddressSpace *space = container->space;
         VFIOGuestIOMMU *giommu, *tmp;
+        VFIOIOMMUContext *giommu_ctx, *ctx;
 
         QLIST_REMOVE(container, next);
 
@@ -1446,6 +1447,14 @@ static void vfio_disconnect_container(VFIOGroup *group)
             g_free(giommu);
         }
 
+        QLIST_FOREACH_SAFE(giommu_ctx, &container->iommu_ctx_list,
+                                                   iommu_ctx_next, ctx) {
+            iommu_ctx_notifier_unregister(giommu_ctx->iommu_ctx,
+                                                      &giommu_ctx->n);
+            QLIST_REMOVE(giommu_ctx, iommu_ctx_next);
+            g_free(giommu_ctx);
+        }
+
         trace_vfio_disconnect_container(container->fd);
         close(container->fd);
         g_free(container);
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 12fac39..8721ff6 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2699,11 +2699,80 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
     vdev->req_enabled = false;
 }
 
+static void vfio_register_iommu_ctx_notifier(VFIOPCIDevice *vdev,
+                                             IOMMUContext *iommu_ctx,
+                                             IOMMUCTXNotifyFn fn,
+                                             IOMMUCTXEvent event)
+{
+    VFIOContainer *container = vdev->vbasedev.group->container;
+    VFIOIOMMUContext *giommu_ctx;
+
+    giommu_ctx = g_malloc0(sizeof(*giommu_ctx));
+    giommu_ctx->container = container;
+    giommu_ctx->iommu_ctx = iommu_ctx;
+    QLIST_INSERT_HEAD(&container->iommu_ctx_list,
+                      giommu_ctx,
+                      iommu_ctx_next);
+    iommu_ctx_notifier_register(iommu_ctx,
+                                &giommu_ctx->n,
+                                fn,
+                                event);
+}
+
+static void vfio_iommu_pasid_alloc_notify(IOMMUCTXNotifier *n,
+                                          IOMMUCTXEventData *event_data)
+{
+    VFIOIOMMUContext *giommu_ctx = container_of(n, VFIOIOMMUContext, n);
+    VFIOContainer *container = giommu_ctx->container;
+    IOMMUCTXPASIDReqDesc *pasid_req =
+                              (IOMMUCTXPASIDReqDesc *) event_data->data;
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+    int pasid;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flag = VFIO_IOMMU_PASID_ALLOC;
+    req.min_pasid = pasid_req->min_pasid;
+    req.max_pasid = pasid_req->max_pasid;
+
+    pasid = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
+    if (pasid < 0) {
+        error_report("%s: %d, alloc failed", __func__, -errno);
+    }
+    pasid_req->alloc_result = pasid;
+}
+
+static void vfio_iommu_pasid_free_notify(IOMMUCTXNotifier *n,
+                                          IOMMUCTXEventData *event_data)
+{
+    VFIOIOMMUContext *giommu_ctx = container_of(n, VFIOIOMMUContext, n);
+    VFIOContainer *container = giommu_ctx->container;
+    IOMMUCTXPASIDReqDesc *pasid_req =
+                              (IOMMUCTXPASIDReqDesc *) event_data->data;
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+    int ret = 0;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flag = VFIO_IOMMU_PASID_FREE;
+    req.pasid = pasid_req->pasid;
+
+    ret = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
+    if (ret != 0) {
+        error_report("%s: %d, pasid %u free failed",
+                   __func__, -errno, (unsigned) pasid_req->pasid);
+    }
+    pasid_req->free_result = ret;
+}
+
 static void vfio_realize(PCIDevice *pdev, Error **errp)
 {
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
     VFIODevice *vbasedev_iter;
     VFIOGroup *group;
+    IOMMUContext *iommu_context;
     char *tmp, *subsys, group_path[PATH_MAX], *group_name;
     Error *err = NULL;
     ssize_t len;
@@ -3000,6 +3069,18 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     vfio_register_req_notifier(vdev);
     vfio_setup_resetfn_quirk(vdev);
 
+    iommu_context = pci_device_iommu_context(pdev);
+    if (iommu_context) {
+        vfio_register_iommu_ctx_notifier(vdev,
+                                         iommu_context,
+                                         vfio_iommu_pasid_alloc_notify,
+                                         IOMMU_CTX_EVENT_PASID_ALLOC);
+        vfio_register_iommu_ctx_notifier(vdev,
+                                         iommu_context,
+                                         vfio_iommu_pasid_free_notify,
+                                         IOMMU_CTX_EVENT_PASID_FREE);
+    }
+
     return;
 
 out_teardown:
diff --git a/include/hw/iommu/iommu.h b/include/hw/iommu/iommu.h
index c22c442..4352afd 100644
--- a/include/hw/iommu/iommu.h
+++ b/include/hw/iommu/iommu.h
@@ -31,10 +31,25 @@
 typedef struct IOMMUContext IOMMUContext;
 
 enum IOMMUCTXEvent {
+    IOMMU_CTX_EVENT_PASID_ALLOC,
+    IOMMU_CTX_EVENT_PASID_FREE,
     IOMMU_CTX_EVENT_NUM,
 };
 typedef enum IOMMUCTXEvent IOMMUCTXEvent;
 
+union IOMMUCTXPASIDReqDesc {
+    struct {
+        uint32_t min_pasid;
+        uint32_t max_pasid;
+        int32_t alloc_result; /* pasid allocated for the alloc request */
+    };
+    struct {
+        uint32_t pasid; /* pasid to be free */
+        int free_result;
+    };
+};
+typedef union IOMMUCTXPASIDReqDesc IOMMUCTXPASIDReqDesc;
+
 struct IOMMUCTXEventData {
     IOMMUCTXEvent event;
     uint64_t length;
-- 
2.7.4

