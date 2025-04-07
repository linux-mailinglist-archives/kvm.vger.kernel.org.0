Return-Path: <kvm+bounces-42802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB29A7D6E6
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 311C23B4B5B
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EABD922652D;
	Mon,  7 Apr 2025 07:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SftZPm2h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3202122616C
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744012201; cv=none; b=HKb9pSEq3+KoqU/I5vRqZwTGkJDD0gMLHgdYqJ7+z1Bd3HruueYB/M6zQgGKtq+1uBZR/hwzv7IYMQ1JpztKAcVbmzucpSwO3LbGgvqKHxPdJXs3n9wgVLFlwg8Z/zu1pIn/S6K2Ce8NCHWOMx91RKPMzIOMrH0LIby1bG8m32I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744012201; c=relaxed/simple;
	bh=kk3uHBuJkJcjtKmTs4aWLcjX3wmb5FE548hrfQQbsSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkPRdK6+8XPlcvzTj2hEJVknw4dtTQotZAzdh2g3pSIM4h4GNtQqABRS0JpX/NCikDEGBIAm3wOSbF7LQK8na79D5B5rqo3wrNmiDoaQ7qgNHtb1QjsW2j9TPrKnVOc6B0vBKaNXP3pI+nBIEY2iZSS+Asavgw4L9fzDmucQqM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SftZPm2h; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744012200; x=1775548200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kk3uHBuJkJcjtKmTs4aWLcjX3wmb5FE548hrfQQbsSk=;
  b=SftZPm2hBFjbi2Wa8jy4zuz4+ZNnWMN+NiWcZKQNNwm7Ncyo5KFvDAAJ
   e3s3CZpU5rZdhtTkpLmp9xnAilI8PYm9bK64/eGbBZvE0H7dgwwn0I0bH
   5iDioSnU290Vk1F2nXxGie29egz3L/0gTZXe83M7U9JSfEjShwxdplGHR
   QWZeqPd1X0f/Aj4FmQKLXlPJOUsUKZNE3jsLZw5KF05z8eYnUKgaD9+gX
   g++E3DHbhlQGg8cuc+uN0P5h6PD89v5SzTgcSNQgNNkuQoz7LkZ5ndXbq
   b/PqavS7SNoMMwGEAJW2cQ8mJvKgzMik15wliBn77MnKLcVLlEXkXviPi
   Q==;
X-CSE-ConnectionGUID: je97al0mRhiQkC7d2XYuYQ==
X-CSE-MsgGUID: s9dV5kEhTLai8JjPvm5H9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="67857522"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="67857522"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:49:59 -0700
X-CSE-ConnectionGUID: r2LJDjivQ7CzKUj3/5+NxQ==
X-CSE-MsgGUID: t/e3SxxMSzeUz6Fac+NPzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128405484"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 00:49:56 -0700
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
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v4 03/13] memory: Unify the definiton of ReplayRamPopulate() and ReplayRamDiscard()
Date: Mon,  7 Apr 2025 15:49:23 +0800
Message-ID: <20250407074939.18657-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250407074939.18657-1-chenyi.qiang@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update ReplayRamDiscard() function to return the result and unify the
ReplayRamPopulate() and ReplayRamDiscard() to ReplayStateChange() at
the same time due to their identical definitions. This unification
simplifies related structures, such as VirtIOMEMReplayData, which makes
it more cleaner and maintainable.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v4:
    - Modify the commit message. We won't use Replay() operation when
      doing the attribute change like v3.

Changes in v3:
    - Newly added.
---
 hw/virtio/virtio-mem.c | 20 ++++++++++----------
 include/exec/memory.h  | 31 ++++++++++++++++---------------
 migration/ram.c        |  5 +++--
 system/memory.c        | 12 ++++++------
 4 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index d0d3a0240f..1a88d649cb 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -1733,7 +1733,7 @@ static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
 }
 
 struct VirtIOMEMReplayData {
-    void *fn;
+    ReplayStateChange fn;
     void *opaque;
 };
 
@@ -1741,12 +1741,12 @@ static int virtio_mem_rdm_replay_populated_cb(MemoryRegionSection *s, void *arg)
 {
     struct VirtIOMEMReplayData *data = arg;
 
-    return ((ReplayRamPopulate)data->fn)(s, data->opaque);
+    return data->fn(s, data->opaque);
 }
 
 static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
                                            MemoryRegionSection *s,
-                                           ReplayRamPopulate replay_fn,
+                                           ReplayStateChange replay_fn,
                                            void *opaque)
 {
     const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
@@ -1765,14 +1765,14 @@ static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
 {
     struct VirtIOMEMReplayData *data = arg;
 
-    ((ReplayRamDiscard)data->fn)(s, data->opaque);
+    data->fn(s, data->opaque);
     return 0;
 }
 
-static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
-                                            MemoryRegionSection *s,
-                                            ReplayRamDiscard replay_fn,
-                                            void *opaque)
+static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
+                                           MemoryRegionSection *s,
+                                           ReplayStateChange replay_fn,
+                                           void *opaque)
 {
     const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
     struct VirtIOMEMReplayData data = {
@@ -1781,8 +1781,8 @@ static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
     };
 
     g_assert(s->mr == &vmem->memdev->mr);
-    virtio_mem_for_each_unplugged_section(vmem, s, &data,
-                                          virtio_mem_rdm_replay_discarded_cb);
+    return virtio_mem_for_each_unplugged_section(vmem, s, &data,
+                                                 virtio_mem_rdm_replay_discarded_cb);
 }
 
 static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 390477b588..3b1d25a403 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -566,8 +566,7 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
     rdl->double_discard_supported = double_discard_supported;
 }
 
-typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void *opaque);
-typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
+typedef int (*ReplayStateChange)(MemoryRegionSection *section, void *opaque);
 
 /*
  * RamDiscardManagerClass:
@@ -641,36 +640,38 @@ struct RamDiscardManagerClass {
     /**
      * @replay_populated:
      *
-     * Call the #ReplayRamPopulate callback for all populated parts within the
+     * Call the #ReplayStateChange callback for all populated parts within the
      * #MemoryRegionSection via the #RamDiscardManager.
      *
      * In case any call fails, no further calls are made.
      *
      * @rdm: the #RamDiscardManager
      * @section: the #MemoryRegionSection
-     * @replay_fn: the #ReplayRamPopulate callback
+     * @replay_fn: the #ReplayStateChange callback
      * @opaque: pointer to forward to the callback
      *
      * Returns 0 on success, or a negative error if any notification failed.
      */
     int (*replay_populated)(const RamDiscardManager *rdm,
                             MemoryRegionSection *section,
-                            ReplayRamPopulate replay_fn, void *opaque);
+                            ReplayStateChange replay_fn, void *opaque);
 
     /**
      * @replay_discarded:
      *
-     * Call the #ReplayRamDiscard callback for all discarded parts within the
+     * Call the #ReplayStateChange callback for all discarded parts within the
      * #MemoryRegionSection via the #RamDiscardManager.
      *
      * @rdm: the #RamDiscardManager
      * @section: the #MemoryRegionSection
-     * @replay_fn: the #ReplayRamDiscard callback
+     * @replay_fn: the #ReplayStateChange callback
      * @opaque: pointer to forward to the callback
+     *
+     * Returns 0 on success, or a negative error if any notification failed.
      */
-    void (*replay_discarded)(const RamDiscardManager *rdm,
-                             MemoryRegionSection *section,
-                             ReplayRamDiscard replay_fn, void *opaque);
+    int (*replay_discarded)(const RamDiscardManager *rdm,
+                            MemoryRegionSection *section,
+                            ReplayStateChange replay_fn, void *opaque);
 
     /**
      * @register_listener:
@@ -713,13 +714,13 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
 
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          MemoryRegionSection *section,
-                                         ReplayRamPopulate replay_fn,
+                                         ReplayStateChange replay_fn,
                                          void *opaque);
 
-void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                          MemoryRegionSection *section,
-                                          ReplayRamDiscard replay_fn,
-                                          void *opaque);
+int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
+                                         MemoryRegionSection *section,
+                                         ReplayStateChange replay_fn,
+                                         void *opaque);
 
 void ram_discard_manager_register_listener(RamDiscardManager *rdm,
                                            RamDiscardListener *rdl,
diff --git a/migration/ram.c b/migration/ram.c
index ce28328141..053730367b 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -816,8 +816,8 @@ static inline bool migration_bitmap_clear_dirty(RAMState *rs,
     return ret;
 }
 
-static void dirty_bitmap_clear_section(MemoryRegionSection *section,
-                                       void *opaque)
+static int dirty_bitmap_clear_section(MemoryRegionSection *section,
+                                      void *opaque)
 {
     const hwaddr offset = section->offset_within_region;
     const hwaddr size = int128_get64(section->size);
@@ -836,6 +836,7 @@ static void dirty_bitmap_clear_section(MemoryRegionSection *section,
     }
     *cleared_bits += bitmap_count_one_with_offset(rb->bmap, start, npages);
     bitmap_clear(rb->bmap, start, npages);
+    return 0;
 }
 
 /*
diff --git a/system/memory.c b/system/memory.c
index 62d6b410f0..b5ab729e13 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -2147,7 +2147,7 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
 
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          MemoryRegionSection *section,
-                                         ReplayRamPopulate replay_fn,
+                                         ReplayStateChange replay_fn,
                                          void *opaque)
 {
     RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
@@ -2156,15 +2156,15 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
     return rdmc->replay_populated(rdm, section, replay_fn, opaque);
 }
 
-void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-                                          MemoryRegionSection *section,
-                                          ReplayRamDiscard replay_fn,
-                                          void *opaque)
+int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
+                                         MemoryRegionSection *section,
+                                         ReplayStateChange replay_fn,
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


