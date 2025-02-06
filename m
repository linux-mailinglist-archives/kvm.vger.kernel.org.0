Return-Path: <kvm+bounces-37432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C3CA2A212
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:26:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68F7D168A48
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7080B225A36;
	Thu,  6 Feb 2025 07:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="bnngmEnr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2316622576E
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826601; cv=none; b=iEk3CogKrHg1Et84e7OSjoYDfHSVbjisqsYpvWD4nc6vRLY6BNp9LlXd9gE5UEw+bB2A++vs7R8FiItwnON68l7/q3u3zDEiFrEYAlAWrdiCwwEw2utPAU1YIqfnBgqV4Cb05z225iOli/VWX8w1o83A0GBZSwcuChRaBti1Oq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826601; c=relaxed/simple;
	bh=4XB6m7nZYUSEEiL+c9tlvG3/aEjYpvoBVRAUzMeXWJU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hjUHgBp5vVUhdNQc5U8w1b1VnlA0Mdbr8pWaonznjC+o66VhTBgl3KFRTIML7QGmkTK4TnNM0jtplL61WMwOAMn9N1IHcTFj1LHlWVOk0ARqf76q8bZuxZSj3oE1UUcYyX2cYi6wLgHcJ4VS/DYs99gLChI5Qn8gMmFHGpeeMPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=bnngmEnr; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2f9cd9601b8so952780a91.3
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826597; x=1739431397; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NxybKo6wKHKxESvcOW2nXeuq/jFAsxN4ho9kLcK6bSI=;
        b=bnngmEnr2L/+/SIbyc5f81m0jVZewuNFsDE7HxDThfFuXqr2qJIXnQj6Dlg6vsDeJ5
         5oLAlVCGoENrgttQdiANFUMMHTJOkEesLDoefFnWB8vHYRN7jmLKZQe6CIZdf8mtI7Z6
         sfSur5CZVbTCEEx11Ee6V9aVL6WEb2yoWn124IxaDvFUB7CbyiLWSNIHaqbB+lnvakeK
         irD/sSsS6ZWfC/+dzAc1lS8MO0hVkfPawbUhU/rfTIJ4bytoFk28ASf0nnWUbLN4OUCr
         SKUzPlzJZk3hGP36mn/kIWX2zqXrYzj7mcOmyfhoms6A96Mto8PiIXcKD+o32APZfPDb
         bsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826597; x=1739431397;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NxybKo6wKHKxESvcOW2nXeuq/jFAsxN4ho9kLcK6bSI=;
        b=njRzGmLMbrC9ER1+mBbCvMeTLd1mza60fe7eQF4cytI+7GoVE/ovtCf2iAyjHHjHTE
         BhBSguHJDtPRBIVqvWgqMWJbRveh9vwyehjQOHhuG2do67mMb8EMDw0glXoFvgnYuJhJ
         /Z4HVazCTGRy46gGZlpPUwXvlByM/uBqSEhCtGXrmhyzJykudo0Sx4AJ47cfTGnKZtiI
         SYGq9c3ke5WhfKXIz2gFKhg58mEMVyQ/6KcjlDjW+sAe+oE9ZCnx1pNRvr7LPm26THxk
         82xVckD7tQmWv4xygKPVLtlSmXMB2XcncfPR8PHG/ZyQzWqjM3DGaY1VxKZldqZsHjWW
         ww7g==
X-Forwarded-Encrypted: i=1; AJvYcCXcj0Iusi9t3oVREQ0PRhcPS41aHJ3caPzwBut6grYC304QX8SSO0db5gNkDQCpkQJdHP4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2Hz0dggv0kDvvGZDg+7GiYSE3CmZjq/LP43JA9t/fwZz1RhOz
	Fca5fiY3IqzNmep4ie5Gm/PVRY4EtMKswO60TpAesHPNjk+a729AKfeHgwHudO0=
X-Gm-Gg: ASbGnct6ZD7GD4yenixsNUSqEW6W738TMgQhAuy+IawUUUqCCkT9nMDkkahOKBWYQA2
	J0F1+YFNlh4nbaNSirqihfiVbo/PpMRuqVTMtHVMhl6vSmVflNvR6Xh4cb3oyifWbN6Si5Q7HxK
	W6Iws4NP3tvFeTODaP2B29cwIcDiYHsXdco0qRxDuz8OEJAr1xkxEApZh2rz+doifep35mGkW8i
	77jwaEfbZxjCYLgfTRhmcrd1QG9h8kxFwz7A0bPfMATGqwOB2BOJXLi4dSRj2RwtIAFWt7hG0TN
	kDYPQt/gL2lOt4MPFUt61vBpBwGQ
X-Google-Smtp-Source: AGHT+IFT6mwcX1AF4g8ZydopueptdAl80WdzAm6cTfrKu9FnLeLwiOd9eXRT7KCT16vslg88b4iYTQ==
X-Received: by 2002:a17:90b:4cc2:b0:2f5:63a:44f9 with SMTP id 98e67ed59e1d1-2f9e0811e4bmr7386320a91.23.1738826597037;
        Wed, 05 Feb 2025 23:23:17 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:16 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 05 Feb 2025 23:23:06 -0800
Subject: [PATCH v4 01/21] perf pmu-events: Add functions in jevent.py to
 parse counter and event info for hardware aware grouping
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-counter_delegation-v4-1-835cfa88e3b1@rivosinc.com>
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

From: Weilin Wang <weilin.wang@intel.com>

These functions are added to parse event counter restrictions and counter
availability info from json files so that the metric grouping method could
do grouping based on the counter restriction of events and the counters
that are available on the system.

Signed-off-by: Weilin Wang <weilin.wang@intel.com>
---
 tools/perf/pmu-events/empty-pmu-events.c | 299 ++++++++++++++++++++-----------
 tools/perf/pmu-events/jevents.py         | 205 ++++++++++++++++++++-
 tools/perf/pmu-events/pmu-events.h       |  32 +++-
 3 files changed, 419 insertions(+), 117 deletions(-)

diff --git a/tools/perf/pmu-events/empty-pmu-events.c b/tools/perf/pmu-events/empty-pmu-events.c
index 1c7a2cfa321f..3a7ec31576f5 100644
--- a/tools/perf/pmu-events/empty-pmu-events.c
+++ b/tools/perf/pmu-events/empty-pmu-events.c
@@ -20,73 +20,73 @@ struct pmu_table_entry {
 
 static const char *const big_c_string =
 /* offset=0 */ "tool\000"
-/* offset=5 */ "duration_time\000tool\000Wall clock interval time in nanoseconds\000config=1\000\00000\000\000"
-/* offset=78 */ "user_time\000tool\000User (non-kernel) time in nanoseconds\000config=2\000\00000\000\000"
-/* offset=145 */ "system_time\000tool\000System/kernel time in nanoseconds\000config=3\000\00000\000\000"
-/* offset=210 */ "has_pmem\000tool\0001 if persistent memory installed otherwise 0\000config=4\000\00000\000\000"
-/* offset=283 */ "num_cores\000tool\000Number of cores. A core consists of 1 or more thread, with each thread being associated with a logical Linux CPU\000config=5\000\00000\000\000"
-/* offset=425 */ "num_cpus\000tool\000Number of logical Linux CPUs. There may be multiple such CPUs on a core\000config=6\000\00000\000\000"
-/* offset=525 */ "num_cpus_online\000tool\000Number of online logical Linux CPUs. There may be multiple such CPUs on a core\000config=7\000\00000\000\000"
-/* offset=639 */ "num_dies\000tool\000Number of dies. Each die has 1 or more cores\000config=8\000\00000\000\000"
-/* offset=712 */ "num_packages\000tool\000Number of packages. Each package has 1 or more die\000config=9\000\00000\000\000"
-/* offset=795 */ "slots\000tool\000Number of functional units that in parallel can execute parts of an instruction\000config=0xa\000\00000\000\000"
-/* offset=902 */ "smt_on\000tool\0001 if simultaneous multithreading (aka hyperthreading) is enable otherwise 0\000config=0xb\000\00000\000\000"
-/* offset=1006 */ "system_tsc_freq\000tool\000The amount a Time Stamp Counter (TSC) increases per second\000config=0xc\000\00000\000\000"
-/* offset=1102 */ "default_core\000"
-/* offset=1115 */ "bp_l1_btb_correct\000branch\000L1 BTB Correction\000event=0x8a\000\00000\000\000"
-/* offset=1174 */ "bp_l2_btb_correct\000branch\000L2 BTB Correction\000event=0x8b\000\00000\000\000"
-/* offset=1233 */ "l3_cache_rd\000cache\000L3 cache access, read\000event=0x40\000\00000\000Attributable Level 3 cache access, read\000"
-/* offset=1328 */ "segment_reg_loads.any\000other\000Number of segment register loads\000event=6,period=200000,umask=0x80\000\00000\000\000"
-/* offset=1427 */ "dispatch_blocked.any\000other\000Memory cluster signals to block micro-op dispatch for any reason\000event=9,period=200000,umask=0x20\000\00000\000\000"
-/* offset=1557 */ "eist_trans\000other\000Number of Enhanced Intel SpeedStep(R) Technology (EIST) transitions\000event=0x3a,period=200000\000\00000\000\000"
-/* offset=1672 */ "hisi_sccl,ddrc\000"
-/* offset=1687 */ "uncore_hisi_ddrc.flux_wcmd\000uncore\000DDRC write commands\000event=2\000\00000\000DDRC write commands\000"
-/* offset=1773 */ "uncore_cbox\000"
-/* offset=1785 */ "unc_cbo_xsnp_response.miss_eviction\000uncore\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000event=0x22,umask=0x81\000\00000\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000"
-/* offset=2016 */ "event-hyphen\000uncore\000UNC_CBO_HYPHEN\000event=0xe0\000\00000\000UNC_CBO_HYPHEN\000"
-/* offset=2081 */ "event-two-hyph\000uncore\000UNC_CBO_TWO_HYPH\000event=0xc0\000\00000\000UNC_CBO_TWO_HYPH\000"
-/* offset=2152 */ "hisi_sccl,l3c\000"
-/* offset=2166 */ "uncore_hisi_l3c.rd_hit_cpipe\000uncore\000Total read hits\000event=7\000\00000\000Total read hits\000"
-/* offset=2246 */ "uncore_imc_free_running\000"
-/* offset=2270 */ "uncore_imc_free_running.cache_miss\000uncore\000Total cache misses\000event=0x12\000\00000\000Total cache misses\000"
-/* offset=2365 */ "uncore_imc\000"
-/* offset=2376 */ "uncore_imc.cache_hits\000uncore\000Total cache hits\000event=0x34\000\00000\000Total cache hits\000"
-/* offset=2454 */ "uncore_sys_ddr_pmu\000"
-/* offset=2473 */ "sys_ddr_pmu.write_cycles\000uncore\000ddr write-cycles event\000event=0x2b\000v8\00000\000\000"
-/* offset=2546 */ "uncore_sys_ccn_pmu\000"
-/* offset=2565 */ "sys_ccn_pmu.read_cycles\000uncore\000ccn read-cycles event\000config=0x2c\0000x01\00000\000\000"
-/* offset=2639 */ "uncore_sys_cmn_pmu\000"
-/* offset=2658 */ "sys_cmn_pmu.hnf_cache_miss\000uncore\000Counts total cache misses in first lookup result (high priority)\000eventid=1,type=5\000(434|436|43c|43a).*\00000\000\000"
-/* offset=2798 */ "CPI\000\0001 / IPC\000\000\000\000\000\000\000\00000"
-/* offset=2820 */ "IPC\000group1\000inst_retired.any / cpu_clk_unhalted.thread\000\000\000\000\000\000\000\00000"
-/* offset=2883 */ "Frontend_Bound_SMT\000\000idq_uops_not_delivered.core / (4 * (cpu_clk_unhalted.thread / 2 * (1 + cpu_clk_unhalted.one_thread_active / cpu_clk_unhalted.ref_xclk)))\000\000\000\000\000\000\000\00000"
-/* offset=3049 */ "dcache_miss_cpi\000\000l1d\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000"
-/* offset=3113 */ "icache_miss_cycles\000\000l1i\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000"
-/* offset=3180 */ "cache_miss_cycles\000group1\000dcache_miss_cpi + icache_miss_cycles\000\000\000\000\000\000\000\00000"
-/* offset=3251 */ "DCache_L2_All_Hits\000\000l2_rqsts.demand_data_rd_hit + l2_rqsts.pf_hit + l2_rqsts.rfo_hit\000\000\000\000\000\000\000\00000"
-/* offset=3345 */ "DCache_L2_All_Miss\000\000max(l2_rqsts.all_demand_data_rd - l2_rqsts.demand_data_rd_hit, 0) + l2_rqsts.pf_miss + l2_rqsts.rfo_miss\000\000\000\000\000\000\000\00000"
-/* offset=3479 */ "DCache_L2_All\000\000DCache_L2_All_Hits + DCache_L2_All_Miss\000\000\000\000\000\000\000\00000"
-/* offset=3543 */ "DCache_L2_Hits\000\000d_ratio(DCache_L2_All_Hits, DCache_L2_All)\000\000\000\000\000\000\000\00000"
-/* offset=3611 */ "DCache_L2_Misses\000\000d_ratio(DCache_L2_All_Miss, DCache_L2_All)\000\000\000\000\000\000\000\00000"
-/* offset=3681 */ "M1\000\000ipc + M2\000\000\000\000\000\000\000\00000"
-/* offset=3703 */ "M2\000\000ipc + M1\000\000\000\000\000\000\000\00000"
-/* offset=3725 */ "M3\000\0001 / M3\000\000\000\000\000\000\000\00000"
-/* offset=3745 */ "L1D_Cache_Fill_BW\000\00064 * l1d.replacement / 1e9 / duration_time\000\000\000\000\000\000\000\00000"
+/* offset=5 */ "duration_time\000tool\000Wall clock interval time in nanoseconds\000config=1\000\00000\000\000\000"
+/* offset=79 */ "user_time\000tool\000User (non-kernel) time in nanoseconds\000config=2\000\00000\000\000\000"
+/* offset=147 */ "system_time\000tool\000System/kernel time in nanoseconds\000config=3\000\00000\000\000\000"
+/* offset=213 */ "has_pmem\000tool\0001 if persistent memory installed otherwise 0\000config=4\000\00000\000\000\000"
+/* offset=287 */ "num_cores\000tool\000Number of cores. A core consists of 1 or more thread, with each thread being associated with a logical Linux CPU\000config=5\000\00000\000\000\000"
+/* offset=430 */ "num_cpus\000tool\000Number of logical Linux CPUs. There may be multiple such CPUs on a core\000config=6\000\00000\000\000\000"
+/* offset=531 */ "num_cpus_online\000tool\000Number of online logical Linux CPUs. There may be multiple such CPUs on a core\000config=7\000\00000\000\000\000"
+/* offset=646 */ "num_dies\000tool\000Number of dies. Each die has 1 or more cores\000config=8\000\00000\000\000\000"
+/* offset=720 */ "num_packages\000tool\000Number of packages. Each package has 1 or more die\000config=9\000\00000\000\000\000"
+/* offset=804 */ "slots\000tool\000Number of functional units that in parallel can execute parts of an instruction\000config=0xa\000\00000\000\000\000"
+/* offset=912 */ "smt_on\000tool\0001 if simultaneous multithreading (aka hyperthreading) is enable otherwise 0\000config=0xb\000\00000\000\000\000"
+/* offset=1017 */ "system_tsc_freq\000tool\000The amount a Time Stamp Counter (TSC) increases per second\000config=0xc\000\00000\000\000\000"
+/* offset=1114 */ "default_core\000"
+/* offset=1127 */ "bp_l1_btb_correct\000branch\000L1 BTB Correction\000event=0x8a\000\00000\000\000\000"
+/* offset=1187 */ "bp_l2_btb_correct\000branch\000L2 BTB Correction\000event=0x8b\000\00000\000\000\000"
+/* offset=1247 */ "l3_cache_rd\000cache\000L3 cache access, read\000event=0x40\000\00000\000Attributable Level 3 cache access, read\000\000"
+/* offset=1343 */ "segment_reg_loads.any\000other\000Number of segment register loads\000event=6,period=200000,umask=0x80\000\00000\000\0000,1\000"
+/* offset=1446 */ "dispatch_blocked.any\000other\000Memory cluster signals to block micro-op dispatch for any reason\000event=9,period=200000,umask=0x20\000\00000\000\0000,1\000"
+/* offset=1580 */ "eist_trans\000other\000Number of Enhanced Intel SpeedStep(R) Technology (EIST) transitions\000event=0x3a,period=200000\000\00000\000\0000,1\000"
+/* offset=1699 */ "hisi_sccl,ddrc\000"
+/* offset=1714 */ "uncore_hisi_ddrc.flux_wcmd\000uncore\000DDRC write commands\000event=2\000\00000\000DDRC write commands\000\000"
+/* offset=1801 */ "uncore_cbox\000"
+/* offset=1813 */ "unc_cbo_xsnp_response.miss_eviction\000uncore\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000event=0x22,umask=0x81\000\00000\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\0000,1\000"
+/* offset=2048 */ "event-hyphen\000uncore\000UNC_CBO_HYPHEN\000event=0xe0\000\00000\000UNC_CBO_HYPHEN\000\000"
+/* offset=2114 */ "event-two-hyph\000uncore\000UNC_CBO_TWO_HYPH\000event=0xc0\000\00000\000UNC_CBO_TWO_HYPH\000\000"
+/* offset=2186 */ "hisi_sccl,l3c\000"
+/* offset=2200 */ "uncore_hisi_l3c.rd_hit_cpipe\000uncore\000Total read hits\000event=7\000\00000\000Total read hits\000\000"
+/* offset=2281 */ "uncore_imc_free_running\000"
+/* offset=2305 */ "uncore_imc_free_running.cache_miss\000uncore\000Total cache misses\000event=0x12\000\00000\000Total cache misses\000\000"
+/* offset=2401 */ "uncore_imc\000"
+/* offset=2412 */ "uncore_imc.cache_hits\000uncore\000Total cache hits\000event=0x34\000\00000\000Total cache hits\000\000"
+/* offset=2491 */ "uncore_sys_ddr_pmu\000"
+/* offset=2510 */ "sys_ddr_pmu.write_cycles\000uncore\000ddr write-cycles event\000event=0x2b\000v8\00000\000\000\000"
+/* offset=2584 */ "uncore_sys_ccn_pmu\000"
+/* offset=2603 */ "sys_ccn_pmu.read_cycles\000uncore\000ccn read-cycles event\000config=0x2c\0000x01\00000\000\000\000"
+/* offset=2678 */ "uncore_sys_cmn_pmu\000"
+/* offset=2697 */ "sys_cmn_pmu.hnf_cache_miss\000uncore\000Counts total cache misses in first lookup result (high priority)\000eventid=1,type=5\000(434|436|43c|43a).*\00000\000\000\000"
+/* offset=2838 */ "CPI\000\0001 / IPC\000\000\000\000\000\000\000\00000"
+/* offset=2860 */ "IPC\000group1\000inst_retired.any / cpu_clk_unhalted.thread\000\000\000\000\000\000\000\00000"
+/* offset=2923 */ "Frontend_Bound_SMT\000\000idq_uops_not_delivered.core / (4 * (cpu_clk_unhalted.thread / 2 * (1 + cpu_clk_unhalted.one_thread_active / cpu_clk_unhalted.ref_xclk)))\000\000\000\000\000\000\000\00000"
+/* offset=3089 */ "dcache_miss_cpi\000\000l1d\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000"
+/* offset=3153 */ "icache_miss_cycles\000\000l1i\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000"
+/* offset=3220 */ "cache_miss_cycles\000group1\000dcache_miss_cpi + icache_miss_cycles\000\000\000\000\000\000\000\00000"
+/* offset=3291 */ "DCache_L2_All_Hits\000\000l2_rqsts.demand_data_rd_hit + l2_rqsts.pf_hit + l2_rqsts.rfo_hit\000\000\000\000\000\000\000\00000"
+/* offset=3385 */ "DCache_L2_All_Miss\000\000max(l2_rqsts.all_demand_data_rd - l2_rqsts.demand_data_rd_hit, 0) + l2_rqsts.pf_miss + l2_rqsts.rfo_miss\000\000\000\000\000\000\000\00000"
+/* offset=3519 */ "DCache_L2_All\000\000DCache_L2_All_Hits + DCache_L2_All_Miss\000\000\000\000\000\000\000\00000"
+/* offset=3583 */ "DCache_L2_Hits\000\000d_ratio(DCache_L2_All_Hits, DCache_L2_All)\000\000\000\000\000\000\000\00000"
+/* offset=3651 */ "DCache_L2_Misses\000\000d_ratio(DCache_L2_All_Miss, DCache_L2_All)\000\000\000\000\000\000\000\00000"
+/* offset=3721 */ "M1\000\000ipc + M2\000\000\000\000\000\000\000\00000"
+/* offset=3743 */ "M2\000\000ipc + M1\000\000\000\000\000\000\000\00000"
+/* offset=3765 */ "M3\000\0001 / M3\000\000\000\000\000\000\000\00000"
+/* offset=3785 */ "L1D_Cache_Fill_BW\000\00064 * l1d.replacement / 1e9 / duration_time\000\000\000\000\000\000\000\00000"
 ;
 
 static const struct compact_pmu_event pmu_events__common_tool[] = {
-{ 5 }, /* duration_time\000tool\000Wall clock interval time in nanoseconds\000config=1\000\00000\000\000 */
-{ 210 }, /* has_pmem\000tool\0001 if persistent memory installed otherwise 0\000config=4\000\00000\000\000 */
-{ 283 }, /* num_cores\000tool\000Number of cores. A core consists of 1 or more thread, with each thread being associated with a logical Linux CPU\000config=5\000\00000\000\000 */
-{ 425 }, /* num_cpus\000tool\000Number of logical Linux CPUs. There may be multiple such CPUs on a core\000config=6\000\00000\000\000 */
-{ 525 }, /* num_cpus_online\000tool\000Number of online logical Linux CPUs. There may be multiple such CPUs on a core\000config=7\000\00000\000\000 */
-{ 639 }, /* num_dies\000tool\000Number of dies. Each die has 1 or more cores\000config=8\000\00000\000\000 */
-{ 712 }, /* num_packages\000tool\000Number of packages. Each package has 1 or more die\000config=9\000\00000\000\000 */
-{ 795 }, /* slots\000tool\000Number of functional units that in parallel can execute parts of an instruction\000config=0xa\000\00000\000\000 */
-{ 902 }, /* smt_on\000tool\0001 if simultaneous multithreading (aka hyperthreading) is enable otherwise 0\000config=0xb\000\00000\000\000 */
-{ 145 }, /* system_time\000tool\000System/kernel time in nanoseconds\000config=3\000\00000\000\000 */
-{ 1006 }, /* system_tsc_freq\000tool\000The amount a Time Stamp Counter (TSC) increases per second\000config=0xc\000\00000\000\000 */
-{ 78 }, /* user_time\000tool\000User (non-kernel) time in nanoseconds\000config=2\000\00000\000\000 */
+{ 5 }, /* duration_time\000tool\000Wall clock interval time in nanoseconds\000config=1\000\00000\000\000\000 */
+{ 213 }, /* has_pmem\000tool\0001 if persistent memory installed otherwise 0\000config=4\000\00000\000\000\000 */
+{ 287 }, /* num_cores\000tool\000Number of cores. A core consists of 1 or more thread, with each thread being associated with a logical Linux CPU\000config=5\000\00000\000\000\000 */
+{ 430 }, /* num_cpus\000tool\000Number of logical Linux CPUs. There may be multiple such CPUs on a core\000config=6\000\00000\000\000\000 */
+{ 531 }, /* num_cpus_online\000tool\000Number of online logical Linux CPUs. There may be multiple such CPUs on a core\000config=7\000\00000\000\000\000 */
+{ 646 }, /* num_dies\000tool\000Number of dies. Each die has 1 or more cores\000config=8\000\00000\000\000\000 */
+{ 720 }, /* num_packages\000tool\000Number of packages. Each package has 1 or more die\000config=9\000\00000\000\000\000 */
+{ 804 }, /* slots\000tool\000Number of functional units that in parallel can execute parts of an instruction\000config=0xa\000\00000\000\000\000 */
+{ 912 }, /* smt_on\000tool\0001 if simultaneous multithreading (aka hyperthreading) is enable otherwise 0\000config=0xb\000\00000\000\000\000 */
+{ 147 }, /* system_time\000tool\000System/kernel time in nanoseconds\000config=3\000\00000\000\000\000 */
+{ 1017 }, /* system_tsc_freq\000tool\000The amount a Time Stamp Counter (TSC) increases per second\000config=0xc\000\00000\000\000\000 */
+{ 79 }, /* user_time\000tool\000User (non-kernel) time in nanoseconds\000config=2\000\00000\000\000\000 */
 
 };
 
@@ -99,29 +99,29 @@ const struct pmu_table_entry pmu_events__common[] = {
 };
 
 static const struct compact_pmu_event pmu_events__test_soc_cpu_default_core[] = {
-{ 1115 }, /* bp_l1_btb_correct\000branch\000L1 BTB Correction\000event=0x8a\000\00000\000\000 */
-{ 1174 }, /* bp_l2_btb_correct\000branch\000L2 BTB Correction\000event=0x8b\000\00000\000\000 */
-{ 1427 }, /* dispatch_blocked.any\000other\000Memory cluster signals to block micro-op dispatch for any reason\000event=9,period=200000,umask=0x20\000\00000\000\000 */
-{ 1557 }, /* eist_trans\000other\000Number of Enhanced Intel SpeedStep(R) Technology (EIST) transitions\000event=0x3a,period=200000\000\00000\000\000 */
-{ 1233 }, /* l3_cache_rd\000cache\000L3 cache access, read\000event=0x40\000\00000\000Attributable Level 3 cache access, read\000 */
-{ 1328 }, /* segment_reg_loads.any\000other\000Number of segment register loads\000event=6,period=200000,umask=0x80\000\00000\000\000 */
+{ 1127 }, /* bp_l1_btb_correct\000branch\000L1 BTB Correction\000event=0x8a\000\00000\000\000\000 */
+{ 1187 }, /* bp_l2_btb_correct\000branch\000L2 BTB Correction\000event=0x8b\000\00000\000\000\000 */
+{ 1446 }, /* dispatch_blocked.any\000other\000Memory cluster signals to block micro-op dispatch for any reason\000event=9,period=200000,umask=0x20\000\00000\000\0000,1\000 */
+{ 1580 }, /* eist_trans\000other\000Number of Enhanced Intel SpeedStep(R) Technology (EIST) transitions\000event=0x3a,period=200000\000\00000\000\0000,1\000 */
+{ 1247 }, /* l3_cache_rd\000cache\000L3 cache access, read\000event=0x40\000\00000\000Attributable Level 3 cache access, read\000\000 */
+{ 1343 }, /* segment_reg_loads.any\000other\000Number of segment register loads\000event=6,period=200000,umask=0x80\000\00000\000\0000,1\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_hisi_sccl_ddrc[] = {
-{ 1687 }, /* uncore_hisi_ddrc.flux_wcmd\000uncore\000DDRC write commands\000event=2\000\00000\000DDRC write commands\000 */
+{ 1714 }, /* uncore_hisi_ddrc.flux_wcmd\000uncore\000DDRC write commands\000event=2\000\00000\000DDRC write commands\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_hisi_sccl_l3c[] = {
-{ 2166 }, /* uncore_hisi_l3c.rd_hit_cpipe\000uncore\000Total read hits\000event=7\000\00000\000Total read hits\000 */
+{ 2200 }, /* uncore_hisi_l3c.rd_hit_cpipe\000uncore\000Total read hits\000event=7\000\00000\000Total read hits\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_uncore_cbox[] = {
-{ 2016 }, /* event-hyphen\000uncore\000UNC_CBO_HYPHEN\000event=0xe0\000\00000\000UNC_CBO_HYPHEN\000 */
-{ 2081 }, /* event-two-hyph\000uncore\000UNC_CBO_TWO_HYPH\000event=0xc0\000\00000\000UNC_CBO_TWO_HYPH\000 */
-{ 1785 }, /* unc_cbo_xsnp_response.miss_eviction\000uncore\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000event=0x22,umask=0x81\000\00000\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000 */
+{ 2048 }, /* event-hyphen\000uncore\000UNC_CBO_HYPHEN\000event=0xe0\000\00000\000UNC_CBO_HYPHEN\000\000 */
+{ 2114 }, /* event-two-hyph\000uncore\000UNC_CBO_TWO_HYPH\000event=0xc0\000\00000\000UNC_CBO_TWO_HYPH\000\000 */
+{ 1813 }, /* unc_cbo_xsnp_response.miss_eviction\000uncore\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\000event=0x22,umask=0x81\000\00000\000A cross-core snoop resulted from L3 Eviction which misses in some processor core\0000,1\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_uncore_imc[] = {
-{ 2376 }, /* uncore_imc.cache_hits\000uncore\000Total cache hits\000event=0x34\000\00000\000Total cache hits\000 */
+{ 2412 }, /* uncore_imc.cache_hits\000uncore\000Total cache hits\000event=0x34\000\00000\000Total cache hits\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_cpu_uncore_imc_free_running[] = {
-{ 2270 }, /* uncore_imc_free_running.cache_miss\000uncore\000Total cache misses\000event=0x12\000\00000\000Total cache misses\000 */
+{ 2305 }, /* uncore_imc_free_running.cache_miss\000uncore\000Total cache misses\000event=0x12\000\00000\000Total cache misses\000\000 */
 
 };
 
@@ -129,51 +129,51 @@ const struct pmu_table_entry pmu_events__test_soc_cpu[] = {
 {
      .entries = pmu_events__test_soc_cpu_default_core,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_default_core),
-     .pmu_name = { 1102 /* default_core\000 */ },
+     .pmu_name = { 1114 /* default_core\000 */ },
 },
 {
      .entries = pmu_events__test_soc_cpu_hisi_sccl_ddrc,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_hisi_sccl_ddrc),
-     .pmu_name = { 1672 /* hisi_sccl,ddrc\000 */ },
+     .pmu_name = { 1699 /* hisi_sccl,ddrc\000 */ },
 },
 {
      .entries = pmu_events__test_soc_cpu_hisi_sccl_l3c,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_hisi_sccl_l3c),
-     .pmu_name = { 2152 /* hisi_sccl,l3c\000 */ },
+     .pmu_name = { 2186 /* hisi_sccl,l3c\000 */ },
 },
 {
      .entries = pmu_events__test_soc_cpu_uncore_cbox,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_uncore_cbox),
-     .pmu_name = { 1773 /* uncore_cbox\000 */ },
+     .pmu_name = { 1801 /* uncore_cbox\000 */ },
 },
 {
      .entries = pmu_events__test_soc_cpu_uncore_imc,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_uncore_imc),
-     .pmu_name = { 2365 /* uncore_imc\000 */ },
+     .pmu_name = { 2401 /* uncore_imc\000 */ },
 },
 {
      .entries = pmu_events__test_soc_cpu_uncore_imc_free_running,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_cpu_uncore_imc_free_running),
-     .pmu_name = { 2246 /* uncore_imc_free_running\000 */ },
+     .pmu_name = { 2281 /* uncore_imc_free_running\000 */ },
 },
 };
 
 static const struct compact_pmu_event pmu_metrics__test_soc_cpu_default_core[] = {
-{ 2798 }, /* CPI\000\0001 / IPC\000\000\000\000\000\000\000\00000 */
-{ 3479 }, /* DCache_L2_All\000\000DCache_L2_All_Hits + DCache_L2_All_Miss\000\000\000\000\000\000\000\00000 */
-{ 3251 }, /* DCache_L2_All_Hits\000\000l2_rqsts.demand_data_rd_hit + l2_rqsts.pf_hit + l2_rqsts.rfo_hit\000\000\000\000\000\000\000\00000 */
-{ 3345 }, /* DCache_L2_All_Miss\000\000max(l2_rqsts.all_demand_data_rd - l2_rqsts.demand_data_rd_hit, 0) + l2_rqsts.pf_miss + l2_rqsts.rfo_miss\000\000\000\000\000\000\000\00000 */
-{ 3543 }, /* DCache_L2_Hits\000\000d_ratio(DCache_L2_All_Hits, DCache_L2_All)\000\000\000\000\000\000\000\00000 */
-{ 3611 }, /* DCache_L2_Misses\000\000d_ratio(DCache_L2_All_Miss, DCache_L2_All)\000\000\000\000\000\000\000\00000 */
-{ 2883 }, /* Frontend_Bound_SMT\000\000idq_uops_not_delivered.core / (4 * (cpu_clk_unhalted.thread / 2 * (1 + cpu_clk_unhalted.one_thread_active / cpu_clk_unhalted.ref_xclk)))\000\000\000\000\000\000\000\00000 */
-{ 2820 }, /* IPC\000group1\000inst_retired.any / cpu_clk_unhalted.thread\000\000\000\000\000\000\000\00000 */
-{ 3745 }, /* L1D_Cache_Fill_BW\000\00064 * l1d.replacement / 1e9 / duration_time\000\000\000\000\000\000\000\00000 */
-{ 3681 }, /* M1\000\000ipc + M2\000\000\000\000\000\000\000\00000 */
-{ 3703 }, /* M2\000\000ipc + M1\000\000\000\000\000\000\000\00000 */
-{ 3725 }, /* M3\000\0001 / M3\000\000\000\000\000\000\000\00000 */
-{ 3180 }, /* cache_miss_cycles\000group1\000dcache_miss_cpi + icache_miss_cycles\000\000\000\000\000\000\000\00000 */
-{ 3049 }, /* dcache_miss_cpi\000\000l1d\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000 */
-{ 3113 }, /* icache_miss_cycles\000\000l1i\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000 */
+{ 2838 }, /* CPI\000\0001 / IPC\000\000\000\000\000\000\000\00000 */
+{ 3519 }, /* DCache_L2_All\000\000DCache_L2_All_Hits + DCache_L2_All_Miss\000\000\000\000\000\000\000\00000 */
+{ 3291 }, /* DCache_L2_All_Hits\000\000l2_rqsts.demand_data_rd_hit + l2_rqsts.pf_hit + l2_rqsts.rfo_hit\000\000\000\000\000\000\000\00000 */
+{ 3385 }, /* DCache_L2_All_Miss\000\000max(l2_rqsts.all_demand_data_rd - l2_rqsts.demand_data_rd_hit, 0) + l2_rqsts.pf_miss + l2_rqsts.rfo_miss\000\000\000\000\000\000\000\00000 */
+{ 3583 }, /* DCache_L2_Hits\000\000d_ratio(DCache_L2_All_Hits, DCache_L2_All)\000\000\000\000\000\000\000\00000 */
+{ 3651 }, /* DCache_L2_Misses\000\000d_ratio(DCache_L2_All_Miss, DCache_L2_All)\000\000\000\000\000\000\000\00000 */
+{ 2923 }, /* Frontend_Bound_SMT\000\000idq_uops_not_delivered.core / (4 * (cpu_clk_unhalted.thread / 2 * (1 + cpu_clk_unhalted.one_thread_active / cpu_clk_unhalted.ref_xclk)))\000\000\000\000\000\000\000\00000 */
+{ 2860 }, /* IPC\000group1\000inst_retired.any / cpu_clk_unhalted.thread\000\000\000\000\000\000\000\00000 */
+{ 3785 }, /* L1D_Cache_Fill_BW\000\00064 * l1d.replacement / 1e9 / duration_time\000\000\000\000\000\000\000\00000 */
+{ 3721 }, /* M1\000\000ipc + M2\000\000\000\000\000\000\000\00000 */
+{ 3743 }, /* M2\000\000ipc + M1\000\000\000\000\000\000\000\00000 */
+{ 3765 }, /* M3\000\0001 / M3\000\000\000\000\000\000\000\00000 */
+{ 3220 }, /* cache_miss_cycles\000group1\000dcache_miss_cpi + icache_miss_cycles\000\000\000\000\000\000\000\00000 */
+{ 3089 }, /* dcache_miss_cpi\000\000l1d\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000 */
+{ 3153 }, /* icache_miss_cycles\000\000l1i\\-loads\\-misses / inst_retired.any\000\000\000\000\000\000\000\00000 */
 
 };
 
@@ -181,18 +181,18 @@ const struct pmu_table_entry pmu_metrics__test_soc_cpu[] = {
 {
      .entries = pmu_metrics__test_soc_cpu_default_core,
      .num_entries = ARRAY_SIZE(pmu_metrics__test_soc_cpu_default_core),
-     .pmu_name = { 1102 /* default_core\000 */ },
+     .pmu_name = { 1114 /* default_core\000 */ },
 },
 };
 
 static const struct compact_pmu_event pmu_events__test_soc_sys_uncore_sys_ccn_pmu[] = {
-{ 2565 }, /* sys_ccn_pmu.read_cycles\000uncore\000ccn read-cycles event\000config=0x2c\0000x01\00000\000\000 */
+{ 2603 }, /* sys_ccn_pmu.read_cycles\000uncore\000ccn read-cycles event\000config=0x2c\0000x01\00000\000\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_sys_uncore_sys_cmn_pmu[] = {
-{ 2658 }, /* sys_cmn_pmu.hnf_cache_miss\000uncore\000Counts total cache misses in first lookup result (high priority)\000eventid=1,type=5\000(434|436|43c|43a).*\00000\000\000 */
+{ 2697 }, /* sys_cmn_pmu.hnf_cache_miss\000uncore\000Counts total cache misses in first lookup result (high priority)\000eventid=1,type=5\000(434|436|43c|43a).*\00000\000\000\000 */
 };
 static const struct compact_pmu_event pmu_events__test_soc_sys_uncore_sys_ddr_pmu[] = {
-{ 2473 }, /* sys_ddr_pmu.write_cycles\000uncore\000ddr write-cycles event\000event=0x2b\000v8\00000\000\000 */
+{ 2510 }, /* sys_ddr_pmu.write_cycles\000uncore\000ddr write-cycles event\000event=0x2b\000v8\00000\000\000\000 */
 
 };
 
@@ -200,17 +200,17 @@ const struct pmu_table_entry pmu_events__test_soc_sys[] = {
 {
      .entries = pmu_events__test_soc_sys_uncore_sys_ccn_pmu,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_sys_uncore_sys_ccn_pmu),
-     .pmu_name = { 2546 /* uncore_sys_ccn_pmu\000 */ },
+     .pmu_name = { 2584 /* uncore_sys_ccn_pmu\000 */ },
 },
 {
      .entries = pmu_events__test_soc_sys_uncore_sys_cmn_pmu,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_sys_uncore_sys_cmn_pmu),
-     .pmu_name = { 2639 /* uncore_sys_cmn_pmu\000 */ },
+     .pmu_name = { 2678 /* uncore_sys_cmn_pmu\000 */ },
 },
 {
      .entries = pmu_events__test_soc_sys_uncore_sys_ddr_pmu,
      .num_entries = ARRAY_SIZE(pmu_events__test_soc_sys_uncore_sys_ddr_pmu),
-     .pmu_name = { 2454 /* uncore_sys_ddr_pmu\000 */ },
+     .pmu_name = { 2491 /* uncore_sys_ddr_pmu\000 */ },
 },
 };
 
@@ -227,6 +227,12 @@ struct pmu_metrics_table {
         uint32_t num_pmus;
 };
 
+/* Struct used to make the PMU counter layout table implementation opaque to callers. */
+struct pmu_layouts_table {
+        const struct compact_pmu_event *entries;
+        size_t length;
+};
+
 /*
  * Map a CPU to its table of PMU events. The CPU is identified by the
  * cpuid field, which is an arch-specific identifier for the CPU.
@@ -240,6 +246,7 @@ struct pmu_events_map {
         const char *cpuid;
         struct pmu_events_table event_table;
         struct pmu_metrics_table metric_table;
+        struct pmu_layouts_table layout_table;
 };
 
 /*
@@ -273,6 +280,7 @@ const struct pmu_events_map pmu_events_map[] = {
 	.cpuid = 0,
 	.event_table = { 0, 0 },
 	.metric_table = { 0, 0 },
+	.layout_table = { 0, 0 },
 }
 };
 
@@ -317,6 +325,8 @@ static void decompress_event(int offset, struct pmu_event *pe)
 	pe->unit = (*p == '\0' ? NULL : p);
 	while (*p++);
 	pe->long_desc = (*p == '\0' ? NULL : p);
+	while (*p++);
+	pe->counters_list = (*p == '\0' ? NULL : p);
 }
 
 static void decompress_metric(int offset, struct pmu_metric *pm)
@@ -348,6 +358,19 @@ static void decompress_metric(int offset, struct pmu_metric *pm)
 	pm->event_grouping = *p - '0';
 }
 
+static void decompress_layout(int offset, struct pmu_layout *pm)
+{
+	const char *p = &big_c_string[offset];
+
+	pm->pmu = (*p == '\0' ? NULL : p);
+	while (*p++);
+	pm->desc = (*p == '\0' ? NULL : p);
+	p++;
+	pm->counters_num_gp = *p - '0';
+	p++;
+	pm->counters_num_fixed = *p - '0';
+}
+
 static int pmu_events_table__for_each_event_pmu(const struct pmu_events_table *table,
                                                 const struct pmu_table_entry *pmu,
                                                 pmu_event_iter_fn fn,
@@ -503,6 +526,21 @@ int pmu_metrics_table__for_each_metric(const struct pmu_metrics_table *table,
         return 0;
 }
 
+int pmu_layouts_table__for_each_layout(const struct pmu_layouts_table *table,
+                                     pmu_layout_iter_fn fn,
+                                     void *data) {
+        for (size_t i = 0; i < table->length; i++) {
+                struct pmu_layout pm;
+                int ret;
+
+                decompress_layout(table->entries[i].offset, &pm);
+                ret = fn(&pm, data);
+                if (ret)
+                        return ret;
+        }
+        return 0;
+}
+
 static const struct pmu_events_map *map_for_cpu(struct perf_cpu cpu)
 {
         static struct {
@@ -595,6 +633,34 @@ const struct pmu_metrics_table *pmu_metrics_table__find(void)
         return map ? &map->metric_table : NULL;
 }
 
+const struct pmu_layouts_table *perf_pmu__find_layouts_table(void)
+{
+        const struct pmu_layouts_table *table = NULL;
+        struct perf_cpu cpu = {-1};
+        char *cpuid = get_cpuid_allow_env_override(cpu);
+        int i;
+
+        /* on some platforms which uses cpus map, cpuid can be NULL for
+         * PMUs other than CORE PMUs.
+         */
+        if (!cpuid)
+                return NULL;
+
+        i = 0;
+        for (;;) {
+                const struct pmu_events_map *map = &pmu_events_map[i++];
+                if (!map->arch)
+                        break;
+
+                if (!strcmp_cpuid_str(map->cpuid, cpuid)) {
+                        table = &map->layout_table;
+                        break;
+                }
+        }
+        free(cpuid);
+        return table;
+}
+
 const struct pmu_events_table *find_core_events_table(const char *arch, const char *cpuid)
 {
         for (const struct pmu_events_map *tables = &pmu_events_map[0];
@@ -616,6 +682,16 @@ const struct pmu_metrics_table *find_core_metrics_table(const char *arch, const
         }
         return NULL;
 }
+const struct pmu_layouts_table *find_core_layouts_table(const char *arch, const char *cpuid)
+{
+        for (const struct pmu_events_map *tables = &pmu_events_map[0];
+             tables->arch;
+             tables++) {
+                if (!strcmp(tables->arch, arch) && !strcmp_cpuid_str(tables->cpuid, cpuid))
+                        return &tables->layout_table;
+        }
+        return NULL;
+}
 
 int pmu_for_each_core_event(pmu_event_iter_fn fn, void *data)
 {
@@ -644,6 +720,19 @@ int pmu_for_each_core_metric(pmu_metric_iter_fn fn, void *data)
         return 0;
 }
 
+int pmu_for_each_core_layout(pmu_layout_iter_fn fn, void *data)
+{
+        for (const struct pmu_events_map *tables = &pmu_events_map[0];
+             tables->arch;
+             tables++) {
+                int ret = pmu_layouts_table__for_each_layout(&tables->layout_table, fn, data);
+
+                if (ret)
+                        return ret;
+        }
+        return 0;
+}
+
 const struct pmu_events_table *find_sys_events_table(const char *name)
 {
         for (const struct pmu_sys_events *tables = &pmu_sys_event_tables[0];
diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
index d781a377757a..5fd906ac6642 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -23,6 +23,8 @@ _metric_tables = []
 _sys_metric_tables = []
 # Mapping between sys event table names and sys metric table names.
 _sys_event_table_to_metric_table_mapping = {}
+# List of regular PMU counter layout tables.
+_pmu_layouts_tables = []
 # Map from an event name to an architecture standard
 # JsonEvent. Architecture standard events are in json files in the top
 # f'{_args.starting_dir}/{_args.arch}' directory.
@@ -31,6 +33,10 @@ _arch_std_events = {}
 _pending_events = []
 # Name of events table to be written out
 _pending_events_tblname = None
+# PMU counter layout to write out when the layout table is closed
+_pending_pmu_counts = []
+# Name of PMU counter layout table to be written out
+_pending_pmu_counts_tblname = None
 # Metrics to write out when the table is closed
 _pending_metrics = []
 # Name of metrics table to be written out
@@ -51,6 +57,11 @@ _json_event_attributes = [
     'long_desc'
 ]
 
+# Attributes that are in pmu_unit_layout.
+_json_layout_attributes = [
+    'pmu', 'desc'
+]
+
 # Attributes that are in pmu_metric rather than pmu_event.
 _json_metric_attributes = [
     'metric_name', 'metric_group', 'metric_expr', 'metric_threshold',
@@ -265,7 +276,7 @@ class JsonEvent:
 
     def unit_to_pmu(unit: str) -> Optional[str]:
       """Convert a JSON Unit to Linux PMU name."""
-      if not unit:
+      if not unit or unit == "core":
         return 'default_core'
       # Comment brought over from jevents.c:
       # it's not realistic to keep adding these, we need something more scalable ...
@@ -336,6 +347,19 @@ class JsonEvent:
     if 'Errata' in jd:
       extra_desc += '  Spec update: ' + jd['Errata']
     self.pmu = unit_to_pmu(jd.get('Unit'))
+    # The list of counter(s) the event could be collected with
+    class Counter:
+      gp = str()
+      fixed = str()
+    self.counters = {'list': str(), 'num': Counter()}
+    self.counters['list'] = jd.get('Counter')
+    # Number of generic counter
+    self.counters['num'].gp = jd.get('CountersNumGeneric')
+    # Number of fixed counter
+    self.counters['num'].fixed = jd.get('CountersNumFixed')
+    # If the event uses an MSR, other event uses the same MSR could not be
+    # schedule to collect at the same time.
+    self.msr = jd.get('MSRIndex')
     filter = jd.get('Filter')
     self.unit = jd.get('ScaleUnit')
     self.perpkg = jd.get('PerPkg')
@@ -411,8 +435,20 @@ class JsonEvent:
         s += f'\t{attr} = {value},\n'
     return s + '}'
 
-  def build_c_string(self, metric: bool) -> str:
+  def build_c_string(self, metric: bool, layout: bool) -> str:
     s = ''
+    if layout:
+      for attr in _json_layout_attributes:
+        x = getattr(self, attr)
+        if attr in _json_enum_attributes:
+          s += x if x else '0'
+        else:
+          s += f'{x}\\000' if x else '\\000'
+      x = self.counters['num'].gp
+      s += x if x else '0'
+      x = self.counters['num'].fixed
+      s += x if x else '0'
+      return s
     for attr in _json_metric_attributes if metric else _json_event_attributes:
       x = getattr(self, attr)
       if metric and x and attr == 'metric_expr':
@@ -425,12 +461,15 @@ class JsonEvent:
         s += x if x else '0'
       else:
         s += f'{x}\\000' if x else '\\000'
+    if not metric:
+      x = self.counters['list']
+      s += f'{x}\\000' if x else '\\000'
     return s
 
-  def to_c_string(self, metric: bool) -> str:
+  def to_c_string(self, metric: bool, layout: bool) -> str:
     """Representation of the event as a C struct initializer."""
 
-    s = self.build_c_string(metric)
+    s = self.build_c_string(metric, layout)
     return f'{{ { _bcs.offsets[s] } }}, /* {s} */\n'
 
 
@@ -467,6 +506,8 @@ def preprocess_arch_std_files(archpath: str) -> None:
           _arch_std_events[event.name.lower()] = event
         if event.metric_name:
           _arch_std_events[event.metric_name.lower()] = event
+        if event.counters['num'].gp:
+          _arch_std_events[event.pmu.lower()] = event
 
 
 def add_events_table_entries(item: os.DirEntry, topic: str) -> None:
@@ -476,6 +517,8 @@ def add_events_table_entries(item: os.DirEntry, topic: str) -> None:
       _pending_events.append(e)
     if e.metric_name:
       _pending_metrics.append(e)
+    if e.counters['num'].gp:
+      _pending_pmu_counts.append(e)
 
 
 def print_pending_events() -> None:
@@ -519,8 +562,8 @@ def print_pending_events() -> None:
       last_pmu = event.pmu
       pmus.add((event.pmu, pmu_name))
 
-    _args.output_file.write(event.to_c_string(metric=False))
     last_name = event.name
+    _args.output_file.write(event.to_c_string(metric=False, layout=False))
   _pending_events = []
 
   _args.output_file.write(f"""
@@ -575,7 +618,7 @@ def print_pending_metrics() -> None:
       last_pmu = metric.pmu
       pmus.add((metric.pmu, pmu_name))
 
-    _args.output_file.write(metric.to_c_string(metric=True))
+    _args.output_file.write(metric.to_c_string(metric=True, layout=False))
   _pending_metrics = []
 
   _args.output_file.write(f"""
@@ -593,6 +636,35 @@ const struct pmu_table_entry {_pending_metrics_tblname}[] = {{
 """)
   _args.output_file.write('};\n\n')
 
+def print_pending_pmu_counter_layout_table() -> None:
+  '''Print counter layout data from counter.json file to counter layout table in
+    c-string'''
+
+  def pmu_counts_cmp_key(j: JsonEvent) -> Tuple[bool, str, str]:
+    def fix_none(s: Optional[str]) -> str:
+      if s is None:
+        return ''
+      return s
+
+    return (j.desc is not None, fix_none(j.pmu))
+
+  global _pending_pmu_counts
+  if not _pending_pmu_counts:
+    return
+
+  global _pending_pmu_counts_tblname
+  global pmu_layouts_tables
+  _pmu_layouts_tables.append(_pending_pmu_counts_tblname)
+
+  _args.output_file.write(
+      f'static const struct compact_pmu_event {_pending_pmu_counts_tblname}[] = {{\n')
+
+  for pmu_layout in sorted(_pending_pmu_counts, key=pmu_counts_cmp_key):
+    _args.output_file.write(pmu_layout.to_c_string(metric=False, layout=True))
+    _pending_pmu_counts = []
+
+  _args.output_file.write('};\n\n')
+
 def get_topic(topic: str) -> str:
   if topic.endswith('metrics.json'):
     return 'metrics'
@@ -629,10 +701,12 @@ def preprocess_one_file(parents: Sequence[str], item: os.DirEntry) -> None:
     pmu_name = f"{event.pmu}\\000"
     if event.name:
       _bcs.add(pmu_name, metric=False)
-      _bcs.add(event.build_c_string(metric=False), metric=False)
+      _bcs.add(event.build_c_string(metric=False, layout=False), metric=False)
     if event.metric_name:
       _bcs.add(pmu_name, metric=True)
-      _bcs.add(event.build_c_string(metric=True), metric=True)
+      _bcs.add(event.build_c_string(metric=True, layout=False), metric=True)
+    if event.counters['num'].gp:
+      _bcs.add(event.build_c_string(metric=False, layout=True), metric=False)
 
 def process_one_file(parents: Sequence[str], item: os.DirEntry) -> None:
   """Process a JSON file during the main walk."""
@@ -649,11 +723,14 @@ def process_one_file(parents: Sequence[str], item: os.DirEntry) -> None:
   if item.is_dir() and is_leaf_dir_ignoring_sys(item.path):
     print_pending_events()
     print_pending_metrics()
+    print_pending_pmu_counter_layout_table()
 
     global _pending_events_tblname
     _pending_events_tblname = file_name_to_table_name('pmu_events_', parents, item.name)
     global _pending_metrics_tblname
     _pending_metrics_tblname = file_name_to_table_name('pmu_metrics_', parents, item.name)
+    global _pending_pmu_counts_tblname
+    _pending_pmu_counts_tblname = file_name_to_table_name('pmu_layouts_', parents, item.name)
 
     if item.name == 'sys':
       _sys_event_table_to_metric_table_mapping[_pending_events_tblname] = _pending_metrics_tblname
@@ -687,6 +764,12 @@ struct pmu_metrics_table {
         uint32_t num_pmus;
 };
 
+/* Struct used to make the PMU counter layout table implementation opaque to callers. */
+struct pmu_layouts_table {
+        const struct compact_pmu_event *entries;
+        size_t length;
+};
+
 /*
  * Map a CPU to its table of PMU events. The CPU is identified by the
  * cpuid field, which is an arch-specific identifier for the CPU.
@@ -700,6 +783,7 @@ struct pmu_events_map {
         const char *cpuid;
         struct pmu_events_table event_table;
         struct pmu_metrics_table metric_table;
+        struct pmu_layouts_table layout_table;
 };
 
 /*
@@ -755,6 +839,12 @@ const struct pmu_events_map pmu_events_map[] = {
               metric_size = '0'
             if event_size == '0' and metric_size == '0':
               continue
+            layout_tblname = file_name_to_table_name('pmu_layouts_', [], row[2].replace('/', '_'))
+            if layout_tblname in _pmu_layouts_tables:
+              layout_size = f'ARRAY_SIZE({layout_tblname})'
+            else:
+              layout_tblname = 'NULL'
+              layout_size = '0'
             cpuid = row[0].replace('\\', '\\\\')
             _args.output_file.write(f"""{{
 \t.arch = "{arch}",
@@ -766,6 +856,10 @@ const struct pmu_events_map pmu_events_map[] = {
 \t.metric_table = {{
 \t\t.pmus = {metric_tblname},
 \t\t.num_pmus = {metric_size}
+\t}},
+\t.layout_table = {{
+\t\t.entries = {layout_tblname},
+\t\t.length = {layout_size}
 \t}}
 }},
 """)
@@ -776,6 +870,7 @@ const struct pmu_events_map pmu_events_map[] = {
 \t.cpuid = 0,
 \t.event_table = { 0, 0 },
 \t.metric_table = { 0, 0 },
+\t.layout_table = { 0, 0 },
 }
 };
 """)
@@ -844,6 +939,9 @@ static void decompress_event(int offset, struct pmu_event *pe)
       _args.output_file.write('\tp++;')
     else:
       _args.output_file.write('\twhile (*p++);')
+  _args.output_file.write('\twhile (*p++);')
+  _args.output_file.write(f'\n\tpe->counters_list = ')
+  _args.output_file.write("(*p == '\\0' ? NULL : p);\n")
   _args.output_file.write("""}
 
 static void decompress_metric(int offset, struct pmu_metric *pm)
@@ -864,6 +962,30 @@ static void decompress_metric(int offset, struct pmu_metric *pm)
       _args.output_file.write('\twhile (*p++);')
   _args.output_file.write("""}
 
+static void decompress_layout(int offset, struct pmu_layout *pm)
+{
+\tconst char *p = &big_c_string[offset];
+""")
+  for attr in _json_layout_attributes:
+    _args.output_file.write(f'\n\tpm->{attr} = ')
+    if attr in _json_enum_attributes:
+      _args.output_file.write("*p - '0';\n")
+    else:
+      _args.output_file.write("(*p == '\\0' ? NULL : p);\n")
+    if attr == _json_layout_attributes[-1]:
+      continue
+    if attr in _json_enum_attributes:
+      _args.output_file.write('\tp++;')
+    else:
+      _args.output_file.write('\twhile (*p++);')
+  _args.output_file.write('\tp++;')
+  _args.output_file.write(f'\n\tpm->counters_num_gp = ')
+  _args.output_file.write("*p - '0';\n")
+  _args.output_file.write('\tp++;')
+  _args.output_file.write(f'\n\tpm->counters_num_fixed = ')
+  _args.output_file.write("*p - '0';\n")
+  _args.output_file.write("""}
+
 static int pmu_events_table__for_each_event_pmu(const struct pmu_events_table *table,
                                                 const struct pmu_table_entry *pmu,
                                                 pmu_event_iter_fn fn,
@@ -1019,6 +1141,21 @@ int pmu_metrics_table__for_each_metric(const struct pmu_metrics_table *table,
         return 0;
 }
 
+int pmu_layouts_table__for_each_layout(const struct pmu_layouts_table *table,
+                                     pmu_layout_iter_fn fn,
+                                     void *data) {
+        for (size_t i = 0; i < table->length; i++) {
+                struct pmu_layout pm;
+                int ret;
+
+                decompress_layout(table->entries[i].offset, &pm);
+                ret = fn(&pm, data);
+                if (ret)
+                        return ret;
+        }
+        return 0;
+}
+
 static const struct pmu_events_map *map_for_cpu(struct perf_cpu cpu)
 {
         static struct {
@@ -1111,6 +1248,34 @@ const struct pmu_metrics_table *pmu_metrics_table__find(void)
         return map ? &map->metric_table : NULL;
 }
 
+const struct pmu_layouts_table *perf_pmu__find_layouts_table(void)
+{
+        const struct pmu_layouts_table *table = NULL;
+        struct perf_cpu cpu = {-1};
+        char *cpuid = get_cpuid_allow_env_override(cpu);
+        int i;
+
+        /* on some platforms which uses cpus map, cpuid can be NULL for
+         * PMUs other than CORE PMUs.
+         */
+        if (!cpuid)
+                return NULL;
+
+        i = 0;
+        for (;;) {
+                const struct pmu_events_map *map = &pmu_events_map[i++];
+                if (!map->arch)
+                        break;
+
+                if (!strcmp_cpuid_str(map->cpuid, cpuid)) {
+                        table = &map->layout_table;
+                        break;
+                }
+        }
+        free(cpuid);
+        return table;
+}
+
 const struct pmu_events_table *find_core_events_table(const char *arch, const char *cpuid)
 {
         for (const struct pmu_events_map *tables = &pmu_events_map[0];
@@ -1132,6 +1297,16 @@ const struct pmu_metrics_table *find_core_metrics_table(const char *arch, const
         }
         return NULL;
 }
+const struct pmu_layouts_table *find_core_layouts_table(const char *arch, const char *cpuid)
+{
+        for (const struct pmu_events_map *tables = &pmu_events_map[0];
+             tables->arch;
+             tables++) {
+                if (!strcmp(tables->arch, arch) && !strcmp_cpuid_str(tables->cpuid, cpuid))
+                        return &tables->layout_table;
+        }
+        return NULL;
+}
 
 int pmu_for_each_core_event(pmu_event_iter_fn fn, void *data)
 {
@@ -1160,6 +1335,19 @@ int pmu_for_each_core_metric(pmu_metric_iter_fn fn, void *data)
         return 0;
 }
 
+int pmu_for_each_core_layout(pmu_layout_iter_fn fn, void *data)
+{
+        for (const struct pmu_events_map *tables = &pmu_events_map[0];
+             tables->arch;
+             tables++) {
+                int ret = pmu_layouts_table__for_each_layout(&tables->layout_table, fn, data);
+
+                if (ret)
+                        return ret;
+        }
+        return 0;
+}
+
 const struct pmu_events_table *find_sys_events_table(const char *name)
 {
         for (const struct pmu_sys_events *tables = &pmu_sys_event_tables[0];
@@ -1320,6 +1508,7 @@ struct pmu_table_entry {
     ftw(arch_path, [], process_one_file)
     print_pending_events()
     print_pending_metrics()
+    print_pending_pmu_counter_layout_table()
 
   print_mapping_table(archs)
   print_system_mapping_table()
diff --git a/tools/perf/pmu-events/pmu-events.h b/tools/perf/pmu-events/pmu-events.h
index 675562e6f770..9a5cbec32513 100644
--- a/tools/perf/pmu-events/pmu-events.h
+++ b/tools/perf/pmu-events/pmu-events.h
@@ -45,6 +45,11 @@ struct pmu_event {
 	const char *desc;
 	const char *topic;
 	const char *long_desc;
+	/**
+	 * The list of counter(s) the event could be collected on.
+	 * eg., "0,1,2,3,4,5,6,7".
+	 */
+	const char *counters_list;
 	const char *pmu;
 	const char *unit;
 	bool perpkg;
@@ -67,8 +72,18 @@ struct pmu_metric {
 	enum metric_event_groups event_grouping;
 };
 
+struct pmu_layout {
+	const char *pmu;
+	const char *desc;
+	/** Total number of generic counters*/
+	int counters_num_gp;
+	/** Total number of fixed counters. Set to zero if no fixed counter on the unit.*/
+	int counters_num_fixed;
+};
+
 struct pmu_events_table;
 struct pmu_metrics_table;
+struct pmu_layouts_table;
 
 #define PMU_EVENTS__NOT_FOUND -1000
 
@@ -80,6 +95,9 @@ typedef int (*pmu_metric_iter_fn)(const struct pmu_metric *pm,
 				  const struct pmu_metrics_table *table,
 				  void *data);
 
+typedef int (*pmu_layout_iter_fn)(const struct pmu_layout *pm,
+				  void *data);
+
 int pmu_events_table__for_each_event(const struct pmu_events_table *table,
 				    struct perf_pmu *pmu,
 				    pmu_event_iter_fn fn,
@@ -92,10 +110,13 @@ int pmu_events_table__for_each_event(const struct pmu_events_table *table,
  * search of all tables.
  */
 int pmu_events_table__find_event(const struct pmu_events_table *table,
-                                 struct perf_pmu *pmu,
-                                 const char *name,
-                                 pmu_event_iter_fn fn,
-				 void *data);
+				struct perf_pmu *pmu,
+				const char *name,
+				pmu_event_iter_fn fn,
+				void *data);
+int pmu_layouts_table__for_each_layout(const struct pmu_layouts_table *table,
+					pmu_layout_iter_fn fn,
+					void *data);
 size_t pmu_events_table__num_events(const struct pmu_events_table *table,
 				    struct perf_pmu *pmu);
 
@@ -104,10 +125,13 @@ int pmu_metrics_table__for_each_metric(const struct pmu_metrics_table *table, pm
 
 const struct pmu_events_table *perf_pmu__find_events_table(struct perf_pmu *pmu);
 const struct pmu_metrics_table *pmu_metrics_table__find(void);
+const struct pmu_layouts_table *perf_pmu__find_layouts_table(void);
 const struct pmu_events_table *find_core_events_table(const char *arch, const char *cpuid);
 const struct pmu_metrics_table *find_core_metrics_table(const char *arch, const char *cpuid);
+const struct pmu_layouts_table *find_core_layouts_table(const char *arch, const char *cpuid);
 int pmu_for_each_core_event(pmu_event_iter_fn fn, void *data);
 int pmu_for_each_core_metric(pmu_metric_iter_fn fn, void *data);
+int pmu_for_each_core_layout(pmu_layout_iter_fn fn, void *data);
 
 const struct pmu_events_table *find_sys_events_table(const char *name);
 const struct pmu_metrics_table *find_sys_metrics_table(const char *name);

-- 
2.43.0


