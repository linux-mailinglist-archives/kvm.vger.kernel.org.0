Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB05A7983
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiHaIyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiHaIxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:53:53 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39390CAC65;
        Wed, 31 Aug 2022 01:53:52 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d12so13519488plr.6;
        Wed, 31 Aug 2022 01:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=n4xJJQm16hxaBCpj8YKFv/yui3kLzCuA1z3ufWBUg3c=;
        b=pXl4nL3Ns57dEP1Rlyt00cG4GpWjsssRkrOLB2WSCJlb7ttj4sYoS0SYXrPOuwoQ1R
         Duqbsr2KcHjgiZbNcJJfPRNK6KNZPIoVTo4XvjTOEkmJt1iylG5dDMQhWyKR+RHhBeqC
         hhv9wsZ1aw4k0adebJQe0BdPMkzYPKSIUXL/yJ6bwyxHTKg+AhmG9s0P4A7zyY+gXE3d
         dTz3JnKgLWa0NMDKgNmU2RMiMt0jC5hKWMQS7Xk83dVGaN2oNcXxOfHK5zYrJnCBXkjp
         LRgsNTISaF23t54AKQqu6zjRe45OLzLELCg41Lp8Sm2+4M/7ZuwD0jzZpWl37RS6pB36
         uoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=n4xJJQm16hxaBCpj8YKFv/yui3kLzCuA1z3ufWBUg3c=;
        b=Tg4nVJd8r2Dv46/8JR/hrj3VwBBs36o/DqoYvsC6N2KYIOsaAD9dHLs/53IXplZE/E
         9R/i03cpE6IHmI7d5F3FkA2165ca7+Crg2ZWvsfAyTGaWU6YzZ8aH8DnDG4OmWyloA3h
         wXpQExJsIxDfWoO5Ne3B/ecYvK+YDs32Ot+mqtR3tugu+4yBRlw9VmqXFP2cJG7jo/n+
         2IwSq68Q8+KP19NLpcpKzzldisvnGtZplE98S5ZU45kOumdJzgtdEBLCEzyR9PMIMZGL
         uPiH+TmJ8s6Qt0R6YTJh5jCIEyvl4i/VlR0zbvrrsi+VE6AogAQXfFyQuTRaHVswvkpM
         sjVw==
X-Gm-Message-State: ACgBeo2xDEJIIBAZxkQEcdJnRHjyclmr5qVcsN7ggdxLmA4oS9HZ0yK0
        x+7e+JV/QZu1/zuSkW0c51c=
X-Google-Smtp-Source: AA6agR5NPOoN7Rb/jnDVS4jLTMlettiK675j5edx1RbIoI99uHmqrF57PqAXEKel5KNJALcyV6iU4g==
X-Received: by 2002:a17:902:e80a:b0:175:41cd:2684 with SMTP id u10-20020a170902e80a00b0017541cd2684mr2518738plg.159.1661936031884;
        Wed, 31 Aug 2022 01:53:51 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a1a1a00b001fab208523esm868772pjk.3.2022.08.31.01.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 01:53:51 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/7] KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
Date:   Wed, 31 Aug 2022 16:53:24 +0800
Message-Id: <20220831085328.45489-4-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220831085328.45489-1-likexu@tencent.com>
References: <20220831085328.45489-1-likexu@tencent.com>
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

The check logic in the pmc_resume_counter() to determine whether
a perf_event is reusable is partial and flawed, especially when it
comes to a pseudocode sequence (not correct but clearly valid) like:

  - enabling a counter and its PEBS bit
  - enable global_ctrl
  - run workload
  - disable only the PEBS bit, leaving the global_ctrl bit enabled

In this corner case, a perf_event created for PEBS can be reused by
a normal counter before it has been released and recreated, and when this
normal counter overflows, it triggers a PEBS interrupt (precise_ip != 0).

To address this issue, the reuse check has been revamped and KVM will
go back to do reprogram_counter() when any bit of guest PEBS_ENABLE
msr has changed, which is similar to what global_ctrl_changed() does.

Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           |  4 ++--
 arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 390d697efde1..d9b9a0f0db17 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -237,8 +237,8 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
-	if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
-	    pmc->perf_event->attr.precise_ip)
+	if (test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) !=
+	    (!!pmc->perf_event->attr.precise_ip))
 		return false;
 
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d595ff33d32d..6242b0b81116 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,15 +68,11 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-/* function is called when global control register has been updated. */
-static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
+static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 {
 	int bit;
-	u64 diff = pmu->global_ctrl ^ data;
 	struct kvm_pmc *pmc;
 
-	pmu->global_ctrl = data;
-
 	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 		if (pmc)
@@ -397,7 +393,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
-	u64 reserved_bits;
+	u64 reserved_bits, diff;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -418,7 +414,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->global_ctrl == data)
 			return 0;
 		if (kvm_valid_perf_global_ctrl(pmu, data)) {
-			global_ctrl_changed(pmu, data);
+			diff = pmu->global_ctrl ^ data;
+			pmu->global_ctrl = data;
+			reprogram_counters(pmu, diff);
 			return 0;
 		}
 		break;
@@ -433,7 +431,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->pebs_enable == data)
 			return 0;
 		if (!(data & pmu->pebs_enable_mask)) {
+			diff = pmu->pebs_enable ^ data;
 			pmu->pebs_enable = data;
+			reprogram_counters(pmu, diff);
 			return 0;
 		}
 		break;
-- 
2.37.3

