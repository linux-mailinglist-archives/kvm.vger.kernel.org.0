Return-Path: <kvm+bounces-6907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F1383B7CD
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:28:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BB98285ABC
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8812101E2;
	Thu, 25 Jan 2024 03:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fD3u+CbJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9302748D
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153289; cv=none; b=OEmajHK55h1q0w9ZAK+TfQosq81hytAEeLH9B81SFnGfUlV+0cVAFQac4Nc6JyOAjVp9UX0RFaHWW9/yNCFgbl2bT+HbXRIudmGjVcOqu/0sRontGDJ+Mf0+xtNjyPiq3S1Ltm1NdobWC5XPSTfShKUcTqzDvyklEyqwwx54shQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153289; c=relaxed/simple;
	bh=lqNbwiyyIhP4S9mFdJcUZyQPGWvmsdMdma4vIpFwUpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vGr5He2yeU3tMJOc7EQgvuHp+u1n1S1KlTMegmWRQQbqBBmxUfIcLkl0vyFzzAqvGURjUVonh2L6qVBPPwtMtDUL2YHdgg34jV4A8plcJLLXd+aVH0j/hoToZ2iktaFELEKbRDNTn3a5eQSi5e9NX/3VB7dEfSv+um0AEDXaMFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fD3u+CbJ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153287; x=1737689287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lqNbwiyyIhP4S9mFdJcUZyQPGWvmsdMdma4vIpFwUpY=;
  b=fD3u+CbJgKsMSooa+VRi+Vw1ts380vbcv5Vo0Xo3JTsEHEfBdsIPa7b3
   MQGLvBsmzH3RJyfJVW2G5hx2p4XnQ0M3Hs8qB/A7Eo5pgS17XHMAvfUhO
   ioSjtjooPwMyeiV/R7AHPC9wqyCSlDWb108FGnKN+FoGtcg1CgvoO1xmi
   2+pIUSLpapAdgPHN7JMKQnldvRqtIejF/P3zf04lqcWgdFWedrj8ohsE2
   wrUl0fvjDyBsEd/X0D6Ya0jIARgY018MA/rSKJ/Ztc7G26Ak9Y3O7zXvz
   3EzAxOZpmSmc3Yhf1d5D6T3tE2imXd0gg8Vy5Oigc/8rYugf1QY4Stv1G
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9427955"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9427955"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:24:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084529"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:23:59 -0800
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
Subject: [PATCH v4 05/66] kvm: Enable KVM_SET_USER_MEMORY_REGION2 for memslot
Date: Wed, 24 Jan 2024 22:22:27 -0500
Message-Id: <20240125032328.2522472-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Peng <chao.p.peng@linux.intel.com>

Switch to KVM_SET_USER_MEMORY_REGION2 when supported by KVM.

With KVM_SET_USER_MEMORY_REGION2, QEMU can set up memory region that
backend'ed both by hva-based shared memory and guest memfd based private
memory.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
- update KVM_MEM_PRIVATE to KVM_MEM_GUEST_MEMFD; (Isaku)
---
 accel/kvm/kvm-all.c      | 56 ++++++++++++++++++++++++++++++++++------
 accel/kvm/trace-events   |  2 +-
 include/sysemu/kvm_int.h |  2 ++
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 56b41a4ea8dc..50c10becf772 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -283,35 +283,69 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
 static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, bool new)
 {
     KVMState *s = kvm_state;
-    struct kvm_userspace_memory_region mem;
+    struct kvm_userspace_memory_region2 mem;
+    static int cap_user_memory2 = -1;
     int ret;
 
+    if (cap_user_memory2 == -1) {
+        cap_user_memory2 = kvm_check_extension(s, KVM_CAP_USER_MEMORY2);
+    }
+
+    if (!cap_user_memory2 && slot->guest_memfd >= 0) {
+        error_report("%s, KVM doesn't support KVM_CAP_USER_MEMORY2,"
+                     " which is required by guest memfd!", __func__);
+        exit(1);
+    }
+
     mem.slot = slot->slot | (kml->as_id << 16);
     mem.guest_phys_addr = slot->start_addr;
     mem.userspace_addr = (unsigned long)slot->ram;
     mem.flags = slot->flags;
+    mem.guest_memfd = slot->guest_memfd;
+    mem.guest_memfd_offset = slot->guest_memfd_offset;
 
     if (slot->memory_size && !new && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
         /* Set the slot size to 0 before setting the slot to the desired
          * value. This is needed based on KVM commit 75d61fbc. */
         mem.memory_size = 0;
-        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+
+        if (cap_user_memory2) {
+            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
+        } else {
+            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+        }
         if (ret < 0) {
             goto err;
         }
     }
     mem.memory_size = slot->memory_size;
-    ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+    if (cap_user_memory2) {
+        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
+    } else {
+        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+    }
     slot->old_flags = mem.flags;
 err:
     trace_kvm_set_user_memory(mem.slot >> 16, (uint16_t)mem.slot, mem.flags,
                               mem.guest_phys_addr, mem.memory_size,
-                              mem.userspace_addr, ret);
+                              mem.userspace_addr, mem.guest_memfd,
+                              mem.guest_memfd_offset, ret);
     if (ret < 0) {
-        error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
-                     " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
-                     __func__, mem.slot, slot->start_addr,
-                     (uint64_t)mem.memory_size, strerror(errno));
+        if (cap_user_memory2) {
+                error_report("%s: KVM_SET_USER_MEMORY_REGION2 failed, slot=%d,"
+                        " start=0x%" PRIx64 ", size=0x%" PRIx64 ","
+                        " flags=0x%" PRIx32 ", guest_memfd=%" PRId32 ","
+                        " guest_memfd_offset=0x%" PRIx64 ": %s",
+                        __func__, mem.slot, slot->start_addr,
+                        (uint64_t)mem.memory_size, mem.flags,
+                        mem.guest_memfd, (uint64_t)mem.guest_memfd_offset,
+                        strerror(errno));
+        } else {
+                error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
+                            " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
+                            __func__, mem.slot, slot->start_addr,
+                            (uint64_t)mem.memory_size, strerror(errno));
+        }
     }
     return ret;
 }
@@ -466,6 +500,9 @@ static int kvm_mem_flags(MemoryRegion *mr)
     if (readonly && kvm_readonly_mem_allowed) {
         flags |= KVM_MEM_READONLY;
     }
+    if (memory_region_has_guest_memfd(mr)) {
+        flags |= KVM_MEM_GUEST_MEMFD;
+    }
     return flags;
 }
 
@@ -1353,6 +1390,9 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
         mem->ram_start_offset = ram_start_offset;
         mem->ram = ram;
         mem->flags = kvm_mem_flags(mr);
+        mem->guest_memfd = mr->ram_block->guest_memfd;
+        mem->guest_memfd_offset = (uint8_t*)ram - mr->ram_block->host;
+
         kvm_slot_init_dirty_bitmap(mem);
         err = kvm_set_user_memory_region(kml, mem, true);
         if (err) {
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index 9f599abc172c..e8c52cb9e7a1 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -15,7 +15,7 @@ kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
 kvm_irqchip_release_virq(int virq) "virq %d"
 kvm_set_ioeventfd_mmio(int fd, uint64_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%" PRIx64 " val=0x%x assign: %d size: %d match: %d"
 kvm_set_ioeventfd_pio(int fd, uint16_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%x val=0x%x assign: %d size: %d match: %d"
-kvm_set_user_memory(uint16_t as, uint16_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "AddrSpace#%d Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
+kvm_set_user_memory(uint16_t as, uint16_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, uint32_t fd, uint64_t fd_offset, int ret) "AddrSpace#%d Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " guest_memfd=%d" " guest_memfd_offset=0x%" PRIx64 " ret=%d"
 kvm_clear_dirty_log(uint32_t slot, uint64_t start, uint32_t size) "slot#%"PRId32" start 0x%"PRIx64" size 0x%"PRIx32
 kvm_resample_fd_notify(int gsi) "gsi %d"
 kvm_dirty_ring_full(int id) "vcpu %d"
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 882e37e12c5b..cad763e240c1 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -30,6 +30,8 @@ typedef struct KVMSlot
     int as_id;
     /* Cache of the offset in ram address space */
     ram_addr_t ram_start_offset;
+    int guest_memfd;
+    hwaddr guest_memfd_offset;
 } KVMSlot;
 
 typedef struct KVMMemoryUpdate {
-- 
2.34.1


