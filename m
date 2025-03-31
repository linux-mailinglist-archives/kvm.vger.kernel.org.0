Return-Path: <kvm+bounces-42235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 734C2A761C6
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C7EF168D94
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D9FA1E5B76;
	Mon, 31 Mar 2025 08:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="YZ0iWw1g"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA25E1DD889;
	Mon, 31 Mar 2025 08:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409456; cv=none; b=ZlbanS14LpovZnFu+skJ8b9iaERJ7dQ5c+zOqTNCB2HptwBGWqSEW0f8aceFuYnsisAv/dlTbBhYz2A+aeO9Hix7Bdf5ilDb4AmuYdx+q8XSILgoZAwWWLPzE9CLGPc8ztgEcdN9D+gyXrRknFgLyz5yYhQHVR4K3CJ+cAes/Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409456; c=relaxed/simple;
	bh=qU9mZV/Ilpao3OzuBn2p54VPGVrfDdtWqmvb8dbK1/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UohaNP3efj+4OsRBuJjlrGiBqfIaitP/UM73hFgvC50aajU5wIKxA55dHRvC6WfUmUqp3pfGWGO4jqpW6RnwAK9W3XJJ00ql97kZvusJJ6Flm3JR/21GWx5Ubm5eUqbLpdjfWzW15Rup7CGQ56vtXWTPq2iHEV1J4t6sUG10U68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=YZ0iWw1g; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52V8Mp0D3171319
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 31 Mar 2025 01:23:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52V8Mp0D3171319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743409406;
	bh=MTNAHE0XoF/3VfQI20ic/94siCvLM4yHxZJbzupiGV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZ0iWw1g3Cln5AvXjilDQAKtaaSHfwJ+OM5wjPktUJyEqApfbUfhM09OIuU8QP2ZZ
	 mYIqHTSj9WbWaRawl1ndfEI99/JZFReL4cHv2Bb1eaQsckThi+Yd7S/58DdR7MADp7
	 brFPhnzRo2b4ImK45TMad4AgaT1rzmLAJjkaQzPMD0yRdou+z3xLfMDvndeKh03uRp
	 /+zHv3a4TGJZ32AoXQQXNfLWD3AqlBnWwlZqVKdNR8IVx0jW2LdzRYxxK+IYI7jo1X
	 8Jzz5y7bJekuTfQ2vMotkE1uZCAR+Ikj1SSqu1wAmeaafKH5SDC3fXFrxE045okmoi
	 kvDiyWI69VGjg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v1 13/15] x86/msr: Use the alternatives mechanism to read MSR
Date: Mon, 31 Mar 2025 01:22:49 -0700
Message-ID: <20250331082251.3171276-14-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250331082251.3171276-1-xin@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also add support for the immediate form MSR read support.

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h            | 274 ++++++++++++++++++++------
 arch/x86/include/asm/paravirt.h       |  40 ----
 arch/x86/include/asm/paravirt_types.h |   9 -
 arch/x86/kernel/paravirt.c            |   2 -
 arch/x86/xen/enlighten_pv.c           |  45 ++---
 arch/x86/xen/xen-asm.S                |  34 ++++
 arch/x86/xen/xen-ops.h                |   7 +
 7 files changed, 276 insertions(+), 135 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 066cde11254a..fc93c2601853 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -74,6 +74,8 @@ static inline void do_trace_rdpmc(unsigned int msr, u64 val, int failed) {}
 #endif
 
 #ifdef CONFIG_CC_IS_GCC
+#define ASM_RDMSR_IMM			\
+	" .insn VEX.128.F2.M7.W0 0xf6 /0, %[msr]%{:u32}, %[val]\n\t"
 #define ASM_WRMSRNS_IMM			\
 	" .insn VEX.128.F3.M7.W0 0xf6 /0, %[val], %[msr]%{:u32}\n\t"
 #endif
@@ -85,10 +87,17 @@ static inline void do_trace_rdpmc(unsigned int msr, u64 val, int failed) {}
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
+	"or %%rdx, %[val]\n\t"
+
 #define PREPARE_RDX_FOR_WRMSR		\
 	"mov %%rax, %%rdx\n\t"		\
 	"shr $0x20, %%rdx\n\t"
@@ -142,6 +151,7 @@ static __always_inline enum pv_msr_action get_pv_msr_action(const u32 msr)
 	}
 }
 
+extern void asm_xen_read_msr(void);
 extern void asm_xen_write_msr(void);
 #else
 static __always_inline enum pv_msr_action get_pv_msr_action(const u32 msr)
@@ -150,35 +160,95 @@ static __always_inline enum pv_msr_action get_pv_msr_action(const u32 msr)
 }
 #endif
 
-static __always_inline unsigned long long __rdmsr(unsigned int msr)
+static __always_inline bool __native_rdmsr_variable(const u32 msr, u64 *val, const int type)
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
+		: "memory", "rdx"
+		: badmsr);
+#else
+	asm_inline volatile goto(
+		"1: rdmsr\n\t"
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For RDMSR */
+
+		: "=A" (*val)
+		: "c" (msr), [type] "i" (type)
+		: "memory"
+		: badmsr);
+#endif
+
+	return false;
+
+badmsr:
+	return true;
+}
+
+#ifdef CONFIG_X86_64
+static __always_inline bool __native_rdmsr_constant(const u32 msr, u64 *val, const int type)
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
+static __always_inline bool __native_rdmsr(const u32 msr, u64 *val, const int type)
+{
+#ifdef CONFIG_X86_64
+	if (__builtin_constant_p(msr))
+		return __native_rdmsr_constant(msr, val, type);
+#endif
+
+	return __native_rdmsr_variable(msr, val, type);
 }
 
-#define native_rdmsr(msr, val1, val2)			\
+#define native_rdmsr(msr, low, high)			\
 do {							\
-	u64 __val = __rdmsr((msr));			\
-	(void)((val1) = (u32)__val);			\
-	(void)((val2) = (u32)(__val >> 32));		\
+	u64 __val = 0;					\
+	__native_rdmsr((msr), &__val, EX_TYPE_RDMSR);	\
+	(void)((low) = (u32)__val);			\
+	(void)((high) = (u32)(__val >> 32));		\
 } while (0)
 
 static __always_inline u64 native_rdmsrl(const u32 msr)
 {
-	return __rdmsr(msr);
+	u64 val = 0;
+
+	__native_rdmsr(msr, &val, EX_TYPE_RDMSR);
+	return val;
 }
 
-static inline unsigned long long native_read_msr(unsigned int msr)
+static inline u64 native_read_msr(const u32 msr)
 {
-	unsigned long long val;
+	u64 val = 0;
 
-	val = __rdmsr(msr);
+	__native_rdmsr(msr, &val, EX_TYPE_RDMSR);
 
 	if (tracepoint_enabled(read_msr))
 		do_trace_read_msr(msr, val, 0);
@@ -186,19 +256,139 @@ static inline unsigned long long native_read_msr(unsigned int msr)
 	return val;
 }
 
-static inline unsigned long long native_read_msr_safe(unsigned int msr,
-						      int *err)
+static inline u64 native_read_msr_safe(const u32 msr, int *err)
 {
-	DECLARE_ARGS(val, low, high);
+	u64 val = 0;
+
+	*err = __native_rdmsr(msr, &val, EX_TYPE_RDMSR_SAFE) ? -EIO : 0;
 
-	asm volatile("1: rdmsr ; xor %[err],%[err]\n"
-		     "2:\n\t"
-		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_RDMSR_SAFE, %[err])
-		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr));
 	if (tracepoint_enabled(read_msr))
-		do_trace_read_msr(msr, EAX_EDX_VAL(val, low, high), *err);
-	return EAX_EDX_VAL(val, low, high);
+		do_trace_read_msr(msr, val, *err);
+
+	return val;
+}
+
+static __always_inline bool __rdmsr_variable(const u32 msr, u64 *val, const int type)
+{
+#ifdef CONFIG_X86_64
+	BUILD_BUG_ON(__builtin_constant_p(msr));
+
+	asm_inline volatile goto(
+		"1:\n"
+		ALTERNATIVE(RDMSR_AND_SAVE_RESULT,
+			    "call asm_xen_read_msr\n\t",
+			    X86_FEATURE_XENPV)
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For RDMSR and CALL */
+
+		: [val] "=a" (*val), ASM_CALL_CONSTRAINT
+		: "c" (msr), [type] "i" (type)
+		: "memory", "rdx"
+		: badmsr);
+
+	return false;
+
+badmsr:
+	return true;
+#else
+	return __native_rdmsr_variable(msr, val, type);
+#endif
+}
+
+static __always_inline bool __rdmsr_variable_all(const u32 msr, u64 *val, const int type)
+{
+	const enum pv_msr_action action = get_pv_msr_action(msr);
+
+	if (action == PV_MSR_PV) {
+		return __rdmsr_variable(msr, val, type);
+	} else if (action == PV_MSR_IGNORE) {
+		if (cpu_feature_enabled(X86_FEATURE_XENPV))
+			return false;
+	}
+
+	return __native_rdmsr_variable(msr, val, type);
+}
+
+#ifdef CONFIG_X86_64
+static __always_inline bool __rdmsr_constant(const u32 msr, u64 *val, const int type)
+{
+	BUILD_BUG_ON(!__builtin_constant_p(msr));
+
+	asm_inline volatile goto(
+		"1:\n"
+		ALTERNATIVE_2("mov %[msr], %%ecx\n\t"
+			      "2:\n"
+			      RDMSR_AND_SAVE_RESULT,
+			      ASM_RDMSR_IMM,
+			      X86_FEATURE_MSR_IMM,
+			      "mov %[msr], %%ecx\n\t"
+			      "call asm_xen_read_msr\n\t",
+			      X86_FEATURE_XENPV)
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For RDMSR immediate */
+		_ASM_EXTABLE_TYPE(2b, %l[badmsr], %c[type])	/* For RDMSR and CALL */
+
+		: [val] "=a" (*val), ASM_CALL_CONSTRAINT
+		: [msr] "i" (msr), [type] "i" (type)
+		: "memory", "ecx", "rdx"
+		: badmsr);
+
+	return false;
+
+badmsr:
+	return true;
+}
+
+static __always_inline bool __rdmsr_constant_all(const u32 msr, u64 *val, const int type)
+{
+	const enum pv_msr_action action = get_pv_msr_action(msr);
+
+	if (action == PV_MSR_PV) {
+		return __rdmsr_constant(msr, val, type);
+	} else if (action == PV_MSR_IGNORE) {
+		if (cpu_feature_enabled(X86_FEATURE_XENPV))
+			return false;
+	}
+
+	return __native_rdmsr_constant(msr, val, type);
+}
+#endif
+
+static __always_inline bool __rdmsr(const u32 msr, u64 *val, const int type)
+{
+#ifdef CONFIG_X86_64
+	if (__builtin_constant_p(msr))
+		return __rdmsr_constant_all(msr, val, type);
+#endif
+
+	return __rdmsr_variable_all(msr, val, type);
+}
+
+#define rdmsr(msr, low, high)				\
+do {							\
+	u64 __val = 0;					\
+	__rdmsr((msr), &__val, EX_TYPE_RDMSR);		\
+	(void)((low) = (u32)__val);			\
+	(void)((high) = (u32)(__val >> 32));		\
+} while (0)
+
+#define rdmsrl(msr, val)				\
+do {							\
+	u64 __val = 0;					\
+	__rdmsr((msr), &__val, EX_TYPE_RDMSR);		\
+	(val) = __val;					\
+} while (0)
+
+#define rdmsr_safe(msr, low, high)						\
+({										\
+	u64 __val = 0;								\
+	int __err = __rdmsr((msr), &__val, EX_TYPE_RDMSR_SAFE) ? -EIO : 0;	\
+	(*low) = (u32)__val;							\
+	(*high) = (u32)(__val >> 32);						\
+	__err;									\
+})
+
+static __always_inline int rdmsrl_safe(const u32 msr, u64 *val)
+{
+	return __rdmsr(msr, val, EX_TYPE_RDMSR_SAFE) ? -EIO : 0;
 }
 
 /*
@@ -503,40 +693,6 @@ static inline unsigned long long native_read_pmc(int counter)
  * Note: the rd* operations modify the parameters directly (without using
  * pointer indirection), this allows gcc to optimize better
  */
-
-#define rdmsr(msr, low, high)					\
-do {								\
-	u64 __val = native_read_msr((msr));			\
-	(void)((low) = (u32)__val);				\
-	(void)((high) = (u32)(__val >> 32));			\
-} while (0)
-
-#define rdmsrl(msr, val)			\
-	((val) = native_read_msr((msr)))
-
-static inline void wrmsrl(u32 msr, u64 val)
-{
-	native_write_msr(msr, val);
-}
-
-/* rdmsr with exception handling */
-#define rdmsr_safe(msr, low, high)				\
-({								\
-	int __err;						\
-	u64 __val = native_read_msr_safe((msr), &__err);	\
-	(*low) = (u32)__val;					\
-	(*high) = (u32)(__val >> 32);				\
-	__err;							\
-})
-
-static inline int rdmsrl_safe(unsigned int msr, unsigned long long *p)
-{
-	int err;
-
-	*p = native_read_msr_safe(msr, &err);
-	return err;
-}
-
 #define rdpmc(counter, low, high)			\
 do {							\
 	u64 _l = native_read_pmc((counter));		\
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 351feb890ab0..7ddb71ed9d0c 100644
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
-#define rdmsrl(msr, val)			\
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
-static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
-{
-	int err;
-
-	*p = paravirt_read_msr_safe(msr, &err);
-	return err;
-}
-
 static inline unsigned long long paravirt_read_pmc(int counter)
 {
 	return PVOP_CALL1(u64, cpu.read_pmc, counter);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 8a563576d70e..5c57e6e4115f 100644
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
-	 * read sets err to 0 or -EIO.  write returns 0 or -EIO.
-	 */
-	u64 (*read_msr_safe)(unsigned int msr, int *err);
-
 	u64 (*read_pmc)(int counter);
 
 	void (*start_context_switch)(struct task_struct *prev);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ffb04445f97e..e3d4f9869779 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -128,8 +128,6 @@ struct paravirt_patch_template pv_ops = {
 	.cpu.read_cr0		= native_read_cr0,
 	.cpu.write_cr0		= native_write_cr0,
 	.cpu.write_cr4		= native_write_cr4,
-	.cpu.read_msr		= native_read_msr,
-	.cpu.read_msr_safe	= native_read_msr_safe,
 	.cpu.read_pmc		= native_read_pmc,
 	.cpu.load_tr_desc	= native_load_tr_desc,
 	.cpu.set_ldt		= native_set_ldt,
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index d02f55bfa869..e49f16278487 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1087,19 +1087,26 @@ static void xen_write_cr4(unsigned long cr4)
 	native_write_cr4(cr4);
 }
 
-static u64 xen_do_read_msr(unsigned int msr, int *err)
+/*
+ * Return true in xen_rdmsr_ret_type to indicate the requested MSR read has
+ * been done successfully.
+ */
+struct xen_rdmsr_ret_type xen_do_read_msr(u32 msr)
 {
-	u64 val = 0;	/* Avoid uninitialized value for safe variant. */
-	bool emulated;
+	struct xen_rdmsr_ret_type ret;
 
-	if (pmu_msr_chk_emulated(msr, &val, true, &emulated) && emulated)
-		return val;
+	ret.done = true;
 
-	if (err)
-		val = native_read_msr_safe(msr, err);
-	else
-		val = native_read_msr(msr);
+	if (pmu_msr_chk_emulated(msr, &ret.val, true, &ret.done) && ret.done)
+		return ret;
+
+	ret.val = 0;
+	ret.done = false;
+	return ret;
+}
 
+u64 xen_do_read_msr_fixup(u32 msr, u64 val)
+{
 	switch (msr) {
 	case MSR_IA32_APICBASE:
 		val &= ~X2APIC_ENABLE;
@@ -1108,7 +1115,11 @@ static u64 xen_do_read_msr(unsigned int msr, int *err)
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
 
@@ -1160,18 +1171,6 @@ bool xen_do_write_msr(u32 msr, u64 val)
 	}
 }
 
-static u64 xen_read_msr_safe(unsigned int msr, int *err)
-{
-	return xen_do_read_msr(msr, err);
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
@@ -1206,10 +1205,6 @@ static const typeof(pv_ops) xen_cpu_ops __initconst = {
 
 		.write_cr4 = xen_write_cr4,
 
-		.read_msr = xen_read_msr,
-
-		.read_msr_safe = xen_read_msr_safe,
-
 		.read_pmc = xen_read_pmc,
 
 		.load_tr_desc = paravirt_nop,
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index e672632b1cc0..6e7a9daa03d4 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -399,3 +399,37 @@ SYM_CODE_END(xen_entry_SYSCALL_compat)
 	RET
 SYM_FUNC_END(asm_xen_write_msr)
 EXPORT_SYMBOL_GPL(asm_xen_write_msr)
+
+/*
+ * The prototype of the Xen C code:
+ * 	struct { u64 val, bool done } xen_do_read_msr(u32 msr)
+ */
+SYM_FUNC_START(asm_xen_read_msr)
+	ENDBR
+	FRAME_BEGIN
+	XEN_SAVE_CALLEE_REGS_FOR_MSR
+	mov %ecx, %edi		/* MSR number */
+	call xen_do_read_msr
+	test %dl, %dl		/* %dl=1, i.e., ZF=0, meaning successfully done */
+	XEN_RESTORE_CALLEE_REGS_FOR_MSR
+	jnz 2f
+
+1:	rdmsr
+	_ASM_EXTABLE_FUNC_REWIND(1b, -5, FRAME_OFFSET / (BITS_PER_LONG / 8))
+	shl $0x20, %rdx
+	or %rdx, %rax
+	/*
+	 * The top of the stack points directly at the return address;
+	 * back up by 5 bytes from the return address.
+	 */
+
+	XEN_SAVE_CALLEE_REGS_FOR_MSR
+	mov %ecx, %edi
+	mov %rax, %rsi
+	call xen_do_read_msr_fixup
+	XEN_RESTORE_CALLEE_REGS_FOR_MSR
+
+2:	FRAME_END
+	RET
+SYM_FUNC_END(asm_xen_read_msr)
+EXPORT_SYMBOL_GPL(asm_xen_read_msr)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index fc3c55871037..46efeaa4bbd3 100644
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
 extern bool xen_do_write_msr(u32 msr, u64 val);
+extern struct xen_rdmsr_ret_type xen_do_read_msr(u32 msr);
+extern u64 xen_do_read_msr_fixup(u32 msr, u64 val);
 
 extern int xen_panic_handler_init(void);
 
-- 
2.49.0


