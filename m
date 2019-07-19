Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 566AF6EBB1
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 22:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388192AbfGSUlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 16:41:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:46747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbfGSUlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 16:41:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 13:41:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="168655830"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.165])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jul 2019 13:41:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] KVM: VMX: Optimize VMX instruction error and fault handling
Date:   Fri, 19 Jul 2019 13:41:07 -0700
Message-Id: <20190719204110.18306-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190719204110.18306-1-sean.j.christopherson@intel.com>
References: <20190719204110.18306-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the VMX instruction helpers using asm-goto to branch directly
to error/fault "handlers" in lieu of using __ex(), i.e. the generic
____kvm_handle_fault_on_reboot().  Branching directly to fault handling
code during fixup avoids the extra JMP that is inserted after every VMX
instruction when using the generic "fault on reboot" (see commit
3901336ed9887, "x86/kvm: Don't call kvm_spurious_fault() from .fixup").

Opportunistically clean up the helpers so that they all have consistent
error handling and messages.

Leave the usage of ____kvm_handle_fault_on_reboot() (via __ex()) in
kvm_cpu_vmxoff() and nested_vmx_check_vmentry_hw() as is.  The VMXOFF
case is not a fast path, i.e. the cleanliness of __ex() is worth the
JMP, and the extra JMP in nested_vmx_check_vmentry_hw() is unavoidable.

Note, VMREAD cannot get the asm-goto treatment as output operands aren't
compatible with GCC's asm-goto due to internal compiler restrictions.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/ops.h | 72 +++++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.c | 34 ++++++++++++++++++++
 2 files changed, 74 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index 2200fb698dd0..79e25d49d4d9 100644
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -14,6 +14,12 @@
 #define __ex_clear(x, reg) \
 	____kvm_handle_fault_on_reboot(x, "xor " reg ", " reg)
 
+void vmwrite_error(unsigned long field, unsigned long value);
+void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
+void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
+void invvpid_error(unsigned long ext, u16 vpid, gva_t gva);
+void invept_error(unsigned long ext, u64 eptp, gpa_t gpa);
+
 static __always_inline void vmcs_check16(unsigned long field)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2000,
@@ -103,21 +109,39 @@ static __always_inline unsigned long vmcs_readl(unsigned long field)
 	return __vmcs_readl(field);
 }
 
-static noinline void vmwrite_error(unsigned long field, unsigned long value)
-{
-	printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
-	       field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
-	dump_stack();
-}
+#define vmx_asm1(insn, op1, error_args...)				\
+do {									\
+	asm_volatile_goto("1: " __stringify(insn) " %0\n\t"		\
+			  ".byte 0x2e\n\t" /* branch not taken hint */	\
+			  "jna %l[error]\n\t"				\
+			  _ASM_EXTABLE(1b, %l[fault])			\
+			  : : op1 : "cc" : error, fault);		\
+	return;								\
+error:									\
+	insn##_error(error_args);					\
+	return;								\
+fault:									\
+	kvm_spurious_fault();						\
+} while (0)
+
+#define vmx_asm2(insn, op1, op2, error_args...)				\
+do {									\
+	asm_volatile_goto("1: "  __stringify(insn) " %1, %0\n\t"	\
+			  ".byte 0x2e\n\t" /* branch not taken hint */	\
+			  "jna %l[error]\n\t"				\
+			  _ASM_EXTABLE(1b, %l[fault])			\
+			  : : op1, op2 : "cc" : error, fault);		\
+	return;								\
+error:									\
+	insn##_error(error_args);					\
+	return;								\
+fault:									\
+	kvm_spurious_fault();						\
+} while (0)
 
 static __always_inline void __vmcs_writel(unsigned long field, unsigned long value)
 {
-	bool error;
-
-	asm volatile (__ex("vmwrite %2, %1") CC_SET(na)
-		      : CC_OUT(na) (error) : "r"(field), "rm"(value));
-	if (unlikely(error))
-		vmwrite_error(field, value);
+	vmx_asm2(vmwrite, "r"(field), "rm"(value), field, value);
 }
 
 static __always_inline void vmcs_write16(unsigned long field, u16 value)
@@ -182,28 +206,18 @@ static __always_inline void vmcs_set_bits(unsigned long field, u32 mask)
 static inline void vmcs_clear(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
-	bool error;
 
-	asm volatile (__ex("vmclear %1") CC_SET(na)
-		      : CC_OUT(na) (error) : "m"(phys_addr));
-	if (unlikely(error))
-		printk(KERN_ERR "kvm: vmclear fail: %p/%llx\n",
-		       vmcs, phys_addr);
+	vmx_asm1(vmclear, "m"(phys_addr), vmcs, phys_addr);
 }
 
 static inline void vmcs_load(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
-	bool error;
 
 	if (static_branch_unlikely(&enable_evmcs))
 		return evmcs_load(phys_addr);
 
-	asm volatile (__ex("vmptrld %1") CC_SET(na)
-		      : CC_OUT(na) (error) : "m"(phys_addr));
-	if (unlikely(error))
-		printk(KERN_ERR "kvm: vmptrld %p/%llx failed\n",
-		       vmcs, phys_addr);
+	vmx_asm1(vmptrld, "m"(phys_addr), vmcs, phys_addr);
 }
 
 static inline void __invvpid(unsigned long ext, u16 vpid, gva_t gva)
@@ -213,11 +227,8 @@ static inline void __invvpid(unsigned long ext, u16 vpid, gva_t gva)
 		u64 rsvd : 48;
 		u64 gva;
 	} operand = { vpid, 0, gva };
-	bool error;
 
-	asm volatile (__ex("invvpid %2, %1") CC_SET(na)
-		      : CC_OUT(na) (error) : "r"(ext), "m"(operand));
-	BUG_ON(error);
+	vmx_asm2(invvpid, "r"(ext), "m"(operand), ext, vpid, gva);
 }
 
 static inline void __invept(unsigned long ext, u64 eptp, gpa_t gpa)
@@ -225,11 +236,8 @@ static inline void __invept(unsigned long ext, u64 eptp, gpa_t gpa)
 	struct {
 		u64 eptp, gpa;
 	} operand = {eptp, gpa};
-	bool error;
 
-	asm volatile (__ex("invept %2, %1") CC_SET(na)
-		      : CC_OUT(na) (error) : "r"(ext), "m"(operand));
-	BUG_ON(error);
+	vmx_asm2(invept, "r"(ext), "m"(operand), ext, eptp, gpa);
 }
 
 static inline bool vpid_sync_vcpu_addr(int vpid, gva_t addr)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 69536553446d..46689019ebf7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -343,6 +343,40 @@ static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bit
 
 void vmx_vmexit(void);
 
+#define vmx_insn_failed(fmt...)		\
+do {					\
+	WARN_ONCE(1, fmt);		\
+	pr_warn_ratelimited(fmt);	\
+} while (0)
+
+noinline void vmwrite_error(unsigned long field, unsigned long value)
+{
+	vmx_insn_failed("kvm: vmwrite failed: field=%lx val=%lx err=%d\n",
+			field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
+}
+
+noinline void vmclear_error(struct vmcs *vmcs, u64 phys_addr)
+{
+	vmx_insn_failed("kvm: vmclear failed: %p/%llx\n", vmcs, phys_addr);
+}
+
+noinline void vmptrld_error(struct vmcs *vmcs, u64 phys_addr)
+{
+	vmx_insn_failed("kvm: vmptrld failed: %p/%llx\n", vmcs, phys_addr);
+}
+
+noinline void invvpid_error(unsigned long ext, u16 vpid, gva_t gva)
+{
+	vmx_insn_failed("kvm: invvpid failed: ext=0x%lx vpid=%u gva=0x%lx\n",
+			ext, vpid, gva);
+}
+
+noinline void invept_error(unsigned long ext, u64 eptp, gpa_t gpa)
+{
+	vmx_insn_failed("kvm: invept failed: ext=0x%lx eptp=%llx gpa=0x%llx\n",
+			ext, eptp, gpa);
+}
+
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 /*
-- 
2.22.0

