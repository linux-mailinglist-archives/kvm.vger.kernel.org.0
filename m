Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11C126403B
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 10:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgIJIko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 04:40:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:49004 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729911AbgIJIfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 04:35:50 -0400
IronPort-SDR: FwFjbfr3nm/6qI/dztIV318i8h3ztAt64af6eLHmkkF/qt2qyNAsmT+CBTXHkxD/h3Y7UOF9Gx
 eg8YxAxOsy9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="222691441"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="222691441"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 01:35:49 -0700
IronPort-SDR: yMANbFdTVbqHN4EGmgPs1W0d40cQTvrKRwdkK7Q0JXLhDxBE8c0fyqje0Hrb/Am2lh3mdlQ9gX
 8UkPXz+nOupQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="329255947"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga004.fm.intel.com with ESMTP; 10 Sep 2020 01:35:46 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v3 2/2] KVM: VMX: Enable bus lock VM exit
Date:   Thu, 10 Sep 2020 16:37:51 +0800
Message-Id: <20200910083751.26686-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910083751.26686-1-chenyi.qiang@intel.com>
References: <20200910083751.26686-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Virtual Machine can exploit bus locks to degrade the performance of
system. Bus lock can be caused by split locked access to writeback(WB)
memory or by using locks on uncacheable(UC) memory. The bus lock is
typically >1000 cycles slower than an atomic operation within a cache
line. It also disrupts performance on other cores (which must wait for
the bus lock to be released before their memory operations can
complete).

To address the threat, bus lock VM exit is introduced to notify the VMM
when a bus lock was acquired, allowing it to enforce throttling or other
policy based mitigations.

A VMM can enable VM exit due to bus locks by setting a new "Bus Lock
Detection" VM-execution control(bit 30 of Secondary Processor-based VM
execution controls). If delivery of this VM exit was preempted by a
higher priority VM exit (e.g. EPT misconfiguration, EPT violation, APIC
access VM exit, APIC write VM exit, exception bitmap exiting), bit 26 of
exit reason in vmcs field is set to 1.

In current implementation, the KVM exposes this capability through
KVM_CAP_X86_BUS_LOCK_EXIT. The user can get the supported mode bitmap
(i.e. off and exit) and enable it explicitly (disabled by default). If
bus locks in guest are detected by KVM, exit to user space even when
current exit reason is handled by KVM internally. Set a new field
KVM_RUN_BUS_LOCK in vcpu->run->flags to inform the user space that there
is a bus lock in guest and it is preempted by a higher prioriy VM exit.

Document for Bus Lock VM exit is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h    |  5 ++++
 arch/x86/include/asm/vmx.h         |  1 +
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 ++-
 arch/x86/kvm/vmx/capabilities.h    |  6 +++++
 arch/x86/kvm/vmx/vmx.c             | 42 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             |  2 +-
 arch/x86/kvm/x86.c                 | 27 ++++++++++++++++++-
 arch/x86/kvm/x86.h                 |  5 ++++
 include/uapi/linux/kvm.h           |  7 +++++
 11 files changed, 96 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5303dbc5c9bc..8059b8b21ecd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -961,6 +961,9 @@ struct kvm_arch {
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
 
+	/* Set when bus lock vm exit is enabled by user */
+	bool bus_lock_exit;
+
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 };
@@ -1347,6 +1350,8 @@ extern u8   kvm_tsc_scaling_ratio_frac_bits;
 extern u64  kvm_max_tsc_scaling_ratio;
 /* 1ull << kvm_tsc_scaling_ratio_frac_bits */
 extern u64  kvm_default_tsc_scaling_ratio;
+/* bus lock detection supported */
+extern bool kvm_has_bus_lock_exit;
 
 extern u64 kvm_mce_cap_supported;
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cd7de4b401fe..93a880bc31a7 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -73,6 +73,7 @@
 #define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
 #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
 #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
+#define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
 
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index 9915990fd8cf..e80523346274 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -83,5 +83,6 @@
 #define VMX_FEATURE_TSC_SCALING		( 2*32+ 25) /* Scale hardware TSC when read in guest */
 #define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* Enable TPAUSE, UMONITOR, UMWAIT in guest */
 #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
+#define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* VM-Exit when bus lock caused */
 
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0780f97c1850..a1471c05f7f9 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -111,6 +111,7 @@ struct kvm_ioapic_state {
 #define KVM_NR_IRQCHIPS          3
 
 #define KVM_RUN_X86_SMM		 (1 << 0)
+#define KVM_RUN_BUS_LOCK         (1 << 1)
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index b8ff9e8ac0d5..14c177c4afd5 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -88,6 +88,7 @@
 #define EXIT_REASON_XRSTORS             64
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
+#define EXIT_REASON_BUS_LOCK            74
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -148,7 +149,8 @@
 	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
 	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
-	{ EXIT_REASON_TPAUSE,                "TPAUSE" }
+	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
+	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4bbd8b448d22..aa94535e6705 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -262,6 +262,12 @@ static inline bool cpu_has_vmx_tsc_scaling(void)
 		SECONDARY_EXEC_TSC_SCALING;
 }
 
+static inline bool cpu_has_vmx_bus_lock_detection(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+	    SECONDARY_EXEC_BUS_LOCK_DETECTION;
+}
+
 static inline bool cpu_has_vmx_apicv(void)
 {
 	return cpu_has_vmx_apic_register_virt() &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index adc59cf9036d..5dbfee639375 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2461,7 +2461,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
-			SECONDARY_EXEC_ENABLE_VMFUNC;
+			SECONDARY_EXEC_ENABLE_VMFUNC |
+			SECONDARY_EXEC_BUS_LOCK_DETECTION;
 		if (cpu_has_sgx())
 			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
 		if (adjust_vmx_controls(min2, opt2,
@@ -4244,6 +4245,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
+	if (!kvm_bus_lock_exit_enabled(vmx->vcpu.kvm))
+		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
+
 	vmx->secondary_exec_control = exec_control;
 }
 
@@ -5685,6 +5689,14 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_bus_lock(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *kvm_run = vcpu->run;
+
+	kvm_run->exit_reason = KVM_EXIT_BUS_LOCK;
+	return 0;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5741,6 +5753,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
+	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -5979,7 +5992,7 @@ void dump_vmcs(void)
  * The guest has exited.  See if we can fix it or if we need userspace
  * assistance.
  */
-static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	union vmx_exit_reason exit_reason = vmx->exit_reason;
@@ -6131,6 +6144,28 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return 0;
 }
 
+static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
+
+	/*
+	 * Even when current exit reason is handled by KVM
+	 * internally, we still needs to exit to user space
+	 * when bus lock detected to inform that there is a
+	 * bus lock in guest.
+	 */
+	if (vmx->exit_reason.bus_lock_detected) {
+		if (ret > 0)
+			vcpu->run->exit_reason = KVM_EXIT_BUS_LOCK;
+		else
+			vcpu->run->flags |= KVM_RUN_BUS_LOCK;
+		return 0;
+	}
+	vcpu->run->flags &= ~KVM_RUN_BUS_LOCK;
+	return ret;
+}
+
 /*
  * Software based L1D cache flush which is used when microcode providing
  * the cache control MSR is not loaded.
@@ -8097,6 +8132,9 @@ static __init int hardware_setup(void)
 		kvm_tsc_scaling_ratio_frac_bits = 48;
 	}
 
+	if (cpu_has_vmx_bus_lock_detection())
+		kvm_has_bus_lock_exit = true;
+
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
 	if (enable_ept)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8bf97a81affd..779ea3b15134 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -105,7 +105,7 @@ union vmx_exit_reason {
 		u32	reserved23		: 1;
 		u32	reserved24		: 1;
 		u32	reserved25		: 1;
-		u32	reserved26		: 1;
+		u32	bus_lock_detected	: 1;
 		u32	enclave_mode		: 1;
 		u32	smi_pending_mtf		: 1;
 		u32	smi_from_vmx_root	: 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d39d6cf1d473..d96619ce7f66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -134,6 +134,8 @@ u64  __read_mostly kvm_max_tsc_scaling_ratio;
 EXPORT_SYMBOL_GPL(kvm_max_tsc_scaling_ratio);
 u64 __read_mostly kvm_default_tsc_scaling_ratio;
 EXPORT_SYMBOL_GPL(kvm_default_tsc_scaling_ratio);
+bool __read_mostly kvm_has_bus_lock_exit;
+EXPORT_SYMBOL_GPL(kvm_has_bus_lock_exit);
 
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
 static u32 __read_mostly tsc_tolerance_ppm = 250;
@@ -3578,6 +3580,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SMALLER_MAXPHYADDR:
 		r = (int) allow_smaller_maxphyaddr;
 		break;
+	case KVM_CAP_X86_BUS_LOCK_EXIT:
+		r |= KVM_BUS_LOCK_DETECTION_OFF;
+		if (kvm_has_bus_lock_exit)
+			r |= KVM_BUS_LOCK_DETECTION_EXIT;
+		break;
 	default:
 		break;
 	}
@@ -5030,6 +5037,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_BUS_LOCK_EXIT:
+		r = -EINVAL;
+		if (cap->args[0] & ~KVM_BUS_LOCK_DETECTION_VALID_MODE)
+			break;
+
+		if ((cap->args[0] & KVM_BUS_LOCK_DETECTION_OFF) &&
+		    (cap->args[0] & KVM_BUS_LOCK_DETECTION_EXIT))
+			break;
+
+		if (kvm_has_bus_lock_exit &&
+		    cap->args[0] & KVM_BUS_LOCK_DETECTION_EXIT)
+			kvm->arch.bus_lock_exit = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -7772,12 +7793,16 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 
 	kvm_run->if_flag = (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
-	kvm_run->flags = is_smm(vcpu) ? KVM_RUN_X86_SMM : 0;
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
 	kvm_run->ready_for_interrupt_injection =
 		pic_in_kernel(vcpu->kvm) ||
 		kvm_vcpu_ready_for_interrupt_injection(vcpu);
+
+	if (is_smm(vcpu))
+		kvm_run->flags |= KVM_RUN_X86_SMM;
+	else
+		kvm_run->flags &= ~KVM_RUN_X86_SMM;
 }
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 995ab696dcf0..54aa7712cb52 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -335,6 +335,11 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
+static inline bool kvm_bus_lock_exit_enabled(struct kvm *kvm)
+{
+	return kvm->arch.bus_lock_exit;
+}
+
 DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
 
 static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6d86033c4fa..3f0176733622 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -248,6 +248,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_BUS_LOCK         29
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -1035,6 +1036,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_X86_BUS_LOCK_EXIT 187
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1689,4 +1691,9 @@ struct kvm_hyperv_eventfd {
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
+#define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
+#define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
+#define KVM_BUS_LOCK_DETECTION_VALID_MODE      (KVM_BUS_LOCK_DETECTION_OFF | \
+						KVM_BUS_LOCK_DETECTION_EXIT)
+
 #endif /* __LINUX_KVM_H */
-- 
2.17.1

