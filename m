Return-Path: <kvm+bounces-31391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3B69C33F1
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 18:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A730EB20F0A
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 17:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7CE13C683;
	Sun, 10 Nov 2024 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEYQQDpa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E8113BAEE
	for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731259020; cv=none; b=KZd5RngCD/cIPi/Rvz50LRuWzl3UsRfEize21TVfd0xGuOmuguptQe+ULB/KcLQ0dYIap5xAJEItvnDO6oMulq02U4Kx5yAQgw5/wR+UWYLoxi/ZwFNQYdb5f4EMA7Gh3XAG+CjqxydZVI53dL0xyZWnV2VMMTgHSf1GkrImoZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731259020; c=relaxed/simple;
	bh=6Lw5mTRP/rklE1HAFfKYvpG2oF5U8vmyY/cQP0HNxik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpMBw8mtENN/NPRWxHKhKsZnkr2eSpNEC267h1L139CeUkYBKsx98vNGriwgY9sd+NHQ1ZhwCrb1E1GC8sfasdrrYOkDHNZPhKqIOTQVA7WP7T993HSmo8uu6DEFudaUAVfvxYyXcZkmtujQrSE8c+2XPgzjJSPNk/WCCBVR8fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEYQQDpa; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-72097a5ca74so3209438b3a.3
        for <kvm@vger.kernel.org>; Sun, 10 Nov 2024 09:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731259018; x=1731863818; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iC7Lje7RrOq4k5vhxnJDbE02KGEXZFOrswm+uPxLgrA=;
        b=nEYQQDpazBdiwSfd3mh3tU8+ROCbsWPI+mbaenAlKfSzpWW3hjUyhXhFYMVC0N9XdO
         wQ7guQ6UMqm16zrXKcK9wVMr1PlB9kFW7wB1/oTdwW6vk5JwSM6kOjYpq7JXQxnH/Z3m
         nX5PgYkDptFfhG5Hf/I+31HAehKfgu8i6lDFV9NW0xg+C8cicyZkTPRCuuneUIm5ZSL8
         Psl9W2pTTAOkHkd0h1Dj1+koz7p+VUG9zOOk5bLOH8XoCHKS1fVPqkPQ7CuHeYhkO3HV
         JRcJ9AZBB+0KfrySpD2kG746eRTo/4SQOV0D+Ne4Tl9RQvT30QbG5/4a5kQrKCtbzCsi
         mr1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731259018; x=1731863818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iC7Lje7RrOq4k5vhxnJDbE02KGEXZFOrswm+uPxLgrA=;
        b=EDZ79EsK9visAbYpMj/JPVlkQyCG4TWevqbYG0YheBnsxZ43LhKafksE7aXxnjsbov
         nQvfeNp/0xyLfyxzJKN9Ka8TPqk+pDdluUqLtJA9MhPOjanT4zTnv7shyKyeTa6yTH1E
         2bJV7FkYRrdKhxSa72Q5mUWrKjqa63f8lV0NA0FHRNLzyVtri6f6WFEDezDTakyDPLSN
         /Qdm5MMOBkrUGSQt03XUv7OC84ZymNYLafpULTuKbe+fO343vlGedruYHEdRhhYSxgVL
         WqY0s0gUV2ra2JYbAcqbF3eW/UaQlOXF2zww75ZrCifESDuC7zQGeALvkpEPJVvpGG5q
         VvbA==
X-Gm-Message-State: AOJu0Ywl7eP+WBEzhEGltmBjF54TEzpFeU3tkbd3/yC1jf2/VafsJ2bj
	1OIbcAIDZqgMRrFdnL8pkk7dgO7vNEp5A3k2SOq5cOFsGWCgQR9I9hDcQ42c
X-Google-Smtp-Source: AGHT+IHuSBbX6fSymHm1xY/ztNHcxhIO7szbEHQlZjF+aJeSY7Wf3XEutQSg1G4voW+8ISpG4qOYAQ==
X-Received: by 2002:a05:6a20:840e:b0:1db:ebbf:4b8a with SMTP id adf61e73a8af0-1dc228932d4mr12408996637.7.1731259017641;
        Sun, 10 Nov 2024 09:16:57 -0800 (PST)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078641a2sm7578415b3a.20.2024.11.10.09.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 09:16:57 -0800 (PST)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v7 2/2] riscv: sbi: Add tests for HSM extension
Date: Mon, 11 Nov 2024 01:16:33 +0800
Message-ID: <20241110171633.113515-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241110171633.113515-1-jamestiotio@gmail.com>
References: <20241110171633.113515-1-jamestiotio@gmail.com>
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
 riscv/sbi.c | 612 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 612 insertions(+)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 300e5cc9..021b606c 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -21,6 +21,7 @@
 #include <asm/delay.h>
 #include <asm/io.h>
 #include <asm/mmu.h>
+#include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/sbi.h>
 #include <asm/setup.h>
@@ -54,6 +55,11 @@ static struct sbiret sbi_dbcn_write_byte(uint8_t byte)
 	return sbi_ecall(SBI_EXT_DBCN, SBI_EXT_DBCN_CONSOLE_WRITE_BYTE, byte, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
+{
+	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
+}
+
 static struct sbiret sbi_system_suspend(uint32_t sleep_type, unsigned long resume_addr, unsigned long opaque)
 {
 	return sbi_ecall(SBI_EXT_SUSP, 0, sleep_type, resume_addr, opaque, 0, 0, 0);
@@ -834,6 +840,611 @@ static void check_susp(void)
 	report_prefix_pop();
 }
 
+static const char *hart_state_str[] = {
+	[SBI_EXT_HSM_STARTED] = "started",
+	[SBI_EXT_HSM_STOPPED] = "stopped",
+	[SBI_EXT_HSM_SUSPENDED] = "suspended",
+};
+struct hart_state_transition_info {
+	enum sbi_ext_hsm_sid initial_state;
+	enum sbi_ext_hsm_sid intermediate_state;
+	enum sbi_ext_hsm_sid final_state;
+};
+static cpumask_t sbi_hsm_started_hart_checks;
+static bool sbi_hsm_invalid_hartid_check;
+static bool sbi_hsm_timer_fired;
+extern void sbi_hsm_check_hart_start(void);
+extern void sbi_hsm_check_non_retentive_suspend(void);
+
+static void hsm_timer_irq_handler(struct pt_regs *regs)
+{
+	timer_stop();
+	sbi_hsm_timer_fired = true;
+}
+
+static void hsm_timer_setup(void)
+{
+	install_irq_handler(IRQ_S_TIMER, hsm_timer_irq_handler);
+	timer_irq_enable();
+}
+
+static void hsm_timer_teardown(void)
+{
+	timer_irq_disable();
+	install_irq_handler(IRQ_S_TIMER, NULL);
+}
+
+static void hart_check_already_started(void *data)
+{
+	struct sbiret ret;
+	unsigned long hartid = current_thread_info()->hartid;
+	int me = smp_processor_id();
+
+	ret = sbi_hart_start(hartid, virt_to_phys(&start_cpu), 0);
+
+	if (ret.error == SBI_ERR_ALREADY_AVAILABLE)
+		cpumask_set_cpu(me, &sbi_hsm_started_hart_checks);
+}
+
+static void hart_start_invalid_hartid(void *data)
+{
+	struct sbiret ret;
+
+	ret = sbi_hart_start(-1UL, virt_to_phys(&start_cpu), 0);
+
+	if (ret.error == SBI_ERR_INVALID_PARAM)
+		sbi_hsm_invalid_hartid_check = true;
+}
+
+static void hart_stop(void *data)
+{
+	unsigned long hartid = current_thread_info()->hartid;
+	struct sbiret ret = sbi_hart_stop();
+
+	report_fail("failed to stop hart %ld (error=%ld)", hartid, ret.error);
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
+	unsigned long params[] = {
+		[SBI_HSM_MAGIC_IDX] = SBI_HSM_MAGIC,
+		[SBI_HSM_HARTID_IDX] = hartid,
+	};
+	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE,
+					     virt_to_phys(&sbi_hsm_check_non_retentive_suspend),
+					     virt_to_phys(params));
+
+	report_fail("failed to non-retentive suspend hart %ld (error=%ld)", hartid, ret.error);
+}
+
+/* This test function is only being run on RV64 to verify that upper bits of suspend_type are ignored */
+static void hart_retentive_suspend_with_msb_set(void *data)
+{
+	unsigned long hartid = current_thread_info()->hartid;
+	unsigned long suspend_type = SBI_EXT_HSM_HART_SUSPEND_RETENTIVE | (_AC(1, UL) << (__riscv_xlen - 1));
+	struct sbiret ret = sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, 0, 0, 0, 0, 0);
+
+	if (ret.error)
+		report_fail("failed to retentive suspend hart %ld with MSB set (error=%ld)", hartid, ret.error);
+}
+
+/* This test function is only being run on RV64 to verify that upper bits of suspend_type are ignored */
+static void hart_non_retentive_suspend_with_msb_set(void *data)
+{
+	unsigned long hartid = current_thread_info()->hartid;
+	unsigned long suspend_type = SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE | (_AC(1, UL) << (__riscv_xlen - 1));
+	unsigned long params[] = {
+		[SBI_HSM_MAGIC_IDX] = SBI_HSM_MAGIC,
+		[SBI_HSM_HARTID_IDX] = hartid,
+	};
+
+	struct sbiret ret = sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type,
+				      virt_to_phys(&sbi_hsm_check_non_retentive_suspend), virt_to_phys(params),
+				      0, 0, 0);
+
+	report_fail("failed to non-retentive suspend hart %ld with MSB set (error=%ld)", hartid, ret.error);
+}
+
+static bool hart_wait_on_status(unsigned long hartid, enum sbi_ext_hsm_sid status, unsigned long duration)
+{
+	struct sbiret ret;
+
+	sbi_hsm_timer_fired = false;
+	timer_start(duration);
+
+	ret = sbi_hart_get_status(hartid);
+
+	while (!ret.error && ret.value == status && !sbi_hsm_timer_fired) {
+		cpu_relax();
+		ret = sbi_hart_get_status(hartid);
+	}
+
+	timer_stop();
+
+	if (sbi_hsm_timer_fired)
+		report_info("timer fired while waiting on status %u for hart %ld", status, hartid);
+	else if (ret.error)
+		report_fail("got %ld while waiting on status %u for hart %ld\n", ret.error, status, hartid);
+
+	return !sbi_hsm_timer_fired && !ret.error;
+}
+
+static int hart_wait_state_transition(cpumask_t mask, unsigned long duration, struct hart_state_transition_info states)
+{
+	struct sbiret ret;
+	unsigned long hartid;
+	int cpu, count = 0;
+
+	for_each_cpu(cpu, &mask) {
+		hartid = cpus[cpu].hartid;
+		if (!hart_wait_on_status(hartid, states.initial_state, duration))
+			continue;
+		if (!hart_wait_on_status(hartid, states.intermediate_state, duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != states.final_state)
+			report_info("hart %ld status is not '%s' (ret.value=%ld)", hartid,
+				    hart_state_str[states.final_state], ret.value);
+		else
+			count++;
+	}
+
+	return count;
+}
+
+static void hart_wait_until_idle(int max_cpus, unsigned long duration)
+{
+	sbi_hsm_timer_fired = false;
+	timer_start(duration);
+
+	while (cpumask_weight(&cpu_idle_mask) != max_cpus - 1 && !sbi_hsm_timer_fired)
+		cpu_relax();
+
+	timer_stop();
+
+	if (sbi_hsm_timer_fired)
+		report_info("hsm timer fired before all secondary harts go to idle");
+}
+
+static void check_hsm(void)
+{
+	struct sbiret ret;
+	unsigned long hartid;
+	cpumask_t secondary_cpus_mask;
+	int hsm_start, hsm_stop, hsm_suspend, hsm_resume, hsm_check;
+	struct hart_state_transition_info transition_states;
+	bool ipi_unavailable = false;
+	bool suspend_with_msb = false, resume_with_msb = false, check_with_msb = false, stop_with_msb = false;
+	int cpu, me = smp_processor_id();
+	int max_cpus = getenv("SBI_MAX_CPUS") ? strtol(getenv("SBI_MAX_CPUS"), NULL, 0) : nr_cpus;
+	unsigned long hsm_timer_duration = getenv("SBI_HSM_TIMER_DURATION")
+					 ? strtol(getenv("SBI_HSM_TIMER_DURATION"), NULL, 0) : 200000;
+
+	max_cpus = MIN(MIN(max_cpus, nr_cpus), cpumask_weight(&cpu_present_mask));
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
+	if (max_cpus < 2) {
+		report_skip("no other cpus to run the remaining hsm tests on");
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("hart_stop");
+
+	cpumask_copy(&secondary_cpus_mask, &cpu_present_mask);
+	cpumask_clear_cpu(me, &secondary_cpus_mask);
+	hsm_timer_setup();
+	local_irq_enable();
+
+	/* Assume that previous tests have not cleaned up and stopped the secondary harts */
+	on_cpumask_async(&secondary_cpus_mask, hart_stop, NULL);
+
+	transition_states = (struct hart_state_transition_info) {
+		.initial_state = SBI_EXT_HSM_STARTED,
+		.intermediate_state = SBI_EXT_HSM_STOP_PENDING,
+		.final_state = SBI_EXT_HSM_STOPPED,
+	};
+	hsm_stop = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
+
+	report(hsm_stop == max_cpus - 1, "all secondary harts stopped");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_start");
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		sbi_hsm_hart_start_params[cpu * SBI_HSM_NUM_OF_PARAMS + SBI_HSM_MAGIC_IDX] = SBI_HSM_MAGIC;
+		sbi_hsm_hart_start_params[cpu * SBI_HSM_NUM_OF_PARAMS + SBI_HSM_HARTID_IDX] = hartid;
+
+		ret = sbi_hart_start(hartid, virt_to_phys(&sbi_hsm_check_hart_start),
+				     virt_to_phys(&sbi_hsm_hart_start_params[cpu * SBI_HSM_NUM_OF_PARAMS]));
+		if (ret.error) {
+			report_fail("failed to start test hart %ld (error=%ld)", hartid, ret.error);
+			continue;
+		}
+	}
+
+	transition_states = (struct hart_state_transition_info) {
+		.initial_state = SBI_EXT_HSM_STOPPED,
+		.intermediate_state = SBI_EXT_HSM_START_PENDING,
+		.final_state = SBI_EXT_HSM_STARTED,
+	};
+
+	hsm_start = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
+	hsm_check = 0;
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		sbi_hsm_timer_fired = false;
+		timer_start(hsm_timer_duration);
+
+		while (!(READ_ONCE(sbi_hsm_hart_start_checks[cpu]) & SBI_HSM_TEST_DONE) && !sbi_hsm_timer_fired)
+			cpu_relax();
+
+		timer_stop();
+
+		if (sbi_hsm_timer_fired) {
+			report_info("hsm timer fired before hart %ld is done with start checks", hartid);
+			continue;
+		}
+
+		if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_SATP))
+			report_info("satp is not zero for test hart %ld", hartid);
+		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_SIE))
+			report_info("sstatus.SIE is not zero for test hart %ld", hartid);
+		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_MAGIC_A1))
+			report_info("a1 does not start with magic for test hart %ld", hartid);
+		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
+			report_info("a0 is not hartid for test hart %ld", hartid);
+		else
+			hsm_check++;
+	}
+
+	report(hsm_start == max_cpus - 1, "all secondary harts started");
+	report(hsm_check == max_cpus - 1,
+	       "all secondary harts have expected register values after hart start");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_stop");
+
+	memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
+
+	transition_states = (struct hart_state_transition_info) {
+		.initial_state = SBI_EXT_HSM_STARTED,
+		.intermediate_state = SBI_EXT_HSM_STOP_PENDING,
+		.final_state = SBI_EXT_HSM_STOPPED,
+	};
+	hsm_stop = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
+
+	report(hsm_stop == max_cpus - 1, "all secondary harts stopped");
+
+	/* Reset the stop flags so that we can reuse them after suspension tests */
+	memset(sbi_hsm_stop_hart, 0, sizeof(sbi_hsm_stop_hart));
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_start");
+
+	/* Select just one secondary cpu to run the invalid hartid test */
+	on_cpu(cpumask_next(-1, &secondary_cpus_mask), hart_start_invalid_hartid, NULL);
+
+	report(sbi_hsm_invalid_hartid_check, "secondary hart refuse to start with invalid hartid");
+
+	on_cpumask_async(&secondary_cpus_mask, hart_check_already_started, NULL);
+
+	transition_states = (struct hart_state_transition_info) {
+		.initial_state = SBI_EXT_HSM_STOPPED,
+		.intermediate_state = SBI_EXT_HSM_START_PENDING,
+		.final_state = SBI_EXT_HSM_STARTED,
+	};
+
+	hsm_start = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
+
+	report(hsm_start == max_cpus - 1, "all secondary harts started");
+
+	hart_wait_until_idle(max_cpus, hsm_timer_duration);
+
+	report(cpumask_weight(&cpu_idle_mask) == max_cpus - 1,
+	       "all secondary harts successfully executed code after start");
+	report(cpumask_weight(&cpu_online_mask) == max_cpus, "all secondary harts online");
+	report(cpumask_weight(&sbi_hsm_started_hart_checks) == max_cpus - 1,
+	       "all secondary harts are already started");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_suspend");
+
+	if (!sbi_probe(SBI_EXT_IPI)) {
+		report_skip("skipping suspension tests since ipi extension is unavailable");
+		report_prefix_pop();
+		ipi_unavailable = true;
+		goto sbi_hsm_hart_stop_tests;
+	}
+
+	on_cpumask_async(&secondary_cpus_mask, hart_retentive_suspend, NULL);
+
+	transition_states = (struct hart_state_transition_info) {
+		.initial_state = SBI_EXT_HSM_STARTED,
+		.intermediate_state = SBI_EXT_HSM_SUSPEND_PENDING,
+		.final_state = SBI_EXT_HSM_SUSPENDED,
+	};
+
+	hsm_suspend = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
+
+	report(hsm_suspend == max_cpus - 1, "all secondary harts retentive suspended");
+
+	/* Ignore the return value since we check the status of each hart anyway */
+	sbi_send_ipi_cpumask(&secondary_cpus_mask);
+
+	transition_states = (struct hart_state_transition_info) {
+		.initial_state = SBI_EXT_HSM_SUSPENDED,
+		.intermediate_state = SBI_EXT_HSM_RESUME_PENDING,
+		.final_state = SBI_EXT_HSM_STARTED,
+	};
+
+	hsm_resume = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
+
+	report(hsm_resume == max_cpus - 1, "all secondary harts retentive resumed");
+
+	hart_wait_until_idle(max_cpus, hsm_timer_duration);
+
+	report(cpumask_weight(&cpu_idle_mask) == max_cpus - 1,
+	       "all secondary harts successfully executed code after retentive suspend");
+	report(cpumask_weight(&cpu_online_mask) == max_cpus,
+	       "all secondary harts online");
+
+	on_cpumask_async(&secondary_cpus_mask, hart_non_retentive_suspend, NULL);
+
+	transition_states = (struct hart_state_transition_info) {
+		.initial_state = SBI_EXT_HSM_STARTED,
+		.intermediate_state = SBI_EXT_HSM_SUSPEND_PENDING,
+		.final_state = SBI_EXT_HSM_SUSPENDED,
+	};
+
+	hsm_suspend = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
+
+	report(hsm_suspend == max_cpus - 1, "all secondary harts non-retentive suspended");
+
+	/* Ignore the return value since we check the status of each hart anyway */
+	sbi_send_ipi_cpumask(&secondary_cpus_mask);
+
+	transition_states = (struct hart_state_transition_info) {
+		.initial_state = SBI_EXT_HSM_SUSPENDED,
+		.intermediate_state = SBI_EXT_HSM_RESUME_PENDING,
+		.final_state = SBI_EXT_HSM_STARTED,
+	};
+
+	hsm_resume = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
+	hsm_check = 0;
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		sbi_hsm_timer_fired = false;
+		timer_start(hsm_timer_duration);
+
+		while (!((READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[cpu])) & SBI_HSM_TEST_DONE)
+			&& !sbi_hsm_timer_fired)
+			cpu_relax();
+
+		timer_stop();
+
+		if (sbi_hsm_timer_fired) {
+			report_info("hsm timer fired before hart %ld is done with non-retentive resume checks",
+				    hartid);
+			continue;
+		}
+
+		if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SATP))
+			report_info("satp is not zero for test hart %ld", hartid);
+		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SIE))
+			report_info("sstatus.SIE is not zero for test hart %ld", hartid);
+		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_MAGIC_A1))
+			report_info("a1 does not start with magic for test hart %ld", hartid);
+		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
+			report_info("a0 is not hartid for test hart %ld", hartid);
+		else
+			hsm_check++;
+	}
+
+	report(hsm_resume == max_cpus - 1, "all secondary harts non-retentive resumed");
+	report(hsm_check == max_cpus - 1,
+	       "all secondary harts have expected register values after non-retentive resume");
+
+	report_prefix_pop();
+
+sbi_hsm_hart_stop_tests:
+	report_prefix_push("hart_stop");
+
+	if (ipi_unavailable)
+		on_cpumask_async(&secondary_cpus_mask, hart_stop, NULL);
+	else
+		memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
+
+	transition_states = (struct hart_state_transition_info) {
+		.initial_state = SBI_EXT_HSM_STARTED,
+		.intermediate_state = SBI_EXT_HSM_STOP_PENDING,
+		.final_state = SBI_EXT_HSM_STOPPED,
+	};
+	hsm_stop = hart_wait_state_transition(secondary_cpus_mask, hsm_timer_duration, transition_states);
+
+	report(hsm_stop == max_cpus - 1, "all secondary harts stopped");
+
+	report_prefix_pop();
+
+	if (__riscv_xlen == 32 || ipi_unavailable) {
+		local_irq_disable();
+		hsm_timer_teardown();
+		report_prefix_pop();
+		return;
+	}
+
+	report_prefix_push("hart_suspend");
+
+	/* Select just one secondary cpu to run suspension tests with MSB of suspend type being set */
+	cpu = cpumask_next(-1, &secondary_cpus_mask);
+	hartid = cpus[cpu].hartid;
+
+	/* Boot up the secondary cpu and let it proceed to the idle loop */
+	on_cpu(cpu, start_cpu, NULL);
+
+	on_cpu_async(cpu, hart_retentive_suspend_with_msb_set, NULL);
+
+	if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
+	    hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration)) {
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
+			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
+		else
+			suspend_with_msb = true;
+	}
+
+	report(suspend_with_msb, "secondary hart retentive suspended with MSB set");
+
+	/* Ignore the return value since we manually validate the status of the hart anyway */
+	sbi_send_ipi_cpu(cpu);
+
+	if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration) &&
+	    hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration)) {
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STARTED)
+			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+		else
+			resume_with_msb = true;
+	}
+
+	report(resume_with_msb, "secondary hart retentive resumed with MSB set");
+
+	/* Reset these flags so that we can reuse them for the non-retentive suspension test */
+	suspend_with_msb = false;
+	resume_with_msb = false;
+	sbi_hsm_stop_hart[cpu] = 0;
+	sbi_hsm_non_retentive_hart_suspend_checks[cpu] = 0;
+
+	on_cpu_async(cpu, hart_non_retentive_suspend_with_msb_set, NULL);
+
+	if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
+	    hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration)) {
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
+			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
+		else
+			suspend_with_msb = true;
+	}
+
+	report(suspend_with_msb, "secondary hart non-retentive suspended with MSB set");
+
+	/* Ignore the return value since we manually validate the status of the hart anyway */
+	sbi_send_ipi_cpu(cpu);
+
+	if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration) &&
+	    hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration)) {
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STARTED)
+			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+		else
+			resume_with_msb = true;
+
+		sbi_hsm_timer_fired = false;
+		timer_start(hsm_timer_duration);
+
+		while (!((READ_ONCE(sbi_hsm_non_retentive_hart_suspend_checks[cpu])) & SBI_HSM_TEST_DONE)
+			&& !sbi_hsm_timer_fired)
+			cpu_relax();
+
+		timer_stop();
+
+		if (sbi_hsm_timer_fired) {
+			report_info("hsm timer fired before hart %ld is done with non-retentive resume checks",
+				    hartid);
+		} else {
+			if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SATP))
+				report_info("satp is not zero for test hart %ld", hartid);
+			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SIE))
+				report_info("sstatus.SIE is not zero for test hart %ld", hartid);
+			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_MAGIC_A1))
+				report_info("a1 does not start with magic for test hart %ld", hartid);
+			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
+				report_info("a0 is not hartid for test hart %ld", hartid);
+			else
+				check_with_msb = true;
+		}
+	}
+
+	report(resume_with_msb, "secondary hart non-retentive resumed with MSB set");
+	report(check_with_msb,
+	       "secondary hart has expected register values after non-retentive resume with MSB set");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_stop");
+
+	sbi_hsm_stop_hart[cpu] = 1;
+
+	if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
+	    hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration)) {
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STOPPED)
+			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
+		else
+			stop_with_msb = true;
+	}
+
+	report(stop_with_msb, "secondary hart stopped after suspension tests with MSB set");
+
+	local_irq_disable();
+	hsm_timer_teardown();
+	report_prefix_popn(2);
+}
+
 int main(int argc, char **argv)
 {
 	if (argc > 1 && !strcmp(argv[1], "-h")) {
@@ -845,6 +1456,7 @@ int main(int argc, char **argv)
 	check_base();
 	check_time();
 	check_ipi();
+	check_hsm();
 	check_dbcn();
 	check_susp();
 
-- 
2.43.0


