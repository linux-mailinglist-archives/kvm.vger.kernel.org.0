Return-Path: <kvm+bounces-43760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE11A9625B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 731B83B9E42
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E97258CF1;
	Tue, 22 Apr 2025 08:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="dk8fSv+A"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866F23AE96;
	Tue, 22 Apr 2025 08:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310230; cv=none; b=TVw+gyUPWrSwSAwWWWxdnEnbo+h0r48SVeheapON4XMg/GycyHCLumHjRsw65cDUDvB+7Zekjp1LK+OTL3eBG4mjQHfsWu2mI33adEIZO4WQ2hnpgZFwmuFtjHyYV4mvE4cveNURTEoKdzWO5s3RMIdVRChCW7RGz5fUwHL63Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310230; c=relaxed/simple;
	bh=sBSTNuKiU6r8Juka0a3RzlIdidHvN0ZB3MfIi88Mk84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVf/ED9BRWSLp21Sn5+39gtERJG7fkg7gklVgIHQkrRtDgsIUORsAuPOet9DJehcRbSmaR9fJMQN/+i61OzCnGV1BPYhLylnMO02L9aYEDPTlHn+/cY7OBWY+MbCROw5HS5+5ayNHTZN/uGbDZmjv9HhPL3T0eJ0kKnAwlYqUKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=dk8fSv+A; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9a1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:05 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9a1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310187;
	bh=kSMr7RD7HY/M1n+drsBYA+dTa0bsodjA/Xja0eKYtpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dk8fSv+AkELIlRdpChMel9SZnbgJwXWLUal3Sr5HedtvF0oEaDqZZh6Mdxa7mmUOT
	 pqQdxNOxwQ4ybP6YSHN2p3qgPm+AHwGHY6vRqs34rDOln9kiX04a8OVrfTSTyv9hBb
	 34WIeGV4sB3p1zaJqo+aOqc44RNU8Kq4ppqMimtdoBQAG7VGMAbMWiZKoImvIN0gSV
	 OO41Y95uih4tueaVJRntAe4BEy85pl8eYbyQlzkndESIEuNB0Z85J+RvyIIkgLX7aw
	 WNJLctduOI+9g2lQPfZSVT+8+Ar7uKwRHKuaPTStQaEsQaOM0C52LZpyqgNVVR8jQ/
	 8Uzgb4Yr3XL9w==
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
Subject: [RFC PATCH v2 22/34] x86/msr: Utilize the alternatives mechanism to read MSR
Date: Tue, 22 Apr 2025 01:22:03 -0700
Message-ID: <20250422082216.1954310-23-xin@zytor.com>
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

To eliminate the indirect call overhead introduced by the pv_ops API,
utilize the alternatives mechanism to read MSR:

    1) When built with !CONFIG_XEN_PV, X86_FEATURE_XENPV becomes a
       disabled feature, preventing the Xen code from being built
       and ensuring the native code is executed unconditionally.

    2) When built with CONFIG_XEN_PV:

       2.1) If not running on the Xen hypervisor (!X86_FEATURE_XENPV),
            the kernel runtime binary is patched to unconditionally
            jump to the native MSR read code.

       2.2) If running on the Xen hypervisor (X86_FEATURE_XENPV), the
            kernel runtime binary is patched to unconditionally jump
            to the Xen MSR read code.

The alternatives mechanism is also used to choose the new immediate
form MSR read instruction when it's available.

Consequently, remove the pv_ops MSR read APIs and the Xen callbacks.

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h            | 277 +++++++++++++++++++-------
 arch/x86/include/asm/paravirt.h       |  40 ----
 arch/x86/include/asm/paravirt_types.h |   9 -
 arch/x86/kernel/paravirt.c            |   2 -
 arch/x86/xen/enlighten_pv.c           |  48 ++---
 arch/x86/xen/xen-asm.S                |  49 +++++
 arch/x86/xen/xen-ops.h                |   7 +
 7 files changed, 279 insertions(+), 153 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index bd3bdb3c3d23..5271cb002b23 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -75,6 +75,7 @@ static inline void do_trace_rdpmc(u32 msr, u64 val, int failed) {}
 #endif
 
 #ifdef CONFIG_XEN_PV
+extern void asm_xen_read_msr(void);
 extern void asm_xen_write_msr(void);
 extern u64 xen_read_pmc(int counter);
 #endif
@@ -88,6 +89,8 @@ extern u64 xen_read_pmc(int counter);
 
 /* The GNU Assembler (Gas) with Binutils 2.41 adds the .insn directive support */
 #if defined(CONFIG_AS_IS_GNU) && CONFIG_AS_VERSION >= 24100
+#define ASM_RDMSR_IMM			\
+	" .insn VEX.128.F2.M7.W0 0xf6 /0, %[msr]%{:u32}, %[val]\n\t"
 #define ASM_WRMSRNS_IMM			\
 	" .insn VEX.128.F3.M7.W0 0xf6 /0, %[val], %[msr]%{:u32}\n\t"
 #else
@@ -97,10 +100,17 @@ extern u64 xen_read_pmc(int counter);
  * The register operand is encoded as %rax because all uses of the immediate
  * form MSR access instructions reference %rax as the register operand.
  */
+#define ASM_RDMSR_IMM			\
+	" .byte 0xc4,0xe7,0x7b,0xf6,0xc0; .long %c[msr]"
 #define ASM_WRMSRNS_IMM			\
 	" .byte 0xc4,0xe7,0x7a,0xf6,0xc0; .long %c[msr]"
 #endif
 
+#define RDMSR_AND_SAVE_RESULT		\
+	"rdmsr\n\t"			\
+	"shl $0x20, %%rdx\n\t"		\
+	"or %%rdx, %%rax\n\t"
+
 #define PREPARE_RDX_FOR_WRMSR		\
 	"mov %%rax, %%rdx\n\t"		\
 	"shr $0x20, %%rdx\n\t"
@@ -127,35 +137,135 @@ static __always_inline bool is_msr_imm_insn(void *ip)
 #endif
 }
 
-static __always_inline u64 __rdmsr(u32 msr)
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
+ * Below is a diagram illustrating the derivation of the MSR read APIs:
+ *
+ *      __native_rdmsrq_variable()    __native_rdmsrq_constant()
+ *                         \           /
+ *                          \         /
+ *                         __native_rdmsrq()   -----------------------
+ *                            /     \                                |
+ *                           /       \                               |
+ *               native_rdmsrq()    native_read_msr_safe()           |
+ *                   /    \                                          |
+ *                  /      \                                         |
+ *      native_rdmsr()    native_read_msr()                          |
+ *                                                                   |
+ *                                                                   |
+ *                                                                   |
+ *                    __xenpv_rdmsrq()                               |
+ *                         |                                         |
+ *                         |                                         |
+ *                      __rdmsrq()   <--------------------------------
+ *                       /    \
+ *                      /      \
+ *                 rdmsrq()   rdmsrq_safe()
+ *                    /          \
+ *                   /            \
+ *                rdmsr()        rdmsr_safe()
+ */
+
+static __always_inline bool __native_rdmsrq_variable(u32 msr, u64 *val, int type)
 {
-	DECLARE_ARGS(val, low, high);
+#ifdef CONFIG_X86_64
+	BUILD_BUG_ON(__builtin_constant_p(msr));
 
-	asm volatile("1: rdmsr\n"
-		     "2:\n"
-		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_RDMSR)
-		     : EAX_EDX_RET(val, low, high) : "c" (msr));
+	asm_inline volatile goto(
+		"1:\n"
+		RDMSR_AND_SAVE_RESULT
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For RDMSR */
 
-	return EAX_EDX_VAL(val, low, high);
+		: [val] "=a" (*val)
+		: "c" (msr), [type] "i" (type)
+		: "rdx"
+		: badmsr);
+#else
+	asm_inline volatile goto(
+		"1: rdmsr\n\t"
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For RDMSR */
+
+		: "=A" (*val)
+		: "c" (msr), [type] "i" (type)
+		:
+		: badmsr);
+#endif
+
+	return false;
+
+badmsr:
+	*val = 0;
+
+	return true;
 }
 
-#define native_rdmsr(msr, val1, val2)			\
-do {							\
-	u64 __val = __rdmsr((msr));			\
-	(void)((val1) = (u32)__val);			\
-	(void)((val2) = (u32)(__val >> 32));		\
-} while (0)
+#ifdef CONFIG_X86_64
+static __always_inline bool __native_rdmsrq_constant(u32 msr, u64 *val, int type)
+{
+	BUILD_BUG_ON(!__builtin_constant_p(msr));
+
+	asm_inline volatile goto(
+		"1:\n"
+		ALTERNATIVE("mov %[msr], %%ecx\n\t"
+			    "2:\n"
+			    RDMSR_AND_SAVE_RESULT,
+			    ASM_RDMSR_IMM,
+			    X86_FEATURE_MSR_IMM)
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For RDMSR immediate */
+		_ASM_EXTABLE_TYPE(2b, %l[badmsr], %c[type])	/* For RDMSR */
+
+		: [val] "=a" (*val)
+		: [msr] "i" (msr), [type] "i" (type)
+		: "ecx", "rdx"
+		: badmsr);
+
+	return false;
+
+badmsr:
+	*val = 0;
+
+	return true;
+}
+#endif
+
+static __always_inline bool __native_rdmsrq(u32 msr, u64 *val, int type)
+{
+#ifdef CONFIG_X86_64
+	if (__builtin_constant_p(msr))
+		return __native_rdmsrq_constant(msr, val, type);
+#endif
+
+	return __native_rdmsrq_variable(msr, val, type);
+}
 
 static __always_inline u64 native_rdmsrq(u32 msr)
 {
-	return __rdmsr(msr);
+	u64 val = 0;
+
+	__native_rdmsrq(msr, &val, EX_TYPE_RDMSR);
+	return val;
 }
 
+#define native_rdmsr(msr, low, high)			\
+do {							\
+	u64 __val = native_rdmsrq(msr);			\
+	(void)((low) = (u32)__val);			\
+	(void)((high) = (u32)(__val >> 32));		\
+} while (0)
+
 static inline u64 native_read_msr(u32 msr)
 {
-	u64 val;
-
-	val = __rdmsr(msr);
+	u64 val = native_rdmsrq(msr);
 
 	if (tracepoint_enabled(read_msr))
 		do_trace_read_msr(msr, val, 0);
@@ -163,36 +273,91 @@ static inline u64 native_read_msr(u32 msr)
 	return val;
 }
 
-static inline int native_read_msr_safe(u32 msr, u64 *p)
+static inline int native_read_msr_safe(u32 msr, u64 *val)
 {
 	int err;
-	DECLARE_ARGS(val, low, high);
 
-	asm volatile("1: rdmsr ; xor %[err],%[err]\n"
-		     "2:\n\t"
-		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_RDMSR_SAFE, %[err])
-		     : [err] "=r" (err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr));
-	if (tracepoint_enabled(read_msr))
-		do_trace_read_msr(msr, EAX_EDX_VAL(val, low, high), err);
+	err = __native_rdmsrq(msr, val, EX_TYPE_RDMSR_SAFE) ? -EIO : 0;
 
-	*p = EAX_EDX_VAL(val, low, high);
+	if (tracepoint_enabled(read_msr))
+		do_trace_read_msr(msr, *val, err);
 
 	return err;
 }
 
+#ifdef CONFIG_XEN_PV
+/* No plan to support immediate form MSR instructions in Xen */
+static __always_inline bool __xenpv_rdmsrq(u32 msr, u64 *val, int type)
+{
+	asm_inline volatile goto(
+		"1: call asm_xen_read_msr\n\t"
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For CALL */
+
+		: [val] "=a" (*val), ASM_CALL_CONSTRAINT
+		: "c" (msr), [type] "i" (type)
+		: "rdx"
+		: badmsr);
+
+	return false;
+
+badmsr:
+	*val = 0;
+
+	return true;
+}
+#endif
+
+static __always_inline bool __rdmsrq(u32 msr, u64 *val, int type)
+{
+	bool ret;
+
+#ifdef CONFIG_XEN_PV
+	if (cpu_feature_enabled(X86_FEATURE_XENPV))
+		return __xenpv_rdmsrq(msr, val, type);
+#endif
+
+	/*
+	 * 1) When built with !CONFIG_XEN_PV.
+	 * 2) When built with CONFIG_XEN_PV but not running on Xen hypervisor.
+	 */
+	ret = __native_rdmsrq(msr, val, type);
+
+	if (tracepoint_enabled(read_msr))
+		do_trace_read_msr(msr, *val, ret ? -EIO : 0);
+
+	return ret;
+}
+
+#define rdmsrq(msr, val)				\
+do {							\
+	u64 ___val = 0;					\
+	__rdmsrq((msr), &___val, EX_TYPE_RDMSR);	\
+	(val) = ___val;					\
+} while (0)
+
+#define rdmsr(msr, low, high)				\
+do {							\
+	u64 __val = 0;					\
+	rdmsrq((msr), __val);				\
+	(void)((low) = (u32)__val);			\
+	(void)((high) = (u32)(__val >> 32));		\
+} while (0)
+
+static __always_inline int rdmsrq_safe(u32 msr, u64 *val)
+{
+	return __rdmsrq(msr, val, EX_TYPE_RDMSR_SAFE) ? -EIO : 0;
+}
+
+#define rdmsr_safe(msr, low, high)			\
+({							\
+	u64 __val = 0;					\
+	int __err = rdmsrq_safe((msr), &__val);		\
+	(*low) = (u32)__val;				\
+	(*high) = (u32)(__val >> 32);			\
+	__err;						\
+})
+
 /*
- * There are two sets of APIs for MSR accesses: native APIs and generic APIs.
- * Native MSR APIs execute MSR instructions directly, regardless of whether the
- * CPU is paravirtualized or native.  Generic MSR APIs determine the appropriate
- * MSR access method at runtime, allowing them to be used generically on both
- * paravirtualized and native CPUs.
- *
- * When the compiler can determine the MSR number at compile time, the APIs
- * with the suffix _constant() are used to enable the immediate form MSR
- * instructions when available.  The APIs with the suffix _variable() are
- * used when the MSR number is not known until run time.
- *
  * Below is a diagram illustrating the derivation of the MSR write APIs:
  *
  *      __native_wrmsrq_variable()    __native_wrmsrq_constant()
@@ -420,42 +585,6 @@ static __always_inline u64 rdpmcq(int counter)
 	return native_rdpmcq(counter);
 }
 
-#ifdef CONFIG_PARAVIRT_XXL
-#include <asm/paravirt.h>
-#else
-#include <linux/errno.h>
-/*
- * Access to machine-specific registers (available on 586 and better only)
- * Note: the rd* operations modify the parameters directly (without using
- * pointer indirection), this allows gcc to optimize better
- */
-
-#define rdmsr(msr, low, high)					\
-do {								\
-	u64 __val = native_read_msr((msr));			\
-	(void)((low) = (u32)__val);				\
-	(void)((high) = (u32)(__val >> 32));			\
-} while (0)
-
-#define rdmsrq(msr, val)			\
-	((val) = native_read_msr((msr)))
-
-/* rdmsr with exception handling */
-#define rdmsr_safe(msr, low, high)				\
-({								\
-	u64 __val;						\
-	int __err = native_read_msr_safe((msr), &__val);	\
-	(*low) = (u32)__val;					\
-	(*high) = (u32)(__val >> 32);				\
-	__err;							\
-})
-
-static inline int rdmsrq_safe(u32 msr, u64 *p)
-{
-	return native_read_msr_safe(msr, p);
-}
-#endif	/* !CONFIG_PARAVIRT_XXL */
-
 struct msr __percpu *msrs_alloc(void);
 void msrs_free(struct msr __percpu *msrs);
 int msr_set_bit(u32 msr, u8 bit);
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 6634f6cf801f..e248a77b719f 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -175,46 +175,6 @@ static inline void __write_cr4(unsigned long x)
 	PVOP_VCALL1(cpu.write_cr4, x);
 }
 
-static inline u64 paravirt_read_msr(unsigned msr)
-{
-	return PVOP_CALL1(u64, cpu.read_msr, msr);
-}
-
-static inline u64 paravirt_read_msr_safe(unsigned msr, int *err)
-{
-	return PVOP_CALL2(u64, cpu.read_msr_safe, msr, err);
-}
-
-#define rdmsr(msr, val1, val2)			\
-do {						\
-	u64 _l = paravirt_read_msr(msr);	\
-	val1 = (u32)_l;				\
-	val2 = _l >> 32;			\
-} while (0)
-
-#define rdmsrq(msr, val)			\
-do {						\
-	val = paravirt_read_msr(msr);		\
-} while (0)
-
-/* rdmsr with exception handling */
-#define rdmsr_safe(msr, a, b)				\
-({							\
-	int _err;					\
-	u64 _l = paravirt_read_msr_safe(msr, &_err);	\
-	(*a) = (u32)_l;					\
-	(*b) = _l >> 32;				\
-	_err;						\
-})
-
-static inline int rdmsrq_safe(unsigned msr, u64 *p)
-{
-	int err;
-
-	*p = paravirt_read_msr_safe(msr, &err);
-	return err;
-}
-
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
 	PVOP_VCALL2(cpu.alloc_ldt, ldt, entries);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 18bb0e5bd22f..ae31ecf08933 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -90,15 +90,6 @@ struct pv_cpu_ops {
 	void (*cpuid)(unsigned int *eax, unsigned int *ebx,
 		      unsigned int *ecx, unsigned int *edx);
 
-	/* Unsafe MSR operations.  These will warn or panic on failure. */
-	u64 (*read_msr)(unsigned int msr);
-
-	/*
-	 * Safe MSR operations.
-	 * Returns 0 or -EIO.
-	 */
-	int (*read_msr_safe)(unsigned int msr, u64 *val);
-
 	void (*start_context_switch)(struct task_struct *prev);
 	void (*end_context_switch)(struct task_struct *next);
 #endif
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 62bf66f61821..9f5eb8a78040 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -128,8 +128,6 @@ struct paravirt_patch_template pv_ops = {
 	.cpu.read_cr0		= native_read_cr0,
 	.cpu.write_cr0		= native_write_cr0,
 	.cpu.write_cr4		= native_write_cr4,
-	.cpu.read_msr		= native_read_msr,
-	.cpu.read_msr_safe	= native_read_msr_safe,
 	.cpu.load_tr_desc	= native_load_tr_desc,
 	.cpu.set_ldt		= native_set_ldt,
 	.cpu.load_gdt		= native_load_gdt,
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 4672de7fc084..267e241b9236 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1086,19 +1086,26 @@ static void xen_write_cr4(unsigned long cr4)
 	native_write_cr4(cr4);
 }
 
-static u64 xen_do_read_msr(unsigned int msr, int *err)
+/*
+ * Return true in xen_rdmsr_ret_type to indicate the requested MSR read has
+ * been done successfully.
+ */
+struct xen_rdmsr_ret_type xen_read_msr(u32 msr)
 {
-	u64 val = 0;	/* Avoid uninitialized value for safe variant. */
-	bool emulated;
+	struct xen_rdmsr_ret_type ret;
 
-	if (pmu_msr_chk_emulated(msr, &val, true, &emulated) && emulated)
-		return val;
+	ret.done = true;
 
-	if (err)
-		*err = native_read_msr_safe(msr, &val);
-	else
-		val = native_read_msr(msr);
+	if (pmu_msr_chk_emulated(msr, &ret.val, true, &ret.done) && ret.done)
+		return ret;
+
+	ret.val = 0;
+	ret.done = false;
+	return ret;
+}
 
+u64 xen_read_msr_fixup(u32 msr, u64 val)
+{
 	switch (msr) {
 	case MSR_IA32_APICBASE:
 		val &= ~X2APIC_ENABLE;
@@ -1107,7 +1114,11 @@ static u64 xen_do_read_msr(unsigned int msr, int *err)
 		else
 			val &= ~MSR_IA32_APICBASE_BSP;
 		break;
+
+	default:
+		break;
 	}
+
 	return val;
 }
 
@@ -1159,21 +1170,6 @@ bool xen_write_msr(u32 msr, u64 val)
 	}
 }
 
-static int xen_read_msr_safe(unsigned int msr, u64 *val)
-{
-	int err;
-
-	*val = xen_do_read_msr(msr, &err);
-	return err;
-}
-
-static u64 xen_read_msr(unsigned int msr)
-{
-	int err;
-
-	return xen_do_read_msr(msr, xen_msr_safe ? &err : NULL);
-}
-
 /* This is called once we have the cpu_possible_mask */
 void __init xen_setup_vcpu_info_placement(void)
 {
@@ -1208,10 +1204,6 @@ static const typeof(pv_ops) xen_cpu_ops __initconst = {
 
 		.write_cr4 = xen_write_cr4,
 
-		.read_msr = xen_read_msr,
-
-		.read_msr_safe = xen_read_msr_safe,
-
 		.load_tr_desc = paravirt_nop,
 		.set_ldt = xen_set_ldt,
 		.load_gdt = xen_load_gdt,
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index eecce47fbe49..62270ef85c56 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -406,3 +406,52 @@ SYM_CODE_END(xen_entry_SYSCALL_compat)
 	RET
 SYM_FUNC_END(asm_xen_write_msr)
 EXPORT_SYMBOL_GPL(asm_xen_write_msr)
+
+/*
+ * MSR number in %ecx, MSR value will be returned in %rax.
+ *
+ * The prototype of the Xen C code:
+ * 	struct { u64 val, bool done } xen_read_msr(u32 msr)
+ */
+SYM_FUNC_START(asm_xen_read_msr)
+	ENDBR
+	FRAME_BEGIN
+	XEN_SAVE_CALLEE_REGS_FOR_MSR
+	mov %ecx, %edi		/* MSR number */
+	call xen_read_msr
+	test %dl, %dl		/* %dl=1, i.e., ZF=0, meaning successfully done */
+	XEN_RESTORE_CALLEE_REGS_FOR_MSR
+	jnz 2f
+
+	/*
+	 * Falls through to the native RDMSR instruction if xen_read_msr() failed,
+	 * i.e., the MSR access should be executed natively, which will trigger a
+	 * #GP fault...
+	 */
+1:	rdmsr
+
+	/*
+	 * Note, #GP on RDMSR is reflected to the caller of this function through
+	 * EX_TYPE_FUNC_REWIND, which enforces a coupling between the caller and
+	 * callee, IOW the callee is able to calculate the address of the CALL
+	 * instruction in the caller that invoked it.
+	 *
+	 * The top of the stack points directly at the return address;
+	 * back up by 5 bytes (length of the CALL instruction in the caller) from
+	 * the return address.
+	 */
+	_ASM_EXTABLE_FUNC_REWIND(1b, -5, FRAME_OFFSET / (BITS_PER_LONG / 8))
+
+	shl $0x20, %rdx
+	or %rdx, %rax
+
+	XEN_SAVE_CALLEE_REGS_FOR_MSR
+	mov %ecx, %edi
+	mov %rax, %rsi
+	call xen_read_msr_fixup
+	XEN_RESTORE_CALLEE_REGS_FOR_MSR
+
+2:	FRAME_END
+	RET
+SYM_FUNC_END(asm_xen_read_msr)
+EXPORT_SYMBOL_GPL(asm_xen_read_msr)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 56712242262a..483526ec13c6 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -146,7 +146,14 @@ __visible unsigned long xen_read_cr2_direct(void);
 /* These are not functions, and cannot be called normally */
 __visible void xen_iret(void);
 
+struct xen_rdmsr_ret_type {
+	u64 val;
+	bool done;
+};
+
 extern bool xen_write_msr(u32 msr, u64 val);
+extern struct xen_rdmsr_ret_type xen_read_msr(u32 msr);
+extern u64 xen_read_msr_fixup(u32 msr, u64 val);
 
 extern int xen_panic_handler_init(void);
 
-- 
2.49.0


