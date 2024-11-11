Return-Path: <kvm+bounces-31495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0CB9C42A1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:28:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF9C61F26170
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921511A2651;
	Mon, 11 Nov 2024 16:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XZqzwwls"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344EB13C80D;
	Mon, 11 Nov 2024 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731342463; cv=none; b=mQyI1oQ0lV5HQFbXhfaMPkIbXgPFzmyRmSxNMgSxGO0lKej7o4Jv77RJ3nils+ehiGtjShpHvstw7SfgLJ/l7IFPEOmndU6Ob1kOKEGgnOVMBwgclAMZLMIPpIiAoWAYXt6bffyjxamOOPisM2EHSmlKDzSjQRqo4K+OO8TzlIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731342463; c=relaxed/simple;
	bh=egKjVowvtsWVSG4CgTwPs8fUlbuA4hZZqqO8gVE2l8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TxwUo2xD0p93unWxVDljPAV4Fg/Zo9xqdwiFyM/SGBJeEH8b09R7hQlC8pntXwVtJMiiu2aX5H0S/lMkOtXxu61dJfjQemA2NEesvOyNyqEYTos+wDnljxpfP70JCA6nQk8QV3uYpW4dN0WfGq27nahyD1QSBsCAy2j84dxxXs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XZqzwwls; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+zvP978HC8ij+yUZ2+LgBWNTCywn9D7eehFh+U5IJmo=; b=XZqzwwlsuoZrbOqVA61YhAFGg7
	tw6Efu3xvly4ZZgg53fPonjQo2KULPhq4dHsddnhFhGLPhlKFOkfLuUR+rgQymLO788wRfd3JfqJY
	ZV8grXYgLd5AckqHCipYJj6aylKvVblUf6b315eM2zYDWX/2SGLHg1A7T6uD4NANRCK+Mia2bXt6g
	8r8yC4Lsv5Fr87RjdWUVmLd3RZY/29d4BKydKy1fimWwOte/maz2ggv5B4ebkc/hKt+J+35i52H0w
	91OJcMfvnQUAFzujnbzGyaZEGCrhUB9e3gIooPwrCNZPWf5usPagQUNwhP0u98ow5afl8EJr6NXlq
	GWT8aGyQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tAXGN-0000000CsCj-1764;
	Mon, 11 Nov 2024 16:27:39 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E9D8B300472; Mon, 11 Nov 2024 17:27:38 +0100 (CET)
Date: Mon, 11 Nov 2024 17:27:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: seanjc@google.com, pbonzini@redhat.com, jpoimboe@redhat.com,
	tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com, andrew.cooper3@citrix.com
Subject: Re: [PATCH v2 12/12] x86/kvm/emulate: Avoid RET for fastops
Message-ID: <20241111162738.GI22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125219.361243118@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241111125219.361243118@infradead.org>

On Mon, Nov 11, 2024 at 12:59:47PM +0100, Peter Zijlstra wrote:

> +/*
> + * All the FASTOP magic above relies on there being *one* instance of this
> + * so it can JMP back, avoiding RET and it's various thunks.
> + */
> +static noinline int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)
>  {
>  	ulong flags = (ctxt->eflags & EFLAGS_MASK) | X86_EFLAGS_IF;
>  
>  	if (!(ctxt->d & ByteOp))
>  		fop += __ffs(ctxt->dst.bytes) * FASTOP_SIZE;
>  
> -	asm("push %[flags]; popf; " CALL_NOSPEC " ; pushf; pop %[flags]\n"
> +	asm("push %[flags]; popf \n\t"
> +	    UNWIND_HINT(UNWIND_HINT_TYPE_SAVE, 0, 0, 0)
> +	    ASM_ANNOTATE(ANNOTYPE_JUMP_TABLE)
> +	    JMP_NOSPEC
> +	    "fastop_return: \n\t"
> +	    UNWIND_HINT(UNWIND_HINT_TYPE_RESTORE, 0, 0, 0)
> +	    "pushf; pop %[flags]\n"
>  	    : "+a"(ctxt->dst.val), "+d"(ctxt->src.val), [flags]"+D"(flags),
>  	      [thunk_target]"+S"(fop), ASM_CALL_CONSTRAINT
>  	    : "c"(ctxt->src2.val));

Do Andrew is telling me the compiler is free to mess this up... Notably:

  https://github.com/llvm/llvm-project/issues/92161

In lieu of that, I wrote the below hack. It makes objtool sad (it don't
like STT_FUNC calling STT_NOTYPE), but it should work if we ever run
into the compiler being daft like that (it should fail to compile
because of the duplicate fastop_return label, so it's not silent
failure).

Wear protective eye gear before continuing...

---
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -429,9 +429,9 @@ static inline void call_depth_return_thu
 
 #ifdef CONFIG_X86_64
 
-#define __CS_PREFIX						\
+#define __CS_PREFIX(reg)					\
 	".irp rs,r8,r9,r10,r11,r12,r13,r14,r15\n"		\
-	".ifc %V[thunk_target],\\rs\n"				\
+	".ifc " reg ",\\rs\n"					\
 	".byte 0x2e\n"						\
 	".endif\n"						\
 	".endr\n"
@@ -441,12 +441,12 @@ static inline void call_depth_return_thu
  * which is ensured when CONFIG_MITIGATION_RETPOLINE is defined.
  */
 # define CALL_NOSPEC						\
-	__CS_PREFIX						\
+	__CS_PREFIX("%V[thunk_target]")				\
 	"call __x86_indirect_thunk_%V[thunk_target]\n"
 
-# define JMP_NOSPEC						\
-	__CS_PREFIX						\
-	"jmp __x86_indirect_thunk_%V[thunk_target]\n"
+# define __JMP_NOSPEC(reg)					\
+	__CS_PREFIX(reg)					\
+	"jmp __x86_indirect_thunk_" reg "\n"
 
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 
@@ -478,10 +478,10 @@ static inline void call_depth_return_thu
 	"call *%[thunk_target]\n",				\
 	X86_FEATURE_RETPOLINE_LFENCE)
 
-# define JMP_NOSPEC						\
+# define __JMP_NOSPEC(reg)					\
 	ALTERNATIVE_2(						\
 	ANNOTATE_RETPOLINE_SAFE					\
-	"jmp *%[thunk_target]\n",				\
+	"jmp *%%" reg "\n",					\
 	"       jmp    901f;\n"					\
 	"       .align 16\n"					\
 	"901:	call   903f;\n"					\
@@ -490,22 +490,25 @@ static inline void call_depth_return_thu
 	"       jmp    902b;\n"					\
 	"       .align 16\n"					\
 	"903:	lea    4(%%esp), %%esp;\n"			\
-	"       pushl  %[thunk_target];\n"			\
+	"       pushl  %%" reg "\n"				\
 	"       ret;\n",					\
 	X86_FEATURE_RETPOLINE,					\
 	"lfence;\n"						\
 	ANNOTATE_RETPOLINE_SAFE					\
-	"jmp *%[thunk_target]\n",				\
+	"jmp *%%" reg "\n",					\
 	X86_FEATURE_RETPOLINE_LFENCE)
 
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
 #endif
+
 #else /* No retpoline for C / inline asm */
 # define CALL_NOSPEC "call *%[thunk_target]\n"
-# define JMP_NOSPEC "jmp *%[thunk_target]\n"
+# define __JMP_NOSPEC(reg) "jmp *%%" reg "\n"
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
 #endif
 
+# define JMP_NOSPEC __JMP_NOSPEC("%V[thunk_target]")
+
 /* The Spectre V2 mitigation variants */
 enum spectre_v2_mitigation {
 	SPECTRE_V2_NONE,
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5039,23 +5039,45 @@ static void fetch_possible_mmx_operand(s
 }
 
 /*
+ * Stub written in asm in order to ensure GCC doesn't duplicate the
+ * fastop_return: label.
+ *
+ * Custom calling convention.
+ *
+ * __fastop:
+ * ax = ctxt->dst.val
+ * dx = ctxt->src.val
+ * cx = ctxt->src.val2
+ * di = flags
+ * si = fop
+ */
+asm (ASM_FUNC_ALIGN
+     "__fastop: \n\t"
+     "push %" _ASM_DI "\n\t"
+     "popf \n\t"
+     UNWIND_HINT(UNWIND_HINT_TYPE_SAVE, 0, 0, 0)
+     ASM_ANNOTATE(ANNOTYPE_JUMP_TABLE)
+     __JMP_NOSPEC(_ASM_SI)
+     "fastop_return: \n\t"
+     UNWIND_HINT(UNWIND_HINT_TYPE_RESTORE, 0, 0, 0)
+     "pushf \n\t"
+     "pop %" _ASM_DI "\n\t"
+     ASM_RET
+     ".type __fastop, @notype \n\t"
+     ".size __fastop, . - __fastop \n\t");
+
+/*
  * All the FASTOP magic above relies on there being *one* instance of this
  * so it can JMP back, avoiding RET and it's various thunks.
  */
-static noinline int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)
+static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)
 {
 	ulong flags = (ctxt->eflags & EFLAGS_MASK) | X86_EFLAGS_IF;
 
 	if (!(ctxt->d & ByteOp))
 		fop += __ffs(ctxt->dst.bytes) * FASTOP_SIZE;
 
-	asm("push %[flags]; popf \n\t"
-	    UNWIND_HINT(UNWIND_HINT_TYPE_SAVE, 0, 0, 0)
-	    ASM_ANNOTATE(ANNOTYPE_JUMP_TABLE)
-	    JMP_NOSPEC
-	    "fastop_return: \n\t"
-	    UNWIND_HINT(UNWIND_HINT_TYPE_RESTORE, 0, 0, 0)
-	    "pushf; pop %[flags]\n"
+	asm("call __fastop"
 	    : "+a"(ctxt->dst.val), "+d"(ctxt->src.val), [flags]"+D"(flags),
 	      [thunk_target]"+S"(fop), ASM_CALL_CONSTRAINT
 	    : "c"(ctxt->src2.val));

