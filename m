Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2772A78AE
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 09:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbgKEIQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 03:16:07 -0500
Received: from mga04.intel.com ([192.55.52.120]:39805 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbgKEIQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 03:16:04 -0500
IronPort-SDR: mCkOL5x7k9jhsJRPvZBcBepVBT9xJXq0xCQt2y+IISg2IcPgOmtmOpBt+jSdC6W6HKRDfLbkkM
 Q4+e0/8FnnOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9795"; a="166755749"
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="166755749"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 00:16:03 -0800
IronPort-SDR: 05IwEy/VozTgYE7NroiL4avmOZ0AmLLlBB1AfnxpHEKV7Rbl5N5VPmInirU4uezqeSZc9PQEtf
 6RkImQi8SCog==
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="539281547"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 00:16:01 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Add tests for PKS
Date:   Thu,  5 Nov 2020 16:18:05 +0800
Message-Id: <20201105081805.5674-9-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201105081805.5674-1-chenyi.qiang@intel.com>
References: <20201105081805.5674-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This unit-test is intended to test the KVM support for Protection Keys
for Supervisor Pages (PKS). If CR4.PKS is set in long mode, supervisor
pkeys are checked in addition to normal paging protections and Access or
Write can be disabled via a MSR update without TLB flushes when
permissions change.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 lib/x86/msr.h       |   1 +
 lib/x86/processor.h |   2 +
 x86/Makefile.x86_64 |   1 +
 x86/pks.c           | 146 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   5 ++
 5 files changed, 155 insertions(+)
 create mode 100644 x86/pks.c

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 6ef5502..e36934b 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -209,6 +209,7 @@
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 #define MSR_IA32_TSC_ADJUST		0x0000003b
+#define MSR_IA32_PKRS			0x000006e1
 
 #define FEATURE_CONTROL_LOCKED				(1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 74a2498..985fdd0 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -50,6 +50,7 @@
 #define X86_CR4_SMEP   0x00100000
 #define X86_CR4_SMAP   0x00200000
 #define X86_CR4_PKE    0x00400000
+#define X86_CR4_PKS    0x01000000
 
 #define X86_EFLAGS_CF    0x00000001
 #define X86_EFLAGS_FIXED 0x00000002
@@ -157,6 +158,7 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
+#define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
 #define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
 
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index af61d85..3a353df 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -20,6 +20,7 @@ tests += $(TEST_DIR)/tscdeadline_latency.flat
 tests += $(TEST_DIR)/intel-iommu.flat
 tests += $(TEST_DIR)/vmware_backdoors.flat
 tests += $(TEST_DIR)/rdpru.flat
+tests += $(TEST_DIR)/pks.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/x86/pks.c b/x86/pks.c
new file mode 100644
index 0000000..a3044cf
--- /dev/null
+++ b/x86/pks.c
@@ -0,0 +1,146 @@
+#include "libcflat.h"
+#include "x86/desc.h"
+#include "x86/processor.h"
+#include "x86/vm.h"
+#include "x86/msr.h"
+
+#define CR0_WP_MASK      (1UL << 16)
+#define PTE_PKEY_BIT     59
+#define SUPER_BASE        (1 << 24)
+#define SUPER_VAR(v)      (*((__typeof__(&(v))) (((unsigned long)&v) + SUPER_BASE)))
+
+volatile int pf_count = 0;
+volatile unsigned save;
+volatile unsigned test;
+
+static void set_cr0_wp(int wp)
+{
+    unsigned long cr0 = read_cr0();
+
+    cr0 &= ~CR0_WP_MASK;
+    if (wp)
+        cr0 |= CR0_WP_MASK;
+    write_cr0(cr0);
+}
+
+void do_pf_tss(unsigned long error_code);
+void do_pf_tss(unsigned long error_code)
+{
+    printf("#PF handler, error code: 0x%lx\n", error_code);
+    pf_count++;
+    save = test;
+    wrmsr(MSR_IA32_PKRS, 0);
+}
+
+extern void pf_tss(void);
+
+asm ("pf_tss: \n\t"
+#ifdef __x86_64__
+    // no task on x86_64, save/restore caller-save regs
+    "push %rax; push %rcx; push %rdx; push %rsi; push %rdi\n"
+    "push %r8; push %r9; push %r10; push %r11\n"
+    "mov 9*8(%rsp), %rdi\n"
+#endif
+    "call do_pf_tss \n\t"
+#ifdef __x86_64__
+    "pop %r11; pop %r10; pop %r9; pop %r8\n"
+    "pop %rdi; pop %rsi; pop %rdx; pop %rcx; pop %rax\n"
+#endif
+    "add $"S", %"R "sp\n\t" // discard error code
+    "iret"W" \n\t"
+    "jmp pf_tss\n\t"
+    );
+
+static void init_test(void)
+{
+    pf_count = 0;
+
+    invlpg(&test);
+    invlpg(&SUPER_VAR(test));
+    wrmsr(MSR_IA32_PKRS, 0);
+    set_cr0_wp(0);
+}
+
+int main(int ac, char **av)
+{
+    unsigned long i;
+    unsigned int pkey = 0x2;
+    unsigned int pkrs_ad = 0x10;
+    unsigned int pkrs_wd = 0x20;
+
+    if (!this_cpu_has(X86_FEATURE_PKS)) {
+        printf("PKS not enabled\n");
+        return report_summary();
+    }
+
+    setup_vm();
+    setup_alt_stack();
+    set_intr_alt_stack(14, pf_tss);
+    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_LMA);
+
+    // First 16MB are user pages
+    for (i = 0; i < SUPER_BASE; i += PAGE_SIZE) {
+        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) |= ((unsigned long)pkey << PTE_PKEY_BIT);
+        invlpg((void *)i);
+    }
+
+    // Present the same 16MB as supervisor pages in the 16MB-32MB range
+    for (i = SUPER_BASE; i < 2 * SUPER_BASE; i += PAGE_SIZE) {
+        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~SUPER_BASE;
+        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~PT_USER_MASK;
+        *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) |= ((unsigned long)pkey << PTE_PKEY_BIT);
+        invlpg((void *)i);
+    }
+
+    write_cr4(read_cr4() | X86_CR4_PKS);
+    write_cr3(read_cr3());
+
+    init_test();
+    set_cr0_wp(1);
+    wrmsr(MSR_IA32_PKRS, pkrs_ad);
+    SUPER_VAR(test) = 21;
+    report(pf_count == 1 && test == 21 && save == 0,
+           "write to supervisor page when pkrs is ad and wp == 1");
+
+    init_test();
+    set_cr0_wp(0);
+    wrmsr(MSR_IA32_PKRS, pkrs_ad);
+    SUPER_VAR(test) = 22;
+    report(pf_count == 1 && test == 22 && save == 21,
+           "write to supervisor page when pkrs is ad and wp == 0");
+
+    init_test();
+    set_cr0_wp(1);
+    wrmsr(MSR_IA32_PKRS, pkrs_wd);
+    SUPER_VAR(test) = 23;
+    report(pf_count == 1 && test == 23 && save == 22,
+           "write to supervisor page when pkrs is wd and wp == 1");
+
+    init_test();
+    set_cr0_wp(0);
+    wrmsr(MSR_IA32_PKRS, pkrs_wd);
+    SUPER_VAR(test) = 24;
+    report(pf_count == 0 && test == 24,
+           "write to supervisor page when pkrs is wd and wp == 0");
+
+    init_test();
+    set_cr0_wp(0);
+    wrmsr(MSR_IA32_PKRS, pkrs_wd);
+    test = 25;
+    report(pf_count == 0 && test == 25,
+           "write to user page when pkrs is wd and wp == 0");
+
+    init_test();
+    set_cr0_wp(1);
+    wrmsr(MSR_IA32_PKRS, pkrs_wd);
+    test = 26;
+    report(pf_count == 0 && test == 26,
+           "write to user page when pkrs is wd and wp == 1");
+
+    init_test();
+    wrmsr(MSR_IA32_PKRS, pkrs_ad);
+    (void)((__typeof__(&(test))) (((unsigned long)&test)));
+    report(pf_count == 0, "read from user page when pkrs is ad");
+
+    return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3a79151..b75419e 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -127,6 +127,11 @@ file = pku.flat
 arch = x86_64
 extra_params = -cpu host
 
+[pks]
+file = pks.flat
+arch = x86_64
+extra_params = -cpu host
+
 [asyncpf]
 file = asyncpf.flat
 extra_params = -m 2048
-- 
2.17.1

