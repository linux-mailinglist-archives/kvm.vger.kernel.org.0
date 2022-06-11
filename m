Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDD15470CE
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 03:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349598AbiFKA6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 20:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347057AbiFKA6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 20:58:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC11A69CEC
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:05 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c14-20020a17090a1d0e00b001e328238e7eso305064pjd.4
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 17:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WgoZeAKYDyVN6Bu2yQIDkTn9WR4zthBieE/N5Plhmhc=;
        b=bqRtvouyluy+O/l+kRML5bLb4jehUo9JPzZHa1oAsFm4ibK8Y9EveZJq8/oqO7/ltm
         ZI2dTxUb+DwoNdykVCTv73nBuROFUDUVvkzgZwWBiwv4WHDf6cEJFp8lwyJ3jSVe0n3U
         2F38NsxhjfIw1wRtrzI0SrSTiZjxQrnUfgM9t4r3/2ijeE4x0PEy0IZOpImx3ZwqEW7q
         8FuZsL3y246affWxFfkR1jv9UtDjV/0thXz3iWgfUsroE1m6MYULIl/5cY2W3lvapj9R
         cH6Fjtkf8ThE+iLzgCSJOLBevWspycKqxKpz+M/NyWoPPj7lVNFM2kWYHfgawuGdaNPF
         u6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WgoZeAKYDyVN6Bu2yQIDkTn9WR4zthBieE/N5Plhmhc=;
        b=Iumy/EHkFFhO+jxucNy0Or47OVKB4dWVuR1GNs24vYc6ylu7p7jOmjrMi1iTwo3d+y
         ps/+nOVvK0nNt7NpLvutBixLwnaSdo2+kA85HiTOKIf/JpCYltAj2A3rVDh4pPt0L8to
         uQm9ANBerWvrYrt0QsHbOMLf2Sd3fC/8135uA26Dn2TJDxXwY1wkdgdKVbYO83myDxwD
         jAmxTB1oPi3Wrw5iGN7uSZBUGA/YitSglQsiyMMiMruJfaI0kU+Oi68mnDggpj4It1Za
         3ueln6GI5NymrlavK1h205r+O/K3jRSpqIojPJ1hla2LLELc3wRj3JEELRJqGuT/ExLU
         2f1A==
X-Gm-Message-State: AOAM531CR9OSh3a1Bf74dmAj/ZNMWPqm5cor9fHfYDsrMFKWMQh6D5xF
        JFujMokW2CAkkMojRbM21KBRAF92jh0=
X-Google-Smtp-Source: ABdhPJzXXiVeTw8Msz9L9/SVwecUJFAGLbiQPL+JnaHZFu9sEjgzPoOu8RI1s6asSDaq+V5zsqJfpwItKZI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c7d1:b0:163:bb03:d5f0 with SMTP id
 r17-20020a170902c7d100b00163bb03d5f0mr45502961pla.167.1654909085265; Fri, 10
 Jun 2022 17:58:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Jun 2022 00:57:52 +0000
In-Reply-To: <20220611005755.753273-1-seanjc@google.com>
Message-Id: <20220611005755.753273-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220611005755.753273-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 4/7] Revert "KVM: x86: always allow host-initiated writes to
 PMU MSRs"
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

Revert the hack to allow host-initiated accesses to all "PMU" MSRs,
as intel_is_valid_msr() returns true for _all_ MSRs, regardless of whether
or not it has a snowball's chance in hell of actually being a PMU MSR.

That mostly gets papered over by the actual get/set helpers only handling
MSRs that they knows about, except there's the minor detail that
kvm_pmu_{g,s}et_msr() eat reads and writes when the PMU is disabled.
I.e. KVM will happy allow reads and writes to _any_ MSR if the PMU is
disabled, either via module param or capability.

This reverts commit d1c88a4020567ba4da52f778bcd9619d87e4ea75.

Fixes: d1c88a402056 ("KVM: x86: always allow host-initiated writes to PMU MSRs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c           |  4 ++--
 arch/x86/kvm/pmu.h           |  4 ++--
 arch/x86/kvm/svm/pmu.c       |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 27 ++++++++++-----------------
 arch/x86/kvm/x86.c           | 10 +++++-----
 5 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 87483e503c46..02f9e4f245bd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -425,10 +425,10 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 	}
 }
 
-bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated)
+bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
-		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr, host_initiated);
+		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
 }
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index c1b61671ba1e..5cc5721f260b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -32,7 +32,7 @@ struct kvm_pmu_ops {
 		unsigned int idx, u64 *mask);
 	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, u32 msr);
 	bool (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
-	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated);
+	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	void (*refresh)(struct kvm_vcpu *vcpu);
@@ -189,7 +189,7 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
-bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated);
+bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 256244b8f89c..f24613a108c5 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -179,7 +179,7 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return &counters[idx];
 }
 
-static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated)
+static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	/* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
 	return false;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b62012766226..b1aae60cf061 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -196,45 +196,38 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	return ret;
 }
 
-static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated)
+static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	u64 perf_capabilities = vcpu->arch.perf_capabilities;
+	int ret;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		if (host_initiated)
-			return true;
-		return pmu->version > 1;
+		ret = pmu->version > 1;
 		break;
 	case MSR_IA32_PEBS_ENABLE:
-		if (host_initiated)
-			return true;
-		return perf_capabilities & PERF_CAP_PEBS_FORMAT;
+		ret = perf_capabilities & PERF_CAP_PEBS_FORMAT;
 		break;
 	case MSR_IA32_DS_AREA:
-		if (host_initiated)
-			return true;
-		return guest_cpuid_has(vcpu, X86_FEATURE_DS);
+		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
 		break;
 	case MSR_PEBS_DATA_CFG:
-		if (host_initiated)
-			return true;
-		return (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
+		ret = (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
 			((perf_capabilities & PERF_CAP_PEBS_FORMAT) > 3);
 		break;
 	default:
-		if (host_initiated)
-			return true;
-		return get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
+		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
 			get_fixed_pmc(pmu, msr) || get_fw_gp_pmc(pmu, msr) ||
 			intel_pmu_is_valid_lbr_msr(vcpu, msr);
 		break;
 	}
+
+	return ret;
 }
 
 static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
@@ -596,7 +589,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	nested_vmx_pmu_refresh(vcpu,
-			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL, false));
+			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
 
 	if (cpuid_model_is_consistent(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d1beb7d310e..25f471adb8b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3704,7 +3704,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		fallthrough;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr, msr_info->host_initiated))
+		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 
 		if (pr || data != 0)
@@ -3787,7 +3787,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 #endif
 	default:
-		if (kvm_pmu_is_valid_msr(vcpu, msr, msr_info->host_initiated))
+		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 		return KVM_MSR_RET_INVALID;
 	}
@@ -3867,7 +3867,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0;
 		break;
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index, msr_info->host_initiated))
+		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		if (!msr_info->host_initiated)
 			return 1;
@@ -3877,7 +3877,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index, msr_info->host_initiated))
+		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		msr_info->data = 0;
 		break;
@@ -4123,7 +4123,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 #endif
 	default:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index, msr_info->host_initiated))
+		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		return KVM_MSR_RET_INVALID;
 	}
-- 
2.36.1.476.g0c4daa206d-goog

