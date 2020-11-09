Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FB42AAF6B
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 03:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgKICSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 21:18:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:64927 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729226AbgKICRY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 21:17:24 -0500
IronPort-SDR: i4jNVnmcJ0y9tbdPg8ci7p5Bma7USNbNUqVe6lfFGMEMQkGyj1djH3/NinUgqvoMuyaj4YKtQv
 MmhrEWudOPhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9799"; a="187684610"
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="187684610"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2020 18:17:13 -0800
IronPort-SDR: VzWfIYoM0B05j5g8mtLUdWwiX60HANJVZWj+b+NDY4FyDmFuwO42Ydff5P9QCcFcCMLmMUR/HW
 skVS/VdYdozQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,462,1596524400"; 
   d="scan'208";a="540646186"
Received: from e5-2699-v4-likexu.sh.intel.com ([10.239.48.39])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2020 18:17:09 -0800
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
Subject: [PATCH v2 06/17] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
Date:   Mon,  9 Nov 2020 10:12:43 +0800
Message-Id: <20201109021254.79755-7-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201109021254.79755-1-like.xu@linux.intel.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the
IA32_PEBS_ENABLE MSR exists and all architecturally enumerated fixed
and general purpose counters have corresponding bits in IA32_PEBS_ENABLE
that enable generation of PEBS records. The general-purpose counter bits
start at bit IA32_PEBS_ENABLE[0], and the fixed counter bits start at
bit IA32_PEBS_ENABLE[32].

When guest PEBS is enabled, the IA32_PEBS_ENABLE MSR will be
added to the perf_guest_switch_msr() and switched during the
VMX transitions just like CORE_PERF_GLOBAL_CTRL MSR.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c     | 21 +++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h  |  1 +
 arch/x86/include/asm/msr-index.h |  6 ++++++
 arch/x86/kvm/vmx/pmu_intel.c     | 28 ++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 31e6887d24f1..d824c7156d34 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3419,6 +3419,27 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 		*nr = 2;
 	}
 
+	if (cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask) {
+		arr[1].msr = MSR_IA32_PEBS_ENABLE;
+		arr[1].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
+		arr[1].guest = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+		/*
+		 * Without x86_pmu.counter_freezing support on the host,
+		 * the guest PEBS is disabled once the host PEBS is enabled
+		 * since the both enabled case may brings a unknown PMI to
+		 * confuse host and the guest PEBS overflow PMI would be missed.
+		 */
+		if (!x86_pmu.counter_freezing && arr[1].host)
+			arr[1].guest = 0;
+		arr[0].guest |= arr[1].guest;
+		*nr = 2;
+	} else if (*nr == 1) {
+		/* Remove MSR_IA32_PEBS_ENABLE from MSR switch list in KVM */
+		arr[1].msr = MSR_IA32_PEBS_ENABLE;
+		arr[1].host = arr[1].guest = 0;
+		*nr = 2;
+	}
+
 	return arr;
 }
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eb0d73a095a3..6d7e895ae535 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -450,6 +450,7 @@ struct kvm_pmu {
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
 	u64 pebs_enable;
+	u64 pebs_enable_mask;
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2859ee4f39a8..8bc6269f577d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -184,6 +184,12 @@
 #define MSR_PEBS_DATA_CFG		0x000003f2
 #define MSR_IA32_DS_AREA		0x00000600
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
+#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
+#define PERF_CAP_ARCH_REG              BIT_ULL(7)
+#define PERF_CAP_PEBS_FORMAT           0xf00
+#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
+#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
+	PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 
 #define MSR_IA32_RTIT_CTL		0x00000570
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 50047114c298..2f10587bda19 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -180,6 +180,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -221,6 +224,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PEBS_ENABLE:
+		msr_info->data = pmu->pebs_enable;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -280,6 +286,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		if (pmu->pebs_enable == data)
+			return 0;
+		if (!(data & pmu->pebs_enable_mask)) {
+			pmu->pebs_enable = data;
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -329,6 +343,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
+	pmu->pebs_enable_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -384,6 +399,19 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
+	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
+			pmu->pebs_enable_mask = ~pmu->global_ctrl;
+			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
+			for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+				pmu->fixed_ctr_ctrl_mask &=
+					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
+		} else
+			pmu->pebs_enable_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
+	} else {
+		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
+	}
+
 	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 }
 
-- 
2.21.3

