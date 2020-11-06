Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6206E2A91F1
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 10:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgKFJBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 04:01:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:4564 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgKFJBF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 04:01:05 -0500
IronPort-SDR: oU8ejvkKaAkBVOMTPAzc/7Ofm35/jrqxav1gVGfBpYoaerrHxOe9ZESSWJez/7iC2XUIbZDfiU
 qVI53duhDaqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="169670253"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="169670253"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:01:04 -0800
IronPort-SDR: 5MLRBveabe/ekHuyab3gDLIGFb2CcH0tvF4j7ZQCAY4sfM40UpSlM0o3tvJF/FpPpl1I96K0z0
 GSsUEkUjps1w==
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="472000367"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:01:01 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/4] KVM: VMX: Enable bus lock VM exit
Date:   Fri,  6 Nov 2020 17:03:14 +0800
Message-Id: <20201106090315.18606-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106090315.18606-1-chenyi.qiang@intel.com>
References: <20201106090315.18606-1-chenyi.qiang@intel.com>
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
is a bus lock detected in guest.

Document for Bus Lock VM exit is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h    |  7 ++++++
 arch/x86/include/asm/vmx.h         |  1 +
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 +++-
 arch/x86/kvm/vmx/capabilities.h    |  6 +++++
 arch/x86/kvm/vmx/vmx.c             | 37 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h             |  2 +-
 arch/x86/kvm/x86.c                 | 23 +++++++++++++++++++
 include/uapi/linux/kvm.h           |  5 ++++
 10 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d44858b69353..df3d5e8438f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -52,6 +52,9 @@
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 					KVM_DIRTY_LOG_INITIALLY_SET)
 
+#define KVM_BUS_LOCK_DETECTION_VALID_MODE	(KVM_BUS_LOCK_DETECTION_OFF | \
+						 KVM_BUS_LOCK_DETECTION_EXIT)
+
 /* x86-specific vcpu->requests bit members */
 #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
 #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
@@ -993,6 +996,8 @@ struct kvm_arch {
 		struct msr_bitmap_range ranges[16];
 	} msr_filter;
 
+	bool bus_lock_detection_enabled;
+
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 
@@ -1399,6 +1404,8 @@ extern u8   kvm_tsc_scaling_ratio_frac_bits;
 extern u64  kvm_max_tsc_scaling_ratio;
 /* 1ull << kvm_tsc_scaling_ratio_frac_bits */
 extern u64  kvm_default_tsc_scaling_ratio;
+/* bus lock detection supported? */
+extern bool kvm_has_bus_lock_exit;
 
 extern u64 kvm_mce_cap_supported;
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f8ba5289ecb0..0ee2c1967a9f 100644
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
index 89e5f3d1bba8..ebab18e132f1 100644
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
index 3a1861403d73..5366ccdd134c 100644
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
index 177141b756ea..6068a85e5255 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2429,7 +2429,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
-			SECONDARY_EXEC_ENABLE_VMFUNC;
+			SECONDARY_EXEC_ENABLE_VMFUNC |
+			SECONDARY_EXEC_BUS_LOCK_DETECTION;
 		if (cpu_has_sgx())
 			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
 		if (adjust_vmx_controls(min2, opt2,
@@ -4272,6 +4273,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	vmx_adjust_sec_exec_control(vmx, &exec_control, waitpkg, WAITPKG,
 				    ENABLE_USR_WAIT_PAUSE, false);
 
+	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
+		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
+
 	vmx->secondary_exec_control = exec_control;
 }
 
@@ -5620,6 +5624,13 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_bus_lock(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = KVM_EXIT_BUS_LOCK;
+	vcpu->run->flags |= KVM_RUN_BUS_LOCK;
+	return 0;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5676,6 +5687,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
+	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -5928,7 +5940,7 @@ void dump_vmcs(void)
  * The guest has exited.  See if we can fix it or if we need userspace
  * assistance.
  */
-static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	union vmx_exit_reason exit_reason = vmx->exit_reason;
@@ -6081,6 +6093,25 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return 0;
 }
 
+static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+{
+	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
+
+	/*
+	 * Even when current exit reason is handled by KVM internally, we
+	 * still need to exit to user space when bus lock detected to inform
+	 * that there is a bus lock in guest.
+	 */
+	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
+		if (ret > 0)
+			vcpu->run->exit_reason = KVM_EXIT_BUS_LOCK;
+
+		vcpu->run->flags |= KVM_RUN_BUS_LOCK;
+		return 0;
+	}
+	return ret;
+}
+
 /*
  * Software based L1D cache flush which is used when microcode providing
  * the cache control MSR is not loaded.
@@ -7807,6 +7838,8 @@ static __init int hardware_setup(void)
 		kvm_tsc_scaling_ratio_frac_bits = 48;
 	}
 
+	kvm_has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
+
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
 	if (enable_ept)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ae3a89ac0600..7bb2a386ab2e 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -83,7 +83,7 @@ union vmx_exit_reason {
 		u32	reserved23		: 1;
 		u32	reserved24		: 1;
 		u32	reserved25		: 1;
-		u32	reserved26		: 1;
+		u32	bus_lock_detected	: 1;
 		u32	enclave_mode		: 1;
 		u32	smi_pending_mtf		: 1;
 		u32	smi_from_vmx_root	: 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bd239cab0a1a..a38e57a5319d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -135,6 +135,8 @@ u64  __read_mostly kvm_max_tsc_scaling_ratio;
 EXPORT_SYMBOL_GPL(kvm_max_tsc_scaling_ratio);
 u64 __read_mostly kvm_default_tsc_scaling_ratio;
 EXPORT_SYMBOL_GPL(kvm_default_tsc_scaling_ratio);
+bool __read_mostly kvm_has_bus_lock_exit;
+EXPORT_SYMBOL_GPL(kvm_has_bus_lock_exit);
 
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
 static u32 __read_mostly tsc_tolerance_ppm = 250;
@@ -3771,6 +3773,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_STEAL_TIME:
 		r = sched_info_on();
 		break;
+	case KVM_CAP_X86_BUS_LOCK_EXIT:
+		if (kvm_has_bus_lock_exit)
+			r = KVM_BUS_LOCK_DETECTION_OFF |
+			    KVM_BUS_LOCK_DETECTION_EXIT;
+		else
+			r = 0;
+		break;
 	default:
 		break;
 	}
@@ -5232,6 +5241,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.user_space_msr_mask = cap->args[0];
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
+			kvm->arch.bus_lock_detection_enabled = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..ad5dd3caeab2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -250,6 +250,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_ARM_NISV         28
 #define KVM_EXIT_X86_RDMSR        29
 #define KVM_EXIT_X86_WRMSR        30
+#define KVM_EXIT_BUS_LOCK         31
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -1053,6 +1054,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_X86_USER_SPACE_MSR 188
 #define KVM_CAP_X86_MSR_FILTER 189
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
+#define KVM_CAP_X86_BUS_LOCK_EXIT 191
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1710,4 +1712,7 @@ struct kvm_hyperv_eventfd {
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
+#define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
+#define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
+
 #endif /* __LINUX_KVM_H */
-- 
2.17.1

