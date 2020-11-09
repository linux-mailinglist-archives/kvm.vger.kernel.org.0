Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0841F2AAF65
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgKICRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:17:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:64930 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729239AbgKICRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:24 -0500
IronPort-SDR: IPK7K8iRctX+kHWgb4Iuz7Wnp0KLl53arCbwYnxMLVfXYpTCOrb7FYGMUZwtMiAS84Z6nYjN5s
 stABFcNqI+2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684614"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684614"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:17 -0800
IronPort-SDR: MI9INPfgghH52Tsb41AaWPyqiy2EFIiQNvtoq6sRGJT8PXDeSvACifAch6473+QIP2dEJ9DNpD
 3RHG7rLf+4zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646195"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:13 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/17] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to manage guest DS buffer
Date:   Mon,  9 Nov 2020 10:12:44 +0800
Message-Id: <20201109021254.79755-8-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
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
 arch/x86/events/intel/core.c    | 13 +++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c          |  6 ++++++
 4 files changed, 31 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index d824c7156d34..71b45376ee1f 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3394,6 +3394,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
 
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
@@ -3440,6 +3441,18 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 		*nr = 2;
 	}
 
+	if (arr[1].guest) {
+		arr[2].msr = MSR_IA32_DS_AREA;
+		arr[2].host = (unsigned long)ds;
+		/* KVM will update MSR_IA32_DS_AREA with the trapped guest value. */
+		arr[2].guest = 0ull;
+		*nr = 3;
+	} else if (*nr == 2) {
+		arr[2].msr = MSR_IA32_DS_AREA;
+		arr[2].host = arr[2].guest = 0;
+		*nr = 3;
+	}
+
 	return arr;
 }
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d7e895ae535..eb24c4796f8b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -449,6 +449,7 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2f10587bda19..ff5fc405703f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -183,6 +183,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
 		break;
+	case MSR_IA32_DS_AREA:
+		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -227,6 +230,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		return 0;
+	case MSR_IA32_DS_AREA:
+		msr_info->data = pmu->ds_area;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -294,6 +300,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index 83a16ae04b4e..94dbd79a8582 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -975,6 +975,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 			return;
 		}
 		break;
+	case MSR_IA32_DS_AREA:
 	case MSR_IA32_PEBS_ENABLE:
 		/* PEBS needs a quiescent period after being disabled (to write
 		 * a record).  Disabling PEBS through VMX MSR swapping doesn't
@@ -6536,12 +6537,17 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 {
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	msrs = perf_guest_get_msrs(&nr_msrs);
 
 	if (!msrs)
 		return;
 
+	if (nr_msrs > 2 && msrs[1].guest)
+		msrs[2].guest = pmu->ds_area;
+
 	for (i = 0; i < nr_msrs; i++)
 		if (msrs[i].host == msrs[i].guest)
 			clear_atomic_switch_msr(vmx, msrs[i].msr);
-- 
2.21.3

