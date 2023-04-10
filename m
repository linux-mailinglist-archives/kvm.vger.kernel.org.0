Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C694B6DC5E2
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjDJKv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjDJKv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:51:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69044236;
        Mon, 10 Apr 2023 03:51:23 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-246bc3d38cdso74449a91.1;
        Mon, 10 Apr 2023 03:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123883; x=1683715883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RWeR6igNoML2gvd7fvpyzsafAnh0P7tkBzGcnQmcT0Q=;
        b=mAFiJFjZ5RR/d+jCmRdN3sucO+P7ZxYhUzI//njZFWtlb5pxFMhYuDhN7REm1BqPWK
         FmkiJpM1Vu8uerP8nSrDm0j4kNbjQFLcTT3fgO71j8fpLKMqkw2AZ2WOUWLj+5AbSjYs
         Msjhue85Kkjtf2mfpci+P1VA5n74HzQeiZDItr6PtgK0++JIrbTi8n1ITEi/YBz/DiqT
         y0/YENEQtPlQTdDj9LjOIl73KUasapHToshxKfZ/btXqAZk0N0qUcv/4H1RoHbbCFidL
         fvY/nXHs4y3kIaAt6xMdHoY74i96Mx9hloCvL+pNshs8DHYqMGEQdhGWlsJLxOKpBJcj
         Iewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123883; x=1683715883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RWeR6igNoML2gvd7fvpyzsafAnh0P7tkBzGcnQmcT0Q=;
        b=2VEyjWgR3DnxV6BbvwFHC3YsKLk/jAjvkJiu6ts288Cddqq+bdxwYm1Bh6UEdW+jym
         MczbRSyKNl4ahdsSddwf6gW0v5LQaIVnln4W4yiS4ivcv8KSeqtGwumSJD+Ko7c7Acs/
         j9aGvsh0z4vxU3Oi29HS/+8i2fpL66iYbTRkCrbRSlOKPRuzR95z15fy7JKATCuaRnYv
         PXVTGSPxHV4nfaKOwiWgk194yVUJmNZbwoPj37+YeYVq9BfDI0zymgYKEd+z33BMWkxD
         OvY/vlwhljlukEdkfi+X/KJXkpwMbqXcK4cRoNkzXqA65hXeOraxWCvwQULWT6XUljj8
         nF9A==
X-Gm-Message-State: AAQBX9fDAhSIPZOphdXZEjrSIX6Oreg9/zGY5Jhwjahm3KWBKGi2/nkD
        zoQ6hBO0Xpeb1W2dyb1ht5Q=
X-Google-Smtp-Source: AKy350ZnV4dOlBVNpvrrEZvXGlK1ArpnwB2TDYOOJ2TM7ATXsS6Wp7qLyHAURUFsPOAUrfT/S43I2w==
X-Received: by 2002:aa7:9488:0:b0:637:ecd6:cb0e with SMTP id z8-20020aa79488000000b00637ecd6cb0emr2717323pfk.23.1681123882913;
        Mon, 10 Apr 2023 03:51:22 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:22 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 03/10] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs handling x86 generic
Date:   Mon, 10 Apr 2023 18:50:49 +0800
Message-Id: <20230410105056.60973-4-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230410105056.60973-1-likexu@tencent.com>
References: <20230410105056.60973-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 597a8f8f90b9..69d0a3ae7b45 100644
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
2.40.0

