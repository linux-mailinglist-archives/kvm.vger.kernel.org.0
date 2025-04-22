Return-Path: <kvm+bounces-43769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BAA49A96163
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E3A37A876B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5761525E473;
	Tue, 22 Apr 2025 08:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WGSG51uv"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9A3255E26;
	Tue, 22 Apr 2025 08:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310232; cv=none; b=PgQXDMZ66kmSmKbY32OAvZkIsPJJapacmHG1sLtpOK85wNtbGmRH7gMTqrDpLRz3WUf9KZQGy/ZaxwwOb0Xlu4e7JT7fymm3C2cIoMKPCYHJDwm3XKahcV/HoXWk+guIr8zVjuqxBn6AV17CSGxtTX1Cx3Ur6svLMwUARBQfirk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310232; c=relaxed/simple;
	bh=CcLd+fyFBOuhMxRw0SH6VUSOHBlV3FVclavbkT7M1eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAFFAbeZeFXoSczpUcJmC4GjA0RY2Ttj85FARgYd+u0m2XT5xA4XfCZZjZHV/reM7kr9pqaPUgXHtiOAL5gYUqB1aFXmh6M041YVHTk3rORdbkVm0xlOL7Vq/FMgW9MPOxTM8LNPEdTqXVFHLYzHB3OZPlvdmLFVtLO4gLdqlZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WGSG51uv; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9H1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9H1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310148;
	bh=mNpHziw81ylHHpqc1SxmLLn7DCCjcGwbF9kQxURfyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGSG51uvub6A5rzsml4txgFzoajXAdfoda1G/nE+NTRoBDlL4LvMcYXj0gdkcO1F9
	 wJvAWM4IlePONZVgX8QjJekCwYCll4jk6VQSBCwxg/rMvXk4+4zIMsDQ4DsAjs3CMb
	 qDbJ6d65Rpd2r8+RcMPy69MtcbHwLb94ttXoRRlz5IirDQCIZyegbO7WOyKkFmYoYY
	 CIoYXaTNvuhjXhq5m59Ar/2CyeoMVEGV2uOFr4IdQ9GbjLEEaJUr4u8kdh7e15iJmd
	 eey5z4DOLmG8haxBJOdUoul5SiKAtTEpWcXtiCuz0PvhJ0r8uyuGOBYquz4X4VfGOg
	 V/BPsaCXOjQpg==
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
Subject: [RFC PATCH v2 03/34] x86/msr: Rename rdpmcl() to rdpmcq()
Date: Tue, 22 Apr 2025 01:21:44 -0700
Message-ID: <20250422082216.1954310-4-xin@zytor.com>
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
 arch/x86/include/asm/msr.h                |  2 +-
 arch/x86/include/asm/paravirt.h           |  2 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 12 ++++++------
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index f231e1078e51..b9933ab3116c 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -152,7 +152,7 @@ static void amd_uncore_read(struct perf_event *event)
 	if (hwc->event_base_rdpmc < 0)
 		rdmsrq(hwc->event_base, new);
 	else
-		rdpmcl(hwc->event_base_rdpmc, new);
+		rdpmcq(hwc->event_base_rdpmc, new);
 
 	local64_set(&hwc->prev_count, new);
 	delta = (new << COUNTER_SHIFT) - (prev << COUNTER_SHIFT);
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index d390472f6c10..3da1f0b3446c 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -139,7 +139,7 @@ u64 x86_perf_event_update(struct perf_event *event)
 	 */
 	prev_raw_count = local64_read(&hwc->prev_count);
 	do {
-		rdpmcl(hwc->event_base_rdpmc, new_raw_count);
+		rdpmcq(hwc->event_base_rdpmc, new_raw_count);
 	} while (!local64_try_cmpxchg(&hwc->prev_count,
 				      &prev_raw_count, new_raw_count));
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 1aed31514869..ba623e6cae1b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2739,12 +2739,12 @@ static u64 intel_update_topdown_event(struct perf_event *event, int metric_end,
 
 	if (!val) {
 		/* read Fixed counter 3 */
-		rdpmcl((3 | INTEL_PMC_FIXED_RDPMC_BASE), slots);
+		rdpmcq((3 | INTEL_PMC_FIXED_RDPMC_BASE), slots);
 		if (!slots)
 			return 0;
 
 		/* read PERF_METRICS */
-		rdpmcl(INTEL_PMC_FIXED_RDPMC_METRICS, metrics);
+		rdpmcq(INTEL_PMC_FIXED_RDPMC_METRICS, metrics);
 	} else {
 		slots = val[0];
 		metrics = val[1];
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index f33395c2e925..4074567219de 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2279,7 +2279,7 @@ intel_pmu_save_and_restart_reload(struct perf_event *event, int count)
 	WARN_ON(this_cpu_read(cpu_hw_events.enabled));
 
 	prev_raw_count = local64_read(&hwc->prev_count);
-	rdpmcl(hwc->event_base_rdpmc, new_raw_count);
+	rdpmcq(hwc->event_base_rdpmc, new_raw_count);
 	local64_set(&hwc->prev_count, new_raw_count);
 
 	/*
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index e05466e486fc..ed32637b1df6 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -234,7 +234,7 @@ static inline int rdmsrq_safe(u32 msr, u64 *p)
 	return err;
 }
 
-#define rdpmcl(counter, val) ((val) = native_read_pmc(counter))
+#define rdpmcq(counter, val) ((val) = native_read_pmc(counter))
 
 #endif	/* !CONFIG_PARAVIRT_XXL */
 
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index c4dedb984735..63ca099f8368 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -244,7 +244,7 @@ static inline u64 paravirt_read_pmc(int counter)
 	return PVOP_CALL1(u64, cpu.read_pmc, counter);
 }
 
-#define rdpmcl(counter, val) ((val) = paravirt_read_pmc(counter))
+#define rdpmcq(counter, val) ((val) = paravirt_read_pmc(counter))
 
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 26c354bdea07..a5e21f44b0ca 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -1019,8 +1019,8 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * used in L1 cache, second to capture accurate value that does not
 	 * include cache misses incurred because of instruction loads.
 	 */
-	rdpmcl(hit_pmcnum, hits_before);
-	rdpmcl(miss_pmcnum, miss_before);
+	rdpmcq(hit_pmcnum, hits_before);
+	rdpmcq(miss_pmcnum, miss_before);
 	/*
 	 * From SDM: Performing back-to-back fast reads are not guaranteed
 	 * to be monotonic.
@@ -1028,8 +1028,8 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * before proceeding.
 	 */
 	rmb();
-	rdpmcl(hit_pmcnum, hits_before);
-	rdpmcl(miss_pmcnum, miss_before);
+	rdpmcq(hit_pmcnum, hits_before);
+	rdpmcq(miss_pmcnum, miss_before);
 	/*
 	 * Use LFENCE to ensure all previous instructions are retired
 	 * before proceeding.
@@ -1051,8 +1051,8 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	 * before proceeding.
 	 */
 	rmb();
-	rdpmcl(hit_pmcnum, hits_after);
-	rdpmcl(miss_pmcnum, miss_after);
+	rdpmcq(hit_pmcnum, hits_after);
+	rdpmcq(miss_pmcnum, miss_after);
 	/*
 	 * Use LFENCE to ensure all previous instructions are retired
 	 * before proceeding.
-- 
2.49.0


