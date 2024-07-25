Return-Path: <kvm+bounces-22214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D4F93BD03
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 09:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E94E1C21232
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 07:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B90417109C;
	Thu, 25 Jul 2024 07:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FueTa9SA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7984428
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 07:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721892164; cv=none; b=mAGYV3WvKgK3AfuLbFn8kMPxp4M1yJRFdlmGh+/p3xjhad1o7hxPd29s7EtiFyIHlwoto066ppIzOvnqSoGZDwcen3TVWcM02NnubRYjuwGcCtHZp6W0CxzuO8Lnk806J/xpVrlhWpdO0vGmkpZqv/5Sq4mEsXpPP4OT2Jr96uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721892164; c=relaxed/simple;
	bh=H5K123PXaJQqQxOo8ELc+HzpStV4NW+TCKC7nAh3EBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx5LF+19nKPzmm4Nh5tRBNgIK2PG9iHhK725Kx9vX0u5Rmi+UxnbfuIheSAO4OmJJMJm8GUDBYGKAZwvSvFO/Uc3UHhkVZC+PEMfmrbavoc9WIykLuxRosShJ/U8Cjsdy0CobOLWMCA4BCtcg2KVPKy+CAc0Qms2TJb2rXdhAaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FueTa9SA; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721892162; x=1753428162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H5K123PXaJQqQxOo8ELc+HzpStV4NW+TCKC7nAh3EBY=;
  b=FueTa9SAgDym6Yoz+RNkPb8DgZu3D5p/kp04E65VRAIp+9fXcqw9vOER
   +BE5epWhxrXUk71XSI1YhD4txdRCjsXQ0qT66rVxwPN6wKtJ/P3JqsnaY
   z/69AyzvSZrF3lN5uWBRwKNVlCuLAdmkXBHMVxMoN9TUsH9qAIJJjCqor
   whgqHjzdHbXfoF6NAKU6693hisjpsBbiYxHAemR3SYinc2YDK7LuH4+6y
   I6XEaur5Webr39nXhWyFDsc6XPbVlvpzSUCJUP61ALikLpXqXJC+qLM3n
   w5g9ACJQXIKAcmf11+p9ScO3MdYE1wURDU+MQKOTH+F5BSTUEuQRN+uY1
   Q==;
X-CSE-ConnectionGUID: utObAXJoQWKhlmwvrRu81g==
X-CSE-MsgGUID: q69eVkEVQyyE+QIgibbpSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30753930"
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="30753930"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:42 -0700
X-CSE-ConnectionGUID: 3w8sSJbVTvCY1sQAFyC/hg==
X-CSE-MsgGUID: yyr8OVH1QCOWaxtpNbBKOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="52858146"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 00:22:38 -0700
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Wu Hao <hao.wu@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [RFC PATCH 1/6] guest_memfd: Introduce an object to manage the guest-memfd with RamDiscardManager
Date: Thu, 25 Jul 2024 03:21:10 -0400
Message-ID: <20240725072118.358923-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240725072118.358923-1-chenyi.qiang@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
uncoordinated discard") highlighted, some subsystems like VFIO might
disable ram block discard. However, guest_memfd relies on the discard
operation to perform page conversion between private and shared memory.
This can lead to stale IOMMU mapping issue when assigning a hardware
device to a confidential guest via shared memory (unprotected memory
pages). Blocking shared page discard can solve this problem, but it
could cause guests to consume twice the memory with VFIO, which is not
acceptable in some cases. An alternative solution is to convey other
systems like VFIO to refresh its outdated IOMMU mappings.

RamDiscardManager is an existing concept (used by virtio-mem) to adjust
VFIO mappings in relation to VM page assignement. Effectively page
conversion is similar to hot-removing a page in one mode and adding it
back in the other, so the similar work that needs to happen in response
to virtio-mem changes needs to happen for page conversion events.
Introduce the RamDiscardManager to guest_memfd to achieve it.

However, Implementing the RamDiscardManager interface poses a challenge
as guest_memfd is not an object, instead, it is contained within RamBlock
and is indicated by a RAM_GUEST_MEMFD flag upon creation.

One option is to implement the interface in HostMemoryBackend. Any
guest_memfd-backed host memory backend can register itself in the target
MemoryRegion. However, this solution doesn't cover the scenario where a
guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
the virtual BIOS MemoryRegion.

Thus, implement the second option, which involves defining an object type
named guest_memfd_manager with the RamDiscardManager interface. Upon
creation of guest_memfd, a new guest_memfd_manager object can be
instantiated and registered to the managed guest_memfd MemoryRegion to
handle the page conversion events.

In the context of guest_memfd, the discarded state signifies that the
page is private, while the populated state indicated that the page is
shared. The state of the memory is tracked at the granularity of the
host page size (i.e. block_size), as the minimum conversion size can be
one page per request. In addition, VFIO expects the DMA mapping for a
specific iova to be mapped and unmapped with the same granularity.
However, there's no guarantee that the confidential guest won't
partially convert the pages. For instance the confidential guest may
flip a 2M page from private to shared and later flip the first 4K
sub-range from shared to private. To prevent such invalid cases, all
operations are performed with a 4K granularity.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 include/sysemu/guest-memfd-manager.h |  46 +++++
 system/guest-memfd-manager.c         | 283 +++++++++++++++++++++++++++
 system/meson.build                   |   1 +
 3 files changed, 330 insertions(+)
 create mode 100644 include/sysemu/guest-memfd-manager.h
 create mode 100644 system/guest-memfd-manager.c

diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/guest-memfd-manager.h
new file mode 100644
index 0000000000..ab8c2ba362
--- /dev/null
+++ b/include/sysemu/guest-memfd-manager.h
@@ -0,0 +1,46 @@
+/*
+ * QEMU guest memfd manager
+ *
+ * Copyright Intel
+ *
+ * Author:
+ *      Chenyi Qiang <chenyi.qiang@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory
+ *
+ */
+
+#ifndef SYSEMU_GUEST_MEMFD_MANAGER_H
+#define SYSEMU_GUEST_MEMFD_MANAGER_H
+
+#include "sysemu/hostmem.h"
+
+#define TYPE_GUEST_MEMFD_MANAGER "guest-memfd-manager"
+
+OBJECT_DECLARE_TYPE(GuestMemfdManager, GuestMemfdManagerClass, GUEST_MEMFD_MANAGER)
+
+struct GuestMemfdManager {
+    Object parent;
+
+    /* Managed memory region. */
+    MemoryRegion *mr;
+
+    /* bitmap used to track discard (private) memory */
+    int32_t discard_bitmap_size;
+    unsigned long *discard_bitmap;
+
+    /* block size and alignment */
+    uint64_t block_size;
+
+    /* listeners to notify on populate/discard activity. */
+    QLIST_HEAD(, RamDiscardListener) rdl_list;
+};
+
+struct GuestMemfdManagerClass {
+    ObjectClass parent_class;
+
+    void (*realize)(Object *gmm, MemoryRegion *mr, uint64_t region_size);
+};
+
+#endif
diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
new file mode 100644
index 0000000000..7b90f26859
--- /dev/null
+++ b/system/guest-memfd-manager.c
@@ -0,0 +1,283 @@
+/*
+ * QEMU guest memfd manager
+ *
+ * Copyright Intel
+ *
+ * Author:
+ *      Chenyi Qiang <chenyi.qiang@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory
+ *
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "sysemu/guest-memfd-manager.h"
+
+OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(GuestMemfdManager,
+                                          guest_memfd_manager,
+                                          GUEST_MEMFD_MANAGER,
+                                          OBJECT,
+                                          { TYPE_RAM_DISCARD_MANAGER },
+                                          { })
+
+static bool guest_memfd_rdm_is_populated(const RamDiscardManager *rdm,
+                                         const MemoryRegionSection *section)
+{
+    const GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
+    uint64_t first_bit = section->offset_within_region / gmm->block_size;
+    uint64_t last_bit = first_bit + int128_get64(section->size) / gmm->block_size - 1;
+    unsigned long first_discard_bit;
+
+    first_discard_bit = find_next_bit(gmm->discard_bitmap, last_bit + 1, first_bit);
+    return first_discard_bit > last_bit;
+}
+
+static bool guest_memfd_rdm_intersect_memory_section(MemoryRegionSection *section,
+                                                     uint64_t offset, uint64_t size)
+{
+    uint64_t start = MAX(section->offset_within_region, offset);
+    uint64_t end = MIN(section->offset_within_region + int128_get64(section->size),
+                       offset + size);
+    if (end <= start) {
+        return false;
+    }
+
+    section->offset_within_address_space += start - section->offset_within_region;
+    section->offset_within_region = start;
+    section->size = int128_make64(end - start);
+
+    return true;
+}
+
+typedef int (*guest_memfd_section_cb)(MemoryRegionSection *s, void *arg);
+
+static int guest_memfd_notify_populate_cb(MemoryRegionSection *section, void *arg)
+{
+    RamDiscardListener *rdl = arg;
+
+    return rdl->notify_populate(rdl, section);
+}
+
+static int guest_memfd_notify_discard_cb(MemoryRegionSection *section, void *arg)
+{
+    RamDiscardListener *rdl = arg;
+
+    rdl->notify_discard(rdl, section);
+
+    return 0;
+}
+
+static int guest_memfd_for_each_populated_range(const GuestMemfdManager *gmm,
+                                                MemoryRegionSection *section,
+                                                void *arg,
+                                                guest_memfd_section_cb cb)
+{
+    unsigned long first_zero_bit, last_zero_bit;
+    uint64_t offset, size;
+    int ret = 0;
+
+    first_zero_bit = section->offset_within_region / gmm->block_size;
+    first_zero_bit = find_next_zero_bit(gmm->discard_bitmap, gmm->discard_bitmap_size,
+                                        first_zero_bit);
+
+    while (first_zero_bit < gmm->discard_bitmap_size) {
+        MemoryRegionSection tmp = *section;
+
+        offset = first_zero_bit * gmm->block_size;
+        last_zero_bit = find_next_bit(gmm->discard_bitmap, gmm->discard_bitmap_size,
+                                      first_zero_bit + 1) - 1;
+        size = (last_zero_bit - first_zero_bit + 1) * gmm->block_size;
+
+        if (!guest_memfd_rdm_intersect_memory_section(&tmp, offset, size)) {
+            break;
+        }
+
+        ret = cb(&tmp, arg);
+        if (ret) {
+            break;
+        }
+
+        first_zero_bit = find_next_zero_bit(gmm->discard_bitmap, gmm->discard_bitmap_size,
+                                            last_zero_bit + 2);
+    }
+
+    return ret;
+}
+
+static int guest_memfd_for_each_discarded_range(const GuestMemfdManager *gmm,
+                                                MemoryRegionSection *section,
+                                                void *arg,
+                                                guest_memfd_section_cb cb)
+{
+    unsigned long first_one_bit, last_one_bit;
+    uint64_t offset, size;
+    int ret = 0;
+
+    first_one_bit = section->offset_within_region / gmm->block_size;
+    first_one_bit = find_next_bit(gmm->discard_bitmap, gmm->discard_bitmap_size,
+                                  first_one_bit);
+
+    while (first_one_bit < gmm->discard_bitmap_size) {
+        MemoryRegionSection tmp = *section;
+
+        offset = first_one_bit * gmm->block_size;
+        last_one_bit = find_next_zero_bit(gmm->discard_bitmap, gmm->discard_bitmap_size,
+                                          first_one_bit + 1) - 1;
+        size = (last_one_bit - first_one_bit + 1) * gmm->block_size;
+
+        if (!guest_memfd_rdm_intersect_memory_section(&tmp, offset, size)) {
+            break;
+        }
+
+        ret = cb(&tmp, arg);
+        if (ret) {
+            break;
+        }
+
+        first_one_bit = find_next_bit(gmm->discard_bitmap, gmm->discard_bitmap_size,
+                                      last_one_bit + 2);
+    }
+
+    return ret;
+}
+
+static uint64_t guest_memfd_rdm_get_min_granularity(const RamDiscardManager *rdm,
+                                                    const MemoryRegion *mr)
+{
+    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
+
+    g_assert(mr == gmm->mr);
+    return gmm->block_size;
+}
+
+static void guest_memfd_rdm_register_listener(RamDiscardManager *rdm,
+                                              RamDiscardListener *rdl,
+                                              MemoryRegionSection *section)
+{
+    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
+    int ret;
+
+    g_assert(section->mr == gmm->mr);
+    rdl->section = memory_region_section_new_copy(section);
+
+    QLIST_INSERT_HEAD(&gmm->rdl_list, rdl, next);
+
+    ret = guest_memfd_for_each_populated_range(gmm, section, rdl,
+                                               guest_memfd_notify_populate_cb);
+    if (ret) {
+        error_report("%s: Failed to register RAM discard listener: %s", __func__,
+                     strerror(-ret));
+    }
+}
+
+static void guest_memfd_rdm_unregister_listener(RamDiscardManager *rdm,
+                                                RamDiscardListener *rdl)
+{
+    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
+    int ret;
+
+    g_assert(rdl->section);
+    g_assert(rdl->section->mr == gmm->mr);
+
+    ret = guest_memfd_for_each_populated_range(gmm, rdl->section, rdl,
+                                               guest_memfd_notify_discard_cb);
+    if (ret) {
+        error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
+                     strerror(-ret));
+    }
+
+    memory_region_section_free_copy(rdl->section);
+    rdl->section = NULL;
+    QLIST_REMOVE(rdl, next);
+
+}
+
+typedef struct GuestMemfdReplayData {
+    void *fn;
+    void *opaque;
+} GuestMemfdReplayData;
+
+static int guest_memfd_rdm_replay_populated_cb(MemoryRegionSection *section, void *arg)
+{
+    struct GuestMemfdReplayData *data = arg;
+    ReplayRamPopulate replay_fn = data->fn;
+
+    return replay_fn(section, data->opaque);
+}
+
+static int guest_memfd_rdm_replay_populated(const RamDiscardManager *rdm,
+                                            MemoryRegionSection *section,
+                                            ReplayRamPopulate replay_fn,
+                                            void *opaque)
+{
+    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
+    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == gmm->mr);
+    return guest_memfd_for_each_populated_range(gmm, section, &data,
+                                                guest_memfd_rdm_replay_populated_cb);
+}
+
+static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection *section, void *arg)
+{
+    struct GuestMemfdReplayData *data = arg;
+    ReplayRamDiscard replay_fn = data->fn;
+
+    replay_fn(section, data->opaque);
+
+    return 0;
+}
+
+static void guest_memfd_rdm_replay_discarded(const RamDiscardManager *rdm,
+                                             MemoryRegionSection *section,
+                                             ReplayRamDiscard replay_fn,
+                                             void *opaque)
+{
+    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
+    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque = opaque };
+
+    g_assert(section->mr == gmm->mr);
+    guest_memfd_for_each_discarded_range(gmm, section, &data,
+                                         guest_memfd_rdm_replay_discarded_cb);
+}
+
+static void guest_memfd_manager_realize(Object *obj, MemoryRegion *mr,
+                                        uint64_t region_size)
+{
+    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
+    uint64_t bitmap_size = ROUND_UP(region_size, gmm->block_size) / gmm->block_size;
+
+    gmm->mr = mr;
+    gmm->discard_bitmap_size = bitmap_size;
+    gmm->discard_bitmap = bitmap_new(bitmap_size);
+}
+
+static void guest_memfd_manager_init(Object *obj)
+{
+    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
+
+    gmm->block_size = qemu_real_host_page_size();
+    QLIST_INIT(&gmm->rdl_list);
+}
+
+static void guest_memfd_manager_finalize(Object *obj)
+{
+    g_free(GUEST_MEMFD_MANAGER(obj)->discard_bitmap);
+}
+
+static void guest_memfd_manager_class_init(ObjectClass *oc, void *data)
+{
+    GuestMemfdManagerClass *gmmc = GUEST_MEMFD_MANAGER_CLASS(oc);
+    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
+
+    gmmc->realize = guest_memfd_manager_realize;
+
+    rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
+    rdmc->register_listener = guest_memfd_rdm_register_listener;
+    rdmc->unregister_listener = guest_memfd_rdm_unregister_listener;
+    rdmc->is_populated = guest_memfd_rdm_is_populated;
+    rdmc->replay_populated = guest_memfd_rdm_replay_populated;
+    rdmc->replay_discarded = guest_memfd_rdm_replay_discarded;
+}
diff --git a/system/meson.build b/system/meson.build
index a296270cb0..9b96d645ab 100644
--- a/system/meson.build
+++ b/system/meson.build
@@ -16,6 +16,7 @@ system_ss.add(files(
   'dirtylimit.c',
   'dma-helpers.c',
   'globals.c',
+  'guest-memfd-manager.c',
   'memory_mapping.c',
   'qdev-monitor.c',
   'qtest.c',
-- 
2.43.5


