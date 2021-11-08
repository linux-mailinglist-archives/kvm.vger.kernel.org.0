Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023D0447E8D
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbhKHLNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239016AbhKHLNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:39 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903E0C061714;
        Mon,  8 Nov 2021 03:10:55 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u11so15565710plf.3;
        Mon, 08 Nov 2021 03:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kHBzy264HfP+fEwCgrD2AXuk2kQWTQNkuleAS7P7egg=;
        b=CHR1y68hI5pVrjvkXOV2rFLivt+U2CE60eqHV/TsJlZ47sRa7r2YNPAAIXrx0kieXw
         Wn9ex5omAUKps+SiueFHTxVWF8+APPvnvKFcPCrPJFaaeIGt+7/kzS257D8rH8bBsjEb
         coolgCh2DyB3VSzHczYyXj61BEqSdp34EeZHr0hYKUUxV3ZMzarVafrwdwv51Qjna/xt
         dXz7toW8HZ2TqRRlOon+QU7jFMowJBPjg/QIn5x1z1obs0EnqG1mQWthzmgf4E6uMGMo
         qPcEjtEqrihnUNnPchl9QQ3T5+CDroLCRLTGxRpMaktFXfJf2iuXSDC3vAT6YE6P4zCk
         yEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kHBzy264HfP+fEwCgrD2AXuk2kQWTQNkuleAS7P7egg=;
        b=tS1MiOgj5HkHJ9JATWQClfdHntkJjL4gwMxS+ZOsDCVkat5wvL0K57/0gvFXQfhT+O
         FroTSLBOTahUsf95tR+7toVNZQ17wz5jjCvZSpV9C9SrvPwdtun2QYSevZAcjzQe2lf3
         2uhawx5Gle9+TZBgsrlw1swxMXNnBrfCQUqbXwbXLIyyDUuWbC/uoAS4Qqo4A1Dqkhmp
         wdqjJTPMielp5HQLAwHa83JmQh+HP6MTYVlMVzK9E2y88c2hoqtFPHN7D7K8ybt6nwIN
         IhbbrfitBeneApx2blMri3iysm6uYAXRYTMS6cPIRCRTPQvx9iemvQx9IQQf08hYXJZ2
         ELqA==
X-Gm-Message-State: AOAM531DIr2AdIDWO4xdPWi3xgXt+H7EY6blPzIWmLeqbpcCk939ZGto
        VGtKbI61MwNFBtKhiHZbHwQ=
X-Google-Smtp-Source: ABdhPJxRL15ZEGzeiG8Urf9eRIJs58pB1QTBs1t/ipZK6nwBgEDxAM0xQl4a4JeNxo/Qr6kLe1PbSg==
X-Received: by 2002:a17:90b:1bd1:: with SMTP id oa17mr38910425pjb.246.1636369855077;
        Mon, 08 Nov 2021 03:10:55 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ne7sm16559483pjb.36.2021.11.08.03.10.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:10:54 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
Date:   Mon,  8 Nov 2021 19:10:29 +0800
Message-Id: <20211108111032.24457-5-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108111032.24457-1-likexu@tencent.com>
References: <20211108111032.24457-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Replace the kvm_pmu_ops pointer in common x86 with an instance of the
struct to save one pointer dereference when invoking functions. Copy the
struct by value to set the ops during kvm_init().

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 41 ++++++++++++++++++++++-------------------
 arch/x86/kvm/pmu.h |  4 +++-
 arch/x86/kvm/x86.c |  1 +
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index aa6ac9c7aff2..353989bf0102 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -47,6 +47,9 @@
  *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] <=> gp counters
  */
 
+struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
+EXPORT_SYMBOL_GPL(kvm_pmu_ops);
+
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 {
 	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
@@ -214,7 +217,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_x86_ops.pmu_ops->find_arch_event(pmc_to_pmu(pmc),
+		config = kvm_pmu_ops.find_arch_event(pmc_to_pmu(pmc),
 						      event_select,
 						      unit_mask);
 		if (config != PERF_COUNT_HW_MAX)
@@ -268,7 +271,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_x86_ops.pmu_ops->find_fixed_event(idx),
+			      kvm_pmu_ops.find_fixed_event(idx),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi, false, false);
@@ -277,7 +280,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 {
-	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
+	struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, pmc_idx);
 
 	if (!pmc)
 		return;
@@ -299,7 +302,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	int bit;
 
 	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
-		struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+		struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, bit);
 
 		if (unlikely(!pmc || !pmc->perf_event)) {
 			clear_bit(bit, pmu->reprogram_pmi);
@@ -321,7 +324,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 /* check if idx is a valid index to access PMU */
 int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return kvm_x86_ops.pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
+	return kvm_pmu_ops.is_valid_rdpmc_ecx(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -371,7 +374,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_x86_ops.pmu_ops->rdpmc_ecx_to_pmc(vcpu, idx, &mask);
+	pmc = kvm_pmu_ops.rdpmc_ecx_to_pmc(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -387,23 +390,23 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu)) {
-		if (kvm_x86_ops.pmu_ops->deliver_pmi)
-			kvm_x86_ops.pmu_ops->deliver_pmi(vcpu);
+		if (kvm_pmu_ops.deliver_pmi)
+			kvm_pmu_ops.deliver_pmi(vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
 	}
 }
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
-	return kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
-		kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, msr);
+	return kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr) ||
+		kvm_pmu_ops.is_valid_msr(vcpu, msr);
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_is_valid_msr);
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr);
+	struct kvm_pmc *pmc = kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -411,13 +414,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	return kvm_x86_ops.pmu_ops->get_msr(vcpu, msr_info);
+	return kvm_pmu_ops.get_msr(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
-	return kvm_x86_ops.pmu_ops->set_msr(vcpu, msr_info);
+	return kvm_pmu_ops.set_msr(vcpu, msr_info);
 }
 
 /* refresh PMU settings. This function generally is called when underlying
@@ -426,7 +429,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops.pmu_ops->refresh(vcpu);
+	kvm_pmu_ops.refresh(vcpu);
 }
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
@@ -434,7 +437,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	irq_work_sync(&pmu->irq_work);
-	kvm_x86_ops.pmu_ops->reset(vcpu);
+	kvm_pmu_ops.reset(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
@@ -442,7 +445,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	kvm_x86_ops.pmu_ops->init(vcpu);
+	kvm_pmu_ops.init(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
@@ -474,14 +477,14 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 		      pmu->pmc_in_use, X86_PMC_IDX_MAX);
 
 	for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
-		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
+		pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, i);
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
 	}
 
-	if (kvm_x86_ops.pmu_ops->cleanup)
-		kvm_x86_ops.pmu_ops->cleanup(vcpu);
+	if (kvm_pmu_ops.cleanup)
+		kvm_pmu_ops.cleanup(vcpu);
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0e4f2b1fa9fb..b2fe135d395a 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -17,6 +17,8 @@
 
 #define MAX_FIXED_COUNTERS	3
 
+extern struct kvm_pmu_ops kvm_pmu_ops;
+
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
@@ -92,7 +94,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
 
 static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 {
-	return kvm_x86_ops.pmu_ops->pmc_is_enabled(pmc);
+	return kvm_pmu_ops.pmc_is_enabled(pmc);
 }
 
 static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0aee0a078d6f..ca9a76abb6ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11323,6 +11323,7 @@ int kvm_arch_hardware_setup(void *opaque)
 		return r;
 
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
+	memcpy(&kvm_pmu_ops, kvm_x86_ops.pmu_ops, sizeof(kvm_pmu_ops));
 	kvm_ops_static_call_update();
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-- 
2.33.0

