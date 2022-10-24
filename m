Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5C609DA1
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiJXJN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJXJNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:44 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C597669F53
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso8394145pjc.5
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKgpAoNh2IEQOZ+LvJjkBexGM/DA1qHleGUwQYu4zQo=;
        b=KqgSBjYdaME/Oa9ujefmR28w8m4Mc6v4q8nvT4Tb9pf5BEmH/oytYTsGTU+rrr3n7W
         tGC+GSFECoRPHhHG/ftWto5wMRn0VzpEw3NdwtMEIUIONUi0SuIaR1XoogIbcRhEvVlt
         yujrNtr/QqOHEopYDO9sLsNLLlRwJOn3dbH2yVM93ADws6cu/gzIdI3ddydLJg3H8u4b
         DzlsOkWrwvcLu429Pv1ZteI/kNy7XEFacvlmJ0mE4973YyPnw//Gk9qp4o4B2BtsugyY
         6wqwjp3M5cHSmQhh2Z+VB5FK9oDY3Rsp/7YDYJVwl8xvOZp9gylI2X4ZXNYovIEWEQc/
         F2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JKgpAoNh2IEQOZ+LvJjkBexGM/DA1qHleGUwQYu4zQo=;
        b=p6IOQX410Q6qRiFOYmVR3PheQwpNWL0JE58URmI0OPt+Vyro29yDNWXlOx6YCUbfbZ
         cbevFC6sAxo76i+Mj0GRfFZxfQKxYV7A2tR+NKbm+fGa6iHPYoSDxWPjO5YjpLaaqT+P
         Tm6cpSnPjFRlbxRblQW0Nw5SzJoCxjQgPBiNqy1IcD4ok+wjgtDe9ouaP+ULfvsiM4n+
         8/6OCCND/si6myVxE3CkkQ6d1C7lU9THp+1apVIwkFYzc4nuUTxIBv94CbaTQLC6OFmK
         bKR/IF5frU3WeSrRaQexnyXGfqYMmBuD0rxZpW47FQkNGAg+spV1gcGjVYW2uHYCk94D
         XSng==
X-Gm-Message-State: ACrzQf1eA+yUaxlVySYzS610dxVCtJQSuFL07r6IjwbAi9BVbQKeS0jO
        Gg7SXFSFHz6P49/2tcMudj4=
X-Google-Smtp-Source: AMsMyM5WR+CvU0aW0pc7zqruVS1CK8HBuxVr23B4XBUBC/vTW/wHkzZxRuDID+BWOdwqDaHWfVC6Fw==
X-Received: by 2002:a17:90a:6045:b0:212:fe9a:5792 with SMTP id h5-20020a17090a604500b00212fe9a5792mr7403798pjm.178.1666602807702;
        Mon, 24 Oct 2022 02:13:27 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:27 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 16/24] x86/pmu: Add GP counter related helpers
Date:   Mon, 24 Oct 2022 17:12:15 +0800
Message-Id: <20221024091223.42631-17-likexu@tencent.com>
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

Continuing the theme of code reuse, tests shouldn't need to manually
compute gp_counter_base and gp_event_select_base.

They can be accessed directly after initialization and changed via setters
when they need to be changed in some cases, e.g. full writes.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/pmu.c |  2 ++
 lib/x86/pmu.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 x86/pmu.c     | 50 ++++++++++++++++++++++++--------------------------
 3 files changed, 73 insertions(+), 26 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 35b7efb..c0d100d 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -8,4 +8,6 @@ void pmu_init(void)
     cpuid_10 = cpuid(10);
     if (this_cpu_has(X86_FEATURE_PDCM))
         pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+    pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
+    pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
 }
\ No newline at end of file
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 95b17da..7487a30 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -35,6 +35,8 @@
 
 struct pmu_caps {
     u64 perf_cap;
+    u32 msr_gp_counter_base;
+    u32 msr_gp_event_select_base;
 };
 
 extern struct cpuid cpuid_10;
@@ -42,6 +44,46 @@ extern struct pmu_caps pmu;
 
 void pmu_init(void);
 
+static inline u32 gp_counter_base(void)
+{
+	return pmu.msr_gp_counter_base;
+}
+
+static inline void set_gp_counter_base(u32 new_base)
+{
+	pmu.msr_gp_counter_base = new_base;
+}
+
+static inline u32 gp_event_select_base(void)
+{
+	return pmu.msr_gp_event_select_base;
+}
+
+static inline void set_gp_event_select_base(u32 new_base)
+{
+	pmu.msr_gp_event_select_base = new_base;
+}
+
+static inline u32 gp_counter_msr(unsigned int i)
+{
+	return gp_counter_base() + i;
+}
+
+static inline u32 gp_event_select_msr(unsigned int i)
+{
+	return gp_event_select_base() + i;
+}
+
+static inline void write_gp_counter_value(unsigned int i, u64 value)
+{
+	wrmsr(gp_counter_msr(i), value);
+}
+
+static inline void write_gp_event_select(unsigned int i, u64 value)
+{
+	wrmsr(gp_event_select_msr(i), value);
+}
+
 static inline u8 pmu_version(void)
 {
 	return cpuid_10.a & 0xff;
@@ -109,4 +151,9 @@ static inline bool pmu_has_full_writes(void)
 	return this_cpu_perf_capabilities() & PMU_CAP_FW_WRITES;
 }
 
+static inline bool pmu_use_full_writes(void)
+{
+	return gp_counter_base() == MSR_IA32_PMC0;
+}
+
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu.c b/x86/pmu.c
index a6329cd..589c7cb 100644
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
+	return cnt->ctr - (is_gp(cnt) ? gp_counter_base() :
 		(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
 }
 
@@ -121,8 +119,7 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
     evt->count = count;
     wrmsr(evt->ctr, evt->count);
     if (is_gp(evt))
-	    wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
-			    evt->config | EVNTSEL_EN);
+	    write_gp_event_select(event_to_global_idx(evt), evt->config | EVNTSEL_EN);
     else {
 	    uint32_t ctrl = rdmsr(MSR_CORE_PERF_FIXED_CTR_CTRL);
 	    int shift = (evt->ctr - MSR_CORE_PERF_FIXED_CTR0) * 4;
@@ -150,8 +147,7 @@ static void stop_event(pmu_counter_t *evt)
 {
 	global_disable(evt);
 	if (is_gp(evt))
-		wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
-				evt->config & ~EVNTSEL_EN);
+		write_gp_event_select(event_to_global_idx(evt), evt->config & ~EVNTSEL_EN);
 	else {
 		uint32_t ctrl = rdmsr(MSR_CORE_PERF_FIXED_CTR_CTRL);
 		int shift = (evt->ctr - MSR_CORE_PERF_FIXED_CTR0) * 4;
@@ -198,12 +194,12 @@ static void check_gp_counter(struct pmu_event *evt)
 {
 	int nr_gp_counters = pmu_nr_gp_counters();
 	pmu_counter_t cnt = {
-		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | evt->unit_sel,
 	};
 	int i;
 
-	for (i = 0; i < nr_gp_counters; i++, cnt.ctr++) {
+	for (i = 0; i < nr_gp_counters; i++) {
+		cnt.ctr = gp_counter_msr(i);
 		measure_one(&cnt);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
 	}
@@ -247,7 +243,7 @@ static void check_counters_many(void)
 		if (!pmu_gp_counter_is_available(i))
 			continue;
 
-		cnt[n].ctr = gp_counter_base + n;
+		cnt[n].ctr = gp_counter_msr(n);
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
 			gp_events[i % ARRAY_SIZE(gp_events)].unit_sel;
 		n++;
@@ -287,7 +283,7 @@ static void check_counter_overflow(void)
 	uint64_t overflow_preset;
 	int i;
 	pmu_counter_t cnt = {
-		.ctr = gp_counter_base,
+		.ctr = gp_counter_msr(0),
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 	};
 	overflow_preset = measure_for_overflow(&cnt);
@@ -297,18 +293,20 @@ static void check_counter_overflow(void)
 
 	report_prefix_push("overflow");
 
-	for (i = 0; i < nr_gp_counters + 1; i++, cnt.ctr++) {
+	for (i = 0; i < nr_gp_counters + 1; i++) {
 		uint64_t status;
 		int idx;
 
 		cnt.count = overflow_preset;
-		if (gp_counter_base == MSR_IA32_PMC0)
+		if (pmu_use_full_writes())
 			cnt.count &= (1ull << pmu_gp_counter_width()) - 1;
 
 		if (i == nr_gp_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
 			cnt.count = measure_for_overflow(&cnt);
 			cnt.count &= (1ull << pmu_fixed_counter_width()) - 1;
+		} else {
+			cnt.ctr = gp_counter_msr(i);
 		}
 
 		if (i % 2)
@@ -332,7 +330,7 @@ static void check_counter_overflow(void)
 static void check_gp_counter_cmask(void)
 {
 	pmu_counter_t cnt = {
-		.ctr = gp_counter_base,
+		.ctr = gp_counter_msr(0),
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
@@ -367,7 +365,7 @@ static void check_rdpmc(void)
 	for (i = 0; i < nr_gp_counters; i++) {
 		uint64_t x;
 		pmu_counter_t cnt = {
-			.ctr = gp_counter_base + i,
+			.ctr = gp_counter_msr(i),
 			.idx = i
 		};
 
@@ -375,7 +373,7 @@ static void check_rdpmc(void)
 	         * Without full-width writes, only the low 32 bits are writable,
 	         * and the value is sign-extended.
 	         */
-		if (gp_counter_base == MSR_IA32_PERFCTR0)
+		if (gp_counter_base() == MSR_IA32_PERFCTR0)
 			x = (uint64_t)(int64_t)(int32_t)val;
 		else
 			x = (uint64_t)(int64_t)val;
@@ -383,7 +381,7 @@ static void check_rdpmc(void)
 		/* Mask according to the number of supported bits */
 		x &= (1ull << gp_counter_width) - 1;
 
-		wrmsr(gp_counter_base + i, val);
+		write_gp_counter_value(i, val);
 		report(rdpmc(i) == x, "cntr-%d", i);
 
 		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
@@ -417,7 +415,7 @@ static void check_running_counter_wrmsr(void)
 	uint64_t status;
 	uint64_t count;
 	pmu_counter_t evt = {
-		.ctr = gp_counter_base,
+		.ctr = gp_counter_msr(0),
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
 	};
 
@@ -425,7 +423,7 @@ static void check_running_counter_wrmsr(void)
 
 	start_event(&evt);
 	loop();
-	wrmsr(gp_counter_base, 0);
+	write_gp_counter_value(0, 0);
 	stop_event(&evt);
 	report(evt.count < gp_events[1].min, "cntr");
 
@@ -436,10 +434,10 @@ static void check_running_counter_wrmsr(void)
 	start_event(&evt);
 
 	count = -1;
-	if (gp_counter_base == MSR_IA32_PMC0)
+	if (pmu_use_full_writes())
 		count &= (1ull << pmu_gp_counter_width()) - 1;
 
-	wrmsr(gp_counter_base, count);
+	write_gp_counter_value(0, count);
 
 	loop();
 	stop_event(&evt);
@@ -453,12 +451,12 @@ static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
 	pmu_counter_t brnch_cnt = {
-		.ctr = MSR_IA32_PERFCTR0,
+		.ctr = gp_counter_msr(0),
 		/* branch instructions */
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[5].unit_sel,
 	};
 	pmu_counter_t instr_cnt = {
-		.ctr = MSR_IA32_PERFCTR0 + 1,
+		.ctr = gp_counter_msr(1),
 		/* instructions */
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
 	};
@@ -472,8 +470,8 @@ static void check_emulated_instr(void)
 
 	brnch_start = -EXPECTED_BRNCH;
 	instr_start = -EXPECTED_INSTR;
-	wrmsr(MSR_IA32_PERFCTR0, brnch_start);
-	wrmsr(MSR_IA32_PERFCTR0 + 1, instr_start);
+	write_gp_counter_value(0, brnch_start);
+	write_gp_counter_value(1, instr_start);
 	// KVM_FEP is a magic prefix that forces emulation so
 	// 'KVM_FEP "jne label\n"' just counts as a single instruction.
 	asm volatile(
@@ -670,7 +668,7 @@ int main(int ac, char **av)
 	check_counters();
 
 	if (pmu_has_full_writes()) {
-		gp_counter_base = MSR_IA32_PMC0;
+		set_gp_counter_base(MSR_IA32_PMC0);
 		report_prefix_push("full-width writes");
 		check_counters();
 		check_gp_counters_write_width();
-- 
2.38.1

