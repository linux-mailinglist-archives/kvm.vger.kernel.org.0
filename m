Return-Path: <kvm+bounces-71216-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEBqKFV3lWl8RwIAu9opvQ
	(envelope-from <kvm+bounces-71216-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 09:24:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BBB515400F
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 09:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A29623095F68
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 08:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C201131D38B;
	Wed, 18 Feb 2026 08:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m2c+YmlB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m2c+YmlB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEBA31A57B
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 08:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771402950; cv=none; b=q+20zHYeDWaTfh4SxNV7JU29dvhuzcnQvilFIooACV/0486cNiFaQ3x1gTCuJooBZ7kqO3+hBM40t06u0HCuZhXcEOn/9n+XgaNS0faQjP3U+lGZydCNPQEIt0QsLyRknHdovGS/QSf0lcfmNo25dyEFfom1+P9VUR5MyqgbiS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771402950; c=relaxed/simple;
	bh=tipT+x+rzefZm0v6MGWOlLJXq7aNBBX+PV3YXyihiyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6zWf+Qw6dHHjaQ912FqjoCBXE9DxhnDYmWVJj3+HgJd8F7Z/38NX8RUmTnvZFxdBn2y7G+b6qSHqMlzeCGz4RER/mJtOwEm9aDzHVOJaA6TZwChBh9VNfsqZWwJW+Lq1u5Q41DwpbGHhCoiYq8R1zt5BSBdpW2eJBQeWGR9Ly8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m2c+YmlB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m2c+YmlB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C08155BCC1;
	Wed, 18 Feb 2026 08:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771402946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5n3VBEp5XW54gxR7TQ9eIqPv5CmnPOTbBO3+6ULmth4=;
	b=m2c+YmlBIvdMzgR4lO5qjDXP3E+pBiM68LAPt+DiXPw1kx3dHf8mFGKQkszUgRrCdEePTu
	KAAMjOmmcAQVC4rHplVFgKKVH0DUP5K0A8+/AUy48MdJsTEKg7wN4AEHe1ec6oRelYU7rs
	S5gWViRIDfSSvnHL4ApHYv8JoEJpYf8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771402946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5n3VBEp5XW54gxR7TQ9eIqPv5CmnPOTbBO3+6ULmth4=;
	b=m2c+YmlBIvdMzgR4lO5qjDXP3E+pBiM68LAPt+DiXPw1kx3dHf8mFGKQkszUgRrCdEePTu
	KAAMjOmmcAQVC4rHplVFgKKVH0DUP5K0A8+/AUy48MdJsTEKg7wN4AEHe1ec6oRelYU7rs
	S5gWViRIDfSSvnHL4ApHYv8JoEJpYf8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 576243EA65;
	Wed, 18 Feb 2026 08:22:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WCovFMJ2lWmSHgAAD6G6ig
	(envelope-from <jgross@suse.com>); Wed, 18 Feb 2026 08:22:26 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	llvm@lists.linux.dev
Cc: Juergen Gross <jgross@suse.com>,
	Xin Li <xin@zytor.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: [PATCH v3 09/16] x86/msr: Use the alternatives mechanism for WRMSR
Date: Wed, 18 Feb 2026 09:21:26 +0100
Message-ID: <20260218082133.400602-10-jgross@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260218082133.400602-1-jgross@suse.com>
References: <20260218082133.400602-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -5.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[suse.com,zytor.com,kernel.org,redhat.com,alien8.de,linux.intel.com,google.com,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-71216-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgross@suse.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,lkml];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 4BBB515400F
X-Rspamd-Action: no action

When available use one of the non-serializing WRMSR variants (WRMSRNS
with or without an immediate operand specifying the MSR register) in
__wrmsrq().

For the safe/unsafe variants make __wrmsrq() to be a common base
function instead of duplicating the ALTERNATIVE*() macros. This
requires to let native_wrmsr() use native_wrmsrq() instead of
__wrmsrq(). While changing this, convert native_wrmsr() into an inline
function.

Replace the only call of wsrmsrns() with the now equivalent call to
native_wrmsrq() and remove wsrmsrns().

The paravirt case will be handled later.

Originally-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- new patch, partially taken from "[RFC PATCH v2 21/34] x86/msr: Utilize
  the alternatives mechanism to write MSR" by Xin Li.
---
 arch/x86/include/asm/fred.h |   2 +-
 arch/x86/include/asm/msr.h  | 144 +++++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.c      |   2 +-
 3 files changed, 111 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 2bb65677c079..71fc0c6e4e32 100644
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
index 71f41af11591..ba11c3375cbd 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -7,11 +7,11 @@
 #ifndef __ASSEMBLER__
 
 #include <asm/asm.h>
-#include <asm/errno.h>
 #include <asm/cpumask.h>
 #include <uapi/asm/msr.h>
 #include <asm/shared/msr.h>
 
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/percpu.h>
 
@@ -56,6 +56,36 @@ static inline void do_trace_read_msr(u32 msr, u64 val, int failed) {}
 static inline void do_trace_rdpmc(u32 msr, u64 val, int failed) {}
 #endif
 
+/* The GNU Assembler (Gas) with Binutils 2.40 adds WRMSRNS support */
+#if defined(CONFIG_AS_IS_GNU) && CONFIG_AS_VERSION >= 24000
+#define ASM_WRMSRNS		"wrmsrns\n\t"
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
  * __rdmsr() and __wrmsr() are the two primitives which are the bare minimum MSR
  * accessors and should not have any tracing or other functionality piggybacking
@@ -75,12 +105,76 @@ static __always_inline u64 __rdmsr(u32 msr)
 	return EAX_EDX_VAL(val, low, high);
 }
 
-static __always_inline void __wrmsrq(u32 msr, u64 val)
+static __always_inline bool __wrmsrq_variable(u32 msr, u64 val, int type)
 {
-	asm volatile("1: wrmsr\n"
-		     "2:\n"
-		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
-		     : : "c" (msr), "a" ((u32)val), "d" ((u32)(val >> 32)) : "memory");
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
+static __always_inline bool __wrmsrq_constant(u32 msr, u64 val, int type)
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
+static __always_inline bool __wrmsrq(u32 msr, u64 val, int type)
+{
+#ifdef CONFIG_X86_64
+	if (__builtin_constant_p(msr))
+		return __wrmsrq_constant(msr, val, type);
+#endif
+
+	return __wrmsrq_variable(msr, val, type);
 }
 
 #define native_rdmsr(msr, val1, val2)			\
@@ -95,11 +189,15 @@ static __always_inline u64 native_rdmsrq(u32 msr)
 	return __rdmsr(msr);
 }
 
-#define native_wrmsr(msr, low, high)			\
-	__wrmsrq((msr), (u64)(high) << 32 | (low))
+static __always_inline void native_wrmsrq(u32 msr, u64 val)
+{
+	__wrmsrq(msr, val, EX_TYPE_WRMSR);
+}
 
-#define native_wrmsrq(msr, val)				\
-	__wrmsrq((msr), (val))
+static __always_inline void native_wrmsr(u32 msr, u32 low, u32 high)
+{
+	native_wrmsrq(msr, (u64)high << 32 | low);
+}
 
 static inline u64 native_read_msr(u32 msr)
 {
@@ -131,15 +229,7 @@ static inline void notrace native_write_msr(u32 msr, u64 val)
 /* Can be uninlined because referenced by paravirt */
 static inline int notrace native_write_msr_safe(u32 msr, u64 val)
 {
-	int err;
-
-	asm volatile("1: wrmsr ; xor %[err],%[err]\n"
-		     "2:\n\t"
-		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_WRMSR_SAFE, %[err])
-		     : [err] "=a" (err)
-		     : "c" (msr), "0" ((u32)val), "d" ((u32)(val >> 32))
-		     : "memory");
-	return err;
+	return __wrmsrq(msr, val, EX_TYPE_WRMSR_SAFE) ? -EIO : 0;
 }
 
 extern int rdmsr_safe_regs(u32 regs[8]);
@@ -158,7 +248,6 @@ static inline u64 native_read_pmc(int counter)
 #ifdef CONFIG_PARAVIRT_XXL
 #include <asm/paravirt.h>
 #else
-#include <linux/errno.h>
 static __always_inline u64 read_msr(u32 msr)
 {
 	return native_read_msr(msr);
@@ -250,21 +339,6 @@ static inline int wrmsrq_safe(u32 msr, u64 val)
 	return err;
 }
 
-/* Instruction opcode for WRMSRNS supported in binutils >= 2.40 */
-#define ASM_WRMSRNS _ASM_BYTES(0x0f,0x01,0xc6)
-
-/* Non-serializing WRMSR, when available.  Falls back to a serializing WRMSR. */
-static __always_inline void wrmsrns(u32 msr, u64 val)
-{
-	/*
-	 * WRMSR is 2 bytes.  WRMSRNS is 3 bytes.  Pad WRMSR with a redundant
-	 * DS prefix to avoid a trailing NOP.
-	 */
-	asm volatile("1: " ALTERNATIVE("ds wrmsr", ASM_WRMSRNS, X86_FEATURE_WRMSRNS)
-		     "2: " _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
-		     : : "c" (msr), "a" ((u32)val), "d" ((u32)(val >> 32)));
-}
-
 static inline void wrmsr(u32 msr, u32 low, u32 high)
 {
 	wrmsrq(msr, (u64)high << 32 | low);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3799cbbb4577..e29a2ac24669 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1473,7 +1473,7 @@ static void vmx_write_guest_host_msr(struct vcpu_vmx *vmx, u32 msr, u64 data,
 {
 	preempt_disable();
 	if (vmx->vt.guest_state_loaded)
-		wrmsrns(msr, data);
+		native_wrmsrq(msr, data);
 	preempt_enable();
 	*cache = data;
 }
-- 
2.53.0


