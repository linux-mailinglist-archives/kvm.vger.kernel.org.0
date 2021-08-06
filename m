Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293C13E2B9F
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 15:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344318AbhHFNjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 09:39:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:4266 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344257AbhHFNjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 09:39:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10068"; a="214398035"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="214398035"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:39:17 -0700
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="523463652"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 06:39:13 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V10 11/18] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
Date:   Fri,  6 Aug 2021 21:37:55 +0800
Message-Id: <20210806133802.3528-12-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210806133802.3528-1-lingshan.zhu@intel.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c    | 10 +++++++++-
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 11 +++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index b25c9d6be314..6501f8adb2b6 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -21,6 +21,7 @@
 #include <asm/intel_pt.h>
 #include <asm/apic.h>
 #include <asm/cpu_device_id.h>
+#include <asm/kvm_host.h>
 
 #include "../perf_event.h"
 
@@ -3917,6 +3918,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+	struct kvm_pmu *kvm_pmu = (struct kvm_pmu *)data;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
 	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
 	int global_ctrl, pebs_enable;
@@ -3949,9 +3951,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		return arr;
 	}
 
-	if (!x86_pmu.pebs_vmx)
+	if (!kvm_pmu || !x86_pmu.pebs_vmx)
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
index 425e872ddf4f..35f106f9f124 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -505,6 +505,7 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9938b485c31c..5584b8dfadb3 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -223,6 +223,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
 		break;
+	case MSR_IA32_DS_AREA:
+		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -373,6 +376,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		return 0;
+	case MSR_IA32_DS_AREA:
+		msr_info->data = pmu->ds_area;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -441,6 +447,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.27.0

