Return-Path: <kvm+bounces-3307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68FB1802ED8
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A7EE1C209A9
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC771D69B;
	Mon,  4 Dec 2023 09:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hp565mu6"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAF0B2;
	Mon,  4 Dec 2023 01:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=iT8rZBU1kFBBncA0eT4LO89fZPLO0VJsqubseEy0Iso=; b=hp565mu6qAqH0rQKKpsy33mH+O
	VpKF9v1+ZY5Yp+5PFrwbFzKoNR9q9e3UR44zfU8E52uaGpF57V1ZBwk9ex1c/RW5p3Od/YJFqJZz5
	zuiTDQVT9+w7JKjVWBcLB8Vv4+gmq129P9lBr5yg9qvgqBxB4BrFavooC1bGcArbIfucbEELn6o79
	fR1WgLHahQIucmH/dpwTyvpF1k5sfKeNNizLgH/ADqofQuJ1dUJ8NWxTTlHcTWnw15v19iGIQ5nGR
	Kv+xQU8tCFXSNvMjw6+2brg+Q6jtAnzfPE6Nd+wgZr7wajPnlEpn58wxBW181sjQQUqWc1YGByOod
	yXtVUwng==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rA5QY-004KSg-34;
	Mon, 04 Dec 2023 09:39:47 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id A03D730088E; Mon,  4 Dec 2023 10:39:45 +0100 (CET)
Message-Id: <20231204093731.986118946@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 04 Dec 2023 10:37:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 x86@kernel.org,
 kvm@vger.kernel.org
Subject: [PATCH 06/11] objtool: Convert ANNOTATE_IGNORE_ALTERNATIVE to ANNOTATE
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
 arch/x86/include/asm/alternative.h  |   14 ++---------
 include/linux/objtool_types.h       |    1 
 tools/include/linux/objtool_types.h |    1 
 tools/objtool/check.c               |   45 ++++++++----------------------------
 4 files changed, 15 insertions(+), 46 deletions(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/stringify.h>
+#include <linux/objtool.h>
 #include <asm/asm.h>
 
 #define ALT_FLAGS_SHIFT		16
@@ -55,11 +56,7 @@
  * objtool annotation to ignore the alternatives and only consider the original
  * instruction(s).
  */
-#define ANNOTATE_IGNORE_ALTERNATIVE				\
-	"999:\n\t"						\
-	".pushsection .discard.ignore_alts\n\t"			\
-	".long 999b\n\t"					\
-	".popsection\n\t"
+#define ANNOTATE_IGNORE_ALTERNATIVE	ASM_ANNOTATE(ANNOTYPE_IGNORE_ALTS)
 
 /*
  * The patching flags are part of the upper bits of the @ft_flags parameter when
@@ -349,12 +346,7 @@ static inline int alternatives_text_rese
  * objtool annotation to ignore the alternatives and only consider the original
  * instruction(s).
  */
-.macro ANNOTATE_IGNORE_ALTERNATIVE
-	.Lannotate_\@:
-	.pushsection .discard.ignore_alts
-	.long .Lannotate_\@
-	.popsection
-.endm
+#define ANNOTATE_IGNORE_ALTERNATIVE ANNOTATE type=ANNOTYPE_IGNORE_ALTS
 
 /*
  * Issue one struct alt_instr descriptor entry (need to put it into
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -62,5 +62,6 @@ struct unwind_hint {
 #define ANNOTYPE_INSTR_BEGIN		3
 #define ANNOTYPE_INSTR_END		4
 #define ANNOTYPE_UNRET_BEGIN		5
+#define ANNOTYPE_IGNORE_ALTS		6
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -62,5 +62,6 @@ struct unwind_hint {
 #define ANNOTYPE_INSTR_BEGIN		3
 #define ANNOTYPE_INSTR_END		4
 #define ANNOTYPE_UNRET_BEGIN		5
+#define ANNOTYPE_IGNORE_ALTS		6
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1255,40 +1255,6 @@ static void add_uaccess_safe(struct objt
 }
 
 /*
- * FIXME: For now, just ignore any alternatives which add retpolines.  This is
- * a temporary hack, as it doesn't allow ORC to unwind from inside a retpoline.
- * But it at least allows objtool to understand the control flow *around* the
- * retpoline.
- */
-static int add_ignore_alternatives(struct objtool_file *file)
-{
-	struct section *rsec;
-	struct reloc *reloc;
-	struct instruction *insn;
-
-	rsec = find_section_by_name(file->elf, ".rela.discard.ignore_alts");
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
-			WARN("bad .discard.ignore_alts entry");
-			return -1;
-		}
-
-		insn->ignore_alts = true;
-	}
-
-	return 0;
-}
-
-/*
  * Symbols that replace INSN_CALL_DYNAMIC, every (tail) call to such a symbol
  * will be added to the .retpoline_sites section.
  */
@@ -2341,6 +2307,15 @@ static int read_annotate(struct objtool_
 	return 0;
 }
 
+static int __annotate_ignore_alts(int type, struct instruction *insn)
+{
+	if (type != ANNOTYPE_IGNORE_ALTS)
+		return 0;
+
+	insn->ignore_alts = true;
+	return 0;
+}
+
 static int __annotate_noendbr(int type, struct instruction *insn)
 {
 	if (type != ANNOTYPE_NOENDBR)
@@ -2550,7 +2525,7 @@ static int decode_sections(struct objtoo
 	add_ignores(file);
 	add_uaccess_safe(file);
 
-	ret = add_ignore_alternatives(file);
+	ret = read_annotate(file, __annotate_ignore_alts);
 	if (ret)
 		return ret;
 



