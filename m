Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B89B4CD0B5
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbiCDJGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbiCDJGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:06:17 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CBC1A615B;
        Fri,  4 Mar 2022 01:05:15 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gb21so6837978pjb.5;
        Fri, 04 Mar 2022 01:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5+cvDJpNHJYywdcUky33cLSwZ0u/2lgK3+gk4QmnN8o=;
        b=laOTKsYM+a43ly2RKT0K7DodAyYi+uY5mwbzGHawhsyQPBRz5SKdpVhZXSg/10IJ0t
         FOrBKTkEUSyIHysHwkMzEueaa7rbAM3MckIMBMKiGiuDB5J3OUHxytTEg5FCG1LwlRh6
         3IMheXJuFvhCfW9JllWHgPj9B7QBftnMDITAV2iLaVTC8rdbqHiEUSkH0yQ6pXAbCsu1
         5ZEMbqM6CnqBCUm+HY5Aulplt1iwgy7tRTEe7rCh24Dp/MqgnWQb6R4oJwIE+fwszkv1
         fMU8mUBchC0qd8wTvTBjK8L+adtZqbcad4eUxkwYyinm5Wcy1QRcwzDxALAFjlLSkjnd
         6E7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5+cvDJpNHJYywdcUky33cLSwZ0u/2lgK3+gk4QmnN8o=;
        b=V3BZFiB2s5Ldm33jnPxlLfUEjOUvVfZc0+Ag4KqufldCgxd83p6rKKF0FJpHwSX4F9
         63PjSE8q3i+sM/JJi5yIClktQEpTvi7Md7qEpOqDadiBHosREWvceUgKRnXXV75AYZPC
         kWN+Jb1A+/CLRpOXHlqBJ5ToJ7QtzOKgQO0ZZR3IZ7x3chcC3N761mJO4DQXyijwLry9
         Az2K+S/gFR1F/5RuigqRcv0k6rrwScIFf68MYeCUVtbyZ19NditSOrTnxvcsAnjGGnV0
         4LCkihHRf+EyjFlv/vgFCaUPsX1zUb/j8s5swYclwpCIlDmv1yYtGdOa4Tq1Ij6y5LoA
         JvNQ==
X-Gm-Message-State: AOAM530fU1Bdcw1C9+R6xh5D4Po0k6xglsFVtmakIdodqBGbaa6A1/tQ
        AI4RzXlN1y104sfIXLl0HIM=
X-Google-Smtp-Source: ABdhPJw1pFdVFBh3ni9L60rQpelDBYQhKZWfKTe3CAQs/ce+M3tSvprU5jfMw6kR/8lVzUPvmBqAZw==
X-Received: by 2002:a17:90a:4542:b0:1b9:bc2a:910f with SMTP id r2-20020a17090a454200b001b9bc2a910fmr9454094pjm.133.1646384715120;
        Fri, 04 Mar 2022 01:05:15 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:14 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 10/17] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
Date:   Fri,  4 Mar 2022 17:04:20 +0800
Message-Id: <20220304090427.90888-11-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
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

From: Like Xu <like.xu@linux.intel.com>

When CPUID.01H:EDX.DS[21] is set, the IA32_DS_AREA MSR exists and points
to the linear address of the first byte of the DS buffer management area,
which is used to manage the PEBS records.

When guest PEBS is enabled, the MSR_IA32_DS_AREA MSR will be added to the
perf_guest_switch_msr() and switched during the VMX transitions just like
CORE_PERF_GLOBAL_CTRL MSR. The WRMSR to IA32_DS_AREA MSR brings a #GP(0)
if the source register contains a non-canonical address.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c    | 10 +++++++++-
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 11 +++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index f88b3be88061..1e303539f205 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -21,6 +21,7 @@
 #include <asm/intel_pt.h>
 #include <asm/apic.h>
 #include <asm/cpu_device_id.h>
+#include <asm/kvm_host.h>
 
 #include "../perf_event.h"
 
@@ -3969,6 +3970,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+	struct kvm_pmu *kvm_pmu = (struct kvm_pmu *)data;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
 	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
 	int global_ctrl, pebs_enable;
@@ -4001,9 +4003,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		return arr;
 	}
 
-	if (!x86_pmu.pebs_ept)
+	if (!kvm_pmu || !x86_pmu.pebs_ept)
 		return arr;
 
+	arr[(*nr)++] = (struct perf_guest_switch_msr){
+		.msr = MSR_IA32_DS_AREA,
+		.host = (unsigned long)cpuc->ds,
+		.guest = kvm_pmu->ds_area,
+	};
+
 	pebs_enable = (*nr)++;
 	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3bc4c5d79110..c6ccb8aea407 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -519,6 +519,7 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9f1b25d7b966..b0c3f13e392b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -217,6 +217,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
 		break;
+	case MSR_IA32_DS_AREA:
+		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -367,6 +370,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		return 0;
+	case MSR_IA32_DS_AREA:
+		msr_info->data = pmu->ds_area;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -434,6 +440,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_DS_AREA:
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		pmu->ds_area = data;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
-- 
2.35.1

