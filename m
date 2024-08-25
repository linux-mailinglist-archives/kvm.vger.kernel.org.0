Return-Path: <kvm+bounces-25014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F67F95E484
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 19:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E4C01F2139E
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 17:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7185115AADA;
	Sun, 25 Aug 2024 17:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ISMyEHVQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC9B16F273
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724605726; cv=none; b=a18FedfLiKYmTnTERqkmQZfIPdNIk3qJ3QY9E1QW/V8oCtPJpupAEq52hnpKf1CftjvOuhMr5mpZBkxH9Tct/FDsTKOVzsXwFt78vBnP0NiEftzKxYC8gMOmxB3SN/jDsoRA15phT5f7welOMgaU0EJPnZJc03iEgIBObpV2X9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724605726; c=relaxed/simple;
	bh=maoNae85CCqTT7K9OY62uSidL0LqV8Fj48Xw+e3iXp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Al/aXwob6kryUNW8eRv4R/XgMC9PJ3HcdnWT26/z1X2x3qn1f379UwEl0jRmKSXl3v7EHElH7BZtRpZNdFwlq9UBzaRiIGEk1ynxLP7oYzjNfQnpJr+rfUkPe3MHacd9SS917pnbWbqi5RLns3MmCJ3owDz/b5kW81QtlSA3yFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ISMyEHVQ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-201ee6b084bso29604875ad.2
        for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 10:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724605723; x=1725210523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUzCQefNyTL9tkyHPQdjVTYyES/LTP6VixeQz23zJug=;
        b=ISMyEHVQ9v1pd2nTkEa/zw51CgIuWyzQ4COVqw658J5aEpveUIenLE4Clb/GwbgVn3
         6B2D0z1IiyXy0YMOFRyU2C6gLFdyBch3nmBVlQY+9EMrW/c3yL3lvdDyaNO6NaX0LPe1
         xM4//p3Io3yd12+3P/CLB7J3iNH4o0nF1GqZHQul03Ydeq1ch//7QDAwYR1BhQowqRL8
         NHBahLvsyAfa7t5y+/SLcixBQ6Wux6h+RMOu+eGpltpAvW4Jp/W6QetWRzAfCsVj8lAh
         jZ5eZtRLR26Hjr0y6A07J86u9xxAvEqoEoK9lADi2b9YxH6IIUrLqqlVXJ13yHl1pRhq
         KjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724605723; x=1725210523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lUzCQefNyTL9tkyHPQdjVTYyES/LTP6VixeQz23zJug=;
        b=JDprAle5zI/1se17BifKEPIJMDlDxIHuh4dVMXH5R0KOFDtztUfse0pUQHus5wr8sN
         9f1nH569727YZZAmU3kYrrtNUFad9KpZs3kLMUtgBK2p1Uf2Gce0WsEhFGybkphWpSXs
         9DVT3YBdT7axgqEnN/3iOFXv/W9bgvLmuuBOYxU3KmWeY4hcHEl/YHAQIvW5oaJOcxcE
         r4ewLHc4kGo8lqwG0UJEfpokv7wZh5du5K//IfnqC5AxYNW+IDIOmVAeSwC4XIgzy7Ym
         BV7b1e2g4AY7YWx64gcW58uuLh9K5RBjLD2kWpGcT4Ns3QQ0N1cHJHOj6+2WasjRtlIY
         PmFw==
X-Gm-Message-State: AOJu0YyN8H0iqz27B6BT7DFhUKACNEWYJdxn5ePFuDC+pGnbaYUeWoGv
	7epbvO02vkszuCve9oBbysANAtzCd99wb5+DteYQo3qLz9i4rzVoRf5iRyli
X-Google-Smtp-Source: AGHT+IHSMra+TZeq7WaJtXtWwt/rEXBtykcPthl5euqqudAP4rvqh1ngyOshr+1O2GkNogelorLzAw==
X-Received: by 2002:a17:902:db0e:b0:1fc:5ed5:ff56 with SMTP id d9443c01a7336-2039e54a903mr90611115ad.61.1724605723228;
        Sun, 25 Aug 2024 10:08:43 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855dd985sm56083165ad.164.2024.08.25.10.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 10:08:42 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v2 4/4] riscv: sbi: Add tests for HSM extension
Date: Mon, 26 Aug 2024 01:08:24 +0800
Message-ID: <20240825170824.107467-5-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240825170824.107467-1-jamestiotio@gmail.com>
References: <20240825170824.107467-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some tests for all of the HSM extension functions. These tests
ensure that the HSM extension functions follow the behavior as described
in the SBI specification.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 riscv/Makefile  |   7 +-
 riscv/sbi-asm.S |  79 ++++++++++
 riscv/sbi.c     | 382 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 465 insertions(+), 3 deletions(-)
 create mode 100644 riscv/sbi-asm.S

diff --git a/riscv/Makefile b/riscv/Makefile
index 179a373d..548041ad 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -43,6 +43,7 @@ cflatobjs += lib/riscv/timer.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
+cflatobjs += riscv/sbi-asm.o
 
 ########################################
 
@@ -99,7 +100,7 @@ cflatobjs += lib/efi.o
 .PRECIOUS: %.so
 
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
-%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o
+%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) $(sbi-asm.o) %.aux.o
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
 
@@ -115,7 +116,7 @@ cflatobjs += lib/efi.o
 		-O binary $^ $@
 else
 %.elf: LDFLAGS += -pie -n -z notext
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) $(sbi-asm.o) %.aux.o
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
@@ -127,7 +128,7 @@ else
 endif
 
 generated-files = $(asm-offsets)
-$(tests:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
+$(tests:.$(exe)=.o) $(cstart.o) $(sbi-asm.o) $(cflatobjs): $(generated-files)
 
 arch_clean: asm_offsets_clean
 	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi,debug} \
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
new file mode 100644
index 00000000..f31bc096
--- /dev/null
+++ b/riscv/sbi-asm.S
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Helper assembly code routines for RISC-V SBI extension tests.
+ *
+ * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#define __ASSEMBLY__
+#include <config.h>
+#include <asm/csr.h>
+#include <asm/page.h>
+
+#define SBI_HSM_TEST_DONE       (1 << 0)
+#define SBI_HSM_TEST_SATP       (1 << 1)
+#define SBI_HSM_TEST_SIE        (1 << 2)
+#define SBI_HSM_TEST_HARTID_A1  (1 << 3)
+
+.section .text
+.balign 4
+.global sbi_hsm_check_hart_start
+sbi_hsm_check_hart_start:
+	li	t0, 0
+	csrr	t1, CSR_SATP
+	bnez	t1, 1f
+	li	t0, SBI_HSM_TEST_SATP
+1:	csrr	t1, CSR_SSTATUS
+	andi	t1, t1, SR_SIE
+	bnez	t1, 2f
+	ori	t0, t0, SBI_HSM_TEST_SIE
+2:	bne	a0, a1, 3f
+	ori	t0, t0, SBI_HSM_TEST_HARTID_A1
+3:	ori	t0, t0, SBI_HSM_TEST_DONE
+	la	t1, sbi_hsm_hart_start_checks
+	add	t1, t1, a0
+	sb	t0, 0(t1)
+4:	la	t0, sbi_hsm_stop_hart
+	add	t0, t0, a0
+	lb	t0, 0(t0)
+	pause
+	beqz	t0, 4b
+	li	a7, 0x48534d	/* SBI_EXT_HSM */
+	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
+	ecall
+	j	halt
+
+.balign 4
+.global sbi_hsm_check_non_retentive_suspend
+sbi_hsm_check_non_retentive_suspend:
+	li	t0, 0
+	csrr	t1, CSR_SATP
+	bnez	t1, 1f
+	li	t0, SBI_HSM_TEST_SATP
+1:	csrr	t1, CSR_SSTATUS
+	andi	t1, t1, SR_SIE
+	bnez	t1, 2f
+	ori	t0, t0, SBI_HSM_TEST_SIE
+2:	bne	a0, a1, 3f
+	ori	t0, t0, SBI_HSM_TEST_HARTID_A1
+3:	ori	t0, t0, SBI_HSM_TEST_DONE
+	la	t1, sbi_hsm_non_retentive_hart_suspend_checks
+	add	t1, t1, a0
+	sb	t0, 0(t1)
+4:	la	t0, sbi_hsm_stop_hart
+	add	t0, t0, a0
+	lb	t0, 0(t0)
+	pause
+	beqz	t0, 4b
+	li	a7, 0x48534d	/* SBI_EXT_HSM */
+	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
+	ecall
+	j	halt
+
+.section .data
+.balign PAGE_SIZE
+.global sbi_hsm_hart_start_checks
+sbi_hsm_hart_start_checks:			.space CONFIG_NR_CPUS
+.global sbi_hsm_non_retentive_hart_suspend_checks
+sbi_hsm_non_retentive_hart_suspend_checks:	.space CONFIG_NR_CPUS
+.global sbi_hsm_stop_hart
+sbi_hsm_stop_hart:				.space CONFIG_NR_CPUS
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 6469304b..25fc2e81 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -6,6 +6,8 @@
  */
 #include <libcflat.h>
 #include <alloc_page.h>
+#include <cpumask.h>
+#include <on-cpus.h>
 #include <stdlib.h>
 #include <string.h>
 #include <limits.h>
@@ -17,8 +19,10 @@
 #include <asm/io.h>
 #include <asm/isa.h>
 #include <asm/mmu.h>
+#include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
+#include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
 
@@ -425,6 +429,383 @@ static void check_dbcn(void)
 	report_prefix_pop();
 }
 
+#define SBI_HSM_TEST_DONE       (1 << 0)
+#define SBI_HSM_TEST_SATP       (1 << 1)
+#define SBI_HSM_TEST_SIE        (1 << 2)
+#define SBI_HSM_TEST_HARTID_A1  (1 << 3)
+
+static cpumask_t cpus_alive_after_start;
+static cpumask_t cpus_alive_after_retentive_suspend;
+extern void sbi_hsm_check_hart_start(void);
+extern void sbi_hsm_check_non_retentive_suspend(void);
+extern unsigned char sbi_hsm_stop_hart[NR_CPUS];
+extern unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
+extern unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];
+static void on_secondary_cpus_async(void (*func)(void *data), void *data)
+{
+	int cpu, me = smp_processor_id();
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+		on_cpu_async(cpu, func, data);
+	}
+}
+
+static bool cpumask_test_secondary_cpus(cpumask_t *mask)
+{
+	int cpu, me = smp_processor_id();
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+
+		if (!cpumask_test_cpu(cpu, mask))
+			return false;
+	}
+
+	return true;
+}
+
+static void hart_execute(void *data)
+{
+	int me = smp_processor_id();
+
+	cpumask_set_cpu(me, &cpus_alive_after_start);
+}
+
+static void hart_retentive_suspend(void *data)
+{
+	int me = smp_processor_id();
+	unsigned long hartid = current_thread_info()->hartid;
+	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_RETENTIVE, __pa(NULL), __pa(NULL));
+
+	if (ret.error)
+		report_fail("failed to retentive suspend hart %ld", hartid);
+	else
+		cpumask_set_cpu(me, &cpus_alive_after_retentive_suspend);
+}
+
+static void hart_non_retentive_suspend(void *data)
+{
+	unsigned long hartid = current_thread_info()->hartid;
+
+	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE,
+					     virt_to_phys(&sbi_hsm_check_non_retentive_suspend), hartid);
+
+	if (ret.error)
+		report_fail("failed to non-retentive suspend hart %ld", hartid);
+}
+
+static void hart_wait_on_status(unsigned long hartid, enum sbi_ext_hsm_sid status)
+{
+	struct sbiret ret = sbi_hart_get_status(hartid);
+
+	while (!ret.error && ret.value == status)
+		ret = sbi_hart_get_status(hartid);
+
+	if (ret.error)
+		report_fail("got %ld while waiting on status %u for hart %lx\n", ret.error, status, hartid);
+}
+
+static void check_hsm(void)
+{
+	struct sbiret ret;
+	unsigned long hartid;
+	unsigned char per_hart_start_checks, per_hart_non_retentive_suspend_checks;
+	unsigned long hart_mask[NR_CPUS / BITS_PER_LONG] = {0};
+	bool ipi_failed = false;
+	int cpu, me = smp_processor_id();
+
+	report_prefix_push("hsm");
+
+	if (!sbi_probe(SBI_EXT_HSM)) {
+		report_skip("hsm extension not available");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("hart_get_status");
+
+	hartid = current_thread_info()->hartid;
+	ret = sbi_hart_get_status(hartid);
+
+	if (ret.error == SBI_ERR_INVALID_PARAM) {
+		report_fail("current hartid is invalid");
+		report_prefix_popn(2);
+		return;
+	} else if (ret.value != SBI_EXT_HSM_STARTED) {
+		report_fail("current hart is not started");
+		report_prefix_popn(2);
+		return;
+	}
+
+	report_pass("status of current hart is started");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_start");
+
+	ret = sbi_hart_start(hartid, virt_to_phys(&hart_execute), __pa(NULL));
+	report(ret.error == SBI_ERR_ALREADY_AVAILABLE, "boot hart is already started");
+
+	ret = sbi_hart_start(ULONG_MAX, virt_to_phys(&hart_execute), __pa(NULL));
+	report(ret.error == SBI_ERR_INVALID_PARAM, "invalid hartid check");
+
+	if (nr_cpus < 2) {
+		report_skip("no other cpus to run the remaining hsm tests on");
+		report_prefix_popn(2);
+		return;
+	}
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+
+		hartid = cpus[cpu].hartid;
+		ret = sbi_hart_start(hartid, virt_to_phys(&sbi_hsm_check_hart_start), hartid);
+
+		if (ret.error) {
+			report_fail("failed to start test hart %ld", hartid);
+			report_prefix_popn(2);
+			return;
+		}
+	}
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+
+		hartid = cpus[cpu].hartid;
+
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
+		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
+		ret = sbi_hart_get_status(hartid);
+		report(!ret.error && ret.value == SBI_EXT_HSM_STARTED,
+		       "test hart with hartid %ld successfully started", hartid);
+	}
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+
+		hartid = cpus[cpu].hartid;
+
+		while (!((per_hart_start_checks = READ_ONCE(sbi_hsm_hart_start_checks[hartid]))
+			 & SBI_HSM_TEST_DONE))
+			cpu_relax();
+
+		report(per_hart_start_checks & SBI_HSM_TEST_SATP,
+		       "satp is zero for test hart %ld", hartid);
+		report(per_hart_start_checks & SBI_HSM_TEST_SIE,
+		       "sstatus.SIE is zero for test hart %ld", hartid);
+		report(per_hart_start_checks & SBI_HSM_TEST_HARTID_A1,
+		       "a0 and a1 are hartid for test hart %ld", hartid);
+	}
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_stop");
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+
+		hartid = cpus[cpu].hartid;
+		WRITE_ONCE(sbi_hsm_stop_hart[hartid], true);
+	}
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
+		ret = sbi_hart_get_status(hartid);
+		report(!ret.error && (ret.value == SBI_EXT_HSM_STOPPED),
+		       "test hart %ld successfully stopped", hartid);
+	}
+
+	/* Reset the stop flags so that we can reuse them after suspension tests */
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+
+		hartid = cpus[cpu].hartid;
+		WRITE_ONCE(sbi_hsm_stop_hart[hartid], false);
+	}
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_start");
+
+	on_secondary_cpus_async(hart_execute, NULL);
+
+	for_each_present_cpu(cpu) {
+		if (cpu == me)
+			continue;
+
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
+		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
+		ret = sbi_hart_get_status(hartid);
+		report(!ret.error && (ret.value == SBI_EXT_HSM_STARTED),
+		       "new hart with hartid %ld successfully started", hartid);
+	}
+
+	while (!cpumask_test_secondary_cpus(&cpu_idle_mask))
+		cpu_relax();
+
+	report(cpumask_full(&cpu_online_mask), "all cpus online");
+	report(cpumask_test_secondary_cpus(&cpus_alive_after_start),
+	       "all secondary harts successfully executed code after start");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_suspend");
+
+	if (sbi_probe(SBI_EXT_IPI)) {
+		on_secondary_cpus_async(hart_retentive_suspend, NULL);
+
+		for_each_present_cpu(cpu) {
+			if (cpu == me)
+				continue;
+
+			hartid = cpus[cpu].hartid;
+			hart_mask[hartid / BITS_PER_LONG] |= 1UL << hartid;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
+			ret = sbi_hart_get_status(hartid);
+			report(!ret.error && (ret.value == SBI_EXT_HSM_SUSPENDED),
+			       "hart %ld successfully retentive suspended", hartid);
+		}
+
+		for (int i = 0; i < NR_CPUS / BITS_PER_LONG; ++i) {
+			if (hart_mask[i]) {
+				ret = sbi_send_ipi(hart_mask[i], i * BITS_PER_LONG);
+				if (ret.error) {
+					ipi_failed = true;
+					report_fail("got %ld when sending ipi to retentive suspended harts",
+						    ret.error);
+					break;
+				}
+			}
+		}
+
+		if (!ipi_failed) {
+			for_each_present_cpu(cpu) {
+				if (cpu == me)
+					continue;
+
+				hartid = cpus[cpu].hartid;
+				hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
+				hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
+				ret = sbi_hart_get_status(hartid);
+				report(!ret.error && (ret.value == SBI_EXT_HSM_STARTED),
+				       "hart %ld successfully retentive resumed", hartid);
+			}
+
+			while (!cpumask_test_secondary_cpus(&cpu_idle_mask))
+				cpu_relax();
+
+			report(cpumask_full(&cpu_online_mask), "all cpus online");
+			report(cpumask_test_secondary_cpus(&cpus_alive_after_retentive_suspend),
+			       "all secondary harts successfully executed code after retentive suspend");
+		}
+
+		/* Reset the ipi_failed flag so that we can reuse it for non-retentive suspension tests */
+		ipi_failed = false;
+
+		on_secondary_cpus_async(hart_non_retentive_suspend, NULL);
+
+		for_each_present_cpu(cpu) {
+			if (cpu == me)
+				continue;
+
+			hartid = cpus[cpu].hartid;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
+			ret = sbi_hart_get_status(hartid);
+			report(!ret.error && (ret.value == SBI_EXT_HSM_SUSPENDED),
+			       "hart %ld successfully non-retentive suspended", hartid);
+		}
+
+		for (int i = 0; i < NR_CPUS / BITS_PER_LONG; ++i) {
+			if (hart_mask[i]) {
+				ret = sbi_send_ipi(hart_mask[i], i * BITS_PER_LONG);
+				if (ret.error) {
+					ipi_failed = true;
+					report_fail("got %ld when sending ipi to non-retentive suspended harts",
+						    ret.error);
+					break;
+				}
+			}
+		}
+
+		if (!ipi_failed) {
+			for_each_present_cpu(cpu) {
+				if (cpu == me)
+					continue;
+
+				hartid = cpus[cpu].hartid;
+				hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
+				hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
+				ret = sbi_hart_get_status(hartid);
+				report(!ret.error && (ret.value == SBI_EXT_HSM_STARTED),
+				       "hart %ld successfully non-retentive resumed", hartid);
+			}
+
+			for_each_present_cpu(cpu) {
+				if (cpu == me)
+					continue;
+
+				hartid = cpus[cpu].hartid;
+
+				while (!((per_hart_non_retentive_suspend_checks =
+					 READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid]))
+					 & SBI_HSM_TEST_DONE))
+					cpu_relax();
+
+				report(per_hart_non_retentive_suspend_checks & SBI_HSM_TEST_SATP,
+				       "satp is zero for test hart %ld", hartid);
+				report(per_hart_non_retentive_suspend_checks & SBI_HSM_TEST_SIE,
+				       "sstatus.SIE is zero for test hart %ld", hartid);
+				report(per_hart_non_retentive_suspend_checks & SBI_HSM_TEST_HARTID_A1,
+				       "a0 and a1 are hartid for test hart %ld", hartid);
+			}
+
+			report_prefix_pop();
+
+			report_prefix_push("hart_stop");
+
+			for_each_present_cpu(cpu) {
+				if (cpu == me)
+					continue;
+
+				hartid = cpus[cpu].hartid;
+				WRITE_ONCE(sbi_hsm_stop_hart[hartid], true);
+			}
+
+			for_each_present_cpu(cpu) {
+				if (cpu == me)
+					continue;
+
+				hartid = cpus[cpu].hartid;
+				hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+				hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
+				ret = sbi_hart_get_status(hartid);
+				report(!ret.error && (ret.value == SBI_EXT_HSM_STOPPED),
+				       "test hart %ld successfully stopped", hartid);
+			}
+		}
+	} else {
+		report_skip("skipping suspension tests since ipi extension is unavailable");
+	}
+
+	report_prefix_popn(2);
+}
+
 int main(int argc, char **argv)
 {
 	if (argc > 1 && !strcmp(argv[1], "-h")) {
@@ -435,6 +816,7 @@ int main(int argc, char **argv)
 	report_prefix_push("sbi");
 	check_base();
 	check_time();
+	check_hsm();
 	check_dbcn();
 
 	return report_summary();
-- 
2.43.0


