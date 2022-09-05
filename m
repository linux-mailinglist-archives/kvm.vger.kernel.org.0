Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264655AD332
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 14:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbiIEMnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 08:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238290AbiIEMnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 08:43:16 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CB324941;
        Mon,  5 Sep 2022 05:40:11 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o4so8318481pjp.4;
        Mon, 05 Sep 2022 05:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Ce7v6XPbHgf2/p0uT0z3Mwufd/C1Mv28FlyqnGf8RzY=;
        b=UeCrCQ0btQ3hROiN/wwHnMAWj98jcxdom1cEMZ/y99z3xkblRaadUC6xdPGkA7xmPI
         ymWylD5NUyiTxNIgaHCC/NLJSFf0Obb7XGEkNjR4D1YdR/fqKlcgi8g8qK4cSryj+JO5
         60k/KJ90NoIw5CwKdLamvgyBqWN1cCcavd6XitH2AzlAAeJ2ourxpr13Ei0e/ZQY/c7D
         ZArFRKw02mO6M7fdtQeMLnOj0EPcGFHd9ZSBfODOgpHRj9SCYwcGUFgYkRSAT8L4Blg5
         VGkEccKoQ+a4qWcLx/A9NUgUbzEiWem5ZwDSNZkccumsHdBE+vNYY7jCNmyQ9GIiu5V9
         iyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ce7v6XPbHgf2/p0uT0z3Mwufd/C1Mv28FlyqnGf8RzY=;
        b=dLafWZHZHDkeZfAGM26jbmMbE8AAyoPmChzLP94ZY3DRGIj9znZDuYhy1M2SCwVsNa
         3+PDyKUylrZlDbr8ijgAkIUB478eca+LtwHhZpXxteyCQFF4gsxoTyV+N86xTHgHiThf
         STc4GQNKznD8fpBoRPx7T8FpRnacFKMhjgWtfZGScENm6Z43AUNVItuiZHRrKBUWite8
         hEEVaXjaw2n09G6eGTazGs/sWRQMqT1+XUoKkbXhGRVIGypasi1r1COvzRJCroqNmIFI
         gZ3V2tfrLfX2b8OGPjHNyoRGjlNy/XvV5pjLyy5qU2yA3ft8yVQ1oyQL26LbMJDXiDMa
         BSHQ==
X-Gm-Message-State: ACgBeo2f148Vu8bCzHQfinaZysU7DmGt4eiF0NxfzyLU9qF6w89huNtF
        HRt4HGZp+wJOl5Ax5km5wKE=
X-Google-Smtp-Source: AA6agR6aAuGpJR5LUW8O2ZNuIXkqhs3X/xn6cOvuNvtQUCv7wtb2qp0jMvDrhlKyzOvSY+10yDKBxA==
X-Received: by 2002:a17:90b:38c8:b0:1ff:f1cc:b433 with SMTP id nn8-20020a17090b38c800b001fff1ccb433mr19536691pjb.161.1662381610793;
        Mon, 05 Sep 2022 05:40:10 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902ec8800b00168dadc7354sm7428431plg.78.2022.09.05.05.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 05:40:10 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
Date:   Mon,  5 Sep 2022 20:39:43 +0800
Message-Id: <20220905123946.95223-4-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220905123946.95223-1-likexu@tencent.com>
References: <20220905123946.95223-1-likexu@tencent.com>
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
 arch/x86/kvm/pmu.c     |  6 +++++
 arch/x86/kvm/svm/pmu.c | 50 +++++++++++++++++++++++++++++++++---------
 arch/x86/kvm/x86.c     | 11 ++++++++++
 3 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7002e1b74108..56b4f898a246 100644
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
index 3a20972e9f1a..4c7d408e3caa 100644
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
+		    msr < MSR_F15H_PERF_CTL0 + 2 * KVM_AMD_PMC_MAX_GENERIC)
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
@@ -162,20 +179,31 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_cpuid_entry2 *entry;
+	union cpuid_0x80000022_ebx ebx;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
+	pmu->version = 1;
+	entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
+	if (kvm_pmu_cap.version > 1 && entry && (entry->eax & BIT(0))) {
+		pmu->version = 2;
+		ebx.full = entry->ebx;
+		pmu->nr_arch_gp_counters = min3((unsigned int)ebx.split.num_core_pmc,
+						(unsigned int)kvm_pmu_cap.num_counters_gp,
+						(unsigned int)KVM_AMD_PMC_MAX_GENERIC);
+		pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
+		pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask;
+	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
-	else
+	} else {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
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
 
@@ -206,6 +234,8 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc_stop_counter(pmc);
 		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
 	}
+
+	pmu->global_ctrl = pmu->global_status = 0;
 }
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9738efd8425..96bb01c5eab8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1424,6 +1424,11 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+
+	MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
+
 	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
 	MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
 	MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
@@ -3856,6 +3861,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
 		/*
@@ -3959,6 +3967,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		/*
-- 
2.37.3

