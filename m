Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921826C3065
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 12:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjCUL2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 07:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjCUL2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 07:28:05 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29274988F;
        Tue, 21 Mar 2023 04:28:01 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id n20so4132859pfa.3;
        Tue, 21 Mar 2023 04:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679398081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AEkTSNyaJiPfFB7l+xqH5i9KcB2YkyXJblJOotBkVwE=;
        b=SP7T16fA/gl803oergmlEBNZQTq2BZyMyzrrjXBGyB8yU/HqBRFpMZV0w/bWIwNwCw
         JIgpQXV14afiCkJ1+B+szcCNlnAd9lSOU0iuQ/2jYoB45lTPavwexck+5PjyeAOywK5m
         QF3HmTEq5PggSNBCN7iSoZ+JeO1OFqLOo2yhje9RBlBqYtoI6xc0H32FQkLdAN/qZdYP
         kp0kbh9zQRW50zSGFj/zLvkNn5rhcaSWNLTfg4dbIaW/skWErLKNEdmivOVZE9h5bZRS
         iacU7QBSqUQGXko3uTmwJgBQqRsbK6/bFXlZhxDli8NMl1ZTKTiJKMlOmjXTLqiOLv6v
         b0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679398081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AEkTSNyaJiPfFB7l+xqH5i9KcB2YkyXJblJOotBkVwE=;
        b=AjWtjOvCOtmy3jizfCxAmWJauuZXnx/P0p+lkLTiVTdjl04DsfEXawC1Ofy9PF98S8
         i4OxNkr/aK2y/qztKpc+MPOJyfM141RvbVyxCJvOQyTGiW36OJf8WFg6WDQ2A7Kt9ZTQ
         sgH0wLYKuJlNEND7BwC6FpiKbbj5PnPDv7TSDbdrq8zK70MlyyCSTYRqWmv2uZe507IQ
         2Hd1BAQuJdE+2+kl2lJCL3zb7Jh3SO9ENIuz9YpJJxWEDaLygEBdRtD2fXvmwPq1M7VD
         s2lR7WmnmzeacSPXCjQJ/p8JdvhJYskiNPYSQXLsj9fovEI8+N6IHRaEQU4FtubWDmYd
         ciOA==
X-Gm-Message-State: AO0yUKVWbFGEfvBeASBV3S/SGSICF8yD5V1rl0fnM4GIgnkZelTi/rnW
        g9neWGk9FrHYans/3pTA2fQ=
X-Google-Smtp-Source: AK7set/1YivuKg+wX8KbsGU9JdXAbUAx3D+iQ/vZSSEffQcUZDyOQqvaWQYgW+y+srnTi3hxLiU7kA==
X-Received: by 2002:a62:7904:0:b0:626:237c:bcfe with SMTP id u4-20020a627904000000b00626237cbcfemr2275307pfc.8.1679398080732;
        Tue, 21 Mar 2023 04:28:00 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c26-20020aa781da000000b0062578514d6fsm8037415pfn.58.2023.03.21.04.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 04:28:00 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Add Intel PMU supported fixed counters bit mask
Date:   Tue, 21 Mar 2023 19:27:42 +0800
Message-Id: <20230321112742.25255-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
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

Per Intel SDM, fixed-function performance counter 'i' is supported if:

	FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i);

which means that the KVM user space can use EDX to limit the number of
fixed counters and at the same time, using ECX to enable part of other
KVM supported fixed counters.

Add a bitmap (instead of always checking the vcpu's CPUIDs) to keep track
of the guest available fixed counters and perform the semantic checks.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.h              |  8 +++++
 arch/x86/kvm/vmx/pmu_intel.c    | 53 +++++++++++++++++++++------------
 3 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a45de1118a42..14689e583127 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -565,6 +565,8 @@ struct kvm_pmu {
 	 */
 	bool need_cleanup;
 
+	DECLARE_BITMAP(supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);
+
 	/*
 	 * The total number of programmed perf_events and it helps to avoid
 	 * redundant check before cleanup if guest don't use vPMU at all.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index be62c16f2265..9f4504e5e9d5 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -111,6 +111,11 @@ static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 	return NULL;
 }
 
+static inline bool fixed_ctr_is_supported(struct kvm_pmu *pmu, unsigned int idx)
+{
+	return test_bit(idx, pmu->supported_fixed_pmc_idx);
+}
+
 /* returns fixed PMC with the specified MSR */
 static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
 {
@@ -120,6 +125,9 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
 		u32 index = array_index_nospec(msr - base,
 					       pmu->nr_arch_fixed_counters);
 
+		if (!fixed_ctr_is_supported(pmu, index))
+			return NULL;
+
 		return &pmu->fixed_counters[index];
 	}
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..12f4b2fe7756 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -43,13 +43,16 @@ static int fixed_pmc_events[] = {1, 0, 7};
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
-	u8 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
+	u8 new_ctrl, old_ctrl, old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
 	int i;
 
 	pmu->fixed_ctr_ctrl = data;
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
-		u8 new_ctrl = fixed_ctrl_field(data, i);
-		u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
+		if (!fixed_ctr_is_supported(pmu, i))
+			continue;
+
+		new_ctrl = fixed_ctrl_field(data, i);
+		old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
 
 		if (old_ctrl == new_ctrl)
 			continue;
@@ -125,6 +128,9 @@ static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 
 	idx &= ~(3u << 30);
 
+	if (fixed && !fixed_ctr_is_supported(pmu, idx))
+		return false;
+
 	return fixed ? idx < pmu->nr_arch_fixed_counters
 		     : idx < pmu->nr_arch_gp_counters;
 }
@@ -145,7 +151,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 		counters = pmu->gp_counters;
 		num_counters = pmu->nr_arch_gp_counters;
 	}
-	if (idx >= num_counters)
+	if (idx >= num_counters || (fixed && !fixed_ctr_is_supported(pmu, idx)))
 		return NULL;
 	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
 	return &counters[array_index_nospec(idx, num_counters)];
@@ -500,6 +506,9 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 	int i;
 
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		if (!fixed_ctr_is_supported(pmu, i))
+			continue;
+
 		pmc = &pmu->fixed_counters[i];
 		event = fixed_pmc_events[array_index_nospec(i, size)];
 		pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
@@ -520,6 +529,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
+	bitmap_zero(pmu->supported_fixed_pmc_idx, KVM_PMC_MAX_FIXED);
 	pmu->counter_bitmask[KVM_PMC_GP] = 0;
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
@@ -551,13 +561,24 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->available_event_types = ~entry->ebx &
 					((1ull << eax.split.mask_length) - 1);
 
-	if (pmu->version == 1) {
-		pmu->nr_arch_fixed_counters = 0;
-	} else {
+	counter_mask = ~(BIT_ULL(pmu->nr_arch_gp_counters) - 1);
+	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
+
+	if (pmu->version > 1) {
 		pmu->nr_arch_fixed_counters =
-			min3(ARRAY_SIZE(fixed_pmc_events),
-			     (size_t) edx.split.num_counters_fixed,
-			     (size_t)kvm_pmu_cap.num_counters_fixed);
+			min_t(int, ARRAY_SIZE(fixed_pmc_events),
+			      kvm_pmu_cap.num_counters_fixed);
+		for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+			/* FxCtr[i]_is_supported := CPUID.0xA.ECX[i] || (EDX[4:0] > i) */
+			if (!(entry->ecx & BIT_ULL(i) ||
+			      edx.split.num_counters_fixed > i))
+				continue;
+
+			set_bit(i, pmu->supported_fixed_pmc_idx);
+			set_bit(INTEL_PMC_MAX_GENERIC + i, pmu->all_valid_pmc_idx);
+			pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
+			counter_mask &= ~BIT_ULL(INTEL_PMC_MAX_GENERIC + i);
+		}
 		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
@@ -565,10 +586,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		setup_fixed_pmc_eventsel(pmu);
 	}
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
-		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
-	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
-		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
 	pmu->global_ctrl_mask = counter_mask;
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
@@ -585,11 +602,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->raw_event_mask |= (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
 	}
 
-	bitmap_set(pmu->all_valid_pmc_idx,
-		0, pmu->nr_arch_gp_counters);
-	bitmap_set(pmu->all_valid_pmc_idx,
-		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
-
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
 	if (cpuid_model_is_consistent(vcpu) &&
 	    (perf_capabilities & PMU_CAP_LBR_FMT))
@@ -605,6 +617,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			pmu->pebs_enable_mask = counter_mask;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
 			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+				if (!fixed_ctr_is_supported(pmu, i))
+					continue;
+
 				pmu->fixed_ctr_ctrl_mask &=
 					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
 			}

base-commit: d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7
-- 
2.40.0

