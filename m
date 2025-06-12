Return-Path: <kvm+bounces-49244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A32AD6ABA
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F6FB18894AE
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 08:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8870722A4DB;
	Thu, 12 Jun 2025 08:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ATTF9SIa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41E82222B7
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 08:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716891; cv=none; b=leMiJUZIocVGn2M0ewBUxxkK0AeG9CV7Wz6oNU58nUFNKxb2tT8ZvaK1RsuZmy9x1gCs1c4WXDkS4zOZLxDJ7Wv/+9zVxXoRDLKJ0dI4LuaobVgec0DzeMmqkY6uicAk/VHcomlSY2I4Zb9DbH3UP5kwI4LodnJH9GG4R0msq5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716891; c=relaxed/simple;
	bh=IoDfVvR6sOQKPtD7NymR46Bpd3lDqmDVR2c529+KaPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ee5dBnULbuWAoW53GnA5rvUED/3H/J43SvlVczNl2Tq9syOBsWPPBEYZs4Bi233mAU8X8Cf8lVbQexSPxaK7GvbxtrREj2TkffOXWyYsw25vgxamCIkkf1nn3lCBmzyYEjdtCTGP4x+ZfyF4hDX50wtXXepBpUppU/zgglA+ubs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ATTF9SIa; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716890; x=1781252890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IoDfVvR6sOQKPtD7NymR46Bpd3lDqmDVR2c529+KaPQ=;
  b=ATTF9SIapiPqj0fmnPat9OFbuo2jk11YPEkF3yNWjOSJNzLmK/cJCOQc
   ZdHZcrjwa1nNXU1Cwb2psHoFiYq6tdDkLxh8xuu/KVMvgOq60F+7xaWEC
   NSPPzb1coyYQxCtBUdRicYvDOqfzqRle5t+6/GjHrn07oxkr3PwXQ2K3+
   R4OeNyfL3/sZ/ybnGvS3P7LDKCpHzwahnXE4Am6JWYxyLTDFFXovPhI6l
   UXoTV3jbdLquCl4K1MqFx+Y2BFJ0TjMLs4qzleKLdcE9QrpSx46unoLjG
   LmLYj/Kdox0JDDjwkBlilC0Pt+JGqHPjfs/kz1UW4ClBbdR20wIYRLdNU
   g==;
X-CSE-ConnectionGUID: zw5wHMc6QK6I4HYYIz3DiA==
X-CSE-MsgGUID: rZNttfOxSdyPDk0QgbHTUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="69453442"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="69453442"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:28:10 -0700
X-CSE-ConnectionGUID: DiI5kDGUQzyaj1BObYm3GA==
X-CSE-MsgGUID: 2lPuQWzSQNiOrb/Uvrf9AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="152442037"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:28:05 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v7 3/5] memory: Unify the definiton of ReplayRamPopulate() and ReplayRamDiscard()
Date: Thu, 12 Jun 2025 16:27:44 +0800
Message-ID: <20250612082747.51539-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250612082747.51539-1-chenyi.qiang@intel.com>
References: <20250612082747.51539-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update ReplayRamDiscard() function to return the result and unify the
ReplayRamPopulate() and ReplayRamDiscard() to ReplayRamDiscardState() at
the same time due to their identical definitions. This unification
simplifies related structures, such as VirtIOMEMReplayData, which makes
it cleaner.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v7:
    - Add Reviewed-by from Xiaoyao and Pankaj.

Changes in v6:
    - Add Reviewed-by from David
    - Add a documentation comment for the prototype change

Changes in v5:
    - Rename ReplayRamStateChange to ReplayRamDiscardState (David)
    - return data->fn(s, data->opaque) instead of 0 in
      virtio_mem_rdm_replay_discarded_cb(). (Alexey)

Changes in v4:
    - Modify the commit message. We won't use Replay() operation when
      doing the attribute change like v3.
---
 hw/virtio/virtio-mem.c  | 21 +++++++-------
 include/system/memory.h | 64 ++++++++++++++++++++++++++++++-----------
 migration/ram.c         |  5 ++--
 system/memory.c         | 12 ++++----
 4 files changed, 66 insertions(+), 36 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 2e491e8c44..c46f6f9c3e 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -1732,7 +1732,7 @@ static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
 }
 
 struct VirtIOMEMReplayData {
-    void *fn;
+    ReplayRamDiscardState fn;
     void *opaque;
 };
 
@@ -1740,12 +1740,12 @@ static int virtio_mem_rdm_replay_populated_cb(MemoryRegionSection *s, void *arg)
 {
     struct VirtIOMEMReplayData *data = arg;
 
-    return ((ReplayRamPopulate)data->fn)(s, data->opaque);
+    return data->fn(s, data->opaque);
 }
 
 static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
                                            MemoryRegionSection *s,
-                                           ReplayRamPopulate replay_fn,
+                                           ReplayRamDiscardState replay_fn,
                                            void *opaque)
 {
     const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
@@ -1764,14 +1764,13 @@ static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
 {
     struct VirtIOMEMReplayData *data = arg;
 
-    ((ReplayRamDiscard)data->fn)(s, data->opaque);
-    return 0;
+    return data->fn(s, data->opaque);
 }
 
-static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
-                                            MemoryRegionSection *s,
-                                            ReplayRamDiscard replay_fn,
-                                            void *opaque)
+static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
+                                           MemoryRegionSection *s,
+                                           ReplayRamDiscardState replay_fn,
+                                           void *opaque)
 {
     const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
     struct VirtIOMEMReplayData data = {
@@ -1780,8 +1779,8 @@ static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
     };
 
     g_assert(s->mr == &vmem->memdev->mr);
-    virtio_mem_for_each_unplugged_section(vmem, s, &data,
-                                          virtio_mem_rdm_replay_discarded_cb);
+    return virtio_mem_for_each_unplugged_section(vmem, s, &data,
+                                                 virtio_mem_rdm_replay_discarded_cb);
 }
 
 static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
diff --git a/include/system/memory.h b/include/system/memory.h
index 60983d4977..eb2618e1b4 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -576,8 +576,20 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
     rdl->double_discard_supported = double_discard_supported;
 }
 
-typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void *opaque);
-typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
+/**
+ * ReplayRamDiscardState:
+ *
+ * The callback handler for #RamDiscardManagerClass.replay_populated/
+ * #RamDiscardManagerClass.replay_discarded to invoke on populated/discarded
+ * parts.
+ *
+ * @section: the #MemoryRegionSection of populated/discarded part
+ * @opaque: pointer to forward to the callback
+ *
+ * Returns 0 on success, or a negative error if failed.
+ */
+typedef int (*ReplayRamDiscardState)(MemoryRegionSection *section,
+                                     void *opaque);
 
 /*
  * RamDiscardManagerClass:
@@ -651,36 +663,38 @@ struct RamDiscardManagerClass {
     /**
      * @replay_populated:
      *
-     * Call the #ReplayRamPopulate callback for all populated parts within the
-     * #MemoryRegionSection via the #RamDiscardManager.
+     * Call the #ReplayRamDiscardState callback for all populated parts within
+     * the #MemoryRegionSection via the #RamDiscardManager.
      *
      * In case any call fails, no further calls are made.
      *
      * @rdm: the #RamDiscardManager
      * @section: the #MemoryRegionSection
-     * @replay_fn: the #ReplayRamPopulate callback
+     * @replay_fn: the #ReplayRamDiscardState callback
      * @opaque: pointer to forward to the callback
      *
      * Returns 0 on success, or a negative error if any notification failed.
      */
     int (*replay_populated)(const RamDiscardManager *rdm,
                             MemoryRegionSection *section,
-                            ReplayRamPopulate replay_fn, void *opaque);
+                            ReplayRamDiscardState replay_fn, void *opaque);
 
     /**
      * @replay_discarded:
      *
-     * Call the #ReplayRamDiscard callback for all discarded parts within the
-     * #MemoryRegionSection via the #RamDiscardManager.
+     * Call the #ReplayRamDiscardState callback for all discarded parts within
+     * the #MemoryRegionSection via the #RamDiscardManager.
      *
      * @rdm: the #RamDiscardManager
      * @section: the #MemoryRegionSection
-     * @replay_fn: the #ReplayRamDiscard callback
+     * @replay_fn: the #ReplayRamDiscardState callback
      * @opaque: pointer to forward to the callback
+     *
+     * Returns 0 on success, or a negative error if any notification failed.
      */
-    void (*replay_discarded)(const RamDiscardManager *rdm,
-                             MemoryRegionSection *section,
-                             ReplayRamDiscard replay_fn, void *opaque);
+    int (*replay_discarded)(const RamDiscardManager *rdm,
+                            MemoryRegionSection *section,
+                            ReplayRamDiscardState replay_fn, void *opaque);
 
     /**
      * @register_listener:
@@ -721,15 +735,31 @@ uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
 bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
                                       const MemoryRegionSection *section);
 
+/**
+ * ram_discard_manager_replay_populated:
+ *
+ * A wrapper to call the #RamDiscardManagerClass.replay_populated callback
+ * of the #RamDiscardManager.
+ *
+ * Returns 0 on success, or a negative error if any notification failed.
+ */
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          MemoryRegionSection *section,
-                                         ReplayRamPopulate replay_fn,
+                                         ReplayRamDiscardState replay_fn,
                                          void *opaque);
 
-void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                          MemoryRegionSection *section,
-                                          ReplayRamDiscard replay_fn,
-                                          void *opaque);
+/**
+ * ram_discard_manager_replay_discarded:
+ *
+ * A wrapper to call the #RamDiscardManagerClass.replay_discarded callback
+ * of the #RamDiscardManager.
+ *
+ * Returns 0 on success, or a negative error if any notification failed.
+ */
+int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
+                                         MemoryRegionSection *section,
+                                         ReplayRamDiscardState replay_fn,
+                                         void *opaque);
 
 void ram_discard_manager_register_listener(RamDiscardManager *rdm,
                                            RamDiscardListener *rdl,
diff --git a/migration/ram.c b/migration/ram.c
index d26dbd37c4..2d4af497b5 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -848,8 +848,8 @@ static inline bool migration_bitmap_clear_dirty(RAMState *rs,
     return ret;
 }
 
-static void dirty_bitmap_clear_section(MemoryRegionSection *section,
-                                       void *opaque)
+static int dirty_bitmap_clear_section(MemoryRegionSection *section,
+                                      void *opaque)
 {
     const hwaddr offset = section->offset_within_region;
     const hwaddr size = int128_get64(section->size);
@@ -868,6 +868,7 @@ static void dirty_bitmap_clear_section(MemoryRegionSection *section,
     }
     *cleared_bits += bitmap_count_one_with_offset(rb->bmap, start, npages);
     bitmap_clear(rb->bmap, start, npages);
+    return 0;
 }
 
 /*
diff --git a/system/memory.c b/system/memory.c
index d0c186e9f6..76b44b8220 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2138,7 +2138,7 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
 
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          MemoryRegionSection *section,
-                                         ReplayRamPopulate replay_fn,
+                                         ReplayRamDiscardState replay_fn,
                                          void *opaque)
 {
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
@@ -2147,15 +2147,15 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
     return rdmc->replay_populated(rdm, section, replay_fn, opaque);
 }
 
-void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                          MemoryRegionSection *section,
-                                          ReplayRamDiscard replay_fn,
-                                          void *opaque)
+int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
+                                         MemoryRegionSection *section,
+                                         ReplayRamDiscardState replay_fn,
+                                         void *opaque)
 {
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
 
     g_assert(rdmc->replay_discarded);
-    rdmc->replay_discarded(rdm, section, replay_fn, opaque);
+    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
 }
 
 void ram_discard_manager_register_listener(RamDiscardManager *rdm,
-- 
2.43.5


