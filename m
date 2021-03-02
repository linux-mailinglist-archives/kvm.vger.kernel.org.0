Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A156532A753
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839288AbhCBQGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:06:45 -0500
Received: from mga04.intel.com ([192.55.52.120]:30499 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447344AbhCBMw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:52:28 -0500
IronPort-SDR: jDnS6GuTRw13W/nRCnaibS2X2MjoLHpO5lQ2pzh6z0fyK4ylbzgwgCyWI1FjmxX+sVVyfOeVsr
 WlBMPMx1bB/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="184363242"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="184363242"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:40:02 -0800
IronPort-SDR: btrSUPgz3QbnkqBUOPX3XoGo5aHkL2h6PRi3dnBG61ML97vw0TKrOl2VsgxP/4N5JD+NLK0JZR
 td9lz4hvFNuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472795"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:39:58 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Lingshan.Zhu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v11 08/25] vfio: check VFIO_TYPE1_NESTING_IOMMU support
Date:   Wed,  3 Mar 2021 04:38:10 +0800
Message-Id: <20210302203827.437645-9-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 44097875e2..883815d5b0 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1543,30 +1543,44 @@ static void vfio_put_address_space(VFIOAddressSpace *space)
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
@@ -1666,7 +1680,7 @@ static void vfio_get_iommu_info_migration(VFIOContainer *container,
 }
 
 static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
-                                  Error **errp)
+                                  bool want_nested, Error **errp)
 {
     VFIOContainer *container;
     int ret, fd;
@@ -1738,12 +1752,13 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
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
@@ -1968,7 +1983,7 @@ VFIOGroup *vfio_get_group(int groupid, AddressSpace *as,
     group->groupid = groupid;
     QLIST_INIT(&group->device_list);
 
-    if (vfio_connect_container(group, as, errp)) {
+    if (vfio_connect_container(group, as, want_nested, errp)) {
         error_prepend(errp, "failed to setup container for group %d: ",
                       groupid);
         goto close_fd_exit;
-- 
2.25.1

