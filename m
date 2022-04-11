Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5114FB7A1
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344439AbiDKJii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344524AbiDKJid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:33 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A696403DC;
        Mon, 11 Apr 2022 02:36:18 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p25so7373514pfn.13;
        Mon, 11 Apr 2022 02:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QbkEjkl9ftZFhzuzmbFjiq0IAVnlVCc+oIbvoqaNepo=;
        b=Oeg2hqNogXppBTMshhx7EhTcRcypOFNcVOjWw23BizQ7FU6BLSEEIsdfnlptpunYWk
         YwzB2jfTNTJ5PG0LCsQsDeA+r4/UFTrl2rXmkhfBRRsZMPdEF+DJruRiZzG6YMbHeCFZ
         dFtAsXhxXpciMG1TBZ/W9nO+2poVttbI+sN9HDB1m5ViaVvndRX53FG9W0EIgesRQVUu
         OrG6YJTvD3z4+OMlnCgKEZLSwBuxn4yKSkZdeg1KwHKrd8fU/FZGzs36/uMy15w0dhvA
         BVlORaShCWHQZIumCAlSZTXx1bPjPD+p3N8hw0UXuqI2Q2BOFbYaucQ/aHFHpz9qf8lH
         mxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QbkEjkl9ftZFhzuzmbFjiq0IAVnlVCc+oIbvoqaNepo=;
        b=ZyUeoY/YhNxBdzBQq2ZrkqaYBUUzHurFXgOYvTZ5qghVhGZJJyv96iMlj0uYOwgJOx
         VbgY4cj+kMF/TSc0dYpX33pOCYRwQZIbYGhcsOVcgXvng8R3wlKiwMcVXB9TLSo6lMPV
         KHxmhuA+uyJfrdLWGQMH/6P4gi1PzlDxATekPe+naZUXHLfJKyPLPrkh2BJllLZ/rC/E
         uAIZ70oqh5Sxa9usmygNxAjcEcl+LVZ5eVgrDLPv6z/qVjRMdoX9YOI8/xIMAW8uQZ8y
         yGWtXADoT7yqr3DaA5UgvmCA3UZXx3Q2xGdiBg6OslDH0SAQ+SQ0ot955gQfPT3qKSwE
         cCoQ==
X-Gm-Message-State: AOAM531nOKM67BdP6yYYaOm6Ykipd7ZDg5/EFdQGVuTo87HjmassXUYs
        kjuFspW3GB3mQlrXfx6digQ=
X-Google-Smtp-Source: ABdhPJxe6AIByThQqqbW8s3kDWh4+2z62zhHOEhzPgx4d+7ZbR3OFLC89oIaUMBZb5/d549GIiGugA==
X-Received: by 2002:a63:b24b:0:b0:398:9894:b8be with SMTP id t11-20020a63b24b000000b003989894b8bemr26222769pgo.108.1649669777512;
        Mon, 11 Apr 2022 02:36:17 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:36:17 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 11/11] KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context
Date:   Mon, 11 Apr 2022 17:35:37 +0800
Message-Id: <20220411093537.11558-12-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411093537.11558-1-likexu@tencent.com>
References: <20220411093537.11558-1-likexu@tencent.com>
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
 arch/x86/kvm/pmu.c                     |  6 ++---
 arch/x86/kvm/pmu.h                     |  2 +-
 arch/x86/kvm/svm/pmu.c                 | 34 +++-----------------------
 arch/x86/kvm/vmx/pmu_intel.c           | 11 +++------
 5 files changed, 12 insertions(+), 43 deletions(-)

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
index f6fd85942a6b..03100e4a5cfb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -139,9 +139,6 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.config = config,
 	};
 
-	if (type == PERF_TYPE_HARDWARE && config >= PERF_COUNT_HW_MAX)
-		return;
-
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
 	if ((attr.config & HSW_IN_TX_CHECKPOINTED) &&
@@ -213,6 +210,9 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	__u64 key;
 	int idx, srcu_idx;
 
+	if (static_call(kvm_x86_pmu_hw_event_is_unavail)(pmc))
+		return false;
+
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index f4a799816c51..c3c2ac8f79ca 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -22,7 +22,7 @@ struct kvm_event_hw_type_mapping {
 };
 
 struct kvm_pmu_ops {
-	unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
+	bool (*hw_event_is_unavail)(struct kvm_pmc *pmc);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index ebec2b478ac1..0c9f2e4b7b6b 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -33,18 +33,6 @@ enum index {
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
 static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
@@ -138,25 +126,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return &pmu->gp_counters[msr_to_index(msr)];
 }
 
-static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
+static bool amd_hw_event_is_unavail(struct kvm_pmc *pmc)
 {
-	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
-	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
-	int i;
-
-	/* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
-	if (WARN_ON(pmc_is_fixed(pmc)))
-		return PERF_COUNT_HW_MAX;
-
-	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
-		if (amd_event_mapping[i].eventsel == event_select
-		    && amd_event_mapping[i].unit_mask == unit_mask)
-			break;
-
-	if (i == ARRAY_SIZE(amd_event_mapping))
-		return PERF_COUNT_HW_MAX;
-
-	return amd_event_mapping[i].event_type;
+	return false;
 }
 
 /* check if a PMC is enabled by comparing it against global_ctrl bits. Because
@@ -322,7 +294,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
-	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
+	.hw_event_is_unavail = amd_hw_event_is_unavail,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 11eb186929bc..f74816d8f9f1 100644
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
@@ -730,7 +727,7 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
-	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
+	.hw_event_is_unavail = intel_hw_event_is_unavail,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
-- 
2.35.1

