Return-Path: <kvm+bounces-7161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F9983DBBC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 679C92841E8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331AD1CD21;
	Fri, 26 Jan 2024 14:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AgS2uhGZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1531C69F
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279055; cv=none; b=rI9Rf0aWY+2otgipFpctstNsS8G2CJxW5b8JiY+BWY125o0x/oODz/aH4KAuzL52kbOx0+gsqx9dvos+XB2LiKF4kMGIk22YhAvzhi2d9ompQQrk5oi98LUGCK7PmN2n5bYAyugL2vQHxi0oMmimQKbRksYp5lfE59JELe7GMsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279055; c=relaxed/simple;
	bh=JEPphEtAZgA+A/aFN6+dxTRX5AxM6LKd1+WGCEHDvZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=k3067EcZLgXOOoRi9s4Tpbr1qpb/KDVEIfVFdlor5LXC7aIQJrG2Uuzq/LXC2asbc8s+thBEFs9Jz/wAMVwkr2K932krtkUOpkhVyu4lwS5OZIgsmWYZHpoOX1pmV3eCtCodcfTsbeIG07wclmQsf/taMCaTC7KB0ZxcRL7Pj7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AgS2uhGZ; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=84KsIvweir9AGGB9wZJAIIFO38Fj/Y8bg+V/ho1zNW0=;
	b=AgS2uhGZL0ybJ4AC1X6Fh6MG6sHygEKINIhkY1Vk2EUdvX03t9tSPn/OhbvieDLmk9hAbw
	fBDqJZT/4HEHePv5CXFJf4UK4FnWR/EXKh2YKHhN4vIT6yeDhuE+7GLB7xokEv7SM1K3N5
	/uc6ImyKj7JJHnd2mwyg6acsjByaf6Q=
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
Subject: [kvm-unit-tests PATCH v2 15/24] riscv: Add SMP support
Date: Fri, 26 Jan 2024 15:23:40 +0100
Message-ID: <20240126142324.66674-41-andrew.jones@linux.dev>
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

Implement the same SMP API that Arm has but using an SBI HSM
call instead of PSCI. Unlike Arm, riscv needs to always set
cpu0_calls_idle, because the boot hart doesn't have to be the
first hart described in the DT, which means cpu0 may well be
a secondary. As usual, add a couple tests to selftest.c to
make sure everything works.

(The secondary boot process is also improved over Arm's a bit
by keeping boot data percpu, dropping the need for a lock. We
could create percpu data for Arm too, but that's left as future
work.)

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/riscv/asm-offsets.c |  6 ++++
 lib/riscv/asm/barrier.h |  2 ++
 lib/riscv/asm/sbi.h     | 22 +++++++++++++++
 lib/riscv/asm/smp.h     | 28 +++++++++++++++++++
 lib/riscv/processor.c   |  2 ++
 lib/riscv/sbi.c         |  5 ++++
 lib/riscv/setup.c       |  2 ++
 lib/riscv/smp.c         | 61 +++++++++++++++++++++++++++++++++++++++++
 riscv/Makefile          |  1 +
 riscv/cstart.S          | 25 +++++++++++++++++
 riscv/selftest.c        | 31 +++++++++++++++++++++
 11 files changed, 185 insertions(+)
 create mode 100644 lib/riscv/asm/smp.h

diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
index 7b88d16fd0e4..f5beeeb45e09 100644
--- a/lib/riscv/asm-offsets.c
+++ b/lib/riscv/asm-offsets.c
@@ -2,6 +2,7 @@
 #include <kbuild.h>
 #include <elf.h>
 #include <asm/ptrace.h>
+#include <asm/smp.h>
 
 int main(void)
 {
@@ -51,5 +52,10 @@ int main(void)
 	OFFSET(PT_CAUSE, pt_regs, cause);
 	OFFSET(PT_ORIG_A0, pt_regs, orig_a0);
 	DEFINE(PT_SIZE, sizeof(struct pt_regs));
+
+	OFFSET(SECONDARY_STVEC, secondary_data, stvec);
+	OFFSET(SECONDARY_FUNC, secondary_data, func);
+	DEFINE(SECONDARY_DATA_SIZE, sizeof(struct secondary_data));
+
 	return 0;
 }
diff --git a/lib/riscv/asm/barrier.h b/lib/riscv/asm/barrier.h
index 6036d66af76f..4fef120a0fe8 100644
--- a/lib/riscv/asm/barrier.h
+++ b/lib/riscv/asm/barrier.h
@@ -15,4 +15,6 @@
 #define smp_rmb()	RISCV_FENCE(r,r)
 #define smp_wmb()	RISCV_FENCE(w,w)
 
+#define cpu_relax()	__asm__ __volatile__ ("pause")
+
 #endif /* _ASMRISCV_BARRIER_H_ */
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index aeff07f6f1a8..d82a384da5ce 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -2,8 +2,21 @@
 #ifndef _ASMRISCV_SBI_H_
 #define _ASMRISCV_SBI_H_
 
+#define SBI_SUCCESS			0
+#define SBI_ERR_FAILURE			-1
+#define SBI_ERR_NOT_SUPPORTED		-2
+#define SBI_ERR_INVALID_PARAM		-3
+#define SBI_ERR_DENIED			-4
+#define SBI_ERR_INVALID_ADDRESS		-5
+#define SBI_ERR_ALREADY_AVAILABLE	-6
+#define SBI_ERR_ALREADY_STARTED		-7
+#define SBI_ERR_ALREADY_STOPPED		-8
+
+#ifndef __ASSEMBLY__
+
 enum sbi_ext_id {
 	SBI_EXT_BASE = 0x10,
+	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
 };
 
@@ -17,6 +30,13 @@ enum sbi_ext_base_fid {
 	SBI_EXT_BASE_GET_MIMPID,
 };
 
+enum sbi_ext_hsm_fid {
+	SBI_EXT_HSM_HART_START = 0,
+	SBI_EXT_HSM_HART_STOP,
+	SBI_EXT_HSM_HART_STATUS,
+	SBI_EXT_HSM_HART_SUSPEND,
+};
+
 struct sbiret {
 	long error;
 	long value;
@@ -28,5 +48,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg5);
 
 void sbi_shutdown(void);
+struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
 
+#endif /* !__ASSEMBLY__ */
 #endif /* _ASMRISCV_SBI_H_ */
diff --git a/lib/riscv/asm/smp.h b/lib/riscv/asm/smp.h
new file mode 100644
index 000000000000..931766dc3969
--- /dev/null
+++ b/lib/riscv/asm/smp.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_SMP_H_
+#define _ASMRISCV_SMP_H_
+#include <asm/barrier.h>
+#include <asm/processor.h>
+
+#define smp_wait_for_event()	cpu_relax()
+#define smp_send_event()	cpu_relax()
+
+static inline int smp_processor_id(void)
+{
+	return current_thread_info()->cpu;
+}
+
+typedef void (*secondary_func_t)(void);
+
+struct secondary_data {
+	unsigned long stvec;
+	secondary_func_t func;
+} __attribute__((aligned(16)));
+
+void secondary_entry(unsigned long hartid, unsigned long sp_phys);
+secondary_func_t secondary_cinit(struct secondary_data *data);
+
+void smp_boot_secondary(int cpu, void (*func)(void));
+void smp_boot_secondary_nofail(int cpu, void (*func)(void));
+
+#endif /* _ASMRISCV_SMP_H_ */
diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
index fafa0f864179..2bfbd4e9b274 100644
--- a/lib/riscv/processor.c
+++ b/lib/riscv/processor.c
@@ -11,10 +11,12 @@ extern unsigned long _text;
 
 void show_regs(struct pt_regs *regs)
 {
+	struct thread_info *info = current_thread_info();
 	uintptr_t text = (uintptr_t)&_text;
 	unsigned int w = __riscv_xlen / 4;
 
 	printf("Load address: %" PRIxPTR "\n", text);
+	printf("CPU%3d : hartid=%lx\n", info->cpu, info->hartid);
 	printf("status : %.*lx\n", w, regs->status);
 	printf("cause  : %.*lx\n", w, regs->cause);
 	printf("badaddr: %.*lx\n", w, regs->badaddr);
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index fd758555b888..f39134c4d77e 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -33,3 +33,8 @@ void sbi_shutdown(void)
 	sbi_ecall(SBI_EXT_SRST, 0, 0, 0, 0, 0, 0, 0);
 	puts("SBI shutdown failed!\n");
 }
+
+struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp)
+{
+	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_START, hartid, entry, sp, 0, 0, 0);
+}
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 57eb4797f798..9ff446b5e171 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -10,6 +10,7 @@
 #include <argv.h>
 #include <cpumask.h>
 #include <devicetree.h>
+#include <on-cpus.h>
 #include <asm/csr.h>
 #include <asm/page.h>
 #include <asm/processor.h>
@@ -60,6 +61,7 @@ static void cpu_init(void)
 	}
 
 	set_cpu_online(hartid_to_cpu(csr_read(CSR_SSCRATCH)), true);
+	cpu0_calls_idle = true;
 }
 
 static void mem_init(phys_addr_t freemem_start)
diff --git a/lib/riscv/smp.c b/lib/riscv/smp.c
index a89b59d8dd03..ed7984e75608 100644
--- a/lib/riscv/smp.c
+++ b/lib/riscv/smp.c
@@ -1,6 +1,67 @@
 // SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Boot secondary CPUs
+ *
+ * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
+ */
+#include <libcflat.h>
+#include <alloc.h>
 #include <cpumask.h>
+#include <asm/csr.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/sbi.h>
+#include <asm/smp.h>
 
 cpumask_t cpu_present_mask;
 cpumask_t cpu_online_mask;
 cpumask_t cpu_idle_mask;
+
+static cpumask_t cpu_started;
+
+secondary_func_t secondary_cinit(struct secondary_data *data)
+{
+	struct thread_info *info;
+
+	thread_info_init();
+	info = current_thread_info();
+	set_cpu_online(info->cpu, true);
+	smp_send_event();
+
+	return data->func;
+}
+
+static void __smp_boot_secondary(int cpu, secondary_func_t func)
+{
+	struct secondary_data *sp = memalign(16, SZ_8K) + SZ_8K - 16;
+	struct sbiret ret;
+
+	sp -= sizeof(struct secondary_data);
+	sp->stvec = csr_read(CSR_STVEC);
+	sp->func = func;
+
+	ret = sbi_hart_start(cpus[cpu].hartid, (unsigned long)&secondary_entry, __pa(sp));
+	assert(ret.error == SBI_SUCCESS);
+}
+
+void smp_boot_secondary(int cpu, void (*func)(void))
+{
+	int ret = cpumask_test_and_set_cpu(cpu, &cpu_started);
+
+	assert_msg(!ret, "CPU%d already boot once", cpu);
+	__smp_boot_secondary(cpu, func);
+
+	while (!cpu_online(cpu))
+		smp_wait_for_event();
+}
+
+void smp_boot_secondary_nofail(int cpu, void (*func)(void))
+{
+	int ret = cpumask_test_and_set_cpu(cpu, &cpu_started);
+
+	if (!ret)
+		__smp_boot_secondary(cpu, func);
+
+	while (!cpu_online(cpu))
+		smp_wait_for_event();
+}
diff --git a/riscv/Makefile b/riscv/Makefile
index 697a3beb2703..932f3378264c 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -24,6 +24,7 @@ cstart.o = $(TEST_DIR)/cstart.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/devicetree.o
+cflatobjs += lib/on-cpus.o
 cflatobjs += lib/riscv/bitops.o
 cflatobjs += lib/riscv/io.o
 cflatobjs += lib/riscv/processor.o
diff --git a/riscv/cstart.S b/riscv/cstart.S
index 2066e37d1ef6..c935467ff6a1 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -117,6 +117,31 @@ halt:
 1:	wfi
 	j	1b
 
+.balign 4
+.global secondary_entry
+secondary_entry:
+	/*
+	 * From the "HSM Hart Start Register State" table of the SBI spec:
+	 *	satp		0
+	 *	sstatus.SIE	0
+	 *	a0		hartid
+	 *	a1		opaque parameter
+	 *
+	 * __smp_boot_secondary() sets the opaque parameter (a1) to the physical
+	 * address of the stack and the stack contains the secondary data.
+	 */
+	csrw	CSR_SSCRATCH, a0
+	mv	sp, a1
+	mv	fp, zero
+	REG_L	a0, SECONDARY_STVEC(sp)
+	csrw	CSR_STVEC, a0
+	mv	a0, sp
+	call	secondary_cinit
+	addi	sp, sp, SECONDARY_DATA_SIZE
+	jr	a0
+	la	a0, do_idle
+	jr	a0
+
 /*
  * Save context to address in a0.
  * For a0, sets PT_A0(a0) to the contents of PT_ORIG_A0(a0).
diff --git a/riscv/selftest.c b/riscv/selftest.c
index 219093489b62..da13c622dba7 100644
--- a/riscv/selftest.c
+++ b/riscv/selftest.c
@@ -6,8 +6,10 @@
  */
 #include <libcflat.h>
 #include <cpumask.h>
+#include <on-cpus.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
+#include <asm/smp.h>
 
 static void check_cpus(void)
 {
@@ -33,6 +35,34 @@ static void check_exceptions(void)
 	report(exceptions_work, "exceptions");
 }
 
+static cpumask_t cpus_alive;
+
+static void check_secondary(void *data)
+{
+	cpumask_set_cpu(smp_processor_id(), &cpus_alive);
+}
+
+static void check_smp(void)
+{
+	int cpu, me = smp_processor_id();
+	bool fail = false;
+
+	on_cpus(check_secondary, NULL);
+
+	report(cpumask_full(&cpu_online_mask), "Brought up all cpus");
+	report(cpumask_full(&cpus_alive), "check_secondary");
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+		if (!cpu_idle(cpu)) {
+			fail = true;
+			break;
+		}
+	}
+	report(!fail, "All secondaries are idle");
+}
+
 int main(int argc, char **argv)
 {
 	bool r;
@@ -64,6 +94,7 @@ int main(int argc, char **argv)
 
 	check_exceptions();
 	check_cpus();
+	check_smp();
 
 	return report_summary();
 }
-- 
2.43.0


