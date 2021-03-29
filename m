Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5000D34C33A
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 07:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhC2Fu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 01:50:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:15632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230506AbhC2Ftz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 01:49:55 -0400
IronPort-SDR: 9eNo31UpZ6eEjDnWOQLJfhcz/vPLbkfvQGddUOCzltMsUbLufmDiV4/RkiQp2sr0cV2NctG0Nr
 y+lvRe+p829Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="255478749"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="255478749"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 22:49:55 -0700
IronPort-SDR: m9536HqlSSY7P1ovv8vhHBhmL8/F1HDyGZ0GnCreXnucKTQTSKfNnRf948UrP8homCWP48Ouj2
 pzamBgZqwy/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="417506823"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2021 22:49:51 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     eranian@google.com, andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v4 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to manage guest DS buffer
Date:   Mon, 29 Mar 2021 13:41:29 +0800
Message-Id: <20210329054137.120994-9-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210329054137.120994-1-like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When CPUID.01H:EDX.DS[21] is set, the IA32_DS_AREA MSR exists and
points to the linear address of the first byte of the DS buffer
management area, which is used to manage the PEBS records.

When guest PEBS is enabled and the value is different from the
host, KVM will add the IA32_DS_AREA MSR to the msr-switch list.
The guest's DS value can be loaded to the real HW before VM-entry,
and will be removed when guest PEBS is disabled.

The WRMSR to IA32_DS_AREA MSR brings a #GP(0) if the source register
contains a non-canonical address. The switch of IA32_DS_AREA MSR would
also, setup a quiescent period to write the host PEBS records (if any)
to host DS area rather than guest DS area.

When guest PEBS is enabled, the MSR_IA32_DS_AREA MSR will be
added to the perf_guest_switch_msr() and switched during the
VMX transitions just like CORE_PERF_GLOBAL_CTRL MSR.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c    | 15 ++++++++++++---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c          |  1 +
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2ca8ed61f444..7f3821a59b84 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -21,6 +21,7 @@
 #include <asm/intel_pt.h>
 #include <asm/apic.h>
 #include <asm/cpu_device_id.h>
+#include <asm/kvm_host.h>
 
 #include "../perf_event.h"
 
@@ -3841,6 +3842,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
+	struct kvm_pmu *pmu = (struct kvm_pmu *)data;
 
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
@@ -3851,11 +3854,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
 	*nr = 1;
 
-	if (x86_pmu.pebs) {
+	if (pmu && x86_pmu.pebs) {
 		arr[1].msr = MSR_IA32_PEBS_ENABLE;
 		arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
 		arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
 
+		arr[2].msr = MSR_IA32_DS_AREA;
+		arr[2].host = (unsigned long)ds;
+		arr[2].guest = pmu->ds_area;
+
 		/*
 		 * If PMU counter has PEBS enabled it is not enough to
 		 * disable counter on a guest entry since PEBS memory
@@ -3869,10 +3876,12 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 
 		if (arr[1].guest)
 			arr[0].guest |= arr[1].guest;
-		else
+		else {
 			arr[1].guest = arr[1].host;
+			arr[2].guest = arr[2].host;
+		}
 
-		*nr = 2;
+		*nr = 3;
 	}
 
 	return arr;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f620485d7836..2275cc144f58 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -460,6 +460,7 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 0700d6d739f7..77d30106abca 100644
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8063cb7e8387..594c058f6f0f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1001,6 +1001,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 			return;
 		}
 		break;
+	case MSR_IA32_DS_AREA:
 	case MSR_IA32_PEBS_ENABLE:
 		/* PEBS needs a quiescent period after being disabled (to write
 		 * a record).  Disabling PEBS through VMX MSR swapping doesn't
-- 
2.29.2

