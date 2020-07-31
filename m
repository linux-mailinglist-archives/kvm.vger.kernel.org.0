Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602E523406D
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbgGaHqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:46:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:55479 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731818AbgGaHqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:46:22 -0400
IronPort-SDR: zCmXO7SrcDZ/A8HBtht/Ko0kpWgnIeurst257pq5FgkcDA4FIZ9k/J5mhoJDVMJBuqRcfFuAMu
 CU+LZTzOuk7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149570543"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="149570543"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 00:46:21 -0700
IronPort-SDR: nvm/6hWbf3hzTHy3RDCYkxR7s2fPcmK0SxEaps6zwWCxmHtVO2gna1x4+QsxiMZ/SIrpNAqmou
 SqIN+J7B4V3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="323160611"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2020 00:46:18 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH 5/6] KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
Date:   Fri, 31 Jul 2020 15:44:01 +0800
Message-Id: <20200731074402.8879-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200731074402.8879-1-like.xu@linux.intel.com>
References: <20200731074402.8879-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When set bit 21 in vmentry_ctrl, VM entry will write the value from the
"Guest IA32_LBR_CTL" guest state field to IA32_LBR_CTL. When set bit 26
in vmexit_ctrl, VM exit will clear IA32_LBR_CTL after the value has been
saved to the "Guest IA32_LBR_CTL" guest state field.

To enable guest Arch LBR, KVM should set both the "Load Guest IA32_LBR_CTL"
entry control and the "Clear IA32_LBR_CTL" exit control. If these two
conditions cannot be met, the vmx_get_perf_capabilities() will clear
the LBR_FMT bits.

If Arch LBR is exposed on KVM, the guest could set X86_FEATURE_ARCH_LBR
to enable guest LBR, which is equivalent to the legacy LBR_FMT setting.
The Arch LBR feature could bypass the host/guest x86_model check and
the records msrs can still be pass-through to guest as usual and work
like the legacy LBR.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/vmx.h      |  2 ++
 arch/x86/kvm/vmx/capabilities.h |  9 ++++++++-
 arch/x86/kvm/vmx/pmu_intel.c    | 17 ++++++++++++++---
 arch/x86/kvm/vmx/vmx.c          |  6 ++++--
 4 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 27f53c81a17f..2e4b89a55c53 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -94,6 +94,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_CLEAR_IA32_LBR_CTL		0x04000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -107,6 +108,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_IA32_LBR_CTL		0x00200000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f5f0586f4cd7..d1f6bba243c4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -378,6 +378,13 @@ static inline bool cpu_has_vmx_lbr(void)
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_DEBUG_CONTROLS);
 }
 
+static inline bool cpu_has_vmx_arch_lbr(void)
+{
+	return boot_cpu_has(X86_FEATURE_ARCH_LBR) &&
+		(vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_IA32_LBR_CTL) &&
+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL);
+}
+
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	/*
@@ -389,7 +396,7 @@ static inline u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
 
-	if (cpu_has_vmx_lbr())
+	if (cpu_has_vmx_lbr() || cpu_has_vmx_arch_lbr())
 		perf_cap |= perf_cap & PMU_CAP_LBR_FMT;
 
 	return perf_cap;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 289c267732bd..daf838dc1689 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -177,12 +177,17 @@ bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
 	if (pmu->version < 2)
 		return false;
 
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) !=
+	    guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return false;
+
 	/*
 	 * As a first step, a guest could only enable LBR feature if its
 	 * cpu model is the same as the host because the LBR registers
 	 * would be pass-through to the guest and they're model specific.
 	 */
-	if (boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR) &&
+	    boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
 		return false;
 
 	return !x86_perf_get_lbr(lbr);
@@ -210,8 +215,11 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	if (!intel_pmu_lbr_is_enabled(vcpu))
 		return ret;
 
-	ret =  (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
-		(index >= records->from && index < records->from + records->nr) ||
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS);
+
+	if (!ret)
+		ret = (index >= records->from && index < records->from + records->nr) ||
 		(index >= records->to && index < records->to + records->nr);
 
 	if (!ret && records->info)
@@ -693,6 +701,9 @@ static void vmx_update_intercept_for_lbr_msrs(struct kvm_vcpu *vcpu, bool set)
 				lbr->info + i, MSR_TYPE_RW, set);
 	}
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
+		return;
+
 	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_SELECT, MSR_TYPE_RW, set);
 	vmx_set_intercept_for_msr(msr_bitmap, MSR_LBR_TOS, MSR_TYPE_RW, set);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9f42553b1e11..3843aebf4efb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2550,7 +2550,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_CLEAR_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2574,7 +2575,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
-- 
2.21.3

