Return-Path: <kvm+bounces-3315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 824A5802EE9
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3876F1F21026
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099FE20B09;
	Mon,  4 Dec 2023 09:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LSDJhy0t"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561FA106;
	Mon,  4 Dec 2023 01:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=gFiDthjTb2jV5OQYX2IoNEzMxtX8OE63urpzPswRdWY=; b=LSDJhy0tFFO/L0bq9COPVzaqVF
	bhDhZ3JnjeXxphLgY4flbljhmu/U5KIhZ6A/V5+ElaDcouYjY7Gy845lVJaZAU4tz0Xyi8/cyFyPz
	SMKABRRODkBBnKKrE2tSIrjil13QBM+oG84AEqld5hzCLDc9swSnXMRdAv67oS9MB+TZj4r0qAHz4
	owfWdwA96RFUMdtT77j5fIG+5WyL/BfpTYbzwxa0iOes2pqQQmnVLt7nyhI9F+5mWAu5tXn1Qi/Fj
	gCKL29MU4a/jhxpHMLtJUmBEYdl/hdWulzGAiwOJjNRhWEenD7I/zxkQolUjeSOkt+TixPBWcuBul
	kRyGmS5A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rA5QY-000X0P-GC; Mon, 04 Dec 2023 09:39:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id 97E073005B2; Mon,  4 Dec 2023 10:39:45 +0100 (CET)
Message-Id: <20231204093731.682850335@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 04 Dec 2023 10:37:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 x86@kernel.org,
 kvm@vger.kernel.org
Subject: [PATCH 04/11] objtool: Convert instrumentation_{begin,end}() to ANNOTATE
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
 include/linux/instrumentation.h     |   11 +++-----
 include/linux/objtool.h             |    9 ++++--
 include/linux/objtool_types.h       |    2 +
 tools/include/linux/objtool_types.h |    2 +
 tools/objtool/check.c               |   49 +++++++-----------------------------
 5 files changed, 25 insertions(+), 48 deletions(-)

--- a/include/linux/instrumentation.h
+++ b/include/linux/instrumentation.h
@@ -4,14 +4,14 @@
 
 #ifdef CONFIG_NOINSTR_VALIDATION
 
+#include <linux/objtool.h>
 #include <linux/stringify.h>
 
 /* Begin/end of an instrumentation safe region */
 #define __instrumentation_begin(c) ({					\
 	asm volatile(__stringify(c) ": nop\n\t"				\
-		     ".pushsection .discard.instr_begin\n\t"		\
-		     ".long " __stringify(c) "b - .\n\t"		\
-		     ".popsection\n\t" : : "i" (c));			\
+		     __ASM_ANNOTATE(c, ANNOTYPE_INSTR_BEGIN)		\
+		     : : "i" (c));					\
 })
 #define instrumentation_begin() __instrumentation_begin(__COUNTER__)
 
@@ -48,9 +48,8 @@
  */
 #define __instrumentation_end(c) ({					\
 	asm volatile(__stringify(c) ": nop\n\t"				\
-		     ".pushsection .discard.instr_end\n\t"		\
-		     ".long " __stringify(c) "b - .\n\t"		\
-		     ".popsection\n\t" : : "i" (c));			\
+		     __ASM_ANNOTATE(c, ANNOTYPE_INSTR_END)		\
+		     : : "i" (c));					\
 })
 #define instrumentation_end() __instrumentation_end(__COUNTER__)
 #else /* !CONFIG_NOINSTR_VALIDATION */
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -51,13 +51,16 @@
 	".long 998b\n\t"						\
 	".popsection\n\t"
 
-#define ASM_ANNOTATE(x)						\
-	"911:\n\t"						\
+#define __ASM_ANNOTATE(s, x)					\
 	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
-	".long 911b - .\n\t"					\
+	".long " __stringify(s) "b - .\n\t"			\
 	".long " __stringify(x) "\n\t"				\
 	".popsection\n\t"
 
+#define ASM_ANNOTATE(x)						\
+	"911:\n\t"						\
+	__ASM_ANNOTATE(911, x)
+
 #define ANNOTATE_NOENDBR	ASM_ANNOTATE(ANNOTYPE_NOENDBR)
 
 #else /* __ASSEMBLY__ */
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -59,5 +59,7 @@ struct unwind_hint {
  */
 #define ANNOTYPE_NOENDBR		1
 #define ANNOTYPE_RETPOLINE_SAFE		2
+#define ANNOTYPE_INSTR_BEGIN		3
+#define ANNOTYPE_INSTR_END		4
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -59,5 +59,7 @@ struct unwind_hint {
  */
 #define ANNOTYPE_NOENDBR		1
 #define ANNOTYPE_RETPOLINE_SAFE		2
+#define ANNOTYPE_INSTR_BEGIN		3
+#define ANNOTYPE_INSTR_END		4
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2367,48 +2367,19 @@ static int __annotate_retpoline_safe(int
 	return 0;
 }
 
-static int read_instr_hints(struct objtool_file *file)
+static int __annotate_instr(int type, struct instruction *insn)
 {
-	struct section *rsec;
-	struct instruction *insn;
-	struct reloc *reloc;
-
-	rsec = find_section_by_name(file->elf, ".rela.discard.instr_end");
-	if (!rsec)
-		return 0;
-
-	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type != STT_SECTION) {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
-
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
-		if (!insn) {
-			WARN("bad .discard.instr_end entry");
-			return -1;
-		}
+	switch (type) {
+	case ANNOTYPE_INSTR_BEGIN:
+		insn->instr++;
+		break;
 
+	case ANNOTYPE_INSTR_END:
 		insn->instr--;
-	}
-
-	rsec = find_section_by_name(file->elf, ".rela.discard.instr_begin");
-	if (!rsec)
-		return 0;
+		break;
 
-	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type != STT_SECTION) {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
-
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
-		if (!insn) {
-			WARN("bad .discard.instr_begin entry");
-			return -1;
-		}
-
-		insn->instr++;
+	default:
+		break;
 	}
 
 	return 0;
@@ -2654,7 +2625,7 @@ static int decode_sections(struct objtoo
 	if (ret)
 		return ret;
 
-	ret = read_instr_hints(file);
+	ret = read_annotate(file, __annotate_instr);
 	if (ret)
 		return ret;
 



