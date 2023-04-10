Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20486DC5EF
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDJKwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjDJKwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:52:08 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2174449DE;
        Mon, 10 Apr 2023 03:51:51 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w11so4346681plp.13;
        Mon, 10 Apr 2023 03:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123894; x=1683715894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hb1HHB4PSbBivLbpeaeCZmvKA1+PbCgmPvuvftmh9Lg=;
        b=pX6ORqNYOn6Ynk0hPo00u+EOAaWSYcDJ3wDhaZkwij9HEdCM0KBCuEv8WNjCXT54se
         0D8Fz23q1tNPwfDEIdCffT/lPuPueqiZle7iI96WgMr26N10Fmq1K98V3vE8unoz06Yi
         ACRfTUU9fmwFMY1fOEg927R7G+Bi0Pteoe5gVRGUnXBIR4/l49WfqXPXvQnxH37rzkug
         b5t7RHfHiBehyydY6q20RTAbBf5HlApRwdb/RpYxjDhjztlNo1Q2t1wPT5P5d+z42K1t
         ALxYkCemkx0HCmm82nEjaEBp5s0PXLKpPNtKtQY7SrARUSjxgG1amMngiectPBktY15D
         oI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123894; x=1683715894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hb1HHB4PSbBivLbpeaeCZmvKA1+PbCgmPvuvftmh9Lg=;
        b=hoh3SdMbGC+vScAQKCfm8VgeXG0OzyVUQWcdz3WvAanjtHXSPdb96rcRRVeOTYudqW
         oSHCxpqdID/MQBbDf5v3xhavxL/fR54jLAMG4xyIezd2VgOPvSzyxrZldi2GNt/orJ/0
         XLbd3hwwEq/mM8lf00Mx7TsNzeGNJODgWPeIGKb0K/edMGJlcfb61/HbVb4Gzqob6Oth
         1x4eE7UJTaiHfjUWIjSsoDC7vgxx+lR9bn3zyfPtF1wVzO1juyT37dhFIum7xqBxK8yT
         lJz98FcN4GZHi+fJVsdIOUjKZvHsDo99RcGF0fgX5FgVo2xc8qlqbxVvq9vySf1ZlWp6
         itJQ==
X-Gm-Message-State: AAQBX9eqvwFd2VsxyYf43ycaT8DMJ8764PvD//U2W4aBpCP8Du3264es
        en7u54Vy+bry/AT9IwlFRbY=
X-Google-Smtp-Source: AKy350ZrF0Mr1MZUfyk9nm593E+sENeT53oQ3UA0sdkzZhLUlIdt2TW7uJbMzWXN/PUr+4WkN32q4g==
X-Received: by 2002:a05:6a20:7a1f:b0:db:314d:c19a with SMTP id t31-20020a056a207a1f00b000db314dc19amr9941713pzh.50.1681123893375;
        Mon, 10 Apr 2023 03:51:33 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:33 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: [PATCH V5 09/10] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
Date:   Mon, 10 Apr 2023 18:50:55 +0800
Message-Id: <20230410105056.60973-10-likexu@tencent.com>
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

If AMD Performance Monitoring Version 2 (PerfMonV2) is detected by
the guest, it can use a new scheme to manage the Core PMCs using the
new global control and status registers.

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
 arch/x86/kvm/pmu.c     | 24 +++++++++++++++++-
 arch/x86/kvm/svm/pmu.c | 55 ++++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/x86.c     | 10 ++++++++
 3 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 69d0a3ae7b45..7d2678f06863 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -577,11 +577,18 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr) {
 	case MSR_CORE_PERF_GLOBAL_STATUS:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 		msr_info->data = pmu->global_status;
 		break;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+		/* Based on the observed HW. */
+		fallthrough;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 		msr_info->data = pmu->global_ctrl;
 		break;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+		/* Based on the observed HW. */
+		fallthrough;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = 0;
 		break;
@@ -599,13 +606,26 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u64 data = msr_info->data;
 	u64 diff;
 
+	/*
+	 * Note, AMD ignores writes to reserved bits and read-only PMU MSRs,
+	 * whereas Intel generates #GP on attempts to write reserved/RO MSRs.
+	 */
 	switch (msr) {
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))
 			return 1; /* RO MSR */
+		fallthrough;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+		/* Per PPR, Read-only MSR. Writes are ignored. */
+		if (!msr_info->host_initiated)
+			break;
 
 		pmu->global_status = data;
 		break;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+		/* Based on the observed HW. */
+		data &= ~pmu->global_ctrl_mask;
+		fallthrough;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 		if (!kvm_valid_perf_global_ctrl(pmu, data))
 			return 1;
@@ -619,7 +639,9 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		if (data & pmu->global_ovf_ctrl_mask)
 			return 1;
-
+		fallthrough;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+		/* Based on the observed HW. */
 		if (!msr_info->host_initiated)
 			pmu->global_status &= ~data;
 		break;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 825b9cc26ae5..56607a3f6a47 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -94,12 +94,6 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
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
@@ -111,6 +105,29 @@ static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
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
@@ -164,23 +181,39 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	union cpuid_0x80000022_ebx ebx;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
+	pmu->version = 1;
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)) {
+		pmu->version = 2;
+		/*
+		 * Note, PERFMON_V2 is also in 0x80000022.0x0, i.e. the guest
+		 * CPUID entry is guaranteed to be non-NULL.
+		 */
+		BUILD_BUG_ON(x86_feature_cpuid(X86_FEATURE_PERFMON_V2).function != 0x80000022 ||
+			     x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index);
+		ebx.full = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0)->ebx;
+		pmu->nr_arch_gp_counters = ebx.split.num_core_pmc;
+	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
-	else
+	} else {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
+	}
 
 	pmu->nr_arch_gp_counters = min_t(unsigned int, pmu->nr_arch_gp_counters,
 					 kvm_pmu_cap.num_counters_gp);
 
+	if (pmu->version > 1) {
+		pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
+		pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask;
+	}
+
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
 
@@ -211,6 +244,8 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc_stop_counter(pmc);
 		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
 	}
+
+	pmu->global_ctrl = pmu->global_status = 0;
 }
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a86ad45a53b8..a389ebd2ded1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1468,6 +1468,10 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
+
+	MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_base) +
@@ -7110,6 +7114,12 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		    kvm_pmu_cap.num_counters_fixed)
 			return;
 		break;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+		if (!kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2))
+			return;
+		break;
 	case MSR_IA32_XFD:
 	case MSR_IA32_XFD_ERR:
 		if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
-- 
2.40.0

