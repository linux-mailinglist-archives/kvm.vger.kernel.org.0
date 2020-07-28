Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7E52302DF
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgG1G1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:27:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:41268 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgG1G1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:45 -0400
IronPort-SDR: 8/4QnLfyIXxuZs+r9o2JzUltBqpxJbobprS5V8PBW3B4fRDCBbSxizlgQ2lqLlCAPMdZ/NkkdQ
 o1Mafy2rnLFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="149021043"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="149021043"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:41 -0700
IronPort-SDR: ZZBh2i2ZiLLbFq2GI8n1scT1MUTr2ELDtZKZ6a62v2422P609PZmiTGok7fQ4Y3rhkjetKls9u
 qv8FmENxgEzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394232901"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:40 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v9 11/25] vfio/common: provide PASID alloc/free hooks
Date:   Mon, 27 Jul 2020 23:34:04 -0700
Message-Id: <1595918058-33392-12-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch defines vfio_host_iommu_context_info, implements the PASID
alloc/free hooks defined in HostIOMMUContextClass.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/common.c                      | 66 +++++++++++++++++++++++++++++++++++
 include/hw/iommu/host_iommu_context.h |  3 ++
 include/hw/vfio/vfio-common.h         |  4 +++
 3 files changed, 73 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index af91eca..41aaf41 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1183,6 +1183,50 @@ static int vfio_get_iommu_type(VFIOContainer *container,
     return ret;
 }
 
+static int vfio_host_iommu_ctx_pasid_alloc(HostIOMMUContext *iommu_ctx,
+                                           uint32_t min, uint32_t max,
+                                           uint32_t *pasid)
+{
+    VFIOContainer *container = container_of(iommu_ctx,
+                                            VFIOContainer, iommu_ctx);
+    struct vfio_iommu_type1_pasid_request req;
+    int ret = 0;
+
+    req.argsz = sizeof(req);
+    req.flags = VFIO_IOMMU_FLAG_ALLOC_PASID;
+    req.range.min = min;
+    req.range.max = max;
+
+    ret = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
+    if (ret < 0) {
+        error_report("%s: alloc failed (%m)", __func__);
+        return ret;
+    }
+    *pasid = ret;
+    return 0;
+}
+
+static int vfio_host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx,
+                                          uint32_t pasid)
+{
+    VFIOContainer *container = container_of(iommu_ctx,
+                                            VFIOContainer, iommu_ctx);
+    struct vfio_iommu_type1_pasid_request req;
+
+    int ret = 0;
+
+    req.argsz = sizeof(req);
+    req.flags = VFIO_IOMMU_FLAG_FREE_PASID;
+    req.range.min = pasid;
+    req.range.max = pasid + 1;
+
+    ret = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
+    if (ret) {
+        error_report("%s: free failed (%m)", __func__);
+    }
+    return ret;
+}
+
 static int vfio_init_container(VFIOContainer *container, int group_fd,
                                bool want_nested, Error **errp)
 {
@@ -1802,3 +1846,25 @@ int vfio_eeh_as_op(AddressSpace *as, uint32_t op)
     }
     return vfio_eeh_container_op(container, op);
 }
+
+static void vfio_host_iommu_context_class_init(ObjectClass *klass,
+                                                       void *data)
+{
+    HostIOMMUContextClass *hicxc = HOST_IOMMU_CONTEXT_CLASS(klass);
+
+    hicxc->pasid_alloc = vfio_host_iommu_ctx_pasid_alloc;
+    hicxc->pasid_free = vfio_host_iommu_ctx_pasid_free;
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
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
index 35c4861..227c433 100644
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
index bdb09f4..a5eaf35 100644
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
+    HostIOMMUContext iommu_ctx;
     Error *error;
     bool initialized;
     unsigned long pgsizes;
-- 
2.7.4

