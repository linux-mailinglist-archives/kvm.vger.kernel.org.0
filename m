Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2506B4C0C7A
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 07:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbiBWGTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 01:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiBWGTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 01:19:37 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DA04CD5C;
        Tue, 22 Feb 2022 22:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645597149; x=1677133149;
  h=from:to:cc:subject:date:message-id;
  bh=apTM0CNbsDbLqB5cfrElsE8YcGxjZCG5QHSgOhYKNO4=;
  b=dIBr42bzSn8GzXUTKK+mfTZ93z3f2YEOiagxVF9zgeUdZj9k6zGp3Awu
   Wzf93GNcpyTOpjqvRdegJElLoL7wxvnAtr1+ktPJ9Nd/B18f8kp2Ehh+u
   oPcA9lftDmN7V5Af/7tQKm7awhO2RnQws3KoqSqt1ZGspzr7m1IQ0y/9D
   u70/81crJMbnv/nblAp5tmPXz4+xBFSzDy9w+cbkkfPrbX1N4C/sGqviq
   Me0zHcfOXwQNw0aVEPcHYVu1bah9pgRJfdCF1JlUOt9RN3TXWLcNCJA6C
   IIZQSuvecaY0ZGqrqZPv7X5yHnSEN0t1weGSLtNCr3QGsh/MgTg/80W/H
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="276510910"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="276510910"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 22:19:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="548102409"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 22:19:06 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Tao Xu <tao3.xu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3] KVM: VMX: Enable Notify VM exit
Date:   Wed, 23 Feb 2022 14:24:12 +0800
Message-Id: <20220223062412.22334-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
- Expose a module param to configure notify window by admin, which is in
  unit of crystal clock.
  - if notify_window < 0, feature disabled;
  - if notify_window >= 0, feature enabled;
- There's a possibility, however small, that a notify VM exit happens
  with VM_CONTEXT_INVALID set in exit qualification. In this case, the
  vcpu can no longer run. To avoid killing a well-behaved guest, set
  notify window as -1 to disable this feature by default.
- It's safe to even set notify window to zero since an internal
  hardware threshold is added to vmcs.notifiy_window.

VM exit handling:
- Introduce a vcpu state notify_window_exits to records the count of
  notify VM exits and expose it through the debugfs.
- warn the notify vm exit in kernel log since host can a) get an
  indication that a guest is potentially malicious and b) rule out (or
  confirm) notify VM exits as the source of degraded guest performance.
- Notify VM exit can happen incident to delivery of a vector event.
  Allow it in KVM.

Nested handling
- Nested notify VM exits are not supported yet. Keep the same notify
  window control in vmcs02 as vmcs01, so that L1 can't escape the
  restriction of notify VM exits through launching L2 VM.
- When L2 VM is context invalid, synthesize a nested
  EXIT_REASON_TRIPLE_FAULT to L1 so that L1 won't be killed due to L2's
  VM_CONTEXT_INVALID happens.

Notify VM exit is defined in latest Intel Architecture Instruction Set
Extensions Programming Reference, chapter 9.2.

TODO: Allow to change the window size (to enable the feature) at runtime,
which can make it more flexible to do management.

---
Change logs:
v2 -> v3
- add a vcpu state notify_window_exits to record the number of
  occurence as well as a pr_warn output. (Sean)
- Add the handling in nested VM to prevent L1 bypassing the restriction
  through launching a L2. (Sean)
- Only kill L2 when L2 VM is context invalid, synthesize a
  EXIT_REASON_TRIPLE_FAULT to L1 (Sean)
- To ease the current implementation, make module parameter
  notify_window read-only. (Sean)
- Disable notify window exit by default.
- v2: https://lore.kernel.org/lkml/20210525051204.1480610-1-tao3.xu@intel.com/

v1 -> v2
- Default set notify window to 0, less than 0 to disable.
- Add more description in commit message.
---

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
Co-developed-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

---
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/include/asm/vmx.h         |  7 ++++
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 +-
 arch/x86/kvm/vmx/capabilities.h    |  7 ++++
 arch/x86/kvm/vmx/nested.c          | 16 +++++++-
 arch/x86/kvm/vmx/vmx.c             | 59 +++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c                 |  3 +-
 include/uapi/linux/kvm.h           |  2 +
 9 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 713e08f62385..3df68fea9f22 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1281,6 +1281,7 @@ struct kvm_vcpu_stat {
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
 	u64 guest_mode;
+	u64 notify_window_exits;
 };
 
 struct x86_instruction_info;
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
index 3f430e218375..fff010d24ad0 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -14,6 +14,7 @@ extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
 extern int __read_mostly pt_mode;
+extern int __read_mostly notify_window;
 
 #define PT_MODE_SYSTEM		0
 #define PT_MODE_HOST_GUEST	1
@@ -417,4 +418,10 @@ static inline u64 vmx_supported_debugctl(void)
 	return debugctl;
 }
 
+static inline bool cpu_has_notify_vm_exiting(void)
+{
+	return vmcs_config.cpu_based_2nd_exec_ctrl &
+		SECONDARY_EXEC_NOTIFY_VM_EXITING;
+}
+
 #endif /* __KVM_X86_VMX_CAPS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1dfe23963a9e..f306b642c3e1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2177,6 +2177,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_encls_vmexit())
 		vmcs_write64(ENCLS_EXITING_BITMAP, INVALID_GPA);
 
+	if (notify_window >= 0)
+		vmcs_write32(NOTIFY_WINDOW, notify_window);
+
 	/*
 	 * Set the MSR load/store lists to match L0's settings.  Only the
 	 * addresses are constant (for vmcs02), the counts can change based
@@ -4213,8 +4216,16 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		/*
 		 * Transfer the event that L0 or L1 may wanted to inject into
 		 * L2 to IDT_VECTORING_INFO_FIELD.
+		 * L0 will synthensize a nested TRIPLE_FAULT to kill L2 when
+		 * notify VM exit occurred in L2 and NOTIFY_VM_CONTEXT_INVALID is
+		 * set in exit qualification. In this case, if notify VM exit
+		 * occurred incident to delivery of a vectored event, the IDT
+		 * vectoring info are recorded in VMCS. Drop the pending event
+		 * in vmcs12, otherwise L1 VMM will exit to userspace with
+		 * internal error due to delivery event.
 		 */
-		vmcs12_save_pending_event(vcpu, vmcs12);
+		if (to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_NOTIFY)
+			vmcs12_save_pending_event(vcpu, vmcs12);
 
 		/*
 		 * According to spec, there's no need to store the guest's
@@ -6080,6 +6091,9 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
 	case EXIT_REASON_ENCLS:
 		return nested_vmx_exit_handled_encls(vcpu, vmcs12);
+	case EXIT_REASON_NOTIFY:
+		return nested_cpu_has2(vmcs12,
+			SECONDARY_EXEC_NOTIFY_VM_EXITING);
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b183dfc41d74..c8f1c2f83a8a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -207,6 +207,15 @@ module_param(ple_window_max, uint, 0444);
 int __read_mostly pt_mode = PT_MODE_SYSTEM;
 module_param(pt_mode, int, S_IRUGO);
 
+/*
+ * Set default as -1 to disable notify VM exit.
+ * Admin can set non-negative value to enable notify VM exit.
+ * An recommended value is 128K, which is an ideal threshold
+ * to ensure no false positive on some platforms.
+ */
+int __read_mostly notify_window = -1;
+module_param(notify_window, int, 0444);
+
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
 static DEFINE_MUTEX(vmx_l1d_flush_mutex);
@@ -2479,7 +2488,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			SECONDARY_EXEC_PT_USE_GPA |
 			SECONDARY_EXEC_PT_CONCEAL_VMX |
 			SECONDARY_EXEC_ENABLE_VMFUNC |
-			SECONDARY_EXEC_BUS_LOCK_DETECTION;
+			SECONDARY_EXEC_BUS_LOCK_DETECTION |
+			SECONDARY_EXEC_NOTIFY_VM_EXITING;
 		if (cpu_has_sgx())
 			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
 		if (adjust_vmx_controls(min2, opt2,
@@ -4369,6 +4379,9 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
 		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
 
+	if (notify_window < 0)
+		exec_control &= ~SECONDARY_EXEC_NOTIFY_VM_EXITING;
+
 	return exec_control;
 }
 
@@ -4410,6 +4423,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmx->ple_window_dirty = true;
 	}
 
+	if (notify_window >= 0)
+		vmcs_write32(NOTIFY_WINDOW, notify_window);
+
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
 	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
@@ -5691,6 +5707,40 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
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
+	if (is_guest_mode(vcpu)) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return 1;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_NO_EVENT_WINDOW;
+	vcpu->run->internal.ndata = 1;
+	vcpu->run->internal.data[0] = exit_qual;
+
+	return 0;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5748,6 +5798,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
 	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock_vmexit,
+	[EXIT_REASON_NOTIFY]		      = handle_notify,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -6112,7 +6163,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	     exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
 	     exit_reason.basic != EXIT_REASON_PML_FULL &&
 	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
-	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
+	     exit_reason.basic != EXIT_REASON_TASK_SWITCH &&
+	     exit_reason.basic != EXIT_REASON_NOTIFY)) {
 		int ndata = 3;
 
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
@@ -7975,6 +8027,9 @@ static __init int hardware_setup(void)
 
 	kvm_has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
 
+	if (!cpu_has_notify_vm_exiting())
+		notify_window = -1;
+
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
 	if (enable_ept)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6552360d8888..06a74561d44e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -289,7 +289,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, nested_run),
 	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
-	STATS_DESC_ICOUNTER(VCPU, guest_mode)
+	STATS_DESC_ICOUNTER(VCPU, guest_mode),
+	STATS_DESC_COUNTER(VCPU, notify_window_exits),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5191b57e1562..20ee68b4ac14 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -280,6 +280,8 @@ struct kvm_xen_exit {
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
 /* Encounter unexpected vm-exit reason */
 #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
+/* Encounter notify vm-exit */
+#define KVM_INTERNAL_ERROR_NO_EVENT_WINDOW   5
 
 /* Flags that describe what fields in emulation_failure hold valid data. */
 #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
-- 
2.17.1

