Return-Path: <kvm+bounces-37452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B64A2A24F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:32:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAF123A84CA
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27230233D90;
	Thu,  6 Feb 2025 07:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="IjCYMQWd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702DF232369
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826633; cv=none; b=D32Oc1OUcQqDJuWMDTfUe/uZLibyj6qdcQ4x7N41dKlK6wZ/TlrDgYvVWvaeYhjBt8gk3IbdXW/Dz1D/n7BxUU63g6enMDID/gfM/tXSVswAJpVjrEv0asJRnmpiFKUBgtBJNtQgLiaXgOd1Beo1zmYrnGwjC0Z513QBwNQSblw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826633; c=relaxed/simple;
	bh=BM3ov8+LAwFOyFwamgTeu1nplfS8DxldhKUk0Yt9AEc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OE/Z+uySo9/n89nSqLZsqh+/pC/74W344Da69ZhGUeO4EmFRBwoyUwROleI6roR03EckZmaekJqIm2z4s3csDI7vQ0lIk/+uKUXgRr7mre4qPaDAdRKVfNUDR870sf4UEJOKLBNyc7ZNTmspPmniF+IqggtioUgf3h1/YH7pLCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=IjCYMQWd; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21634338cfdso14082195ad.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826629; x=1739431429; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3rXBekgxwrWqHmt4oM/pU0sf9hDrHDVKf/jA5yAU2uU=;
        b=IjCYMQWdPauzjXJSJOa9BIxMHWSryq8GxR0uLtc22PXUWygGiQRt09DRxtZ0+53ftE
         1xLkn4ETMbuiM7XP+T/TYJYvhzoIQCpWURdGOqg+1tjLtWuak36A5vWKqWr+/gS65hI9
         Vm597I0XawWuBg4z5rOPB81UAto/naiGKhktSUU2FPBRfCCSG8JwY751frSgbG4ua8SZ
         ctKxyNCE2yAAP4M2JlbWpSJpOf+zuLAd5gTgnEzoarS+KqLILGQ/Uj/CsHE82BfkB0Nt
         RNqF52rl26qpixpuVMfRw+OFcpwNdGVQzRXPw0dnS0wQ6RgKwbcEC4FMK44VwO+eSZrY
         yYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826629; x=1739431429;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3rXBekgxwrWqHmt4oM/pU0sf9hDrHDVKf/jA5yAU2uU=;
        b=K8sVsMqYJThd3sA01wAB6z3EPZHYVoWbIwwaNRPii+H4WqQPAGcuskz5FO6iCQ/fiq
         4mHhNOljQ3oUJM/we3p0Cy4ZlfHTILc4dPynJiRhDB+nJSkUd6vb4N39+58ydigQI6Fy
         WOPYEdawsFu3/PKD32k7G1bSazoohw4GDMJALSdw4QuPhL50f4wCk5KKi40oQqQ+XTUX
         0NsHcA+DgqlTGmugn4Z/cthZPHIwK+JuF6oW1j9bVwZr5QYDatHlCeyp7ttq7hW3FGc+
         tA/h9thkljzTQjTA8iBAddZIHYm90d7Eg7jj89eL32eDlHN6LdfC5DFFV4kkrNxXMuar
         UZLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzLUJVFHcexizsmlEfdkQ0hzWtmtJD9kvhkkNk5smhWtdTAqgicviF0dww9gbHM2yEJ7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCojhcxr5zA7Joyi/kQ9Y7Kk9Botp8YH6HiRQfDdd06h2WITbN
	5Q0PqLXNNpt0njd6E5T3jfSXhbSoIJSn34iukfYriRSLbmUkRrD1fgAeOjGEoYQ=
X-Gm-Gg: ASbGncuyR8SoCqX2btjanDLafDkPxHGGr/rYRFJTnBWD+A7LgskthM5WaQkakgDVqJX
	c/Y3MTNi7Qu+CUcGPSdLr7p5I6KYmTrM+smi+L6lDSdb4Wbvt1NsCq678t3tmeNuKMTI4I58tVg
	S+45qecnDI9EiAYFxQBdAcuZuA1cOiIjWh2OX9QSqRDi6NW4r7rnSMozvybDib3PqUNRnL60ba9
	d6jWsTX9eTyZh2dCLm/BzFEPpUu3xnVLi550M2ZJIbkhEkkQFbSXYr1ek436cN7qZGEuYjSM0W9
	0OWuQQYEB5xfCDPNY3mJ1LC3Q78U
X-Google-Smtp-Source: AGHT+IEa71V3dAQMzlW1coBP9GpcYnAZy8MgrA6Jkwq3aId/xS02HFJyHmPPn3F7l6BTr74BjlvPKQ==
X-Received: by 2002:a17:903:1a06:b0:215:7719:24f6 with SMTP id d9443c01a7336-21f17e7472bmr101410705ad.23.1738826629449;
        Wed, 05 Feb 2025 23:23:49 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:49 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 05 Feb 2025 23:23:26 -0800
Subject: [PATCH v4 21/21] Sync empty-pmu-events.c with autogenerated one
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-counter_delegation-v4-21-835cfa88e3b1@rivosinc.com>
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
 Atish Patra <atishp@rivosinc.com>
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
2.43.0


