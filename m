Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259D81F157B
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 11:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgFHJeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 05:34:36 -0400
Received: from mx57.baidu.com ([61.135.168.57]:37536 "EHLO
        tc-sys-mailedm05.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729156AbgFHJef (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 05:34:35 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id 9C1AF1EBA001;
        Mon,  8 Jun 2020 17:34:18 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        jmattson@google.com, wanpengli@tencent.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, lirongqing@baidu.com, wei.huang2@amd.com
Subject: [PATCH][v7] KVM: X86: support APERF/MPERF registers
Date:   Mon,  8 Jun 2020 17:34:18 +0800
Message-Id: <1591608858-10935-1-git-send-email-lirongqing@baidu.com>
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

Pass-though: it is only suitable for pinned vcpu

And a per-VM capability is added to configure aperfmperf mode

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Chai Wen <chaiwen@baidu.com>
Signed-off-by: Jia Lina <jialina01@baidu.com>
---
diff v6:
drop the unneed check from kvm_update_cpuid and __do_cpuid_func
add the validation check in kvm_vm_ioctl_enable_cap
thank for Jim Mattson,  Paolo Bonzini and Xiaoyao Li

diff v5:
return error if guest is configured with aperf/mperf, but host cpu has not

diff v4:
fix maybe-uninitialized warning

diff v3:
fix interception of MSR_IA32_APERF/MPERF in svm
thanks for wei.huang2 

diff v2:
support aperfmperf pass though
move common codes to kvm_get_msr_common
thanks for Xiaoyao Li and Peter Zijlstra

diff v1:
1. support AMD, but not test
2. support per-vm capability to enable
Documentation/virt/kvm/api.rst  | 16 ++++++++++++
 arch/x86/include/asm/kvm_host.h | 11 ++++++++
 arch/x86/kvm/svm/svm.c          |  8 ++++++
 arch/x86/kvm/vmx/vmx.c          |  6 +++++
 arch/x86/kvm/x86.c              | 56 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              | 15 +++++++++++
 include/uapi/linux/kvm.h        |  1 +
 7 files changed, 113 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 426f94582b7a..ae30ac02a771 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6150,3 +6150,19 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+8.23 KVM_CAP_APERFMPERF
+----------------------------
+
+:Architectures: x86
+:Parameters: args[0] is aperfmperf mode;
+             0 for not support, it is default mode
+             1 for software emulation
+             2 for pass-through which is only suitable for pinned vcpu
+:Returns: 0 on success, -EINVAL when args[0] contains invalid,
+           -EBUSY if vcpus has been created
+
+Enabling this capability on a VM provides guest with aperf/mperf
+register, which are used to get cpu running frequency currently
+
+Do not enable KVM_CAP_APERFMPERF if host does not support aperf/mperf
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1da5858501ca..7d1d3668c4f1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -829,6 +829,9 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	u64 v_mperf;
+	u64 v_aperf;
 };
 
 struct kvm_lpage_info {
@@ -907,6 +910,12 @@ enum kvm_irqchip_mode {
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
@@ -1004,6 +1013,8 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+
+	enum kvm_aperfmperf_mode aperfmperf_mode;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9e333b91ff78..0db7d866e09f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1198,6 +1198,14 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
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
index 170cc76a581f..952e3728ca86 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6914,6 +6914,12 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
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
index 9e41b5135340..84884f4778cb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3324,6 +3324,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
 			return kvm_pmu_get_msr(vcpu, msr_info);
@@ -3534,6 +3540,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
 		break;
+	case KVM_CAP_APERFMPERF:
+		r = boot_cpu_has(X86_FEATURE_APERFMPERF) ? 1 : 0;
+		break;
 	default:
 		break;
 	}
@@ -4985,6 +4994,25 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_APERFMPERF:
+		r = 0;
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus)
+			r = -EBUSY;
+		if (r)
+			goto aperfmperf_unlock;
+
+		r = -EINVAL;
+		if (cap->args[0] > KVM_APERFMPERF_PT)
+			goto aperfmperf_unlock;
+		if (cap->args[0] != KVM_APERFMPERF_NONE
+				&& !boot_cpu_has(X86_FEATURE_APERFMPERF))
+			goto aperfmperf_unlock;
+		r = 0;
+		kvm->arch.aperfmperf_mode = cap->args[0];
+aperfmperf_unlock:
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -8311,6 +8339,25 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
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
@@ -8324,6 +8371,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
 
+	bool enable_aperfmperf = guest_aperfmperf_soft(vcpu->kvm);
+	u64 uninitialized_var(mperf), uninitialized_var(aperf);
 	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
@@ -8462,6 +8511,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
+	if (unlikely(enable_aperfmperf))
+		guest_enter_aperfmperf(&mperf, &aperf);
+
 	kvm_x86_ops.prepare_guest_switch(vcpu);
 
 	/*
@@ -8583,6 +8635,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
index 4fdf30316582..c240941d7821 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_APERFMPERF 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.16.2

