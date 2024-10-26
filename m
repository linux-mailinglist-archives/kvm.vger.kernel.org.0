Return-Path: <kvm+bounces-29752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA3419B19BC
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 18:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9A3D282292
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 16:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044FB1386B4;
	Sat, 26 Oct 2024 16:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ds9iOWH2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9AD1D278C
	for <kvm@vger.kernel.org>; Sat, 26 Oct 2024 16:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729959511; cv=none; b=RzOw1R/tLfFgsZlrHlB+vMKrn44gkQBYn25/jykG4tl7QXmfluw6Tx2kca7cff2InHJ3h4495rYBB8MLdcuZiXMTpHm5a9INEqww/wosxdPV4DhVOSuGWMhTemHgzmb0PMiJIVNNCcywNglU++0LwWlc4B+owUspT7jNH5ANyJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729959511; c=relaxed/simple;
	bh=bCTMv4sl/cvJf9tJ7nCOSfZ6a4rooWY+eiMp8UagDCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gW/cJFEsWkoPKaSq9wOSu2mohMnGgJ942n+kemYpnqPB/BgMNd990YgoGBFK0JMisMEykji/l6jAyLNk+z7v3GxYoi9+oTP7hvzzAOltKSWK6nyWvg/WvT8fMTV611T9IW7GN1jB2pGd/pFRT4vtdKk5mVainTFPA53CQuZhDCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ds9iOWH2; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7203c431f93so2393864b3a.1
        for <kvm@vger.kernel.org>; Sat, 26 Oct 2024 09:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729959506; x=1730564306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T0smmCl2Pl9lYuSwhonRnWZqPkBcB1aJnBGothIWogQ=;
        b=Ds9iOWH2p/REbaBJ1w6kkBCIBtNGaruS3G/UiPxCtj3jj3IrbUMzWu7qrjWsN9r2ez
         oqLiW35EAxk9RjUv4xakiCTz5gM/LMgZjzFl9h5YW4WYy+vMONGPCc3d7FZ/rnpOx0j2
         Ve0eLl8U+zRoTspPReWa2cNT5AxNctIlf6CwMNWdLc3c5etBe9y5BVwLgDGlmmCWdUXX
         NsgaGxMKDfVjf4nEJGtEedjl1ap+UZsRnNKDSbgNbKU4A3kyFeCUM1ftU5DzFfl2KDEE
         5w3anPMC7MIC4JHsaqEs5/XcM+ivpQui6tden0b0GqRezDZUvOEjI8Gp58EE7FqTmOQn
         PcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729959506; x=1730564306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T0smmCl2Pl9lYuSwhonRnWZqPkBcB1aJnBGothIWogQ=;
        b=xJZL3sojoPmkuxwCATI9ehS2bnSB5GEtIJWjZEt3UTQZ+Cfnl3wMXmGqeYZYqUBY6a
         MbzEaxP7iXOKNGmi7t9tvMe/dwKek9YYqFTdzV9h4eUzL6eRBcX9BmAf6WpaXTOgx57F
         x+pskAdSdIqGzs53cy/iGTnU+WyYKGhjO646U0CWPxD8pMuU7S7ruZOz619/TY7A9TFC
         bUJpaLzTrMjA11HG1QkBBVm4uibCo2hOPmmlkBjsPr9SVE//lWeamIC+/3wXhROrPNlo
         lOxfTBN6tPCjEg7I+fyezbD3f8Rj/PojBYxY0XcW8XgdEk5ZhBlfPxHH21Dh9mL97t4r
         g4KA==
X-Gm-Message-State: AOJu0YzDqdDPzzNYj4j+tA5OdAeC6rTYP1PPohBxLG2IMpTNX56fu10S
	VK9GlQBdxxElq6cjHuVhhK5OTc20+DcfHPFyyYEUfUUxidTab4H4htewe5ur
X-Google-Smtp-Source: AGHT+IF54vghMgTd/7p1j23WzVQMVZLs+gsvV+uemtll42vrtNOCvSF5dH+1jXhArYOssvGbGdz+vg==
X-Received: by 2002:a05:6a20:9e06:b0:1d9:6e67:de83 with SMTP id adf61e73a8af0-1d9a83b04f4mr4535871637.1.1729959506080;
        Sat, 26 Oct 2024 09:18:26 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a1fe53sm2904317b3a.162.2024.10.26.09.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 09:18:25 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v6 1/1] riscv: sbi: Add tests for HSM extension
Date: Sun, 27 Oct 2024 00:18:13 +0800
Message-ID: <20241026161813.17189-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241026161813.17189-1-jamestiotio@gmail.com>
References: <20241026161813.17189-1-jamestiotio@gmail.com>
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
 riscv/sbi.c | 663 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 663 insertions(+)

diff --git a/riscv/sbi.c b/riscv/sbi.c
index 6f2d3e35..b09e2e45 100644
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
@@ -833,6 +839,662 @@ static void check_susp(void)
 	report_prefix_pop();
 }
 
+unsigned char sbi_hsm_stop_hart[NR_CPUS];
+unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
+unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];
+cpumask_t sbi_hsm_started_hart_checks;
+static bool sbi_hsm_invalid_hartid_check;
+static bool sbi_hsm_timer_fired;
+extern void sbi_hsm_check_hart_start(void);
+extern void sbi_hsm_check_non_retentive_suspend(void);
+
+static void hsm_timer_irq_handler(struct pt_regs *regs)
+{
+	sbi_hsm_timer_fired = true;
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
+}
+
+static void hart_start_invalid_hartid(void *data)
+{
+	struct sbiret ret;
+
+	ret = sbi_hart_start(ULONG_MAX, virt_to_phys(&hart_empty_fn), 0);
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
+
+	/* Set opaque as hartid so that we can check a0 == a1, ensuring that a0 is hartid and a1 is opaque */
+	struct sbiret ret = sbi_hart_suspend(SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE,
+					     virt_to_phys(&sbi_hsm_check_non_retentive_suspend), hartid);
+
+	report_fail("failed to non-retentive suspend hart %ld (error=%ld)", hartid, ret.error);
+}
+
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
+static void hart_non_retentive_suspend_with_msb_set(void *data)
+{
+	unsigned long hartid = current_thread_info()->hartid;
+	unsigned long suspend_type = SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE | (_AC(1, UL) << (__riscv_xlen - 1));
+
+	/* Set opaque as hartid so that we can check a0 == a1, ensuring that a0 is hartid and a1 is opaque */
+	struct sbiret ret = sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type,
+				      virt_to_phys(&sbi_hsm_check_non_retentive_suspend), hartid, 0, 0, 0);
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
+	return sbi_hsm_timer_fired || ret.error;
+}
+
+static void check_hsm(void)
+{
+	struct sbiret ret;
+	unsigned long hartid;
+	cpumask_t secondary_cpus_mask, hsm_start, hsm_stop, hsm_suspend, hsm_resume, hsm_check;
+	bool ipi_unavailable = false;
+	bool suspend_with_msb = false, resume_with_msb = false, check_with_msb = false, stop_with_msb = false;
+	int cpu, me = smp_processor_id();
+	int max_cpus = getenv("SBI_MAX_CPUS") ? strtol(getenv("SBI_MAX_CPUS"), NULL, 0) : nr_cpus;
+	unsigned long hsm_timer_duration = getenv("SBI_HSM_TIMER_DURATION")
+					 ? strtol(getenv("SBI_HSM_TIMER_DURATION"), NULL, 0) : 200000;
+
+	max_cpus = MIN(max_cpus, nr_cpus);
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
+	for_each_present_cpu(cpu) {
+		if (sbi_hart_get_status(cpus[cpu].hartid).error == SBI_ERR_INVALID_PARAM)
+			set_cpu_present(cpu, false);
+	}
+
+	report(cpumask_weight(&cpu_present_mask) == nr_cpus, "all present harts have valid hartids");
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
+
+	/* Assume that previous tests have not cleaned up and stopped the secondary harts */
+	on_cpumask_async(&secondary_cpus_mask, hart_stop, NULL);
+
+	cpumask_clear(&hsm_stop);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
+			continue;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STOPPED)
+			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_stop);
+	}
+
+	report(cpumask_weight(&hsm_stop) == max_cpus - 1, "all secondary harts stopped");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_start");
+
+	cpumask_clear(&hsm_start);
+	cpumask_clear(&hsm_check);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		/* Set opaque as hartid so that we can check a0 == a1, ensuring that a0 is hartid and a1 is opaque */
+		ret = sbi_hart_start(hartid, virt_to_phys(&sbi_hsm_check_hart_start), hartid);
+		if (ret.error) {
+			report_fail("failed to start test hart %ld (error=%ld)", hartid, ret.error);
+			continue;
+		}
+
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED, hsm_timer_duration))
+			continue;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING, hsm_timer_duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error) {
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+			continue;
+		} else if (ret.value != SBI_EXT_HSM_STARTED) {
+			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+			continue;
+		} else {
+			cpumask_set_cpu(cpu, &hsm_start);
+		}
+
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
+		else if (!(sbi_hsm_hart_start_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
+			report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
+		else
+			cpumask_set_cpu(cpu, &hsm_check);
+	}
+
+	report(cpumask_weight(&hsm_start) == max_cpus - 1, "all secondary harts started");
+	report(cpumask_weight(&hsm_check) == max_cpus - 1,
+	       "all secondary harts have expected register values after hart start");
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_stop");
+
+	memset(sbi_hsm_stop_hart, 1, sizeof(sbi_hsm_stop_hart));
+
+	cpumask_clear(&hsm_stop);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
+			continue;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STOPPED)
+			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_stop);
+	}
+
+	report(cpumask_weight(&hsm_stop) == max_cpus - 1, "all secondary harts stopped");
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
+	on_cpumask_async(&secondary_cpus_mask, hart_execute, NULL);
+
+	cpumask_clear(&hsm_start);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOPPED, hsm_timer_duration))
+			continue;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_START_PENDING, hsm_timer_duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STARTED)
+			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_start);
+	}
+
+	report(cpumask_weight(&hsm_start) == max_cpus - 1, "all secondary harts started");
+
+	sbi_hsm_timer_fired = false;
+	timer_start(hsm_timer_duration);
+
+	while (cpumask_weight(&cpu_idle_mask) != max_cpus - 1 && !sbi_hsm_timer_fired)
+		cpu_relax();
+
+	timer_stop();
+
+	if (sbi_hsm_timer_fired)
+		report_info("hsm timer fired before all secondary harts started");
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
+	cpumask_clear(&hsm_suspend);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
+			continue;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
+			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_suspend);
+	}
+
+	report(cpumask_weight(&hsm_suspend) == max_cpus - 1, "all secondary harts retentive suspended");
+
+	/* Ignore the return value since we check the status of each hart anyway */
+	sbi_send_ipi_cpumask(&secondary_cpus_mask);
+
+	cpumask_clear(&hsm_resume);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration))
+			continue;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STARTED)
+			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_resume);
+	}
+
+	report(cpumask_weight(&hsm_resume) == max_cpus - 1, "all secondary harts retentive resumed");
+
+	sbi_hsm_timer_fired = false;
+	timer_start(hsm_timer_duration);
+
+	while (cpumask_weight(&cpu_idle_mask) != max_cpus - 1 && !sbi_hsm_timer_fired)
+		cpu_relax();
+
+	timer_stop();
+
+	if (sbi_hsm_timer_fired)
+		report_info("hsm timer fired before all secondary harts retentive resumed");
+
+	report(cpumask_weight(&cpu_idle_mask) == max_cpus - 1,
+	       "all secondary harts successfully executed code after retentive suspend");
+	report(cpumask_weight(&cpu_online_mask) == max_cpus,
+	       "all secondary harts online");
+
+	on_cpumask_async(&secondary_cpus_mask, hart_non_retentive_suspend, NULL);
+
+	cpumask_clear(&hsm_suspend);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
+			continue;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_SUSPENDED)
+			report_info("hart %ld status is not 'suspended' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_suspend);
+	}
+
+	report(cpumask_weight(&hsm_suspend) == max_cpus - 1, "all secondary harts non-retentive suspended");
+
+	/* Ignore the return value since we check the status of each hart anyway */
+	sbi_send_ipi_cpumask(&secondary_cpus_mask);
+
+	cpumask_clear(&hsm_resume);
+	cpumask_clear(&hsm_check);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration))
+			continue;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error) {
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+			continue;
+		} else if (ret.value != SBI_EXT_HSM_STARTED) {
+			report_info("hart %ld status is not 'started' (ret.value=%ld)", hartid, ret.value);
+			continue;
+		} else {
+			cpumask_set_cpu(cpu, &hsm_resume);
+		}
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
+			continue;
+		}
+
+		if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SATP))
+			report_info("satp is not zero for test hart %ld", hartid);
+		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_SIE))
+			report_info("sstatus.SIE is not zero for test hart %ld", hartid);
+		else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
+			report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
+		else
+			cpumask_set_cpu(cpu, &hsm_check);
+	}
+
+	report(cpumask_weight(&hsm_resume) == max_cpus - 1, "all secondary harts non-retentive resumed");
+	report(cpumask_weight(&hsm_check) == max_cpus - 1,
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
+	cpumask_clear(&hsm_stop);
+
+	for_each_cpu(cpu, &secondary_cpus_mask) {
+		hartid = cpus[cpu].hartid;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration))
+			continue;
+		if (hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration))
+			continue;
+
+		ret = sbi_hart_get_status(hartid);
+		if (ret.error)
+			report_info("hart %ld get status failed (error=%ld)", hartid, ret.error);
+		else if (ret.value != SBI_EXT_HSM_STOPPED)
+			report_info("hart %ld status is not 'stopped' (ret.value=%ld)", hartid, ret.value);
+		else
+			cpumask_set_cpu(cpu, &hsm_stop);
+	}
+
+	report(cpumask_weight(&hsm_stop) == max_cpus - 1, "all secondary harts stopped");
+
+	if (__riscv_xlen == 32 || ipi_unavailable) {
+		hsm_timer_teardown();
+		report_prefix_popn(2);
+		return;
+	}
+
+	report_prefix_pop();
+
+	report_prefix_push("hart_suspend");
+
+	/* Select just one secondary cpu to run suspension tests with MSB of suspend type being set */
+	cpu = cpumask_next(-1, &secondary_cpus_mask);
+	hartid = cpus[cpu].hartid;
+
+	/* Boot up the secondary cpu and let it proceed to the idle loop */
+	on_cpu(cpu, hart_empty_fn, NULL);
+
+	on_cpu_async(cpu, hart_retentive_suspend_with_msb_set, NULL);
+
+	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
+	    !hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration)) {
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
+	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration) &&
+	    !hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration)) {
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
+	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
+	    !hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPEND_PENDING, hsm_timer_duration)) {
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
+	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_SUSPENDED, hsm_timer_duration) &&
+	    !hart_wait_on_status(hartid, SBI_EXT_HSM_RESUME_PENDING, hsm_timer_duration)) {
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
+			else if (!(sbi_hsm_non_retentive_hart_suspend_checks[cpu] & SBI_HSM_TEST_HARTID_A1))
+				report_info("either a0 or a1 is not hartid for test hart %ld", hartid);
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
+	if (!hart_wait_on_status(hartid, SBI_EXT_HSM_STARTED, hsm_timer_duration) &&
+	    !hart_wait_on_status(hartid, SBI_EXT_HSM_STOP_PENDING, hsm_timer_duration)) {
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
+	hsm_timer_teardown();
+	report_prefix_popn(2);
+}
+
 int main(int argc, char **argv)
 {
 	if (argc > 1 && !strcmp(argv[1], "-h")) {
@@ -844,6 +1506,7 @@ int main(int argc, char **argv)
 	check_base();
 	check_time();
 	check_ipi();
+	check_hsm();
 	check_dbcn();
 	check_susp();
 
-- 
2.43.0


