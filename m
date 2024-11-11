Return-Path: <kvm+bounces-31464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2549C3ECF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08FBFB22017
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6369419E997;
	Mon, 11 Nov 2024 12:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y/SaczTt"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9097D158DC8;
	Mon, 11 Nov 2024 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329678; cv=none; b=bYZjO3GrW6tUSvWkms2CGRfRd5nmahKJM1hmOlANH/4IlZXm1p49geMVdq0Dzu5fm5JIrTznlI+HzPaa/NKdE0gtPMrDPY6+fmKS0ijzPNjmIwZe130mE8wyZaUZ7upqSURcK/atZ5c+mA5qdMZr1CDHwsTajfERqPc0kTEA4DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329678; c=relaxed/simple;
	bh=oYrIFwvJfrI7jAQgaqfbw5jx8yrxxSmXJ4S7CQo7fxg=;
	h=Message-Id:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=ju2bIDpkhIOq9Kr7ZR4XdjdllmgGf1H+OzRxsOfdZrDRc/+Dj9wdAkU8ouTsgMFq4IZKTKEFD7g7QG3I3wGEQ1DXHqX54g+JscP4fjgnuGgXKHAnjCGpjD1P9BT3VEu62Wg5uogScrWGbK/VIjW6Pik4a9CARyZl3mUBA3ty7cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y/SaczTt; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=O8rCIvUkqNpAaMxQiAO/KoN2MOG0w6rqWm9LpswbbCQ=; b=Y/SaczTt2VLJeFlQy4NUTmJoFv
	os+shIddrDIK8eHeP/2ce+6zBS4frieguidXLlaqzvKdNkfyrQQTvDffiQ84947/rWiKM4D7/q0W3
	pxG6uONvpyw7OSY4AaKuMLW/rCtiryO0tmTzZjAOzl1rCVsjRSTfIseQwQ7veP4+UwU0iH7c2wZhl
	jGLq7GttfpzYISIggXLWvMa7tXYrMUwBAzLAhu5LaBfIsKBKplLdyKKTGaYZ4gVtPQRoN47QYl3hi
	njeasJTnIcQmqlhYpbw9rAMUp49Uc3AzGSX72A3jS4mmeHRNCIKaWDThXjvuZvzJ2P0G1vnk3mdvM
	zwieHMVA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATw9-0000000Cqjf-2bS1;
	Mon, 11 Nov 2024 12:54:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id CD60F300DDC; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111125218.357848045@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:38 +0100
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
Subject: [PATCH v2 03/12] objtool: Convert ANNOTATE_RETPOLINE_SAFE to ANNOTATE
References: <20241111115935.796797988@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8


Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/nospec-branch.h |   13 +-------
 include/linux/objtool_types.h        |    1 
 tools/include/linux/objtool_types.h  |    1 
 tools/objtool/check.c                |   52 ++++++++++++-----------------------
 4 files changed, 22 insertions(+), 45 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -193,12 +193,7 @@
  * objtool the subsequent indirect jump/call is vouched safe for retpoline
  * builds.
  */
-.macro ANNOTATE_RETPOLINE_SAFE
-.Lhere_\@:
-	.pushsection .discard.retpoline_safe
-	.long .Lhere_\@
-	.popsection
-.endm
+#define ANNOTATE_RETPOLINE_SAFE	ANNOTATE type=ANNOTYPE_RETPOLINE_SAFE
 
 /*
  * (ab)use RETPOLINE_SAFE on RET to annotate away 'bare' RET instructions
@@ -317,11 +312,7 @@
 
 #else /* __ASSEMBLY__ */
 
-#define ANNOTATE_RETPOLINE_SAFE					\
-	"999:\n\t"						\
-	".pushsection .discard.retpoline_safe\n\t"		\
-	".long 999b\n\t"					\
-	".popsection\n\t"
+#define ANNOTATE_RETPOLINE_SAFE ASM_ANNOTATE(ANNOTYPE_RETPOLINE_SAFE)
 
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
 extern retpoline_thunk_t __x86_indirect_thunk_array[];
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -58,5 +58,6 @@ struct unwind_hint {
  * Annotate types
  */
 #define ANNOTYPE_NOENDBR		1
+#define ANNOTYPE_RETPOLINE_SAFE		2
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -58,5 +58,6 @@ struct unwind_hint {
  * Annotate types
  */
 #define ANNOTYPE_NOENDBR		1
+#define ANNOTYPE_RETPOLINE_SAFE		2
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2308,12 +2308,12 @@ static int read_unwind_hints(struct objt
 	return 0;
 }
 
-static int read_annotate(struct objtool_file *file, void (*func)(int type, struct instruction *insn))
+static int read_annotate(struct objtool_file *file, int (*func)(int type, struct instruction *insn))
 {
 	struct section *rsec, *sec;
 	struct instruction *insn;
 	struct reloc *reloc;
-	int type;
+	int type, ret;
 
 	rsec = find_section_by_name(file->elf, ".rela.discard.annotate");
 	if (!rsec)
@@ -2333,53 +2333,37 @@ static int read_annotate(struct objtool_
 
 		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
 
-		func(type, insn);
+		ret = func(type, insn);
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
 }
 
-static void __annotate_noendbr(int type, struct instruction *insn)
+static int __annotate_noendbr(int type, struct instruction *insn)
 {
 	if (type != ANNOTYPE_NOENDBR)
-		return;
+		return 0;
 
 	insn->noendbr = 1;
+	return 0;
 }
 
-static int read_retpoline_hints(struct objtool_file *file)
+static int __annotate_retpoline_safe(int type, struct instruction *insn)
 {
-	struct section *rsec;
-	struct instruction *insn;
-	struct reloc *reloc;
-
-	rsec = find_section_by_name(file->elf, ".rela.discard.retpoline_safe");
-	if (!rsec)
+	if (type != ANNOTYPE_RETPOLINE_SAFE)
 		return 0;
 
-	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type != STT_SECTION) {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
-
-		insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
-		if (!insn) {
-			WARN("bad .discard.retpoline_safe entry");
-			return -1;
-		}
-
-		if (insn->type != INSN_JUMP_DYNAMIC &&
-		    insn->type != INSN_CALL_DYNAMIC &&
-		    insn->type != INSN_RETURN &&
-		    insn->type != INSN_NOP) {
-			WARN_INSN(insn, "retpoline_safe hint not an indirect jump/call/ret/nop");
-			return -1;
-		}
-
-		insn->retpoline_safe = true;
+	if (insn->type != INSN_JUMP_DYNAMIC &&
+	    insn->type != INSN_CALL_DYNAMIC &&
+	    insn->type != INSN_RETURN &&
+	    insn->type != INSN_NOP) {
+		WARN_INSN(insn, "retpoline_safe hint not an indirect jump/call/ret/nop");
+		return -1;
 	}
 
+	insn->retpoline_safe = true;
 	return 0;
 }
 
@@ -2666,7 +2650,7 @@ static int decode_sections(struct objtoo
 	if (ret)
 		return ret;
 
-	ret = read_retpoline_hints(file);
+	ret = read_annotate(file, __annotate_retpoline_safe);
 	if (ret)
 		return ret;
 



