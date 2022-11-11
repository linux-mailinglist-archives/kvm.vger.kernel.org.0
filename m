Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E80625845
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiKKK1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiKKK1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:27:12 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C171D6455;
        Fri, 11 Nov 2022 02:27:11 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id y203so4549315pfb.4;
        Fri, 11 Nov 2022 02:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NWeg3l+WCE6eWRvhaYi2P6vdJ+3aID8zZxapaCNApo0=;
        b=TQJywnEeaur2+0Potwijl74nUNV0otwbIjE6nnr4NIFp0HPpYNyy2Kf/kq63r7X3aX
         SsovMsPJnzs/6bZJqjdAiq810UQniYuy8BnXEtZzsqjlloEgkyNa6qrOCmiERAOD2f6s
         ztZ7rQ3kEeHLArDRyrpC4sXwDw0KMkBIpKahXJBBntxc+Pl462SzHHhTA+3hH3zOGbck
         L0pEsBvsg6Y5zpy4ybJc09JonOuPXNqFAOuAWUscrYKPadJ3DnW6BY/zBZaedsKM11rw
         9O1ZgtrSoUrnQTYZPwaKiCf8cgH1l17b4bwBXHklxELgYpfbhCnzAdXwKb3tuUsLn4wV
         3DUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NWeg3l+WCE6eWRvhaYi2P6vdJ+3aID8zZxapaCNApo0=;
        b=xx6GFpR7DIbB5KqyznMEpAASChLhQPKz0GkNW7Vp2t8KIzY4djb2DHzfPMsJVtOcIn
         2k26HAvEFZsNfkgfXb+KQ+wNIbCHSYluUur4m7zFoFhIZOS4z3gZLv6jMEJpIWIzupRt
         dStdz2NrWmx36ib9Y//bgbsuLxxtiluDirLaY+eDQlkpE5pxWHlCxnUF3vzDguqULZKq
         eM24BjLSal0SrtZsLdAeB3qQoZBtgcRCb3dOGkcv1FvsjP26Sv7+KqcfMxICYfFjs1Zl
         Y52JsuETPZaQ7GbkQTWtdZutRtZgVp3D+Lzw5lGy8e21BpNmzzn/tVCR1wToGF9bXF4T
         YtrQ==
X-Gm-Message-State: ANoB5pmZFl9vXJvBWvD3jedtycg7Zpo7dGizQ9cS3dybeK/uM8qg2SkI
        MBdKEF09nwtR8YjM9VaROqo=
X-Google-Smtp-Source: AA0mqf7yW5bIHYRnnzhAVOut3bny7oSHBO5hdOIBO068cXh52pgsDfQIV5MN8e5AZBN4TqeZkwM5gQ==
X-Received: by 2002:a63:5320:0:b0:46e:e210:a491 with SMTP id h32-20020a635320000000b0046ee210a491mr1157471pgb.96.1668162431231;
        Fri, 11 Nov 2022 02:27:11 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u67-20020a626046000000b0056b6acb58a0sm1248612pfb.102.2022.11.11.02.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 02:27:11 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/8] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
Date:   Fri, 11 Nov 2022 18:26:41 +0800
Message-Id: <20221111102645.82001-5-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111102645.82001-1-likexu@tencent.com>
References: <20221111102645.82001-1-likexu@tencent.com>
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
 arch/x86/kvm/vmx/pmu_intel.c           | 46 +--------------------
 5 files changed, 67 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 86a3fb01e103..6c98f4bb4228 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -13,7 +13,6 @@ BUILD_BUG_ON(1)
  * at the call sites.
  */
 KVM_X86_PMU_OP(hw_event_available)
-KVM_X86_PMU_OP(pmc_is_globally_enabled)
 KVM_X86_PMU_OP(pmc_idx_to_pmc)
 KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
 KVM_X86_PMU_OP(msr_idx_to_pmc)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e57f707fb940..a3726af5416d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -83,11 +83,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
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
@@ -471,11 +466,61 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
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
+		if (!msr_info->host_initiated)
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
index be552c8217a0..8739e5ea2835 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -26,7 +26,6 @@ struct kvm_event_hw_type_mapping {
 
 struct kvm_pmu_ops {
 	bool (*hw_event_available)(struct kvm_pmc *pmc);
-	bool (*pmc_is_globally_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
@@ -200,6 +199,22 @@ static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 	}
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
index 7958a983b760..4e7d7e6cccec 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -76,14 +76,6 @@ static bool amd_hw_event_available(struct kvm_pmc *pmc)
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
@@ -218,7 +210,6 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.hw_event_available = amd_hw_event_available,
-	.pmc_is_globally_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index db704eea2d7c..f95f8d1db2cf 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -90,17 +90,6 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
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
@@ -335,15 +324,6 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -391,29 +371,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
 		break;
-	case MSR_CORE_PERF_GLOBAL_STATUS:
-		if (!msr_info->host_initiated)
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
@@ -773,7 +730,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 
 		if (!pmc || !pmc_speculative_in_use(pmc) ||
-		    !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
+		    !pmc_is_globally_enabled(pmc) || !pmc->perf_event)
 			continue;
 
 		/*
@@ -788,7 +745,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.hw_event_available = intel_hw_event_available,
-	.pmc_is_globally_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.38.1

