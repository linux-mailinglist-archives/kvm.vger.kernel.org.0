Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D281E8DDA
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 06:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgE3EgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 00:36:19 -0400
Received: from mx140-tc.baidu.com ([61.135.168.140]:54397 "EHLO
        tc-sys-mailedm03.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725776AbgE3EgS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 30 May 2020 00:36:18 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm03.tc.baidu.com (Postfix) with ESMTP id 0EC444500032;
        Sat, 30 May 2020 12:35:53 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        jmattson@google.com, wanpengli@tencent.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, wei.huang2@amd.com, lirongqing@baidu.com
Subject: [PATCH][v5] KVM: X86: support APERF/MPERF registers
Date:   Sat, 30 May 2020 12:35:53 +0800
Message-Id: <1590813353-11775-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest kernel reports a fixed cpu frequency in /proc/cpuinfo,
this is confused to user when turbo is enable, and aperf/mperf
can be used to show current cpu frequency after 7d5905dc14a
"(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
so guest should support aperf/mperf capability

This patch implements aperf/mperf by three mode: none, software
emulation, and pass-through

None: default mode, guest does not support aperf/mperf

Software emulation: the period of aperf/mperf in guest mode are
accumulated as emulated value

Pass-though: it is only suitable for KVM_HINTS_REALTIME, Because
that hint guarantees we have a 1:1 vCPU:CPU binding and guaranteed
no over-commit.

And a per-VM capability is added to configure aperfmperf mode

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Chai Wen <chaiwen@baidu.com>
Signed-off-by: Jia Lina <jialina01@baidu.com>
---
diff v4:
fix maybe-uninitialized warning

diff v3:
fix interception of MSR_IA32_MPERF/APERF in svm

diff v2:
support aperfmperf pass though
move common codes to kvm_get_msr_common

diff v1:
1. support AMD, but not test
2. support per-vm capability to enable

 Documentation/virt/kvm/api.rst  | 10 ++++++++++
 arch/x86/include/asm/kvm_host.h | 11 +++++++++++
 arch/x86/kvm/cpuid.c            | 13 ++++++++++++-
 arch/x86/kvm/svm/svm.c          |  8 ++++++++
 arch/x86/kvm/vmx/vmx.c          |  6 ++++++
 arch/x86/kvm/x86.c              | 42 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              | 15 +++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 8 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d871dacb984e..f854f4da6fd8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6126,3 +6126,13 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+8.23 KVM_CAP_APERFMPERF
+----------------------------
+
+:Architectures: x86
+:Parameters: args[0] is aperfmperf mode;
+             0 for not support, 1 for software emulation, 2 for pass-through
+:Returns: 0 on success; -1 on error
+
+This capability indicates that KVM supports APERF and MPERF MSR registers
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fd78bd44b2d6..14643f8af9c4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -824,6 +824,9 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	u64 v_mperf;
+	u64 v_aperf;
 };
 
 struct kvm_lpage_info {
@@ -889,6 +892,12 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
 
+enum kvm_aperfmperf_mode {
+	KVM_APERFMPERF_NONE,
+	KVM_APERFMPERF_SOFT,      /* software emulate aperfmperf */
+	KVM_APERFMPERF_PT,        /* pass-through aperfmperf to guest */
+};
+
 #define APICV_INHIBIT_REASON_DISABLE    0
 #define APICV_INHIBIT_REASON_HYPERV     1
 #define APICV_INHIBIT_REASON_NESTED     2
@@ -986,6 +995,8 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+
+	enum kvm_aperfmperf_mode aperfmperf_mode;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cd708b0b460a..c960dda4251b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -122,6 +122,14 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 
+	best = kvm_find_cpuid_entry(vcpu, 6, 0);
+	if (best) {
+		if (guest_has_aperfmperf(vcpu->kvm) &&
+			boot_cpu_has(X86_FEATURE_APERFMPERF))
+			best->ecx |= 1;
+		else
+			best->ecx &= ~1;
+	}
 	/* Note, maxphyaddr must be updated before tdp_level. */
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
@@ -557,7 +565,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 6: /* Thermal management */
 		entry->eax = 0x4; /* allow ARAT */
 		entry->ebx = 0;
-		entry->ecx = 0;
+		if (boot_cpu_has(X86_FEATURE_APERFMPERF))
+			entry->ecx = 0x1;
+		else
+			entry->ecx = 0x0;
 		entry->edx = 0;
 		break;
 	/* function 7 has additional index. */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e9c0fb68387d..1d38fe3afc0d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1200,6 +1200,14 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm->msrpm = page_address(msrpm_pages);
 	svm_vcpu_init_msrpm(svm->msrpm);
 
+	if (guest_aperfmperf_soft(vcpu->kvm)) {
+		set_msr_interception(svm->msrpm, MSR_IA32_MPERF, 0, 0);
+		set_msr_interception(svm->msrpm, MSR_IA32_APERF, 0, 0);
+	} else if (guest_aperfmperf_pt(vcpu->kvm)) {
+		set_msr_interception(svm->msrpm, MSR_IA32_MPERF, 1, 0);
+		set_msr_interception(svm->msrpm, MSR_IA32_APERF, 1, 0);
+	}
+
 	svm->nested.msrpm = page_address(nested_msrpm_pages);
 	svm_vcpu_init_msrpm(svm->nested.msrpm);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ea5a225a579..18d02e95db04 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6916,6 +6916,12 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
 	}
+
+	if (guest_aperfmperf_pt(vcpu->kvm)) {
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_MPERF, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_APERF, MSR_TYPE_R);
+	}
+
 	vmx->msr_bitmap_mode = 0;
 
 	vmx->loaded_vmcs = &vmx->vmcs01;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ac69c16f153..de6406d51722 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3271,6 +3271,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_K7_HWCR:
 		msr_info->data = vcpu->arch.msr_hwcr;
 		break;
+	case MSR_IA32_MPERF:
+		msr_info->data = vcpu->arch.v_mperf;
+		break;
+	case MSR_IA32_APERF:
+		msr_info->data = vcpu->arch.v_aperf;
+		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info->index, &msr_info->data);
@@ -3480,6 +3486,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
 		break;
+	case KVM_CAP_APERFMPERF:
+		r = boot_cpu_has(X86_FEATURE_APERFMPERF) ? 1 : 0;
+		break;
 	default:
 		break;
 	}
@@ -4930,6 +4939,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_APERFMPERF:
+		kvm->arch.aperfmperf_mode =
+			boot_cpu_has(X86_FEATURE_APERFMPERF) ? cap->args[0] : 0;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -8217,6 +8231,25 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
+
+static void guest_enter_aperfmperf(u64 *mperf, u64 *aperf)
+{
+	rdmsrl(MSR_IA32_MPERF, *mperf);
+	rdmsrl(MSR_IA32_APERF, *aperf);
+}
+
+static void guest_exit_aperfmperf(struct kvm_vcpu *vcpu,
+		u64 mperf, u64 aperf)
+{
+	u64 perf;
+
+	rdmsrl(MSR_IA32_MPERF, perf);
+	vcpu->arch.v_mperf += perf - mperf;
+
+	rdmsrl(MSR_IA32_APERF, perf);
+	vcpu->arch.v_aperf += perf - aperf;
+}
+
 /*
  * Returns 1 to let vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -8230,6 +8263,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
 
+	bool enable_aperfmperf = guest_aperfmperf_soft(vcpu->kvm);
+	u64 uninitialized_var(mperf), uninitialized_var(aperf);
 	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
@@ -8393,6 +8428,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
+	if (unlikely(enable_aperfmperf))
+		guest_enter_aperfmperf(&mperf, &aperf);
+
 	kvm_x86_ops.prepare_guest_switch(vcpu);
 
 	/*
@@ -8514,6 +8552,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	local_irq_enable();
+
+	if (unlikely(enable_aperfmperf))
+		guest_exit_aperfmperf(vcpu, mperf, aperf);
+
 	preempt_enable();
 
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6eb62e97e59f..8216f697c53c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -361,6 +361,21 @@ static inline bool kvm_dr7_valid(u64 data)
 	return !(data >> 32);
 }
 
+static inline bool guest_has_aperfmperf(struct kvm *kvm)
+{
+	return kvm->arch.aperfmperf_mode != KVM_APERFMPERF_NONE;
+}
+
+static inline bool guest_aperfmperf_soft(struct kvm *kvm)
+{
+	return kvm->arch.aperfmperf_mode == KVM_APERFMPERF_SOFT;
+}
+
+static inline bool guest_aperfmperf_pt(struct kvm *kvm)
+{
+	return kvm->arch.aperfmperf_mode == KVM_APERFMPERF_PT;
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac9eba0289d1..57285a53078d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1018,6 +1018,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
+#define KVM_CAP_APERFMPERF 183
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.16.2

