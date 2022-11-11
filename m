Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3F9625848
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiKKK1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbiKKK1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:27:07 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F00E87;
        Fri, 11 Nov 2022 02:27:06 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id f63so4095591pgc.2;
        Fri, 11 Nov 2022 02:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5eBVcPwaumKEJXIVyuoCommILQ5oYUh8LUmCMRlRlA4=;
        b=nQRKc3KRVa6H4PmpzFnyJ53zEPjofu0/sxR+ed1Je28U1sYGnGM80b8YSXm3SEpx3t
         LTIrSMyrKZfibUV8rIUlN1FTUv2Pn1/VLzWGi6a/a55IBywpHct4smEgVKKcv/e0QQac
         2Ww4WTa5SrdY1KUpQizE2R6a9Th2E0DdzZyanxXlbMua7IX4nWjpH1Bca/5Rv9ZNGO/v
         vJsEQfExkZ4V4Jsqr0svl4UYrkwW2+xlA7zONYZccW1G1BV4Id9gez5BJi+MX1XW3/Ol
         /Zq+ikBpRbGv4LoAg2OWVf0PSXJry4vaeQ94n27BNx4iOgFwUrzkwo+LsrysBcRB0l41
         +Skg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5eBVcPwaumKEJXIVyuoCommILQ5oYUh8LUmCMRlRlA4=;
        b=e1oyDWnK8Ddb3hnW+xZhLS3fgqWGNHoCJeylFrCfYatk91oy6lSYcHq3N9jSzO8hmP
         Kx75Ekw0GVA3pnKc6Dfe42KAzYZEEE/WuwNHtKonLr3abrofgUxEovpAu6GzttWOspGk
         a+n13xjK3IeXQq4M9HUpxe3NW0Pwio7ThPjyq9/8uwdO+k3xt9uNDhVdNL/e6FpjfvTR
         cC5aFraXdzeFxbCnDwxv6wt9gPuLmrUcAWfMrfIAEm1OWfoSjIA9Kt1AVmhqavl3JOp6
         T+ynvG/BdhlKaNB74jsuXSLnZfYeYgocWQuHZaJfHWeOee4BoSr3H1BYljYYXSdnE6Gz
         UmGQ==
X-Gm-Message-State: ANoB5pk6U0JvLn9zvgmfct10rugXCJKTQbXcpwKLmtRfMl8HNEAMcngf
        mAe/EPmTotiLiOTiLOMRapg=
X-Google-Smtp-Source: AA0mqf7uVi27c9V8jBatoZYzmP2OylyMD2uxJ4pxcHzNEvu7tMfttFLJYtu46qob8/Xvvwy82pWONg==
X-Received: by 2002:a63:1042:0:b0:43c:1cb8:73ba with SMTP id 2-20020a631042000000b0043c1cb873bamr1120656pgq.11.1668162426371;
        Fri, 11 Nov 2022 02:27:06 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u67-20020a626046000000b0056b6acb58a0sm1248612pfb.102.2022.11.11.02.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 02:27:06 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v3 1/8] KVM: x86/pmu: Rename pmc_is_enabled() to pmc_is_globally_enabled()
Date:   Fri, 11 Nov 2022 18:26:38 +0800
Message-Id: <20221111102645.82001-2-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111102645.82001-1-likexu@tencent.com>
References: <20221111102645.82001-1-likexu@tencent.com>
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

The name of function pmc_is_enabled() is a bit misleading. A PMC can
be disabled either by PERF_CLOBAL_CTRL or by its corresponding EVTSEL.
Add the global semantic to its name.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h | 2 +-
 arch/x86/kvm/pmu.c                     | 6 +++---
 arch/x86/kvm/pmu.h                     | 2 +-
 arch/x86/kvm/svm/pmu.c                 | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c           | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index c17e3e96fc1d..86a3fb01e103 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -13,7 +13,7 @@ BUILD_BUG_ON(1)
  * at the call sites.
  */
 KVM_X86_PMU_OP(hw_event_available)
-KVM_X86_PMU_OP(pmc_is_enabled)
+KVM_X86_PMU_OP(pmc_is_globally_enabled)
 KVM_X86_PMU_OP(pmc_idx_to_pmc)
 KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
 KVM_X86_PMU_OP(msr_idx_to_pmc)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 684393c22105..e57f707fb940 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -83,7 +83,7 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
 #undef __KVM_X86_PMU_OP
 }
 
-static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
+static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
 {
 	return static_call(kvm_x86_pmu_pmc_is_enabled)(pmc);
 }
@@ -306,7 +306,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 
 	pmc_pause_counter(pmc);
 
-	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
+	if (!pmc_speculative_in_use(pmc) || !pmc_is_globally_enabled(pmc))
 		goto reprogram_complete;
 
 	if (!check_pmu_event_filter(pmc))
@@ -581,7 +581,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
 		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
-		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
+		if (!pmc || !pmc_is_globally_enabled(pmc) || !pmc_speculative_in_use(pmc))
 			continue;
 
 		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 85ff3c0588ba..2b5376ba66ea 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -26,7 +26,7 @@ struct kvm_event_hw_type_mapping {
 
 struct kvm_pmu_ops {
 	bool (*hw_event_available)(struct kvm_pmc *pmc);
-	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
+	bool (*pmc_is_globally_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 0e313fbae055..7958a983b760 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -218,7 +218,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.hw_event_available = amd_hw_event_available,
-	.pmc_is_enabled = amd_pmc_is_enabled,
+	.pmc_is_globally_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e5cec07ca8d9..f81cf54a245f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -797,7 +797,7 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.hw_event_available = intel_hw_event_available,
-	.pmc_is_enabled = intel_pmc_is_enabled,
+	.pmc_is_globally_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.38.1

