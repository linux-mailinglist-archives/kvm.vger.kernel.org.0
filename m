Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18B447E94
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbhKHLNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbhKHLNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:47 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4698CC061746;
        Mon,  8 Nov 2021 03:11:03 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so4130383pjj.0;
        Mon, 08 Nov 2021 03:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vUAqZwFKsYN3uK9M4YrApSgCvGlMCSiYQp4Tquu3W2A=;
        b=Bk1rIbu98VM5kQhofNWut0oL4HooOc9wogoQ1vpbOtGxLgIf9YQu/kUfAzcKc2Jk4Q
         nrSW1IN1/lB8gvMORZ7+uAXgmR8lYCNZ6M76fwytsaByrB/Ae2eNCDVwjoRO+/J3HcTN
         sFeh9JqPWFrR3mUgGqt1hVe3+Dd7wQqSbQK+eEvYMpbSCVvhU8pVHRYaAdR8+cL8TJcj
         nC0uhj21uAbihZ8tTYdTpIsC8NWG4uUj36Q6TTU/DjPPlZ674nBd0RPdZKt/T4WG0u6Q
         1l+8TcZsYJzOwDo0wbmifN3vLEcUo2w2L7qhJpsFstLjjoKZqe8+z01fc96rHU8cavuq
         ucMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vUAqZwFKsYN3uK9M4YrApSgCvGlMCSiYQp4Tquu3W2A=;
        b=pbg67pZaPdzLhQ3K8du0wj3CqPyNlaP9naSVRBv0bWTtotPZzgOGElTpKtBTPdgPEr
         dVnvBCXkUz2X9pZtDgdv7455Ad+XiGe4DTMloKOZTmWa+ocmN0maoFyIKDeCmDmSizfJ
         lvryqi6EPGuAXEUIWF8xDNhzsnRYdTa4ENSrRFF3kG3chcbMjAw5Hdmxnh1O4IKYF1Mn
         Qk4LLkLE1w+keRwrnFwJcnImD1RoUpmhUkFyI1cOWqYFWDFTJrhI4p5ttc4Fk6HR+kFA
         K3CI6X3QEfuGAfy1qtEtUFfS6bHWtkjW6JHXOGKeJ8XFlk0HLOOy6Ms0tKJsi/6O3y3I
         tVwg==
X-Gm-Message-State: AOAM530IO8arxk5k5LGH2s3Jqncl5haKTyw0v+4HoN4iTdo+xNH3golu
        CyFL8iIKogGIEf1sdy5y5HE=
X-Google-Smtp-Source: ABdhPJwPtF9ihW9kWSN60rI0oUUKYmiVDADcO8nar2zEh+YWrQmKiEmIWmBOjtqgFQOQyTOhBRseCw==
X-Received: by 2002:a17:902:bd01:b0:141:6232:6f89 with SMTP id p1-20020a170902bd0100b0014162326f89mr69429459pls.12.1636369862851;
        Mon, 08 Nov 2021 03:11:02 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ne7sm16559483pjb.36.2021.11.08.03.11.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:11:02 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] KVM: x86: Use static calls to reduce kvm_pmu_ops overhead
Date:   Mon,  8 Nov 2021 19:10:32 +0800
Message-Id: <20211108111032.24457-8-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108111032.24457-1-likexu@tencent.com>
References: <20211108111032.24457-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Convert kvm_pmu_ops to use static calls.

Here are the worst sched_clock() nanosecond numbers for the kvm_pmu_ops
functions that is most often called (up to 7 digits of calls) when running
a single perf test case in a guest on an ICX 2.70GHz host (mitigations=on):

		|	legacy	|	static call
------------------------------------------------------------
.pmc_idx_to_pmc	|	10946	|	10047 (8%)
.pmc_is_enabled	|	11291	|	11175 (1%)
.msr_idx_to_pmc	|	13526	|	12346 (8%)
.is_valid_msr	|	10895	|	10484 (3%)

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 36 +++++++++++++++++-------------------
 arch/x86/kvm/pmu.h |  2 +-
 arch/x86/kvm/x86.c |  5 +++++
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bfdd9f2bc0fa..c86ff3057e2c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -223,7 +223,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_pmu_ops.find_arch_event(pmc_to_pmu(pmc),
+		config = static_call(kvm_x86_pmu_find_arch_event)(pmc_to_pmu(pmc),
 						      event_select,
 						      unit_mask);
 		if (config != PERF_COUNT_HW_MAX)
@@ -277,7 +277,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_pmu_ops.find_fixed_event(idx),
+			      static_call(kvm_x86_pmu_find_fixed_event)(idx),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi, false, false);
@@ -286,7 +286,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 {
-	struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, pmc_idx);
+	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, pmc_idx);
 
 	if (!pmc)
 		return;
@@ -308,7 +308,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	int bit;
 
 	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
-		struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, bit);
+		struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit);
 
 		if (unlikely(!pmc || !pmc->perf_event)) {
 			clear_bit(bit, pmu->reprogram_pmi);
@@ -330,7 +330,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 /* check if idx is a valid index to access PMU */
 int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return kvm_pmu_ops.is_valid_rdpmc_ecx(vcpu, idx);
+	return static_call(kvm_x86_pmu_is_valid_rdpmc_ecx)(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -380,7 +380,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_pmu_ops.rdpmc_ecx_to_pmc(vcpu, idx, &mask);
+	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -396,23 +396,22 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu)) {
-		if (kvm_pmu_ops.deliver_pmi)
-			kvm_pmu_ops.deliver_pmi(vcpu);
+		static_call_cond(kvm_x86_pmu_deliver_pmi)(vcpu);
 		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
 	}
 }
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
-	return kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr) ||
-		kvm_pmu_ops.is_valid_msr(vcpu, msr);
+	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
+		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_is_valid_msr);
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr);
+	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -420,13 +419,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	return kvm_pmu_ops.get_msr(vcpu, msr_info);
+	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
-	return kvm_pmu_ops.set_msr(vcpu, msr_info);
+	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
 }
 
 /* refresh PMU settings. This function generally is called when underlying
@@ -435,7 +434,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
-	kvm_pmu_ops.refresh(vcpu);
+	static_call(kvm_x86_pmu_refresh)(vcpu);
 }
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
@@ -443,7 +442,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	irq_work_sync(&pmu->irq_work);
-	kvm_pmu_ops.reset(vcpu);
+	static_call(kvm_x86_pmu_reset)(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
@@ -451,7 +450,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	kvm_pmu_ops.init(vcpu);
+	static_call(kvm_x86_pmu_init)(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
@@ -483,14 +482,13 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 		      pmu->pmc_in_use, X86_PMC_IDX_MAX);
 
 	for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
-		pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, i);
+		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
 		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
 			pmc_stop_counter(pmc);
 	}
 
-	if (kvm_pmu_ops.cleanup)
-		kvm_pmu_ops.cleanup(vcpu);
+	static_call_cond(kvm_x86_pmu_cleanup)(vcpu);
 
 	bitmap_zero(pmu->pmc_in_use, X86_PMC_IDX_MAX);
 }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 40e0b523637b..a4bfd4200d67 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -99,7 +99,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
 
 static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 {
-	return kvm_pmu_ops.pmc_is_enabled(pmc);
+	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
 }
 
 static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70dc8f41329c..c5db444d5f4a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11306,6 +11306,11 @@ static inline void kvm_ops_static_call_update(void)
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func)
 #define KVM_X86_OP_NULL KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
+
+#define	KVM_X86_PMU_OP(func)	\
+	static_call_update(kvm_x86_pmu_##func, kvm_pmu_ops.func)
+#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
 }
 
 int kvm_arch_hardware_setup(void *opaque)
-- 
2.33.0

