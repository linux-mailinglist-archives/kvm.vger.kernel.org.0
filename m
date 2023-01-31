Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB116837F7
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjAaUyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjAaUyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:54:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE65C12580
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qCpc7iIHODBh77PMzBKAAQ4aymiwZqRT32o5cZlkvRU=;
        b=J1chO8MPzmqu1rlYdSalfUKwJEYyK/wk22CGEbeNrPtDvEn5+WiMgp5gOrEW1UbHDVi7+C
        sG6KCc7s4KjCx1Qsxpgx+0edRSnMSttM0vmlqK6qnVHdBFo0XDUci/iy/3enbnP9FHtqa+
        araAm71R/6L68oGUjY4pnHgII0EZeW4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-Y59ZUiicPjaoatnyq3YNpA-1; Tue, 31 Jan 2023 15:53:37 -0500
X-MC-Unique: Y59ZUiicPjaoatnyq3YNpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C584A18E0A62;
        Tue, 31 Jan 2023 20:53:35 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B5DA40C2064;
        Tue, 31 Jan 2023 20:53:28 +0000 (UTC)
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
Subject: [RFC v3 03/18] vfio/common: Move IOMMU agnostic helpers to a separate file
Date:   Tue, 31 Jan 2023 21:52:50 +0100
Message-Id: <20230131205305.2726330-4-eric.auger@redhat.com>
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

Move low-level IOMMU iommu agnostic helpers to a separate helpers.c
file. They relate to regions, interrupts and device/region
capabilities.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 include/hw/vfio/vfio-common.h |   2 +
 hw/vfio/common.c              | 569 --------------------------------
 hw/vfio/helpers.c             | 598 ++++++++++++++++++++++++++++++++++
 hw/vfio/meson.build           |   1 +
 4 files changed, 601 insertions(+), 569 deletions(-)
 create mode 100644 hw/vfio/helpers.c

diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index e573f5a9f1..2cf6a9e928 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -232,6 +232,8 @@ bool vfio_get_info_dma_avail(struct vfio_iommu_type1_info *info,
                              unsigned int *avail);
 struct vfio_info_cap_header *
 vfio_get_device_info_cap(struct vfio_device_info *info, uint16_t id);
+struct vfio_info_cap_header *
+vfio_get_cap(void *ptr, uint32_t cap_offset, uint16_t id);
 #endif
 extern const MemoryListener vfio_prereg_listener;
 
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 130e5d1dc7..f9ae28d5b9 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -58,84 +58,6 @@ static QLIST_HEAD(, VFIOAddressSpace) vfio_address_spaces =
 static int vfio_kvm_device_fd = -1;
 #endif
 
-/*
- * Common VFIO interrupt disable
- */
-void vfio_disable_irqindex(VFIODevice *vbasedev, int index)
-{
-    struct vfio_irq_set irq_set = {
-        .argsz = sizeof(irq_set),
-        .flags = VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
-        .index = index,
-        .start = 0,
-        .count = 0,
-    };
-
-    ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
-}
-
-void vfio_unmask_single_irqindex(VFIODevice *vbasedev, int index)
-{
-    struct vfio_irq_set irq_set = {
-        .argsz = sizeof(irq_set),
-        .flags = VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_UNMASK,
-        .index = index,
-        .start = 0,
-        .count = 1,
-    };
-
-    ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
-}
-
-void vfio_mask_single_irqindex(VFIODevice *vbasedev, int index)
-{
-    struct vfio_irq_set irq_set = {
-        .argsz = sizeof(irq_set),
-        .flags = VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_MASK,
-        .index = index,
-        .start = 0,
-        .count = 1,
-    };
-
-    ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
-}
-
-static inline const char *action_to_str(int action)
-{
-    switch (action) {
-    case VFIO_IRQ_SET_ACTION_MASK:
-        return "MASK";
-    case VFIO_IRQ_SET_ACTION_UNMASK:
-        return "UNMASK";
-    case VFIO_IRQ_SET_ACTION_TRIGGER:
-        return "TRIGGER";
-    default:
-        return "UNKNOWN ACTION";
-    }
-}
-
-static const char *index_to_str(VFIODevice *vbasedev, int index)
-{
-    if (vbasedev->type != VFIO_DEVICE_TYPE_PCI) {
-        return NULL;
-    }
-
-    switch (index) {
-    case VFIO_PCI_INTX_IRQ_INDEX:
-        return "INTX";
-    case VFIO_PCI_MSI_IRQ_INDEX:
-        return "MSI";
-    case VFIO_PCI_MSIX_IRQ_INDEX:
-        return "MSIX";
-    case VFIO_PCI_ERR_IRQ_INDEX:
-        return "ERR";
-    case VFIO_PCI_REQ_IRQ_INDEX:
-        return "REQ";
-    default:
-        return NULL;
-    }
-}
-
 static int vfio_ram_block_discard_disable(VFIOContainer *container, bool state)
 {
     switch (container->iommu_type) {
@@ -159,160 +81,6 @@ static int vfio_ram_block_discard_disable(VFIOContainer *container, bool state)
     }
 }
 
-int vfio_set_irq_signaling(VFIODevice *vbasedev, int index, int subindex,
-                           int action, int fd, Error **errp)
-{
-    struct vfio_irq_set *irq_set;
-    int argsz, ret = 0;
-    const char *name;
-    int32_t *pfd;
-
-    argsz = sizeof(*irq_set) + sizeof(*pfd);
-
-    irq_set = g_malloc0(argsz);
-    irq_set->argsz = argsz;
-    irq_set->flags = VFIO_IRQ_SET_DATA_EVENTFD | action;
-    irq_set->index = index;
-    irq_set->start = subindex;
-    irq_set->count = 1;
-    pfd = (int32_t *)&irq_set->data;
-    *pfd = fd;
-
-    if (ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, irq_set)) {
-        ret = -errno;
-    }
-    g_free(irq_set);
-
-    if (!ret) {
-        return 0;
-    }
-
-    error_setg_errno(errp, -ret, "VFIO_DEVICE_SET_IRQS failure");
-
-    name = index_to_str(vbasedev, index);
-    if (name) {
-        error_prepend(errp, "%s-%d: ", name, subindex);
-    } else {
-        error_prepend(errp, "index %d-%d: ", index, subindex);
-    }
-    error_prepend(errp,
-                  "Failed to %s %s eventfd signaling for interrupt ",
-                  fd < 0 ? "tear down" : "set up", action_to_str(action));
-    return ret;
-}
-
-/*
- * IO Port/MMIO - Beware of the endians, VFIO is always little endian
- */
-void vfio_region_write(void *opaque, hwaddr addr,
-                       uint64_t data, unsigned size)
-{
-    VFIORegion *region = opaque;
-    VFIODevice *vbasedev = region->vbasedev;
-    union {
-        uint8_t byte;
-        uint16_t word;
-        uint32_t dword;
-        uint64_t qword;
-    } buf;
-
-    switch (size) {
-    case 1:
-        buf.byte = data;
-        break;
-    case 2:
-        buf.word = cpu_to_le16(data);
-        break;
-    case 4:
-        buf.dword = cpu_to_le32(data);
-        break;
-    case 8:
-        buf.qword = cpu_to_le64(data);
-        break;
-    default:
-        hw_error("vfio: unsupported write size, %u bytes", size);
-        break;
-    }
-
-    if (pwrite(vbasedev->fd, &buf, size, region->fd_offset + addr) != size) {
-        error_report("%s(%s:region%d+0x%"HWADDR_PRIx", 0x%"PRIx64
-                     ",%d) failed: %m",
-                     __func__, vbasedev->name, region->nr,
-                     addr, data, size);
-    }
-
-    trace_vfio_region_write(vbasedev->name, region->nr, addr, data, size);
-
-    /*
-     * A read or write to a BAR always signals an INTx EOI.  This will
-     * do nothing if not pending (including not in INTx mode).  We assume
-     * that a BAR access is in response to an interrupt and that BAR
-     * accesses will service the interrupt.  Unfortunately, we don't know
-     * which access will service the interrupt, so we're potentially
-     * getting quite a few host interrupts per guest interrupt.
-     */
-    vbasedev->ops->vfio_eoi(vbasedev);
-}
-
-uint64_t vfio_region_read(void *opaque,
-                          hwaddr addr, unsigned size)
-{
-    VFIORegion *region = opaque;
-    VFIODevice *vbasedev = region->vbasedev;
-    union {
-        uint8_t byte;
-        uint16_t word;
-        uint32_t dword;
-        uint64_t qword;
-    } buf;
-    uint64_t data = 0;
-
-    if (pread(vbasedev->fd, &buf, size, region->fd_offset + addr) != size) {
-        error_report("%s(%s:region%d+0x%"HWADDR_PRIx", %d) failed: %m",
-                     __func__, vbasedev->name, region->nr,
-                     addr, size);
-        return (uint64_t)-1;
-    }
-    switch (size) {
-    case 1:
-        data = buf.byte;
-        break;
-    case 2:
-        data = le16_to_cpu(buf.word);
-        break;
-    case 4:
-        data = le32_to_cpu(buf.dword);
-        break;
-    case 8:
-        data = le64_to_cpu(buf.qword);
-        break;
-    default:
-        hw_error("vfio: unsupported read size, %u bytes", size);
-        break;
-    }
-
-    trace_vfio_region_read(vbasedev->name, region->nr, addr, size, data);
-
-    /* Same as write above */
-    vbasedev->ops->vfio_eoi(vbasedev);
-
-    return data;
-}
-
-const MemoryRegionOps vfio_region_ops = {
-    .read = vfio_region_read,
-    .write = vfio_region_write,
-    .endianness = DEVICE_LITTLE_ENDIAN,
-    .valid = {
-        .min_access_size = 1,
-        .max_access_size = 8,
-    },
-    .impl = {
-        .min_access_size = 1,
-        .max_access_size = 8,
-    },
-};
-
 /*
  * Device state interfaces
  */
@@ -1436,30 +1204,6 @@ static void vfio_listener_release(VFIOContainer *container)
     }
 }
 
-static struct vfio_info_cap_header *
-vfio_get_cap(void *ptr, uint32_t cap_offset, uint16_t id)
-{
-    struct vfio_info_cap_header *hdr;
-
-    for (hdr = ptr + cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
-        if (hdr->id == id) {
-            return hdr;
-        }
-    }
-
-    return NULL;
-}
-
-struct vfio_info_cap_header *
-vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
-{
-    if (!(info->flags & VFIO_REGION_INFO_FLAG_CAPS)) {
-        return NULL;
-    }
-
-    return vfio_get_cap((void *)info, info->cap_offset, id);
-}
-
 static struct vfio_info_cap_header *
 vfio_get_iommu_type1_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
 {
@@ -1470,16 +1214,6 @@ vfio_get_iommu_type1_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
     return vfio_get_cap((void *)info, info->cap_offset, id);
 }
 
-struct vfio_info_cap_header *
-vfio_get_device_info_cap(struct vfio_device_info *info, uint16_t id)
-{
-    if (!(info->flags & VFIO_DEVICE_FLAGS_CAPS)) {
-        return NULL;
-    }
-
-    return vfio_get_cap((void *)info, info->cap_offset, id);
-}
-
 bool vfio_get_info_dma_avail(struct vfio_iommu_type1_info *info,
                              unsigned int *avail)
 {
@@ -1501,232 +1235,6 @@ bool vfio_get_info_dma_avail(struct vfio_iommu_type1_info *info,
     return true;
 }
 
-static int vfio_setup_region_sparse_mmaps(VFIORegion *region,
-                                          struct vfio_region_info *info)
-{
-    struct vfio_info_cap_header *hdr;
-    struct vfio_region_info_cap_sparse_mmap *sparse;
-    int i, j;
-
-    hdr = vfio_get_region_info_cap(info, VFIO_REGION_INFO_CAP_SPARSE_MMAP);
-    if (!hdr) {
-        return -ENODEV;
-    }
-
-    sparse = container_of(hdr, struct vfio_region_info_cap_sparse_mmap, header);
-
-    trace_vfio_region_sparse_mmap_header(region->vbasedev->name,
-                                         region->nr, sparse->nr_areas);
-
-    region->mmaps = g_new0(VFIOMmap, sparse->nr_areas);
-
-    for (i = 0, j = 0; i < sparse->nr_areas; i++) {
-        if (sparse->areas[i].size) {
-            trace_vfio_region_sparse_mmap_entry(i, sparse->areas[i].offset,
-                                            sparse->areas[i].offset +
-                                            sparse->areas[i].size - 1);
-            region->mmaps[j].offset = sparse->areas[i].offset;
-            region->mmaps[j].size = sparse->areas[i].size;
-            j++;
-        }
-    }
-
-    region->nr_mmaps = j;
-    region->mmaps = g_realloc(region->mmaps, j * sizeof(VFIOMmap));
-
-    return 0;
-}
-
-int vfio_region_setup(Object *obj, VFIODevice *vbasedev, VFIORegion *region,
-                      int index, const char *name)
-{
-    struct vfio_region_info *info;
-    int ret;
-
-    ret = vfio_get_region_info(vbasedev, index, &info);
-    if (ret) {
-        return ret;
-    }
-
-    region->vbasedev = vbasedev;
-    region->flags = info->flags;
-    region->size = info->size;
-    region->fd_offset = info->offset;
-    region->nr = index;
-
-    if (region->size) {
-        region->mem = g_new0(MemoryRegion, 1);
-        memory_region_init_io(region->mem, obj, &vfio_region_ops,
-                              region, name, region->size);
-
-        if (!vbasedev->no_mmap &&
-            region->flags & VFIO_REGION_INFO_FLAG_MMAP) {
-
-            ret = vfio_setup_region_sparse_mmaps(region, info);
-
-            if (ret) {
-                region->nr_mmaps = 1;
-                region->mmaps = g_new0(VFIOMmap, region->nr_mmaps);
-                region->mmaps[0].offset = 0;
-                region->mmaps[0].size = region->size;
-            }
-        }
-    }
-
-    g_free(info);
-
-    trace_vfio_region_setup(vbasedev->name, index, name,
-                            region->flags, region->fd_offset, region->size);
-    return 0;
-}
-
-static void vfio_subregion_unmap(VFIORegion *region, int index)
-{
-    trace_vfio_region_unmap(memory_region_name(&region->mmaps[index].mem),
-                            region->mmaps[index].offset,
-                            region->mmaps[index].offset +
-                            region->mmaps[index].size - 1);
-    memory_region_del_subregion(region->mem, &region->mmaps[index].mem);
-    munmap(region->mmaps[index].mmap, region->mmaps[index].size);
-    object_unparent(OBJECT(&region->mmaps[index].mem));
-    region->mmaps[index].mmap = NULL;
-}
-
-int vfio_region_mmap(VFIORegion *region)
-{
-    int i, prot = 0;
-    char *name;
-
-    if (!region->mem) {
-        return 0;
-    }
-
-    prot |= region->flags & VFIO_REGION_INFO_FLAG_READ ? PROT_READ : 0;
-    prot |= region->flags & VFIO_REGION_INFO_FLAG_WRITE ? PROT_WRITE : 0;
-
-    for (i = 0; i < region->nr_mmaps; i++) {
-        region->mmaps[i].mmap = mmap(NULL, region->mmaps[i].size, prot,
-                                     MAP_SHARED, region->vbasedev->fd,
-                                     region->fd_offset +
-                                     region->mmaps[i].offset);
-        if (region->mmaps[i].mmap == MAP_FAILED) {
-            int ret = -errno;
-
-            trace_vfio_region_mmap_fault(memory_region_name(region->mem), i,
-                                         region->fd_offset +
-                                         region->mmaps[i].offset,
-                                         region->fd_offset +
-                                         region->mmaps[i].offset +
-                                         region->mmaps[i].size - 1, ret);
-
-            region->mmaps[i].mmap = NULL;
-
-            for (i--; i >= 0; i--) {
-                vfio_subregion_unmap(region, i);
-            }
-
-            return ret;
-        }
-
-        name = g_strdup_printf("%s mmaps[%d]",
-                               memory_region_name(region->mem), i);
-        memory_region_init_ram_device_ptr(&region->mmaps[i].mem,
-                                          memory_region_owner(region->mem),
-                                          name, region->mmaps[i].size,
-                                          region->mmaps[i].mmap);
-        g_free(name);
-        memory_region_add_subregion(region->mem, region->mmaps[i].offset,
-                                    &region->mmaps[i].mem);
-
-        trace_vfio_region_mmap(memory_region_name(&region->mmaps[i].mem),
-                               region->mmaps[i].offset,
-                               region->mmaps[i].offset +
-                               region->mmaps[i].size - 1);
-    }
-
-    return 0;
-}
-
-void vfio_region_unmap(VFIORegion *region)
-{
-    int i;
-
-    if (!region->mem) {
-        return;
-    }
-
-    for (i = 0; i < region->nr_mmaps; i++) {
-        if (region->mmaps[i].mmap) {
-            vfio_subregion_unmap(region, i);
-        }
-    }
-}
-
-void vfio_region_exit(VFIORegion *region)
-{
-    int i;
-
-    if (!region->mem) {
-        return;
-    }
-
-    for (i = 0; i < region->nr_mmaps; i++) {
-        if (region->mmaps[i].mmap) {
-            memory_region_del_subregion(region->mem, &region->mmaps[i].mem);
-        }
-    }
-
-    trace_vfio_region_exit(region->vbasedev->name, region->nr);
-}
-
-void vfio_region_finalize(VFIORegion *region)
-{
-    int i;
-
-    if (!region->mem) {
-        return;
-    }
-
-    for (i = 0; i < region->nr_mmaps; i++) {
-        if (region->mmaps[i].mmap) {
-            munmap(region->mmaps[i].mmap, region->mmaps[i].size);
-            object_unparent(OBJECT(&region->mmaps[i].mem));
-        }
-    }
-
-    object_unparent(OBJECT(region->mem));
-
-    g_free(region->mem);
-    g_free(region->mmaps);
-
-    trace_vfio_region_finalize(region->vbasedev->name, region->nr);
-
-    region->mem = NULL;
-    region->mmaps = NULL;
-    region->nr_mmaps = 0;
-    region->size = 0;
-    region->flags = 0;
-    region->nr = 0;
-}
-
-void vfio_region_mmaps_set_enabled(VFIORegion *region, bool enabled)
-{
-    int i;
-
-    if (!region->mem) {
-        return;
-    }
-
-    for (i = 0; i < region->nr_mmaps; i++) {
-        if (region->mmaps[i].mmap) {
-            memory_region_set_enabled(&region->mmaps[i].mem, enabled);
-        }
-    }
-
-    trace_vfio_region_mmaps_set_enabled(memory_region_name(region->mem),
-                                        enabled);
-}
-
 void vfio_reset_handler(void *opaque)
 {
     VFIOGroup *group;
@@ -2401,83 +1909,6 @@ void vfio_put_base_device(VFIODevice *vbasedev)
     close(vbasedev->fd);
 }
 
-int vfio_get_region_info(VFIODevice *vbasedev, int index,
-                         struct vfio_region_info **info)
-{
-    size_t argsz = sizeof(struct vfio_region_info);
-
-    *info = g_malloc0(argsz);
-
-    (*info)->index = index;
-retry:
-    (*info)->argsz = argsz;
-
-    if (ioctl(vbasedev->fd, VFIO_DEVICE_GET_REGION_INFO, *info)) {
-        g_free(*info);
-        *info = NULL;
-        return -errno;
-    }
-
-    if ((*info)->argsz > argsz) {
-        argsz = (*info)->argsz;
-        *info = g_realloc(*info, argsz);
-
-        goto retry;
-    }
-
-    return 0;
-}
-
-int vfio_get_dev_region_info(VFIODevice *vbasedev, uint32_t type,
-                             uint32_t subtype, struct vfio_region_info **info)
-{
-    int i;
-
-    for (i = 0; i < vbasedev->num_regions; i++) {
-        struct vfio_info_cap_header *hdr;
-        struct vfio_region_info_cap_type *cap_type;
-
-        if (vfio_get_region_info(vbasedev, i, info)) {
-            continue;
-        }
-
-        hdr = vfio_get_region_info_cap(*info, VFIO_REGION_INFO_CAP_TYPE);
-        if (!hdr) {
-            g_free(*info);
-            continue;
-        }
-
-        cap_type = container_of(hdr, struct vfio_region_info_cap_type, header);
-
-        trace_vfio_get_dev_region(vbasedev->name, i,
-                                  cap_type->type, cap_type->subtype);
-
-        if (cap_type->type == type && cap_type->subtype == subtype) {
-            return 0;
-        }
-
-        g_free(*info);
-    }
-
-    *info = NULL;
-    return -ENODEV;
-}
-
-bool vfio_has_region_cap(VFIODevice *vbasedev, int region, uint16_t cap_type)
-{
-    struct vfio_region_info *info = NULL;
-    bool ret = false;
-
-    if (!vfio_get_region_info(vbasedev, region, &info)) {
-        if (vfio_get_region_info_cap(info, cap_type)) {
-            ret = true;
-        }
-        g_free(info);
-    }
-
-    return ret;
-}
-
 /*
  * Interfaces for IBM EEH (Enhanced Error Handling)
  */
diff --git a/hw/vfio/helpers.c b/hw/vfio/helpers.c
new file mode 100644
index 0000000000..4338456b08
--- /dev/null
+++ b/hw/vfio/helpers.c
@@ -0,0 +1,598 @@
+/*
+ * low level and IOMMU backend agnostic helpers used by VFIO devices,
+ * related to regions, interrupts, capabilities
+ *
+ * Copyright Red Hat, Inc. 2012
+ *
+ * Authors:
+ *  Alex Williamson <alex.williamson@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * Based on qemu-kvm device-assignment:
+ *  Adapted for KVM by Qumranet.
+ *  Copyright (c) 2007, Neocleus, Alex Novik (alex@neocleus.com)
+ *  Copyright (c) 2007, Neocleus, Guy Zana (guy@neocleus.com)
+ *  Copyright (C) 2008, Qumranet, Amit Shah (amit.shah@qumranet.com)
+ *  Copyright (C) 2008, Red Hat, Amit Shah (amit.shah@redhat.com)
+ *  Copyright (C) 2008, IBM, Muli Ben-Yehuda (muli@il.ibm.com)
+ */
+
+#include "qemu/osdep.h"
+#include <sys/ioctl.h>
+
+#include "hw/vfio/vfio-common.h"
+#include "hw/vfio/vfio.h"
+#include "hw/hw.h"
+#include "trace.h"
+#include "qapi/error.h"
+
+/*
+ * Common VFIO interrupt disable
+ */
+void vfio_disable_irqindex(VFIODevice *vbasedev, int index)
+{
+    struct vfio_irq_set irq_set = {
+        .argsz = sizeof(irq_set),
+        .flags = VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
+        .index = index,
+        .start = 0,
+        .count = 0,
+    };
+
+    ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
+}
+
+void vfio_unmask_single_irqindex(VFIODevice *vbasedev, int index)
+{
+    struct vfio_irq_set irq_set = {
+        .argsz = sizeof(irq_set),
+        .flags = VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_UNMASK,
+        .index = index,
+        .start = 0,
+        .count = 1,
+    };
+
+    ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
+}
+
+void vfio_mask_single_irqindex(VFIODevice *vbasedev, int index)
+{
+    struct vfio_irq_set irq_set = {
+        .argsz = sizeof(irq_set),
+        .flags = VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_MASK,
+        .index = index,
+        .start = 0,
+        .count = 1,
+    };
+
+    ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, &irq_set);
+}
+
+static inline const char *action_to_str(int action)
+{
+    switch (action) {
+    case VFIO_IRQ_SET_ACTION_MASK:
+        return "MASK";
+    case VFIO_IRQ_SET_ACTION_UNMASK:
+        return "UNMASK";
+    case VFIO_IRQ_SET_ACTION_TRIGGER:
+        return "TRIGGER";
+    default:
+        return "UNKNOWN ACTION";
+    }
+}
+
+static const char *index_to_str(VFIODevice *vbasedev, int index)
+{
+    if (vbasedev->type != VFIO_DEVICE_TYPE_PCI) {
+        return NULL;
+    }
+
+    switch (index) {
+    case VFIO_PCI_INTX_IRQ_INDEX:
+        return "INTX";
+    case VFIO_PCI_MSI_IRQ_INDEX:
+        return "MSI";
+    case VFIO_PCI_MSIX_IRQ_INDEX:
+        return "MSIX";
+    case VFIO_PCI_ERR_IRQ_INDEX:
+        return "ERR";
+    case VFIO_PCI_REQ_IRQ_INDEX:
+        return "REQ";
+    default:
+        return NULL;
+    }
+}
+
+int vfio_set_irq_signaling(VFIODevice *vbasedev, int index, int subindex,
+                           int action, int fd, Error **errp)
+{
+    struct vfio_irq_set *irq_set;
+    int argsz, ret = 0;
+    const char *name;
+    int32_t *pfd;
+
+    argsz = sizeof(*irq_set) + sizeof(*pfd);
+
+    irq_set = g_malloc0(argsz);
+    irq_set->argsz = argsz;
+    irq_set->flags = VFIO_IRQ_SET_DATA_EVENTFD | action;
+    irq_set->index = index;
+    irq_set->start = subindex;
+    irq_set->count = 1;
+    pfd = (int32_t *)&irq_set->data;
+    *pfd = fd;
+
+    if (ioctl(vbasedev->fd, VFIO_DEVICE_SET_IRQS, irq_set)) {
+        ret = -errno;
+    }
+    g_free(irq_set);
+
+    if (!ret) {
+        return 0;
+    }
+
+    error_setg_errno(errp, -ret, "VFIO_DEVICE_SET_IRQS failure");
+
+    name = index_to_str(vbasedev, index);
+    if (name) {
+        error_prepend(errp, "%s-%d: ", name, subindex);
+    } else {
+        error_prepend(errp, "index %d-%d: ", index, subindex);
+    }
+    error_prepend(errp,
+                  "Failed to %s %s eventfd signaling for interrupt ",
+                  fd < 0 ? "tear down" : "set up", action_to_str(action));
+    return ret;
+}
+
+/*
+ * IO Port/MMIO - Beware of the endians, VFIO is always little endian
+ */
+void vfio_region_write(void *opaque, hwaddr addr,
+                       uint64_t data, unsigned size)
+{
+    VFIORegion *region = opaque;
+    VFIODevice *vbasedev = region->vbasedev;
+    union {
+        uint8_t byte;
+        uint16_t word;
+        uint32_t dword;
+        uint64_t qword;
+    } buf;
+
+    switch (size) {
+    case 1:
+        buf.byte = data;
+        break;
+    case 2:
+        buf.word = cpu_to_le16(data);
+        break;
+    case 4:
+        buf.dword = cpu_to_le32(data);
+        break;
+    case 8:
+        buf.qword = cpu_to_le64(data);
+        break;
+    default:
+        hw_error("vfio: unsupported write size, %u bytes", size);
+        break;
+    }
+
+    if (pwrite(vbasedev->fd, &buf, size, region->fd_offset + addr) != size) {
+        error_report("%s(%s:region%d+0x%"HWADDR_PRIx", 0x%"PRIx64
+                     ",%d) failed: %m",
+                     __func__, vbasedev->name, region->nr,
+                     addr, data, size);
+    }
+
+    trace_vfio_region_write(vbasedev->name, region->nr, addr, data, size);
+
+    /*
+     * A read or write to a BAR always signals an INTx EOI.  This will
+     * do nothing if not pending (including not in INTx mode).  We assume
+     * that a BAR access is in response to an interrupt and that BAR
+     * accesses will service the interrupt.  Unfortunately, we don't know
+     * which access will service the interrupt, so we're potentially
+     * getting quite a few host interrupts per guest interrupt.
+     */
+    vbasedev->ops->vfio_eoi(vbasedev);
+}
+
+uint64_t vfio_region_read(void *opaque,
+                          hwaddr addr, unsigned size)
+{
+    VFIORegion *region = opaque;
+    VFIODevice *vbasedev = region->vbasedev;
+    union {
+        uint8_t byte;
+        uint16_t word;
+        uint32_t dword;
+        uint64_t qword;
+    } buf;
+    uint64_t data = 0;
+
+    if (pread(vbasedev->fd, &buf, size, region->fd_offset + addr) != size) {
+        error_report("%s(%s:region%d+0x%"HWADDR_PRIx", %d) failed: %m",
+                     __func__, vbasedev->name, region->nr,
+                     addr, size);
+        return (uint64_t)-1;
+    }
+    switch (size) {
+    case 1:
+        data = buf.byte;
+        break;
+    case 2:
+        data = le16_to_cpu(buf.word);
+        break;
+    case 4:
+        data = le32_to_cpu(buf.dword);
+        break;
+    case 8:
+        data = le64_to_cpu(buf.qword);
+        break;
+    default:
+        hw_error("vfio: unsupported read size, %u bytes", size);
+        break;
+    }
+
+    trace_vfio_region_read(vbasedev->name, region->nr, addr, size, data);
+
+    /* Same as write above */
+    vbasedev->ops->vfio_eoi(vbasedev);
+
+    return data;
+}
+
+const MemoryRegionOps vfio_region_ops = {
+    .read = vfio_region_read,
+    .write = vfio_region_write,
+    .endianness = DEVICE_LITTLE_ENDIAN,
+    .valid = {
+        .min_access_size = 1,
+        .max_access_size = 8,
+    },
+    .impl = {
+        .min_access_size = 1,
+        .max_access_size = 8,
+    },
+};
+
+struct vfio_info_cap_header *
+vfio_get_cap(void *ptr, uint32_t cap_offset, uint16_t id)
+{
+    struct vfio_info_cap_header *hdr;
+
+    for (hdr = ptr + cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
+        if (hdr->id == id) {
+            return hdr;
+        }
+    }
+
+    return NULL;
+}
+
+struct vfio_info_cap_header *
+vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
+{
+    if (!(info->flags & VFIO_REGION_INFO_FLAG_CAPS)) {
+        return NULL;
+    }
+
+    return vfio_get_cap((void *)info, info->cap_offset, id);
+}
+
+struct vfio_info_cap_header *
+vfio_get_device_info_cap(struct vfio_device_info *info, uint16_t id)
+{
+    if (!(info->flags & VFIO_DEVICE_FLAGS_CAPS)) {
+        return NULL;
+    }
+
+    return vfio_get_cap((void *)info, info->cap_offset, id);
+}
+
+static int vfio_setup_region_sparse_mmaps(VFIORegion *region,
+                                          struct vfio_region_info *info)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_region_info_cap_sparse_mmap *sparse;
+    int i, j;
+
+    hdr = vfio_get_region_info_cap(info, VFIO_REGION_INFO_CAP_SPARSE_MMAP);
+    if (!hdr) {
+        return -ENODEV;
+    }
+
+    sparse = container_of(hdr, struct vfio_region_info_cap_sparse_mmap, header);
+
+    trace_vfio_region_sparse_mmap_header(region->vbasedev->name,
+                                         region->nr, sparse->nr_areas);
+
+    region->mmaps = g_new0(VFIOMmap, sparse->nr_areas);
+
+    for (i = 0, j = 0; i < sparse->nr_areas; i++) {
+        if (sparse->areas[i].size) {
+            trace_vfio_region_sparse_mmap_entry(i, sparse->areas[i].offset,
+                                            sparse->areas[i].offset +
+                                            sparse->areas[i].size - 1);
+            region->mmaps[j].offset = sparse->areas[i].offset;
+            region->mmaps[j].size = sparse->areas[i].size;
+            j++;
+        }
+    }
+
+    region->nr_mmaps = j;
+    region->mmaps = g_realloc(region->mmaps, j * sizeof(VFIOMmap));
+
+    return 0;
+}
+
+int vfio_region_setup(Object *obj, VFIODevice *vbasedev, VFIORegion *region,
+                      int index, const char *name)
+{
+    struct vfio_region_info *info;
+    int ret;
+
+    ret = vfio_get_region_info(vbasedev, index, &info);
+    if (ret) {
+        return ret;
+    }
+
+    region->vbasedev = vbasedev;
+    region->flags = info->flags;
+    region->size = info->size;
+    region->fd_offset = info->offset;
+    region->nr = index;
+
+    if (region->size) {
+        region->mem = g_new0(MemoryRegion, 1);
+        memory_region_init_io(region->mem, obj, &vfio_region_ops,
+                              region, name, region->size);
+
+        if (!vbasedev->no_mmap &&
+            region->flags & VFIO_REGION_INFO_FLAG_MMAP) {
+
+            ret = vfio_setup_region_sparse_mmaps(region, info);
+
+            if (ret) {
+                region->nr_mmaps = 1;
+                region->mmaps = g_new0(VFIOMmap, region->nr_mmaps);
+                region->mmaps[0].offset = 0;
+                region->mmaps[0].size = region->size;
+            }
+        }
+    }
+
+    g_free(info);
+
+    trace_vfio_region_setup(vbasedev->name, index, name,
+                            region->flags, region->fd_offset, region->size);
+    return 0;
+}
+
+static void vfio_subregion_unmap(VFIORegion *region, int index)
+{
+    trace_vfio_region_unmap(memory_region_name(&region->mmaps[index].mem),
+                            region->mmaps[index].offset,
+                            region->mmaps[index].offset +
+                            region->mmaps[index].size - 1);
+    memory_region_del_subregion(region->mem, &region->mmaps[index].mem);
+    munmap(region->mmaps[index].mmap, region->mmaps[index].size);
+    object_unparent(OBJECT(&region->mmaps[index].mem));
+    region->mmaps[index].mmap = NULL;
+}
+
+int vfio_region_mmap(VFIORegion *region)
+{
+    int i, prot = 0;
+    char *name;
+
+    if (!region->mem) {
+        return 0;
+    }
+
+    prot |= region->flags & VFIO_REGION_INFO_FLAG_READ ? PROT_READ : 0;
+    prot |= region->flags & VFIO_REGION_INFO_FLAG_WRITE ? PROT_WRITE : 0;
+
+    for (i = 0; i < region->nr_mmaps; i++) {
+        region->mmaps[i].mmap = mmap(NULL, region->mmaps[i].size, prot,
+                                     MAP_SHARED, region->vbasedev->fd,
+                                     region->fd_offset +
+                                     region->mmaps[i].offset);
+        if (region->mmaps[i].mmap == MAP_FAILED) {
+            int ret = -errno;
+
+            trace_vfio_region_mmap_fault(memory_region_name(region->mem), i,
+                                         region->fd_offset +
+                                         region->mmaps[i].offset,
+                                         region->fd_offset +
+                                         region->mmaps[i].offset +
+                                         region->mmaps[i].size - 1, ret);
+
+            region->mmaps[i].mmap = NULL;
+
+            for (i--; i >= 0; i--) {
+                vfio_subregion_unmap(region, i);
+            }
+
+            return ret;
+        }
+
+        name = g_strdup_printf("%s mmaps[%d]",
+                               memory_region_name(region->mem), i);
+        memory_region_init_ram_device_ptr(&region->mmaps[i].mem,
+                                          memory_region_owner(region->mem),
+                                          name, region->mmaps[i].size,
+                                          region->mmaps[i].mmap);
+        g_free(name);
+        memory_region_add_subregion(region->mem, region->mmaps[i].offset,
+                                    &region->mmaps[i].mem);
+
+        trace_vfio_region_mmap(memory_region_name(&region->mmaps[i].mem),
+                               region->mmaps[i].offset,
+                               region->mmaps[i].offset +
+                               region->mmaps[i].size - 1);
+    }
+
+    return 0;
+}
+
+void vfio_region_unmap(VFIORegion *region)
+{
+    int i;
+
+    if (!region->mem) {
+        return;
+    }
+
+    for (i = 0; i < region->nr_mmaps; i++) {
+        if (region->mmaps[i].mmap) {
+            vfio_subregion_unmap(region, i);
+        }
+    }
+}
+
+void vfio_region_exit(VFIORegion *region)
+{
+    int i;
+
+    if (!region->mem) {
+        return;
+    }
+
+    for (i = 0; i < region->nr_mmaps; i++) {
+        if (region->mmaps[i].mmap) {
+            memory_region_del_subregion(region->mem, &region->mmaps[i].mem);
+        }
+    }
+
+    trace_vfio_region_exit(region->vbasedev->name, region->nr);
+}
+
+void vfio_region_finalize(VFIORegion *region)
+{
+    int i;
+
+    if (!region->mem) {
+        return;
+    }
+
+    for (i = 0; i < region->nr_mmaps; i++) {
+        if (region->mmaps[i].mmap) {
+            munmap(region->mmaps[i].mmap, region->mmaps[i].size);
+            object_unparent(OBJECT(&region->mmaps[i].mem));
+        }
+    }
+
+    object_unparent(OBJECT(region->mem));
+
+    g_free(region->mem);
+    g_free(region->mmaps);
+
+    trace_vfio_region_finalize(region->vbasedev->name, region->nr);
+
+    region->mem = NULL;
+    region->mmaps = NULL;
+    region->nr_mmaps = 0;
+    region->size = 0;
+    region->flags = 0;
+    region->nr = 0;
+}
+
+void vfio_region_mmaps_set_enabled(VFIORegion *region, bool enabled)
+{
+    int i;
+
+    if (!region->mem) {
+        return;
+    }
+
+    for (i = 0; i < region->nr_mmaps; i++) {
+        if (region->mmaps[i].mmap) {
+            memory_region_set_enabled(&region->mmaps[i].mem, enabled);
+        }
+    }
+
+    trace_vfio_region_mmaps_set_enabled(memory_region_name(region->mem),
+                                        enabled);
+}
+
+int vfio_get_region_info(VFIODevice *vbasedev, int index,
+                         struct vfio_region_info **info)
+{
+    size_t argsz = sizeof(struct vfio_region_info);
+
+    *info = g_malloc0(argsz);
+
+    (*info)->index = index;
+retry:
+    (*info)->argsz = argsz;
+
+    if (ioctl(vbasedev->fd, VFIO_DEVICE_GET_REGION_INFO, *info)) {
+        g_free(*info);
+        *info = NULL;
+        return -errno;
+    }
+
+    if ((*info)->argsz > argsz) {
+        argsz = (*info)->argsz;
+        *info = g_realloc(*info, argsz);
+
+        goto retry;
+    }
+
+    return 0;
+}
+
+int vfio_get_dev_region_info(VFIODevice *vbasedev, uint32_t type,
+                             uint32_t subtype, struct vfio_region_info **info)
+{
+    int i;
+
+    for (i = 0; i < vbasedev->num_regions; i++) {
+        struct vfio_info_cap_header *hdr;
+        struct vfio_region_info_cap_type *cap_type;
+
+        if (vfio_get_region_info(vbasedev, i, info)) {
+            continue;
+        }
+
+        hdr = vfio_get_region_info_cap(*info, VFIO_REGION_INFO_CAP_TYPE);
+        if (!hdr) {
+            g_free(*info);
+            continue;
+        }
+
+        cap_type = container_of(hdr, struct vfio_region_info_cap_type, header);
+
+        trace_vfio_get_dev_region(vbasedev->name, i,
+                                  cap_type->type, cap_type->subtype);
+
+        if (cap_type->type == type && cap_type->subtype == subtype) {
+            return 0;
+        }
+
+        g_free(*info);
+    }
+
+    *info = NULL;
+    return -ENODEV;
+}
+
+bool vfio_has_region_cap(VFIODevice *vbasedev, int region, uint16_t cap_type)
+{
+    struct vfio_region_info *info = NULL;
+    bool ret = false;
+
+    if (!vfio_get_region_info(vbasedev, region, &info)) {
+        if (vfio_get_region_info_cap(info, cap_type)) {
+            ret = true;
+        }
+        g_free(info);
+    }
+
+    return ret;
+}
diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
index da9af297a0..3746c9f984 100644
--- a/hw/vfio/meson.build
+++ b/hw/vfio/meson.build
@@ -1,5 +1,6 @@
 vfio_ss = ss.source_set()
 vfio_ss.add(files(
+  'helpers.c',
   'common.c',
   'spapr.c',
   'migration.c',
-- 
2.37.3

