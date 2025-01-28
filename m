Return-Path: <kvm+bounces-36736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE8C6A203C6
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:05:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E2863A299B
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3CD1F866D;
	Tue, 28 Jan 2025 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="uwpmWINs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A51F78F1
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040417; cv=none; b=j7JjMWVWHknRkOR8JAxbGXqFdd8wwI2xUoOq6+AEo4Co7bdtN6p7u729f9ek2vnKqmGXzZaUMJZhQ86+1Zl8yUvWzOLHGQ6WC2pE+Nr2MN9hrnyW+pB34yBUipQ4rplXjBEBIJKnLBbOydSqEvvwrxWLBkTLlACd3aEguLLHoiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040417; c=relaxed/simple;
	bh=ZCYEBVqxpbzQ+9XIJos03qUFz14KllynHzMk3UmVHLQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JCrJZNUqu03WUf2Y6J5ZHp5LRSNT0Qrs6xDGNsNsBsQZQZCTgLmmHW1A/fYbczJa5xSxY58iKMMZVItyizJSVDsZ5dOeLdayKryS5BB4gjWlktuMbLXrttHyJQfw5Aby5sT/THsfADmgnrPE4cA5w+FQjJS7AXIgNBVwdNIddMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=uwpmWINs; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ef760a1001so8867259a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040414; x=1738645214; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x6U8xZqyjao8QAwlfpahdSahI9u3EBcxYiljZLY35B4=;
        b=uwpmWINsAqOD8kk/KDZQLBsrZPimng6Z5OhOrrrmARQ+PNlg9nQHmUY4go1YKFwg3I
         dOghwWOSbR49c1TsV575Lp33M3FjZUyBp6yG8Yw/jvSEDqySfl5oCdU5aXaUxzJScine
         Endnuj4TQXY1jPUWv1NcxRRZBmYGB0yZ67N+hPZ+eYXmShyT2dADFpe5qeORbr657ACN
         OwXX1TgWP7n0CZ/8bOR9AWnOCeEIFe/eGH946COF1Uj0uZN9oHBs7dywDQ+3qmQFK3rU
         uMwinwhlBkFhvoMY6YIHGyB35Az35QTuEiFLwAp8ZZFUvECNgaXfcu1+ziykDIsh7x4z
         qEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040414; x=1738645214;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6U8xZqyjao8QAwlfpahdSahI9u3EBcxYiljZLY35B4=;
        b=qR1RZdyOxxDcqP/OFi9GS9F6iHskucjjIz06qublN8xJduqLPlmaH0kkuvIMIE18ax
         0YLUcFWZz+XeAwXr+tY8CrR1gnFTv22qK30YdYqb4rgsvJ6+a1ymAg9umW/Vz0StlorR
         s6rUaHdSXM7R2NYsIgHxj+gjbn4/RBRke0GSWYYh2Y6tbr2r+w967FB0TaNhQ3mIgYGO
         O36OC0EX1A5BOaWkuFIUINUsGDFggsEkue7uiusn51U/lucfjgIL/r4Ux2+ad6etzzH6
         mC3WEqpRBmg5aYUlqNTOvh+6/Z778sqq0PzcN0JT21Z4AYFDV1HA6TGpThbrijNcgwmP
         fyOg==
X-Forwarded-Encrypted: i=1; AJvYcCW4oKdqD3zJjNgxWUgbjDYCxSJbe2vi8ygR/USfNk4nibuO0TBR5ironQrl7Qw+i4r01ro=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcjaPuIKCyt0RWELUNlaPoLJVXu5yLVMCdkG4V9hv8ONaCC4b8
	355K8W3ry+AQo9/EYiY2L4cSQ2RnccWk5rqDF5B/YqzEAJ67CxOm6AhB33EAseg=
X-Gm-Gg: ASbGncsmoKPsKW96iqJhMCVTpy+aE2XqdXvHj/BQ12BVtx8XCpuuqMr9ZVt35pIORaL
	H9CMh9qo2ANsPsYrjsQgW0p0/kPsXQbXaIZyni1UUlieOYZvWSmvfLNu7VSWemC7iVr/SK4EmWg
	I1agT9XKLPmit4B41OE7nPvXHBMQOcpjUO05v0PKXTRE8SgsNhogjXITOO7vY54F29LjaklkQfP
	NNAg0Gukio8fuR2OUN/sv+MJv95IK6x5kX/KwIMpuXZc06R0YWI/ydfuLpl8YZcLMvGnJufro8O
	JsOdo+XWYQt8bq/c0D/tpGTpetCr
X-Google-Smtp-Source: AGHT+IFgdohYqccPp8BM6+1NKCY6Ks2M+aFjD71kBC5/Uka5+FjgMiLBaROCKnbBuozTYd+KOO+EXw==
X-Received: by 2002:a17:90b:524b:b0:2ea:3d2e:a0d7 with SMTP id 98e67ed59e1d1-2f782c9846fmr65179131a91.15.1738040413684;
        Mon, 27 Jan 2025 21:00:13 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.21.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:13 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:56 -0800
Subject: [PATCH v3 15/21] RISC-V: perf: Skip PMU SBI extension when not
 implemented
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-15-64894d7e16d5@rivosinc.com>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
In-Reply-To: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
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
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>, Charlie Jenkins <charlie@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

From: Charlie Jenkins <charlie@rivosinc.com>

When the PMU SBI extension is not implemented, sbi_v2_available should
not be set to true. The SBI implementation for counter config matching
and firmware counter read  should also be skipped when the SBI extension
is not implemented.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
---
 drivers/perf/riscv_pmu_dev.c | 49 +++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.c
index e075d0d15221..52d927576c9b 100644
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
@@ -1524,9 +1530,8 @@ static int rvpmu_event_map(struct perf_event *event, u64 *econfig)
 	config1 = event->attr.config1;
 	if (riscv_pmu_cdeleg_available() && !pmu_sbi_is_fw_event(event))
 		return rvpmu_cdeleg_event_map(event, econfig);
-	} else {
+	else
 		return rvpmu_sbi_event_map(event, econfig);
-	}
 }
 
 static int rvpmu_ctr_get_idx(struct perf_event *event)
@@ -1944,14 +1949,16 @@ static int __init rvpmu_devinit(void)
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


