Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E36345D1DC
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353921AbhKYA00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:26:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:16278 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352993AbhKYAYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432272"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432272"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:28 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042411"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:28 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Isaku Yamahata <isaku.yamahata@linux.intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: [RFC PATCH v3 55/59] KVM: TDX: Add "basic" support for building and running Trust Domains
Date:   Wed, 24 Nov 2021 16:20:38 -0800
Message-Id: <b14334c951200364c433712e5c5ee74a1709dab1.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/events/intel/ds.c            |   1 +
 arch/x86/include/uapi/asm/kvm.h       |  56 ++++
 arch/x86/include/uapi/asm/vmx.h       |   3 +-
 arch/x86/kvm/Makefile                 |   5 +-
 arch/x86/kvm/mmu.h                    |   2 +-
 arch/x86/kvm/mmu/mmu.c                |   1 +
 arch/x86/kvm/mmu/spte.c               |   5 +-
 arch/x86/kvm/vmx/common.h             |   1 +
 arch/x86/kvm/vmx/main.c               | 403 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/posted_intr.c        |   6 +
 arch/x86/kvm/vmx/tdx.h                | 114 ++++++++
 arch/x86/kvm/vmx/tdx_arch.h           |  24 +-
 arch/x86/kvm/vmx/tdx_ops.h            |  14 +
 arch/x86/kvm/vmx/tdx_stubs.c          |  50 ++++
 arch/x86/kvm/vmx/vmenter.S            | 146 ++++++++++
 arch/x86/kvm/vmx/vmx.c                |  39 ---
 arch/x86/kvm/vmx/x86_ops.h            |  80 +++++
 arch/x86/kvm/x86.c                    |   8 +-
 tools/arch/x86/include/uapi/asm/kvm.h |  51 ++++
 19 files changed, 946 insertions(+), 63 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx_stubs.c

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 2e215369df4a..b6c556225fd2 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2248,3 +2248,4 @@ void perf_restore_debug_store(void)
 
 	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
 }
+EXPORT_SYMBOL_GPL(perf_restore_debug_store);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a0805a2a81f8..6f93a3d345d7 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -512,4 +512,60 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_SEV_ES_VM	1
 #define KVM_X86_TDX_VM		2
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
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
+	__u32 padding;
+	struct kvm_tdx_cpuid_config cpuid_configs[0];
+};
+
+struct kvm_tdx_init_vm {
+	__u32 max_vcpus;
+	__u32 tsc_khz;
+	__u64 attributes;
+	__u64 cpuid;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha348 digest */
+	__u64 reserved[43];	/* must be zero for future extensibility */
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
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index ba5908dfc7c0..79843a0143d2 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -32,8 +32,9 @@
 #define EXIT_REASON_EXCEPTION_NMI       0
 #define EXIT_REASON_EXTERNAL_INTERRUPT  1
 #define EXIT_REASON_TRIPLE_FAULT        2
-#define EXIT_REASON_INIT_SIGNAL			3
+#define EXIT_REASON_INIT_SIGNAL         3
 #define EXIT_REASON_SIPI_SIGNAL         4
+#define EXIT_REASON_OTHER_SMI           6
 
 #define EXIT_REASON_INTERRUPT_WINDOW    7
 #define EXIT_REASON_NMI_WINDOW          8
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index d28f990bd81d..51b2d5fdaeed 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -29,7 +29,10 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
-kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx_error.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx_error.o vmx/tdx.o
+ifneq ($(CONFIG_INTEL_TDX_HOST),y)
+kvm-intel-y				+= vmx/tdx_stubs.o
+endif
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2c4b8fde66d9..0bcf583216a1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -65,7 +65,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only, u64 init_value);
 void kvm_mmu_set_spte_init_value(u64 init_value);
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7d3830508a44..f8109002da0d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5461,6 +5461,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
 static void __kvm_mmu_unload(struct kvm_vcpu *vcpu, u32 roots_to_free)
 {
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index bb45e71eb105..75784ac9d91a 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -312,14 +312,15 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only, u64 init_value)
 {
 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
 	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
-	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
+	shadow_present_mask	=
+		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | init_value;
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
 	shadow_me_mask		= 0ull;
 
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 684cd3add46b..18b939e363e2 100644
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
index 4d6bf1f56641..958d4805eda4 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -3,11 +3,19 @@
 
 #include "x86_ops.h"
 #include "vmx.h"
+#include "tdx.h"
 #include "common.h"
 #include "nested.h"
 #include "mmu.h"
 #include "pmu.h"
 
+#ifdef CONFIG_INTEL_TDX_HOST
+static bool __read_mostly enable_tdx = 1;
+module_param_named(tdx, enable_tdx, bool, 0444);
+#else
+#define enable_tdx 0
+#endif
+
 static int __init vt_cpu_has_kvm_support(void)
 {
 	return cpu_has_vmx();
@@ -26,6 +34,16 @@ static int __init vt_check_processor_compatibility(void)
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
 
@@ -37,20 +55,40 @@ static __init int vt_hardware_setup(void)
 	if (ret)
 		return ret;
 
-	if (enable_ept)
+#ifdef CONFIG_INTEL_TDX_HOST
+	if (enable_tdx && tdx_hardware_setup(&vt_x86_ops))
+		enable_tdx = false;
+#endif
+
+	if (enable_ept) {
+		const u64 init_value = enable_tdx ? VMX_EPT_SUPPRESS_VE_BIT : 0ull;
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
-				      cpu_has_vmx_ept_execute_only());
+				      cpu_has_vmx_ept_execute_only(), init_value);
+		kvm_mmu_set_spte_init_value(init_value);
+	}
 
 	return 0;
 }
 
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
 
@@ -61,60 +99,92 @@ static bool vt_cpu_has_accelerated_tpr(void)
 
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
 
 static void vt_mmu_prezap(struct kvm *kvm)
 {
+	if (is_td(kvm))
+		return tdx_vm_teardown(kvm);
 }
 
 static void vt_vm_destroy(struct kvm *kvm)
 {
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
 
@@ -130,21 +200,33 @@ static void vt_update_emulated_instruction(struct kvm_vcpu *vcpu)
 
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
 
 static int vt_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
 	return vmx_enter_smm(vcpu, smstate);
 }
 
 static int vt_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return 0;
+
 	return vmx_leave_smm(vcpu, smstate);
 }
 
@@ -157,6 +239,9 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
 static bool vt_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn,
 				       int insn_len)
 {
+	if (is_td_vcpu(vcpu))
+		return false;
+
 	return vmx_can_emulate_instruction(vcpu, insn, insn_len);
 }
 
@@ -165,11 +250,17 @@ static int vt_check_intercept(struct kvm_vcpu *vcpu,
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
 
@@ -178,13 +269,43 @@ static void vt_migrate_timers(struct kvm_vcpu *vcpu)
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
 
@@ -195,31 +316,49 @@ static bool vt_check_apicv_inhibit_reasons(ulong bit)
 
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
 
@@ -229,6 +368,9 @@ static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
  */
 static bool vt_has_emulated_msr(struct kvm *kvm, u32 index)
 {
+	if (kvm && is_td(kvm))
+		return tdx_is_emulated_msr(index, true);
+
 	return vmx_has_emulated_msr(kvm, index);
 }
 
@@ -239,11 +381,25 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
 
 static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * All host state is saved/restored across SEAMCALL/SEAMRET, and the
+	 * guest state of a TD is obviously off limits.  Deferring MSRs and DRs
+	 * is pointless because TDX-SEAM needs to load *something* so as not to
+	 * expose guest state.
+	 */
+	if (is_td_vcpu(vcpu)) {
+		tdx_prepare_switch_to_guest(vcpu);
+		return;
+	}
+
 	vmx_prepare_switch_to_guest(vcpu);
 }
 
 static void vt_update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_update_exception_bitmap(vcpu);
+
 	vmx_update_exception_bitmap(vcpu);
 }
 
@@ -254,49 +410,84 @@ static int vt_get_msr_feature(struct kvm_msr_entry *msr)
 
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
+	if (is_td_vcpu(vcpu) && !is_td_vcpu_initialized(vcpu))
+		/* ignore reset on vcpu creation. */
+		return;
+
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_set_cr0(vcpu, cr0);
 }
 
 static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			    int pgd_level)
 {
+	if (is_td_vcpu(vcpu))
+		return tdx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
 static void vt_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
+	if (is_td_vcpu(vcpu) && !is_td_vcpu_initialized(vcpu))
+		/* ignore reset on vcpu creation. */
+		return;
+
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_set_cr4(vcpu, cr4);
 }
 
@@ -307,6 +498,13 @@ static bool vt_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 static int vt_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	if (is_td_vcpu(vcpu) && !is_td_vcpu_initialized(vcpu))
+		/* ignore reset on vcpu creation. */
+		return 0;
+
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return -EIO;
+
 	return vmx_set_efer(vcpu, efer);
 }
 
@@ -318,6 +516,9 @@ static void vt_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_set_idt(vcpu, dt);
 }
 
@@ -329,16 +530,30 @@ static void vt_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
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
 
@@ -350,34 +565,47 @@ void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 
 	switch (reg) {
 	case VCPU_REGS_RSP:
-		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
+		vcpu->arch.regs[VCPU_REGS_RSP] = vmreadl(vcpu, GUEST_RSP);
 		break;
 	case VCPU_REGS_RIP:
-		vcpu->arch.regs[VCPU_REGS_RIP] = vmcs_readl(GUEST_RIP);
+#ifdef CONFIG_INTEL_TDX_HOST
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
 		/*
 		 * When intercepting CR3 loads, e.g. for shadowing paging, KVM's
 		 * CR3 is loaded into hardware, not the guest's CR3.
 		 */
-		if (!(exec_controls_get(to_vmx(vcpu)) & CPU_BASED_CR3_LOAD_EXITING))
-			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
+		if ((!is_td_vcpu(vcpu) /* to use to_vmx() */ &&
+			(!(exec_controls_get(to_vmx(vcpu)) &
+				CPU_BASED_CR3_LOAD_EXITING))) ||
+			is_debug_td(vcpu))
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
@@ -387,173 +615,296 @@ void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 
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
 	vmx_enable_nmi_window(vcpu);
 }
 
 static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_enable_irq_window(vcpu);
 }
 
 static void vt_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_update_cr8_intercept(vcpu, tpr, irr);
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
 
 static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
+	if (is_td_vcpu(vcpu)) {
+		tdx_get_exit_info(vcpu, reason, info1, info2, intr_info,
+				error_code);
+		return;
+	}
+
 	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
 }
 
 static u64 vt_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
 	return vmx_get_l2_tsc_offset(vcpu);
 }
 
 static u64 vt_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
 	return vmx_get_l2_tsc_multiplier(vcpu);
 }
 
 static void vt_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
 	vmx_write_tsc_offset(vcpu, offset);
 }
 
 static void vt_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
 {
+	if (is_td_vcpu(vcpu)) {
+		if (kvm_scale_tsc(vcpu, tsc_khz, multiplier) !=
+		    vcpu->kvm->arch.initial_tsc_khz)
+			KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm);
+		return;
+	}
+
 	vmx_write_tsc_multiplier(vcpu, multiplier);
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
 
 static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
+	if (is_td_vcpu(vcpu))
+		return;
+
 	vmx_update_cpu_dirty_logging(vcpu);
 }
 
@@ -562,12 +913,16 @@ static int vt_pre_block(struct kvm_vcpu *vcpu)
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
@@ -577,17 +932,26 @@ static void vt_post_block(struct kvm_vcpu *vcpu)
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
 
@@ -730,6 +1094,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.mem_enc_op_dev = vt_mem_enc_op_dev,
+	.mem_enc_op = vt_mem_enc_op,
+	.mem_enc_op_vcpu = vt_mem_enc_op_vcpu,
 };
 
 static struct kvm_x86_init_ops vt_init_ops __initdata = {
@@ -746,6 +1114,9 @@ static int __init vt_init(void)
 	unsigned int vcpu_size = 0, vcpu_align = 0;
 	int r;
 
+	/* tdx_pre_kvm_init must be called before vmx_pre_kvm_init(). */
+	tdx_pre_kvm_init(&vcpu_size, &vcpu_align, &vt_x86_ops.vm_size);
+
 	vmx_pre_kvm_init(&vcpu_size, &vcpu_align);
 
 	r = kvm_init(&vt_init_ops, vcpu_size, vcpu_align, THIS_MODULE);
@@ -756,8 +1127,14 @@ static int __init vt_init(void)
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
index 5f81ef092bd4..d71808358feb 100644
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
+#ifdef CONFIG_INTEL_TDX_HOST
+	if (is_td_vcpu(vcpu))
+		return &(to_tdx(vcpu)->pi_desc);
+#endif
+
 	return &(to_vmx(vcpu)->pi_desc);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 31412ed8049f..39853a260e06 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -8,6 +8,7 @@
 #include "tdx_errno.h"
 #include "tdx_arch.h"
 #include "tdx_ops.h"
+#include "posted_intr.h"
 
 #ifdef CONFIG_INTEL_TDX_HOST
 
@@ -22,6 +23,51 @@ struct kvm_tdx {
 
 	struct tdx_td_page tdr;
 	struct tdx_td_page tdcs[TDX_NR_TDCX_PAGES];
+
+	u64 attributes;
+	u64 xfam;
+	int hkid;
+
+	int cpuid_nent;
+	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
+
+	bool finalized;
+	bool tdh_mem_track;
+
+	hpa_t source_pa;
+
+	u64 tsc_offset;
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
+		u64 bus_lock_detected	: 1;
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
@@ -29,6 +75,46 @@ struct vcpu_tdx {
 
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page tdvpx[TDX_NR_TDVPX_PAGES];
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
+
+	bool host_state_need_save;
+	bool host_state_need_restore;
+	u64 msr_host_kernel_gs_base;
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
+	struct tdx_cpuid_config cpuid_configs[TDX_MAX_NR_CPUID_CONFIGS];
 };
 
 static inline bool is_td(struct kvm *kvm)
@@ -56,6 +142,11 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 
+static inline bool is_td_vcpu_initialized(struct kvm_vcpu *vcpu)
+{
+	return to_tdx(vcpu)->initialized;
+}
+
 static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
@@ -84,6 +175,7 @@ static __always_inline void tdvps_gpr_check(u64 field, u8 bits)
 static __always_inline void tdvps_apic_check(u64 field, u8 bits) {}
 static __always_inline void tdvps_dr_check(u64 field, u8 bits) {}
 static __always_inline void tdvps_state_check(u64 field, u8 bits) {}
+static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
 static __always_inline void tdvps_msr_check(u64 field, u8 bits) {}
 static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
 
@@ -151,9 +243,30 @@ TDX_BUILD_TDVPS_ACCESSORS(64, APIC, apic);
 TDX_BUILD_TDVPS_ACCESSORS(64, GPR, gpr);
 TDX_BUILD_TDVPS_ACCESSORS(64, DR, dr);
 TDX_BUILD_TDVPS_ACCESSORS(64, STATE, state);
+TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
 TDX_BUILD_TDVPS_ACCESSORS(64, MSR, msr);
 TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
 
+static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
+{
+	struct tdx_ex_ret ex_ret;
+	u64 err;
+
+	err = tdh_mng_rd(kvm_tdx->tdr.pa, TDCS_EXEC(field), &ex_ret);
+	if (unlikely(err)) {
+		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
+		WARN_ON(1);
+		return 0;
+	}
+	return ex_ret.regs.r8;
+}
+
+static __always_inline int pg_level_to_tdx_sept_level(enum pg_level level)
+{
+	WARN_ON(level == PG_LEVEL_NONE);
+	return level - 1;
+}
+
 #else
 struct kvm_tdx;
 struct vcpu_tdx;
@@ -163,6 +276,7 @@ static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
 static inline bool is_debug_td(struct kvm_vcpu *vcpu) { return false; }
 static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm) { return NULL; }
 static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu) { return NULL; }
+static inline bool is_td_vcpu_initialized(struct kvm_vcpu *vcpu) { return false; }
 
 #endif /* CONFIG_INTEL_TDX_HOST */
 
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index f57f9bfb7007..7d1483a23714 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -54,11 +54,21 @@
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
 
 /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
+#define TDX_NON_ARCH			BIT_ULL(63)
 #define TDX_CLASS_SHIFT			56
 #define TDX_FIELD_MASK			GENMASK_ULL(31, 0)
 
-#define BUILD_TDX_FIELD(class, field)	\
-	(((u64)(class) << TDX_CLASS_SHIFT) | ((u64)(field) & TDX_FIELD_MASK))
+#define __BUILD_TDX_FIELD(non_arch, class, field)	\
+	(((non_arch) ? TDX_NON_ARCH : 0) |		\
+	 ((u64)(class) << TDX_CLASS_SHIFT) |		\
+	 ((u64)(field) & TDX_FIELD_MASK))
+
+#define BUILD_TDX_FIELD(class, field)			\
+	__BUILD_TDX_FIELD(false, (class), (field))
+
+#define BUILD_TDX_FIELD_NON_ARCH(class, field)		\
+	__BUILD_TDX_FIELD(true, (class), (field))
+
 
 /* @field is the VMCS field encoding */
 #define TDVPS_VMCS(field)		BUILD_TDX_FIELD(0, (field))
@@ -83,10 +93,20 @@ enum tdx_guest_other_state {
 	TD_VCPU_IWK_INTKEY0 = 68,
 	TD_VCPU_IWK_INTKEY1,
 	TD_VCPU_IWK_FLAGS = 70,
+	TD_VCPU_STATE_DETAILS_NON_ARCH = 0x100,
+};
+
+union tdx_vcpu_state_details {
+	struct {
+		u64 vmxip	: 1;
+		u64 reserved	: 63;
+	};
+	u64 full;
 };
 
 /* @field is any of enum tdx_guest_other_state */
 #define TDVPS_STATE(field)		BUILD_TDX_FIELD(17, (field))
+#define TDVPS_STATE_NON_ARCH(field)	BUILD_TDX_FIELD_NON_ARCH(17, field)
 
 /* @msr is the MSR index */
 #define TDVPS_MSR(msr)			BUILD_TDX_FIELD(19, (msr))
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 87ed67fd2715..f40c46eaff4c 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -8,36 +8,48 @@
 
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
+#include <asm/cacheflush.h>
 
 #include "seamcall.h"
+#include "tdx_arch.h"
 
 #ifdef CONFIG_INTEL_TDX_HOST
 
+static inline void tdx_clflush_page(hpa_t addr)
+{
+	clflush_cache_range(__va(addr), PAGE_SIZE);
+}
+
 static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
 {
+	tdx_clflush_page(addr);
 	return seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, 0, NULL);
 }
 
 static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
 			    struct tdx_ex_ret *ex)
 {
+	tdx_clflush_page(hpa);
 	return seamcall(TDH_MEM_PAGE_ADD, gpa, tdr, hpa, source, 0, ex);
 }
 
 static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 			    struct tdx_ex_ret *ex)
 {
+	tdx_clflush_page(page);
 	return seamcall(TDH_MEM_SEPT_ADD, gpa | level, tdr, page, 0, 0, ex);
 }
 
 static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
 {
+	tdx_clflush_page(addr);
 	return seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, 0, NULL);
 }
 
 static inline u64 tdh_mem_page_aug(hpa_t tdr, gpa_t gpa, hpa_t hpa,
 			    struct tdx_ex_ret *ex)
 {
+	tdx_clflush_page(hpa);
 	return seamcall(TDH_MEM_PAGE_AUG, gpa, tdr, hpa, 0, 0, ex);
 }
 
@@ -54,11 +66,13 @@ static inline u64 tdh_mng_key_config(hpa_t tdr)
 
 static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
 {
+	tdx_clflush_page(tdr);
 	return seamcall(TDH_MNG_CREATE, tdr, hkid, 0, 0, 0, NULL);
 }
 
 static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
 {
+	tdx_clflush_page(tdvpr);
 	return seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, 0, NULL);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx_stubs.c b/arch/x86/kvm/vmx/tdx_stubs.c
new file mode 100644
index 000000000000..5417d778e6c0
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_stubs.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kvm_host.h>
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
+int tdx_vm_init(struct kvm *kvm) { return 0; }
+void tdx_vm_teardown(struct kvm *kvm) {}
+void tdx_vm_destroy(struct kvm *kvm) {}
+int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return 0; }
+void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
+void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
+void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
+void tdx_hardware_enable(void) {}
+void tdx_hardware_disable(void) {}
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu) {}
+int tdx_handle_exit(struct kvm_vcpu *vcpu, enum exit_fastpath_completion fastpath) { return 0; }
+int tdx_dev_ioctl(void __user *argp) { return -EINVAL; }
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EINVAL; }
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EINVAL; }
+void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t pgd, int pgd_level) {}
+void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu) {}
+void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu) {}
+int tdx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector) { return -1; }
+
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
+		u64 *info2, u32 *intr_info, u32 *error_code)
+{
+}
+
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
+int __init tdx_check_processor_compatibility(void) { return 0; }
+void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
+			unsigned int *vcpu_align, unsigned int *vm_size)
+{
+}
+
+int __init tdx_init(void) { return 0; }
+void tdx_update_exception_bitmap(struct kvm_vcpu *vcpu) {}
+void tdx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val) {}
+int tdx_get_cpl(struct kvm_vcpu *vcpu) { return 0; }
+unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu) { return 0; }
+void tdx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags) {}
+bool tdx_is_emulated_msr(u32 index, bool write) { return false; }
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg) { return 0; }
+void tdx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg) {}
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 3a6461694fc2..79fa88b30f4d 100644
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
 
+#ifdef CONFIG_INTEL_TDX_HOST
+#define TDENTER 		0
+#define EXIT_REASON_TDCALL	77
+#define TDENTER_ERROR_BIT	63
+#include "seamcall.h"
+#endif
+
 .section .noinstr.text, "ax"
 
 /**
@@ -328,3 +336,141 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
 	pop %_ASM_BP
 	ret
 SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
+
+#ifdef CONFIG_INTEL_TDX_HOST
+
+.pushsection .noinstr.text, "ax"
+
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
+
+.popsection
+
+#endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f38e0d2e1b6..4b7d6fe63d58 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3752,45 +3752,6 @@ void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 	pt_update_intercept_for_msr(vcpu);
 }
 
-static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
-						     bool nested)
-{
-#ifdef CONFIG_SMP
-	int pi_vec = nested ? POSTED_INTR_NESTED_VECTOR : POSTED_INTR_VECTOR;
-
-	if (vcpu->mode == IN_GUEST_MODE) {
-		/*
-		 * The vector of interrupt to be delivered to vcpu had
-		 * been set in PIR before this function.
-		 *
-		 * Following cases will be reached in this block, and
-		 * we always send a notification event in all cases as
-		 * explained below.
-		 *
-		 * Case 1: vcpu keeps in non-root mode. Sending a
-		 * notification event posts the interrupt to vcpu.
-		 *
-		 * Case 2: vcpu exits to root mode and is still
-		 * runnable. PIR will be synced to vIRR before the
-		 * next vcpu entry. Sending a notification event in
-		 * this case has no effect, as vcpu is not in root
-		 * mode.
-		 *
-		 * Case 3: vcpu exits to root mode and is blocked.
-		 * vcpu_block() has already synced PIR to vIRR and
-		 * never blocks vcpu if vIRR is not cleared. Therefore,
-		 * a blocked vcpu here does not wait for any requested
-		 * interrupts in PIR, and sending a notification event
-		 * which has no effect is safe here.
-		 */
-
-		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
-		return true;
-	}
-#endif
-	return false;
-}
-
 static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 						int vector)
 {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index fec22bef05b7..3325dfa5bf52 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -114,10 +114,90 @@ int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
+static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
+						     bool nested)
+{
+#ifdef CONFIG_SMP
+	int pi_vec = nested ? POSTED_INTR_NESTED_VECTOR : POSTED_INTR_VECTOR;
 
+	if (vcpu->mode == IN_GUEST_MODE) {
+		/*
+		 * The vector of interrupt to be delivered to vcpu had
+		 * been set in PIR before this function.
+		 *
+		 * Following cases will be reached in this block, and
+		 * we always send a notification event in all cases as
+		 * explained below.
+		 *
+		 * Case 1: vcpu keeps in non-root mode. Sending a
+		 * notification event posts the interrupt to vcpu.
+		 *
+		 * Case 2: vcpu exits to root mode and is still
+		 * runnable. PIR will be synced to vIRR before the
+		 * next vcpu entry. Sending a notification event in
+		 * this case has no effect, as vcpu is not in root
+		 * mode.
+		 *
+		 * Case 3: vcpu exits to root mode and is blocked.
+		 * vcpu_block() has already synced PIR to vIRR and
+		 * never blocks vcpu if vIRR is not cleared. Therefore,
+		 * a blocked vcpu here does not wait for any requested
+		 * interrupts in PIR, and sending a notification event
+		 * which has no effect is safe here.
+		 */
+
+		apic->send_IPI_mask(get_cpu_mask(vcpu->cpu), pi_vec);
+		return true;
+	}
+#endif
+	return false;
+}
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 void __init vmx_pre_kvm_init(unsigned int *vcpu_size, unsigned int *vcpu_align);
 int __init vmx_init(void);
 void vmx_exit(void);
 void vmx_post_kvm_exit(void);
 
+int tdx_vm_init(struct kvm *kvm);
+void tdx_vm_teardown(struct kvm *kvm);
+void tdx_vm_destroy(struct kvm *kvm);
+int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_free(struct kvm_vcpu *vcpu);
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+void tdx_inject_nmi(struct kvm_vcpu *vcpu);
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
+void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void tdx_vcpu_put(struct kvm_vcpu *vcpu);
+void tdx_hardware_enable(void);
+void tdx_hardware_disable(void);
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu);
+int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath);
+int tdx_dev_ioctl(void __user *argp);
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
+void tdx_flush_tlb(struct kvm_vcpu *vcpu);
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t pgd, int pgd_level);
+void tdx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
+void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
+int tdx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector);
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+int __init tdx_check_processor_compatibility(void);
+void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
+			unsigned int *vcpu_align, unsigned int *vm_size);
+int __init tdx_init(void);
+void tdx_update_exception_bitmap(struct kvm_vcpu *vcpu);
+void tdx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
+int tdx_get_cpl(struct kvm_vcpu *vcpu);
+unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu);
+void tdx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
+bool tdx_is_emulated_msr(u32 index, bool write);
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
+void tdx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 447f0d5b53c7..da75530d75e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -292,6 +292,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 };
 
 u64 __read_mostly host_xcr0;
+EXPORT_SYMBOL_GPL(host_xcr0);
 u64 __read_mostly supported_xcr0;
 EXPORT_SYMBOL_GPL(supported_xcr0);
 
@@ -2265,9 +2266,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 	u64 ratio;
 
 	/* Guest TSC same frequency as host TSC? */
-	if (!scale || vcpu->kvm->arch.tsc_immutable) {
-		if (scale)
-			pr_warn_ratelimited("Guest TSC immutable, scaling not supported\n");
+	if (!scale) {
 		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
 		return 0;
 	}
@@ -10740,7 +10739,8 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 {
 	int ret;
 
-	if (vcpu->arch.guest_state_protected)
+	if (vcpu->arch.guest_state_protected ||
+	    vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM)
 		return -EINVAL;
 
 	vcpu_load(vcpu);
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 96b0064cff5c..16dd7bf57ac9 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -508,4 +508,55 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_SEV_ES_VM	1
 #define KVM_X86_TDX_VM		2
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
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
2.25.1

