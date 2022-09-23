Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805765E708D
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 02:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiIWAOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 20:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiIWAOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 20:14:11 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA21106534
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:14:10 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id m10-20020a170902db0a00b001789bd49db9so7026344plx.23
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=EzYkgN8mabakGnvYj+N48jsNX6a8/81bGRaQci8iJjQ=;
        b=aNLw7jyaLlbqLQteGB5ehmKXP57MyrZ038jjncK+m8lWrgBzi7q3XZa//tAT+Ua9XK
         tWAiYF4q3CcF07V04BwKJnZS52xB6NBnjmrptFm1tBtO6Z2juurrkaKosLHW9R9eouzU
         GdEKAHhfL/mHP1gwRRIx7chgyjW8hoRBweHgDc2zoQ+PzsbtgfMuYxLVOPKmlhriXT3L
         tQs0vNt553TEIRrNiQBpBHfuc5zHZAtqlU69QBdk+vc9Rdx50nn/8A1IeWe6whe2PKem
         Lrt3BKz53b15J5MEoALRIMs1WoSVNY5LGiOO+jiaoyzAU3TEq4qJoFlMV7J8tqOQ4RDJ
         dB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=EzYkgN8mabakGnvYj+N48jsNX6a8/81bGRaQci8iJjQ=;
        b=fZCDMJUCx2qsKpmSIDI93bmDnUjbaXjAOADHgKjEXg0TKM0YnpisacJwK5h6c82F+/
         0pP8thBAZ8OPGWWnPB/h7qpUS0uSVIuwAQecic3xUfVHY5jsMw1eABLztZTW2NurcJGs
         pUdMNpu57YHbsg7Ks2nt07aaBemfBposoj7mL6bYE+dN2DcGfwwPub1KPEpUR5INHKHY
         rc5Ar1YrQNOF3Ht96rSnGttxkvQzX26Y+szppHdnaTkTkGrnFQltkYv5jRVz9jB+2Ski
         x85/GRqQrNybiTOGtBFSHPtrzkyMYge4JNo8DKh+OtkToqRJOtbhte+CsyP83YEci8rs
         5JHw==
X-Gm-Message-State: ACrzQf0dBrv9sTMC4TcFbyi5cN1CWrt1NIBIjsUwHKey7Ql/QT3vqrva
        ZAxbEeVzouV9TzX7yAGcGu74ttI0oI0=
X-Google-Smtp-Source: AMsMyM4phjE663nw9ogfVflbHCX+eO8lLiQBp7ZCmqUDUmna3PKoffErmx3DpUfId/cYrbhyW5w9HEyaxy0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2ce:b0:178:7b5:c070 with SMTP id
 n14-20020a170902d2ce00b0017807b5c070mr5827561plc.58.1663892049838; Thu, 22
 Sep 2022 17:14:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Sep 2022 00:13:54 +0000
In-Reply-To: <20220923001355.3741194-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220923001355.3741194-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220923001355.3741194-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
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

Batch reprogramming PMU counters by setting KVM_REQ_PMU and thus
deferring reprogramming kvm_pmu_handle_event() to avoid reprogramming
a counter multiple times during a single VM-Exit.

Deferring programming will also allow KVM to fix a bug where immediately
reprogramming a counter can result in sleeping (taking a mutex) while
interrupts are disabled in the VM-Exit fastpath.

Introduce kvm_pmu_request_counter_reprogam() to make it obvious that
KVM is _requesting_ a reprogram and not actually doing the reprogram.

Opportunistically refine related comments to avoid misunderstandings.

Signed-off-by: Like Xu <likexu@tencent.com>
Link: https://lore.kernel.org/r/20220831085328.45489-5-likexu@tencent.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 17 ++++++++++++-----
 arch/x86/kvm/pmu.h              |  6 +++++-
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  6 +++---
 5 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 462f041ede9f..12dcfc9330e7 100644
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
index 4cd99320019b..d8330e6064ab 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -101,7 +101,11 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	bool skip_pmi = false;
 
-	/* Ignore counters that have been reprogrammed already. */
+	/*
+	 * Ignore overflow events for counters that are scheduled to be
+	 * reprogrammed, e.g. if a PMI for the previous event races with KVM's
+	 * handling of a related guest WRMSR.
+	 */
 	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
 		return;
 
@@ -292,7 +296,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_counter(struct kvm_pmc *pmc)
+static void reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u64 eventsel = pmc->eventsel;
@@ -345,7 +349,6 @@ void reprogram_counter(struct kvm_pmc *pmc)
 reprogram_complete:
 	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
 }
-EXPORT_SYMBOL_GPL(reprogram_counter);
 
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
@@ -355,10 +358,11 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
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
 
@@ -552,12 +556,15 @@ static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 {
 	bool select_os, select_user;
-	u64 config = pmc->current_config;
+	u64 config;
 
 	if (pmc_is_gp(pmc)) {
+		config = pmc->eventsel;
 		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
 		select_user = config & ARCH_PERFMON_EVENTSEL_USR;
 	} else {
+		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
+					  pmc->idx - INTEL_PMC_IDX_FIXED);
 		select_os = config & 0x1;
 		select_user = config & 0x2;
 	}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5cc5721f260b..85ff3c0588ba 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -183,7 +183,11 @@ static inline void kvm_init_pmu_capability(void)
 					     KVM_PMC_MAX_FIXED);
 }
 
-void reprogram_counter(struct kvm_pmc *pmc);
+static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
+{
+	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
+	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+}
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b68956299fa8..041aa898e1bc 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -159,7 +159,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
-			reprogram_counter(pmc);
+			kvm_pmu_request_counter_reprogam(pmc);
 		}
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 25b70a85bef5..e38518afc265 100644
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
2.37.3.998.g577e59143f-goog

