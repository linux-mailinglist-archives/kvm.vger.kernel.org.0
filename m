Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8925F5D79
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJFADs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJFADc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:03:32 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E754868A3
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:03:27 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3576c47f204so3786597b3.2
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Wj4A07un6XHGrt+RTvAYDxXvCrE6FMxZlQG3F61qZAk=;
        b=iG1o4YPhrYlPlC3HN4jg+SaAuXL7rCrlwJvGSMCLx8npgtLdXsBMPWXBu3ZdCijcEB
         wZFLG5pc/3Y0CkkaYHVyJknyRpylE/cqSKwtETmaul/QpaKc6ZeHHkM52WhU4emH/BR0
         VAgTPfEnxG8oDiVi1Ws2+VHMEpG2M6vHnDCnmZCW6avGH8Qaazj/sTzknbGiDq/7muUL
         7XuNmC46UENEyMeDgfwa8hPffxbL9Ood8vAHRwfcXhsSwdIp+jJGOPK3UoiR0sfcI8OA
         H4Up/8yBGlfG8YiZRsuUIXwd21BWlt9hjte2S7s2VlpElIJjUXjVRTNTMQBSD1mEGa11
         prwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wj4A07un6XHGrt+RTvAYDxXvCrE6FMxZlQG3F61qZAk=;
        b=iFIEU4UVYeAAVKgEMrpudsuLbkZNa1BcBTCJXXvZknUxhVRHzggGLKg9YMAkuYEj73
         h7wzZ/h+O1/VWFybaBBPJ1bN8kWPDu035aH4FClA8aWmU40m2NZ63PSSBbD447OXybZw
         wWpBZNkoteZquaBRfhJwyc9DmWPNnDywASVHMZEmmiTmmQSO3ZcC6NhOns8HvC3NFx3T
         /duG2dEzKPmDzUA0loZBG/ft3XtwkwD/en0Ibeq0IsTMs/wT63gUgYXs3OpfgERNjbNx
         X/fNo40x9ios6wBL+RubgyPM2dSLDTHnBiQtTaTVAsekd+y8VaIg0TiS06M5EuGB1iOQ
         jGNg==
X-Gm-Message-State: ACrzQf10GCXmZCyAOroY0fkVFNJSv4RUDXffVHFrcAanDVaIlJiTgu6m
        BSfWDq1RQw80YhtqNY2MDIugWYMxSOc=
X-Google-Smtp-Source: AMsMyM6Bn4QRL3X0Dchb11IIegjCuKKOMiDuJ3db3fucIrjWjmCy19dyFzfhmmKzM1kbsVbroT+LJZexee0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:8c9:0:b0:6be:3490:3dd6 with SMTP id
 w9-20020a5b08c9000000b006be34903dd6mr2370762ybq.422.1665014606348; Wed, 05
 Oct 2022 17:03:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:03:11 +0000
In-Reply-To: <20221006000314.73240-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006000314.73240-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006000314.73240-6-seanjc@google.com>
Subject: [PATCH v5 5/8] KVM: x86: Track supported PERF_CAPABILITIES in kvm_caps
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
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

Track KVM's supported PERF_CAPABILITIES in kvm_caps instead of computing
the supported capabilities on the fly every time.  Using kvm_caps will
also allow for future cleanups as the kvm_caps values can be used
directly in common x86 code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/capabilities.h | 25 ------------------------
 arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 34 +++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.h              |  1 +
 5 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d9357..6b680b249975 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2715,6 +2715,7 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 			msr->data |= MSR_F10H_DECFG_LFENCE_SERIALIZE;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
+		msr->data = kvm_caps.supported_perf_cap;
 		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
@@ -4898,6 +4899,7 @@ static __init void svm_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
 
+	kvm_caps.supported_perf_cap = 0;
 	kvm_caps.supported_xss = 0;
 
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 479124e49bbd..cd2ac9536c99 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -395,31 +395,6 @@ static inline bool vmx_pebs_supported(void)
 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
 }
 
-static inline u64 vmx_get_perf_capabilities(void)
-{
-	u64 perf_cap = PMU_CAP_FW_WRITES;
-	struct x86_pmu_lbr lbr;
-	u64 host_perf_cap = 0;
-
-	if (!enable_pmu)
-		return 0;
-
-	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
-
-	x86_perf_get_lbr(&lbr);
-	if (lbr.nr)
-		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
-
-	if (vmx_pebs_supported()) {
-		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
-		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
-			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
-	}
-
-	return perf_cap;
-}
-
 static inline bool cpu_has_notify_vmexit(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 25b70a85bef5..24f4c22691f8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -631,7 +631,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].current_config = 0;
 	}
 
-	vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
+	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
 	lbr_desc->msr_passthrough = false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e70ac91cd2fb..850ff6e683d1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1850,7 +1850,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
 	case MSR_IA32_PERF_CAPABILITIES:
-		msr->data = vmx_get_perf_capabilities();
+		msr->data = kvm_caps.supported_perf_cap;
 		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
@@ -2029,7 +2029,7 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	    (host_initiated || guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
 		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
 
-	if ((vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT) &&
+	if ((kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT) &&
 	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
 		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
@@ -2342,14 +2342,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		if (data & PMU_CAP_LBR_FMT) {
 			if ((data & PMU_CAP_LBR_FMT) !=
-			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
+			    (kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT))
 				return 1;
 			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
 		if (data & PERF_CAP_PEBS_FORMAT) {
 			if ((data & PERF_CAP_PEBS_MASK) !=
-			    (vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
+			    (kvm_caps.supported_perf_cap & PERF_CAP_PEBS_MASK))
 				return 1;
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
 				return 1;
@@ -7669,6 +7669,31 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vmx_update_exception_bitmap(vcpu);
 }
 
+static u64 vmx_get_perf_capabilities(void)
+{
+	u64 perf_cap = PMU_CAP_FW_WRITES;
+	struct x86_pmu_lbr lbr;
+	u64 host_perf_cap = 0;
+
+	if (!enable_pmu)
+		return 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+
+	x86_perf_get_lbr(&lbr);
+	if (lbr.nr)
+		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+
+	if (vmx_pebs_supported()) {
+		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
+		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
+			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
+	}
+
+	return perf_cap;
+}
+
 static __init void vmx_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
@@ -7691,6 +7716,7 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (!enable_pmu)
 		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
+	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
 
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 829d3134c1eb..9de72586f406 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -27,6 +27,7 @@ struct kvm_caps {
 	u64 supported_mce_cap;
 	u64 supported_xcr0;
 	u64 supported_xss;
+	u64 supported_perf_cap;
 };
 
 void kvm_spurious_fault(void);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

