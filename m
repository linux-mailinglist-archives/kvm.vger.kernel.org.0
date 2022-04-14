Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E13500B7B
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242463AbiDNKuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242473AbiDNKt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:49:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6D48149D
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933246; x=1681469246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xY7UyaVEvJ5caj+3+YkMuOpNZxDlr5V2P2U4rZef+Fc=;
  b=VfZeY2udajplHLmYGWf6oOuIJzOv53w+yIeu+flbgHM+cnQLRD2IJgiY
   dTRof3YTpBWL0EQeWLqoOfk4KSEYm4aFHgDSGCLuhKht6yOY0ZDwm1dIF
   R5F8lpt7qCQm/PYLqXWGjWQ4fxI2mVOzfejiG7IenjCF+ua6Kz8TGkXIq
   /etzHSHyfIds3NWkgdHksAMN5kfLZMmgLZSeV4e3c0N1fTjncK4fk8j3G
   KMSlgP40jFinrLKtOLcbFyM2q27C19dQXIvtZ1i966wpC5m2CMBo9fEJY
   8e/k0PleyZEY4BH6PizcMVBccZvembpJne1F+Mw3GJOzJF5Hr4OjzZz55
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808696"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808696"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091245"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:20 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com
Subject: [RFC 13/18] vfio/container-obj: Introduce VFIOContainer reset callback
Date:   Thu, 14 Apr 2022 03:47:05 -0700
Message-Id: <20220414104710.28534-14-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220414104710.28534-1-yi.l.liu@intel.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Reset implementation depends on the container backend. Let's
introduce a VFIOContainer class function and register a generic
reset handler that will be able to call the right reset function
depending on the container type. Also, let's move the
registration/unregistration to a place that is not backend-specific
(first vfio address space created instead of the first group).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/as.c                         | 18 ++++++++++++++++++
 hw/vfio/container-obj.c              | 13 +++++++++++++
 hw/vfio/container.c                  | 26 ++++++++++++++------------
 include/hw/vfio/vfio-container-obj.h |  2 ++
 4 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index 30e86f6833..4abaa4068f 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -847,6 +847,18 @@ const MemoryListener vfio_memory_listener = {
     .log_sync = vfio_listener_log_sync,
 };
 
+void vfio_reset_handler(void *opaque)
+{
+    VFIOAddressSpace *space;
+    VFIOContainer *bcontainer;
+
+    QLIST_FOREACH(space, &vfio_address_spaces, list) {
+         QLIST_FOREACH(bcontainer, &space->containers, next) {
+             vfio_container_reset(bcontainer);
+         }
+    }
+}
+
 VFIOAddressSpace *vfio_get_address_space(AddressSpace *as)
 {
     VFIOAddressSpace *space;
@@ -862,6 +874,9 @@ VFIOAddressSpace *vfio_get_address_space(AddressSpace *as)
     space->as = as;
     QLIST_INIT(&space->containers);
 
+    if (QLIST_EMPTY(&vfio_address_spaces)) {
+        qemu_register_reset(vfio_reset_handler, NULL);
+    }
     QLIST_INSERT_HEAD(&vfio_address_spaces, space, list);
 
     return space;
@@ -873,6 +888,9 @@ void vfio_put_address_space(VFIOAddressSpace *space)
         QLIST_REMOVE(space, list);
         g_free(space);
     }
+    if (QLIST_EMPTY(&vfio_address_spaces)) {
+        qemu_unregister_reset(vfio_reset_handler, NULL);
+    }
 }
 
 static VFIOContainerClass *
diff --git a/hw/vfio/container-obj.c b/hw/vfio/container-obj.c
index 40c1e2a2b5..c4220336af 100644
--- a/hw/vfio/container-obj.c
+++ b/hw/vfio/container-obj.c
@@ -68,6 +68,19 @@ int vfio_container_dma_unmap(VFIOContainer *container,
     return vccs->dma_unmap(container, iova, size, iotlb);
 }
 
+int vfio_container_reset(VFIOContainer *container)
+{
+    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
+
+    vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
+
+    if (!vccs->reset) {
+        return -ENOENT;
+    }
+
+    return vccs->reset(container);
+}
+
 void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
                                             bool start)
 {
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index 74febc1567..2f59422048 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -458,12 +458,15 @@ vfio_legacy_container_del_section_window(VFIOContainer *bcontainer,
     }
 }
 
-void vfio_reset_handler(void *opaque)
+static int vfio_legacy_container_reset(VFIOContainer *bcontainer)
 {
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer, obj);
     VFIOGroup *group;
     VFIODevice *vbasedev;
+    int ret, final_ret = 0;
 
-    QLIST_FOREACH(group, &vfio_group_list, next) {
+    QLIST_FOREACH(group, &container->group_list, container_next) {
         QLIST_FOREACH(vbasedev, &group->device_list, next) {
             if (vbasedev->dev->realized) {
                 vbasedev->ops->vfio_compute_needs_reset(vbasedev);
@@ -471,13 +474,19 @@ void vfio_reset_handler(void *opaque)
         }
     }
 
-    QLIST_FOREACH(group, &vfio_group_list, next) {
+    QLIST_FOREACH(group, &container->group_list, next) {
         QLIST_FOREACH(vbasedev, &group->device_list, next) {
             if (vbasedev->dev->realized && vbasedev->needs_reset) {
-                vbasedev->ops->vfio_hot_reset_multi(vbasedev);
+                ret = vbasedev->ops->vfio_hot_reset_multi(vbasedev);
+                if (ret) {
+                    error_report("failed to reset %s (%d)",
+                                 vbasedev->name, ret);
+                    final_ret = ret;
+                }
             }
         }
     }
+    return final_ret;
 }
 
 static void vfio_kvm_device_add_group(VFIOGroup *group)
@@ -1004,10 +1013,6 @@ static VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
         goto close_fd_exit;
     }
 
-    if (QLIST_EMPTY(&vfio_group_list)) {
-        qemu_register_reset(vfio_reset_handler, NULL);
-    }
-
     QLIST_INSERT_HEAD(&vfio_group_list, group, next);
 
     return group;
@@ -1036,10 +1041,6 @@ static void vfio_put_group(VFIOGroup *group)
     trace_vfio_put_group(group->fd);
     close(group->fd);
     g_free(group);
-
-    if (QLIST_EMPTY(&vfio_group_list)) {
-        qemu_unregister_reset(vfio_reset_handler, NULL);
-    }
 }
 
 static int vfio_get_device(VFIOGroup *group, const char *name,
@@ -1293,6 +1294,7 @@ static void vfio_legacy_container_class_init(ObjectClass *klass,
     vccs->add_window = vfio_legacy_container_add_section_window;
     vccs->del_window = vfio_legacy_container_del_section_window;
     vccs->check_extension = vfio_legacy_container_check_extension;
+    vccs->reset = vfio_legacy_container_reset;
     vccs->attach_device = legacy_attach_device;
     vccs->detach_device = legacy_detach_device;
 }
diff --git a/include/hw/vfio/vfio-container-obj.h b/include/hw/vfio/vfio-container-obj.h
index ebc1340530..ffd8590ff8 100644
--- a/include/hw/vfio/vfio-container-obj.h
+++ b/include/hw/vfio/vfio-container-obj.h
@@ -118,6 +118,7 @@ typedef struct VFIOContainerClass {
     int (*dma_unmap)(VFIOContainer *container,
                      hwaddr iova, ram_addr_t size,
                      IOMMUTLBEntry *iotlb);
+    int (*reset)(VFIOContainer *container);
     /* migration feature */
     bool (*devices_all_dirty_tracking)(VFIOContainer *container);
     void (*set_dirty_page_tracking)(VFIOContainer *container, bool start);
@@ -142,6 +143,7 @@ int vfio_container_dma_map(VFIOContainer *container,
 int vfio_container_dma_unmap(VFIOContainer *container,
                              hwaddr iova, ram_addr_t size,
                              IOMMUTLBEntry *iotlb);
+int vfio_container_reset(VFIOContainer *container);
 bool vfio_container_devices_all_dirty_tracking(VFIOContainer *container);
 void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
                                             bool start);
-- 
2.27.0

