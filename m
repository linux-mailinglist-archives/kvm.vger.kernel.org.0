Return-Path: <kvm+bounces-26948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4EF197981E
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 20:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4FC0B21799
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 18:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6281C9DEB;
	Sun, 15 Sep 2024 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKqQT8Jr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2F02F4A
	for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 18:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726425315; cv=none; b=vFPmzQ7GTsexDo7d9luC5h+sfTnHpj6dJXpREk+OmpAhG5tMXB9YTgjbS5DEtw0B50+wpojidOxaBODSOtBH/HlClPEDs1j+wvSQyVQE1eH/ID0KTgDt5SFnZ6Z7xez/vAciQV6xvW0c7gwqB2B9McZCU/wjk8h0vS2tv0GtPVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726425315; c=relaxed/simple;
	bh=y5a/L3//Ix8/omuUUGPoTFGlxkSLNhdEc+C4z4Ab4aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRCPBt5DRhBfx3/ShvpaqBq36OyDJAP7RPLJcwQfwc3Hfd4XUZMwdKJFoHPcyTICSk8vl6fUPYUuxDdxGvOh1F3wSp2lb6SBaAKoG0UmHVVlNo/S88fXTqv65D2y8CzQUQRYZV/uQ28w7Uz4Cdgh+sEjFShhUW+Rlx/PFSKb2fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IKqQT8Jr; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-718f4fd89e5so3473412b3a.0
        for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 11:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726425312; x=1727030112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VecAxz5qXutxIU5JiDT/QHrCKYj1plrVx+KdpKdPfqM=;
        b=IKqQT8JreclJqdUgCmky1TTzjrabdW9o+qg4ttnPTsLXA6/KGwtN4CkiX+txNxznTW
         q7QeXvR4sBRYn/qnzxZCFzEM049EHFB8773MzFM2i7velw/jn5rd9CTtRGnKbwtmpYEv
         bh7BZDygJue0/T3gBQdxZu67H8sWVqSRE0NfEtHcEAOl2uGYu8fxiFp7fd3Qe0+fxOk/
         e1Llh/bnLwuqhUqTMjN6rmNndVkgFyoxYDDNW94HO+/fQfbwv51YFnGsSi6D+yHA9q3g
         3YuSRYTk0NAa74FwedkJICJswkUawp6dndWamgAZ+0Ee1E9Zpe3uuclf7prJxib9eehh
         HIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726425312; x=1727030112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VecAxz5qXutxIU5JiDT/QHrCKYj1plrVx+KdpKdPfqM=;
        b=VUmnhodWX3DAmZVjranIbnp5WAKMgAfmvAMc6d4Og9Mko9kaK+lJzyOyEIN+xj4YK7
         YEYcVif30t+3Nq0YIxtjW+y7M16NJ/CmWVqfAxhO6WOgDdqBFHWfi49Ba6Ng+1ANEnrG
         z5Rlew/+XSJyB3ujC8HhOdKTVzq+g1DLsbDO+voCeYfQa7Dge5NXBwX26V+CIrGnx5eG
         nap+4IHnsn8aT6aCu4/bHkTkPuCZ8V0XBtfQCIsWwkNs73oBRVdRYmdY0BjPZCKxZxT1
         ShrPWWXfIzGtjwhZUaAr/P+lR0KvT+g46xtQfrKpDchshcWUslKkpsaJxK5DoiNObCGy
         L9lw==
X-Gm-Message-State: AOJu0YzgmESAjwP/HJYiwyttDP0PzqBgdUcNY0Wq9Ec7O2aIF6vQE2pG
	gWt1580cIiy6ZMuaSsnrylpAIqHSRi+MyA3RZoB46XOe/KHsEACyarL6PPBx
X-Google-Smtp-Source: AGHT+IFDDmBePeYnMyo0qqm/QAnZwsdW39acBN/r8mR93xLAcMWihKaLxbJTmisw9J9rL++RFGkA+w==
X-Received: by 2002:a05:6a20:d523:b0:1d2:bbf2:4c0e with SMTP id adf61e73a8af0-1d2bbf24c8fmr6313164637.43.1726425312343;
        Sun, 15 Sep 2024 11:35:12 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db498de2d5sm2358874a12.15.2024.09.15.11.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 11:35:11 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v4 3/3] riscv: sbi: Add tests for HSM extension
Date: Mon, 16 Sep 2024 02:34:59 +0800
Message-ID: <20240915183459.52476-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240915183459.52476-1-jamestiotio@gmail.com>
References: <20240915183459.52476-1-jamestiotio@gmail.com>
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
 riscv/sbi.h |  10 +
 riscv/sbi.c | 561 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 571 insertions(+)
 create mode 100644 riscv/sbi.h

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
diff --git a/riscv/sbi.c b/riscv/sbi.c
index d4dfd48e..fab0091b 100644
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
@@ -16,11 +18,13 @@
 #include <asm/delay.h>
 #include <asm/io.h>
 #include <asm/mmu.h>
+#include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
 #include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
+#include <sbi.h>
 
 #define	HIGH_ADDR_BOUNDARY	((phys_addr_t)1 << 32)
 
@@ -47,6 +51,11 @@ static struct sbiret sbi_dbcn_write_byte(uint8_t byte)
 	return sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, byte, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
+{
+	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
+}
+
 static void split_phys_addr(phys_addr_t paddr, unsigned long *hi, unsigned long *lo)
 {
 	*lo = (unsigned long)paddr;
@@ -434,6 +443,557 @@ static void check_dbcn(void)
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
+static void hsm_timer_setup(void)
+{
+	install_irq_handler(IRQ_S_TIMER, hsm_timer_irq_handler);
+	local_irq_enable();
+	timer_irq_enable();
+}
+
+static void hsm_timer_teardown(void)
+{
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
+	while (!ret.error && ret.value == status && !hsm_timer_fired) {
+		cpu_relax();
+		ret = sbi_hart_get_status(hartid);
+	}
+
+	if (hsm_timer_fired)
+		report_info("timer fired while waiting on status %u for hart %ld", status, hartid);
+	else if (ret.error)
+		report_fail("got %ld while waiting on status %u for hart %ld\n", ret.error, status, hartid);
+}
+
+static void check_hsm(void)
+{
+	struct sbiret ret;
+	unsigned long hartid;
+	cpumask_t secondary_cpus_mask, hsm_start, hsm_stop, hsm_suspend, hsm_resume, hsm_check;
+	int cpu, me = smp_processor_id();
+	int max_cpu = getenv("SBI_HSM_MAX_CPU") ? strtol(getenv("SBI_HSM_MAX_CPU"), NULL, 0) : INT_MAX;
+	unsigned long hsm_timer_duration = getenv("SBI_HSM_TIMER_DURATION")
+					 ? strtol(getenv("SBI_HSM_TIMER_DURATION"), NULL, 0) : 200000;
+
+	max_cpu = MIN(max_cpu, nr_cpus - 1);
+
+	cpumask_copy(&secondary_cpus_mask, &cpu_present_mask);
+	cpumask_clear_cpu(me, &secondary_cpus_mask);
+	for_each_cpu(cpu, &secondary_cpus_mask)
+		if (cpu > max_cpu)
+			cpumask_clear_cpu(cpu, &secondary_cpus_mask);
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
+	if (max_cpu + 1 < 2) {
+		report_skip("no other cpus to run the remaining hsm tests on");
+		report_prefix_pop();
+		return;
+	}
+
+	/* This is necessary since we do not choose which cpu the boot hart will run on */
+	if (me > max_cpu)
+		max_cpu++;
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
+	cpumask_clear(&hsm_start);
+	hsm_timer_setup();
+	timer_start(hsm_timer_duration);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
+		if (hsm_timer_fired)
+			break;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
+		if (hsm_timer_fired)
+			break;
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STARTED)
+			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_start);
+	}
+
+	if (hsm_timer_fired) {
+		hsm_timer_teardown();
+		report_fail("hsm timer fired before all secondary harts started");
+		report_prefix_popn(2);
+		return;
+	}
+
+	report(cpumask_weight(&hsm_start) == max_cpu, "all secondary harts started");
+
+	cpumask_clear(&hsm_check);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+
+		while (!(READ_ONCE(sbi_hsm_hart_start_checks[cpu]) & SBI_HSM_TEST_DONE) && !hsm_timer_fired)
+			cpu_relax();
+
+		if (hsm_timer_fired)
+			break;
+
+		if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_SATP))
+			report_info("satp is not zero for test hart %ld", hartid);
+		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_SIE))
+			report_info("sstatus.SIE is not zero for test hart %ld", hartid);
+		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
+			report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
+		else
+			cpumask_set_cpu(cpu, &hsm_check);
+	}
+
+	if (hsm_timer_fired) {
+		hsm_timer_teardown();
+		report_fail("hsm timer fired before all secondary harts are done with checks");
+		report_prefix_popn(2);
+		return;
+	}
+
+	timer_stop();
+
+	report(cpumask_weight(&hsm_check) == max_cpu,
+	       "all secondary harts have expected register values after hart start");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_stop");
+
+	memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
+
+	cpumask_clear(&hsm_stop);
+	hsm_timer_fired = false;
+	timer_start(hsm_timer_duration);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+		if (hsm_timer_fired)
+			break;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
+		if (hsm_timer_fired)
+			break;
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STOPPED)
+			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_stop);
+	}
+
+	if (hsm_timer_fired) {
+		hsm_timer_teardown();
+		report_fail("hsm timer fired before all secondary harts stopped");
+		report_prefix_popn(2);
+		return;
+	}
+
+	timer_stop();
+
+	report(cpumask_weight(&hsm_stop) == max_cpu, "all secondary harts stopped");
+
+	/* Reset the stop flags so that we can reuse them after suspension tests */
+	memset(sbi_hsm_stop_hart, 0, sizeof(sbi_hsm_stop_hart));
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_start");
+
+	on_cpumask_async(&secondary_cpus_mask, hart_execute, NULL);
+
+	cpumask_clear(&hsm_start);
+	hsm_timer_fired = false;
+	timer_start(hsm_timer_duration);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED);
+		if (hsm_timer_fired)
+			break;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING);
+		if (hsm_timer_fired)
+			break;
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STARTED)
+			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_start);
+	}
+
+	if (hsm_timer_fired) {
+		hsm_timer_teardown();
+		report_fail("hsm timer fired before all secondary harts started");
+		report_prefix_popn(2);
+		return;
+	}
+
+	report(cpumask_weight(&hsm_start) == max_cpu, "all secondary harts started");
+
+	while (cpumask_weight(&cpu_idle_mask) != max_cpu && !hsm_timer_fired)
+		cpu_relax();
+
+	if (hsm_timer_fired) {
+		hsm_timer_teardown();
+		report_fail("hsm timer fired before all secondary harts started");
+		report_prefix_popn(2);
+		return;
+	}
+
+	timer_stop();
+
+	report(cpumask_weight(&cpu_idle_mask) == max_cpu,
+	       "all secondary harts successfully executed code after start");
+	report(cpumask_weight(&cpu_online_mask) == max_cpu + 1, "all secondary harts online");
+	report(cpumask_weight(&sbi_hsm_started_hart_checks) == max_cpu,
+	       "all secondary harts are already started");
+	report(cpumask_weight(&sbi_hsm_invalid_hartid_checks) == max_cpu,
+	       "all secondary harts refuse to start with invalid hartid");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_suspend");
+
+	if (!sbi_probe(SBI_EXT_IPI)) {
+		hsm_timer_teardown();
+		report_skip("skipping suspension tests since ipi extension is unavailable");
+		report_prefix_popn(2);
+		return;
+	}
+
+	on_cpumask_async(&secondary_cpus_mask, hart_retentive_suspend, NULL);
+
+	cpumask_clear(&hsm_suspend);
+	hsm_timer_fired = false;
+	timer_start(hsm_timer_duration);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+		if (hsm_timer_fired)
+			break;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
+		if (hsm_timer_fired)
+			break;
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
+			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_suspend);
+	}
+
+	if (hsm_timer_fired) {
+		hsm_timer_teardown();
+		report_fail("hsm timer fired before all secondary harts retentive suspended");
+		report_prefix_popn(2);
+		return;
+	}
+
+	timer_stop();
+
+	report(cpumask_weight(&hsm_suspend) == max_cpu, "all secondary harts retentive suspended");
+
+	ret = sbi_send_ipi_cpumask(&secondary_cpus_mask);
+
+	if (!ret.error) {
+		cpumask_clear(&hsm_resume);
+		hsm_timer_fired = false;
+		timer_start(hsm_timer_duration);
+
+		for_each_cpu(cpu, &secondary_cpus_mask) {
+			hartid = cpus[cpu].hartid;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
+			if (hsm_timer_fired)
+				break;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
+			if (hsm_timer_fired)
+				break;
+			ret = sbi_hart_get_status(hartid);
+			if (ret.error)
+				report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+			else if (ret.value != SBI_EXT_HSM_STARTED)
+				report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+			else
+				cpumask_set_cpu(cpu, &hsm_resume);
+		}
+
+		if (hsm_timer_fired) {
+			hsm_timer_teardown();
+			report_fail("hsm timer fired before all secondary harts retentive resumed");
+			report_prefix_popn(2);
+			return;
+		}
+
+		report(cpumask_weight(&hsm_resume) == max_cpu, "all secondary harts retentive resumed");
+
+		while (cpumask_weight(&cpu_idle_mask) != max_cpu && !hsm_timer_fired)
+			cpu_relax();
+
+		if (hsm_timer_fired) {
+			hsm_timer_teardown();
+			report_fail("hsm timer fired before all secondary harts retentive resumed");
+			report_prefix_popn(2);
+			return;
+		}
+
+		timer_stop();
+
+		report(cpumask_weight(&cpu_idle_mask) == max_cpu,
+		       "all secondary harts successfully executed code after retentive suspend");
+		report(cpumask_weight(&cpu_online_mask) == max_cpu + 1,
+		       "all secondary harts online");
+	}
+
+	on_cpumask_async(&secondary_cpus_mask, hart_non_retentive_suspend, NULL);
+
+	cpumask_clear(&hsm_suspend);
+	hsm_timer_fired = false;
+	timer_start(hsm_timer_duration);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+		if (hsm_timer_fired)
+			break;
+		hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING);
+		if (hsm_timer_fired)
+			break;
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
+			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_suspend);
+	}
+
+	if (hsm_timer_fired) {
+		hsm_timer_teardown();
+		report_fail("hsm timer fired before all secondary harts non-retentive suspended");
+		report_prefix_popn(2);
+		return;
+	}
+
+	timer_stop();
+
+	report(cpumask_weight(&hsm_suspend) == max_cpu, "all secondary harts non-retentive suspended");
+
+	ret = sbi_send_ipi_cpumask(&secondary_cpus_mask);
+
+	if (!ret.error) {
+		cpumask_clear(&hsm_resume);
+		hsm_timer_fired = false;
+		timer_start(hsm_timer_duration);
+
+		for_each_cpu(cpu, &secondary_cpus_mask) {
+			hartid = cpus[cpu].hartid;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED);
+			if (hsm_timer_fired)
+				break;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING);
+			if (hsm_timer_fired)
+				break;
+			ret = sbi_hart_get_status(hartid);
+			if (ret.error)
+				report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+			else if (ret.value != SBI_EXT_HSM_STARTED)
+				report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+			else
+				cpumask_set_cpu(cpu, &hsm_resume);
+		}
+
+		if (hsm_timer_fired) {
+			hsm_timer_teardown();
+			report_fail("hsm timer fired before all secondary harts non-retentive resumed");
+			report_prefix_popn(2);
+			return;
+		}
+
+		report(cpumask_weight(&hsm_resume) == max_cpu, "all secondary harts non-retentive resumed");
+
+		cpumask_clear(&hsm_check);
+
+		for_each_cpu(cpu, &secondary_cpus_mask) {
+			hartid = cpus[cpu].hartid;
+
+			while (!((READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[cpu])) & SBI_HSM_TEST_DONE)
+			       && !hsm_timer_fired)
+				cpu_relax();
+
+			if (hsm_timer_fired)
+				break;
+
+			if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SATP))
+				report_info("satp is not zero for test hart %ld", hartid);
+			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SIE))
+				report_info("sstatus.SIE is not zero for test hart %ld", hartid);
+			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
+				report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
+			else
+				cpumask_set_cpu(cpu, &hsm_check);
+		}
+
+		if (hsm_timer_fired) {
+			hsm_timer_teardown();
+			report_fail("hsm timer fired before all secondary harts are done with checks");
+			report_prefix_popn(2);
+			return;
+		}
+
+		timer_stop();
+
+		report(cpumask_weight(&hsm_check) == max_cpu,
+		       "all secondary harts have expected register values after non-retentive resume");
+
+		report_prefix_pop();
+
+		report_prefix_push("hart_stop");
+
+		memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
+
+		cpumask_clear(&hsm_stop);
+		hsm_timer_fired = false;
+		timer_start(hsm_timer_duration);
+
+		for_each_cpu(cpu, &secondary_cpus_mask) {
+			hartid = cpus[cpu].hartid;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED);
+			if (hsm_timer_fired)
+				break;
+			hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING);
+			if (hsm_timer_fired)
+				break;
+			ret = sbi_hart_get_status(hartid);
+			if (ret.error)
+				report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+			else if (ret.value != SBI_EXT_HSM_STOPPED)
+				report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
+			else
+				cpumask_set_cpu(cpu, &hsm_stop);
+		}
+
+		if (hsm_timer_fired) {
+			hsm_timer_teardown();
+			report_fail("hsm timer fired before all secondary harts stopped after resumption");
+			report_prefix_popn(2);
+			return;
+		}
+
+		timer_stop();
+
+		report(cpumask_weight(&hsm_stop) == max_cpu, "all secondary harts stopped after resumption");
+	}
+
+	hsm_timer_teardown();
+	report_prefix_popn(2);
+}
+
 int main(int argc, char **argv)
 {
 	if (argc > 1 && !strcmp(argv[1], "-h")) {
@@ -444,6 +1004,7 @@ int main(int argc, char **argv)
 	report_prefix_push("sbi");
 	check_base();
 	check_time();
+	check_hsm();
 	check_dbcn();
 
 	return report_summary();
-- 
2.43.0


