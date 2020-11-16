Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8712B4F5B
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388391AbgKPS2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:48463 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388349AbgKPS2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:25 -0500
IronPort-SDR: J/ADQz6Tv5R2hM6HKyt5mYSnvx6Snb57d2g1e9Zzhfhc2VbLVK4yWS0WJn3V5TFYKUR82PD4KP
 ImqtixvwzLiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819217"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819217"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:23 -0800
IronPort-SDR: P/PomvdexH5Gh8ak4PBtyPaAIhINRJSP3oqC8LOkyBaiPGctFOlWJEztvzcq6kVo0WvYKBVEdo
 U4ysYwp4ouIQ==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528395"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:22 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: [RFC PATCH 64/67] KVM: TDX: Add "basic" support for building and running Trust Domains
Date:   Mon, 16 Nov 2020 10:26:49 -0800
Message-Id: <b7004ea31380e113f38965f21f86a10cb7be1dc9.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add what is effectively a TDX-specific ioctl for initializing the guest
Trust Domain.  Implement the functionality as a subcommand of
KVM_MEMORY_ENCRYPT_OP, analogous to how the ioctl is used by SVM to
manage SEV guests.

For easy compatibility with future versions of TDX-SEAM, add a
KVM-defined struct, tdx_capabilities, to track requirements/capabilities
for the overall system, and define a global instance to serve as the
canonical reference.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h       |   51 +
 arch/x86/kvm/trace.h                  |   57 +
 arch/x86/kvm/vmx/common.h             |    1 +
 arch/x86/kvm/vmx/main.c               |  384 ++++-
 arch/x86/kvm/vmx/posted_intr.c        |    6 +
 arch/x86/kvm/vmx/tdx.c                | 1850 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |   78 ++
 arch/x86/kvm/vmx/tdx_ops.h            |   13 +
 arch/x86/kvm/vmx/tdx_stubs.c          |   45 +
 arch/x86/kvm/vmx/vmenter.S            |  140 ++
 arch/x86/kvm/x86.c                    |    5 +-
 tools/arch/x86/include/uapi/asm/kvm.h |   51 +
 12 files changed, 2666 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx_stubs.c

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 29cdf262e516..03f7bcc3fb85 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -490,4 +490,55 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_SEV_ES_VM	1
 #define KVM_X86_TDX_VM		2
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	__u32 id;
+	__u32 metadata;
+	__u64 data;
+};
+
+struct kvm_tdx_cpuid_config {
+	__u32 leaf;
+	__u32 sub_leaf;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
+
+	__u32 nr_cpuid_configs;
+	struct kvm_tdx_cpuid_config cpuid_configs[0];
+};
+
+struct kvm_tdx_init_vm {
+	__u32 max_vcpus;
+	__u32 reserved;
+	__u64 attributes;
+	__u64 cpuid;
+};
+
+#define KVM_TDX_MEASURE_MEMORY_REGION	(1UL << 0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index aef960f90f26..e2d9e5caecc8 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -623,6 +623,63 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
 		  __entry->exit_int_info, __entry->exit_int_info_err)
 );
 
+/*
+ * Tracepoint for TDVMCALL from a TDX guest
+ */
+TRACE_EVENT(kvm_tdvmcall,
+	TP_PROTO(struct kvm_vcpu *vcpu, __u32 exit_reason,
+		 __u64 p1, __u64 p2, __u64 p3, __u64 p4),
+	TP_ARGS(vcpu, exit_reason, p1, p2, p3, p4),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		rip		)
+		__field(	__u32,		exit_reason	)
+		__field(	__u64,		p1		)
+		__field(	__u64,		p2		)
+		__field(	__u64,		p3		)
+		__field(	__u64,		p4		)
+	),
+
+	TP_fast_assign(
+		__entry->rip			= kvm_rip_read(vcpu);
+		__entry->exit_reason		= exit_reason;
+		__entry->p1			= p1;
+		__entry->p2			= p2;
+		__entry->p3			= p3;
+		__entry->p4			= p4;
+	),
+
+	TP_printk("rip: %llx reason: %s p1: %llx p2: %llx p3: %llx p4: %llx",
+		  __entry->rip,
+		  __print_symbolic(__entry->exit_reason, VMX_EXIT_REASONS),
+		  __entry->p1, __entry->p2, __entry->p3, __entry->p4)
+);
+
+/*
+ * Tracepoint for SEPT related SEAMCALLs.
+ */
+TRACE_EVENT(kvm_sept_seamcall,
+	TP_PROTO(__u64 op, __u64 gpa, __u64 hpa, int level),
+	TP_ARGS(op, gpa, hpa, level),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		op	)
+		__field(	__u64,		gpa	)
+		__field(	__u64,		hpa	)
+		__field(	int,		level	)
+	),
+
+	TP_fast_assign(
+		__entry->op			= op;
+		__entry->gpa			= gpa;
+		__entry->hpa			= hpa;
+		__entry->level			= level;
+	),
+
+	TP_printk("op: %llu gpa: 0x%llx hpa: 0x%llx level: %u",
+		  __entry->op, __entry->gpa, __entry->hpa, __entry->level)
+);
+
 /*
  * Tracepoint for nested #vmexit because of interrupt pending
  */
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 8519423bfd88..a48a683af2c3 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -9,6 +9,7 @@
 #include <asm/vmx.h>
 
 #include "mmu.h"
+#include "tdx.h"
 #include "vmcs.h"
 #include "vmx.h"
 #include "x86.h"
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 53e1ea8df861..6437b8b23199 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -1,8 +1,21 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/moduleparam.h>
 
+#ifdef CONFIG_KVM_INTEL_TDX
+static bool __read_mostly enable_tdx = 1;
+module_param_named(tdx, enable_tdx, bool, 0444);
+#else
+#define enable_tdx 0
+#endif
+
 #include "vmx.c"
 
+#ifdef CONFIG_KVM_INTEL_TDX
+#include "tdx.c"
+#else
+#include "tdx_stubs.c"
+#endif
+
 static struct kvm_x86_ops vt_x86_ops __initdata;
 
 static int __init vt_cpu_has_kvm_support(void)
@@ -23,6 +36,16 @@ static int __init vt_check_processor_compatibility(void)
 	if (ret)
 		return ret;
 
+	if (enable_tdx) {
+		/*
+		 * Reject the entire module load if the per-cpu check fails, it
+		 * likely indicates a hardware or system configuration issue.
+		 */
+		ret = tdx_check_processor_compatibility();
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -31,13 +54,16 @@ static __init void vt_set_ept_masks(void)
 	const u64 u_mask = VMX_EPT_READABLE_MASK;
 	const u64 a_mask = enable_ept_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
 	const u64 d_mask = enable_ept_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
-	const u64 p_mask = cpu_has_vmx_ept_execute_only() ? 0ull :
-							    VMX_EPT_READABLE_MASK;
 	const u64 x_mask = VMX_EPT_EXECUTABLE_MASK;
 	const u64 nx_mask = 0ull;
+	const u64 init_value = enable_tdx ? VMX_EPT_SUPPRESS_VE_BIT : 0ull;
+	const u64 p_mask = (cpu_has_vmx_ept_execute_only() ?
+				0ull : VMX_EPT_READABLE_MASK) | init_value;
 
 	kvm_mmu_set_mask_ptes(u_mask, a_mask, d_mask, nx_mask, x_mask, p_mask,
 			      VMX_EPT_RWX_MASK, 0ull);
+
+	kvm_mmu_set_spte_init_value(init_value);
 }
 
 static __init int vt_hardware_setup(void)
@@ -48,6 +74,11 @@ static __init int vt_hardware_setup(void)
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_KVM_INTEL_TDX
+	if (enable_tdx && tdx_hardware_setup(&vt_x86_ops))
+		enable_tdx = false;
+#endif
+
 	if (enable_ept)
 		vt_set_ept_masks();
 
@@ -56,11 +87,23 @@ static __init int vt_hardware_setup(void)
 
 static int vt_hardware_enable(void)
 {
-	return hardware_enable();
+	int ret;
+
+	ret = hardware_enable();
+	if (ret)
+		return ret;
+
+	if (enable_tdx)
+		tdx_hardware_enable();
+	return 0;
 }
 
 static void vt_hardware_disable(void)
 {
+	/* Note, TDX *and* VMX need to be disabled if TDX is enabled. */
+	if (enable_tdx)
+		tdx_hardware_disable();
+
 	hardware_disable();
 }
 
@@ -71,62 +114,92 @@ static bool vt_cpu_has_accelerated_tpr(void)
 
 static bool vt_is_vm_type_supported(unsigned long type)
 {
-	return type == KVM_X86_LEGACY_VM;
+	return type == KVM_X86_LEGACY_VM ||
+	       (type == KVM_X86_TDX_VM && enable_tdx);
 }
 
 static int vt_vm_init(struct kvm *kvm)
 {
+	if (kvm->arch.vm_type == KVM_X86_TDX_VM)
+		return tdx_vm_init(kvm);
+
 	return vmx_vm_init(kvm);
 }
 
 static void vt_vm_teardown(struct kvm *kvm)
 {
-
+	if (is_td(kvm))
+		return tdx_vm_teardown(kvm);
 }
 
 static void vt_vm_destroy(struct kvm *kvm)
 {
-
+	if (is_td(kvm))
+		return tdx_vm_destroy(kvm);
 }
 
 static int vt_vcpu_create(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_create(vcpu);
+
 	return vmx_create_vcpu(vcpu);
 }
 
 static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_run(vcpu);
+
 	return vmx_vcpu_run(vcpu);
 }
 
 static void vt_vcpu_free(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_free(vcpu);
+
 	return vmx_free_vcpu(vcpu);
 }
 
 static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_reset(vcpu, init_event);
+
 	return vmx_vcpu_reset(vcpu, init_event);
 }
 
 static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_load(vcpu, cpu);
+
 	return vmx_vcpu_load(vcpu, cpu);
 }
 
 static void vt_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_put(vcpu);
+
 	return vmx_vcpu_put(vcpu);
 }
 
 static int vt_handle_exit(struct kvm_vcpu *vcpu,
 			     enum exit_fastpath_completion fastpath)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_handle_exit(vcpu, fastpath);
+
 	return vmx_handle_exit(vcpu, fastpath);
 }
 
 static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_handle_exit_irqoff(vcpu);
+
 	vmx_handle_exit_irqoff(vcpu);
 }
 
@@ -142,21 +215,33 @@ static void vt_update_emulated_instruction(struct kvm_vcpu *vcpu)
 
 static int vt_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_set_msr(vcpu, msr_info);
+
 	return vmx_set_msr(vcpu, msr_info);
 }
 
 static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
+	if (is_td_vcpu(vcpu))
+		return false;
+
 	return vmx_smi_allowed(vcpu, for_injection);
 }
 
 static int vt_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
 	return vmx_pre_enter_smm(vcpu, smstate);
 }
 
 static int vt_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return 0;
+
 	return vmx_pre_leave_smm(vcpu, smstate);
 }
 
@@ -168,6 +253,9 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
 static bool vt_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn,
 				       int insn_len)
 {
+	if (is_td_vcpu(vcpu))
+		return false;
+
 	return vmx_can_emulate_instruction(vcpu, insn, insn_len);
 }
 
@@ -176,11 +264,17 @@ static int vt_check_intercept(struct kvm_vcpu *vcpu,
 				 enum x86_intercept_stage stage,
 				 struct x86_exception *exception)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return X86EMUL_UNHANDLEABLE;
+
 	return vmx_check_intercept(vcpu, info, stage, exception);
 }
 
 static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return true;
+
 	return vmx_apic_init_signal_blocked(vcpu);
 }
 
@@ -189,13 +283,43 @@ static void vt_migrate_timers(struct kvm_vcpu *vcpu)
 	vmx_migrate_timers(vcpu);
 }
 
+static int vt_mem_enc_op_dev(void __user *argp)
+{
+	if (!enable_tdx)
+		return -EINVAL;
+
+	return tdx_dev_ioctl(argp);
+}
+
+static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
+{
+	if (!is_td(kvm))
+		return -ENOTTY;
+
+	return tdx_vm_ioctl(kvm, argp);
+}
+
+static int vt_mem_enc_op_vcpu(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	if (!is_td_vcpu(vcpu))
+		return -EINVAL;
+
+	return tdx_vcpu_ioctl(vcpu, argp);
+}
+
 static void vt_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_set_virtual_apic_mode(vcpu);
+
 	return vmx_set_virtual_apic_mode(vcpu);
 }
 
 static void vt_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_apicv_post_state_restore(vcpu);
+
 	return vmx_apicv_post_state_restore(vcpu);
 }
 
@@ -209,36 +333,57 @@ static bool vt_check_apicv_inhibit_reasons(ulong bit)
 
 static void vt_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
 {
+	if (is_td_vcpu(vcpu))
+		return;
+
 	return vmx_hwapic_irr_update(vcpu, max_irr);
 }
 
 static void vt_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
+	if (is_td_vcpu(vcpu))
+		return;
+
 	return vmx_hwapic_isr_update(vcpu, max_isr);
 }
 
 static bool vt_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return false;
+
 	return vmx_guest_apic_has_interrupt(vcpu);
 }
 
 static int vt_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return -1;
+
 	return vmx_sync_pir_to_irr(vcpu);
 }
 
 static int vt_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_deliver_posted_interrupt(vcpu, vector);
+
 	return vmx_deliver_posted_interrupt(vcpu, vector);
 }
 
 static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return;
+
 	return vmx_vcpu_after_set_cpuid(vcpu);
 }
 
 static bool vt_has_emulated_msr(struct kvm *kvm, u32 index)
 {
+	if (kvm && is_td(kvm))
+		return tdx_is_emulated_msr(index, true);
+
 	return vmx_has_emulated_msr(index);
 }
 
@@ -249,11 +394,23 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
 
 static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * All host state is saved/restored across SEAMCALL/SEAMRET, and the
+	 * guest state of a TD is obviously off limits.  Deferring MSRs and DRs
+	 * is pointless because TDX-SEAM needs to load *something* so as not to
+	 * expose guest state.
+	 */
+	if (is_td_vcpu(vcpu))
+		return;
+
 	vmx_prepare_switch_to_guest(vcpu);
 }
 
 static void vt_update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_update_exception_bitmap(vcpu);
+
 	update_exception_bitmap(vcpu);
 }
 
@@ -264,54 +421,84 @@ static int vt_get_msr_feature(struct kvm_msr_entry *msr)
 
 static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_get_msr(vcpu, msr_info);
+
 	return vmx_get_msr(vcpu, msr_info);
 }
 
 static u64 vt_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_get_segment_base(vcpu, seg);
+
 	return vmx_get_segment_base(vcpu, seg);
 }
 
 static void vt_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
 			      int seg)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_get_segment(vcpu, var, seg);
+
 	vmx_get_segment(vcpu, var, seg);
 }
 
 static void vt_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
 			      int seg)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_set_segment(vcpu, var, seg);
 }
 
 static int vt_get_cpl(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_get_cpl(vcpu);
+
 	return vmx_get_cpl(vcpu);
 }
 
 static void vt_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu) && !is_debug_td(vcpu), vcpu->kvm))
+		return;
+
 	vmx_get_cs_db_l_bits(vcpu, db, l);
 }
 
 static void vt_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_set_cr0(vcpu, cr0);
 }
 
 static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 			    int pgd_level)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_load_mmu_pgd(vcpu, pgd, pgd_level);
+
 	vmx_load_mmu_pgd(vcpu, pgd, pgd_level);
 }
 
 static int vt_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 1;
+
 	return vmx_set_cr4(vcpu, cr4);
 }
 
 static int vt_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return -EIO;
+
 	return vmx_set_efer(vcpu, efer);
 }
 
@@ -323,6 +510,9 @@ static void vt_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_set_idt(vcpu, dt);
 }
 
@@ -334,16 +524,30 @@ static void vt_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_set_gdt(vcpu, dt);
 }
 
 static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_set_dr7(vcpu, val);
+
 	vmx_set_dr7(vcpu, val);
 }
 
 static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * MOV-DR exiting is always cleared for TD guest, even in debug mode.
+	 * Thus KVM_DEBUGREG_WONT_EXIT can never be set and it should never
+	 * reach here for TD vcpu.
+	 */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_sync_dirty_debug_regs(vcpu);
 }
 
@@ -355,31 +559,41 @@ static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 
 	switch (reg) {
 	case VCPU_REGS_RSP:
-		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
+		vcpu->arch.regs[VCPU_REGS_RSP] = vmreadl(vcpu, GUEST_RSP);
 		break;
 	case VCPU_REGS_RIP:
-		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
+#ifdef CONFIG_KVM_INTEL_TDX
+		/*
+		 * RIP can be read by tracepoints, stuff a bogus value and
+		 * avoid a WARN/error.
+		 */
+		if (unlikely(is_td_vcpu(vcpu) && !is_debug_td(vcpu))) {
+			vcpu->arch.regs[VCPU_REGS_RIP] = 0xdeadul << 48;
+			break;
+		}
+#endif
+		vcpu->arch.regs[VCPU_REGS_RIP] = vmreadl(vcpu, GUEST_RIP);
 		break;
 	case VCPU_EXREG_PDPTR:
-		if (enable_ept)
+		if (enable_ept && !KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
 			ept_save_pdptrs(vcpu);
 		break;
 	case VCPU_EXREG_CR0:
 		guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
 
 		vcpu->arch.cr0 &= ~guest_owned_bits;
-		vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & guest_owned_bits;
+		vcpu->arch.cr0 |= vmreadl(vcpu, GUEST_CR0) & guest_owned_bits;
 		break;
 	case VCPU_EXREG_CR3:
 		if (is_unrestricted_guest(vcpu) ||
 		    (enable_ept && is_paging(vcpu)))
-			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
+			vcpu->arch.cr3 = vmreadl(vcpu, GUEST_CR3);
 		break;
 	case VCPU_EXREG_CR4:
 		guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
 
 		vcpu->arch.cr4 &= ~guest_owned_bits;
-		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
+		vcpu->arch.cr4 |= vmreadl(vcpu, GUEST_CR4) & guest_owned_bits;
 		break;
 	default:
 		KVM_BUG_ON(1, vcpu->kvm);
@@ -389,171 +603,284 @@ static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 
 static unsigned long vt_get_rflags(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_get_rflags(vcpu);
+
 	return vmx_get_rflags(vcpu);
 }
 
 static void vt_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_set_rflags(vcpu, rflags);
+
 	vmx_set_rflags(vcpu, rflags);
 }
 
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_flush_tlb(vcpu);
+
 	vmx_flush_tlb_all(vcpu);
 }
 
 static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_flush_tlb(vcpu);
+
 	vmx_flush_tlb_current(vcpu);
 }
 
 static void vt_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_flush_tlb_gva(vcpu, addr);
 }
 
 static void vt_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return;
+
 	vmx_flush_tlb_guest(vcpu);
 }
 
 static void vt_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_set_interrupt_shadow(vcpu, mask);
 }
 
 static u32 vt_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
-	return vmx_get_interrupt_shadow(vcpu);
+	return __vmx_get_interrupt_shadow(vcpu);
 }
 
 static void vt_patch_hypercall(struct kvm_vcpu *vcpu,
 				  unsigned char *hypercall)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_patch_hypercall(vcpu, hypercall);
 }
 
 static void vt_inject_irq(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_inject_irq(vcpu);
 }
 
 static void vt_inject_nmi(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_inject_nmi(vcpu);
+
 	vmx_inject_nmi(vcpu);
 }
 
 static void vt_queue_exception(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu) && !is_debug_td(vcpu), vcpu->kvm))
+		return;
+
 	vmx_queue_exception(vcpu);
 }
 
 static void vt_cancel_injection(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return;
+
 	vmx_cancel_injection(vcpu);
 }
 
 static int vt_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
+	if (is_td_vcpu(vcpu))
+		return true;
+
 	return vmx_interrupt_allowed(vcpu, for_injection);
 }
 
 static int vt_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
+	/*
+	 * TDX-SEAM manages NMI windows and NMI reinjection, and hides NMI
+	 * blocking, all KVM can do is throw an NMI over the wall.
+	 */
+	if (is_td_vcpu(vcpu))
+		return true;
+
 	return vmx_nmi_allowed(vcpu, for_injection);
 }
 
 static bool vt_get_nmi_mask(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Assume NMIs are always unmasked.  KVM could query PEND_NMI and treat
+	 * NMIs as masked if a previous NMI is still pending, but SEAMCALLs are
+	 * expensive and the end result is unchanged as the only relevant usage
+	 * of get_nmi_mask() is to limit the number of pending NMIs, i.e. it
+	 * only changes whether KVM or TDX-SEAM drops an NMI.
+	 */
+	if (is_td_vcpu(vcpu))
+		return false;
+
 	return vmx_get_nmi_mask(vcpu);
 }
 
 static void vt_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 {
+	if (is_td_vcpu(vcpu))
+		return;
+
 	vmx_set_nmi_mask(vcpu, masked);
 }
 
 static void vt_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
+	/* TDX-SEAM handles NMI windows, KVM always reports NMIs as unblocked. */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	enable_nmi_window(vcpu);
 }
 
 static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	enable_irq_window(vcpu);
 }
 
 static void vt_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	update_cr8_intercept(vcpu, tpr, irr);
 }
 
 static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 {
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return;
+
 	vmx_set_apic_access_page_addr(vcpu);
 }
 
 static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return;
+
 	vmx_refresh_apicv_exec_ctrl(vcpu);
 }
 
 static void vt_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 {
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return;
+
 	vmx_load_eoi_exitmap(vcpu, eoi_exit_bitmap);
 }
 
 static int vt_set_tss_addr(struct kvm *kvm, unsigned int addr)
 {
+	/* TODO: Reject this and update Qemu, or eat it? */
+	if (is_td(kvm))
+		return 0;
+
 	return vmx_set_tss_addr(kvm, addr);
 }
 
 static int vt_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 {
+	/* TODO: Reject this and update Qemu, or eat it? */
+	if (is_td(kvm))
+		return 0;
+
 	return vmx_set_identity_map_addr(kvm, ident_addr);
 }
 
 static u64 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
+	if (is_td_vcpu(vcpu)) {
+		if (is_mmio)
+			return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+	}
+
 	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
 }
 
 static void vt_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
 			     u32 *intr_info, u32 *error_code)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_get_exit_info(vcpu, info1, info2, intr_info,
+					 error_code);
 
 	return vmx_get_exit_info(vcpu, info1, info2, intr_info, error_code);
 }
 
 static u64 vt_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
 	return vmx_write_l1_tsc_offset(vcpu, offset);
 }
 
 static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return __kvm_request_immediate_exit(vcpu);
+
 	vmx_request_immediate_exit(vcpu);
 }
 
 static void vt_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
+	if (is_td_vcpu(vcpu))
+		return;
+
 	vmx_sched_in(vcpu, cpu);
 }
 
 static void vt_slot_enable_log_dirty(struct kvm *kvm,
 					struct kvm_memory_slot *slot)
 {
+	if (is_td(kvm))
+		return;
+
 	vmx_slot_enable_log_dirty(kvm, slot);
 }
 
 static void vt_slot_disable_log_dirty(struct kvm *kvm,
 					 struct kvm_memory_slot *slot)
 {
+	if (is_td(kvm))
+		return;
+
 	vmx_slot_disable_log_dirty(kvm, slot);
 }
 
 static void vt_flush_log_dirty(struct kvm *kvm)
 {
+	if (is_td(kvm))
+		return;
+
 	vmx_flush_log_dirty(kvm);
 }
 
@@ -561,6 +888,9 @@ static void vt_enable_log_dirty_pt_masked(struct kvm *kvm,
 					     struct kvm_memory_slot *memslot,
 					     gfn_t offset, unsigned long mask)
 {
+	if (is_td(kvm))
+		return;
+
 	vmx_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
 }
 
@@ -569,12 +899,16 @@ static int vt_pre_block(struct kvm_vcpu *vcpu)
 	if (pi_pre_block(vcpu))
 		return 1;
 
+	if (is_td_vcpu(vcpu))
+		return 0;
+
 	return vmx_pre_block(vcpu);
 }
 
 static void vt_post_block(struct kvm_vcpu *vcpu)
 {
-	vmx_post_block(vcpu);
+	if (!is_td_vcpu(vcpu))
+		vmx_post_block(vcpu);
 
 	pi_post_block(vcpu);
 }
@@ -584,17 +918,26 @@ static void vt_post_block(struct kvm_vcpu *vcpu)
 static int vt_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			      bool *expired)
 {
+	if (is_td_vcpu(vcpu))
+		return -EINVAL;
+
 	return vmx_set_hv_timer(vcpu, guest_deadline_tsc, expired);
 }
 
 static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_cancel_hv_timer(vcpu);
 }
 #endif
 
 static void vt_setup_mce(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return;
+
 	vmx_setup_mce(vcpu);
 }
 
@@ -729,6 +1072,10 @@ static struct kvm_x86_ops vt_x86_ops __initdata = {
 	.migrate_timers = vt_migrate_timers,
 
 	.msr_filter_changed = vt_msr_filter_changed,
+
+	.mem_enc_op_dev = vt_mem_enc_op_dev,
+	.mem_enc_op = vt_mem_enc_op,
+	.mem_enc_op_vcpu = vt_mem_enc_op_vcpu,
 };
 
 static struct kvm_x86_init_ops vt_init_ops __initdata = {
@@ -745,6 +1092,9 @@ static int __init vt_init(void)
 	unsigned int vcpu_size = 0, vcpu_align = 0;
 	int r;
 
+	/* tdx_pre_kvm_init must be called before vmx_pre_kvm_init(). */
+	tdx_pre_kvm_init(&vcpu_size, &vcpu_align, &vt_x86_ops.vm_size);
+
 	vmx_pre_kvm_init(&vcpu_size, &vcpu_align, &vt_x86_ops);
 
 	r = kvm_init(&vt_init_ops, vcpu_size, vcpu_align, THIS_MODULE);
@@ -755,8 +1105,14 @@ static int __init vt_init(void)
 	if (r)
 		goto err_kvm_exit;
 
+	r = tdx_init();
+	if (r)
+		goto err_vmx_exit;
+
 	return 0;
 
+err_vmx_exit:
+	vmx_exit();
 err_kvm_exit:
 	kvm_exit();
 err_vmx_post_exit:
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index f02962dcc72c..86c3ae5ee27e 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -6,6 +6,7 @@
 
 #include "lapic.h"
 #include "posted_intr.h"
+#include "tdx.h"
 #include "trace.h"
 #include "vmx.h"
 
@@ -18,6 +19,11 @@ static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_KVM_INTEL_TDX
+	if (is_td_vcpu(vcpu))
+		return &(to_tdx(vcpu)->pi_desc);
+#endif
+
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..adcb866861b7
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,1850 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+#include <linux/kvm_host.h>
+#include <linux/jump_label.h>
+#include <linux/trace_events.h>
+#include <linux/pagemap.h>
+
+#include <asm/kvm_boot.h>
+#include <asm/virtext.h>
+
+#include "common.h"
+#include "cpuid.h"
+#include "lapic.h"
+#include "tdx.h"
+#include "tdx_errno.h"
+#include "tdx_ops.h"
+
+#include <trace/events/kvm.h>
+#include "trace.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) "tdx: " fmt
+
+/* Capabilities of KVM + TDX-SEAM. */
+struct tdx_capabilities tdx_caps;
+
+static DEFINE_MUTEX(tdwbcache_lock);
+static DEFINE_MUTEX(tdconfigkey_lock);
+
+/*
+ * A per-CPU list of TD vCPUs associated with a given CPU.  Used when a CPU
+ * is brought down to invoke TDFLUSHVP on the approapriate TD vCPUS.
+ */
+static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
+
+static __always_inline unsigned long tdexit_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rcx_read(vcpu);
+}
+static __always_inline unsigned long tdexit_ext_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rdx_read(vcpu);
+}
+static __always_inline unsigned long tdexit_gpa(struct kvm_vcpu *vcpu)
+{
+	return kvm_r8_read(vcpu);
+}
+static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
+{
+	return kvm_r9_read(vcpu);
+}
+
+#define BUILD_TDVMCALL_ACCESSORS(param, gpr)				    \
+static __always_inline							    \
+unsigned long tdvmcall_##param##_read(struct kvm_vcpu *vcpu)		    \
+{									    \
+	return kvm_##gpr##_read(vcpu);					    \
+}									    \
+static __always_inline void tdvmcall_##param##_write(struct kvm_vcpu *vcpu, \
+						     unsigned long val)	    \
+{									    \
+	kvm_##gpr##_write(vcpu, val);					    \
+}
+BUILD_TDVMCALL_ACCESSORS(p1, r12);
+BUILD_TDVMCALL_ACCESSORS(p2, r13);
+BUILD_TDVMCALL_ACCESSORS(p3, r14);
+BUILD_TDVMCALL_ACCESSORS(p4, r15);
+
+static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
+{
+	return kvm_r10_read(vcpu);
+}
+static __always_inline unsigned long tdvmcall_exit_reason(struct kvm_vcpu *vcpu)
+{
+	return kvm_r11_read(vcpu);
+}
+static __always_inline void tdvmcall_set_return_code(struct kvm_vcpu *vcpu,
+						     long val)
+{
+	kvm_r10_write(vcpu, val);
+}
+static __always_inline void tdvmcall_set_return_val(struct kvm_vcpu *vcpu,
+						    unsigned long val)
+{
+	kvm_r11_write(vcpu, val);
+}
+
+static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
+{
+	return tdx->tdvpr.added;
+}
+
+static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->tdr.added;
+}
+
+static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->hkid >= 0;
+}
+
+static inline bool is_td_initialized(struct kvm *kvm)
+{
+	return !!kvm->max_vcpus;
+}
+
+static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->finalized;
+}
+
+static void tdx_clear_page(unsigned long page)
+{
+	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
+	unsigned long i;
+
+	/* Zeroing the page is only necessary for systems with MKTME-i. */
+	if (!static_cpu_has(X86_FEATURE_MOVDIR64B))
+		return;
+
+	for (i = 0; i < 4096; i += 64)
+		/* MOVDIR64B [rdx], es:rdi */
+		asm (".byte 0x66, 0x0f, 0x38, 0xf8, 0x3a"
+		     : : "d" (zero_page), "D" (page + i) : "memory");
+}
+
+static int __tdx_reclaim_page(unsigned long va, hpa_t pa, bool do_wb)
+{
+	struct tdx_ex_ret ex_ret;
+	u64 err;
+
+	err = tdreclaimpage(pa, &ex_ret);
+	if (TDX_ERR(err, TDRECLAIMPAGE))
+		return -EIO;
+
+	if (do_wb) {
+		err = tdwbinvdpage(pa);
+		if (TDX_ERR(err, TDWBINVDPAGE))
+			return -EIO;
+	}
+
+	tdx_clear_page(va);
+	return 0;
+}
+
+static int tdx_reclaim_page(unsigned long va, hpa_t pa)
+{
+	return __tdx_reclaim_page(va, pa, false);
+}
+
+static int tdx_alloc_td_page(struct tdx_td_page *page)
+{
+	page->va = __get_free_page(GFP_KERNEL_ACCOUNT);
+	if (!page->va)
+		return -ENOMEM;
+
+	page->pa = __pa(page->va);
+	return 0;
+}
+
+static void tdx_add_td_page(struct tdx_td_page *page)
+{
+	WARN_ON_ONCE(page->added);
+	page->added = true;
+}
+
+static void tdx_reclaim_td_page(struct tdx_td_page *page)
+{
+	if (page->added) {
+		if (tdx_reclaim_page(page->va, page->pa))
+			return;
+
+		page->added = false;
+	}
+	free_page(page->va);
+}
+
+static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
+{
+	list_del(&to_tdx(vcpu)->cpu_list);
+
+	/*
+	 * Ensure tdx->cpu_list is updated is before setting vcpu->cpu to -1,
+	 * otherwise, a different CPU can see vcpu->cpu = -1 and add the vCPU
+	 * to its list before its deleted from this CPUs list.
+	 */
+	smp_wmb();
+
+	vcpu->cpu = -1;
+}
+
+static void tdx_flush_vp(void *arg)
+{
+	struct kvm_vcpu *vcpu = arg;
+	u64 err;
+
+	/* Task migration can race with CPU offlining. */
+	if (vcpu->cpu != raw_smp_processor_id())
+		return;
+
+	err = tdflushvp(to_tdx(vcpu)->tdvpr.pa);
+	if (unlikely(err && err != TDX_VCPU_NOT_ASSOCIATED))
+		TDX_ERR(err, TDFLUSHVP);
+
+	tdx_disassociate_vp(vcpu);
+}
+
+static void tdx_flush_vp_on_cpu(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->cpu == -1)
+		return;
+
+	/*
+	 * No need to do TDFLUSHVP if the vCPU hasn't been initialized.  The
+	 * list tracking still needs to be updated so that it's correct if/when
+	 * the vCPU does get initialized.
+	 */
+	if (is_td_vcpu_created(to_tdx(vcpu)))
+		smp_call_function_single(vcpu->cpu, tdx_flush_vp, vcpu, 1);
+	else
+		tdx_disassociate_vp(vcpu);
+}
+
+static void tdx_do_tdwbcache(void *data)
+{
+	u64 err = 0;
+
+	do {
+		err = tdwbcache(!!err);
+	} while (err == TDX_INTERRUPTED_RESUMABLE);
+
+	if (err && cmpxchg64((u64 *)data, 0, err) == 0)
+		TDX_ERR(err, TDWBCACHE);
+}
+
+static void tdx_vm_teardown(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_vcpu *vcpu;
+	u64 err;
+	int i;
+
+	if (!is_hkid_assigned(kvm_tdx))
+		return;
+
+	if (!is_td_created(kvm_tdx))
+		goto free_hkid;
+
+	err = tdreclaimhkids(kvm_tdx->tdr.pa);
+	if (TDX_ERR(err, TDRECLAIMHKIDS))
+		return;
+
+	kvm_for_each_vcpu(i, vcpu, (&kvm_tdx->kvm))
+		tdx_flush_vp_on_cpu(vcpu);
+
+	err = tdflushvpdone(kvm_tdx->tdr.pa);
+	if (TDX_ERR(err, TDFLUSHVPDONE))
+		return;
+
+	tdx_seamcall_on_each_pkg(tdx_do_tdwbcache, &err, &tdwbcache_lock);
+
+	if (unlikely(err))
+		return;
+
+	err = tdfreehkids(kvm_tdx->tdr.pa);
+	if (TDX_ERR(err, TDFREEHKIDS))
+		return;
+
+free_hkid:
+	tdx_keyid_free(kvm_tdx->hkid);
+	kvm_tdx->hkid = -1;
+}
+
+static void tdx_vm_destroy(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	int i;
+
+	/* Can't reclaim or free TD pages if teardown failed. */
+	if (is_hkid_assigned(kvm_tdx))
+		return;
+
+	kvm_mmu_zap_all_private(kvm);
+
+	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++)
+		tdx_reclaim_td_page(&kvm_tdx->tdcs[i]);
+
+	if (kvm_tdx->tdr.added &&
+	    __tdx_reclaim_page(kvm_tdx->tdr.va, kvm_tdx->tdr.pa, true))
+		return;
+
+	free_page(kvm_tdx->tdr.va);
+}
+
+struct tdx_tdconfigkey {
+	hpa_t tdr;
+	u64 err;
+};
+
+static void tdx_do_tdconfigkey(void *data)
+{
+	struct tdx_tdconfigkey *configkey = data;
+	u64 err;
+
+	if (configkey->err)
+		return;
+
+	do {
+		err = tdconfigkey(configkey->tdr);
+	} while (err == TDX_KEY_GENERATION_FAILED);
+
+	if (TDX_ERR(err, TDCONFIGKEY))
+		configkey->err = err;
+}
+
+static int tdx_vm_init(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_tdconfigkey configkey;
+	int ret, i;
+	u64 err;
+
+	kvm->dirty_log_unsupported = true;
+	kvm->readonly_mem_unsupported = true;
+
+	kvm->arch.tsc_immutable = true;
+	kvm->arch.eoi_intercept_unsupported = true;
+	kvm->arch.guest_state_protected = true;
+	kvm->arch.irq_injection_disallowed = true;
+	kvm->arch.mce_injection_disallowed = true;
+	kvm_mmu_set_mmio_spte_mask(kvm, 0, 0);
+
+	/* TODO: Enable 2mb and 1gb large page support. */
+	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
+
+	kvm_apicv_init(kvm, true);
+
+	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
+	kvm->max_vcpus = 0;
+
+	kvm_tdx->hkid = tdx_keyid_alloc();
+	if (kvm_tdx->hkid < 0)
+		return -EBUSY;
+	if (WARN_ON_ONCE(kvm_tdx->hkid >> 16)) {
+		ret = -EIO;
+		goto free_hkid;
+	}
+
+	ret = tdx_alloc_td_page(&kvm_tdx->tdr);
+	if (ret)
+		goto free_hkid;
+
+	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
+		ret = tdx_alloc_td_page(&kvm_tdx->tdcs[i]);
+		if (ret)
+			goto free_tdcs;
+	}
+
+	ret = -EIO;
+	err = tdcreate(kvm_tdx->tdr.pa, kvm_tdx->hkid);
+	if (TDX_ERR(err, TDCREATE))
+		goto free_tdcs;
+	tdx_add_td_page(&kvm_tdx->tdr);
+
+	configkey.tdr = kvm_tdx->tdr.pa;
+	configkey.err = 0;
+
+	tdx_seamcall_on_each_pkg(tdx_do_tdconfigkey, &configkey,
+				 &tdconfigkey_lock);
+	if (configkey.err)
+		goto teardown;
+
+	for (i = 0; i < tdx_caps.tdcs_nr_pages; i++) {
+		err = tdaddcx(kvm_tdx->tdr.pa, kvm_tdx->tdcs[i].pa);
+		if (TDX_ERR(err, TDADDCX))
+			goto teardown;
+		tdx_add_td_page(&kvm_tdx->tdcs[i]);
+	}
+
+	/*
+	 * Note, TDINIT cannot be invoked here.  TDINIT requires a dedicated
+	 * ioctl() to define the configure CPUID values for the TD.
+	 */
+	return 0;
+
+	/*
+	 * The sequence for freeing resources from a partially initialized TD
+	 * varies based on where in the initialization flow failure occurred.
+	 * Simply use the full teardown and destroy, which naturally play nice
+	 * with partial initialization.
+	 */
+teardown:
+	tdx_vm_teardown(kvm);
+	tdx_vm_destroy(kvm);
+	return ret;
+
+free_tdcs:
+	/* @i points at the TDCS page that failed allocation. */
+	for (--i; i >= 0; i--)
+		free_page(kvm_tdx->tdcs[i].va);
+
+	free_page(kvm_tdx->tdr.va);
+free_hkid:
+	tdx_keyid_free(kvm_tdx->hkid);
+	return ret;
+}
+
+static int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int cpu, ret, i;
+
+	ret = tdx_alloc_td_page(&tdx->tdvpr);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		ret = tdx_alloc_td_page(&tdx->tdvpx[i]);
+		if (ret)
+			goto free_tdvpx;
+	}
+
+	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
+
+	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCHED;
+	vcpu->arch.cr0_guest_owned_bits = -1ul;
+	vcpu->arch.cr4_guest_owned_bits = -1ul;
+
+	/* TODO: Grab TSC_OFFSET from the TDCS (need updated API). */
+	vcpu->arch.tsc_offset = 0;
+	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
+
+	tdx->pi_desc.nv = POSTED_INTR_VECTOR;
+	tdx->pi_desc.sn = 1;
+
+	cpu = get_cpu();
+	list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu));
+	vcpu->cpu = cpu;
+	put_cpu();
+
+	return 0;
+
+free_tdvpx:
+	/* @i points at the TDVPX page that failed allocation. */
+	for (--i; i >= 0; i--)
+		free_page(tdx->tdvpx[i].va);
+
+	free_page(tdx->tdvpr.va);
+
+	return ret;
+}
+
+static void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (vcpu->cpu != cpu) {
+		tdx_flush_vp_on_cpu(vcpu);
+
+		/*
+		 * Pairs with the smp_wmb() in tdx_disassociate_vp() to ensure
+		 * vcpu->cpu is read before tdx->cpu_list.
+		 */
+		smp_rmb();
+
+		list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu));
+	}
+
+	vmx_vcpu_pi_load(vcpu, cpu);
+}
+
+static void tdx_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	vmx_vcpu_pi_put(vcpu);
+}
+
+static void tdx_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int i;
+
+	/* Can't reclaim or free pages if teardown failed. */
+	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
+		return;
+
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
+		tdx_reclaim_td_page(&tdx->tdvpx[i]);
+
+	tdx_reclaim_td_page(&tdx->tdvpr);
+}
+
+static void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct msr_data apic_base_msr;
+	u64 err;
+	int i;
+
+	if (WARN_ON(init_event) || !vcpu->arch.apic)
+		goto td_bugged;
+
+	err = tdcreatevp(kvm_tdx->tdr.pa, tdx->tdvpr.pa);
+	if (TDX_ERR(err, TDCREATEVP))
+		goto td_bugged;
+	tdx_add_td_page(&tdx->tdvpr);
+
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		err = tdaddvpx(tdx->tdvpr.pa, tdx->tdvpx[i].pa);
+		if (TDX_ERR(err, TDADDVPX))
+			goto td_bugged;
+		tdx_add_td_page(&tdx->tdvpx[i]);
+	}
+
+	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
+	if (kvm_vcpu_is_reset_bsp(vcpu))
+		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
+	apic_base_msr.host_initiated = true;
+	if (WARN_ON(kvm_set_apic_base(vcpu, &apic_base_msr)))
+		goto td_bugged;
+
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+	return;
+
+td_bugged:
+	vcpu->kvm->vm_bugged = true;
+	return;
+}
+
+static void tdx_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
+}
+
+u64 __tdx_vcpu_run(hpa_t tdvpr, void *regs, u32 regs_mask);
+
+static fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (unlikely(vcpu->kvm->vm_bugged)) {
+		tdx->exit_reason.full = TDX_NON_RECOVERABLE_VCPU;
+		return EXIT_FASTPATH_NONE;
+	}
+
+	if (pi_test_on(&tdx->pi_desc)) {
+		apic->send_IPI_self(POSTED_INTR_VECTOR);
+
+		kvm_wait_lapic_expire(vcpu, true);
+	}
+
+	tdx->exit_reason.full = __tdx_vcpu_run(tdx->tdvpr.pa, vcpu->arch.regs,
+					       tdx->tdvmcall.regs_mask);
+
+	vmx_register_cache_reset(vcpu);
+
+	trace_kvm_exit((unsigned int)tdx->exit_reason.full, vcpu, KVM_ISA_VMX);
+
+	if (tdx->exit_reason.error || tdx->exit_reason.non_recoverable)
+		return EXIT_FASTPATH_NONE;
+
+	if (tdx->exit_reason.basic == EXIT_REASON_TDCALL)
+		tdx->tdvmcall.rcx = vcpu->arch.regs[VCPU_REGS_RCX];
+	else
+		tdx->tdvmcall.rcx = 0;
+
+	return EXIT_FASTPATH_NONE;
+}
+
+static void tdx_hardware_enable(void)
+{
+	INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, raw_smp_processor_id()));
+}
+
+static void tdx_hardware_disable(void)
+{
+	int cpu = raw_smp_processor_id();
+	struct list_head *tdvcpus = &per_cpu(associated_tdvcpus, cpu);
+	struct vcpu_tdx *tdx, *tmp;
+
+	/* Safe variant needed as tdx_disassociate_vp() deletes the entry. */
+	list_for_each_entry_safe(tdx, tmp, tdvcpus, cpu_list)
+		tdx_disassociate_vp(&tdx->vcpu);
+}
+
+static void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	u16 exit_reason = to_tdx(vcpu)->exit_reason.basic;
+
+	if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
+		vmx_handle_exception_nmi_irqoff(vcpu, tdexit_intr_info(vcpu));
+	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+		vmx_handle_external_interrupt_irqoff(vcpu,
+						     tdexit_intr_info(vcpu));
+}
+
+static int tdx_handle_exception(struct kvm_vcpu *vcpu)
+{
+	u32 intr_info = tdexit_intr_info(vcpu);
+
+	if (is_nmi(intr_info) || is_machine_check(intr_info))
+		return 1;
+
+	kvm_pr_unimpl("unexpected exception 0x%x\n", intr_info);
+	return -EFAULT;
+}
+
+static int tdx_handle_external_interrupt(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.irq_exits;
+	return 1;
+}
+
+static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+	vcpu->mmio_needed = 0;
+	return 0;
+}
+
+static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 eax, ebx, ecx, edx;
+
+	eax = tdvmcall_p1_read(vcpu);
+	ecx = tdvmcall_p2_read(vcpu);
+
+	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
+
+	tdvmcall_p1_write(vcpu, eax);
+	tdvmcall_p2_write(vcpu, ebx);
+	tdvmcall_p3_write(vcpu, ecx);
+	tdvmcall_p4_write(vcpu, edx);
+
+	tdvmcall_set_return_code(vcpu, 0);
+
+	return 1;
+}
+
+static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
+{
+	tdvmcall_set_return_code(vcpu, 0);
+
+	return kvm_vcpu_halt(vcpu);
+}
+
+static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	int ret;
+
+	BUG_ON(vcpu->arch.pio.count != 1);
+
+	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
+					 vcpu->arch.pio.port, &val, 1);
+	WARN_ON(!ret);
+
+	tdvmcall_set_return_code(vcpu, 0);
+	tdvmcall_set_return_val(vcpu, val);
+
+	return 1;
+}
+
+static int tdx_emulate_io(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+	unsigned long val = 0;
+	unsigned port;
+	int size, ret;
+
+	++vcpu->stat.io_exits;
+
+	size = tdvmcall_p1_read(vcpu);
+	port = tdvmcall_p3_read(vcpu);
+
+	if (size > 4) {
+		tdvmcall_set_return_code(vcpu, -E2BIG);
+		return 1;
+	}
+
+	if (!tdvmcall_p2_read(vcpu)) {
+		ret = ctxt->ops->pio_in_emulated(ctxt, size, port, &val, 1);
+		if (!ret)
+			vcpu->arch.complete_userspace_io = tdx_complete_pio_in;
+		else
+			tdvmcall_set_return_val(vcpu, val);
+	} else {
+		val = tdvmcall_p4_read(vcpu);
+		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
+
+		// No need for a complete_userspace_io callback.
+		vcpu->arch.pio.count = 0;
+	}
+	if (ret)
+		tdvmcall_set_return_code(vcpu, 0);
+	return ret;
+}
+
+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
+{
+	unsigned long nr, a0, a1, a2, a3, ret;
+
+	nr = tdvmcall_exit_reason(vcpu);
+	a0 = tdvmcall_p1_read(vcpu);
+	a1 = tdvmcall_p2_read(vcpu);
+	a2 = tdvmcall_p3_read(vcpu);
+	a3 = tdvmcall_p4_read(vcpu);
+
+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, true);
+
+	tdvmcall_set_return_code(vcpu, ret);
+
+	return 1;
+}
+
+static int tdx_complete_mmio(struct kvm_vcpu *vcpu)
+{
+	unsigned long val = 0;
+	gpa_t gpa;
+	int size;
+
+	BUG_ON(vcpu->mmio_needed != 1);
+	vcpu->mmio_needed = 0;
+
+	if (!vcpu->mmio_is_write) {
+		gpa = vcpu->mmio_fragments[0].gpa;
+		size = vcpu->mmio_fragments[0].len;
+
+		memcpy(&val, vcpu->run->mmio.data, size);
+		tdvmcall_set_return_val(vcpu, val);
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
+	}
+	return 1;
+}
+
+static inline int tdx_mmio_write(struct kvm_vcpu *vcpu, gpa_t gpa, int size,
+				 unsigned long val)
+{
+	if (kvm_iodevice_write(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
+	    kvm_io_bus_write(vcpu, KVM_MMIO_BUS, gpa, size, &val))
+		return -EOPNOTSUPP;
+
+	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, size, gpa, &val);
+	return 0;
+}
+
+static inline int tdx_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, int size)
+{
+	unsigned long val;
+
+	if (kvm_iodevice_read(vcpu, &vcpu->arch.apic->dev, gpa, size, &val) &&
+	    kvm_io_bus_read(vcpu, KVM_MMIO_BUS, gpa, size, &val))
+		return -EOPNOTSUPP;
+
+	tdvmcall_set_return_val(vcpu, val);
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ, size, gpa, &val);
+	return 0;
+}
+
+static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
+{
+	struct kvm_memory_slot *slot;
+	int size, write, r;
+	unsigned long val;
+	gpa_t gpa;
+
+	BUG_ON(vcpu->mmio_needed);
+
+	size = tdvmcall_p1_read(vcpu);
+	write = tdvmcall_p2_read(vcpu);
+	gpa = tdvmcall_p3_read(vcpu);
+	val = write ? tdvmcall_p4_read(vcpu) : 0;
+
+	/* Strip the shared bit, allow MMIO with and without it set. */
+	gpa &= ~(vcpu->kvm->arch.gfn_shared_mask << PAGE_SHIFT);
+
+	if (size > 8u || ((gpa + size - 1) ^ gpa) & PAGE_MASK) {
+		tdvmcall_set_return_code(vcpu, -E2BIG);
+		return 1;
+	}
+
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa >> PAGE_SHIFT);
+	if (slot && !(slot->flags & KVM_MEMSLOT_INVALID)) {
+		tdvmcall_set_return_code(vcpu, -EFAULT);
+		return 1;
+	}
+
+	if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
+		trace_kvm_fast_mmio(gpa);
+		return 1;
+	}
+
+	if (write)
+		r = tdx_mmio_write(vcpu, gpa, size, val);
+	else
+		r = tdx_mmio_read(vcpu, gpa, size);
+	if (!r) {
+		tdvmcall_set_return_code(vcpu, 0);
+		return 1;
+	}
+
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_is_write = write;
+	vcpu->arch.complete_userspace_io = tdx_complete_mmio;
+
+	vcpu->run->mmio.phys_addr = gpa;
+	vcpu->run->mmio.len = size;
+	vcpu->run->mmio.is_write = write;
+	vcpu->run->exit_reason = KVM_EXIT_MMIO;
+
+	if (write) {
+		memcpy(vcpu->run->mmio.data, &val, size);
+	} else {
+		vcpu->mmio_fragments[0].gpa = gpa;
+		vcpu->mmio_fragments[0].len = size;
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, size, gpa, NULL);
+	}
+	return 0;
+}
+
+static int tdx_emulate_rdmsr(struct kvm_vcpu *vcpu)
+{
+	u32 index = tdvmcall_p1_read(vcpu);
+	u64 data;
+
+	if (kvm_get_msr(vcpu, index, &data)) {
+		trace_kvm_msr_read_ex(index);
+		tdvmcall_set_return_code(vcpu, -EFAULT);
+		return 1;
+	}
+	trace_kvm_msr_read(index, data);
+
+	tdvmcall_set_return_code(vcpu, 0);
+	tdvmcall_set_return_val(vcpu, data);
+	return 1;
+}
+
+static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
+{
+	u32 index = tdvmcall_p1_read(vcpu);
+	u64 data = tdvmcall_p2_read(vcpu);
+
+	if (kvm_set_msr(vcpu, index, data)) {
+		trace_kvm_msr_write_ex(index, data);
+		tdvmcall_set_return_code(vcpu, -EFAULT);
+		return 1;
+	}
+
+	trace_kvm_msr_write(index, data);
+	tdvmcall_set_return_code(vcpu, 0);
+	return 1;
+}
+
+static int tdx_map_gpa(struct kvm_vcpu *vcpu)
+{
+	gpa_t gpa = tdvmcall_p1_read(vcpu);
+	gpa_t size = tdvmcall_p2_read(vcpu);
+
+	if (!IS_ALIGNED(gpa, 4096) || !IS_ALIGNED(size, 4096) ||
+	    (gpa + size) < gpa ||
+	    (gpa + size) > vcpu->kvm->arch.gfn_shared_mask << (PAGE_SHIFT + 1))
+		tdvmcall_set_return_code(vcpu, -EINVAL);
+	else
+		tdvmcall_set_return_code(vcpu, 0);
+
+	return 1;
+}
+
+static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
+	vcpu->run->system_event.flags = tdvmcall_p1_read(vcpu);
+	return 0;
+}
+
+static int handle_tdvmcall(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	unsigned long exit_reason;
+
+	if (unlikely(tdx->tdvmcall.xmm_mask))
+		goto unsupported;
+
+	if (tdvmcall_exit_type(vcpu))
+		return tdx_emulate_vmcall(vcpu);
+
+	exit_reason = tdvmcall_exit_reason(vcpu);
+
+	trace_kvm_tdvmcall(vcpu, exit_reason,
+			   tdvmcall_p1_read(vcpu), tdvmcall_p2_read(vcpu),
+			   tdvmcall_p3_read(vcpu), tdvmcall_p4_read(vcpu));
+
+	switch (exit_reason) {
+	case EXIT_REASON_CPUID:
+		return tdx_emulate_cpuid(vcpu);
+	case EXIT_REASON_HLT:
+		return tdx_emulate_hlt(vcpu);
+	// case EXIT_REASON_RDPMC:
+	// 	ret = tdx_emulate_rdpmc(vcpu);
+	// 	break;
+	// case EXIT_REASON_VMCALL:
+	// 	
+	// 	break;
+	case EXIT_REASON_IO_INSTRUCTION:
+		return tdx_emulate_io(vcpu);
+	case EXIT_REASON_MSR_READ:
+		return tdx_emulate_rdmsr(vcpu);
+	case EXIT_REASON_MSR_WRITE:
+		return tdx_emulate_wrmsr(vcpu);
+	case EXIT_REASON_EPT_VIOLATION:
+		return tdx_emulate_mmio(vcpu);
+	case TDVMCALL_MAP_GPA:
+		return tdx_map_gpa(vcpu);
+	case TDVMCALL_REPORT_FATAL_ERROR:
+		return tdx_report_fatal_error(vcpu);
+	default:
+		break;
+	}
+
+unsupported:
+	tdvmcall_set_return_code(vcpu, -EOPNOTSUPP);
+	return 1;
+}
+
+static void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
+			     int pgd_level)
+{
+	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, pgd & PAGE_MASK);
+}
+
+#define SEPT_ERR(err, op, kvm)			\
+({						\
+	int __ret = KVM_BUG_ON(err, kvm);	\
+						\
+	if (unlikely(__ret))			\
+		pr_seamcall_error(op, err);	\
+	__ret;					\
+})
+
+static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa)
+{
+	struct tdx_ex_ret ex_ret;
+	u64 err;
+	int i;
+
+	for (i = 0; i < PAGE_SIZE; i += TDX1_EXTENDMR_CHUNKSIZE) {
+		err = tdextendmr(kvm_tdx->tdr.pa, gpa + i, &ex_ret);
+		if (SEPT_ERR(err, TDEXTENDMR, &kvm_tdx->kvm))
+			break;
+	}
+}
+
+static void tdx_sept_set_private_spte(struct kvm_vcpu *vcpu, gfn_t gfn,
+				      int level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	hpa_t hpa = pfn << PAGE_SHIFT;
+	gpa_t gpa = gfn << PAGE_SHIFT;
+	struct tdx_ex_ret ex_ret;
+	hpa_t source_pa;
+	u64 err;
+
+	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn)))
+		return;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, vcpu->kvm))
+		return;
+
+	/* Pin the page, KVM doesn't yet support page migration. */
+	get_page(pfn_to_page(pfn));
+
+	/* Build-time faults are induced and handled via TDADDPAGE. */
+	if (is_td_finalized(kvm_tdx)) {
+		trace_kvm_sept_seamcall(SEAMCALL_TDAUGPAGE, gpa, hpa, level);
+
+		err = tdaugpage(kvm_tdx->tdr.pa, gpa, hpa, &ex_ret);
+		SEPT_ERR(err, TDAUGPAGE, vcpu->kvm);
+		return;
+	}
+
+	trace_kvm_sept_seamcall(SEAMCALL_TDADDPAGE, gpa, hpa, level);
+
+	source_pa = kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION;
+
+	err = tdaddpage(kvm_tdx->tdr.pa,  gpa, hpa, source_pa, &ex_ret);
+	if (!SEPT_ERR(err, TDADDPAGE, vcpu->kvm) &&
+	    (kvm_tdx->source_pa & KVM_TDX_MEASURE_MEMORY_REGION))
+		tdx_measure_page(kvm_tdx, gpa);
+}
+
+static void tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn, int level,
+				       kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn << PAGE_SHIFT;
+	hpa_t hpa = pfn << PAGE_SHIFT;
+	struct tdx_ex_ret ex_ret;
+	u64 err;
+
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_NONE, kvm))
+		return;
+
+	if (is_hkid_assigned(kvm_tdx)) {
+		trace_kvm_sept_seamcall(SEAMCALL_TDREMOVEPAGE, gpa, hpa, level);
+
+		err = tdremovepage(kvm_tdx->tdr.pa, gpa, level, &ex_ret);
+		if (SEPT_ERR(err, TDREMOVEPAGE, kvm))
+			return;
+	} else if (tdx_reclaim_page((unsigned long)__va(hpa), hpa)) {
+		return;
+	}
+
+	put_page(pfn_to_page(pfn));
+}
+
+static int tdx_sept_link_private_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
+				    int level, void *sept_page)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	gpa_t gpa = gfn << PAGE_SHIFT;
+	hpa_t hpa = __pa(sept_page);
+	struct tdx_ex_ret ex_ret;
+	u64 err;
+
+	trace_kvm_sept_seamcall(SEAMCALL_TDADDSEPT, gpa, hpa, level);
+
+	err = tdaddsept(kvm_tdx->tdr.pa, gpa, level, hpa, &ex_ret);
+	if (SEPT_ERR(err, TDADDSEPT, vcpu->kvm))
+		return -EIO;
+
+	return 0;
+}
+
+static void tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn, int level)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn << PAGE_SHIFT;
+	struct tdx_ex_ret ex_ret;
+	u64 err;
+
+	trace_kvm_sept_seamcall(SEAMCALL_TDBLOCK, gpa, -1ull, level);
+
+	err = tdblock(kvm_tdx->tdr.pa, gpa, level, &ex_ret);
+	SEPT_ERR(err, TDBLOCK, kvm);
+}
+
+static void tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn, int level)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn << PAGE_SHIFT;
+	struct tdx_ex_ret ex_ret;
+	u64 err;
+
+	trace_kvm_sept_seamcall(SEAMCALL_TDUNBLOCK, gpa, -1ull, level);
+
+	err = tdunblock(kvm_tdx->tdr.pa, gpa, level, &ex_ret);
+	SEPT_ERR(err, TDUNBLOCK, kvm);
+}
+
+static int tdx_sept_free_private_sp(struct kvm *kvm, gfn_t gfn, int level,
+				    void *sept_page)
+{
+	/*
+	 * free_private_sp() is (obviously) called when a shadow page is being
+	 * zapped.  KVM doesn't (yet) zap private SPs while the TD is active.
+	 */
+	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
+		return -EINVAL;
+
+	return tdx_reclaim_page((unsigned long)sept_page, __pa(sept_page));
+}
+
+static int tdx_sept_tlb_remote_flush(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx;
+	u64 err;
+
+	if (!is_td(kvm))
+		return -ENOTSUPP;
+
+	kvm_tdx = to_kvm_tdx(kvm);
+	kvm_tdx->tdtrack = true;
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
+
+	if (is_hkid_assigned(kvm_tdx) && is_td_finalized(kvm_tdx)) {
+		err = tdtrack(to_kvm_tdx(kvm)->tdr.pa);
+		SEPT_ERR(err, TDTRACK, kvm);
+	}
+
+	WRITE_ONCE(kvm_tdx->tdtrack, false);
+
+	return 0;
+}
+
+static void tdx_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	u64 root_hpa = mmu->root_hpa;
+
+	/* Flush the shared EPTP, if it's valid. */
+	if (VALID_PAGE(root_hpa))
+		ept_sync_context(construct_eptp(vcpu, root_hpa,
+						mmu->shadow_root_level));
+
+	while (READ_ONCE(kvm_tdx->tdtrack))
+		cpu_relax();
+}
+
+static inline bool tdx_is_private_gpa(struct kvm *kvm, gpa_t gpa)
+{
+	return !((gpa >> PAGE_SHIFT) & kvm->arch.gfn_shared_mask);
+}
+
+#define TDX_SEPT_PFERR (PFERR_WRITE_MASK | PFERR_USER_MASK)
+
+static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qual;
+
+	if (tdx_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu)))
+		exit_qual = TDX_SEPT_PFERR;
+	else
+		exit_qual = tdexit_exit_qual(vcpu);
+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
+}
+
+static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
+{
+	WARN_ON(1);
+
+	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+	vcpu->run->hw.hardware_exit_reason = EXIT_REASON_EPT_MISCONFIG;
+
+	return 0;
+}
+
+static int tdx_handle_exit(struct kvm_vcpu *vcpu,
+			   enum exit_fastpath_completion fastpath)
+{
+	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
+
+	if (unlikely(exit_reason.non_recoverable))
+		return tdx_handle_triple_fault(vcpu);
+
+	if (unlikely(exit_reason.error))
+		goto unhandled_exit;
+
+	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
+
+	switch (exit_reason.basic) {
+	case EXIT_REASON_EXCEPTION_NMI:
+		return tdx_handle_exception(vcpu);
+	case EXIT_REASON_EXTERNAL_INTERRUPT:
+		return tdx_handle_external_interrupt(vcpu);
+	case EXIT_REASON_TDCALL:
+		return handle_tdvmcall(vcpu);
+	case EXIT_REASON_EPT_VIOLATION:
+		return tdx_handle_ept_violation(vcpu);
+	case EXIT_REASON_EPT_MISCONFIG:
+		return tdx_handle_ept_misconfig(vcpu);
+	default:
+		break;
+	}
+
+unhandled_exit:
+	kvm_pr_unimpl("Unhandled TD-Exit Reason 0x%llx\n", exit_reason.full);
+	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+	vcpu->run->hw.hardware_exit_reason = exit_reason.full;
+	return 0;
+}
+
+static void tdx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+			      u32 *intr_info, u32 *error_code)
+{
+	*info1 = tdexit_exit_qual(vcpu);
+	*info2 = 0;
+
+	*intr_info = tdexit_intr_info(vcpu);
+	*error_code = 0;
+}
+
+static int __init tdx_check_processor_compatibility(void)
+{
+	/* TDX-SEAM itself verifies compatibility on all CPUs. */
+	return 0;
+}
+
+static void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(kvm_get_apic_mode(vcpu) != LAPIC_MODE_X2APIC);
+}
+
+static void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	pi_clear_on(&tdx->pi_desc);
+	memset(tdx->pi_desc.pir, 0, sizeof(tdx->pi_desc.pir));
+}
+
+/*
+ * Send interrupt to vcpu via posted interrupt way.
+ * 1. If target vcpu is running(non-root mode), send posted interrupt
+ * notification to vcpu and hardware will sync PIR to vIRR atomically.
+ * 2. If target vcpu isn't running(root mode), kick it to pick up the
+ * interrupt from PIR in next vmentry.
+ */
+static int tdx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (pi_test_and_set_pir(vector, &tdx->pi_desc))
+		return 0;
+
+	/* If a previous notification has sent the IPI, nothing to do. */
+	if (pi_test_and_set_on(&tdx->pi_desc))
+		return 0;
+
+	if (vcpu != kvm_get_running_vcpu() &&
+	    !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
+		kvm_vcpu_kick(vcpu);
+
+	return 0;
+}
+
+static int tdx_dev_ioctl(void __user *argp)
+{
+	struct kvm_tdx_capabilities __user *user_caps;
+	struct kvm_tdx_capabilities caps;
+	struct kvm_tdx_cmd cmd;
+
+	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
+		     sizeof(struct tdx_cpuid_config));
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.metadata || cmd.id != KVM_TDX_CAPABILITIES)
+		return -EINVAL;
+
+	user_caps = (void __user *)cmd.data;
+	if (copy_from_user(&caps, user_caps, sizeof(caps)))
+		return -EFAULT;
+
+	if (caps.nr_cpuid_configs < tdx_caps.nr_cpuid_configs)
+		return -E2BIG;
+	caps.nr_cpuid_configs = tdx_caps.nr_cpuid_configs;
+
+	if (copy_to_user(user_caps->cpuid_configs, &tdx_caps.cpuid_configs,
+			 tdx_caps.nr_cpuid_configs * sizeof(struct tdx_cpuid_config)))
+		return -EFAULT;
+
+	caps.attrs_fixed0 = tdx_caps.attrs_fixed0;
+	caps.attrs_fixed1 = tdx_caps.attrs_fixed1;
+	caps.xfam_fixed0 = tdx_caps.xfam_fixed0;
+	caps.xfam_fixed1 = tdx_caps.xfam_fixed1;
+
+	if (copy_to_user((void __user *)cmd.data, &caps, sizeof(caps)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * TDX-SEAM definitions for fixed{0,1} are inverted relative to VMX.  The TDX
+ * definitions are sane, the VMX definitions are backwards.
+ *
+ * if fixed0[i] == 0: val[i] must be 0
+ * if fixed1[i] == 1: val[i] must be 1
+ */
+static inline bool tdx_fixed_bits_valid(u64 val, u64 fixed0, u64 fixed1)
+{
+	return ((val & fixed0) | fixed1) == val;
+}
+
+static struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(struct kvm_tdx *kvm_tdx,
+						     u32 function, u32 index)
+{
+	struct kvm_cpuid_entry2 *e;
+	int i;
+
+	for (i = 0; i < kvm_tdx->cpuid_nent; i++) {
+		e = &kvm_tdx->cpuid_entries[i];
+
+		if (e->function == function && (e->index == index ||
+		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
+			return e;
+	}
+	return NULL;
+}
+
+static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
+			  struct kvm_tdx_init_vm *init_vm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_cpuid_config *config;
+	struct kvm_cpuid_entry2 *entry;
+	struct tdx_cpuid_value *value;
+	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
+	u32 guest_tsc_khz;
+	int max_pa;
+	int i;
+
+	td_params->attributes = init_vm->attributes;
+	td_params->max_vcpus = init_vm->max_vcpus;
+
+	/* TODO: Enforce consistent CPUID features for all vCPUs. */
+	for (i = 0; i < tdx_caps.nr_cpuid_configs; i++) {
+		config = &tdx_caps.cpuid_configs[i];
+
+		entry = tdx_find_cpuid_entry(kvm_tdx, config->leaf,
+					     config->sub_leaf);
+		if (!entry)
+			continue;
+
+		/*
+		 * Non-configurable bits must be '0', even if they are fixed to
+		 * '1' by TDX-SEAM, i.e. mask off non-configurable bits.
+		 */
+		value = &td_params->cpuid_values[i];
+		value->eax = entry->eax & config->eax;
+		value->ebx = entry->ebx & config->ebx;
+		value->ecx = entry->ecx & config->ecx;
+		value->edx = entry->edx & config->edx;
+	}
+
+	entry = tdx_find_cpuid_entry(kvm_tdx, 0xd, 0);
+	if (entry)
+		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
+	else
+		guest_supported_xcr0 = 0;
+	guest_supported_xcr0 &= supported_xcr0;
+
+	entry = tdx_find_cpuid_entry(kvm_tdx, 0xd, 1);
+	if (entry)
+		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
+	else
+		guest_supported_xss = 0;
+	guest_supported_xss &= supported_xss;
+
+	max_pa = 36;
+	entry = tdx_find_cpuid_entry(kvm_tdx, 0x80000008, 0);
+	if (entry)
+		max_pa = entry->eax & 0xff;
+
+	td_params->eptp_controls = VMX_EPTP_MT_WB;
+
+	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
+		td_params->eptp_controls |= VMX_EPTP_PWL_5;
+		td_params->exec_controls |= TDX1_EXEC_CONTROL_MAX_GPAW;
+	} else {
+		td_params->eptp_controls |= VMX_EPTP_PWL_4;
+	}
+
+	if (!tdx_fixed_bits_valid(td_params->attributes,
+				  tdx_caps.attrs_fixed0,
+				  tdx_caps.attrs_fixed1))
+		return -EINVAL;
+
+	/* Setup td_params.xfam */
+	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
+	if (!tdx_fixed_bits_valid(td_params->xfam,
+				  tdx_caps.xfam_fixed0,
+				  tdx_caps.xfam_fixed1))
+		return -EINVAL;
+
+	/* TODO: Support a scaled guest TSC, i.e. take this from userspace. */
+	guest_tsc_khz = tsc_khz;
+	if (guest_tsc_khz < TDX1_MIN_TSC_FREQUENCY_KHZ ||
+	    guest_tsc_khz > TDX1_MAX_TSC_FREQUENCY_KHZ)
+		return -EINVAL;
+
+	td_params->tsc_frequency = TDX1_TSC_KHZ_TO_25MHZ(guest_tsc_khz);
+	if (TDX1_TSC_25MHZ_TO_KHZ(td_params->tsc_frequency) != guest_tsc_khz)
+		pr_warn_once("KVM: TD TSC not a multiple of 25Mhz\n");
+
+	/* TODO
+	 *  - MRCONFIGID
+	 *  - MROWNER
+	 *  - MROWNERCONFIG
+	 */
+	return 0;
+}
+
+static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_cpuid2 __user *user_cpuid;
+	struct kvm_tdx_init_vm init_vm;
+	struct td_params *td_params;
+	struct tdx_ex_ret ex_ret;
+	struct kvm_cpuid2 cpuid;
+	int ret;
+	u64 err;
+
+	if (is_td_initialized(kvm))
+		return -EINVAL;
+
+	if (cmd->metadata)
+		return -EINVAL;
+
+	if (copy_from_user(&init_vm, (void __user *)cmd->data, sizeof(init_vm)))
+		return -EFAULT;
+
+	if (init_vm.max_vcpus > KVM_MAX_VCPUS || init_vm.reserved)
+		return -EINVAL;
+
+	user_cpuid = (void *)init_vm.cpuid;
+	if (copy_from_user(&cpuid, user_cpuid, sizeof(cpuid)))
+		return -EFAULT;
+
+	if (cpuid.nent > KVM_MAX_CPUID_ENTRIES)
+		return -E2BIG;
+
+	if (copy_from_user(&kvm_tdx->cpuid_entries, user_cpuid->entries,
+			   cpuid.nent * sizeof(struct kvm_cpuid_entry2)))
+		return -EFAULT;
+
+	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
+
+	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL_ACCOUNT);
+	if (!td_params)
+		return -ENOMEM;
+
+	kvm_tdx->cpuid_nent = cpuid.nent;
+
+	ret = setup_tdparams(kvm, td_params, &init_vm);
+	if (ret)
+		goto free_tdparams;
+
+	err = tdinit(kvm_tdx->tdr.pa, __pa(td_params), &ex_ret);
+	if (TDX_ERR(err, TDINIT)) {
+		ret = -EIO;
+		goto free_tdparams;
+	}
+
+	kvm->max_vcpus = td_params->max_vcpus;
+	kvm->arch.guest_state_protected = !(td_params->attributes &
+					    TDX1_TD_ATTRIBUTE_DEBUG);
+
+	if (td_params->exec_controls & TDX1_EXEC_CONTROL_MAX_GPAW)
+		kvm->arch.gfn_shared_mask = BIT_ULL(51) >> PAGE_SHIFT;
+	else
+		kvm->arch.gfn_shared_mask = BIT_ULL(47) >> PAGE_SHIFT;
+
+free_tdparams:
+	kfree(td_params);
+	if (ret)
+		kvm_tdx->cpuid_nent = 0;
+	return ret;
+}
+
+static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_mem_region region;
+	struct kvm_vcpu *vcpu;
+	struct page *page;
+	kvm_pfn_t pfn;
+	int idx, ret;
+
+	/* The BSP vCPU must be created before initializing memory regions. */
+	if (!atomic_read(&kvm->online_vcpus))
+		return -EINVAL;
+
+	if (cmd->metadata & ~KVM_TDX_MEASURE_MEMORY_REGION)
+		return -EINVAL;
+
+	if (copy_from_user(&region, (void __user *)cmd->data, sizeof(region)))
+		return -EFAULT;
+
+	/* Sanity check */
+	if (!IS_ALIGNED(region.source_addr, PAGE_SIZE))
+		return -EINVAL;
+	if (!IS_ALIGNED(region.gpa, PAGE_SIZE))
+		return -EINVAL;
+	if (region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa)
+		return -EINVAL;
+	if (!tdx_is_private_gpa(kvm, region.gpa))
+		return -EINVAL;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	if (mutex_lock_killable(&vcpu->mutex))
+		return -EINTR;
+
+	vcpu_load(vcpu);
+	idx = srcu_read_lock(&kvm->srcu);
+
+	kvm_mmu_reload(vcpu);
+
+	while (region.nr_pages) {
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		if (need_resched())
+			cond_resched();
+
+
+		/* Pin the source page. */
+		ret = get_user_pages_fast(region.source_addr, 1, 0, &page);
+		if (ret < 0)
+			break;
+		if (ret != 1) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		kvm_tdx->source_pa = pfn_to_hpa(page_to_pfn(page)) |
+				     (cmd->metadata & KVM_TDX_MEASURE_MEMORY_REGION);
+
+		pfn = kvm_mmu_map_tdp_page(vcpu, region.gpa, TDX_SEPT_PFERR,
+					   PG_LEVEL_4K);
+		if (is_error_noslot_pfn(pfn) || kvm->vm_bugged)
+			ret = -EFAULT;
+		else
+			ret = 0;
+
+		put_page(page);
+		if (ret)
+			break;
+
+		region.source_addr += PAGE_SIZE;
+		region.gpa += PAGE_SIZE;
+		region.nr_pages--;
+	}
+
+	srcu_read_unlock(&kvm->srcu, idx);
+	vcpu_put(vcpu);
+
+	mutex_unlock(&vcpu->mutex);
+
+	if (copy_to_user((void __user *)cmd->data, &region, sizeof(region)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
+static int tdx_td_finalizemr(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err;
+
+	if (!is_td_initialized(kvm) || is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	err = tdfinalizemr(kvm_tdx->tdr.pa);
+	if (TDX_ERR(err, TDFINALIZEMR))
+		return -EIO;
+
+	kvm_tdx->finalized = true;
+	return 0;
+}
+
+static int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_tdx_cmd tdx_cmd;
+	int r;
+
+	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
+		return -EFAULT;
+
+	mutex_lock(&kvm->lock);
+
+	switch (tdx_cmd.id) {
+	case KVM_TDX_INIT_VM:
+		r = tdx_td_init(kvm, &tdx_cmd);
+		break;
+	case KVM_TDX_INIT_MEM_REGION:
+		r = tdx_init_mem_region(kvm, &tdx_cmd);
+		break;
+	case KVM_TDX_FINALIZE_VM:
+		r = tdx_td_finalizemr(kvm);
+		break;
+	default:
+		r = -EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
+		r = -EFAULT;
+
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
+static int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm_tdx_cmd cmd;
+	u64 err;
+
+	if (tdx->initialized)
+		return -EINVAL;
+
+	if (!is_td_initialized(vcpu->kvm) || is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.metadata || cmd.id != KVM_TDX_INIT_VCPU)
+		return -EINVAL;
+
+	err = tdinitvp(tdx->tdvpr.pa, cmd.data);
+	if (TDX_ERR(err, TDINITVP))
+		return -EIO;
+
+	tdx->initialized = true;
+
+	td_vmcs_write16(tdx, POSTED_INTR_NV, POSTED_INTR_VECTOR);
+	td_vmcs_write64(tdx, POSTED_INTR_DESC_ADDR, __pa(&tdx->pi_desc));
+	td_vmcs_setbit32(tdx, PIN_BASED_VM_EXEC_CONTROL, PIN_BASED_POSTED_INTR);
+	return 0;
+}
+
+static void tdx_update_exception_bitmap(struct kvm_vcpu *vcpu)
+{
+	/* TODO: Figure out exception bitmap for debug TD. */
+}
+
+static void tdx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	/* TODO: Add TDWRVPS(GUEST_DR7) for debug TDs. */
+	if (is_debug_td(vcpu))
+		return;
+
+	KVM_BUG_ON(val != DR7_FIXED_1, vcpu->kvm);
+}
+
+static int tdx_get_cpl(struct kvm_vcpu *vcpu)
+{
+	if (KVM_BUG_ON(!is_debug_td(vcpu), vcpu->kvm))
+		return 0;
+
+	/*
+	 * For debug TDs, tdx_get_cpl() may be called before the vCPU is
+	 * initialized, i.e. before TDRDVPS is legal, if the vCPU is scheduled
+	 * out.  If this happens, simply return CPL0 to avoid TDRDVPS failure.
+	 */
+	if (!to_tdx(vcpu)->initialized)
+		return 0;
+
+	return VMX_AR_DPL(td_vmcs_read32(to_tdx(vcpu), GUEST_SS_AR_BYTES));
+}
+
+static unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu)
+{
+	if (KVM_BUG_ON(!is_debug_td(vcpu), vcpu->kvm))
+		return 0;
+
+	return td_vmcs_read64(to_tdx(vcpu), GUEST_RFLAGS);
+}
+
+static void tdx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
+{
+	if (KVM_BUG_ON(!is_debug_td(vcpu), vcpu->kvm))
+		return;
+
+	/*
+	 * TODO: This is currently disallowed by TDX-SEAM, which breaks single-
+	 * step debug.
+	 */
+	td_vmcs_write64(to_tdx(vcpu), GUEST_RFLAGS, rflags);
+}
+
+static bool tdx_is_emulated_msr(u32 index, bool write)
+{
+	switch (index) {
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_ARCH_CAPABILITIES:
+	case MSR_IA32_POWER_CTL:
+	case MSR_MTRRcap:
+	case 0x200 ... 0x2ff:
+	case MSR_IA32_TSCDEADLINE:
+	case MSR_IA32_MISC_ENABLE:
+	case MSR_KVM_STEAL_TIME:
+	case MSR_KVM_POLL_CONTROL:
+	case MSR_PLATFORM_INFO:
+	case MSR_MISC_FEATURES_ENABLES:
+	case MSR_IA32_MCG_CTL:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(32) - 1:
+		return true;
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
+		/*
+		 * x2APIC registers that are virtualized by the CPU can't be
+		 * emulated, KVM doesn't have access to the virtual APIC page.
+		 */
+		switch (index) {
+		case X2APIC_MSR(APIC_TASKPRI):
+		case X2APIC_MSR(APIC_PROCPRI):
+		case X2APIC_MSR(APIC_EOI):
+		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
+		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
+		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
+			return false;
+		default:
+			return true;
+		}
+	case MSR_IA32_APICBASE:
+	case MSR_EFER:
+		return !write;
+	default:
+		return false;
+	}
+}
+
+static int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (tdx_is_emulated_msr(msr->index, false))
+		return kvm_get_msr_common(vcpu, msr);
+	return 1;
+}
+
+static int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (tdx_is_emulated_msr(msr->index, true))
+		return kvm_set_msr_common(vcpu, msr);
+	return 1;
+}
+
+static u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
+{
+	if (!is_debug_td(vcpu))
+		return 0;
+
+	return td_vmcs_read64(to_tdx(vcpu), GUEST_ES_BASE + seg * 2);
+}
+
+static void tdx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
+			    int seg)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (!is_debug_td(vcpu)) {
+		memset(var, 0, sizeof(*var));
+		return;
+	}
+
+	seg *= 2;
+	var->base = td_vmcs_read64(tdx, GUEST_ES_BASE + seg);
+	var->limit = td_vmcs_read32(tdx, GUEST_ES_LIMIT + seg);
+	var->selector = td_vmcs_read16(tdx, GUEST_ES_SELECTOR + seg);
+	vmx_decode_ar_bytes(td_vmcs_read32(tdx, GUEST_ES_AR_BYTES + seg), var);
+}
+
+static void tdx_cache_gprs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int i;
+
+	if (!is_td_vcpu(vcpu) || !is_debug_td(vcpu))
+		return;
+
+	for (i = 0; i < NR_VCPU_REGS; i++) {
+		if (i == VCPU_REGS_RSP || i == VCPU_REGS_RIP)
+			continue;
+
+		vcpu->arch.regs[i] = td_gpr_read64(tdx, i);
+	}
+}
+
+static void tdx_flush_gprs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int i;
+
+	if (!is_td_vcpu(vcpu) || KVM_BUG_ON(!is_debug_td(vcpu), vcpu->kvm))
+		return;
+
+	for (i = 0; i < NR_VCPU_REGS; i++)
+		td_gpr_write64(tdx, i, vcpu->arch.regs[i]);
+}
+
+static void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
+				    unsigned int *vcpu_align,
+				    unsigned int *vm_size)
+{
+	*vcpu_size = sizeof(struct vcpu_tdx);
+	*vcpu_align = __alignof__(struct vcpu_tdx);
+
+	if (sizeof(struct kvm_tdx) > *vm_size)
+		*vm_size = sizeof(struct kvm_tdx);
+}
+
+static int __init tdx_init(void)
+{
+	return 0;
+}
+
+static int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	struct tdsysinfo_struct *tdsysinfo = tdx_get_sysinfo();
+
+	if (tdsysinfo == NULL) {
+		WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_TDX));
+		return -ENODEV;
+	}
+
+	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
+		return -EIO;
+
+	tdx_caps.tdcs_nr_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE;
+	if (tdx_caps.tdcs_nr_pages != TDX1_NR_TDCX_PAGES)
+		return -EIO;
+
+	tdx_caps.tdvpx_nr_pages = tdsysinfo->tdvps_base_size / PAGE_SIZE - 1;
+	if (tdx_caps.tdvpx_nr_pages != TDX1_NR_TDVPX_PAGES)
+		return -EIO;
+
+	tdx_caps.attrs_fixed0 = tdsysinfo->attributes_fixed0;
+	tdx_caps.attrs_fixed1 = tdsysinfo->attributes_fixed1;
+	tdx_caps.xfam_fixed0 =	tdsysinfo->xfam_fixed0;
+	tdx_caps.xfam_fixed1 = tdsysinfo->xfam_fixed1;
+
+	tdx_caps.nr_cpuid_configs = tdsysinfo->num_cpuid_config;
+	if (tdx_caps.nr_cpuid_configs > TDX1_MAX_NR_CPUID_CONFIGS)
+		return -EIO;
+
+	if (!memcpy(tdx_caps.cpuid_configs, tdsysinfo->cpuid_configs,
+		    tdsysinfo->num_cpuid_config * sizeof(struct tdx_cpuid_config)))
+		return -EIO;
+
+	x86_ops->cache_gprs = tdx_cache_gprs;
+	x86_ops->flush_gprs = tdx_flush_gprs;
+
+	x86_ops->tlb_remote_flush = tdx_sept_tlb_remote_flush;
+	x86_ops->set_private_spte = tdx_sept_set_private_spte;
+	x86_ops->drop_private_spte = tdx_sept_drop_private_spte;
+	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
+	x86_ops->unzap_private_spte = tdx_sept_unzap_private_spte;
+	x86_ops->link_private_sp = tdx_sept_link_private_sp;
+	x86_ops->free_private_sp = tdx_sept_free_private_sp;
+
+	return 0;
+}
+
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index b55108a8e484..e6e768b40eaf 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -8,6 +8,7 @@
 #include "tdx_arch.h"
 #include "tdx_errno.h"
 #include "tdx_ops.h"
+#include "posted_intr.h"
 
 #ifdef CONFIG_KVM_INTEL_TDX
 
@@ -22,6 +23,47 @@ struct kvm_tdx {
 
 	struct tdx_td_page tdr;
 	struct tdx_td_page tdcs[TDX1_NR_TDCX_PAGES];
+
+	int hkid;
+
+	int cpuid_nent;
+	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
+
+	bool finalized;
+	bool tdtrack;
+
+	hpa_t source_pa;
+};
+
+union tdx_exit_reason {
+	struct {
+		/* 31:0 mirror the VMX Exit Reason format */
+		u64 basic		: 16;
+		u64 reserved16		: 1;
+		u64 reserved17		: 1;
+		u64 reserved18		: 1;
+		u64 reserved19		: 1;
+		u64 reserved20		: 1;
+		u64 reserved21		: 1;
+		u64 reserved22		: 1;
+		u64 reserved23		: 1;
+		u64 reserved24		: 1;
+		u64 reserved25		: 1;
+		u64 reserved26		: 1;
+		u64 enclave_mode	: 1;
+		u64 smi_pending_mtf	: 1;
+		u64 smi_from_vmx_root	: 1;
+		u64 reserved30		: 1;
+		u64 failed_vmentry	: 1;
+
+		/* 63:32 are TDX specific */
+		u64 details_l1		: 8;
+		u64 class		: 8;
+		u64 reserved61_48	: 14;
+		u64 non_recoverable	: 1;
+		u64 error		: 1;
+	};
+	u64 full;
 };
 
 struct vcpu_tdx {
@@ -29,6 +71,42 @@ struct vcpu_tdx {
 
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page tdvpx[TDX1_NR_TDVPX_PAGES];
+
+	struct list_head cpu_list;
+
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
+	union {
+		struct {
+			union {
+				struct {
+					u16 gpr_mask;
+					u16 xmm_mask;
+				};
+				u32 regs_mask;
+			};
+			u32 reserved;
+		};
+		u64 rcx;
+	} tdvmcall;
+
+	union tdx_exit_reason exit_reason;
+
+	bool initialized;
+};
+
+struct tdx_capabilities {
+	u8 tdcs_nr_pages;
+	u8 tdvpx_nr_pages;
+
+	u64 attrs_fixed0;
+	u64 attrs_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+
+	u32 nr_cpuid_configs;
+	struct tdx_cpuid_config cpuid_configs[TDX1_MAX_NR_CPUID_CONFIGS];
 };
 
 static inline bool is_td(struct kvm *kvm)
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index a6f87cfe9bda..9e76a2a9763b 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -6,6 +6,7 @@
 
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
+#include <asm/cacheflush.h>
 
 struct tdx_ex_ret {
 	union {
@@ -294,25 +295,34 @@ do {									\
 	seamcall_N_5(fn, ex, "c"(rcx), "d"(rdx), "r"(r8), "r"(r9), "r"(r10)); \
 } while (0)
 
+static inline void tdx_clflush_page(hpa_t addr)
+{
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+}
+
 static inline u64 tdaddcx(hpa_t tdr, hpa_t addr)
 {
+	tdx_clflush_page(addr);
 	seamcall_2(TDADDCX, addr, tdr);
 }
 
 static inline u64 tdaddpage(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
 			    struct tdx_ex_ret *ex)
 {
+	tdx_clflush_page(hpa);
 	seamcall_4_2(TDADDPAGE, gpa, tdr, hpa, source, ex);
 }
 
 static inline u64 tdaddsept(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 			    struct tdx_ex_ret *ex)
 {
+	tdx_clflush_page(page);
 	seamcall_3_2(TDADDSEPT, gpa | level, tdr, page, ex);
 }
 
 static inline u64 tdaddvpx(hpa_t tdvpr, hpa_t addr)
 {
+	tdx_clflush_page(addr);
 	seamcall_2(TDADDVPX, addr, tdvpr);
 }
 
@@ -324,6 +334,7 @@ static inline u64 tdassignhkid(hpa_t tdr, int hkid)
 static inline u64 tdaugpage(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 			    struct tdx_ex_ret *ex)
 {
+	tdx_clflush_page(hpa);
 	seamcall_3_2(TDAUGPAGE, gpa, tdr, hpa, ex);
 }
 
@@ -340,11 +351,13 @@ static inline u64 tdconfigkey(hpa_t tdr)
 
 static inline u64 tdcreate(hpa_t tdr, int hkid)
 {
+	tdx_clflush_page(tdr);
 	seamcall_2(TDCREATE, tdr, hkid);
 }
 
 static inline u64 tdcreatevp(hpa_t tdr, hpa_t tdvpr)
 {
+	tdx_clflush_page(tdvpr);
 	seamcall_2(TDCREATEVP, tdvpr, tdr);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx_stubs.c b/arch/x86/kvm/vmx/tdx_stubs.c
new file mode 100644
index 000000000000..def5b0789bf7
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_stubs.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kvm_host.h>
+
+static int tdx_vm_init(struct kvm *kvm) { return 0; }
+static void tdx_vm_teardown(struct kvm *kvm) {}
+static void tdx_vm_destroy(struct kvm *kvm) {}
+static int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return 0; }
+static void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+static void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
+static fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
+static void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
+static void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
+static void tdx_hardware_enable(void) {}
+static void tdx_hardware_disable(void) {}
+static void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu) {}
+static int tdx_handle_exit(struct kvm_vcpu *vcpu,
+			   enum exit_fastpath_completion fastpath) { return 0; }
+static int tdx_dev_ioctl(void __user *argp) { return -EINVAL; }
+static int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EINVAL; }
+static int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EINVAL; }
+static void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
+static void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
+			     int pgd_level) {}
+static void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu) {}
+static void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu) {}
+static int tdx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector) { return -1; }
+static void tdx_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
+			      u32 *intr_info, u32 *error_code) { }
+static int __init tdx_check_processor_compatibility(void) { return 0; }
+static void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
+				    unsigned int *vcpu_align,
+				    unsigned int *vm_size) {}
+static int __init tdx_init(void) { return 0; }
+static void tdx_update_exception_bitmap(struct kvm_vcpu *vcpu) {}
+static void tdx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val) {}
+static int tdx_get_cpl(struct kvm_vcpu *vcpu) { return 0; }
+static unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu) { return 0; }
+static void tdx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags) {}
+static bool tdx_is_emulated_msr(u32 index, bool write) { return false; }
+static int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+static int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+static u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg) { return 0; }
+static void tdx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
+			    int seg) {}
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 90ad7a6246e3..ddefa2e80441 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -2,6 +2,7 @@
 #include <linux/linkage.h>
 #include <asm/asm.h>
 #include <asm/bitsperlong.h>
+#include <asm/errno.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
 #include <asm/segment.h>
@@ -28,6 +29,13 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
+#ifdef CONFIG_KVM_INTEL_TDX
+#define TDENTER 		0
+#define EXIT_REASON_TDCALL	77
+#define TDENTER_ERROR_BIT	63
+#define seamcall .byte 0x66,0x0f,0x01,0xcf
+#endif
+
 .section .noinstr.text, "ax"
 
 /**
@@ -328,3 +336,135 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
 	pop %_ASM_BP
 	ret
 SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
+
+#ifdef CONFIG_KVM_INTEL_TDX
+/**
+ * __tdx_vcpu_run - Call SEAMCALL(TDENTER) to run a TD vcpu
+ * @tdvpr:	physical address of TDVPR
+ * @regs:	void * (to registers of TDVCPU)
+ * @gpr_mask:	non-zero if guest registers need to be loaded prior to TDENTER
+ *
+ * Returns:
+ *	TD-Exit Reason
+ *
+ * Note: KVM doesn't support using XMM in its hypercalls, it's the HyperV
+ *	 code's responsibility to save/restore XMM registers on TDVMCALL.
+ */
+SYM_FUNC_START(__tdx_vcpu_run)
+	push %rbp
+	mov  %rsp, %rbp
+
+	push %r15
+	push %r14
+	push %r13
+	push %r12
+	push %rbx
+
+	/* Save @regs, which is needed after TDENTER to capture output. */
+	push %rsi
+
+	/* Load @tdvpr to RCX */
+	mov %rdi, %rcx
+
+	/* No need to load guest GPRs if the last exit wasn't a TDVMCALL. */
+	test %dx, %dx
+	je 1f
+
+	/* Load @regs to RAX, which will be clobbered with $TDENTER anyways. */
+	mov %rsi, %rax
+
+	mov VCPU_RBX(%rax), %rbx
+	mov VCPU_RDX(%rax), %rdx
+	mov VCPU_RBP(%rax), %rbp
+	mov VCPU_RSI(%rax), %rsi
+	mov VCPU_RDI(%rax), %rdi
+
+	mov VCPU_R8 (%rax),  %r8
+	mov VCPU_R9 (%rax),  %r9
+	mov VCPU_R10(%rax), %r10
+	mov VCPU_R11(%rax), %r11
+	mov VCPU_R12(%rax), %r12
+	mov VCPU_R13(%rax), %r13
+	mov VCPU_R14(%rax), %r14
+	mov VCPU_R15(%rax), %r15
+
+	/*  Load TDENTER to RAX.  This kills the @regs pointer! */
+1:	mov $TDENTER, %rax
+
+2:	seamcall
+
+	/* Skip to the exit path if TDENTER failed. */
+	bt $TDENTER_ERROR_BIT, %rax
+	jc 4f
+
+	/* Temporarily save the TD-Exit reason. */
+	push %rax
+
+	/* check if TD-exit due to TDVMCALL */
+	cmp $EXIT_REASON_TDCALL, %ax
+
+	/* Reload @regs to RAX. */
+	mov 8(%rsp), %rax
+
+	/* Jump on non-TDVMCALL */
+	jne 3f
+
+	/* Save all output from SEAMCALL(TDENTER) */
+	mov %rbx, VCPU_RBX(%rax)
+	mov %rbp, VCPU_RBP(%rax)
+	mov %rsi, VCPU_RSI(%rax)
+	mov %rdi, VCPU_RDI(%rax)
+	mov %r10, VCPU_R10(%rax)
+	mov %r11, VCPU_R11(%rax)
+	mov %r12, VCPU_R12(%rax)
+	mov %r13, VCPU_R13(%rax)
+	mov %r14, VCPU_R14(%rax)
+	mov %r15, VCPU_R15(%rax)
+
+3:	mov %rcx, VCPU_RCX(%rax)
+	mov %rdx, VCPU_RDX(%rax)
+	mov %r8,  VCPU_R8 (%rax)
+	mov %r9,  VCPU_R9 (%rax)
+
+	/*
+	 * Clear all general purpose registers except RSP and RAX to prevent
+	 * speculative use of the guest's values.
+	 */
+	xor %rbx, %rbx
+	xor %rcx, %rcx
+	xor %rdx, %rdx
+	xor %rsi, %rsi
+	xor %rdi, %rdi
+	xor %rbp, %rbp
+	xor %r8,  %r8
+	xor %r9,  %r9
+	xor %r10, %r10
+	xor %r11, %r11
+	xor %r12, %r12
+	xor %r13, %r13
+	xor %r14, %r14
+	xor %r15, %r15
+
+	/* Restore the TD-Exit reason to RAX for return. */
+	pop %rax
+
+	/* "POP" @regs. */
+4:	add $8, %rsp
+	pop %rbx
+	pop %r12
+	pop %r13
+	pop %r14
+	pop %r15
+
+	pop %rbp
+	ret
+
+5:	cmpb $0, kvm_rebooting
+	je 6f
+	mov $-EFAULT, %rax
+	jmp 4b
+6:	ud2
+	_ASM_EXTABLE(2b, 5b)
+
+SYM_FUNC_END(__tdx_vcpu_run)
+#endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7ffb36c318c..5566e7f25ce6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9744,7 +9744,8 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 {
 	int ret;
 
-	if (vcpu->kvm->arch.guest_state_protected)
+	if (vcpu->kvm->arch.guest_state_protected ||
+	    vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM)
 		return -EINVAL;
 
 	vcpu_load(vcpu);
@@ -11388,6 +11389,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_tdvmcall);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_sept_seamcall);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter_failed);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 44313ac967dd..959dc883fb11 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -470,4 +470,55 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_SEV_ES_VM	1
 #define KVM_X86_TDX_VM		2
 
+/* Trust Domain eXtension command*/
+enum tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	__u32 id;
+	__u32 metadata;
+	__u64 data;
+};
+
+struct kvm_tdx_cpuid_config {
+	__u32 leaf;
+	__u32 sub_leaf;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
+
+	__u32 nr_cpuid_configs;
+	struct kvm_tdx_cpuid_config cpuid_configs[0];
+};
+
+struct kvm_tdx_init_vm {
+	__u32 max_vcpus;
+	__u32 reserved;
+	__u64 attributes;
+	__u64 cpuid;
+};
+
+#define KVM_TDX_MEASURE_MEMORY_REGION	(1UL << 0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.17.1

