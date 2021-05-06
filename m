Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C60B374CF4
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhEFBm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:42:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:9180 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230351AbhEFBmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:42:23 -0400
IronPort-SDR: ySHx3erzpub35JBHyYt0iDOqdUrX/ulLdxzZ6rr7PpPgWREK62xPDTA1wtMomBzC76McWuvppY
 k9z07W94YNFA==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="195230501"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="195230501"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:25 -0700
IronPort-SDR: NnjfrUoogJTAGWJu7U7kjySmrhJEElxTwLgCJjvDd8StIz+SRywXHL0URqBrXiySjym7YEz1gd
 d+WGAWivPPdw==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220450"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:22 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 08/10] Introduce debug version of physical memory read/write API
Date:   Thu,  6 May 2021 09:40:35 +0800
Message-Id: <20210506014037.11982-9-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yuan Yao <yuan.yao@intel.com>

Add below APIs for reading/writing the physical memory, subsequent
patch will use them in monitor commands and gdbstub to support
encrypted guest debugging.

uint32_t x86_ldl_phys_debug(CPUState *cs, hwaddr addr);
uint64_t x86_ldq_phys_debug(CPUState *cs, hwaddr addr);
void cpu_physical_memory_rw_debug(hwaddr addr, void *buf,
                                  hwaddr len, bool is_write);
void cpu_physical_memory_read_debug(hwaddr addr,
                                    void *buf,
                                    hwaddr len);
void cpu_physical_memory_write_debug(hwaddr addr,
                                     const void *buf,
                                     hwaddr len);

Signed-off-by: Yuan Yao <yuan.yao@intel.com>

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 5a0a2d93e0..f77a9ecb60 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -69,6 +69,8 @@ size_t qemu_ram_pagesize_largest(void);
 
 void cpu_physical_memory_rw(hwaddr addr, void *buf,
                             hwaddr len, bool is_write);
+void cpu_physical_memory_rw_debug(hwaddr addr, void *buf,
+                                  hwaddr len, bool is_write);
 static inline void cpu_physical_memory_read(hwaddr addr,
                                             void *buf, hwaddr len)
 {
@@ -79,6 +81,18 @@ static inline void cpu_physical_memory_write(hwaddr addr,
 {
     cpu_physical_memory_rw(addr, (void *)buf, len, true);
 }
+
+static inline void cpu_physical_memory_read_debug(hwaddr addr,
+                                                  void *buf, hwaddr len)
+{
+    cpu_physical_memory_rw_debug(addr, buf, len, false);
+}
+static inline void cpu_physical_memory_write_debug(hwaddr addr,
+                                                   const void *buf, hwaddr len)
+{
+    cpu_physical_memory_rw_debug(addr, (void *)buf, len, true);
+}
+
 void *cpu_physical_memory_map(hwaddr addr,
                               hwaddr *plen,
                               bool is_write);
diff --git a/include/exec/memattrs.h b/include/exec/memattrs.h
index c8b56389d6..6d223ea196 100644
--- a/include/exec/memattrs.h
+++ b/include/exec/memattrs.h
@@ -60,6 +60,9 @@ typedef struct MemTxAttrs {
  */
 #define MEMTXATTRS_UNSPECIFIED ((MemTxAttrs) { .unspecified = 1 })
 
+// Same as MEMTXATTRS_UNSPECIFIED but enable debug
+#define MEMTXATTRS_UNSPECIFIED_DEBUG ((MemTxAttrs) { .unspecified = 1, .debug = 1 })
+
 /* New-style MMIO accessors can indicate that the transaction failed.
  * A zero (MEMTX_OK) response means success; anything else is a failure
  * of some kind. The memory subsystem will bitwise-OR together results
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 0fde02d325..ff6e215a3a 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -2910,6 +2910,19 @@ void cpu_physical_memory_rw(hwaddr addr, void *buf,
                      buf, len, is_write);
 }
 
+void cpu_physical_memory_rw_debug(hwaddr addr, void *buf,
+                            hwaddr len, bool is_write)
+{
+    if (is_write)
+        physical_memory_debug_ops->write(&address_space_memory,
+                                         addr, MEMTXATTRS_UNSPECIFIED_DEBUG,
+                                         buf, len);
+    else
+        physical_memory_debug_ops->read(&address_space_memory,
+                                        addr, MEMTXATTRS_UNSPECIFIED_DEBUG,
+                                        buf, len);
+}
+
 enum write_rom_type {
     WRITE_DATA,
     FLUSH_CACHE,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e5dbe84d3a..7a8a1386fb 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1960,6 +1960,8 @@ void x86_stl_phys_notdirty(CPUState *cs, hwaddr addr, uint32_t val);
 void x86_stw_phys(CPUState *cs, hwaddr addr, uint32_t val);
 void x86_stl_phys(CPUState *cs, hwaddr addr, uint32_t val);
 void x86_stq_phys(CPUState *cs, hwaddr addr, uint64_t val);
+uint32_t x86_ldl_phys_debug(CPUState *cs, hwaddr addr);
+uint64_t x86_ldq_phys_debug(CPUState *cs, hwaddr addr);
 #endif
 
 /* will be suppressed */
diff --git a/target/i386/helper.c b/target/i386/helper.c
index 618ad1c409..21edcb9204 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -663,4 +663,30 @@ void x86_stq_phys(CPUState *cs, hwaddr addr, uint64_t val)
 
     address_space_stq(as, addr, val, attrs, NULL);
 }
+
+uint32_t x86_ldl_phys_debug(CPUState *cs, hwaddr addr)
+{
+    uint32_t ret;
+    MemTxAttrs attrs = MEMTXATTRS_UNSPECIFIED_DEBUG;
+    int as_id = cpu_asidx_from_attrs(cs, attrs);
+    struct AddressSpace *as = cpu_get_address_space(cs, as_id);
+
+    physical_memory_debug_ops->read(as, addr, attrs,
+                                    &ret, sizeof(ret));
+
+    return tswap32(ret);
+}
+
+uint64_t x86_ldq_phys_debug(CPUState *cs, hwaddr addr)
+{
+    uint64_t ret;
+    MemTxAttrs attrs = MEMTXATTRS_UNSPECIFIED_DEBUG;
+    int as_id = cpu_asidx_from_attrs(cs, attrs);
+    struct AddressSpace *as = cpu_get_address_space(cs, as_id);
+
+    physical_memory_debug_ops->read(as, addr, attrs,
+                                    &ret, sizeof(ret));
+
+    return tswap64(ret);
+}
 #endif
-- 
2.20.1

