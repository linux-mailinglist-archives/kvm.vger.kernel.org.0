Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E80374CF2
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhEFBmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:42:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:9158 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230344AbhEFBmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:42:15 -0400
IronPort-SDR: OpHPaJQ6orF2g+AqXt2PHRqd0/wyT9g9YyIUA2kAioiD7tIFTuw4/OazuHvhf+dCvyVbwR3QIL
 BYGMROTbmd6A==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="195230490"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="195230490"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:18 -0700
IronPort-SDR: 8GT797jRE+K50ygb3hvoSuOakNu3PTiA1JIToz/G3hVFiDuXm40UqGyFcUYM/Oyp7CP/3hsAZ2
 mf4MBJwknD1w==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220401"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:15 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 06/10] Introduce new MemoryDebugOps which hook into guest virtual and physical memory debug interfaces such as cpu_memory_rw_debug, to allow vendor specific assist/hooks for debugging and delegating accessing the guest memory. This is required for example in case of AMD SEV platform where the guest memory is encrypted and a SEV specific debug assist/hook will be required to access the guest memory.
Date:   Thu,  6 May 2021 09:40:33 +0800
Message-Id: <20210506014037.11982-7-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The MemoryDebugOps are used by cpu_memory_rw_debug() and default to
address_space_read and address_space_write_rom.

Yuan Yao: Exports the physical_memory_debug_ops variable for functions
in target/i386/helper.c

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Yuan Yao <yuan.yao@intel.com>

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 7e6fdcb8e4..0250b50beb 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -2498,6 +2498,20 @@ MemTxResult address_space_write_cached_slow(MemoryRegionCache *cache,
                                             hwaddr addr, const void *buf,
                                             hwaddr len);
 
+typedef struct MemoryDebugOps {
+    MemTxResult (*read)(AddressSpace *as, hwaddr phys_addr,
+                        MemTxAttrs attrs, void *buf,
+                        hwaddr len);
+    MemTxResult (*write)(AddressSpace *as, hwaddr phys_addr,
+                         MemTxAttrs attrs, const void *buf,
+                         hwaddr len);
+} MemoryDebugOps;
+
+// Export for functions in target/i386/helper.c
+extern const MemoryDebugOps *physical_memory_debug_ops;
+
+void address_space_set_debug_ops(const MemoryDebugOps *ops);
+
 static inline bool memory_access_is_direct(MemoryRegion *mr, bool is_write)
 {
     if (is_write) {
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 85034d9c11..c8029f69ad 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -171,6 +171,18 @@ struct DirtyBitmapSnapshot {
     unsigned long dirty[];
 };
 
+static const MemoryDebugOps default_debug_ops = {
+    .read = address_space_read,
+    .write = address_space_write_rom
+};
+
+const MemoryDebugOps *physical_memory_debug_ops = &default_debug_ops;
+
+void address_space_set_debug_ops(const MemoryDebugOps *ops)
+{
+    physical_memory_debug_ops = ops;
+}
+
 static void phys_map_node_reserve(PhysPageMap *map, unsigned nodes)
 {
     static unsigned alloc_hint = 16;
@@ -3396,6 +3408,10 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
         page = addr & TARGET_PAGE_MASK;
         phys_addr = cpu_get_phys_page_attrs_debug(cpu, page, &attrs);
         asidx = cpu_asidx_from_attrs(cpu, attrs);
+
+        /* set debug attrs to indicate memory access is from the debugger */
+        attrs.debug = 1;
+
         /* if no physical page mapped, return an error */
         if (phys_addr == -1)
             return -1;
@@ -3404,11 +3420,13 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
             l = len;
         phys_addr += (addr & ~TARGET_PAGE_MASK);
         if (is_write) {
-            res = address_space_write_rom(cpu->cpu_ases[asidx].as, phys_addr,
-                                          attrs, buf, l);
+            res = physical_memory_debug_ops->write(cpu->cpu_ases[asidx].as,
+                                                   phys_addr,
+                                                   attrs, buf, l);
         } else {
-            res = address_space_read(cpu->cpu_ases[asidx].as, phys_addr,
-                                     attrs, buf, l);
+            res = physical_memory_debug_ops->read(cpu->cpu_ases[asidx].as,
+                                                  phys_addr,
+                                                  attrs, buf, l);
         }
         if (res != MEMTX_OK) {
             return -1;
-- 
2.20.1

