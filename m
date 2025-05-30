Return-Path: <kvm+bounces-48084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ABD4AC89F3
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 10:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46D6B1BA5DD9
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 08:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27846219A6B;
	Fri, 30 May 2025 08:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D4mnaBYP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11CC215783
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 08:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594044; cv=none; b=YVVjkpGw5rWZdd7jPFV5n/LCUz0WGate3jJSMODkN1aWlH2dtA4Z+TaTT3e5XAXsf1O0r/mfKHj+sWiKB/APvGNioeRngQLxRAOsHzojCqNDjdVZAbpeHyFGgOP1RfYcg7EDZxyzWefGkSNX28ypAfYjj9xOYisVpCyp3oZmYn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594044; c=relaxed/simple;
	bh=ErOx1YGbQNtXWKSFT1x2vQVQKaLrP+c6flBUhQ6KGOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlBzoYspFp/B3/2JW9cOSXIGRpKIIXD3OLTVYTri5ZSy6JDt9VkjyYJ0X0oMIy6rErgV1BPpzUMoYMoad0VKX4bVGNxHiftHzzdxdjzRlhHzXbbI39ar9W9AhrWar3Ds9TMHJZLTrqvR7GM99tbHEsTd1w5YugCC5IHYbi99e2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D4mnaBYP; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748594042; x=1780130042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ErOx1YGbQNtXWKSFT1x2vQVQKaLrP+c6flBUhQ6KGOg=;
  b=D4mnaBYP9TR7bAdVSJt8SMelLnCUpJX/RdBHR8vzwOrOzX19fEnTOqcm
   a1ebmDdebzhdndZFo9f4B4rAFeKLu4fE6GbSjajtDfzMDuZuBz+HtE05e
   mVgJXhNgiO4PndDUq6+1d4yQJirkc5HUPF5gOGdddQHAf68jjCHpNeOCx
   E+JxTWTt0S20mnCaU3/I43CmsmdWEZA/JqVKwYDbkaIvleOqvm1SDncva
   BoqZgnssrQAgHV+gdpkqw9KYIIh9MhWWU5uPM0LTlu/PnYHy/B71V4Dty
   Lohsa1QKwq2JPgHzV+O968krJw4SSTTeb4ePd0jfCU4SvQQYpBaF2i2Wz
   Q==;
X-CSE-ConnectionGUID: bDIEttJxRwq8m7R+DxhZKQ==
X-CSE-MsgGUID: z3f22BFnTcGaPaGIIqQ7Bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="62081499"
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="62081499"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2025 01:34:02 -0700
X-CSE-ConnectionGUID: 7bfgkNDAQ82bV8T88t+zEA==
X-CSE-MsgGUID: WnjLLr2aQxO5SjuTXVXhyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="144453759"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2025 01:33:58 -0700
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
Subject: [PATCH v6 1/5] memory: Export a helper to get intersection of a MemoryRegionSection with a given range
Date: Fri, 30 May 2025 16:32:50 +0800
Message-ID: <20250530083256.105186-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250530083256.105186-1-chenyi.qiang@intel.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the helper to memory_region_section_intersect_range() to make it
more generic. Meanwhile, define the @end as Int128 and replace the
related operations with Int128_* format since the helper is exported as
a wider API.

Suggested-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
Changes in v6:
    - No change.

Changes in v5:
    - Indent change for int128 ops to avoid the line over 80
    - Add two Review-by from Alexey and Zhao

Changes in v4:
    - No change.
---
 hw/virtio/virtio-mem.c  | 32 +++++---------------------------
 include/system/memory.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index a3d1a676e7..b3c126ea1e 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -244,28 +244,6 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
     return ret;
 }
 
-/*
- * Adjust the memory section to cover the intersection with the given range.
- *
- * Returns false if the intersection is empty, otherwise returns true.
- */
-static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
-                                                uint64_t offset, uint64_t size)
-{
-    uint64_t start = MAX(s->offset_within_region, offset);
-    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
-                       offset + size);
-
-    if (end <= start) {
-        return false;
-    }
-
-    s->offset_within_address_space += start - s->offset_within_region;
-    s->offset_within_region = start;
-    s->size = int128_make64(end - start);
-    return true;
-}
-
 typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
 
 static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
@@ -287,7 +265,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
                                       first_bit + 1) - 1;
         size = (last_bit - first_bit + 1) * vmem->block_size;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             break;
         }
         ret = cb(&tmp, arg);
@@ -319,7 +297,7 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
                                  first_bit + 1) - 1;
         size = (last_bit - first_bit + 1) * vmem->block_size;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             break;
         }
         ret = cb(&tmp, arg);
@@ -355,7 +333,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
         MemoryRegionSection tmp = *rdl->section;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
         rdl->notify_discard(rdl, &tmp);
@@ -371,7 +349,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
     QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
         MemoryRegionSection tmp = *rdl->section;
 
-        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
             continue;
         }
         ret = rdl->notify_populate(rdl, &tmp);
@@ -388,7 +366,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
             if (rdl2 == rdl) {
                 break;
             }
-            if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
+            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
                 continue;
             }
             rdl2->notify_discard(rdl2, &tmp);
diff --git a/include/system/memory.h b/include/system/memory.h
index fbbf4cf911..b961c4076a 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -1211,6 +1211,36 @@ MemoryRegionSection *memory_region_section_new_copy(MemoryRegionSection *s);
  */
 void memory_region_section_free_copy(MemoryRegionSection *s);
 
+/**
+ * memory_region_section_intersect_range: Adjust the memory section to cover
+ * the intersection with the given range.
+ *
+ * @s: the #MemoryRegionSection to be adjusted
+ * @offset: the offset of the given range in the memory region
+ * @size: the size of the given range
+ *
+ * Returns false if the intersection is empty, otherwise returns true.
+ */
+static inline bool memory_region_section_intersect_range(MemoryRegionSection *s,
+                                                         uint64_t offset,
+                                                         uint64_t size)
+{
+    uint64_t start = MAX(s->offset_within_region, offset);
+    Int128 end = int128_min(int128_add(int128_make64(s->offset_within_region),
+                                       s->size),
+                            int128_add(int128_make64(offset),
+                                       int128_make64(size)));
+
+    if (int128_le(end, int128_make64(start))) {
+        return false;
+    }
+
+    s->offset_within_address_space += start - s->offset_within_region;
+    s->offset_within_region = start;
+    s->size = int128_sub(end, int128_make64(start));
+    return true;
+}
+
 /**
  * memory_region_init: Initialize a memory region
  *
-- 
2.43.5


