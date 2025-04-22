Return-Path: <kvm+bounces-43759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B94A9626C
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23B941889262
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55492258CD7;
	Tue, 22 Apr 2025 08:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="hXQwswW0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C181F4CA4;
	Tue, 22 Apr 2025 08:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310229; cv=none; b=H7F69VpvnrhHMn1mFoA3/oP5/64Lzm1aAanVlC4VUQ4COgxcVPYs448AgkqywXSdpmPocL5c4t4SBiAHlbClcJWc6IJN/uk3RExA9dbAuw3N8aNWhVhLCA77XMXoJt4TbeOmnggqabbqJCYxekT40cPLCBATDlPQNXeHqtktTCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310229; c=relaxed/simple;
	bh=C0FspV1ZST+J24tDT6mD3ZpZzhzWXr/27gl8w0km+Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnfcEZ8+0qpsUV3NKxevr1Wmj2zL1KSfWelGU3ob4Nfw3DwK5kSWuKIocp9R7KvaDmKjfC5yYM440UmHbUeWOSO1lxKVy/ytMQeHRBhtOC81ZUsNC30yPzcjCkYeh/DUOWcz6c/RjSh/qlJyTDlDAmMQctPymYbqcjNo582kgUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=hXQwswW0; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9Z1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:03 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9Z1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310185;
	bh=SbFiqhpbEovrK+LS0VBC/tyDAZ8ViG+4jyr/a40aPa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXQwswW0EIq1GXsIdTTdlsmac4Ckmw7cL/SALCqoewd6gCGQXChXGtTsoS3S39jnV
	 Nowa4E8N7IAmCY+Y6yzI8ipd1xkA30BhCu/NC86sXKDjTYM8EIsO+8EH36a+8+ySFH
	 1brFFlqy48+6W4xkPu0fKFHrfQIHwgi49N22uBh7AtX0JMahohyUbVW8F1R22hOLan
	 q2dy+35krNJcaUnwtDmjqE2OLcuen46yUjhCfUZZK+k/PXrWjBJ9GFmNYiehg7vX99
	 OykPagDxBcFgIAGGDVuEaXYTcBRcMMpyHsNvoAeAMPc+LpKYGjR6USukd0JQncqgNw
	 zZ9D1k5iwVvyw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 21/34] x86/msr: Utilize the alternatives mechanism to write MSR
Date: Tue, 22 Apr 2025 01:22:02 -0700
Message-ID: <20250422082216.1954310-22-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The story started from tglx's reply in [1]:

  For actual performance relevant code the current PV ops mechanics
  are a horrorshow when the op defaults to the native instruction.

  look at wrmsrl():

  wrmsrl(msr, val
   wrmsr(msr, (u32)val, (u32)val >> 32))
    paravirt_write_msr(msr, low, high)
      PVOP_VCALL3(cpu.write_msr, msr, low, high)

  Which results in

	mov	$msr, %edi
	mov	$val, %rdx
	mov	%edx, %esi
	shr	$0x20, %rdx
	call	native_write_msr

  and native_write_msr() does at minimum:

	mov    %edi,%ecx
	mov    %esi,%eax
	wrmsr
	ret

  In the worst case 'ret' is going through the return thunk. Not to
  talk about function prologues and whatever.

  This becomes even more silly for trivial instructions like STI/CLI
  or in the worst case paravirt_nop().

  The call makes only sense, when the native default is an actual
  function, but for the trivial cases it's a blatant engineering
  trainwreck.

Later a consensus was reached to utilize the alternatives mechanism to
eliminate the indirect call overhead introduced by the pv_ops APIs:

    1) When built with !CONFIG_XEN_PV, X86_FEATURE_XENPV becomes a
       disabled feature, preventing the Xen code from being built
       and ensuring the native code is executed unconditionally.

    2) When built with CONFIG_XEN_PV:

       2.1) If not running on the Xen hypervisor (!X86_FEATURE_XENPV),
            the kernel runtime binary is patched to unconditionally
            jump to the native MSR write code.

       2.2) If running on the Xen hypervisor (X86_FEATURE_XENPV), the
            kernel runtime binary is patched to unconditionally jump
            to the Xen MSR write code.

The alternatives mechanism is also used to choose the new immediate
form MSR write instruction when it's available.

Consequently, remove the pv_ops MSR write APIs and the Xen callbacks.

[1]: https://lore.kernel.org/lkml/87y1h81ht4.ffs@tglx/

Originally-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/fred.h           |   2 +-
 arch/x86/include/asm/msr.h            | 294 ++++++++++++++++++++------
 arch/x86/include/asm/paravirt.h       |  25 ---
 arch/x86/include/asm/paravirt_types.h |   2 -
 arch/x86/kernel/paravirt.c            |   2 -
 arch/x86/xen/enlighten_pv.c           |  41 +---
 arch/x86/xen/xen-asm.S                |  64 ++++++
 arch/x86/xen/xen-ops.h                |   2 +
 8 files changed, 302 insertions(+), 130 deletions(-)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 12b34d5b2953..8ae4429e5401 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -101,7 +101,7 @@ static __always_inline void fred_update_rsp0(void)
 	unsigned long rsp0 = (unsigned long) task_stack_page(current) + THREAD_SIZE;
 
 	if (cpu_feature_enabled(X86_FEATURE_FRED) && (__this_cpu_read(fred_rsp0) != rsp0)) {
-		wrmsrns(MSR_IA32_FRED_RSP0, rsp0);
+		native_wrmsrq(MSR_IA32_FRED_RSP0, rsp0);
 		__this_cpu_write(fred_rsp0, rsp0);
 	}
 }
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 8f7a67b1c61c..bd3bdb3c3d23 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -75,9 +75,40 @@ static inline void do_trace_rdpmc(u32 msr, u64 val, int failed) {}
 #endif
 
 #ifdef CONFIG_XEN_PV
+extern void asm_xen_write_msr(void);
 extern u64 xen_read_pmc(int counter);
 #endif
 
+/* The GNU Assembler (Gas) with Binutils 2.40 adds WRMSRNS support */
+#if defined(CONFIG_AS_IS_GNU) && CONFIG_AS_VERSION >= 24000
+#define ASM_WRMSRNS		"wrmsrns"
+#else
+#define ASM_WRMSRNS		_ASM_BYTES(0x0f,0x01,0xc6)
+#endif
+
+/* The GNU Assembler (Gas) with Binutils 2.41 adds the .insn directive support */
+#if defined(CONFIG_AS_IS_GNU) && CONFIG_AS_VERSION >= 24100
+#define ASM_WRMSRNS_IMM			\
+	" .insn VEX.128.F3.M7.W0 0xf6 /0, %[val], %[msr]%{:u32}\n\t"
+#else
+/*
+ * Note, clang also doesn't support the .insn directive.
+ *
+ * The register operand is encoded as %rax because all uses of the immediate
+ * form MSR access instructions reference %rax as the register operand.
+ */
+#define ASM_WRMSRNS_IMM			\
+	" .byte 0xc4,0xe7,0x7a,0xf6,0xc0; .long %c[msr]"
+#endif
+
+#define PREPARE_RDX_FOR_WRMSR		\
+	"mov %%rax, %%rdx\n\t"		\
+	"shr $0x20, %%rdx\n\t"
+
+#define PREPARE_RCX_RDX_FOR_WRMSR	\
+	"mov %[msr], %%ecx\n\t"		\
+	PREPARE_RDX_FOR_WRMSR
+
 /*
  * Called only from an MSR fault handler, the instruction pointer points to
  * the MSR access instruction that caused the fault.
@@ -96,13 +127,6 @@ static __always_inline bool is_msr_imm_insn(void *ip)
 #endif
 }
 
-/*
- * __rdmsr() and __wrmsr() are the two primitives which are the bare minimum MSR
- * accessors and should not have any tracing or other functionality piggybacking
- * on them - those are *purely* for accessing MSRs and nothing more. So don't even
- * think of extending them - you will be slapped with a stinking trout or a frozen
- * shark will reach you, wherever you are! You've been warned.
- */
 static __always_inline u64 __rdmsr(u32 msr)
 {
 	DECLARE_ARGS(val, low, high);
@@ -115,14 +139,6 @@ static __always_inline u64 __rdmsr(u32 msr)
 	return EAX_EDX_VAL(val, low, high);
 }
 
-static __always_inline void __wrmsrq(u32 msr, u64 val)
-{
-	asm volatile("1: wrmsr\n"
-		     "2:\n"
-		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
-		     : : "c" (msr), "a" ((u32)val), "d" ((u32)(val >> 32)) : "memory");
-}
-
 #define native_rdmsr(msr, val1, val2)			\
 do {							\
 	u64 __val = __rdmsr((msr));			\
@@ -135,12 +151,6 @@ static __always_inline u64 native_rdmsrq(u32 msr)
 	return __rdmsr(msr);
 }
 
-#define native_wrmsr(msr, low, high)			\
-	__wrmsrq((msr), (u64)(high) << 32 | (low))
-
-#define native_wrmsrq(msr, val)				\
-	__wrmsrq((msr), (val))
-
 static inline u64 native_read_msr(u32 msr)
 {
 	u64 val;
@@ -171,7 +181,132 @@ static inline int native_read_msr_safe(u32 msr, u64 *p)
 	return err;
 }
 
-/* Can be uninlined because referenced by paravirt */
+/*
+ * There are two sets of APIs for MSR accesses: native APIs and generic APIs.
+ * Native MSR APIs execute MSR instructions directly, regardless of whether the
+ * CPU is paravirtualized or native.  Generic MSR APIs determine the appropriate
+ * MSR access method at runtime, allowing them to be used generically on both
+ * paravirtualized and native CPUs.
+ *
+ * When the compiler can determine the MSR number at compile time, the APIs
+ * with the suffix _constant() are used to enable the immediate form MSR
+ * instructions when available.  The APIs with the suffix _variable() are
+ * used when the MSR number is not known until run time.
+ *
+ * Below is a diagram illustrating the derivation of the MSR write APIs:
+ *
+ *      __native_wrmsrq_variable()    __native_wrmsrq_constant()
+ *                         \           /
+ *                          \         /
+ *                         __native_wrmsrq()   -----------------------
+ *                            /     \                                |
+ *                           /       \                               |
+ *               native_wrmsrq()    native_write_msr_safe()          |
+ *                   /    \                                          |
+ *                  /      \                                         |
+ *      native_wrmsr()    native_write_msr()                         |
+ *                                                                   |
+ *                                                                   |
+ *                                                                   |
+ *                   __xenpv_wrmsrq()                                |
+ *                         |                                         |
+ *                         |                                         |
+ *                      __wrmsrq()   <--------------------------------
+ *                       /    \
+ *                      /      \
+ *                 wrmsrq()   wrmsrq_safe()
+ *                    /          \
+ *                   /            \
+ *                wrmsr()        wrmsr_safe()
+ */
+
+/*
+ * Non-serializing WRMSR, when available.
+ *
+ * Otherwise, it falls back to a serializing WRMSR.
+ */
+static __always_inline bool __native_wrmsrq_variable(u32 msr, u64 val, int type)
+{
+#ifdef CONFIG_X86_64
+	BUILD_BUG_ON(__builtin_constant_p(msr));
+#endif
+
+	/*
+	 * WRMSR is 2 bytes.  WRMSRNS is 3 bytes.  Pad WRMSR with a redundant
+	 * DS prefix to avoid a trailing NOP.
+	 */
+	asm_inline volatile goto(
+		"1:\n"
+		ALTERNATIVE("ds wrmsr",
+			    ASM_WRMSRNS,
+			    X86_FEATURE_WRMSRNS)
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])
+
+		:
+		: "c" (msr), "a" ((u32)val), "d" ((u32)(val >> 32)), [type] "i" (type)
+		: "memory"
+		: badmsr);
+
+	return false;
+
+badmsr:
+	return true;
+}
+
+#ifdef CONFIG_X86_64
+/*
+ * Non-serializing WRMSR or its immediate form, when available.
+ *
+ * Otherwise, it falls back to a serializing WRMSR.
+ */
+static __always_inline bool __native_wrmsrq_constant(u32 msr, u64 val, int type)
+{
+	BUILD_BUG_ON(!__builtin_constant_p(msr));
+
+	asm_inline volatile goto(
+		"1:\n"
+		ALTERNATIVE_2(PREPARE_RCX_RDX_FOR_WRMSR
+			      "2: ds wrmsr",
+			      PREPARE_RCX_RDX_FOR_WRMSR
+			      ASM_WRMSRNS,
+			      X86_FEATURE_WRMSRNS,
+			      ASM_WRMSRNS_IMM,
+			      X86_FEATURE_MSR_IMM)
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For WRMSRNS immediate */
+		_ASM_EXTABLE_TYPE(2b, %l[badmsr], %c[type])	/* For WRMSR(NS) */
+
+		:
+		: [val] "a" (val), [msr] "i" (msr), [type] "i" (type)
+		: "memory", "ecx", "rdx"
+		: badmsr);
+
+	return false;
+
+badmsr:
+	return true;
+}
+#endif
+
+static __always_inline bool __native_wrmsrq(u32 msr, u64 val, int type)
+{
+#ifdef CONFIG_X86_64
+	if (__builtin_constant_p(msr))
+		return __native_wrmsrq_constant(msr, val, type);
+#endif
+
+	return __native_wrmsrq_variable(msr, val, type);
+}
+
+static __always_inline void native_wrmsrq(u32 msr, u64 val)
+{
+	__native_wrmsrq(msr, val, EX_TYPE_WRMSR);
+}
+
+static __always_inline void native_wrmsr(u32 msr, u32 low, u32 high)
+{
+	native_wrmsrq(msr, (u64)high << 32 | low);
+}
+
 static inline void notrace native_write_msr(u32 msr, u64 val)
 {
 	native_wrmsrq(msr, val);
@@ -180,22 +315,82 @@ static inline void notrace native_write_msr(u32 msr, u64 val)
 		do_trace_write_msr(msr, val, 0);
 }
 
-/* Can be uninlined because referenced by paravirt */
 static inline int notrace native_write_msr_safe(u32 msr, u64 val)
 {
-	int err;
+	int err = __native_wrmsrq(msr, val, EX_TYPE_WRMSR_SAFE) ? -EIO : 0;
 
-	asm volatile("1: wrmsr ; xor %[err],%[err]\n"
-		     "2:\n\t"
-		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_WRMSR_SAFE, %[err])
-		     : [err] "=a" (err)
-		     : "c" (msr), "0" ((u32)val), "d" ((u32)(val >> 32))
-		     : "memory");
 	if (tracepoint_enabled(write_msr))
 		do_trace_write_msr(msr, val, err);
+
 	return err;
 }
 
+#ifdef CONFIG_XEN_PV
+/* No plan to support immediate form MSR instructions in Xen */
+static __always_inline bool __xenpv_wrmsrq(u32 msr, u64 val, int type)
+{
+	asm_inline volatile goto(
+		"call asm_xen_write_msr\n\t"
+		"jnz 2f\n\t"
+		ALTERNATIVE("1: ds wrmsr",
+			    ASM_WRMSRNS,
+			    X86_FEATURE_WRMSRNS)
+		"2:\n"
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For WRMSR(NS) */
+
+		: ASM_CALL_CONSTRAINT
+		: "a" (val), "c" (msr), [type] "i" (type)
+		: "memory", "rdx"
+		: badmsr);
+
+	return false;
+
+badmsr:
+	return true;
+}
+#endif
+
+static __always_inline bool __wrmsrq(u32 msr, u64 val, int type)
+{
+	bool ret;
+
+#ifdef CONFIG_XEN_PV
+	if (cpu_feature_enabled(X86_FEATURE_XENPV))
+		return __xenpv_wrmsrq(msr, val, type);
+#endif
+
+	/*
+	 * 1) When built with !CONFIG_XEN_PV.
+	 * 2) When built with CONFIG_XEN_PV but not running on Xen hypervisor.
+	 */
+	ret = __native_wrmsrq(msr, val, type);
+
+	if (tracepoint_enabled(write_msr))
+		do_trace_write_msr(msr, val, ret ? -EIO : 0);
+
+	return ret;
+}
+
+static __always_inline void wrmsrq(u32 msr, u64 val)
+{
+	__wrmsrq(msr, val, EX_TYPE_WRMSR);
+}
+
+static __always_inline void wrmsr(u32 msr, u32 low, u32 high)
+{
+	wrmsrq(msr, (u64)high << 32 | low);
+}
+
+static __always_inline int wrmsrq_safe(u32 msr, u64 val)
+{
+	return __wrmsrq(msr, val, EX_TYPE_WRMSR_SAFE) ? -EIO : 0;
+}
+
+static __always_inline int wrmsr_safe(u32 msr, u32 low, u32 high)
+{
+	return wrmsrq_safe(msr, (u64)high << 32 | low);
+}
+
 extern int rdmsr_safe_regs(u32 regs[8]);
 extern int wrmsr_safe_regs(u32 regs[8]);
 
@@ -242,25 +437,9 @@ do {								\
 	(void)((high) = (u32)(__val >> 32));			\
 } while (0)
 
-static inline void wrmsr(u32 msr, u32 low, u32 high)
-{
-	native_write_msr(msr, (u64)high << 32 | low);
-}
-
 #define rdmsrq(msr, val)			\
 	((val) = native_read_msr((msr)))
 
-static inline void wrmsrq(u32 msr, u64 val)
-{
-	native_write_msr(msr, val);
-}
-
-/* wrmsr with exception handling */
-static inline int wrmsrq_safe(u32 msr, u64 val)
-{
-	return native_write_msr_safe(msr, val);
-}
-
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, low, high)				\
 ({								\
@@ -277,29 +456,6 @@ static inline int rdmsrq_safe(u32 msr, u64 *p)
 }
 #endif	/* !CONFIG_PARAVIRT_XXL */
 
-/* Instruction opcode for WRMSRNS supported in binutils >= 2.40 */
-#define WRMSRNS _ASM_BYTES(0x0f,0x01,0xc6)
-
-/* Non-serializing WRMSR, when available.  Falls back to a serializing WRMSR. */
-static __always_inline void wrmsrns(u32 msr, u64 val)
-{
-	/*
-	 * WRMSR is 2 bytes.  WRMSRNS is 3 bytes.  Pad WRMSR with a redundant
-	 * DS prefix to avoid a trailing NOP.
-	 */
-	asm volatile("1: " ALTERNATIVE("ds wrmsr", WRMSRNS, X86_FEATURE_WRMSRNS)
-		     "2: " _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
-		     : : "c" (msr), "a" ((u32)val), "d" ((u32)(val >> 32)));
-}
-
-/*
- * Dual u32 version of wrmsrq_safe():
- */
-static inline int wrmsr_safe(u32 msr, u32 low, u32 high)
-{
-	return wrmsrq_safe(msr, (u64)high << 32 | low);
-}
-
 struct msr __percpu *msrs_alloc(void);
 void msrs_free(struct msr __percpu *msrs);
 int msr_set_bit(u32 msr, u8 bit);
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 1bd1dad8da5a..6634f6cf801f 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -180,21 +180,11 @@ static inline u64 paravirt_read_msr(unsigned msr)
 	return PVOP_CALL1(u64, cpu.read_msr, msr);
 }
 
-static inline void paravirt_write_msr(u32 msr, u64 val)
-{
-	PVOP_VCALL2(cpu.write_msr, msr, val);
-}
-
 static inline u64 paravirt_read_msr_safe(unsigned msr, int *err)
 {
 	return PVOP_CALL2(u64, cpu.read_msr_safe, msr, err);
 }
 
-static inline int paravirt_write_msr_safe(u32 msr, u64 val)
-{
-	return PVOP_CALL2(int, cpu.write_msr_safe, msr, val);
-}
-
 #define rdmsr(msr, val1, val2)			\
 do {						\
 	u64 _l = paravirt_read_msr(msr);	\
@@ -202,26 +192,11 @@ do {						\
 	val2 = _l >> 32;			\
 } while (0)
 
-static __always_inline void wrmsr(u32 msr, u32 low, u32 high)
-{
-	paravirt_write_msr(msr, (u64)high << 32 | low);
-}
-
 #define rdmsrq(msr, val)			\
 do {						\
 	val = paravirt_read_msr(msr);		\
 } while (0)
 
-static inline void wrmsrq(u32 msr, u64 val)
-{
-	paravirt_write_msr(msr, val);
-}
-
-static inline int wrmsrq_safe(u32 msr, u64 val)
-{
-	return paravirt_write_msr_safe(msr, val)
-}
-
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, a, b)				\
 ({							\
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index d2db38c32bc5..18bb0e5bd22f 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -92,14 +92,12 @@ struct pv_cpu_ops {
 
 	/* Unsafe MSR operations.  These will warn or panic on failure. */
 	u64 (*read_msr)(unsigned int msr);
-	void (*write_msr)(u32 msr, u64 val);
 
 	/*
 	 * Safe MSR operations.
 	 * Returns 0 or -EIO.
 	 */
 	int (*read_msr_safe)(unsigned int msr, u64 *val);
-	int (*write_msr_safe)(u32 msr, u64 val);
 
 	void (*start_context_switch)(struct task_struct *prev);
 	void (*end_context_switch)(struct task_struct *next);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 28d195ad7514..62bf66f61821 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -129,9 +129,7 @@ struct paravirt_patch_template pv_ops = {
 	.cpu.write_cr0		= native_write_cr0,
 	.cpu.write_cr4		= native_write_cr4,
 	.cpu.read_msr		= native_read_msr,
-	.cpu.write_msr		= native_write_msr,
 	.cpu.read_msr_safe	= native_read_msr_safe,
-	.cpu.write_msr_safe	= native_write_msr_safe,
 	.cpu.load_tr_desc	= native_load_tr_desc,
 	.cpu.set_ldt		= native_set_ldt,
 	.cpu.load_gdt		= native_load_gdt,
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 195e6501a000..4672de7fc084 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1118,26 +1118,26 @@ static void set_seg(u32 which, u64 base)
 }
 
 /*
- * Support write_msr_safe() and write_msr() semantics.
- * With err == NULL write_msr() semantics are selected.
- * Supplying an err pointer requires err to be pre-initialized with 0.
+ * Return true to indicate the requested MSR write has been done successfully,
+ * otherwise return false to have the calling MSR write primitives in msr.h to
+ * fail.
  */
-static void xen_do_write_msr(u32 msr, u64 val, int *err)
+bool xen_write_msr(u32 msr, u64 val)
 {
 	bool emulated;
 
 	switch (msr) {
 	case MSR_FS_BASE:
 		set_seg(SEGBASE_FS, val);
-		break;
+		return true;
 
 	case MSR_KERNEL_GS_BASE:
 		set_seg(SEGBASE_GS_USER, val);
-		break;
+		return true;
 
 	case MSR_GS_BASE:
 		set_seg(SEGBASE_GS_KERNEL, val);
-		break;
+		return true;
 
 	case MSR_STAR:
 	case MSR_CSTAR:
@@ -1149,16 +1149,13 @@ static void xen_do_write_msr(u32 msr, u64 val, int *err)
 		/* Fast syscall setup is all done in hypercalls, so
 		   these are all ignored.  Stub them out here to stop
 		   Xen console noise. */
-		break;
+		return true;
 
 	default:
 		if (pmu_msr_chk_emulated(msr, &val, false, &emulated) && emulated)
-			return;
+			return true;
 
-		if (err)
-			*err = native_write_msr_safe(msr, val);
-		else
-			native_write_msr(msr, val);
+		return false;
 	}
 }
 
@@ -1170,15 +1167,6 @@ static int xen_read_msr_safe(unsigned int msr, u64 *val)
 	return err;
 }
 
-static int xen_write_msr_safe(u32 msr, u64 val)
-{
-	int err = 0;
-
-	xen_do_write_msr(msr, val, &err);
-
-	return err;
-}
-
 static u64 xen_read_msr(unsigned int msr)
 {
 	int err;
@@ -1186,13 +1174,6 @@ static u64 xen_read_msr(unsigned int msr)
 	return xen_do_read_msr(msr, xen_msr_safe ? &err : NULL);
 }
 
-static void xen_write_msr(u32 msr, u64 val)
-{
-	int err;
-
-	xen_do_write_msr(msr, val, xen_msr_safe ? &err : NULL);
-}
-
 /* This is called once we have the cpu_possible_mask */
 void __init xen_setup_vcpu_info_placement(void)
 {
@@ -1228,10 +1209,8 @@ static const typeof(pv_ops) xen_cpu_ops __initconst = {
 		.write_cr4 = xen_write_cr4,
 
 		.read_msr = xen_read_msr,
-		.write_msr = xen_write_msr,
 
 		.read_msr_safe = xen_read_msr_safe,
-		.write_msr_safe = xen_write_msr_safe,
 
 		.load_tr_desc = paravirt_nop,
 		.set_ldt = xen_set_ldt,
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 461bb1526502..eecce47fbe49 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -342,3 +342,67 @@ SYM_CODE_END(xen_entry_SYSENTER_compat)
 SYM_CODE_END(xen_entry_SYSCALL_compat)
 
 #endif	/* CONFIG_IA32_EMULATION */
+
+/*
+ * To leverage the alternatives mechanism and eliminate the overhead of Xen
+ * MSR and PMU counter access on native systems, as well as to enable new MSR
+ * instructions based on their availability, assembly trampoline functions
+ * are introduced when CONFIG_XEN_PV is enabled.
+ *
+ * Since these trampoline functions are invoked without saving callee registers,
+ * they must save the callee registers and the frame pointer.
+ */
+.macro XEN_SAVE_CALLEE_REGS_FOR_MSR
+	push %rcx
+	push %rdi
+	push %rsi
+	push %r8
+	push %r9
+	push %r10
+	push %r11
+.endm
+
+.macro XEN_RESTORE_CALLEE_REGS_FOR_MSR
+	pop %r11
+	pop %r10
+	pop %r9
+	pop %r8
+	pop %rsi
+	pop %rdi
+	pop %rcx
+.endm
+
+/*
+ * MSR number in %ecx, MSR value in %rax.
+ *
+ * %edx is set up to match %rax >> 32 like the native stub
+ * is expected to do
+ *
+ * Let xen_write_msr() return 'false' if the MSR access should
+ * be executed natively, IOW, 'true' means it has done the job.
+ *
+ * 	bool xen_write_msr(u32 msr, u64 value)
+ *
+ * If ZF=1 then this will fall down to the actual native WRMSR[NS]
+ * instruction.
+ *
+ * This also removes the need for Xen to maintain different safe and
+ * unsafe MSR routines, as the difference is handled by the same
+ * trap handler as is used natively.
+ */
+ SYM_FUNC_START(asm_xen_write_msr)
+	ENDBR
+	FRAME_BEGIN
+	push %rax		/* Save in case of native fallback */
+	XEN_SAVE_CALLEE_REGS_FOR_MSR
+	mov %ecx, %edi		/* MSR number */
+	mov %rax, %rsi		/* MSR data */
+	call xen_write_msr
+	test %al, %al		/* %al=1, i.e., ZF=0, means successfully done */
+	XEN_RESTORE_CALLEE_REGS_FOR_MSR
+	mov 4(%rsp), %edx	/* Set up %edx for native execution */
+	pop %rax
+	FRAME_END
+	RET
+SYM_FUNC_END(asm_xen_write_msr)
+EXPORT_SYMBOL_GPL(asm_xen_write_msr)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index fde9f9d7415f..56712242262a 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -146,6 +146,8 @@ __visible unsigned long xen_read_cr2_direct(void);
 /* These are not functions, and cannot be called normally */
 __visible void xen_iret(void);
 
+extern bool xen_write_msr(u32 msr, u64 val);
+
 extern int xen_panic_handler_init(void);
 
 int xen_cpuhp_setup(int (*cpu_up_prepare_cb)(unsigned int),
-- 
2.49.0


