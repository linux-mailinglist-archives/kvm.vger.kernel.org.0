Return-Path: <kvm+bounces-29634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CBEF9AE538
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9138A1C24F0D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E535E1DACBB;
	Thu, 24 Oct 2024 12:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GgAXAtbJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72241D63F0
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 12:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729773683; cv=none; b=oDsH8nxlVBvwCMsv4hAr2Z9Hc8VEAznDeJomWfyfy3GMYWsFV+XjobDIDysIs0C2THMyhjyALm8OD6GpzXUc7RHcf8GEPLLgywOFI9Ob42I4cQDpTeyRXCI28Bmdq+3F4cUrq9nYa9i7GlVr7wskIR2c0CyfRZsIEqoHd3d4G4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729773683; c=relaxed/simple;
	bh=Gvnh5jExUA7tEhWZGXaQct3POq8yHS/+GbkHqVlG9fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4LxWyOG3sHqR2l4POYZEnpOBfJbrnh+YsjsfRMFvU8B9pTFboAZqPWP+2n0QXbuYVT4HbD+FwRcemvvRtSEgGxVCMTb+K8IJbdUuGbTkh/qR97CiUUUJaCYCqwaEf7s3LiZCBZwi3e+9Q9NR+0s3wWCIExvuX3JrU4bgHZgubE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GgAXAtbJ; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729773677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lgq/xX7JGQeSzGzakJU88iq1b0yVMwy0/wKKa6czMIQ=;
	b=GgAXAtbJFGdgcqrzpUGyvmjQffWSeJBK4Dy21izI15SUyBs5iwxp8k8zav2S3tU3+Tp6wU
	bGbZo9DB5YLVXqWbcGeuGFVtxOgsAcmLucy2As4fhU9z9b2+S7dV+PbeNh0haMufhcFgId
	SYg8grxU6JZdVT3NvZ1VpqKZVt0lZDY=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 3/3] riscv: sbi: Add SUSP tests
Date: Thu, 24 Oct 2024 14:41:05 +0200
Message-ID: <20241024124101.73405-8-andrew.jones@linux.dev>
In-Reply-To: <20241024124101.73405-5-andrew.jones@linux.dev>
References: <20241024124101.73405-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Introduce tests for SBI system suspend. The basic test makes
sure it works and other tests make sure it fails as expected
with invalid entry criteria.

To test on QEMU or hardware the firmware needs to support system
suspend. For QEMU, OpenSBI can be told to enable its system
suspend test mode by creating a new DTB which has

    opensbi-config {
        compatible = "opensbi,config";
        system-suspend-test;
    };

added to the 'chosen' node. Then, run with '-dtb susp.dtb'.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/asm.h |   3 +
 lib/riscv/asm/sbi.h |   1 +
 riscv/sbi-asm.S     |  55 +++++++++
 riscv/sbi-tests.h   |  19 +++
 riscv/sbi.c         | 278 ++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 344 insertions(+), 12 deletions(-)

diff --git a/lib/riscv/asm/asm.h b/lib/riscv/asm/asm.h
index 763b28e6ad3c..107b5bb7e981 100644
--- a/lib/riscv/asm/asm.h
+++ b/lib/riscv/asm/asm.h
@@ -14,6 +14,9 @@
 #define REG_S	__REG_SEL(sd, sw)
 #define SZREG	__REG_SEL(8, 4)
 
+/* ASMARR() may be used with arrays of longs */
+#define ASMARR(reg, idx)	((idx) * SZREG)(reg)
+
 #define FP_SIZE 16
 
 #endif /* _ASMRISCV_ASM_H_ */
diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 1319439b7118..4e72f125fb43 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -22,6 +22,7 @@ enum sbi_ext_id {
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_DBCN = 0x4442434E,
+	SBI_EXT_SUSP = 0x53555350,
 };
 
 enum sbi_ext_base_fid {
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
index 9606a13e5f3a..e871ea506f07 100644
--- a/riscv/sbi-asm.S
+++ b/riscv/sbi-asm.S
@@ -5,6 +5,7 @@
  * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
  */
 #define __ASSEMBLY__
+#include <asm/asm.h>
 #include <asm/csr.h>
 
 #include "sbi-tests.h"
@@ -69,3 +70,57 @@ sbi_hsm_check_hart_start:
 sbi_hsm_check_non_retentive_suspend:
 	la	HSM_RESULTS_ARRAY, sbi_hsm_non_retentive_hart_suspend_checks
 	j	sbi_hsm_check
+
+.balign 4
+restore_csrs:
+	REG_L	a1, ASMARR(a0, SBI_CSR_SSTATUS_IDX)
+	csrw	CSR_SSTATUS, a1
+	REG_L	a1, ASMARR(a0, SBI_CSR_SIE_IDX)
+	csrw	CSR_SIE, a1
+	REG_L	a1, ASMARR(a0, SBI_CSR_STVEC_IDX)
+	csrw	CSR_STVEC, a1
+	REG_L	a1, ASMARR(a0, SBI_CSR_SSCRATCH_IDX)
+	csrw	CSR_SSCRATCH, a1
+	REG_L	a1, ASMARR(a0, SBI_CSR_SATP_IDX)
+	sfence.vma
+	csrw	CSR_SATP, a1
+	ret
+
+/*
+ * sbi_susp_resume
+ *
+ * State is as specified by "SUSP System Resume Register State" of the SBI spec
+ *   a0 is the hartid
+ *   a1 is the opaque parameter (here, it's the context array defined in check_susp())
+ * Doesn't return.
+ */
+#define SUSP_CTX		s1
+#define SUSP_RESULTS_MAP	s2
+.balign 4
+.global sbi_susp_resume
+sbi_susp_resume:
+	li	SUSP_RESULTS_MAP, 0
+	mv	SUSP_CTX, a1
+	REG_L	t0, ASMARR(SUSP_CTX, SBI_SUSP_MAGIC_IDX)
+	li	t1, SBI_SUSP_MAGIC
+	beq	t0, t1, 2f
+1:	pause
+	j	1b
+2:	csrr	t0, CSR_SATP
+	bnez	t0, 3f
+	ori	SUSP_RESULTS_MAP, SUSP_RESULTS_MAP, SBI_SUSP_TEST_SATP
+3:	csrr	t0, CSR_SSTATUS
+	andi	t0, t0, SR_SIE
+	bnez	t0, 4f
+	ori	SUSP_RESULTS_MAP, SUSP_RESULTS_MAP, SBI_SUSP_TEST_SIE
+4:	REG_L	t0, ASMARR(SUSP_CTX, SBI_SUSP_HARTID_IDX)
+	bne	t0, a0, 5f
+	ori	SUSP_RESULTS_MAP, SUSP_RESULTS_MAP, SBI_SUSP_TEST_HARTID
+5:	REG_S	SUSP_RESULTS_MAP, ASMARR(SUSP_CTX, SBI_SUSP_RESULTS_IDX)
+	REG_L	a0, ASMARR(SUSP_CTX, SBI_SUSP_CSRS_IDX)
+	call	restore_csrs
+	la	a0, sbi_susp_jmp
+	REG_L	a1, ASMARR(SUSP_CTX, SBI_SUSP_TESTNUM_IDX)
+	call	longjmp
+6:	pause	/* unreachable */
+	j	6b
diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
index f5cc8635d2aa..d0a7561a47b3 100644
--- a/riscv/sbi-tests.h
+++ b/riscv/sbi-tests.h
@@ -2,9 +2,28 @@
 #ifndef _RISCV_SBI_TESTS_H_
 #define _RISCV_SBI_TESTS_H_
 
+#define SBI_CSR_SSTATUS_IDX	0
+#define SBI_CSR_SIE_IDX		1
+#define SBI_CSR_STVEC_IDX	2
+#define SBI_CSR_SSCRATCH_IDX	3
+#define SBI_CSR_SATP_IDX	4
+
 #define SBI_HSM_TEST_DONE	(1 << 0)
 #define SBI_HSM_TEST_HARTID_A1	(1 << 1)
 #define SBI_HSM_TEST_SATP	(1 << 2)
 #define SBI_HSM_TEST_SIE	(1 << 3)
 
+#define SBI_SUSP_TEST_SATP	(1 << 0)
+#define SBI_SUSP_TEST_SIE	(1 << 1)
+#define SBI_SUSP_TEST_HARTID	(1 << 2)
+#define SBI_SUSP_TEST_MASK	7
+
+#define SBI_SUSP_MAGIC		0x505b
+
+#define SBI_SUSP_MAGIC_IDX	0
+#define SBI_SUSP_CSRS_IDX	1
+#define SBI_SUSP_HARTID_IDX	2
+#define SBI_SUSP_TESTNUM_IDX	3
+#define SBI_SUSP_RESULTS_IDX	4
+
 #endif /* _RISCV_SBI_TESTS_H_ */
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 1e7314ec8d98..44c76692dad4 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -6,11 +6,14 @@
  */
 #include <libcflat.h>
 #include <alloc_page.h>
+#include <limits.h>
+#include <memregions.h>
+#include <on-cpus.h>
+#include <setjmp.h>
 #include <stdlib.h>
 #include <string.h>
-#include <limits.h>
 #include <vmalloc.h>
-#include <memregions.h>
+
 #include <asm/barrier.h>
 #include <asm/csr.h>
 #include <asm/delay.h>
@@ -22,6 +25,8 @@
 #include <asm/smp.h>
 #include <asm/timer.h>
 
+#include "sbi-tests.h"
+
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
 
 static void help(void)
@@ -47,6 +52,22 @@ static struct sbiret sbi_dbcn_write_byte(uint8_t byte)
 	return sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, byte, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret sbi_system_suspend(uint32_t sleep_type, unsigned long resume_addr, unsigned long opaque)
+{
+	return sbi_ecall(SBI_EXT_SUSP, 0, sleep_type, resume_addr, opaque, 0, 0, 0);
+}
+
+static void start_cpu(void *data)
+{
+	/* nothing to do */
+}
+
+static void stop_cpu(void *data)
+{
+	struct sbiret ret = sbi_hart_stop();
+	assert_msg(0, "cpu%d failed to stop with sbiret.error %ld", smp_processor_id(), ret.error);
+}
+
 static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo)
 {
 	*lo = (unsigned long)paddr;
@@ -98,6 +119,22 @@ static bool env_or_skip(const char *env)
 	return true;
 }
 
+static bool get_invalid_addr(phys_addr_t *paddr, bool allow_default)
+{
+	if (env_enabled("INVALID_ADDR_AUTO")) {
+		*paddr = get_highest_addr() + 1;
+		return true;
+	} else if (allow_default && !getenv("INVALID_ADDR")) {
+		*paddr = -1ul;
+		return true;
+	} else if (env_or_skip("INVALID_ADDR")) {
+		*paddr = strtoull(getenv("INVALID_ADDR"), NULL, 0);
+		return true;
+	}
+
+	return false;
+}
+
 static void gen_report(struct sbiret *ret,
 		       long expected_error, long expected_value)
 {
@@ -358,7 +395,6 @@ static void check_dbcn(void)
 {
 	unsigned long num_bytes = strlen(DBCN_WRITE_TEST_STRING);
 	unsigned long base_addr_lo, base_addr_hi;
-	bool do_invalid_addr = false;
 	bool highmem_supported = true;
 	phys_addr_t paddr;
 	struct sbiret ret;
@@ -407,15 +443,7 @@ static void check_dbcn(void)
 
 	/* Bytes are read from memory and written to the console */
 	report_prefix_push("invalid parameter");
-	if (env_enabled("INVALID_ADDR_AUTO")) {
-		paddr = get_highest_addr() + 1;
-		do_invalid_addr = true;
-	} else if (env_or_skip("INVALID_ADDR")) {
-		paddr = strtoull(getenv("INVALID_ADDR"), NULL, 0);
-		do_invalid_addr = true;
-	}
-
-	if (do_invalid_addr) {
+	if (get_invalid_addr(&paddr, false)) {
 		split_phys_addr(paddr, &base_addr_hi, &base_addr_lo);
 		ret = sbi_dbcn_write(1, base_addr_lo, base_addr_hi);
 		report(ret.error == SBI_ERR_INVALID_PARAM, "address (error=%ld)", ret.error);
@@ -438,6 +466,231 @@ static void check_dbcn(void)
 	report_prefix_popn(2);
 }
 
+void sbi_susp_resume(unsigned long hartid, unsigned long opaque);
+jmp_buf sbi_susp_jmp;
+
+struct susp_params {
+	unsigned long sleep_type;
+	unsigned long resume_addr;
+	unsigned long opaque;
+	bool returns;
+	struct sbiret ret;
+};
+
+static bool susp_basic_prep(unsigned long ctx[], struct susp_params *params)
+{
+	int cpu, me = smp_processor_id();
+	struct sbiret ret;
+	cpumask_t mask;
+
+	memset(params, 0, sizeof(*params));
+	params->sleep_type = 0; /* suspend-to-ram */
+	params->resume_addr = virt_to_phys(sbi_susp_resume);
+	params->opaque = virt_to_phys(ctx);
+	params->returns = false;
+
+	cpumask_copy(&mask, &cpu_present_mask);
+	cpumask_clear_cpu(me, &mask);
+	on_cpumask_async(&mask, stop_cpu, NULL);
+
+	/* Wait up to 1s for all harts to stop */
+	for (int i = 0; i < 100; i++) {
+		int count = 1;
+
+		udelay(10000);
+
+		for_each_present_cpu(cpu) {
+			if (cpu == me)
+				continue;
+			ret = sbi_hart_get_status(cpus[cpu].hartid);
+			if (!ret.error && ret.value == SBI_EXT_HSM_STOPPED)
+				++count;
+		}
+		if (count == cpumask_weight(&cpu_present_mask))
+			break;
+	}
+
+	for_each_present_cpu(cpu) {
+		ret = sbi_hart_get_status(cpus[cpu].hartid);
+		if (cpu == me) {
+			assert_msg(!ret.error && ret.value == SBI_EXT_HSM_STARTED,
+				   "cpu%d is not started", cpu);
+		} else {
+			assert_msg(!ret.error && ret.value == SBI_EXT_HSM_STOPPED,
+				   "cpu%d is not stopped", cpu);
+		}
+	}
+
+	return true;
+}
+
+static void susp_basic_check(unsigned long ctx[], struct susp_params *params)
+{
+	if (ctx[SBI_SUSP_RESULTS_IDX] == SBI_SUSP_TEST_MASK) {
+		report_pass("suspend and resume");
+	} else {
+		if (!(ctx[SBI_SUSP_RESULTS_IDX] & SBI_SUSP_TEST_SATP))
+			report_fail("SATP set to zero on resume");
+		if (!(ctx[SBI_SUSP_RESULTS_IDX] & SBI_SUSP_TEST_SIE))
+			report_fail("sstatus.SIE clear on resume");
+		if (!(ctx[SBI_SUSP_RESULTS_IDX] & SBI_SUSP_TEST_HARTID))
+			report_fail("a0 is hartid on resume");
+	}
+}
+
+static bool susp_type_prep(unsigned long ctx[], struct susp_params *params)
+{
+	bool r;
+
+	r = susp_basic_prep(ctx, params);
+	assert(r);
+	params->sleep_type = 1;
+	params->returns = true;
+	params->ret.error = SBI_ERR_INVALID_PARAM;
+
+	return true;
+}
+
+static bool susp_badaddr_prep(unsigned long ctx[], struct susp_params *params)
+{
+	phys_addr_t badaddr;
+	bool r;
+
+	if (!get_invalid_addr(&badaddr, false))
+		return false;
+
+	r = susp_basic_prep(ctx, params);
+	assert(r);
+	params->resume_addr = badaddr;
+	params->returns = true;
+	params->ret.error = SBI_ERR_INVALID_ADDRESS;
+
+	return true;
+}
+
+static bool susp_one_prep(unsigned long ctx[], struct susp_params *params)
+{
+	int started = 0, cpu, me = smp_processor_id();
+	struct sbiret ret;
+	bool r;
+
+	if (cpumask_weight(&cpu_present_mask) < 2) {
+		report_skip("At least 2 cpus required");
+		return false;
+	}
+
+	r = susp_basic_prep(ctx, params);
+	assert(r);
+	params->returns = true;
+	params->ret.error = SBI_ERR_DENIED;
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+		break;
+	}
+
+	on_cpu(cpu, start_cpu, NULL);
+
+	for_each_present_cpu(cpu) {
+		ret = sbi_hart_get_status(cpus[cpu].hartid);
+		assert_msg(!ret.error, "HSM get status failed for cpu%d", cpu);
+		if (ret.value == SBI_EXT_HSM_STARTED)
+			started++;
+	}
+
+	assert(started == 2);
+
+	return true;
+}
+
+static void check_susp(void)
+{
+	unsigned long csrs[] = {
+		[SBI_CSR_SSTATUS_IDX] = csr_read(CSR_SSTATUS),
+		[SBI_CSR_SIE_IDX] = csr_read(CSR_SIE),
+		[SBI_CSR_STVEC_IDX] = csr_read(CSR_STVEC),
+		[SBI_CSR_SSCRATCH_IDX] = csr_read(CSR_SSCRATCH),
+		[SBI_CSR_SATP_IDX] = csr_read(CSR_SATP),
+	};
+	unsigned long ctx[] = {
+		[SBI_SUSP_MAGIC_IDX] = SBI_SUSP_MAGIC,
+		[SBI_SUSP_CSRS_IDX] = (unsigned long)csrs,
+		[SBI_SUSP_HARTID_IDX] = current_thread_info()->hartid,
+		[SBI_SUSP_TESTNUM_IDX] = 0,
+		[SBI_SUSP_RESULTS_IDX] = 0,
+	};
+	enum {
+#define SUSP_FIRST_TESTNUM 1
+		SUSP_BASIC = SUSP_FIRST_TESTNUM,
+		SUSP_TYPE,
+		SUSP_BAD_ADDR,
+		SUSP_ONE_ONLINE,
+		NR_SUSP_TESTS,
+	};
+	struct susp_test {
+		const char *name;
+		bool (*prep)(unsigned long ctx[], struct susp_params *params);
+		void (*check)(unsigned long ctx[], struct susp_params *params);
+	} susp_tests[] = {
+		[SUSP_BASIC]		= { "basic",		susp_basic_prep,	susp_basic_check,	},
+		[SUSP_TYPE]		= { "sleep_type",	susp_type_prep,					},
+		[SUSP_BAD_ADDR]		= { "bad addr",		susp_badaddr_prep,				},
+		[SUSP_ONE_ONLINE]	= { "one cpu online",	susp_one_prep,					},
+	};
+	struct susp_params params;
+	struct sbiret ret;
+	int testnum, i;
+
+	local_irq_disable();
+	timer_stop();
+
+	report_prefix_push("susp");
+
+	ret = sbi_ecall(SBI_EXT_SUSP, 1, 0, 0, 0, 0, 0, 0);
+	report(ret.error == SBI_ERR_NOT_SUPPORTED, "funcid != 0 not supported");
+
+	for (i = SUSP_FIRST_TESTNUM; i < NR_SUSP_TESTS; i++) {
+		report_prefix_push(susp_tests[i].name);
+
+		ctx[SBI_SUSP_TESTNUM_IDX] = i;
+		ctx[SBI_SUSP_RESULTS_IDX] = 0;
+
+		assert(susp_tests[i].prep);
+		if (!susp_tests[i].prep(ctx, &params)) {
+			report_prefix_pop();
+			continue;
+		}
+
+		if ((testnum = setjmp(sbi_susp_jmp)) == 0) {
+			ret = sbi_system_suspend(params.sleep_type, params.resume_addr, params.opaque);
+
+			if (!params.returns && ret.error == SBI_ERR_NOT_SUPPORTED) {
+				report_skip("SUSP not supported?");
+				report_prefix_popn(2);
+				return;
+			} else if (!params.returns) {
+				report_fail("unexpected return with error: %ld, value: %ld", ret.error, ret.value);
+			} else {
+				report(ret.error == params.ret.error, "expected sbi.error");
+				if (ret.error != params.ret.error)
+					report_info("expected error %ld, received %ld", params.ret.error, ret.error);
+			}
+
+			report_prefix_pop();
+			continue;
+		}
+		assert(testnum == i);
+
+		if (susp_tests[i].check)
+			susp_tests[i].check(ctx, &params);
+
+		report_prefix_pop();
+	}
+
+	report_prefix_pop();
+}
+
 int main(int argc, char **argv)
 {
 	if (argc > 1 && !strcmp(argv[1], "-h")) {
@@ -449,6 +702,7 @@ int main(int argc, char **argv)
 	check_base();
 	check_time();
 	check_dbcn();
+	check_susp();
 
 	return report_summary();
 }
-- 
2.47.0


