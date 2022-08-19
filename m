Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66757599A8B
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348740AbiHSLKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348731AbiHSLKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:20 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE83F4936
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s31-20020a17090a2f2200b001faaf9d92easo7208469pjd.3
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=KabTlyKzWR46PecaMYP6VWE+yqk+UVkCY71aNb5hRPE=;
        b=O69HxEELCoriQTXrZJpSJf2t49KXDxLOlvQtHIvGgTj/p65Uu3a4VNUF4StQAuVjY1
         2JBW6S3eqRDhekx5P4H/K6chUKdXNApPeZgLJFoqmPv7MfYIxq/pn+3rp8uugsV0xBR5
         8VLe/1DM0WVEp4pD/YEmZWuj3rXJ850uWejHPbPKz4Jy1MNCCFuNy4oObFpGhyT9DyaX
         GHPREJqjB51uEUtB3NxIkUjc/FaImQzIkMIbGl5vxiZzyrsYHNg8jyXJmGsf3l/fw29y
         wzLUuVo2Z1C8Zg3Ci6N7hcJVHF8KlZPXfbObqc6G60C5pKjZYOvms3tTyU1k4pkdsJuF
         D4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=KabTlyKzWR46PecaMYP6VWE+yqk+UVkCY71aNb5hRPE=;
        b=gp59H5RhsPFa0Uq9C/6cFNbIs0Z1hRTLegGF9H2bZN49nyNDeNp7um5gZO5x5ZtvXe
         TVQFpPmOSBG7QpEVmnHqyA1fxqCy5DAvB44YWFytOJhFepz+BFH0W5VUX/D05NV+nRND
         pGdQfo16Ib8hcj5P3tG99g9XMFHq2OrPsEoAXStCB4BBAIBAaImNHDHtyhhR86nDYT70
         0SoHNGmEkMPmFlB8GDuCcSRL4kMcs4ZISl98zN7FbGwa+KylQj/G5nbO4lowy3/kRZ77
         Mj81bJgqkYluZqMJQdHlQMA6arnIzZZtMwDbhWCBvOkgFOvyPqCw4n7DqXY1MS2tNuuI
         b2xQ==
X-Gm-Message-State: ACgBeo1Y4HWyASmRegBFmIlU2L/VVl3PyUakH1t/CfzUAfH+5hEmDXAq
        EuNXNf3mZiumsm6FQx1cHYj33nC264qsAQ==
X-Google-Smtp-Source: AA6agR5ge/9GGg8W946H0BK+pJwqsQmp5aWqC8ErjR3U4yInjpbGCOPvT5T9zAFetAEjY+syVYhC7Q==
X-Received: by 2002:a17:902:7247:b0:16e:ecb2:4870 with SMTP id c7-20020a170902724700b0016eecb24870mr6862654pll.110.1660907418870;
        Fri, 19 Aug 2022 04:10:18 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:18 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 12/13] x86/pmu: Add assignment framework for Intel-specific HW resources
Date:   Fri, 19 Aug 2022 19:09:38 +0800
Message-Id: <20220819110939.78013-13-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819110939.78013-1-likexu@tencent.com>
References: <20220819110939.78013-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

This is a pre-requisite operation for adding AMD PMU tests.

AMD and Intel PMU are different in counter registers, event selection
registers, number of generic registers and generic hardware events.
By introducing a set of global variables to facilitate assigning
different values on different platforms.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 99 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 58 insertions(+), 41 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index b22f255..0706cb1 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -50,7 +50,7 @@ struct pmu_event {
 	uint32_t unit_sel;
 	int min;
 	int max;
-} gp_events[] = {
+} intel_gp_events[] = {
 	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"ref cycles", 0x013c, 1*N, 30*N},
@@ -65,7 +65,13 @@ struct pmu_event {
 };
 
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
-static u64 gp_counter_base = MSR_IA32_PERFCTR0;
+static u32 gp_counter_base;
+static u32 gp_select_base;
+static unsigned int gp_events_size;
+static unsigned int nr_gp_counters;
+
+typedef struct pmu_event PMU_EVENTS_ARRAY_t[];
+static PMU_EVENTS_ARRAY_t *gp_events = NULL;
 
 char *buf;
 
@@ -114,9 +120,9 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 	if (is_gp(cnt)) {
 		int i;
 
-		for (i = 0; i < sizeof(gp_events)/sizeof(gp_events[0]); i++)
-			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
-				return &gp_events[i];
+		for (i = 0; i < gp_events_size; i++)
+			if ((*gp_events)[i].unit_sel == (cnt->config & 0xffff))
+				return &(*gp_events)[i];
 	} else
 		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
 
@@ -142,12 +148,22 @@ static void global_disable(pmu_counter_t *cnt)
 			~(1ull << cnt->idx));
 }
 
+static inline uint32_t get_gp_counter_msr(unsigned int i)
+{
+	return gp_counter_base + i;
+}
+
+static inline uint32_t get_gp_select_msr(unsigned int i)
+{
+	return gp_select_base + i;
+}
+
 static void __start_event(pmu_counter_t *evt, uint64_t count)
 {
     evt->count = count;
     wrmsr(evt->ctr, evt->count);
     if (is_gp(evt))
-	    wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
+	    wrmsr(get_gp_select_msr(event_to_global_idx(evt)),
 			    evt->config | EVNTSEL_EN);
     else {
 	    uint32_t ctrl = rdmsr(MSR_CORE_PERF_FIXED_CTR_CTRL);
@@ -176,7 +192,7 @@ static void stop_event(pmu_counter_t *evt)
 {
 	global_disable(evt);
 	if (is_gp(evt))
-		wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
+		wrmsr(get_gp_select_msr(event_to_global_idx(evt)),
 				evt->config & ~EVNTSEL_EN);
 	else {
 		uint32_t ctrl = rdmsr(MSR_CORE_PERF_FIXED_CTR_CTRL);
@@ -222,14 +238,13 @@ static bool verify_counter(pmu_counter_t *cnt)
 
 static void check_gp_counter(struct pmu_event *evt)
 {
-	int nr_gp_counters = pmu_nr_gp_counters();
 	pmu_counter_t cnt = {
-		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | evt->unit_sel,
 	};
 	int i;
 
-	for (i = 0; i < nr_gp_counters; i++, cnt.ctr++) {
+	for (i = 0; i < nr_gp_counters; i++) {
+		cnt.ctr = get_gp_counter_msr(i);
 		measure_one(&cnt);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
 	}
@@ -239,12 +254,11 @@ static void check_gp_counters(void)
 {
 	int i;
 
-	for (i = 0; i < sizeof(gp_events)/sizeof(gp_events[0]); i++)
+	for (i = 0; i < gp_events_size; i++)
 		if (pmu_gp_counter_is_available(i))
-			check_gp_counter(&gp_events[i]);
+			check_gp_counter(&(*gp_events)[i]);
 		else
-			printf("GP event '%s' is disabled\n",
-					gp_events[i].name);
+			printf("GP event '%s' is disabled\n", (*gp_events)[i].name);
 }
 
 static void check_fixed_counters(void)
@@ -265,7 +279,6 @@ static void check_fixed_counters(void)
 static void check_counters_many(void)
 {
 	int nr_fixed_counters = pmu_nr_fixed_counters();
-	int nr_gp_counters = pmu_nr_gp_counters();
 	pmu_counter_t cnt[10];
 	int i, n;
 
@@ -273,9 +286,8 @@ static void check_counters_many(void)
 		if (!pmu_gp_counter_is_available(i))
 			continue;
 
-		cnt[n].ctr = gp_counter_base + n;
-		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
-			gp_events[i % ARRAY_SIZE(gp_events)].unit_sel;
+		cnt[n].ctr = get_gp_counter_msr(n);
+		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[i % gp_events_size].unit_sel;
 		n++;
 	}
 	for (i = 0; i < nr_fixed_counters; i++) {
@@ -295,12 +307,11 @@ static void check_counters_many(void)
 
 static void check_counter_overflow(void)
 {
-	int nr_gp_counters = pmu_nr_gp_counters();
 	uint64_t count;
 	int i;
 	pmu_counter_t cnt = {
 		.ctr = gp_counter_base,
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
+		.config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[1].unit_sel /* instructions */,
 	};
 	__measure(&cnt, 0);
 	count = cnt.count;
@@ -313,10 +324,11 @@ static void check_counter_overflow(void)
 
 	report_prefix_push("overflow");
 
-	for (i = 0; i < nr_gp_counters + 1; i++, cnt.ctr++) {
+	for (i = 0; i < nr_gp_counters + 1; i++) {
 		uint64_t status;
 		int idx;
 
+		cnt.ctr = get_gp_counter_msr(i);
 		cnt.count = 1 - count;
 		if (gp_counter_base == MSR_IA32_PMC0)
 			cnt.count &= (1ull << pmu_gp_counter_width()) - 1;
@@ -359,11 +371,11 @@ static void check_gp_counter_cmask(void)
 {
 	pmu_counter_t cnt = {
 		.ctr = gp_counter_base,
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
+		.config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[1].unit_sel /* instructions */,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
 	measure_one(&cnt);
-	report(cnt.count < gp_events[1].min, "cmask");
+	report(cnt.count < (*gp_events)[1].min, "cmask");
 }
 
 static void do_rdpmc_fast(void *ptr)
@@ -383,7 +395,6 @@ static void check_rdpmc(void)
 	int fixed_counter_width = pmu_fixed_counter_width();
 	int nr_fixed_counters = pmu_nr_fixed_counters();
 	u8 gp_counter_width = pmu_gp_counter_width();
-	int nr_gp_counters = pmu_nr_gp_counters();
 	uint64_t val = 0xff0123456789ull;
 	bool exc;
 	int i;
@@ -393,7 +404,7 @@ static void check_rdpmc(void)
 	for (i = 0; i < nr_gp_counters; i++) {
 		uint64_t x;
 		pmu_counter_t cnt = {
-			.ctr = gp_counter_base + i,
+			.ctr = get_gp_counter_msr(i),
 			.idx = i
 		};
 
@@ -409,7 +420,7 @@ static void check_rdpmc(void)
 		/* Mask according to the number of supported bits */
 		x &= (1ull << gp_counter_width) - 1;
 
-		wrmsr(gp_counter_base + i, val);
+		wrmsr(get_gp_counter_msr(i), val);
 		report(rdpmc(i) == x, "cntr-%d", i);
 
 		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
@@ -444,7 +455,7 @@ static void check_running_counter_wrmsr(void)
 	uint64_t count;
 	pmu_counter_t evt = {
 		.ctr = gp_counter_base,
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[1].unit_sel,
 	};
 
 	report_prefix_push("running counter wrmsr");
@@ -453,7 +464,7 @@ static void check_running_counter_wrmsr(void)
 	loop();
 	wrmsr(gp_counter_base, 0);
 	stop_event(&evt);
-	report(evt.count < gp_events[1].min, "cntr");
+	report(evt.count < (*gp_events)[1].min, "cntr");
 
 	/* clear status before overflow test */
 	if (pmu_version() > 1) {
@@ -483,15 +494,16 @@ static void check_running_counter_wrmsr(void)
 static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
+	unsigned int branch_idx = 5;
 	pmu_counter_t brnch_cnt = {
-		.ctr = MSR_IA32_PERFCTR0,
+		.ctr = get_gp_counter_msr(0),
 		/* branch instructions */
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[5].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[branch_idx].unit_sel,
 	};
 	pmu_counter_t instr_cnt = {
-		.ctr = MSR_IA32_PERFCTR0 + 1,
+		.ctr = get_gp_counter_msr(1),
 		/* instructions */
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | intel_gp_events[1].unit_sel,
 	};
 	report_prefix_push("emulated instruction");
 
@@ -505,8 +517,8 @@ static void check_emulated_instr(void)
 
 	brnch_start = -EXPECTED_BRNCH;
 	instr_start = -EXPECTED_INSTR;
-	wrmsr(MSR_IA32_PERFCTR0, brnch_start);
-	wrmsr(MSR_IA32_PERFCTR0 + 1, instr_start);
+	wrmsr(get_gp_counter_msr(0), brnch_start);
+	wrmsr(get_gp_counter_msr(1), instr_start);
 	// KVM_FEP is a magic prefix that forces emulation so
 	// 'KVM_FEP "jne label\n"' just counts as a single instruction.
 	asm volatile(
@@ -579,7 +591,6 @@ static void check_gp_counters_write_width(void)
 	u64 val_64 = 0xffffff0123456789ull;
 	u64 val_32 = val_64 & ((1ull << 32) - 1);
 	u64 val_max_width = val_64 & ((1ull << pmu_gp_counter_width()) - 1);
-	int nr_gp_counters = pmu_nr_gp_counters();
 	int i;
 
 	/*
@@ -627,14 +638,14 @@ static void check_gp_counters_write_width(void)
 static void set_ref_cycle_expectations(void)
 {
 	pmu_counter_t cnt = {
-		.ctr = MSR_IA32_PERFCTR0,
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[2].unit_sel,
+		.ctr = get_gp_counter_msr(0),
+		.config = EVNTSEL_OS | EVNTSEL_USR | intel_gp_events[2].unit_sel,
 	};
 	uint64_t tsc_delta;
 	uint64_t t0, t1, t2, t3;
 
 	/* Bit 2 enumerates the availability of reference cycles events. */
-	if (!pmu_nr_gp_counters() || !pmu_gp_counter_is_available(2))
+	if (!nr_gp_counters || !pmu_gp_counter_is_available(2))
 		return;
 
 	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -663,8 +674,8 @@ static void set_ref_cycle_expectations(void)
 	if (!tsc_delta)
 		return;
 
-	gp_events[2].min = (gp_events[2].min * cnt.count) / tsc_delta;
-	gp_events[2].max = (gp_events[2].max * cnt.count) / tsc_delta;
+	intel_gp_events[2].min = (intel_gp_events[2].min * cnt.count) / tsc_delta;
+	intel_gp_events[2].max = (intel_gp_events[2].max * cnt.count) / tsc_delta;
 }
 
 static bool detect_intel_pmu(void)
@@ -674,6 +685,12 @@ static bool detect_intel_pmu(void)
 		return false;
 	}
 
+	nr_gp_counters = pmu_nr_gp_counters();
+	gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
+	gp_events = (PMU_EVENTS_ARRAY_t *)intel_gp_events;
+	gp_counter_base = MSR_IA32_PERFCTR0;
+	gp_select_base = MSR_P6_EVNTSEL0;
+
 	report_prefix_push("Intel");
 	return true;
 }
@@ -700,7 +717,7 @@ int main(int ac, char **av)
 	set_ref_cycle_expectations();
 
 	printf("PMU version:         %d\n", pmu_version());
-	printf("GP counters:         %d\n", pmu_nr_gp_counters());
+	printf("GP counters:         %d\n", nr_gp_counters);
 	printf("GP counter width:    %d\n", pmu_gp_counter_width());
 	printf("Mask length:         %d\n", pmu_gp_counter_mask_length());
 	printf("Fixed counters:      %d\n", pmu_nr_fixed_counters());
-- 
2.37.2

