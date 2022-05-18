Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AD052BC36
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbiERNZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237825AbiERNZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:52 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6EFAFB09;
        Wed, 18 May 2022 06:25:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i8so1735503plr.13;
        Wed, 18 May 2022 06:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=InECIgSZ0QPmtYHzj1Juv9iX30hqeOQtFiR8TnwIpkk=;
        b=MMa7UcDqe3NztEgAoWKoc79WYsyZyGuVhIY8+mgRs3qZyGi62S3JQ1PMMVKSUiVlfn
         nN4n9WWVCDrJjzVsjua3/EkFIxdITSfZNpVAZMNBaH08diQenCWunfQMF9Q32uiwFYw2
         yQTecdH1DOsZbnO3spGNb2nYi3Bl9yk2VVQ4bDA9HOBLvAV4zZBnqG0krx9waDr8+nJY
         +xwpN/Bz/ATVOmSsDV07rpshwA6Vo+z0TScDVj13ckjEfWEITkddWe06VYQV9TUo3YI+
         IOUYau13DOxeTz4/cjVDTB/NXUuOjyRYNBsofnKU7SwGJhRrgMQr8eGdTaM/7H5LDZL2
         wtaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=InECIgSZ0QPmtYHzj1Juv9iX30hqeOQtFiR8TnwIpkk=;
        b=W9Gk02DS/VsDPcP4l7CFppZBSGLq3DZx611surMoGQnyPE1Jt8RdmZ+y79kv9uGh95
         wRqNLICUfz+mDQ37BGQ7OdawWcRj2C0KsZr5GaYnjkSW+Rq81Bwd+J2kwWYjlw08nU+Z
         j268ZEfQzquSom7QkH3VS7JfJW2bFc2jyk+2z7PYYmZrn0Vsp51d4ckMySfM81knmc3I
         nM/IWpju6CdNOPp7e41ZMCYLVjj4XqWTs01itvJqsuIACMauD0laeNa3/9NsNeYu19Eg
         ImjQvzYxCFU071Rt7iAm0RaLLkbh5I9ohOLf0gO3uTtwvJ9dEbd8TmNXjrYS/AV/1Ygq
         fpOw==
X-Gm-Message-State: AOAM530RMBQnx0ne7PH1+CURLa0kAKGLE2fasus0uoy/DqQZM11voZEN
        2bxaBKsn4lmT/bYfI8nq+wE=
X-Google-Smtp-Source: ABdhPJyGausP/HaR90eiCTKx/g3tX1H76STHGVBFl5nIC+S+CYDhEiOTlENLOVOTdPzQ9kvcoIaucA==
X-Received: by 2002:a17:90a:9a8b:b0:1df:6b7a:8a40 with SMTP id e11-20020a17090a9a8b00b001df6b7a8a40mr14059230pjp.213.1652880349751;
        Wed, 18 May 2022 06:25:49 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:49 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 11/11] KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context
Date:   Wed, 18 May 2022 21:25:12 +0800
Message-Id: <20220518132512.37864-12-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
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

All gp or fixed counters have been reprogrammed using PERF_TYPE_RAW,
which means that the table that maps perf_hw_id to event select values is
no longer useful, at least for AMD.

For Intel, the logic to check if the pmu event reported by Intel cpuid is
not available is still required, in which case pmc_perf_hw_id() could be
renamed to hw_event_is_unavail() and a bool value is returned to replace
the semantics of "PERF_COUNT_HW_MAX+1".

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  2 +-
 arch/x86/kvm/pmu.c                     |  6 +--
 arch/x86/kvm/pmu.h                     |  2 +-
 arch/x86/kvm/svm/pmu.c                 | 56 ++------------------------
 arch/x86/kvm/vmx/pmu_intel.c           | 11 ++---
 5 files changed, 12 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index fdfd8e06fee6..227317bafb22 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -12,7 +12,7 @@ BUILD_BUG_ON(1)
  * a NULL definition, for example if "static_call_cond()" will be used
  * at the call sites.
  */
-KVM_X86_PMU_OP(pmc_perf_hw_id)
+KVM_X86_PMU_OP(hw_event_is_unavail)
 KVM_X86_PMU_OP(pmc_is_enabled)
 KVM_X86_PMU_OP(pmc_idx_to_pmc)
 KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7dc949f6a92c..c01d66d237bb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -151,9 +151,6 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	};
 	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
 
-	if (type == PERF_TYPE_HARDWARE && config >= PERF_COUNT_HW_MAX)
-		return;
-
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
 	if ((attr.config & HSW_IN_TX_CHECKPOINTED) &&
@@ -248,6 +245,9 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	__u64 key;
 	int idx, srcu_idx;
 
+	if (static_call(kvm_x86_pmu_hw_event_is_unavail)(pmc))
+		return false;
+
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 8d7912978249..1ad19c1949ad 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -30,7 +30,7 @@ struct kvm_event_hw_type_mapping {
 };
 
 struct kvm_pmu_ops {
-	unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
+	bool (*hw_event_is_unavail)(struct kvm_pmc *pmc);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b5ba846fee88..0c9f2e4b7b6b 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -33,34 +33,6 @@ enum index {
 	INDEX_ERROR,
 };
 
-/* duplicated from amd_perfmon_event_map, K7 and above should work. */
-static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
-	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
-	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
-	[2] = { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES },
-	[3] = { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES },
-	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
-	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
-	[6] = { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
-	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
-};
-
-/* duplicated from amd_f17h_perfmon_event_map. */
-static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
-	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
-	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
-	[2] = { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
-	[3] = { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
-	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
-	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
-	[6] = { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
-	[7] = { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
-};
-
-/* amd_pmc_perf_hw_id depends on these being the same size */
-static_assert(ARRAY_SIZE(amd_event_mapping) ==
-	     ARRAY_SIZE(amd_f17h_event_mapping));
-
 static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
@@ -154,31 +126,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return &pmu->gp_counters[msr_to_index(msr)];
 }
 
-static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
+static bool amd_hw_event_is_unavail(struct kvm_pmc *pmc)
 {
-	struct kvm_event_hw_type_mapping *event_mapping;
-	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
-	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
-	int i;
-
-	/* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
-	if (WARN_ON(pmc_is_fixed(pmc)))
-		return PERF_COUNT_HW_MAX;
-
-	if (guest_cpuid_family(pmc->vcpu) >= 0x17)
-		event_mapping = amd_f17h_event_mapping;
-	else
-		event_mapping = amd_event_mapping;
-
-	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
-		if (event_mapping[i].eventsel == event_select
-		    && event_mapping[i].unit_mask == unit_mask)
-			break;
-
-	if (i == ARRAY_SIZE(amd_event_mapping))
-		return PERF_COUNT_HW_MAX;
-
-	return event_mapping[i].event_type;
+	return false;
 }
 
 /* check if a PMC is enabled by comparing it against global_ctrl bits. Because
@@ -344,7 +294,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
-	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
+	.hw_event_is_unavail = amd_hw_event_is_unavail,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 75aa2282ae93..6d24db41d8e0 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -84,7 +84,7 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 	}
 }
 
-static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
+static bool intel_hw_event_is_unavail(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
@@ -98,15 +98,12 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 
 		/* disable event that reported as not present by cpuid */
 		if ((i < 7) && !(pmu->available_event_types & (1 << i)))
-			return PERF_COUNT_HW_MAX + 1;
+			return true;
 
 		break;
 	}
 
-	if (i == ARRAY_SIZE(intel_arch_events))
-		return PERF_COUNT_HW_MAX;
-
-	return intel_arch_events[i].event_type;
+	return false;
 }
 
 /* check if a PMC is enabled by comparing it with globl_ctrl bits. */
@@ -805,7 +802,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
-	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
+	.hw_event_is_unavail = intel_hw_event_is_unavail,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
-- 
2.36.1

