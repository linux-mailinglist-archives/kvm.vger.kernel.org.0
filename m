Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52CA4EB70A
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 01:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241173AbiC2XxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 19:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241196AbiC2Xwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 19:52:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2E7205BCC
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:51:11 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso2300953pjt.0
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=poq6HhoJ5C86Jvzu6FLzn1emdPhg3i74xPs1BHgN3lo=;
        b=FbYxYTHdbMKLV6p+W5MYMbinAsdWrgodXVcFSyNwOB3OYZ60lth5g55jSeiP4byD40
         ZQD/wuclgwcIes+Nt5TB7SOGuxXUcnbQDrBOeArU6Ws3ASIb7+nS3DjzyBtj1z35NPXt
         oqngHr4/M1Wy6JhfMB4ZxEVi/S4EMUK17NtUHmkPOB1L0QsirotMxoGbzSCPLMNf1gOo
         4FVe+6sCGrzeJhRx6BmKhxdlXjYSdIs+O3HI5HoroTu22rr9YzGGDU+5pEnf+7UB5mLE
         ABfOUgDNQ0n+rtBQOqgyK6BddM3lFT2ZiV3Vp4aIORJlZH/4Wrvdj3tch99Qe3ywX+1v
         xFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=poq6HhoJ5C86Jvzu6FLzn1emdPhg3i74xPs1BHgN3lo=;
        b=PifC3p6wAeqPuSBXmMt6wRHKZ9nowlN2uoXyR/p+aqDXMOkyHmzGBawSnKdNosaS7U
         CWRqJ3+DGEtOzOpNBPlWiaqgM1+KCUYxp6qsLqJsFXCzcDK8oo5SDReC+HuCrrVaMzT4
         GJTO6vZNdek49sKttQl73OISMc/xGRxw9y0shHc3hJ4Wbmps58mpNhS75ICk1flB//cV
         ve7LDmXZavw9nN8rCkvuznwulNaOBD34FWrp4RtIE7LBHTduTyLf2TSVKiepyu+An/Z2
         lxwxZJ0cgEY29Y6zoVVc3Ixqzs2mxpPStvhS8mIwOD7CWfjJc8t0ZIKBdMU9xA//AIij
         O4VA==
X-Gm-Message-State: AOAM531Cex92gO3wfOQdgJwrcdocVWj+Ef/oa11tad18z9C3FtemxYsq
        zXbf20iwDdcR+RZPxP1mzDQm1V7f5ZU=
X-Google-Smtp-Source: ABdhPJxNozzSCrFK/1c3W05ocHmHw/K4lDUBdSTbJsIHmX2gNG9K/ClvnDKF2ubC0OEkmnDRLVnh26RR+RQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:24c6:b0:4fd:9038:74f0 with SMTP id
 d6-20020a056a0024c600b004fd903874f0mr3483855pfv.63.1648597870721; Tue, 29 Mar
 2022 16:51:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Mar 2022 23:50:54 +0000
In-Reply-To: <20220329235054.3534728-1-seanjc@google.com>
Message-Id: <20220329235054.3534728-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220329235054.3534728-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3.1 4/4] KVM: x86: Use static calls to reduce kvm_pmu_ops overhead
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Use static calls to improve kvm_pmu_ops performance, following the same
pattern and naming scheme used by kvm-x86-ops.h.

Here are the worst fenced_rdtsc() cycles numbers for the kvm_pmu_ops
functions that is most often called (up to 7 digits of calls) when running
a single perf test case in a guest on an ICX 2.70GHz host (mitigations=on):

		|	legacy	|	static call
------------------------------------------------------------
.pmc_idx_to_pmc	|	1304840	|	994872 (+23%)
.pmc_is_enabled	|	978670	|	1011750 (-3%)
.msr_idx_to_pmc	|	47828	|	41690 (+12%)
.is_valid_msr	|	28786	|	30108 (-4%)

Signed-off-by: Like Xu <likexu@tencent.com>
[sean: Handle static call updates in pmu.c, tweak changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h | 31 ++++++++++++++
 arch/x86/kvm/pmu.c                     | 56 ++++++++++++++++----------
 2 files changed, 65 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
new file mode 100644
index 000000000000..fdfd8e06fee6
--- /dev/null
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(KVM_X86_PMU_OP) || !defined(KVM_X86_PMU_OP_OPTIONAL)
+BUILD_BUG_ON(1)
+#endif
+
+/*
+ * KVM_X86_PMU_OP() and KVM_X86_PMU_OP_OPTIONAL() are used to help generate
+ * both DECLARE/DEFINE_STATIC_CALL() invocations and
+ * "static_call_update()" calls.
+ *
+ * KVM_X86_PMU_OP_OPTIONAL() can be used for those functions that can have
+ * a NULL definition, for example if "static_call_cond()" will be used
+ * at the call sites.
+ */
+KVM_X86_PMU_OP(pmc_perf_hw_id)
+KVM_X86_PMU_OP(pmc_is_enabled)
+KVM_X86_PMU_OP(pmc_idx_to_pmc)
+KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
+KVM_X86_PMU_OP(msr_idx_to_pmc)
+KVM_X86_PMU_OP(is_valid_rdpmc_ecx)
+KVM_X86_PMU_OP(is_valid_msr)
+KVM_X86_PMU_OP(get_msr)
+KVM_X86_PMU_OP(set_msr)
+KVM_X86_PMU_OP(refresh)
+KVM_X86_PMU_OP(init)
+KVM_X86_PMU_OP(reset)
+KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
+KVM_X86_PMU_OP_OPTIONAL(cleanup)
+
+#undef KVM_X86_PMU_OP
+#undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bb0b1ad0fda5..618f529f1c4d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -51,14 +51,28 @@
 
 static struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
 
+#define KVM_X86_PMU_OP(func)					     \
+	DEFINE_STATIC_CALL_NULL(kvm_x86_pmu_##func,			     \
+				*(((struct kvm_pmu_ops *)0)->func));
+#define KVM_X86_PMU_OP_OPTIONAL KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
 {
 	memcpy(&kvm_pmu_ops, pmu_ops, sizeof(kvm_pmu_ops));
+
+#define __KVM_X86_PMU_OP(func) \
+	static_call_update(kvm_x86_pmu_##func, kvm_pmu_ops.func);
+#define KVM_X86_PMU_OP(func) \
+	WARN_ON(!kvm_pmu_ops.func); __KVM_X86_PMU_OP(func)
+#define KVM_X86_PMU_OP_OPTIONAL __KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+#undef __KVM_X86_PMU_OP
 }
 
 static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 {
-	return kvm_pmu_ops.pmc_is_enabled(pmc);
+	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
 }
 
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
@@ -225,7 +239,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_pmu_ops.pmc_perf_hw_id(pmc);
+		config = static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
@@ -275,7 +289,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_pmu_ops.pmc_perf_hw_id(pmc),
+			      static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi);
@@ -284,7 +298,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 {
-	struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, pmc_idx);
+	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, pmc_idx);
 
 	if (!pmc)
 		return;
@@ -306,7 +320,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	int bit;
 
 	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
-		struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, bit);
+		struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit);
 
 		if (unlikely(!pmc || !pmc->perf_event)) {
 			clear_bit(bit, pmu->reprogram_pmi);
@@ -328,7 +342,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 /* check if idx is a valid index to access PMU */
 bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return kvm_pmu_ops.is_valid_rdpmc_ecx(vcpu, idx);
+	return static_call(kvm_x86_pmu_is_valid_rdpmc_ecx)(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -378,7 +392,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_pmu_ops.rdpmc_ecx_to_pmc(vcpu, idx, &mask);
+	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -394,22 +408,21 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu)) {
-		if (kvm_pmu_ops.deliver_pmi)
-			kvm_pmu_ops.deliver_pmi(vcpu);
+		static_call_cond(kvm_x86_pmu_deliver_pmi)(vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
 	}
 }
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
-	return kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr) ||
-		kvm_pmu_ops.is_valid_msr(vcpu, msr);
+	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
+		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
 }
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr);
+	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -417,13 +430,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	return kvm_pmu_ops.get_msr(vcpu, msr_info);
+	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
-	return kvm_pmu_ops.set_msr(vcpu, msr_info);
+	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
 }
 
 /* refresh PMU settings. This function generally is called when underlying
@@ -432,7 +445,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
-	kvm_pmu_ops.refresh(vcpu);
+	static_call(kvm_x86_pmu_refresh)(vcpu);
 }
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
@@ -440,7 +453,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	irq_work_sync(&pmu->irq_work);
-	kvm_pmu_ops.reset(vcpu);
+	static_call(kvm_x86_pmu_reset)(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
@@ -448,7 +461,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	kvm_pmu_ops.init(vcpu);
+	static_call(kvm_x86_pmu_init)(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
@@ -480,14 +493,13 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 		      pmu->pmc_in_use, X86_PMC_IDX_MAX);
 
 	for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
-		pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, i);
+		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
 	}
 
-	if (kvm_pmu_ops.cleanup)
-		kvm_pmu_ops.cleanup(vcpu);
+	static_call_cond(kvm_x86_pmu_cleanup)(vcpu);
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
@@ -517,7 +529,7 @@ static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 	unsigned int config;
 
 	pmc->eventsel &= (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
-	config = kvm_pmu_ops.pmc_perf_hw_id(pmc);
+	config = static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc);
 	pmc->eventsel = old_eventsel;
 	return config == perf_hw_id;
 }
@@ -545,7 +557,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	int i;
 
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
-		pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, i);
+		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
 		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
 			continue;
-- 
2.35.1.1021.g381101b075-goog

