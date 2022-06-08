Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C2D54306E
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbiFHMcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239333AbiFHMby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:31:54 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DC9254460
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654691510; x=1686227510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QOWvCiC5xeNIhozB8NOdNSZTOHuvSql4zTaZ4nNSoFA=;
  b=bnrjW0UtR/yrezOWQy1XrEo+QLQ7YV/DkM6gEfZpyupRGqG7SnP0Y/A0
   jAgTB47tSHMw1RsMg3VfZmolpF+jfdt3xm1n4zbmqa6FAJGrXN+Gemh/s
   Utjmwr8a8f6k/ieRWC5MnijzIDxS3/KvBGDz7mXg+kn6f6fKYato8PM0f
   oBT89dZg5qKwMjmHQx0wfo1WTHUjYvDjrpn1Qs/N7fox7iYOZhGUvyRvb
   HpC2jQZZFX5CXt7PdNAjEro43NnT4XvSpif9SXg/t3EaGjZPCYN+yYTPB
   esUaTOgJJSxayhboMvXLT6QSR0q6bTCYhOuZRD49w6NOJ2aXlQoqPYV5j
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302238091"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="302238091"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:31:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="670529900"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jun 2022 05:31:49 -0700
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
Subject: [RFC v2 14/15] vfio/iommufd: Add IOAS_COPY_DMA support
Date:   Wed,  8 Jun 2022 05:31:38 -0700
Message-Id: <20220608123139.19356-15-yi.l.liu@intel.com>
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
 hw/vfio/as.c                          | 117 ++++++++++++++++++++++----
 hw/vfio/container-base.c              |  13 ++-
 hw/vfio/container.c                   |  19 ++---
 hw/vfio/iommufd.c                     |  47 +++++++++--
 include/hw/vfio/vfio-common.h         |   5 +-
 include/hw/vfio/vfio-container-base.h |   8 +-
 6 files changed, 167 insertions(+), 42 deletions(-)

diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index 3ff9d4215f..56485f9299 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -405,16 +405,16 @@ static bool vfio_known_safe_misalignment(MemoryRegionSection *section)
     return true;
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
@@ -558,12 +558,25 @@ static void vfio_listener_region_add(MemoryListener *listener,
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
@@ -572,6 +585,9 @@ static void vfio_listener_region_add(MemoryListener *listener,
         goto fail;
     }
 
+    if (copy_dma_supported) {
+        *src_container = container;
+    }
     return;
 
 fail:
@@ -598,10 +614,22 @@ fail:
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
@@ -707,18 +735,38 @@ static void vfio_listener_region_del(MemoryListener *listener,
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
@@ -848,11 +896,9 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *container,
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
@@ -863,6 +909,18 @@ static void vfio_listener_log_sync(MemoryListener *listener,
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
@@ -907,6 +965,31 @@ VFIOAddressSpace *vfio_get_address_space(AddressSpace *as)
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
diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
index a9f28e4b9d..0a6bc31686 100644
--- a/hw/vfio/container-base.c
+++ b/hw/vfio/container-base.c
@@ -47,6 +47,17 @@ int vfio_container_dma_map(VFIOContainer *container,
     return container->ops->dma_map(container, iova, size, vaddr, readonly);
 }
 
+int vfio_container_dma_copy(VFIOContainer *src, VFIOContainer *dst,
+                            hwaddr iova, ram_addr_t size, bool readonly)
+{
+    if (!src->ops->dma_copy || src->ops->dma_copy != dst->ops->dma_copy) {
+        error_report("Incompatible container: unable to copy dma");
+        return -EINVAL;
+    }
+
+    return src->ops->dma_copy(src, dst, iova, size, readonly);
+}
+
 int vfio_container_dma_unmap(VFIOContainer *container,
                              hwaddr iova, ram_addr_t size,
                              IOMMUTLBEntry *iotlb)
@@ -137,8 +148,6 @@ void vfio_container_destroy(VFIOContainer *container)
     VFIOGuestIOMMU *giommu, *tmp;
     VFIOHostDMAWindow *hostwin, *next;
 
-    QLIST_SAFE_REMOVE(container, next);
-
     QLIST_FOREACH_SAFE(vrdl, &container->vrdl_list, next, vrdl_tmp) {
         RamDiscardManager *rdm;
 
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index 2d9704bc1a..760ba56da4 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -362,9 +362,6 @@ err_out:
 
 static void vfio_listener_release(VFIOLegacyContainer *container)
 {
-    VFIOContainer *bcontainer = &container->bcontainer;
-
-    memory_listener_unregister(&bcontainer->listener);
     if (container->iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
         memory_listener_unregister(&container->prereg_listener);
     }
@@ -894,14 +891,11 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
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
@@ -914,8 +908,8 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
 
     return 0;
 listener_release_exit:
+    vfio_as_del_container(space, bcontainer);
     QLIST_REMOVE(group, container_next);
-    QLIST_REMOVE(bcontainer, next);
     vfio_kvm_device_del_group(group);
     vfio_listener_release(container);
 
@@ -938,6 +932,7 @@ static void vfio_disconnect_container(VFIOGroup *group)
 {
     VFIOLegacyContainer *container = group->container;
     VFIOContainer *bcontainer = &container->bcontainer;
+    VFIOAddressSpace *space = bcontainer->space;
 
     QLIST_REMOVE(group, container_next);
     group->container = NULL;
@@ -945,10 +940,12 @@ static void vfio_disconnect_container(VFIOGroup *group)
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
@@ -957,10 +954,8 @@ static void vfio_disconnect_container(VFIOGroup *group)
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
index 7417c6ce44..75f43345f0 100644
--- a/hw/vfio/iommufd.c
+++ b/hw/vfio/iommufd.c
@@ -39,6 +39,8 @@ static bool iommufd_check_extension(VFIOContainer *bcontainer,
                                     VFIOContainerFeature feat)
 {
     switch (feat) {
+    case VFIO_FEAT_DMA_COPY:
+        return true;
     default:
         return false;
     };
@@ -55,6 +57,20 @@ static int iommufd_map(VFIOContainer *bcontainer, hwaddr iova,
                                    iova, size, vaddr, readonly);
 }
 
+static int iommufd_copy(VFIOContainer *src, VFIOContainer *dst,
+                        hwaddr iova, ram_addr_t size, bool readonly)
+{
+    VFIOIOMMUFDContainer *container_src = container_of(src,
+                                             VFIOIOMMUFDContainer, bcontainer);
+    VFIOIOMMUFDContainer *container_dst = container_of(dst,
+                                             VFIOIOMMUFDContainer, bcontainer);
+
+    assert(container_src->be->fd == container_dst->be->fd);
+
+    return iommufd_backend_copy_dma(container_src->be, container_src->ioas_id,
+                                    container_dst->ioas_id, iova, size, readonly);
+}
+
 static int iommufd_unmap(VFIOContainer *bcontainer,
                          hwaddr iova, ram_addr_t size,
                          IOMMUTLBEntry *iotlb)
@@ -413,12 +429,14 @@ static int iommufd_attach_device(VFIODevice *vbasedev, AddressSpace *as,
      * between iommufd and kvm.
      */
 
-    QLIST_INSERT_HEAD(&space->containers, bcontainer, next);
-
-    bcontainer->listener = vfio_memory_listener;
-
-    memory_listener_register(&bcontainer->listener, bcontainer->space->as);
+    vfio_as_add_container(space, bcontainer);
 
+    if (bcontainer->error) {
+        ret = -1;
+        error_propagate_prepend(errp, bcontainer->error,
+            "memory listener initialization failed: ");
+        goto error;
+    }
     bcontainer->initialized = true;
 
 out:
@@ -435,8 +453,7 @@ out:
     ret = ioctl(devfd, VFIO_DEVICE_GET_INFO, &dev_info);
     if (ret) {
         error_setg_errno(errp, errno, "error getting device info");
-        memory_listener_unregister(&bcontainer->listener);
-        QLIST_SAFE_REMOVE(bcontainer, next);
+        vfio_as_del_container(space, bcontainer);
         goto error;
     }
 
@@ -465,6 +482,7 @@ static void iommufd_detach_device(VFIODevice *vbasedev)
     VFIOIOMMUFDContainer *container;
     VFIODevice *vbasedev_iter;
     VFIOIOASHwpt *hwpt;
+    VFIOAddressSpace *space;
     Error *err = NULL;
 
     if (!bcontainer) {
@@ -490,15 +508,25 @@ found:
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
+        uint32_t ioas_id = container->ioas_id;
 
-        iommufd_backend_put_ioas(container->be, container->ioas_id);
         vfio_iommufd_container_destroy(container);
+        iommufd_backend_put_ioas(vbasedev->iommufd, ioas_id);
         vfio_put_address_space(space);
     }
     vbasedev->container = NULL;
@@ -510,6 +538,7 @@ out:
 const VFIOContainerOps iommufd_container_ops = {
     .check_extension = iommufd_check_extension,
     .dma_map = iommufd_map,
+    .dma_copy = iommufd_copy,
     .dma_unmap = iommufd_unmap,
     .attach_device = iommufd_attach_device,
     .detach_device = iommufd_detach_device,
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 2470b6d58a..6269672712 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -34,7 +34,6 @@
 
 #define VFIO_MSG_PREFIX "vfio %s: "
 
-extern const MemoryListener vfio_memory_listener;
 extern const VFIOContainerOps legacy_container_ops;
 extern const VFIOContainerOps iommufd_container_ops;
 
@@ -186,6 +185,10 @@ void vfio_host_win_add(VFIOContainer *bcontainer,
 int vfio_host_win_del(VFIOContainer *bcontainer, hwaddr min_iova,
                       hwaddr max_iova);
 VFIOAddressSpace *vfio_get_address_space(AddressSpace *as);
+void vfio_as_add_container(VFIOAddressSpace *space,
+                           VFIOContainer *bcontainer);
+void vfio_as_del_container(VFIOAddressSpace *space,
+                           VFIOContainer *container);
 void vfio_put_address_space(VFIOAddressSpace *space);
 
 void vfio_put_base_device(VFIODevice *vbasedev);
diff --git a/include/hw/vfio/vfio-container-base.h b/include/hw/vfio/vfio-container-base.h
index f9fb8b6af7..27ed29e081 100644
--- a/include/hw/vfio/vfio-container-base.h
+++ b/include/hw/vfio/vfio-container-base.h
@@ -31,12 +31,15 @@
 
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
@@ -75,6 +78,8 @@ typedef struct VFIOContainerOps {
     int (*dma_map)(VFIOContainer *container,
                    hwaddr iova, ram_addr_t size,
                    void *vaddr, bool readonly);
+    int (*dma_copy)(VFIOContainer *src, VFIOContainer *dst,
+                    hwaddr iova, ram_addr_t size, bool readonly);
     int (*dma_unmap)(VFIOContainer *container,
                      hwaddr iova, ram_addr_t size,
                      IOMMUTLBEntry *iotlb);
@@ -101,7 +106,6 @@ typedef struct VFIOContainerOps {
 struct VFIOContainer {
     const VFIOContainerOps *ops;
     VFIOAddressSpace *space;
-    MemoryListener listener;
     Error *error;
     bool initialized;
     bool dirty_pages_supported;
@@ -120,6 +124,8 @@ bool vfio_container_check_extension(VFIOContainer *container,
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

