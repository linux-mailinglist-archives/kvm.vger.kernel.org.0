Return-Path: <kvm+bounces-3317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C318F802EEC
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:41:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B0BC280ED7
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4EBB219E1;
	Mon,  4 Dec 2023 09:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TsMsM4Rq"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1F1119;
	Mon,  4 Dec 2023 01:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=Jgweoy9v1ry+vJ+0xQvkdC/DCJR/HfQjV7GgwvonHBA=; b=TsMsM4RqmJ30Dxhaj7X6J4Zvnb
	S1vBqgDpLm/YetggJX/GKdtsZdMYIARCMQTuL89qct50tzNboez/lYKD5uO3NX2mOvnewAo+12F+P
	tZpcUqtnC7SQLklE7qJe72Y8wk4/wE6R/PWxK4aqk2QFRyxHDiqe4E773IZn/gqrE8ORLRFNzEPj6
	LkyyKx7xzYzviXyYUkY6Xqo7NKc5tMTdkXO77Kgg2wlwR7I1pCrTfGT4ipektuCH7g26epOtf7N3y
	nNMKzkx8qfvtDKIsTMjFgAz4cUYY0bLyefv++/U3k+9SjN3c/ua7Nrll5njDV0bXDXarSA0nB3JGR
	R0S+ckng==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rA5QZ-000X0Z-5i; Mon, 04 Dec 2023 09:39:47 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id A486B300AA5; Mon,  4 Dec 2023 10:39:45 +0100 (CET)
Message-Id: <20231204093732.097671022@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 04 Dec 2023 10:37:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 x86@kernel.org,
 kvm@vger.kernel.org
Subject: [PATCH 07/11] objtool: Convert ANNOTATE_INTRA_FUNCTION_CALLS to ANNOTATE
References: <20231204093702.989848513@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8


Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/objtool.h             |   16 ++----
 include/linux/objtool_types.h       |    1 
 tools/include/linux/objtool_types.h |    1 
 tools/objtool/check.c               |   96 ++++++++++++++----------------------
 4 files changed, 47 insertions(+), 67 deletions(-)

--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -66,16 +66,6 @@
 #else /* __ASSEMBLY__ */
 
 /*
- * This macro indicates that the following intra-function call is valid.
- * Any non-annotated intra-function call will cause objtool to issue a warning.
- */
-#define ANNOTATE_INTRA_FUNCTION_CALL				\
-	999:							\
-	.pushsection .discard.intra_function_calls;		\
-	.long 999b;						\
-	.popsection;
-
-/*
  * In asm, there are two kinds of code: normal C-type callable functions and
  * the rest.  The normal callable functions can be called by other code, and
  * don't do anything unusual with the stack.  Such normal callable functions
@@ -152,6 +142,12 @@
 
 #define ANNOTATE_NOENDBR	ANNOTATE type=ANNOTYPE_NOENDBR
 
+/*
+ * This macro indicates that the following intra-function call is valid.
+ * Any non-annotated intra-function call will cause objtool to issue a warning.
+ */
+#define ANNOTATE_INTRA_FUNCTION_CALL ANNOTATE type=ANNOTYPE_INTRA_FUNCTION_CALLS
+
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_OBJTOOL */
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -63,5 +63,6 @@ struct unwind_hint {
 #define ANNOTYPE_INSTR_END		4
 #define ANNOTYPE_UNRET_BEGIN		5
 #define ANNOTYPE_IGNORE_ALTS		6
+#define ANNOTYPE_INTRA_FUNCTION_CALLS	7
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -63,5 +63,6 @@ struct unwind_hint {
 #define ANNOTYPE_INSTR_END		4
 #define ANNOTYPE_UNRET_BEGIN		5
 #define ANNOTYPE_IGNORE_ALTS		6
+#define ANNOTYPE_INTRA_FUNCTION_CALLS	7
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2274,7 +2274,8 @@ static int read_unwind_hints(struct objt
 	return 0;
 }
 
-static int read_annotate(struct objtool_file *file, int (*func)(int type, struct instruction *insn))
+static int read_annotate(struct objtool_file *file,
+			 int (*func)(struct objtool_file *file, int type, struct instruction *insn))
 {
 	struct section *rsec, *sec;
 	struct instruction *insn;
@@ -2299,7 +2300,7 @@ static int read_annotate(struct objtool_
 
 		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
 
-		ret = func(type, insn);
+		ret = func(file, type, insn);
 		if (ret < 0)
 			return ret;
 	}
@@ -2307,7 +2308,7 @@ static int read_annotate(struct objtool_
 	return 0;
 }
 
-static int __annotate_ignore_alts(int type, struct instruction *insn)
+static int __annotate_ignore_alts(struct objtool_file *file, int type, struct instruction *insn)
 {
 	if (type != ANNOTYPE_IGNORE_ALTS)
 		return 0;
@@ -2316,7 +2317,7 @@ static int __annotate_ignore_alts(int ty
 	return 0;
 }
 
-static int __annotate_noendbr(int type, struct instruction *insn)
+static int __annotate_noendbr(struct objtool_file *file, int type, struct instruction *insn)
 {
 	if (type != ANNOTYPE_NOENDBR)
 		return 0;
@@ -2325,7 +2326,37 @@ static int __annotate_noendbr(int type,
 	return 0;
 }
 
-static int __annotate_retpoline_safe(int type, struct instruction *insn)
+static int __annotate_ifc(struct objtool_file *file, int type, struct instruction *insn)
+{
+	unsigned long dest_off;
+
+	if (type != ANNOTYPE_INTRA_FUNCTION_CALLS)
+		return 0;
+
+	if (insn->type != INSN_CALL) {
+		WARN_INSN(insn, "intra_function_call not a direct call");
+		return -1;
+	}
+
+	/*
+	 * Treat intra-function CALLs as JMPs, but with a stack_op.
+	 * See add_call_destinations(), which strips stack_ops from
+	 * normal CALLs.
+	 */
+	insn->type = INSN_JUMP_UNCONDITIONAL;
+
+	dest_off = arch_jump_destination(insn);
+	insn->jump_dest = find_insn(file, insn->sec, dest_off);
+	if (!insn->jump_dest) {
+		WARN_INSN(insn, "can't find call dest at %s+0x%lx",
+			  insn->sec->name, dest_off);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int __annotate_retpoline_safe(struct objtool_file *file, int type, struct instruction *insn)
 {
 	if (type != ANNOTYPE_RETPOLINE_SAFE)
 		return 0;
@@ -2342,7 +2373,7 @@ static int __annotate_retpoline_safe(int
 	return 0;
 }
 
-static int __annotate_instr(int type, struct instruction *insn)
+static int __annotate_instr(struct objtool_file *file, int type, struct instruction *insn)
 {
 	switch (type) {
 	case ANNOTYPE_INSTR_BEGIN:
@@ -2360,7 +2391,7 @@ static int __annotate_instr(int type, st
 	return 0;
 }
 
-static int __annotate_unret(int type, struct instruction *insn)
+static int __annotate_unret(struct objtool_file *file, int type, struct instruction *insn)
 {
 	if (type != ANNOTYPE_UNRET_BEGIN)
 		return 0;
@@ -2370,55 +2401,6 @@ static int __annotate_unret(int type, st
 
 }
 
-static int read_intra_function_calls(struct objtool_file *file)
-{
-	struct instruction *insn;
-	struct section *rsec;
-	struct reloc *reloc;
-
-	rsec = find_section_by_name(file->elf, ".rela.discard.intra_function_calls");
-	if (!rsec)
-		return 0;
-
-	for_each_reloc(rsec, reloc) {
-		unsigned long dest_off;
-
-		if (reloc->sym->type != STT_SECTION) {
-			WARN("unexpected relocation symbol type in %s",
-			     rsec->name);
-			return -1;
-		}
-
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
-		if (!insn) {
-			WARN("bad .discard.intra_function_call entry");
-			return -1;
-		}
-
-		if (insn->type != INSN_CALL) {
-			WARN_INSN(insn, "intra_function_call not a direct call");
-			return -1;
-		}
-
-		/*
-		 * Treat intra-function CALLs as JMPs, but with a stack_op.
-		 * See add_call_destinations(), which strips stack_ops from
-		 * normal CALLs.
-		 */
-		insn->type = INSN_JUMP_UNCONDITIONAL;
-
-		dest_off = arch_jump_destination(insn);
-		insn->jump_dest = find_insn(file, insn->sec, dest_off);
-		if (!insn->jump_dest) {
-			WARN_INSN(insn, "can't find call dest at %s+0x%lx",
-				  insn->sec->name, dest_off);
-			return -1;
-		}
-	}
-
-	return 0;
-}
-
 /*
  * Return true if name matches an instrumentation function, where calls to that
  * function from noinstr code can safely be removed, but compilers won't do so.
@@ -2554,7 +2536,7 @@ static int decode_sections(struct objtoo
 	 * Must be before add_call_destination(); it changes INSN_CALL to
 	 * INSN_JUMP.
 	 */
-	ret = read_intra_function_calls(file);
+	ret = read_annotate(file, __annotate_ifc);
 	if (ret)
 		return ret;
 



