Return-Path: <kvm+bounces-43773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C34BAA96171
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70D4917BBD7
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBDD2641CA;
	Tue, 22 Apr 2025 08:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="QGVnEjv8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4278B25D543;
	Tue, 22 Apr 2025 08:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310235; cv=none; b=dEr0Yp4CDzGpEXPoCaKNsdwhJG54RoaUuQ4/2NR7MOSDJmnvfw44sKMuMoRv4Gtf2asSHuz9kc/X58ArKO4SKhVgZ3OkMoVke4kll/GmhbjrDT/WsaXepzoBzsVIlJLNo3mfCCJGfcCIA2rua/4E4zEkDECGc1/14LFNL41dVaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310235; c=relaxed/simple;
	bh=Yk8n5o8WrJPKVqHSS/f9xG7muqahhiwGXkKCAe3no2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KioT5LZFhlpl9iHGZN31xE15lAYeiFoJ4aKcFSb7hk7DUGRzrpqnf3z7WPDzMrGPtoKtQYsXU12bElFnYAOGKaps9DkB/j6nTyi5ySM9R5CI5Q/ZRM9NbcDkj54eRrvUFyZnJ7K5Lwyx5moGchLTF1eOv8aeSjBocydlviBweVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=QGVnEjv8; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9I1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:29 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9I1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310150;
	bh=LVsPA2fgI6zP2WHSw0Nia0LCB15Xp7S+WVy/cleUJE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGVnEjv8tkGkgZOr/+y8tNZXRRi8XZB8ZUa+hfPMwgCsh/bvO2xAJc9VhI65ltj5f
	 LMenRE/fk3S5bW+6vEW/9EjVTjmw+65DjmMvRnz6VuJvvPndtokirGhHIMxOWUzT2M
	 bIUKmTb6xJsOQYxjwZVpD51rGRaiashhG0EWnYIoNFDkiI2ospc66RIjCIqRJWJ/CP
	 +fpEFOvt1EWqbNyzTmd3AOW9kLnosooHZzpFKsuIPLbiVSdFUwzHvJkSu7shtN70qV
	 rM9/AEtTfOcxs3bRd6Mxjf9DlDoUk5oHlzv2vYsxQwfHSorx8cOLau0HjwAXgZ8ds3
	 mK4Mot9OoKckQ==
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
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 04/34] x86/msr: Convert rdpmcq() into a function
Date: Tue, 22 Apr 2025 01:21:45 -0700
Message-ID: <20250422082216.1954310-5-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
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
index b9933ab3116c..f2601c662783 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -152,7 +152,7 @@ static void amd_uncore_read(struct perf_event *event)
 	if (hwc->event_base_rdpmc < 0)
 		rdmsrq(hwc->event_base, new);
 	else
-		rdpmcq(hwc->event_base_rdpmc, new);
+		new = rdpmcq(hwc->event_base_rdpmc);
 
 	local64_set(&hwc->prev_count, new);
 	delta = (new << COUNTER_SHIFT) - (prev << COUNTER_SHIFT);
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 3da1f0b3446c..0a3939b9965e 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -139,7 +139,7 @@ u64 x86_perf_event_update(struct perf_event *event)
 	 */
 	prev_raw_count = local64_read(&hwc->prev_count);
 	do {
-		rdpmcq(hwc->event_base_rdpmc, new_raw_count);
+		new_raw_count = rdpmcq(hwc->event_base_rdpmc);
 	} while (!local64_try_cmpxchg(&hwc->prev_count,
 				      &prev_raw_count, new_raw_count));
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index ba623e6cae1b..4370d0d86013 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2739,12 +2739,12 @@ static u64 intel_update_topdown_event(struct perf_event *event, int metric_end,
 
 	if (!val) {
 		/* read Fixed counter 3 */
-		rdpmcq((3 | INTEL_PMC_FIXED_RDPMC_BASE), slots);
+		slots = rdpmcq(3 | INTEL_PMC_FIXED_RDPMC_BASE);
 		if (!slots)
 			return 0;
 
 		/* read PERF_METRICS */
-		rdpmcq(INTEL_PMC_FIXED_RDPMC_METRICS, metrics);
+		metrics = rdpmcq(INTEL_PMC_FIXED_RDPMC_METRICS);
 	} else {
 		slots = val[0];
 		metrics = val[1];
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 4074567219de..845439fd9c03 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2279,7 +2279,7 @@ intel_pmu_save_and_restart_reload(struct perf_event *event, int count)
 	WARN_ON(this_cpu_read(cpu_hw_events.enabled));
 
 	prev_raw_count = local64_read(&hwc->prev_count);
-	rdpmcq(hwc->event_base_rdpmc, new_raw_count);
+	new_raw_count = rdpmcq(hwc->event_base_rdpmc);
 	local64_set(&hwc->prev_count, new_raw_count);
 
 	/*
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index ed32637b1df6..01dc8e61ef97 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -234,7 +234,10 @@ static inline int rdmsrq_safe(u32 msr, u64 *p)
 	return err;
 }
 
-#define rdpmcq(counter, val) ((val) = native_read_pmc(counter))
+static __always_inline u64 rdpmcq(int counter)
+{
+	return native_read_pmc(counter);
+}
 
 #endif	/* !CONFIG_PARAVIRT_XXL */
 
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 63ca099f8368..590824916394 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -239,13 +239,11 @@ static inline int rdmsrq_safe(unsigned msr, u64 *p)
 	return err;
 }
 
-static inline u64 paravirt_read_pmc(int counter)
+static __always_inline u64 rdpmcq(int counter)
 {
 	return PVOP_CALL1(u64, cpu.read_pmc, counter);
 }
 
-#define rdpmcq(counter, val) ((val) = paravirt_read_pmc(counter))
-
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
 	PVOP_VCALL2(cpu.alloc_ldt, ldt, entries);
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index a5e21f44b0ca..276ffab194f6 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -1019,8 +1019,8 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * used in L1 cache, second to capture accurate value that does not
 	 * include cache misses incurred because of instruction loads.
 	 */
-	rdpmcq(hit_pmcnum, hits_before);
-	rdpmcq(miss_pmcnum, miss_before);
+	hits_before = rdpmcq(hit_pmcnum);
+	miss_before = rdpmcq(miss_pmcnum);
 	/*
 	 * From SDM: Performing back-to-back fast reads are not guaranteed
 	 * to be monotonic.
@@ -1028,8 +1028,8 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * before proceeding.
 	 */
 	rmb();
-	rdpmcq(hit_pmcnum, hits_before);
-	rdpmcq(miss_pmcnum, miss_before);
+	hits_before = rdpmcq(hit_pmcnum);
+	miss_before = rdpmcq(miss_pmcnum);
 	/*
 	 * Use LFENCE to ensure all previous instructions are retired
 	 * before proceeding.
@@ -1051,8 +1051,8 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * before proceeding.
 	 */
 	rmb();
-	rdpmcq(hit_pmcnum, hits_after);
-	rdpmcq(miss_pmcnum, miss_after);
+	hits_after = rdpmcq(hit_pmcnum);
+	miss_after = rdpmcq(miss_pmcnum);
 	/*
 	 * Use LFENCE to ensure all previous instructions are retired
 	 * before proceeding.
-- 
2.49.0


