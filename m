Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF517A2B3
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgCEJ75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:59:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:52162 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgCEJ75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:59:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:59:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366650"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:59:50 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com,
        Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 09/11] KVM: x86/pmu: Expose PEBS feature to guest
Date:   Fri,  6 Mar 2020 01:57:03 +0800
Message-Id: <1583431025-19802-10-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch exposed some bits of MSRs to KVM guest which realate with PEBS
feature. It include some bits in IA32_PERF_CAPABILITIES and IA32_MISC_ENABLE.

Originally-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h  |  1 +
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/kvm/vmx/pmu_intel.c     | 15 +++++++++++++++
 arch/x86/kvm/x86.c               |  6 +++++-
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 33b990b..35d230e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -481,6 +481,7 @@ struct kvm_pmu {
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
 	u64 ds_area;
+	u64 perf_cap;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d5e517d..2bf66e9 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -151,6 +151,9 @@
 #define MSR_PEBS_DATA_CFG		0x000003f2
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
+#define PERF_CAP_PEBS_TRAP		BIT_ULL(6)
+#define PERF_CAP_ARCH_REG		BIT_ULL(7)
+#define PERF_CAP_PEBS_FORMAT		0xf00
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 
 #define MSR_IA32_RTIT_CTL		0x00000570
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 227589a..8161488 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -180,6 +180,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		break;
 	case MSR_IA32_DS_AREA:
 	case MSR_IA32_PEBS_ENABLE:
+	case MSR_IA32_PERF_CAPABILITIES:
 		ret = pmu->has_pebs_via_ds;
 		break;
 	default:
@@ -244,6 +245,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	case MSR_IA32_DS_AREA:
 		*data = pmu->ds_area;
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		*data = pmu->perf_cap;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -311,6 +315,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DS_AREA:
 		pmu->ds_area = data;
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES:
+		break; /* RO MSR */
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (!msr_info->host_initiated)
@@ -396,6 +402,15 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->pebs_enable_mask = ~pmu->global_ctrl;
 	}
 
+	if (pmu->has_pebs_via_ds) {
+		u64 perf_cap;
+
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+		pmu->perf_cap = (perf_cap & (PERF_CAP_PEBS_TRAP |
+					     PERF_CAP_ARCH_REG |
+					     PERF_CAP_PEBS_FORMAT));
+	}
+
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a23406..5ab8447 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3086,7 +3086,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = (u64)vcpu->arch.ia32_tsc_adjust_msr;
 		break;
 	case MSR_IA32_MISC_ENABLE:
-		msr_info->data = vcpu->arch.ia32_misc_enable_msr;
+		if (vcpu_to_pmu(vcpu)->has_pebs_via_ds)
+			msr_info->data = (vcpu->arch.ia32_misc_enable_msr &
+					~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL);
+		else
+			msr_info->data = vcpu->arch.ia32_misc_enable_msr;
 		break;
 	case MSR_IA32_SMBASE:
 		if (!msr_info->host_initiated)
-- 
1.8.3.1

