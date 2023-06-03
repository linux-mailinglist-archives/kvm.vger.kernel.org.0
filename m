Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1203720CD9
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbjFCBLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237064AbjFCBLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:11:10 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D8DB9
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:11:09 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2553b096ddfso2387507a91.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754669; x=1688346669;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=swEcMgjVxKvw1b5Bf6E2j3Zu7xMBEr/QXOoV0DUFx6c=;
        b=vql83tzz8Nv6CwSsZWAIWzRxPyJ4JmBNCY+I8T31VQtwJ3ApMXLSmkUmWeesDkcEng
         tgjPq6G53Bb69bCGwixT7FFAw7ypzpUPiqupkbpz8nBTmWyIh4pnI1RAW6dZ+htcw+IM
         fLkm5YZHz6oA/IvaRUEyWkIi29Kwdf/bBotQDYy+z+kHAdCv4p/S+piL343KvO5ii61N
         UiMsju2/61shtM2gy4fg/jDR38oGWFscLBhhz8e4wd4O8I7kxHE2r+Wo0z1fsvH3aN91
         fwytyIybOf6rDlQ1Afqb9BT+pqgaGCbTFbQz41m+5pPkxM8sxn/o09rzphrQAv5ZVgjd
         4K+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754669; x=1688346669;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=swEcMgjVxKvw1b5Bf6E2j3Zu7xMBEr/QXOoV0DUFx6c=;
        b=ZdrbEUX1bbMhIGpbsVYwKhuwb8J0/FeHBlNMoKFuHQJbvPkHBR1WNY4XsDSiMN8HeP
         FMzzQAIt6a9zCREFrLRpTRBoMDt1PlRyx2c0t4L+m+KuUImHZ7aOtBONVUUnn2DC+Kp9
         GcW9fLz/9PDRve3Qnm7sUsv1Vvybvji3N8pYrhrKJFZiS6n0qBDfr99VQYHG2NFN3EbY
         NXQI9MmgCWvb/SAxXWhGe3BFa5e+BB5Z95vlZcMNJf375lk+TpboblJ/8NZmA8jhOn5x
         zjqfwSXX89KpictF0OAkKdEwkqHBhsv2PdwueJPuKighpcqRXkZ7jHbIFRWQZ0RDsfPD
         63TA==
X-Gm-Message-State: AC+VfDw34sOXuA9S3Rup6NBtDq86tFIw9Xop0xdia5Gq78WLPN1RJ+WN
        5ydaomU6zbT9IKZRRy01JWKKQr+3DEY=
X-Google-Smtp-Source: ACHHUZ70p7wq6NQEoxnxEnQSJY6ePLYxl303VkojN4lsCoDxiKggcGzVH00pnhDKkQO/g20AINPrfjFAI50=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e2cb:b0:256:bc5e:7d76 with SMTP id
 fr11-20020a17090ae2cb00b00256bc5e7d76mr313305pjb.3.1685754669034; Fri, 02 Jun
 2023 18:11:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 18:10:50 -0700
In-Reply-To: <20230603011058.1038821-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230603011058.1038821-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603011058.1038821-5-seanjc@google.com>
Subject: [PATCH v7 04/12] KVM: x86/pmu: Move handling PERF_GLOBAL_CTRL and
 friends to common x86
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

Move the handling of GLOBAL_CTRL, GLOBAL_STATUS, and GLOBAL_OVF_CTRL,
a.k.a. GLOBAL_STATUS_RESET, from Intel PMU code to generic x86 PMU code.
AMD PerfMonV2 defines three registers that have the same semantics as
Intel's variants, just with different names and indices.  Conveniently,
since KVM virtualizes GLOBAL_CTRL on Intel only for PMU v2 and above, and
AMD's version shows up in v2, KVM can use common code for the existence
check as well.

Signed-off-by: Like Xu <likexu@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c           | 71 ++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/pmu.h           | 14 +++++++
 arch/x86/kvm/vmx/nested.c    |  4 +-
 arch/x86/kvm/vmx/pmu_intel.c | 47 +-----------------------
 arch/x86/kvm/vmx/vmx.h       | 12 ------
 5 files changed, 86 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 1690d41c1830..c720cc186ab4 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -562,6 +562,14 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
+	switch (msr) {
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		return kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu));
+	default:
+		break;
+	}
 	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
 		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
 }
@@ -577,13 +585,70 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u32 msr = msr_info->index;
+
+	switch (msr) {
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+		msr_info->data = pmu->global_status;
+		break;
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+		msr_info->data = pmu->global_ctrl;
+		break;
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		msr_info->data = 0;
+		break;
+	default:
+		return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
+	}
+
+	return 0;
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
-	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u32 msr = msr_info->index;
+	u64 data = msr_info->data;
+	u64 diff;
+
+	switch (msr) {
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+		if (!msr_info->host_initiated)
+			return 1; /* RO MSR */
+
+		if (data & pmu->global_status_mask)
+			return 1;
+
+		pmu->global_status = data;
+		break;
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+		if (!kvm_valid_perf_global_ctrl(pmu, data))
+			return 1;
+
+		if (pmu->global_ctrl != data) {
+			diff = pmu->global_ctrl ^ data;
+			pmu->global_ctrl = data;
+			reprogram_counters(pmu, diff);
+		}
+		break;
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		/*
+		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
+		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
+		 */
+		if (data & pmu->global_status_mask)
+			return 1;
+
+		if (!msr_info->host_initiated)
+			pmu->global_status &= ~data;
+		break;
+	default:
+		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
+		return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
+	}
+
+	return 0;
 }
 
 /* refresh PMU settings. This function generally is called when underlying
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 986563aeeef8..7c2c64142443 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -41,6 +41,20 @@ struct kvm_pmu_ops {
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
 
+static inline bool kvm_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
+{
+	/*
+	 * Architecturally, Intel's SDM states that IA32_PERF_GLOBAL_CTRL is
+	 * supported if "CPUID.0AH: EAX[7:0] > 0", i.e. if the PMU version is
+	 * greater than zero.  However, KVM only exposes and emulates the MSR
+	 * to/for the guest if the guest PMU supports at least "Architectural
+	 * Performance Monitoring Version 2".
+	 *
+	 * AMD's version of PERF_GLOBAL_CTRL conveniently shows up with v2.
+	 */
+	return pmu->version > 1;
+}
+
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e35cf0bd0df9..ba2ed6d87364 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2649,7 +2649,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	}
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
-	    intel_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
+	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
@@ -4524,7 +4524,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
 	}
 	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
-	    intel_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
+	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 					 vmcs12->host_ia32_perf_global_ctrl));
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index efd113f24c1b..ff2f52d1e22f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -100,7 +100,7 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (!intel_pmu_has_perf_global_ctrl(pmu))
+	if (!kvm_pmu_has_perf_global_ctrl(pmu))
 		return true;
 
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
@@ -186,11 +186,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
-	case MSR_CORE_PERF_GLOBAL_STATUS:
-	case MSR_CORE_PERF_GLOBAL_CTRL:
-	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		return intel_pmu_has_perf_global_ctrl(pmu);
-		break;
+		return kvm_pmu_has_perf_global_ctrl(pmu);
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
 		break;
@@ -340,15 +336,6 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		msr_info->data = pmu->fixed_ctr_ctrl;
 		break;
-	case MSR_CORE_PERF_GLOBAL_STATUS:
-		msr_info->data = pmu->global_status;
-		break;
-	case MSR_CORE_PERF_GLOBAL_CTRL:
-		msr_info->data = pmu->global_ctrl;
-		break;
-	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		msr_info->data = 0;
-		break;
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		break;
@@ -398,36 +385,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
-	case MSR_CORE_PERF_GLOBAL_STATUS:
-		if (!msr_info->host_initiated)
-			return 1; /* RO MSR */
-
-		if (data & pmu->global_status_mask)
-			return 1;
-
-		pmu->global_status = data;
-		break;
-	case MSR_CORE_PERF_GLOBAL_CTRL:
-		if (!kvm_valid_perf_global_ctrl(pmu, data))
-			return 1;
-
-		if (pmu->global_ctrl != data) {
-			diff = pmu->global_ctrl ^ data;
-			pmu->global_ctrl = data;
-			reprogram_counters(pmu, diff);
-		}
-		break;
-	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		/*
-		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
-		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
-		 */
-		if (data & pmu->global_status_mask)
-			return 1;
-
-		if (!msr_info->host_initiated)
-			pmu->global_status &= ~data;
-		break;
 	case MSR_IA32_PEBS_ENABLE:
 		if (data & pmu->pebs_enable_mask)
 			return 1;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9e66531861cf..32384ba38499 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -93,18 +93,6 @@ union vmx_exit_reason {
 	u32 full;
 };
 
-static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
-{
-	/*
-	 * Architecturally, Intel's SDM states that IA32_PERF_GLOBAL_CTRL is
-	 * supported if "CPUID.0AH: EAX[7:0] > 0", i.e. if the PMU version is
-	 * greater than zero.  However, KVM only exposes and emulates the MSR
-	 * to/for the guest if the guest PMU supports at least "Architectural
-	 * Performance Monitoring Version 2".
-	 */
-	return pmu->version > 1;
-}
-
 struct lbr_desc {
 	/* Basic info about guest LBR records. */
 	struct x86_pmu_lbr records;
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

