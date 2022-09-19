Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DFE5BC575
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 11:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiISJfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 05:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiISJfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 05:35:15 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3C61145E;
        Mon, 19 Sep 2022 02:35:13 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id e5so27516057pfl.2;
        Mon, 19 Sep 2022 02:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=0Aj4tTSXvBHIsrSsj8qfa018l7xGBXUxci/tZXK4PRE=;
        b=OBOhZC94ytOtkIB7jzJZnJGipIJ/slxl1CyVs17ZIoO1+bm1tg0GpEt4sr9TpIs/Ak
         hsTgVYhqlbDG7aJ9WiGQfYY2Va39AS40mS1qZ1pbcqmwEtEXJAnIrozz0iXROCyxSphQ
         1HsT5FnjhG955ZNEXApgtj3pCg+SoBLG8TSXRvxzW5b1aJjkX0BXiRpBsuEdyGfcAqLX
         jHHD+C4wwox8BAGGHS/27fB/qjHqUrdsnKjdSePJGZC4bs4vQycFhC09OSzbrYA/q448
         kDYT1hRV2L0PJDDgnVEWdROad66F8T+ZhmmqRHuXRRphZExBSyCicgIcCX8F+mUZfZ9H
         SrOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0Aj4tTSXvBHIsrSsj8qfa018l7xGBXUxci/tZXK4PRE=;
        b=70YY9znKefdSIgd9gEBjsOl4braonn+fyQBV8FOimShT4/xITQ72cXebWZ5TTF1l9M
         Cx/GwO9ip41IJn5OoxzsBbeUuB+X9JphNdhWa8r4RTJC4CMOmktnrnPspm/v1Fvwtj8G
         L/pSTY3eWzXYbH+Ida2vTcwOVBg6qEsF3h4xdWjeh6/6z4AwEJtpZ+VUg7kdpsMUT/x0
         Na4SJICTRSh2RvZQ/nHj1lccdAGSIzHnQuX5turlkOCClQI9RXJijuJDhx5ss4hu84ZK
         3SV+tFwH0hmF4n1r+sCUrYa+cjEbLoLYv5nrFkrKN2qxuAK9wCVHROTHccOCkvarvP+3
         R5Kg==
X-Gm-Message-State: ACrzQf0b1gkl7BjID3rGdak8oi09CYD8/Zm/Cu/nioPzIeNv9gh6woZk
        6fpejzOt24HgInFvzbOvCF8=
X-Google-Smtp-Source: AMsMyM5tCG92h8r7UQt7ng7Q03nuIRiZwJvVcldaT/tKmy0SxgGBYKSp9DOSxG3499Txrt8Xu5TehQ==
X-Received: by 2002:a63:575a:0:b0:439:169f:4b5a with SMTP id h26-20020a63575a000000b00439169f4b5amr15471476pgm.595.1663580113014;
        Mon, 19 Sep 2022 02:35:13 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w5-20020aa79545000000b0053818255880sm19815434pfq.193.2022.09.19.02.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 02:35:12 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
Date:   Mon, 19 Sep 2022 17:34:51 +0800
Message-Id: <20220919093453.71737-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220919093453.71737-1-likexu@tencent.com>
References: <20220919093453.71737-1-likexu@tencent.com>
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

The AMD PerfMonV2 defines three registers similar to part of the
Intel v2 PMU registers, including the GLOBAL_CTRL, GLOBAL_STATUS
and GLOBAL_OVF_CTRL MSRs. For better code reuse, this specific
part of the handling can be extracted to make it generic for X86.

The new non-prefix pmc_is_enabled() works well as legacy AMD vPMU
version is indexeqd as 1. Note that the specific *_is_valid_msr will
continue to be used to avoid cross-vendor msr access.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/kvm/pmu.c                     | 55 +++++++++++++++++++++---
 arch/x86/kvm/pmu.h                     | 30 ++++++++++++-
 arch/x86/kvm/svm/pmu.c                 |  9 ----
 arch/x86/kvm/vmx/pmu_intel.c           | 58 +-------------------------
 5 files changed, 80 insertions(+), 73 deletions(-)

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
index fabbc43031b3..2643a3994624 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -83,11 +83,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
 #undef __KVM_X86_PMU_OP
 }
 
-static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
-{
-	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
-}
-
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 {
 	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
@@ -455,11 +450,61 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
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
+		if (msr_info->host_initiated) {
+			pmu->global_status = data;
+			return 0;
+		}
+		break; /* RO MSR */
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+		if (pmu->global_ctrl == data)
+			return 0;
+		if (kvm_valid_perf_global_ctrl(pmu, data)) {
+			diff = pmu->global_ctrl ^ data;
+			pmu->global_ctrl = data;
+			reprogram_counters(pmu, diff);
+			return 0;
+		}
+		break;
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+		if (!(data & pmu->global_ovf_ctrl_mask)) {
+			if (!msr_info->host_initiated)
+				pmu->global_status &= ~data;
+			return 0;
+		}
+		break;
+	default:
+		break;
+	}
+
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
 	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
 }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 847e7112a5d3..0275f1bff5ea 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -26,7 +26,6 @@ struct kvm_event_hw_type_mapping {
 
 struct kvm_pmu_ops {
 	bool (*hw_event_available)(struct kvm_pmc *pmc);
-	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
@@ -189,6 +188,35 @@ static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
 
+/*
+ * Check if a PMC is enabled by comparing it against global_ctrl bits.
+ *
+ * If the current version of vPMU doesn't have global_ctrl MSR,
+ * all vPMCs are enabled (return TRUE).
+ */
+static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (pmu->version < 2)
+		return true;
+
+	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
+}
+
+static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
+{
+	int bit;
+
+	if (!diff)
+		return;
+
+	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
+		__set_bit(bit, pmu->reprogram_pmi);
+
+	kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index f99f2c869664..3a20972e9f1a 100644
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
-	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 612c89ef5398..12eb2edfe9bc 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,18 +68,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
-{
-	int bit;
-	struct kvm_pmc *pmc;
-
-	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
-		pmc = intel_pmc_idx_to_pmc(pmu, bit);
-		if (pmc)
-			kvm_pmu_request_counter_reprogam(pmc);
-	}
-}
-
 static bool intel_hw_event_available(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -102,17 +90,6 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
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
@@ -347,15 +324,6 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -404,29 +372,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
-	case MSR_CORE_PERF_GLOBAL_STATUS:
-		if (msr_info->host_initiated) {
-			pmu->global_status = data;
-			return 0;
-		}
-		break; /* RO MSR */
-	case MSR_CORE_PERF_GLOBAL_CTRL:
-		if (pmu->global_ctrl == data)
-			return 0;
-		if (kvm_valid_perf_global_ctrl(pmu, data)) {
-			diff = pmu->global_ctrl ^ data;
-			pmu->global_ctrl = data;
-			reprogram_counters(pmu, diff);
-			return 0;
-		}
-		break;
-	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		if (!(data & pmu->global_ovf_ctrl_mask)) {
-			if (!msr_info->host_initiated)
-				pmu->global_status &= ~data;
-			return 0;
-		}
-		break;
 	case MSR_IA32_PEBS_ENABLE:
 		if (pmu->pebs_enable == data)
 			return 0;
@@ -783,7 +728,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 
 		if (!pmc || !pmc_speculative_in_use(pmc) ||
-		    !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
+		    !pmc_is_enabled(pmc) || !pmc->perf_event)
 			continue;
 
 		hw_idx = pmc->perf_event->hw.idx;
@@ -795,7 +740,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.hw_event_available = intel_hw_event_available,
-	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.37.3

