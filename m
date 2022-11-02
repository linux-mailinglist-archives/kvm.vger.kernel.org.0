Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3312C6170E4
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiKBWv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiKBWvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:25 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768AED2C7
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:24 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l1-20020a170902f68100b00187117d8e44so196253plg.2
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dragfJuO8MQlza0cLvEA8K9vdS8di7PiQG3Vw/G4vPc=;
        b=GDBwhEgATIuRzbFFZHhvwuniABMUV8QYhhi985MRF7p43Oxb1zWD28g2r7456SfMrf
         +XuFGtczGrzUEiPZ8IEDW+6zkQ9jVIq33n7w4AvmvL5X4miSWWxU7kUZld0YcBNoukrx
         TRA5fB6xaYEWs4wZeo9q+6j+Ub2fLPy5eoZ4Jkcmfihm4W7oPWlFLKIyfDo8jbaRzeHN
         X8JNOCvAwYnQYrlNEaC6Xpbbg9RTEUdaQ9dVhLetCEDV2I2fQLSF+3PBWTko6BS8zD6E
         I+azSs9IwwBNUuWfHtlREK/M9pyDqCpR71flVsgYy4fAbAnOipWokgYI1X8GeiMGH5Kr
         TRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dragfJuO8MQlza0cLvEA8K9vdS8di7PiQG3Vw/G4vPc=;
        b=vPwaHT36MQ7VAjYnvkjjapEmt738riCwOCyn6qf0Sj3/QMAPdOaxYPBSquNuOm6/av
         4dRDkFdiqK3VqhTMWk4iPRCmV2CYNlM8TPAkRIOf1oxBB1k5KUY9KwvxSpTgOtt9HY0P
         MvME9ldQt1TuYUf1OMUlSRAA7ivcyru6U5+huXZvn+v5Sl9FooSrDOa6BZ0gyLTBcVyL
         4Xs1QUAC5XFY7PJMV1Erry5KEYPSArLTPPL4Ra8Pn0EUbCB1lvTfWTI8YOrXEMhpbwTT
         sBynPI8gQDdAkVNjfEIT3Lv4Eh7nffam2ohgZ75fVlYu6fnocEERkEAAjWM+NHDSW+tn
         3Rmg==
X-Gm-Message-State: ACrzQf2qmfnYT0j0RPJIkydrIKxk2gJEcZZSLeIqMDJr0DTvfQRNbe4N
        8K7EQEMmw1OUcgXTPKgC4NdD9ZZ1LMU=
X-Google-Smtp-Source: AMsMyM52Seg13r9gis56ND9gOcLPyELntYl2RqUSqagr6xuSZnS65nRgeSPxfiR9onUgHc0xILktrXRwlag=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10cf:b0:528:48c3:79e0 with SMTP id
 d15-20020a056a0010cf00b0052848c379e0mr27105947pfu.18.1667429483987; Wed, 02
 Nov 2022 15:51:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:49 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 06/27] x86/pmu: Introduce __start_event() to
 drop all of the manual zeroing
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

Most invocation of start_event() and measure() first sets evt.count=0.
Instead of forcing each caller to ensure count is zeroed, optimize the
count to zero during start_event(), then drop all of the manual zeroing.

Accumulating counts can be handled by reading the current count before
start_event(), and doing something like stuffing a high count to test an
edge case could be handled by an inner helper, __start_event().

For overflow, just open code measure() for that one-off case. Requiring
callers to zero out a field in most common cases isn't exactly flexible.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
[sean: tag __measure() noinline so its count is stable]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 715b45a3..77e59c5c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -137,9 +137,9 @@ static void global_disable(pmu_counter_t *cnt)
 			~(1ull << cnt->idx));
 }
 
-
-static void start_event(pmu_counter_t *evt)
+static void __start_event(pmu_counter_t *evt, uint64_t count)
 {
+    evt->count = count;
     wrmsr(evt->ctr, evt->count);
     if (is_gp(evt))
 	    wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
@@ -162,6 +162,11 @@ static void start_event(pmu_counter_t *evt)
     apic_write(APIC_LVTPC, PC_VECTOR);
 }
 
+static void start_event(pmu_counter_t *evt)
+{
+	__start_event(evt, 0);
+}
+
 static void stop_event(pmu_counter_t *evt)
 {
 	global_disable(evt);
@@ -186,6 +191,13 @@ static noinline void measure(pmu_counter_t *evt, int count)
 		stop_event(&evt[i]);
 }
 
+static noinline void __measure(pmu_counter_t *evt, uint64_t count)
+{
+	__start_event(evt, count);
+	loop();
+	stop_event(evt);
+}
+
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
 	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
@@ -208,7 +220,6 @@ static void check_gp_counter(struct pmu_event *evt)
 	int i;
 
 	for (i = 0; i < nr_gp_counters; i++, cnt.ctr++) {
-		cnt.count = 0;
 		measure(&cnt, 1);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
 	}
@@ -235,7 +246,6 @@ static void check_fixed_counters(void)
 	int i;
 
 	for (i = 0; i < nr_fixed_counters; i++) {
-		cnt.count = 0;
 		cnt.ctr = fixed_events[i].unit_sel;
 		measure(&cnt, 1);
 		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d", i);
@@ -253,14 +263,12 @@ static void check_counters_many(void)
 		if (!pmu_gp_counter_is_available(i))
 			continue;
 
-		cnt[n].count = 0;
 		cnt[n].ctr = gp_counter_base + n;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
 			gp_events[i % ARRAY_SIZE(gp_events)].unit_sel;
 		n++;
 	}
 	for (i = 0; i < nr_fixed_counters; i++) {
-		cnt[n].count = 0;
 		cnt[n].ctr = fixed_events[i].unit_sel;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
 		n++;
@@ -283,9 +291,8 @@ static void check_counter_overflow(void)
 	pmu_counter_t cnt = {
 		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
-		.count = 0,
 	};
-	measure(&cnt, 1);
+	__measure(&cnt, 0);
 	count = cnt.count;
 
 	/* clear status before test */
@@ -311,7 +318,7 @@ static void check_counter_overflow(void)
 		else
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
-		measure(&cnt, 1);
+		__measure(&cnt, cnt.count);
 		report(cnt.count == 1, "cntr-%d", i);
 		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
 		report(status & (1ull << idx), "status-%d", i);
@@ -329,7 +336,6 @@ static void check_gp_counter_cmask(void)
 	pmu_counter_t cnt = {
 		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
-		.count = 0,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
 	measure(&cnt, 1);
@@ -415,7 +421,6 @@ static void check_running_counter_wrmsr(void)
 	pmu_counter_t evt = {
 		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
-		.count = 0,
 	};
 
 	report_prefix_push("running counter wrmsr");
@@ -430,7 +435,6 @@ static void check_running_counter_wrmsr(void)
 	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
 
-	evt.count = 0;
 	start_event(&evt);
 
 	count = -1;
@@ -454,13 +458,11 @@ static void check_emulated_instr(void)
 		.ctr = MSR_IA32_PERFCTR0,
 		/* branch instructions */
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[5].unit_sel,
-		.count = 0,
 	};
 	pmu_counter_t instr_cnt = {
 		.ctr = MSR_IA32_PERFCTR0 + 1,
 		/* instructions */
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
-		.count = 0,
 	};
 	report_prefix_push("emulated instruction");
 
@@ -592,7 +594,6 @@ static void set_ref_cycle_expectations(void)
 	pmu_counter_t cnt = {
 		.ctr = MSR_IA32_PERFCTR0,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[2].unit_sel,
-		.count = 0,
 	};
 	uint64_t tsc_delta;
 	uint64_t t0, t1, t2, t3;
-- 
2.38.1.431.g37b22c650d-goog

