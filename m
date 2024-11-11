Return-Path: <kvm+bounces-31468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 046399C3ED1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36C031C21C0B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C86F1A08A0;
	Mon, 11 Nov 2024 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WoxR2q26"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34A119CC20;
	Mon, 11 Nov 2024 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329679; cv=none; b=dav2UBF9ZUgDEqs8DzVOSyEHDm4ycGUX/5dDduwRz+UTWlFS2817GC/o50xL3XUKrVO8pq+7uwvY2i5BRjV9WCIY/XLftF9cqX9FSODGF+livEGlxGJc5WQPR7PZynFvE6MjBHQRBjVOY+QP02RPShiOtBJOxxlStut6KxqbsJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329679; c=relaxed/simple;
	bh=kDi+TVCXm76xbQAD1/onHdkrODKXEEtiHXcBLawYGW4=;
	h=Message-Id:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=pjaoi/11X1/zt0OCW0idZmgOUPV9OBXcqRUrriYRzp8I8Y32fEw9i5UsjHaLbUL1xk27uNpDEcbkPoGzz7jDHdZkAbn1jJD6lQ40Xpj7DkwS9YfbbNWEDdwTuSNlK09Kt/NI6yOQ8+QuAeKKz5I5RBAucqzBoClK2Ii87tOSJe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WoxR2q26; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=cKtSfZ5sWaSTj7tZINYGDLIwyP/HVC5Nz5I81xWPCwk=; b=WoxR2q26i+JGKuI+u/OTnBS/As
	fN2FnAawEqX+BeWD0xU8yoKIHkTbWmmIgJNS0w0wfaX+hAMsSCpueVLcPkHDCLSCBTY7T9lzNugWl
	yBNCYhG9B6gpLKORP0MAw4J2cByVteC6b1QeZ6xT7/ZPP//bDHr16bWYcsEnoGHIx7lE+dxIqBU9h
	y6xnub51UBoGZ67ajic4ja9gVG3eRS1IUqNKXFDyhAu35eRydrLEkgoOl+ndQdKPzgeqpvtHvwlXX
	tBkjjrwbbbhug7Ix6u0q1XTf46MXqCT+bq+MUwAn2RqIr8heZZesK3QEp7zyRPyG+E0amY/eO4AcE
	h5kq3Z3A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATwA-0000000Coet-23KF;
	Mon, 11 Nov 2024 12:54:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id F102C302795; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111125219.361243118@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: seanjc@google.com,
 pbonzini@redhat.com,
 jpoimboe@redhat.com,
 tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org,
 x86@kernel.org,
 kvm@vger.kernel.org,
 jthoughton@google.com,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 12/12] x86/kvm/emulate: Avoid RET for fastops
References: <20241111115935.796797988@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Since there is only a single fastop() function, convert the FASTOP
stuff from CALL_NOSPEC+RET to JMP_NOSPEC+JMP, avoiding the return
thunks and all that jazz.

Specifically FASTOPs rely on the return thunk to preserve EFLAGS,
which not all of them can trivially do (call depth tracing suffers
here).

Objtool strenuously complains about this:

 - indirect call without a .rodata, fails to determine JUMP_TABLE,
   annotate
 - fastop functions fall through, exception
 - unreachable instruction after fastop_return, save/restore

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/emulate.c              |   20 +++++++++++++++-----
 include/linux/objtool_types.h       |    1 +
 tools/include/linux/objtool_types.h |    1 +
 tools/objtool/check.c               |   11 ++++++++++-
 4 files changed, 27 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -285,8 +285,8 @@ static void invalidate_registers(struct
  * different operand sizes can be reached by calculation, rather than a jump
  * table (which would be bigger than the code).
  *
- * The 16 byte alignment, considering 5 bytes for the RET thunk, 3 for ENDBR
- * and 1 for the straight line speculation INT3, leaves 7 bytes for the
+ * The 16 byte alignment, considering 5 bytes for the JMP, 4 for ENDBR
+ * and 1 for the straight line speculation INT3, leaves 6 bytes for the
  * body of the function.  Currently none is larger than 4.
  */
 static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
@@ -304,7 +304,7 @@ static int fastop(struct x86_emulate_ctx
 	__FOP_FUNC(#name)
 
 #define __FOP_RET(name) \
-	"11: " ASM_RET \
+	"11: jmp fastop_return; int3 \n\t" \
 	".size " name ", .-" name "\n\t"
 
 #define FOP_RET(name) \
@@ -5071,14 +5071,24 @@ static void fetch_possible_mmx_operand(s
 		kvm_read_mmx_reg(op->addr.mm, &op->mm_val);
 }
 
-static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)
+/*
+ * All the FASTOP magic above relies on there being *one* instance of this
+ * so it can JMP back, avoiding RET and it's various thunks.
+ */
+static noinline int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop)
 {
 	ulong flags = (ctxt->eflags & EFLAGS_MASK) | X86_EFLAGS_IF;
 
 	if (!(ctxt->d & ByteOp))
 		fop += __ffs(ctxt->dst.bytes) * FASTOP_SIZE;
 
-	asm("push %[flags]; popf; " CALL_NOSPEC " ; pushf; pop %[flags]\n"
+	asm("push %[flags]; popf \n\t"
+	    UNWIND_HINT(UNWIND_HINT_TYPE_SAVE, 0, 0, 0)
+	    ASM_ANNOTATE(ANNOTYPE_JUMP_TABLE)
+	    JMP_NOSPEC
+	    "fastop_return: \n\t"
+	    UNWIND_HINT(UNWIND_HINT_TYPE_RESTORE, 0, 0, 0)
+	    "pushf; pop %[flags]\n"
 	    : "+a"(ctxt->dst.val), "+d"(ctxt->src.val), [flags]"+D"(flags),
 	      [thunk_target]"+S"(fop), ASM_CALL_CONSTRAINT
 	    : "c"(ctxt->src2.val));
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -64,5 +64,6 @@ struct unwind_hint {
 #define ANNOTYPE_UNRET_BEGIN		5
 #define ANNOTYPE_IGNORE_ALTS		6
 #define ANNOTYPE_INTRA_FUNCTION_CALLS	7
+#define ANNOTYPE_JUMP_TABLE		8
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -64,5 +64,6 @@ struct unwind_hint {
 #define ANNOTYPE_UNRET_BEGIN		5
 #define ANNOTYPE_IGNORE_ALTS		6
 #define ANNOTYPE_INTRA_FUNCTION_CALLS	7
+#define ANNOTYPE_JUMP_TABLE		8
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2386,6 +2386,14 @@ static int __annotate_late(struct objtoo
 		insn->unret = 1;
 		break;
 
+	/*
+	 * Must be after add_jump_table(); for it doesn't set a sane
+	 * _jump_table value.
+	 */
+	case ANNOTYPE_JUMP_TABLE:
+		insn->_jump_table = (void *)1;
+		break;
+
 	default:
 		break;
 	}
@@ -3459,7 +3467,8 @@ static int validate_branch(struct objtoo
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
 			if (!strncmp(func->name, "__cfi_", 6) ||
-			    !strncmp(func->name, "__pfx_", 6))
+			    !strncmp(func->name, "__pfx_", 6) ||
+			    !strcmp(insn_func(insn)->name, "fastop"))
 				return 0;
 
 			WARN("%s() falls through to next function %s()",



