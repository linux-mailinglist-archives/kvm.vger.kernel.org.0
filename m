Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738B5374CF6
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhEFBmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:42:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:9180 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhEFBmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:42:32 -0400
IronPort-SDR: mn8unO6uNKn/jHMG6G7jvfo+D91e+z+vLmUcx7yh2Z/H90M9YSRxEaWxZMVI/Xm61VeuvgWr5z
 VlgIApzuuWNQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="195230521"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="195230521"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:32 -0700
IronPort-SDR: s0Mtm9jpzon4ZF3wCxKoFToTGOCQ6RIRtSBUqcpKrtr/mU2A7L82P41mTr/hrHoq80TpemUdvo
 +tzUJ0xhpL+A==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220482"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:29 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 10/10] Introduce new CPUClass::get_phys_page_attrs_debug implementation for encrypted guests
Date:   Thu,  6 May 2021 09:40:37 +0800
Message-Id: <20210506014037.11982-11-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yuan Yao <yuan.yao@intel.com>

Add new function x86_cpu_get_phys_page_attrs_encrypted_debug() to walking guset
page tables to do VA -> PA translation for encrypted guests.

Now install this to cc->get_phys_page_attrs_debug for INTEL TD guests only.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 7a8a1386fb..9ce81bb21c 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1807,6 +1807,8 @@ void x86_cpu_dump_state(CPUState *cs, FILE *f, int flags);
 
 hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cpu, vaddr addr,
                                          MemTxAttrs *attrs);
+hwaddr x86_cpu_get_phys_page_attrs_encrypted_debug(CPUState *cs, vaddr addr,
+                                                   MemTxAttrs *attrs);
 
 int x86_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
 int x86_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, int reg);
diff --git a/target/i386/helper.c b/target/i386/helper.c
index 21edcb9204..a9a0467b50 100644
--- a/target/i386/helper.c
+++ b/target/i386/helper.c
@@ -205,8 +205,10 @@ void cpu_x86_update_cr4(CPUX86State *env, uint32_t new_cr4)
 }
 
 #if !defined(CONFIG_USER_ONLY)
-hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
-                                         MemTxAttrs *attrs)
+static hwaddr x86_cpu_get_phys_page_attrs_debug_internal(CPUState *cs, vaddr addr,
+                                                         MemTxAttrs *attrs,
+                                                         uint64_t (*ldq_phys)(CPUState *, hwaddr),
+                                                         uint32_t (*ldl_phys)(CPUState *, hwaddr))
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
@@ -242,7 +244,7 @@ hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
             if (la57) {
                 pml5e_addr = ((env->cr[3] & ~0xfff) +
                         (((addr >> 48) & 0x1ff) << 3)) & a20_mask;
-                pml5e = x86_ldq_phys(cs, pml5e_addr);
+                pml5e = ldq_phys(cs, pml5e_addr);
                 if (!(pml5e & PG_PRESENT_MASK)) {
                     return -1;
                 }
@@ -252,13 +254,13 @@ hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
 
             pml4e_addr = ((pml5e & PG_ADDRESS_MASK) +
                     (((addr >> 39) & 0x1ff) << 3)) & a20_mask;
-            pml4e = x86_ldq_phys(cs, pml4e_addr);
+            pml4e = ldq_phys(cs, pml4e_addr);
             if (!(pml4e & PG_PRESENT_MASK)) {
                 return -1;
             }
             pdpe_addr = ((pml4e & PG_ADDRESS_MASK) +
                          (((addr >> 30) & 0x1ff) << 3)) & a20_mask;
-            pdpe = x86_ldq_phys(cs, pdpe_addr);
+            pdpe = ldq_phys(cs, pdpe_addr);
             if (!(pdpe & PG_PRESENT_MASK)) {
                 return -1;
             }
@@ -273,14 +275,14 @@ hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
         {
             pdpe_addr = ((env->cr[3] & ~0x1f) + ((addr >> 27) & 0x18)) &
                 a20_mask;
-            pdpe = x86_ldq_phys(cs, pdpe_addr);
+            pdpe = ldq_phys(cs, pdpe_addr);
             if (!(pdpe & PG_PRESENT_MASK))
                 return -1;
         }
 
         pde_addr = ((pdpe & PG_ADDRESS_MASK) +
                     (((addr >> 21) & 0x1ff) << 3)) & a20_mask;
-        pde = x86_ldq_phys(cs, pde_addr);
+        pde = ldq_phys(cs, pde_addr);
         if (!(pde & PG_PRESENT_MASK)) {
             return -1;
         }
@@ -293,7 +295,7 @@ hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
             pte_addr = ((pde & PG_ADDRESS_MASK) +
                         (((addr >> 12) & 0x1ff) << 3)) & a20_mask;
             page_size = 4096;
-            pte = x86_ldq_phys(cs, pte_addr);
+            pte = ldq_phys(cs, pte_addr);
         }
         if (!(pte & PG_PRESENT_MASK)) {
             return -1;
@@ -303,7 +305,7 @@ hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
 
         /* page directory entry */
         pde_addr = ((env->cr[3] & ~0xfff) + ((addr >> 20) & 0xffc)) & a20_mask;
-        pde = x86_ldl_phys(cs, pde_addr);
+        pde = ldl_phys(cs, pde_addr);
         if (!(pde & PG_PRESENT_MASK))
             return -1;
         if ((pde & PG_PSE_MASK) && (env->cr[4] & CR4_PSE_MASK)) {
@@ -312,7 +314,7 @@ hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
         } else {
             /* page directory entry */
             pte_addr = ((pde & ~0xfff) + ((addr >> 10) & 0xffc)) & a20_mask;
-            pte = x86_ldl_phys(cs, pte_addr);
+            pte = ldl_phys(cs, pte_addr);
             if (!(pte & PG_PRESENT_MASK)) {
                 return -1;
             }
@@ -329,6 +331,22 @@ out:
     return pte | page_offset;
 }
 
+hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
+                                         MemTxAttrs *attrs)
+{
+    return x86_cpu_get_phys_page_attrs_debug_internal(cs, addr, attrs,
+                                                      x86_ldq_phys,
+                                                      x86_ldl_phys);
+}
+
+hwaddr x86_cpu_get_phys_page_attrs_encrypted_debug(CPUState *cs, vaddr addr,
+                                                   MemTxAttrs *attrs)
+{
+    return x86_cpu_get_phys_page_attrs_debug_internal(cs, addr, attrs,
+                                                      x86_ldq_phys_debug,
+                                                      x86_ldl_phys_debug);
+}
+
 typedef struct MCEInjectionParams {
     Monitor *mon;
     int bank;
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d13d4c8487..b1e089f73f 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -273,6 +273,7 @@ void tdx_pre_create_vcpu(CPUState *cpu)
 
     MachineState *ms = MACHINE(qdev_get_machine());
     X86CPU *x86cpu = X86_CPU(cpu);
+    CPUClass *cc = CPU_GET_CLASS(cpu);
     CPUX86State *env = &x86cpu->env;
     TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
                                                     TYPE_TDX_GUEST);
@@ -320,6 +321,11 @@ void tdx_pre_create_vcpu(CPUState *cpu)
 
     init_vm.cpuid = (__u64)(&cpuid_data);
     tdx_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
+
+    if (tdx->debug) {
+        cc->get_phys_page_attrs_debug
+            = x86_cpu_get_phys_page_attrs_encrypted_debug;
+    }
 out:
     qemu_mutex_unlock(&tdx->lock);
 }
-- 
2.20.1

