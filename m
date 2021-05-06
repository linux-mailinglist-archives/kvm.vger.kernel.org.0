Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D394A374CF3
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhEFBmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:42:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:9158 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230335AbhEFBmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:42:21 -0400
IronPort-SDR: JOB77xCuG5dUGDRsBMcUWsJUIp6rjM5Oly0NyhFJHD0aoC1+g/7Q6RD0kx56BJrVdeFfgTNw/V
 IPFSS+bocvtQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="195230497"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="195230497"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:23 -0700
IronPort-SDR: BFIX9YRfBMILk28KYYz9MzEmkSPdXsiE78LudaBd577f3cbTpImWJENJJcnwDrSQPqeob+eN1M
 ZFqcp4ogR3Dw==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220437"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:18 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 07/10] Add new address_space_read and address_space_write debug helper interfaces which can be invoked by vendor specific guest memory debug assist/hooks to do guest RAM memory accesses using the added MemoryRegion callbacks.
Date:   Thu,  6 May 2021 09:40:34 +0800
Message-Id: <20210506014037.11982-8-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Yuan Yao:
    - Fixed fuzz_dma_read_cb() parameter issue for QEMU 5.2.91.
    - Move the caller of encrypted_memory_debug_ops into phymem.c
      as common callbacks for encrypted guests.
    - Adapted address_space_read_debug/address_space_wirte_rom_debug
      with new definition of MemoryRegion::ram_debug_ops;
    - Install the encrypted_memory_debug_ops/phymem.c for INTEL
      TD guest.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Yuan Yao <yuan.yao@intel.com>

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 0250b50beb..c0d6c1bd8f 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2246,6 +2246,12 @@ MemTxResult address_space_write_rom(AddressSpace *as, hwaddr addr,
                                     MemTxAttrs attrs,
                                     const void *buf, hwaddr len);
 
+MemTxResult address_space_write_rom_debug(AddressSpace *as,
+                                          hwaddr addr,
+                                          MemTxAttrs attrs,
+                                          const void *ptr,
+                                          hwaddr len);
+
 /* address_space_ld*: load from an address space
  * address_space_st*: store to an address space
  *
@@ -2512,6 +2518,8 @@ extern const MemoryDebugOps *physical_memory_debug_ops;
 
 void address_space_set_debug_ops(const MemoryDebugOps *ops);
 
+void set_encrypted_memory_debug_ops(void);
+
 static inline bool memory_access_is_direct(MemoryRegion *mr, bool is_write)
 {
     if (is_write) {
@@ -2567,6 +2575,10 @@ MemTxResult address_space_read(AddressSpace *as, hwaddr addr,
     return result;
 }
 
+MemTxResult address_space_read_debug(AddressSpace *as, hwaddr addr,
+                                     MemTxAttrs attrs, void *buf,
+                                     hwaddr len);
+
 /**
  * address_space_read_cached: read from a cached RAM region
  *
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index c8029f69ad..0fde02d325 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -3245,6 +3245,94 @@ void cpu_physical_memory_unmap(void *buffer, hwaddr len,
 #define RCU_READ_UNLOCK(...)     rcu_read_unlock()
 #include "memory_ldst.c.inc"
 
+inline MemTxResult address_space_read_debug(AddressSpace *as, hwaddr addr,
+                                            MemTxAttrs attrs, void *ptr,
+                                            hwaddr len)
+{
+    uint64_t val;
+    MemoryRegion *mr;
+    hwaddr l = len;
+    hwaddr addr1;
+    MemTxResult result = MEMTX_OK;
+    bool release_lock = false;
+    uint8_t *buf = ptr;
+    uint8_t *ram_ptr;
+
+    for (;;) {
+        RCU_READ_LOCK_GUARD();
+        mr = address_space_translate(as, addr, &addr1, &l, false, attrs);
+        if (!memory_access_is_direct(mr, false)) {
+            /* I/O case */
+            release_lock |= prepare_mmio_access(mr);
+            l = memory_access_size(mr, l, addr1);
+            result |= memory_region_dispatch_read(mr, addr1, &val,
+                                                  size_memop(l), attrs);
+            stn_he_p(buf, l, val);
+        } else {
+            /* RAM case */
+            fuzz_dma_read_cb(addr, l, mr);
+            ram_ptr = qemu_ram_ptr_length(mr->ram_block, addr1, &l, false);
+            if (attrs.debug && mr->ram_debug_ops) {
+                mr->ram_debug_ops->read(buf, ram_ptr, addr1, l, attrs);
+            } else {
+                memcpy(buf, ram_ptr, l);
+            }
+            result = MEMTX_OK;
+        }
+        if (release_lock) {
+            qemu_mutex_unlock_iothread();
+            release_lock = false;
+        }
+
+        len -= l;
+        buf += l;
+        addr += l;
+
+        if (!len) {
+            break;
+        }
+        l = len;
+    }
+    return result;
+}
+
+MemTxResult address_space_write_rom_debug(AddressSpace *as,
+                                          hwaddr addr,
+                                          MemTxAttrs attrs,
+                                          const void *ptr,
+                                          hwaddr len)
+{
+    hwaddr l;
+    uint8_t *ram_ptr;
+    hwaddr addr1;
+    MemoryRegion *mr;
+    const uint8_t *buf = ptr;
+
+    RCU_READ_LOCK_GUARD();
+    while (len > 0) {
+        l = len;
+        mr = address_space_translate(as, addr, &addr1, &l, true, attrs);
+
+        if (!(memory_region_is_ram(mr) ||
+              memory_region_is_romd(mr))) {
+            l = memory_access_size(mr, l, addr1);
+        } else {
+            /* ROM/RAM case */
+            ram_ptr = qemu_map_ram_ptr(mr->ram_block, addr1);
+            if (attrs.debug && mr->ram_debug_ops) {
+                mr->ram_debug_ops->write(ram_ptr, addr1, buf, l, attrs);
+            } else {
+                memcpy(ram_ptr, buf, l);
+            }
+            invalidate_and_set_dirty(mr, addr1, l);
+        }
+        len -= l;
+        buf += l;
+        addr += l;
+    }
+    return MEMTX_OK;
+}
+
 int64_t address_space_cache_init(MemoryRegionCache *cache,
                                  AddressSpace *as,
                                  hwaddr addr,
@@ -3438,6 +3526,33 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
     return 0;
 }
 
+static MemTxResult address_space_encrypted_memory_read_debug(AddressSpace *as,
+                                                             hwaddr addr, MemTxAttrs attrs,
+                                                             void *ptr, hwaddr len)
+{
+    attrs.debug = 1;
+    return address_space_read_debug(as, addr, attrs, ptr, len);
+}
+
+
+static MemTxResult address_space_encrypted_rom_write_debug(AddressSpace *as,
+                                                           hwaddr addr, MemTxAttrs attrs,
+                                                           const void *ptr, hwaddr len)
+{
+    attrs.debug = 1;
+    return address_space_write_rom_debug(as, addr, attrs, ptr, len);
+}
+
+static const MemoryDebugOps encrypted_memory_debug_ops = {
+    .read = address_space_encrypted_memory_read_debug,
+    .write = address_space_encrypted_rom_write_debug,
+};
+
+void set_encrypted_memory_debug_ops(void)
+{
+    address_space_set_debug_ops(&encrypted_memory_debug_ops);
+}
+
 /*
  * Allows code that needs to deal with migration bitmaps etc to still be built
  * target independent.
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 5050b2a82f..228d18a449 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2231,9 +2231,11 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }
 
-    if (kvm_tdx_enabled())
+    if (kvm_tdx_enabled()) {
         kvm_setup_memory_region_debug_ops(s,
                                           kvm_encrypted_guest_set_memory_region_debug_ops);
+        set_encrypted_memory_debug_ops();
+    }
 
     if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
         error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM");
-- 
2.20.1

