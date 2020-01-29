Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C936A14CA7C
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgA2MLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:11:51 -0500
Received: from mga04.intel.com ([192.55.52.120]:15948 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbgA2MLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:11:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 04:11:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,377,1574150400"; 
   d="scan'208";a="314070985"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jan 2020 04:11:47 -0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com
Cc:     mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3 10/25] vfio: register DualStageIOMMUObject to vIOMMU
Date:   Wed, 29 Jan 2020 04:16:41 -0800
Message-Id: <1580300216-86172-11-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liu Yi L <yi.l.liu@intel.com>

After confirming dual stage DMA translation support
with kernel by checking VFIO_TYPE1_NESTING_IOMMU,
VFIO could register DualStageIOMMUObject instance to
vIOMMU, thus that vIOMMU is aware of such hardware
capability. vIOMMU may make use of such capability by
leveraging the ops provided by DualStageIOMMUObject.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/vfio/common.c              | 30 ++++++++++++++++++++++++++++--
 include/hw/vfio/vfio-common.h |  2 ++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index a5e70b1..fc1723d 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1179,6 +1179,9 @@ static int vfio_get_iommu_type(VFIOContainer *container,
     return -EINVAL;
 }
 
+static struct DualStageIOMMUOps vfio_ds_iommu_ops = {
+};
+
 static int vfio_init_container(VFIOContainer *container, int group_fd,
                                Error **errp)
 {
@@ -1210,12 +1213,29 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
         return -errno;
     }
 
+    if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
+        ds_iommu_object_init(&container->dsi_obj, &vfio_ds_iommu_ops);
+        if (iommu_context_register_ds_iommu(container->iommu_ctx,
+                                            &container->dsi_obj)) {
+            /*
+             * Here just need an info to indicate that there is no
+             * DualStageIOMMUObject instance registered to vIOMMU
+             * due to either no IOMMUContext support in vIOMMU or
+             * vIOMMU internal failure. Neither is fatal error to
+             * VFIO as it is not mandatory requirement to use such
+             * capability in vIOMMU.
+             */
+            printf("No Dual Stage IOMMU for container(0x%p)\n", container);
+            ds_iommu_object_destroy(&container->dsi_obj);
+        }
+    }
+
     container->iommu_type = iommu_type;
     return 0;
 }
 
 static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
-                                  Error **errp)
+                                  IOMMUContext *iommu_ctx, Error **errp)
 {
     VFIOContainer *container;
     int ret, fd;
@@ -1277,6 +1297,7 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
     container = g_malloc0(sizeof(*container));
     container->space = space;
     container->fd = fd;
+    container->iommu_ctx = iommu_ctx;
     container->error = NULL;
     QLIST_INIT(&container->giommu_list);
     QLIST_INIT(&container->hostwin_list);
@@ -1457,6 +1478,11 @@ static void vfio_disconnect_container(VFIOGroup *group)
 
         trace_vfio_disconnect_container(container->fd);
         close(container->fd);
+        if (container->iommu_ctx) {
+            iommu_context_unregister_ds_iommu(container->iommu_ctx,
+                                              &container->dsi_obj);
+        }
+        ds_iommu_object_destroy(&container->dsi_obj);
         g_free(container);
 
         vfio_put_address_space(space);
@@ -1508,7 +1534,7 @@ VFIOGroup *vfio_get_group(int groupid, AddressSpace *as,
     group->groupid = groupid;
     QLIST_INIT(&group->device_list);
 
-    if (vfio_connect_container(group, as, errp)) {
+    if (vfio_connect_container(group, as, iommu_ctx, errp)) {
         error_prepend(errp, "failed to setup container for group %d: ",
                       groupid);
         goto close_fd_exit;
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 8ab68fa..dc68552 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -72,6 +72,8 @@ typedef struct VFIOContainer {
     MemoryListener listener;
     MemoryListener prereg_listener;
     unsigned iommu_type;
+    IOMMUContext *iommu_ctx;
+    DualStageIOMMUObject dsi_obj;
     Error *error;
     bool initialized;
     unsigned long pgsizes;
-- 
2.7.4

