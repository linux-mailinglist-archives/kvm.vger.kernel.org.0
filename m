Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968F769582E
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjBNFIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjBNFIf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:35 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839541968E;
        Mon, 13 Feb 2023 21:08:27 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id m2so15874012plg.4;
        Mon, 13 Feb 2023 21:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ncKAk6gJ4iVF6K5b2IB+22EVjiIiVXQJGnamVv3TxEo=;
        b=NZTPTlgWB+Gy7JQ9HJXVOupBKi3VHl14oVZaWpe36Xcj8YUl/GVNBbE+7uj2bOKOCd
         Qt8w/kJhNfgakythMDlB453w0rTDPMnuQfjGTJzxMp4Thb3z2aS3dqjhfIOkp7O2q/R3
         MKu2eEIkyitAVfRTgp8T+Crzxxp+xjJs3tAy+o2JUZbWk+jas90+riwSo0WjIVMwAkhi
         wYle+innPfcIuxAkZoXHo9tdEbV+dllsh9df0AeczzwMB5WHKgS9xevTn7119zH1d/c8
         OmVfysViRD6OdnGr99iEYtIQBXkI52MVmKPihk4AsNGC8+k0eQ5zLJNUorrAB5vpxJnL
         33TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ncKAk6gJ4iVF6K5b2IB+22EVjiIiVXQJGnamVv3TxEo=;
        b=oCqjEf3ALAsWq5E/tnCJSXqALv+P6YDE0FGYdeUzITgb8vbVlpbNhj9tFLSz3YKznJ
         7hO3Det0DMhRTMs35DctI5i3lAEIsoZBya2fQhhdOJ3x/FJWLogIN2BKuPEnul29W9FA
         Wk0gJsQx7pBU0srC8S3ZwSlTDm/j9ovOCSSLy0nbTKj24Luym8Jw5vKOkoBEAWneYO7V
         AFBEtjmXVVTjI6xwy8LhNPoM+mvvxveizKwolLR86c1XrHFCzilkzT0bUwurfn+iexts
         hWC1T34OaaL3ALhkNLQEkMO8S8+0oRzMU0L0pQQjZt48dVnfjS4xgC0pcTb0jP7yhUUS
         U2nA==
X-Gm-Message-State: AO0yUKVamtbHF8D7NXhpaZBiNcyZdMTEFoEOoZ3IeO7Uu+0z0kTcFftu
        +7iZ2TaRNnBlpv50A3PmIqc=
X-Google-Smtp-Source: AK7set+TSCA/O5H6LC15wJ4XsXc18/xCNWC1Hi9mT8wSAUEx3BKGkcDs/1d/HU7YC/p7AGaQJKEYwA==
X-Received: by 2002:a05:6a21:99a1:b0:bc:bdb1:165a with SMTP id ve33-20020a056a2199a100b000bcbdb1165amr1404578pzb.39.1676351306977;
        Mon, 13 Feb 2023 21:08:26 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:26 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 06/12] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
Date:   Tue, 14 Feb 2023 13:07:51 +0800
Message-Id: <20230214050757.9623-7-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
References: <20230214050757.9623-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The AMD PerfMonV2 defines three registers similar to part of the Intel
v2 PMU registers, including the GLOBAL_CTRL, GLOBAL_STATUS and
GLOBAL_OVF_CTRL MSRs. For better code reuse, this specific part of
the handling can be extracted to make it generic for X86 as a straight
code movement.

Specifically, move the kvm_pmu_set/get_msr() hanlders of GLOBAL_STATUS,
GLOBAL_CTRL, GLOBAL_OVF_CTRL defined by intel to generic pmu.c and
remove the callback function .pmc_is_globally_enabled, which is very
helpful to introduce the AMD PerfMonV2 code later.

The new non-prefix pmc_is_globally_enabled() works well as legacy AMD
vPMU version is indexed as 1. Note that the specific *_is_valid_msr will
continue to be used to avoid cross-vendor msr access.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/kvm/pmu.c                     | 55 +++++++++++++++++++++++---
 arch/x86/kvm/pmu.h                     | 17 +++++++-
 arch/x86/kvm/svm/pmu.c                 |  9 -----
 arch/x86/kvm/vmx/pmu_intel.c           | 49 +----------------------
 5 files changed, 67 insertions(+), 64 deletions(-)

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
index af541c913acd..5a3428d212dd 100644
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
@@ -574,11 +569,61 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u32 msr = msr_info->index;
+
+	switch (msr) {
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+		msr_info->data = pmu->global_status;
+		return 0;
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+		msr_info->data = pmu->global_ctrl;
+		return 0;
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		msr_info->data = 0;
+		return 0;
+	default:
+		break;
+	}
+
 	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
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
+		return 0;
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+		if (!kvm_valid_perf_global_ctrl(pmu, data))
+			return 1;
+
+		if (pmu->global_ctrl != data) {
+			diff = pmu->global_ctrl ^ data;
+			pmu->global_ctrl = data;
+			reprogram_counters(pmu, diff);
+		}
+		return 0;
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		if (data & pmu->global_ovf_ctrl_mask)
+			return 1;
+
+		if (!msr_info->host_initiated)
+			pmu->global_status &= ~data;
+		return 0;
+	default:
+		break;
+	}
+
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
 	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
 }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 1eb50129fae7..d1cc02c8da88 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -20,7 +20,6 @@
 
 struct kvm_pmu_ops {
 	bool (*hw_event_available)(struct kvm_pmc *pmc);
-	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
@@ -201,6 +200,22 @@ static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
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
index cc77a0681800..9e12142e0c4b 100644
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
index aaea25d2cae8..52b9339f2644 100644
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
@@ -186,9 +175,6 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
-	case MSR_CORE_PERF_GLOBAL_STATUS:
-	case MSR_CORE_PERF_GLOBAL_CTRL:
-	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		return intel_pmu_has_perf_global_ctrl(pmu);
 		break;
 	case MSR_IA32_PEBS_ENABLE:
@@ -340,15 +326,6 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		msr_info->data = pmu->fixed_ctr_ctrl;
 		return 0;
-	case MSR_CORE_PERF_GLOBAL_STATUS:
-		msr_info->data = pmu->global_status;
-		return 0;
-	case MSR_CORE_PERF_GLOBAL_CTRL:
-		msr_info->data = pmu->global_ctrl;
-		return 0;
-	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		msr_info->data = 0;
-		return 0;
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		return 0;
@@ -396,29 +373,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
-	case MSR_CORE_PERF_GLOBAL_STATUS:
-		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))
-			return 1; /* RO MSR */
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
-		if (data & pmu->global_ovf_ctrl_mask)
-			return 1;
-
-		if (!msr_info->host_initiated)
-			pmu->global_status &= ~data;
-		break;
 	case MSR_IA32_PEBS_ENABLE:
 		if (data & pmu->pebs_enable_mask)
 			return 1;
@@ -777,7 +731,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 
 		if (!pmc || !pmc_speculative_in_use(pmc) ||
-		    !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
+		    !pmc_is_globally_enabled(pmc) || !pmc->perf_event)
 			continue;
 
 		/*
@@ -792,7 +746,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.hw_event_available = intel_hw_event_available,
-	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.39.1

