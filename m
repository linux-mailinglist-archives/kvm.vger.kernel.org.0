Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9641C6B66
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgEFIUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:20:08 -0400
Received: from mga12.intel.com ([192.55.52.136]:35429 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgEFITz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 04:19:55 -0400
IronPort-SDR: VqJKZEEzcdj1YgKSpINlDgDJJq2b3p91DsXx7MFsjzKuz2T8/jpkWIKB/ocVHJhoxD6IA8YKj+
 2T75cRtCPCOA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 01:19:54 -0700
IronPort-SDR: yli7e7APvdlvEK0vLCZxya489KoOSZC+VfTXK7gDuEQWGG7ScvFsgcaEI6a3yXTdty0DygbAF2
 ImdOjSbG6S8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="260030142"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 01:19:52 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [kvm-unit-tests PATCH v2] x86: Add test cases for user-mode CET validation
Date:   Wed,  6 May 2020 16:21:10 +0800
Message-Id: <20200506082110.25441-12-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This unit test is intended to test user-mode CET support of KVM,
it's tested on Intel new platform. Two CET features: Shadow Stack
Protection(SHSTK) and Indirect-Branch Tracking(IBT) are enclosed.

In SHSTK test, if the function return-address in normal stack is
tampered with a value not equal to the one on shadow-stack, #CP
(Control Protection Exception)will generated on function returning.
This feature is supported by processor itself, no compiler/link
option is required.

However, to enabled IBT, we need to add -fcf-protection=full in
compiler options, this makes the compiler insert endbr64 at the
very beginning of each jmp/call target given the binary is for
x86_64.

To get PASS results, the following conditions must be met:
1) The processor is powered with CET feature.
2) The kernel is patched with the latest CET kernel patches.
3) The KVM and QEMU are patched with the latest CET patches.
4) Use CET-enabled gcc to compile the test app.

v2:
- Removed extra dependency on test framework for user/kernel mode switch.
- Directly set #CP handler instead of through TSS.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 lib/x86/desc.c      |   2 +
 lib/x86/msr.h       |   2 +
 lib/x86/processor.h |   3 +
 x86/Makefile.common |   3 +-
 x86/Makefile.x86_64 |   3 +-
 x86/cet.c           | 205 ++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg   |   6 ++
 7 files changed, 222 insertions(+), 2 deletions(-)
 create mode 100644 x86/cet.c

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 451f504..983d4d8 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -179,6 +179,7 @@ EX(mf, 16);
 EX_E(ac, 17);
 EX(mc, 18);
 EX(xm, 19);
+EX_E(cp, 21);
 
 asm (".pushsection .text \n\t"
      "__handle_exception: \n\t"
@@ -224,6 +225,7 @@ static void *idt_handlers[32] = {
 	[17] = &ac_fault,
 	[18] = &mc_fault,
 	[19] = &xm_fault,
+	[21] = &cp_fault,
 };
 
 void setup_idt(void)
diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 8dca964..98489e0 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -208,6 +208,8 @@
 #define MSR_IA32_EBL_CR_POWERON		0x0000002a
 #define MSR_IA32_FEATURE_CONTROL        0x0000003a
 #define MSR_IA32_TSC_ADJUST		0x0000003b
+#define MSR_IA32_U_CET                  0x000006a0
+#define MSR_IA32_PL3_SSP                0x000006a7
 
 #define FEATURE_CONTROL_LOCKED				(1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 03fdf64..5763d62 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -44,6 +44,7 @@
 #define X86_CR4_SMEP   0x00100000
 #define X86_CR4_SMAP   0x00200000
 #define X86_CR4_PKE    0x00400000
+#define X86_CR4_CET    0x00800000
 
 #define X86_EFLAGS_CF    0x00000001
 #define X86_EFLAGS_FIXED 0x00000002
@@ -149,8 +150,10 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_PKU			(CPUID(0x7, 0, ECX, 3))
 #define	X86_FEATURE_LA57		(CPUID(0x7, 0, ECX, 16))
 #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
+#define	X86_FEATURE_SHSTK		(CPUID(0x7, 0, ECX, 7))
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
+#define	X86_FEATURE_IBT			(CPUID(0x7, 0, EDX, 20))
 #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
 #define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
 
diff --git a/x86/Makefile.common b/x86/Makefile.common
index ab67ca0..c5b4d2c 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -58,7 +58,8 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
                $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
                $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
                $(TEST_DIR)/hyperv_connections.flat \
-               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
+               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat \
+               $(TEST_DIR)/cet.flat
 
 test_cases: $(tests-common) $(tests)
 
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 010102b..43d9706 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -1,7 +1,7 @@
 cstart.o = $(TEST_DIR)/cstart64.o
 bits = 64
 ldarch = elf64-x86-64
-COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2
+COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 -fcf-protection=full
 
 cflatobjs += lib/x86/setjmp64.o
 cflatobjs += lib/x86/intel-iommu.o
@@ -20,6 +20,7 @@ tests += $(TEST_DIR)/tscdeadline_latency.flat
 tests += $(TEST_DIR)/intel-iommu.flat
 tests += $(TEST_DIR)/vmware_backdoors.flat
 tests += $(TEST_DIR)/rdpru.flat
+tests += $(TEST_DIR)/cet.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/x86/cet.c b/x86/cet.c
new file mode 100644
index 0000000..22adb65
--- /dev/null
+++ b/x86/cet.c
@@ -0,0 +1,205 @@
+
+#include "libcflat.h"
+#include "x86/desc.h"
+#include "x86/processor.h"
+#include "x86/vm.h"
+#include "x86/msr.h"
+#include "vmalloc.h"
+#include "alloc_page.h"
+#include "fault_test.h"
+
+
+static unsigned char user_stack[0x400];
+static unsigned long rbx, rsi, rdi, rsp, rbp, r8, r9,
+		     r10, r11, r12, r13, r14, r15;
+
+static unsigned long expected_rip;
+static int cp_count;
+typedef u64 (*cet_test_func)(void);
+
+cet_test_func func;
+
+static u64 cet_shstk_func(void)
+{
+	unsigned long *ret_addr, *ssp;
+
+	asm volatile ("rdsspq %0" : "=r"(ssp));
+	asm("movq %%rbp,%0" : "=r"(ret_addr));
+	printf("The return-address in shadow-stack = 0x%lx, in normal stack = 0x%lx\n",
+	       *ssp, *(ret_addr + 1));
+
+	/*
+	 * In below line, it modifies the return address, it'll trigger #CP
+	 * while function is returning. The error-code is 0x1, meaning it's
+	 * caused by a near RET instruction, and the execution is terminated
+	 * when HW detects the violation.
+	 */
+	printf("Try to temper the return-address, this causes #CP on returning...\n");
+	*(ret_addr + 1) = 0xdeaddead;
+
+	return 0;
+}
+
+static u64 cet_ibt_func(void)
+{
+	/*
+	 * In below assembly code, the first instruction at lable 2 is not
+	 * endbr64, it'll trigger #CP with error code 0x3, and the execution
+	 * is terminated when HW detects the violation.
+	 */
+	printf("No endbr64 instruction at jmp target, this triggers #CP...\n");
+	asm volatile ("movq $2, %rcx\n"
+		      "dec %rcx\n"
+		      "leaq 2f, %rax\n"
+		      "jmp *%rax \n"
+		      "2:\n"
+		      "dec %rcx\n");
+	return 0;
+}
+
+void test_func(void);
+void test_func(void) {
+	asm volatile (
+			/* IRET into user mode */
+			"pushq %[user_ds]\n\t"
+			"pushq %[user_stack_top]\n\t"
+			"pushfq\n\t"
+			"pushq %[user_cs]\n\t"
+			"pushq $user_mode\n\t"
+			"iretq\n"
+
+			"user_mode:\n\t"
+			"call *%[func]\n\t"
+			::
+			[func]"m"(func),
+			[user_ds]"i"(USER_DS),
+			[user_cs]"i"(USER_CS),
+			[user_stack_top]"r"(user_stack +
+					sizeof(user_stack)));
+}
+
+#define SAVE_REGS() \
+	asm ("movq %%rbx, %0\t\n"  \
+	     "movq %%rsi, %1\t\n"  \
+	     "movq %%rdi, %2\t\n"  \
+	     "movq %%rsp, %3\t\n"  \
+	     "movq %%rbp, %4\t\n"  \
+	     "movq %%r8, %5\t\n"   \
+	     "movq %%r9, %6\t\n"   \
+	     "movq %%r10, %7\t\n"  \
+	     "movq %%r11, %8\t\n"  \
+	     "movq %%r12, %9\t\n"  \
+	     "movq %%r13, %10\t\n" \
+	     "movq %%r14, %11\t\n" \
+	     "movq %%r15, %12\t\n" :: \
+	     "m"(rbx), "m"(rsi), "m"(rdi), "m"(rsp), "m"(rbp), \
+	     "m"(r8), "m"(r9), "m"(r10),  "m"(r11), "m"(r12),  \
+	     "m"(r13), "m"(r14), "m"(r15));
+
+#define RESTOR_REGS() \
+	asm ("movq %0, %%rbx\t\n"  \
+	     "movq %1, %%rsi\t\n"  \
+	     "movq %2, %%rdi\t\n"  \
+	     "movq %3, %%rsp\t\n"  \
+	     "movq %4, %%rbp\t\n"  \
+	     "movq %5, %%r8\t\n"   \
+	     "movq %6, %%r9\t\n"   \
+	     "movq %7, %%r10\t\n"  \
+	     "movq %8, %%r11\t\n"  \
+	     "movq %9, %%r12\t\n"  \
+	     "movq %10, %%r13\t\n" \
+	     "movq %11, %%r14\t\n" \
+	     "movq %12, %%r15\t\n" ::\
+	     "m"(rbx), "m"(rsi), "m"(rdi), "m"(rsp), "m"(rbp), \
+	     "m"(r8), "m"(r9), "m"(r10), "m"(r11), "m"(r12),   \
+	     "m"(r13), "m"(r14), "m"(r15));
+
+#define RUN_TEST() \
+	do {		\
+		SAVE_REGS();    \
+		asm volatile ("pushq %%rax\t\n"           \
+			      "leaq 1f(%%rip), %%rax\t\n" \
+			      "movq %%rax, %0\t\n"        \
+			      "popq %%rax\t\n"            \
+			      "call test_func\t\n"         \
+			      "1:" ::"m"(expected_rip) : "rax", "rdi"); \
+		RESTOR_REGS(); \
+	} while (0)
+
+#define ENABLE_SHSTK_BIT 0x1
+#define ENABLE_IBT_BIT   0x4
+
+static void handle_cp(struct ex_regs *regs)
+{
+	cp_count++;
+	printf("In #CP exception handler, error_code = 0x%lx\n",
+		regs->error_code);
+	asm("jmp *%0" :: "m"(expected_rip));
+}
+
+int main(int ac, char **av)
+{
+	char *shstk_virt;
+	unsigned long shstk_phys;
+	unsigned long *ptep;
+	pteval_t pte = 0;
+
+	cp_count = 0;
+	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
+		printf("SHSTK not enabled\n");
+		return report_summary();
+	}
+
+	if (!this_cpu_has(X86_FEATURE_IBT)) {
+		printf("IBT not enabled\n");
+		return report_summary();
+	}
+
+	setup_vm();
+	setup_idt();
+	handle_exception(21, handle_cp);
+
+	/* Allocate one page for shadow-stack. */
+	shstk_virt = alloc_vpage();
+	shstk_phys = (unsigned long)virt_to_phys(alloc_page());
+
+	/* Install the new page. */
+	pte = shstk_phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+	install_pte(current_page_table(), 1, shstk_virt, pte, 0);
+	memset(shstk_virt, 0x0, PAGE_SIZE);
+
+	/* Mark it as shadow-stack page. */
+	ptep = get_pte_level(current_page_table(), shstk_virt, 1);
+	*ptep &= ~PT_WRITABLE_MASK;
+	*ptep |= PT_DIRTY_MASK;
+
+	/* Flush the paging cache. */
+	invlpg((void *)shstk_phys);
+
+	/* Enable shadow-stack protection */
+	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
+
+	/* Store shadow-stack pointer. */
+	wrmsr(MSR_IA32_PL3_SSP, (u64)(shstk_virt + 0x1000));
+
+	/* Enable CET master control bit in CR4. */
+	write_cr4(read_cr4() | X86_CR4_CET);
+
+	func = cet_shstk_func;
+	RUN_TEST();
+	report(cp_count == 1, "Completed shadow-stack protection test successfully.");
+	cp_count = 0;
+
+	/* Do user-mode indirect-branch-tracking test.*/
+	func = cet_ibt_func;
+	/* Enable indirect-branch tracking */
+	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
+
+	RUN_TEST();
+	report(cp_count == 1, "Completed Indirect-branch tracking test successfully.");
+
+	write_cr4(read_cr4() & ~X86_CR4_CET);
+	wrmsr(MSR_IA32_U_CET, 0);
+
+	return report_summary();
+}
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f2401eb..87d412f 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -346,3 +346,9 @@ extra_params = -M q35,kernel-irqchip=split -device intel-iommu,intremap=on,eim=o
 file = tsx-ctrl.flat
 extra_params = -cpu host
 groups = tsx-ctrl
+
+[intel_cet]
+file = cet.flat
+arch = x86_64
+smp = 2
+extra_params = -enable-kvm -m 2048 -cpu host
-- 
2.17.2

