Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900BE695839
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjBNFJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjBNFJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:09:03 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B5210412;
        Mon, 13 Feb 2023 21:08:36 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id bx22so14004477pjb.3;
        Mon, 13 Feb 2023 21:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T50M5OWJQs2wvxC72ExV73DSxuRGd8t0n4DfEyRPMX8=;
        b=hm3/c1SPTjxglBUgdEM0E6KHastVRNkDJRmzoRlVoHn43rMuIvXn26P28lxnHVJ9SV
         liohijQNZvYwt5/atilc+Mirpb/lPsewLNlKkiV14OT4bFznEcSBUSGXm+0cUacRgKzb
         cIXA178fkV9xk7KDc5oUPvMV0Yls6i1F7k5Kq+Bd8rDDDeosVcP1HEvs3hZIc14+8WJR
         cBwDUNoASFmJJf/DaW5ITAfEZK+VVJp2K2/FGp15cFNB31e5ZUIuP+/XFlEWBxKujKCx
         4QozCIs2kHHKrFymNZNEyK2TTRCGmJOlehbIv7b1mnIj94XM46JkWB4U6DjPycLvMUY+
         MEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T50M5OWJQs2wvxC72ExV73DSxuRGd8t0n4DfEyRPMX8=;
        b=UpQl/S/5airvS5EouHlYOGCKWz96jSDqVVYpggXLGOsK4rni98NWbH5Di711ttvqGD
         H+dkEAIAHy/fS9vZXlIUzJAxZ6jQmVsh40Abu38OVIFivDj5ojwpQeYzei5uZ0KTm4Nq
         aH+ZCotPSXDW76ZkKkSa7Cr4wu6fj/8KkDv2+JCLo3aSYL7/jSlF60+bBALkXTa1Kh8n
         i045QwwnUE+gh005nYvd42FJpX05tXGxssze/z3lARsHb5qr6IcHmnwTKyXYfps96ZlC
         MocN8osOEBPyZwPt4BHubEwXbXQWQtFI1N3TK8Gfo0bKTMyUMjm316L8DsvAOr8P1y2j
         dTrw==
X-Gm-Message-State: AO0yUKXU6nB3wMUH+4oHZor4XcEJUNDMf/rls37AWZdumkWbUdbN9LYi
        zreXM+Bbc9RbD2XgmB18Gb8=
X-Google-Smtp-Source: AK7set8oMI1bf5CHyyi9If9bS4mS0FX8Jar36U++dYwuRa0dIEXhDoRVmAChNwJk7TYywAdBaZX+BQ==
X-Received: by 2002:a05:6a21:7893:b0:be:a082:670f with SMTP id bf19-20020a056a21789300b000bea082670fmr811810pzc.28.1676351315443;
        Mon, 13 Feb 2023 21:08:35 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:35 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: [PATCH v4 11/12] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
Date:   Tue, 14 Feb 2023 13:07:56 +0800
Message-Id: <20230214050757.9623-12-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
References: <20230214050757.9623-1-likexu@tencent.com>
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
 arch/x86/kvm/pmu.c     | 14 +++++++++--
 arch/x86/kvm/svm/pmu.c | 53 ++++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/x86.c     | 10 ++++++++
 3 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5a3428d212dd..d5be8320fd54 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -574,12 +574,15 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
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
@@ -600,13 +603,19 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))
 			return 1; /* RO MSR */
+		fallthrough;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+		if (!msr_info->host_initiated)
+			return 0; /* Writes are ignored */
 
 		pmu->global_status = data;
 		return 0;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 		if (!kvm_valid_perf_global_ctrl(pmu, data))
 			return 1;
-
+		fallthrough;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+		data &= ~pmu->global_ctrl_mask;
 		if (pmu->global_ctrl != data) {
 			diff = pmu->global_ctrl ^ data;
 			pmu->global_ctrl = data;
@@ -616,7 +625,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		if (data & pmu->global_ovf_ctrl_mask)
 			return 1;
-
+		fallthrough;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
 		if (!msr_info->host_initiated)
 			pmu->global_status &= ~data;
 		return 0;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 9e12142e0c4b..8bbaace003b2 100644
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
@@ -164,20 +181,34 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_cpuid_entry2 *entry;
+	union cpuid_0x80000022_ebx ebx;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
+	pmu->version = 1;
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)) {
+		pmu->version = 2;
+		entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
+		ebx.full = entry->ebx;
+		pmu->nr_arch_gp_counters = min_t(unsigned int,
+						 ebx.split.num_core_pmc,
+						 kvm_pmu_cap.num_counters_gp);
+	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
-	else
+	} else {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
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
 
@@ -208,6 +239,8 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc_stop_counter(pmc);
 		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
 	}
+
+	pmu->global_ctrl = pmu->global_status = 0;
 }
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64c567a1b32b..74e0c53b6a00 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1464,6 +1464,10 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
+
+	MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_base) +
@@ -7067,6 +7071,12 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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
2.39.1

