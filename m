Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DAB5E7090
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 02:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiIWAOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 20:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiIWAOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 20:14:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C51106F67
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:14:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id pc10-20020a17090b3b8a00b00202be8d81d2so2423262pjb.1
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=MpGY4j2+HNaS4pIK9i1574FgHbMWXnwyl50j6Y5l4ns=;
        b=DDZQtcI8HcW4ZNwcB3YWNlpdzUNkTDOJD4Z4frFbFub3o0IvhP65RrnoMw1lrlFZli
         XUCEZU53R+VS0cb0POQZWjfl1vaQeYkVVp8MqTtMWLEpgmye3Qokzg/QaVmopGauY9pk
         gJ858vimDO428U2r0JFoiA3qceWciU/4poFF0NW0xJwE+AAWd1QzxD107Iou9uh7fnwu
         KVMc7pradILq2kMDgjY9gPlR4WNWnOL9qeKDumwMdd6lnWn/r3hDZl3C2mgb7XQnAeWY
         ZojaWYTAIZ0BmqgM4JpAbndykSPnvhAY6BTnDxePOr6ZRI9wtRe6twjp5ult/6+RN5cv
         xyaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=MpGY4j2+HNaS4pIK9i1574FgHbMWXnwyl50j6Y5l4ns=;
        b=oLhJNqWrWVNGIgLhMn7/OIPAaxNzxV7PBOMBeHlFDXnz6VPvKcTqe1OaMfwccbXuJt
         XRVXdCVAMTM2NS1+wggW/iMNgu2w+bBabl/2HMhoix5T9FT01exRuBTb6RUCarA4Bwx+
         PRUoR+i083LF6AthIva34wIHWkh6TbM4QUVthAwVNtrZDR/iy+2jHL/em0QQdcsVB4jq
         Mo2Q0MPtHKnfHkrGXO1eeC/fsB33MeCIaj4wNXkMlbsvl/tp5ZHyvk+JXqtPF9E2xvaJ
         c+L+QX7cdkcQDKH2EzHxGR5c0SL9MFeGxW3bu8Fwvan6+3kLLUxH1bYhuxX3jL2sa5HI
         4TLw==
X-Gm-Message-State: ACrzQf21CIaF7jz8lShU/U7DskabVKsSj0YIf//KdTprjQFWbGLNzZqC
        Ee8U3iNLWDKS8+49VHRD5R4L5vISQx4=
X-Google-Smtp-Source: AMsMyM6dR8YjTdbIGbobhsytlzYF4LuFcy7c0+vSn8nMZnL9q0hTWanGut+PyhNipbx1MRUNNtBJTh3lLqQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP id
 p10-20020a17090b010a00b002002849235fmr437296pjz.1.1663892051472; Thu, 22 Sep
 2022 17:14:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Sep 2022 00:13:55 +0000
In-Reply-To: <20220923001355.3741194-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220923001355.3741194-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220923001355.3741194-5-seanjc@google.com>
Subject: [PATCH 4/4] KVM: x86/pmu: Defer counter emulated overflow via pmc->prev_counter
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <likexu@tencent.com>,
        Wanpeng Li <wanpengli@tencent.com>
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

Defer reprogramming counters and handling overflow via KVM_REQ_PMU
when incrementing counters.  KVM skips emulated WRMSR in the VM-Exit
fastpath, the fastpath runs with IRQs disabled, skipping instructions
can increment and reprogram counters, reprogramming counters can
sleep, and sleeping is disallowed while IRQs are disabled.

 [*] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
 [*] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 2981888, name: CPU 15/KVM
 [*] preempt_count: 1, expected: 0
 [*] RCU nest depth: 0, expected: 0
 [*] INFO: lockdep is turned off.
 [*] irq event stamp: 0
 [*] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 [*] hardirqs last disabled at (0): [<ffffffff8121222a>] copy_process+0x146a/0x62d0
 [*] softirqs last  enabled at (0): [<ffffffff81212269>] copy_process+0x14a9/0x62d0
 [*] softirqs last disabled at (0): [<0000000000000000>] 0x0
 [*] Preemption disabled at:
 [*] [<ffffffffc2063fc1>] vcpu_enter_guest+0x1001/0x3dc0 [kvm]
 [*] CPU: 17 PID: 2981888 Comm: CPU 15/KVM Kdump: 5.19.0-rc1-g239111db364c-dirty #2
 [*] Call Trace:
 [*]  <TASK>
 [*]  dump_stack_lvl+0x6c/0x9b
 [*]  __might_resched.cold+0x22e/0x297
 [*]  __mutex_lock+0xc0/0x23b0
 [*]  perf_event_ctx_lock_nested+0x18f/0x340
 [*]  perf_event_pause+0x1a/0x110
 [*]  reprogram_counter+0x2af/0x1490 [kvm]
 [*]  kvm_pmu_trigger_event+0x429/0x950 [kvm]
 [*]  kvm_skip_emulated_instruction+0x48/0x90 [kvm]
 [*]  handle_fastpath_set_msr_irqoff+0x349/0x3b0 [kvm]
 [*]  vmx_vcpu_run+0x268e/0x3b80 [kvm_intel]
 [*]  vcpu_enter_guest+0x1d22/0x3dc0 [kvm]

Add a field to kvm_pmc to track the previous counter value in order
to defer overflow detection to kvm_pmu_handle_event() (the counter must
be paused before handling overflow, and that may increment the counter).

Opportunistically shrink sizeof(struct kvm_pmc) a bit.

Suggested-by: Wanpeng Li <wanpengli@tencent.com>
Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
Signed-off-by: Like Xu <likexu@tencent.com>
Link: https://lore.kernel.org/r/20220831085328.45489-6-likexu@tencent.com
[sean: avoid re-triggering KVM_REQ_PMU on overflow, tweak changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/pmu.c              | 32 ++++++++++++++++----------------
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  4 ++--
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 12dcfc9330e7..9639404f2856 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -488,7 +488,10 @@ enum pmc_type {
 struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
+	bool is_paused;
+	bool intr;
 	u64 counter;
+	u64 prev_counter;
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
@@ -498,8 +501,6 @@ struct kvm_pmc {
 	 * ctrl value for fixed counters.
 	 */
 	u64 current_config;
-	bool is_paused;
-	bool intr;
 };
 
 #define KVM_PMC_MAX_FIXED	3
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d8330e6064ab..935c9d80ab50 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -101,14 +101,6 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	bool skip_pmi = false;
 
-	/*
-	 * Ignore overflow events for counters that are scheduled to be
-	 * reprogrammed, e.g. if a PMI for the previous event races with KVM's
-	 * handling of a related guest WRMSR.
-	 */
-	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
-		return;
-
 	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
 		if (!in_pmi) {
 			/*
@@ -126,7 +118,6 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 	} else {
 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 	}
-	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
 	if (!pmc->intr || skip_pmi)
 		return;
@@ -151,7 +142,17 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 {
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 
+	/*
+	 * Ignore overflow events for counters that are scheduled to be
+	 * reprogrammed, e.g. if a PMI for the previous event races with KVM's
+	 * handling of a related guest WRMSR.
+	 */
+	if (test_and_set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi))
+		return;
+
 	__kvm_perf_overflow(pmc, true);
+
+	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
 
 static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
@@ -311,6 +312,9 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 	if (!check_pmu_event_filter(pmc))
 		goto reprogram_complete;
 
+	if (pmc->counter < pmc->prev_counter)
+		__kvm_perf_overflow(pmc, false);
+
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
 
@@ -348,6 +352,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 
 reprogram_complete:
 	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
+	pmc->prev_counter = 0;
 }
 
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
@@ -536,14 +541,9 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 
 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
-	u64 prev_count;
-
-	prev_count = pmc->counter;
+	pmc->prev_counter = pmc->counter;
 	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
-
-	reprogram_counter(pmc);
-	if (pmc->counter < prev_count)
-		__kvm_perf_overflow(pmc, false);
+	kvm_pmu_request_counter_reprogam(pmc);
 }
 
 static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 041aa898e1bc..2ec420b85d6a 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -211,7 +211,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 		struct kvm_pmc *pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
-		pmc->counter = pmc->eventsel = 0;
+		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e38518afc265..1bf5d4b00296 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -647,14 +647,14 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
-		pmc->counter = pmc->eventsel = 0;
+		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
 	}
 
 	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
 		pmc = &pmu->fixed_counters[i];
 
 		pmc_stop_counter(pmc);
-		pmc->counter = 0;
+		pmc->counter = pmc->prev_counter = 0;
 	}
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
-- 
2.37.3.998.g577e59143f-goog

