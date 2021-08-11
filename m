Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C763E8E11
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbhHKKHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:07:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:49605 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236939AbhHKKHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 06:07:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="215083929"
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="215083929"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:18 -0700
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="484785711"
Received: from chenyi-pc.sh.intel.com ([10.239.159.88])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:15 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/7] KVM: X86: Expose IA32_PKRS MSR
Date:   Wed, 11 Aug 2021 18:11:22 +0800
Message-Id: <20210811101126.8973-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210811101126.8973-1-chenyi.qiang@intel.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protection Key for Superviosr Pages (PKS) uses IA32_PKRS MSR (PKRS) at
index 0x6E1 to allow software to manage superviosr key rights, i.e. it
can enforce additional permissions checks besides normal paging
protections via a MSR update without TLB flushes when permissions
change.

For performance consideration, PKRS intercept in KVM will be disabled
when PKS is supported in guest so that PKRS can be accessed without VM
exit.

PKS introduces dedicated control fields in VMCS to switch PKRS, which
only does the retore part. In addition, every VM exit saves PKRS into
the guest-state area in VMCS, while VM enter won't save the host value
due to the expectation that the host won't change the MSR often. Update
the host's value in VMCS manually if the MSR has been changed by the
kernel since the last time the VMCS was run.

Introduce a function get_current_pkrs() in arch/x86/mm/pkeys.c exports
the per-cpu variable pkrs_cache to avoid frequent rdmsr of PKRS.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/vmx/vmcs.h |  1 +
 arch/x86/kvm/vmx/vmx.c  | 69 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h  |  2 +-
 arch/x86/kvm/x86.c      |  6 +++-
 arch/x86/kvm/x86.h      |  6 ++++
 arch/x86/mm/pkeys.c     |  6 ++++
 include/linux/pkeys.h   |  5 +++
 7 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 4b9957e2bf5b..05312af594cd 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -40,6 +40,7 @@ struct vmcs_host_state {
 #ifdef CONFIG_X86_64
 	u16           ds_sel, es_sel;
 #endif
+	u32           pkrs;
 };
 
 struct vmcs_controls_shadow {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bf911029aa35..0f3ca6a07a21 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -28,6 +28,7 @@
 #include <linux/tboot.h>
 #include <linux/trace_events.h>
 #include <linux/entry-kvm.h>
+#include <linux/pkeys.h>
 
 #include <asm/apic.h>
 #include <asm/asm.h>
@@ -170,6 +171,7 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_CORE_C3_RESIDENCY,
 	MSR_CORE_C6_RESIDENCY,
 	MSR_CORE_C7_RESIDENCY,
+	MSR_IA32_PKRS,
 };
 
 /*
@@ -1115,6 +1117,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 	unsigned long fs_base, gs_base;
 	u16 fs_sel, gs_sel;
+	u32 host_pkrs;
 	int i;
 
 	vmx->req_immediate_exit = false;
@@ -1150,6 +1153,20 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 */
 	host_state->ldt_sel = kvm_read_ldt();
 
+	/*
+	 * Update the host pkrs vmcs field before vcpu runs.
+	 * The setting of VM_EXIT_LOAD_IA32_PKRS can ensure
+	 * kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	 * guest_cpuid_has(vcpu, X86_FEATURE_PKS)
+	 */
+	if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS) {
+		host_pkrs = get_current_pkrs();
+		if (unlikely(host_pkrs != host_state->pkrs)) {
+			vmcs_write64(HOST_IA32_PKRS, host_pkrs);
+			host_state->pkrs = host_pkrs;
+		}
+	}
+
 #ifdef CONFIG_X86_64
 	savesegment(ds, host_state->ds_sel);
 	savesegment(es, host_state->es_sel);
@@ -1371,6 +1388,15 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 		vmx->emulation_required = emulation_required(vcpu);
 }
 
+static void vmx_set_pkrs(struct kvm_vcpu *vcpu, u64 pkrs)
+{
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS)) {
+		vcpu->arch.pkrs = pkrs;
+		kvm_register_mark_available(vcpu, VCPU_EXREG_PKRS);
+		vmcs_write64(GUEST_IA32_PKRS, pkrs);
+	}
+}
+
 u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
 	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
@@ -1899,6 +1925,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
+	case MSR_IA32_PKRS:
+		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
+		    (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
+			return 1;
+		msr_info->data = kvm_read_pkrs(vcpu);
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2226,7 +2259,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
-
+	case MSR_IA32_PKRS:
+		if (!kvm_pkrs_valid(data))
+			return 1;
+		if (!kvm_cpu_cap_has(X86_FEATURE_PKS) ||
+		    (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PKS)))
+			return 1;
+		vmx_set_pkrs(vcpu, data);
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
@@ -2507,7 +2548,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_IA32_PKRS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2531,7 +2573,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_IA32_PKRS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -4462,6 +4505,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (kvm_mpx_supported())
 		vmcs_write64(GUEST_BNDCFGS, 0);
 
+	/* PKRS is cleared on INIT/RESET */
+	vmx_set_pkrs(vcpu, 0);
+
 	setup_msrs(vmx);
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
@@ -5783,6 +5829,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		       vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL));
 	if (vmentry_ctl & VM_ENTRY_LOAD_BNDCFGS)
 		pr_err("BndCfgS = 0x%016llx\n", vmcs_read64(GUEST_BNDCFGS));
+	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_PKRS)
+		pr_err("PKRS = 0x%016llx\n", vmcs_read64(GUEST_IA32_PKRS));
 	pr_err("Interruptibility = %08x  ActivityState = %08x\n",
 	       vmcs_read32(GUEST_INTERRUPTIBILITY_INFO),
 	       vmcs_read32(GUEST_ACTIVITY_STATE));
@@ -5824,6 +5872,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
 	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
 		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
+	if (vmexit_ctl & VM_EXIT_LOAD_IA32_PKRS)
+		pr_err("PKRS = 0x%016llx\n", vmcs_read64(HOST_IA32_PKRS));
 
 	pr_err("*** Control State ***\n");
 	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
@@ -7207,6 +7257,19 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_PKS)) {
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);
+	} else {
+		/*
+		 * Remove VM control in case guest VM doesn't support PKS to mitigate
+		 * overhead during VM-{exit,entry}. They are present by default
+		 * if supported.
+		 */
+		vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
+		vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
+	}
 }
 
 static __init void vmx_set_cpu_caps(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 18039eb6efb0..858d9a959c72 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -336,7 +336,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	13
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	14
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4fd10604f72..16cd5f98d3f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1303,7 +1303,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
 	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
-	MSR_IA32_UMWAIT_CONTROL,
+	MSR_IA32_UMWAIT_CONTROL, MSR_IA32_PKRS,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
@@ -6219,6 +6219,10 @@ static void kvm_init_msr_list(void)
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
 			break;
+		case MSR_IA32_PKRS:
+			if (!kvm_cpu_cap_has(X86_FEATURE_PKS))
+				continue;
+			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 44ae10312740..f8aaf89e6dc5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -436,6 +436,12 @@ static inline void kvm_machine_check(void)
 #endif
 }
 
+static inline bool kvm_pkrs_valid(u64 data)
+{
+	/* bit[63,32] must be zero */
+	return !(data >> 32);
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index 201004586c2b..d1a58df2663e 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -452,4 +452,10 @@ void pks_abandon_protections(int pkey)
 }
 EXPORT_SYMBOL_GPL(pks_abandon_protections);
 
+u32 get_current_pkrs(void)
+{
+	return this_cpu_read(pkrs_cache);
+}
+EXPORT_SYMBOL_GPL(get_current_pkrs);
+
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index c06b47264c5d..5389318e3aa3 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -62,6 +62,7 @@ void pks_mk_noaccess(int pkey);
 void pks_mk_readonly(int pkey);
 void pks_mk_readwrite(int pkey);
 void pks_abandon_protections(int pkey);
+u32 get_current_pkrs(void);
 
 typedef bool (*pks_key_callback)(unsigned long address, bool write);
 
@@ -79,6 +80,10 @@ static inline void pks_mk_noaccess(int pkey) {}
 static inline void pks_mk_readonly(int pkey) {}
 static inline void pks_mk_readwrite(int pkey) {}
 static inline void pks_abandon_protections(int pkey) {}
+static inline u32 get_current_pkrs(void)
+{
+	return 0;
+}
 
 #endif /* CONFIG_ARCH_ENABLE_SUPERVISOR_PKEYS */
 
-- 
2.17.1

