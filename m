Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9B74CFD8D
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 12:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbiCGMAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240078AbiCGMAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:00:33 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1B566AC0;
        Mon,  7 Mar 2022 03:59:38 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id bc27so13372417pgb.4;
        Mon, 07 Mar 2022 03:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TNnPRy1cmbOAFkP5qd6ZOC7OMQvSH+mBx5Z1HHbtWiY=;
        b=WO0i27nVHFtDUv3vLN/FwV4XMdL32nKhchFUrtGHgPUcz6viAQwpwMeYkyuMiL79ps
         bfQS/EuCYHH1bvnUdc1nZ0azWuN977UMqPUfC9SzM8WEKCqcxFuLMH73wASqxfaxr/xr
         YVcdiTCtwp/htRgw9q6GFSe03HX7SNZT72H58X5RR660zaaWzDItWbNOx8NkAaTzbh7+
         qNFI4+uPlCdXRqnz+kevL6RiE3sxSadBwcGyVOwBSZ6ZZTldkqx8oNwjc5QSw4ua3JgR
         oHSPZtk3NBGDd+htVCmbY9wXmGEywZfnd3+eNS8FGtQfLWWjghf9LuLsJvGR7diF8cCX
         ZrIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TNnPRy1cmbOAFkP5qd6ZOC7OMQvSH+mBx5Z1HHbtWiY=;
        b=tNnAGRcsghrDLA5v4zUW+0i3sZSPoFF/2hCo14KEkDFXEmpQ58CdP3lGkNjKRUETng
         4X/gdgtSXQQ65lQochAbR11utgl6kSgknCFgTTPX7rYwwxY+VuU6TbESNgwETYvaGCy5
         csNKMfFxf20mOGcUByJGd/XqTK8KU8MTe15bq7FqpPzcuRHDpVfBSnGlnP8P5uZEL1dS
         1GzzsODWrNKBzln5azpjUAJON2t97LUYWc0XGcKDAZGUR6s5mbbFKa4zBfttf0gkpejT
         RxSQtaL4CfDOstBxJUNpbf0zfoDXV93GBh59CEp7diZqo2NZkzw1fAa0DCVjxNwaDzM1
         YXVQ==
X-Gm-Message-State: AOAM530s290NsjMQI1DstFUVuYiVKpLC+Rk8qi14tS9/4hxtS3NK7HN+
        /WXmOSY51zgePhssDeRVSLA=
X-Google-Smtp-Source: ABdhPJwszxmxW04C0jZh7AqSlnvLnVQ2vYxMQmnHELnRexRcG7uZRs8HekEmaya5OVseC7JGCoudWg==
X-Received: by 2002:a63:8543:0:b0:380:3079:dffd with SMTP id u64-20020a638543000000b003803079dffdmr5112741pgd.106.1646654378069;
        Mon, 07 Mar 2022 03:59:38 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m6-20020a62f206000000b004e152bc0527sm15323164pfh.153.2022.03.07.03.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:59:37 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] KVM: x86: Use static calls to reduce kvm_pmu_ops overhead
Date:   Mon,  7 Mar 2022 19:59:20 +0800
Message-Id: <20220307115920.51099-5-likexu@tencent.com>
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

Use static calls to improve kvm_pmu_ops performance. Introduce the
definitions that will be used by a subsequent patch to actualize the
savings. Add a new kvm-x86-pmu-ops.h header that can be used for the
definition of static calls. This header is also intended to be
used to simplify the defition of amd_pmu_ops and intel_pmu_ops.

Here are the worst fenced_rdtsc() cycles numbers for the kvm_pmu_ops
functions that is most often called (up to 7 digits of calls) when running
a single perf test case in a guest on an ICX 2.70GHz host (mitigations=on):

		|	legacy	|	static call
------------------------------------------------------------
.pmc_idx_to_pmc	|	1304840	|	994872 (+23%)
.pmc_is_enabled	|	978670	|	1011750 (-3%)
.msr_idx_to_pmc	|	47828	|	41690 (+12%)
.is_valid_msr	|	28786	|	30108 (-4%)

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h | 31 +++++++++++++++++
 arch/x86/kvm/pmu.c                     | 46 ++++++++++++++------------
 arch/x86/kvm/pmu.h                     |  7 +++-
 arch/x86/kvm/x86.c                     |  8 +++++
 4 files changed, 70 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
new file mode 100644
index 000000000000..fdfd8e06fee6
--- /dev/null
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(KVM_X86_PMU_OP) || !defined(KVM_X86_PMU_OP_OPTIONAL)
+BUILD_BUG_ON(1)
+#endif
+
+/*
+ * KVM_X86_PMU_OP() and KVM_X86_PMU_OP_OPTIONAL() are used to help generate
+ * both DECLARE/DEFINE_STATIC_CALL() invocations and
+ * "static_call_update()" calls.
+ *
+ * KVM_X86_PMU_OP_OPTIONAL() can be used for those functions that can have
+ * a NULL definition, for example if "static_call_cond()" will be used
+ * at the call sites.
+ */
+KVM_X86_PMU_OP(pmc_perf_hw_id)
+KVM_X86_PMU_OP(pmc_is_enabled)
+KVM_X86_PMU_OP(pmc_idx_to_pmc)
+KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
+KVM_X86_PMU_OP(msr_idx_to_pmc)
+KVM_X86_PMU_OP(is_valid_rdpmc_ecx)
+KVM_X86_PMU_OP(is_valid_msr)
+KVM_X86_PMU_OP(get_msr)
+KVM_X86_PMU_OP(set_msr)
+KVM_X86_PMU_OP(refresh)
+KVM_X86_PMU_OP(init)
+KVM_X86_PMU_OP(reset)
+KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
+KVM_X86_PMU_OP_OPTIONAL(cleanup)
+
+#undef KVM_X86_PMU_OP
+#undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 771edc4f4494..4146be236506 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -51,6 +51,12 @@
 
 struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
 
+#define KVM_X86_PMU_OP(func)					     \
+	DEFINE_STATIC_CALL_NULL(kvm_x86_pmu_##func,			     \
+				*(((struct kvm_pmu_ops *)0)->func));
+#define KVM_X86_PMU_OP_OPTIONAL KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 {
 	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
@@ -217,7 +223,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_pmu_ops.pmc_perf_hw_id(pmc);
+		config = static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
@@ -269,7 +275,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_pmu_ops.pmc_perf_hw_id(pmc),
+			      static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi, false, false);
@@ -278,7 +284,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 {
-	struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, pmc_idx);
+	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, pmc_idx);
 
 	if (!pmc)
 		return;
@@ -300,7 +306,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	int bit;
 
 	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
-		struct kvm_pmc *pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, bit);
+		struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit);
 
 		if (unlikely(!pmc || !pmc->perf_event)) {
 			clear_bit(bit, pmu->reprogram_pmi);
@@ -322,7 +328,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 /* check if idx is a valid index to access PMU */
 bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return kvm_pmu_ops.is_valid_rdpmc_ecx(vcpu, idx);
+	return static_call(kvm_x86_pmu_is_valid_rdpmc_ecx)(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
@@ -372,7 +378,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-	pmc = kvm_pmu_ops.rdpmc_ecx_to_pmc(vcpu, idx, &mask);
+	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
 	if (!pmc)
 		return 1;
 
@@ -388,22 +394,21 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
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
 
 static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = kvm_pmu_ops.msr_idx_to_pmc(vcpu, msr);
+	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr);
 
 	if (pmc)
 		__set_bit(pmc->idx, pmu->pmc_in_use);
@@ -411,13 +416,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
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
@@ -426,7 +431,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
-	kvm_pmu_ops.refresh(vcpu);
+	static_call(kvm_x86_pmu_refresh)(vcpu);
 }
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
@@ -434,7 +439,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	irq_work_sync(&pmu->irq_work);
-	kvm_pmu_ops.reset(vcpu);
+	static_call(kvm_x86_pmu_reset)(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
@@ -442,7 +447,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	memset(pmu, 0, sizeof(*pmu));
-	kvm_pmu_ops.init(vcpu);
+	static_call(kvm_x86_pmu_init)(vcpu);
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
@@ -474,14 +479,13 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
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
@@ -511,7 +515,7 @@ static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 	unsigned int config;
 
 	pmc->eventsel &= (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
-	config = kvm_pmu_ops.pmc_perf_hw_id(pmc);
+	config = static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc);
 	pmc->eventsel = old_eventsel;
 	return config == perf_hw_id;
 }
@@ -539,7 +543,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	int i;
 
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
-		pmc = kvm_pmu_ops.pmc_idx_to_pmc(pmu, i);
+		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
 		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
 			continue;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7032d3ebf8f4..9ccdfb4e838e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -43,6 +43,11 @@ struct kvm_pmu_ops {
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 };
 
+#define KVM_X86_PMU_OP(func) \
+	DECLARE_STATIC_CALL(kvm_x86_pmu_##func, *(((struct kvm_pmu_ops *)0)->func));
+#define KVM_X86_PMU_OP_OPTIONAL KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -92,7 +97,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
 
 static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 {
-	return kvm_pmu_ops.pmc_is_enabled(pmc);
+	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
 }
 
 static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a76f7281e74..ffa0b219c13e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11519,6 +11519,14 @@ static inline void kvm_ops_static_call_update(void)
 					   (void *)__static_call_return0);
 #include <asm/kvm-x86-ops.h>
 #undef __KVM_X86_OP
+
+#define __KVM_X86_PMU_OP(func) \
+	static_call_update(kvm_x86_pmu_##func, kvm_pmu_ops.func);
+#define KVM_X86_PMU_OP(func) \
+	WARN_ON(!kvm_pmu_ops.func); __KVM_X86_PMU_OP(func)
+#define KVM_X86_PMU_OP_OPTIONAL __KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+#undef __KVM_X86_PMU_OP
 }
 
 int kvm_arch_hardware_setup(void *opaque)
-- 
2.35.1

