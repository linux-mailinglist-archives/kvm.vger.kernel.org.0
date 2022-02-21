Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FC04BE67C
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357003AbiBULxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:53:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356958AbiBULxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:53:08 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887241FA4C;
        Mon, 21 Feb 2022 03:52:33 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id u16so8592174pfg.12;
        Mon, 21 Feb 2022 03:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+B3Yky+zX1epczrKKuYCg8o/0cqQs8TYj8PRpxw+424=;
        b=pooyAdproOfT2WxnVSFkUF1HI3Eb6lRxlD6qBC68zDRuewvLYxxUAEXW1ewC4fSXYm
         eSzFPVp5z0r1S5G2un8gI5vv+4Bi9BWHV29/IY0WMBJEGz56wPxldFG3oTgrguwRTXVa
         q9LPYlKlRuwkZWE0OYp5R0LG89MtcjTIuYxeUArL0QzVYe6wvd6vyzI56pQ1/ZCbgUiA
         ZJ0KT1OAC2fWdwg3YG6FMjzDlBO6bkL/kDS5qDDzQzjwt0akzil1yHPPxaXaHOaLvf9U
         g/8sb5UXh2G1nhkAtoEv9NzTq42hzJBRPWo1ONvpS9KMzwujg6zYILzgh8Vq+9qaLdlX
         Xmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+B3Yky+zX1epczrKKuYCg8o/0cqQs8TYj8PRpxw+424=;
        b=h6B8YrYF56iRdto3EaqVAFv2DdpTKZPXbvEpXDS9QjLa1+PY0r4nbGNTbjEVye6x8E
         uq5UAs+y6eIB9p+P2igDU/Pb2cSEA7cwxjfqaOw9lHS4AbyEg1IwsfK7Dz5CmcZx6vsP
         fnYIlyezha8kqouBg63bqav2NXkzy58JXNdyh4LBGpofXTxh93z7aIQqXjYNZYrrukGu
         036C0oEpTJkc4gi98TaiE7MqJiqVT2aCo5CMiuu2r2iE1Czc668kWiig0Ehg7K4/93SJ
         n46SHzwQc0SkVndG9FYkf0iAQ0MI/pzaiTcg7uIAQYrXKFTZuisEMwtnUMVf/7PskK7+
         3SFg==
X-Gm-Message-State: AOAM533wJQNhYQTLvcz336VOBV1YmL781YsFwcAAHbL78k7sMUYJHMsy
        yrKMnrLKVtl9wSazwZFTheA=
X-Google-Smtp-Source: ABdhPJyIbe2WfkEX4KIh8EsuwCuJAhUcr3bAQJP6HdFd+D4fzMWdj8tetxn/iE6hV6voS0/5F7x9tg==
X-Received: by 2002:a05:6a00:218a:b0:4e1:9ed6:c399 with SMTP id h10-20020a056a00218a00b004e19ed6c399mr19638896pfi.8.1645444353069;
        Mon, 21 Feb 2022 03:52:33 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:32 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 07/11] KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp, fixed}counter()
Date:   Mon, 21 Feb 2022 19:51:57 +0800
Message-Id: <20220221115201.22208-8-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220221115201.22208-1-likexu@tencent.com>
References: <20220221115201.22208-1-likexu@tencent.com>
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

The code sketch for reprogram_{gp, fixed}_counter() is similar, while the
fixed counter using the PERF_TYPE_HARDWAR type and the gp being
able to use either PERF_TYPE_HARDWAR or PERF_TYPE_RAW type
depending on the pmc->eventsel value.

After 'commit 761875634a5e ("KVM: x86/pmu: Setup pmc->eventsel
for fixed PMCs")', the pmc->eventsel of the fixed counter will also have
been setup with the same semantic value and will not be changed during
the guest runtime. But essentially, "the HARDWARE is just a convenience
wrapper over RAW IIRC", quoated from Peterz. So it could be pretty safe
to use the PERF_TYPE_RAW type only to program both gp and fixed
counters naturally in the reprogram_counter().

To make the gp and fixed counters more semantically symmetrical,
the selection of EVENTSEL_{USER, OS, INT} bits is temporarily translated
via fixed_ctr_ctrl before the pmc_reprogram_counter() call.

Practically, this change drops the guest pmu support on the hosts without
X86_FEATURE_ARCH_PERFMON  (the oldest Pentium 4), where the
PERF_TYPE_HARDWAR is intentionally introduced so that hosts can
map the architectural guest PMU events to their own.

Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 106 +++++++++++------------------------
 arch/x86/kvm/vmx/pmu_intel.c |   2 +-
 2 files changed, 35 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5816af6b6494..edd51ec7711d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -213,35 +213,44 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-static void reprogram_gp_counter(struct kvm_pmc *pmc)
+static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 {
-	u64 config;
-	u32 type = PERF_TYPE_RAW;
-	u64 eventsel = pmc->eventsel;
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
-	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
-		printk_once("kvm pmu: pin control bit is ignored\n");
+	if (pmc_is_fixed(pmc))
+		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+
+	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
+}
+
+void reprogram_counter(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u64 eventsel = pmc->eventsel;
+	u8 fixed_ctr_ctrl;
 
 	pmc_pause_counter(pmc);
 
-	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
+	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
 		return;
 
 	if (!check_pmu_event_filter(pmc))
 		return;
 
-	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
-			  ARCH_PERFMON_EVENTSEL_INV |
-			  ARCH_PERFMON_EVENTSEL_CMASK |
-			  HSW_IN_TX |
-			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
-		if (config != PERF_COUNT_HW_MAX)
-			type = PERF_TYPE_HARDWARE;
-	}
+	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
+		printk_once("kvm pmu: pin control bit is ignored\n");
 
-	if (type == PERF_TYPE_RAW)
-		config = eventsel & AMD64_RAW_EVENT_MASK;
+	if (pmc_is_fixed(pmc)) {
+		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+						  pmc->idx - INTEL_PMC_IDX_FIXED);
+		if (fixed_ctr_ctrl & 0x1)
+			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
+		if (fixed_ctr_ctrl & 0x2)
+			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
+		if (fixed_ctr_ctrl & 0x8)
+			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
+	}
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
@@ -249,49 +258,13 @@ static void reprogram_gp_counter(struct kvm_pmc *pmc)
 	pmc_release_perf_event(pmc);
 
 	pmc->current_config = eventsel;
-	pmc_reprogram_counter(pmc, type, config,
-			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
-			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			      eventsel & ARCH_PERFMON_EVENTSEL_INT,
-			      (eventsel & HSW_IN_TX),
-			      (eventsel & HSW_IN_TX_CHECKPOINTED));
-}
-
-static void reprogram_fixed_counter(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-	int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
-	u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
-	unsigned en_field = ctrl & 0x3;
-	bool pmi = ctrl & 0x8;
-
-	pmc_pause_counter(pmc);
-
-	if (!en_field || !pmc_is_enabled(pmc))
-		return;
-
-	if (!check_pmu_event_filter(pmc))
-		return;
-
-	if (pmc->current_config == (u64)ctrl && pmc_resume_counter(pmc))
-		return;
-
-	pmc_release_perf_event(pmc);
-
-	pmc->current_config = (u64)ctrl;
-	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
-			      !(en_field & 0x2), /* exclude user */
-			      !(en_field & 0x1), /* exclude kernel */
-			      pmi, false, false);
-}
-
-void reprogram_counter(struct kvm_pmc *pmc)
-{
-	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc);
-	else
-		reprogram_fixed_counter(pmc);
+	pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
+			(eventsel & AMD64_RAW_EVENT_MASK),
+			!(eventsel & ARCH_PERFMON_EVENTSEL_USR),
+			!(eventsel & ARCH_PERFMON_EVENTSEL_OS),
+			eventsel & ARCH_PERFMON_EVENTSEL_INT,
+			(eventsel & HSW_IN_TX),
+			(eventsel & HSW_IN_TX_CHECKPOINTED));
 }
 EXPORT_SYMBOL_GPL(reprogram_counter);
 
@@ -449,17 +422,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	kvm_pmu_refresh(vcpu);
 }
 
-static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-
-	if (pmc_is_fixed(pmc))
-		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
-
-	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
-}
-
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a69d2aeb7526..98a01f6a9d5d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -492,7 +492,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry || !enable_pmu)
+	if (!entry || !enable_pmu || !boot_cpu_has(X86_FEATURE_ARCH_PERFMON))
 		return;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
-- 
2.35.0

