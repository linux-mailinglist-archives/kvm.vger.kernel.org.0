Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8FC1B7C8F
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgDXRT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:19:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:14632 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgDXRT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 13:19:28 -0400
IronPort-SDR: 8oDrBcXIfUv4rkGplRme9Xi2fs8fGKbrVaolAZ8Z/gHfiPMC4Z/oOihwMrROPi1lzB3IMhABVj
 +e5aAvNn6J0g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 10:19:27 -0700
IronPort-SDR: YquaYbCpzuPcEbkFG18XrwTE0QbEwlzOzr7LCqlIXar3KpDE/jHZ7en8cKwOcvDVdUUCM3J6ee
 pXoftvnPaVZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="259894358"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 24 Apr 2020 10:19:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Tweak handling of failure code for nested VM-Enter failure
Date:   Fri, 24 Apr 2020 10:19:25 -0700
Message-Id: <20200424171925.1178-1-sean.j.christopherson@intel.com>
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

Opportunistically rename the variables in load_vmcs12_host_state() and
vmx_set_nested_state() to call out that they're ignored, and add a
comment in nested_vmx_load_msr() to call out that returning 'i + 1'
can't wrap.

No functional change intended.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/vmx.h | 10 ++++++----
 arch/x86/kvm/vmx/nested.c  | 38 +++++++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 21 deletions(-)

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
index b516c24494e3..e66320997910 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -927,6 +927,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	}
 	return 0;
 fail:
+	/* Note, max_msr_list_size is at most 4096, i.e. this can't wrap. */
 	return i + 1;
 }
 
@@ -1122,7 +1123,7 @@ static bool nested_vmx_transition_mmu_sync(struct kvm_vcpu *vcpu)
  * @entry_failure_code.
  */
 static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
-			       u32 *entry_failure_code)
+			       enum vm_entry_failure_code *entry_failure_code)
 {
 	if (cr3 != kvm_read_cr3(vcpu) || (!nested_ept && pdptrs_changed(vcpu))) {
 		if (CC(!nested_cr3_valid(vcpu, cr3))) {
@@ -2475,7 +2476,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
  * is assigned to entry_failure_code on failure.
  */
 static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
-			  u32 *entry_failure_code)
+			  enum vm_entry_failure_code *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
@@ -2935,11 +2936,11 @@ static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
 
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
@@ -2954,7 +2955,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (nested_vmx_check_vmcs_link_ptr(vcpu, vmcs12)) {
-		*exit_qual = ENTRY_FAIL_VMCS_LINK_PTR;
+		*entry_failure_code = ENTRY_FAIL_VMCS_LINK_PTR;
 		return -EINVAL;
 	}
 
@@ -3247,8 +3248,9 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	bool evaluate_pending_interrupts;
+	enum vm_entry_failure_code entry_failure_code;
 	u32 exit_reason = EXIT_REASON_INVALID_STATE;
-	u32 exit_qual;
+	u32 failed_msr;
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
 		kvm_vcpu_flush_tlb_current(vcpu);
@@ -3296,7 +3298,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 			return NVMX_VMENTRY_VMFAIL;
 		}
 
-		if (nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
+		if (nested_vmx_check_guest_state(vcpu, vmcs12, &entry_failure_code))
 			goto vmentry_fail_vmexit;
 	}
 
@@ -3304,16 +3306,18 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
 		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
 
-	if (prepare_vmcs02(vcpu, vmcs12, &exit_qual))
+	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code))
 		goto vmentry_fail_vmexit_guest_mode;
 
 	if (from_vmentry) {
 		exit_reason = EXIT_REASON_MSR_LOAD_FAIL;
-		exit_qual = nested_vmx_load_msr(vcpu,
-						vmcs12->vm_entry_msr_load_addr,
-						vmcs12->vm_entry_msr_load_count);
-		if (exit_qual)
+		failed_msr = nested_vmx_load_msr(vcpu,
+						 vmcs12->vm_entry_msr_load_addr,
+						 vmcs12->vm_entry_msr_load_count);
+		if (failed_msr) {
+			entry_failure_code = failed_msr;
 			goto vmentry_fail_vmexit_guest_mode;
+		}
 	} else {
 		/*
 		 * The MMU is not initialized to point at the right entities yet and
@@ -3377,7 +3381,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	load_vmcs12_host_state(vcpu, vmcs12);
 	vmcs12->vm_exit_reason = exit_reason | VMX_EXIT_REASONS_FAILED_VMENTRY;
-	vmcs12->exit_qualification = exit_qual;
+	vmcs12->exit_qualification = entry_failure_code;
 	if (enable_shadow_vmcs || vmx->nested.hv_evmcs)
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 	return NVMX_VMENTRY_VMEXIT;
@@ -4053,8 +4057,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				   struct vmcs12 *vmcs12)
 {
+	enum vm_entry_failure_code ignored;
 	struct kvm_segment seg;
-	u32 entry_failure_code;
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER)
 		vcpu->arch.efer = vmcs12->host_ia32_efer;
@@ -4089,7 +4093,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	 * Only PDPTE load can fail as the value of cr3 was checked on entry and
 	 * couldn't have changed.
 	 */
-	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &entry_failure_code))
+	if (nested_vmx_load_cr3(vcpu, vmcs12->host_cr3, false, &ignored))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_PDPTE_FAIL);
 
 	if (!enable_ept)
@@ -5989,7 +5993,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12;
-	u32 exit_qual;
+	enum vm_entry_failure_code ignored;
 	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
 		&user_kvm_nested_state->data.vmx[0];
 	int ret;
@@ -6130,7 +6134,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 	if (nested_vmx_check_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_host_state(vcpu, vmcs12) ||
-	    nested_vmx_check_guest_state(vcpu, vmcs12, &exit_qual))
+	    nested_vmx_check_guest_state(vcpu, vmcs12, &ignored))
 		goto error_guest_mode;
 
 	vmx->nested.dirty_vmcs12 = true;
-- 
2.26.0

