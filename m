Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322EA683813
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjAaU4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjAaU43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:56:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83C359E57
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gGIeLyX6bDjc+2QAPna3VSEmDPd9yrktq69F2V/fNfc=;
        b=Kt3OAJdNd5vHriyYR2oYEkDf39k0kq0FGVNpCwyASgTzjEAgj7tzZPQNvk97/N8Yl7v3cI
        VX1n5b9EXaxrUvQvza8jYuM+9DC6S3W2Sm/Pb2g8JhFls0jonxAiQro8w+21AjwqUmk2dF
        HWQkwuSFbnvJLc9KFT8Cm5YcZUZj5RU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-SEGSRY1hOZ-x7H77HXMp9g-1; Tue, 31 Jan 2023 15:55:08 -0500
X-MC-Unique: SEGSRY1hOZ-x7H77HXMp9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8DC13814953;
        Tue, 31 Jan 2023 20:55:06 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDDC640C2064;
        Tue, 31 Jan 2023 20:55:00 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, alex.williamson@redhat.com,
        clg@redhat.com, qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, kevin.tian@intel.com, chao.p.peng@intel.com,
        peterx@redhat.com, shameerali.kolothum.thodi@huawei.com,
        zhangfei.gao@linaro.org, berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: [RFC v3 17/18] vfio/iommufd: Add IOAS_COPY_DMA support
Date:   Tue, 31 Jan 2023 21:53:04 +0100
Message-Id: <20230131205305.2726330-18-eric.auger@redhat.com>
In-Reply-To: <20230131205305.2726330-1-eric.auger@redhat.com>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

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
 include/hw/vfio/vfio-common.h         |   4 +
 include/hw/vfio/vfio-container-base.h |   8 +-
 hw/vfio/as.c                          | 118 ++++++++++++++++++++++----
 hw/vfio/container-base.c              |  13 ++-
 hw/vfio/container.c                   |  19 ++---
 hw/vfio/iommufd.c                     |  48 +++++++++--
 6 files changed, 169 insertions(+), 41 deletions(-)

diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index c096778476..9c2e52be0d 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -178,6 +178,10 @@ void vfio_host_win_add(VFIOContainer *bcontainer,
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
index 9907d05531..eae9b1de6f 100644
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
@@ -75,7 +78,6 @@ typedef struct VFIOIOMMUBackendOpsClass VFIOIOMMUBackendOpsClass;
 struct VFIOContainer {
     VFIOIOMMUBackendOpsClass *ops;
     VFIOAddressSpace *space;
-    MemoryListener listener;
     Error *error;
     bool initialized;
     bool dirty_pages_supported;
@@ -94,6 +96,8 @@ bool vfio_container_check_extension(VFIOContainer *container,
 int vfio_container_dma_map(VFIOContainer *container,
                            hwaddr iova, ram_addr_t size,
                            void *vaddr, bool readonly);
+int vfio_container_dma_copy(VFIOContainer *src, VFIOContainer *dst,
+                            hwaddr iova, ram_addr_t size, bool readonly);
 int vfio_container_dma_unmap(VFIOContainer *container,
                              hwaddr iova, ram_addr_t size,
                              IOMMUTLBEntry *iotlb);
@@ -132,6 +136,8 @@ struct VFIOIOMMUBackendOpsClass {
     int (*dma_map)(VFIOContainer *container,
                    hwaddr iova, ram_addr_t size,
                    void *vaddr, bool readonly);
+    int (*dma_copy)(VFIOContainer *src, VFIOContainer *dst,
+                    hwaddr iova, ram_addr_t size, bool readonly);
     int (*dma_unmap)(VFIOContainer *container,
                      hwaddr iova, ram_addr_t size,
                      IOMMUTLBEntry *iotlb);
diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index ee126a5f03..04cd5a1d30 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -348,16 +348,16 @@ static bool vfio_known_safe_misalignment(MemoryRegionSection *section)
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
@@ -501,12 +501,26 @@ static void vfio_listener_region_add(MemoryListener *listener,
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
+            info_report("IOAS copy failed try map for container: %p",
+                        container);
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
@@ -515,6 +529,9 @@ static void vfio_listener_region_add(MemoryListener *listener,
         goto fail;
     }
 
+    if (copy_dma_supported) {
+        *src_container = container;
+    }
     return;
 
 fail:
@@ -541,10 +558,22 @@ fail:
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
@@ -658,18 +687,38 @@ static void vfio_listener_region_del(MemoryListener *listener,
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
@@ -799,11 +848,9 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *container,
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
@@ -814,6 +861,18 @@ static void vfio_listener_log_sync(MemoryListener *listener,
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
@@ -858,6 +917,31 @@ VFIOAddressSpace *vfio_get_address_space(AddressSpace *as)
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
index 3ae939c6c9..88eab9b197 100644
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
index 61caf388c2..07579c9a38 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -386,9 +386,6 @@ err_out:
 
 static void vfio_listener_release(VFIOLegacyContainer *container)
 {
-    VFIOContainer *bcontainer = &container->bcontainer;
-
-    memory_listener_unregister(&bcontainer->listener);
     if (container->iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
         memory_listener_unregister(&container->prereg_listener);
     }
@@ -929,14 +926,11 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
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
@@ -949,8 +943,8 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
 
     return 0;
 listener_release_exit:
+    vfio_as_del_container(space, bcontainer);
     QLIST_REMOVE(group, container_next);
-    QLIST_REMOVE(bcontainer, next);
     vfio_kvm_device_del_group(group);
     vfio_listener_release(container);
 
@@ -973,6 +967,7 @@ static void vfio_disconnect_container(VFIOGroup *group)
 {
     VFIOLegacyContainer *container = group->container;
     VFIOContainer *bcontainer = &container->bcontainer;
+    VFIOAddressSpace *space = bcontainer->space;
 
     QLIST_REMOVE(group, container_next);
     group->container = NULL;
@@ -980,10 +975,12 @@ static void vfio_disconnect_container(VFIOGroup *group)
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
@@ -992,10 +989,8 @@ static void vfio_disconnect_container(VFIOGroup *group)
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
index 18f755bcc0..9c1a1b1779 100644
--- a/hw/vfio/iommufd.c
+++ b/hw/vfio/iommufd.c
@@ -40,6 +40,8 @@ static bool iommufd_check_extension(VFIOContainer *bcontainer,
                                     VFIOContainerFeature feat)
 {
     switch (feat) {
+    case VFIO_FEAT_DMA_COPY:
+        return true;
     default:
         return false;
     };
@@ -56,6 +58,21 @@ static int iommufd_map(VFIOContainer *bcontainer, hwaddr iova,
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
+                                    container_dst->ioas_id, iova,
+                                    size, readonly);
+}
+
 static int iommufd_unmap(VFIOContainer *bcontainer,
                          hwaddr iova, ram_addr_t size,
                          IOMMUTLBEntry *iotlb)
@@ -414,12 +431,14 @@ static int iommufd_attach_device(VFIODevice *vbasedev, AddressSpace *as,
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
@@ -436,8 +455,7 @@ out:
     ret = ioctl(devfd, VFIO_DEVICE_GET_INFO, &dev_info);
     if (ret) {
         error_setg_errno(errp, errno, "error getting device info");
-        memory_listener_unregister(&bcontainer->listener);
-        QLIST_SAFE_REMOVE(bcontainer, next);
+        vfio_as_del_container(space, bcontainer);
         goto error;
     }
 
@@ -466,6 +484,7 @@ static void iommufd_detach_device(VFIODevice *vbasedev)
     VFIOIOMMUFDContainer *container;
     VFIODevice *vbasedev_iter;
     VFIOIOASHwpt *hwpt;
+    VFIOAddressSpace *space;
     Error *err = NULL;
 
     if (!bcontainer) {
@@ -491,15 +510,25 @@ found:
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
@@ -514,6 +543,7 @@ static void vfio_iommu_backend_iommufd_ops_class_init(ObjectClass *oc,
 
     ops->check_extension = iommufd_check_extension;
     ops->dma_map = iommufd_map;
+    ops->dma_copy = iommufd_copy;
     ops->dma_unmap = iommufd_unmap;
     ops->attach_device = iommufd_attach_device;
     ops->detach_device = iommufd_detach_device;
-- 
2.37.3

