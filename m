Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91156837FF
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjAaUzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbjAaUzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:55:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA1510CA
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xG/w4NbsrioqtWY7YAJKcCPrNc6FVFgR4IXN1v8E7+4=;
        b=h/1VxazW5bX4aYt/5sglMxk+6iFbKseD3b/Q3vkN2j0J5ZtIm2OJ/rj9EPzeYsQQ+02erY
        JgQA6PXfwHXZTTT55z5ttEvWaQaNdYMRdeYn0G31h9PoBS48Jg5Z4YBYURM7fag3sJ0dMy
        5VDGUjdL+hyEOWt3b1kEx6xnT+7W+e0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-2_6AUA0uOWaIgHKj5CJPYw-1; Tue, 31 Jan 2023 15:54:04 -0500
X-MC-Unique: 2_6AUA0uOWaIgHKj5CJPYw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A20C13813F2F;
        Tue, 31 Jan 2023 20:54:03 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E69640C2064;
        Tue, 31 Jan 2023 20:53:56 +0000 (UTC)
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
Subject: [RFC v3 07/18] vfio: Add base container
Date:   Tue, 31 Jan 2023 21:52:54 +0100
Message-Id: <20230131205305.2726330-8-eric.auger@redhat.com>
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
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
v2 -> v3:
- Use OpsClass instead of a simple ops struct

v1 -> v2:
- Remove QOM for VFIOContainer object, use callback instead per David's
  comment.
- Rename container-obj.c/.h to be container-base.c/.h
---
 include/hw/vfio/vfio-common.h         |  78 +--------
 include/hw/vfio/vfio-container-base.h | 151 +++++++++++++++++
 hw/vfio/as.c                          |  61 ++++---
 hw/vfio/container-base.c              | 154 +++++++++++++++++
 hw/vfio/container.c                   | 232 ++++++++++++++++----------
 hw/vfio/migration.c                   |   5 +-
 hw/vfio/pci.c                         |   4 +-
 hw/vfio/spapr.c                       |  22 +--
 hw/vfio/meson.build                   |   1 +
 9 files changed, 517 insertions(+), 191 deletions(-)
 create mode 100644 include/hw/vfio/vfio-container-base.h
 create mode 100644 hw/vfio/container-base.c

diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index bc70e8748a..63566ddbc0 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -30,6 +30,7 @@
 #include <linux/vfio.h>
 #endif
 #include "sysemu/sysemu.h"
+#include "hw/vfio/vfio-container-base.h"
 
 #define VFIO_MSG_PREFIX "vfio %s: "
 
@@ -70,58 +71,15 @@ typedef struct VFIOMigration {
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
 
@@ -159,7 +117,7 @@ struct VFIODeviceOps {
 typedef struct VFIOGroup {
     int fd;
     int groupid;
-    VFIOContainer *container;
+    VFIOLegacyContainer *container;
     QLIST_HEAD(, VFIODevice) device_list;
     QLIST_ENTRY(VFIOGroup) next;
     QLIST_ENTRY(VFIOGroup) container_next;
@@ -192,31 +150,13 @@ typedef struct VFIODisplay {
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
@@ -265,10 +205,10 @@ vfio_get_cap(void *ptr, uint32_t cap_offset, uint16_t id);
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
index 0000000000..6080a588bf
--- /dev/null
+++ b/include/hw/vfio/vfio-container-base.h
@@ -0,0 +1,151 @@
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
+typedef struct VFIODevice VFIODevice;
+typedef struct VFIOIOMMUBackendOpsClass VFIOIOMMUBackendOpsClass;
+
+/*
+ * This is the base object for vfio container backends
+ */
+struct VFIOContainer {
+    VFIOIOMMUBackendOpsClass *ops;
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
+                         struct VFIOIOMMUBackendOpsClass *ops);
+void vfio_container_destroy(VFIOContainer *container);
+
+#define TYPE_VFIO_IOMMU_BACKEND_LEGACY_OPS "vfio-iommu-backend-legacy-ops"
+#define TYPE_VFIO_IOMMU_BACKEND_OPS "vfio-iommu-backend-ops"
+
+DECLARE_CLASS_CHECKERS(VFIOIOMMUBackendOpsClass,
+                       VFIO_IOMMU_BACKEND_OPS, TYPE_VFIO_IOMMU_BACKEND_OPS)
+
+struct VFIOIOMMUBackendOpsClass {
+    /*< private >*/
+    ObjectClass parent_class;
+
+    /*< public >*/
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
+};
+
+
+#endif /* HW_VFIO_VFIO_BASE_CONTAINER_H */
diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index d2899151db..6a5f3f80b5 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -159,9 +159,9 @@ static void vfio_iommu_map_notify(IOMMUNotifier *n, IOMMUTLBEntry *iotlb)
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
@@ -169,7 +169,8 @@ static void vfio_iommu_map_notify(IOMMUNotifier *n, IOMMUTLBEntry *iotlb)
                          iotlb->addr_mask + 1, vaddr, ret);
         }
     } else {
-        ret = vfio_dma_unmap(container, iova, iotlb->addr_mask + 1, iotlb);
+        ret = vfio_container_dma_unmap(container, iova,
+                                       iotlb->addr_mask + 1, iotlb);
         if (ret) {
             error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
                          "0x%"HWADDR_PRIx") = %d (%m)",
@@ -186,12 +187,13 @@ static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
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
@@ -203,6 +205,7 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
 {
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
+    VFIOContainer *container = vrdl->container;
     const hwaddr end = section->offset_within_region +
                        int128_get64(section->size);
     hwaddr start, next, iova;
@@ -221,8 +224,8 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
                section->offset_within_address_space;
         vaddr = memory_region_get_ram_ptr(section->mr) + start;
 
-        ret = vfio_dma_map(vrdl->container, iova, next - start,
-                           vaddr, section->readonly);
+        ret = vfio_container_dma_map(container, iova, next - start,
+                                     vaddr, section->readonly);
         if (ret) {
             /* Rollback */
             vfio_ram_discard_notify_discard(rdl, section);
@@ -498,8 +501,8 @@ static void vfio_listener_region_add(MemoryListener *listener,
         }
     }
 
-    ret = vfio_dma_map(container, iova, int128_get64(llsize),
-                       vaddr, section->readonly);
+    ret = vfio_container_dma_map(container, iova, int128_get64(llsize),
+                                 vaddr, section->readonly);
     if (ret) {
         error_setg(&err, "vfio_dma_map(%p, 0x%"HWADDR_PRIx", "
                    "0x%"HWADDR_PRIx", %p) = %d (%m)",
@@ -632,7 +635,8 @@ static void vfio_listener_region_del(MemoryListener *listener,
         if (int128_eq(llsize, int128_2_64())) {
             /* The unmap ioctl doesn't accept a full 64-bit span. */
             llsize = int128_rshift(llsize, 1);
-            ret = vfio_dma_unmap(container, iova, int128_get64(llsize), NULL);
+            ret = vfio_container_dma_unmap(container, iova,
+                                           int128_get64(llsize), NULL);
             if (ret) {
                 error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
                              "0x%"HWADDR_PRIx") = %d (%m)",
@@ -640,7 +644,8 @@ static void vfio_listener_region_del(MemoryListener *listener,
             }
             iova += int128_get64(llsize);
         }
-        ret = vfio_dma_unmap(container, iova, int128_get64(llsize), NULL);
+        ret = vfio_container_dma_unmap(container, iova,
+                                       int128_get64(llsize), NULL);
         if (ret) {
             error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
                          "0x%"HWADDR_PRIx") = %d (%m)",
@@ -657,14 +662,14 @@ static void vfio_listener_log_global_start(MemoryListener *listener)
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
@@ -693,8 +698,9 @@ static void vfio_iommu_map_dirty_notify(IOMMUNotifier *n, IOMMUTLBEntry *iotlb)
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
@@ -718,11 +724,13 @@ static int vfio_ram_discard_get_dirty_bitmap(MemoryRegionSection *section,
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
@@ -786,7 +794,7 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *container,
     ram_addr = memory_region_get_ram_addr(section->mr) +
                section->offset_within_region;
 
-    return vfio_get_dirty_bitmap(container,
+    return vfio_container_get_dirty_bitmap(container,
                    REAL_HOST_PAGE_ALIGN(section->offset_within_address_space),
                    int128_get64(section->size), ram_addr);
 }
@@ -801,7 +809,7 @@ static void vfio_listener_log_sync(MemoryListener *listener,
         return;
     }
 
-    if (vfio_devices_all_dirty_tracking(container)) {
+    if (vfio_container_devices_all_dirty_tracking(container)) {
         vfio_sync_dirty_bitmap(container, section);
     }
 }
@@ -842,3 +850,16 @@ void vfio_put_address_space(VFIOAddressSpace *space)
         g_free(space);
     }
 }
+
+static const TypeInfo vfio_iommu_backend_ops_type_info = {
+    .name = TYPE_VFIO_IOMMU_BACKEND_OPS,
+    .parent = TYPE_OBJECT,
+    .abstract = true,
+    .class_size = sizeof(VFIOIOMMUBackendOpsClass),
+};
+
+static void vfio_iommu_backend_ops_register_types(void)
+{
+    type_register_static(&vfio_iommu_backend_ops_type_info);
+}
+type_init(vfio_iommu_backend_ops_register_types);
diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
new file mode 100644
index 0000000000..b4ce0cd89a
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
+                         struct VFIOIOMMUBackendOpsClass *ops)
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
index 68d4e360ed..ca24f7f922 100644
--- a/hw/vfio/container.c
+++ b/hw/vfio/container.c
@@ -53,7 +53,8 @@ VFIOGroupList vfio_group_list =
 static int vfio_kvm_device_fd = -1;
 #endif
 
-static int vfio_ram_block_discard_disable(VFIOContainer *container, bool state)
+static int
+vfio_ram_block_discard_disable(VFIOLegacyContainer *container, bool state)
 {
     switch (container->iommu_type) {
     case VFIO_TYPE1v2_IOMMU:
@@ -99,8 +100,11 @@ bool vfio_mig_active(void)
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
@@ -126,7 +130,7 @@ bool vfio_devices_all_dirty_tracking(VFIOContainer *container)
     return true;
 }
 
-bool vfio_devices_all_running_and_saving(VFIOContainer *container)
+static bool vfio_devices_all_running_and_saving(VFIOLegacyContainer *container)
 {
     VFIOGroup *group;
     VFIODevice *vbasedev;
@@ -155,10 +159,11 @@ bool vfio_devices_all_running_and_saving(VFIOContainer *container)
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
@@ -182,7 +187,7 @@ static int vfio_dma_unmap_bitmap(VFIOContainer *container,
     bitmap->size = ROUND_UP(pages, sizeof(__u64) * BITS_PER_BYTE) /
                    BITS_PER_BYTE;
 
-    if (bitmap->size > container->max_dirty_bitmap_size) {
+    if (bitmap->size > bcontainer->max_dirty_bitmap_size) {
         error_report("UNMAP: Size of bitmap too big 0x%"PRIx64,
                      (uint64_t)bitmap->size);
         ret = -E2BIG;
@@ -212,10 +217,13 @@ unmap_exit:
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
@@ -223,7 +231,7 @@ int vfio_dma_unmap(VFIOContainer *container,
         .size = size,
     };
 
-    if (iotlb && container->dirty_pages_supported &&
+    if (iotlb && bcontainer->dirty_pages_supported &&
         vfio_devices_all_running_and_saving(container)) {
         return vfio_dma_unmap_bitmap(container, iova, size, iotlb);
     }
@@ -244,7 +252,7 @@ int vfio_dma_unmap(VFIOContainer *container,
         if (errno == EINVAL && unmap.size && !(unmap.iova + unmap.size) &&
             container->iommu_type == VFIO_TYPE1v2_IOMMU) {
             trace_vfio_dma_unmap_overflow_workaround();
-            unmap.size -= 1ULL << ctz64(container->pgsizes);
+            unmap.size -= 1ULL << ctz64(bcontainer->pgsizes);
             continue;
         }
         error_report("VFIO_UNMAP_DMA failed: %s", strerror(errno));
@@ -254,9 +262,23 @@ int vfio_dma_unmap(VFIOContainer *container,
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
@@ -275,7 +297,7 @@ int vfio_dma_map(VFIOContainer *container, hwaddr iova,
      * the VGA ROM space.
      */
     if (ioctl(container->fd, VFIO_IOMMU_MAP_DMA, &map) == 0 ||
-        (errno == EBUSY && vfio_dma_unmap(container, iova, size, NULL) == 0 &&
+        (errno == EBUSY && vfio_dma_unmap(bcontainer, iova, size, NULL) == 0 &&
          ioctl(container->fd, VFIO_IOMMU_MAP_DMA, &map) == 0)) {
         return 0;
     }
@@ -284,8 +306,11 @@ int vfio_dma_map(VFIOContainer *container, hwaddr iova,
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
@@ -304,9 +329,12 @@ void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start)
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
@@ -356,18 +384,24 @@ err_out:
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
@@ -377,7 +411,7 @@ int vfio_container_add_section_window(VFIOContainer *container,
     }
 
     /* For now intersections are not allowed, we may relax this later */
-    QLIST_FOREACH(hostwin, &container->hostwin_list, hostwin_next) {
+    QLIST_FOREACH(hostwin, &bcontainer->hostwin_list, hostwin_next) {
         if (ranges_overlap(hostwin->min_iova,
                            hostwin->max_iova - hostwin->min_iova + 1,
                            section->offset_within_address_space,
@@ -399,7 +433,7 @@ int vfio_container_add_section_window(VFIOContainer *container,
         return ret;
     }
 
-    vfio_host_win_add(container, section->offset_within_address_space,
+    vfio_host_win_add(bcontainer, section->offset_within_address_space,
                       section->offset_within_address_space +
                       int128_get64(section->size) - 1, pgsize);
 #ifdef CONFIG_KVM
@@ -432,16 +466,21 @@ int vfio_container_add_section_window(VFIOContainer *container,
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
@@ -559,7 +598,7 @@ static void vfio_kvm_device_del_group(VFIOGroup *group)
 /*
  * vfio_get_iommu_type - selects the richest iommu_type (v2 first)
  */
-static int vfio_get_iommu_type(VFIOContainer *container,
+static int vfio_get_iommu_type(VFIOLegacyContainer *container,
                                Error **errp)
 {
     int iommu_types[] = { VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
@@ -575,7 +614,7 @@ static int vfio_get_iommu_type(VFIOContainer *container,
     return -EINVAL;
 }
 
-static int vfio_init_container(VFIOContainer *container, int group_fd,
+static int vfio_init_container(VFIOLegacyContainer *container, int group_fd,
                                Error **errp)
 {
     int iommu_type, ret;
@@ -610,7 +649,7 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
     return 0;
 }
 
-static int vfio_get_iommu_info(VFIOContainer *container,
+static int vfio_get_iommu_info(VFIOLegacyContainer *container,
                                struct vfio_iommu_type1_info **info)
 {
 
@@ -654,11 +693,12 @@ vfio_get_iommu_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
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
@@ -673,16 +713,19 @@ static void vfio_get_iommu_info_migration(VFIOContainer *container,
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
 
 static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
                                   Error **errp)
 {
-    VFIOContainer *container;
+    VFIOIOMMUBackendOpsClass *ops = VFIO_IOMMU_BACKEND_OPS_CLASS(
+        object_class_by_name(TYPE_VFIO_IOMMU_BACKEND_LEGACY_OPS));
+    VFIOContainer *bcontainer;
+    VFIOLegacyContainer *container;
     int ret, fd;
     VFIOAddressSpace *space;
 
@@ -719,7 +762,8 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
      * details once we know which type of IOMMU we are using.
      */
 
-    QLIST_FOREACH(container, &space->containers, next) {
+    QLIST_FOREACH(bcontainer, &space->containers, next) {
+        container = container_of(bcontainer, VFIOLegacyContainer, bcontainer);
         if (!ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &container->fd)) {
             ret = vfio_ram_block_discard_disable(container, true);
             if (ret) {
@@ -755,14 +799,9 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
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
+    vfio_container_init(bcontainer, space, ops);
 
     ret = vfio_init_container(container, group->fd, errp);
     if (ret) {
@@ -788,13 +827,13 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
         }
 
         if (info->flags & VFIO_IOMMU_INFO_PGSIZES) {
-            container->pgsizes = info->iova_pgsizes;
+            bcontainer->pgsizes = info->iova_pgsizes;
         } else {
-            container->pgsizes = qemu_real_host_page_size();
+            bcontainer->pgsizes = qemu_real_host_page_size();
         }
 
-        if (!vfio_get_info_dma_avail(info, &container->dma_max_mappings)) {
-            container->dma_max_mappings = 65535;
+        if (!vfio_get_info_dma_avail(info, &bcontainer->dma_max_mappings)) {
+            bcontainer->dma_max_mappings = 65535;
         }
         vfio_get_iommu_info_migration(container, info);
         g_free(info);
@@ -804,7 +843,7 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
          * information to get the actual window extent rather than assume
          * a 64-bit IOVA address space.
          */
-        vfio_host_win_add(container, 0, (hwaddr)-1, container->pgsizes);
+        vfio_host_win_add(bcontainer, 0, (hwaddr)-1, bcontainer->pgsizes);
 
         break;
     }
@@ -831,10 +870,10 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
 
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
@@ -853,7 +892,7 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
         }
 
         if (v2) {
-            container->pgsizes = info.ddw.pgsizes;
+            bcontainer->pgsizes = info.ddw.pgsizes;
             /*
              * There is a default window in just created container.
              * To make region_add/del simpler, we better remove this
@@ -868,8 +907,8 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
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
@@ -880,28 +919,28 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
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
 
@@ -922,7 +961,8 @@ put_space_exit:
 
 static void vfio_disconnect_container(VFIOGroup *group)
 {
-    VFIOContainer *container = group->container;
+    VFIOLegacyContainer *container = group->container;
+    VFIOContainer *bcontainer = &container->bcontainer;
 
     QLIST_REMOVE(group, container_next);
     group->container = NULL;
@@ -942,25 +982,9 @@ static void vfio_disconnect_container(VFIOGroup *group)
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
@@ -972,13 +996,15 @@ static void vfio_disconnect_container(VFIOGroup *group)
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
@@ -1130,7 +1156,7 @@ void vfio_put_base_device(VFIODevice *vbasedev)
 /*
  * Interfaces for IBM EEH (Enhanced Error Handling)
  */
-static bool vfio_eeh_container_ok(VFIOContainer *container)
+static bool vfio_eeh_container_ok(VFIOLegacyContainer *container)
 {
     /*
      * As of 2016-03-04 (linux-4.5) the host kernel EEH/VFIO
@@ -1158,7 +1184,7 @@ static bool vfio_eeh_container_ok(VFIOContainer *container)
     return true;
 }
 
-static int vfio_eeh_container_op(VFIOContainer *container, uint32_t op)
+static int vfio_eeh_container_op(VFIOLegacyContainer *container, uint32_t op)
 {
     struct vfio_eeh_pe_op pe_op = {
         .argsz = sizeof(pe_op),
@@ -1181,19 +1207,21 @@ static int vfio_eeh_container_op(VFIOContainer *container, uint32_t op)
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
          * multiple containers
@@ -1209,17 +1237,45 @@ out:
 
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
+static void vfio_iommu_backend_legacy_ops_class_init(ObjectClass *oc,
+                                                     void *data) {
+    VFIOIOMMUBackendOpsClass *ops = VFIO_IOMMU_BACKEND_OPS_CLASS(oc);
+
+    ops->dma_map = vfio_dma_map;
+    ops->dma_unmap = vfio_dma_unmap;
+    ops->devices_all_dirty_tracking = vfio_devices_all_dirty_tracking;
+    ops->set_dirty_page_tracking = vfio_set_dirty_page_tracking;
+    ops->get_dirty_bitmap = vfio_get_dirty_bitmap;
+    ops->add_window = vfio_legacy_container_add_section_window;
+    ops->del_window = vfio_legacy_container_del_section_window;
+    ops->check_extension = vfio_legacy_container_check_extension;
+}
+
+static const TypeInfo vfio_iommu_backend_legacy_ops_type = {
+    .name = TYPE_VFIO_IOMMU_BACKEND_LEGACY_OPS,
+
+    .parent = TYPE_VFIO_IOMMU_BACKEND_OPS,
+    .class_init = vfio_iommu_backend_legacy_ops_class_init,
+    .abstract = true,
+};
+static void vfio_iommu_backend_legacy_ops_register_types(void)
+{
+    type_register_static(&vfio_iommu_backend_legacy_ops_type);
+}
+type_init(vfio_iommu_backend_legacy_ops_register_types);
+
diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
index c74453e0b5..e66ca81bda 100644
--- a/hw/vfio/migration.c
+++ b/hw/vfio/migration.c
@@ -859,11 +859,12 @@ int64_t vfio_mig_bytes_transferred(void)
 
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
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index 7937dab078..fd0dfd198a 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -2,6 +2,7 @@ vfio_ss = ss.source_set()
 vfio_ss.add(files(
   'helpers.c',
   'as.c',
+  'container-base.c',
   'container.c',
   'spapr.c',
   'migration.c',
-- 
2.37.3

