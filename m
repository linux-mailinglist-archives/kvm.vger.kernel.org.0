Return-Path: <kvm+bounces-7155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC9483DBB0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98ACF1F249C8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47871DA23;
	Fri, 26 Jan 2024 14:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YpG5V2VF"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932461D6A7
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279041; cv=none; b=mNZ8d3ZZrN1pGR6jQtpYLbO9LUXBbbWm6MwtB/FZYYhTUjsqaI36FaaEU+9K5qPSqXGUJDtU4aerlrnihNKfeGnOjcaAT5KEAv53Rv/i20tAOwvRfwH/LWiVQMsVQouRm3DVZkqP80q/AcxzmEsNqqdsiP78ht9/fKsEu7Q8VEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279041; c=relaxed/simple;
	bh=WBxUp/W1npM3k14vrv1t4k7WgCsn+qqOUPySHS4UWps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=E6wK0xtVeL6Odaf46WP4yt9muWKHsKzab6fbZUnxWR30fnVRXGAKhdtSfrdwlKuZAcTEtTZI+Ru19BrkxEBEEnP+rnVg70xOS4YHRY/6q6tvaI90GudMEOZk5lCxQKwFT1tiphXXUGVN2FqPKLr3Vn865Fx12zpVr6yqVNlmap0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YpG5V2VF; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XhO/mP8yJ9tQm34rh4KtXceEJ5K0gcIyIGz7YLkd4I=;
	b=YpG5V2VFyiy2GeQoBZ1YpK8ZNZCtrTuueM5YyRq4Cz8WWJhAwN2c6jjG9kuqOTSZrCzURy
	+yHqi47YsSVQzUAB3wlB33qpteslhgcB2U7cXWdcLYnP89GI5Q2m0eGCJ7Z2gpM2u6v+64
	z3toE4c1twTzUY6GUXJ9JSaHe5+w3VQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 09/24] riscv: Add exception handling
Date: Fri, 26 Jan 2024 15:23:34 +0100
Message-ID: <20240126142324.66674-35-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Steal more code from Linux to implement exception handling, but with
the same kvm-unit-tests API that Arm has. Also introduce struct
thread_info like Arm has in order to hold the handler pointers.
Finally, as usual, extend the selftest to make sure it all works.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/riscv/asm-offsets.c   |  38 +++++++++++++
 lib/riscv/asm/bug.h       |  20 +++++++
 lib/riscv/asm/csr.h       |  28 +++++++++
 lib/riscv/asm/processor.h |  28 +++++++++
 lib/riscv/asm/ptrace.h    |  46 +++++++++++++++
 lib/riscv/asm/setup.h     |   3 +-
 lib/riscv/processor.c     |  60 +++++++++++++++++++
 lib/riscv/setup.c         |   9 ++-
 riscv/Makefile            |   1 +
 riscv/cstart.S            | 117 +++++++++++++++++++++++++++++++++++++-
 riscv/selftest.c          |  20 ++++++-
 11 files changed, 362 insertions(+), 8 deletions(-)
 create mode 100644 lib/riscv/asm/bug.h
 create mode 100644 lib/riscv/asm/processor.h
 create mode 100644 lib/riscv/asm/ptrace.h
 create mode 100644 lib/riscv/processor.c

diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index eb337b7547b8..7b88d16fd0e4 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <kbuild.h>
 #include <elf.h>
+#include <asm/ptrace.h>
 
 int main(void)
 {
@@ -13,5 +14,42 @@ int main(void)
 	OFFSET(ELF_RELA_ADDEND, elf64_rela, r_addend);
 	DEFINE(ELF_RELA_SIZE, sizeof(struct elf64_rela));
 #endif
+	OFFSET(PT_EPC, pt_regs, epc);
+	OFFSET(PT_RA, pt_regs, ra);
+	OFFSET(PT_SP, pt_regs, sp);
+	OFFSET(PT_GP, pt_regs, gp);
+	OFFSET(PT_TP, pt_regs, tp);
+	OFFSET(PT_T0, pt_regs, t0);
+	OFFSET(PT_T1, pt_regs, t1);
+	OFFSET(PT_T2, pt_regs, t2);
+	OFFSET(PT_S0, pt_regs, s0);
+	OFFSET(PT_S1, pt_regs, s1);
+	OFFSET(PT_A0, pt_regs, a0);
+	OFFSET(PT_A1, pt_regs, a1);
+	OFFSET(PT_A2, pt_regs, a2);
+	OFFSET(PT_A3, pt_regs, a3);
+	OFFSET(PT_A4, pt_regs, a4);
+	OFFSET(PT_A5, pt_regs, a5);
+	OFFSET(PT_A6, pt_regs, a6);
+	OFFSET(PT_A7, pt_regs, a7);
+	OFFSET(PT_S2, pt_regs, s2);
+	OFFSET(PT_S3, pt_regs, s3);
+	OFFSET(PT_S4, pt_regs, s4);
+	OFFSET(PT_S5, pt_regs, s5);
+	OFFSET(PT_S6, pt_regs, s6);
+	OFFSET(PT_S7, pt_regs, s7);
+	OFFSET(PT_S8, pt_regs, s8);
+	OFFSET(PT_S9, pt_regs, s9);
+	OFFSET(PT_S10, pt_regs, s10);
+	OFFSET(PT_S11, pt_regs, s11);
+	OFFSET(PT_T3, pt_regs, t3);
+	OFFSET(PT_T4, pt_regs, t4);
+	OFFSET(PT_T5, pt_regs, t5);
+	OFFSET(PT_T6, pt_regs, t6);
+	OFFSET(PT_STATUS, pt_regs, status);
+	OFFSET(PT_BADADDR, pt_regs, badaddr);
+	OFFSET(PT_CAUSE, pt_regs, cause);
+	OFFSET(PT_ORIG_A0, pt_regs, orig_a0);
+	DEFINE(PT_SIZE, sizeof(struct pt_regs));
 	return 0;
 }
diff --git a/lib/riscv/asm/bug.h b/lib/riscv/asm/bug.h
new file mode 100644
index 000000000000..a6f4136ba1b6
--- /dev/null
+++ b/lib/riscv/asm/bug.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_BUG_H_
+#define _ASMRISCV_BUG_H_
+
+#ifndef __ASSEMBLY__
+
+static inline void bug(void)
+{
+	asm volatile("ebreak");
+}
+
+#else
+
+.macro bug
+	ebreak
+.endm
+
+#endif
+
+#endif /* _ASMRISCV_BUG_H_ */
diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 356ae054bfff..39ffd2a146be 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -3,7 +3,35 @@
 #define _ASMRISCV_CSR_H_
 #include <linux/const.h>
 
+#define CSR_SSTATUS		0x100
+#define CSR_STVEC		0x105
 #define CSR_SSCRATCH		0x140
+#define CSR_SEPC		0x141
+#define CSR_SCAUSE		0x142
+#define CSR_STVAL		0x143
+
+/* Exception cause high bit - is an interrupt if set */
+#define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
+
+/* Exception causes */
+#define EXC_INST_MISALIGNED	0
+#define EXC_INST_ACCESS		1
+#define EXC_INST_ILLEGAL	2
+#define EXC_BREAKPOINT		3
+#define EXC_LOAD_MISALIGNED	4
+#define EXC_LOAD_ACCESS		5
+#define EXC_STORE_MISALIGNED	6
+#define EXC_STORE_ACCESS	7
+#define EXC_SYSCALL		8
+#define EXC_HYPERVISOR_SYSCALL	9
+#define EXC_SUPERVISOR_SYSCALL	10
+#define EXC_INST_PAGE_FAULT	12
+#define EXC_LOAD_PAGE_FAULT	13
+#define EXC_STORE_PAGE_FAULT	15
+#define EXC_INST_GUEST_PAGE_FAULT	20
+#define EXC_LOAD_GUEST_PAGE_FAULT	21
+#define EXC_VIRTUAL_INST_FAULT		22
+#define EXC_STORE_GUEST_PAGE_FAULT	23
 
 #ifndef __ASSEMBLY__
 
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
new file mode 100644
index 000000000000..f20774d02d8e
--- /dev/null
+++ b/lib/riscv/asm/processor.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_PROCESSOR_H_
+#define _ASMRISCV_PROCESSOR_H_
+#include <asm/csr.h>
+#include <asm/ptrace.h>
+
+#define EXCEPTION_CAUSE_MAX	16
+
+typedef void (*exception_fn)(struct pt_regs *);
+
+struct thread_info {
+	int cpu;
+	unsigned long hartid;
+	exception_fn exception_handlers[EXCEPTION_CAUSE_MAX];
+};
+
+static inline struct thread_info *current_thread_info(void)
+{
+	return (struct thread_info *)csr_read(CSR_SSCRATCH);
+}
+
+void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *));
+void do_handle_exception(struct pt_regs *regs);
+void thread_info_init(void);
+
+void show_regs(struct pt_regs *regs);
+
+#endif /* _ASMRISCV_PROCESSOR_H_ */
diff --git a/lib/riscv/asm/ptrace.h b/lib/riscv/asm/ptrace.h
new file mode 100644
index 000000000000..0873a8ae749f
--- /dev/null
+++ b/lib/riscv/asm/ptrace.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_PTRACE_H_
+#define _ASMRISCV_PTRACE_H_
+
+struct pt_regs {
+	unsigned long epc;
+	unsigned long ra;
+	unsigned long sp;
+	unsigned long gp;
+	unsigned long tp;
+	unsigned long t0;
+	unsigned long t1;
+	unsigned long t2;
+	unsigned long s0;
+	unsigned long s1;
+	unsigned long a0;
+	unsigned long a1;
+	unsigned long a2;
+	unsigned long a3;
+	unsigned long a4;
+	unsigned long a5;
+	unsigned long a6;
+	unsigned long a7;
+	unsigned long s2;
+	unsigned long s3;
+	unsigned long s4;
+	unsigned long s5;
+	unsigned long s6;
+	unsigned long s7;
+	unsigned long s8;
+	unsigned long s9;
+	unsigned long s10;
+	unsigned long s11;
+	unsigned long t3;
+	unsigned long t4;
+	unsigned long t5;
+	unsigned long t6;
+	/* Supervisor/Machine CSRs */
+	unsigned long status;
+	unsigned long badaddr;
+	unsigned long cause;
+	/* a0 value before the syscall */
+	unsigned long orig_a0;
+};
+
+#endif /* _ASMRISCV_PTRACE_H_ */
diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
index c8cfebb4f2c1..e58dd53071ae 100644
--- a/lib/riscv/asm/setup.h
+++ b/lib/riscv/asm/setup.h
@@ -2,9 +2,10 @@
 #ifndef _ASMRISCV_SETUP_H_
 #define _ASMRISCV_SETUP_H_
 #include <libcflat.h>
+#include <asm/processor.h>
 
 #define NR_CPUS 16
-extern unsigned long cpus[NR_CPUS];       /* per-cpu IDs (hartids) */
+extern struct thread_info cpus[NR_CPUS];
 extern int nr_cpus;
 int hartid_to_cpu(unsigned long hartid);
 
diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
new file mode 100644
index 000000000000..fafa0f864179
--- /dev/null
+++ b/lib/riscv/processor.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
+ */
+#include <libcflat.h>
+#include <asm/csr.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+
+extern unsigned long _text;
+
+void show_regs(struct pt_regs *regs)
+{
+	uintptr_t text = (uintptr_t)&_text;
+	unsigned int w = __riscv_xlen / 4;
+
+	printf("Load address: %" PRIxPTR "\n", text);
+	printf("status : %.*lx\n", w, regs->status);
+	printf("cause  : %.*lx\n", w, regs->cause);
+	printf("badaddr: %.*lx\n", w, regs->badaddr);
+	printf("pc: %.*lx ra: %.*lx\n", w, regs->epc, w, regs->ra);
+	printf("sp: %.*lx gp: %.*lx tp : %.*lx\n", w, regs->sp, w, regs->gp, w, regs->tp);
+	printf("a0: %.*lx a1: %.*lx a2 : %.*lx a3 : %.*lx\n", w, regs->a0, w, regs->a1, w, regs->a2, w, regs->a3);
+	printf("a4: %.*lx a5: %.*lx a6 : %.*lx a7 : %.*lx\n", w, regs->a4, w, regs->a5, w, regs->a6, w, regs->a7);
+	printf("t0: %.*lx t1: %.*lx t2 : %.*lx t3 : %.*lx\n", w, regs->t0, w, regs->t1, w, regs->t2, w, regs->t3);
+	printf("t4: %.*lx t5: %.*lx t6 : %.*lx\n", w, regs->t4, w, regs->t5, w, regs->t6);
+	printf("s0: %.*lx s1: %.*lx s2 : %.*lx s3 : %.*lx\n", w, regs->s0, w, regs->s1, w, regs->s2, w, regs->s3);
+	printf("s4: %.*lx s5: %.*lx s6 : %.*lx s7 : %.*lx\n", w, regs->s4, w, regs->s5, w, regs->s6, w, regs->s7);
+	printf("s8: %.*lx s9: %.*lx s10: %.*lx s11: %.*lx\n", w, regs->s8, w, regs->s9, w, regs->s10, w, regs->s11);
+}
+
+void do_handle_exception(struct pt_regs *regs)
+{
+	struct thread_info *info = current_thread_info();
+
+	assert(regs->cause < EXCEPTION_CAUSE_MAX);
+	if (info->exception_handlers[regs->cause]) {
+		info->exception_handlers[regs->cause](regs);
+		return;
+	}
+
+	show_regs(regs);
+	assert(0);
+}
+
+void install_exception_handler(unsigned long cause, void (*handler)(struct pt_regs *))
+{
+	struct thread_info *info = current_thread_info();
+
+	assert(cause < EXCEPTION_CAUSE_MAX);
+	info->exception_handlers[cause] = handler;
+}
+
+void thread_info_init(void)
+{
+	unsigned long hartid = csr_read(CSR_SSCRATCH);
+	int cpu = hartid_to_cpu(hartid);
+
+	csr_write(CSR_SSCRATCH, &cpus[cpu]);
+}
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 44c26b125a27..57eb4797f798 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -12,12 +12,13 @@
 #include <devicetree.h>
 #include <asm/csr.h>
 #include <asm/page.h>
+#include <asm/processor.h>
 #include <asm/setup.h>
 
 char *initrd;
 u32 initrd_size;
 
-unsigned long cpus[NR_CPUS] = { [0 ... NR_CPUS - 1] = ~0UL };
+struct thread_info cpus[NR_CPUS];
 int nr_cpus;
 
 int hartid_to_cpu(unsigned long hartid)
@@ -25,7 +26,7 @@ int hartid_to_cpu(unsigned long hartid)
 	int cpu;
 
 	for_each_present_cpu(cpu)
-		if (cpus[cpu] == hartid)
+		if (cpus[cpu].hartid == hartid)
 			return cpu;
 	return -1;
 }
@@ -36,7 +37,8 @@ static void cpu_set_fdt(int fdtnode __unused, u64 regval, void *info __unused)
 
 	assert_msg(cpu < NR_CPUS, "Number cpus exceeds maximum supported (%d).", NR_CPUS);
 
-	cpus[cpu] = regval;
+	cpus[cpu].cpu = cpu;
+	cpus[cpu].hartid = regval;
 	set_cpu_present(cpu, true);
 }
 
@@ -104,6 +106,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 
 	mem_init(PAGE_ALIGN((unsigned long)freemem));
 	cpu_init();
+	thread_info_init();
 	io_init();
 
 	ret = dt_get_bootargs(&bootargs);
diff --git a/riscv/Makefile b/riscv/Makefile
index fb97e678a456..1243be125c00 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -26,6 +26,7 @@ cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/devicetree.o
 cflatobjs += lib/riscv/bitops.o
 cflatobjs += lib/riscv/io.o
+cflatobjs += lib/riscv/processor.o
 cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setup.o
 cflatobjs += lib/riscv/smp.o
diff --git a/riscv/cstart.S b/riscv/cstart.S
index 6ec2231e5812..b3842d667309 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -37,8 +37,9 @@
 .global start
 start:
 	/*
-	 * Stash the hartid in scratch and shift the dtb
-	 * address into a0
+	 * Stash the hartid in scratch and shift the dtb address into a0.
+	 * thread_info_init() will later promote scratch to point at thread
+	 * local storage.
 	 */
 	csrw	CSR_SSCRATCH, a0
 	mv	a0, a1
@@ -74,7 +75,8 @@ start:
 	zero_range a1, sp
 
 	/* set up exception handling */
-	//TODO
+	la	a1, exception_vectors
+	csrw	CSR_STVEC, a1
 
 	/* complete setup */
 	la	a1, stacktop			// a1 is the base of free memory
@@ -97,3 +99,112 @@ start:
 halt:
 1:	wfi
 	j	1b
+
+/*
+ * Save context to address in a0.
+ * For a0, sets PT_A0(a0) to the contents of PT_ORIG_A0(a0).
+ * Clobbers a1.
+ */
+.macro save_context
+	REG_S	ra, PT_RA(a0)			// x1
+	REG_S	sp, PT_SP(a0)			// x2
+	REG_S	gp, PT_GP(a0)			// x3
+	REG_S	tp, PT_TP(a0)			// x4
+	REG_S	t0, PT_T0(a0)			// x5
+	REG_S	t1, PT_T1(a0)			// x6
+	REG_S	t2, PT_T2(a0)			// x7
+	REG_S	s0, PT_S0(a0)			// x8 / fp
+	REG_S	s1, PT_S1(a0)			// x9
+	/* a0 */				// x10
+	REG_S   a1, PT_A1(a0)			// x11
+	REG_S	a2, PT_A2(a0)			// x12
+	REG_S	a3, PT_A3(a0)			// x13
+	REG_S	a4, PT_A4(a0)			// x14
+	REG_S	a5, PT_A5(a0)			// x15
+	REG_S	a6, PT_A6(a0)			// x16
+	REG_S	a7, PT_A7(a0)			// x17
+	REG_S	s2, PT_S2(a0)			// x18
+	REG_S	s3, PT_S3(a0)			// x19
+	REG_S	s4, PT_S4(a0)			// x20
+	REG_S	s5, PT_S5(a0)			// x21
+	REG_S	s6, PT_S6(a0)			// x22
+	REG_S	s7, PT_S7(a0)			// x23
+	REG_S	s8, PT_S8(a0)			// x24
+	REG_S	s9, PT_S9(a0)			// x25
+	REG_S	s10, PT_S10(a0)			// x26
+	REG_S	s11, PT_S11(a0)			// x27
+	REG_S	t3, PT_T3(a0)			// x28
+	REG_S	t4, PT_T4(a0)			// x29
+	REG_S	t5, PT_T5(a0)			// x30
+	REG_S	t6, PT_T6(a0)			// x31
+	csrr	a1, CSR_SEPC
+	REG_S	a1, PT_EPC(a0)
+	csrr	a1, CSR_SSTATUS
+	REG_S	a1, PT_STATUS(a0)
+	csrr	a1, CSR_STVAL
+	REG_S	a1, PT_BADADDR(a0)
+	csrr	a1, CSR_SCAUSE
+	REG_S	a1, PT_CAUSE(a0)
+	REG_L	a1, PT_ORIG_A0(a0)
+	REG_S	a1, PT_A0(a0)
+.endm
+
+/*
+ * Restore context from address in a0.
+ * Also restores a0.
+ */
+.macro restore_context
+	REG_L	ra, PT_RA(a0)			// x1
+	REG_L	sp, PT_SP(a0)			// x2
+	REG_L	gp, PT_GP(a0)			// x3
+	REG_L	tp, PT_TP(a0)			// x4
+	REG_L	t0, PT_T0(a0)			// x5
+	REG_L	t1, PT_T1(a0)			// x6
+	REG_L	t2, PT_T2(a0)			// x7
+	REG_L	s0, PT_S0(a0)			// x8 / fp
+	REG_L	s1, PT_S1(a0)			// x9
+	/* a0 */				// x10
+	/* a1 */				// x11
+	REG_L	a2, PT_A2(a0)			// x12
+	REG_L	a3, PT_A3(a0)			// x13
+	REG_L	a4, PT_A4(a0)			// x14
+	REG_L	a5, PT_A5(a0)			// x15
+	REG_L	a6, PT_A6(a0)			// x16
+	REG_L	a7, PT_A7(a0)			// x17
+	REG_L	s2, PT_S2(a0)			// x18
+	REG_L	s3, PT_S3(a0)			// x19
+	REG_L	s4, PT_S4(a0)			// x20
+	REG_L	s5, PT_S5(a0)			// x21
+	REG_L	s6, PT_S6(a0)			// x22
+	REG_L	s7, PT_S7(a0)			// x23
+	REG_L	s8, PT_S8(a0)			// x24
+	REG_L	s9, PT_S9(a0)			// x25
+	REG_L	s10, PT_S10(a0)			// x26
+	REG_L	s11, PT_S11(a0)			// x27
+	REG_L	t3, PT_T3(a0)			// x28
+	REG_L	t4, PT_T4(a0)			// x29
+	REG_L	t5, PT_T5(a0)			// x30
+	REG_L	t6, PT_T6(a0)			// x31
+	REG_L	a1, PT_EPC(a0)
+	csrw	CSR_SEPC, a1
+	REG_L	a1, PT_STATUS(a0)
+	csrw	CSR_SSTATUS, a1
+	REG_L	a1, PT_BADADDR(a0)
+	csrw	CSR_STVAL, a1
+	REG_L	a1, PT_CAUSE(a0)
+	csrw	CSR_SCAUSE, a1
+	REG_L	a1, PT_A1(a0)
+	REG_L	a0, PT_A0(a0)
+.endm
+
+.balign 4
+.global exception_vectors
+exception_vectors:
+	REG_S	a0, (-PT_SIZE + PT_ORIG_A0)(sp)
+	addi	a0, sp, -PT_SIZE
+	save_context
+	mv	sp, a0
+	call	do_handle_exception
+	mv	a0, sp
+	restore_context
+	sret
diff --git a/riscv/selftest.c b/riscv/selftest.c
index d3b269cf6255..219093489b62 100644
--- a/riscv/selftest.c
+++ b/riscv/selftest.c
@@ -6,6 +6,7 @@
  */
 #include <libcflat.h>
 #include <cpumask.h>
+#include <asm/processor.h>
 #include <asm/setup.h>
 
 static void check_cpus(void)
@@ -13,7 +14,23 @@ static void check_cpus(void)
 	int cpu;
 
 	for_each_present_cpu(cpu)
-		report_info("CPU%3d: hartid=%08lx", cpu, cpus[cpu]);
+		report_info("CPU%3d: hartid=%08lx", cpu, cpus[cpu].hartid);
+}
+
+static bool exceptions_work;
+
+static void handler(struct pt_regs *regs)
+{
+	exceptions_work = true;
+	regs->epc += 2;
+}
+
+static void check_exceptions(void)
+{
+	install_exception_handler(EXC_INST_ILLEGAL, handler);
+	asm volatile(".4byte 0");
+	install_exception_handler(EXC_INST_ILLEGAL, NULL);
+	report(exceptions_work, "exceptions");
 }
 
 int main(int argc, char **argv)
@@ -45,6 +62,7 @@ int main(int argc, char **argv)
 		report_skip("environ parsing");
 	}
 
+	check_exceptions();
 	check_cpus();
 
 	return report_summary();
-- 
2.43.0


