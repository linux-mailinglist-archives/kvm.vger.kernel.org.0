Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0823183D4B
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgCLX1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:27:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:14954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgCLX1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:27:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:27:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261705930"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 16:27:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/8] nVMX: Refactor VM-Entry "failure" struct into "result"
Date:   Thu, 12 Mar 2020 16:27:39 -0700
Message-Id: <20200312232745.884-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312232745.884-1-sean.j.christopherson@intel.com>
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename "struct vmentry_failure" to "struct vmentry_result" and add the
full VM-Exit reason to the result.  Implement exit_reason as a union so
that tests can easily pull out the parts of interest, e.g. basic exit
reason, whether VM-Entry failed, etc...

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c       | 128 ++++++++++++++++++++++++++----------------------
 x86/vmx.h       |  39 ++++++++++++---
 x86/vmx_tests.c |  24 ++++-----
 3 files changed, 112 insertions(+), 79 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 99c3791..da17807 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -607,11 +607,14 @@ void print_vmexit_info()
 		regs.r12, regs.r13, regs.r14, regs.r15);
 }
 
-void
-print_vmentry_failure_info(struct vmentry_failure *failure) {
-	if (failure->early) {
-		printf("Early %s failure: ", failure->instr);
-		switch (failure->flags & VMX_ENTRY_FLAGS) {
+void print_vmentry_failure_info(struct vmentry_result *result)
+{
+	if (result->entered)
+		return;
+
+	if (result->vm_fail) {
+		printf("VM-Fail on %s: ", result->instr);
+		switch (result->flags & VMX_ENTRY_FLAGS) {
 		case X86_EFLAGS_CF:
 			printf("current-VMCS pointer is not valid.\n");
 			break;
@@ -620,16 +623,15 @@ print_vmentry_failure_info(struct vmentry_failure *failure) {
 			       vmcs_read(VMX_INST_ERROR));
 			break;
 		default:
-			printf("unexpected flags %lx!\n", failure->flags);
+			printf("unexpected flags %lx!\n", result->flags);
 		}
 	} else {
-		u64 reason = vmcs_read(EXI_REASON);
 		u64 qual = vmcs_read(EXI_QUALIFICATION);
 
-		printf("Non-early %s failure (reason=%#lx, qual=%#lx): ",
-			failure->instr, reason, qual);
+		printf("VM-Exit failure on %s (reason=%#x, qual=%#lx): ",
+			result->instr, result->exit_reason.full, qual);
 
-		switch (reason & 0xff) {
+		switch (result->exit_reason.basic) {
 		case VMX_FAIL_STATE:
 			printf("invalid guest state\n");
 			break;
@@ -640,14 +642,14 @@ print_vmentry_failure_info(struct vmentry_failure *failure) {
 			printf("machine-check event\n");
 			break;
 		default:
-			printf("unexpected basic exit reason %ld\n",
-			       reason & 0xff);
+			printf("unexpected basic exit reason %u\n",
+			  result->exit_reason.basic);
 		}
 
-		if (!(reason & VMX_ENTRY_FAILURE))
+		if (!result->exit_reason.failed_vmentry)
 			printf("\tVMX_ENTRY_FAILURE BIT NOT SET!\n");
 
-		if (reason & 0x7fff0000)
+		if (result->exit_reason.full & 0x7fff0000)
 			printf("\tRESERVED BITS SET!\n");
 	}
 }
@@ -1632,12 +1634,12 @@ static int exit_handler(void)
 }
 
 /*
- * Tries to enter the guest. Returns true if entry succeeded. Otherwise,
- * populates @failure.
+ * Tries to enter the guest, populates @result with VM-Fail, VM-Exit, entered,
+ * etc...
  */
-static void vmx_enter_guest(struct vmentry_failure *failure)
+static void vmx_enter_guest(struct vmentry_result *result)
 {
-	failure->early = 0;
+	memset(result, 0, sizeof(*result));
 
 	in_guest = 1;
 	asm volatile (
@@ -1654,35 +1656,35 @@ static void vmx_enter_guest(struct vmentry_failure *failure)
 		SAVE_GPR_C
 		"pushf\n\t"
 		"pop %%rdi\n\t"
-		"mov %%rdi, %[failure_flags]\n\t"
-		"movl $1, %[failure_early]\n\t"
+		"mov %%rdi, %[vm_fail_flags]\n\t"
+		"movl $1, %[vm_fail]\n\t"
 		"jmp 3f\n\t"
 		"vmx_return:\n\t"
 		SAVE_GPR_C
 		"3: \n\t"
-		: [failure_early]"+m"(failure->early),
-		  [failure_flags]"=m"(failure->flags)
+		: [vm_fail]"+m"(result->vm_fail),
+		  [vm_fail_flags]"=m"(result->flags)
 		: [launched]"m"(launched), [HOST_RSP]"i"(HOST_RSP)
 		: "rdi", "memory", "cc"
 	);
 	in_guest = 0;
 
-	failure->vmlaunch = !launched;
-	failure->instr = launched ? "vmresume" : "vmlaunch";
+	result->vmlaunch = !launched;
+	result->instr = launched ? "vmresume" : "vmlaunch";
+	result->exit_reason.full = result->vm_fail ? 0xdead :
+						     vmcs_read(EXI_REASON);
+	result->entered = !result->vm_fail &&
+			  !result->exit_reason.failed_vmentry;
 }
 
 static int vmx_run(void)
 {
+	struct vmentry_result result;
+	u32 ret;
+
 	while (1) {
-		u32 ret;
-		bool entered;
-		struct vmentry_failure failure;
-
-		vmx_enter_guest(&failure);
-		entered = !failure.early &&
-			  !(vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE);
-
-		if (entered) {
+		vmx_enter_guest(&result);
+		if (result.entered) {
 			/*
 			 * VMCS isn't in "launched" state if there's been any
 			 * entry failure (early or otherwise).
@@ -1690,7 +1692,7 @@ static int vmx_run(void)
 			launched = 1;
 			ret = exit_handler();
 		} else if (current->entry_failure_handler) {
-			ret = current->entry_failure_handler(failure);
+			ret = current->entry_failure_handler(&result);
 		} else {
 			ret = VMX_TEST_EXIT;
 		}
@@ -1705,15 +1707,15 @@ static int vmx_run(void)
 			break;
 		default:
 			printf("ERROR : Invalid %s_handler return val %d.\n",
-			       entered ? "exit" : "entry_failure",
+			       result.entered ? "exit" : "entry_failure",
 			       ret);
 			break;
 		}
 
-		if (entered)
+		if (result.entered)
 			print_vmexit_info();
 		else
-			print_vmentry_failure_info(&failure);
+			print_vmentry_failure_info(&result);
 		abort();
 	}
 }
@@ -1845,7 +1847,7 @@ static void check_for_guest_termination(void)
  * Enters the guest (or launches it for the first time). Error to call once the
  * guest has returned (i.e., run past the end of its guest() function).
  */
-static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
+static void __enter_guest(u8 abort_flag, struct vmentry_result *result)
 {
 	TEST_ASSERT_MSG(v2_guest_main,
 			"Never called test_set_guest_func!");
@@ -1853,24 +1855,32 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
 	TEST_ASSERT_MSG(!guest_finished,
 			"Called enter_guest() after guest returned.");
 
-	vmx_enter_guest(failure);
-	if ((abort_flag & ABORT_ON_EARLY_VMENTRY_FAIL && failure->early) ||
-	    (abort_flag & ABORT_ON_INVALID_GUEST_STATE &&
-	    vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
+	vmx_enter_guest(result);
 
-		print_vmentry_failure_info(failure);
-		abort();
+	if (result->vm_fail) {
+		if (abort_flag & ABORT_ON_EARLY_VMENTRY_FAIL)
+			goto do_abort;
+		return;
 	}
-
-	if (!failure->early && !(vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
-		launched = 1;
-		check_for_guest_termination();
+	if (result->exit_reason.failed_vmentry) {
+		if ((abort_flag & ABORT_ON_INVALID_GUEST_STATE) ||
+		    result->exit_reason.basic != VMX_FAIL_STATE)
+			goto do_abort;
+		return;
 	}
+
+	launched = 1;
+	check_for_guest_termination();
+	return;
+
+do_abort:
+	print_vmentry_failure_info(result);
+	abort();
 }
 
 void enter_guest_with_bad_controls(void)
 {
-	struct vmentry_failure failure = {0};
+	struct vmentry_result result;
 
 	TEST_ASSERT_MSG(v2_guest_main,
 			"Never called test_set_guest_func!");
@@ -1878,10 +1888,10 @@ void enter_guest_with_bad_controls(void)
 	TEST_ASSERT_MSG(!guest_finished,
 			"Called enter_guest() after guest returned.");
 
-	__enter_guest(ABORT_ON_INVALID_GUEST_STATE, &failure);
-	report(failure.early, "failure occurred early");
-	report((failure.flags & VMX_ENTRY_FLAGS) == X86_EFLAGS_ZF,
-               "FLAGS set correctly");
+	__enter_guest(ABORT_ON_INVALID_GUEST_STATE, &result);
+	report(result.vm_fail, "VM-Fail occurred as expected");
+	report((result.flags & VMX_ENTRY_FLAGS) == X86_EFLAGS_ZF,
+               "FLAGS set correctly on VM-Fail");
 	report(vmcs_read(VMX_INST_ERROR) == VMXERR_ENTRY_INVALID_CONTROL_FIELD,
 	       "VM-Inst Error # is %d (VM entry with invalid control field(s))",
 	       VMXERR_ENTRY_INVALID_CONTROL_FIELD);
@@ -1893,23 +1903,23 @@ void enter_guest_with_bad_controls(void)
 	 * unexpectedly succeed, it's nice to check whether the guest has
 	 * terminated, to reduce the number of error messages.
 	 */
-	if (!failure.early)
+	if (!result.vm_fail)
 		check_for_guest_termination();
 }
 
 void enter_guest(void)
 {
-	struct vmentry_failure failure = {0};
+	struct vmentry_result result;
 
 	__enter_guest(ABORT_ON_EARLY_VMENTRY_FAIL |
-		      ABORT_ON_INVALID_GUEST_STATE, &failure);
+		      ABORT_ON_INVALID_GUEST_STATE, &result);
 }
 
 void enter_guest_with_invalid_guest_state(void)
 {
-	struct vmentry_failure failure = {0};
+	struct vmentry_result result;
 
-	__enter_guest(ABORT_ON_EARLY_VMENTRY_FAIL, &failure);
+	__enter_guest(ABORT_ON_EARLY_VMENTRY_FAIL, &result);
 }
 
 extern struct vmx_test vmx_tests[];
@@ -1924,6 +1934,8 @@ test_wanted(const char *name, const char *filters[], int filter_count)
 	char *c;
 	const char *n;
 
+	printf("filter = %s, test = %s\n", filters[0], name);
+
 	/* Replace spaces with underscores. */
 	n = name;
 	c = &clean_name[0];
diff --git a/x86/vmx.h b/x86/vmx.h
index 6adf091..c4a0fb4 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -44,13 +44,38 @@ struct regs {
 	u64 rflags;
 };
 
-struct vmentry_failure {
-	/* Did a vmlaunch or vmresume fail? */
-	bool vmlaunch;
+struct vmentry_result {
 	/* Instruction mnemonic (for convenience). */
 	const char *instr;
-	/* Did the instruction return right away, or did we jump to HOST_RIP? */
-	bool early;
+	/* Did the test attempt vmlaunch or vmresume? */
+	bool vmlaunch;
+	/* Did the instruction VM-Fail? */
+	bool vm_fail;
+	/* Did the VM-Entry fully enter the guest? */
+	bool entered;
+	/* VM-Exit reason, valid iff !vm_fail */
+	union {
+		struct {
+			u32	basic			: 16;
+			u32	reserved16		: 1;
+			u32	reserved17		: 1;
+			u32	reserved18		: 1;
+			u32	reserved19		: 1;
+			u32	reserved20		: 1;
+			u32	reserved21		: 1;
+			u32	reserved22		: 1;
+			u32	reserved23		: 1;
+			u32	reserved24		: 1;
+			u32	reserved25		: 1;
+			u32	reserved26		: 1;
+			u32	enclave_mode		: 1;
+			u32	smi_pending_mtf		: 1;
+			u32	smi_from_vmx_root	: 1;
+			u32	reserved30		: 1;
+			u32	failed_vmentry		: 1;
+		};
+		u32 full;
+	} exit_reason;
 	/* Contents of [re]flags after failed entry. */
 	unsigned long flags;
 };
@@ -62,7 +87,7 @@ struct vmx_test {
 	int (*exit_handler)(void);
 	void (*syscall_handler)(u64 syscall_no);
 	struct regs guest_regs;
-	int (*entry_failure_handler)(struct vmentry_failure *failure);
+	int (*entry_failure_handler)(struct vmentry_result *result);
 	struct vmcs *vmcs;
 	int exits;
 	/* Alternative test interface. */
@@ -800,7 +825,7 @@ void init_vmx(u64 *vmxon_region);
 
 const char *exit_reason_description(u64 reason);
 void print_vmexit_info(void);
-void print_vmentry_failure_info(struct vmentry_failure *failure);
+void print_vmentry_failure_info(struct vmentry_result *result);
 void ept_sync(int type, u64 eptp);
 void vpid_sync(int type, u16 vpid);
 void install_ept_entry(unsigned long *pml4, int pte_level,
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a7abd63..c4077b1 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1996,24 +1996,22 @@ static int msr_switch_exit_handler(void)
 	return VMX_TEST_EXIT;
 }
 
-static int msr_switch_entry_failure(struct vmentry_failure *failure)
+static int msr_switch_entry_failure(struct vmentry_result *result)
 {
-	ulong reason;
-
-	if (failure->early) {
-		printf("ERROR %s: early exit\n", __func__);
+	if (result->vm_fail) {
+		printf("ERROR %s: VM-Fail on %s\n", __func__, result->instr);
 		return VMX_TEST_EXIT;
 	}
 
-	reason = vmcs_read(EXI_REASON);
-	if (reason == (VMX_ENTRY_FAILURE | VMX_FAIL_MSR) &&
+	if (result->exit_reason.failed_vmentry &&
+	    result->exit_reason.basic == VMX_FAIL_MSR &&
 	    vmx_get_test_stage() == 3) {
 		report(vmcs_read(EXI_QUALIFICATION) == 1,
 		       "VM entry MSR load: try to load FS_BASE");
 		return VMX_TEST_VMEXIT;
 	}
-	printf("ERROR %s: unexpected stage=%u or reason=%lu\n",
-		__func__, vmx_get_test_stage(), reason);
+	printf("ERROR %s: unexpected stage=%u or reason=%x\n",
+		__func__, vmx_get_test_stage(), result->exit_reason.full);
 	return VMX_TEST_EXIT;
 }
 
@@ -9428,12 +9426,10 @@ static int invalid_msr_exit_handler(void)
 	return VMX_TEST_EXIT;
 }
 
-static int invalid_msr_entry_failure(struct vmentry_failure *failure)
+static int invalid_msr_entry_failure(struct vmentry_result *result)
 {
-	ulong reason;
-
-	reason = vmcs_read(EXI_REASON);
-	report(reason == (0x80000000u | VMX_FAIL_MSR), "Invalid MSR load");
+	report(result->exit_reason.failed_vmentry &&
+	       result->exit_reason.basic == VMX_FAIL_MSR, "Invalid MSR load");
 	return VMX_TEST_VMEXIT;
 }
 
-- 
2.24.1

