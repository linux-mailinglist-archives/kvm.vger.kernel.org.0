Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943A95BC506
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 11:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiISJKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 05:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiISJKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 05:10:30 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F79B1F2F2;
        Mon, 19 Sep 2022 02:10:29 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s206so26216379pgs.3;
        Mon, 19 Sep 2022 02:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=dRecQQWYcgJJfvO0J9c0n3sUunsYqQ+igXitXiQW8OI=;
        b=hUf68X+ZnpfhVQ+Dyu7Bqyi6EtR94FWHrsp131a4+CP3EBsCSniHw+TQb3zAM/6Kkq
         fKdelNlP7kvvAIpHtOpOInobLLQqDHIr3kc1fbjHczm0lwN01h5JqZ6D/YfXLHK2+HH9
         4QYYkWCk2H/4aMYu+Rw5YUXC925cOxrvO2gyCORep+bQOzl4+/pNwf9Ed1l6fOd0QJNJ
         wAAUAQiOwLBRpIXlwIYVyrgO1xnlhHLhMlFD9a0Pu86ldHqpXtx+AAC3/bXEdoC8lZ3I
         pMFiDeMSfcO9c1inVX/9GsxXEFU27fWj+0Wi0dBLiympDpkV6u6snmYWIz9aMtkwTuKL
         SCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=dRecQQWYcgJJfvO0J9c0n3sUunsYqQ+igXitXiQW8OI=;
        b=TY4bvPuiNBFTM/qxqKBzXcMjaf40bMysHwVRrSrFQ1ytptEJpaqaKOBAcnJwyRKj0R
         A5FLJs6vnGR/TKBOyW8TthJmf7jg6eRVfF2eqwWlpmeZ8EsRX1LqnMinJfuQuKz+GUgV
         Omi46FUsibD8UZjVfAMSXw5C84dcZ/+JXW2ch13jj0QnFwvlvcqjTRuHP0m/YJmxaQZO
         ca5ew5t6L6SahWD0k9v6mOfkBJBxw8aHGPFmGeUGEvG72TI/9VjmXN3kSbS7/CrRTD0T
         FLg5XI5Gj/+xG8jME7DObCepI+v3Fi6WUlsb2+xMI7NnQaRCczEDwq5SQzPmArf0X+L2
         Ys6A==
X-Gm-Message-State: ACrzQf1jc89oup8lDOe3w1G56xNxASgXYhF6341R/FpwgEgjq9rT0bjJ
        uGBeiXa1TtdXittHPVa8QwA=
X-Google-Smtp-Source: AMsMyM6Aejg4Tj7YFQJh7XmkBWpWrs5Xc6wdQRncIln5ZfUKkl45bf/AmYyd+WgG9yjkiVrokWknEA==
X-Received: by 2002:a63:f20e:0:b0:439:398f:80f8 with SMTP id v14-20020a63f20e000000b00439398f80f8mr14761884pgh.494.1663578628938;
        Mon, 19 Sep 2022 02:10:28 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020a63a54f000000b0043395af24f6sm18185684pgu.25.2022.09.19.02.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 02:10:28 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] KVM: x86/pmu: Limit the maximum number of supported Intel GP counters
Date:   Mon, 19 Sep 2022 17:10:07 +0800
Message-Id: <20220919091008.60695-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220919091008.60695-1-likexu@tencent.com>
References: <20220919091008.60695-1-likexu@tencent.com>
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

The Intel Architectural IA32_PMCx MSRs addresses range allows for
a maximum of 8 GP counters. A local macro (named KVM_INTEL_PMC_MAX_GENERIC)
is introduced to take back control of this virtual capability to avoid
errors introduced by the out-of-bound counter emulations.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++++-
 arch/x86/kvm/pmu.c              |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  4 ++--
 arch/x86/kvm/x86.c              | 12 +++++++-----
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..17abcf5c496a 100644
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
index 9f74c3924377..bf7eafcbe5ec 100644
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
@@ -6916,14 +6918,14 @@ static void kvm_init_msr_list(void)
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

