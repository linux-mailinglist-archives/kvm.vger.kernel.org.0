Return-Path: <kvm+bounces-44502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B288A9E1C1
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 11:25:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D03D2169F17
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483092550A8;
	Sun, 27 Apr 2025 09:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="D0ogFz8x"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E0724A067;
	Sun, 27 Apr 2025 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745745695; cv=none; b=mHxuz7HUYcO9gqGF4ysYuslron8CcP1DSEB62ITNm2GpVqAJ8YP1JwOCn5OiNZnl3cZZ/DPaWlKfjXPek4XgEXlvhaNQBptM3D8nKXB4qJ0Xp8lA3Wh1O1LMmGsh5iS1246szpIlbswlhNUf9gwvNXwNFJlWgA9dKf+zLY2b11Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745745695; c=relaxed/simple;
	bh=u8xjMs0f/wZ6npeeiO/kGoUf8izCKrVIU+y3Uw+zGRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tprz0RQ4cM7D1VJjjzEcNsvkllC87a1N30PuarSPYlnbAK7DkDxosutY0d93IsxW37MgGw9HP1Sr2JCoLz1w/nx+8WMu7uvFsjZuhrS5aphOuphVXfrnu9ptfJw97RXQBWewHXkO12OsrI52LatL//UCvyhtT8RXfXawufYz5iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=D0ogFz8x; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53R9KRS21598826
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 27 Apr 2025 02:20:42 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53R9KRS21598826
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745745644;
	bh=ksSIeWAVTacslihTdf7Zx49dtQ9Az+Y+aR8mjOcQqHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0ogFz8xK+U7+UDSUO9GSUMse1XC6Jyah0kmGFtpu5IzZEm46jWJ40rUrbGWi2csJ
	 9o6vLboUmczU+neAMTj74y44dFlbR92Grb53hWR0cR2b7H+o91aoHqaUwmQcyCKUJq
	 FwjqWWVhsgoqWlKjk24/r1/hHZ+ui4ceJrKMSvBGCCvkCUoyAk6LTtv3QrczwHQOpq
	 QY8tV47D00uLSMVryvI0jqkdTDmxmYJN5KYAnJQtq4BUwInkvj3e8YipxAb+9JCIhX
	 yqNBXqdUB81Htf6c+l0BmGUtvczcAzQQm6BiN5EfF9sCUa/yYFBoJHtTLn/u5pMZYg
	 7/vgd7gA2lURw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
Subject: [PATCH v4 05/15] x86/msr: Convert the rdpmc() macro into an always inline function
Date: Sun, 27 Apr 2025 02:20:17 -0700
Message-ID: <20250427092027.1598740-6-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250427092027.1598740-1-xin@zytor.com>
References: <20250427092027.1598740-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Functions offer type safety and better readability compared to macros.
Additionally, always inline functions can match the performance of
macros.  Converting the rdpmc() macro into an always inline function
is simple and straightforward, so just make the change.

Moreover, the read result is now the returned value, further enhancing
readability.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---

Change in v3:
*) Add a changelog even it's obvious (Dave Hansen).
---
 arch/x86/events/amd/uncore.c              |  2 +-
 arch/x86/events/core.c                    |  2 +-
 arch/x86/events/intel/core.c              |  4 ++--
 arch/x86/events/intel/ds.c                |  2 +-
 arch/x86/include/asm/msr.h                |  5 ++++-
 arch/x86/include/asm/paravirt.h           |  4 +---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 12 ++++++------
 7 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 42c833cf9d98..13c4cea545c5 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -108,7 +108,7 @@ static void amd_uncore_read(struct perf_event *event)
 	if (hwc->event_base_rdpmc < 0)
 		rdmsrq(hwc->event_base, new);
 	else
-		rdpmc(hwc->event_base_rdpmc, new);
+		new = rdpmc(hwc->event_base_rdpmc);
 
 	local64_set(&hwc->prev_count, new);
 	delta = (new << COUNTER_SHIFT) - (prev << COUNTER_SHIFT);
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index ea618dd8a678..d8634446684e 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -134,7 +134,7 @@ u64 x86_perf_event_update(struct perf_event *event)
 	 */
 	prev_raw_count = local64_read(&hwc->prev_count);
 	do {
-		rdpmc(hwc->event_base_rdpmc, new_raw_count);
+		new_raw_count = rdpmc(hwc->event_base_rdpmc);
 	} while (!local64_try_cmpxchg(&hwc->prev_count,
 				      &prev_raw_count, new_raw_count));
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 8ac7a03ae4e9..9fa94b6e4e74 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2724,12 +2724,12 @@ static u64 intel_update_topdown_event(struct perf_event *event, int metric_end,
 
 	if (!val) {
 		/* read Fixed counter 3 */
-		rdpmc((3 | INTEL_PMC_FIXED_RDPMC_BASE), slots);
+		slots = rdpmc(3 | INTEL_PMC_FIXED_RDPMC_BASE);
 		if (!slots)
 			return 0;
 
 		/* read PERF_METRICS */
-		rdpmc(INTEL_PMC_FIXED_RDPMC_METRICS, metrics);
+		metrics = rdpmc(INTEL_PMC_FIXED_RDPMC_METRICS);
 	} else {
 		slots = val[0];
 		metrics = val[1];
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index be05e93b48e7..a093cb485278 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2274,7 +2274,7 @@ intel_pmu_save_and_restart_reload(struct perf_event *event, int count)
 	WARN_ON(this_cpu_read(cpu_hw_events.enabled));
 
 	prev_raw_count = local64_read(&hwc->prev_count);
-	rdpmc(hwc->event_base_rdpmc, new_raw_count);
+	new_raw_count = rdpmc(hwc->event_base_rdpmc);
 	local64_set(&hwc->prev_count, new_raw_count);
 
 	/*
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index ae96d35e0621..73d44081e597 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -234,7 +234,10 @@ static inline int rdmsrq_safe(u32 msr, u64 *p)
 	return err;
 }
 
-#define rdpmc(counter, val) ((val) = native_read_pmc(counter))
+static __always_inline u64 rdpmc(int counter)
+{
+	return native_read_pmc(counter);
+}
 
 #endif	/* !CONFIG_PARAVIRT_XXL */
 
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index faa0713553b1..f272c4bd3d5b 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -239,13 +239,11 @@ static inline int rdmsrq_safe(unsigned msr, u64 *p)
 	return err;
 }
 
-static inline u64 paravirt_read_pmc(int counter)
+static __always_inline u64 rdpmc(int counter)
 {
 	return PVOP_CALL1(u64, cpu.read_pmc, counter);
 }
 
-#define rdpmc(counter, val) ((val) = paravirt_read_pmc(counter))
-
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
 	PVOP_VCALL2(cpu.alloc_ldt, ldt, entries);
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 15ff62d83bd8..61d762555a79 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -1019,8 +1019,8 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * used in L1 cache, second to capture accurate value that does not
 	 * include cache misses incurred because of instruction loads.
 	 */
-	rdpmc(hit_pmcnum, hits_before);
-	rdpmc(miss_pmcnum, miss_before);
+	hits_before = rdpmc(hit_pmcnum);
+	miss_before = rdpmc(miss_pmcnum);
 	/*
 	 * From SDM: Performing back-to-back fast reads are not guaranteed
 	 * to be monotonic.
@@ -1028,8 +1028,8 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * before proceeding.
 	 */
 	rmb();
-	rdpmc(hit_pmcnum, hits_before);
-	rdpmc(miss_pmcnum, miss_before);
+	hits_before = rdpmc(hit_pmcnum);
+	miss_before = rdpmc(miss_pmcnum);
 	/*
 	 * Use LFENCE to ensure all previous instructions are retired
 	 * before proceeding.
@@ -1051,8 +1051,8 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * before proceeding.
 	 */
 	rmb();
-	rdpmc(hit_pmcnum, hits_after);
-	rdpmc(miss_pmcnum, miss_after);
+	hits_after = rdpmc(hit_pmcnum);
+	miss_after = rdpmc(miss_pmcnum);
 	/*
 	 * Use LFENCE to ensure all previous instructions are retired
 	 * before proceeding.
-- 
2.49.0


