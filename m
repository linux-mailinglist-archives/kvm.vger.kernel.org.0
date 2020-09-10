Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E29D2644ED
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 13:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbgIJK7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:59:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:6916 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730609AbgIJK4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:56:40 -0400
IronPort-SDR: joO7FawhN3Ngj0oRA78TXIGCT0bO541ojpg8RSr73TLv2tMwTL1ZGMBXpPiBFAAjTcyjYzDqjt
 pkMKVsHg4TPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="159459147"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="159459147"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:54:40 -0700
IronPort-SDR: 7hvIrgrGnxw8CTd+Mee4bnG82zdBDf73syyEouKcS7uzgKaNmeM1/UJhxMK/q9YPpwihu3GBZn
 1/TzD9uNXk9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="334140082"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:54:40 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v10 16/25] vfio: add bind stage-1 page table support
Date:   Thu, 10 Sep 2020 03:56:29 -0700
Message-Id: <1599735398-6829-17-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599735398-6829-1-git-send-email-yi.l.liu@intel.com>
References: <1599735398-6829-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds bind_stage1_pgtbl() definition in HostIOMMUContextClass,
also adds corresponding implementation in VFIO. This is to expose a way
for vIOMMU to setup dual stage DMA translation for passthru devices on
hardware.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/iommu/host_iommu_context.c         | 57 +++++++++++++++++++++++++++++++++-
 hw/vfio/common.c                      | 58 ++++++++++++++++++++++++++++++++++-
 include/hw/iommu/host_iommu_context.h | 19 +++++++++++-
 3 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
index 5fb2223..c43965c 100644
--- a/hw/iommu/host_iommu_context.c
+++ b/hw/iommu/host_iommu_context.c
@@ -69,23 +69,78 @@ int host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx, uint32_t pasid)
     return hicxc->pasid_free(iommu_ctx, pasid);
 }
 
+int host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                     struct iommu_gpasid_bind_data *bind)
+{
+    HostIOMMUContextClass *hicxc;
+
+    if (!iommu_ctx) {
+        return -EINVAL;
+    }
+
+    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(iommu_ctx);
+    if (!hicxc) {
+        return -EINVAL;
+    }
+
+    if (!(iommu_ctx->flags & HOST_IOMMU_NESTING) ||
+        !hicxc->bind_stage1_pgtbl) {
+        return -EINVAL;
+    }
+
+    return hicxc->bind_stage1_pgtbl(iommu_ctx, bind);
+}
+
+int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                 struct iommu_gpasid_bind_data *unbind)
+{
+    HostIOMMUContextClass *hicxc;
+
+    if (!iommu_ctx) {
+        return -EINVAL;
+    }
+
+    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(iommu_ctx);
+    if (!hicxc) {
+        return -EINVAL;
+    }
+
+    if (!(iommu_ctx->flags & HOST_IOMMU_NESTING) ||
+        !hicxc->unbind_stage1_pgtbl) {
+        return -EINVAL;
+    }
+
+    return hicxc->unbind_stage1_pgtbl(iommu_ctx, unbind);
+}
+
 void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
                          const char *mrtypename,
-                         uint64_t flags)
+                         uint64_t flags,
+                         struct iommu_nesting_info *info)
 {
     HostIOMMUContext *iommu_ctx;
 
     object_initialize(_iommu_ctx, instance_size, mrtypename);
     iommu_ctx = HOST_IOMMU_CONTEXT(_iommu_ctx);
     iommu_ctx->flags = flags;
+    iommu_ctx->info = g_malloc0(info->argsz);
+    memcpy(iommu_ctx->info, info, info->argsz);
     iommu_ctx->initialized = true;
 }
 
+static void host_iommu_ctx_finalize_fn(Object *obj)
+{
+    HostIOMMUContext *iommu_ctx = HOST_IOMMU_CONTEXT(obj);
+
+    g_free(iommu_ctx->info);
+}
+
 static const TypeInfo host_iommu_context_info = {
     .parent             = TYPE_OBJECT,
     .name               = TYPE_HOST_IOMMU_CONTEXT,
     .class_size         = sizeof(HostIOMMUContextClass),
     .instance_size      = sizeof(HostIOMMUContext),
+    .instance_finalize  = host_iommu_ctx_finalize_fn,
     .abstract           = true,
 };
 
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index f41deeb..74dbeaf 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1227,6 +1227,54 @@ static int vfio_host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx,
     return ret;
 }
 
+static int vfio_host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                         struct iommu_gpasid_bind_data *bind)
+{
+    VFIOContainer *container = container_of(iommu_ctx,
+                                            VFIOContainer, iommu_ctx);
+    struct vfio_iommu_type1_nesting_op *op;
+    unsigned long argsz;
+    int ret = 0;
+
+    argsz = sizeof(*op) + sizeof(*bind);
+    op = g_malloc0(argsz);
+    op->argsz = argsz;
+    op->flags = VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
+    memcpy(&op->data, bind, sizeof(*bind));
+
+    if (ioctl(container->fd, VFIO_IOMMU_NESTING_OP, op)) {
+        ret = -errno;
+        error_report("%s: pasid (%llu) bind failed: %m",
+                      __func__, bind->hpasid);
+    }
+    g_free(op);
+    return ret;
+}
+
+static int vfio_host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                         struct iommu_gpasid_bind_data *unbind)
+{
+    VFIOContainer *container = container_of(iommu_ctx,
+                                            VFIOContainer, iommu_ctx);
+    struct vfio_iommu_type1_nesting_op *op;
+    unsigned long argsz;
+    int ret = 0;
+
+    argsz = sizeof(*op) + sizeof(*unbind);
+    op = g_malloc0(argsz);
+    op->argsz = argsz;
+    op->flags = VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL;
+    memcpy(&op->data, unbind, sizeof(*unbind));
+
+    if (ioctl(container->fd, VFIO_IOMMU_NESTING_OP, op)) {
+        ret = -errno;
+        error_report("%s: pasid (%llu) unbind failed: %m",
+                      __func__, unbind->hpasid);
+    }
+    g_free(op);
+    return ret;
+}
+
 /**
  * Get iommu info from host. Caller of this funcion should free
  * the memory pointed by the returned pointer stored in @info
@@ -1364,10 +1412,16 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
         nest_info = (struct iommu_nesting_info *) &nesting->info;
         flags |= (nest_info->features & IOMMU_NESTING_FEAT_SYSWIDE_PASID) ?
                  HOST_IOMMU_PASID_REQUEST : 0;
+        if ((nest_info->features & IOMMU_NESTING_FEAT_BIND_PGTBL) &&
+            (nest_info->features & IOMMU_NESTING_FEAT_CACHE_INVLD)) {
+            flags |= HOST_IOMMU_NESTING;
+        }
+
         host_iommu_ctx_init(&container->iommu_ctx,
                             sizeof(container->iommu_ctx),
                             TYPE_VFIO_HOST_IOMMU_CONTEXT,
-                            flags);
+                            flags,
+                            nest_info);
         g_free(nesting);
     }
 
@@ -1967,6 +2021,8 @@ static void vfio_host_iommu_context_class_init(ObjectClass *klass,
 
     hicxc->pasid_alloc = vfio_host_iommu_ctx_pasid_alloc;
     hicxc->pasid_free = vfio_host_iommu_ctx_pasid_free;
+    hicxc->bind_stage1_pgtbl = vfio_host_iommu_ctx_bind_stage1_pgtbl;
+    hicxc->unbind_stage1_pgtbl = vfio_host_iommu_ctx_unbind_stage1_pgtbl;
 }
 
 static const TypeInfo vfio_host_iommu_context_info = {
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
index 227c433..2883ed8 100644
--- a/include/hw/iommu/host_iommu_context.h
+++ b/include/hw/iommu/host_iommu_context.h
@@ -54,6 +54,16 @@ typedef struct HostIOMMUContextClass {
     /* Reclaim pasid from HostIOMMUContext (a.k.a. host software) */
     int (*pasid_free)(HostIOMMUContext *iommu_ctx,
                       uint32_t pasid);
+    /*
+     * Bind stage-1 page table to a hostIOMMU w/ dual stage
+     * DMA translation capability.
+     * @bind specifies the bind configurations.
+     */
+    int (*bind_stage1_pgtbl)(HostIOMMUContext *iommu_ctx,
+                             struct iommu_gpasid_bind_data *bind);
+    /* Undo a previous bind. @unbind specifies the unbind info. */
+    int (*unbind_stage1_pgtbl)(HostIOMMUContext *iommu_ctx,
+                               struct iommu_gpasid_bind_data *unbind);
 } HostIOMMUContextClass;
 
 /*
@@ -62,17 +72,24 @@ typedef struct HostIOMMUContextClass {
 struct HostIOMMUContext {
     Object parent_obj;
 #define HOST_IOMMU_PASID_REQUEST (1ULL << 0)
+#define HOST_IOMMU_NESTING       (1ULL << 1)
     uint64_t flags;
+    struct iommu_nesting_info *info;
     bool initialized;
 };
 
 int host_iommu_ctx_pasid_alloc(HostIOMMUContext *iommu_ctx, uint32_t min,
                                uint32_t max, uint32_t *pasid);
 int host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx, uint32_t pasid);
+int host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                     struct iommu_gpasid_bind_data *bind);
+int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                 struct iommu_gpasid_bind_data *unbind);
 
 void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
                          const char *mrtypename,
-                         uint64_t flags);
+                         uint64_t flags,
+                         struct iommu_nesting_info *info);
 void host_iommu_ctx_destroy(HostIOMMUContext *iommu_ctx);
 
 #endif
-- 
2.7.4

