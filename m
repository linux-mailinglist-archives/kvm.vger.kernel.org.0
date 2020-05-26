Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1D21BD42D
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 07:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgD2Fq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 01:46:57 -0400
Received: from mx137-tc.baidu.com ([61.135.168.137]:43907 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725798AbgD2Fq5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 01:46:57 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 044A211C0069;
        Wed, 29 Apr 2020 13:46:37 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        joro@8bytes.org, jmattson@google.com, wanpengli@tencent.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: [PATCH][v2] kvm: x86: emulate APERF/MPERF registers
Date:   Wed, 29 Apr 2020 13:46:36 +0800
Message-Id: <1588139196-23802-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest kernel reports a fixed cpu frequency in /proc/cpuinfo,
this is confused to user when turbo is enable, and aperf/mperf
can be used to show current cpu frequency after 7d5905dc14a
"(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
so we should emulate aperf mperf to achieve it

the period of aperf/mperf in guest mode are accumulated as
emulated value, and add per-VM knod to enable emulate mperfaperf

diff v1:
1. support AMD
2. support per-vm capability to enable

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Chai Wen <chaiwen@baidu.com>
Signed-off-by: Jia Lina <jialina01@baidu.com>
---
 Documentation/virt/kvm/api.rst  |  7 +++++++
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/cpuid.c            | 13 ++++++++++++-
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx/vmx.c          |  6 ++++++
 arch/x86/kvm/x86.c              | 37 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |  6 ++++++
 include/uapi/linux/kvm.h        |  1 +
 8 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b..dc4b4036e5d2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6109,3 +6109,10 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+8.23 KVM_CAP_MPERFAPERF
+----------------------------
+
+:Architectures: x86
+
+This capability indicates that KVM supports APERF and MPERF MSR registers
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..58fd3254804f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -820,6 +820,9 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	u64 v_mperf;
+	u64 v_aperf;
 };
 
 struct kvm_lpage_info {
@@ -979,6 +982,7 @@ struct kvm_arch {
 
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
+	bool guest_has_mperfaperf;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..3bdd907981b5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -124,6 +124,14 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 
+	best = kvm_find_cpuid_entry(vcpu, 6, 0);
+	if (best) {
+		if (guest_has_mperfaperf(vcpu->kvm) &&
+			boot_cpu_has(X86_FEATURE_APERFMPERF))
+			best->ecx |= 1;
+		else
+			best->ecx &= ~1;
+	}
 	/* Update physical-address width */
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	kvm_mmu_reset_context(vcpu);
@@ -558,7 +566,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 851e9cc79930..1d157a8dba46 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4310,6 +4310,12 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_F10H_DECFG:
 		msr_info->data = svm->msr_decfg;
 		break;
+	case MSR_IA32_MPERF:
+		msr_info->data = vcpu->arch.v_mperf;
+		break;
+	case MSR_IA32_APERF:
+		msr_info->data = vcpu->arch.v_aperf;
+		break;
 	default:
 		return kvm_get_msr_common(vcpu, msr_info);
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 91749f1254e8..b05e276e262b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1914,6 +1914,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
 			return 1;
 		goto find_shared_msr;
+	case MSR_IA32_MPERF:
+		msr_info->data = vcpu->arch.v_mperf;
+		break;
+	case MSR_IA32_APERF:
+		msr_info->data = vcpu->arch.v_aperf;
+		break;
 	default:
 	find_shared_msr:
 		msr = find_msr_entry(vmx, msr_info->index);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8124b562dea..38deb11b1544 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3435,6 +3435,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_enable_evmcs != NULL;
 		break;
+	case KVM_CAP_MPERFAPERF:
+		r = boot_cpu_has(X86_FEATURE_APERFMPERF) ? 1 : 0;
+		break;
 	default:
 		break;
 	}
@@ -4883,6 +4886,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_MPERFAPERF:
+		kvm->arch.guest_has_mperfaperf =
+			boot_cpu_has(X86_FEATURE_APERFMPERF) ? cap->args[0] : 0;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -8163,6 +8171,25 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
+
+static void guest_enter_mperfaperf(u64 *mperf, u64 *aperf)
+{
+	rdmsrl(MSR_IA32_MPERF, *mperf);
+	rdmsrl(MSR_IA32_APERF, *aperf);
+}
+
+static void guest_exit_mperfaperf(struct kvm_vcpu *vcpu,
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
@@ -8176,7 +8203,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_cpu_accept_dm_intr(vcpu);
 	enum exit_fastpath_completion exit_fastpath = EXIT_FASTPATH_NONE;
 
+	bool enable_mperfaperf = guest_has_mperfaperf(vcpu->kvm);
 	bool req_immediate_exit = false;
+	u64 mperf, aperf;
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
@@ -8326,6 +8355,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
+	mperf = aperf = 0;
+	if (unlikely(enable_mperfaperf))
+		guest_enter_mperfaperf(&mperf, &aperf);
+
 	kvm_x86_ops.prepare_guest_switch(vcpu);
 
 	/*
@@ -8449,6 +8482,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	local_irq_enable();
+
+	if (unlikely(enable_mperfaperf) && mperf)
+		guest_exit_mperfaperf(vcpu, mperf, aperf);
+
 	preempt_enable();
 
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b968acc0516f..69b66ed8d82a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -355,6 +355,12 @@ static inline bool kvm_dr7_valid(u64 data)
 	return !(data >> 32);
 }
 
+
+static inline bool guest_has_mperfaperf(struct kvm *kvm)
+{
+	return kvm->arch.guest_has_mperfaperf;
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b..1f9abdf0d1a9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_MPERFAPERF 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.16.2

