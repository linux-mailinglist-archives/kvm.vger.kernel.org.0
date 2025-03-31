Return-Path: <kvm+bounces-42243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 544B3A76235
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:30:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 678001889ACD
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1213A1F09AD;
	Mon, 31 Mar 2025 08:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="YQm0yq2/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B901E7C03;
	Mon, 31 Mar 2025 08:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409468; cv=none; b=EAdRub3EgrsqpvJBrfwQky2hFYcysC8JARzQWBdGcKoLpQilfluiMYgFrLFXVigCf5RqisWv2hVDBHOYrVM3wM703OAIxVII2UnNKnVm5i+H5cBxT6ekn8xqE2Ar26FcgUH9TVLrp1UuRQp3L6zCjRxC1Z38xX7zMcl0lRySjIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409468; c=relaxed/simple;
	bh=bDcjpXAKJC+ghOaegd6KXIC08jV5/IcjH/5FkEK+PDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYynPxRlUyMLwStLvVLYyPzqeEA+osOpRxeOTne9HP7NAz4/59FphCA4PNliIW646VsdPbbinRjP++C4kpTl/2qiD+rxwt70GpYRZFl4Z6oO42xsa+NSE6PaMVagZK7np4sQfT8qSVVwXKCbKVSqp9GzmHdEXDNnRUtROxhiElk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=YQm0yq2/; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52V8Mp0C3171319
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 31 Mar 2025 01:23:22 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52V8Mp0C3171319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743409404;
	bh=NQD+TN3+0whhA/vOhooP6nsjLYQCN7OafGSYujp9CME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQm0yq2/abEsmYWAyVQbq5tQv70sDODfxwc7WwdlTgBlPxMIbMLpLMH0zVC9Lcc7p
	 Qvuu6AGlbcJx1X1yi5tNXQ5AKhi8sR5rEB9RkE6QsQL5YjMdPz8fU2pc5ce/HEbaab
	 pUpzIeMuYD0iFpFUHOnJVdPXd2WtqkGUYx9CVAc5El2OjF8wD56yIUXJ4kaoH1bad9
	 SJRD+yopao3aWS761ht+LyTO99joEjJ6c9vMcU/A45DJvYphj3Yt7CI/55kNcF9glQ
	 eECNCo/JvLAwqkbaYdbrxsCEMwYktqL28wYgtJYsHjujTsS41z8JotrbNwa4TedKYG
	 jPVVW5zxNNySA==
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
Subject: [RFC PATCH v1 12/15] x86/msr: Use the alternatives mechanism to write MSR
Date: Mon, 31 Mar 2025 01:22:48 -0700
Message-ID: <20250331082251.3171276-13-xin@zytor.com>
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

Also add support for the immediate form MSR write support.

Originally-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/fred.h           |   2 +-
 arch/x86/include/asm/msr.h            | 340 ++++++++++++++++++++++----
 arch/x86/include/asm/paravirt.h       |  22 --
 arch/x86/include/asm/paravirt_types.h |   2 -
 arch/x86/kernel/paravirt.c            |   2 -
 arch/x86/xen/enlighten_pv.c           |  63 ++---
 arch/x86/xen/xen-asm.S                |  55 +++++
 arch/x86/xen/xen-ops.h                |   2 +
 8 files changed, 362 insertions(+), 126 deletions(-)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 2a29e5216881..e6eab64095d4 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -100,7 +100,7 @@ static __always_inline void fred_update_rsp0(void)
 	unsigned long rsp0 = (unsigned long) task_stack_page(current) + THREAD_SIZE;
 
 	if (cpu_feature_enabled(X86_FEATURE_FRED) && (__this_cpu_read(fred_rsp0) != rsp0)) {
-		wrmsrns(MSR_IA32_FRED_RSP0, rsp0);
+		native_wrmsrl(MSR_IA32_FRED_RSP0, rsp0);
 		__this_cpu_write(fred_rsp0, rsp0);
 	}
 }
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index da4f2f6d127f..066cde11254a 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -8,6 +8,7 @@
 
 #include <asm/asm.h>
 #include <asm/errno.h>
+#include <asm/cpufeature.h>
 #include <asm/cpumask.h>
 #include <uapi/asm/msr.h>
 #include <asm/shared/msr.h>
@@ -72,13 +73,83 @@ static inline void do_trace_read_msr(unsigned int msr, u64 val, int failed) {}
 static inline void do_trace_rdpmc(unsigned int msr, u64 val, int failed) {}
 #endif
 
+#ifdef CONFIG_CC_IS_GCC
+#define ASM_WRMSRNS_IMM			\
+	" .insn VEX.128.F3.M7.W0 0xf6 /0, %[val], %[msr]%{:u32}\n\t"
+#endif
+
+#ifdef CONFIG_CC_IS_CLANG
 /*
- * __rdmsr() and __wrmsr() are the two primitives which are the bare minimum MSR
- * accessors and should not have any tracing or other functionality piggybacking
- * on them - those are *purely* for accessing MSRs and nothing more. So don't even
- * think of extending them - you will be slapped with a stinking trout or a frozen
- * shark will reach you, wherever you are! You've been warned.
+ * clang doesn't support the insn directive.
+ *
+ * The register operand is encoded as %rax because all uses of the immediate
+ * form MSR access instructions reference %rax as the register operand.
  */
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
+enum pv_msr_action {
+	PV_MSR_NATIVE,
+	PV_MSR_PV,
+	PV_MSR_IGNORE,
+};
+
+#ifdef CONFIG_XEN_PV
+static __always_inline enum pv_msr_action get_pv_msr_action(const u32 msr)
+{
+	if (!__builtin_constant_p(msr)) {
+		/* Is it safe to blindly do so? */
+		return PV_MSR_NATIVE;
+	}
+
+	switch (msr) {
+	case MSR_FS_BASE:
+	case MSR_KERNEL_GS_BASE:
+	case MSR_GS_BASE:
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+	case MSR_CORE_PERF_FIXED_CTR_CTRL:
+	case MSR_IA32_APICBASE:
+		return PV_MSR_PV;
+
+	case MSR_STAR:
+	case MSR_CSTAR:
+	case MSR_LSTAR:
+	case MSR_SYSCALL_MASK:
+	case MSR_IA32_SYSENTER_CS:
+	case MSR_IA32_SYSENTER_ESP:
+	case MSR_IA32_SYSENTER_EIP:
+		return PV_MSR_IGNORE;
+
+	default:
+		/*
+		 * MSR access instructions RDMSR/WRMSR/WRMSRNS will be used.
+		 *
+		 * The hypervisor will trap and inject #GP into the guest and
+		 * the MSR access instruction will be skipped.
+		 */
+		return PV_MSR_NATIVE;
+	}
+}
+
+extern void asm_xen_write_msr(void);
+#else
+static __always_inline enum pv_msr_action get_pv_msr_action(const u32 msr)
+{
+	return PV_MSR_NATIVE;
+}
+#endif
+
 static __always_inline unsigned long long __rdmsr(unsigned int msr)
 {
 	DECLARE_ARGS(val, low, high);
@@ -91,14 +162,6 @@ static __always_inline unsigned long long __rdmsr(unsigned int msr)
 	return EAX_EDX_VAL(val, low, high);
 }
 
-static __always_inline void __wrmsr(u32 msr, u64 val)
-{
-	asm volatile("1: wrmsr\n"
-		     "2:\n"
-		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
-		     : : "c" (msr), "a"((u32)val), "d" ((u32)(val >> 32)) : "memory");
-}
-
 #define native_rdmsr(msr, val1, val2)			\
 do {							\
 	u64 __val = __rdmsr((msr));			\
@@ -111,9 +174,6 @@ static __always_inline u64 native_rdmsrl(const u32 msr)
 	return __rdmsr(msr);
 }
 
-#define native_wrmsrl(msr, val)				\
-	__wrmsr((msr), (val))
-
 static inline unsigned long long native_read_msr(unsigned int msr)
 {
 	unsigned long long val;
@@ -141,31 +201,232 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 	return EAX_EDX_VAL(val, low, high);
 }
 
-/* Can be uninlined because referenced by paravirt */
-static inline void notrace native_write_msr(u32 msr, u64 val)
+/*
+ * Non-serializing WRMSR, when available.
+ * Falls back to a serializing WRMSR.
+ */
+static __always_inline bool __native_wrmsr_variable(const u32 msr, const u64 val, const int type)
+{
+#ifdef CONFIG_X86_64
+	BUILD_BUG_ON(__builtin_constant_p(msr));
+#endif
+
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
+ * Falls back to a serializing WRMSR.
+ */
+static __always_inline bool __native_wrmsr_constant(const u32 msr, const u64 val, const int type)
+{
+	BUILD_BUG_ON(!__builtin_constant_p(msr));
+
+	/*
+	 * WRMSR is 2 bytes.  WRMSRNS is 3 bytes.  Pad WRMSR with a redundant
+	 * DS prefix to avoid a trailing NOP.
+	 */
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
+static __always_inline bool __native_wrmsr(const u32 msr, const u64 val, const int type)
+{
+#ifdef CONFIG_X86_64
+	if (__builtin_constant_p(msr))
+		return __native_wrmsr_constant(msr, val, type);
+#endif
+
+	return __native_wrmsr_variable(msr, val, type);
+}
+
+static __always_inline void native_wrmsr(const u32 msr, const u32 low, const u32 high)
+{
+	__native_wrmsr(msr, (u64)high << 32 | low, EX_TYPE_WRMSR);
+}
+
+static __always_inline void native_wrmsrl(const u32 msr, const u64 val)
+{
+	__native_wrmsr(msr, val, EX_TYPE_WRMSR);
+}
+
+static inline void notrace native_write_msr(const u32 msr, const u64 val)
 {
-	native_wrmsrl(msr, val);
+	__native_wrmsr(msr, val, EX_TYPE_WRMSR);
 
 	if (tracepoint_enabled(write_msr))
 		do_trace_write_msr(msr, val, 0);
 }
 
-/* Can be uninlined because referenced by paravirt */
-static inline int notrace native_write_msr_safe(u32 msr, u64 val)
+static inline int notrace native_write_msr_safe(const u32 msr, const u64 val)
 {
-	int err;
+	int err = __native_wrmsr(msr, val, EX_TYPE_WRMSR_SAFE) ? -EIO : 0;
 
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
 
+static __always_inline bool __wrmsr_variable(const u32 msr, const u64 val, const int type)
+{
+#ifdef CONFIG_X86_64
+	BUILD_BUG_ON(__builtin_constant_p(msr));
+
+	asm_inline volatile goto(
+		ALTERNATIVE(PREPARE_RDX_FOR_WRMSR,
+			    "call asm_xen_write_msr\n\t"
+			    "jnz 2f\n\t",
+			    X86_FEATURE_XENPV)
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
+#else
+	return __native_wrmsr_variable(msr, val, type);
+#endif
+}
+
+static __always_inline bool __wrmsr_variable_all(const u32 msr, const u64 val, const int type)
+{
+	const enum pv_msr_action action = get_pv_msr_action(msr);
+
+	if (action == PV_MSR_PV) {
+		return __wrmsr_variable(msr, val, type);
+	} else if (action == PV_MSR_IGNORE) {
+		if (cpu_feature_enabled(X86_FEATURE_XENPV))
+			return false;
+	}
+
+	return __native_wrmsr_variable(msr, val, type);
+}
+
+#ifdef CONFIG_X86_64
+static __always_inline bool __wrmsr_constant(const u32 msr, const u64 val, const int type)
+{
+	BUILD_BUG_ON(!__builtin_constant_p(msr));
+
+	asm_inline volatile goto(
+		"1:\n"
+		ALTERNATIVE_2(PREPARE_RCX_RDX_FOR_WRMSR,
+			      "",
+			      X86_FEATURE_MSR_IMM,
+			      "mov %[msr], %%ecx\n\t"
+			      "call asm_xen_write_msr\n\t"
+			      "jnz 3f\n\t",
+			      X86_FEATURE_XENPV)
+		ALTERNATIVE_2("2: ds wrmsr",
+			      ASM_WRMSRNS,
+			      X86_FEATURE_WRMSRNS,
+			      ASM_WRMSRNS_IMM,
+			      X86_FEATURE_MSR_IMM)
+		"3:\n"
+		_ASM_EXTABLE_TYPE(1b, %l[badmsr], %c[type])	/* For WRMSRNS immediate */
+		_ASM_EXTABLE_TYPE(2b, %l[badmsr], %c[type])	/* For WRMSR(NS) */
+
+		: ASM_CALL_CONSTRAINT
+		: [val] "a" (val), [msr] "i" (msr), [type] "i" (type)
+		: "memory", "ecx", "rdx"
+		: badmsr);
+
+	return false;
+
+badmsr:
+	return true;
+}
+
+static __always_inline bool __wrmsr_constant_all(const u32 msr, const u64 val, const int type)
+{
+	const enum pv_msr_action action = get_pv_msr_action(msr);
+
+	if (action == PV_MSR_PV) {
+		return __wrmsr_constant(msr, val, type);
+	} else if (action == PV_MSR_IGNORE) {
+		if (cpu_feature_enabled(X86_FEATURE_XENPV))
+			return false;
+	}
+
+	return __native_wrmsr_constant(msr, val, type);
+}
+#endif
+
+static __always_inline bool __wrmsr(const u32 msr, const u64 val, const int type)
+{
+#ifdef CONFIG_X86_64
+	if (__builtin_constant_p(msr))
+		return __wrmsr_constant_all(msr, val, type);
+#endif
+
+	return __wrmsr_variable_all(msr, val, type);
+}
+
+static __always_inline void wrmsr(const u32 msr, const u32 low, const u32 high)
+{
+	__wrmsr(msr, (u64)high << 32 | low, EX_TYPE_WRMSR);
+}
+
+static __always_inline void wrmsrl(const u32 msr, const u64 val)
+{
+	__wrmsr(msr, val, EX_TYPE_WRMSR);
+}
+
+static __always_inline int wrmsr_safe(const u32 msr, const u32 low, const u32 high)
+{
+	return __wrmsr(msr, (u64)high << 32 | low, EX_TYPE_WRMSR_SAFE) ? -EIO : 0;
+}
+
+static __always_inline int wrmsrl_safe(const u32 msr, const u64 val)
+{
+	return __wrmsr(msr, val, EX_TYPE_WRMSR_SAFE) ? -EIO : 0;
+}
+
 extern int rdmsr_safe_regs(u32 regs[8]);
 extern int wrmsr_safe_regs(u32 regs[8]);
 
@@ -287,29 +548,6 @@ do {							\
 
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
- * 64-bit version of wrmsr_safe():
- */
-static inline int wrmsrl_safe(u32 msr, u64 val)
-{
-	return native_write_msr_safe(msr, val);
-}
-
 struct msr __percpu *msrs_alloc(void);
 void msrs_free(struct msr __percpu *msrs);
 int msr_set_bit(u32 msr, u8 bit);
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index f3d6e8394d38..351feb890ab0 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -180,21 +180,11 @@ static inline u64 paravirt_read_msr(unsigned msr)
 	return PVOP_CALL1(u64, cpu.read_msr, msr);
 }
 
-static inline void paravirt_write_msr(u32 msr, u32 low, u32 high)
-{
-	PVOP_VCALL2(cpu.write_msr, msr, (u64)high << 32 | low);
-}
-
 static inline u64 paravirt_read_msr_safe(unsigned msr, int *err)
 {
 	return PVOP_CALL2(u64, cpu.read_msr_safe, msr, err);
 }
 
-static inline int paravirt_write_msr_safe(u32 msr, u32 low, u32 high)
-{
-	return PVOP_CALL2(int, cpu.write_msr_safe, msr, (u64)high << 32 | low);
-}
-
 #define rdmsr(msr, val1, val2)			\
 do {						\
 	u64 _l = paravirt_read_msr(msr);	\
@@ -202,23 +192,11 @@ do {						\
 	val2 = _l >> 32;			\
 } while (0)
 
-#define wrmsr(msr, val1, val2)			\
-do {						\
-	paravirt_write_msr(msr, val1, val2);	\
-} while (0)
-
 #define rdmsrl(msr, val)			\
 do {						\
 	val = paravirt_read_msr(msr);		\
 } while (0)
 
-static inline void wrmsrl(unsigned msr, u64 val)
-{
-	wrmsr(msr, (u32)val, (u32)(val>>32));
-}
-
-#define wrmsr_safe(msr, a, b)	paravirt_write_msr_safe(msr, a, b)
-
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, a, b)				\
 ({							\
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 78777b78da12..8a563576d70e 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -92,14 +92,12 @@ struct pv_cpu_ops {
 
 	/* Unsafe MSR operations.  These will warn or panic on failure. */
 	u64 (*read_msr)(unsigned int msr);
-	void (*write_msr)(u32 msr, u64 val);
 
 	/*
 	 * Safe MSR operations.
 	 * read sets err to 0 or -EIO.  write returns 0 or -EIO.
 	 */
 	u64 (*read_msr_safe)(unsigned int msr, int *err);
-	int (*write_msr_safe)(u32 msr, u64 val);
 
 	u64 (*read_pmc)(int counter);
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1ccd05d8999f..ffb04445f97e 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -129,9 +129,7 @@ struct paravirt_patch_template pv_ops = {
 	.cpu.write_cr0		= native_write_cr0,
 	.cpu.write_cr4		= native_write_cr4,
 	.cpu.read_msr		= native_read_msr,
-	.cpu.write_msr		= native_write_msr,
 	.cpu.read_msr_safe	= native_read_msr_safe,
-	.cpu.write_msr_safe	= native_write_msr_safe,
 	.cpu.read_pmc		= native_read_pmc,
 	.cpu.load_tr_desc	= native_load_tr_desc,
 	.cpu.set_ldt		= native_set_ldt,
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index a047dadf4511..d02f55bfa869 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1112,43 +1112,33 @@ static u64 xen_do_read_msr(unsigned int msr, int *err)
 	return val;
 }
 
-static void set_seg(unsigned int which, unsigned int low, unsigned int high,
-		    int *err)
+static void set_seg(u32 which, u64 base)
 {
-	u64 base = ((u64)high << 32) | low;
-
-	if (HYPERVISOR_set_segment_base(which, base) == 0)
-		return;
-
-	if (err)
-		*err = -EIO;
-	else
+	if (HYPERVISOR_set_segment_base(which, base))
 		WARN(1, "Xen set_segment_base(%u, %llx) failed\n", which, base);
 }
 
 /*
- * Support write_msr_safe() and write_msr() semantics.
- * With err == NULL write_msr() semantics are selected.
- * Supplying an err pointer requires err to be pre-initialized with 0.
+ * Return true to indicate the requested MSR write has been done successfully,
+ * otherwise return false to have the calling MSR write primitives in msr.h to
+ * fail.
  */
-static void xen_do_write_msr(unsigned int msr, unsigned int low,
-			     unsigned int high, int *err)
+bool xen_do_write_msr(u32 msr, u64 val)
 {
-	u64 val;
 	bool emulated;
 
 	switch (msr) {
 	case MSR_FS_BASE:
-		set_seg(SEGBASE_FS, low, high, err);
-		break;
+		set_seg(SEGBASE_FS, val);
+		return true;
 
 	case MSR_KERNEL_GS_BASE:
-		set_seg(SEGBASE_GS_USER, low, high, err);
-		break;
+		set_seg(SEGBASE_GS_USER, val);
+		return true;
 
 	case MSR_GS_BASE:
-		set_seg(SEGBASE_GS_KERNEL, low, high, err);
-		break;
+		set_seg(SEGBASE_GS_KERNEL, val);
+		return true;
 
 	case MSR_STAR:
 	case MSR_CSTAR:
@@ -1160,18 +1150,13 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
 		/* Fast syscall setup is all done in hypercalls, so
 		   these are all ignored.  Stub them out here to stop
 		   Xen console noise. */
-		break;
+		return true;
 
 	default:
-		val = (u64)high << 32 | low;
-
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
 
@@ -1180,15 +1165,6 @@ static u64 xen_read_msr_safe(unsigned int msr, int *err)
 	return xen_do_read_msr(msr, err);
 }
 
-static int xen_write_msr_safe(u32 msr, u64 val)
-{
-	int err = 0;
-
-	xen_do_write_msr(msr, val, (u32)(val >> 32), &err);
-
-	return err;
-}
-
 static u64 xen_read_msr(unsigned int msr)
 {
 	int err;
@@ -1196,13 +1172,6 @@ static u64 xen_read_msr(unsigned int msr)
 	return xen_do_read_msr(msr, xen_msr_safe ? &err : NULL);
 }
 
-static void xen_write_msr(u32 msr, u64 val)
-{
-	int err;
-
-	xen_do_write_msr(msr, val, (u32)(val >> 32), xen_msr_safe ? &err : NULL);
-}
-
 /* This is called once we have the cpu_possible_mask */
 void __init xen_setup_vcpu_info_placement(void)
 {
@@ -1238,10 +1207,8 @@ static const typeof(pv_ops) xen_cpu_ops __initconst = {
 		.write_cr4 = xen_write_cr4,
 
 		.read_msr = xen_read_msr,
-		.write_msr = xen_write_msr,
 
 		.read_msr_safe = xen_read_msr_safe,
-		.write_msr_safe = xen_write_msr_safe,
 
 		.read_pmc = xen_read_pmc,
 
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 109af12f7647..e672632b1cc0 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -344,3 +344,58 @@ SYM_CODE_END(xen_entry_SYSENTER_compat)
 SYM_CODE_END(xen_entry_SYSCALL_compat)
 
 #endif	/* CONFIG_IA32_EMULATION */
+
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
+ * Let xen_do_write_msr() return 'false' if the MSR access should
+ * be executed natively, IOW, 'true' means it has done the job.
+ *
+ * 	bool xen_do_write_msr(u32 msr, u64 value)
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
+	call xen_do_write_msr
+	test %al, %al		/* %al=1, i.e., ZF=0, means successfully done */
+	XEN_RESTORE_CALLEE_REGS_FOR_MSR
+	mov 4(%rsp), %edx	/* Set up %edx for native execution */
+	pop %rax
+	FRAME_END
+	RET
+SYM_FUNC_END(asm_xen_write_msr)
+EXPORT_SYMBOL_GPL(asm_xen_write_msr)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 6545661010ce..fc3c55871037 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -146,6 +146,8 @@ __visible unsigned long xen_read_cr2_direct(void);
 /* These are not functions, and cannot be called normally */
 __visible void xen_iret(void);
 
+extern bool xen_do_write_msr(u32 msr, u64 val);
+
 extern int xen_panic_handler_init(void);
 
 int xen_cpuhp_setup(int (*cpu_up_prepare_cb)(unsigned int),
-- 
2.49.0


