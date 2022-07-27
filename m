Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE915835AE
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 01:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbiG0Xek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 19:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiG0Xej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 19:34:39 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3EE5A17E
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 16:34:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r6-20020a17090a2e8600b001f0768a1af1so1830099pjd.8
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 16:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WtmlaQOLAvBdCC5Xqq1im2R9nvQtqKXLoleX18wOxFw=;
        b=as8BVIHPEYuQOT1/Dby16+bzXRaZ05D9D2fWsshSMOYLYfsXR0/39JxhqtnEQB4IxS
         eM4rSIS9aSD7gHcRze5YYaCaEq1A6a+bjgSmFYmbpZpr0UzwSM82VEf5T94R9+97rcoI
         Ql5MFDPF2BRKS3THfDro7hqaKXTxrbUj9euvFyMHg7EpBPgKpN/OwppB3YDH21WDWHCo
         U0hFEIzXfbP5/V+M0ym460tN5GG1QmGvMz1hWd8BT8pM4bxWSeRbmgTpsnJmenbzt0HJ
         DvJtO4GX3bAbrWBlHdUEdle7w8nB1um53PEK4mosNCbQMy1kw0JkPV1t7yN7a2bOOkY3
         DeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WtmlaQOLAvBdCC5Xqq1im2R9nvQtqKXLoleX18wOxFw=;
        b=qBA1EfqrTUs+YajwZlkxBda7w/Blm9KbRu3zZ5J2XL+g9FafqhORrgpRAYWHS0yGhG
         hZzU17x3nLN3/856SB7dFh20VCPJ+hhWxU/HNFKoT8apyAoeWleMgCtTSw897pKuFEgg
         GcrANyUOF+Aln+dmaW+Jabs0BxA7Zzu81rGqHCcihfnQdaTZxKRxPBesYo4hYgyOCXEL
         wm8HxvRjmmQgMfg4+9klFx/nTm5DqkkB9seDJuaLAOvu0WNuLhHP7OQxc/PmYAX1fmuv
         gZSADE7pivjHLRheMnea8E58XY0v/aczAzTjigG4xw4lyq7Thl2ADg0rbV8u9ftFsyrl
         HKZQ==
X-Gm-Message-State: AJIora83su64vpEJMDoFoE0CfzlCUT8yeGkiCv9f6pau2DZJ6hQvleC2
        DdLSqCNoe/RzZBzjg1wAA6nC5GxSt9I=
X-Google-Smtp-Source: AGRyM1sJeEN47VSsEvXaqSGcKVReigYyfKFSXGDSr32GDLnIG87fO1QpS9KkPyctRxcOtdCxQF4vbC+0Aro=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:10e:b0:1f1:f3b0:9304 with SMTP id
 p14-20020a17090b010e00b001f1f3b09304mr658262pjz.1.1658964876762; Wed, 27 Jul
 2022 16:34:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Jul 2022 23:34:24 +0000
In-Reply-To: <20220727233424.2968356-1-seanjc@google.com>
Message-Id: <20220727233424.2968356-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220727233424.2968356-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 3/3] KVM: VMX: Adjust number of LBR records for
 PERF_CAPABILITIES at refresh
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
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

Now that the PMU is refreshed when MSR_IA32_PERF_CAPABILITIES is written
by host userspace, zero out the number of LBR records for a vCPU during
PMU refresh if PMU_CAP_LBR_FMT is not set in PERF_CAPABILITIES instead of
handling the check at run-time.

guest_cpuid_has() is expensive due to the linear search of guest CPUID
entries, intel_pmu_lbr_is_enabled() is checked on every VM-Enter, _and_
simply enumerating the same "Model" as the host causes KVM to set the
number of LBR records to a non-zero value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 12 +++---------
 arch/x86/kvm/vmx/vmx.h       |  7 +++++--
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index cfcb590afaa7..d111dc0d86df 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -171,13 +171,6 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
-bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
-{
-	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
-
-	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);
-}
-
 static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 {
 	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
@@ -590,7 +583,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	if (cpuid_model_is_consistent(vcpu))
+	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
+	if (cpuid_model_is_consistent(vcpu) &&
+	    (perf_capabilities & PMU_CAP_LBR_FMT))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
 		lbr_desc->records.nr = 0;
@@ -598,7 +593,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
-	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
 	if (perf_capabilities & PERF_CAP_PEBS_FORMAT) {
 		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = counter_mask;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 690421b7d26c..c05e302fe2b1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -526,9 +526,12 @@ static inline struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
 	return &vcpu_to_lbr_desc(vcpu)->records;
 }
 
+static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
+{
+	return !!vcpu_to_lbr_records(vcpu)->nr;
+}
+
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
-bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
-
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 
-- 
2.37.1.359.gd136c6c3e2-goog

