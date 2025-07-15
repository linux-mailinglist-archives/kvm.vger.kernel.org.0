Return-Path: <kvm+bounces-52420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB986B04F36
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 05:40:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8C4B4A5037
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 03:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD022D130B;
	Tue, 15 Jul 2025 03:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Myv1x+1o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A871F2D12E0
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 03:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550805; cv=none; b=d1uwLXsjITvaM2wdPGuWP0RPCMs5V6wgDlpSA7MRrQy6pm7VRe1iNDxuqejqG+INwWJfHqQ7ymNkBeRJg+h5Zs3/xE52+KDdhA/lgCIPqfdUfc+VLP65IwXKtCrwS1AoGAMInJ9Sjj6efwipa0/80L4IbVPzGAEAuj+DMrcWaF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550805; c=relaxed/simple;
	bh=X3NUwnnatzcmEwzonfTfmIa0wURgw66ax6O0/XgE1Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRaAPv3ku7CcLaUv70y95ddcZPmFX2L5sPfgZTC8MOYSfex+35aCM8YIUQiFNOiCW0p3dApvvctD+qbGuakYYJ9wOhS5m31H2xdraj7ZAwLrsDkHZe7zwaaBKW5/z9220ABKVysMnGz8Y+0Tk/Zg73bEAyb1QgsFVti1seW7Bi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Myv1x+1o; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752550804; x=1784086804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X3NUwnnatzcmEwzonfTfmIa0wURgw66ax6O0/XgE1Hs=;
  b=Myv1x+1o40MSvwfPZR4/kvk3rl6iD8CtGp5myA97j8l84E0OU7Jw38EX
   mFIO3h8Mmjest4C9VLr7oICtn6sMB1uJw0mbootC3ghXfPDl+zf7C+ZcI
   5B0JKwgwxxA8hEGHGH2/RY0O1GizWMazGRhyoP6mfUEJOmuFVf6+Az66/
   rOZRcphO1IT+Y70lcNSyxqMjnCU9eUgKWROjlKNC+bgFJIEbd0Ysky6W+
   5w3qaZ+5N2hGEECx0CL9YrNTO/aAVPZV5LXE8zuShfw2p66ulDxC5PbBy
   5yFEs2qXaVLvJG41PVPR7opOCErF+ao1ZIadqFQIIPb3aK6JrcpE5H0GE
   A==;
X-CSE-ConnectionGUID: fnMhDDYgSYarsYKE6+MGAQ==
X-CSE-MsgGUID: LoZce0/YQMqggGCT3149fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="72334932"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="72334932"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 20:40:04 -0700
X-CSE-ConnectionGUID: Q9Y6B1MuRZaPmH9e8CbT6g==
X-CSE-MsgGUID: z+dqKtX3TwivifMeWRVZlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="180808120"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa002.fm.intel.com with ESMTP; 14 Jul 2025 20:40:00 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	ackerleytng@google.com,
	seanjc@google.com
Cc: Fuad Tabba <tabba@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	ira.weiny@intel.com,
	michael.roth@amd.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [POC PATCH 3/5] memory/guest_memfd: Enable in-place conversion when available
Date: Tue, 15 Jul 2025 11:31:39 +0800
Message-ID: <20250715033141.517457-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250715033141.517457-1-xiaoyao.li@intel.com>
References: <cover.1747264138.git.ackerleytng@google.com>
 <20250715033141.517457-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yan Zhao <yan.y.zhao@intel.com>

(This is just the POC code to use in-place conversion gmem.)

Try to use in-place conversion gmem when it is supported.

When in-place conversion is enabled, there is no need to discard memory
since it still needs to be used as the memory of opposite attribute
after conversion.

For a upstreamable solution, we can introduce memory-backend-guestmemfd
for in-place conversion. With the non in-place conversion, it needs
seperate non-gmem memory to back the shared memory and gmem is created
implicitly and internally based on vm type. While with in-place
conversion, there is no need for seperate non-gmem memory because gmem
itself can be served as shared memory. So that we can introduce
memory-backend-guestmemfd as the specific backend for in-place
conversion gmem.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Co-developed-by Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c       | 79 ++++++++++++++++++++++++++++-----------
 accel/stubs/kvm-stub.c    |  1 +
 include/system/kvm.h      |  1 +
 include/system/memory.h   |  2 +
 include/system/ramblock.h |  1 +
 system/memory.c           |  7 ++++
 system/physmem.c          | 21 ++++++++++-
 7 files changed, 90 insertions(+), 22 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a106d1ba0f0b..609537738d38 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -105,6 +105,7 @@ static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static uint64_t kvm_supported_memory_attributes;
 static bool kvm_guest_memfd_supported;
+bool kvm_guest_memfd_inplace_supported;
 static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -1487,6 +1488,30 @@ static int kvm_set_memory_attributes(hwaddr start, uint64_t size, uint64_t attr)
     return r;
 }
 
+static int kvm_set_guest_memfd_shareability(MemoryRegion *mr, ram_addr_t offset,
+                                            uint64_t size, bool shared)
+{
+    int guest_memfd = mr->ram_block->guest_memfd;
+    struct kvm_gmem_convert param = {
+                .offset = offset,
+                .size = size,
+                .error_offset = 0,
+    };
+    unsigned long op;
+    int r;
+
+    op = shared ? KVM_GMEM_CONVERT_SHARED : KVM_GMEM_CONVERT_PRIVATE;
+
+    r = ioctl(guest_memfd, op, &param);
+    if (r) {
+        error_report("failed to set guest_memfd offset 0x%lx size 0x%lx to %s  "
+                     "error '%s' error offset 0x%llx",
+                     offset, size, shared ? "shared" : "private",
+                     strerror(errno), param.error_offset);
+    }
+    return r;
+}
+
 int kvm_set_memory_attributes_private(hwaddr start, uint64_t size)
 {
     return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
@@ -1604,7 +1629,8 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
             abort();
         }
 
-        if (memory_region_has_guest_memfd(mr)) {
+        if (memory_region_has_guest_memfd(mr) &&
+            !memory_region_guest_memfd_in_place_conversion(mr)) {
             err = kvm_set_memory_attributes_private(start_addr, slot_size);
             if (err) {
                 error_report("%s: failed to set memory attribute private: %s",
@@ -2779,6 +2805,9 @@ static int kvm_init(AccelState *as, MachineState *ms)
         kvm_check_extension(s, KVM_CAP_GUEST_MEMFD) &&
         kvm_check_extension(s, KVM_CAP_USER_MEMORY2) &&
         (kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE);
+    kvm_guest_memfd_inplace_supported =
+        kvm_check_extension(s, KVM_CAP_GMEM_SHARED_MEM) &&
+        kvm_check_extension(s, KVM_CAP_GMEM_CONVERSION);
     kvm_pre_fault_memory_supported = kvm_vm_check_extension(s, KVM_CAP_PRE_FAULT_MEMORY);
 
     if (s->kernel_irqchip_split == ON_OFF_AUTO_AUTO) {
@@ -3056,6 +3085,7 @@ static void kvm_eat_signals(CPUState *cpu)
 
 int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
 {
+    bool in_place_conversion = false;
     MemoryRegionSection section;
     ram_addr_t offset;
     MemoryRegion *mr;
@@ -3112,18 +3142,23 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
         goto out_unref;
     }
 
-    if (to_private) {
-        ret = kvm_set_memory_attributes_private(start, size);
-    } else {
-        ret = kvm_set_memory_attributes_shared(start, size);
-    }
-    if (ret) {
-        goto out_unref;
-    }
-
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
+    in_place_conversion = memory_region_guest_memfd_in_place_conversion(mr);
+    if (in_place_conversion) {
+        ret = kvm_set_guest_memfd_shareability(mr, offset, size, !to_private);
+    } else {
+        if (to_private) {
+            ret = kvm_set_memory_attributes_private(start, size);
+        } else {
+            ret = kvm_set_memory_attributes_shared(start, size);
+        }
+    }
+    if (ret) {
+        goto out_unref;
+    }
+
     ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
                                             offset, size, to_private);
     if (ret) {
@@ -3133,17 +3168,19 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
         goto out_unref;
     }
 
-    if (to_private) {
-        if (rb->page_size != qemu_real_host_page_size()) {
-            /*
-             * shared memory is backed by hugetlb, which is supposed to be
-             * pre-allocated and doesn't need to be discarded
-             */
-            goto out_unref;
-        }
-        ret = ram_block_discard_range(rb, offset, size);
-    } else {
-        ret = ram_block_discard_guest_memfd_range(rb, offset, size);
+    if (!in_place_conversion) {
+        if (to_private) {
+            if (rb->page_size != qemu_real_host_page_size()) {
+               /*
+                * shared memory is backed by hugetlb, which is supposed to be
+                * pre-allocated and doesn't need to be discarded
+                */
+                goto out_unref;
+             }
+             ret = ram_block_discard_range(rb, offset, size);
+         } else {
+             ret = ram_block_discard_guest_memfd_range(rb, offset, size);
+         }
     }
 
 out_unref:
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 68cd33ba9735..bf0ccae27b62 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -24,6 +24,7 @@ bool kvm_gsi_direct_mapping;
 bool kvm_allowed;
 bool kvm_readonly_mem_allowed;
 bool kvm_msi_use_devid;
+bool kvm_guest_memfd_inplace_supported;
 
 void kvm_flush_coalesced_mmio_buffer(void)
 {
diff --git a/include/system/kvm.h b/include/system/kvm.h
index 3c7d31473663..32f2be5f92e1 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -43,6 +43,7 @@ extern bool kvm_gsi_direct_mapping;
 extern bool kvm_readonly_mem_allowed;
 extern bool kvm_msi_use_devid;
 extern bool kvm_pre_fault_memory_supported;
+extern bool kvm_guest_memfd_inplace_supported;
 
 #define kvm_enabled()           (kvm_allowed)
 /**
diff --git a/include/system/memory.h b/include/system/memory.h
index 46248d4a52c4..f14fbf65805d 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -1812,6 +1812,8 @@ bool memory_region_is_protected(MemoryRegion *mr);
  */
 bool memory_region_has_guest_memfd(MemoryRegion *mr);
 
+bool memory_region_guest_memfd_in_place_conversion(MemoryRegion *mr);
+
 /**
  * memory_region_get_iommu: check whether a memory region is an iommu
  *
diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 87e847e184aa..87757940ea21 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -46,6 +46,7 @@ struct RAMBlock {
     int fd;
     uint64_t fd_offset;
     int guest_memfd;
+    uint64_t guest_memfd_flags;
     RamBlockAttributes *attributes;
     size_t page_size;
     /* dirty bitmap used during migration */
diff --git a/system/memory.c b/system/memory.c
index e8d9b15b28f6..6870a41629ef 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -35,6 +35,7 @@
 
 #include "memory-internal.h"
 
+#include <linux/kvm.h>
 //#define DEBUG_UNASSIGNED
 
 static unsigned memory_region_transaction_depth;
@@ -1878,6 +1879,12 @@ bool memory_region_has_guest_memfd(MemoryRegion *mr)
     return mr->ram_block && mr->ram_block->guest_memfd >= 0;
 }
 
+bool memory_region_guest_memfd_in_place_conversion(MemoryRegion *mr)
+{
+    return mr && memory_region_has_guest_memfd(mr) &&
+           (mr->ram_block->guest_memfd_flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED);
+}
+
 uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
 {
     uint8_t mask = mr->dirty_log_mask;
diff --git a/system/physmem.c b/system/physmem.c
index 130c148ffb5c..955480685310 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -89,6 +89,9 @@
 
 #include "memory-internal.h"
 
+#include <linux/guestmem.h>
+#include <linux/kvm.h>
+
 //#define DEBUG_SUBPAGE
 
 /* ram_list is read under rcu_read_lock()/rcu_read_unlock().  Writes
@@ -1913,6 +1916,9 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
 
     if (new_block->flags & RAM_GUEST_MEMFD) {
         int ret;
+        bool in_place = kvm_guest_memfd_inplace_supported;
+
+        new_block->guest_memfd_flags = 0;
 
         if (!kvm_enabled()) {
             error_setg(errp, "cannot set up private guest memory for %s: KVM required",
@@ -1929,13 +1935,26 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
             goto out_free;
         }
 
+        if (in_place) {
+            new_block->guest_memfd_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED |
+                                            GUEST_MEMFD_FLAG_INIT_PRIVATE;
+        }
+
         new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
-                                                        0, errp);
+                                 new_block->guest_memfd_flags, errp);
         if (new_block->guest_memfd < 0) {
             qemu_mutex_unlock_ramlist();
             goto out_free;
         }
 
+        if (in_place) {
+            qemu_ram_munmap(new_block->fd, new_block->host, new_block->max_length);
+            new_block->host = qemu_ram_mmap(new_block->guest_memfd,
+                                            new_block->max_length,
+                                            QEMU_VMALLOC_ALIGN,
+                                            QEMU_MAP_SHARED, 0);
+        }
+
         /*
          * The attribute bitmap of the RamBlockAttributes is default to
          * discarded, which mimics the behavior of kvm_set_phys_mem() when it
-- 
2.43.0


