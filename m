Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5604E6170EC
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiKBWwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiKBWvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B624FDEBF
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k7-20020a256f07000000b006cbcc030bc8so265457ybc.18
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x99poFCmv2sByJACqRFbdVWvdIL+1KnQUwKTFtKMNaw=;
        b=BxVcKYwiRZq46qCfLoGDId6r40tmwDHUphXFVzlK1c/YV4yhI9FRz5Hoad+OyWrg8d
         AWO8wo+hRmsbOkUnyJncPdyszwqBG2HseA7B0j5dHAhYX0C2Xfb/LsSFd5qmG7sjxZM8
         9+d9ZizslSNr9SMgH3NP3AED67D4iyD/32NR1YTKurpzN92bunn0GKPw+9eTQ6XRKtc2
         0YVaNBDbkwTbGQLkJE80xFuQIVOYRJlqWt5JbEwuxi/ws8eKmIKQUzn/bpZ2+I2cAX5h
         /3SN/VIoQhgbbnqzPzEs/gGzaDflbxrBFY8W7/G8+V8zGVKIgUpFt4ApWpDyU+Ku9erw
         kwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x99poFCmv2sByJACqRFbdVWvdIL+1KnQUwKTFtKMNaw=;
        b=cQcMNFe3kIEIr45zgYQbTFX7l1goYvS9WEn/tammI8Nqa4pZflFsYBUVTa324WEQVN
         68E5AH5JZOcio139UdXxDGZj0ig0ULnq83D9H7NcW6D6TFpb0YfMH0LqKqtY26z+m89o
         s1g7SbXV4uRv4bV2/0fqURX8G8o7jDZT8vlrOVGvq7BbcKn+mKhjdw4KQNUfTuhblpO0
         Vg/ZPvKzGr6NeKBy/YUkgAQ0qoudvJ0fxZ/TxbD9yZvvNP5PwlIHh2ybF/q2iYk3X1yd
         T3SS3KCEH0iwzckwwgaHwVPUKdw7X/v1h4O5uDt/KlGZby88ohrsCMwTRceEBLy8ocz1
         u3gg==
X-Gm-Message-State: ACrzQf0Lx0uLMuJwkggXkPn2Ritn0bUtdvJsrv3F7Gn8ZesmOYSY6rv0
        T99LG3XAKQD/PpVQI0Z+j3ssm+qLydU=
X-Google-Smtp-Source: AMsMyM7ebzMnq1Q51FsZdRktx9aMA/N1TGFjn3pZacfddA02IPm818ZAcP3idbh38XPSJ9AEkOl8xYxeIro=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c64e:0:b0:6ca:20bd:5fff with SMTP id
 k75-20020a25c64e000000b006ca20bd5fffmr25414746ybf.269.1667429505531; Wed, 02
 Nov 2022 15:51:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:01 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-19-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 18/27] x86/pmu: Track GP counter and event
 select base MSRs in pmu_caps
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

From: Like Xu <likexu@tencent.com>

Snapshot the base MSRs for GP counters and event selects during pmu_init()
so that tests don't need to manually compute the bases.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: rename helpers to look more like macros, drop wrmsr wrappers]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c |  2 ++
 lib/x86/pmu.h | 18 +++++++++++++++
 x86/pmu.c     | 63 ++++++++++++++++++++++++++-------------------------
 3 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 9c1034aa..c73f802a 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -22,4 +22,6 @@ void pmu_init(void)
 
 	if (this_cpu_has(X86_FEATURE_PDCM))
 		pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+	pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
+	pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
 }
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index f6abe1a6..c98c583c 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -41,6 +41,9 @@ struct pmu_caps {
 	u8 gp_counter_width;
 	u8 gp_counter_mask_length;
 	u32 gp_counter_available;
+	u32 msr_gp_counter_base;
+	u32 msr_gp_event_select_base;
+
 	u64 perf_cap;
 };
 
@@ -48,6 +51,16 @@ extern struct pmu_caps pmu;
 
 void pmu_init(void);
 
+static inline u32 MSR_GP_COUNTERx(unsigned int i)
+{
+	return pmu.msr_gp_counter_base + i;
+}
+
+static inline u32 MSR_GP_EVENT_SELECTx(unsigned int i)
+{
+	return pmu.msr_gp_event_select_base + i;
+}
+
 static inline bool this_cpu_has_pmu(void)
 {
 	return !!pmu.version;
@@ -73,4 +86,9 @@ static inline bool pmu_has_full_writes(void)
 	return pmu.perf_cap & PMU_CAP_FW_WRITES;
 }
 
+static inline bool pmu_use_full_writes(void)
+{
+	return pmu.msr_gp_counter_base == MSR_IA32_PMC0;
+}
+
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu.c b/x86/pmu.c
index d13291fe..d66786be 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -44,8 +44,6 @@ struct pmu_event {
 	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
-static u64 gp_counter_base = MSR_IA32_PERFCTR0;
-
 char *buf;
 
 static inline void loop(void)
@@ -84,7 +82,7 @@ static bool is_gp(pmu_counter_t *evt)
 
 static int event_to_global_idx(pmu_counter_t *cnt)
 {
-	return cnt->ctr - (is_gp(cnt) ? gp_counter_base :
+	return cnt->ctr - (is_gp(cnt) ? pmu.msr_gp_counter_base :
 		(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
 }
 
@@ -120,10 +118,10 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
 {
     evt->count = count;
     wrmsr(evt->ctr, evt->count);
-    if (is_gp(evt))
-	    wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
-			    evt->config | EVNTSEL_EN);
-    else {
+    if (is_gp(evt)) {
+	    wrmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
+		  evt->config | EVNTSEL_EN);
+    } else {
 	    uint32_t ctrl = rdmsr(MSR_CORE_PERF_FIXED_CTR_CTRL);
 	    int shift = (evt->ctr - MSR_CORE_PERF_FIXED_CTR0) * 4;
 	    uint32_t usrospmi = 0;
@@ -149,10 +147,10 @@ static void start_event(pmu_counter_t *evt)
 static void stop_event(pmu_counter_t *evt)
 {
 	global_disable(evt);
-	if (is_gp(evt))
-		wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
-				evt->config & ~EVNTSEL_EN);
-	else {
+	if (is_gp(evt)) {
+		wrmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
+		      evt->config & ~EVNTSEL_EN);
+	} else {
 		uint32_t ctrl = rdmsr(MSR_CORE_PERF_FIXED_CTR_CTRL);
 		int shift = (evt->ctr - MSR_CORE_PERF_FIXED_CTR0) * 4;
 		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl & ~(0xf << shift));
@@ -197,12 +195,12 @@ static bool verify_counter(pmu_counter_t *cnt)
 static void check_gp_counter(struct pmu_event *evt)
 {
 	pmu_counter_t cnt = {
-		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | evt->unit_sel,
 	};
 	int i;
 
-	for (i = 0; i < pmu.nr_gp_counters; i++, cnt.ctr++) {
+	for (i = 0; i < pmu.nr_gp_counters; i++) {
+		cnt.ctr = MSR_GP_COUNTERx(i);
 		measure_one(&cnt);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
 	}
@@ -243,7 +241,7 @@ static void check_counters_many(void)
 		if (!pmu_gp_counter_is_available(i))
 			continue;
 
-		cnt[n].ctr = gp_counter_base + n;
+		cnt[n].ctr = MSR_GP_COUNTERx(n);
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
 			gp_events[i % ARRAY_SIZE(gp_events)].unit_sel;
 		n++;
@@ -282,7 +280,7 @@ static void check_counter_overflow(void)
 	uint64_t overflow_preset;
 	int i;
 	pmu_counter_t cnt = {
-		.ctr = gp_counter_base,
+		.ctr = MSR_GP_COUNTERx(0),
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 	};
 	overflow_preset = measure_for_overflow(&cnt);
@@ -292,18 +290,20 @@ static void check_counter_overflow(void)
 
 	report_prefix_push("overflow");
 
-	for (i = 0; i < pmu.nr_gp_counters + 1; i++, cnt.ctr++) {
+	for (i = 0; i < pmu.nr_gp_counters + 1; i++) {
 		uint64_t status;
 		int idx;
 
 		cnt.count = overflow_preset;
-		if (gp_counter_base == MSR_IA32_PMC0)
+		if (pmu_use_full_writes())
 			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
 
 		if (i == pmu.nr_gp_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
 			cnt.count = measure_for_overflow(&cnt);
-			cnt.count &= (1ull << pmu.fixed_counter_width) - 1;
+			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
+		} else {
+			cnt.ctr = MSR_GP_COUNTERx(i);
 		}
 
 		if (i % 2)
@@ -327,7 +327,7 @@ static void check_counter_overflow(void)
 static void check_gp_counter_cmask(void)
 {
 	pmu_counter_t cnt = {
-		.ctr = gp_counter_base,
+		.ctr = MSR_GP_COUNTERx(0),
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
@@ -358,7 +358,7 @@ static void check_rdpmc(void)
 	for (i = 0; i < pmu.nr_gp_counters; i++) {
 		uint64_t x;
 		pmu_counter_t cnt = {
-			.ctr = gp_counter_base + i,
+			.ctr = MSR_GP_COUNTERx(i),
 			.idx = i
 		};
 
@@ -366,7 +366,7 @@ static void check_rdpmc(void)
 	         * Without full-width writes, only the low 32 bits are writable,
 	         * and the value is sign-extended.
 	         */
-		if (gp_counter_base == MSR_IA32_PERFCTR0)
+		if (pmu.msr_gp_counter_base == MSR_IA32_PERFCTR0)
 			x = (uint64_t)(int64_t)(int32_t)val;
 		else
 			x = (uint64_t)(int64_t)val;
@@ -374,7 +374,7 @@ static void check_rdpmc(void)
 		/* Mask according to the number of supported bits */
 		x &= (1ull << pmu.gp_counter_width) - 1;
 
-		wrmsr(gp_counter_base + i, val);
+		wrmsr(MSR_GP_COUNTERx(i), val);
 		report(rdpmc(i) == x, "cntr-%d", i);
 
 		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
@@ -408,7 +408,7 @@ static void check_running_counter_wrmsr(void)
 	uint64_t status;
 	uint64_t count;
 	pmu_counter_t evt = {
-		.ctr = gp_counter_base,
+		.ctr = MSR_GP_COUNTERx(0),
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
 	};
 
@@ -416,7 +416,7 @@ static void check_running_counter_wrmsr(void)
 
 	start_event(&evt);
 	loop();
-	wrmsr(gp_counter_base, 0);
+	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
 	report(evt.count < gp_events[1].min, "cntr");
 
@@ -427,10 +427,10 @@ static void check_running_counter_wrmsr(void)
 	start_event(&evt);
 
 	count = -1;
-	if (gp_counter_base == MSR_IA32_PMC0)
+	if (pmu_use_full_writes())
 		count &= (1ull << pmu.gp_counter_width) - 1;
 
-	wrmsr(gp_counter_base, count);
+	wrmsr(MSR_GP_COUNTERx(0), count);
 
 	loop();
 	stop_event(&evt);
@@ -444,12 +444,12 @@ static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
 	pmu_counter_t brnch_cnt = {
-		.ctr = MSR_IA32_PERFCTR0,
+		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[5].unit_sel,
 	};
 	pmu_counter_t instr_cnt = {
-		.ctr = MSR_IA32_PERFCTR0 + 1,
+		.ctr = MSR_GP_COUNTERx(1),
 		/* instructions */
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
 	};
@@ -463,8 +463,8 @@ static void check_emulated_instr(void)
 
 	brnch_start = -EXPECTED_BRNCH;
 	instr_start = -EXPECTED_INSTR;
-	wrmsr(MSR_IA32_PERFCTR0, brnch_start);
-	wrmsr(MSR_IA32_PERFCTR0 + 1, instr_start);
+	wrmsr(MSR_GP_COUNTERx(0), brnch_start);
+	wrmsr(MSR_GP_COUNTERx(1), instr_start);
 	// KVM_FEP is a magic prefix that forces emulation so
 	// 'KVM_FEP "jne label\n"' just counts as a single instruction.
 	asm volatile(
@@ -660,7 +660,8 @@ int main(int ac, char **av)
 	check_counters();
 
 	if (pmu_has_full_writes()) {
-		gp_counter_base = MSR_IA32_PMC0;
+		pmu.msr_gp_counter_base = MSR_IA32_PMC0;
+
 		report_prefix_push("full-width writes");
 		check_counters();
 		check_gp_counters_write_width();
-- 
2.38.1.431.g37b22c650d-goog

