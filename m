Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6066218E8DA
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 13:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgCVMa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 08:30:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:40476 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgCVMak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 08:30:40 -0400
IronPort-SDR: UHqs/nN+YV9Ag8aY2BpQmmZIRuqMsJAJKHOBUawLZpGdN+WkNcxg8eHq0tgSprHwgaPfXZpBd7
 zZjJvP79Bneg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 05:30:38 -0700
IronPort-SDR: ZixMWGhic1XTd8cYcie6djNE42p1WRqBzLAHAstRd5jFqB5NgCboBbCgW3SOYhS9AuOpFLjZ3I
 24w3QUPW8y9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="239664374"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2020 05:30:38 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [PATCH v1 08/22] vfio: init HostIOMMUContext per-container
Date:   Sun, 22 Mar 2020 05:36:05 -0700
Message-Id: <1584880579-12178-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After confirming dual stage DMA translation support with kernel by
checking VFIO_TYPE1_NESTING_IOMMU, VFIO inits HostIOMMUContet instance
and exposes it to PCI layer. Thus vIOMMU emualtors may make use of
such capability by leveraging the methods provided by HostIOMMUContext.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/common.c                      | 80 +++++++++++++++++++++++++++++++++++
 hw/vfio/pci.c                         | 13 ++++++
 include/hw/iommu/host_iommu_context.h |  3 ++
 include/hw/vfio/vfio-common.h         |  4 ++
 4 files changed, 100 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index c276732..e4f5f10 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1179,10 +1179,55 @@ static int vfio_get_iommu_type(VFIOContainer *container,
     return -EINVAL;
 }
 
+static int vfio_host_icx_pasid_alloc(HostIOMMUContext *host_icx,
+                                  uint32_t min, uint32_t max, uint32_t *pasid)
+{
+    VFIOContainer *container = container_of(host_icx, VFIOContainer, host_icx);
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+    int ret;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flags = VFIO_IOMMU_PASID_ALLOC;
+    req.alloc_pasid.min = min;
+    req.alloc_pasid.max = max;
+
+    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
+        ret = -errno;
+        error_report("%s: %d, alloc failed", __func__, ret);
+        return ret;
+    }
+    *pasid = req.alloc_pasid.result;
+    return 0;
+}
+
+static int vfio_host_icx_pasid_free(HostIOMMUContext *host_icx,
+                                    uint32_t pasid)
+{
+    VFIOContainer *container = container_of(host_icx, VFIOContainer, host_icx);
+    struct vfio_iommu_type1_pasid_request req;
+    unsigned long argsz;
+    int ret;
+
+    argsz = sizeof(req);
+    req.argsz = argsz;
+    req.flags = VFIO_IOMMU_PASID_FREE;
+    req.free_pasid = pasid;
+
+    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
+        ret = -errno;
+        error_report("%s: %d, free failed", __func__, ret);
+        return ret;
+    }
+    return 0;
+}
+
 static int vfio_init_container(VFIOContainer *container, int group_fd,
                                Error **errp)
 {
     int iommu_type, ret;
+    uint64_t flags = 0;
 
     iommu_type = vfio_get_iommu_type(container, errp);
     if (iommu_type < 0) {
@@ -1210,6 +1255,18 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
         return -errno;
     }
 
+    if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
+        /*
+         * TODO: config flags per host IOMMU nesting capability
+         * e.g. check if VFIO_TYPE1_NESTING_IOMMU supports PASID
+         * alloc/free
+         */
+        host_iommu_ctx_init(&container->host_icx,
+                            sizeof(container->host_icx),
+                            TYPE_VFIO_HOST_IOMMU_CONTEXT,
+                            flags);
+    }
+
     container->iommu_type = iommu_type;
     return 0;
 }
@@ -1456,6 +1513,7 @@ static void vfio_disconnect_container(VFIOGroup *group)
         }
 
         trace_vfio_disconnect_container(container->fd);
+        host_iommu_ctx_destroy(&container->host_icx);
         close(container->fd);
         g_free(container);
 
@@ -1791,3 +1849,25 @@ int vfio_eeh_as_op(AddressSpace *as, uint32_t op)
     }
     return vfio_eeh_container_op(container, op);
 }
+
+static void vfio_host_iommu_context_class_init(ObjectClass *klass,
+                                                       void *data)
+{
+    HostIOMMUContextClass *hicxc = HOST_IOMMU_CONTEXT_CLASS(klass);
+
+    hicxc->pasid_alloc = vfio_host_icx_pasid_alloc;
+    hicxc->pasid_free = vfio_host_icx_pasid_free;
+}
+
+static const TypeInfo vfio_host_iommu_context_info = {
+    .parent = TYPE_HOST_IOMMU_CONTEXT,
+    .name = TYPE_VFIO_HOST_IOMMU_CONTEXT,
+    .class_init = vfio_host_iommu_context_class_init,
+};
+
+static void vfio_register_types(void)
+{
+    type_register_static(&vfio_host_iommu_context_info);
+}
+
+type_init(vfio_register_types)
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 5e75a95..f099df3 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2717,6 +2717,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
     VFIODevice *vbasedev_iter;
     VFIOGroup *group;
+    VFIOContainer *container;
     char *tmp, *subsys, group_path[PATH_MAX], *group_name;
     Error *err = NULL;
     ssize_t len;
@@ -3028,6 +3029,11 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     vfio_register_req_notifier(vdev);
     vfio_setup_resetfn_quirk(vdev);
 
+    container = vdev->vbasedev.group->container;
+    if (container->host_icx.initialized) {
+        pci_device_set_iommu_context(pdev, &container->host_icx);
+    }
+
     return;
 
 out_deregister:
@@ -3072,9 +3078,16 @@ static void vfio_instance_finalize(Object *obj)
 static void vfio_exitfn(PCIDevice *pdev)
 {
     VFIOPCIDevice *vdev = PCI_VFIO(pdev);
+    VFIOContainer *container;
 
     vfio_unregister_req_notifier(vdev);
     vfio_unregister_err_notifier(vdev);
+
+    container = vdev->vbasedev.group->container;
+    if (container->host_icx.initialized) {
+        pci_device_unset_iommu_context(pdev);
+    }
+
     pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
     if (vdev->irqchip_change_notifier.notify) {
         kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
index cfbf5ac..5f11a4c 100644
--- a/include/hw/iommu/host_iommu_context.h
+++ b/include/hw/iommu/host_iommu_context.h
@@ -33,6 +33,9 @@
 #define TYPE_HOST_IOMMU_CONTEXT "qemu:host-iommu-context"
 #define HOST_IOMMU_CONTEXT(obj) \
         OBJECT_CHECK(HostIOMMUContext, (obj), TYPE_HOST_IOMMU_CONTEXT)
+#define HOST_IOMMU_CONTEXT_CLASS(klass) \
+        OBJECT_CLASS_CHECK(HostIOMMUContextClass, (klass), \
+                         TYPE_HOST_IOMMU_CONTEXT)
 #define HOST_IOMMU_CONTEXT_GET_CLASS(obj) \
         OBJECT_GET_CLASS(HostIOMMUContextClass, (obj), \
                          TYPE_HOST_IOMMU_CONTEXT)
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index fd56420..532b78d 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -26,12 +26,15 @@
 #include "qemu/notify.h"
 #include "ui/console.h"
 #include "hw/display/ramfb.h"
+#include "hw/iommu/host_iommu_context.h"
 #ifdef CONFIG_LINUX
 #include <linux/vfio.h>
 #endif
 
 #define VFIO_MSG_PREFIX "vfio %s: "
 
+#define TYPE_VFIO_HOST_IOMMU_CONTEXT "qemu:vfio-host-iommu-context"
+
 enum {
     VFIO_DEVICE_TYPE_PCI = 0,
     VFIO_DEVICE_TYPE_PLATFORM = 1,
@@ -71,6 +74,7 @@ typedef struct VFIOContainer {
     MemoryListener listener;
     MemoryListener prereg_listener;
     unsigned iommu_type;
+    HostIOMMUContext host_icx;
     Error *error;
     bool initialized;
     unsigned long pgsizes;
-- 
2.7.4

