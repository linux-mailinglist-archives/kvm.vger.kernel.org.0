Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F60E183D4F
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgCLX1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:27:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:14955 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgCLX1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:27:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261705942"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 16:27:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 6/8] nVMX: Pass exit reason union to v1 exit handlers
Date:   Thu, 12 Mar 2020 16:27:43 -0700
Message-Id: <20200312232745.884-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312232745.884-1-sean.j.christopherson@intel.com>
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the recently introduce "union exit_reason" to the v1 exit handlers
and use it in lieu of a manual VMREAD of the exit reason.

Opportunistically fix a variety of warts in the handlers, e.g. grabbing
only bits 7:0 of the exit reason.  Modify the "Unknown exit reason"
prints to display the exit reason in hex format to make a failed
VM-Entry more recognizable.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c       |   6 +-
 x86/vmx.h       |  48 ++++++++--------
 x86/vmx_tests.c | 149 +++++++++++++++++++-----------------------------
 3 files changed, 88 insertions(+), 115 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 1c837f0..35d7fc7 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1618,7 +1618,7 @@ void test_skip(const char *msg)
 	abort();
 }
 
-static int exit_handler(void)
+static int exit_handler(union exit_reason exit_reason)
 {
 	int ret;
 
@@ -1627,7 +1627,7 @@ static int exit_handler(void)
 	if (is_hypercall())
 		ret = handle_hypercall();
 	else
-		ret = current->exit_handler();
+		ret = current->exit_handler(exit_reason);
 	vmcs_write(GUEST_RFLAGS, regs.rflags);
 
 	return ret;
@@ -1690,7 +1690,7 @@ static int vmx_run(void)
 			 * entry failure (early or otherwise).
 			 */
 			launched = 1;
-			ret = exit_handler();
+			ret = exit_handler(result.exit_reason);
 		} else if (current->entry_failure_handler) {
 			ret = current->entry_failure_handler(&result);
 		} else {
diff --git a/x86/vmx.h b/x86/vmx.h
index 73979f7..b79cbc1 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -44,6 +44,29 @@ struct regs {
 	u64 rflags;
 };
 
+union exit_reason {
+	struct {
+		u32	basic			: 16;
+		u32	reserved16		: 1;
+		u32	reserved17		: 1;
+		u32	reserved18		: 1;
+		u32	reserved19		: 1;
+		u32	reserved20		: 1;
+		u32	reserved21		: 1;
+		u32	reserved22		: 1;
+		u32	reserved23		: 1;
+		u32	reserved24		: 1;
+		u32	reserved25		: 1;
+		u32	reserved26		: 1;
+		u32	enclave_mode		: 1;
+		u32	smi_pending_mtf		: 1;
+		u32	smi_from_vmx_root	: 1;
+		u32	reserved30		: 1;
+		u32	failed_vmentry		: 1;
+	};
+	u32 full;
+};
+
 struct vmentry_result {
 	/* Instruction mnemonic (for convenience). */
 	const char *instr;
@@ -54,28 +77,7 @@ struct vmentry_result {
 	/* Did the VM-Entry fully enter the guest? */
 	bool entered;
 	/* VM-Exit reason, valid iff !vm_fail */
-	union {
-		struct {
-			u32	basic			: 16;
-			u32	reserved16		: 1;
-			u32	reserved17		: 1;
-			u32	reserved18		: 1;
-			u32	reserved19		: 1;
-			u32	reserved20		: 1;
-			u32	reserved21		: 1;
-			u32	reserved22		: 1;
-			u32	reserved23		: 1;
-			u32	reserved24		: 1;
-			u32	reserved25		: 1;
-			u32	reserved26		: 1;
-			u32	enclave_mode		: 1;
-			u32	smi_pending_mtf		: 1;
-			u32	smi_from_vmx_root	: 1;
-			u32	reserved30		: 1;
-			u32	failed_vmentry		: 1;
-		};
-		u32 full;
-	} exit_reason;
+	union exit_reason exit_reason;
 	/* Contents of [re]flags after failed entry. */
 	unsigned long flags;
 };
@@ -84,7 +86,7 @@ struct vmx_test {
 	const char *name;
 	int (*init)(struct vmcs *vmcs);
 	void (*guest_main)(void);
-	int (*exit_handler)(void);
+	int (*exit_handler)(union exit_reason exit_reason);
 	void (*syscall_handler)(u64 syscall_no);
 	struct regs guest_regs;
 	int (*entry_failure_handler)(struct vmentry_result *result);
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 5befcd3..f46a0b9 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -58,7 +58,7 @@ static void basic_guest_main(void)
 	report(1, "Basic VMX test");
 }
 
-static int basic_exit_handler(void)
+static int basic_exit_handler(union exit_reason exit_reason)
 {
 	report(0, "Basic VMX test");
 	print_vmexit_info();
@@ -83,14 +83,11 @@ static void vmenter_main(void)
 	report((rax == 0xFFFF) && (rsp == resume_rsp), "test vmresume");
 }
 
-static int vmenter_exit_handler(void)
+static int vmenter_exit_handler(union exit_reason exit_reason)
 {
-	u64 guest_rip;
-	ulong reason;
+	u64 guest_rip = vmcs_read(GUEST_RIP);
 
-	guest_rip = vmcs_read(GUEST_RIP);
-	reason = vmcs_read(EXI_REASON) & 0xff;
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		if (regs.rax != 0xABCD) {
 			report(0, "test vmresume");
@@ -152,18 +149,16 @@ static void preemption_timer_main(void)
 	vmcall();
 }
 
-static int preemption_timer_exit_handler(void)
+static int preemption_timer_exit_handler(union exit_reason exit_reason)
 {
 	bool guest_halted;
 	u64 guest_rip;
-	ulong reason;
 	u32 insn_len;
 	u32 ctrl_exit;
 
 	guest_rip = vmcs_read(GUEST_RIP);
-	reason = vmcs_read(EXI_REASON) & 0xff;
 	insn_len = vmcs_read(EXI_INST_LEN);
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_PREEMPT:
 		switch (vmx_get_test_stage()) {
 		case 1:
@@ -240,7 +235,7 @@ static int preemption_timer_exit_handler(void)
 		}
 		break;
 	default:
-		report(false, "Unknown exit reason, %ld", reason);
+		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info();
 	}
 	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_PREEMPT);
@@ -335,15 +330,13 @@ static void test_ctrl_pat_main(void)
 		report(guest_ia32_pat == ia32_pat, "Entry load PAT");
 }
 
-static int test_ctrl_pat_exit_handler(void)
+static int test_ctrl_pat_exit_handler(union exit_reason exit_reason)
 {
 	u64 guest_rip;
-	ulong reason;
 	u64 guest_pat;
 
 	guest_rip = vmcs_read(GUEST_RIP);
-	reason = vmcs_read(EXI_REASON) & 0xff;
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		guest_pat = vmcs_read(GUEST_PAT);
 		if (!(ctrl_exit_rev.clr & EXI_SAVE_PAT)) {
@@ -361,7 +354,7 @@ static int test_ctrl_pat_exit_handler(void)
 		vmcs_write(GUEST_RIP, guest_rip + 3);
 		return VMX_TEST_RESUME;
 	default:
-		printf("ERROR : Undefined exit reason, reason = %ld.\n", reason);
+		printf("ERROR : Unknown exit reason, 0x%x.\n", exit_reason.full);
 		break;
 	}
 	return VMX_TEST_VMEXIT;
@@ -403,15 +396,13 @@ static void test_ctrl_efer_main(void)
 		report(guest_ia32_efer == ia32_efer, "Entry load EFER");
 }
 
-static int test_ctrl_efer_exit_handler(void)
+static int test_ctrl_efer_exit_handler(union exit_reason exit_reason)
 {
 	u64 guest_rip;
-	ulong reason;
 	u64 guest_efer;
 
 	guest_rip = vmcs_read(GUEST_RIP);
-	reason = vmcs_read(EXI_REASON) & 0xff;
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		guest_efer = vmcs_read(GUEST_EFER);
 		if (!(ctrl_exit_rev.clr & EXI_SAVE_EFER)) {
@@ -431,7 +422,7 @@ static int test_ctrl_efer_exit_handler(void)
 		vmcs_write(GUEST_RIP, guest_rip + 3);
 		return VMX_TEST_RESUME;
 	default:
-		printf("ERROR : Undefined exit reason, reason = %ld.\n", reason);
+		printf("ERROR : Unknown exit reason, 0x%x.\n", exit_reason.full);
 		break;
 	}
 	return VMX_TEST_VMEXIT;
@@ -529,18 +520,16 @@ static void cr_shadowing_main(void)
 	       "Write shadowing different X86_CR4_DE");
 }
 
-static int cr_shadowing_exit_handler(void)
+static int cr_shadowing_exit_handler(union exit_reason exit_reason)
 {
 	u64 guest_rip;
-	ulong reason;
 	u32 insn_len;
 	u32 exit_qual;
 
 	guest_rip = vmcs_read(GUEST_RIP);
-	reason = vmcs_read(EXI_REASON) & 0xff;
 	insn_len = vmcs_read(EXI_INST_LEN);
 	exit_qual = vmcs_read(EXI_QUALIFICATION);
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
@@ -624,7 +613,7 @@ static int cr_shadowing_exit_handler(void)
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, %ld", reason);
+		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info();
 	}
 	return VMX_TEST_VMEXIT;
@@ -694,17 +683,16 @@ static void iobmp_main(void)
 	       "I/O bitmap - unconditional exiting");
 }
 
-static int iobmp_exit_handler(void)
+static int iobmp_exit_handler(union exit_reason exit_reason)
 {
 	u64 guest_rip;
-	ulong reason, exit_qual;
+	ulong exit_qual;
 	u32 insn_len, ctrl_cpu0;
 
 	guest_rip = vmcs_read(GUEST_RIP);
-	reason = vmcs_read(EXI_REASON) & 0xff;
 	exit_qual = vmcs_read(EXI_QUALIFICATION);
 	insn_len = vmcs_read(EXI_INST_LEN);
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_IO:
 		switch (vmx_get_test_stage()) {
 		case 0:
@@ -784,7 +772,7 @@ static int iobmp_exit_handler(void)
 		return VMX_TEST_RESUME;
 	default:
 		printf("guest_rip = %#lx\n", guest_rip);
-		printf("\tERROR : Undefined exit reason, reason = %ld.\n", reason);
+		printf("\tERROR : Unknown exit reason, 0x%x\n", exit_reason.full);
 		break;
 	}
 	return VMX_TEST_VMEXIT;
@@ -989,22 +977,20 @@ static void insn_intercept_main(void)
 	}
 }
 
-static int insn_intercept_exit_handler(void)
+static int insn_intercept_exit_handler(union exit_reason exit_reason)
 {
 	u64 guest_rip;
-	u32 reason;
 	ulong exit_qual;
 	u32 insn_len;
 	u32 insn_info;
 	bool pass;
 
 	guest_rip = vmcs_read(GUEST_RIP);
-	reason = vmcs_read(EXI_REASON) & 0xff;
 	exit_qual = vmcs_read(EXI_QUALIFICATION);
 	insn_len = vmcs_read(EXI_INST_LEN);
 	insn_info = vmcs_read(EXI_INST_INFO);
 
-	if (reason == VMX_VMCALL) {
+	if (exit_reason.basic == VMX_VMCALL) {
 		u32 val = 0;
 
 		if (insn_table[cur_insn].type == INSN_CPU0)
@@ -1023,7 +1009,7 @@ static int insn_intercept_exit_handler(void)
 			vmcs_write(CPU_EXEC_CTRL1, val | ctrl_cpu_rev[1].set);
 	} else {
 		pass = (cur_insn * 2 == vmx_get_test_stage()) &&
-			insn_table[cur_insn].reason == reason;
+			insn_table[cur_insn].reason == exit_reason.full;
 		if (insn_table[cur_insn].test_field & FIELD_EXIT_QUAL &&
 		    insn_table[cur_insn].exit_qual != exit_qual)
 			pass = false;
@@ -1275,16 +1261,15 @@ static bool invept_test(int type, u64 eptp)
 	return true;
 }
 
-static int pml_exit_handler(void)
+static int pml_exit_handler(union exit_reason exit_reason)
 {
 	u16 index, count;
-	ulong reason = vmcs_read(EXI_REASON) & 0xff;
 	u64 *pmlbuf = pml_log;
 	u64 guest_rip = vmcs_read(GUEST_RIP);;
 	u64 guest_cr3 = vmcs_read(GUEST_CR3);
 	u32 insn_len = vmcs_read(EXI_INST_LEN);
 
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
@@ -1315,27 +1300,25 @@ static int pml_exit_handler(void)
 		vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, %ld", reason);
+		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info();
 	}
 	return VMX_TEST_VMEXIT;
 }
 
-static int ept_exit_handler_common(bool have_ad)
+static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 {
 	u64 guest_rip;
 	u64 guest_cr3;
-	ulong reason;
 	u32 insn_len;
 	u32 exit_qual;
 	static unsigned long data_page1_pte, data_page1_pte_pte, memaddr_pte;
 
 	guest_rip = vmcs_read(GUEST_RIP);
 	guest_cr3 = vmcs_read(GUEST_CR3);
-	reason = vmcs_read(EXI_REASON) & 0xff;
 	insn_len = vmcs_read(EXI_INST_LEN);
 	exit_qual = vmcs_read(EXI_QUALIFICATION);
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
@@ -1483,15 +1466,15 @@ static int ept_exit_handler_common(bool have_ad)
 		}
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, %ld", reason);
+		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info();
 	}
 	return VMX_TEST_VMEXIT;
 }
 
-static int ept_exit_handler(void)
+static int ept_exit_handler(union exit_reason exit_reason)
 {
-	return ept_exit_handler_common(false);
+	return ept_exit_handler_common(exit_reason, false);
 }
 
 static int eptad_init(struct vmcs *vmcs)
@@ -1556,9 +1539,9 @@ static void eptad_main(void)
 	ept_common();
 }
 
-static int eptad_exit_handler(void)
+static int eptad_exit_handler(union exit_reason exit_reason)
 {
-	return ept_exit_handler_common(true);
+	return ept_exit_handler_common(exit_reason, true);
 }
 
 static bool invvpid_test(int type, u16 vpid)
@@ -1609,17 +1592,15 @@ static void vpid_main(void)
 	report(vmx_get_test_stage() == 5, "INVVPID ALL");
 }
 
-static int vpid_exit_handler(void)
+static int vpid_exit_handler(union exit_reason exit_reason)
 {
 	u64 guest_rip;
-	ulong reason;
 	u32 insn_len;
 
 	guest_rip = vmcs_read(GUEST_RIP);
-	reason = vmcs_read(EXI_REASON) & 0xff;
 	insn_len = vmcs_read(EXI_INST_LEN);
 
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		switch(vmx_get_test_stage()) {
 		case 0:
@@ -1643,7 +1624,7 @@ static int vpid_exit_handler(void)
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, %ld", reason);
+		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info();
 	}
 	return VMX_TEST_VMEXIT;
@@ -1761,13 +1742,12 @@ static void interrupt_main(void)
 	report(timer_fired, "Inject an event to a halted guest");
 }
 
-static int interrupt_exit_handler(void)
+static int interrupt_exit_handler(union exit_reason exit_reason)
 {
 	u64 guest_rip = vmcs_read(GUEST_RIP);
-	ulong reason = vmcs_read(EXI_REASON) & 0xff;
 	u32 insn_len = vmcs_read(EXI_INST_LEN);
 
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
@@ -1815,7 +1795,7 @@ static int interrupt_exit_handler(void)
 			vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, %ld", reason);
+		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info();
 	}
 
@@ -1886,9 +1866,8 @@ static void dbgctls_main(void)
 	report(vmx_get_test_stage() == 4, "Don't save debug controls");
 }
 
-static int dbgctls_exit_handler(void)
+static int dbgctls_exit_handler(union exit_reason exit_reason)
 {
-	unsigned int reason = vmcs_read(EXI_REASON) & 0xff;
 	u32 insn_len = vmcs_read(EXI_INST_LEN);
 	u64 guest_rip = vmcs_read(GUEST_RIP);
 	u64 dr7, debugctl;
@@ -1896,7 +1875,7 @@ static int dbgctls_exit_handler(void)
 	asm volatile("mov %%dr7,%0" : "=r" (dr7));
 	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
@@ -1929,7 +1908,7 @@ static int dbgctls_exit_handler(void)
 		vmcs_write(GUEST_RIP, guest_rip + insn_len);
 		return VMX_TEST_RESUME;
 	default:
-		report(false, "Unknown exit reason, %d", reason);
+		report(false, "Unknown exit reason, %d", exit_reason.full);
 		print_vmexit_info();
 	}
 	return VMX_TEST_VMEXIT;
@@ -1977,12 +1956,9 @@ static void msr_switch_main(void)
 	vmcall();
 }
 
-static int msr_switch_exit_handler(void)
+static int msr_switch_exit_handler(union exit_reason exit_reason)
 {
-	ulong reason;
-
-	reason = vmcs_read(EXI_REASON);
-	if (reason == VMX_VMCALL && vmx_get_test_stage() == 2) {
+	if (exit_reason.basic == VMX_VMCALL && vmx_get_test_stage() == 2) {
 		report(exit_msr_store[0].value == MSR_MAGIC + 1,
 		       "VM exit MSR store");
 		report(rdmsr(MSR_KERNEL_GS_BASE) == MSR_MAGIC + 2,
@@ -1991,8 +1967,8 @@ static int msr_switch_exit_handler(void)
 		entry_msr_load[0].index = MSR_FS_BASE;
 		return VMX_TEST_RESUME;
 	}
-	printf("ERROR %s: unexpected stage=%u or reason=%lu\n",
-		__func__, vmx_get_test_stage(), reason);
+	printf("ERROR %s: unexpected stage=%u or reason=0x%x\n",
+		__func__, vmx_get_test_stage(), exit_reason.full);
 	return VMX_TEST_EXIT;
 }
 
@@ -2031,12 +2007,9 @@ static void vmmcall_main(void)
 	report(0, "VMMCALL");
 }
 
-static int vmmcall_exit_handler(void)
+static int vmmcall_exit_handler(union exit_reason exit_reason)
 {
-	ulong reason;
-
-	reason = vmcs_read(EXI_REASON);
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		printf("here\n");
 		report(0, "VMMCALL triggers #UD");
@@ -2046,7 +2019,7 @@ static int vmmcall_exit_handler(void)
 		       "VMMCALL triggers #UD");
 		break;
 	default:
-		report(false, "Unknown exit reason, %ld", reason);
+		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info();
 	}
 
@@ -2098,11 +2071,9 @@ static void disable_rdtscp_main(void)
 	vmcall();
 }
 
-static int disable_rdtscp_exit_handler(void)
+static int disable_rdtscp_exit_handler(union exit_reason exit_reason)
 {
-	unsigned int reason = vmcs_read(EXI_REASON) & 0xff;
-
-	switch (reason) {
+	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		switch (vmx_get_test_stage()) {
 		case 0:
@@ -2120,7 +2091,7 @@ static int disable_rdtscp_exit_handler(void)
 		break;
 
 	default:
-		report(false, "Unknown exit reason, %d", reason);
+		report(false, "Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info();
 	}
 	return VMX_TEST_VMEXIT;
@@ -2137,12 +2108,12 @@ static void int3_guest_main(void)
 	asm volatile ("int3");
 }
 
-static int int3_exit_handler(void)
+static int int3_exit_handler(union exit_reason exit_reason)
 {
-	u32 reason = vmcs_read(EXI_REASON);
 	u32 intr_info = vmcs_read(EXI_INTR_INFO);
 
-	report(reason == VMX_EXC_NMI && (intr_info & INTR_INFO_VALID_MASK) &&
+	report(exit_reason.basic == VMX_EXC_NMI &&
+	       (intr_info & INTR_INFO_VALID_MASK) &&
 	       (intr_info & INTR_INFO_VECTOR_MASK) == BP_VECTOR &&
 	       ((intr_info & INTR_INFO_INTR_TYPE_MASK) >>
 	        INTR_INFO_INTR_TYPE_SHIFT) == VMX_INTR_TYPE_SOFT_EXCEPTION,
@@ -2186,12 +2157,12 @@ into:
 	__builtin_unreachable();
 }
 
-static int into_exit_handler(void)
+static int into_exit_handler(union exit_reason exit_reason)
 {
-	u32 reason = vmcs_read(EXI_REASON);
 	u32 intr_info = vmcs_read(EXI_INTR_INFO);
 
-	report(reason == VMX_EXC_NMI && (intr_info & INTR_INFO_VALID_MASK) &&
+	report(exit_reason.basic == VMX_EXC_NMI &&
+	       (intr_info & INTR_INFO_VALID_MASK) &&
 	       (intr_info & INTR_INFO_VECTOR_MASK) == OF_VECTOR &&
 	       ((intr_info & INTR_INFO_INTR_TYPE_MASK) >>
 	        INTR_INFO_INTR_TYPE_SHIFT) == VMX_INTR_TYPE_SOFT_EXCEPTION,
@@ -2206,7 +2177,7 @@ static void exit_monitor_from_l2_main(void)
 	exit(0);
 }
 
-static int exit_monitor_from_l2_handler(void)
+static int exit_monitor_from_l2_handler(union exit_reason exit_reason)
 {
 	report(false, "The guest should have killed the VMM");
 	return VMX_TEST_EXIT;
@@ -9375,7 +9346,7 @@ static void invalid_msr_main(void)
 	report(0, "Invalid MSR load");
 }
 
-static int invalid_msr_exit_handler(void)
+static int invalid_msr_exit_handler(union exit_reason exit_reason)
 {
 	report(0, "Invalid MSR load");
 	print_vmexit_info();
-- 
2.24.1

