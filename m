Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE12414CA6E
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgA2MLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:11:52 -0500
Received: from mga04.intel.com ([192.55.52.120]:15945 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgA2MLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:11:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:11:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="314071012"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 04:11:48 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com
Cc:     mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3 11/25] vfio: get stage-1 pasid formats from Kernel
Date:   Wed, 29 Jan 2020 04:16:42 -0800
Message-Id: <1580300216-86172-12-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

VFIO checks IOMMU UAPI version when it finds Kernel supports
VFIO_TYPE1_NESTING_IOMMU. It is enough for UAPI compatibility
check. However, IOMMU UAPI may support multiple stage-1 pasid
formats in a specific UAPI version, which is highly possible
since IOMMU UAPI supports stage-1 formats across all IOMMU vendors.
So VFIO needs to get the supported formats from Kernel and tell
vIOMMU. Let vIOMMU select proper format when setup dual stage DMA
translation.

This patch gets the stage-1 pasid format from kernel by using IOCTL
VFIO_IOMMU_GET_INFO and pass the supported format to vIOMMU by the
DualStageIOMMUObject instance which has been registered to vIOMMU.

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
 hw/iommu/dual_stage_iommu.c         |  5 ++-
 hw/vfio/common.c                    | 85 ++++++++++++++++++++++++++++++++++++-
 include/hw/iommu/dual_stage_iommu.h | 10 ++++-
 3 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/hw/iommu/dual_stage_iommu.c b/hw/iommu/dual_stage_iommu.c
index be4179d..d5a7168 100644
--- a/hw/iommu/dual_stage_iommu.c
+++ b/hw/iommu/dual_stage_iommu.c
@@ -48,9 +48,12 @@ int ds_iommu_pasid_free(DualStageIOMMUObject *dsi_obj, uint32_t pasid)
 }
 
 void ds_iommu_object_init(DualStageIOMMUObject *dsi_obj,
-                          DualStageIOMMUOps *ops)
+                          DualStageIOMMUOps *ops,
+                          DualStageIOMMUInfo *uinfo)
 {
     dsi_obj->ops = ops;
+
+    dsi_obj->uinfo.pasid_format = uinfo->pasid_format;
 }
 
 void ds_iommu_object_destroy(DualStageIOMMUObject *dsi_obj)
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index fc1723d..a07824b 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1182,10 +1182,84 @@ static int vfio_get_iommu_type(VFIOContainer *container,
 static struct DualStageIOMMUOps vfio_ds_iommu_ops = {
 };
 
+static int vfio_get_iommu_info(VFIOContainer *container,
+                         struct vfio_iommu_type1_info **info)
+{
+
+    size_t argsz = sizeof(struct vfio_iommu_type1_info);
+
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
+static int vfio_get_nesting_iommu_format(VFIOContainer *container,
+                                         uint32_t *pasid_format)
+{
+    struct vfio_iommu_type1_info *info;
+    struct vfio_info_cap_header *hdr;
+    struct vfio_iommu_type1_info_cap_nesting *cap;
+
+    if (vfio_get_iommu_info(container, &info)) {
+        return -errno;
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
+    *pasid_format = cap->pasid_format;
+
+    g_free(info);
+    return 0;
+}
+
 static int vfio_init_container(VFIOContainer *container, int group_fd,
                                Error **errp)
 {
     int iommu_type, ret;
+    uint32_t format;
+    DualStageIOMMUInfo uinfo;
 
     iommu_type = vfio_get_iommu_type(container, errp);
     if (iommu_type < 0) {
@@ -1214,7 +1288,16 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
     }
 
     if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
-        ds_iommu_object_init(&container->dsi_obj, &vfio_ds_iommu_ops);
+        if (vfio_get_nesting_iommu_format(container, &format)) {
+            error_setg_errno(errp, errno,
+                             "Failed to get nesting iommu format");
+            return -errno;
+        }
+
+        uinfo.pasid_format = format;
+        ds_iommu_object_init(&container->dsi_obj,
+                             &vfio_ds_iommu_ops, &uinfo);
+
         if (iommu_context_register_ds_iommu(container->iommu_ctx,
                                             &container->dsi_obj)) {
             /*
diff --git a/include/hw/iommu/dual_stage_iommu.h b/include/hw/iommu/dual_stage_iommu.h
index e9891e3..c6100b4 100644
--- a/include/hw/iommu/dual_stage_iommu.h
+++ b/include/hw/iommu/dual_stage_iommu.h
@@ -23,12 +23,14 @@
 #define HW_DS_IOMMU_H
 
 #include "qemu/queue.h"
+#include <linux/iommu.h>
 #ifndef CONFIG_USER_ONLY
 #include "exec/hwaddr.h"
 #endif
 
 typedef struct DualStageIOMMUObject DualStageIOMMUObject;
 typedef struct DualStageIOMMUOps DualStageIOMMUOps;
+typedef struct DualStageIOMMUInfo DualStageIOMMUInfo;
 
 struct DualStageIOMMUOps {
     /* Allocate pasid from DualStageIOMMU (a.k.a. host IOMMU) */
@@ -41,11 +43,16 @@ struct DualStageIOMMUOps {
                       uint32_t pasid);
 };
 
+struct DualStageIOMMUInfo {
+    uint32_t pasid_format;
+};
+
 /*
  * This is an abstraction of Dual-stage IOMMU.
  */
 struct DualStageIOMMUObject {
     DualStageIOMMUOps *ops;
+    DualStageIOMMUInfo uinfo;
 };
 
 int ds_iommu_pasid_alloc(DualStageIOMMUObject *dsi_obj, uint32_t min,
@@ -53,7 +60,8 @@ int ds_iommu_pasid_alloc(DualStageIOMMUObject *dsi_obj, uint32_t min,
 int ds_iommu_pasid_free(DualStageIOMMUObject *dsi_obj, uint32_t pasid);
 
 void ds_iommu_object_init(DualStageIOMMUObject *dsi_obj,
-                          DualStageIOMMUOps *ops);
+                          DualStageIOMMUOps *ops,
+                          DualStageIOMMUInfo *uinfo);
 void ds_iommu_object_destroy(DualStageIOMMUObject *dsi_obj);
 
 #endif
-- 
2.7.4

