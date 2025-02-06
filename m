Return-Path: <kvm+bounces-37446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CEB0A2A23B
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A63F3A3F7A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB032230995;
	Thu,  6 Feb 2025 07:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="DwH4BTTT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F60B22FDF8
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826622; cv=none; b=IxHBWADFd9uHL+xkvs3yoDvJrzo6c4fvRBPQQzbzibGUucfuS4X21NLsCHnsEt7nhLELfu4LVFuZDZaBlfCBjPERztFQEkUfhFQlJsm7qQICFeSL+V0zyxOVqBxK9+N9jrOxyUVP3RPC/rmWltBSJKu+MUZdP/jOlCm+gTjpSEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826622; c=relaxed/simple;
	bh=5pQU73YVC2BHWefCjWg3jVhPGLfz1UhgII0sPsu1PmQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FWI3aeOgV7zQlRMmNRus9w7ssMiI8W595Oh5YWxJIc0ZqgCzt0pAgq8EGX9bJTXeZhTe8OuewSbKp/CLZbJPuWoBwx7lF6ejA2zyUSZYyNwdYtlyOy8J4aCCCD9uZu6O2H+nOVlU8yehEQaRmmTEtRm4bTn95eK9g2LxtDoIxig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=DwH4BTTT; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2f9d627b5fbso955799a91.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826620; x=1739431420; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YQ1bM+mdYO24XpbpY93Gza0u/hfSg2U52kt5rlPb2uw=;
        b=DwH4BTTTfB97psACzZZLJ4kL41CvAHVcTCNrB6muvDLq6DufiNZl/u9Vf0Pki9GsPs
         mNEbzZ+5x8fk93jAKDn/EZfyfwodGXb/KmUKeWqEOjDbc+1+KLVWkAR5TC1lkc2rkMJG
         /UGFPIMpxzKHlJDgR37tQxGPjj4DFGUeOd9r6roDMRDfZC1Jiv9vspSF8EBBu7bksHFA
         gY4deOt6OVs7s19VlEhkxTRILYyQjGM9W7dbuhGNE7Kc2XCDRqrhoWnMGHYhD85VfbUW
         hu+1gtbO3PZQ6LtteSRbZ17OkHjpxMwZKszdLSVKWAKnj3Q++36DrS8WS5EeigJgp8Xf
         LFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826620; x=1739431420;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQ1bM+mdYO24XpbpY93Gza0u/hfSg2U52kt5rlPb2uw=;
        b=bPpWfQq23TN16PS17Z+27MDGzX4klFu8QtlrxEgeysx/HwrI+0X75jDHx23PyK7BFe
         58b2cCq6LIWKpKsJhoCCyD5W3C5qI+d4LnsDaYuSFXuTQpQYYLaeY4/V4FBgeGixyCkp
         dGhiKMuqJZQSfva5UEwLwJPlJBiPEEY3oxxkyCtsmPJwSqXK+lZX0ikjC3VA5jNn5e6a
         bQnogm1pggKH337aMCk7aRdDJOUyR1ve1K21kyjJMAzemxLIC/h3dAsLbI2HDUej51BG
         Rs7BBebKbdh7YlnkOOAKDXuliqU4hZLjXNxoCYXtbPE1wtBVHtX10xtPwyS7aSTkhdcS
         zxAA==
X-Forwarded-Encrypted: i=1; AJvYcCVyvlBP1Xq4vnyQoX+vaNcM+3XFTfZsIB5AHjv6b0sre15+pRSPmW41sMlLujsEdIxITcs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCz3+0VYTVYLTitGMr2vzcGHWk2v+wzYv3pAb/u2mBVtYVHTkb
	AnJPWaJ3gWyoEkn69UrXPISnssCkNRcGCRD1UJbAwW3i8Kimi4gHDj+tn7woxjw=
X-Gm-Gg: ASbGncsYPe6X6cBTm2nee1hlyCXr0fourNKAa5Cod8P/pWD3AkkaQrFpBAXgz99QodP
	wvBrXJLG2yDlB3Aiyb7fDd23onumyNSlxjmHPnkenhM3kesqC3I6U5BNrUxqQxvUfRYMhDhixlM
	n8CvNtOWK/Ix3Y/ftFq1niLpKyHVr8obMxq5khF1ae7nmasA1UjKFqGSPxnpR73RLQSHIgo8iPs
	J0GCUx8hlAfwb9k57GdAmxsw9h0d79pf995/prG1iQ4pjqKqOTm9UR7o/cn/l2ACs3osG9SE9ut
	YTk+DnAAIT5wFAEbhLxOgUjX/Mmj
X-Google-Smtp-Source: AGHT+IHr3HVst/0GQEzeOnoyNAyzJUxG9J5qyTanVRpVP7lxbmu+OPESYtyRFZuabnz8KqnI9biZIQ==
X-Received: by 2002:a17:90b:4c43:b0:2ee:fdf3:390d with SMTP id 98e67ed59e1d1-2f9e084fcc0mr8578133a91.31.1738826619909;
        Wed, 05 Feb 2025 23:23:39 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:39 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 05 Feb 2025 23:23:20 -0800
Subject: [PATCH v4 15/21] RISC-V: perf: Skip PMU SBI extension when not
 implemented
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-counter_delegation-v4-15-835cfa88e3b1@rivosinc.com>
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
In-Reply-To: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
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
 drivers/perf/riscv_pmu_dev.c | 46 ++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.c
index 5112049b491c..219f65eb167c 100644
--- a/drivers/perf/riscv_pmu_dev.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -410,18 +410,22 @@ static void rvpmu_sbi_check_event(struct sbi_pmu_event_data *edata)
 	}
 }
 
-static void rvpmu_sbi_check_std_events(struct work_struct *work)
+static void rvpmu_check_std_events(struct work_struct *work)
 {
-	for (int i = 0; i < ARRAY_SIZE(pmu_hw_event_sbi_map); i++)
-		rvpmu_sbi_check_event(&pmu_hw_event_sbi_map[i]);
-
-	for (int i = 0; i < ARRAY_SIZE(pmu_cache_event_sbi_map); i++)
-		for (int j = 0; j < ARRAY_SIZE(pmu_cache_event_sbi_map[i]); j++)
-			for (int k = 0; k < ARRAY_SIZE(pmu_cache_event_sbi_map[i][j]); k++)
-				rvpmu_sbi_check_event(&pmu_cache_event_sbi_map[i][j][k]);
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
@@ -1940,14 +1946,16 @@ static int __init rvpmu_devinit(void)
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
2.43.0


