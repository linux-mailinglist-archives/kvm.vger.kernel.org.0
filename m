Return-Path: <kvm+bounces-26277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6DA1973B3F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:16:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4866A1F256F9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC5F619148A;
	Tue, 10 Sep 2024 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBzzOBH2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF9D199923
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725981350; cv=none; b=U3YQvTCpvzX8Rj7o3gTcveLnEydMSpeRm1vkpTg8otXkDLNwJqMb+QzJcaQPDlQ9MJjFFYv0ry8E/nsYLa6gnyJJJ8s9YGAbDdYXz1yvb5+2uvcehHbjAc7gsw1EfUFH3urrduKTI+XLnZFzYVTkC5iXq+cwjgQrMZyMyzlXd1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725981350; c=relaxed/simple;
	bh=1kxaj3I1YqzpJt7XFFVe9OnLu/MkFaOOxnqfmHS9/zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYNtt0NfZ5xU2zPAKhTcE5SQuPkLewlD6YdBIRXzeHCUCfLRqK1y/QVDS7HicYNUk61G1zkYQZT4YKY9VBnP/2TxCCW2Or4gE3B87wsCkusvV/IiCqC+1VGk7/sd1G/mEYDbXhKQG2Nsx7f1lIJzdVwbIaXSD3osShWWUsdu/tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBzzOBH2; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7dafd9df795so766947a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 08:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725981347; x=1726586147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hd/EJpNV11vMvxnPGz57RpVduGpkwGWxZZQrWdvgHaM=;
        b=jBzzOBH2rIciVIC3uk50Fc0FIuJxwe2hahDcPdOutfVq3XbmUt2Hyrkqk/To569GyL
         NxR0hXB5K6fdk5qq/wagjtzu9FDKPQXjcyvOFmM9Y/fY15Lzwvzpx046twdGm5IZJtpf
         UBubNo8EkMznM54B+MLyy7MzFIeOKvejNFJ5hZjBAS2bmpB78KJDaUkkawYRG7JEEfhg
         RBGqgPRieZ4ZLb0dv+IinmzbGWhQWItR9+/YBQjGxjP2GKJWXlasMavEp3K8nXtc0N6P
         VxDPFWSKNzAL0qKoNzlB31612c4QoNOA3bYE3GxcEB5FPHRoGuUgm9gMGRJwDTzyP3jr
         KP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725981347; x=1726586147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hd/EJpNV11vMvxnPGz57RpVduGpkwGWxZZQrWdvgHaM=;
        b=UciM7NHbU0Acg2Tk4NxlxLHKu1OXc45zNLN9KysekQ7qYxAFfRN5dxhM3D5BwCug7l
         yMP0wpApiyfXLh/1GlWUhAJC6nLgnquAN4zBnIulvLp/qS3YAHOlsN+IkkhYOsFu1pqr
         ArUDNFUA65V6wRSRhQzcuIclF+FsMPI0gQhIhKDXAuS4HCGV/E/1zU5s8TrQG9UTHyXi
         LR12aEKh9PW5eyJQ4zjASgj1QM8zfxwAjABNEZhFIIkMqzBonQz3849l8MwzPU0ryTA4
         vNZlA8o1GlPHedt6m4d63R+0QzYtrlbDy8L9dllwixrjI1vBRC4p5v18X1AuX4n80IBm
         sP2g==
X-Gm-Message-State: AOJu0Yz+NzyFhFLVQTCG9XzyQjbybLzpDhhI16hdSjDs28PRA5/i2SDt
	ou7b6Yw80H/q0WC1AVdxIYZqPvcoA52x4ktFFaeF1WPema9lW76xPP3k83v3
X-Google-Smtp-Source: AGHT+IHlPZID1elGuypkPjFaFFj/+JcfbHJCDt5PQgGacdwDq1QBgYQveRLTOuhbhtXm8lyAyo6ULg==
X-Received: by 2002:a05:6a21:a24c:b0:1cf:4b74:7659 with SMTP id adf61e73a8af0-1cf62cc32d3mr131043637.15.1725981346945;
        Tue, 10 Sep 2024 08:15:46 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d823cf3d58sm4939414a12.20.2024.09.10.08.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 08:15:46 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v3 2/2] riscv: sbi: Add tests for HSM extension
Date: Tue, 10 Sep 2024 23:15:36 +0800
Message-ID: <20240910151536.163830-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240910151536.163830-1-jamestiotio@gmail.com>
References: <20240910151536.163830-1-jamestiotio@gmail.com>
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
 riscv/Makefile  |   3 +-
 riscv/sbi.h     |  10 ++
 riscv/sbi-asm.S |  47 +++++++
 riscv/sbi.c     | 352 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 411 insertions(+), 1 deletion(-)
 create mode 100644 riscv/sbi.h
 create mode 100644 riscv/sbi-asm.S

diff --git a/riscv/Makefile b/riscv/Makefile
index 2ee7c5bb..4676d262 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -43,6 +43,7 @@ cflatobjs += lib/riscv/timer.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
+cflatobjs += riscv/sbi-asm.o
 
 ########################################
 
@@ -80,7 +81,7 @@ CFLAGS += -mcmodel=medany
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
-CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
+CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
 
 asm-offsets = lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
diff --git a/riscv/sbi.h b/riscv/sbi.h
new file mode 100644
index 00000000..e8625cb1
--- /dev/null
+++ b/riscv/sbi.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _RISCV_SBI_H_
+#define _RISCV_SBI_H_
+
+#define SBI_HSM_TEST_DONE	(1 << 0)
+#define SBI_HSM_TEST_SATP	(1 << 1)
+#define SBI_HSM_TEST_SIE	(1 << 2)
+#define SBI_HSM_TEST_HARTID_A1	(1 << 3)
+
+#endif /* _RISCV_SBI_H_ */
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
new file mode 100644
index 00000000..1b8b2fd8
--- /dev/null
+++ b/riscv/sbi-asm.S
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Helper assembly code routines for RISC-V SBI extension tests.
+ *
+ * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#define __ASSEMBLY__
+#include <config.h>
+#include <asm/csr.h>
+#include <sbi.h>
+
+.section .text
+.balign 4
+sbi_hsm_check:
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
+	add	t1, t6, a0	/* t6 is the address of the results array */
+	sb	t0, 0(t1)
+	la	t0, sbi_hsm_stop_hart
+	add	t1, t0, a0
+4:	lb	t0, 0(t1)
+	pause
+	beqz	t0, 4b
+	li	a7, 0x48534d	/* SBI_EXT_HSM */
+	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
+	ecall
+	j	halt
+
+.balign 4
+.global sbi_hsm_check_hart_start
+sbi_hsm_check_hart_start:
+	la	t6, sbi_hsm_hart_start_checks
+	j	sbi_hsm_check
+
+.balign 4
+.global sbi_hsm_check_non_retentive_suspend
+sbi_hsm_check_non_retentive_suspend:
+	la	t6, sbi_hsm_non_retentive_hart_suspend_checks
+	j	sbi_hsm_check
diff --git a/riscv/sbi.c b/riscv/sbi.c
index c9fbd6db..bf275630 100644
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
@@ -16,10 +18,13 @@
 #include <asm/delay.h>
 #include <asm/io.h>
 #include <asm/mmu.h>
+#include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
+#include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
+#include <sbi.h>
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
 
@@ -420,6 +425,352 @@ static void check_dbcn(void)
 	report_prefix_popn(2);
 }
 
+unsigned char sbi_hsm_stop_hart[NR_CPUS];
+unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
+unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];
+cpumask_t sbi_hsm_started_hart_checks;
+cpumask_t sbi_hsm_invalid_hartid_checks;
+static bool hsm_timer_fired;
+extern void sbi_hsm_check_hart_start(void);
+extern void sbi_hsm_check_non_retentive_suspend(void);
+
+static void hsm_timer_irq_handler(struct pt_regs *regs)
+{
+	hsm_timer_fired = true;
+	timer_stop();
+}
+
+static void hsm_timer_wait(int nr_secondary_cpus)
+{
+	unsigned long hsm_timer_duration = getenv("SBI_HSM_TIMER_DURATION")
+					 ? strtol(getenv("SBI_HSM_TIMER_DURATION"), NULL, 0) : 200000;
+
+	install_irq_handler(IRQ_S_TIMER, hsm_timer_irq_handler);
+	local_irq_enable();
+	timer_irq_enable();
+	timer_start(hsm_timer_duration);
+
+	while (cpumask_weight(&cpu_idle_mask) != nr_secondary_cpus && !hsm_timer_fired)
+		cpu_relax();
+
+	timer_irq_disable();
+	local_irq_disable();
+	install_irq_handler(IRQ_S_TIMER, NULL);
+}
+
+static void hart_empty_fn(void *data) {}
+
+static void hart_execute(void *data)
+{
+	struct sbiret ret;
+	unsigned long hartid = current_thread_info()->hartid;
+	int me = smp_processor_id();
+
+	ret = sbi_hart_start(hartid, virt_to_phys(&hart_empty_fn), 0);
+
+	if (ret.error == SBI_ERR_ALREADY_AVAILABLE)
+		cpumask_set_cpu(me, &sbi_hsm_started_hart_checks);
+
+	ret = sbi_hart_start(ULONG_MAX, virt_to_phys(&hart_empty_fn), 0);
+
+	if (ret.error == SBI_ERR_INVALID_PARAM)
+		cpumask_set_cpu(me, &sbi_hsm_invalid_hartid_checks);
+}
+
+static void hart_retentive_suspend(void *data)
+{
+	unsigned long hartid = current_thread_info()->hartid;
+	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_RETENTIVE, 0, 0);
+
+	if (ret.error)
+		report_fail("failed to retentive suspend hart %ld (error=%ld)", hartid, ret.error);
+}
+
+static void hart_non_retentive_suspend(void *data)
+{
+	unsigned long hartid = current_thread_info()->hartid;
+
+	/* Set opaque as hartid so that we can check a0 == a1, ensuring that a0 is hartid and a1 is opaque */
+	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE,
+					     virt_to_phys(&sbi_hsm_check_non_retentive_suspend), hartid);
+
+	report_fail("failed to non-retentive suspend hart %ld (error=%ld)", hartid, ret.error);
+}
+
+static void hart_wait_on_status(unsigned long hartid, enum sbi_ext_hsm_sid status)
+{
+	struct sbiret ret = sbi_hart_get_status(hartid);
+
+	while (!ret.error && ret.value == status) {
+		cpu_relax();
+		ret = sbi_hart_get_status(hartid);
+	}
+
+	if (ret.error)
+		report_fail("got %ld while waiting on status %u for hart %ld\n", ret.error, status, hartid);
+}
+
+static void check_hsm(void)
+{
+	struct sbiret ret;
+	unsigned long hartid;
+	bool ipi_failed = false;
+	int cpu, nr_secondary_cpus, me = smp_processor_id();
+	unsigned long max_cpu = getenv("SBI_HSM_MAX_CPU") ? strtol(getenv("SBI_HSM_MAX_CPU"), NULL, 0) : NR_CPUS;
+	cpumask_t secondary_cpus_mask;
+
+	cpumask_copy(&secondary_cpus_mask, &cpu_present_mask);
+	cpumask_clear_cpu(me, &secondary_cpus_mask);
+	for_each_cpu(cpu, &secondary_cpus_mask)
+		if (cpu >= max_cpu)
+			cpumask_clear_cpu(cpu, &secondary_cpus_mask);
+
+	nr_secondary_cpus = cpumask_weight(&secondary_cpus_mask);
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
+	if (ret.error) {
+		report_fail("failed to get status of current hart (error=%ld)", ret.error);
+		report_prefix_popn(2);
+		return;
+	} else if (ret.value != SBI_EXT_HSM_STARTED) {
+		report_fail("current hart is not started (ret.value=%ld)", ret.value);
+		report_prefix_popn(2);
+		return;
+	}
+
+	report_pass("status of current hart is started");
+
+	report_prefix_pop();
+
+	if (nr_cpus < 2) {
+		report_skip("no other cpus to run the remaining hsm tests on");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("hart_start");
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		/* Set opaque as hartid so that we can check a0 == a1, ensuring that a0 is hartid and a1 is opaque */
+		ret = sbi_hart_start(hartid, virt_to_phys(&sbi_hsm_check_hart_start), hartid);
+		if (ret.error) {
+			report_fail("failed to start test hart %ld (error=%ld)", hartid, ret.error);
+			report_prefix_popn(2);
+			return;
+		}
+	}
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
+		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
+		ret = sbi_hart_get_status(hartid);
+		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
+		report(ret.value == SBI_EXT_HSM_STARTED,
+		       "hart %ld start success (ret.value=%ld)", hartid, ret.value);
+	}
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+
+		while (!(READ_ONCE(sbi_hsm_hart_start_checks[hartid]) & SBI_HSM_TEST_DONE))
+			cpu_relax();
+
+		report(READ_ONCE(sbi_hsm_hart_start_checks[hartid]) & SBI_HSM_TEST_SATP,
+		       "satp is zero for test hart %ld", hartid);
+		report(READ_ONCE(sbi_hsm_hart_start_checks[hartid]) & SBI_HSM_TEST_SIE,
+		       "sstatus.SIE is zero for test hart %ld", hartid);
+		report(READ_ONCE(sbi_hsm_hart_start_checks[hartid]) & SBI_HSM_TEST_HARTID_A1,
+		       "a0 and a1 are hartid for test hart %ld", hartid);
+	}
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_stop");
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		WRITE_ONCE(sbi_hsm_stop_hart[hartid], true);
+	}
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
+		ret = sbi_hart_get_status(hartid);
+		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
+		report(ret.value == SBI_EXT_HSM_STOPPED,
+		       "hart %ld stop success (ret.value=%ld)", hartid, ret.value);
+	}
+
+	/* Reset the stop flags so that we can reuse them after suspension tests */
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		WRITE_ONCE(sbi_hsm_stop_hart[hartid], false);
+	}
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_start");
+
+	on_cpumask_async(&secondary_cpus_mask, hart_execute, NULL);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
+		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
+		ret = sbi_hart_get_status(hartid);
+		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
+		report(ret.value == SBI_EXT_HSM_STARTED,
+		       "hart %ld start success (ret.value=%ld)", hartid, ret.value);
+	}
+
+	hsm_timer_wait(nr_secondary_cpus);
+
+	if (hsm_timer_fired) {
+		report_fail("hsm timer fired before all secondary harts started");
+		report_prefix_popn(2);
+		return;
+	}
+
+	report(cpumask_weight(&cpu_idle_mask) == nr_secondary_cpus,
+	       "all secondary harts successfully executed code after start");
+	report(cpumask_weight(&cpu_online_mask) == nr_secondary_cpus + 1, "all secondary harts online");
+	report(cpumask_weight(&sbi_hsm_started_hart_checks) == nr_secondary_cpus,
+	       "all secondary harts are already started");
+	report(cpumask_weight(&sbi_hsm_invalid_hartid_checks) == nr_secondary_cpus,
+	       "all secondary harts refuse to start with invalid hartid");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_suspend");
+
+	if (!sbi_probe(SBI_EXT_IPI)) {
+		report_skip("skipping suspension tests since ipi extension is unavailable");
+		report_prefix_popn(2);
+		return;
+	}
+
+	on_cpumask_async(&secondary_cpus_mask, hart_retentive_suspend, NULL);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+		hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
+		ret = sbi_hart_get_status(hartid);
+		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
+		report(ret.value == SBI_EXT_HSM_SUSPENDED,
+		       "hart %ld retentive suspend success (ret.value=%ld)", hartid, ret.value);
+	}
+
+	sbi_send_ipi_cpumask(&secondary_cpus_mask);
+
+	if (!ipi_failed) {
+		for_each_cpu(cpu, &secondary_cpus_mask) {
+			hartid = cpus[cpu].hartid;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
+			hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
+			ret = sbi_hart_get_status(hartid);
+			report(ret.error == SBI_SUCCESS,
+			       "hart %ld get status success (error=%ld)", hartid, ret.error);
+			report(ret.value == SBI_EXT_HSM_STARTED,
+			       "hart %ld retentive resume success (ret.value=%ld)", hartid, ret.value);
+		}
+
+		hsm_timer_wait(nr_secondary_cpus);
+
+		if (hsm_timer_fired) {
+			report_fail("hsm timer fired before all secondary harts retentive resumed");
+			report_prefix_popn(2);
+			return;
+		}
+
+		report(cpumask_weight(&cpu_idle_mask) == nr_secondary_cpus,
+		       "all secondary harts successfully executed code after retentive suspend");
+		report(cpumask_weight(&cpu_online_mask) == nr_secondary_cpus + 1,
+		       "all secondary harts online");
+	}
+
+	/* Reset the ipi_failed flag so that we can reuse it for non-retentive suspension tests */
+	ipi_failed = false;
+
+	on_cpumask_async(&secondary_cpus_mask, hart_non_retentive_suspend, NULL);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+		hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
+		ret = sbi_hart_get_status(hartid);
+		report(ret.error == SBI_SUCCESS, "hart %ld get status success (error=%ld)", hartid, ret.error);
+		report(ret.value == SBI_EXT_HSM_SUSPENDED,
+		       "hart %ld non-retentive suspend success (ret.value=%ld)", hartid, ret.value);
+	}
+
+	sbi_send_ipi_cpumask(&secondary_cpus_mask);
+
+	if (!ipi_failed) {
+		for_each_cpu(cpu, &secondary_cpus_mask) {
+			hartid = cpus[cpu].hartid;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
+			hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
+			ret = sbi_hart_get_status(hartid);
+			report(ret.error == SBI_SUCCESS,
+			       "hart %ld get status success (error=%ld)", hartid, ret.error);
+			report(ret.value == SBI_EXT_HSM_STARTED,
+			       "hart %ld non-retentive resume success (ret.value=%ld)", hartid, ret.value);
+		}
+
+		for_each_cpu(cpu, &secondary_cpus_mask) {
+			hartid = cpus[cpu].hartid;
+
+			while (!((READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid])) & SBI_HSM_TEST_DONE))
+				cpu_relax();
+
+			report(READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid]) & SBI_HSM_TEST_SATP,
+			       "satp is zero for test hart %ld", hartid);
+			report(READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid]) & SBI_HSM_TEST_SIE,
+			       "sstatus.SIE is zero for test hart %ld", hartid);
+			report(READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[hartid]) & SBI_HSM_TEST_HARTID_A1,
+			       "a0 and a1 are hartid for test hart %ld", hartid);
+		}
+
+		report_prefix_pop();
+
+		report_prefix_push("hart_stop");
+
+		for_each_cpu(cpu, &secondary_cpus_mask) {
+			hartid = cpus[cpu].hartid;
+			WRITE_ONCE(sbi_hsm_stop_hart[hartid], true);
+		}
+
+		for_each_cpu(cpu, &secondary_cpus_mask) {
+			hartid = cpus[cpu].hartid;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+			hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
+			ret = sbi_hart_get_status(hartid);
+			report(ret.error == SBI_SUCCESS,
+			       "hart %ld get status success (error=%ld)", hartid, ret.error);
+			report(ret.value == SBI_EXT_HSM_STOPPED,
+			       "hart %ld stop after retention success (ret.value=%ld)", hartid, ret.value);
+		}
+	}
+
+	report_prefix_popn(2);
+}
+
 int main(int argc, char **argv)
 {
 	if (argc > 1 && !strcmp(argv[1], "-h")) {
@@ -430,6 +781,7 @@ int main(int argc, char **argv)
 	report_prefix_push("sbi");
 	check_base();
 	check_time();
+	check_hsm();
 	check_dbcn();
 
 	return report_summary();
-- 
2.43.0


