Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542EB4EB71E
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 01:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbiC2Xxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 19:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241175AbiC2Xwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 19:52:51 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5EE205BCD
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:51:08 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id om8-20020a17090b3a8800b001c68e7ccd5fso292193pjb.9
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 16:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rUm8X861zRhcP7IH2r62TLmqODWxaakk5bqj/4FKees=;
        b=lp+161YCBaksKfEsnop3WkW2sEbYQsYlWsIIuCpFR565hGaN4ctyrwOY9c+qBVVxN7
         u398mF45ljWlgcx64gdh62+mdMl2nuwyT8FHRa4HvIccIqkdeqgLqb/PV620/wm5eb2J
         JiyBcN6V/RGFa/m4VwCCpJ7LFCyCWrxfd1Nc63OKDa6jTTlMz5X+rK3yuiDhnSacBNpO
         eH8LXepxAiEpd0i1nc7SRogXfkLYeIjCfVeJ+wShhqWXthXGdEQ3+yF8g5bs0HfPEAwy
         18RRAypPvc17L9Hb6tP74IZ9KHhlitfn9yRfgjJUAVp9YH9Ad9+DNMPxjvLAjM1FvZg7
         HBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rUm8X861zRhcP7IH2r62TLmqODWxaakk5bqj/4FKees=;
        b=ooH49SjJA/Ycm6DDWIuXbMPesNXh7i8tYM+95AgJZ8vE63gMRZp5FAfFlksuw3lHUV
         3Izgxe+HxM0qt32pdukSfAtXlT2U9cT8zfjheAze2BGMfhLcbjZSlvVIHJ15dvyascuL
         r2OHKF/IMJ27AGIzil3J/fo7/Hm95qHETY8LFVVEMMoqSgZuetK6Pn3NMSYh4UCnqkCO
         yPfVZtDxemZ81SyZOAedF30BpHkPNO8F5wG4ECvfXh60yqQWd5V4XAsNGQts3VMdiWi0
         XgOt2MlEXX4zAdNiToOjFx2YpKlVxE3M+5fr2HU5+yz9xEnIvVzL+ARSc5NHRQMmArgN
         2YfA==
X-Gm-Message-State: AOAM530hyzX059oHLS7WLvNXi1+pxsbniuql6+MvFs3OM+Ge1drkJf8e
        CQaPHJDm2mb27JmLcIMCghOyYkxYmKs=
X-Google-Smtp-Source: ABdhPJx+bv7YCHgDCbGLE+StVp2R1OFLwih633YA0wO8603nhVXNZi9ZdvZc6kSwNCXUPR7imoqSBzZpdTY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP id
 m11-20020a17090a858b00b001c65bc8781amr166639pjn.0.1648597867298; Tue, 29 Mar
 2022 16:51:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Mar 2022 23:50:52 +0000
In-Reply-To: <20220329235054.3534728-1-seanjc@google.com>
Message-Id: <20220329235054.3534728-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220329235054.3534728-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3.1 2/4] KVM: x86: Copy kvm_pmu_ops by value to eliminate
 layer of indirection
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Replace the kvm_pmu_ops pointer in common x86 with an instance of the
struct to save one pointer dereference when invoking functions. Copy the
struct by value to set the ops during kvm_init().

Signed-off-by: Like Xu <likexu@tencent.com>
[sean: Move pmc_is_enabled(), make kvm_pmu_ops static]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 54 ++++++++++++++++++++++++++++------------------
 arch/x86/kvm/pmu.h |  7 ++----
 arch/x86/kvm/x86.c |  2 ++
 3 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index eca39f56c231..bb0b1ad0fda5 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -49,6 +49,18 @@
  *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] <=> gp counters
  */
 
+static struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
+
+void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
+{
+	memcpy(&kvm_pmu_ops, pmu_ops, sizeof(kvm_pmu_ops));
+}
+
+static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
+{
+	return kvm_pmu_ops.pmc_is_enabled(pmc);
+}
+
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 {
 	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
@@ -213,7 +225,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
+		config = kvm_pmu_ops.pmc_perf_hw_id(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
@@ -263,7 +275,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
+			      kvm_pmu_ops.pmc_perf_hw_id(pmc),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi);
@@ -272,7 +284,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 {
-	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
+	struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, pmc_idx);
 
 	if (!pmc)
 		return;
@@ -294,7 +306,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	int bit;
 
 	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
-		struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+		struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, bit);
 
 		if (unlikely(!pmc || !pmc->perf_event)) {
 			clear_bit(bit, pmu->reprogram_pmi);
@@ -316,7 +328,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 /* check if idx is a valid index to access PMU */
 bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return kvm_x86_ops.pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
+	return kvm_pmu_ops.is_valid_rdpmc_ecx(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -366,7 +378,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_x86_ops.pmu_ops->rdpmc_ecx_to_pmc(vcpu, idx, &mask);
+	pmc = kvm_pmu_ops.rdpmc_ecx_to_pmc(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -382,22 +394,22 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu)) {
-		if (kvm_x86_ops.pmu_ops->deliver_pmi)
-			kvm_x86_ops.pmu_ops->deliver_pmi(vcpu);
+		if (kvm_pmu_ops.deliver_pmi)
+			kvm_pmu_ops.deliver_pmi(vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
 	}
 }
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
-	return kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
-		kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, msr);
+	return kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr) ||
+		kvm_pmu_ops.is_valid_msr(vcpu, msr);
 }
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr);
+	struct kvm_pmc *pmc = kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -405,13 +417,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	return kvm_x86_ops.pmu_ops->get_msr(vcpu, msr_info);
+	return kvm_pmu_ops.get_msr(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
-	return kvm_x86_ops.pmu_ops->set_msr(vcpu, msr_info);
+	return kvm_pmu_ops.set_msr(vcpu, msr_info);
 }
 
 /* refresh PMU settings. This function generally is called when underlying
@@ -420,7 +432,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops.pmu_ops->refresh(vcpu);
+	kvm_pmu_ops.refresh(vcpu);
 }
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
@@ -428,7 +440,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	irq_work_sync(&pmu->irq_work);
-	kvm_x86_ops.pmu_ops->reset(vcpu);
+	kvm_pmu_ops.reset(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
@@ -436,7 +448,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	kvm_x86_ops.pmu_ops->init(vcpu);
+	kvm_pmu_ops.init(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
@@ -468,14 +480,14 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 		      pmu->pmc_in_use, X86_PMC_IDX_MAX);
 
 	for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
-		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
+		pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, i);
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
 	}
 
-	if (kvm_x86_ops.pmu_ops->cleanup)
-		kvm_x86_ops.pmu_ops->cleanup(vcpu);
+	if (kvm_pmu_ops.cleanup)
+		kvm_pmu_ops.cleanup(vcpu);
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
@@ -505,7 +517,7 @@ static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 	unsigned int config;
 
 	pmc->eventsel &= (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
-	config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
+	config = kvm_pmu_ops.pmc_perf_hw_id(pmc);
 	pmc->eventsel = old_eventsel;
 	return config == perf_hw_id;
 }
@@ -533,7 +545,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	int i;
 
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
-		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
+		pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, i);
 
 		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
 			continue;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..cbe9987f9cba 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -41,6 +41,8 @@ struct kvm_pmu_ops {
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 };
 
+void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
+
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -88,11 +90,6 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
 	return pmc->type == KVM_PMC_FIXED;
 }
 
-static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
-{
-	return kvm_x86_ops.pmu_ops->pmc_is_enabled(pmc);
-}
-
 static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
 						 u64 data)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99aa2d16845a..6f1676fab6c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11609,6 +11609,8 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 					   (void *)__static_call_return0);
 #include <asm/kvm-x86-ops.h>
 #undef __KVM_X86_OP
+
+	kvm_pmu_ops_update(ops->runtime_ops->pmu_ops);
 }
 
 int kvm_arch_hardware_setup(void *opaque)
-- 
2.35.1.1021.g381101b075-goog

