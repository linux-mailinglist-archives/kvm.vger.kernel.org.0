Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B63A5AD337
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 14:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbiIEMnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 08:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238314AbiIEMnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 08:43:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C033D252BD;
        Mon,  5 Sep 2022 05:40:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id n65-20020a17090a5ac700b001fbb4fad865so8544356pji.1;
        Mon, 05 Sep 2022 05:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=seGHwr7wN/RToSOqMCREluZ1ZHPCTPepY5jr28/SuRQ=;
        b=llBMzmv0mFQMPd+JjOiF8DMmipDMSDRnDT6nGx1HD6E4QzXlGfj10vKHsQR75Tn6/N
         Uf+mPJfUynaXIjQYgEgGt0MEeEsQjUtLM+plhQCYSLZdEea/nZSrnZ1dd3mCjE42VPuN
         BTihFuVegK2G9/P5JapVYP/P17cBlFRocJCj3A62k2zlTGSXEdYS0LWu3+m7PQg8xw8Q
         NCDr9F4PQh/zCo+kHlt6Samc19M5Qoh/H3Mjed4C9fPbsxbEJnPjZH+KvOG+ODGrOQp2
         jcsRW3Ufc//wsV4CMRopByxtVpRXs/6ymW57QL8ZIFwnhatOvLBg99qP5bnzvMmw/Dk7
         YUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=seGHwr7wN/RToSOqMCREluZ1ZHPCTPepY5jr28/SuRQ=;
        b=y1S357+Sxo8SMmqgZ3D7fdv1Rw2wp/CryhOnCimR0qu2NK7Ft+iwtm1xcT/qsbbKyO
         Hba4BHUrzr1DmOPx3cWNwk6m+kZS73kSEbmA6B8msvorZBdbFb4aQw7zM3gkcwNIDwoo
         CV0TecdEbg7a7uZRPzGu3Z6XlKEgjs/hCgg4MzDtq4mQQBpa0BO5CI9lu3EHBh61J/fA
         ZffCYu6/PLWXziDxBvoJ9EQY8vENdoJWexyzaAE8GuXcL7h5EnAqQspRAZqHzm8mCVOy
         w6uy/O4bzxC6IWGBhQD99Xpydxpdms67YBfPTjoxz2gXGCH3Pyw4IzkIwFTEtDFz9/oY
         +few==
X-Gm-Message-State: ACgBeo16YIecTaDjYYXCCPppQjtchsOg/aSXCbdOO5cy/6F2WiS93Z/4
        NFIHmpYZtWwFLdx6umzVFas=
X-Google-Smtp-Source: AA6agR4kWpkpDog/KasihJVn1sfOQuUU04GApqMie1dL3PdK5m+JEBfFmv6fa7sP12jE2ZgulfY8YQ==
X-Received: by 2002:a17:90b:1d08:b0:200:823f:9745 with SMTP id on8-20020a17090b1d0800b00200823f9745mr2203693pjb.84.1662381616274;
        Mon, 05 Sep 2022 05:40:16 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902ec8800b00168dadc7354sm7428431plg.78.2022.09.05.05.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 05:40:16 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/2] x86/pmu: Add AMD Guest PerfMonV2 testcases
Date:   Mon,  5 Sep 2022 20:39:46 +0800
Message-Id: <20220905123946.95223-7-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220905123946.95223-1-likexu@tencent.com>
References: <20220905123946.95223-1-likexu@tencent.com>
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

Updated test cases to cover KVM enabling code for AMD Guest PerfMonV2.

The Intel-specific PMU helpers were added to check for AMD cpuid, and
some of the same semantics of MSRs were assigned during the initialization
phase. The vast majority of pmu test cases are reused seamlessly.

On some x86 machines (AMD only), even with retired events, the same
workload is measured repeatedly and the number of events collected is
erratic, which essentially reflects the details of hardware implementation,
and from a software perspective, the type of event is an unprecise event,
which brings a tolerance check in the counter overflow testcases.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/msr.h       |  5 ++++
 lib/x86/processor.h |  9 ++++++-
 x86/pmu.c           | 61 ++++++++++++++++++++++++++++++++-------------
 3 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 5f16a58..6f31155 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -419,6 +419,11 @@
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
 
+/* AMD Performance Counter Global Status and Control MSRs */
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS	0xc0000300
+#define MSR_AMD64_PERF_CNTR_GLOBAL_CTL		0xc0000301
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR	0xc0000302
+
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9c490d9..b9592c4 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -796,8 +796,12 @@ static inline void flush_tlb(void)
 
 static inline u8 pmu_version(void)
 {
-	if (!is_intel())
+	if (!is_intel()) {
+		/* Performance Monitoring Version 2 Supported */
+		if (cpuid(0x80000022).a & 0x1)
+			return 2;
 		return 0;
+	}
 
 	return cpuid(10).a & 0xff;
 }
@@ -824,6 +828,9 @@ static inline u8 pmu_nr_gp_counters(void)
 {
 	if (is_intel()) {
 		return (cpuid(10).a >> 8) & 0xff;
+	} else if (this_cpu_has_perf_global_ctrl()) {
+		/* Number of Core Performance Counters. */
+		return cpuid(0x80000022).b & 0xf;
 	} else if (!has_amd_perfctr_core()) {
 		return AMD64_NUM_COUNTERS;
 	}
diff --git a/x86/pmu.c b/x86/pmu.c
index 11607c0..6d5363b 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -72,6 +72,9 @@ struct pmu_event {
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 static u32 gp_counter_base;
 static u32 gp_select_base;
+static u32 global_status_msr;
+static u32 global_ctl_msr;
+static u32 global_status_clr_msr;
 static unsigned int gp_events_size;
 static unsigned int nr_gp_counters;
 
@@ -150,8 +153,7 @@ static void global_enable(pmu_counter_t *cnt)
 		return;
 
 	cnt->idx = event_to_global_idx(cnt);
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) |
-			(1ull << cnt->idx));
+	wrmsr(global_ctl_msr, rdmsr(global_ctl_msr) | (1ull << cnt->idx));
 }
 
 static void global_disable(pmu_counter_t *cnt)
@@ -159,8 +161,7 @@ static void global_disable(pmu_counter_t *cnt)
 	if (pmu_version() < 2)
 		return;
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
-			~(1ull << cnt->idx));
+	wrmsr(global_ctl_msr, rdmsr(global_ctl_msr) & ~(1ull << cnt->idx));
 }
 
 static inline uint32_t get_gp_counter_msr(unsigned int i)
@@ -326,6 +327,23 @@ static void check_counters_many(void)
 	report(i == n, "all counters");
 }
 
+static bool is_the_count_reproducible(pmu_counter_t *cnt)
+{
+	unsigned int i;
+	uint64_t count;
+
+	__measure(cnt, 0);
+	count = cnt->count;
+
+	for (i = 0; i < 10; i++) {
+		__measure(cnt, 0);
+		if (count != cnt->count)
+			return false;
+	}
+
+	return true;
+}
+
 static void check_counter_overflow(void)
 {
 	uint64_t count;
@@ -334,13 +352,14 @@ static void check_counter_overflow(void)
 		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | (*gp_events)[1].unit_sel /* instructions */,
 	};
+	bool precise_event = is_the_count_reproducible(&cnt);
+
 	__measure(&cnt, 0);
 	count = cnt.count;
 
 	/* clear status before test */
 	if (pmu_version() > 1) {
-		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-		      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+		wrmsr(global_status_clr_msr, rdmsr(global_status_msr));
 	}
 
 	report_prefix_push("overflow");
@@ -373,7 +392,7 @@ static void check_counter_overflow(void)
 		__measure(&cnt, cnt.count);
 
 		report(check_irq() == (i % 2), "irq-%d", i);
-		if (pmu_version() > 1)
+		if (precise_event)
 			report(cnt.count == 1, "cntr-%d", i);
 		else
 			report(cnt.count < 4, "cntr-%d", i);
@@ -381,10 +400,10 @@ static void check_counter_overflow(void)
 		if (pmu_version() < 2)
 			continue;
 
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		status = rdmsr(global_status_msr);
 		report(status & (1ull << idx), "status-%d", i);
-		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, status);
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		wrmsr(global_status_clr_msr, status);
+		status = rdmsr(global_status_msr);
 		report(!(status & (1ull << idx)), "status clear-%d", i);
 	}
 
@@ -492,8 +511,7 @@ static void check_running_counter_wrmsr(void)
 
 	/* clear status before overflow test */
 	if (pmu_version() > 1) {
-		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-			rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+		wrmsr(global_status_clr_msr, rdmsr(global_status_msr));
 	}
 
 	start_event(&evt);
@@ -508,7 +526,7 @@ static void check_running_counter_wrmsr(void)
 	stop_event(&evt);
 
 	if (pmu_version() > 1) {
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		status = rdmsr(global_status_msr);
 		report(status & 1, "status");
 	}
 
@@ -532,8 +550,7 @@ static void check_emulated_instr(void)
 	report_prefix_push("emulated instruction");
 
 	if (pmu_version() > 1) {
-		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-			rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+		wrmsr(global_status_clr_msr, rdmsr(global_status_msr));
 	}
 
 	start_event(&brnch_cnt);
@@ -576,7 +593,7 @@ static void check_emulated_instr(void)
 		: "eax", "ebx", "ecx", "edx");
 
 	if (pmu_version() > 1)
-		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+		wrmsr(global_ctl_msr, 0);
 
 	stop_event(&brnch_cnt);
 	stop_event(&instr_cnt);
@@ -590,7 +607,7 @@ static void check_emulated_instr(void)
 
 	if (pmu_version() > 1) {
 		// Additionally check that those counters overflowed properly.
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		status = rdmsr(global_status_msr);
 		report(status & 1, "instruction counter overflow");
 		report(status & 2, "branch counter overflow");
 	}
@@ -679,7 +696,7 @@ static void set_ref_cycle_expectations(void)
 	if (!nr_gp_counters || !pmu_gp_counter_is_available(2))
 		return;
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	wrmsr(global_ctl_msr, 0);
 
 	t0 = fenced_rdtsc();
 	start_event(&cnt);
@@ -722,6 +739,10 @@ static bool detect_intel_pmu(void)
 	gp_counter_base = MSR_IA32_PERFCTR0;
 	gp_select_base = MSR_P6_EVNTSEL0;
 
+	global_status_msr = MSR_CORE_PERF_GLOBAL_STATUS;
+	global_ctl_msr = MSR_CORE_PERF_GLOBAL_CTRL;
+	global_status_clr_msr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+
 	report_prefix_push("Intel");
 	return true;
 }
@@ -746,6 +767,10 @@ static bool detect_amd_pmu(void)
 	gp_counter_base = MSR_F15H_PERF_CTR0;
 	gp_select_base = MSR_F15H_PERF_CTL0;
 
+	global_status_msr = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
+	global_ctl_msr = MSR_AMD64_PERF_CNTR_GLOBAL_CTL;
+	global_status_clr_msr = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR;
+
 	report_prefix_push("AMD");
 	return true;
 }
-- 
2.37.3

