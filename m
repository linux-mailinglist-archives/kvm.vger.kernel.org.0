Return-Path: <kvm+bounces-35479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB33A114E1
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE288166B57
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F85F22A1ED;
	Tue, 14 Jan 2025 22:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="XdrcVeqE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489E1229818
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895540; cv=none; b=HiOko4DhKj8/v0tV+KBNlo6kEBnser+Pm3fzk8jVaJLLbYni6z9mluiyVlt2sIj7egLb01d8nZvpTq0jTPDwJ+kivAGELhROo6tJsmdbl1eyjElreNhIPDLV7QlzjM4a6mKU6W5IqtgAHxRO9eKTdQRmMlQTF9011P5FdR/tAuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895540; c=relaxed/simple;
	bh=qQi0qEa37wtz3k1Q8ux7Swe3fgMMiffA1gVEdLrkUVs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dLf36trDyZObHGUXYPck4uUYxwxFna3O2f5ucSQD37fNWV2ONeieFFepYk3U6L9J3eBElrbaLbJQg0Mz7ba8X5Br4GUlbXqIoxITuSpsu9p8Y+AXlB0Y26osju8wrtbiz7q2vydNP8J+yB997xXtdQWFL6FkdgzrGp5aGLbViX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=XdrcVeqE; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21636268e43so142417675ad.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895535; x=1737500335; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LjV/iWQ7Q2hesd2gulek6pUTfHIp6aO/uFRo9yx7LyQ=;
        b=XdrcVeqEjLCNraMzEdqAazNuA7fFvQlNLj0W8tudxljxzRhBAu2uF6Mhyv+A8ytgyN
         REZLLsMHiMjiekex1fjdk03ENMB3umdlQqOZvXv/fxbVcl2eeGFvsjbmzJi0sF6ugMkm
         FFEt2t6/SFgeyI0QZ6omqXsP4FN28Joo6U9004BjgJoj7PEZ+CcTXYy6swv3GBC8t4ri
         //KmDlbC+Rhyi4NqHjZHWtOZnfjoOHE2oCjyn5QrWZcDRvSBab5mvdXj8IHmNg+uVVrt
         BQ51l5Mv+LqRTfBycM7yKjSt3HWbBfZcqhx42ZqCKx1FhKqVaTvqczH0HD9diXlpE6vA
         rZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895535; x=1737500335;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LjV/iWQ7Q2hesd2gulek6pUTfHIp6aO/uFRo9yx7LyQ=;
        b=ne8q4ExM5oW0+ZJgP8ekZ/HSH99WQAE8I8ezBfSB4Q0bG2VS5WsCpT9FpMndrWJPhW
         QRiQid9QrC7MvU1T2yeaCGApbO9KXszh37NJ9C1xusyvJMlemvzfDcs9hUfWc5jMR5RW
         7sg6P4tjdoFlNjpMfu4Hfw+aul/0v7gxyLeLdYqt2bvVfWy6MX0P2pw199x7nnPeG0BF
         VzunLwvwRIgZl5fwOQsPbZZ6XtjqcbZ2JgKg/4Nr0q2pDk3PsDYQs5WJ/Awc8YF3zqQk
         PJPmYYGqxvTyrVMD4QAv5LDKrYjgb9YF+MiNFQLLHOBtPex1EbmDhN3kTwdP9t+q9fEY
         a2sg==
X-Forwarded-Encrypted: i=1; AJvYcCUXTmSIomxcE7kmnC5Tu5mB4GEDegyalj3pQccQ4kB4ppzvyVrl03ip+JajR3gQMtk4d5A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXG5mcqHOMS0B2ZdHMVPcVh5u0HZ8X0sZS8xmCVUVE7xzcGiuc
	3K/oZoe8IcvPGphJx2AfTh8TrFFRGSRbqNWPcUzuGeXxxlboOKFYHWj7FBe9ZaQ=
X-Gm-Gg: ASbGncu7FGNBjKFT9KQK1zJSZVr7wywKNksnRnOtNmkguB4QS2Lrrsg8PSVvzP37jiS
	X4f9Sm6RK0jVMq5ikct66lJx0Oah12fYpxN9OroAslfiGax/305CWd4Dy8tdTqtr1dw+cJOIDeY
	zhAohpD7+DHDpVeR93g/NtXwnhoCW+D6tpQM3gzQOtxYDwTeu4cl8qwA/aoIYPdNdN3BQ+HVXfd
	UiM92RTZjO/AFtv+lmsnjVvwCDaIE/g8/O9jG/iqgM9XGXSU4w/ZTDU8kgan3XRz15SHA==
X-Google-Smtp-Source: AGHT+IGpq1D0JSZ4EdQBx5hjv0FmY9nuAiwDhta/aR1j0yblsLfxDKj7PPRqG9xkC9dq1hVdO/mUXQ==
X-Received: by 2002:a17:902:f685:b0:215:853d:38 with SMTP id d9443c01a7336-21a83f76588mr388110205ad.25.1736895535348;
        Tue, 14 Jan 2025 14:58:55 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:55 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:46 -0800
Subject: [PATCH v2 21/21] Sync empty-pmu-events.c with autogenerated one
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-21-8ba74cdb851b@rivosinc.com>
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
 linux-perf-users@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/perf/pmu-events/empty-pmu-events.c | 144 +++++++++++++++----------------
 1 file changed, 72 insertions(+), 72 deletions(-)

diff --git a/tools/perf/pmu-events/empty-pmu-events.c b/tools/perf/pmu-events/empty-pmu-events.c
index 3a7ec31576f5..22f0463dc522 100644
--- a/tools/perf/pmu-events/empty-pmu-events.c
+++ b/tools/perf/pmu-events/empty-pmu-events.c
@@ -36,42 +36,42 @@ static const char *const big_c_string =
 /* offset=1127 */ "bp_l1_btb_correct\000branch\000L1 BTB Correction\000event=0x8a\000\00000\000\000\000"
 /* offset=1187 */ "bp_l2_btb_correct\000branch\000L2 BTB Correction\000event=0x8b\000\00000\000\000\000"
 /* offset=1247 */ "l3_cache_rd\000cache\000L3 cache access, read\000event=0x40\000\00000\000Attributable Level 3 cache access, read\000\000"
-/* offset=1343 */ "segment_reg_loads.any\000other\000Number of segment register loads\000event=6,period=200000,umask=0x80\000\00000\000\0000,1\000"
-/* offset=1446 */ "dispatch_blocked.any\000other\000Memory cluster signals to block micro-op dispatch for any reason\000event=9,period=200000,umask=0x20\000\00000\000\0000,1\000"
-/* offset=1580 */ "eist_trans\000other\000Number of Enhanced Intel SpeedStep(R) Technology (EIST) transitions\000event=0x3a,period=200000\000\00000\000\0000,1\000"
-/* offset=1699 */ "hisi_sccl,ddrc\000"
-/* offset=1714 */ "uncore_hisi_ddrc.flux_wcmd\000uncore\000DDRC write commands\000event=2\000\00000\000DDRC write commands\000\000"
-/* offset=1801 */ "uncore_cbox\000"
-/* offset=1813 */ "unc_cbo_xsnp_response.miss_eviction\000uncore\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000event=0x22,umask=0x81\000\00000\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\0000,1\000"
-/* offset=2048 */ "event-hyphen\000uncore\000UNC_CBO_HYPHEN\000event=0xe0\000\00000\000UNC_CBO_HYPHEN\000\000"
-/* offset=2114 */ "event-two-hyph\000uncore\000UNC_CBO_TWO_HYPH\000event=0xc0\000\00000\000UNC_CBO_TWO_HYPH\000\000"
-/* offset=2186 */ "hisi_sccl,l3c\000"
-/* offset=2200 */ "uncore_hisi_l3c.rd_hit_cpipe\000uncore\000Total read hits\000event=7\000\00000\000Total read hits\000\000"
-/* offset=2281 */ "uncore_imc_free_running\000"
-/* offset=2305 */ "uncore_imc_free_running.cache_miss\000uncore\000Total cache misses\000event=0x12\000\00000\000Total cache misses\000\000"
-/* offset=2401 */ "uncore_imc\000"
-/* offset=2412 */ "uncore_imc.cache_hits\000uncore\000Total cache hits\000event=0x34\000\00000\000Total cache hits\000\000"
-/* offset=2491 */ "uncore_sys_ddr_pmu\000"
-/* offset=2510 */ "sys_ddr_pmu.write_cycles\000uncore\000ddr write-cycles event\000event=0x2b\000v8\00000\000\000\000"
-/* offset=2584 */ "uncore_sys_ccn_pmu\000"
-/* offset=2603 */ "sys_ccn_pmu.read_cycles\000uncore\000ccn read-cycles event\000config=0x2c\0000x01\00000\000\000\000"
-/* offset=2678 */ "uncore_sys_cmn_pmu\000"
-/* offset=2697 */ "sys_cmn_pmu.hnf_cache_miss\000uncore\000Counts total cache misses in first lookup result (high priority)\000eventid=1,type=5\000(434|436|43c|43a).*\00000\000\000\000"
-/* offset=2838 */ "CPI\000\0001 / IPC\000\000\000\000\000\000\000\00000"
-/* offset=2860 */ "IPC\000group1\000inst_retired.any / cpu_clk_unhalted.thread\000\000\000\000\000\000\000\00000"
-/* offset=2923 */ "Frontend_Bound_SMT\000\000idq_uops_not_delivered.core / (4 * (cpu_clk_unhalted.thread / 2 * (1 + cpu_clk_unhalted.one_thread_active / cpu_clk_unhalted.ref_xclk)))\000\000\000\000\000\000\000\00000"
-/* offset=3089 */ "dcache_miss_cpi\000\000l1d\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000"
-/* offset=3153 */ "icache_miss_cycles\000\000l1i\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000"
-/* offset=3220 */ "cache_miss_cycles\000group1\000dcache_miss_cpi + icache_miss_cycles\000\000\000\000\000\000\000\00000"
-/* offset=3291 */ "DCache_L2_All_Hits\000\000l2_rqsts.demand_data_rd_hit + l2_rqsts.pf_hit + l2_rqsts.rfo_hit\000\000\000\000\000\000\000\00000"
-/* offset=3385 */ "DCache_L2_All_Miss\000\000max(l2_rqsts.all_demand_data_rd - l2_rqsts.demand_data_rd_hit, 0) + l2_rqsts.pf_miss + l2_rqsts.rfo_miss\000\000\000\000\000\000\000\00000"
-/* offset=3519 */ "DCache_L2_All\000\000DCache_L2_All_Hits + DCache_L2_All_Miss\000\000\000\000\000\000\000\00000"
-/* offset=3583 */ "DCache_L2_Hits\000\000d_ratio(DCache_L2_All_Hits, DCache_L2_All)\000\000\000\000\000\000\000\00000"
-/* offset=3651 */ "DCache_L2_Misses\000\000d_ratio(DCache_L2_All_Miss, DCache_L2_All)\000\000\000\000\000\000\000\00000"
-/* offset=3721 */ "M1\000\000ipc + M2\000\000\000\000\000\000\000\00000"
-/* offset=3743 */ "M2\000\000ipc + M1\000\000\000\000\000\000\000\00000"
-/* offset=3765 */ "M3\000\0001 / M3\000\000\000\000\000\000\000\00000"
-/* offset=3785 */ "L1D_Cache_Fill_BW\000\00064 * l1d.replacement / 1e9 / duration_time\000\000\000\000\000\000\000\00000"
+/* offset=1343 */ "segment_reg_loads.any\000other\000Number of segment register loads\000event=6,period=200000,umask=0x80,counterid_mask=0x3\000\00000\000\0000,1\000"
+/* offset=1465 */ "dispatch_blocked.any\000other\000Memory cluster signals to block micro-op dispatch for any reason\000event=9,period=200000,umask=0x20,counterid_mask=0x3\000\00000\000\0000,1\000"
+/* offset=1618 */ "eist_trans\000other\000Number of Enhanced Intel SpeedStep(R) Technology (EIST) transitions\000event=0x3a,period=200000,counterid_mask=0x3\000\00000\000\0000,1\000"
+/* offset=1756 */ "hisi_sccl,ddrc\000"
+/* offset=1771 */ "uncore_hisi_ddrc.flux_wcmd\000uncore\000DDRC write commands\000event=2\000\00000\000DDRC write commands\000\000"
+/* offset=1858 */ "uncore_cbox\000"
+/* offset=1870 */ "unc_cbo_xsnp_response.miss_eviction\000uncore\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000event=0x22,umask=0x81,counterid_mask=0x3\000\00000\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\0000,1\000"
+/* offset=2124 */ "event-hyphen\000uncore\000UNC_CBO_HYPHEN\000event=0xe0\000\00000\000UNC_CBO_HYPHEN\000\000"
+/* offset=2190 */ "event-two-hyph\000uncore\000UNC_CBO_TWO_HYPH\000event=0xc0\000\00000\000UNC_CBO_TWO_HYPH\000\000"
+/* offset=2262 */ "hisi_sccl,l3c\000"
+/* offset=2276 */ "uncore_hisi_l3c.rd_hit_cpipe\000uncore\000Total read hits\000event=7\000\00000\000Total read hits\000\000"
+/* offset=2357 */ "uncore_imc_free_running\000"
+/* offset=2381 */ "uncore_imc_free_running.cache_miss\000uncore\000Total cache misses\000event=0x12\000\00000\000Total cache misses\000\000"
+/* offset=2477 */ "uncore_imc\000"
+/* offset=2488 */ "uncore_imc.cache_hits\000uncore\000Total cache hits\000event=0x34\000\00000\000Total cache hits\000\000"
+/* offset=2567 */ "uncore_sys_ddr_pmu\000"
+/* offset=2586 */ "sys_ddr_pmu.write_cycles\000uncore\000ddr write-cycles event\000event=0x2b\000v8\00000\000\000\000"
+/* offset=2660 */ "uncore_sys_ccn_pmu\000"
+/* offset=2679 */ "sys_ccn_pmu.read_cycles\000uncore\000ccn read-cycles event\000config=0x2c\0000x01\00000\000\000\000"
+/* offset=2754 */ "uncore_sys_cmn_pmu\000"
+/* offset=2773 */ "sys_cmn_pmu.hnf_cache_miss\000uncore\000Counts total cache misses in first lookup result (high priority)\000eventid=1,type=5\000(434|436|43c|43a).*\00000\000\000\000"
+/* offset=2914 */ "CPI\000\0001 / IPC\000\000\000\000\000\000\000\00000"
+/* offset=2936 */ "IPC\000group1\000inst_retired.any / cpu_clk_unhalted.thread\000\000\000\000\000\000\000\00000"
+/* offset=2999 */ "Frontend_Bound_SMT\000\000idq_uops_not_delivered.core / (4 * (cpu_clk_unhalted.thread / 2 * (1 + cpu_clk_unhalted.one_thread_active / cpu_clk_unhalted.ref_xclk)))\000\000\000\000\000\000\000\00000"
+/* offset=3165 */ "dcache_miss_cpi\000\000l1d\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000"
+/* offset=3229 */ "icache_miss_cycles\000\000l1i\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000"
+/* offset=3296 */ "cache_miss_cycles\000group1\000dcache_miss_cpi + icache_miss_cycles\000\000\000\000\000\000\000\00000"
+/* offset=3367 */ "DCache_L2_All_Hits\000\000l2_rqsts.demand_data_rd_hit + l2_rqsts.pf_hit + l2_rqsts.rfo_hit\000\000\000\000\000\000\000\00000"
+/* offset=3461 */ "DCache_L2_All_Miss\000\000max(l2_rqsts.all_demand_data_rd - l2_rqsts.demand_data_rd_hit, 0) + l2_rqsts.pf_miss + l2_rqsts.rfo_miss\000\000\000\000\000\000\000\00000"
+/* offset=3595 */ "DCache_L2_All\000\000DCache_L2_All_Hits + DCache_L2_All_Miss\000\000\000\000\000\000\000\00000"
+/* offset=3659 */ "DCache_L2_Hits\000\000d_ratio(DCache_L2_All_Hits, DCache_L2_All)\000\000\000\000\000\000\000\00000"
+/* offset=3727 */ "DCache_L2_Misses\000\000d_ratio(DCache_L2_All_Miss, DCache_L2_All)\000\000\000\000\000\000\000\00000"
+/* offset=3797 */ "M1\000\000ipc + M2\000\000\000\000\000\000\000\00000"
+/* offset=3819 */ "M2\000\000ipc + M1\000\000\000\000\000\000\000\00000"
+/* offset=3841 */ "M3\000\0001 / M3\000\000\000\000\000\000\000\00000"
+/* offset=3861 */ "L1D_Cache_Fill_BW\000\00064 * l1d.replacement / 1e9 / duration_time\000\000\000\000\000\000\000\00000"
 ;
 
 static const struct compact_pmu_event pmu_events__common_tool[] = {
@@ -101,27 +101,27 @@ const struct pmu_table_entry pmu_events__common[] = {
 static const struct compact_pmu_event pmu_events__test_soc_cpu_default_core[] = {
 { 1127 }, /* bp_l1_btb_correct\000branch\000L1 BTB Correction\000event=0x8a\000\00000\000\000\000 */
 { 1187 }, /* bp_l2_btb_correct\000branch\000L2 BTB Correction\000event=0x8b\000\00000\000\000\000 */
-{ 1446 }, /* dispatch_blocked.any\000other\000Memory cluster signals to block micro-op dispatch for any reason\000event=9,period=200000,umask=0x20\000\00000\000\0000,1\000 */
-{ 1580 }, /* eist_trans\000other\000Number of Enhanced Intel SpeedStep(R) Technology (EIST) transitions\000event=0x3a,period=200000\000\00000\000\0000,1\000 */
+{ 1465 }, /* dispatch_blocked.any\000other\000Memory cluster signals to block micro-op dispatch for any reason\000event=9,period=200000,umask=0x20,counterid_mask=0x3\000\00000\000\0000,1\000 */
+{ 1618 }, /* eist_trans\000other\000Number of Enhanced Intel SpeedStep(R) Technology (EIST) transitions\000event=0x3a,period=200000,counterid_mask=0x3\000\00000\000\0000,1\000 */
 { 1247 }, /* l3_cache_rd\000cache\000L3 cache access, read\000event=0x40\000\00000\000Attributable Level 3 cache access, read\000\000 */
-{ 1343 }, /* segment_reg_loads.any\000other\000Number of segment register loads\000event=6,period=200000,umask=0x80\000\00000\000\0000,1\000 */
+{ 1343 }, /* segment_reg_loads.any\000other\000Number of segment register loads\000event=6,period=200000,umask=0x80,counterid_mask=0x3\000\00000\000\0000,1\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_hisi_sccl_ddrc[] = {
-{ 1714 }, /* uncore_hisi_ddrc.flux_wcmd\000uncore\000DDRC write commands\000event=2\000\00000\000DDRC write commands\000\000 */
+{ 1771 }, /* uncore_hisi_ddrc.flux_wcmd\000uncore\000DDRC write commands\000event=2\000\00000\000DDRC write commands\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_hisi_sccl_l3c[] = {
-{ 2200 }, /* uncore_hisi_l3c.rd_hit_cpipe\000uncore\000Total read hits\000event=7\000\00000\000Total read hits\000\000 */
+{ 2276 }, /* uncore_hisi_l3c.rd_hit_cpipe\000uncore\000Total read hits\000event=7\000\00000\000Total read hits\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_uncore_cbox[] = {
-{ 2048 }, /* event-hyphen\000uncore\000UNC_CBO_HYPHEN\000event=0xe0\000\00000\000UNC_CBO_HYPHEN\000\000 */
-{ 2114 }, /* event-two-hyph\000uncore\000UNC_CBO_TWO_HYPH\000event=0xc0\000\00000\000UNC_CBO_TWO_HYPH\000\000 */
-{ 1813 }, /* unc_cbo_xsnp_response.miss_eviction\000uncore\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000event=0x22,umask=0x81\000\00000\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\0000,1\000 */
+{ 2124 }, /* event-hyphen\000uncore\000UNC_CBO_HYPHEN\000event=0xe0\000\00000\000UNC_CBO_HYPHEN\000\000 */
+{ 2190 }, /* event-two-hyph\000uncore\000UNC_CBO_TWO_HYPH\000event=0xc0\000\00000\000UNC_CBO_TWO_HYPH\000\000 */
+{ 1870 }, /* unc_cbo_xsnp_response.miss_eviction\000uncore\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000event=0x22,umask=0x81,counterid_mask=0x3\000\00000\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\0000,1\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_uncore_imc[] = {
-{ 2412 }, /* uncore_imc.cache_hits\000uncore\000Total cache hits\000event=0x34\000\00000\000Total cache hits\000\000 */
+{ 2488 }, /* uncore_imc.cache_hits\000uncore\000Total cache hits\000event=0x34\000\00000\000Total cache hits\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_uncore_imc_free_running[] = {
-{ 2305 }, /* uncore_imc_free_running.cache_miss\000uncore\000Total cache misses\000event=0x12\000\00000\000Total cache misses\000\000 */
+{ 2381 }, /* uncore_imc_free_running.cache_miss\000uncore\000Total cache misses\000event=0x12\000\00000\000Total cache misses\000\000 */
 
 };
 
@@ -134,46 +134,46 @@ const struct pmu_table_entry pmu_events__test_soc_cpu[] = {
 {
      .entries = pmu_events__test_soc_cpu_hisi_sccl_ddrc,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_hisi_sccl_ddrc),
-     .pmu_name = { 1699 /* hisi_sccl,ddrc\000 */ },
+     .pmu_name = { 1756 /* hisi_sccl,ddrc\000 */ },
 },
 {
      .entries = pmu_events__test_soc_cpu_hisi_sccl_l3c,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_hisi_sccl_l3c),
-     .pmu_name = { 2186 /* hisi_sccl,l3c\000 */ },
+     .pmu_name = { 2262 /* hisi_sccl,l3c\000 */ },
 },
 {
      .entries = pmu_events__test_soc_cpu_uncore_cbox,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_uncore_cbox),
-     .pmu_name = { 1801 /* uncore_cbox\000 */ },
+     .pmu_name = { 1858 /* uncore_cbox\000 */ },
 },
 {
      .entries = pmu_events__test_soc_cpu_uncore_imc,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_uncore_imc),
-     .pmu_name = { 2401 /* uncore_imc\000 */ },
+     .pmu_name = { 2477 /* uncore_imc\000 */ },
 },
 {
      .entries = pmu_events__test_soc_cpu_uncore_imc_free_running,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_uncore_imc_free_running),
-     .pmu_name = { 2281 /* uncore_imc_free_running\000 */ },
+     .pmu_name = { 2357 /* uncore_imc_free_running\000 */ },
 },
 };
 
 static const struct compact_pmu_event pmu_metrics__test_soc_cpu_default_core[] = {
-{ 2838 }, /* CPI\000\0001 / IPC\000\000\000\000\000\000\000\00000 */
-{ 3519 }, /* DCache_L2_All\000\000DCache_L2_All_Hits + DCache_L2_All_Miss\000\000\000\000\000\000\000\00000 */
-{ 3291 }, /* DCache_L2_All_Hits\000\000l2_rqsts.demand_data_rd_hit + l2_rqsts.pf_hit + l2_rqsts.rfo_hit\000\000\000\000\000\000\000\00000 */
-{ 3385 }, /* DCache_L2_All_Miss\000\000max(l2_rqsts.all_demand_data_rd - l2_rqsts.demand_data_rd_hit, 0) + l2_rqsts.pf_miss + l2_rqsts.rfo_miss\000\000\000\000\000\000\000\00000 */
-{ 3583 }, /* DCache_L2_Hits\000\000d_ratio(DCache_L2_All_Hits, DCache_L2_All)\000\000\000\000\000\000\000\00000 */
-{ 3651 }, /* DCache_L2_Misses\000\000d_ratio(DCache_L2_All_Miss, DCache_L2_All)\000\000\000\000\000\000\000\00000 */
-{ 2923 }, /* Frontend_Bound_SMT\000\000idq_uops_not_delivered.core / (4 * (cpu_clk_unhalted.thread / 2 * (1 + cpu_clk_unhalted.one_thread_active / cpu_clk_unhalted.ref_xclk)))\000\000\000\000\000\000\000\00000 */
-{ 2860 }, /* IPC\000group1\000inst_retired.any / cpu_clk_unhalted.thread\000\000\000\000\000\000\000\00000 */
-{ 3785 }, /* L1D_Cache_Fill_BW\000\00064 * l1d.replacement / 1e9 / duration_time\000\000\000\000\000\000\000\00000 */
-{ 3721 }, /* M1\000\000ipc + M2\000\000\000\000\000\000\000\00000 */
-{ 3743 }, /* M2\000\000ipc + M1\000\000\000\000\000\000\000\00000 */
-{ 3765 }, /* M3\000\0001 / M3\000\000\000\000\000\000\000\00000 */
-{ 3220 }, /* cache_miss_cycles\000group1\000dcache_miss_cpi + icache_miss_cycles\000\000\000\000\000\000\000\00000 */
-{ 3089 }, /* dcache_miss_cpi\000\000l1d\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000 */
-{ 3153 }, /* icache_miss_cycles\000\000l1i\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000 */
+{ 2914 }, /* CPI\000\0001 / IPC\000\000\000\000\000\000\000\00000 */
+{ 3595 }, /* DCache_L2_All\000\000DCache_L2_All_Hits + DCache_L2_All_Miss\000\000\000\000\000\000\000\00000 */
+{ 3367 }, /* DCache_L2_All_Hits\000\000l2_rqsts.demand_data_rd_hit + l2_rqsts.pf_hit + l2_rqsts.rfo_hit\000\000\000\000\000\000\000\00000 */
+{ 3461 }, /* DCache_L2_All_Miss\000\000max(l2_rqsts.all_demand_data_rd - l2_rqsts.demand_data_rd_hit, 0) + l2_rqsts.pf_miss + l2_rqsts.rfo_miss\000\000\000\000\000\000\000\00000 */
+{ 3659 }, /* DCache_L2_Hits\000\000d_ratio(DCache_L2_All_Hits, DCache_L2_All)\000\000\000\000\000\000\000\00000 */
+{ 3727 }, /* DCache_L2_Misses\000\000d_ratio(DCache_L2_All_Miss, DCache_L2_All)\000\000\000\000\000\000\000\00000 */
+{ 2999 }, /* Frontend_Bound_SMT\000\000idq_uops_not_delivered.core / (4 * (cpu_clk_unhalted.thread / 2 * (1 + cpu_clk_unhalted.one_thread_active / cpu_clk_unhalted.ref_xclk)))\000\000\000\000\000\000\000\00000 */
+{ 2936 }, /* IPC\000group1\000inst_retired.any / cpu_clk_unhalted.thread\000\000\000\000\000\000\000\00000 */
+{ 3861 }, /* L1D_Cache_Fill_BW\000\00064 * l1d.replacement / 1e9 / duration_time\000\000\000\000\000\000\000\00000 */
+{ 3797 }, /* M1\000\000ipc + M2\000\000\000\000\000\000\000\00000 */
+{ 3819 }, /* M2\000\000ipc + M1\000\000\000\000\000\000\000\00000 */
+{ 3841 }, /* M3\000\0001 / M3\000\000\000\000\000\000\000\00000 */
+{ 3296 }, /* cache_miss_cycles\000group1\000dcache_miss_cpi + icache_miss_cycles\000\000\000\000\000\000\000\00000 */
+{ 3165 }, /* dcache_miss_cpi\000\000l1d\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000 */
+{ 3229 }, /* icache_miss_cycles\000\000l1i\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000 */
 
 };
 
@@ -186,13 +186,13 @@ const struct pmu_table_entry pmu_metrics__test_soc_cpu[] = {
 };
 
 static const struct compact_pmu_event pmu_events__test_soc_sys_uncore_sys_ccn_pmu[] = {
-{ 2603 }, /* sys_ccn_pmu.read_cycles\000uncore\000ccn read-cycles event\000config=0x2c\0000x01\00000\000\000\000 */
+{ 2679 }, /* sys_ccn_pmu.read_cycles\000uncore\000ccn read-cycles event\000config=0x2c\0000x01\00000\000\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_sys_uncore_sys_cmn_pmu[] = {
-{ 2697 }, /* sys_cmn_pmu.hnf_cache_miss\000uncore\000Counts total cache misses in first lookup result (high priority)\000eventid=1,type=5\000(434|436|43c|43a).*\00000\000\000\000 */
+{ 2773 }, /* sys_cmn_pmu.hnf_cache_miss\000uncore\000Counts total cache misses in first lookup result (high priority)\000eventid=1,type=5\000(434|436|43c|43a).*\00000\000\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_sys_uncore_sys_ddr_pmu[] = {
-{ 2510 }, /* sys_ddr_pmu.write_cycles\000uncore\000ddr write-cycles event\000event=0x2b\000v8\00000\000\000\000 */
+{ 2586 }, /* sys_ddr_pmu.write_cycles\000uncore\000ddr write-cycles event\000event=0x2b\000v8\00000\000\000\000 */
 
 };
 
@@ -200,17 +200,17 @@ const struct pmu_table_entry pmu_events__test_soc_sys[] = {
 {
      .entries = pmu_events__test_soc_sys_uncore_sys_ccn_pmu,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_sys_uncore_sys_ccn_pmu),
-     .pmu_name = { 2584 /* uncore_sys_ccn_pmu\000 */ },
+     .pmu_name = { 2660 /* uncore_sys_ccn_pmu\000 */ },
 },
 {
      .entries = pmu_events__test_soc_sys_uncore_sys_cmn_pmu,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_sys_uncore_sys_cmn_pmu),
-     .pmu_name = { 2678 /* uncore_sys_cmn_pmu\000 */ },
+     .pmu_name = { 2754 /* uncore_sys_cmn_pmu\000 */ },
 },
 {
      .entries = pmu_events__test_soc_sys_uncore_sys_ddr_pmu,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_sys_uncore_sys_ddr_pmu),
-     .pmu_name = { 2491 /* uncore_sys_ddr_pmu\000 */ },
+     .pmu_name = { 2567 /* uncore_sys_ddr_pmu\000 */ },
 },
 };
 

-- 
2.34.1


