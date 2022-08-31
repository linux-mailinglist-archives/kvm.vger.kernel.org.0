Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000835A7984
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiHaIyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiHaIxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:53:55 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CC2C9259;
        Wed, 31 Aug 2022 01:53:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p18so13513969plr.8;
        Wed, 31 Aug 2022 01:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=gDuWmSP1BE6Srfu1dJWvvdDAMEOps0ym11WanWVP6BA=;
        b=OI40+/eIKMqWFL1WqscdIgiizJoDVmAMYC+b2MRH3AVNE3p0QshhGbXMarH0q0bOox
         HycYXXZX+VuOD7NBdrwA01RsPaRCsV7ked8GR7TLwcF17iNwAeuHq7O/mKYJlTKQy7N2
         i0V3gckJe/6FXBihyFos6RxkL4X5wKcLY7QzwHMzjDpzFCS3N8fMvTmuIj0ZF910eCOo
         Hwvlgdz4RFdJKqWdv9WY00OT6hbaWC1meWnu3m3xzeTQqo7eEpiYZJVyueQXoE6k1r4b
         h7q5AQqD5tsi6Xt9vGFvkD8Gdm1PXxpd4Cl7cKMPJ1eB9fn/qbbbP49xvnA3Neq8uemI
         kxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=gDuWmSP1BE6Srfu1dJWvvdDAMEOps0ym11WanWVP6BA=;
        b=RrURq4TRF4V1CyraDVb2/njxGhevf6K8jkSq6lhzlbWamnrUNtw2dkWqdMXgorZ7UM
         ophU/WOVmBLYqdTASOP2smPkADo4d8vlqF2WjFUWwlMtrZEntVkNwaRTc70gGU9C7TCv
         URXa4+IQ5yRL21aw/FL8Bbhvk2MxtMqSXxixJewKK+8RjXLPqxxCeTZselPDneLJzawJ
         S4BK/kuGIi2HP48tIrmnrE5kzcUk+xAC9pImQyKrJ9f9XDYV5e6wspWOvAlYpfPwCLH1
         o/LbZMaHdFNz5KrqTdBW0wgUfY+giXRQHXqG0BoluLZG8vquzmEHBf+7Q+eslmN7kelj
         VbIQ==
X-Gm-Message-State: ACgBeo0rzvu1eBZEZZZfHPNMIazAgjbQeAC7cRACW0ED3x72fSGfsSzQ
        Oi4FX8c0iXfCxUfskH3g0CY=
X-Google-Smtp-Source: AA6agR477QpgtTTJ4QYHNQZc00xn+dTZFYw1GMIHBos87wE1oL2/KNnU9ffAnxal3UzFPa3UgU0+1Q==
X-Received: by 2002:a17:902:ccc9:b0:174:de2b:b19a with SMTP id z9-20020a170902ccc900b00174de2bb19amr11706067ple.100.1661936033484;
        Wed, 31 Aug 2022 01:53:53 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a1a1a00b001fab208523esm868772pjk.3.2022.08.31.01.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 01:53:53 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/7] KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
Date:   Wed, 31 Aug 2022 16:53:25 +0800
Message-Id: <20220831085328.45489-5-likexu@tencent.com>
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

Batch reprogramming PMU counters by setting KVM_REQ_PMU and thus
deferring reprogramming kvm_pmu_handle_event() to avoid reprogramming
a counter multiple times during a single VM-Exit.

Deferring programming will also allow KVM to fix a bug where immediately
reprogramming a counter can result in sleeping (taking a mutex) while
interrupts are disabled in the VM-Exit fastpath.

Introducing kvm_pmu_request_counter_reprogam() to make it obvious that
KVM is _requesting_ a reprogram and not actually doing the reprogram.

Opportunistically refine related comments to avoid misunderstandings.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 11 ++++++-----
 arch/x86/kvm/pmu.h              |  6 +++++-
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  6 +++---
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..4e568a7ef464 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -493,6 +493,7 @@ struct kvm_pmc {
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
 	/*
+	 * only for creating or reusing perf_event,
 	 * eventsel value for general purpose counters,
 	 * ctrl value for fixed counters.
 	 */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d9b9a0f0db17..7f391750ebd3 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -101,7 +101,6 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	bool skip_pmi = false;
 
-	/* Ignore counters that have been reprogrammed already. */
 	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
 		return;
 
@@ -293,7 +292,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_counter(struct kvm_pmc *pmc)
+static void reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u64 eventsel = pmc->eventsel;
@@ -335,7 +334,6 @@ void reprogram_counter(struct kvm_pmc *pmc)
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
 			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
-EXPORT_SYMBOL_GPL(reprogram_counter);
 
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
@@ -345,10 +343,11 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
 		struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit);
 
-		if (unlikely(!pmc || !pmc->perf_event)) {
+		if (unlikely(!pmc)) {
 			clear_bit(bit, pmu->reprogram_pmi);
 			continue;
 		}
+
 		reprogram_counter(pmc);
 	}
 
@@ -542,7 +541,9 @@ static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 {
 	bool select_os, select_user;
-	u64 config = pmc->current_config;
+	u64 config = pmc_is_gp(pmc) ? pmc->eventsel :
+		(u64)fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
+				      pmc->idx - INTEL_PMC_IDX_FIXED);
 
 	if (pmc_is_gp(pmc)) {
 		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5cc5721f260b..847e7112a5d3 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -183,7 +183,11 @@ static inline void kvm_init_pmu_capability(void)
 					     KVM_PMC_MAX_FIXED);
 }
 
-void reprogram_counter(struct kvm_pmc *pmc);
+static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
+{
+	__set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
+	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+}
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index f24613a108c5..70219c19b872 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -238,7 +238,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
-			reprogram_counter(pmc);
+			kvm_pmu_request_counter_reprogam(pmc);
 		}
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6242b0b81116..863a6ff9e214 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -52,7 +52,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
 
 		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
-		reprogram_counter(pmc);
+		kvm_pmu_request_counter_reprogam(pmc);
 	}
 }
 
@@ -76,7 +76,7 @@ static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 		if (pmc)
-			reprogram_counter(pmc);
+			kvm_pmu_request_counter_reprogam(pmc);
 	}
 }
 
@@ -477,7 +477,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
 			if (!(data & reserved_bits)) {
 				pmc->eventsel = data;
-				reprogram_counter(pmc);
+				kvm_pmu_request_counter_reprogam(pmc);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-- 
2.37.3

