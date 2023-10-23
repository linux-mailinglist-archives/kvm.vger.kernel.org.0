Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE2E7D434F
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 01:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjJWXkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 19:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbjJWXkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 19:40:08 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AEED6E
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:05 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9c83b656fso32594685ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698104405; x=1698709205; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7hs5LXK64QuGvnjb5nv5KwW+waLw4KwuiCSeTdPJWrI=;
        b=iZwEAusYbE0n+500Y1eVOxVEOwIgNksAd3nKDsonxcMJ7037Kbl5+PxeU1R7znOzFo
         aR2n1VfB0zLWtXA5G38vjt2uodfT/8q2jocN9JK5d2hxy9O53iQC679sINETkKIpVhru
         dV1sZwF+vKMyXyAboRl1RngCYvOBEmoq2cqg5yOIX2XzFv5LSEyPn7+affm1+FXwpmNd
         50QHaGI5zmBBpSgVgAJ+LP3bJjugNBtS3gHNAI98NsPEJuQ2witBcbDDPGJVilAt76R8
         1KV1lGUe/4Nn3CSLjJVmlmVVbfRWkG4kZyDo3v6kasVpN+Wr11ks2LVBpu/ZDTHpE+5H
         eUbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698104405; x=1698709205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7hs5LXK64QuGvnjb5nv5KwW+waLw4KwuiCSeTdPJWrI=;
        b=cWCHRKF8Hx0uwykVPvpZaCA0vWTr4bfVFuHCoDwIHRgB2SSC5Y2IKHXrZXKWpjP3HW
         rCRiV2/TYXUkGkHYRhK2D2g8LZhaEuhr+xr/5dP3xJq603YeAgH08Uvi8SgWveEJ89r9
         0Mz3QLpey690yuQC+IX6bGJ19I0E02+I54mJeNV3fxfY76kcgGsfydV4962yxSXbSOfT
         bM/pDan7eUC7HmFclxhdbkbyB5kogzveEkH6jHCaER0kEyZCedcrwyfe0DFpZK1Ig6LX
         QUZ9tzNgF9El20LGH0fRMdOhFEh5SjmytL8JD9lGxSy4RIRNxwEcQW6Av+MrIu1Pq0ff
         8BkA==
X-Gm-Message-State: AOJu0YymlqhnE7ENwF8adKmNAUt174ou0ykI7aMV3bqaIAH47YSxxc3/
        OLl1Xz6c7gFj7Q8EIU8l5PnBhpOLUHU=
X-Google-Smtp-Source: AGHT+IFtgExxSownjg4pSQppeXSJemiFNe9s7PaYVEIMlhr6QHeOjldSLqohfie35x54YlyZDzLKQOaGsEc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6502:b0:1c9:b045:5a8b with SMTP id
 b2-20020a170902650200b001c9b0455a8bmr181162plk.6.1698104405345; Mon, 23 Oct
 2023 16:40:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 16:39:55 -0700
In-Reply-To: <20231023234000.2499267-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231023234000.2499267-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023234000.2499267-2-seanjc@google.com>
Subject: [PATCH 1/6] KVM: x86/pmu: Move PMU reset logic to common x86 code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Jim Mattson <jmattson@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the common (or at least "ignored") aspects of resetting the vPMU to
common x86 code, along with the stop/release helpers that are no used only
by the common pmu.c.

There is no need to manually handle fixed counters as all_valid_pmc_idx
tracks both fixed and general purpose counters, and resetting the vPMU is
far from a hot path, i.e. the extra bit of overhead to the PMC from the
index is a non-issue.

Zero fixed_ctr_ctrl in common code even though it's Intel specific.
Ensuring it's zero doesn't harm AMD/SVM in any way, and stopping the fixed
counters via all_valid_pmc_idx, but not clearing the associated control
bits, would be odd/confusing.

Make the .reset() hook optional as SVM no longer needs vendor specific
handling.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  2 +-
 arch/x86/kvm/pmu.c                     | 40 +++++++++++++++++++++++++-
 arch/x86/kvm/pmu.h                     | 18 ------------
 arch/x86/kvm/svm/pmu.c                 | 16 -----------
 arch/x86/kvm/vmx/pmu_intel.c           | 20 -------------
 5 files changed, 40 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 6c98f4bb4228..058bc636356a 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -22,7 +22,7 @@ KVM_X86_PMU_OP(get_msr)
 KVM_X86_PMU_OP(set_msr)
 KVM_X86_PMU_OP(refresh)
 KVM_X86_PMU_OP(init)
-KVM_X86_PMU_OP(reset)
+KVM_X86_PMU_OP_OPTIONAL(reset)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 9ae07db6f0f6..027e9c3c2b93 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -250,6 +250,24 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	return true;
 }
 
+static void pmc_release_perf_event(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event) {
+		perf_event_release_kernel(pmc->perf_event);
+		pmc->perf_event = NULL;
+		pmc->current_config = 0;
+		pmc_to_pmu(pmc)->event_count--;
+	}
+}
+
+static void pmc_stop_counter(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event) {
+		pmc->counter = pmc_read_counter(pmc);
+		pmc_release_perf_event(pmc);
+	}
+}
+
 static int filter_cmp(const void *pa, const void *pb, u64 mask)
 {
 	u64 a = *(u64 *)pa & mask;
@@ -654,7 +672,27 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 {
-	static_call(kvm_x86_pmu_reset)(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int i;
+
+	bitmap_zero(pmu->reprogram_pmi, X86_PMC_IDX_MAX);
+
+	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
+		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
+		if (!pmc)
+			continue;
+
+		pmc_stop_counter(pmc);
+		pmc->counter = 0;
+
+		if (pmc_is_gp(pmc))
+			pmc->eventsel = 0;
+	}
+
+	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
+
+	static_call_cond(kvm_x86_pmu_reset)(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 1d64113de488..a46aa9b25150 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -80,24 +80,6 @@ static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
 	pmc->counter &= pmc_bitmask(pmc);
 }
 
-static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
-{
-	if (pmc->perf_event) {
-		perf_event_release_kernel(pmc->perf_event);
-		pmc->perf_event = NULL;
-		pmc->current_config = 0;
-		pmc_to_pmu(pmc)->event_count--;
-	}
-}
-
-static inline void pmc_stop_counter(struct kvm_pmc *pmc)
-{
-	if (pmc->perf_event) {
-		pmc->counter = pmc_read_counter(pmc);
-		pmc_release_perf_event(pmc);
-	}
-}
-
 static inline bool pmc_is_gp(struct kvm_pmc *pmc)
 {
 	return pmc->type == KVM_PMC_GP;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 373ff6a6687b..3fd47de14b38 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -233,21 +233,6 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void amd_pmu_reset(struct kvm_vcpu *vcpu)
-{
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int i;
-
-	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC; i++) {
-		struct kvm_pmc *pmc = &pmu->gp_counters[i];
-
-		pmc_stop_counter(pmc);
-		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
-	}
-
-	pmu->global_ctrl = pmu->global_status = 0;
-}
-
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.hw_event_available = amd_hw_event_available,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
@@ -259,7 +244,6 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.set_msr = amd_pmu_set_msr,
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
-	.reset = amd_pmu_reset,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820d3e1f6b4f..90c1f7f07e53 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -632,26 +632,6 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 {
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = NULL;
-	int i;
-
-	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
-		pmc = &pmu->gp_counters[i];
-
-		pmc_stop_counter(pmc);
-		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
-	}
-
-	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
-		pmc = &pmu->fixed_counters[i];
-
-		pmc_stop_counter(pmc);
-		pmc->counter = pmc->prev_counter = 0;
-	}
-
-	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
-
 	intel_pmu_release_guest_lbr_event(vcpu);
 }
 
-- 
2.42.0.758.gaed0368e0e-goog

