Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFE32A24B0
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 07:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgKBGOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 01:14:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:29661 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgKBGOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 01:14:51 -0500
IronPort-SDR: 73bBoKCeK7UZPLhktv5oNXITlROVlJP755h5iv1wHxmrU6aUvbHDXazAif4aaAN3rR9C41W3sy
 dcEVY9ZUPa7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9792"; a="186669766"
X-IronPort-AV: E=Sophos;i="5.77,444,1596524400"; 
   d="scan'208";a="186669766"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2020 22:14:50 -0800
IronPort-SDR: 8b703zXJzhYrXVZk+ziuGihKQyo6OX9XG+juqTGPlI8tHT6yrvo9B0TZY63jgx1qHGw5Pv4cpX
 PNKllSpvhqhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,444,1596524400"; 
   d="scan'208";a="526576042"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.159.33])
  by fmsmga006.fm.intel.com with ESMTP; 01 Nov 2020 22:14:47 -0800
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Xu <tao3.xu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH] KVM: VMX: Enable Notify VM exit
Date:   Mon,  2 Nov 2020 14:14:45 +0800
Message-Id: <20201102061445.191638-1-tao3.xu@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are some cases that malicious virtual machines can cause CPU stuck
(event windows don't open up), e.g., infinite loop in microcode when
nested #AC (CVE-2015-5307). No event window obviously means no events,
e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
hardware CPU can't be used by host or other VM.

To resolve those cases, it can enable a notify VM exit if no
event window occur in VMX non-root mode for a specified amount of
time (notify window).

Expose a module param for setting notify window, default setting it to
the time as 1/10 of periodic tick, and user can set it to 0 to disable
this feature.

TODO:
1. The appropriate value of notify window.
2. Another patch to disable interception of #DB and #AC when notify
VM-Exiting is enabled.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/vmx.h         |  7 +++++
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 ++-
 arch/x86/kvm/vmx/capabilities.h    |  6 +++++
 arch/x86/kvm/vmx/vmx.c             | 42 +++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h           |  2 ++
 6 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f8ba5289ecb0..888faa5de895 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -73,6 +73,7 @@
 #define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
 #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
 #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
+#define SECONDARY_EXEC_NOTIFY_VM_EXITING	VMCS_CONTROL_BIT(NOTIFY_VM_EXITING)
 
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
@@ -267,6 +268,7 @@ enum vmcs_field {
 	SECONDARY_VM_EXEC_CONTROL       = 0x0000401e,
 	PLE_GAP                         = 0x00004020,
 	PLE_WINDOW                      = 0x00004022,
+	NOTIFY_WINDOW                   = 0x00004024,
 	VM_INSTRUCTION_ERROR            = 0x00004400,
 	VM_EXIT_REASON                  = 0x00004402,
 	VM_EXIT_INTR_INFO               = 0x00004404,
@@ -552,6 +554,11 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
+/*
+ * Exit Qualifications for NOTIFY VM EXIT
+ */
+#define NOTIFY_VM_CONTEXT_VALID     BIT(0)
+
 /*
  * VM-instruction error numbers
  */
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index 9915990fd8cf..1a0e71b16961 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -83,5 +83,6 @@
 #define VMX_FEATURE_TSC_SCALING		( 2*32+ 25) /* Scale hardware TSC when read in guest */
 #define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* Enable TPAUSE, UMONITOR, UMWAIT in guest */
 #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
+#define VMX_FEATURE_NOTIFY_VM_EXITING	( 2*32+ 31) /* VM-Exit when no event windows after notify window */
 
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index b8ff9e8ac0d5..10873111980c 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -88,6 +88,7 @@
 #define EXIT_REASON_XRSTORS             64
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
+#define EXIT_REASON_NOTIFY              75
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -148,7 +149,8 @@
 	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
 	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
-	{ EXIT_REASON_TPAUSE,                "TPAUSE" }
+	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
+	{ EXIT_REASON_NOTIFY,                "NOTIFY"}
 
 #define VMX_EXIT_REASON_FLAGS \
 	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3a1861403d73..43a0c3eb86ec 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -378,4 +378,10 @@ static inline u64 vmx_get_perf_capabilities(void)
 	return PMU_CAP_FW_WRITES;
 }
 
+static inline bool cpu_has_notify_vm_exiting(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_NOTIFY_VM_EXITING;
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d14c94d0aff1..d03996913145 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -201,6 +201,10 @@ module_param(ple_window_max, uint, 0444);
 int __read_mostly pt_mode = PT_MODE_SYSTEM;
 module_param(pt_mode, int, S_IRUGO);
 
+/* Default is 1/10 of periodic tick, 0 disables notify window. */
+static int __read_mostly notify_window = -1;
+module_param(notify_window, int, 0644);
+
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
 static DEFINE_MUTEX(vmx_l1d_flush_mutex);
@@ -2429,7 +2433,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
-			SECONDARY_EXEC_ENABLE_VMFUNC;
+			SECONDARY_EXEC_ENABLE_VMFUNC |
+			SECONDARY_EXEC_NOTIFY_VM_EXITING;
 		if (cpu_has_sgx())
 			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
 		if (adjust_vmx_controls(min2, opt2,
@@ -4270,6 +4275,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	vmx_adjust_sec_exec_control(vmx, &exec_control, waitpkg, WAITPKG,
 				    ENABLE_USR_WAIT_PAUSE, false);
 
+	if (cpu_has_notify_vm_exiting() && !notify_window)
+		exec_control &= ~SECONDARY_EXEC_NOTIFY_VM_EXITING;
+
 	vmx->secondary_exec_control = exec_control;
 }
 
@@ -4326,6 +4334,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmx->ple_window_dirty = true;
 	}
 
+	if (cpu_has_notify_vm_exiting())
+		vmcs_write32(NOTIFY_WINDOW, notify_window);
+
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
 	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
@@ -5618,6 +5629,31 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_notify(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+
+	/*
+	 * Notify VM exit happened while executing iret from NMI,
+	 * "blocked by NMI" bit has to be set before next VM entry.
+	 */
+	if (exit_qualification & NOTIFY_VM_CONTEXT_VALID) {
+		if (enable_vnmi &&
+		    (exit_qualification & INTR_INFO_UNBLOCK_NMI))
+			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
+				      GUEST_INTR_STATE_NMI);
+
+		return 1;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_NO_EVENT_WINDOW;
+	vcpu->run->internal.ndata = 1;
+	vcpu->run->internal.data[0] = exit_qualification;
+
+	return 0;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5674,6 +5710,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
+	[EXIT_REASON_NOTIFY]		      = handle_notify,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -7873,6 +7910,9 @@ static __init int hardware_setup(void)
 	if (!enable_ept || !cpu_has_vmx_intel_pt())
 		pt_mode = PT_MODE_SYSTEM;
 
+	if (notify_window == -1)
+		notify_window = tsc_khz * 100 / HZ;
+
 	if (nested) {
 		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
 					   vmx_capability.ept);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..84d2c203de50 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -260,6 +260,8 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
+/* Encounter notify vm-exit */
+#define KVM_INTERNAL_ERROR_NO_EVENT_WINDOW   5
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
-- 
2.25.1

