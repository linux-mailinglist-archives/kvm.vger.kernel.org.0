Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8A3443D81
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhKCHGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbhKCHGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 03:06:00 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73157C061714;
        Wed,  3 Nov 2021 00:03:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id r5so1890800pls.1;
        Wed, 03 Nov 2021 00:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5/kU5qotulIdz4RQvPukUhsY06HNcD2se+CSZ3yeiVQ=;
        b=Q/imCNSQpHfxAwAiUrHxA8kVFvenR/FxeeDJkz3T0vP9ldB6zksXW3ojq9DSUFUXOe
         O3YxCExeWvIEERp2RKVih5Sm3PiTqGYQhz2oHqnylnSTCPqhzMN5xPlI1BMs/WUErQj1
         FC4qXtP9nDqTpw3TFJDHH6PMTCE7AcTgaoggQh3w5A0lcAZ6G/fcTZrviQ83dylLfILm
         JIkLpIdb1BC21ItFbnoupv2jQeRcU5Ue7YOoxBFFCRSUO5faC+ENeaAfUgBEhnsdt+Q1
         hvi/VUxXaYYKjSGn7iYQjjfsoX3JISvlJ5jiL6adJfxomrjbXXwurHd0Khh/XjgYW5wr
         ub5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5/kU5qotulIdz4RQvPukUhsY06HNcD2se+CSZ3yeiVQ=;
        b=BlRmKoP9RkDjCLRmD6jztfr1y2c3enoQZW0KXKRVI/KlfYDtFKnctlTfBF1s/Sfi3V
         0rNHqkZAZ8CO42s0sKdfnsobhjE2nFo2JpntjnzmInkmR/0M85op5iXsNaXQIy7XFG+r
         qgqb9rdLoguJ9uMcfc+oogLARrGW9qpPUORrIghPQQEnLC1l8p0ZeFx1mJ3XX7HyhX69
         IouvWKxhAH5fexvG7OThzxgSs+d3VSsKsUewuWPuUajpd2uu1fFbhO9LNmnVCJO31cDS
         Fr5qUHdRxfqEIYa2RHdLfXNeoAunQ+VjdJlxxtBCk/Irfv/ubJFeYwuoRlCE0pZAcSjW
         eFXg==
X-Gm-Message-State: AOAM532xmA9GCh0RRl11xYzmK7izeRICt5F3wOZBkJkCPsg6Bmy/TSfj
        fPGg9HDHz0FruAg16wNToX4=
X-Google-Smtp-Source: ABdhPJy21IF+pKr92lL0FteerlSRfxwxusTlcnZcLXocJiGmO3MnKjAYwmx31CM9rSzSmZ+iol3PJA==
X-Received: by 2002:a17:90a:4e02:: with SMTP id n2mr8902359pjh.170.1635923004036;
        Wed, 03 Nov 2021 00:03:24 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x9sm4242564pjp.50.2021.11.03.00.03.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Nov 2021 00:03:23 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
Date:   Wed,  3 Nov 2021 15:03:08 +0800
Message-Id: <20211103070310.43380-2-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103070310.43380-1-likexu@tencent.com>
References: <20211103070310.43380-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the kvm_pmu_ops pointer in common x86 with an instance of the
struct to save one pointer dereference when invoking functions. Copy the
struct by value to set the ops during kvm_init().

Using kvm_x86_ops.hardware_enable to track whether or not the
ops have been initialized, i.e. a vendor KVM module has been loaded.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c        | 41 +++++++++++++++++++++------------------
 arch/x86/kvm/pmu.h        |  4 +++-
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/x86.c        |  3 +++
 4 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0772bad9165c..0db1887137d9 100644
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
 
@@ -387,22 +390,22 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
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
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr);
+	struct kvm_pmc *pmc = kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -410,13 +413,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
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
@@ -425,7 +428,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops.pmu_ops->refresh(vcpu);
+	kvm_pmu_ops.refresh(vcpu);
 }
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
@@ -433,7 +436,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	irq_work_sync(&pmu->irq_work);
-	kvm_x86_ops.pmu_ops->reset(vcpu);
+	kvm_pmu_ops.reset(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
@@ -441,7 +444,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	kvm_x86_ops.pmu_ops->init(vcpu);
+	kvm_pmu_ops.init(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
@@ -473,14 +476,14 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
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
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b4ee5e9f9e20..1e793e44b5ff 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4796,7 +4796,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
 		return;
 
 	vmx = to_vmx(vcpu);
-	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
+	if (kvm_pmu_ops.is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
 		vmx->nested.msrs.entry_ctls_high |=
 				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 		vmx->nested.msrs.exit_ctls_high |=
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..72d286595012 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11317,6 +11317,9 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
+	if (kvm_x86_ops.hardware_enable)
+		memcpy(&kvm_pmu_ops, kvm_x86_ops.pmu_ops, sizeof(kvm_pmu_ops));
+
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
 
-- 
2.33.0

