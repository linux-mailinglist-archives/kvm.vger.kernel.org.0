Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FB26170F1
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiKBWwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbiKBWwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:52:02 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B8BDE86
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i8-20020a170902c94800b0018712ccd6bbso198653pla.1
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EKgR/WI5I/lNDglANE7E3hIeD9RjZ62Qj1FSqYbVxSY=;
        b=S3FaF8ekdQ+7bnUe3bSSfg1ifBCyBbfKPgupzpELJJi+t6VciWn+WK5Xv2D/c1kn0E
         ze7nfyMw8dskHRyVzA7mkpf5ncCIrov2eXzHaFWayAQjoiIc9R2UmyruPuOxU7Mrlkg1
         zvFHf7iUwcwZ+/Q88RDlvG0j1weYeCGqYbyIaNjkyqJ1q8fxsjg0E7ba7ulMFgjmg4si
         KWtetwVgRoijboR09X0GL2HnmrY4grmKOJkDAza1N4yyrMo9RFdSW2uXxGp37Pezg+Yb
         iF/ho8kZkI/gr//1RT/qhwWLOEuXvJskzkP36J+LuR0CmKAhwo9TEBct2FsnIKf7TNyx
         4o9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EKgR/WI5I/lNDglANE7E3hIeD9RjZ62Qj1FSqYbVxSY=;
        b=Yjsa4VDVxUJPT4KgSIAWgfYX5FnNISCDKWJ8CQ9J9wgrdd4O7xv0P8k+dcVBvtM5qB
         Eh56t6cJSbbPiu0362i48ivtCyvFaECRYA4TA+GehANnsb5PNDa568uqHMyKpcs5iADk
         wGUchIl9AYkkY5m3dw4WkJtNHKn+QLx2NehZBHJcWt00uEZmPiQkJ6OAu9fW5X5xJvzn
         5mo6fPLMfJz5z4RtNYV3w6Z6bGgBWt7UVkU1p7EC7ZcwjFILO/xlD90hgEeGyzuVWuao
         l59Mhk9ZqBDA+5f8DveiiQPiFwRVEkCZ10M8bsDxknJl7z5gzKBxKnr750ua5r9ZEHNd
         I7Bw==
X-Gm-Message-State: ACrzQf0/mM37xi1NKaYp2Jbs2sgUQY4Ml0c2yXy5BzTiW4DZkhaii6q2
        UcplCkd0YWNc3aLhGPWIHP5Vzeh7J30=
X-Google-Smtp-Source: AMsMyM7jV5rWelU12LiuJuNGT3lHn1okxO2iTm2gyXzr4vB1uGvNvG9C7Oi8g27y1UTksFlpxJpE+y0YZjY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ce43:0:b0:45b:d6ed:6c2 with SMTP id
 r3-20020a63ce43000000b0045bd6ed06c2mr23644743pgi.406.1667429503783; Wed, 02
 Nov 2022 15:51:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:00 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-18-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 17/27] x86/pmu: Drop wrappers that just
 passthrough pmu_caps fields
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop wrappers that are and always will be pure passthroughs of pmu_caps
fields, e.g. the number of fixed/general_purpose counters can always be
determined during PMU initialization and doesn't need runtime logic.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.h | 43 ++++--------------------------------
 x86/pmu.c     | 60 +++++++++++++++++++++------------------------------
 x86/pmu_lbr.c |  2 +-
 3 files changed, 30 insertions(+), 75 deletions(-)

diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index c7e9d3ae..f6abe1a6 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -48,44 +48,14 @@ extern struct pmu_caps pmu;
 
 void pmu_init(void);
 
-static inline u8 pmu_version(void)
-{
-	return pmu.version;
-}
-
 static inline bool this_cpu_has_pmu(void)
 {
-	return !!pmu_version();
+	return !!pmu.version;
 }
 
 static inline bool this_cpu_has_perf_global_ctrl(void)
 {
-	return pmu_version() > 1;
-}
-
-static inline u8 pmu_nr_gp_counters(void)
-{
-	return pmu.nr_gp_counters;
-}
-
-static inline u8 pmu_gp_counter_width(void)
-{
-	return pmu.gp_counter_width;
-}
-
-static inline u8 pmu_gp_counter_mask_length(void)
-{
-	return pmu.gp_counter_mask_length;
-}
-
-static inline u8 pmu_nr_fixed_counters(void)
-{
-	return pmu.nr_fixed_counters;
-}
-
-static inline u8 pmu_fixed_counter_width(void)
-{
-	return pmu.fixed_counter_width;
+	return pmu.version > 1;
 }
 
 static inline bool pmu_gp_counter_is_available(int i)
@@ -93,19 +63,14 @@ static inline bool pmu_gp_counter_is_available(int i)
 	return pmu.gp_counter_available & BIT(i);
 }
 
-static inline u64 this_cpu_perf_capabilities(void)
-{
-	return pmu.perf_cap;
-}
-
 static inline u64 pmu_lbr_version(void)
 {
-	return this_cpu_perf_capabilities() & PMU_CAP_LBR_FMT;
+	return pmu.perf_cap & PMU_CAP_LBR_FMT;
 }
 
 static inline bool pmu_has_full_writes(void)
 {
-	return this_cpu_perf_capabilities() & PMU_CAP_FW_WRITES;
+	return pmu.perf_cap & PMU_CAP_FW_WRITES;
 }
 
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu.c b/x86/pmu.c
index 627fd394..d13291fe 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -196,14 +196,13 @@ static bool verify_counter(pmu_counter_t *cnt)
 
 static void check_gp_counter(struct pmu_event *evt)
 {
-	int nr_gp_counters = pmu_nr_gp_counters();
 	pmu_counter_t cnt = {
 		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | evt->unit_sel,
 	};
 	int i;
 
-	for (i = 0; i < nr_gp_counters; i++, cnt.ctr++) {
+	for (i = 0; i < pmu.nr_gp_counters; i++, cnt.ctr++) {
 		measure_one(&cnt);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
 	}
@@ -223,13 +222,12 @@ static void check_gp_counters(void)
 
 static void check_fixed_counters(void)
 {
-	int nr_fixed_counters = pmu_nr_fixed_counters();
 	pmu_counter_t cnt = {
 		.config = EVNTSEL_OS | EVNTSEL_USR,
 	};
 	int i;
 
-	for (i = 0; i < nr_fixed_counters; i++) {
+	for (i = 0; i < pmu.nr_fixed_counters; i++) {
 		cnt.ctr = fixed_events[i].unit_sel;
 		measure_one(&cnt);
 		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d", i);
@@ -238,12 +236,10 @@ static void check_fixed_counters(void)
 
 static void check_counters_many(void)
 {
-	int nr_fixed_counters = pmu_nr_fixed_counters();
-	int nr_gp_counters = pmu_nr_gp_counters();
 	pmu_counter_t cnt[10];
 	int i, n;
 
-	for (i = 0, n = 0; n < nr_gp_counters; i++) {
+	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
 		if (!pmu_gp_counter_is_available(i))
 			continue;
 
@@ -252,7 +248,7 @@ static void check_counters_many(void)
 			gp_events[i % ARRAY_SIZE(gp_events)].unit_sel;
 		n++;
 	}
-	for (i = 0; i < nr_fixed_counters; i++) {
+	for (i = 0; i < pmu.nr_fixed_counters; i++) {
 		cnt[n].ctr = fixed_events[i].unit_sel;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
 		n++;
@@ -283,7 +279,6 @@ static uint64_t measure_for_overflow(pmu_counter_t *cnt)
 
 static void check_counter_overflow(void)
 {
-	int nr_gp_counters = pmu_nr_gp_counters();
 	uint64_t overflow_preset;
 	int i;
 	pmu_counter_t cnt = {
@@ -297,18 +292,18 @@ static void check_counter_overflow(void)
 
 	report_prefix_push("overflow");
 
-	for (i = 0; i < nr_gp_counters + 1; i++, cnt.ctr++) {
+	for (i = 0; i < pmu.nr_gp_counters + 1; i++, cnt.ctr++) {
 		uint64_t status;
 		int idx;
 
 		cnt.count = overflow_preset;
 		if (gp_counter_base == MSR_IA32_PMC0)
-			cnt.count &= (1ull << pmu_gp_counter_width()) - 1;
+			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
 
-		if (i == nr_gp_counters) {
+		if (i == pmu.nr_gp_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
 			cnt.count = measure_for_overflow(&cnt);
-			cnt.count &= (1ull << pmu_fixed_counter_width()) - 1;
+			cnt.count &= (1ull << pmu.fixed_counter_width) - 1;
 		}
 
 		if (i % 2)
@@ -354,17 +349,13 @@ static void do_rdpmc_fast(void *ptr)
 
 static void check_rdpmc(void)
 {
-	int fixed_counter_width = pmu_fixed_counter_width();
-	int nr_fixed_counters = pmu_nr_fixed_counters();
-	u8 gp_counter_width = pmu_gp_counter_width();
-	int nr_gp_counters = pmu_nr_gp_counters();
 	uint64_t val = 0xff0123456789ull;
 	bool exc;
 	int i;
 
 	report_prefix_push("rdpmc");
 
-	for (i = 0; i < nr_gp_counters; i++) {
+	for (i = 0; i < pmu.nr_gp_counters; i++) {
 		uint64_t x;
 		pmu_counter_t cnt = {
 			.ctr = gp_counter_base + i,
@@ -381,7 +372,7 @@ static void check_rdpmc(void)
 			x = (uint64_t)(int64_t)val;
 
 		/* Mask according to the number of supported bits */
-		x &= (1ull << gp_counter_width) - 1;
+		x &= (1ull << pmu.gp_counter_width) - 1;
 
 		wrmsr(gp_counter_base + i, val);
 		report(rdpmc(i) == x, "cntr-%d", i);
@@ -392,8 +383,8 @@ static void check_rdpmc(void)
 		else
 			report(cnt.count == (u32)val, "fast-%d", i);
 	}
-	for (i = 0; i < nr_fixed_counters; i++) {
-		uint64_t x = val & ((1ull << fixed_counter_width) - 1);
+	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+		uint64_t x = val & ((1ull << pmu.fixed_counter_width) - 1);
 		pmu_counter_t cnt = {
 			.ctr = MSR_CORE_PERF_FIXED_CTR0 + i,
 			.idx = i
@@ -437,7 +428,7 @@ static void check_running_counter_wrmsr(void)
 
 	count = -1;
 	if (gp_counter_base == MSR_IA32_PMC0)
-		count &= (1ull << pmu_gp_counter_width()) - 1;
+		count &= (1ull << pmu.gp_counter_width) - 1;
 
 	wrmsr(gp_counter_base, count);
 
@@ -541,15 +532,14 @@ static void check_gp_counters_write_width(void)
 {
 	u64 val_64 = 0xffffff0123456789ull;
 	u64 val_32 = val_64 & ((1ull << 32) - 1);
-	u64 val_max_width = val_64 & ((1ull << pmu_gp_counter_width()) - 1);
-	int nr_gp_counters = pmu_nr_gp_counters();
+	u64 val_max_width = val_64 & ((1ull << pmu.gp_counter_width) - 1);
 	int i;
 
 	/*
 	 * MSR_IA32_PERFCTRn supports 64-bit writes,
 	 * but only the lowest 32 bits are valid.
 	 */
-	for (i = 0; i < nr_gp_counters; i++) {
+	for (i = 0; i < pmu.nr_gp_counters; i++) {
 		wrmsr(MSR_IA32_PERFCTR0 + i, val_32);
 		assert(rdmsr(MSR_IA32_PERFCTR0 + i) == val_32);
 		assert(rdmsr(MSR_IA32_PMC0 + i) == val_32);
@@ -567,7 +557,7 @@ static void check_gp_counters_write_width(void)
 	 * MSR_IA32_PMCn supports writing values up to GP counter width,
 	 * and only the lowest bits of GP counter width are valid.
 	 */
-	for (i = 0; i < nr_gp_counters; i++) {
+	for (i = 0; i < pmu.nr_gp_counters; i++) {
 		wrmsr(MSR_IA32_PMC0 + i, val_32);
 		assert(rdmsr(MSR_IA32_PMC0 + i) == val_32);
 		assert(rdmsr(MSR_IA32_PERFCTR0 + i) == val_32);
@@ -597,7 +587,7 @@ static void set_ref_cycle_expectations(void)
 	uint64_t t0, t1, t2, t3;
 
 	/* Bit 2 enumerates the availability of reference cycles events. */
-	if (!pmu_nr_gp_counters() || !pmu_gp_counter_is_available(2))
+	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
 		return;
 
 	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -646,24 +636,24 @@ int main(int ac, char **av)
 
 	check_invalid_rdpmc_gp();
 
-	if (!pmu_version()) {
+	if (!pmu.version) {
 		report_skip("No Intel Arch PMU is detected!");
 		return report_summary();
 	}
 
-	if (pmu_version() == 1) {
+	if (pmu.version == 1) {
 		report_skip("PMU version 1 is not supported.");
 		return report_summary();
 	}
 
 	set_ref_cycle_expectations();
 
-	printf("PMU version:         %d\n", pmu_version());
-	printf("GP counters:         %d\n", pmu_nr_gp_counters());
-	printf("GP counter width:    %d\n", pmu_gp_counter_width());
-	printf("Mask length:         %d\n", pmu_gp_counter_mask_length());
-	printf("Fixed counters:      %d\n", pmu_nr_fixed_counters());
-	printf("Fixed counter width: %d\n", pmu_fixed_counter_width());
+	printf("PMU version:         %d\n", pmu.version);
+	printf("GP counters:         %d\n", pmu.nr_gp_counters);
+	printf("GP counter width:    %d\n", pmu.gp_counter_width);
+	printf("Mask length:         %d\n", pmu.gp_counter_mask_length);
+	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
+	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
 	apic_write(APIC_LVTPC, PMI_VECTOR);
 
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index d0135520..36c9a8fa 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -67,7 +67,7 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
-	printf("PMU version:		 %d\n", pmu_version());
+	printf("PMU version:		 %d\n", pmu.version);
 	printf("LBR version:		 %ld\n", pmu_lbr_version());
 
 	/* Look for LBR from and to MSRs */
-- 
2.38.1.431.g37b22c650d-goog

