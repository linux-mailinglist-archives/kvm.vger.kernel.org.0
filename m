Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC68609DA4
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiJXJOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiJXJNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:52 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D566A507
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f140so8498261pfa.1
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6J1OnS3XdfNtdXPYWlgN4cK2RdhyhyKRrLj4TTIwxis=;
        b=kf39dU7bz8GMy9tWXwer6RL/+zHvrScsserW8FoK4YctR2Qu4bodz8hz44oZmP7gG+
         v4vu/cqg1JQTujNUwIT8zwlywelFzNuxvqNaR9MsfrehM/ezcPptep9TRTjOAGOY5vng
         ssMypcBc0jVdT5XaUjckzZhvMrwCp19Oa+kSU+QM83vHLKVRBbkClmY3gJ+a4tEe8esN
         1P3RZViPleZDwTjJt6IckVGmLGqvdUYuKtx+BKlw5cIVNyCmS5zVvmpwdTMObUae/DK4
         +0J8zzOI6r+/Ng/ZOBialzili8MBA0NEiE+CBmUD6j4b1IxzzqFxwM/RtLTUtnI/e99I
         Zydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6J1OnS3XdfNtdXPYWlgN4cK2RdhyhyKRrLj4TTIwxis=;
        b=f3IWuOqxQMkD+VSOH4+Yjx110ITLyQj90j0k2gsXQZz8ba60DFbq3LI0nxIw5akjZi
         V/goC/5z7YbDpv9V9dNEFOY/vxHvx1EXgLwwfGvhorptDTdaDcMof4QHhbVVX+hSZqJ6
         rUf1EfgfGwEmLH2I85xrWMkRJGfCvPzkRty4IIabCpUZcs4aa+wzUmPDhvF6D7vwsLNv
         8uEd9btWpLbgxPzWA7hAm0kZzmqtpBRQKMXhencK301Rs6A7tyk5MgNddsDbV6HLgg5/
         ZuGNObLAPfV3A0l3ws1rxrNh0vXIwHLZ0rNBMaYVquv8DnAXue4DUAKb1KriepVA8lGE
         3IaA==
X-Gm-Message-State: ACrzQf1Dca2wgXanxSZ3UtWrkpSw1LGlaC53ZI31gHKFyAXKz23YhmYZ
        Y8lzIyEjWBBUySCd9XAHYJ4=
X-Google-Smtp-Source: AMsMyM4pxCnoDBeV5lGF0gL39+trKeU0gIXAs58IRmTe9mmQsohghWMHFbhqhhsT6Bh2WmVwwoAkug==
X-Received: by 2002:a65:6849:0:b0:461:8779:2452 with SMTP id q9-20020a656849000000b0046187792452mr26515942pgt.383.1666602814319;
        Mon, 24 Oct 2022 02:13:34 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:34 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 20/24] x86/pmu: Add global helpers to cover Intel Arch PMU Version 1
Date:   Mon, 24 Oct 2022 17:12:19 +0800
Message-Id: <20221024091223.42631-21-likexu@tencent.com>
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

To test Intel arch pmu version 1, most of the basic framework and
use cases which test any PMU counter do not require any changes,
except no access to registers introduced only in PMU version 2.

Adding some guardian's checks can seamlessly support version 1,
while opening the door for normal AMD PMUs tests.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/pmu.c |  8 +++++---
 lib/x86/pmu.h |  5 +++++
 x86/pmu.c     | 47 +++++++++++++++++++++++++++++++----------------
 3 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 3b6be37..43e6a43 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -10,8 +10,10 @@ void pmu_init(void)
         pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
     pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
     pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
-    pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
-    pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
-    pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+    if (this_cpu_support_perf_status()) {
+        pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
+        pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
+        pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+    }
     reset_all_counters();
 }
\ No newline at end of file
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 9ba2419..fa49a8f 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -116,6 +116,11 @@ static inline bool this_cpu_has_perf_global_ctrl(void)
 	return pmu_version() > 1;
 }
 
+static inline bool this_cpu_support_perf_status(void)
+{
+	return pmu_version() > 1;
+}
+
 static inline u8 pmu_nr_gp_counters(void)
 {
 	return (cpuid_10.a >> 8) & 0xff;
diff --git a/x86/pmu.c b/x86/pmu.c
index 015591f..daeb7a2 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -102,12 +102,18 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 
 static void global_enable(pmu_counter_t *cnt)
 {
+	if (!this_cpu_has_perf_global_ctrl())
+		return;
+
 	cnt->idx = event_to_global_idx(cnt);
 	pmu_set_global_enable(pmu_get_global_enable() | BIT_ULL(cnt->idx));
 }
 
 static void global_disable(pmu_counter_t *cnt)
 {
+	if (!this_cpu_has_perf_global_ctrl())
+		return;
+
 	pmu_set_global_enable(pmu_get_global_enable() & ~BIT_ULL(cnt->idx));
 }
 
@@ -286,7 +292,8 @@ static void check_counter_overflow(void)
 	overflow_preset = measure_for_overflow(&cnt);
 
 	/* clear status before test */
-	pmu_clear_global_status();
+	if (this_cpu_support_perf_status())
+		pmu_clear_global_status();
 
 	report_prefix_push("overflow");
 
@@ -313,6 +320,10 @@ static void check_counter_overflow(void)
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
 		report(cnt.count == 1, "cntr-%d", i);
+
+		if (!this_cpu_support_perf_status())
+			continue;
+
 		status = pmu_get_global_status();
 		report(status & (1ull << idx), "status-%d", i);
 		pmu_ack_global_status(status);
@@ -425,7 +436,8 @@ static void check_running_counter_wrmsr(void)
 	report(evt.count < gp_events[1].min, "cntr");
 
 	/* clear status before overflow test */
-	pmu_clear_global_status();
+	if (this_cpu_support_perf_status())
+		pmu_clear_global_status();
 
 	start_event(&evt);
 
@@ -437,8 +449,11 @@ static void check_running_counter_wrmsr(void)
 
 	loop();
 	stop_event(&evt);
-	status = pmu_get_global_status();
-	report(status & 1, "status msr bit");
+
+	if (this_cpu_support_perf_status()) {
+		status = pmu_get_global_status();
+		report(status & 1, "status msr bit");
+	}
 
 	report_prefix_pop();
 }
@@ -458,7 +473,8 @@ static void check_emulated_instr(void)
 	};
 	report_prefix_push("emulated instruction");
 
-	pmu_clear_global_status();
+	if (this_cpu_support_perf_status())
+		pmu_clear_global_status();
 
 	start_event(&brnch_cnt);
 	start_event(&instr_cnt);
@@ -492,7 +508,8 @@ static void check_emulated_instr(void)
 		:
 		: "eax", "ebx", "ecx", "edx");
 
-	pmu_reset_global_enable();
+	if (this_cpu_has_perf_global_ctrl())
+		pmu_reset_global_enable();
 
 	stop_event(&brnch_cnt);
 	stop_event(&instr_cnt);
@@ -503,10 +520,12 @@ static void check_emulated_instr(void)
 	       "instruction count");
 	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
 	       "branch count");
-	// Additionally check that those counters overflowed properly.
-	status = pmu_get_global_status();
-	report(status & 1, "branch counter overflow");
-	report(status & 2, "instruction counter overflow");
+	if (this_cpu_support_perf_status()) {
+		// Additionally check that those counters overflowed properly.
+		status = pmu_get_global_status();
+		report(status & 1, "branch counter overflow");
+		report(status & 2, "instruction counter overflow");
+	}
 
 	report_prefix_pop();
 }
@@ -593,7 +612,8 @@ static void set_ref_cycle_expectations(void)
 	if (!pmu_nr_gp_counters() || !pmu_gp_counter_is_available(2))
 		return;
 
-	pmu_reset_global_enable();
+	if (this_cpu_has_perf_global_ctrl())
+		pmu_reset_global_enable();
 
 	t0 = fenced_rdtsc();
 	start_event(&cnt);
@@ -644,11 +664,6 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
-	if (pmu_version() == 1) {
-		report_skip("PMU version 1 is not supported.");
-		return report_summary();
-	}
-
 	set_ref_cycle_expectations();
 
 	printf("PMU version:         %d\n", pmu_version());
-- 
2.38.1

