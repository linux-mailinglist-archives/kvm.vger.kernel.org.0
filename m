Return-Path: <kvm+bounces-20638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06AED91B908
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 09:53:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ECB02860AC
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 07:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA7114D6E4;
	Fri, 28 Jun 2024 07:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="e051xH6V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FABC145340
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 07:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719561130; cv=none; b=GuNSjVWkETKfAPGkhsXRUMZoZDOTYYzjamBw0MAcIn/ZDpbv+XCPR4wbxqujD/f1QCJxFYYhQGoitI8gOgdnetlLp+dCRvS1yC6QMYMeewqCDDdR1+FC1oCX/pZ7TkGsfaBCeHfNUPzS0avoXk6klcAOIBSUuYB+XYvSfctfGXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719561130; c=relaxed/simple;
	bh=2/Gu1GKW3gCm5IsVIukdOBuH7a+DWyYtIl6k1cTTIA4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Qq2DOSV/WRRZrJ19j2/agCd5mA4u/aljvwM4VbPjS2DyFbL5LPnRVxq6XuvkQKbRnftsyhrBf+u7r9nA6xlR2+eOWY2BZhAzeeI+OBl1rzKnYa6QurIcFHMO943V54+rQEbIaWPaah9KpB0+L5HI2KAqMqGheKAiHiXKpQ8c6U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=e051xH6V; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-706b53ee183so1056403b3a.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 00:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1719561129; x=1720165929; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6fc3IuO6YmBNA8s0mWpyu1I7/gJNRg54J9fB76y1B8s=;
        b=e051xH6VN1JL1JL6PZROjMdygC5Ly5ntYuR4M3vZngwQOt8JYK6LMey6u4nJ/hevZj
         /V6Gt7KPSXuT0PROvVYfHuQzikMMEzsZQD7FXpVwdMtuEVUzUKDKl+XEy+gWXxoRt7I6
         o56TyOjoIMP6CNpVuIYtg/2NaQMxBS9NAnbDpx5qYTqpPvlwBU9Sy92MPE7BG+l1Bjdd
         /ThB5SB9rjCjAMtVdUkdKbexxAI2p251UB6R7cw4nzElkJkw7hS2MU1YvxRjhSt47Tyx
         o0labLteXJLzN5KqHcyKRRq5P6ksscueryPUmq7La+OHNbiRajrc64vLdPZRyUhat/xE
         Tsxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719561129; x=1720165929;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fc3IuO6YmBNA8s0mWpyu1I7/gJNRg54J9fB76y1B8s=;
        b=N9bSg4sq7koWdu/qDkHsc08Z7BxfVasACzhODjzfGi5lweobqFegpd+XVkJrgYdGCO
         D9qy/dsfY0jLIlD1U3enBpNSy85kGMErr91vqeNlzLHothTqajOhZp0+oUsJhZCrle5L
         kxgv3zhQ3poquQR6AiXRBeBOVb623MEOU8/8JBKF9MBxv3Ks/86ovM09rOw/UhhKIJQn
         u7LwpNsVnLvG21QHw2cwzcKKPLUjpkVmhGDnW5THhpyCefuFE/4kQmFrytEPdOZ07Wrn
         0P7N47ZODr4/Adyulv36/+txzzSohRUtFcn6Dck38/ofWzxV4NbyNGeOV3kPDDe8FFT1
         JIiw==
X-Forwarded-Encrypted: i=1; AJvYcCUfJmIuO0tPQ87gVy/NVUMjpoFS3WqJ6gMGEdFxUt2fB5IbkCFI+wgVVL2Wki/kqnEmj4BEeFQcUhjX+rABFZ/wyTYU
X-Gm-Message-State: AOJu0YyRPtTFcrOWXsGFUHuKxIG0ZFzBi1+ByXAzSoP+4Sy86hFtH5wS
	/qjZnNgk0QG3OxlrRQwtu81mLJjMhV870HVbcPICQ25B5Lx0SB4bKn76VZfKcR8=
X-Google-Smtp-Source: AGHT+IF3KuUY30k6Fxmt5zQarV5j2YsUdQtDIpW2glwEhLDfVpSu4XavuBx9WBfU01ZxprM4j4Fscw==
X-Received: by 2002:a05:6a00:2e96:b0:708:41c4:8849 with SMTP id d2e1a72fcca58-7085223cda8mr1543391b3a.9.1719561128579;
        Fri, 28 Jun 2024 00:52:08 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c69b53bf2sm685068a12.2.2024.06.28.00.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 00:52:08 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 28 Jun 2024 00:51:43 -0700
Subject: [PATCH v4 3/3] perf: RISC-V: Check standard event availability
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240628-misc_perf_fixes-v4-3-e01cfddcf035@rivosinc.com>
References: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
In-Reply-To: <20240628-misc_perf_fixes-v4-0-e01cfddcf035@rivosinc.com>
To: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org
Cc: Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
 Conor Dooley <conor.dooley@microchip.com>, 
 Samuel Holland <samuel.holland@sifive.com>, 
 Palmer Dabbelt <palmer@rivosinc.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

From: Samuel Holland <samuel.holland@sifive.com>

The RISC-V SBI PMU specification defines several standard hardware and
cache events. Currently, all of these events are exposed to userspace,
even when not actually implemented. They appear in the `perf list`
output, and commands like `perf stat` try to use them.

This is more than just a cosmetic issue, because the PMU driver's .add
function fails for these events, which causes pmu_groups_sched_in() to
prematurely stop scheduling in other (possibly valid) hardware events.

Add logic to check which events are supported by the hardware (i.e. can
be mapped to some counter), so only usable events are reported to
userspace. Since the kernel does not know the mapping between events and
possible counters, this check must happen during boot, when no counters
are in use. Make the check asynchronous to minimize impact on boot time.

Fixes: e9991434596f ("RISC-V: Add perf platform driver based on SBI PMU extension")

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Tested-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c    |  2 +-
 drivers/perf/riscv_pmu_sbi.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 04db1f993c47..bcf41d6e0df0 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -327,7 +327,7 @@ static long kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_att
 
 	event = perf_event_create_kernel_counter(attr, -1, current, kvm_riscv_pmu_overflow, pmc);
 	if (IS_ERR(event)) {
-		pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
+		pr_debug("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
 		return PTR_ERR(event);
 	}
 
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 94bc369a3454..4e842dcedfba 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -20,6 +20,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/sched/clock.h>
 #include <linux/soc/andes/irq.h>
+#include <linux/workqueue.h>
 
 #include <asm/errata_list.h>
 #include <asm/sbi.h>
@@ -114,7 +115,7 @@ struct sbi_pmu_event_data {
 	};
 };
 
-static const struct sbi_pmu_event_data pmu_hw_event_map[] = {
+static struct sbi_pmu_event_data pmu_hw_event_map[] = {
 	[PERF_COUNT_HW_CPU_CYCLES]		= {.hw_gen_event = {
 							SBI_PMU_HW_CPU_CYCLES,
 							SBI_PMU_EVENT_TYPE_HW, 0}},
@@ -148,7 +149,7 @@ static const struct sbi_pmu_event_data pmu_hw_event_map[] = {
 };
 
 #define C(x) PERF_COUNT_HW_CACHE_##x
-static const struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_MAX]
+static struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_MAX]
 [PERF_COUNT_HW_CACHE_OP_MAX]
 [PERF_COUNT_HW_CACHE_RESULT_MAX] = {
 	[C(L1D)] = {
@@ -293,6 +294,34 @@ static const struct sbi_pmu_event_data pmu_cache_event_map[PERF_COUNT_HW_CACHE_M
 	},
 };
 
+static void pmu_sbi_check_event(struct sbi_pmu_event_data *edata)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH,
+			0, cmask, 0, edata->event_idx, 0, 0);
+	if (!ret.error) {
+		sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP,
+			  ret.value, 0x1, SBI_PMU_STOP_FLAG_RESET, 0, 0, 0);
+	} else if (ret.error == SBI_ERR_NOT_SUPPORTED) {
+		/* This event cannot be monitored by any counter */
+		edata->event_idx = -EINVAL;
+	}
+}
+
+static void pmu_sbi_check_std_events(struct work_struct *work)
+{
+	for (int i = 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
+		pmu_sbi_check_event(&pmu_hw_event_map[i]);
+
+	for (int i = 0; i < ARRAY_SIZE(pmu_cache_event_map); i++)
+		for (int j = 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++)
+			for (int k = 0; k < ARRAY_SIZE(pmu_cache_event_map[i][j]); k++)
+				pmu_sbi_check_event(&pmu_cache_event_map[i][j][k]);
+}
+
+static DECLARE_WORK(check_std_events_work, pmu_sbi_check_std_events);
+
 static int pmu_sbi_ctr_get_width(int idx)
 {
 	return pmu_ctr_list[idx].width;
@@ -478,6 +507,12 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
 	u64 raw_config_val;
 	int ret;
 
+	/*
+	 * Ensure we are finished checking standard hardware events for
+	 * validity before allowing userspace to configure any events.
+	 */
+	flush_work(&check_std_events_work);
+
 	switch (type) {
 	case PERF_TYPE_HARDWARE:
 		if (config >= PERF_COUNT_HW_MAX)
@@ -1359,6 +1394,9 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_unregister;
 
+	/* Asynchronously check which standard events are available */
+	schedule_work(&check_std_events_work);
+
 	return 0;
 
 out_unregister:

-- 
2.34.1


