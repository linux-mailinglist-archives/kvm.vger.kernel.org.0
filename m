Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5774E5BC577
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 11:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiISJfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 05:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiISJfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 05:35:17 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40ED212AF6;
        Mon, 19 Sep 2022 02:35:16 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s206so26266268pgs.3;
        Mon, 19 Sep 2022 02:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=5koffDub5LBIWseXiqyQC/BG1gbjRcp5/DdJfcofh7g=;
        b=OYYoWOQpMxgoT5fr8W5dsaNhSXamFd+CuoSUT0sNBgqf1lDMdJHX+WFNo4iyrPUQ4V
         JTIbCCcWcLtk21nY/c4qo+ogq6gC7jMMNqx57OT2HAM4G5L86Hc1YqcM6dSGSjYyqAUs
         1Mhk6hS9YrGXinw5AQRxyqtmncVK8WeBbHTk8k7FBY/SsnTOckTVBb52e9e5bL+xZwuT
         nwJExkqdydaQWoEHMV4YZRP0krf+1dE3g/rEh9h+43qOsmpHCm20tya97QpGmNj+w1gW
         bsWo+4lgd0PCUNWrA/QnQleZgaFlI3QHaGxf6RFkPjgmGlGsYD2LtGD8GkvkrvgioiGK
         g3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5koffDub5LBIWseXiqyQC/BG1gbjRcp5/DdJfcofh7g=;
        b=2mlmdAeGWmoKRHJErsOAXwmu4X8PVtB8fOCdmMmjVsocfla5NjXGCLX3eMCJaKtorm
         0qDtoSCNIhzU76dCy2s41VjFghjL/FRe5i38L/j/2U+7WPNpGPrUGP8AAiO0O+X+KdRW
         ffDz0emDMsXo3iaGsTk/2RQqvoa+yjtTjmisdM4A67yzRVTNwcIWFtG0vGJItv8TFsKX
         ulG/wiRt9Tc6udFDDryL1t6uTsX5Jlh0Mw/GpGmFeSwhHUlc85wNBDyojIV7zYxFYkko
         0pNRU1LR1Dzw0tDWfWH8roUsYDwuuFbWhcajJFsnPL2YCUjsmMH5YBOJO2/J8/vCh/9J
         8O2w==
X-Gm-Message-State: ACrzQf2/qBPYpKj7lbFV4N1y16/68fynebDT4fpxHnth+UDCYsXq9cQX
        3CAizp9QlLpME5QmWmgzM14=
X-Google-Smtp-Source: AMsMyM4IwW6ZNUW+8OOwvmzx9x14N6pibH+HQ9ri876cAMp2ISALkUKl/MpWiqGqeRB4ovnQhrA2ZQ==
X-Received: by 2002:a63:8ac9:0:b0:435:783:ee5d with SMTP id y192-20020a638ac9000000b004350783ee5dmr15622166pgd.77.1663580115569;
        Mon, 19 Sep 2022 02:35:15 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w5-20020aa79545000000b0053818255880sm19815434pfq.193.2022.09.19.02.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 02:35:15 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: [PATCH v2 2/3] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
Date:   Mon, 19 Sep 2022 17:34:52 +0800
Message-Id: <20220919093453.71737-3-likexu@tencent.com>
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

If AMD Performance Monitoring Version 2 (PerfMonV2) is detected
by the guest, it can use a new scheme to manage the Core PMCs using
the new global control and status registers.

In addition to benefiting from the PerfMonV2 functionality in the same
way as the host (higher precision), the guest also can reduce the number
of vm-exits by lowering the total number of MSRs accesses.

In terms of implementation details, amd_is_valid_msr() is resurrected
since three newly added MSRs could not be mapped to one vPMC.
The possibility of emulating PerfMonV2 on the mainframe has also
been eliminated for reasons of precision.

Co-developed-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              |  6 +++
 arch/x86/kvm/svm/pmu.c          | 67 +++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c              | 14 ++++++-
 4 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 323f2fa46bb4..925d07431155 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -509,6 +509,7 @@ struct kvm_pmc {
 #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define KVM_PMC_MAX_FIXED	3
 #define KVM_AMD_PMC_MAX_GENERIC	AMD64_NUM_COUNTERS_CORE
+#define MSR_F15H_PERF_MSR_MAX	(MSR_F15H_PERF_CTR0 + 2 * (KVM_AMD_PMC_MAX_GENERIC - 1))
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
 	unsigned nr_arch_fixed_counters;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2643a3994624..8348c9ba5b37 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -455,12 +455,15 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr) {
 	case MSR_CORE_PERF_GLOBAL_STATUS:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 		msr_info->data = pmu->global_status;
 		return 0;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
 		msr_info->data = pmu->global_ctrl;
 		return 0;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
 		msr_info->data = 0;
 		return 0;
 	default:
@@ -479,12 +482,14 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr) {
 	case MSR_CORE_PERF_GLOBAL_STATUS:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 		if (msr_info->host_initiated) {
 			pmu->global_status = data;
 			return 0;
 		}
 		break; /* RO MSR */
 	case MSR_CORE_PERF_GLOBAL_CTRL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
 		if (pmu->global_ctrl == data)
 			return 0;
 		if (kvm_valid_perf_global_ctrl(pmu, data)) {
@@ -495,6 +500,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
 		if (!(data & pmu->global_ovf_ctrl_mask)) {
 			if (!msr_info->host_initiated)
 				pmu->global_status &= ~data;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 3a20972e9f1a..8a39e9e33b06 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -92,12 +92,6 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx & ~(3u << 30));
 }
 
-static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
-{
-	/* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
-	return false;
-}
-
 static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -109,6 +103,29 @@ static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
 	return pmc;
 }
 
+static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	switch (msr) {
+	case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
+		return pmu->version > 0;
+	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+		return guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE);
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+		return pmu->version > 1;
+	default:
+		if (msr > MSR_F15H_PERF_CTR5 &&
+		    msr < MSR_F15H_PERF_CTL0 + 2 * pmu->nr_arch_gp_counters)
+			return pmu->version > 1;
+		break;
+	}
+
+	return amd_msr_idx_to_pmc(vcpu, msr);
+}
+
 static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -162,20 +179,43 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_cpuid_entry2 *entry;
+	union cpuid_0x80000022_ebx ebx;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
-		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
-	else
-		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
+	pmu->version = 1;
+	if (kvm_pmu_cap.version > 1) {
+		pmu->version = min_t(unsigned int, 2, kvm_pmu_cap.version);
+		entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
+		if (entry) {
+			ebx.full = entry->ebx;
+			pmu->nr_arch_gp_counters = min3((unsigned int)ebx.split.num_core_pmc,
+							(unsigned int)kvm_pmu_cap.num_counters_gp,
+							(unsigned int)KVM_AMD_PMC_MAX_GENERIC);
+		}
+	}
+
+	/* Commitment to minimal PMCs, regardless of CPUID.80000022 */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
+		pmu->nr_arch_gp_counters = max_t(unsigned int,
+						 pmu->nr_arch_gp_counters,
+						 AMD64_NUM_COUNTERS_CORE);
+	} else {
+		pmu->nr_arch_gp_counters = max_t(unsigned int,
+						 pmu->nr_arch_gp_counters,
+						 AMD64_NUM_COUNTERS);
+	}
+
+	if (pmu->version > 1) {
+		pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
+		pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask;
+	}
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
 	pmu->reserved_bits = 0xfffffff000280000ull;
 	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
-	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->nr_arch_fixed_counters = 0;
-	pmu->global_status = 0;
 	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
 }
 
@@ -186,6 +226,7 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 
 	BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > KVM_AMD_PMC_MAX_GENERIC);
 	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
+	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC < 1);
 
 	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
@@ -206,6 +247,8 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc_stop_counter(pmc);
 		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
 	}
+
+	pmu->global_ctrl = pmu->global_status = 0;
 }
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d28d147fc34..34ceae4e2354 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1445,6 +1445,10 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 
+	MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
+
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 };
 
@@ -3848,7 +3852,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
-	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_MSR_MAX:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 		/*
@@ -3951,7 +3958,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
-	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_MSR_MAX:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		/*
-- 
2.37.3

