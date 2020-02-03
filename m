Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392141509B3
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 16:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgBCPVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 10:21:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:32939 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgBCPV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 10:21:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 07:21:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="429473383"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by fmsmga005.fm.intel.com with ESMTP; 03 Feb 2020 07:21:23 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 4/6] kvm: vmx: Extend VMX's #AC handding for split lock in guest
Date:   Mon,  3 Feb 2020 23:16:06 +0800
Message-Id: <20200203151608.28053-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200203151608.28053-1-xiaoyao.li@intel.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
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

When host enables split lock detection, i.e., split_lock_detect != off,
guest will receive an unexpected #AC when there is a split lock happens
since KVM doesn't virtualize this feature to guest hardware value of
MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit stays unchanged when vcpu is running.

Since old guests lack split_lock #AC handler and may have split lock buges.
To make them survive from split lock, applying the similar policy
as host's split lock detect configuration:
 - host split lock detect is sld_warn:
   warn the split lock happened in guest, and disabling split lock
   detect during vcpu is running to allow the guest to continue running.
 - host split lock detect is sld_fatal:
   forwarding #AC to userspace, somewhat similar as sending SIGBUS.

Please note:
1. If sld_warn and SMT is enabled, the split lock in guest's vcpu
leads to disable split lock detect on the sibling CPU thread during
the vcpu is running.

2. When host is sld_warn, it allows guest to generate split lock which also
opens the door for malicious guest to do DoS attack. It is same that in
sld_warn mode, userspace application can do DoS attack.

3. If want to prevent DoS attack from guest, host must use sld_fatal mode.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 48 +++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h |  3 +++
 2 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c475fa2aaae0..93e3370c5f84 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4233,6 +4233,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->msr_ia32_umwait_control = 0;
 
+	vmx->disable_split_lock_detect = false;
+
 	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	vmx->hv_deadline_tsc = -1;
@@ -4557,6 +4559,12 @@ static int handle_machine_check(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static inline bool guest_cpu_alignment_check_enabled(struct kvm_vcpu *vcpu)
+{
+	return vmx_get_cpl(vcpu) == 3 && kvm_read_cr0_bits(vcpu, X86_CR0_AM) &&
+	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
+}
+
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4622,9 +4630,6 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		return handle_rmode_exception(vcpu, ex_no, error_code);
 
 	switch (ex_no) {
-	case AC_VECTOR:
-		kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
-		return 1;
 	case DB_VECTOR:
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
 		if (!(vcpu->guest_debug &
@@ -4653,6 +4658,33 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;
 		break;
+	case AC_VECTOR:
+		/*
+		 * Inject #AC back to guest only when legacy alignment check
+		 * enabled.
+		 * Otherwise, it must be an unexpected split-lock #AC for guest
+		 * since KVM keeps hardware SPLIT_LOCK_DETECT bit unchanged
+		 * when vcpu is running.
+		 *  - If sld_state == sld_warn, treat it similar as user space
+		 *    process that warn and allow it to continue running.
+		 *    In this case, setting vmx->diasble_split_lock_detect to
+		 *    true so that it will toggle MSR_TEST.SPLIT_LOCK_DETECT
+		 *    bit during every following VM Entry and Exit;
+		 *  - If sld_state == sld_fatal, it forwards #AC to userspace,
+		 *    similar as sending SIGBUS.
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
@@ -6530,6 +6562,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	    unlikely(vmx->disable_split_lock_detect) &&
+	    !test_tsk_thread_flag(current, TIF_SLD))
+		split_lock_detect_set(false);
+
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
@@ -6564,6 +6601,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
+	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
+	    unlikely(vmx->disable_split_lock_detect) &&
+	    !test_tsk_thread_flag(current, TIF_SLD))
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

