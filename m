Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047934DD563
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 08:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiCRHpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 03:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiCRHpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 03:45:50 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009A61F42FC;
        Fri, 18 Mar 2022 00:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647589471; x=1679125471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=5hPggAq1cz6R5PurGubCOaDmFW8y+qCwamm+pREmFFU=;
  b=YjYJ3A1jJ0zcmXY0cgpPIjcXea4nb4xIAddWIMjD/Vn2A1KsmnOUQMuC
   SFV5eMyWVCZaoyTV8JMVuoxUUIODL/Q6TuE4Hh1z6yM6lTLFtUlH++Xcm
   AbtBVvImEzv1RDHre9KyhxlrF7kbrLEbXdq+vG6h51cz724Qx1yKiENmb
   qLHcjFJyEHegs/aDzyJgbt3tKFB4YQPqgBdscSMzzRlkjY/vZCGQ3VEKy
   GyoHp6g+AXgnY9bTT/y1Piv2EKE+Mi4q14++gZUeWyQgABACByWF5Dq/R
   CDxCQSNElYuWJY4lMMpqlpdFXTpaUg9cICpeDCko8K3CLvpCbrjWDnLjb
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="254641673"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="254641673"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 00:44:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="558307300"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 00:44:27 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Xu <tao3.xu@intel.com>
Subject: [PATCH v5 2/3] KVM: VMX: Enable Notify VM exit
Date:   Fri, 18 Mar 2022 15:49:54 +0800
Message-Id: <20220318074955.22428-3-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220318074955.22428-1-chenyi.qiang@intel.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tao Xu <tao3.xu@intel.com>

There are cases that malicious virtual machines can cause CPU stuck (due
to event windows don't open up), e.g., infinite loop in microcode when
nested #AC (CVE-2015-5307). No event window means no event (NMI, SMI and
IRQ) can be delivered. It leads the CPU to be unavailable to host or
other VMs.

VMM can enable notify VM exit that a VM exit generated if no event
window occurs in VM non-root mode for a specified amount of time (notify
window).

Feature enabling:
- The new vmcs field SECONDARY_EXEC_NOTIFY_VM_EXITING is introduced to
  enable this feature. VMM can set NOTIFY_WINDOW vmcs field to adjust
  the expected notify window.
- Add a new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT so that user space
  can query and enable this feature in per-VM scope. Notify window is
  also provided from user space during this process.
  - if notify_window < 0, feature disabled;
  - if notify_window >= 0, feature enabled;
- There's a possibility, however small, that a notify VM exit happens
  with VM_CONTEXT_INVALID set in exit qualification, which means VM
  context is corrupted. To avoid the false positive and a well-behaved
  guest gets killed, set notify window as -1 to disable this feature by
  default.
- It's safe to even set notify window to zero since an internal
  hardware threshold is added to vmcs.notifiy_window.

VM exit handling:
- Introduce a vcpu state notify_window_exits to records the count of
  notify VM exits and expose it through the debugfs.
- Warn the notify vm exit in kernel log since host can a) get an
  indication that a guest is potentially malicious and b) rule out (or
  confirm) notify VM exits as the source of degraded guest performance.
- Notify VM exit can happen incident to delivery of a vector event.
  Allow it in KVM.
- Once VM_CONTEXT_INVALID bit is set, exit to user space for further
  handling.

Nested handling
- Nested notify VM exits are not supported yet. Keep the same notify
  window control in vmcs02 as vmcs01, so that L1 can't escape the
  restriction of notify VM exits through launching L2 VM.
- When L2 VM is context invalid and user space should synthesize a shutdown
  event to a vcpu. KVM makes KVM_REQ_TRIPLE_FAULT request accordingly
  and it would synthesize a nested triple fault exit to L1 hypervisor to
  kill L2.

Notify VM exit is defined in latest Intel Architecture Instruction Set
Extensions Programming Reference, chapter 9.2.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
Co-developed-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h    |  5 ++++
 arch/x86/include/asm/vmx.h         |  7 +++++
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 ++-
 arch/x86/kvm/vmx/capabilities.h    |  6 ++++
 arch/x86/kvm/vmx/nested.c          | 17 +++++++++++-
 arch/x86/kvm/vmx/vmx.c             | 44 ++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c                 | 19 +++++++++++--
 arch/x86/kvm/x86.h                 |  5 ++++
 include/uapi/linux/kvm.h           |  7 +++++
 10 files changed, 108 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3a2c855f04e3..807562bb64ef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1149,6 +1149,8 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 	bool enable_pmu;
+
+	int notify_window;
 	/*
 	 * If exit_on_emulation_error is set, and the in-kernel instruction
 	 * emulator fails to emulate an instruction, allow userspace
@@ -1285,6 +1287,7 @@ struct kvm_vcpu_stat {
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
 	u64 guest_mode;
+	u64 notify_window_exits;
 };
 
 struct x86_instruction_info;
@@ -1641,6 +1644,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
 extern u64  kvm_default_tsc_scaling_ratio;
 /* bus lock detection supported? */
 extern bool kvm_has_bus_lock_exit;
+/* notify VM exit supported? */
+extern bool kvm_has_notify_vmexit;
 
 extern u64 kvm_mce_cap_supported;
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..9104c85a973f 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -74,6 +74,7 @@
 #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
 #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
 #define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
+#define SECONDARY_EXEC_NOTIFY_VM_EXITING	VMCS_CONTROL_BIT(NOTIFY_VM_EXITING)
 
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
@@ -269,6 +270,7 @@ enum vmcs_field {
 	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
 	PLE_GAP                         = 0x00004020,
 	PLE_WINDOW                      = 0x00004022,
+	NOTIFY_WINDOW                   = 0x00004024,
 	VM_INSTRUCTION_ERROR            = 0x00004400,
 	VM_EXIT_REASON                  = 0x00004402,
 	VM_EXIT_INTR_INFO               = 0x00004404,
@@ -555,6 +557,11 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
+/*
+ * Exit Qualifications for NOTIFY VM EXIT
+ */
+#define NOTIFY_VM_CONTEXT_INVALID     BIT(0)
+
 /*
  * VM-instruction error numbers
  */
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index d9a74681a77d..15f0f2ab4f95 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -84,5 +84,6 @@
 #define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* Enable TPAUSE, UMONITOR, UMWAIT in guest */
 #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
 #define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
+#define VMX_FEATURE_NOTIFY_VM_EXITING	( 2*32+ 31) /* VM-Exit when no event windows after notify window */
 
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 946d761adbd3..ef4c80f6553e 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -91,6 +91,7 @@
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
 #define EXIT_REASON_BUS_LOCK            74
+#define EXIT_REASON_NOTIFY              75
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -153,7 +154,8 @@
 	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
 	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
-	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }
+	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }, \
+	{ EXIT_REASON_NOTIFY,                "NOTIFY"}
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3f430e218375..0102a6e8a194 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -417,4 +417,10 @@ static inline u64 vmx_supported_debugctl(void)
 	return debugctl;
 }
 
+static inline bool cpu_has_notify_vmexit(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_NOTIFY_VM_EXITING;
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f18744f7ff82..1bcf086d2ed4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2134,6 +2134,8 @@ static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 
 static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 {
+	struct kvm *kvm = vmx->vcpu.kvm;
+
 	/*
 	 * If vmcs02 hasn't been initialized, set the constant vmcs02 state
 	 * according to L0's settings (vmcs12 is irrelevant here).  Host
@@ -2176,6 +2178,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_encls_vmexit())
 		vmcs_write64(ENCLS_EXITING_BITMAP, INVALID_GPA);
 
+	if (kvm_notify_vmexit_enabled(kvm))
+		vmcs_write32(NOTIFY_WINDOW, kvm->arch.notify_window);
+
 	/*
 	 * Set the MSR load/store lists to match L0's settings.  Only the
 	 * addresses are constant (for vmcs02), the counts can change based
@@ -4218,8 +4223,15 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		/*
 		 * Transfer the event that L0 or L1 may wanted to inject into
 		 * L2 to IDT_VECTORING_INFO_FIELD.
+		 *
+		 * Skip this if the exit is due to a NOTIFY_VM_CONTEXT_INVALID
+		 * exit; in that case, L0 will synthesize a nested TRIPLE_FAULT
+		 * vmexit to kill L2.  No IDT vectoring info is recorded for
+		 * triple faults, and __vmx_handle_exit does not expect it.
 		 */
-		vmcs12_save_pending_event(vcpu, vmcs12);
+		if (!(to_vmx(vcpu)->exit_reason.basic == EXIT_REASON_NOTIFY) &&
+		    kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu))
+			vmcs12_save_pending_event(vcpu, vmcs12);
 
 		/*
 		 * According to spec, there's no need to store the guest's
@@ -6085,6 +6097,9 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
 	case EXIT_REASON_ENCLS:
 		return nested_vmx_exit_handled_encls(vcpu, vmcs12);
+	case EXIT_REASON_NOTIFY:
+		/* Notify VM exit is not exposed to L1 */
+		return false;
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e8963f5af618..bd4f117c468c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2472,7 +2472,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
 			SECONDARY_EXEC_ENABLE_VMFUNC |
-			SECONDARY_EXEC_BUS_LOCK_DETECTION;
+			SECONDARY_EXEC_BUS_LOCK_DETECTION |
+			SECONDARY_EXEC_NOTIFY_VM_EXITING;
 		if (cpu_has_sgx())
 			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
 		if (adjust_vmx_controls(min2, opt2,
@@ -4362,6 +4363,9 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
 		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
 
+	if (!kvm_notify_vmexit_enabled(vcpu->kvm))
+		exec_control &= ~SECONDARY_EXEC_NOTIFY_VM_EXITING;
+
 	return exec_control;
 }
 
@@ -4369,6 +4373,8 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 
 static void init_vmcs(struct vcpu_vmx *vmx)
 {
+	struct kvm *kvm = vmx->vcpu.kvm;
+
 	if (nested)
 		nested_vmx_set_vmcs_shadowing_bitmap();
 
@@ -4397,12 +4403,15 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
 	}
 
-	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
+	if (!kvm_pause_in_guest(kvm)) {
 		vmcs_write32(PLE_GAP, ple_gap);
 		vmx->ple_window = ple_window;
 		vmx->ple_window_dirty = true;
 	}
 
+	if (kvm_notify_vmexit_enabled(kvm))
+		vmcs_write32(NOTIFY_WINDOW, kvm->arch.notify_window);
+
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
 	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
@@ -5691,6 +5700,32 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_notify(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
+
+	++vcpu->stat.notify_window_exits;
+	pr_warn_ratelimited("Notify window exits at address: 0x%lx\n",
+			    kvm_rip_read(vcpu));
+
+	if (!(exit_qual & NOTIFY_VM_CONTEXT_INVALID)) {
+		/*
+		 * Notify VM exit happened while executing iret from NMI,
+		 * "blocked by NMI" bit has to be set before next VM entry.
+		 */
+		if (enable_vnmi &&
+		    (exit_qual & INTR_INFO_UNBLOCK_NMI))
+			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
+				      GUEST_INTR_STATE_NMI);
+
+		return 1;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_NOTIFY;
+	vcpu->run->notify.data |= KVM_NOTIFY_CONTEXT_INVALID;
+	return 0;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5748,6 +5783,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
+	[EXIT_REASON_NOTIFY]		      = handle_notify,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -6112,7 +6148,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
 	     exit_reason.basic != EXIT_REASON_PML_FULL &&
 	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
-	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
+	     exit_reason.basic != EXIT_REASON_TASK_SWITCH &&
+	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
 		int ndata = 3;
 
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
@@ -7987,6 +8024,7 @@ static __init int hardware_setup(void)
 	}
 
 	kvm_has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
+	kvm_has_notify_vmexit = cpu_has_notify_vmexit();
 
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fee402a700df..9fd693db6d9d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -163,6 +163,8 @@ u64 __read_mostly kvm_default_tsc_scaling_ratio;
 EXPORT_SYMBOL_GPL(kvm_default_tsc_scaling_ratio);
 bool __read_mostly kvm_has_bus_lock_exit;
 EXPORT_SYMBOL_GPL(kvm_has_bus_lock_exit);
+bool __read_mostly kvm_has_notify_vmexit;
+EXPORT_SYMBOL_GPL(kvm_has_notify_vmexit);
 
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
 static u32 __read_mostly tsc_tolerance_ppm = 250;
@@ -291,7 +293,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, nested_run),
 	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
-	STATS_DESC_ICOUNTER(VCPU, guest_mode)
+	STATS_DESC_ICOUNTER(VCPU, guest_mode),
+	STATS_DESC_COUNTER(VCPU, notify_window_exits),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
@@ -4359,10 +4362,13 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
+	}
 	case KVM_CAP_PMU_CAPABILITY:
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
-	}
+	case KVM_CAP_X86_NOTIFY_VMEXIT:
+		r = kvm_has_notify_vmexit;
+		break;
 	default:
 		break;
 	}
@@ -6055,6 +6061,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_X86_NOTIFY_VMEXIT:
+		r = -EINVAL;
+		if (!kvm_has_notify_vmexit)
+			break;
+		kvm->arch.notify_window = cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -11649,6 +11662,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
 
+	kvm->arch.notify_window = -1;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
 	kvm->arch.hv_root_tdp = INVALID_PAGE;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index aa86abad914d..cf115233ce18 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -349,6 +349,11 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
+static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
+{
+	return kvm->arch.notify_window >= 0;
+}
+
 enum kvm_intr_type {
 	/* Values are arbitrary, but must be non-zero. */
 	KVM_HANDLING_IRQ = 1,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d2f1efc3aa35..8f58196569a0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_NOTIFY           36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -487,6 +488,11 @@ struct kvm_run {
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+		/* KVM_EXIT_NOTIFY */
+		struct {
+#define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
+			__u32 data;
+		} notify;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1143,6 +1149,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_AIL_MODE_3 210
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
+#define KVM_CAP_X86_NOTIFY_VMEXIT 213
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.17.1

