Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A59B6170F7
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiKBWwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiKBWwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:52:06 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B7B1181A
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:58 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-348608c1cd3so281307b3.10
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=W++GGh+DB64T8mGjyKpK8ZHBTBkGXFLmW4/vAnmYs9I=;
        b=CTxWiyZ6Ie4BTbInLB/pBTtahI9E3dhK52VK+Rd380t5lB+p6M2sY13DgQ+j6PANOZ
         /cIPkJIXLS5Sx8tyDC7LlnTLxvhNKmmfDF0+2e/dbxmQelbs3Y6rMs4VoRoq1aXCItMd
         iDISIhagL8Cy1DaZZNVguomr9Qn5S5/zQde4dMXMMkXzfdDi273caTXjior9l8kFTsWt
         mBr0CsD1DXykMDxZlMTcRO3tQ2+i6X0ngQ9HoiYF7c8r++8zSaAAvjN+hxZ0eEku5YAX
         mn4mFTYOW1AAwakccm8plwjL1qe8DpiGIcHj8i3v/nS2vYQaxZFoLyeX2tfqoIJbUgRL
         1DRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W++GGh+DB64T8mGjyKpK8ZHBTBkGXFLmW4/vAnmYs9I=;
        b=037l6VF1bdpwVUQDxHpmAJYcdQ22laR3lloH5jJMcJJ7cCE7GJF4f3jo6urGkPxaml
         GmNLCmSLHXc36/bOJLFiMOtIPZb3op5p/BMcgMXDL24iZCUGbs2IxTj2IaB26Pza6cN8
         UpqdGvJ30LEih5p2qGUlyaelJbtgL2cIvoSRaciQ6HbBFc1nUffEcoFuqWTuoOnnoZIN
         9KZLjKOSn7vyWxa92UfYDxIYbjEPEZm8J/IgIMuNfoCVCyd8CQgXD8cmAYVUcFrfisE3
         Zn7Wgg4HKxKnpiq8WZwEfVGRVZMm8uXBXO2kcHyq8on/CwpwZqObYbNhBaL97zzM3K8i
         blpA==
X-Gm-Message-State: ACrzQf0/pSry4BTU733tH3y2chbK7CcMf2a+KpmUhAe4y8z1cl5Da0eo
        H2yvsDLdxb4ClzwiYi7TPBMxiHVRrS4=
X-Google-Smtp-Source: AMsMyM6vruFKhUPxiovzfrTu2xVXUDScg/Zk02h9kbQiwcDpCHMzTdrHc0VQCLWb9fgAGgIaEAl+ygG3a+U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:124f:b0:66e:e3da:487e with SMTP id
 t15-20020a056902124f00b0066ee3da487emr27618583ybu.310.1667429513193; Wed, 02
 Nov 2022 15:51:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:06 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-24-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 23/27] x86/pmu: Add global helpers to cover
 Intel Arch PMU Version 1
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

To test Intel arch pmu version 1, most of the basic framework and
use cases which test any PMU counter do not require any changes,
except no access to registers introduced only in PMU version 2.

Adding some guardian's checks can seamlessly support version 1,
while opening the door for normal AMD PMUs tests.

Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c |  9 ++++++---
 lib/x86/pmu.h |  5 +++++
 x86/pmu.c     | 47 +++++++++++++++++++++++++++++++----------------
 3 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 0a69a3c6..ea4859df 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -24,9 +24,12 @@ void pmu_init(void)
 		pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
 	pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
 	pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
-	pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
-	pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
-	pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+
+	if (this_cpu_has_perf_global_status()) {
+		pmu.msr_global_status = MSR_CORE_PERF_GLOBAL_STATUS;
+		pmu.msr_global_ctl = MSR_CORE_PERF_GLOBAL_CTRL;
+		pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+	}
 
 	pmu_reset_all_counters();
 }
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 885b53f1..e2c0bdf4 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -89,6 +89,11 @@ static inline bool this_cpu_has_perf_global_ctrl(void)
 	return pmu.version > 1;
 }
 
+static inline bool this_cpu_has_perf_global_status(void)
+{
+	return pmu.version > 1;
+}
+
 static inline bool pmu_gp_counter_is_available(int i)
 {
 	return pmu.gp_counter_available & BIT(i);
diff --git a/x86/pmu.c b/x86/pmu.c
index 3cca5b9c..7f200658 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -102,12 +102,18 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 
 static void global_enable(pmu_counter_t *cnt)
 {
+	if (!this_cpu_has_perf_global_ctrl())
+		return;
+
 	cnt->idx = event_to_global_idx(cnt);
 	wrmsr(pmu.msr_global_ctl, rdmsr(pmu.msr_global_ctl) | BIT_ULL(cnt->idx));
 }
 
 static void global_disable(pmu_counter_t *cnt)
 {
+	if (!this_cpu_has_perf_global_ctrl())
+		return;
+
 	wrmsr(pmu.msr_global_ctl, rdmsr(pmu.msr_global_ctl) & ~BIT_ULL(cnt->idx));
 }
 
@@ -283,7 +289,8 @@ static void check_counter_overflow(void)
 	overflow_preset = measure_for_overflow(&cnt);
 
 	/* clear status before test */
-	pmu_clear_global_status();
+	if (this_cpu_has_perf_global_status())
+		pmu_clear_global_status();
 
 	report_prefix_push("overflow");
 
@@ -310,6 +317,10 @@ static void check_counter_overflow(void)
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
 		report(cnt.count == 1, "cntr-%d", i);
+
+		if (!this_cpu_has_perf_global_status())
+			continue;
+
 		status = rdmsr(pmu.msr_global_status);
 		report(status & (1ull << idx), "status-%d", i);
 		wrmsr(pmu.msr_global_status_clr, status);
@@ -418,7 +429,8 @@ static void check_running_counter_wrmsr(void)
 	report(evt.count < gp_events[1].min, "cntr");
 
 	/* clear status before overflow test */
-	pmu_clear_global_status();
+	if (this_cpu_has_perf_global_status())
+		pmu_clear_global_status();
 
 	start_event(&evt);
 
@@ -430,8 +442,11 @@ static void check_running_counter_wrmsr(void)
 
 	loop();
 	stop_event(&evt);
-	status = rdmsr(pmu.msr_global_status);
-	report(status & 1, "status msr bit");
+
+	if (this_cpu_has_perf_global_status()) {
+		status = rdmsr(pmu.msr_global_status);
+		report(status & 1, "status msr bit");
+	}
 
 	report_prefix_pop();
 }
@@ -451,7 +466,8 @@ static void check_emulated_instr(void)
 	};
 	report_prefix_push("emulated instruction");
 
-	pmu_clear_global_status();
+	if (this_cpu_has_perf_global_status())
+		pmu_clear_global_status();
 
 	start_event(&brnch_cnt);
 	start_event(&instr_cnt);
@@ -485,7 +501,8 @@ static void check_emulated_instr(void)
 		:
 		: "eax", "ebx", "ecx", "edx");
 
-	wrmsr(pmu.msr_global_ctl, 0);
+	if (this_cpu_has_perf_global_ctrl())
+		wrmsr(pmu.msr_global_ctl, 0);
 
 	stop_event(&brnch_cnt);
 	stop_event(&instr_cnt);
@@ -496,10 +513,12 @@ static void check_emulated_instr(void)
 	       "instruction count");
 	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
 	       "branch count");
-	// Additionally check that those counters overflowed properly.
-	status = rdmsr(pmu.msr_global_status);
-	report(status & 1, "branch counter overflow");
-	report(status & 2, "instruction counter overflow");
+	if (this_cpu_has_perf_global_status()) {
+		// Additionally check that those counters overflowed properly.
+		status = rdmsr(pmu.msr_global_status);
+		report(status & 1, "branch counter overflow");
+		report(status & 2, "instruction counter overflow");
+	}
 
 	report_prefix_pop();
 }
@@ -585,7 +604,8 @@ static void set_ref_cycle_expectations(void)
 	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
 		return;
 
-	wrmsr(pmu.msr_global_ctl, 0);
+	if (this_cpu_has_perf_global_ctrl())
+		wrmsr(pmu.msr_global_ctl, 0);
 
 	t0 = fenced_rdtsc();
 	start_event(&cnt);
@@ -636,11 +656,6 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
-	if (pmu.version == 1) {
-		report_skip("PMU version 1 is not supported.");
-		return report_summary();
-	}
-
 	set_ref_cycle_expectations();
 
 	printf("PMU version:         %d\n", pmu.version);
-- 
2.38.1.431.g37b22c650d-goog

