Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5768F543074
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239354AbiFHMcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239291AbiFHMbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:31:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD637253830
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654691508; x=1686227508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lifPEPAqd0/u6utnK71bM3OvcAqpE8N/lgs7hmF7yN4=;
  b=QGVZyf89YMx49z8QKibTx9V6hE1AAM502Gg6LZI4133p4L73e7/nNOen
   yv8LzJoUk9nOV70QRJ3RfLDCT2mgmFUIn2juya4DLAiiUxyrv5WZEQGi2
   R7Onu3o5OBNSMtRD1hiEne1wU6MdXHuGvAmKUJFGVMKGB4Ai2gJRVO3zu
   nlLsOi+yaIy5RhdimvPaY1Tqdq3UTTHf2OkTycGakavaOmO004G5h7R7N
   sFuI+KqQLJT5GzXA2PD3spWD9av+au2KPGfI43Y7Vco7ejG68hrLlF6O4
   ua/u8oSIuqlMDwuVr3jwqr1N+cwRBvgb2in2Yq95RemsXK4tzFTNBZeYZ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302238030"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="302238030"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:31:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="670529854"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jun 2022 05:31:46 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com
Subject: [RFC v2 10/15] vfio/container-base: Introduce VFIOContainer reset callback
Date:   Wed,  8 Jun 2022 05:31:34 -0700
Message-Id: <20220608123139.19356-11-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220608123139.19356-1-yi.l.liu@intel.com>
References: <20220608123139.19356-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 hw/vfio/as.c                          | 18 ++++++++++++++++++
 hw/vfio/container-base.c              |  9 +++++++++
 hw/vfio/container.c                   | 27 +++++++++++++++------------
 include/hw/vfio/vfio-container-base.h |  2 ++
 4 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index 2c83b8e1fe..1a3ceb5e62 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -872,6 +872,18 @@ const MemoryListener vfio_memory_listener = {
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
@@ -887,6 +899,9 @@ VFIOAddressSpace *vfio_get_address_space(AddressSpace *as)
     space->as = as;
     QLIST_INIT(&space->containers);
 
+    if (QLIST_EMPTY(&vfio_address_spaces)) {
+        qemu_register_reset(vfio_reset_handler, NULL);
+    }
     QLIST_INSERT_HEAD(&vfio_address_spaces, space, list);
 
     return space;
@@ -898,6 +913,9 @@ void vfio_put_address_space(VFIOAddressSpace *space)
         QLIST_REMOVE(space, list);
         g_free(space);
     }
+    if (QLIST_EMPTY(&vfio_address_spaces)) {
+        qemu_unregister_reset(vfio_reset_handler, NULL);
+    }
 }
 
 static const VFIOContainerOps *
diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
index 6aaf0e0faa..a9f28e4b9d 100644
--- a/hw/vfio/container-base.c
+++ b/hw/vfio/container-base.c
@@ -58,6 +58,15 @@ int vfio_container_dma_unmap(VFIOContainer *container,
     return container->ops->dma_unmap(container, iova, size, iotlb);
 }
 
+int vfio_container_reset(VFIOContainer *container)
+{
+    if (!container->ops->reset) {
+        return -ENOENT;
+    }
+
+    return container->ops->reset(container);
+}
+
 void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
                                             bool start)
 {
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index f303c08aa5..2d9704bc1a 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -465,12 +465,16 @@ vfio_legacy_container_del_section_window(VFIOContainer *bcontainer,
     }
 }
 
-void vfio_reset_handler(void *opaque)
+static int vfio_legacy_container_reset(VFIOContainer *bcontainer)
 {
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer,
+                                                  bcontainer);
     VFIOGroup *group;
     VFIODevice *vbasedev;
+    int ret, final_ret = 0;
 
-    QLIST_FOREACH(group, &vfio_group_list, next) {
+    QLIST_FOREACH(group, &container->group_list, container_next) {
         QLIST_FOREACH(vbasedev, &group->device_list, next) {
             if (vbasedev->dev->realized) {
                 vbasedev->ops->vfio_compute_needs_reset(vbasedev);
@@ -478,13 +482,19 @@ void vfio_reset_handler(void *opaque)
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
@@ -1010,10 +1020,6 @@ static VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
         goto close_fd_exit;
     }
 
-    if (QLIST_EMPTY(&vfio_group_list)) {
-        qemu_register_reset(vfio_reset_handler, NULL);
-    }
-
     QLIST_INSERT_HEAD(&vfio_group_list, group, next);
 
     return group;
@@ -1042,10 +1048,6 @@ static void vfio_put_group(VFIOGroup *group)
     trace_vfio_put_group(group->fd);
     close(group->fd);
     g_free(group);
-
-    if (QLIST_EMPTY(&vfio_group_list)) {
-        qemu_unregister_reset(vfio_reset_handler, NULL);
-    }
 }
 
 static int vfio_get_device(VFIOGroup *group, const char *name,
@@ -1295,6 +1297,7 @@ const VFIOContainerOps legacy_container_ops = {
     .add_window = vfio_legacy_container_add_section_window,
     .del_window = vfio_legacy_container_del_section_window,
     .check_extension = vfio_legacy_container_check_extension,
+    .reset = vfio_legacy_container_reset,
     .attach_device = legacy_attach_device,
     .detach_device = legacy_detach_device,
 };
diff --git a/include/hw/vfio/vfio-container-base.h b/include/hw/vfio/vfio-container-base.h
index 71df8743fb..f9fb8b6af7 100644
--- a/include/hw/vfio/vfio-container-base.h
+++ b/include/hw/vfio/vfio-container-base.h
@@ -78,6 +78,7 @@ typedef struct VFIOContainerOps {
     int (*dma_unmap)(VFIOContainer *container,
                      hwaddr iova, ram_addr_t size,
                      IOMMUTLBEntry *iotlb);
+    int (*reset)(VFIOContainer *container);
     /* migration feature */
     bool (*devices_all_dirty_tracking)(VFIOContainer *container);
     void (*set_dirty_page_tracking)(VFIOContainer *container, bool start);
@@ -122,6 +123,7 @@ int vfio_container_dma_map(VFIOContainer *container,
 int vfio_container_dma_unmap(VFIOContainer *container,
                              hwaddr iova, ram_addr_t size,
                              IOMMUTLBEntry *iotlb);
+int vfio_container_reset(VFIOContainer *container);
 bool vfio_container_devices_all_dirty_tracking(VFIOContainer *container);
 void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
                                             bool start);
-- 
2.27.0

