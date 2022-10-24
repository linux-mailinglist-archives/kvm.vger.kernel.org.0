Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0291609DA3
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiJXJOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiJXJNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC835D0E3
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:33 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l6so4084104pjj.0
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cq7UpDqVP2pq0R7JK/J7HN1k4KkbHGM+tLfSJ1nuzPM=;
        b=Y+tPcHWDAtkTQ1Km1fi5NpiRDDtqfPbyaN+DXZ/rSqweY/XsQQiu69Zfp68e7A+B4m
         6ZNAZjIX22DaCaxAAt8LwAQdVH7MIs3rL2sLRaN0j3ChfKKzJmudck3bQSidxq/8Rp/J
         SMlhAGRqwIyvQ5fprgxCRuZBXRkNpN0nZI7qNprEO1QowTnNjKog5oc4nbKnQco9qxpC
         17S7ucHC++kXCnW++le03Bv+NrRQgzJ6Am94SBgN6swsXhXk75XATCLLj54eB6kJikpG
         Cd96Zccdpw2g/+ymBFjFWXCmF3repdRKdkdmTNi3Gl9bvvSnhyeDz3o6zoMvB+LGUTWz
         lCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cq7UpDqVP2pq0R7JK/J7HN1k4KkbHGM+tLfSJ1nuzPM=;
        b=nYfRxveDk/qSSn/nefUoPLggurRdCyb3U3CcEc6sHMk1zyU/rdI/w7gpdffsxaIhTd
         WqRm9+rr7azSG1f9dpxPMoZUdStRR11JQkEik1Qfu/kJu6ticB02VD7bSAitcp4O0hio
         LMmZQylnqERHeGdGmc2QUgjo14fgy7jD7eaQuzgSB4X1g7+3sA17Kp/e9DvOhVCgEGhY
         88nvUxRiIUKYHNyo8CD1VJ+SnZvReasP0udY8Y6c4zkvWajn4y1HFLlQCUvwUYMTECsu
         Kgpj1qZS301YiB3VJdFAVCeAbnHXohKK7LI0Eb9DekybGOzM77yMFsAvXAOsgAsnZtIY
         M7wA==
X-Gm-Message-State: ACrzQf2tfIt2ln1H8e7GECFz1opyZATPir+r7XQJiTfP5jeYal0bVi3a
        0CBSQFjEV9PZofscSXnKm8Q=
X-Google-Smtp-Source: AMsMyM7bNH05BvRIAkZLQgRzmL4gdynVW4Z2bJc7dA31VJ50Mwr8gypUQ54X/SHKXg7x1+XMIcJOHA==
X-Received: by 2002:a17:903:124c:b0:184:cb7e:67c5 with SMTP id u12-20020a170903124c00b00184cb7e67c5mr32945163plh.117.1666602810855;
        Mon, 24 Oct 2022 02:13:30 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:30 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 18/24] x86/pmu: Add a set of helpers related to global registers
Date:   Mon, 24 Oct 2022 17:12:17 +0800
Message-Id: <20221024091223.42631-19-likexu@tencent.com>
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

Although AMD and Intel's pmu have the same semantics in terms of
global control features (including ctl and status), their msr indexes
are not the same, and the tests can be fully reused by adding helpers.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/pmu.c |  3 +++
 lib/x86/pmu.h | 33 +++++++++++++++++++++++++++++++++
 x86/pmu.c     | 31 +++++++++++++------------------
 3 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 0ce1691..3b6be37 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -10,5 +10,8 @@ void pmu_init(void)
         pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
     pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
     pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
+    pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
+    pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
+    pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
     reset_all_counters();
 }
\ No newline at end of file
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 564b672..ef83934 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -37,6 +37,9 @@ struct pmu_caps {
     u64 perf_cap;
     u32 msr_gp_counter_base;
     u32 msr_gp_event_select_base;
+    u32 msr_global_status;
+    u32 msr_global_ctl;
+    u32 msr_global_status_clr;
 };
 
 extern struct cpuid cpuid_10;
@@ -194,4 +197,34 @@ static inline void reset_all_counters(void)
     reset_all_fixed_counters();
 }
 
+static inline void pmu_clear_global_status(void)
+{
+	wrmsr(pmu.msr_global_status_clr, rdmsr(pmu.msr_global_status));
+}
+
+static inline u64 pmu_get_global_status(void)
+{
+	return rdmsr(pmu.msr_global_status);
+}
+
+static inline u64 pmu_get_global_enable(void)
+{
+	return rdmsr(pmu.msr_global_ctl);
+}
+
+static inline void pmu_set_global_enable(u64 bitmask)
+{
+	wrmsr(pmu.msr_global_ctl, bitmask);
+}
+
+static inline void pmu_reset_global_enable(void)
+{
+	wrmsr(pmu.msr_global_ctl, 0);
+}
+
+static inline void pmu_ack_global_status(u64 value)
+{
+	wrmsr(pmu.msr_global_status_clr, value);
+}
+
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu.c b/x86/pmu.c
index 7786b49..015591f 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -103,15 +103,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 static void global_enable(pmu_counter_t *cnt)
 {
 	cnt->idx = event_to_global_idx(cnt);
-
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) |
-			(1ull << cnt->idx));
+	pmu_set_global_enable(pmu_get_global_enable() | BIT_ULL(cnt->idx));
 }
 
 static void global_disable(pmu_counter_t *cnt)
 {
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
-			~(1ull << cnt->idx));
+	pmu_set_global_enable(pmu_get_global_enable() & ~BIT_ULL(cnt->idx));
 }
 
 static void __start_event(pmu_counter_t *evt, uint64_t count)
@@ -289,7 +286,7 @@ static void check_counter_overflow(void)
 	overflow_preset = measure_for_overflow(&cnt);
 
 	/* clear status before test */
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	pmu_clear_global_status();
 
 	report_prefix_push("overflow");
 
@@ -316,10 +313,10 @@ static void check_counter_overflow(void)
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
 		report(cnt.count == 1, "cntr-%d", i);
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		status = pmu_get_global_status();
 		report(status & (1ull << idx), "status-%d", i);
-		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, status);
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		pmu_ack_global_status(status);
+		status = pmu_get_global_status();
 		report(!(status & (1ull << idx)), "status clear-%d", i);
 		report(check_irq() == (i % 2), "irq-%d", i);
 	}
@@ -428,8 +425,7 @@ static void check_running_counter_wrmsr(void)
 	report(evt.count < gp_events[1].min, "cntr");
 
 	/* clear status before overflow test */
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	pmu_clear_global_status();
 
 	start_event(&evt);
 
@@ -441,8 +437,8 @@ static void check_running_counter_wrmsr(void)
 
 	loop();
 	stop_event(&evt);
-	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
-	report(status & 1, "status");
+	status = pmu_get_global_status();
+	report(status & 1, "status msr bit");
 
 	report_prefix_pop();
 }
@@ -462,8 +458,7 @@ static void check_emulated_instr(void)
 	};
 	report_prefix_push("emulated instruction");
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	pmu_clear_global_status();
 
 	start_event(&brnch_cnt);
 	start_event(&instr_cnt);
@@ -497,7 +492,7 @@ static void check_emulated_instr(void)
 		:
 		: "eax", "ebx", "ecx", "edx");
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	pmu_reset_global_enable();
 
 	stop_event(&brnch_cnt);
 	stop_event(&instr_cnt);
@@ -509,7 +504,7 @@ static void check_emulated_instr(void)
 	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
 	       "branch count");
 	// Additionally check that those counters overflowed properly.
-	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+	status = pmu_get_global_status();
 	report(status & 1, "branch counter overflow");
 	report(status & 2, "instruction counter overflow");
 
@@ -598,7 +593,7 @@ static void set_ref_cycle_expectations(void)
 	if (!pmu_nr_gp_counters() || !pmu_gp_counter_is_available(2))
 		return;
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	pmu_reset_global_enable();
 
 	t0 = fenced_rdtsc();
 	start_event(&cnt);
-- 
2.38.1

