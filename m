Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1095956F2
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 11:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiHPJrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 05:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiHPJrG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 05:47:06 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C341771BFF
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:13 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ha11so9108459pjb.2
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=5lQJ9N30h1dB8N7TzTDJkwsX1gtcyo4Gy4YtWgKBu68=;
        b=BY0GfeP6PtR9jeMQPMb1+ipUrkMU7Vc8GQfV0mksdMf+fKHZuRsMOYV+UNXJBu+OvQ
         pyTC/IsiJP8+IBrg+e3E9hZCuGMwaZLMVyVLyuFUVqEuLp58AEl7ycdWKikYblQrUWJ4
         v3LU8L8BQGm0EXyvi1qQw3a9GJLfiR7sg6NikjoAv727SmhiKH4VwEukMEGuvWlQ09Vz
         g7o6Zxh5kaw7be7MaF+JCDZ8mmPSgPe+EtYhYChBlh+RdQsGk9sGoOgct6Wae5POa12Q
         axi1LlV6y9OnNscmgOarCXk2fqB5RmzGiJtOEYj7MfZQZH81+0W1zpjmqdo+vs6Ntkz8
         2NAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=5lQJ9N30h1dB8N7TzTDJkwsX1gtcyo4Gy4YtWgKBu68=;
        b=E9Dr7LFSfA9A0UbXp23GmWIjIQG01WantX6uKBnGlSZOuYICxYRNN5aqylLOb2eoP1
         GrXaKkW7vaXaaCRL8n7VpJaSMV8cQ0b2+mT2sl1WRPQh5kpPjtlnQR/iNYfr8Jn0cyL0
         CS3wys+hj0LY/uBCtJ6yJfLKA1cOE6hnrQ3WCPfVZ6iFEmzv3Q3Zgm7lhR4G8Fxk129O
         JVGCXWo/3YJA9ZfdPH/xH20VJbUDuP0Dd+RGA+A7BOyyo9n8rbybXqgq/bJt9QFlbLoE
         hBs0Ih1timiWYcSalvUkxuiw87hwXosMKiPk4U9rivTXfzCiyWXrktEdaqCXrbQz550c
         Vwzw==
X-Gm-Message-State: ACgBeo318kKu5oT8vgPzaYZQVxi/IMFOwh7/pECRxtyzz4xeycF4NZ+b
        LW3ryVWBXasOy9QsrmxG0lQ=
X-Google-Smtp-Source: AA6agR6iqOTzJo/GbIgS/82TA8gu9lh8FSX6eOlXONqXLujwbz4szjMyfGgXSxI3wkb+ePdaQeROaA==
X-Received: by 2002:a17:903:481:b0:172:715f:69d9 with SMTP id jj1-20020a170903048100b00172715f69d9mr7662725plb.5.1660637413265;
        Tue, 16 Aug 2022 01:10:13 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902db0c00b0016d7b2352desm8400920plx.244.2022.08.16.01.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 01:10:12 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/5] x86/pmu: Introduce __start_event() to drop all of the manual zeroing
Date:   Tue, 16 Aug 2022 16:09:05 +0800
Message-Id: <20220816080909.90622-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816080909.90622-1-likexu@tencent.com>
References: <20220816080909.90622-1-likexu@tencent.com>
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
index d59baf1..817b4d0 100644
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
 
@@ -589,7 +591,6 @@ static void set_ref_cycle_expectations(void)
 	pmu_counter_t cnt = {
 		.ctr = MSR_IA32_PERFCTR0,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[2].unit_sel,
-		.count = 0,
 	};
 	uint64_t tsc_delta;
 	uint64_t t0, t1, t2, t3;
-- 
2.37.2

