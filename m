Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F335500B7E
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbiDNKuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242484AbiDNKuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:50:07 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C3E7EA22
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933262; x=1681469262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hqCVHBvMLiO5PUml3lYQKrW7UAw+dj0Yypw69s/N8c0=;
  b=Ij61lM0mebUQEGxUqf53LZ7hCNs5QoOS740JGydaZb6HvLYyDNrXaOwE
   wV/z92TvSL2jusgPk9VlpjXY4cEkIYQdwwzPcjkEdpja3DsxAsAuAotsJ
   vecr1HLi9Kx2qjCpwVW2YbmLETAb2hyF0OJVIsBYHXll3or4I77A36hi2
   0pLAQrfO5f1YGiClNxL2lg71XsvI7T4OrkiqVGz1JbfAIdWGaoqgtNQEn
   VGiuquMdoK+wjRp4mGL6FquAJpuejhr0HXzkKNlFNzHZDT0dI8WM1zOta
   fMAURDcMn7oIGrX7bsHZE7eangqVEW+Hvt2u+YFyM8VY/cJSndKD6Rp/G
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808701"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808701"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091258"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:23 -0700
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
Subject: [RFC 16/18] vfio/iommufd: Add IOAS_COPY_DMA support
Date:   Thu, 14 Apr 2022 03:47:08 -0700
Message-Id: <20220414104710.28534-17-yi.l.liu@intel.com>
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

Compared with legacy vfio container BE, one of the benefits provided by
iommufd is to reduce the redundant page pinning on kernel side through
the usage of IOAS_COPY_DMA. For iommufd containers within the same address
space, IOVA mappings can be copied from a source container to destination
container.

To achieve this, move the vfio_memory_listener to be per address space.
In the memory listener callbacks, all the containers within the address
space will be looped. For the iommufd containers, QEMU uses IOAS_MAP_DMA
on the first one, and then uses IOAS_COPY_DMA to copy the IOVA mappings
from the first iommufd container to other iommufd containers within the
address space. For legacy containers, IOVA mapping is done by
VFIO_IOMMU_MAP_DMA.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/as.c                         | 117 +++++++++++++++++++++++----
 hw/vfio/container-obj.c              |  17 +++-
 hw/vfio/container.c                  |  19 ++---
 hw/vfio/iommufd.c                    |  43 +++++++---
 include/hw/vfio/vfio-common.h        |   6 +-
 include/hw/vfio/vfio-container-obj.h |   8 +-
 6 files changed, 167 insertions(+), 43 deletions(-)

diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index 94618efd1f..13a6653a0d 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -388,16 +388,16 @@ static void vfio_unregister_ram_discard_listener(VFIOContainer *container,
     g_free(vrdl);
 }
 
-static void vfio_listener_region_add(MemoryListener *listener,
-                                     MemoryRegionSection *section)
+static void vfio_container_region_add(VFIOContainer *container,
+                                      VFIOContainer **src_container,
+                                      MemoryRegionSection *section)
 {
-    VFIOContainer *container = container_of(listener, VFIOContainer, listener);
     hwaddr iova, end;
     Int128 llend, llsize;
     void *vaddr;
     int ret;
     VFIOHostDMAWindow *hostwin;
-    bool hostwin_found;
+    bool hostwin_found, copy_dma_supported = false;
     Error *err = NULL;
 
     if (vfio_listener_skipped_section(section)) {
@@ -533,12 +533,25 @@ static void vfio_listener_region_add(MemoryListener *listener,
         }
     }
 
+    copy_dma_supported = vfio_container_check_extension(container,
+                                                        VFIO_FEAT_DMA_COPY);
+
+    if (copy_dma_supported && *src_container) {
+        if (!vfio_container_dma_copy(*src_container, container,
+                                     iova, int128_get64(llsize),
+                                     section->readonly)) {
+            return;
+        } else {
+            info_report("IOAS copy failed try map for container: %p", container);
+        }
+    }
+
     ret = vfio_container_dma_map(container, iova, int128_get64(llsize),
                                  vaddr, section->readonly);
     if (ret) {
-        error_setg(&err, "vfio_dma_map(%p, 0x%"HWADDR_PRIx", "
-                   "0x%"HWADDR_PRIx", %p) = %d (%m)",
-                   container, iova, int128_get64(llsize), vaddr, ret);
+        error_setg(&err, "vfio_container_dma_map(%p, 0x%"HWADDR_PRIx", "
+                   "0x%"HWADDR_PRIx", %p) = %d (%m)", container, iova,
+                   int128_get64(llsize), vaddr, ret);
         if (memory_region_is_ram_device(section->mr)) {
             /* Allow unexpected mappings not to be fatal for RAM devices */
             error_report_err(err);
@@ -547,6 +560,9 @@ static void vfio_listener_region_add(MemoryListener *listener,
         goto fail;
     }
 
+    if (copy_dma_supported) {
+        *src_container = container;
+    }
     return;
 
 fail:
@@ -573,10 +589,22 @@ fail:
     }
 }
 
-static void vfio_listener_region_del(MemoryListener *listener,
+static void vfio_listener_region_add(MemoryListener *listener,
                                      MemoryRegionSection *section)
 {
-    VFIOContainer *container = container_of(listener, VFIOContainer, listener);
+    VFIOAddressSpace *space = container_of(listener,
+                                           VFIOAddressSpace, listener);
+    VFIOContainer *container, *src_container;
+
+    src_container = NULL;
+    QLIST_FOREACH(container, &space->containers, next) {
+        vfio_container_region_add(container, &src_container, section);
+    }
+}
+
+static void vfio_container_region_del(VFIOContainer *container,
+                                      MemoryRegionSection *section)
+{
     hwaddr iova, end;
     Int128 llend, llsize;
     int ret;
@@ -682,18 +710,38 @@ static void vfio_listener_region_del(MemoryListener *listener,
     vfio_container_del_section_window(container, section);
 }
 
+static void vfio_listener_region_del(MemoryListener *listener,
+                                     MemoryRegionSection *section)
+{
+    VFIOAddressSpace *space = container_of(listener,
+                                           VFIOAddressSpace, listener);
+    VFIOContainer *container;
+
+    QLIST_FOREACH(container, &space->containers, next) {
+        vfio_container_region_del(container, section);
+    }
+}
+
 static void vfio_listener_log_global_start(MemoryListener *listener)
 {
-    VFIOContainer *container = container_of(listener, VFIOContainer, listener);
+    VFIOAddressSpace *space = container_of(listener,
+                                           VFIOAddressSpace, listener);
+    VFIOContainer *container;
 
-    vfio_container_set_dirty_page_tracking(container, true);
+    QLIST_FOREACH(container, &space->containers, next) {
+        vfio_container_set_dirty_page_tracking(container, true);
+    }
 }
 
 static void vfio_listener_log_global_stop(MemoryListener *listener)
 {
-    VFIOContainer *container = container_of(listener, VFIOContainer, listener);
+    VFIOAddressSpace *space = container_of(listener,
+                                           VFIOAddressSpace, listener);
+    VFIOContainer *container;
 
-    vfio_container_set_dirty_page_tracking(container, false);
+    QLIST_FOREACH(container, &space->containers, next) {
+        vfio_container_set_dirty_page_tracking(container, false);
+    }
 }
 
 typedef struct {
@@ -823,11 +871,9 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *container,
                    int128_get64(section->size), ram_addr);
 }
 
-static void vfio_listener_log_sync(MemoryListener *listener,
-        MemoryRegionSection *section)
+static void vfio_container_log_sync(VFIOContainer *container,
+                                    MemoryRegionSection *section)
 {
-    VFIOContainer *container = container_of(listener, VFIOContainer, listener);
-
     if (vfio_listener_skipped_section(section) ||
         !container->dirty_pages_supported) {
         return;
@@ -838,6 +884,18 @@ static void vfio_listener_log_sync(MemoryListener *listener,
     }
 }
 
+static void vfio_listener_log_sync(MemoryListener *listener,
+                                   MemoryRegionSection *section)
+{
+    VFIOAddressSpace *space = container_of(listener,
+                                           VFIOAddressSpace, listener);
+    VFIOContainer *container;
+
+    QLIST_FOREACH(container, &space->containers, next) {
+        vfio_container_log_sync(container, section);
+    }
+}
+
 const MemoryListener vfio_memory_listener = {
     .name = "vfio",
     .region_add = vfio_listener_region_add,
@@ -882,6 +940,31 @@ VFIOAddressSpace *vfio_get_address_space(AddressSpace *as)
     return space;
 }
 
+void vfio_as_add_container(VFIOAddressSpace *space,
+                           VFIOContainer *container)
+{
+    if (space->listener_initialized) {
+        memory_listener_unregister(&space->listener);
+    }
+
+    QLIST_INSERT_HEAD(&space->containers, container, next);
+
+    /* Unregistration happen in vfio_as_del_container() */
+    space->listener = vfio_memory_listener;
+    memory_listener_register(&space->listener, space->as);
+    space->listener_initialized = true;
+}
+
+void vfio_as_del_container(VFIOAddressSpace *space,
+                           VFIOContainer *container)
+{
+    QLIST_SAFE_REMOVE(container, next);
+
+    if (QLIST_EMPTY(&space->containers)) {
+        memory_listener_unregister(&space->listener);
+    }
+}
+
 void vfio_put_address_space(VFIOAddressSpace *space)
 {
     if (QLIST_EMPTY(&space->containers)) {
diff --git a/hw/vfio/container-obj.c b/hw/vfio/container-obj.c
index c4220336af..2c79089364 100644
--- a/hw/vfio/container-obj.c
+++ b/hw/vfio/container-obj.c
@@ -27,6 +27,7 @@
 #include "qom/object.h"
 #include "qapi/visitor.h"
 #include "hw/vfio/vfio-container-obj.h"
+#include "exec/memory.h"
 
 bool vfio_container_check_extension(VFIOContainer *container,
                                     VFIOContainerFeature feat)
@@ -53,6 +54,20 @@ int vfio_container_dma_map(VFIOContainer *container,
     return vccs->dma_map(container, iova, size, vaddr, readonly);
 }
 
+int vfio_container_dma_copy(VFIOContainer *src, VFIOContainer *dst,
+                            hwaddr iova, ram_addr_t size, bool readonly)
+{
+    VFIOContainerClass *vccs1 = VFIO_CONTAINER_OBJ_GET_CLASS(src);
+    VFIOContainerClass *vccs2 = VFIO_CONTAINER_OBJ_GET_CLASS(dst);
+
+    if (!vccs1->dma_copy || vccs1->dma_copy != vccs2->dma_copy) {
+        error_report("Incompatiable container: unable to copy dma");
+        return -EINVAL;
+    }
+
+    return vccs1->dma_copy(src, dst, iova, size, readonly);
+}
+
 int vfio_container_dma_unmap(VFIOContainer *container,
                              hwaddr iova, ram_addr_t size,
                              IOMMUTLBEntry *iotlb)
@@ -165,8 +180,6 @@ void vfio_container_destroy(VFIOContainer *container)
     VFIOGuestIOMMU *giommu, *tmp;
     VFIOHostDMAWindow *hostwin, *next;
 
-    QLIST_SAFE_REMOVE(container, next);
-
     QLIST_FOREACH_SAFE(vrdl, &container->vrdl_list, next, vrdl_tmp) {
         RamDiscardManager *rdm;
 
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index 2f59422048..6bc1b8763f 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -357,9 +357,6 @@ err_out:
 
 static void vfio_listener_release(VFIOLegacyContainer *container)
 {
-    VFIOContainer *bcontainer = &container->obj;
-
-    memory_listener_unregister(&bcontainer->listener);
     if (container->iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
         memory_listener_unregister(&container->prereg_listener);
     }
@@ -887,14 +884,11 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
     vfio_kvm_device_add_group(group);
 
     QLIST_INIT(&container->group_list);
-    QLIST_INSERT_HEAD(&space->containers, bcontainer, next);
 
     group->container = container;
     QLIST_INSERT_HEAD(&container->group_list, group, container_next);
 
-    bcontainer->listener = vfio_memory_listener;
-
-    memory_listener_register(&bcontainer->listener, bcontainer->space->as);
+    vfio_as_add_container(space, bcontainer);
 
     if (bcontainer->error) {
         ret = -1;
@@ -907,8 +901,8 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
 
     return 0;
 listener_release_exit:
+    vfio_as_del_container(space, bcontainer);
     QLIST_REMOVE(group, container_next);
-    QLIST_REMOVE(bcontainer, next);
     vfio_kvm_device_del_group(group);
     vfio_listener_release(container);
 
@@ -931,6 +925,7 @@ static void vfio_disconnect_container(VFIOGroup *group)
 {
     VFIOLegacyContainer *container = group->container;
     VFIOContainer *bcontainer = &container->obj;
+    VFIOAddressSpace *space = bcontainer->space;
 
     QLIST_REMOVE(group, container_next);
     group->container = NULL;
@@ -938,10 +933,12 @@ static void vfio_disconnect_container(VFIOGroup *group)
     /*
      * Explicitly release the listener first before unset container,
      * since unset may destroy the backend container if it's the last
-     * group.
+     * group. By removing container from the list, container is disconnected
+     * with address space memory listener.
      */
     if (QLIST_EMPTY(&container->group_list)) {
         vfio_listener_release(container);
+        vfio_as_del_container(space, bcontainer);
     }
 
     if (ioctl(group->fd, VFIO_GROUP_UNSET_CONTAINER, &container->fd)) {
@@ -950,10 +947,8 @@ static void vfio_disconnect_container(VFIOGroup *group)
     }
 
     if (QLIST_EMPTY(&container->group_list)) {
-        VFIOAddressSpace *space = bcontainer->space;
-
-        vfio_container_destroy(bcontainer);
         trace_vfio_disconnect_container(container->fd);
+        vfio_container_destroy(bcontainer);
         close(container->fd);
         g_free(container);
 
diff --git a/hw/vfio/iommufd.c b/hw/vfio/iommufd.c
index f8375f1672..8ff5988b07 100644
--- a/hw/vfio/iommufd.c
+++ b/hw/vfio/iommufd.c
@@ -38,6 +38,8 @@ static bool iommufd_check_extension(VFIOContainer *bcontainer,
                                     VFIOContainerFeature feat)
 {
     switch (feat) {
+    case VFIO_FEAT_DMA_COPY:
+        return true;
     default:
         return false;
     };
@@ -49,10 +51,25 @@ static int iommufd_map(VFIOContainer *bcontainer, hwaddr iova,
     VFIOIOMMUFDContainer *container = container_of(bcontainer,
                                                    VFIOIOMMUFDContainer, obj);
 
-    return iommufd_map_dma(container->iommufd, container->ioas_id,
+    return iommufd_map_dma(container->iommufd,
+                           container->ioas_id,
                            iova, size, vaddr, readonly);
 }
 
+static int iommufd_copy(VFIOContainer *src, VFIOContainer *dst,
+                        hwaddr iova, ram_addr_t size, bool readonly)
+{
+    VFIOIOMMUFDContainer *container_src = container_of(src,
+                                                   VFIOIOMMUFDContainer, obj);
+    VFIOIOMMUFDContainer *container_dst = container_of(dst,
+                                                   VFIOIOMMUFDContainer, obj);
+
+    assert(container_src->iommufd == container_dst->iommufd);
+
+    return iommufd_copy_dma(container_src->iommufd, container_src->ioas_id,
+                            container_dst->ioas_id, iova, size, readonly);
+}
+
 static int iommufd_unmap(VFIOContainer *bcontainer,
                          hwaddr iova, ram_addr_t size,
                          IOMMUTLBEntry *iotlb)
@@ -428,12 +445,7 @@ static int iommufd_attach_device(VFIODevice *vbasedev, AddressSpace *as,
      * between iommufd and kvm.
      */
 
-    QLIST_INSERT_HEAD(&space->containers, bcontainer, next);
-
-    bcontainer->listener = vfio_memory_listener;
-
-    memory_listener_register(&bcontainer->listener, bcontainer->space->as);
-
+    vfio_as_add_container(space, bcontainer);
     bcontainer->initialized = true;
 
 out:
@@ -476,6 +488,7 @@ static void iommufd_detach_device(VFIODevice *vbasedev)
     VFIOIOMMUFDContainer *container;
     VFIODevice *vbasedev_iter;
     VFIOIOASHwpt *hwpt;
+    VFIOAddressSpace *space;
     Error *err;
 
     if (!bcontainer) {
@@ -501,15 +514,26 @@ found:
         vfio_container_put_hwpt(hwpt);
     }
 
+    space = bcontainer->space;
+    /*
+     * Needs to remove the bcontainer from space->containers list before
+     * detach container. Otherwise, detach container may destroy the
+     * container if it's the last device. By removing bcontainer from the
+     * list, container is disconnected with address space memory listener.
+     */
+    if (QLIST_EMPTY(&container->hwpt_list)) {
+        vfio_as_del_container(space, bcontainer);
+    }
     __vfio_device_detach_container(vbasedev, container, &err);
     if (err) {
         error_report_err(err);
     }
     if (QLIST_EMPTY(&container->hwpt_list)) {
-        VFIOAddressSpace *space = bcontainer->space;
+        int iommufd = container->iommufd;
+        uint32_t ioas_id = container->ioas_id;
 
-        iommufd_put_ioas(container->iommufd, container->ioas_id);
         vfio_iommufd_container_destroy(container);
+        iommufd_put_ioas(iommufd, ioas_id);
         vfio_put_address_space(space);
     }
     vbasedev->container = NULL;
@@ -525,6 +549,7 @@ static void vfio_iommufd_class_init(ObjectClass *klass,
 
     vccs->check_extension = iommufd_check_extension;
     vccs->dma_map = iommufd_map;
+    vccs->dma_copy = iommufd_copy;
     vccs->dma_unmap = iommufd_unmap;
     vccs->attach_device = iommufd_attach_device;
     vccs->detach_device = iommufd_detach_device;
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 19731ea685..bef48ddfaf 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -34,8 +34,6 @@
 
 #define VFIO_MSG_PREFIX "vfio %s: "
 
-extern const MemoryListener vfio_memory_listener;
-
 enum {
     VFIO_DEVICE_TYPE_PCI = 0,
     VFIO_DEVICE_TYPE_PLATFORM = 1,
@@ -181,6 +179,10 @@ void vfio_host_win_add(VFIOContainer *bcontainer,
 int vfio_host_win_del(VFIOContainer *bcontainer, hwaddr min_iova,
                       hwaddr max_iova);
 VFIOAddressSpace *vfio_get_address_space(AddressSpace *as);
+void vfio_as_add_container(VFIOAddressSpace *space,
+                           VFIOContainer *bcontainer);
+void vfio_as_del_container(VFIOAddressSpace *space,
+                           VFIOContainer *container);
 void vfio_put_address_space(VFIOAddressSpace *space);
 
 void vfio_put_base_device(VFIODevice *vbasedev);
diff --git a/include/hw/vfio/vfio-container-obj.h b/include/hw/vfio/vfio-container-obj.h
index b5ef2160d8..b65f827bc1 100644
--- a/include/hw/vfio/vfio-container-obj.h
+++ b/include/hw/vfio/vfio-container-obj.h
@@ -47,12 +47,15 @@
 
 typedef enum VFIOContainerFeature {
     VFIO_FEAT_LIVE_MIGRATION,
+    VFIO_FEAT_DMA_COPY,
 } VFIOContainerFeature;
 
 typedef struct VFIOContainer VFIOContainer;
 
 typedef struct VFIOAddressSpace {
     AddressSpace *as;
+    MemoryListener listener;
+    bool listener_initialized;
     QLIST_HEAD(, VFIOContainer) containers;
     QLIST_ENTRY(VFIOAddressSpace) list;
 } VFIOAddressSpace;
@@ -90,7 +93,6 @@ struct VFIOContainer {
     Object parent_obj;
 
     VFIOAddressSpace *space;
-    MemoryListener listener;
     Error *error;
     bool initialized;
     bool dirty_pages_supported;
@@ -116,6 +118,8 @@ typedef struct VFIOContainerClass {
     int (*dma_map)(VFIOContainer *container,
                    hwaddr iova, ram_addr_t size,
                    void *vaddr, bool readonly);
+    int (*dma_copy)(VFIOContainer *src, VFIOContainer *dst,
+                    hwaddr iova, ram_addr_t size, bool readonly);
     int (*dma_unmap)(VFIOContainer *container,
                      hwaddr iova, ram_addr_t size,
                      IOMMUTLBEntry *iotlb);
@@ -141,6 +145,8 @@ bool vfio_container_check_extension(VFIOContainer *container,
 int vfio_container_dma_map(VFIOContainer *container,
                            hwaddr iova, ram_addr_t size,
                            void *vaddr, bool readonly);
+int vfio_container_dma_copy(VFIOContainer *src, VFIOContainer *dst,
+                            hwaddr iova, ram_addr_t size, bool readonly);
 int vfio_container_dma_unmap(VFIOContainer *container,
                              hwaddr iova, ram_addr_t size,
                              IOMMUTLBEntry *iotlb);
-- 
2.27.0

