Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF8B1BC6D9
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgD1RcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 13:32:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:37304 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbgD1RcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 13:32:20 -0400
IronPort-SDR: UamUCxB0+EFyyaxsTLpdyWg4sUdXUyvoueFY8zZXZcxM8LxisX1INKJcYygcliBmzBFycrLTix
 1BRzkuT9zTfQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 10:32:18 -0700
IronPort-SDR: jE8KfGcEeN4UK0e3sfby955MkfVnxiUalJSBy/I/B0c5q9/tGAv00j4AOMrW7/j6hfr5L0duTg
 MjbRj71xLJTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="367565028"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 28 Apr 2020 10:32:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: nVMX: Tweak handling of failure code for nested VM-Enter failure
Date:   Tue, 28 Apr 2020 10:32:17 -0700
Message-Id: <20200428173217.5430-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use an enum for passing around the failure code for a failed VM-Enter
that results in VM-Exit to provide a level of indirection from the final
resting place of the failure code, vmcs.EXIT_QUALIFICATION.  The exit
qualification field is an unsigned long, e.g. passing around
'u32 exit_qual' throws up red flags as it suggests KVM may be dropping
bits when reporting errors to L1.  This is a red herring because the
only defined failure codes are 0, 2, 3, and 4, i.e. don't come remotely
close to overflowing a u32.

Setting vmcs.EXIT_QUALIFICATION on entry failure is further complicated
by the MSR load list, which returns the (1-based) entry that failed, and
the number of MSRs to load is a 32-bit VMCS field.  At first blush, it
would appear that overflowing a u32 is possible, but the number of MSRs
that can be loaded is hardcapped at 4096 (limited by MSR_IA32_VMX_MISC).

In other words, there are two completely disparate types of data that
eventually get stuffed into vmcs.EXIT_QUALIFICATION, neither of which is
an 'unsigned long' in nature.  This was presumably the reasoning for
switching to 'u32' when the related code was refactored in commit
ca0bde28f2ed6 ("kvm: nVMX: Split VMCS checks from nested_vmx_run()").

Using an enum for the failure code addresses the technically-possible-
but-will-never-happen scenario where Intel defines a failure code that
doesn't fit in a 32-bit integer.  The enum variables and values will
either be automatically sized (gcc 5.4 behavior) or be subjected to some
combination of truncation.  The former case will simply work, while the
latter will trigger a compile-time warning unless the compiler is being
particularly unhelpful.

Separating the failure code from the failed MSR entry allows for
disassociating both from vmcs.EXIT_QUALIFICATION, which avoids the
conundrum where KVM has to choose between 'u32 exit_qual' and tracking
values as 'unsigned long' that have no business being tracked as such.
To cement the split, set vmcs12->exit_qualification directly from the
entry error code or failed MSR index instead of bouncing through a local
variable.

Opportunistically rename the variables in load_vmcs12_host_state() and
vmx_set_nested_state() to call out that they're ignored, set exit_reason
on demand on nested VM-Enter failure, and add a comment in
nested_vmx_load_msr() to call out that returning 'i + 1' can't wrap.

No functional change intended.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

v2:
  - Set vmcs12->exit_qualification directly to avoid writing the failed
    MSR index (a u32) to the entry_failure_code enum. [Jim]
  - Set exit_reason on demand since the "goto vm_exit" paths need to set
    vmcs12->exit_qualification anyways, i.e. already have curly braces.

 arch/x86/include/asm/vmx.h | 10 +++++----
 arch/x86/kvm/vmx/nested.c  | 44 ++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 5e090d1f03f8..cd7de4b401fe 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -527,10 +527,12 @@ struct vmx_msr_entry {
 /*
  * Exit Qualifications for entry failure during or after loading guest state
  */
-#define ENTRY_FAIL_DEFAULT		0
-#define ENTRY_FAIL_PDPTE		2
-#define ENTRY_FAIL_NMI			3
-#define ENTRY_FAIL_VMCS_LINK_PTR	4
+enum vm_entry_failure_code {
+	ENTRY_FAIL_DEFAULT		= 0,
+	ENTRY_FAIL_PDPTE		= 2,
+	ENTRY_FAIL_NMI			= 3,
+	ENTRY_FAIL_VMCS_LINK_PTR	= 4,
+};
 
 /*
  * Exit Qualifications for EPT Violations
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2c36f3f53108..dc00d1742480 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -922,6 +922,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	}
 	return 0;
 fail:
+	/* Note, max_msr_list_size is at most 4096, i.e. this can't wrap. */
 	return i + 1;
 }
 
@@ -1117,7 +1118,7 @@ static bool nested_vmx_transition_mmu_sync(struct kvm_vcpu *vcpu)
  * @entry_failure_code.
  */
 static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
-			       u32 *entry_failure_code)
+			       enum vm_entry_failure_code *entry_failure_code)
 {
 	if (cr3 != kvm_read_cr3(vcpu) || (!nested_ept && pdptrs_changed(vcpu))) {
 		if (CC(!nested_cr3_valid(vcpu, cr3))) {
@@ -2470,7 +2471,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
  * is assigned to entry_failure_code on failure.
  */
 static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
-			  u32 *entry_failure_code)
+			  enum vm_entry_failure_code *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
@@ -2930,11 +2931,11 @@ static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
 
 static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					struct vmcs12 *vmcs12,
-					u32 *exit_qual)
+					enum vm_entry_failure_code *entry_failure_code)
 {
 	bool ia32e;
 
-	*exit_qual = ENTRY_FAIL_DEFAULT;
+	*entry_failure_code = ENTRY_FAIL_DEFAULT;
 
 	if (CC(!nested_guest_cr0_valid(vcpu, vmcs12->guest_cr0)) ||
 	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
@@ -2949,7 +2950,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (nested_vmx_check_vmcs_link_ptr(vcpu, vmcs12)) {
-		*exit_qual = ENTRY_FAIL_VMCS_LINK_PTR;
+		*entry_failure_code = ENTRY_FAIL_VMCS_LINK_PTR;
 		return -EINVAL;
 	}
 
@@ -3241,9 +3242,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	enum vm_entry_failure_code entry_failure_code;
 	bool evaluate_pending_interrupts;
-	u32 exit_reason = EXIT_REASON_INVALID_STATE;
-	u32 exit_qual;
+	u32 exit_reason, failed_index;
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
 		kvm_vcpu_flush_tlb_current(vcpu);
@@ -3291,24 +3292,30 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 			return NVMX_VMENTRY_VMFAIL;
 		}
 
-		if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
+		if (nested_vmx_check_guest_state(vcpu, vmcs12,
+						 &entry_failure_code)) {
+			exit_reason = EXIT_REASON_INVALID_STATE;
+			vmcs12->exit_qualification = entry_failure_code;
 			goto vmentry_fail_vmexit;
+		}
 	}
 
 	enter_guest_mode(vcpu);
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
-	if (prepare_vmcs02(vcpu, vmcs12, &exit_qual))
+	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code))
 		goto vmentry_fail_vmexit_guest_mode;
 
 	if (from_vmentry) {
-		exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
-		exit_qual = nested_vmx_load_msr(vcpu,
-						vmcs12->vm_entry_msr_load_addr,
-						vmcs12->vm_entry_msr_load_count);
-		if (exit_qual)
+		failed_index = nested_vmx_load_msr(vcpu,
+						   vmcs12->vm_entry_msr_load_addr,
+						   vmcs12->vm_entry_msr_load_count);
+		if (failed_index) {
+			exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
+			vmcs12->exit_qualification = failed_index;
 			goto vmentry_fail_vmexit_guest_mode;
+		}
 	} else {
 		/*
 		 * The MMU is not initialized to point at the right entities yet and
@@ -3372,7 +3379,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
-	vmcs12->exit_qualification = exit_qual;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	return NVMX_VMENTRY_VMEXIT;
@@ -4066,8 +4072,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				   struct vmcs12 *vmcs12)
 {
+	enum vm_entry_failure_code ignored;
 	struct kvm_segment seg;
-	u32 entry_failure_code;
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
 		vcpu->arch.efer = vmcs12->host_ia32_efer;
@@ -4102,7 +4108,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * Only PDPTE load can fail as the value of cr3 was checked on entry and
 	 * couldn't have changed.
 	 */
-	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &entry_failure_code))
+	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &ignored))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_PDPTE_FAIL);
 
 	if (!enable_ept)
@@ -6002,7 +6008,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12;
-	u32 exit_qual;
+	enum vm_entry_failure_code ignored;
 	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
 		&user_kvm_nested_state->data.vmx[0];
 	int ret;
@@ -6143,7 +6149,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 	if (nested_vmx_check_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_host_state(vcpu, vmcs12) ||
-	    nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
+	    nested_vmx_check_guest_state(vcpu, vmcs12, &ignored))
 		goto error_guest_mode;
 
 	vmx->nested.dirty_vmcs12 = true;
-- 
2.26.0

