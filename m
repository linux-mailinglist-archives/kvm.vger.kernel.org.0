Return-Path: <kvm+bounces-6904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98EB583B7C9
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:28:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6ED41C228BE
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 546C779CB;
	Thu, 25 Jan 2024 03:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="beVSNayP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CAF6FB2
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153286; cv=none; b=biEwzSJypjUStlQpM7cyaSfHe7Y/8RJiSXwz3sngKXFhZ+1DmiUREtPHaPWEVIBGTjRvGigkTuHkXVF3/4IMl7X9uPQG6X7m0pPOQSGN8eSdNHWmC6JRbS8XmeKJX33j0OV0j0S4P0SEVWXoGofiFmxAwpCq9EImxWGjUMXWsdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153286; c=relaxed/simple;
	bh=DJbDJ26JgGKqlwSzg9owqPemduWKddPLgiNvKtR3f8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUwYETiEb7W5KA7jIXo/ax5edRoUMCXiCD+PjVj8LbVdBzxq5sHHtl1rdlb2ymmxDuUeR2mY8HDedWTUfw6PDzaNV3YGaThwCdrZbjLq2/ph5sls43jHOE9zEnHs1PC6GeZewI6IpQXj6K3lCHIlIaTtMO2uk45673MqzvHDOZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=beVSNayP; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153284; x=1737689284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DJbDJ26JgGKqlwSzg9owqPemduWKddPLgiNvKtR3f8s=;
  b=beVSNayPiiSQ7DwtIsYMKmoWk0KEugQQwehLdpSVVLyGh61sIXu209J/
   x/EYVNUxmi0C3mF4640iy7G5c1S8NPnoe7LAxNahY9msnqSrKnpYaB2k1
   Q/Os4ruk9vtlMRIwt440dUPVLOqpcAhJ+oDJASnnqKtrRR/4adWa77PS8
   Lq4zgy2jDCGPXMlqmFo6QEalRQ9Lr/k0cTGAJqAKdfkYi8otcs+gzv6cC
   0S+A8AarmLRVfnmfoE7y7YERHOExSJrHXcGEcz17KzfNW2/LS2gYlzhV5
   OnKUKqI8+27xOpvhQ+pDKM4Uu1sjT5TjD0jq45+5pfp4dswIdaU9k1+2p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9427916"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9427916"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:23:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084394"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:23:43 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 02/66] RAMBlock: Add support of KVM private guest memfd
Date: Wed, 24 Jan 2024 22:22:24 -0500
Message-Id: <20240125032328.2522472-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add KVM guest_memfd support to RAMBlock so both normal hva based memory
and kvm guest memfd based private memory can be associated in one RAMBlock.

Introduce new flag RAM_GUEST_MEMFD. When it's set, it calls KVM ioctl to
create private guest_memfd during RAMBlock setup.

Allocating a new RAM_GUEST_MEMFD flag to instruct the setup of guest memfd
is more flexible and extensible than simply relying on the VM type because
in the future we may have the case that not all the memory of a VM need
guest memfd. As a benefit, it also avoid getting MachineState in memory
subsystem.

Note, RAM_GUEST_MEMFD is supposed to be set for memory backends of
confidential guests, such as TDX VM. How and when to set it for memory
backends will be implemented in the following patches.

Introduce memory_region_has_guest_memfd() to query if the MemoryRegion has
KVM guest_memfd allocated.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
- Add clarification of RAM_GUEST_MEMFD in commit message; (David Hildenbrand)
- refine the return value and error message; (Daniel P. Berrangé)
- remove flags in ram_block_add(); (David Hildenbrand)

Changes in v3:
- rename gmem to guest_memfd;
- close(guest_memfd) when RAMBlock is released; (Daniel P. Berrangé)
- Suqash the patch that introduces memory_region_has_guest_memfd().
---
 accel/kvm/kvm-all.c     | 25 +++++++++++++++++++++++++
 accel/stubs/kvm-stub.c  |  5 +++++
 include/exec/memory.h   | 20 +++++++++++++++++---
 include/exec/ram_addr.h |  2 +-
 include/exec/ramblock.h |  1 +
 include/sysemu/kvm.h    |  2 ++
 system/memory.c         |  5 +++++
 system/physmem.c        | 24 +++++++++++++++++++++---
 8 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 49e755ec4ad2..f6b0f8d2db1c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -91,6 +91,7 @@ bool kvm_msi_use_devid;
 static bool kvm_has_guest_debug;
 static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
+static bool kvm_guest_memfd_supported;
 static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -2385,6 +2386,8 @@ static int kvm_init(MachineState *ms)
     }
     s->as = g_new0(struct KVMAs, s->nr_as);
 
+    kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
+
     if (object_property_find(OBJECT(current_machine), "kvm-type")) {
         g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
                                                             "kvm-type",
@@ -4084,3 +4087,25 @@ void query_stats_schemas_cb(StatsSchemaList **result, Error **errp)
         query_stats_schema_vcpu(first_cpu, &stats_args);
     }
 }
+
+int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp)
+{
+    int fd;
+    struct kvm_create_guest_memfd guest_memfd = {
+        .size = size,
+        .flags = flags,
+    };
+
+    if (!kvm_guest_memfd_supported) {
+        error_setg(errp, "KVM doesn't support guest memfd\n");
+        return -1;
+    }
+
+    fd = kvm_vm_ioctl(kvm_state, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
+    if (fd < 0) {
+        error_setg_errno(errp, errno, "Error creating kvm guest memfd");
+        return -1;
+    }
+
+    return fd;
+}
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 1b37d9a302cc..06cf548a0329 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -124,3 +124,8 @@ uint32_t kvm_dirty_ring_size(void)
 {
     return 0;
 }
+
+int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp)
+{
+    return -ENOSYS;
+}
\ No newline at end of file
diff --git a/include/exec/memory.h b/include/exec/memory.h
index 177be23db709..f11036ead15e 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -243,6 +243,9 @@ typedef struct IOMMUTLBEvent {
 /* RAM FD is opened read-only */
 #define RAM_READONLY_FD (1 << 11)
 
+/* RAM can be private that has kvm guest memfd backend */
+#define RAM_GUEST_MEMFD   (1 << 12)
+
 static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
                                        IOMMUNotifierFlag flags,
                                        hwaddr start, hwaddr end,
@@ -1307,7 +1310,8 @@ bool memory_region_init_ram_nomigrate(MemoryRegion *mr,
  * @name: Region name, becomes part of RAMBlock name used in migration stream
  *        must be unique within any device
  * @size: size of the region.
- * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_NORESERVE.
+ * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_NORESERVE,
+ *             RAM_GUEST_MEMFD.
  * @errp: pointer to Error*, to store an error if it happens.
  *
  * Note that this function does not do anything to cause the data in the
@@ -1369,7 +1373,7 @@ bool memory_region_init_resizeable_ram(MemoryRegion *mr,
  *         (getpagesize()) will be used.
  * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM,
  *             RAM_NORESERVE, RAM_PROTECTED, RAM_NAMED_FILE, RAM_READONLY,
- *             RAM_READONLY_FD
+ *             RAM_READONLY_FD, RAM_GUEST_MEMFD
  * @path: the path in which to allocate the RAM.
  * @offset: offset within the file referenced by path
  * @errp: pointer to Error*, to store an error if it happens.
@@ -1399,7 +1403,7 @@ bool memory_region_init_ram_from_file(MemoryRegion *mr,
  * @size: size of the region.
  * @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM,
  *             RAM_NORESERVE, RAM_PROTECTED, RAM_NAMED_FILE, RAM_READONLY,
- *             RAM_READONLY_FD
+ *             RAM_READONLY_FD, RAM_GUEST_MEMFD
  * @fd: the fd to mmap.
  * @offset: offset within the file referenced by fd
  * @errp: pointer to Error*, to store an error if it happens.
@@ -1722,6 +1726,16 @@ static inline bool memory_region_is_romd(MemoryRegion *mr)
  */
 bool memory_region_is_protected(MemoryRegion *mr);
 
+/**
+ * memory_region_has_guest_memfd: check whether a memory region has guest_memfd
+ *     associated
+ *
+ * Returns %true if a memory region's ram_block has valid guest_memfd assigned.
+ *
+ * @mr: the memory region being queried
+ */
+bool memory_region_has_guest_memfd(MemoryRegion *mr);
+
 /**
  * memory_region_get_iommu: check whether a memory region is an iommu
  *
diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 90676093f5d5..4ebd9ded5e86 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -109,7 +109,7 @@ long qemu_maxrampagesize(void);
  *  @mr: the memory region where the ram block is
  *  @ram_flags: RamBlock flags. Supported flags: RAM_SHARED, RAM_PMEM,
  *              RAM_NORESERVE, RAM_PROTECTED, RAM_NAMED_FILE, RAM_READONLY,
- *              RAM_READONLY_FD
+ *              RAM_READONLY_FD, RAM_GUEST_MEMFD
  *  @mem_path or @fd: specify the backing file or device
  *  @offset: Offset into target file
  *  @errp: pointer to Error*, to store an error if it happens
diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
index 3eb79723c6a8..03b3a3d40a6d 100644
--- a/include/exec/ramblock.h
+++ b/include/exec/ramblock.h
@@ -41,6 +41,7 @@ struct RAMBlock {
     QLIST_HEAD(, RAMBlockNotifier) ramblock_notifiers;
     int fd;
     uint64_t fd_offset;
+    int guest_memfd;
     size_t page_size;
     /* dirty bitmap used during migration */
     unsigned long *bmap;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index d61487816421..fedc28c7d17f 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -538,4 +538,6 @@ bool kvm_arch_cpu_check_are_resettable(void);
 bool kvm_dirty_ring_enabled(void);
 
 uint32_t kvm_dirty_ring_size(void);
+
+int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
 #endif
diff --git a/system/memory.c b/system/memory.c
index a229a79988fc..c756950c0c0f 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -1850,6 +1850,11 @@ bool memory_region_is_protected(MemoryRegion *mr)
     return mr->ram && (mr->ram_block->flags & RAM_PROTECTED);
 }
 
+bool memory_region_has_guest_memfd(MemoryRegion *mr)
+{
+    return mr->ram_block && mr->ram_block->guest_memfd >= 0;
+}
+
 uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
 {
     uint8_t mask = mr->dirty_log_mask;
diff --git a/system/physmem.c b/system/physmem.c
index c1b22bac77c2..4735b0462ed9 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1841,6 +1841,17 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
         }
     }
 
+    if (kvm_enabled() && (new_block->flags & RAM_GUEST_MEMFD) &&
+        new_block->guest_memfd < 0) {
+        /* TODO: to decide if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is supported */
+        new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
+                                                        0, errp);
+        if (new_block->guest_memfd < 0) {
+            qemu_mutex_unlock_ramlist();
+            return;
+        }
+    }
+
     new_ram_size = MAX(old_ram_size,
               (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS);
     if (new_ram_size > old_ram_size) {
@@ -1903,7 +1914,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
     /* Just support these ram flags by now. */
     assert((ram_flags & ~(RAM_SHARED | RAM_PMEM | RAM_NORESERVE |
                           RAM_PROTECTED | RAM_NAMED_FILE | RAM_READONLY |
-                          RAM_READONLY_FD)) == 0);
+                          RAM_READONLY_FD | RAM_GUEST_MEMFD)) == 0);
 
     if (xen_enabled()) {
         error_setg(errp, "-mem-path not supported with Xen");
@@ -1938,6 +1949,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
     new_block->used_length = size;
     new_block->max_length = size;
     new_block->flags = ram_flags;
+    new_block->guest_memfd = -1;
     new_block->host = file_ram_alloc(new_block, size, fd, !file_size, offset,
                                      errp);
     if (!new_block->host) {
@@ -2016,7 +2028,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
     Error *local_err = NULL;
 
     assert((ram_flags & ~(RAM_SHARED | RAM_RESIZEABLE | RAM_PREALLOC |
-                          RAM_NORESERVE)) == 0);
+                          RAM_NORESERVE| RAM_GUEST_MEMFD)) == 0);
     assert(!host ^ (ram_flags & RAM_PREALLOC));
 
     size = HOST_PAGE_ALIGN(size);
@@ -2028,6 +2040,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
     new_block->max_length = max_size;
     assert(max_size >= size);
     new_block->fd = -1;
+    new_block->guest_memfd = -1;
     new_block->page_size = qemu_real_host_page_size();
     new_block->host = host;
     new_block->flags = ram_flags;
@@ -2050,7 +2063,7 @@ RAMBlock *qemu_ram_alloc_from_ptr(ram_addr_t size, void *host,
 RAMBlock *qemu_ram_alloc(ram_addr_t size, uint32_t ram_flags,
                          MemoryRegion *mr, Error **errp)
 {
-    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE)) == 0);
+    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE | RAM_GUEST_MEMFD)) == 0);
     return qemu_ram_alloc_internal(size, size, NULL, NULL, ram_flags, mr, errp);
 }
 
@@ -2078,6 +2091,11 @@ static void reclaim_ramblock(RAMBlock *block)
     } else {
         qemu_anon_ram_free(block->host, block->max_length);
     }
+
+    if (block->guest_memfd >= 0) {
+        close(block->guest_memfd);
+    }
+
     g_free(block);
 }
 
-- 
2.34.1


