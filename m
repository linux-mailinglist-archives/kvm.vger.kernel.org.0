Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49012302E2
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgG1G2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:28:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:37269 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbgG1G1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:45 -0400
IronPort-SDR: ZE1Dwbl0dDzfxEgSpULmAkEbsXQ8D/4kuyLflhVjZJHdaKsyzn2e7UF1nYhy4T2r3kjqQlgUdk
 YtGLBmOHXi1w==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="152412024"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="152412024"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:37 -0700
IronPort-SDR: MEuGDxouWQb4p+84+laiJ8T4xEUiEjhPKXqZPGlnYVjH9jWXhh+wszdWlo7wkPtx7ZMa5tFSxP
 SA2+BWLHFjRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394232852"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:36 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v9 07/25] vfio: check VFIO_TYPE1_NESTING_IOMMU support
Date:   Mon, 27 Jul 2020 23:34:00 -0700
Message-Id: <1595918058-33392-8-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO needs to check VFIO_TYPE1_NESTING_IOMMU support with Kernel before
further using it. e.g. requires to check IOMMU UAPI support.

Referred patch from Eric Auger: https://patchwork.kernel.org/patch/11040499/

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 hw/vfio/common.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 80d7a00..af91eca 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1151,30 +1151,44 @@ static void vfio_put_address_space(VFIOAddressSpace *space)
 }
 
 /*
- * vfio_get_iommu_type - selects the richest iommu_type (v2 first)
+ * vfio_get_iommu_type - selects the richest iommu_type (NESTING first)
  */
 static int vfio_get_iommu_type(VFIOContainer *container,
+                               bool want_nested,
                                Error **errp)
 {
-    int iommu_types[] = { VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
+    int iommu_types[] = { VFIO_TYPE1_NESTING_IOMMU,
+                          VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
                           VFIO_SPAPR_TCE_v2_IOMMU, VFIO_SPAPR_TCE_IOMMU };
-    int i;
+    int i, ret = -EINVAL;
 
     for (i = 0; i < ARRAY_SIZE(iommu_types); i++) {
         if (ioctl(container->fd, VFIO_CHECK_EXTENSION, iommu_types[i])) {
-            return iommu_types[i];
+            if (iommu_types[i] == VFIO_TYPE1_NESTING_IOMMU) {
+                if (!want_nested) {
+                    continue;
+                }
+            }
+            ret = iommu_types[i];
+            break;
         }
     }
-    error_setg(errp, "No available IOMMU models");
-    return -EINVAL;
+
+    if (ret < 0) {
+        error_setg(errp, "No available IOMMU models");
+    } else if (want_nested && ret != VFIO_TYPE1_NESTING_IOMMU) {
+        error_setg(errp, "Nested mode requested but not supported");
+        ret = -EINVAL;
+    }
+    return ret;
 }
 
 static int vfio_init_container(VFIOContainer *container, int group_fd,
-                               Error **errp)
+                               bool want_nested, Error **errp)
 {
     int iommu_type, ret;
 
-    iommu_type = vfio_get_iommu_type(container, errp);
+    iommu_type = vfio_get_iommu_type(container, want_nested, errp);
     if (iommu_type < 0) {
         return iommu_type;
     }
@@ -1205,7 +1219,7 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
 }
 
 static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
-                                  Error **errp)
+                                  bool want_nested, Error **errp)
 {
     VFIOContainer *container;
     int ret, fd;
@@ -1276,12 +1290,13 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
     QLIST_INIT(&container->giommu_list);
     QLIST_INIT(&container->hostwin_list);
 
-    ret = vfio_init_container(container, group->fd, errp);
+    ret = vfio_init_container(container, group->fd, want_nested, errp);
     if (ret) {
         goto free_container_exit;
     }
 
     switch (container->iommu_type) {
+    case VFIO_TYPE1_NESTING_IOMMU:
     case VFIO_TYPE1v2_IOMMU:
     case VFIO_TYPE1_IOMMU:
     {
@@ -1502,7 +1517,7 @@ VFIOGroup *vfio_get_group(int groupid, AddressSpace *as,
     group->groupid = groupid;
     QLIST_INIT(&group->device_list);
 
-    if (vfio_connect_container(group, as, errp)) {
+    if (vfio_connect_container(group, as, want_nested, errp)) {
         error_prepend(errp, "failed to setup container for group %d: ",
                       groupid);
         goto close_fd_exit;
-- 
2.7.4

