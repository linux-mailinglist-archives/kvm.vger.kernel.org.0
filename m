Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF730609D96
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiJXJNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiJXJNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:14 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688F65DF15
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:12 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b11so1553911pjp.2
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lFiYRPMFwxC0VCioIK1PlS5FRVqg/JDQyNk2MrSN+sI=;
        b=IPXNbTJAP/7X09sUuKEkIRo7r3bhkoMOrakDLJl5bsBC3X9nC8K843G+nJXCbqeTXD
         3yA3O3N09ZbPHqhh7a9YMwhlYkmmlT0D5kQ4km0jPXLaG+CgWWs+xSNvBm74WuWHSMFU
         t40t+B7yKTi28gqRV6GP0/ClJw5pfJkAW1GFjqL+jZdomerUdqdOycS77Hc7sb+AscRd
         mLcc7isNAQz0YJGX52kD8sdt6WnMHwCF+eF5LGlmq/H8Phli4gA85gfsH5MblU342pJJ
         APr3nJ/xpRlvRC8avSXNo9/qWBIIU1ug3vuW9z+/ZN77pXm7SPtIskETk3UerFEJpoNO
         FLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFiYRPMFwxC0VCioIK1PlS5FRVqg/JDQyNk2MrSN+sI=;
        b=ujbSUtRhncRoRmYytpih0ieDCGjeLd69mC+B5zTgXqs05Kt2aFohTyVObUDRl1Eq2h
         2NgVxXoh6XOMnHsEAMR6+R77LaDZK0OMqX6RamJqkYaCVA4Zlp20RsFxPhqbjMKt3lU4
         nra+oZ5ecPD11uHFU3L6cqurBrNJb+rle2GgWmHGJLPfyrNPzEWxGlwkRaVpGq2z6BUV
         ep7F/xl6sbNq0agbkBA/6mU6wx0LWJvfWKfi8JnJvbaVIbeSx16zHOqJ0js3mxGt+XqT
         +q8yD7e6uhKOHAoUg0tOBKoumHvO69mhXmqkUCRbRhw9ja6qoozbf/3SRlNDUtGdoFGP
         B3DA==
X-Gm-Message-State: ACrzQf1JB11qwjQ67Ax199wnlg/wrfAJwZbMgttJVSMbvgYH7fsHFycQ
        5f+LHbyKtxf5VlzFGSVCWAo=
X-Google-Smtp-Source: AMsMyM7Sd+6o4j2UJnC9NjiSRaAEB8MPq8OD3vxG2lOOrHLJ1Dl+ZxNY1nvL2WsEgAN7CMnhLgHaQw==
X-Received: by 2002:a17:90a:4607:b0:202:e22d:4892 with SMTP id w7-20020a17090a460700b00202e22d4892mr36546376pjg.220.1666602791475;
        Mon, 24 Oct 2022 02:13:11 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:11 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 06/24] x86/pmu: Introduce __start_event() to drop all of the manual zeroing
Date:   Mon, 24 Oct 2022 17:12:05 +0800
Message-Id: <20221024091223.42631-7-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
---
 x86/pmu.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index d303a36..ba67aa6 100644
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
@@ -186,6 +191,13 @@ static void measure(pmu_counter_t *evt, int count)
 		stop_event(&evt[i]);
 }
 
+static void __measure(pmu_counter_t *evt, uint64_t count)
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
2.38.1

