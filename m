Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289204FB7B3
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344515AbiDKJir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344504AbiDKJic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8099C3ED0F;
        Mon, 11 Apr 2022 02:36:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h15-20020a17090a054f00b001cb7cd2b11dso3976712pjf.5;
        Mon, 11 Apr 2022 02:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PpOmNT+zFHw3HpmH5xZ8DuWxHcZJ/R853DTdReZC2lM=;
        b=ge0EC93AoQGS+Za/9YD4gJX/2vK8kkzxzjbqIar/bOsGylzNqktYzfyPsWHYHd7OJP
         hsMZrlDwzWcjyR30EzogmE5c2ibikrImqFDknfi6HSYE3FED5R+I9g6olabM492PgLnH
         EMlPWMz2v1MkA5c3dFIBAzj/MUrYGHWM4kJ+O4ueI2DGHQwvvnmTawK+tWQ0UDx0NCZJ
         KEYl5qfA1y73v7bcpt7VyA6Gf/sYsdaeymEuGpPdx9FntX9rNJQ68hlJ14fckioBvfNN
         jya5JuvaO8xisZaBqcKbI2EMLSNSiH0eYNIJw5oVwO5evBtMWAMajvywLdh5a3la+jsp
         JgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PpOmNT+zFHw3HpmH5xZ8DuWxHcZJ/R853DTdReZC2lM=;
        b=rsut6+k8kUab1QV09Vjpnh/w7tO5cJa0sKuRL1AtNO/ta4vxpwi+R0uKWSctHeIovR
         eRy1ljz1EPEpJ6uK+T5VWoi3ZfhKTj5q21zSppSp0JGe2oKI+y5HaDTm6k9+zuDAsUcz
         UB4V0DJ1VmKjYAyhsy1JeCZVD804dU+XW0Snu/6UNXQuFF47KVAqE0SDkNL44JV93Q9d
         ZYiq/2dC6r/O+GuEfRYYQA9NvKhfdvZWCKJn31rqRj1tL6JT4EZqFJfP7g1sAlZ/aYEQ
         fWINtCCGkrAscmMgMvPSh7VK7+2F6rtc6tO3DQplp+FJ8p3DijL5YigLJymN4VDBI5Q3
         DxOw==
X-Gm-Message-State: AOAM531+srjijtyD7e8qTE+Z/hEQFMOnUZUdFOhcNOY5WxJ8MEqyDXYB
        kJHcjEyc/x3s3IKTK5KO4qo=
X-Google-Smtp-Source: ABdhPJyNSNrrEzr+l0L0XrSQhnwdv/xhVc7YI9t8GVc8FkZl2TSvkN8AEE1nYIWsSq3f/ONtM6YWig==
X-Received: by 2002:a17:90b:1e04:b0:1ca:b593:cae4 with SMTP id pg4-20020a17090b1e0400b001cab593cae4mr35109231pjb.181.1649669768115;
        Mon, 11 Apr 2022 02:36:08 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:36:07 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 08/11] KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp,fixed}counter()
Date:   Mon, 11 Apr 2022 17:35:34 +0800
Message-Id: <20220411093537.11558-9-likexu@tencent.com>
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

The code sketch for reprogram_{gp, fixed}_counter() is similar, while the
fixed counter using the PERF_TYPE_HARDWAR type and the gp being
able to use either PERF_TYPE_HARDWAR or PERF_TYPE_RAW type
depending on the pmc->eventsel value.

After 'commit 761875634a5e ("KVM: x86/pmu: Setup pmc->eventsel
for fixed PMCs")', the pmc->eventsel of the fixed counter will also have
been setup with the same semantic value and will not be changed during
the guest runtime.

The original story of using the PERF_TYPE_HARDWARE type is to emulate
guest architecture PMU on a host without architecture PMU (the Pentium 4),
for which the guest vPMC needs to be reprogrammed using the kernel
generic perf_hw_id. But essentially, "the HARDWARE is just a convenience
wrapper over RAW IIRC", quoated from Peterz. So it could be pretty safe
to use the PERF_TYPE_RAW type only in practice to program both gp and
fixed counters naturally in the reprogram_counter().

To make the gp and fixed counters more semantically symmetrical,
the selection of EVENTSEL_{USER, OS, INT} bits is temporarily translated
via fixed_ctr_ctrl before the pmc_reprogram_counter() call.

Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 125 ++++++++++++-----------------------
 arch/x86/kvm/vmx/pmu_intel.c |   3 +-
 2 files changed, 46 insertions(+), 82 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 598b19223965..58960844f49f 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -240,84 +240,58 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-static void reprogram_gp_counter(struct kvm_pmc *pmc)
-{
-	u64 config;
-	u32 type = PERF_TYPE_RAW;
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-	u64 eventsel = pmc->eventsel;
-
-	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
-		printk_once("kvm pmu: pin control bit is ignored\n");
-
-	pmc_pause_counter(pmc);
-
-	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
-		return;
-
-	if (!check_pmu_event_filter(pmc))
-		return;
-
-	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
-			  ARCH_PERFMON_EVENTSEL_INV |
-			  ARCH_PERFMON_EVENTSEL_CMASK |
-			  HSW_IN_TX |
-			  HSW_IN_TX_CHECKPOINTED))) {
-		config = static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc);
-		if (config != PERF_COUNT_HW_MAX)
-			type = PERF_TYPE_HARDWARE;
-	}
-
-	if (type == PERF_TYPE_RAW)
-		config = eventsel & pmu->raw_event_mask;
-
-	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
-		return;
-
-	pmc_release_perf_event(pmc);
-
-	pmc->current_config = eventsel;
-	pmc_reprogram_counter(pmc, type, config,
-			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
-			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
-}
-
-static void reprogram_fixed_counter(struct kvm_pmc *pmc)
+static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-	int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
-	u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
-	unsigned en_field = ctrl & 0x3;
-	bool pmi = ctrl & 0x8;
 
-	pmc_pause_counter(pmc);
+	if (pmc_is_fixed(pmc))
+		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
 
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
-			      static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc),
-			      !(en_field & 0x2), /* exclude user */
-			      !(en_field & 0x1), /* exclude kernel */
-			      pmi);
+	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
 void reprogram_counter(struct kvm_pmc *pmc)
 {
-	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc);
-	else
-		reprogram_fixed_counter(pmc);
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u64 eventsel = pmc->eventsel;
+	u64 new_config = eventsel;
+	u8 fixed_ctr_ctrl;
+
+	pmc_pause_counter(pmc);
+
+	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
+		return;
+
+	if (!check_pmu_event_filter(pmc))
+		return;
+
+	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
+		printk_once("kvm pmu: pin control bit is ignored\n");
+
+	if (pmc_is_fixed(pmc)) {
+		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+						  pmc->idx - INTEL_PMC_IDX_FIXED);
+		if (fixed_ctr_ctrl & 0x1)
+			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
+		if (fixed_ctr_ctrl & 0x2)
+			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
+		if (fixed_ctr_ctrl & 0x8)
+			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
+		new_config = (u64)fixed_ctr_ctrl;
+	}
+
+	if (pmc->current_config == new_config && pmc_resume_counter(pmc))
+		return;
+
+	pmc_release_perf_event(pmc);
+
+	pmc->current_config = new_config;
+	pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
+			      (eventsel & pmu->raw_event_mask),
+			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
+			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
+			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
 EXPORT_SYMBOL_GPL(reprogram_counter);
 
@@ -474,17 +448,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
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
index 1f910b349978..11eb186929bc 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -498,7 +498,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry || !vcpu->kvm->arch.enable_pmu)
+	if (!entry || !vcpu->kvm->arch.enable_pmu ||
+	    !boot_cpu_has(X86_FEATURE_ARCH_PERFMON))
 		return;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
-- 
2.35.1

