Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A4D532BA4
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 15:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbiEXNub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 09:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237970AbiEXNu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 09:50:26 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6459BACA;
        Tue, 24 May 2022 06:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653400224; x=1684936224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=nHkj1C3j6HS9vlu3aTejWwUeS7XPFcIvaUY3hzW1O2M=;
  b=R3KxhvlqC553L3roosbe1v21DNm06r5fzWuwZb/NLQXlrGpyprc7IF5u
   WxRApfILLnkPoE8CwG/f3mj/L6LAB7vr1ryBA6qNVbKQnVU1DwQv8uPf/
   F9YS/I2EYkC10S6dtX8OA2yGfZffVMszuTqKNkvV7NZTJAxuAtg9HIIIw
   pnbBhwad5DfHnWy2TmZeM4anFI38W3pQuOFJmoRq+x8e/qrW4Pa35n09H
   EfOy/pHxsI7vZONb2y1LOULV77a37WnHPxnTc2lfIOq4cJQ9TVpntKNAr
   YaDw3tkP7NuqXrg1LSiT+/GcuscJr9zrjqS+IpfmTErA5NWK2+5kibGAV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="272351868"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="272351868"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:50:24 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="601312039"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:50:21 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v7 4/4] KVM: VMX: Enable Notify VM exit
Date:   Tue, 24 May 2022 21:56:24 +0800
Message-Id: <20220524135624.22988-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220524135624.22988-1-chenyi.qiang@intel.com>
References: <20220524135624.22988-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
  can query and enable this feature in per-VM scope. The argument is a
  64bit value: bits 63:32 are used for notify window, and bits 31:0 are
  for flags. Current supported flags:
  - KVM_X86_NOTIFY_VMEXIT_ENABLED: enable the feature with the notify
    window provided.
  - KVM_X86_NOTIFY_VMEXIT_USER: exit to userspace once the exits happen.
- It's safe to even set notify window to zero since an internal hardware
  threshold is added to vmcs.notify_window.

VM exit handling:
- Introduce a vcpu state notify_window_exits to records the count of
  notify VM exits and expose it through the debugfs.
- Notify VM exit can happen incident to delivery of a vector event.
  Allow it in KVM.
- Exit to userspace unconditionally for handling when VM_CONTEXT_INVALID
  bit is set.

Nested handling
- Nested notify VM exits are not supported yet. Keep the same notify
  window control in vmcs02 as vmcs01, so that L1 can't escape the
  restriction of notify VM exits through launching L2 VM.

Notify VM exit is defined in latest Intel Architecture Instruction Set
Extensions Programming Reference, chapter 9.2.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
Co-developed-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 Documentation/virt/kvm/api.rst     | 49 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h    |  7 +++++
 arch/x86/include/asm/vmx.h         |  7 +++++
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 ++-
 arch/x86/kvm/vmx/capabilities.h    |  6 ++++
 arch/x86/kvm/vmx/nested.c          |  8 +++++
 arch/x86/kvm/vmx/vmx.c             | 40 ++++++++++++++++++++++--
 arch/x86/kvm/x86.c                 | 22 +++++++++++++-
 arch/x86/kvm/x86.h                 |  7 +++++
 include/uapi/linux/kvm.h           | 10 ++++++
 11 files changed, 157 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d219523bdb70..1831ee0f7e96 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6325,6 +6325,26 @@ array field represents return values. The userspace should update the return
 values of SBI call before resuming the VCPU. For more details on RISC-V SBI
 spec refer, https://github.com/riscv/riscv-sbi-doc.
 
+::
+
+    /* KVM_EXIT_NOTIFY */
+    struct {
+  #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
+      __u32 flags;
+    } notify;
+
+Used on x86 systems. When the VM capability KVM_CAP_X86_NOTIFY_VMEXIT is
+enabled, a VM exit generated if no event window occurs in VM non-root mode
+for a specified amount of time. Once KVM_X86_NOTIFY_VMEXIT_USER is set when
+enabling the cap, it would exit to userspace with the exit reason
+KVM_EXIT_NOTIFY for further handling. The "flags" field contains more
+detailed info.
+
+The valid value for 'flags' is:
+
+  - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
+    in VMCS. It would run into unknown result if resume the target VM.
+
 ::
 
 		/* Fix the size of the union. */
@@ -7291,6 +7311,35 @@ if the value was set to zero or KVM_ENABLE_CAP was not invoked, KVM
 uses the return value of KVM_CHECK_EXTENSION(KVM_CAP_MAX_VCPU_ID) as
 the maximum APIC ID.
 
+7.33 KVM_CAP_X86_NOTIFY_VMEXIT
+------------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] is the value of notify window as well as some flags
+:Returns: 0 on success, -EINVAL if args[0] contains invalid flags or notify
+          VM exit is unsupported.
+
+Bits 63:32 of args[0] are used for notify window.
+Bits 31:0 of args[0] are for some flags. Valid bits are::
+
+  #define KVM_X86_NOTIFY_VMEXIT_ENABLED    (1 << 0)
+  #define KVM_X86_NOTIFY_VMEXIT_USER       (1 << 1)
+
+This capability allows userspace to configure the notify VM exit on/off
+in per-VM scope during VM creation. Notify VM exit is disabled by default.
+When userspace sets KVM_X86_NOTIFY_VMEXIT_ENABLED bit in args[0], VMM will
+enable this feature with the notify window provided, which will generate
+a VM exit if no event window occurs in VM non-root mode for a specified of
+time (notify window).
+
+If KVM_X86_NOTIFY_VMEXIT_USER is set in args[0], upon notify VM exits happen,
+KVM would exit to userspace for handling.
+
+This capability is aimed to mitigate the threat that malicious VMs can
+cause CPU stuck (due to event windows don't open up) and make the CPU
+unavailable to host or other VMs.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 270460e9f3b1..d4c0ea35efa3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -65,6 +65,9 @@
 #define KVM_BUS_LOCK_DETECTION_VALID_MODE	(KVM_BUS_LOCK_DETECTION_OFF | \
 						 KVM_BUS_LOCK_DETECTION_EXIT)
 
+#define KVM_X86_NOTIFY_VMEXIT_VALID_BITS	(KVM_X86_NOTIFY_VMEXIT_ENABLED | \
+						 KVM_X86_NOTIFY_VMEXIT_USER)
+
 /* x86-specific vcpu->requests bit members */
 #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
 #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
@@ -1178,6 +1181,9 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 	bool enable_pmu;
+
+	u32 notify_window;
+	u32 notify_vmexit_flags;
 	/*
 	 * If exit_on_emulation_error is set, and the in-kernel instruction
 	 * emulator fails to emulate an instruction, allow userspace
@@ -1325,6 +1331,7 @@ struct kvm_vcpu_stat {
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
 	u64 guest_mode;
+	u64 notify_window_exits;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 89d2172787c5..c371ef695fcc 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -75,6 +75,7 @@
 #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
 #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
 #define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
+#define SECONDARY_EXEC_NOTIFY_VM_EXITING	VMCS_CONTROL_BIT(NOTIFY_VM_EXITING)
 
 /*
  * Definitions of Tertiary Processor-Based VM-Execution Controls.
@@ -280,6 +281,7 @@ enum vmcs_field {
 	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
 	PLE_GAP                         = 0x00004020,
 	PLE_WINDOW                      = 0x00004022,
+	NOTIFY_WINDOW                   = 0x00004024,
 	VM_INSTRUCTION_ERROR            = 0x00004400,
 	VM_EXIT_REASON                  = 0x00004402,
 	VM_EXIT_INTR_INFO               = 0x00004404,
@@ -564,6 +566,11 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_GVA_IS_VALID	(1 << EPT_VIOLATION_GVA_IS_VALID_BIT)
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
index 589608c157bf..c6a7eed03914 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -85,6 +85,7 @@
 #define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* Enable TPAUSE, UMONITOR, UMWAIT in guest */
 #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
 #define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
+#define VMX_FEATURE_NOTIFY_VM_EXITING	( 2*32+ 31) /* VM-Exit when no event windows after notify window */
 
 /* Tertiary Processor-Based VM-Execution Controls, word 3 */
 #define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* Enable IPI virtualization */
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 946d761adbd3..a5faf6d88f1b 100644
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
+	{ EXIT_REASON_NOTIFY,                "NOTIFY" }
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f14c4bef97e0..2d3f13b18714 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -436,4 +436,10 @@ static inline u64 vmx_supported_debugctl(void)
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
index aab4745eb1ee..8086db2ad73c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2133,6 +2133,8 @@ static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 
 static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 {
+	struct kvm *kvm = vmx->vcpu.kvm;
+
 	/*
 	 * If vmcs02 hasn't been initialized, set the constant vmcs02 state
 	 * according to L0's settings (vmcs12 is irrelevant here).  Host
@@ -2175,6 +2177,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_encls_vmexit())
 		vmcs_write64(ENCLS_EXITING_BITMAP, INVALID_GPA);
 
+	if (kvm_notify_vmexit_enabled(kvm))
+		vmcs_write32(NOTIFY_WINDOW, kvm->arch.notify_window);
+
 	/*
 	 * Set the MSR load/store lists to match L0's settings.  Only the
 	 * addresses are constant (for vmcs02), the counts can change based
@@ -6107,6 +6112,9 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
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
index b06eafa5884d..a86546921c2b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2497,7 +2497,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
 			SECONDARY_EXEC_ENABLE_VMFUNC |
-			SECONDARY_EXEC_BUS_LOCK_DETECTION;
+			SECONDARY_EXEC_BUS_LOCK_DETECTION |
+			SECONDARY_EXEC_NOTIFY_VM_EXITING;
 		if (cpu_has_sgx())
 			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
 		if (adjust_vmx_controls(min2, opt2,
@@ -4410,6 +4411,9 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
 		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
 
+	if (!kvm_notify_vmexit_enabled(vcpu->kvm))
+		exec_control &= ~SECONDARY_EXEC_NOTIFY_VM_EXITING;
+
 	return exec_control;
 }
 
@@ -4491,6 +4495,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmx->ple_window_dirty = true;
 	}
 
+	if (kvm_notify_vmexit_enabled(kvm))
+		vmcs_write32(NOTIFY_WINDOW, kvm->arch.notify_window);
+
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
 	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
@@ -5777,6 +5784,32 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_notify(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
+	bool context_invalid = exit_qual & NOTIFY_VM_CONTEXT_INVALID;
+
+	++vcpu->stat.notify_window_exits;
+
+	/*
+	 * Notify VM exit happened while executing iret from NMI,
+	 * "blocked by NMI" bit has to be set before next VM entry.
+	 */
+	if (enable_vnmi && (exit_qual & INTR_INFO_UNBLOCK_NMI))
+		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
+			      GUEST_INTR_STATE_NMI);
+
+	if (vcpu->kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_USER ||
+	    context_invalid) {
+		vcpu->run->exit_reason = KVM_EXIT_NOTIFY;
+		vcpu->run->notify.flags = context_invalid ?
+					  KVM_NOTIFY_CONTEXT_INVALID : 0;
+		return 0;
+	}
+
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5834,6 +5867,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
+	[EXIT_REASON_NOTIFY]		      = handle_notify,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -6207,7 +6241,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
 	     exit_reason.basic != EXIT_REASON_PML_FULL &&
 	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
-	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
+	     exit_reason.basic != EXIT_REASON_TASK_SWITCH &&
+	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
 		int ndata = 3;
 
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
@@ -8130,6 +8165,7 @@ static __init int hardware_setup(void)
 	kvm_caps.max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
 	kvm_caps.tsc_scaling_ratio_frac_bits = 48;
 	kvm_caps.has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
+	kvm_caps.has_notify_vmexit = cpu_has_notify_vmexit();
 
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d745d87835e2..9fb20e05a643 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -284,7 +284,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, nested_run),
 	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
-	STATS_DESC_ICOUNTER(VCPU, guest_mode)
+	STATS_DESC_ICOUNTER(VCPU, guest_mode),
+	STATS_DESC_COUNTER(VCPU, notify_window_exits),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
@@ -4399,6 +4400,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = KVM_X86_VALID_QUIRKS;
 		break;
+	case KVM_CAP_X86_NOTIFY_VMEXIT:
+		r = kvm_caps.has_notify_vmexit;
+		break;
 	default:
 		break;
 	}
@@ -6122,6 +6126,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_X86_NOTIFY_VMEXIT:
+		r = -EINVAL;
+		if ((u32)cap->args[0] & ~KVM_X86_NOTIFY_VMEXIT_VALID_BITS)
+			break;
+		if (!kvm_caps.has_notify_vmexit)
+			break;
+		if (!((u32)cap->args[0] & KVM_X86_NOTIFY_VMEXIT_ENABLED))
+			break;
+		mutex_lock(&kvm->lock);
+		if (!kvm->created_vcpus) {
+			kvm->arch.notify_window = cap->args[0] >> 32;
+			kvm->arch.notify_vmexit_flags = (u32)cap->args[0];
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 359d0454ad28..501b884b8cc4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -21,6 +21,8 @@ struct kvm_caps {
 	u64  default_tsc_scaling_ratio;
 	/* bus lock detection supported? */
 	bool has_bus_lock_exit;
+	/* notify VM exit supported? */
+	bool has_notify_vmexit;
 
 	u64 supported_mce_cap;
 	u64 supported_xcr0;
@@ -364,6 +366,11 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.cstate_in_guest;
 }
 
+static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
+{
+	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
+}
+
 enum kvm_intr_type {
 	/* Values are arbitrary, but must be non-zero. */
 	KVM_HANDLING_IRQ = 1,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ec75b56229c7..e028d5246920 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -270,6 +270,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_NOTIFY           36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -494,6 +495,11 @@ struct kvm_run {
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+		/* KVM_EXIT_NOTIFY */
+		struct {
+#define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
+			__u32 flags;
+		} notify;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1154,6 +1160,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_TRIPLE_FAULT_EVENT 216
+#define KVM_CAP_X86_NOTIFY_VMEXIT 217
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2115,4 +2122,7 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+#define KVM_X86_NOTIFY_VMEXIT_ENABLED		(1ULL << 0)
+#define KVM_X86_NOTIFY_VMEXIT_USER		(1ULL << 1)
+
 #endif /* __LINUX_KVM_H */
-- 
2.17.1

