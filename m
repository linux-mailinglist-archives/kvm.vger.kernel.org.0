Return-Path: <kvm+bounces-47102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 271E9ABD50F
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28C354C21E7
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5403926C3BC;
	Tue, 20 May 2025 10:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ni/EXR1C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D869526E15A
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736950; cv=none; b=bzrOQCM/1aDUgtOUqJAyGSgJvcq5R55NyQW5NjTp1Ii9W23s07uz9J6B9fsnItYoLL+7F2eEKEZM3qg9iCD8T+oGud9Ea8DO68JRYtFSBMSvAte6a0lkkCw93Wj/qIS1lAJ57msYKAl4SqD7E8pZjcovh2Qw1QWJzzJQkq+E0vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736950; c=relaxed/simple;
	bh=pvakodypSo80D6jOTbKAlrpB0vU0hAgMhd1K2+L0NeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKYjRFqLkJb6o6p8mI+7n+aaZrabszsYF6DUfREFjfqw/Cj01aDSk4B1R5d6yyibtZV1koy8b1JN1JmAm6K8wpOh3ry8ic8K4Ci8sJUvLGNadwliIaDPHDGTHIzpbpVg+brqZZEb55EhKixrfw4XJ0LmopNV63n773FhI2x1pTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ni/EXR1C; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747736948; x=1779272948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pvakodypSo80D6jOTbKAlrpB0vU0hAgMhd1K2+L0NeY=;
  b=Ni/EXR1C0h91dG87wQj7tfQ3H9Tm+jqoWbRCzi2KLkCX/oauDOTSTDtX
   xli2POch1EaLpKsRVRO5LP/IeTKheTbGOK2OgzFwvIm9Ax18Xy9Jw0ctw
   wgXobvWVr5aOKbrltVs5Q5r/2uG25+onOl9lBlOXuIBtrvu7buLFQkePA
   UqJREmy/juZi2f0QOdKJKGaElPyGLx31dKNcj4pUpINflOaeITmbtDRMV
   yhLyoRUDxKviyJVcQTP5EpXScGI2slot/ZW9hVlHoHmwuwrItSRbT/XWU
   aOuI9NJj+GprwxO1cyCE4uBfgoYn+EeVIEQ7Z9TRR22xXV6/14LIw+qH7
   w==;
X-CSE-ConnectionGUID: Yz1UIyqQQU+pwgoLmOVp/w==
X-CSE-MsgGUID: wUzvSrnpT+qquzu7nVWMPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49566620"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="49566620"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:08 -0700
X-CSE-ConnectionGUID: mVaTGQJsQqajrbrL1g2z1Q==
X-CSE-MsgGUID: FWYrQxcpTkqyaLVKg5nkCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144905221"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 03:29:04 -0700
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
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v5 01/10] memory: Export a helper to get intersection of a MemoryRegionSection with a given range
Date: Tue, 20 May 2025 18:28:41 +0800
Message-ID: <20250520102856.132417-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250520102856.132417-1-chenyi.qiang@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
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
Changes in v5:
    - Indent change for int128 ops to avoid the line over 80
    - Add two Review-by from Alexey and Zhao

Changes in v4:
    - No change.

Changes in v3:
    - No change

Changes in v2:
    - Make memory_region_section_intersect_range() an inline function.
    - Add Reviewed-by from David
    - Define the @end as Int128 and use the related Int128_* ops as a wilder
      API (Alexey)
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


