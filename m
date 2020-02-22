Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC66A168D56
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgBVIB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:01:59 -0500
Received: from mga04.intel.com ([192.55.52.120]:65090 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgBVIB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:01:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547671"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2020 00:01:56 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3.1 07/22] vfio: get nesting iommu cap info from Kernel
Date:   Sat, 22 Feb 2020 00:07:08 -0800
Message-Id: <1582358843-51931-8-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO exposes host IOMMU dual-stage DMA translation programming capability
to userspace by VFIO_TYPE1_NESTING_IOMMU type. However, userspace needs
more info on the nesting type. e.g. the supported stage 1 format and PASID
alloc/free request availability.

This patch gets the iommu nesting cap info from kernel by using IOCTL
VFIO_IOMMU_GET_INFO.

This patch referred some code from Shameer Kolothum.
https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg03759.html

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/iommu/host_iommu_context.c         |  5 +-
 hw/vfio/common.c                      | 97 ++++++++++++++++++++++++++++++++++-
 include/hw/iommu/host_iommu_context.h | 10 +++-
 3 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
index 11b092f..689a087 100644
--- a/hw/iommu/host_iommu_context.c
+++ b/hw/iommu/host_iommu_context.c
@@ -42,10 +42,13 @@ int host_iommu_ctx_pasid_free(HostIOMMUContext *host_icx, uint32_t pasid)
 }
 
 void host_iommu_ctx_init(HostIOMMUContext *host_icx,
-                         uint64_t flags, HostIOMMUOps *ops)
+                         uint64_t flags, HostIOMMUOps *ops,
+                         HostIOMMUInfo *uinfo)
 {
     host_icx->flags = flags;
     host_icx->ops = ops;
+
+    host_icx->uinfo.stage1_format = uinfo->stage1_format;
 }
 
 void host_iommu_ctx_destroy(HostIOMMUContext *host_icx)
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 9ab62a6..f9be68d 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1183,6 +1183,84 @@ static struct HostIOMMUOps vfio_host_icx_ops = {
 /* To be added later */
 };
 
+/**
+ * Get iommu info from host. Caller of this funcion should free
+ * the memory pointed by the returned pointer stored in @info
+ * after a successful calling when finished its usage.
+ */
+static int vfio_get_iommu_info(VFIOContainer *container,
+                         struct vfio_iommu_type1_info **info)
+{
+
+    size_t argsz = sizeof(struct vfio_iommu_type1_info);
+
+    *info = g_malloc0(argsz);
+
+retry:
+    (*info)->argsz = argsz;
+
+    if (ioctl(container->fd, VFIO_IOMMU_GET_INFO, *info)) {
+        g_free(*info);
+        *info = NULL;
+        return -errno;
+    }
+
+    if (((*info)->argsz > argsz)) {
+        argsz = (*info)->argsz;
+        *info = g_realloc(*info, argsz);
+        goto retry;
+    }
+
+    return 0;
+}
+
+static struct vfio_info_cap_header *
+vfio_get_iommu_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
+{
+    struct vfio_info_cap_header *hdr;
+    void *ptr = info;
+
+    if (!(info->flags & VFIO_IOMMU_INFO_CAPS)) {
+        return NULL;
+    }
+
+    for (hdr = ptr + info->cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
+        if (hdr->id == id) {
+            return hdr;
+        }
+    }
+
+    return NULL;
+}
+
+static int vfio_get_nesting_iommu_cap(VFIOContainer *container,
+                   struct vfio_iommu_type1_info_cap_nesting *cap_nesting)
+{
+    struct vfio_iommu_type1_info *info;
+    struct vfio_info_cap_header *hdr;
+    struct vfio_iommu_type1_info_cap_nesting *cap;
+    int ret;
+
+    ret = vfio_get_iommu_info(container, &info);
+    if (ret) {
+        return ret;
+    }
+
+    hdr = vfio_get_iommu_info_cap(info,
+                        VFIO_IOMMU_TYPE1_INFO_CAP_NESTING);
+    if (!hdr) {
+        g_free(info);
+        return -errno;
+    }
+
+    cap = container_of(hdr,
+                struct vfio_iommu_type1_info_cap_nesting, header);
+    *cap_nesting = *cap;
+
+    g_free(info);
+    return 0;
+}
+
 static int vfio_init_container(VFIOContainer *container, int group_fd,
                                Error **errp)
 {
@@ -1216,8 +1294,23 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
     }
 
     if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
-        host_iommu_ctx_init(&container->host_icx,
-                            flags, &vfio_host_icx_ops);
+        struct vfio_iommu_type1_info_cap_nesting nesting = {
+                                         .nesting_capabilities = 0x0,
+                                         .stage1_format = 0, };
+        HostIOMMUInfo uinfo;
+
+        ret = vfio_get_nesting_iommu_cap(container, &nesting);
+        if (ret) {
+            error_setg_errno(errp, -ret,
+                             "Failed to get nesting iommu cap");
+            return ret;
+        }
+
+        uinfo.stage1_format = nesting.stage1_format;
+        flags |= (nesting.nesting_capabilities & VFIO_IOMMU_PASID_REQS) ?
+                 HOST_IOMMU_PASID_REQUEST : 0;
+        host_iommu_ctx_init(&container->host_icx, flags,
+                            &vfio_host_icx_ops, &uinfo);
     }
 
     container->iommu_type = iommu_type;
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
index f4d811a..6797f6d 100644
--- a/include/hw/iommu/host_iommu_context.h
+++ b/include/hw/iommu/host_iommu_context.h
@@ -23,12 +23,14 @@
 #define HW_IOMMU_CONTEXT_H
 
 #include "qemu/queue.h"
+#include <linux/iommu.h>
 #ifndef CONFIG_USER_ONLY
 #include "exec/hwaddr.h"
 #endif
 
 typedef struct HostIOMMUContext HostIOMMUContext;
 typedef struct HostIOMMUOps HostIOMMUOps;
+typedef struct HostIOMMUInfo HostIOMMUInfo;
 
 struct HostIOMMUOps {
     /* Allocate pasid from HostIOMMUContext (a.k.a. host software) */
@@ -41,6 +43,10 @@ struct HostIOMMUOps {
                       uint32_t pasid);
 };
 
+struct HostIOMMUInfo {
+    uint32_t stage1_format;
+};
+
 /*
  * This is an abstraction of host IOMMU with dual-stage capability
  */
@@ -48,6 +54,7 @@ struct HostIOMMUContext {
 #define HOST_IOMMU_PASID_REQUEST (1ULL << 0)
     uint64_t flags;
     HostIOMMUOps *ops;
+    HostIOMMUInfo uinfo;
 };
 
 int host_iommu_ctx_pasid_alloc(HostIOMMUContext *host_icx, uint32_t min,
@@ -55,7 +62,8 @@ int host_iommu_ctx_pasid_alloc(HostIOMMUContext *host_icx, uint32_t min,
 int host_iommu_ctx_pasid_free(HostIOMMUContext *host_icx, uint32_t pasid);
 
 void host_iommu_ctx_init(HostIOMMUContext *host_icx,
-                         uint64_t flags, HostIOMMUOps *ops);
+                         uint64_t flags, HostIOMMUOps *ops,
+                         HostIOMMUInfo *uinfo);
 void host_iommu_ctx_destroy(HostIOMMUContext *host_icx);
 
 #endif
-- 
2.7.4

