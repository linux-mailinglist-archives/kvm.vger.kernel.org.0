Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8FAC313F
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbfJAKYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:24:00 -0400
Received: from foss.arm.com ([217.140.110.172]:46012 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbfJAKYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:24:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B65B01596;
        Tue,  1 Oct 2019 03:23:58 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6063C3F739;
        Tue,  1 Oct 2019 03:23:57 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests RFC PATCH v2 14/19] lib: arm64: Run existing tests at EL2
Date:   Tue,  1 Oct 2019 11:23:18 +0100
Message-Id: <20191001102323.27628-15-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 8.3 of the ARM architecture added support for nested
virtualization. KVM supports both VHE and non-VHE guest hypervisors running
at virtual EL2. To make the changes as minimal as possible, kvm-unit-tests
will run as a VHE guest hypervisor when booted at EL2.

To distinguish between a L1 non-VHE host calling from EL1 into the L1
hypervisor running at EL2 and a PSCI call, KVM sets the PSCI conduit for
guests that boot at EL2 to the SMC instruction. Modify existing tests to
take that into account.

Nested virtualization is enabled only for arm64 guests using GICv3 and
existing tests have been modified to run at EL2.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Changes:
* Added an expected_level variable to the selftest test.

Prefetch abort injection is broken with version v1 of the NV patches; to
run the abort test, I use the following patch:

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index fac962b467bd..3747a31feefc 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -53,15 +53,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 {
        unsigned long cpsr = *vcpu_cpsr(vcpu);
        bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
-       u32 esr = 0;
-
-       vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
-       *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
-
-       *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
-       vcpu_write_spsr(vcpu, cpsr);
-
-       vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
+       u32 esr = ESR_ELx_FSC_EXTABT;
 
        /*
         * Build an {i,d}abort, depending on the level and the
@@ -82,7 +74,20 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
        if (!is_iabt)
                esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
-       vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
+       if (is_hyp_ctxt(vcpu)) {
+               kvm_inject_nested_sync(vcpu, esr);
+               return;
+       }
+
+       vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+
+       vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
+       *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
+
+       *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
+       vcpu_write_spsr(vcpu, cpsr);
+
+       vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
 }
 
 static void inject_undef64(struct kvm_vcpu *vcpu)
@@ -103,7 +108,18 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
        if (kvm_vcpu_trap_il_is32bit(vcpu))
                esr |= ESR_ELx_IL;
 
+       if (is_hyp_ctxt(vcpu)) {
+               kvm_inject_nested_sync(vcpu, esr);
+               return;
+       }
+
        vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
+
+       vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
+       *vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
+
+       *vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
+       vcpu_write_spsr(vcpu, cpsr);
 }
 
 /**

 lib/arm/asm/psci.h        |   1 +
 lib/arm64/asm/esr.h       |   2 +
 lib/arm64/asm/processor.h |   5 ++
 lib/arm64/asm/sysreg.h    |  20 ++++++
 lib/arm/psci.c            |  43 ++++++++++++-
 lib/arm/setup.c           |   4 ++
 lib/arm64/processor.c     |   2 +
 arm/cstart64.S            |  28 +++++++++
 arm/micro-bench.c         |  17 ++++-
 arm/selftest.c            |  41 +++++++++---
 arm/timer.c               | 127 +++++++++++++++++++++++++++++++++-----
 11 files changed, 261 insertions(+), 29 deletions(-)

diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
index 7b956bf5987d..2ed6613fe5ea 100644
--- a/lib/arm/asm/psci.h
+++ b/lib/arm/asm/psci.h
@@ -3,6 +3,7 @@
 #include <libcflat.h>
 #include <linux/psci.h>
 
+extern void psci_init(void);
 extern int psci_invoke(unsigned long function_id, unsigned long arg0,
 		       unsigned long arg1, unsigned long arg2);
 extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
diff --git a/lib/arm64/asm/esr.h b/lib/arm64/asm/esr.h
index 8c351631b0a0..6d4f572923f2 100644
--- a/lib/arm64/asm/esr.h
+++ b/lib/arm64/asm/esr.h
@@ -25,6 +25,8 @@
 #define ESR_EL1_EC_ILL_ISS	(0x0E)
 #define ESR_EL1_EC_SVC32	(0x11)
 #define ESR_EL1_EC_SVC64	(0x15)
+#define ESR_EL2_EC_HVC64	(0x16)
+#define ESR_EL2_EC_SMC64	(0x17)
 #define ESR_EL1_EC_SYS64	(0x18)
 #define ESR_EL1_EC_IABT_EL0	(0x20)
 #define ESR_EL1_EC_IABT_EL1	(0x21)
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index fd508c02f30d..7e9f76d73f1b 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -6,6 +6,8 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 
+#include <linux/const.h>
+
 /* System Control Register (SCTLR_EL1) bits */
 #define SCTLR_EL1_EE	(1 << 25)
 #define SCTLR_EL1_WXN	(1 << 19)
@@ -16,6 +18,9 @@
 #define SCTLR_EL1_A	(1 << 1)
 #define SCTLR_EL1_M	(1 << 0)
 
+#define HCR_EL2_TGE	(1 << 27)
+#define HCR_EL2_E2H	(_UL(1) << 34)
+
 #define CTR_EL0_DMINLINE_SHIFT	16
 #define CTR_EL0_DMINLINE_MASK	(0xf << 16)
 #define CTR_EL0_DMINLINE(x)	\
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index a03830bceb8f..ed407f93330d 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -11,6 +11,14 @@
 #define sys_reg(op0, op1, crn, crm, op2) \
 	((((op0)&3)<<19)|((op1)<<16)|((crn)<<12)|((crm)<<8)|((op2)<<5))
 
+#define SYS_CNTP_TVAL_EL02	sys_reg(3, 5, 14, 2, 0)
+#define SYS_CNTP_CTL_EL02	sys_reg(3, 5, 14, 2, 1)
+#define SYS_CNTP_CVAL_EL02	sys_reg(3, 5, 14, 2, 2)
+
+#define SYS_CNTV_TVAL_EL02	sys_reg(3, 5, 14, 3, 0)
+#define SYS_CNTV_CTL_EL02	sys_reg(3, 5, 14, 3, 1)
+#define SYS_CNTV_CVAL_EL02	sys_reg(3, 5, 14, 3, 2)
+
 #ifdef __ASSEMBLY__
 	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
 	.equ	.L__reg_num_x\num, \num
@@ -52,5 +60,17 @@ asm(
 "	.inst	0xd5000000|(\\sreg)|(.L__reg_num_\\rt)\n"
 "	.endm\n"
 );
+
+#define read_sysreg_s(r) ({					\
+	u64 __val;						\
+	asm volatile("mrs_s %0, " xstr(r) :  "=r" (__val));	\
+	__val;							\
+})
+
+#define write_sysreg_s(v, r) do {				\
+	u64 __val = (u64)v;					\
+	asm volatile("msr_s " xstr(r) ", %x0" : : "rZ" (__val));\
+} while (0)
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASMARM64_SYSREG_H_ */
diff --git a/lib/arm/psci.c b/lib/arm/psci.c
index 936c83948b6a..f0c571cfc5a3 100644
--- a/lib/arm/psci.c
+++ b/lib/arm/psci.c
@@ -11,8 +11,10 @@
 #include <asm/page.h>
 #include <asm/smp.h>
 
-__attribute__((noinline))
-int psci_invoke(unsigned long function_id, unsigned long arg0,
+static int (*psci_fn)(unsigned long, unsigned long, unsigned long,
+		unsigned long);
+
+static int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
 		unsigned long arg1, unsigned long arg2)
 {
 	asm volatile(
@@ -22,13 +24,48 @@ int psci_invoke(unsigned long function_id, unsigned long arg0,
 	return function_id;
 }
 
+#ifdef __arm__
+void psci_init(void)
+{
+	psci_fn = &psci_invoke_hvc;
+}
+
 int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
 {
-#ifdef __arm__
 	return psci_invoke(PSCI_0_2_FN_CPU_ON, cpuid, entry_point, 0);
+}
 #else
+static int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
+		unsigned long arg1, unsigned long arg2)
+{
+	asm volatile(
+		"smc #0"
+	: "+r" (function_id)
+	: "r" (arg0), "r" (arg1), "r" (arg2));
+	return function_id;
+}
+
+void psci_init(void)
+{
+	if (current_level() == CurrentEL_EL2)
+		psci_fn = &psci_invoke_smc;
+	else
+		psci_fn = &psci_invoke_hvc;
+}
+
+int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
+{
 	return psci_invoke(PSCI_0_2_FN64_CPU_ON, cpuid, entry_point, 0);
+}
 #endif
+
+int psci_invoke(unsigned long function_id, unsigned long arg0,
+		unsigned long arg1, unsigned long arg2)
+{
+	/* Oh-oh, some went wrong */
+	if (!psci_fn)
+		psci_init();
+	return psci_fn(function_id, arg0, arg1, arg2);
 }
 
 extern void secondary_entry(void);
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 54fc19a20942..2f23cb07f4fc 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -21,6 +21,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/processor.h>
+#include <asm/psci.h>
 #include <asm/smp.h>
 
 #include "io.h"
@@ -129,6 +130,9 @@ void setup(const void *fdt)
 	u32 fdt_size;
 	int ret;
 
+	/* make sure PSCI calls work as soon as possible */
+	psci_init();
+
 	/*
 	 * Before calling mem_init we need to move the fdt and initrd
 	 * to safe locations. We move them to construct the memory
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index f28066d40145..2030a7a09107 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -42,6 +42,8 @@ static const char *ec_names[EC_MAX] = {
 	[ESR_EL1_EC_ILL_ISS]		= "ILL_ISS",
 	[ESR_EL1_EC_SVC32]		= "SVC32",
 	[ESR_EL1_EC_SVC64]		= "SVC64",
+	[ESR_EL2_EC_HVC64]		= "HVC64",
+	[ESR_EL2_EC_SMC64]		= "SMC64",
 	[ESR_EL1_EC_SYS64]		= "SYS64",
 	[ESR_EL1_EC_IABT_EL0]		= "IABT_EL0",
 	[ESR_EL1_EC_IABT_EL1]		= "IABT_EL1",
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 87bf873795a1..acf86eb6089e 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -51,6 +51,17 @@ start:
 	add	x5, x5, #24
 	b	1b
 
+1:
+	mrs	x4, CurrentEL
+	cmp	x4, CurrentEL_EL2
+	b.ne 	1f
+	mrs	x4, mpidr_el1
+	msr	vmpidr_el2, x4
+	mrs	x4, midr_el1
+	msr	vpidr_el2, x4
+	ldr	x4, =(HCR_EL2_TGE | HCR_EL2_E2H)
+	msr	hcr_el2, x4
+	isb
 1:
 	/* set up stack */
 	mov	x4, #1
@@ -102,6 +113,17 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
+	mrs	x0, CurrentEL
+	cmp	x0, CurrentEL_EL2
+	b.ne 	1f
+	mrs	x0, mpidr_el1
+	msr	vmpidr_el2, x0
+	mrs	x0, midr_el1
+	msr	vpidr_el2, x0
+	ldr	x0, =(HCR_EL2_TGE | HCR_EL2_E2H)
+	msr	hcr_el2, x0
+	isb
+1:
 	/* Enable FP/ASIMD */
 	mov	x0, #(3 << 20)
 	msr	cpacr_el1, x0
@@ -132,6 +154,12 @@ secondary_entry:
 .globl asm_cpu_psci_cpu_die
 asm_cpu_psci_cpu_die:
 	ldr	x0, =PSCI_0_2_FN_CPU_OFF
+	mrs	x9, CurrentEL
+	cmp	x9, CurrentEL_EL2
+	b.ne	1f
+	smc	#0
+	b	halt
+1:
 	hvc	#0
 	b	.
 
diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 4612f41001c2..5469667ddfe8 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -112,6 +112,11 @@ static void hvc_exec(void)
 	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
 }
 
+static void smc_exec(void)
+{
+	asm volatile("mov w0, #0x4b000000; smc #0" ::: "w0");
+}
+
 static void mmio_read_user_exec(void)
 {
 	/*
@@ -138,6 +143,8 @@ static void eoi_exec(void)
 	write_eoir(spurious_id);
 }
 
+static void exec_select(void);
+
 struct exit_test {
 	const char *name;
 	void (*prep)(void);
@@ -146,13 +153,21 @@ struct exit_test {
 };
 
 static struct exit_test tests[] = {
-	{"hvc",			NULL,		hvc_exec,		true},
+	{"hyp_call",		exec_select,	hvc_exec,		true},
 	{"mmio_read_user",	NULL,		mmio_read_user_exec,	true},
 	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
 	{"eoi",			NULL,		eoi_exec,		true},
 	{"ipi",			ipi_prep,	ipi_exec,		true},
 };
 
+static void exec_select(void)
+{
+	if (current_level() == CurrentEL_EL2)
+		tests[0].exec = &smc_exec;
+	else
+		tests[0].exec = &hvc_exec;
+}
+
 struct ns_time {
 	uint64_t ns;
 	uint64_t ns_frac;
diff --git a/arm/selftest.c b/arm/selftest.c
index cdf2d1f2badb..68dd34e59f3d 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -210,6 +210,7 @@ static void check_pabt(void)
 	__builtin_unreachable();
 }
 #elif defined(__aarch64__)
+static unsigned long expected_level;
 
 /*
  * Capture the current register state and execute an instruction
@@ -256,8 +257,7 @@ static bool check_regs(struct pt_regs *regs)
 {
 	unsigned i;
 
-	/* exception handlers should always run in EL1 */
-	if (current_level() != CurrentEL_EL1)
+	if (current_level() != expected_level)
 		return false;
 
 	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
@@ -275,13 +275,14 @@ static bool check_regs(struct pt_regs *regs)
 
 static enum vector check_vector_prep(void)
 {
-	unsigned long daif;
+	unsigned long daif, mode;
 
 	if (is_user())
 		return EL0_SYNC_64;
 
 	asm volatile("mrs %0, daif" : "=r" (daif) ::);
-	expected_regs.pstate = daif | PSR_MODE_EL1h;
+	mode = current_level() == CurrentEL_EL1 ? PSR_MODE_EL1h : PSR_MODE_EL2h;
+	expected_regs.pstate = daif | mode;
 	return EL1H_SYNC;
 }
 
@@ -297,8 +298,8 @@ static bool check_und(void)
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
 
-	/* try to read an el2 sysreg from el0/1 */
-	test_exception("", "mrs x0, sctlr_el2", "");
+	/* try to read an el3 sysreg from el0/1/2 */
+	test_exception("", "mrs x0, sctlr_el3", "");
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
 
@@ -385,6 +386,10 @@ static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
 
 static void check_vectors(void *arg __unused)
 {
+#ifdef __aarch64__
+	if (!is_user())
+		expected_level = current_level();
+#endif
 	report("und", check_und());
 	report("svc", check_svc());
 	if (!is_user()) {
@@ -416,11 +421,29 @@ static bool psci_check(void)
 		printf("bad psci device tree node\n");
 		return false;
 	}
+	if (len != 4) {
+		printf("bad psci method\n");
+		return false;
+	}
+
+#ifdef __arm__
+	if (strcmp(method->data, "hvc") != 0) {
+		printf("psci method must be hvc\n");
+		return false;
+	}
+#else
+	if (current_level() == CurrentEL_EL2 &&
+	    strcmp(method->data, "smc") != 0) {
+		printf("psci method must be smc\n");
+		return false;
+	}
 
-	if (len < 4 || strcmp(method->data, "hvc") != 0) {
+	if (current_level() == CurrentEL_EL1 &&
+	    strcmp(method->data, "hvc") != 0) {
 		printf("psci method must be hvc\n");
 		return false;
 	}
+#endif
 
 	ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
 	printf("PSCI version %d.%d\n", PSCI_VERSION_MAJOR(ver),
@@ -456,7 +479,9 @@ int main(int argc, char **argv)
 		check_vectors(NULL);
 
 	} else if (strcmp(argv[1], "vectors-user") == 0) {
-
+#if defined(__aarch64__)
+		expected_level = current_level();
+#endif
 		start_usr(check_vectors, NULL,
 				(unsigned long)thread_stack_alloc());
 
diff --git a/arm/timer.c b/arm/timer.c
index 125b9f30ad3c..29477ee65878 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -9,6 +9,7 @@
 #include <devicetree.h>
 #include <errata.h>
 #include <asm/processor.h>
+#include <asm/sysreg.h>
 #include <asm/gic.h>
 #include <asm/io.h>
 
@@ -63,6 +64,36 @@ static void write_vtimer_ctl(u64 val)
 	write_sysreg(val, cntv_ctl_el0);
 }
 
+static u64 read_vtimer_cval_vhe(void)
+{
+	return read_sysreg_s(SYS_CNTV_CVAL_EL02);
+}
+
+static void write_vtimer_cval_vhe(u64 val)
+{
+	write_sysreg_s(val, SYS_CNTV_CVAL_EL02);
+}
+
+static s32 read_vtimer_tval_vhe(void)
+{
+	return read_sysreg_s(SYS_CNTV_TVAL_EL02);
+}
+
+static void write_vtimer_tval_vhe(s32 val)
+{
+	write_sysreg_s(val, SYS_CNTV_TVAL_EL02);
+}
+
+static u64 read_vtimer_ctl_vhe(void)
+{
+	return read_sysreg_s(SYS_CNTV_CTL_EL02);
+}
+
+static void write_vtimer_ctl_vhe(u64 val)
+{
+	write_sysreg_s(val, SYS_CNTV_CTL_EL02);
+}
+
 static u64 read_ptimer_counter(void)
 {
 	return read_sysreg(cntpct_el0);
@@ -98,6 +129,36 @@ static void write_ptimer_ctl(u64 val)
 	write_sysreg(val, cntp_ctl_el0);
 }
 
+static u64 read_ptimer_cval_vhe(void)
+{
+	return read_sysreg_s(SYS_CNTP_CVAL_EL02);
+}
+
+static void write_ptimer_cval_vhe(u64 val)
+{
+	write_sysreg_s(val, SYS_CNTP_CVAL_EL02);
+}
+
+static s32 read_ptimer_tval_vhe(void)
+{
+	return read_sysreg_s(SYS_CNTP_TVAL_EL02);
+}
+
+static void write_ptimer_tval_vhe(s32 val)
+{
+	write_sysreg_s(val, SYS_CNTP_TVAL_EL02);
+}
+
+static u64 read_ptimer_ctl_vhe(void)
+{
+	return read_sysreg_s(SYS_CNTP_CTL_EL02);
+}
+
+static void write_ptimer_ctl_vhe(u64 val)
+{
+	write_sysreg_s(val, SYS_CNTP_CTL_EL02);
+}
+
 struct timer_info {
 	u32 irq;
 	u32 irq_flags;
@@ -133,6 +194,30 @@ static struct timer_info ptimer_info = {
 	.write_ctl = write_ptimer_ctl,
 };
 
+static struct timer_info vtimer_info_vhe = {
+	.irq_received = false,
+	.read_counter = read_vtimer_counter,
+	.read_cval = read_vtimer_cval_vhe,
+	.write_cval = write_vtimer_cval_vhe,
+	.read_tval = read_vtimer_tval_vhe,
+	.write_tval = write_vtimer_tval_vhe,
+	.read_ctl = read_vtimer_ctl_vhe,
+	.write_ctl = write_vtimer_ctl_vhe,
+};
+
+static struct timer_info ptimer_info_vhe = {
+	.irq_received = false,
+	.read_counter = read_ptimer_counter,
+	.read_cval = read_ptimer_cval_vhe,
+	.write_cval = write_ptimer_cval_vhe,
+	.read_tval = read_ptimer_tval_vhe,
+	.write_tval = write_ptimer_tval_vhe,
+	.read_ctl = read_ptimer_ctl_vhe,
+	.write_ctl = write_ptimer_ctl_vhe,
+};
+
+static struct timer_info *vtimer, *ptimer;
+
 static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
 {
 	u32 val = 1 << PPI(info->irq);
@@ -152,10 +237,10 @@ static void irq_handler(struct pt_regs *regs)
 	if (irqnr == GICC_INT_SPURIOUS)
 		return;
 
-	if (irqnr == PPI(vtimer_info.irq)) {
-		info = &vtimer_info;
-	} else if (irqnr == PPI(ptimer_info.irq)) {
-		info = &ptimer_info;
+	if (irqnr == PPI(vtimer->irq)) {
+		info = vtimer;
+	} else if (irqnr == PPI(ptimer->irq)) {
+		info = ptimer;
 	} else {
 		report_info("Unexpected interrupt: %d\n", irqnr);
 		return;
@@ -263,7 +348,7 @@ static void test_timer(struct timer_info *info)
 static void test_vtimer(void)
 {
 	report_prefix_push("vtimer-busy-loop");
-	test_timer(&vtimer_info);
+	test_timer(vtimer);
 	report_prefix_pop();
 }
 
@@ -273,7 +358,7 @@ static void test_ptimer(void)
 		return;
 
 	report_prefix_push("ptimer-busy-loop");
-	test_timer(&ptimer_info);
+	test_timer(ptimer);
 	report_prefix_pop();
 }
 
@@ -284,6 +369,14 @@ static void test_init(void)
 	int node, len;
 	u32 *data;
 
+	if (current_level() == CurrentEL_EL1) {
+		vtimer = &vtimer_info;
+		ptimer = &ptimer_info;
+	} else {
+		vtimer = &vtimer_info_vhe;
+		ptimer = &ptimer_info_vhe;
+	}
+
 	node = fdt_node_offset_by_compatible(fdt, -1, "arm,armv8-timer");
 	assert(node >= 0);
 	prop = fdt_get_property(fdt, node, "interrupts", &len);
@@ -291,14 +384,14 @@ static void test_init(void)
 
 	data = (u32 *)prop->data;
 	assert(fdt32_to_cpu(data[3]) == 1);
-	ptimer_info.irq = fdt32_to_cpu(data[4]);
-	ptimer_info.irq_flags = fdt32_to_cpu(data[5]);
+	ptimer->irq = fdt32_to_cpu(data[4]);
+	ptimer->irq_flags = fdt32_to_cpu(data[5]);
 	assert(fdt32_to_cpu(data[6]) == 1);
-	vtimer_info.irq = fdt32_to_cpu(data[7]);
-	vtimer_info.irq_flags = fdt32_to_cpu(data[8]);
+	vtimer->irq = fdt32_to_cpu(data[7]);
+	vtimer->irq_flags = fdt32_to_cpu(data[8]);
 
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
-	read_sysreg(cntp_ctl_el0);
+	ptimer->read_ctl();
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
 
 	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
@@ -332,14 +425,14 @@ static void print_timer_info(void)
 	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
 
 	if (!ptimer_unsupported){
-		printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
-		printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
-		printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
+		printf("CNTPCT_EL0   : 0x%016lx\n", ptimer->read_counter());
+		printf("CNTP_CTL_EL0 : 0x%016lx\n", ptimer->read_ctl());
+		printf("CNTP_CVAL_EL0: 0x%016lx\n", ptimer->read_cval());
 	}
 
-	printf("CNTVCT_EL0   : 0x%016lx\n", read_sysreg(cntvct_el0));
-	printf("CNTV_CTL_EL0 : 0x%016lx\n", read_sysreg(cntv_ctl_el0));
-	printf("CNTV_CVAL_EL0: 0x%016lx\n", read_sysreg(cntv_cval_el0));
+	printf("CNTVCT_EL0   : 0x%016lx\n", vtimer->read_counter());
+	printf("CNTV_CTL_EL0 : 0x%016lx\n", vtimer->read_ctl());
+	printf("CNTV_CVAL_EL0: 0x%016lx\n", vtimer->read_cval());
 }
 
 int main(int argc, char **argv)
-- 
2.20.1

