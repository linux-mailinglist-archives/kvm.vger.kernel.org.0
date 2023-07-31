Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48276769C56
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbjGaQZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjGaQZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:25:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754A61723
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820715; x=1722356715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nzxnw5G/eoYdNN3k9mPcm6LNL3IW0dYwkL/0HXSYmE8=;
  b=e8KODpqx6tWgyIaP/kN5yWKhPOVvc52th4IZCuITMV26U655WyzjC6Jz
   GKmlUBqU8DjDsLzRedC3+A038E+KtJgxCxKogsxWJNRqQvXKI/9Cle82X
   JrolCNsog1GT4WXJNXlgLyFRPUp3wn3qHZhti0Vk+l4DyFztV1ubFRCh+
   gn96cYaWnsxQvAMVsA/gbMRjf0kFT3mEHfIHW8H4vmDG+Gos+BjAR46c1
   TApIz5y72vIte8F0BdB2uYRCkG7/cOKfrVekRveOf8zvClS5rPCf06JjL
   h+pQYZhuU4NNLzHNnhl6/F+QI0X53o049jPZuStfDZKjEM22ubK+zIccN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993431"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993431"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984084"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984084"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:10 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        xiaoyao.li@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 05/19] kvm: Enable KVM_SET_USER_MEMORY_REGION2 for memslot
Date:   Mon, 31 Jul 2023 12:21:47 -0400
Message-Id: <20230731162201.271114-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230731162201.271114-1-xiaoyao.li@intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Peng <chao.p.peng@linux.intel.com>

Switch to KVM_SET_USER_MEMORY_REGION2 when supported by KVM.

With KVM_SET_USER_MEMORY_REGION2, QEMU can set up memory region that
backen'ed both by hva-based shared memory and gmem fd based private
memory.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c      | 57 +++++++++++++++++++++++++++++++++-------
 accel/kvm/trace-events   |  2 +-
 include/sysemu/kvm_int.h |  2 ++
 3 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d8eee405de24..7b1818334ba7 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -288,35 +288,68 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
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
+    if (!cap_user_memory2 && slot->fd >= 0) {
+        error_report("%s, KVM doesn't support gmem!", __func__);
+        exit(1);
+    }
+
     mem.slot = slot->slot | (kml->as_id << 16);
     mem.guest_phys_addr = slot->start_addr;
     mem.userspace_addr = (unsigned long)slot->ram;
     mem.flags = slot->flags;
+    mem.gmem_fd = slot->fd;
+    mem.gmem_offset = slot->ofs;
 
-    if (slot->memory_size && !new && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
+    if (slot->memory_size && !new && (slot->flags ^ slot->old_flags) & KVM_MEM_READONLY) {
         /* Set the slot size to 0 before setting the slot to the desired
          * value. This is needed based on KVM commit 75d61fbc. */
         mem.memory_size = 0;
-        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+
+        if (cap_user_memory2) {
+            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
+        } else {
+            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
+	    }
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
+                              mem.userspace_addr, mem.gmem_fd,
+			      mem.gmem_offset, ret);
     if (ret < 0) {
-        error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
-                     " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
-                     __func__, mem.slot, slot->start_addr,
-                     (uint64_t)mem.memory_size, strerror(errno));
+        if (cap_user_memory2) {
+                error_report("%s: KVM_SET_USER_MEMORY_REGION2 failed, slot=%d,"
+                        " start=0x%" PRIx64 ", size=0x%" PRIx64 ","
+                        " flags=0x%" PRIx32 ","
+                        " gmem_fd=%" PRId32 ", gmem_offset=0x%" PRIx64 ": %s",
+                        __func__, mem.slot, slot->start_addr,
+                (uint64_t)mem.memory_size, mem.flags,
+                        mem.gmem_fd, (uint64_t)mem.gmem_offset,
+                        strerror(errno));
+        } else {
+                error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
+                            " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
+                __func__, mem.slot, slot->start_addr,
+                (uint64_t)mem.memory_size, strerror(errno));
+        }
     }
     return ret;
 }
@@ -472,6 +505,9 @@ static int kvm_mem_flags(MemoryRegion *mr)
     if (readonly && kvm_readonly_mem_allowed) {
         flags |= KVM_MEM_READONLY;
     }
+    if (memory_region_can_be_private(mr)) {
+        flags |= KVM_MEM_PRIVATE;
+    }
     return flags;
 }
 
@@ -1402,6 +1438,9 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
         mem->ram_start_offset = ram_start_offset;
         mem->ram = ram;
         mem->flags = kvm_mem_flags(mr);
+        mem->fd = mr->ram_block->gmem_fd;
+        mem->ofs = (uint8_t*)ram - mr->ram_block->host;
+
         kvm_slot_init_dirty_bitmap(mem);
         err = kvm_set_user_memory_region(kml, mem, true);
         if (err) {
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index 14ebfa1b991c..80694683acea 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -15,7 +15,7 @@ kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
 kvm_irqchip_release_virq(int virq) "virq %d"
 kvm_set_ioeventfd_mmio(int fd, uint64_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%" PRIx64 " val=0x%x assign: %d size: %d match: %d"
 kvm_set_ioeventfd_pio(int fd, uint16_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%x val=0x%x assign: %d size: %d match: %d"
-kvm_set_user_memory(uint16_t as, uint16_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "AddrSpace#%d Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
+kvm_set_user_memory(uint16_t as, uint16_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, uint32_t fd, uint64_t fd_offset, int ret) "AddrSpace#%d Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " gmem_fd=%d" " gmem_fd_offset=0x%" PRIx64 " ret=%d"
 kvm_clear_dirty_log(uint32_t slot, uint64_t start, uint32_t size) "slot#%"PRId32" start 0x%"PRIx64" size 0x%"PRIx32
 kvm_resample_fd_notify(int gsi) "gsi %d"
 kvm_dirty_ring_full(int id) "vcpu %d"
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 511b42bde5c4..48220c0793ac 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -30,6 +30,8 @@ typedef struct KVMSlot
     int as_id;
     /* Cache of the offset in ram address space */
     ram_addr_t ram_start_offset;
+    int fd;
+    hwaddr ofs;
 } KVMSlot;
 
 typedef struct KVMMemoryUpdate {
-- 
2.34.1

