Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859DE4CFD8A
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbiCGMAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239347AbiCGMA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:00:29 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E176A30F71;
        Mon,  7 Mar 2022 03:59:33 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d17so4708768pfv.6;
        Mon, 07 Mar 2022 03:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SbIe1jmzZriCtOAmZpG+IziwRSOjn5LL7LCxlcGebcE=;
        b=QRwfm+h9z9DxkGRkV2WXSJBLC5Af1VN/2aFBjg+UU6xc39OUoKZkzL2pBD6jdHc3Hb
         5tLQwHaHUsvevSnz+QnAW3sCeAIjNszK5f0bs4sw3HO6m72YxLcHANYjZd6zK70wekSJ
         ER8O374/63WRWxBBItGif4a1R9cKrPyE32r8mQfAz1SQl1TFJizc3nQ5csl5zA35kVpm
         JQCx/UaGc6d1gQD3gbyGi7Blrj/aPgf/ZGDQfF+5BSVDXRYWRwcYDLA0+KntL6R/o1Po
         EUoxWDkI+hap8Ae5fg1L4nRI9yg4blBBWRLVLD1ejtZWAiciI8TyNdqlJMqWxRZGKL4m
         ao0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SbIe1jmzZriCtOAmZpG+IziwRSOjn5LL7LCxlcGebcE=;
        b=PPHKJL2zXxX5pAMETk8hyhXrq75ZmblIbdf+iub+IbxIgZivWUUSboQxuVjoI7vnm+
         yTcc5rUewQ4z5RrqqDfBFzxL5W+dwKd83KRIp6gjR5SWpwsVr0z/zHiAuTjybKYqtYEc
         AaxIk6xyPVyG2YuPrKPUFJ+qN4le2Grd0Me7a/wQ8DSvA7reXpTjYMlx3/PFxZpObejr
         XgZq9SiBIAWXuWIn3yBwxMeIQKVXv48ckojvjlDB8iL6Qldp45iAwdHeWYQI+XQr6G66
         4e3Z6EQ3yPBlpam/Vf9/CtP0DKZQnF/orrxUYmE4KMrKnln5ZJD4eBKMqdhr65Lv/9B6
         s/YQ==
X-Gm-Message-State: AOAM531/R8XsEh10EU4DO3WaMFqkY5C4nCzuZWr/q/tsivpNse6jx+ro
        rGvxRgPUTOBtUkW+yFL3QksuAFUe93VtSQ==
X-Google-Smtp-Source: ABdhPJzbZCw/O3sJ8UtEPyAkHEk2HLA4P0v68xg205awyEKxscJK+QpUp7XwmKbAWU7tfOvjSXbYoA==
X-Received: by 2002:a63:4543:0:b0:374:87b6:c9f5 with SMTP id u3-20020a634543000000b0037487b6c9f5mr9559195pgk.302.1646654373405;
        Mon, 07 Mar 2022 03:59:33 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m6-20020a62f206000000b004e152bc0527sm15323164pfh.153.2022.03.07.03.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:59:33 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
Date:   Mon,  7 Mar 2022 19:59:18 +0800
Message-Id: <20220307115920.51099-3-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307115920.51099-1-likexu@tencent.com>
References: <20220307115920.51099-1-likexu@tencent.com>
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

Replace the kvm_pmu_ops pointer in common x86 with an instance of the
struct to save one pointer dereference when invoking functions. Copy the
struct by value to set the ops during kvm_init().

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 44 +++++++++++++++++++++++---------------------
 arch/x86/kvm/pmu.h |  4 +++-
 arch/x86/kvm/x86.c |  1 +
 3 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b1a02993782b..771edc4f4494 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -49,6 +49,8 @@
  *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] <=> gp counters
  */
 
+struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
+
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 {
 	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
@@ -215,7 +217,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
+		config = kvm_pmu_ops.pmc_perf_hw_id(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
@@ -267,7 +269,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
+			      kvm_pmu_ops.pmc_perf_hw_id(pmc),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi, false, false);
@@ -276,7 +278,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 {
-	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
+	struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, pmc_idx);
 
 	if (!pmc)
 		return;
@@ -298,7 +300,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	int bit;
 
 	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
-		struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
+		struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, bit);
 
 		if (unlikely(!pmc || !pmc->perf_event)) {
 			clear_bit(bit, pmu->reprogram_pmi);
@@ -320,7 +322,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 /* check if idx is a valid index to access PMU */
 bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return kvm_x86_ops.pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
+	return kvm_pmu_ops.is_valid_rdpmc_ecx(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -370,7 +372,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_x86_ops.pmu_ops->rdpmc_ecx_to_pmc(vcpu, idx, &mask);
+	pmc = kvm_pmu_ops.rdpmc_ecx_to_pmc(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -386,22 +388,22 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
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
@@ -409,13 +411,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
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
@@ -424,7 +426,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops.pmu_ops->refresh(vcpu);
+	kvm_pmu_ops.refresh(vcpu);
 }
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
@@ -432,7 +434,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	irq_work_sync(&pmu->irq_work);
-	kvm_x86_ops.pmu_ops->reset(vcpu);
+	kvm_pmu_ops.reset(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
@@ -440,7 +442,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	kvm_x86_ops.pmu_ops->init(vcpu);
+	kvm_pmu_ops.init(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
@@ -472,14 +474,14 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
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
@@ -509,7 +511,7 @@ static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 	unsigned int config;
 
 	pmc->eventsel &= (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
-	config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
+	config = kvm_pmu_ops.pmc_perf_hw_id(pmc);
 	pmc->eventsel = old_eventsel;
 	return config == perf_hw_id;
 }
@@ -537,7 +539,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	int i;
 
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
-		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
+		pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, i);
 
 		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
 			continue;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..7032d3ebf8f4 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -17,6 +17,8 @@
 
 #define MAX_FIXED_COUNTERS	3
 
+extern struct kvm_pmu_ops kvm_pmu_ops;
+
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
@@ -90,7 +92,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
 
 static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 {
-	return kvm_x86_ops.pmu_ops->pmc_is_enabled(pmc);
+	return kvm_pmu_ops.pmc_is_enabled(pmc);
 }
 
 static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b4e84d80b57..dcaeedeef675 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11536,6 +11536,7 @@ int kvm_arch_hardware_setup(void *opaque)
 		return r;
 
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
+	memcpy(&kvm_pmu_ops, kvm_x86_ops.pmu_ops, sizeof(kvm_pmu_ops));
 	kvm_ops_static_call_update();
 
 	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);
-- 
2.35.1

