Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A0C6170F3
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiKBWwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiKBWwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:52:03 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BB611467
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x16-20020a63b210000000b0045f5c1e18d0so77041pge.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aqJDVyR8/MDemu+PJclGjzcno9FKeDdVTq85phDEoFI=;
        b=jshLkFsr2bEheaywOJ/9TqfYAp1AzT8OIGCT4LGcWMZQctsI6AiOr6l27KHk4upQ5y
         b1zqFEeznw2kkJllD56Bl/DTPvVuFUAG12R9E2mZ+Kfl30JK347K0sMhZgWp31YhSpyL
         1iJWZB//5nTyot+zcZqd5TDcHL6RBwJ367xXAltkUbEHXd9VnnQTpByKF7Vougrbfyvz
         IgivSDNhqqzJnELXW7AKuSZ5s4ESZ03FbMZcmaWCo00n0c8fZOfD6oggfGlQay7EbKN9
         K1ZM0vfis0IlwDbMzui96PNCT9MC9rQguRbENG1CbIeMDotpyXyG1o06DHs024DN1bbk
         +QgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aqJDVyR8/MDemu+PJclGjzcno9FKeDdVTq85phDEoFI=;
        b=z8I1TPidPeMrllv8P72ndv69GA3mt9pnYSFNDVJ9P/k5pIF4zGHbHT93mIbHJt/vBE
         mh2AXjksL9kcbV/PqUqoz3dc+azpQ8XCQe7lpz2TQUHNrEJW3jq6fyIKaF/M1JciQc+r
         lFgwxCWNcoNVAC2u9R3t0aSjfqiGtGzJKxMnl26gc1wxJL43vQ2B6J1ABPyL/fxctT8D
         fFxwpwvBURY7RB3lm9QicSWjBa0OxvMYR1ThviKx/PLlsDuVR9EO2VEQToYJrl7uu4vE
         tuMwU21zFX1lV/V/GzgWCkO+UIKIeMF/utAOenZP1xgCSuC5Di3pfI4viKMvA8ny0jUc
         F4RQ==
X-Gm-Message-State: ACrzQf0kfBd1AeLck/WyNOTFSoTKWyLXzkCSztaqHeDWLn4MeNlrTSfb
        9oY2R1JHtnsw7gocHzB4abLjSlm4ZnQ=
X-Google-Smtp-Source: AMsMyM4jyHZ14MD3oi0rQJg/XSBMwqOFGwufpEVGE0PhLV1MwrKY/NVr9w0TNLT9kcYmFOjuZMWCGmAWQA8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:27a0:b0:566:9cd9:3843 with SMTP id
 bd32-20020a056a0027a000b005669cd93843mr27462599pfb.17.1667429510000; Wed, 02
 Nov 2022 15:51:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:04 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-22-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 21/27] x86/pmu: Track global
 status/control/clear MSRs in pmu_caps
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

Track the global PMU MSRs in pmu_caps so that tests don't need to manually
differntiate between AMD and Intel.  Although AMD and Intel PMUs have the
same semantics in terms of global control features (including ctl and
status), their MSR indexes are not the same

Signed-off-by: Like Xu <likexu@tencent.com>
[sean: drop most getters/setters]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c |  3 +++
 lib/x86/pmu.h |  9 +++++++++
 x86/pmu.c     | 31 +++++++++++++------------------
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index fb9a121e..0a69a3c6 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -24,6 +24,9 @@ void pmu_init(void)
 		pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
 	pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
 	pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
+	pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
+	pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
+	pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
 
 	pmu_reset_all_counters();
 }
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index cd81f557..cc643a7f 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -44,6 +44,10 @@ struct pmu_caps {
 	u32 msr_gp_counter_base;
 	u32 msr_gp_event_select_base;
 
+	u32 msr_global_status;
+	u32 msr_global_ctl;
+	u32 msr_global_status_clr;
+
 	u64 perf_cap;
 };
 
@@ -124,4 +128,9 @@ static inline void pmu_reset_all_counters(void)
 	pmu_reset_all_fixed_counters();
 }
 
+static inline void pmu_clear_global_status(void)
+{
+	wrmsr(pmu.msr_global_status_clr, rdmsr(pmu.msr_global_status));
+}
+
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu.c b/x86/pmu.c
index eb83c407..3cca5b9c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -103,15 +103,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 static void global_enable(pmu_counter_t *cnt)
 {
 	cnt->idx = event_to_global_idx(cnt);
-
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) |
-			(1ull << cnt->idx));
+	wrmsr(pmu.msr_global_ctl, rdmsr(pmu.msr_global_ctl) | BIT_ULL(cnt->idx));
 }
 
 static void global_disable(pmu_counter_t *cnt)
 {
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
-			~(1ull << cnt->idx));
+	wrmsr(pmu.msr_global_ctl, rdmsr(pmu.msr_global_ctl) & ~BIT_ULL(cnt->idx));
 }
 
 static void __start_event(pmu_counter_t *evt, uint64_t count)
@@ -286,7 +283,7 @@ static void check_counter_overflow(void)
 	overflow_preset = measure_for_overflow(&cnt);
 
 	/* clear status before test */
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	pmu_clear_global_status();
 
 	report_prefix_push("overflow");
 
@@ -313,10 +310,10 @@ static void check_counter_overflow(void)
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
 		report(cnt.count == 1, "cntr-%d", i);
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		status = rdmsr(pmu.msr_global_status);
 		report(status & (1ull << idx), "status-%d", i);
-		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, status);
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		wrmsr(pmu.msr_global_status_clr, status);
+		status = rdmsr(pmu.msr_global_status);
 		report(!(status & (1ull << idx)), "status clear-%d", i);
 		report(check_irq() == (i % 2), "irq-%d", i);
 	}
@@ -421,8 +418,7 @@ static void check_running_counter_wrmsr(void)
 	report(evt.count < gp_events[1].min, "cntr");
 
 	/* clear status before overflow test */
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	pmu_clear_global_status();
 
 	start_event(&evt);
 
@@ -434,8 +430,8 @@ static void check_running_counter_wrmsr(void)
 
 	loop();
 	stop_event(&evt);
-	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
-	report(status & 1, "status");
+	status = rdmsr(pmu.msr_global_status);
+	report(status & 1, "status msr bit");
 
 	report_prefix_pop();
 }
@@ -455,8 +451,7 @@ static void check_emulated_instr(void)
 	};
 	report_prefix_push("emulated instruction");
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	pmu_clear_global_status();
 
 	start_event(&brnch_cnt);
 	start_event(&instr_cnt);
@@ -490,7 +485,7 @@ static void check_emulated_instr(void)
 		:
 		: "eax", "ebx", "ecx", "edx");
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	wrmsr(pmu.msr_global_ctl, 0);
 
 	stop_event(&brnch_cnt);
 	stop_event(&instr_cnt);
@@ -502,7 +497,7 @@ static void check_emulated_instr(void)
 	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
 	       "branch count");
 	// Additionally check that those counters overflowed properly.
-	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+	status = rdmsr(pmu.msr_global_status);
 	report(status & 1, "branch counter overflow");
 	report(status & 2, "instruction counter overflow");
 
@@ -590,7 +585,7 @@ static void set_ref_cycle_expectations(void)
 	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
 		return;
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	wrmsr(pmu.msr_global_ctl, 0);
 
 	t0 = fenced_rdtsc();
 	start_event(&cnt);
-- 
2.38.1.431.g37b22c650d-goog

