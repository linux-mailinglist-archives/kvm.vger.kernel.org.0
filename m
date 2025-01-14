Return-Path: <kvm+bounces-35472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A6D3A114CA
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:02:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98FB41648AB
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF0222759B;
	Tue, 14 Jan 2025 22:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="PDs9JcNZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46239226883
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895527; cv=none; b=RGPaWGz8Tp+MT42DgZ0h8eW+7nsmSAUQRw7EFtEVuUdaxChpZ9k6g7IJh1yB/rt9CIp91okDZuH8P3y0l4WwZOBDihbv/lentyIbf9ORMKEtMroq1cNoDhCh7MedgsSYYyTyfiaxn6E/tjGadhrA1CJuiUmKXpb5RLdTYCcrPGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895527; c=relaxed/simple;
	bh=HiTXq6OQK4mbtcvGc/N9RwcHNfGrvhnCJNp02HkOAWs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V2hm81SdQKc9QU5eJcMpU1jW3j9Zf8/lFbeNEObYJ6JsjVKPlLQl07HmbMRlt4kGR0WfqMPw5XY/Ak4Tnwp9yvbsObTV6WVoEqmVmlSASQTcZI4aiCknAOAulcwF4XwOjPhzY/oUeoLtTG3Cs1lo59e4C9s0qUIeFwlq6ZelGiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=PDs9JcNZ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21675fd60feso134182405ad.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895524; x=1737500324; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R5NzVVWM8qA9Fo1+GRIirXQzRfzq/r/+NUc9JNQjhEc=;
        b=PDs9JcNZCoTeXnLTLCEEOn5O7icdomuySvkAjmy3PF9sf0RnD9bKC9TmQTBHdjM+iM
         VyJdkcREqNEfLtwRI93JIG/qKUvMzynW9OTew3BbGgajB/15xMiU2XDdXn1gYm1SGZ1i
         YY/8DCOxkPqeKqf/Voacmu9Lq5j7/52Z+9iGwH/jX2hFIC2RUgySCuXxoxIlQFc7wg0P
         UTRq6xqHoJc/cZaRyRtXCSibubX5B7vjIjSqDAQM2zceYGUB9jVnTeZt7AW60tRCS3ES
         XhWZEHbQmIx21QHRZnlXuz1w0IXBBfXEG001bM2EqLPS+h6GO7MHwwN6CG6G1NqnjWLA
         dmzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895524; x=1737500324;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R5NzVVWM8qA9Fo1+GRIirXQzRfzq/r/+NUc9JNQjhEc=;
        b=D3hGgkBW/NofJVjyEcOPLu84k3sd65XWRHkMhGceTfiNyTTg2A58lQsQE0itZHqpDT
         99G//xyjmOuIhumw97AzwfPr5wbGJBBZtmSqcHDpRQyUiSi2y8YATetpV0Cvc/FWce3W
         EI1WcE2ZzxvHBB1v4veyLTZfYraZBLImLWRQ0+bIn61FKZJdCHOUhUPEWLxTxQpdMP07
         BG/9ignmJhg+OObgEJcmQghQLzIRj7g7xLyTZeSb82V+a0+GtiIkh17xIxFEscU951y0
         NfHbNW51bLu1cRZgdABt/H8Gt/C+tTuBJ7Uo/a/eEQIUYf+xMYR6JmOIUdhV2Gi+sP5O
         8V6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV2Eojtvwf4go8FgONzpQiPGY21VmuyyncRU/qp1P0tto6JaPzZfIi0qgHk4oWRODqac00=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6a2WRB4X4t4CtniXgNG9Bt3yHZ2T4dMhovmSlzvT9MzlmyEFx
	v1M/hUN31zEQ2cUaqSv9PDo/GsD6/wVCxeaGuDD63Rj4W5/sFVNzlbyqNtTqyKY=
X-Gm-Gg: ASbGnctP6YIqRvIZy+ydqda5LWYKORAB/8libh8jaJip5m0PZsVtjt9OXTAwRErAKa3
	7ai1Kcns0EjI5di6fEMVvVjveF3ZpiAByoU8/SWMdZjEltj0gvOxKRsXRPA4b5mj0nwGCRGms+K
	Iq4WZFMUBX0w9OpmTcnEq+gECZ61Zb6sjDdkj6YdqIvpfgEy/v61cBkSGcee70Ndmr/pCZw2yau
	SgYyL34amuESa0GH6IBXtv7n5sZ+Busb4/ZOyY6GAe8dXL7H2qxSyOiJ+081GV4Vg7lbQ==
X-Google-Smtp-Source: AGHT+IEMFajbox3otJ+OHxS2DGlG5iVgYY9Ppx0qRDeaLCpVzaKhI8pKM7MfO5qFetS73gaIgtP45A==
X-Received: by 2002:a17:903:32c3:b0:215:f1c2:fcc4 with SMTP id d9443c01a7336-21a83fe4f63mr405013495ad.41.1736895524581;
        Tue, 14 Jan 2025 14:58:44 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:44 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:40 -0800
Subject: [PATCH v2 15/21] RISC-V: perf: Skip PMU SBI extension when not
 implemented
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-15-8ba74cdb851b@rivosinc.com>
References: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
In-Reply-To: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Palmer Dabbelt <palmer@sifive.com>, Conor Dooley <conor@kernel.org>, 
 devicetree@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-perf-users@vger.kernel.org, Atish Patra <atishp@rivosinc.com>, 
 Charlie Jenkins <charlie@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

From: Charlie Jenkins <charlie@rivosinc.com>

When the PMU SBI extension is not implemented, sbi_v2_available should
not be set to true. The SBI implementation for counter config matching
and firmware counter read  should also be skipped when the SBI extension
is not implemented.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
---
 drivers/perf/riscv_pmu_dev.c | 46 ++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.c
index c80f8ef79204..83e7d1f6b016 100644
--- a/drivers/perf/riscv_pmu_dev.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -410,18 +410,22 @@ static void rvpmu_sbi_check_event(struct sbi_pmu_event_data *edata)
 	}
 }
 
-static void rvpmu_sbi_check_std_events(struct work_struct *work)
+static void rvpmu_check_std_events(struct work_struct *work)
 {
-	for (int i = 0; i < ARRAY_SIZE(pmu_hw_event_map); i++)
-		rvpmu_sbi_check_event(&pmu_hw_event_map[i]);
-
-	for (int i = 0; i < ARRAY_SIZE(pmu_cache_event_map); i++)
-		for (int j = 0; j < ARRAY_SIZE(pmu_cache_event_map[i]); j++)
-			for (int k = 0; k < ARRAY_SIZE(pmu_cache_event_map[i][j]); k++)
-				rvpmu_sbi_check_event(&pmu_cache_event_map[i][j][k]);
+	if (riscv_pmu_sbi_available()) {
+		for (int i = 0; i < ARRAY_SIZE(pmu_hw_event_sbi_map); i++)
+			rvpmu_sbi_check_event(&pmu_hw_event_sbi_map[i]);
+
+		for (int i = 0; i < ARRAY_SIZE(pmu_cache_event_sbi_map); i++)
+			for (int j = 0; j < ARRAY_SIZE(pmu_cache_event_sbi_map[i]); j++)
+				for (int k = 0; k < ARRAY_SIZE(pmu_cache_event_sbi_map[i][j]); k++)
+					rvpmu_sbi_check_event(&pmu_cache_event_sbi_map[i][j][k]);
+	} else {
+		DO_ONCE_LITE_IF(1, pr_err, "Boot time config matching not required for smcdeleg\n");
+	}
 }
 
-static DECLARE_WORK(check_std_events_work, rvpmu_sbi_check_std_events);
+static DECLARE_WORK(check_std_events_work, rvpmu_check_std_events);
 
 static ssize_t rvpmu_format_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
@@ -549,6 +553,9 @@ static int rvpmu_sbi_ctr_get_idx(struct perf_event *event)
 
 	cflags = rvpmu_sbi_get_filter_flags(event);
 
+	if (!riscv_pmu_sbi_available())
+		return -ENOENT;
+
 	/*
 	 * In legacy mode, we have to force the fixed counters for those events
 	 * but not in the user access mode as we want to use the other counters
@@ -562,10 +569,9 @@ static int rvpmu_sbi_ctr_get_idx(struct perf_event *event)
 			cflags |= SBI_PMU_CFG_FLAG_SKIP_MATCH;
 			ctr_mask = BIT(CSR_INSTRET - CSR_CYCLE);
 		}
-	}
-
-	if (pmu_sbi_is_fw_event(event) && cdeleg_available)
+	} else if (pmu_sbi_is_fw_event(event) && cdeleg_available) {
 		ctr_mask = firmware_cmask;
+	}
 
 	/* retrieve the available counter index */
 #if defined(CONFIG_32BIT)
@@ -871,7 +877,7 @@ static u64 rvpmu_ctr_read(struct perf_event *event)
 		return val;
 	}
 
-	if (pmu_sbi_is_fw_event(event)) {
+	if (pmu_sbi_is_fw_event(event) && riscv_pmu_sbi_available()) {
 		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ,
 				hwc->idx, 0, 0, 0, 0, 0);
 		if (ret.error)
@@ -1952,14 +1958,16 @@ static int __init rvpmu_devinit(void)
 	int ret;
 	struct platform_device *pdev;
 
-	if (sbi_spec_version >= sbi_mk_version(0, 3) &&
-	    sbi_probe_extension(SBI_EXT_PMU)) {
-		static_branch_enable(&riscv_pmu_sbi_available);
-		sbi_available = true;
+	if (sbi_probe_extension(SBI_EXT_PMU)) {
+		if (sbi_spec_version >= sbi_mk_version(0, 3)) {
+			static_branch_enable(&riscv_pmu_sbi_available);
+			sbi_available = true;
+		}
+
+		if (sbi_spec_version >= sbi_mk_version(2, 0))
+			sbi_v2_available = true;
 	}
 
-	if (sbi_spec_version >= sbi_mk_version(2, 0))
-		sbi_v2_available = true;
 	/*
 	 * We need all three extensions to be present to access the counters
 	 * in S-mode via Supervisor Counter delegation.

-- 
2.34.1


