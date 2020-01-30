Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D6414DA94
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 13:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgA3MYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 07:24:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:49436 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbgA3MYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 07:24:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 04:24:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,381,1574150400"; 
   d="scan'208";a="262155263"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2020 04:24:48 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
Date:   Thu, 30 Jan 2020 20:19:39 +0800
Message-Id: <20200130121939.22383-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200130121939.22383-1-xiaoyao.li@intel.com>
References: <20200130121939.22383-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two types of #AC can be generated in Intel CPUs:
 1. legacy alignment check #AC;
 2. split lock #AC;

Legacy alignment check #AC can be injected to guest if guest has enabled
alignemnet check.

When host enables split lock detection, i.e., split_lock_detect!=off,
guest will receive an unexpected #AC when there is a split_lock happens in
guest since KVM doesn't virtualize this feature to guest.

Since the old guests lack split_lock #AC handler and may have split lock
buges. To make guest survive from split lock, applying the similar policy
as host's split lock detect configuration:
 - host split lock detect is sld_warn:
   warning the split lock happened in guest, and disabling split lock
   detect around VM-enter;
 - host split lock detect is sld_fatal:
   forwarding #AC to userspace. (Usually userspace dump the #AC
   exception and kill the guest).

Note, if sld_warn and SMT is enabled, the split lock in guest's vcpu
leads the disabling of split lock detect on the sibling CPU thread during
the vcpu is running.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/cpu.h  |  1 +
 arch/x86/kernel/cpu/intel.c |  6 ++++++
 arch/x86/kvm/vmx/vmx.c      | 42 ++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h      |  3 +++
 4 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 167d0539e0ad..b46262afa6c1 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -52,6 +52,7 @@ extern enum split_lock_detect_state get_split_lock_detect_state(void);
 extern void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
 extern void switch_to_sld(unsigned long tifn);
 extern bool handle_user_split_lock(struct pt_regs *regs, long error_code);
+extern void split_lock_detect_set(bool on);
 #else
 static inline enum split_lock_detect_state get_split_lock_detect_state(void)
 {
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 2f9c48e91caf..889469b54b5a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1124,6 +1124,12 @@ void switch_to_sld(unsigned long tifn)
 	__sld_msr_set(!(tifn & _TIF_SLD));
 }
 
+void split_lock_detect_set(bool on)
+{
+	__sld_msr_set(on);
+}
+EXPORT_SYMBOL_GPL(split_lock_detect_set);
+
 #define SPLIT_LOCK_CPU(model) {X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY}
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cdb4bf50ee14..402a9152c6ee 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4553,6 +4553,12 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
+	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
+}
+
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4618,9 +4624,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		return handle_rmode_exception(vcpu, ex_no, error_code);
 
 	switch (ex_no) {
-	case AC_VECTOR:
-		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
-		return 1;
 	case DB_VECTOR:
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
 		if (!(vcpu->guest_debug &
@@ -4649,6 +4652,29 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;
 		break;
+	case AC_VECTOR:
+		/*
+		 * Inject #AC back to guest only when legacy alignment check
+		 * enabled.
+		 * Otherwise, it must be a split-lock #AC.
+		 *  - If sld_state == sld_warn, it can let guest survive by
+		 *    setting the vcpu's diasble_split_lock_detect to true so
+		 *    that it will toggle MSR_TEST.SPLIT_LOCK_DETECT bit during
+		 *    every following VM Entry and Exit;
+		 *  - If sld_state == sld_fatal, it forwards #AC to userspace;
+		 */
+		if (guest_cpu_alignment_check_enabled(vcpu) ||
+		    WARN_ON(get_split_lock_detect_state() == sld_off)) {
+			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
+			return 1;
+		}
+		if (get_split_lock_detect_state() == sld_warn) {
+			pr_warn("kvm: split lock #AC happened in %s [%d]\n",
+				current->comm, current->pid);
+			vmx->disable_split_lock_detect = true;
+			return 1;
+		}
+		/* fall through*/
 	default:
 		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
 		kvm_run->ex.exception = ex_no;
@@ -6511,6 +6537,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	    !test_tsk_thread_flag(current, TIF_SLD) &&
+	    unlikely(vmx->disable_split_lock_detect))
+		split_lock_detect_set(false);
+
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
@@ -6545,6 +6576,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	    !test_tsk_thread_flag(current, TIF_SLD) &&
+	    unlikely(vmx->disable_split_lock_detect))
+		split_lock_detect_set(true);
+
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f42cf3dcd70..912eba66c5d5 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -274,6 +274,9 @@ struct vcpu_vmx {
 
 	bool req_immediate_exit;
 
+	/* Disable split-lock detection when running the vCPU */
+	bool disable_split_lock_detect;
+
 	/* Support for PML */
 #define PML_ENTITY_NUM		512
 	struct page *pml_pg;
-- 
2.23.0

