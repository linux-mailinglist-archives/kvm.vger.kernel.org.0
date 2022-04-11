Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870464FB954
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345324AbiDKKXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345460AbiDKKWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F333F89E;
        Mon, 11 Apr 2022 03:20:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso17954429pju.1;
        Mon, 11 Apr 2022 03:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dHFo9+3vs0W5oRSw77rSFJ0gLpLc6Pqei2ZitLw03oE=;
        b=INQ2sJMALLdMA1x78fWxKipP8dWzxwTYqg3HTv6cZKEOgO1W0lMwrmP7mIbnymVV36
         OGkECE06WE/LvQLFU0jP73S7XkcvzrqS6wRtY/Tq5kHWT3SWKWJmsR2CXLztmQ4MR0cQ
         HEOcw7/gYaL5WFZydXkfzt/7pvyB0VsUyzV4hCLnHb8XbmJi9l1zUcLf0pcD6rHTo2d3
         hBm+EVGv7rgdx5RPeLVJ+g4WaoYbQYHxOMZ20wlzOcKU7HARyIwytr8mHJbfj0QeZn68
         uvpHOkZ2G6ipUjeWTONPaIrXdi8aDKxMsfA2qm3LTAVs+qa11cd4fx0d0/FFHgoUKtm3
         A/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dHFo9+3vs0W5oRSw77rSFJ0gLpLc6Pqei2ZitLw03oE=;
        b=7u9zwMZRMyWnmcl0kDJLos+iWwOMdyHQuX2fU9SaXIEbgHKF94rsiHL+0dLpBlWSx2
         R0KTsqA1/YnK/GOZmBzqPOW5yoHACoyLQw9qhnTCcKdjZQv6iKdQ1seZksgGQ3YauK4K
         DlcjECWlSWmmOgwgrrz6VmAPewOrRuUQHpCUKmifub4l0+3iK866Jnq0UwqbcnKBkyLP
         GpP55eBqFBNJ7zgexmdpvcxD9Pfmn33/lLz8tFSwGWLAxc+yQRzGJzkGi3NnERE2WVY9
         Z97ZJn7UPQ7r+4AnyyL9tidTjOXyuR97sRyrudJsBWOuAlQ5AyabTkJb2NPRk7GYCT9t
         q8UQ==
X-Gm-Message-State: AOAM532TaO/n+L29B6NHs7pWHWB3Sh7YrVkMLsMHqjK9WUsZE2QIHa3d
        KzclF5tD18V0yAJLG8r66ag=
X-Google-Smtp-Source: ABdhPJxbJeIqj0dQtyZSggUN7l/jRw8dZ2X/SfQmKwIshH1sXgluI5ABtyUR8mEsyKn7joJogt5iSQ==
X-Received: by 2002:a17:902:ea52:b0:153:fd04:c158 with SMTP id r18-20020a170902ea5200b00153fd04c158mr31126881plg.83.1649672425982;
        Mon, 11 Apr 2022 03:20:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:25 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 11/17] KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
Date:   Mon, 11 Apr 2022 18:19:40 +0800
Message-Id: <20220411101946.20262-12-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the adaptive
PEBS is supported. The PEBS_DATA_CFG MSR and adaptive record enable
bits (IA32_PERFEVTSELx.Adaptive_Record and IA32_FIXED_CTR_CTRL.
FCx_Adaptive_Record) are also supported.

Adaptive PEBS provides software the capability to configure the PEBS
records to capture only the data of interest, keeping the record size
compact. An overflow of PMCx results in generation of an adaptive PEBS
record with state information based on the selections specified in
MSR_PEBS_DATA_CFG.By default, the record only contain the Basic group.

When guest adaptive PEBS is enabled, the IA32_PEBS_ENABLE MSR will
be added to the perf_guest_switch_msr() and switched during the VMX
transitions just like CORE_PERF_GLOBAL_CTRL MSR.

According to Intel SDM, software is recommended to  PEBS Baseline
when the following is true. IA32_PERF_CAPABILITIES.PEBS_BASELINE[14]
&& IA32_PERF_CAPABILITIES.PEBS_FMT[11:8] ≥ 4.

Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c    |  8 ++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 20 +++++++++++++++++++-
 arch/x86/kvm/x86.c              |  2 +-
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 07df5e7f444c..f723a24eb29b 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4033,6 +4033,14 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		.guest = kvm_pmu->ds_area,
 	};
 
+	if (x86_pmu.intel_cap.pebs_baseline) {
+		arr[(*nr)++] = (struct perf_guest_switch_msr){
+			.msr = MSR_PEBS_DATA_CFG,
+			.host = cpuc->pebs_data_cfg,
+			.guest = kvm_pmu->pebs_data_cfg,
+		};
+	}
+
 	pebs_enable = (*nr)++;
 	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f4152e85eca8..66057622164d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -521,6 +521,8 @@ struct kvm_pmu {
 	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
+	u64 pebs_data_cfg;
+	u64 pebs_data_cfg_mask;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 54379fcbf803..df661b5bbbf1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -205,6 +205,7 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	u64 perf_capabilities = vcpu->arch.perf_capabilities;
 	int ret;
 
 	switch (msr) {
@@ -215,11 +216,15 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = pmu->version > 1;
 		break;
 	case MSR_IA32_PEBS_ENABLE:
-		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
+		ret = perf_capabilities & PERF_CAP_PEBS_FORMAT;
 		break;
 	case MSR_IA32_DS_AREA:
 		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
 		break;
+	case MSR_PEBS_DATA_CFG:
+		ret = (perf_capabilities & PERF_CAP_PEBS_BASELINE) &&
+			((perf_capabilities & PERF_CAP_PEBS_FORMAT) > 3);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -373,6 +378,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DS_AREA:
 		msr_info->data = pmu->ds_area;
 		return 0;
+	case MSR_PEBS_DATA_CFG:
+		msr_info->data = pmu->pebs_data_cfg;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -446,6 +454,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		pmu->ds_area = data;
 		return 0;
+	case MSR_PEBS_DATA_CFG:
+		if (pmu->pebs_data_cfg == data)
+			return 0;
+		if (!(data & pmu->pebs_data_cfg_mask)) {
+			pmu->pebs_data_cfg = data;
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -519,6 +535,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
 	pmu->pebs_enable_mask = ~0ull;
+	pmu->pebs_data_cfg_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
@@ -599,6 +616,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 				pmu->fixed_ctr_ctrl_mask &=
 					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
 			}
+			pmu->pebs_data_cfg_mask = ~0xff00000full;
 		} else {
 			pmu->pebs_enable_mask =
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1f2e402d05bd..02142fa244f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1443,7 +1443,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
-	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA,
+	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
 	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
 	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
-- 
2.35.1

