Return-Path: <kvm+bounces-33697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B37759F0536
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E1BC169A0D
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015DA18FC85;
	Fri, 13 Dec 2024 07:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FpR+xUK4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C735119006B
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734073780; cv=none; b=sqxbAFOG1AP334WTq7CVxptT6PM9YNLz7umtoGnFlXnv9vWa/hZO4ClQt4psqSamhsF+UaUemJhtyzIHJZMDjl9YyUPtSHVbJKZYmkunrtFsmsT51oyPZzp383YKKexnX6iQY5OxRW2yErFOUEfqBR3GfNJv9u35cmQkQeqZlQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734073780; c=relaxed/simple;
	bh=t+LB+Ns9IyXdCBWhMrXMtMR2X8Lk7IJwTq/0yEzRAaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ra8Ka15Bw53cjt9HmGlgWFBc2CGOPAv0IR+IlRZL+xJSL4EkzQKzyVEI+9tMKazAdwSQxGa48I7ITyvIsqaDGilNMQPHluP7gqX3taWW1sZn5AdZEMS+AIiLSAKKtR9AMiBpAXGtG6EOgJviA1h01gEa5MzWecHzdFfZ7znT+po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FpR+xUK4; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734073778; x=1765609778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t+LB+Ns9IyXdCBWhMrXMtMR2X8Lk7IJwTq/0yEzRAaU=;
  b=FpR+xUK4FHYRXQYR47nKrHxN5DUxoU/LmOz3F/ehhdzzWZOaX5Lgh+4Q
   mjf1aelr9fs9wP/+E50EQnquedVhrjpTGHfnP/EPjJMQyztQ6jiLZuq8E
   0iwvF8+qH0E9LoOcrF/0kC9Zn4/SR/yUFy6v68HRVjHtUCar6K2QtsoBK
   iQPQh5cNOsCN/eE+zK1bCu1Mw54K2tc2gT4PfSBm9/NEyJJ9+tWh4eSWV
   zKlXeH/Qj0v8Vh4rld4HZDFzGiwKC9vE/ya8BtsfF8FOOERH2TwRq92SM
   V1BkByGdqVa6HwrZ5RQOmXa5ZQ6qhPE8zGI6Jol5g1cRgoBRqAYbBl6hb
   g==;
X-CSE-ConnectionGUID: AxRolGBxRmK2CVK8PiZ5mg==
X-CSE-MsgGUID: smAFfKDPTRqmvREA37MgMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="51937109"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="51937109"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:38 -0800
X-CSE-ConnectionGUID: oYKPgmgOTZGMb6AP0BKP5w==
X-CSE-MsgGUID: y5rdZvvoRtibrtxIQBkOlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96365590"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:35 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [RFC PATCH 7/7] memory: Add a new argument to indicate the request attribute in RamDismcardManager helpers
Date: Fri, 13 Dec 2024 15:08:49 +0800
Message-ID: <20241213070852.106092-8-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241213070852.106092-1-chenyi.qiang@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For each ram_discard_manager helper, add a new argument 'is_private' to
indicate the request attribute. If is_private is true, the operation
targets the private range in the section. For example,
replay_populate(true) will replay the populate operation on private part
in the MemoryRegionSection, while replay_popuate(false) will replay
population on shared part.

This helps to distinguish between the states of private/shared and
discarded/populated. It is essential for guest_memfd_manager which uses
RamDiscardManager interface but can't treat private memory as discarded
memory. This is because it does not align with the expectation of
current RamDiscardManager users (e.g. live migration), who expect that
discarded memory is hot-removed and can be skipped when processing guest
memory. Treating private memory as discarded won't work in the future if
live migration needs to handle private memory. For example, live
migration needs to migrate private memory.

The user of the helper needs to figure out which attribute to
manipulate. For legacy VM case, use is_private=true by default. Private
attribute is only valid in a guest_memfd based VM.

Opportunistically rename the guest_memfd_for_each_{discarded,
populated}_section() to guest_memfd_for_each_{private, shared)_section()
to distinguish between private/shared and discarded/populated at the
same time.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 hw/vfio/common.c             |  22 ++++++--
 hw/virtio/virtio-mem.c       |  23 ++++----
 include/exec/memory.h        |  23 ++++++--
 migration/ram.c              |  14 ++---
 system/guest-memfd-manager.c | 106 +++++++++++++++++++++++------------
 system/memory.c              |  13 +++--
 system/memory_mapping.c      |   4 +-
 7 files changed, 135 insertions(+), 70 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index dcef44fe55..a6f49e6450 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -345,7 +345,8 @@ out:
 }
 
 static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
-                                            MemoryRegionSection *section)
+                                            MemoryRegionSection *section,
+                                            bool is_private)
 {
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
@@ -354,6 +355,11 @@ static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
     const hwaddr iova = section->offset_within_address_space;
     int ret;
 
+    if (is_private) {
+        /* Not support discard private memory yet. */
+        return;
+    }
+
     /* Unmap with a single call. */
     ret = vfio_container_dma_unmap(bcontainer, iova, size , NULL);
     if (ret) {
@@ -363,7 +369,8 @@ static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
 }
 
 static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
-                                            MemoryRegionSection *section)
+                                            MemoryRegionSection *section,
+                                            bool is_private)
 {
     VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
                                                 listener);
@@ -374,6 +381,11 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
     void *vaddr;
     int ret;
 
+    if (is_private) {
+        /* Not support discard private memory yet. */
+        return 0;
+    }
+
     /*
      * Map in (aligned within memory region) minimum granularity, so we can
      * unmap in minimum granularity later.
@@ -390,7 +402,7 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
                                      vaddr, section->readonly);
         if (ret) {
             /* Rollback */
-            vfio_ram_discard_notify_discard(rdl, section);
+            vfio_ram_discard_notify_discard(rdl, section, false);
             return ret;
         }
     }
@@ -1248,7 +1260,7 @@ out:
 }
 
 static int vfio_ram_discard_get_dirty_bitmap(MemoryRegionSection *section,
-                                             void *opaque)
+                                             bool is_private, void *opaque)
 {
     const hwaddr size = int128_get64(section->size);
     const hwaddr iova = section->offset_within_address_space;
@@ -1293,7 +1305,7 @@ vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainerBase *bcontainer,
      * We only want/can synchronize the bitmap for actually mapped parts -
      * which correspond to populated parts. Replay all populated parts.
      */
-    return ram_discard_manager_replay_populated(rdm, section,
+    return ram_discard_manager_replay_populated(rdm, section, false,
                                               vfio_ram_discard_get_dirty_bitmap,
                                                 &vrdl);
 }
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index e3d1ccaeeb..e7304c7e47 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -312,14 +312,14 @@ static int virtio_mem_notify_populate_cb(MemoryRegionSection *s, void *arg)
 {
     RamDiscardListener *rdl = arg;
 
-    return rdl->notify_populate(rdl, s);
+    return rdl->notify_populate(rdl, s, false);
 }
 
 static int virtio_mem_notify_discard_cb(MemoryRegionSection *s, void *arg)
 {
     RamDiscardListener *rdl = arg;
 
-    rdl->notify_discard(rdl, s);
+    rdl->notify_discard(rdl, s, false);
     return 0;
 }
 
@@ -334,7 +334,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
         if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
-        rdl->notify_discard(rdl, &tmp);
+        rdl->notify_discard(rdl, &tmp, false);
     }
 }
 
@@ -350,7 +350,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
         if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
-        ret = rdl->notify_populate(rdl, &tmp);
+        ret = rdl->notify_populate(rdl, &tmp, false);
         if (ret) {
             break;
         }
@@ -367,7 +367,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
             if (!memory_region_section_intersect_range(&tmp, offset, size)) {
                 continue;
             }
-            rdl2->notify_discard(rdl2, &tmp);
+            rdl2->notify_discard(rdl2, &tmp, false);
         }
     }
     return ret;
@@ -383,7 +383,7 @@ static void virtio_mem_notify_unplug_all(VirtIOMEM *vmem)
 
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
         if (rdl->double_discard_supported) {
-            rdl->notify_discard(rdl, rdl->section);
+            rdl->notify_discard(rdl, rdl->section, false);
         } else {
             virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
                                                 virtio_mem_notify_discard_cb);
@@ -1685,7 +1685,8 @@ static uint64_t virtio_mem_rdm_get_min_granularity(const RamDiscardManager *rdm,
 }
 
 static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
-                                        const MemoryRegionSection *s)
+                                        const MemoryRegionSection *s,
+                                        bool is_private)
 {
     const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
     uint64_t start_gpa = vmem->addr + s->offset_within_region;
@@ -1712,11 +1713,12 @@ static int virtio_mem_rdm_replay_populated_cb(MemoryRegionSection *s, void *arg)
 {
     struct VirtIOMEMReplayData *data = arg;
 
-    return ((ReplayRamPopulate)data->fn)(s, data->opaque);
+    return ((ReplayRamPopulate)data->fn)(s, false, data->opaque);
 }
 
 static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
                                            MemoryRegionSection *s,
+                                           bool is_private,
                                            ReplayRamPopulate replay_fn,
                                            void *opaque)
 {
@@ -1736,12 +1738,13 @@ static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
 {
     struct VirtIOMEMReplayData *data = arg;
 
-    ((ReplayRamDiscard)data->fn)(s, data->opaque);
+    ((ReplayRamDiscard)data->fn)(s, false, data->opaque);
     return 0;
 }
 
 static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
                                             MemoryRegionSection *s,
+                                            bool is_private,
                                             ReplayRamDiscard replay_fn,
                                             void *opaque)
 {
@@ -1783,7 +1786,7 @@ static void virtio_mem_rdm_unregister_listener(RamDiscardManager *rdm,
     g_assert(rdl->section->mr == &vmem->memdev->mr);
     if (vmem->size) {
         if (rdl->double_discard_supported) {
-            rdl->notify_discard(rdl, rdl->section);
+            rdl->notify_discard(rdl, rdl->section, false);
         } else {
             virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
                                                 virtio_mem_notify_discard_cb);
diff --git a/include/exec/memory.h b/include/exec/memory.h
index ec7bc641e8..8aac61af08 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -508,9 +508,11 @@ struct IOMMUMemoryRegionClass {
 
 typedef struct RamDiscardListener RamDiscardListener;
 typedef int (*NotifyRamPopulate)(RamDiscardListener *rdl,
-                                 MemoryRegionSection *section);
+                                 MemoryRegionSection *section,
+                                 bool is_private);
 typedef void (*NotifyRamDiscard)(RamDiscardListener *rdl,
-                                 MemoryRegionSection *section);
+                                 MemoryRegionSection *section,
+                                 bool is_private);
 
 struct RamDiscardListener {
     /*
@@ -566,8 +568,8 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
     rdl->double_discard_supported = double_discard_supported;
 }
 
-typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void *opaque);
-typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
+typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, bool is_private, void *opaque);
+typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, bool is_private, void *opaque);
 
 /*
  * RamDiscardManagerClass:
@@ -632,11 +634,13 @@ struct RamDiscardManagerClass {
      *
      * @rdm: the #RamDiscardManager
      * @section: the #MemoryRegionSection
+     * @is_private: the attribute of the request section
      *
      * Returns whether the given range is completely populated.
      */
     bool (*is_populated)(const RamDiscardManager *rdm,
-                         const MemoryRegionSection *section);
+                         const MemoryRegionSection *section,
+                         bool is_private);
 
     /**
      * @replay_populated:
@@ -648,6 +652,7 @@ struct RamDiscardManagerClass {
      *
      * @rdm: the #RamDiscardManager
      * @section: the #MemoryRegionSection
+     * @is_private: the attribute of the populated parts
      * @replay_fn: the #ReplayRamPopulate callback
      * @opaque: pointer to forward to the callback
      *
@@ -655,6 +660,7 @@ struct RamDiscardManagerClass {
      */
     int (*replay_populated)(const RamDiscardManager *rdm,
                             MemoryRegionSection *section,
+                            bool is_private,
                             ReplayRamPopulate replay_fn, void *opaque);
 
     /**
@@ -665,11 +671,13 @@ struct RamDiscardManagerClass {
      *
      * @rdm: the #RamDiscardManager
      * @section: the #MemoryRegionSection
+     * @is_private: the attribute of the discarded parts
      * @replay_fn: the #ReplayRamDiscard callback
      * @opaque: pointer to forward to the callback
      */
     void (*replay_discarded)(const RamDiscardManager *rdm,
                              MemoryRegionSection *section,
+                             bool is_private,
                              ReplayRamDiscard replay_fn, void *opaque);
 
     /**
@@ -709,15 +717,18 @@ uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
                                                  const MemoryRegion *mr);
 
 bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
-                                      const MemoryRegionSection *section);
+                                      const MemoryRegionSection *section,
+                                      bool is_private);
 
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          MemoryRegionSection *section,
+                                         bool is_private,
                                          ReplayRamPopulate replay_fn,
                                          void *opaque);
 
 void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
                                           MemoryRegionSection *section,
+                                          bool is_private,
                                           ReplayRamDiscard replay_fn,
                                           void *opaque);
 
diff --git a/migration/ram.c b/migration/ram.c
index 05ff9eb328..b9efba1d14 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -838,7 +838,7 @@ static inline bool migration_bitmap_clear_dirty(RAMState *rs,
 }
 
 static void dirty_bitmap_clear_section(MemoryRegionSection *section,
-                                       void *opaque)
+                                       bool is_private, void *opaque)
 {
     const hwaddr offset = section->offset_within_region;
     const hwaddr size = int128_get64(section->size);
@@ -884,7 +884,7 @@ static uint64_t ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
             .size = int128_make64(qemu_ram_get_used_length(rb)),
         };
 
-        ram_discard_manager_replay_discarded(rdm, &section,
+        ram_discard_manager_replay_discarded(rdm, &section, false,
                                              dirty_bitmap_clear_section,
                                              &cleared_bits);
     }
@@ -907,7 +907,7 @@ bool ramblock_page_is_discarded(RAMBlock *rb, ram_addr_t start)
             .size = int128_make64(qemu_ram_pagesize(rb)),
         };
 
-        return !ram_discard_manager_is_populated(rdm, &section);
+        return !ram_discard_manager_is_populated(rdm, &section, false);
     }
     return false;
 }
@@ -1539,7 +1539,7 @@ static inline void populate_read_range(RAMBlock *block, ram_addr_t offset,
 }
 
 static inline int populate_read_section(MemoryRegionSection *section,
-                                        void *opaque)
+                                        bool is_private, void *opaque)
 {
     const hwaddr size = int128_get64(section->size);
     hwaddr offset = section->offset_within_region;
@@ -1579,7 +1579,7 @@ static void ram_block_populate_read(RAMBlock *rb)
             .size = rb->mr->size,
         };
 
-        ram_discard_manager_replay_populated(rdm, &section,
+        ram_discard_manager_replay_populated(rdm, &section, false,
                                              populate_read_section, NULL);
     } else {
         populate_read_range(rb, 0, rb->used_length);
@@ -1614,7 +1614,7 @@ void ram_write_tracking_prepare(void)
 }
 
 static inline int uffd_protect_section(MemoryRegionSection *section,
-                                       void *opaque)
+                                       bool is_private, void *opaque)
 {
     const hwaddr size = int128_get64(section->size);
     const hwaddr offset = section->offset_within_region;
@@ -1638,7 +1638,7 @@ static int ram_block_uffd_protect(RAMBlock *rb, int uffd_fd)
             .size = rb->mr->size,
         };
 
-        return ram_discard_manager_replay_populated(rdm, &section,
+        return ram_discard_manager_replay_populated(rdm, &section, false,
                                                     uffd_protect_section,
                                                     (void *)(uintptr_t)uffd_fd);
     }
diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
index b6a32f0bfb..50802b34d7 100644
--- a/system/guest-memfd-manager.c
+++ b/system/guest-memfd-manager.c
@@ -23,39 +23,51 @@ OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(GuestMemfdManager,
                                           { })
 
 static bool guest_memfd_rdm_is_populated(const RamDiscardManager *rdm,
-                                         const MemoryRegionSection *section)
+                                         const MemoryRegionSection *section,
+                                         bool is_private)
 {
     const GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
     uint64_t first_bit = section->offset_within_region / gmm->block_size;
     uint64_t last_bit = first_bit + int128_get64(section->size) / gmm->block_size - 1;
     unsigned long first_discard_bit;
 
-    first_discard_bit = find_next_zero_bit(gmm->bitmap, last_bit + 1, first_bit);
+    if (is_private) {
+        /* Check if the private section is populated */
+        first_discard_bit = find_next_bit(gmm->bitmap, last_bit + 1, first_bit);
+    } else {
+        /* Check if the shared section is populated */
+        first_discard_bit = find_next_zero_bit(gmm->bitmap, last_bit + 1, first_bit);
+    }
+
     return first_discard_bit > last_bit;
 }
 
-typedef int (*guest_memfd_section_cb)(MemoryRegionSection *s, void *arg);
+typedef int (*guest_memfd_section_cb)(MemoryRegionSection *s, bool is_private,
+                                      void *arg);
 
-static int guest_memfd_notify_populate_cb(MemoryRegionSection *section, void *arg)
+static int guest_memfd_notify_populate_cb(MemoryRegionSection *section, bool is_private,
+                                          void *arg)
 {
     RamDiscardListener *rdl = arg;
 
-    return rdl->notify_populate(rdl, section);
+    return rdl->notify_populate(rdl, section, is_private);
 }
 
-static int guest_memfd_notify_discard_cb(MemoryRegionSection *section, void *arg)
+static int guest_memfd_notify_discard_cb(MemoryRegionSection *section, bool is_private,
+                                         void *arg)
 {
     RamDiscardListener *rdl = arg;
 
-    rdl->notify_discard(rdl, section);
+    rdl->notify_discard(rdl, section, is_private);
 
     return 0;
 }
 
-static int guest_memfd_for_each_populated_section(const GuestMemfdManager *gmm,
-                                                  MemoryRegionSection *section,
-                                                  void *arg,
-                                                  guest_memfd_section_cb cb)
+static int guest_memfd_for_each_shared_section(const GuestMemfdManager *gmm,
+                                               MemoryRegionSection *section,
+                                               bool is_private,
+                                               void *arg,
+                                               guest_memfd_section_cb cb)
 {
     unsigned long first_one_bit, last_one_bit;
     uint64_t offset, size;
@@ -76,7 +88,7 @@ static int guest_memfd_for_each_populated_section(const GuestMemfdManager *gmm,
             break;
         }
 
-        ret = cb(&tmp, arg);
+        ret = cb(&tmp, is_private, arg);
         if (ret) {
             break;
         }
@@ -88,10 +100,11 @@ static int guest_memfd_for_each_populated_section(const GuestMemfdManager *gmm,
     return ret;
 }
 
-static int guest_memfd_for_each_discarded_section(const GuestMemfdManager *gmm,
-                                                  MemoryRegionSection *section,
-                                                  void *arg,
-                                                  guest_memfd_section_cb cb)
+static int guest_memfd_for_each_private_section(const GuestMemfdManager *gmm,
+                                                MemoryRegionSection *section,
+                                                bool is_private,
+                                                void *arg,
+                                                guest_memfd_section_cb cb)
 {
     unsigned long first_zero_bit, last_zero_bit;
     uint64_t offset, size;
@@ -113,7 +126,7 @@ static int guest_memfd_for_each_discarded_section(const GuestMemfdManager *gmm,
             break;
         }
 
-        ret = cb(&tmp, arg);
+        ret = cb(&tmp, is_private, arg);
         if (ret) {
             break;
         }
@@ -146,8 +159,9 @@ static void guest_memfd_rdm_register_listener(RamDiscardManager *rdm,
 
     QLIST_INSERT_HEAD(&gmm->rdl_list, rdl, next);
 
-    ret = guest_memfd_for_each_populated_section(gmm, section, rdl,
-                                                 guest_memfd_notify_populate_cb);
+    /* Populate shared part */
+    ret = guest_memfd_for_each_shared_section(gmm, section, false, rdl,
+                                              guest_memfd_notify_populate_cb);
     if (ret) {
         error_report("%s: Failed to register RAM discard listener: %s", __func__,
                      strerror(-ret));
@@ -163,8 +177,9 @@ static void guest_memfd_rdm_unregister_listener(RamDiscardManager *rdm,
     g_assert(rdl->section);
     g_assert(rdl->section->mr == gmm->mr);
 
-    ret = guest_memfd_for_each_populated_section(gmm, rdl->section, rdl,
-                                                 guest_memfd_notify_discard_cb);
+    /* Discard shared part */
+    ret = guest_memfd_for_each_shared_section(gmm, rdl->section, false, rdl,
+                                              guest_memfd_notify_discard_cb);
     if (ret) {
         error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
                      strerror(-ret));
@@ -181,16 +196,18 @@ typedef struct GuestMemfdReplayData {
     void *opaque;
 } GuestMemfdReplayData;
 
-static int guest_memfd_rdm_replay_populated_cb(MemoryRegionSection *section, void *arg)
+static int guest_memfd_rdm_replay_populated_cb(MemoryRegionSection *section,
+                                               bool is_private, void *arg)
 {
     struct GuestMemfdReplayData *data = arg;
     ReplayRamPopulate replay_fn = data->fn;
 
-    return replay_fn(section, data->opaque);
+    return replay_fn(section, is_private, data->opaque);
 }
 
 static int guest_memfd_rdm_replay_populated(const RamDiscardManager *rdm,
                                             MemoryRegionSection *section,
+                                            bool is_private,
                                             ReplayRamPopulate replay_fn,
                                             void *opaque)
 {
@@ -198,22 +215,31 @@ static int guest_memfd_rdm_replay_populated(const RamDiscardManager *rdm,
     struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque = opaque };
 
     g_assert(section->mr == gmm->mr);
-    return guest_memfd_for_each_populated_section(gmm, section, &data,
-                                                  guest_memfd_rdm_replay_populated_cb);
+    if (is_private) {
+        /* Replay populate on private section */
+        return guest_memfd_for_each_private_section(gmm, section, is_private, &data,
+                                                    guest_memfd_rdm_replay_populated_cb);
+    } else {
+        /* Replay populate on shared section */
+        return guest_memfd_for_each_shared_section(gmm, section, is_private, &data,
+                                                   guest_memfd_rdm_replay_populated_cb);
+    }
 }
 
-static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection *section, void *arg)
+static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection *section,
+                                               bool is_private, void *arg)
 {
     struct GuestMemfdReplayData *data = arg;
     ReplayRamDiscard replay_fn = data->fn;
 
-    replay_fn(section, data->opaque);
+    replay_fn(section, is_private, data->opaque);
 
     return 0;
 }
 
 static void guest_memfd_rdm_replay_discarded(const RamDiscardManager *rdm,
                                              MemoryRegionSection *section,
+                                             bool is_private,
                                              ReplayRamDiscard replay_fn,
                                              void *opaque)
 {
@@ -221,8 +247,16 @@ static void guest_memfd_rdm_replay_discarded(const RamDiscardManager *rdm,
     struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque = opaque };
 
     g_assert(section->mr == gmm->mr);
-    guest_memfd_for_each_discarded_section(gmm, section, &data,
-                                           guest_memfd_rdm_replay_discarded_cb);
+
+    if (is_private) {
+        /* Replay discard on private section */
+        guest_memfd_for_each_private_section(gmm, section, is_private, &data,
+                                             guest_memfd_rdm_replay_discarded_cb);
+    } else {
+        /* Replay discard on shared section */
+        guest_memfd_for_each_shared_section(gmm, section, is_private, &data,
+                                            guest_memfd_rdm_replay_discarded_cb);
+    }
 }
 
 static bool guest_memfd_is_valid_range(GuestMemfdManager *gmm,
@@ -257,8 +291,9 @@ static void guest_memfd_notify_discard(GuestMemfdManager *gmm,
             continue;
         }
 
-        guest_memfd_for_each_populated_section(gmm, &tmp, rdl,
-                                               guest_memfd_notify_discard_cb);
+        /* For current shared section, notify to discard shared parts */
+        guest_memfd_for_each_shared_section(gmm, &tmp, false, rdl,
+                                            guest_memfd_notify_discard_cb);
     }
 }
 
@@ -276,8 +311,9 @@ static int guest_memfd_notify_populate(GuestMemfdManager *gmm,
             continue;
         }
 
-        ret = guest_memfd_for_each_discarded_section(gmm, &tmp, rdl,
-                                                     guest_memfd_notify_populate_cb);
+        /* For current private section, notify to populate the shared parts */
+        ret = guest_memfd_for_each_private_section(gmm, &tmp, false, rdl,
+                                                   guest_memfd_notify_populate_cb);
         if (ret) {
             break;
         }
@@ -295,8 +331,8 @@ static int guest_memfd_notify_populate(GuestMemfdManager *gmm,
                 continue;
             }
 
-            guest_memfd_for_each_discarded_section(gmm, &tmp, rdl2,
-                                                   guest_memfd_notify_discard_cb);
+            guest_memfd_for_each_private_section(gmm, &tmp, false, rdl2,
+                                                 guest_memfd_notify_discard_cb);
         }
     }
     return ret;
diff --git a/system/memory.c b/system/memory.c
index ddcec90f5e..d3d5a04f98 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2133,34 +2133,37 @@ uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
 }
 
 bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
-                                      const MemoryRegionSection *section)
+                                      const MemoryRegionSection *section,
+                                      bool is_private)
 {
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
 
     g_assert(rdmc->is_populated);
-    return rdmc->is_populated(rdm, section);
+    return rdmc->is_populated(rdm, section, is_private);
 }
 
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          MemoryRegionSection *section,
+                                         bool is_private,
                                          ReplayRamPopulate replay_fn,
                                          void *opaque)
 {
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
 
     g_assert(rdmc->replay_populated);
-    return rdmc->replay_populated(rdm, section, replay_fn, opaque);
+    return rdmc->replay_populated(rdm, section, is_private, replay_fn, opaque);
 }
 
 void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
                                           MemoryRegionSection *section,
+                                          bool is_private,
                                           ReplayRamDiscard replay_fn,
                                           void *opaque)
 {
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
 
     g_assert(rdmc->replay_discarded);
-    rdmc->replay_discarded(rdm, section, replay_fn, opaque);
+    rdmc->replay_discarded(rdm, section, is_private, replay_fn, opaque);
 }
 
 void ram_discard_manager_register_listener(RamDiscardManager *rdm,
@@ -2221,7 +2224,7 @@ bool memory_get_xlat_addr(IOMMUTLBEntry *iotlb, void **vaddr,
          * Disallow that. vmstate priorities make sure any RamDiscardManager
          * were already restored before IOMMUs are restored.
          */
-        if (!ram_discard_manager_is_populated(rdm, &tmp)) {
+        if (!ram_discard_manager_is_populated(rdm, &tmp, false)) {
             error_setg(errp, "iommu map to discarded memory (e.g., unplugged"
                          " via virtio-mem): %" HWADDR_PRIx "",
                          iotlb->translated_addr);
diff --git a/system/memory_mapping.c b/system/memory_mapping.c
index ca2390eb80..c55c0c0c93 100644
--- a/system/memory_mapping.c
+++ b/system/memory_mapping.c
@@ -249,7 +249,7 @@ static void guest_phys_block_add_section(GuestPhysListener *g,
 }
 
 static int guest_phys_ram_populate_cb(MemoryRegionSection *section,
-                                      void *opaque)
+                                      bool is_private, void *opaque)
 {
     GuestPhysListener *g = opaque;
 
@@ -274,7 +274,7 @@ static void guest_phys_blocks_region_add(MemoryListener *listener,
         RamDiscardManager *rdm;
 
         rdm = memory_region_get_ram_discard_manager(section->mr);
-        ram_discard_manager_replay_populated(rdm, section,
+        ram_discard_manager_replay_populated(rdm, section, false,
                                              guest_phys_ram_populate_cb, g);
         return;
     }
-- 
2.43.5


