Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24523715547
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjE3GE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjE3GEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:04:52 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51348B0;
        Mon, 29 May 2023 23:04:50 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-2563a4b6285so2197813a91.2;
        Mon, 29 May 2023 23:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426690; x=1688018690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L4qxgyJAgBoUJPESWX33eEPzSbuOiRKztmB95/78wKA=;
        b=HmKkrYoOVGJccyvhDpdD7A2dkTZtGDpjquuoIQuAf8c4Ch6Fv0ysvX85E9yKrcEQkN
         Xl0nRIM8bKGhWr3f/5dygzjESRLzlp6F/fWN7qjrW92MwcJ/NkJMM0ntUkgtKhAqOeK/
         2i05/vn3BVw3g09ynSBaBYXtipDxbQWfSGunFAmgPnS1jfQKVJ6x+Ife2alggmLjDAqt
         Gp4sxIlIiJZMQPUQLWlv2Cg+TKACXTbu0LBOW7ugQSYmW/hADGs9ExefWmE/zdIsO+4u
         z7chPi1XCFMkPBebKO8MbY/jDRbdW4EMp5vGP9qQWzIWfTFgNBYLr5S0buTn1kLuvzhP
         +GKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426690; x=1688018690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4qxgyJAgBoUJPESWX33eEPzSbuOiRKztmB95/78wKA=;
        b=drvuuucKOOfuEpVdmB1yvhH4+sAV2pLNdF9hbD4NWdOQnLTxnLrkSdzufqXEXEe1Wb
         LPGKC2fSFSHiJzj/oqs+gcV6luL9KfnCq6Bgnb7NqazwuG8ELB7621MraNsS+XL79uJe
         LkCZ4s8Tm1Hqe5ELYXKaoDXGssCr0nOw9xMNGo9eBc0MaCU+iIX0VNmkWAP9Z0b1BUUV
         VmK0MZHJHSfphroEr1wElYXfRf3nUBjtQD/IibjT7Iwcd6H6ib1fxIZK1Wbd66sUtiwi
         RbQwgLv+8A4CQc9SERhCPQBPdqo08L/oPO0b+1NaejMBXRw9w6p++2001CVrErMRWWHH
         tHtA==
X-Gm-Message-State: AC+VfDzBrNVI/eQXq3YgNP5gJuVsZqKdHWEN22dd21U9034j0hBsPvh3
        vqQEkt3YHw+iGQ4Fu5FXL/m8oz/kGMo3vCVEQK8=
X-Google-Smtp-Source: ACHHUZ4rP0LOrWKiSn9nA6pSQzG8N7zUZ7Kut3u05yAXpobyzyPu2ZLxTAqszZ8UG/GOJPzBwbhO/Q==
X-Received: by 2002:a17:90a:f40c:b0:256:cc37:610b with SMTP id ch12-20020a17090af40c00b00256cc37610bmr248721pjb.28.1685426689637;
        Mon, 29 May 2023 23:04:49 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:04:49 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 03/10] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
Date:   Tue, 30 May 2023 14:04:16 +0800
Message-Id: <20230530060423.32361-4-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530060423.32361-1-likexu@tencent.com>
References: <20230530060423.32361-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

AMD PerfMonV2 defines three registers similar to part of the Intel
v2 PMU registers, including the GLOBAL_CTRL, GLOBAL_STATUS and
GLOBAL_OVF_CTRL MSRs. For better code reuse, this specific part of
the handling can be extracted to make it generic for X86 as a straight
code movement.

Specifically, the kvm_pmu_set/get_msr() handlers of GLOBAL_STATUS,
GLOBAL_CTRL, GLOBAL_OVF_CTRL defined for Intel are moved to generic
pmu.c and the callback function .pmc_is_globally_enabled is removed,
which is very helpful to introduce the AMD PerfMonV2 code later.

The new eponymous pmc_is_globally_enabled() works well as legacy AMD
vPMU version is indexed as 1. Note that the specific *_is_valid_msr will
continue to be used to avoid cross-vendor MSR access.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/kvm/pmu.c                     | 61 ++++++++++++++++++++++----
 arch/x86/kvm/pmu.h                     | 17 ++++++-
 arch/x86/kvm/svm/pmu.c                 |  9 ----
 arch/x86/kvm/vmx/pmu_intel.c           | 14 +-----
 5 files changed, 70 insertions(+), 32 deletions(-)

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
index 1690d41c1830..116bc7fe13c6 100644
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
@@ -577,13 +572,63 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
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
+		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))
+			return 1; /* RO MSR */
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
+		if (data & pmu->global_ovf_ctrl_mask)
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
index 986563aeeef8..dd7c7d4ffe3b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -20,7 +20,6 @@
 
 struct kvm_pmu_ops {
 	bool (*hw_event_available)(struct kvm_pmc *pmc);
-	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
@@ -213,6 +212,22 @@ static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 	kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
 }
 
+/*
+ * Check if a PMC is enabled by comparing it against global_ctrl bits.
+ *
+ * If the current version of vPMU doesn't have global_ctrl MSR,
+ * all vPMCs are enabled (return TRUE).
+ */
+static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (pmu->version < 2)
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
index 343b3182b7f4..99d07ccb1869 100644
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
-	if (!intel_pmu_has_perf_global_ctrl(pmu))
-		return true;
-
-	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
-}
-
 static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -793,7 +782,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 
 		if (!pmc || !pmc_speculative_in_use(pmc) ||
-		    !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
+		    !pmc_is_globally_enabled(pmc) || !pmc->perf_event)
 			continue;
 
 		/*
@@ -808,7 +797,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.hw_event_available = intel_hw_event_available,
-	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.40.1

