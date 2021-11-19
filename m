Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F0A456A68
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 07:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhKSGwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 01:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhKSGwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 01:52:13 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FB1C061574;
        Thu, 18 Nov 2021 22:49:12 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id x5so8637060pfr.0;
        Thu, 18 Nov 2021 22:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+C0R42cZXkNUI8oUTBO/cPU3Mmv17041b0kCSOqwtLk=;
        b=iL90//NeoxxkF3V3hooMVDHa7mPmqQJAQSHDAsO+p0t0dOb7V5C/DkWlHUeQYwKBq9
         kE2VQIUz5c3Akpqa5L6I9iOY1tnXYeGdn04JK/D5zmYyrgpmSSMohxRChd771gK7yRSZ
         ONv0Qpj6jdlAlXY5EiMcOlZ0eSklKPqRpfUf9MfrdQn87ucWmLWyGb5+Ic8y3UbXPqpu
         25PCY5cw/6P0ZRLM35jk8HNRKkrKLT9TqvRZGBCRhnuLbyXwHm/mkNqsw7eWaYgbg0qV
         i8a0OURZ2SvHpCCRfDU9Bxmd1h05x4T5+2iHu80HEPgpcwPEUEjLsW35YSzrBv5PcZKG
         btEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+C0R42cZXkNUI8oUTBO/cPU3Mmv17041b0kCSOqwtLk=;
        b=idHBHM1PZ6Rkjlt583WhMUKngyF2u0Fr8KV6MxfyU7jzqhpG4gnKPLkmFCDAWuc0Oa
         ITHpjeEvRPXVtNQMTId0lycT0ybdHps7Bo/o54ufZcc1QqCn+TXmt9cZaTWHx32rdg3X
         jkj7z3uZVR1tgRuEGru8xT0NSvlgYL8Uho1g7ApwHjiA9Fhh7foKdUVCtBsDIf7T1VId
         c3Io+D6eUrGSe+njM7e7NBXjeyn3SW7UM+2eZNPLiQBtGS8h8nZAV9BdoYBmhEqxOUPm
         pmmKBhUHcomSKkb6KGuVl3iGXnu3PixlL4bCCSaNT6VOI7+BO1o57UTPXNujbhxkBuC4
         nanQ==
X-Gm-Message-State: AOAM533W8T3oDPT9dV+BsRIh0trGY33FaldLP7YJ2BnVUcTIsSuZQdJr
        IRb/4Ei1HQPz5QXZizk93vU=
X-Google-Smtp-Source: ABdhPJzcwgLekA2EVT30H+IfJyowljZU3NfvinT6QUzyMGGUE2tIS4qCYEN/obGTejxIRjnjTYs95A==
X-Received: by 2002:a05:6a00:2181:b0:44c:f4bc:2f74 with SMTP id h1-20020a056a00218100b0044cf4bc2f74mr20535238pfi.68.1637304551928;
        Thu, 18 Nov 2021 22:49:11 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mr2sm1286928pjb.25.2021.11.18.22.49.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 22:49:11 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
Date:   Fri, 19 Nov 2021 14:48:54 +0800
Message-Id: <20211119064856.77948-3-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119064856.77948-1-likexu@tencent.com>
References: <20211119064856.77948-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The find_arch_event() returns a "unsigned int" value,
which is used by the pmc_reprogram_counter() to
program a PERF_TYPE_HARDWARE type perf_event.

The returned value is actually the kernel defined gernic
perf_hw_id, let's rename it to pmc_perf_hw_id() with simpler
incoming parameters for better self-explanation.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 8 +-------
 arch/x86/kvm/pmu.h           | 3 +--
 arch/x86/kvm/svm/pmu.c       | 8 ++++----
 arch/x86/kvm/vmx/pmu_intel.c | 9 +++++----
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 09873f6488f7..3b3ccf5b1106 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -174,7 +174,6 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	unsigned config, type = PERF_TYPE_RAW;
-	u8 event_select, unit_mask;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	int i;
@@ -206,17 +205,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	if (!allow_event)
 		return;
 
-	event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
-	unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
-
 	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
 			  ARCH_PERFMON_EVENTSEL_INV |
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_x86_ops.pmu_ops->find_arch_event(pmc_to_pmu(pmc),
-						      event_select,
-						      unit_mask);
+		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 59d6b76203d5..dd7dbb1c5048 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -24,8 +24,7 @@ struct kvm_event_hw_type_mapping {
 };
 
 struct kvm_pmu_ops {
-	unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
-				    u8 unit_mask);
+	unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
 	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 871c426ec389..3c00a34457d7 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -134,10 +134,10 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return &pmu->gp_counters[msr_to_index(msr)];
 }
 
-static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
-				    u8 event_select,
-				    u8 unit_mask)
+static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
+	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
+	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
@@ -319,7 +319,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops = {
-	.find_arch_event = amd_find_arch_event,
+	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
 	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b7ab5fd03681..67a0188ecdc5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,10 +68,11 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 		reprogram_counter(pmu, bit);
 }
 
-static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
-				      u8 event_select,
-				      u8 unit_mask)
+static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
+	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
@@ -719,7 +720,7 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
-	.find_arch_event = intel_find_arch_event,
+	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
-- 
2.33.1

