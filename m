Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D212E715554
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjE3GFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjE3GFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:05:21 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E686137;
        Mon, 29 May 2023 23:05:05 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-256712d65ceso1237671a91.1;
        Mon, 29 May 2023 23:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426703; x=1688018703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/91HAVGLFrzFV7eZ8VaT+4YuRifj/4P8bzLl3nSCng=;
        b=CdXJajV23MDUd0OQzfHVR8xqNwjMfbK5XyxXJd4qVa1icGhh6jT0knV9Yv9Lsh0Mnl
         NzgszrqrqFgyiF6aPMYda8BM7QI4pZsgfrq8OO3jMEnoRlZz0TQbGSz6+qf5V5AZqJ2m
         6sEnknNCgC/2gsxwYUKN1Somteay3ocr6nJTXogxaXX8V03DCOHhqBZiFxFGr1jq5SLM
         12slPypjxg3TfHgNstp2VYP51iZ6qiH5ONR3nDq6SBOpOxslFH/Celnxs3H1ibUcp/CO
         WtuLLD1dZ1qP0EpLXSGTfz1nbh2J5ev1mJW+JBRnxk72+9tXq0eP8sj+MQsUprXrHKkP
         3UPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426703; x=1688018703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s/91HAVGLFrzFV7eZ8VaT+4YuRifj/4P8bzLl3nSCng=;
        b=d48/YYWvZvyH4q1jLVASBvDHTe2a5u7VICufi44LbuZj+1/k16EfcFfkkeLuV6cyS0
         GFe+CbttfxmjF2DII9Vcoc0HwRoNpkX3OpW47v0sc8mWJjbz3HBeOHqzKnx6XuVotoT2
         t3IhuXwRIJrdbKI2tvK6OiDH8Af4Bjjo/cx3e/bXp1NndjIXj3gFXIwKzzOsRPuZQLAJ
         nbzjiY9HBJp+AzgHUEmx4Ss+q2WKUQQ5ZgbPXNUgwjXUAisE0FKwkSHHnd0BtzcWggVZ
         wk8uZRHbCOonrT5HOSV94TDKMXtHOSnVE5Zk0292O9b00QzhajP5LIdItawsw5X+IHDu
         4veQ==
X-Gm-Message-State: AC+VfDzfQWiLeqmhLy7XdUUBJFrgrmCAe9yj9iooBJiWDlwoAsSH/tzw
        DM8ehs9s6JaeWHXJrhF2Mn5+qHdRKUeSuhcAaDw=
X-Google-Smtp-Source: ACHHUZ7bzSvpBqtpAe1mMzFD86CO04WNj8/SCUj4P+YuIHbw9D1TW2UYEe3KEcij1XDP2Vi/Ai31FQ==
X-Received: by 2002:a17:90b:33c7:b0:256:7283:a881 with SMTP id lk7-20020a17090b33c700b002567283a881mr1522658pjb.8.1685426703534;
        Mon, 29 May 2023 23:05:03 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:05:03 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: [PATCH v6 09/10] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
Date:   Tue, 30 May 2023 14:04:22 +0800
Message-Id: <20230530060423.32361-10-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530060423.32361-1-likexu@tencent.com>
References: <20230530060423.32361-1-likexu@tencent.com>
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
index 116bc7fe13c6..e17be25de6ca 100644
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
index c03958063a76..9bcf1dacfd6c 100644
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
index c0778ca39650..abfba3cae0ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1483,6 +1483,10 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
+
+	MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_base) +
@@ -7150,6 +7154,12 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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
2.40.1

