Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C325F1F682D
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 14:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgFKMsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 08:48:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:58113 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbgFKMsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 08:48:20 -0400
IronPort-SDR: PstIE/e6aczALhz9d58GLsBVOl2GHt/gesPtGXbF2CEnqgocs48LL4hS4mzcYjUC8QqqQ8oP7f
 cMQ1dwTxBIvA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 05:48:00 -0700
IronPort-SDR: N6PQBYIeFGw6C+9ZrDbFWZUJAvVGwuc3koE/YNoLYGBHcIcph28RvyisIMnKMredbZ2/JZ5iZj
 pDJKqLXDR88w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="447911281"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2020 05:48:00 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v6 21/25] vfio: add support for flush iommu stage-1 cache
Date:   Thu, 11 Jun 2020 05:54:20 -0700
Message-Id: <1591880064-30638-22-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591880064-30638-1-git-send-email-yi.l.liu@intel.com>
References: <1591880064-30638-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds flush_stage1_cache() definition in HostIOMUContextClass.
And adds corresponding implementation in VFIO. This is to expose a way
for vIOMMU to flush stage-1 cache in host side since guest owns stage-1
translation structures in dual stage DMA translation configuration.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/iommu/host_iommu_context.c         | 19 +++++++++++++++++++
 hw/vfio/common.c                      | 24 ++++++++++++++++++++++++
 include/hw/iommu/host_iommu_context.h |  8 ++++++++
 3 files changed, 51 insertions(+)

diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
index 5c5d5cf..293286a 100644
--- a/hw/iommu/host_iommu_context.c
+++ b/hw/iommu/host_iommu_context.c
@@ -113,6 +113,25 @@ int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
     return hicxc->unbind_stage1_pgtbl(iommu_ctx, unbind);
 }
 
+int host_iommu_ctx_flush_stage1_cache(HostIOMMUContext *iommu_ctx,
+                                 struct iommu_cache_invalidate_info *cache)
+{
+    HostIOMMUContextClass *hicxc;
+
+    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(iommu_ctx);
+
+    if (!hicxc) {
+        return -EINVAL;
+    }
+
+    if (!(iommu_ctx->flags & HOST_IOMMU_NESTING) ||
+        !hicxc->flush_stage1_cache) {
+        return -EINVAL;
+    }
+
+    return hicxc->flush_stage1_cache(iommu_ctx, cache);
+}
+
 void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
                          const char *mrtypename,
                          uint64_t flags,
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 3e500f5..241d044 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1276,6 +1276,29 @@ static int vfio_host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
     return ret;
 }
 
+static int vfio_host_iommu_ctx_flush_stage1_cache(HostIOMMUContext *iommu_ctx,
+                                    struct iommu_cache_invalidate_info *cache)
+{
+    VFIOContainer *container = container_of(iommu_ctx,
+                                            VFIOContainer, iommu_ctx);
+    struct vfio_iommu_type1_nesting_op *op;
+    unsigned long argsz;
+    int ret = 0;
+
+    argsz = sizeof(*op) + sizeof(*cache);
+    op = g_malloc0(argsz);
+    op->argsz = argsz;
+    op->flags = VFIO_IOMMU_NESTING_OP_CACHE_INVLD;
+    memcpy(&op->data, cache, sizeof(*cache));
+
+    if (ioctl(container->fd, VFIO_IOMMU_NESTING_OP, op)) {
+        ret = -errno;
+        error_report("%s: iommu cache flush failed: %m", __func__);
+    }
+    g_free(op);
+    return ret;
+}
+
 /**
  * Get iommu info from host. Caller of this funcion should free
  * the memory pointed by the returned pointer stored in @info
@@ -2016,6 +2039,7 @@ static void vfio_host_iommu_context_class_init(ObjectClass *klass,
     hicxc->pasid_free = vfio_host_iommu_ctx_pasid_free;
     hicxc->bind_stage1_pgtbl = vfio_host_iommu_ctx_bind_stage1_pgtbl;
     hicxc->unbind_stage1_pgtbl = vfio_host_iommu_ctx_unbind_stage1_pgtbl;
+    hicxc->flush_stage1_cache = vfio_host_iommu_ctx_flush_stage1_cache;
 }
 
 static const TypeInfo vfio_host_iommu_context_info = {
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
index 7fb8356..f98ffe9 100644
--- a/include/hw/iommu/host_iommu_context.h
+++ b/include/hw/iommu/host_iommu_context.h
@@ -64,6 +64,12 @@ typedef struct HostIOMMUContextClass {
     /* Undo a previous bind. @unbind specifies the unbind info. */
     int (*unbind_stage1_pgtbl)(HostIOMMUContext *iommu_ctx,
                                struct iommu_gpasid_unbind_data *unbind);
+    /*
+     * Propagate stage-1 cache flush to host IOMMU, cache
+     * info specifid in @cache
+     */
+    int (*flush_stage1_cache)(HostIOMMUContext *iommu_ctx,
+                              struct iommu_cache_invalidate_info *cache);
 } HostIOMMUContextClass;
 
 /*
@@ -85,6 +91,8 @@ int host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
                                      struct iommu_gpasid_bind_data *bind);
 int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
                                  struct iommu_gpasid_unbind_data *unbind);
+int host_iommu_ctx_flush_stage1_cache(HostIOMMUContext *iommu_ctx,
+                               struct iommu_cache_invalidate_info *cache);
 
 void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
                          const char *mrtypename,
-- 
2.7.4

