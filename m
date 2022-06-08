Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13854543071
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239276AbiFHMbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239252AbiFHMbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:31:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9B117705A
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654691504; x=1686227504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HQgNDGaxtm/9gknl6zsGMUe+qWdG9WyLhYuLDEvJUpg=;
  b=lRCfULiEnsmyOE69ixkaJglJ6kNP+cBv9Y47nc3eJDWYWzValWP/W2+m
   xjx+r2HGQ5hmw2gaUqgcoawNHQ6H4hwG1JWMrwIGB/hdi1le2ItQXCOHz
   E5z6RKcs0FpRQ6QQKoE5ybWyfhRJaEEo2WuGY7sbt+XYSx7wRJXPnVri8
   cHPRQU3s3viRkiTVXcycNU79bxbjIJbDuO96mE8sXpcWCLUIaU+Hu4tBE
   9LCDfHGEutN9EJOE4A6w04ivYPN4nxisqKto+cprdHF6xn5RJVofxtGu6
   49fZvNx4bOM0gDdkxpbOgU8gxgpUYjDW2T+Ip2wlcRBBPl8S5aqsbH1LI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302237998"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="302237998"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:31:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="670529749"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jun 2022 05:31:42 -0700
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
Subject: [RFC v2 04/15] vfio: Add base container
Date:   Wed,  8 Jun 2022 05:31:28 -0700
Message-Id: <20220608123139.19356-5-yi.l.liu@intel.com>
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

Abstract the VFIOContainer to be a base object. It is supposed to be
embedded by legacy VFIO container and later on, into the new iommufd
based container.

The base container implements generic code such as code related to
memory_listener and address space management. The VFIOContainerOps
implements callbacks that depend on the kernel user space being used.

'as.c' only manipulates the base container with wrapper functions that
calls the functions defined in VFIOContainerOps. Existing 'container.c'
code is converted to implement the legacy container ops functions.

Existing migration code only works with the legacy container.
Also 'spapr.c' isn't BE agnostic.

Below is the base container. It's named as VFIOContainer, old VFIOContainer
is replaced with VFIOLegacyContainer.

struct VFIOContainer {
    VFIOContainerOps *ops;
    VFIOAddressSpace *space;
    MemoryListener listener;
    Error *error;
    bool initialized;
    bool dirty_pages_supported;
    uint64_t dirty_pgsizes;
    uint64_t max_dirty_bitmap_size;
    unsigned long pgsizes;
    unsigned int dma_max_mappings;
    QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
    QLIST_HEAD(, VFIOHostDMAWindow) hostwin_list;
    QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
    QLIST_ENTRY(VFIOContainer) next;
};

struct VFIOLegacyContainer {
    VFIOContainer bcontainer;
    int fd; /* /dev/vfio/vfio, empowered by the attached groups */
    MemoryListener prereg_listener;
    unsigned iommu_type;
    QLIST_HEAD(, VFIOGroup) group_list;
};

Co-authored-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
v1 -> v2:
- Remove QOM for VFIOContainer object, use callback instead per David's
  comment.
- Rename container-obj.c/.h to be container-base.c/.h
---
 hw/vfio/as.c                          |  48 +++---
 hw/vfio/container-base.c              | 154 +++++++++++++++++++
 hw/vfio/container.c                   | 211 +++++++++++++++-----------
 hw/vfio/meson.build                   |   1 +
 hw/vfio/migration.c                   |   5 +-
 hw/vfio/pci.c                         |   4 +-
 hw/vfio/spapr.c                       |  22 +--
 include/hw/vfio/vfio-common.h         |  79 ++--------
 include/hw/vfio/vfio-container-base.h | 136 +++++++++++++++++
 9 files changed, 470 insertions(+), 190 deletions(-)
 create mode 100644 hw/vfio/container-base.c
 create mode 100644 include/hw/vfio/vfio-container-base.h

diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index 01eb60105b..ec58914001 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -216,9 +216,9 @@ static void vfio_iommu_map_notify(IOMMUNotifier *n, IOMMUTLBEntry *iotlb)
          * of vaddr will always be there, even if the memory object is
          * destroyed and its backing memory munmap-ed.
          */
-        ret = vfio_dma_map(container, iova,
-                           iotlb->addr_mask + 1, vaddr,
-                           read_only);
+        ret = vfio_container_dma_map(container, iova,
+                                     iotlb->addr_mask + 1, vaddr,
+                                     read_only);
         if (ret) {
             error_report("vfio_dma_map(%p, 0x%"HWADDR_PRIx", "
                          "0x%"HWADDR_PRIx", %p) = %d (%m)",
@@ -226,7 +226,8 @@ static void vfio_iommu_map_notify(IOMMUNotifier *n, IOMMUTLBEntry *iotlb)
                          iotlb->addr_mask + 1, vaddr, ret);
         }
     } else {
-        ret = vfio_dma_unmap(container, iova, iotlb->addr_mask + 1, iotlb);
+        ret = vfio_container_dma_unmap(container, iova,
+                                       iotlb->addr_mask + 1, iotlb);
         if (ret) {
             error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
                          "0x%"HWADDR_PRIx") = %d (%m)",
@@ -243,12 +244,13 @@ static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
 {
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
+    VFIOContainer *container = vrdl->container;
     const hwaddr size = int128_get64(section->size);
     const hwaddr iova = section->offset_within_address_space;
     int ret;
 
     /* Unmap with a single call. */
-    ret = vfio_dma_unmap(vrdl->container, iova, size , NULL);
+    ret = vfio_container_dma_unmap(container, iova, size , NULL);
     if (ret) {
         error_report("%s: vfio_dma_unmap() failed: %s", __func__,
                      strerror(-ret));
@@ -260,6 +262,7 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
 {
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
+    VFIOContainer *container = vrdl->container;
     const hwaddr end = section->offset_within_region +
                        int128_get64(section->size);
     hwaddr start, next, iova;
@@ -278,8 +281,8 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
                section->offset_within_address_space;
         vaddr = memory_region_get_ram_ptr(section->mr) + start;
 
-        ret = vfio_dma_map(vrdl->container, iova, next - start,
-                           vaddr, section->readonly);
+        ret = vfio_container_dma_map(container, iova, next - start,
+                                     vaddr, section->readonly);
         if (ret) {
             /* Rollback */
             vfio_ram_discard_notify_discard(rdl, section);
@@ -555,8 +558,8 @@ static void vfio_listener_region_add(MemoryListener *listener,
         }
     }
 
-    ret = vfio_dma_map(container, iova, int128_get64(llsize),
-                       vaddr, section->readonly);
+    ret = vfio_container_dma_map(container, iova, int128_get64(llsize),
+                                 vaddr, section->readonly);
     if (ret) {
         error_setg(&err, "vfio_dma_map(%p, 0x%"HWADDR_PRIx", "
                    "0x%"HWADDR_PRIx", %p) = %d (%m)",
@@ -681,7 +684,8 @@ static void vfio_listener_region_del(MemoryListener *listener,
         if (int128_eq(llsize, int128_2_64())) {
             /* The unmap ioctl doesn't accept a full 64-bit span. */
             llsize = int128_rshift(llsize, 1);
-            ret = vfio_dma_unmap(container, iova, int128_get64(llsize), NULL);
+            ret = vfio_container_dma_unmap(container, iova,
+                                           int128_get64(llsize), NULL);
             if (ret) {
                 error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
                              "0x%"HWADDR_PRIx") = %d (%m)",
@@ -689,7 +693,8 @@ static void vfio_listener_region_del(MemoryListener *listener,
             }
             iova += int128_get64(llsize);
         }
-        ret = vfio_dma_unmap(container, iova, int128_get64(llsize), NULL);
+        ret = vfio_container_dma_unmap(container, iova,
+                                       int128_get64(llsize), NULL);
         if (ret) {
             error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
                          "0x%"HWADDR_PRIx") = %d (%m)",
@@ -706,14 +711,14 @@ static void vfio_listener_log_global_start(MemoryListener *listener)
 {
     VFIOContainer *container = container_of(listener, VFIOContainer, listener);
 
-    vfio_set_dirty_page_tracking(container, true);
+    vfio_container_set_dirty_page_tracking(container, true);
 }
 
 static void vfio_listener_log_global_stop(MemoryListener *listener)
 {
     VFIOContainer *container = container_of(listener, VFIOContainer, listener);
 
-    vfio_set_dirty_page_tracking(container, false);
+    vfio_container_set_dirty_page_tracking(container, false);
 }
 
 typedef struct {
@@ -742,8 +747,9 @@ static void vfio_iommu_map_dirty_notify(IOMMUNotifier *n, IOMMUTLBEntry *iotlb)
     if (vfio_get_xlat_addr(iotlb, NULL, &translated_addr, NULL)) {
         int ret;
 
-        ret = vfio_get_dirty_bitmap(container, iova, iotlb->addr_mask + 1,
-                                    translated_addr);
+        ret = vfio_container_get_dirty_bitmap(container, iova,
+                                              iotlb->addr_mask + 1,
+                                              translated_addr);
         if (ret) {
             error_report("vfio_iommu_map_dirty_notify(%p, 0x%"HWADDR_PRIx", "
                          "0x%"HWADDR_PRIx") = %d (%m)",
@@ -767,11 +773,13 @@ static int vfio_ram_discard_get_dirty_bitmap(MemoryRegionSection *section,
      * Sync the whole mapped region (spanning multiple individual mappings)
      * in one go.
      */
-    return vfio_get_dirty_bitmap(vrdl->container, iova, size, ram_addr);
+    return vfio_container_get_dirty_bitmap(vrdl->container, iova,
+                                           size, ram_addr);
 }
 
-static int vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainer *container,
-                                                   MemoryRegionSection *section)
+static int
+vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainer *container,
+                                            MemoryRegionSection *section)
 {
     RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
     VFIORamDiscardListener *vrdl = NULL;
@@ -835,7 +843,7 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *container,
     ram_addr = memory_region_get_ram_addr(section->mr) +
                section->offset_within_region;
 
-    return vfio_get_dirty_bitmap(container,
+    return vfio_container_get_dirty_bitmap(container,
                    REAL_HOST_PAGE_ALIGN(section->offset_within_address_space),
                    int128_get64(section->size), ram_addr);
 }
@@ -850,7 +858,7 @@ static void vfio_listener_log_sync(MemoryListener *listener,
         return;
     }
 
-    if (vfio_devices_all_dirty_tracking(container)) {
+    if (vfio_container_devices_all_dirty_tracking(container)) {
         vfio_sync_dirty_bitmap(container, section);
     }
 }
diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
new file mode 100644
index 0000000000..6aaf0e0faa
--- /dev/null
+++ b/hw/vfio/container-base.c
@@ -0,0 +1,154 @@
+/*
+ * VFIO BASE CONTAINER
+ *
+ * Copyright (C) 2022 Intel Corporation.
+ * Copyright Red Hat, Inc. 2022
+ *
+ * Authors: Yi Liu <yi.l.liu@intel.com>
+ *          Eric Auger <eric.auger@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu/error-report.h"
+#include "hw/vfio/vfio-container-base.h"
+
+bool vfio_container_check_extension(VFIOContainer *container,
+                                    VFIOContainerFeature feat)
+{
+    if (!container->ops->check_extension) {
+        return false;
+    }
+
+    return container->ops->check_extension(container, feat);
+}
+
+int vfio_container_dma_map(VFIOContainer *container,
+                           hwaddr iova, ram_addr_t size,
+                           void *vaddr, bool readonly)
+{
+    if (!container->ops->dma_map) {
+        return -EINVAL;
+    }
+
+    return container->ops->dma_map(container, iova, size, vaddr, readonly);
+}
+
+int vfio_container_dma_unmap(VFIOContainer *container,
+                             hwaddr iova, ram_addr_t size,
+                             IOMMUTLBEntry *iotlb)
+{
+    if (!container->ops->dma_unmap) {
+        return -EINVAL;
+    }
+
+    return container->ops->dma_unmap(container, iova, size, iotlb);
+}
+
+void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
+                                            bool start)
+{
+    if (!container->ops->set_dirty_page_tracking) {
+        return;
+    }
+
+    container->ops->set_dirty_page_tracking(container, start);
+}
+
+bool vfio_container_devices_all_dirty_tracking(VFIOContainer *container)
+{
+    if (!container->ops->devices_all_dirty_tracking) {
+        return false;
+    }
+
+    return container->ops->devices_all_dirty_tracking(container);
+}
+
+int vfio_container_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
+                                    uint64_t size, ram_addr_t ram_addr)
+{
+    if (!container->ops->get_dirty_bitmap) {
+        return -EINVAL;
+    }
+
+    return container->ops->get_dirty_bitmap(container, iova, size, ram_addr);
+}
+
+int vfio_container_add_section_window(VFIOContainer *container,
+                                      MemoryRegionSection *section,
+                                      Error **errp)
+{
+    if (!container->ops->add_window) {
+        return 0;
+    }
+
+    return container->ops->add_window(container, section, errp);
+}
+
+void vfio_container_del_section_window(VFIOContainer *container,
+                                       MemoryRegionSection *section)
+{
+    if (!container->ops->del_window) {
+        return;
+    }
+
+    return container->ops->del_window(container, section);
+}
+
+void vfio_container_init(VFIOContainer *container,
+                         VFIOAddressSpace *space,
+                         const VFIOContainerOps *ops)
+{
+    container->ops = ops;
+    container->space = space;
+    container->error = NULL;
+    container->dirty_pages_supported = false;
+    container->dma_max_mappings = 0;
+    QLIST_INIT(&container->giommu_list);
+    QLIST_INIT(&container->hostwin_list);
+    QLIST_INIT(&container->vrdl_list);
+}
+
+void vfio_container_destroy(VFIOContainer *container)
+{
+    VFIORamDiscardListener *vrdl, *vrdl_tmp;
+    VFIOGuestIOMMU *giommu, *tmp;
+    VFIOHostDMAWindow *hostwin, *next;
+
+    QLIST_SAFE_REMOVE(container, next);
+
+    QLIST_FOREACH_SAFE(vrdl, &container->vrdl_list, next, vrdl_tmp) {
+        RamDiscardManager *rdm;
+
+        rdm = memory_region_get_ram_discard_manager(vrdl->mr);
+        ram_discard_manager_unregister_listener(rdm, &vrdl->listener);
+        QLIST_REMOVE(vrdl, next);
+        g_free(vrdl);
+    }
+
+    QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next, tmp) {
+        memory_region_unregister_iommu_notifier(
+                MEMORY_REGION(giommu->iommu_mr), &giommu->n);
+        QLIST_REMOVE(giommu, giommu_next);
+        g_free(giommu);
+    }
+
+    QLIST_FOREACH_SAFE(hostwin, &container->hostwin_list, hostwin_next,
+                       next) {
+        QLIST_REMOVE(hostwin, hostwin_next);
+        g_free(hostwin);
+    }
+}
diff --git a/hw/vfio/container.c b/hw/vfio/container.c
index 8ee7c9b980..dfc5183d5d 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -76,8 +76,11 @@ bool vfio_mig_active(void)
     return true;
 }
 
-bool vfio_devices_all_dirty_tracking(VFIOContainer *container)
+static bool vfio_devices_all_dirty_tracking(VFIOContainer *bcontainer)
 {
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer,
+                                                  bcontainer);
     VFIOGroup *group;
     VFIODevice *vbasedev;
     MigrationState *ms = migrate_get_current();
@@ -103,7 +106,7 @@ bool vfio_devices_all_dirty_tracking(VFIOContainer *container)
     return true;
 }
 
-bool vfio_devices_all_running_and_saving(VFIOContainer *container)
+static bool vfio_devices_all_running_and_saving(VFIOLegacyContainer *container)
 {
     VFIOGroup *group;
     VFIODevice *vbasedev;
@@ -132,10 +135,11 @@ bool vfio_devices_all_running_and_saving(VFIOContainer *container)
     return true;
 }
 
-static int vfio_dma_unmap_bitmap(VFIOContainer *container,
+static int vfio_dma_unmap_bitmap(VFIOLegacyContainer *container,
                                  hwaddr iova, ram_addr_t size,
                                  IOMMUTLBEntry *iotlb)
 {
+    VFIOContainer *bcontainer = &container->bcontainer;
     struct vfio_iommu_type1_dma_unmap *unmap;
     struct vfio_bitmap *bitmap;
     uint64_t pages = REAL_HOST_PAGE_ALIGN(size) / qemu_real_host_page_size();
@@ -159,7 +163,7 @@ static int vfio_dma_unmap_bitmap(VFIOContainer *container,
     bitmap->size = ROUND_UP(pages, sizeof(__u64) * BITS_PER_BYTE) /
                    BITS_PER_BYTE;
 
-    if (bitmap->size > container->max_dirty_bitmap_size) {
+    if (bitmap->size > bcontainer->max_dirty_bitmap_size) {
         error_report("UNMAP: Size of bitmap too big 0x%"PRIx64,
                      (uint64_t)bitmap->size);
         ret = -E2BIG;
@@ -189,10 +193,13 @@ unmap_exit:
 /*
  * DMA - Mapping and unmapping for the "type1" IOMMU interface used on x86
  */
-int vfio_dma_unmap(VFIOContainer *container,
-                   hwaddr iova, ram_addr_t size,
-                   IOMMUTLBEntry *iotlb)
+static int vfio_dma_unmap(VFIOContainer *bcontainer,
+                          hwaddr iova, ram_addr_t size,
+                          IOMMUTLBEntry *iotlb)
 {
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer,
+                                                  bcontainer);
     struct vfio_iommu_type1_dma_unmap unmap = {
         .argsz = sizeof(unmap),
         .flags = 0,
@@ -200,7 +207,7 @@ int vfio_dma_unmap(VFIOContainer *container,
         .size = size,
     };
 
-    if (iotlb && container->dirty_pages_supported &&
+    if (iotlb && bcontainer->dirty_pages_supported &&
         vfio_devices_all_running_and_saving(container)) {
         return vfio_dma_unmap_bitmap(container, iova, size, iotlb);
     }
@@ -221,7 +228,7 @@ int vfio_dma_unmap(VFIOContainer *container,
         if (errno == EINVAL && unmap.size && !(unmap.iova + unmap.size) &&
             container->iommu_type == VFIO_TYPE1v2_IOMMU) {
             trace_vfio_dma_unmap_overflow_workaround();
-            unmap.size -= 1ULL << ctz64(container->pgsizes);
+            unmap.size -= 1ULL << ctz64(bcontainer->pgsizes);
             continue;
         }
         error_report("VFIO_UNMAP_DMA failed: %s", strerror(errno));
@@ -231,9 +238,23 @@ int vfio_dma_unmap(VFIOContainer *container,
     return 0;
 }
 
-int vfio_dma_map(VFIOContainer *container, hwaddr iova,
-                 ram_addr_t size, void *vaddr, bool readonly)
+static bool vfio_legacy_container_check_extension(VFIOContainer *bcontainer,
+                                                  VFIOContainerFeature feat)
 {
+    switch (feat) {
+    case VFIO_FEAT_LIVE_MIGRATION:
+        return true;
+    default:
+        return false;
+    };
+}
+
+static int vfio_dma_map(VFIOContainer *bcontainer, hwaddr iova,
+                       ram_addr_t size, void *vaddr, bool readonly)
+{
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer,
+                                                  bcontainer);
     struct vfio_iommu_type1_dma_map map = {
         .argsz = sizeof(map),
         .flags = VFIO_DMA_MAP_FLAG_READ,
@@ -252,7 +273,7 @@ int vfio_dma_map(VFIOContainer *container, hwaddr iova,
      * the VGA ROM space.
      */
     if (ioctl(container->fd, VFIO_IOMMU_MAP_DMA, &map) == 0 ||
-        (errno == EBUSY && vfio_dma_unmap(container, iova, size, NULL) == 0 &&
+        (errno == EBUSY && vfio_dma_unmap(bcontainer, iova, size, NULL) == 0 &&
          ioctl(container->fd, VFIO_IOMMU_MAP_DMA, &map) == 0)) {
         return 0;
     }
@@ -261,8 +282,11 @@ int vfio_dma_map(VFIOContainer *container, hwaddr iova,
     return -errno;
 }
 
-void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start)
+static void vfio_set_dirty_page_tracking(VFIOContainer *bcontainer, bool start)
 {
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer,
+                                                  bcontainer);
     int ret;
     struct vfio_iommu_type1_dirty_bitmap dirty = {
         .argsz = sizeof(dirty),
@@ -281,9 +305,12 @@ void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start)
     }
 }
 
-int vfio_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
-                          uint64_t size, ram_addr_t ram_addr)
+static int vfio_get_dirty_bitmap(VFIOContainer *bcontainer, uint64_t iova,
+                                 uint64_t size, ram_addr_t ram_addr)
 {
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer,
+                                                  bcontainer);
     struct vfio_iommu_type1_dirty_bitmap *dbitmap;
     struct vfio_iommu_type1_dirty_bitmap_get *range;
     uint64_t pages;
@@ -333,18 +360,24 @@ err_out:
     return ret;
 }
 
-static void vfio_listener_release(VFIOContainer *container)
+static void vfio_listener_release(VFIOLegacyContainer *container)
 {
-    memory_listener_unregister(&container->listener);
+    VFIOContainer *bcontainer = &container->bcontainer;
+
+    memory_listener_unregister(&bcontainer->listener);
     if (container->iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
         memory_listener_unregister(&container->prereg_listener);
     }
 }
 
-int vfio_container_add_section_window(VFIOContainer *container,
-                                      MemoryRegionSection *section,
-                                      Error **errp)
+static int
+vfio_legacy_container_add_section_window(VFIOContainer *bcontainer,
+                                         MemoryRegionSection *section,
+                                         Error **errp)
 {
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer,
+                                                  bcontainer);
     VFIOHostDMAWindow *hostwin;
     hwaddr pgsize = 0;
     int ret;
@@ -354,7 +387,7 @@ int vfio_container_add_section_window(VFIOContainer *container,
     }
 
     /* For now intersections are not allowed, we may relax this later */
-    QLIST_FOREACH(hostwin, &container->hostwin_list, hostwin_next) {
+    QLIST_FOREACH(hostwin, &bcontainer->hostwin_list, hostwin_next) {
         if (ranges_overlap(hostwin->min_iova,
                            hostwin->max_iova - hostwin->min_iova + 1,
                            section->offset_within_address_space,
@@ -376,7 +409,7 @@ int vfio_container_add_section_window(VFIOContainer *container,
         return ret;
     }
 
-    vfio_host_win_add(container, section->offset_within_address_space,
+    vfio_host_win_add(bcontainer, section->offset_within_address_space,
                       section->offset_within_address_space +
                       int128_get64(section->size) - 1, pgsize);
 #ifdef CONFIG_KVM
@@ -409,16 +442,21 @@ int vfio_container_add_section_window(VFIOContainer *container,
     return 0;
 }
 
-void vfio_container_del_section_window(VFIOContainer *container,
-                                       MemoryRegionSection *section)
+static void
+vfio_legacy_container_del_section_window(VFIOContainer *bcontainer,
+                                         MemoryRegionSection *section)
 {
+    VFIOLegacyContainer *container = container_of(bcontainer,
+                                                  VFIOLegacyContainer,
+                                                  bcontainer);
+
     if (container->iommu_type != VFIO_SPAPR_TCE_v2_IOMMU) {
         return;
     }
 
     vfio_spapr_remove_window(container,
                              section->offset_within_address_space);
-    if (vfio_host_win_del(container,
+    if (vfio_host_win_del(bcontainer,
                           section->offset_within_address_space,
                           section->offset_within_address_space +
                           int128_get64(section->size) - 1) < 0) {
@@ -505,7 +543,7 @@ static void vfio_kvm_device_del_group(VFIOGroup *group)
 /*
  * vfio_get_iommu_type - selects the richest iommu_type (v2 first)
  */
-static int vfio_get_iommu_type(VFIOContainer *container,
+static int vfio_get_iommu_type(VFIOLegacyContainer *container,
                                Error **errp)
 {
     int iommu_types[] = { VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
@@ -521,7 +559,7 @@ static int vfio_get_iommu_type(VFIOContainer *container,
     return -EINVAL;
 }
 
-static int vfio_init_container(VFIOContainer *container, int group_fd,
+static int vfio_init_container(VFIOLegacyContainer *container, int group_fd,
                                Error **errp)
 {
     int iommu_type, ret;
@@ -556,7 +594,7 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
     return 0;
 }
 
-static int vfio_get_iommu_info(VFIOContainer *container,
+static int vfio_get_iommu_info(VFIOLegacyContainer *container,
                                struct vfio_iommu_type1_info **info)
 {
 
@@ -600,11 +638,12 @@ vfio_get_iommu_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
     return NULL;
 }
 
-static void vfio_get_iommu_info_migration(VFIOContainer *container,
-                                         struct vfio_iommu_type1_info *info)
+static void vfio_get_iommu_info_migration(VFIOLegacyContainer *container,
+                                          struct vfio_iommu_type1_info *info)
 {
     struct vfio_info_cap_header *hdr;
     struct vfio_iommu_type1_info_cap_migration *cap_mig;
+    VFIOContainer *bcontainer = &container->bcontainer;
 
     hdr = vfio_get_iommu_info_cap(info, VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION);
     if (!hdr) {
@@ -619,13 +658,14 @@ static void vfio_get_iommu_info_migration(VFIOContainer *container,
      * qemu_real_host_page_size to mark those dirty.
      */
     if (cap_mig->pgsize_bitmap & qemu_real_host_page_size()) {
-        container->dirty_pages_supported = true;
-        container->max_dirty_bitmap_size = cap_mig->max_dirty_bitmap_size;
-        container->dirty_pgsizes = cap_mig->pgsize_bitmap;
+        bcontainer->dirty_pages_supported = true;
+        bcontainer->max_dirty_bitmap_size = cap_mig->max_dirty_bitmap_size;
+        bcontainer->dirty_pgsizes = cap_mig->pgsize_bitmap;
     }
 }
 
-static int vfio_ram_block_discard_disable(VFIOContainer *container, bool state)
+static int
+vfio_ram_block_discard_disable(VFIOLegacyContainer *container, bool state)
 {
     switch (container->iommu_type) {
     case VFIO_TYPE1v2_IOMMU:
@@ -651,7 +691,8 @@ static int vfio_ram_block_discard_disable(VFIOContainer *container, bool state)
 static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
                                   Error **errp)
 {
-    VFIOContainer *container;
+    VFIOContainer *bcontainer;
+    VFIOLegacyContainer *container;
     int ret, fd;
     VFIOAddressSpace *space;
 
@@ -688,7 +729,8 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
      * details once we know which type of IOMMU we are using.
      */
 
-    QLIST_FOREACH(container, &space->containers, next) {
+    QLIST_FOREACH(bcontainer, &space->containers, next) {
+        container = container_of(bcontainer, VFIOLegacyContainer, bcontainer);
         if (!ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &container->fd)) {
             ret = vfio_ram_block_discard_disable(container, true);
             if (ret) {
@@ -724,14 +766,9 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
     }
 
     container = g_malloc0(sizeof(*container));
-    container->space = space;
     container->fd = fd;
-    container->error = NULL;
-    container->dirty_pages_supported = false;
-    container->dma_max_mappings = 0;
-    QLIST_INIT(&container->giommu_list);
-    QLIST_INIT(&container->hostwin_list);
-    QLIST_INIT(&container->vrdl_list);
+    bcontainer = &container->bcontainer;
+    vfio_container_init(bcontainer, space, &legacy_container_ops);
 
     ret = vfio_init_container(container, group->fd, errp);
     if (ret) {
@@ -763,13 +800,13 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
             /* Assume 4k IOVA page size */
             info->iova_pgsizes = 4096;
         }
-        vfio_host_win_add(container, 0, (hwaddr)-1, info->iova_pgsizes);
-        container->pgsizes = info->iova_pgsizes;
+        vfio_host_win_add(bcontainer, 0, (hwaddr)-1, info->iova_pgsizes);
+        bcontainer->pgsizes = info->iova_pgsizes;
 
         /* The default in the kernel ("dma_entry_limit") is 65535. */
-        container->dma_max_mappings = 65535;
+        bcontainer->dma_max_mappings = 65535;
         if (!ret) {
-            vfio_get_info_dma_avail(info, &container->dma_max_mappings);
+            vfio_get_info_dma_avail(info, &bcontainer->dma_max_mappings);
             vfio_get_iommu_info_migration(container, info);
         }
         g_free(info);
@@ -798,10 +835,10 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
 
             memory_listener_register(&container->prereg_listener,
                                      &address_space_memory);
-            if (container->error) {
+            if (bcontainer->error) {
                 memory_listener_unregister(&container->prereg_listener);
                 ret = -1;
-                error_propagate_prepend(errp, container->error,
+                error_propagate_prepend(errp, bcontainer->error,
                     "RAM memory listener initialization failed: ");
                 goto enable_discards_exit;
             }
@@ -820,7 +857,7 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
         }
 
         if (v2) {
-            container->pgsizes = info.ddw.pgsizes;
+            bcontainer->pgsizes = info.ddw.pgsizes;
             /*
              * There is a default window in just created container.
              * To make region_add/del simpler, we better remove this
@@ -835,8 +872,8 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
             }
         } else {
             /* The default table uses 4K pages */
-            container->pgsizes = 0x1000;
-            vfio_host_win_add(container, info.dma32_window_start,
+            bcontainer->pgsizes = 0x1000;
+            vfio_host_win_add(bcontainer, info.dma32_window_start,
                               info.dma32_window_start +
                               info.dma32_window_size - 1,
                               0x1000);
@@ -847,28 +884,28 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
     vfio_kvm_device_add_group(group);
 
     QLIST_INIT(&container->group_list);
-    QLIST_INSERT_HEAD(&space->containers, container, next);
+    QLIST_INSERT_HEAD(&space->containers, bcontainer, next);
 
     group->container = container;
     QLIST_INSERT_HEAD(&container->group_list, group, container_next);
 
-    container->listener = vfio_memory_listener;
+    bcontainer->listener = vfio_memory_listener;
 
-    memory_listener_register(&container->listener, container->space->as);
+    memory_listener_register(&bcontainer->listener, bcontainer->space->as);
 
-    if (container->error) {
+    if (bcontainer->error) {
         ret = -1;
-        error_propagate_prepend(errp, container->error,
+        error_propagate_prepend(errp, bcontainer->error,
             "memory listener initialization failed: ");
         goto listener_release_exit;
     }
 
-    container->initialized = true;
+    bcontainer->initialized = true;
 
     return 0;
 listener_release_exit:
     QLIST_REMOVE(group, container_next);
-    QLIST_REMOVE(container, next);
+    QLIST_REMOVE(bcontainer, next);
     vfio_kvm_device_del_group(group);
     vfio_listener_release(container);
 
@@ -889,7 +926,8 @@ put_space_exit:
 
 static void vfio_disconnect_container(VFIOGroup *group)
 {
-    VFIOContainer *container = group->container;
+    VFIOLegacyContainer *container = group->container;
+    VFIOContainer *bcontainer = &container->bcontainer;
 
     QLIST_REMOVE(group, container_next);
     group->container = NULL;
@@ -909,25 +947,9 @@ static void vfio_disconnect_container(VFIOGroup *group)
     }
 
     if (QLIST_EMPTY(&container->group_list)) {
-        VFIOAddressSpace *space = container->space;
-        VFIOGuestIOMMU *giommu, *tmp;
-        VFIOHostDMAWindow *hostwin, *next;
-
-        QLIST_REMOVE(container, next);
-
-        QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next, tmp) {
-            memory_region_unregister_iommu_notifier(
-                    MEMORY_REGION(giommu->iommu_mr), &giommu->n);
-            QLIST_REMOVE(giommu, giommu_next);
-            g_free(giommu);
-        }
-
-        QLIST_FOREACH_SAFE(hostwin, &container->hostwin_list, hostwin_next,
-                           next) {
-            QLIST_REMOVE(hostwin, hostwin_next);
-            g_free(hostwin);
-        }
+        VFIOAddressSpace *space = bcontainer->space;
 
+        vfio_container_destroy(bcontainer);
         trace_vfio_disconnect_container(container->fd);
         close(container->fd);
         g_free(container);
@@ -939,13 +961,15 @@ static void vfio_disconnect_container(VFIOGroup *group)
 VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
 {
     VFIOGroup *group;
+    VFIOContainer *bcontainer;
     char path[32];
     struct vfio_group_status status = { .argsz = sizeof(status) };
 
     QLIST_FOREACH(group, &vfio_group_list, next) {
         if (group->groupid == groupid) {
             /* Found it.  Now is it already in the right context? */
-            if (group->container->space->as == as) {
+            bcontainer = &group->container->bcontainer;
+            if (bcontainer->space->as == as) {
                 return group;
             } else {
                 error_setg(errp, "group %d used in multiple address spaces",
@@ -1098,7 +1122,7 @@ void vfio_put_base_device(VFIODevice *vbasedev)
 /*
  * Interfaces for IBM EEH (Enhanced Error Handling)
  */
-static bool vfio_eeh_container_ok(VFIOContainer *container)
+static bool vfio_eeh_container_ok(VFIOLegacyContainer *container)
 {
     /*
      * As of 2016-03-04 (linux-4.5) the host kernel EEH/VFIO
@@ -1126,7 +1150,7 @@ static bool vfio_eeh_container_ok(VFIOContainer *container)
     return true;
 }
 
-static int vfio_eeh_container_op(VFIOContainer *container, uint32_t op)
+static int vfio_eeh_container_op(VFIOLegacyContainer *container, uint32_t op)
 {
     struct vfio_eeh_pe_op pe_op = {
         .argsz = sizeof(pe_op),
@@ -1149,19 +1173,21 @@ static int vfio_eeh_container_op(VFIOContainer *container, uint32_t op)
     return ret;
 }
 
-static VFIOContainer *vfio_eeh_as_container(AddressSpace *as)
+static VFIOLegacyContainer *vfio_eeh_as_container(AddressSpace *as)
 {
     VFIOAddressSpace *space = vfio_get_address_space(as);
-    VFIOContainer *container = NULL;
+    VFIOLegacyContainer *container = NULL;
+    VFIOContainer *bcontainer = NULL;
 
     if (QLIST_EMPTY(&space->containers)) {
         /* No containers to act on */
         goto out;
     }
 
-    container = QLIST_FIRST(&space->containers);
+    bcontainer = QLIST_FIRST(&space->containers);
+    container = container_of(bcontainer, VFIOLegacyContainer, bcontainer);
 
-    if (QLIST_NEXT(container, next)) {
+    if (QLIST_NEXT(bcontainer, next)) {
         /*
          * We don't yet have logic to synchronize EEH state across
          * multiple containers.
@@ -1177,17 +1203,28 @@ out:
 
 bool vfio_eeh_as_ok(AddressSpace *as)
 {
-    VFIOContainer *container = vfio_eeh_as_container(as);
+    VFIOLegacyContainer *container = vfio_eeh_as_container(as);
 
     return (container != NULL) && vfio_eeh_container_ok(container);
 }
 
 int vfio_eeh_as_op(AddressSpace *as, uint32_t op)
 {
-    VFIOContainer *container = vfio_eeh_as_container(as);
+    VFIOLegacyContainer *container = vfio_eeh_as_container(as);
 
     if (!container) {
         return -ENODEV;
     }
     return vfio_eeh_container_op(container, op);
 }
+
+const VFIOContainerOps legacy_container_ops = {
+    .dma_map = vfio_dma_map,
+    .dma_unmap = vfio_dma_unmap,
+    .devices_all_dirty_tracking = vfio_devices_all_dirty_tracking,
+    .set_dirty_page_tracking = vfio_set_dirty_page_tracking,
+    .get_dirty_bitmap = vfio_get_dirty_bitmap,
+    .add_window = vfio_legacy_container_add_section_window,
+    .del_window = vfio_legacy_container_del_section_window,
+    .check_extension = vfio_legacy_container_check_extension,
+};
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index e3b6d6e2cb..067c3c3c5f 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -2,6 +2,7 @@ vfio_ss = ss.source_set()
 vfio_ss.add(files(
   'common.c',
   'as.c',
+  'container-base.c',
   'container.c',
   'spapr.c',
   'migration.c',
diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
index a6ad1f8945..6abbf54d14 100644
--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -857,11 +857,12 @@ int64_t vfio_mig_bytes_transferred(void)
 
 int vfio_migration_probe(VFIODevice *vbasedev, Error **errp)
 {
-    VFIOContainer *container = vbasedev->group->container;
+    VFIOLegacyContainer *container = vbasedev->group->container;
     struct vfio_region_info *info = NULL;
     int ret = -ENOTSUP;
 
-    if (!vbasedev->enable_migration || !container->dirty_pages_supported) {
+    if (!vbasedev->enable_migration ||
+        !container->bcontainer.dirty_pages_supported) {
         goto add_blocker;
     }
 
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 939dcc3d4a..a9973a6d6a 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -3144,7 +3144,9 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
         }
     }
 
-    if (!pdev->failover_pair_id) {
+    if (!pdev->failover_pair_id &&
+        vfio_container_check_extension(&vbasedev->group->container->bcontainer,
+                                       VFIO_FEAT_LIVE_MIGRATION)) {
         ret = vfio_migration_probe(vbasedev, errp);
         if (ret) {
             error_report("%s: Migration disabled", vbasedev->name);
diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
index 9ec1e95f6d..7647e7d492 100644
--- a/hw/vfio/spapr.c
+++ b/hw/vfio/spapr.c
@@ -39,8 +39,8 @@ static void *vfio_prereg_gpa_to_vaddr(MemoryRegionSection *section, hwaddr gpa)
 static void vfio_prereg_listener_region_add(MemoryListener *listener,
                                             MemoryRegionSection *section)
 {
-    VFIOContainer *container = container_of(listener, VFIOContainer,
-                                            prereg_listener);
+    VFIOLegacyContainer *container = container_of(listener, VFIOLegacyContainer,
+                                                  prereg_listener);
     const hwaddr gpa = section->offset_within_address_space;
     hwaddr end;
     int ret;
@@ -83,9 +83,9 @@ static void vfio_prereg_listener_region_add(MemoryListener *listener,
          * can gracefully fail.  Runtime, there's not much we can do other
          * than throw a hardware error.
          */
-        if (!container->initialized) {
-            if (!container->error) {
-                error_setg_errno(&container->error, -ret,
+        if (!container->bcontainer.initialized) {
+            if (!container->bcontainer.error) {
+                error_setg_errno(&container->bcontainer.error, -ret,
                                  "Memory registering failed");
             }
         } else {
@@ -97,8 +97,8 @@ static void vfio_prereg_listener_region_add(MemoryListener *listener,
 static void vfio_prereg_listener_region_del(MemoryListener *listener,
                                             MemoryRegionSection *section)
 {
-    VFIOContainer *container = container_of(listener, VFIOContainer,
-                                            prereg_listener);
+    VFIOLegacyContainer *container = container_of(listener, VFIOLegacyContainer,
+                                                  prereg_listener);
     const hwaddr gpa = section->offset_within_address_space;
     hwaddr end;
     int ret;
@@ -141,7 +141,7 @@ const MemoryListener vfio_prereg_listener = {
     .region_del = vfio_prereg_listener_region_del,
 };
 
-int vfio_spapr_create_window(VFIOContainer *container,
+int vfio_spapr_create_window(VFIOLegacyContainer *container,
                              MemoryRegionSection *section,
                              hwaddr *pgsize)
 {
@@ -159,13 +159,13 @@ int vfio_spapr_create_window(VFIOContainer *container,
     if (pagesize > rampagesize) {
         pagesize = rampagesize;
     }
-    pgmask = container->pgsizes & (pagesize | (pagesize - 1));
+    pgmask = container->bcontainer.pgsizes & (pagesize | (pagesize - 1));
     pagesize = pgmask ? (1ULL << (63 - clz64(pgmask))) : 0;
     if (!pagesize) {
         error_report("Host doesn't support page size 0x%"PRIx64
                      ", the supported mask is 0x%lx",
                      memory_region_iommu_get_min_page_size(iommu_mr),
-                     container->pgsizes);
+                     container->bcontainer.pgsizes);
         return -EINVAL;
     }
 
@@ -233,7 +233,7 @@ int vfio_spapr_create_window(VFIOContainer *container,
     return 0;
 }
 
-int vfio_spapr_remove_window(VFIOContainer *container,
+int vfio_spapr_remove_window(VFIOLegacyContainer *container,
                              hwaddr offset_within_address_space)
 {
     struct vfio_iommu_spapr_tce_remove remove = {
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 03ff7944cb..5cc0413b5c 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -30,10 +30,12 @@
 #include <linux/vfio.h>
 #endif
 #include "sysemu/sysemu.h"
+#include "hw/vfio/vfio-container-base.h"
 
 #define VFIO_MSG_PREFIX "vfio %s: "
 
 extern const MemoryListener vfio_memory_listener;
+extern const VFIOContainerOps legacy_container_ops;
 
 enum {
     VFIO_DEVICE_TYPE_PCI = 0,
@@ -70,58 +72,15 @@ typedef struct VFIOMigration {
     uint64_t pending_bytes;
 } VFIOMigration;
 
-typedef struct VFIOAddressSpace {
-    AddressSpace *as;
-    QLIST_HEAD(, VFIOContainer) containers;
-    QLIST_ENTRY(VFIOAddressSpace) list;
-} VFIOAddressSpace;
-
 struct VFIOGroup;
 
-typedef struct VFIOContainer {
-    VFIOAddressSpace *space;
+typedef struct VFIOLegacyContainer {
+    VFIOContainer bcontainer;
     int fd; /* /dev/vfio/vfio, empowered by the attached groups */
-    MemoryListener listener;
     MemoryListener prereg_listener;
     unsigned iommu_type;
-    Error *error;
-    bool initialized;
-    bool dirty_pages_supported;
-    uint64_t dirty_pgsizes;
-    uint64_t max_dirty_bitmap_size;
-    unsigned long pgsizes;
-    unsigned int dma_max_mappings;
-    QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
-    QLIST_HEAD(, VFIOHostDMAWindow) hostwin_list;
     QLIST_HEAD(, VFIOGroup) group_list;
-    QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
-    QLIST_ENTRY(VFIOContainer) next;
-} VFIOContainer;
-
-typedef struct VFIOGuestIOMMU {
-    VFIOContainer *container;
-    IOMMUMemoryRegion *iommu_mr;
-    hwaddr iommu_offset;
-    IOMMUNotifier n;
-    QLIST_ENTRY(VFIOGuestIOMMU) giommu_next;
-} VFIOGuestIOMMU;
-
-typedef struct VFIORamDiscardListener {
-    VFIOContainer *container;
-    MemoryRegion *mr;
-    hwaddr offset_within_address_space;
-    hwaddr size;
-    uint64_t granularity;
-    RamDiscardListener listener;
-    QLIST_ENTRY(VFIORamDiscardListener) next;
-} VFIORamDiscardListener;
-
-typedef struct VFIOHostDMAWindow {
-    hwaddr min_iova;
-    hwaddr max_iova;
-    uint64_t iova_pgsizes;
-    QLIST_ENTRY(VFIOHostDMAWindow) hostwin_next;
-} VFIOHostDMAWindow;
+} VFIOLegacyContainer;
 
 typedef struct VFIODeviceOps VFIODeviceOps;
 
@@ -159,7 +118,7 @@ struct VFIODeviceOps {
 typedef struct VFIOGroup {
     int fd;
     int groupid;
-    VFIOContainer *container;
+    VFIOLegacyContainer *container;
     QLIST_HEAD(, VFIODevice) device_list;
     QLIST_ENTRY(VFIOGroup) next;
     QLIST_ENTRY(VFIOGroup) container_next;
@@ -192,31 +151,13 @@ typedef struct VFIODisplay {
     } dmabuf;
 } VFIODisplay;
 
-void vfio_host_win_add(VFIOContainer *container,
+void vfio_host_win_add(VFIOContainer *bcontainer,
                        hwaddr min_iova, hwaddr max_iova,
                        uint64_t iova_pgsizes);
-int vfio_host_win_del(VFIOContainer *container, hwaddr min_iova,
+int vfio_host_win_del(VFIOContainer *bcontainer, hwaddr min_iova,
                       hwaddr max_iova);
 VFIOAddressSpace *vfio_get_address_space(AddressSpace *as);
 void vfio_put_address_space(VFIOAddressSpace *space);
-bool vfio_devices_all_running_and_saving(VFIOContainer *container);
-bool vfio_devices_all_dirty_tracking(VFIOContainer *container);
-
-/* container->fd */
-int vfio_dma_unmap(VFIOContainer *container,
-                   hwaddr iova, ram_addr_t size,
-                   IOMMUTLBEntry *iotlb);
-int vfio_dma_map(VFIOContainer *container, hwaddr iova,
-                 ram_addr_t size, void *vaddr, bool readonly);
-void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start);
-int vfio_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
-                          uint64_t size, ram_addr_t ram_addr);
-
-int vfio_container_add_section_window(VFIOContainer *container,
-                                      MemoryRegionSection *section,
-                                      Error **errp);
-void vfio_container_del_section_window(VFIOContainer *container,
-                                       MemoryRegionSection *section);
 
 void vfio_put_base_device(VFIODevice *vbasedev);
 void vfio_disable_irqindex(VFIODevice *vbasedev, int index);
@@ -263,10 +204,10 @@ vfio_get_device_info_cap(struct vfio_device_info *info, uint16_t id);
 #endif
 extern const MemoryListener vfio_prereg_listener;
 
-int vfio_spapr_create_window(VFIOContainer *container,
+int vfio_spapr_create_window(VFIOLegacyContainer *container,
                              MemoryRegionSection *section,
                              hwaddr *pgsize);
-int vfio_spapr_remove_window(VFIOContainer *container,
+int vfio_spapr_remove_window(VFIOLegacyContainer *container,
                              hwaddr offset_within_address_space);
 
 int vfio_migration_probe(VFIODevice *vbasedev, Error **errp);
diff --git a/include/hw/vfio/vfio-container-base.h b/include/hw/vfio/vfio-container-base.h
new file mode 100644
index 0000000000..fa5d7fcb85
--- /dev/null
+++ b/include/hw/vfio/vfio-container-base.h
@@ -0,0 +1,136 @@
+/*
+ * VFIO BASE CONTAINER
+ *
+ * Copyright (C) 2022 Intel Corporation.
+ * Copyright Red Hat, Inc. 2022
+ *
+ * Authors: Yi Liu <yi.l.liu@intel.com>
+ *          Eric Auger <eric.auger@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HW_VFIO_VFIO_BASE_CONTAINER_H
+#define HW_VFIO_VFIO_BASE_CONTAINER_H
+
+#include "exec/memory.h"
+#ifndef CONFIG_USER_ONLY
+#include "exec/hwaddr.h"
+#endif
+
+typedef enum VFIOContainerFeature {
+    VFIO_FEAT_LIVE_MIGRATION,
+} VFIOContainerFeature;
+
+typedef struct VFIOContainer VFIOContainer;
+
+typedef struct VFIOAddressSpace {
+    AddressSpace *as;
+    QLIST_HEAD(, VFIOContainer) containers;
+    QLIST_ENTRY(VFIOAddressSpace) list;
+} VFIOAddressSpace;
+
+typedef struct VFIOGuestIOMMU {
+    VFIOContainer *container;
+    IOMMUMemoryRegion *iommu_mr;
+    hwaddr iommu_offset;
+    IOMMUNotifier n;
+    QLIST_ENTRY(VFIOGuestIOMMU) giommu_next;
+} VFIOGuestIOMMU;
+
+typedef struct VFIORamDiscardListener {
+    VFIOContainer *container;
+    MemoryRegion *mr;
+    hwaddr offset_within_address_space;
+    hwaddr size;
+    uint64_t granularity;
+    RamDiscardListener listener;
+    QLIST_ENTRY(VFIORamDiscardListener) next;
+} VFIORamDiscardListener;
+
+typedef struct VFIOHostDMAWindow {
+    hwaddr min_iova;
+    hwaddr max_iova;
+    uint64_t iova_pgsizes;
+    QLIST_ENTRY(VFIOHostDMAWindow) hostwin_next;
+} VFIOHostDMAWindow;
+
+typedef struct VFIOContainerOps {
+    /* required */
+    bool (*check_extension)(VFIOContainer *container,
+                            VFIOContainerFeature feat);
+    int (*dma_map)(VFIOContainer *container,
+                   hwaddr iova, ram_addr_t size,
+                   void *vaddr, bool readonly);
+    int (*dma_unmap)(VFIOContainer *container,
+                     hwaddr iova, ram_addr_t size,
+                     IOMMUTLBEntry *iotlb);
+    /* migration feature */
+    bool (*devices_all_dirty_tracking)(VFIOContainer *container);
+    void (*set_dirty_page_tracking)(VFIOContainer *container, bool start);
+    int (*get_dirty_bitmap)(VFIOContainer *container, uint64_t iova,
+                            uint64_t size, ram_addr_t ram_addr);
+
+    /* SPAPR specific */
+    int (*add_window)(VFIOContainer *container,
+                      MemoryRegionSection *section,
+                      Error **errp);
+    void (*del_window)(VFIOContainer *container,
+                       MemoryRegionSection *section);
+} VFIOContainerOps;
+
+/*
+ * This is the base object for vfio container backends
+ */
+struct VFIOContainer {
+    const VFIOContainerOps *ops;
+    VFIOAddressSpace *space;
+    MemoryListener listener;
+    Error *error;
+    bool initialized;
+    bool dirty_pages_supported;
+    uint64_t dirty_pgsizes;
+    uint64_t max_dirty_bitmap_size;
+    unsigned long pgsizes;
+    unsigned int dma_max_mappings;
+    QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
+    QLIST_HEAD(, VFIOHostDMAWindow) hostwin_list;
+    QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
+    QLIST_ENTRY(VFIOContainer) next;
+};
+
+bool vfio_container_check_extension(VFIOContainer *container,
+                                    VFIOContainerFeature feat);
+int vfio_container_dma_map(VFIOContainer *container,
+                           hwaddr iova, ram_addr_t size,
+                           void *vaddr, bool readonly);
+int vfio_container_dma_unmap(VFIOContainer *container,
+                             hwaddr iova, ram_addr_t size,
+                             IOMMUTLBEntry *iotlb);
+bool vfio_container_devices_all_dirty_tracking(VFIOContainer *container);
+void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
+                                            bool start);
+int vfio_container_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
+                                    uint64_t size, ram_addr_t ram_addr);
+int vfio_container_add_section_window(VFIOContainer *container,
+                                      MemoryRegionSection *section,
+                                      Error **errp);
+void vfio_container_del_section_window(VFIOContainer *container,
+                                       MemoryRegionSection *section);
+
+void vfio_container_init(VFIOContainer *container,
+                         VFIOAddressSpace *space,
+                         const VFIOContainerOps *ops);
+void vfio_container_destroy(VFIOContainer *container);
+#endif /* HW_VFIO_VFIO_BASE_CONTAINER_H */
-- 
2.27.0

