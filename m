Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF1C720CDD
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbjFCBL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbjFCBLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:11:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1EFE50
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:11:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba8337a5861so6200272276.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754671; x=1688346671;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=miuZ/wWNZFN7b1zXGKrPaL8HShf8kZjo9bpVR4m4UMo=;
        b=UgbLBc4fVtdWOUVtfm4nNyElNGayvvDDwY1KZMzt8nVX6GVH2B0GkwmSdQLH0D0kpW
         YNLrpedmHG9B+WwhIofgdE7jwof0BDUmIwklc/1oXmfGXb4i33rurcbzJVOgeXGrUR1Y
         /QlyqKdfSOMKR733tzhsKRqj9yoYXSWmjcGCvM5gmyC0gFSfM9wp6BMcPpuJO5HqOffZ
         WfYaOc6IrQ5PJ/R54pSb/++xbxHNIgpQnDzhmdTTNFs2OWRjET9UMOJ+KuZJyZe0AjwL
         4Myx6cVXEuQUOvcvf/xBBruUdiequrkT/o54W/u+olHnOv66G1hdmZiiXbSkELmh3Vvk
         PMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754671; x=1688346671;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=miuZ/wWNZFN7b1zXGKrPaL8HShf8kZjo9bpVR4m4UMo=;
        b=T1zV8tr+luy9QbS142+XbeAvZ8iMX9/I6GPiPUS1uN2PgefjybbQwXz7hSyEbuRMoe
         RLuFJ+63G8ZA+15wdUaqck5o9QS4ebGZiGgnU5tER7qBC2CweWpetwRR0PtEOkZSYk0P
         CRc/WBFap6SKBbWDHAkV5RKRwJqUZufD1+OUisGMXEDF9TNrpJRv6hSDPMxtDFFBGUQ6
         Fjeg4dXQqfu1ukTayswU3gxCMIsDH+XC+rZOIMclbnq/9qOVLrUsplb6Fg2M7YOAVeZz
         mLVBKdFF8Ie3yB2oxOvaEif7ztRGp2GkSOTrv8O6OaNlI/wfoheYqFc3Zpyt2MjbOaZY
         BYdw==
X-Gm-Message-State: AC+VfDzXQdWXzmxFlezhf2b5gb78PHK7ddoYBXBrFHkjGgTU3UgKWt8v
        Ed+vi77f8DHV//eVbmcz1v7r1aFRu/k=
X-Google-Smtp-Source: ACHHUZ4NXGHPKErIR2VubFeyjDpxmVj0sNjMQFrGfjVgY8rD6PU4Ts/23SzEIduMQVBpzgkBF53LXC+6WW0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1003:b0:ba8:1e5f:8514 with SMTP id
 w3-20020a056902100300b00ba81e5f8514mr3214688ybt.5.1685754671139; Fri, 02 Jun
 2023 18:11:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 18:10:51 -0700
In-Reply-To: <20230603011058.1038821-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230603011058.1038821-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603011058.1038821-6-seanjc@google.com>
Subject: [PATCH v7 05/12] KVM: x86/pmu: Provide Intel PMU's pmc_is_enabled()
 as generic x86 code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <likexu@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>
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

Move the Intel PMU implementation of pmc_is_enabled() to common x86 code
as pmc_is_globally_enabled(), and drop AMD's implementation.  AMD PMU
currently supports only v1, and thus not PERF_GLOBAL_CONTROL, thus the
semantics for AMD are unchanged.  And when support for AMD PMU v2 comes
along, the common behavior will also Just Work.

Signed-off-by: Like Xu <likexu@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/kvm/pmu.c                     |  5 -----
 arch/x86/kvm/pmu.h                     | 16 +++++++++++++++-
 arch/x86/kvm/svm/pmu.c                 |  9 ---------
 arch/x86/kvm/vmx/pmu_intel.c           | 14 +-------------
 5 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index c17e3e96fc1d..6c98f4bb4228 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -13,7 +13,6 @@ BUILD_BUG_ON(1)
  * at the call sites.
  */
 KVM_X86_PMU_OP(hw_event_available)
-KVM_X86_PMU_OP(pmc_is_enabled)
 KVM_X86_PMU_OP(pmc_idx_to_pmc)
 KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
 KVM_X86_PMU_OP(msr_idx_to_pmc)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c720cc186ab4..4315f46aabfb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -93,11 +93,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
 #undef __KVM_X86_PMU_OP
 }
 
-static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
-{
-	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
-}
-
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 {
 	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7c2c64142443..f77bfc7ede42 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -20,7 +20,6 @@
 
 struct kvm_pmu_ops {
 	bool (*hw_event_available)(struct kvm_pmc *pmc);
-	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
@@ -227,6 +226,21 @@ static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 	kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
 }
 
+/*
+ * Check if a PMC is enabled by comparing it against global_ctrl bits.
+ *
+ * If the vPMU doesn't have global_ctrl MSR, all vPMCs are enabled.
+ */
+static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (!kvm_pmu_has_perf_global_ctrl(pmu))
+		return true;
+
+	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 5fa939e411d8..70143275e0a7 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -78,14 +78,6 @@ static bool amd_hw_event_available(struct kvm_pmc *pmc)
 	return true;
 }
 
-/* check if a PMC is enabled by comparing it against global_ctrl bits. Because
- * AMD CPU doesn't have global_ctrl MSR, all PMCs are enabled (return TRUE).
- */
-static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
-{
-	return true;
-}
-
 static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -220,7 +212,6 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.hw_event_available = amd_hw_event_available,
-	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ff2f52d1e22f..b2f279f934b1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -95,17 +95,6 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
 	return true;
 }
 
-/* check if a PMC is enabled by comparing it with globl_ctrl bits. */
-static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-
-	if (!kvm_pmu_has_perf_global_ctrl(pmu))
-		return true;
-
-	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
-}
-
 static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -759,7 +748,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 
 		if (!pmc || !pmc_speculative_in_use(pmc) ||
-		    !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
+		    !pmc_is_globally_enabled(pmc) || !pmc->perf_event)
 			continue;
 
 		/*
@@ -774,7 +763,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.hw_event_available = intel_hw_event_available,
-	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

