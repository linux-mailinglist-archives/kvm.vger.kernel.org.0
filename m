Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479615470C6
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 02:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346860AbiFKA6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 20:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245075AbiFKA6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 20:58:02 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FAA69CEA
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:00 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f7dbceab08so7179587b3.10
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ijt7+eub9oOFtp9ZKwDKSShQmwiC3mYdxPWQo+7w/V0=;
        b=CZo3Wg55wAw24hpJ1B1SQ6orfyhR8RTFfwitl9xkS/NJ3F44mFVb6naEtlw7oWEq8X
         7IFBhJfFlQnhVrGAVQnF7hN3u+GNPOKYZXknBylCshX5PUJCIdovLjIL8R8NCISab/Oo
         u1QiLkOMAiaQVPVvW29xllEnzzGmBn9Bs6x3w9hRKGQqd2WR71uWuNRLT9zMKH0tCDt5
         RvEzqcqTATzcnSd5vXftFvIgGs+DMfhEEUmw6HzPwBwj+Rie9i9Gk3qDzk5tlrVXZVX9
         BYJX0/O5RBrkKGv8n/X31BDIemrc//8scwgOPJWSvhp/sm+J/2h75MLkt/S1QbDfOjUr
         i7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ijt7+eub9oOFtp9ZKwDKSShQmwiC3mYdxPWQo+7w/V0=;
        b=A7WSP6notk2FJ6fd1W8ehMxDcco4B9yCVhxObMTPQjIWwkoXwRNJ/g5Z5PhJjQTv1+
         DPVXDHxTf+mURcQ/uBG56y12jsD7y+Ldx00zYUyco2RZSqG/OOchYAw1772cNKZgFS5M
         AX7+zrgkbV6/PADCoRFdaZPASi/fTMfln6mR3ybWDi7Z9sxPzWjCVc6cIWBdB2E/PwrC
         /Q3LRBBMzEWia63ONs5eMrhNImYCZdIX/z56/rXEsKWrhpjqyCNMF8o0Hpw5pranIsqm
         FtrVzMcf8SZYuTOWypeRkF5yvxARZXkysZRdK/IVmI0rh4aZjQnUQGnP91tk5eMFU8Ob
         VZ4g==
X-Gm-Message-State: AOAM533FYuMTVpZwZIBPKQiH5R00fLfZjdQfPXn02AL3hQda2RJTWKkI
        +YZUF0uM24xkoyWIJHgiX/Y/CM/p8Cg=
X-Google-Smtp-Source: ABdhPJwz8uLXZjKQObtkL3FAf54uju/7eJlkYc3rrbwhOr6f+NHUw9FTPqDgtwwwhX+0k40+qWPiDvi0ziA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:6041:0:b0:663:6f4c:b3b8 with SMTP id
 u62-20020a256041000000b006636f4cb3b8mr31354240ybb.236.1654909079630; Fri, 10
 Jun 2022 17:57:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Jun 2022 00:57:49 +0000
In-Reply-To: <20220611005755.753273-1-seanjc@google.com>
Message-Id: <20220611005755.753273-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220611005755.753273-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 1/7] KVM: x86: Give host userspace full control of MSR_IA32_MISC_ENABLES
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

Give userspace full control of the read-only bits in MISC_ENABLES, i.e.
do not modify bits on PMU refresh and do not preserve existing bits when
userspace writes MISC_ENABLES.  With a few exceptions where KVM doesn't
expose the necessary controls to userspace _and_ there is a clear cut
association with CPUID, e.g. reserved CR4 bits, KVM does not own the vCPU
and should not manipulate the vCPU model on behalf of "dummy user space".

The argument that KVM is doing userspace a favor because "the order of
setting vPMU capabilities and MSR_IA32_MISC_ENABLE is not strictly
guaranteed" is specious, as attempting to configure MSRs on behalf of
userspace inevitably leads to edge cases precisely because KVM does not
prescribe a specific order of initialization.

Example #1: intel_pmu_refresh() consumes and modifies the vCPU's
MSR_IA32_PERF_CAPABILITIES, and so assumes userspace initializes config
MSRs before setting the guest CPUID model.  If userspace sets CPUID
first, then KVM will mark PEBS as available when arch.perf_capabilities
is initialized with a non-zero PEBS format, thus creating a bad vCPU
model if userspace later disables PEBS by writing PERF_CAPABILITIES.

Example #2: intel_pmu_refresh() does not clear PERF_CAP_PEBS_MASK in
MSR_IA32_PERF_CAPABILITIES if there is no vPMU, making KVM inconsistent
in its desire to be consistent.

Example #3: intel_pmu_refresh() does not clear MSR_IA32_MISC_ENABLE_EMON
if KVM_SET_CPUID2 is called multiple times, first with a vPMU, then
without a vPMU.  While slightly contrived, it's plausible a VMM could
reflect KVM's default vCPU and then operate on KVM's copy of CPUID to
later clear the vPMU settings, e.g. see KVM's selftests.

Example #4: Enumerating an Intel vCPU on an AMD host will not call into
intel_pmu_refresh() at any point, and so the BTS and PEBS "unavailable"
bits will be left clear, without any way for userspace to set them.

Keep the "R" behavior of the bit 7, "EMON available", for the guest.
Unlike the BTS and PEBS bits, which are fully "RO", the EMON bit can be
written with a different value, but that new value is ignored.

Cc: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c |  5 -----
 arch/x86/kvm/x86.c           | 24 +++++++++++-------------
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 422f0a6562ac..3b324ce0b142 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -536,8 +536,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->pebs_enable_mask = ~0ull;
 	pmu->pebs_data_cfg_mask = ~0ull;
 
-	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PMU_RO_MASK;
-
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
 		return;
@@ -548,8 +546,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!pmu->version)
 		return;
 
-	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
-
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 kvm_pmu_cap.num_counters_gp);
 	eax.split.bit_width = min_t(int, eax.split.bit_width,
@@ -611,7 +607,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
 	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
-		vcpu->arch.ia32_misc_enable_msr &= ~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = counter_mask;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2318a99139fa..5d1beb7d310e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3550,21 +3550,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_MISC_ENABLE: {
 		u64 old_val = vcpu->arch.ia32_misc_enable_msr;
-		u64 pmu_mask = MSR_IA32_MISC_ENABLE_PMU_RO_MASK |
-			MSR_IA32_MISC_ENABLE_EMON;
 
-		/* RO bits */
-		if (!msr_info->host_initiated &&
-		    ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PMU_RO_MASK))
-			return 1;
+		if (!msr_info->host_initiated) {
+			/* RO bits */
+			if ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PMU_RO_MASK)
+				return 1;
+
+			/* R bits, i.e. writes are ignored, but don't fault. */
+			data = data & ~MSR_IA32_MISC_ENABLE_EMON;
+			data |= old_val & MSR_IA32_MISC_ENABLE_EMON;
+		}
 
-		/*
-		 * For a dummy user space, the order of setting vPMU capabilities and
-		 * initialising MSR_IA32_MISC_ENABLE is not strictly guaranteed, so to
-		 * avoid inconsistent functionality we keep the vPMU bits unchanged here.
-		 */
-		data &= ~pmu_mask;
-		data |= old_val & pmu_mask;
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
 		    ((old_val ^ data)  & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
@@ -11552,6 +11548,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vcpu->arch.smbase = 0x30000;
 
 		vcpu->arch.msr_misc_features_enables = 0;
+		vcpu->arch.ia32_misc_enable_msr = MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |
+						  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL;
 
 		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
 		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
-- 
2.36.1.476.g0c4daa206d-goog

