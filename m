Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B625B020F
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 12:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiIGKtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 06:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiIGKs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 06:48:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C7D85FF4;
        Wed,  7 Sep 2022 03:48:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o2-20020a17090a9f8200b0020025a22208so10642376pjp.2;
        Wed, 07 Sep 2022 03:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=dfT4FzvwwKlQZnIuSLlYyTj6W7EjK7O33+q3fAWSgb0=;
        b=jdJK35vQ1696uJEUPo5YpRTagxp335KyDP1YpvfBWjBqnRZm3s5ZGRd25bzywXmoP+
         MX9ZObSxNn2Gr92zYPUkxNWeNDsnKTvltL5dACVVT52ZdAp/rNQQR77hLMeoCvBqVM+U
         vWbWK4x2FXXcKVWNSN+urNKbkc8Hv6Kvj9HO+Un8BMt4HTXlszxxTgZ5BhV+9EwsV3nk
         LoLV4ep8c5bD7pzlq7Up3QIg5bjtHF+gapaWLjhkFCTGbXMAKaNTBbyuYaW7uKUeahpy
         4LmQDXLRC9Q3AMb7MWQp2mGr5dH7O4XjoFV0bUHFQvn0+PZwY5LrE+jhEM0SK5jnq8Q1
         hQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=dfT4FzvwwKlQZnIuSLlYyTj6W7EjK7O33+q3fAWSgb0=;
        b=tgxmbjJUQe0F5KxytfzLN0DujOQh/ranI/b+DuUIG96zmCzb2lCkpv2SsOCene9qEj
         Ecv3TaF489NC50Nn9rfdhz2ZeooKa5NH1gPK6pHZbaCU3cVWHI8Ily8F5e99Ga0XAGAF
         MgSTwhO/vH1WJC0LB88DunWqEXL2FPjxQnxfKYoKIXtxskHYvmhtQUjonsEF9hHY0Epz
         dG+fjnMAf1/+pKegZthV1Dy/5b/aRaZfPZb4Hg0E87kMTRQpF9XhGBztxVnMCGwUDwRH
         5c1LFP7dCguILynOhkoEovEnm2drX8/ovOVbpt9DopWhz++05fpfRsCLbeQepQL4tok+
         bJXQ==
X-Gm-Message-State: ACgBeo32aYx3BLquJeHHGnTE3L/viFmwwAoviGnFidSPNbtvKI6tNsWJ
        j+Bh5DKX+OAbUZ6LQm3qRpI=
X-Google-Smtp-Source: AA6agR6xpCEuiVlL/Wab33T0UddoBiEkorLuScSKLU76v440XPw0EhTHEhtE8nNvtlB1m2W5fApBrw==
X-Received: by 2002:a17:90b:3e82:b0:1f7:3792:d33c with SMTP id rj2-20020a17090b3e8200b001f73792d33cmr3254090pjb.222.1662547738391;
        Wed, 07 Sep 2022 03:48:58 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79a4e000000b0053e22fc5b4fsm4044044pfj.0.2022.09.07.03.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 03:48:58 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 2/3] KVM: x86/pmu: Limit the maximum number of supported Intel GP counters
Date:   Wed,  7 Sep 2022 18:48:37 +0800
Message-Id: <20220907104838.8424-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220907104838.8424-1-likexu@tencent.com>
References: <20220907104838.8424-1-likexu@tencent.com>
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

The Intel Architectural IA32_PMCx MSRs addresses range allows for
a maximum of 8 GP counters. A local macro (named KVM_INTEL_PMC_MAX_GENERIC)
is introduced to take back control of this virtual capability to avoid
errors introduced by the out-of-bound counter emulations.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++++-
 arch/x86/kvm/pmu.c              |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  4 ++--
 arch/x86/kvm/x86.c              | 12 +++++++-----
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..70b8266b0474 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -501,6 +501,10 @@ struct kvm_pmc {
 	bool intr;
 };
 
+/* More counters may conflict with other existing Architectural MSRs */
+#define KVM_INTEL_PMC_MAX_GENERIC	8
+#define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
+#define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define KVM_PMC_MAX_FIXED	3
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
@@ -516,7 +520,7 @@ struct kvm_pmu {
 	u64 reserved_bits;
 	u64 raw_event_mask;
 	u8 version;
-	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
+	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
 	struct irq_work irq_work;
 	DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 02f9e4f245bd..15625b858800 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -56,7 +56,7 @@ static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
  *        code. Each pmc, stored in kvm_pmc.idx field, is unique across
  *        all perf counters (both gp and fixed). The mapping relationship
  *        between pmc and perf counters is as the following:
- *        * Intel: [0 .. INTEL_PMC_MAX_GENERIC-1] <=> gp counters
+ *        * Intel: [0 .. KVM_INTEL_PMC_MAX_GENERIC-1] <=> gp counters
  *                 [INTEL_PMC_IDX_FIXED .. INTEL_PMC_IDX_FIXED + 2] <=> fixed
  *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] and, for families 15H
  *          and later, [0 .. AMD64_NUM_COUNTERS_CORE-1] <=> gp counters
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c399637a3a79..ac74fb88e3c8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -617,7 +617,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
-	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
+	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
@@ -643,7 +643,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmc *pmc = NULL;
 	int i;
 
-	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
+	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
 		pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 884f6de11a33..fd64003ee0e0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1424,6 +1424,9 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
+
+	/* This part of MSRs should match KVM_INTEL_PMC_MAX_GENERIC. */
 	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,
 	MSR_ARCH_PERFMON_PERFCTR0 + 2, MSR_ARCH_PERFMON_PERFCTR0 + 3,
 	MSR_ARCH_PERFMON_PERFCTR0 + 4, MSR_ARCH_PERFMON_PERFCTR0 + 5,
@@ -1432,7 +1435,6 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 6, MSR_ARCH_PERFMON_EVENTSEL0 + 7,
-	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
 	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
 	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
@@ -6933,14 +6935,14 @@ static void kvm_init_msr_list(void)
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
 			break;
-		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 7:
+		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
-			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
+			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
-		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 7:
+		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
-			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
+			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
 		case MSR_IA32_XFD:
-- 
2.37.3

