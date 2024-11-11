Return-Path: <kvm+bounces-31469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 770E29C3ED5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2FBB41F22340
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97541A0AE9;
	Mon, 11 Nov 2024 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EOLiYe0z"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B5019CD0E;
	Mon, 11 Nov 2024 12:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329679; cv=none; b=DHIXopa74fjTmzA3SIwGbtqT0zWfocW7kl+3KnoV16jD/V+1zsNA30Dcuz3xhZYVTmEFS/Bi8MP8h5CAeSojf4yrxdxdIALjgvET+QPER8lwf7vEsv1jKs+zyGMWt1Xc0wp+07CtoiyNJzCQupmp7zuJq20DQFq2VJVzW7PBfvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329679; c=relaxed/simple;
	bh=53DniVL2kNJAh6YH3okCJEaYKY7wFXMzVRHLvbrhu4k=;
	h=Message-Id:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=o2f0QGHQLVUOAVfihHOHMCp9g0Tv9xU2bgH1/m/z4ip2hS4TEyNKkokFXi7i5oAskUJV0Py4fIcrPzK4Tz+dQsoyPRnZZ1VaAkPdtUCFb/g3HML9sYcHmuiJIQpS3ADl2Gx4tNgDS6GwqBMMcmvMtP5RVnOO3xL9XWwro7TypEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EOLiYe0z; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=dYFXJA1/fZVGzxQ5AQj4cq8phZVmCHY7eA+a7xfnNgw=; b=EOLiYe0zU+So1jL4PO+NCMf/Cn
	zT6rzJR6daK1Nh8Y8Skab6HGr1A5aVJAc3G2gstHJgsZCIakK9a83uf1IoHEgbsRZY/ALcXxVoF2p
	nIpaB/0V0s5G1nazrw9z0V5bKNFgcoeqSMY2l8/8u7xBC2qQ0e32c6/IwWs1ZqEBCHM87ay/XoZ39
	BOhicg/vcR8ZKkMtYx43GQI2dQ4oVBoLheJMusOoeELwEUU2YX1j3UPiy3JjI0NJzXehtYKhGQZGB
	VQFq15QT8riG39vpECe/6LLyIAlVvDG1FTgyz5VSkiMg6+3Jl6qG8YT6dU/+xOTnn30hVF7eF01gD
	11C0gq8Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATw9-0000000Cqjc-2ZQt;
	Mon, 11 Nov 2024 12:54:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id C98D4300C1F; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111125218.222910882@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:37 +0100
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
Subject: [PATCH v2 02/12] objtool: Convert ANNOTATE_NOENDBR to ANNOTATE
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
 include/linux/objtool.h             |   17 ++++-------------
 include/linux/objtool_types.h       |    5 +++++
 tools/include/linux/objtool_types.h |    5 +++++
 tools/objtool/check.c               |   32 +++++---------------------------
 4 files changed, 19 insertions(+), 40 deletions(-)

--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -45,12 +45,6 @@
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #endif
 
-#define ANNOTATE_NOENDBR					\
-	"986: \n\t"						\
-	".pushsection .discard.noendbr\n\t"			\
-	".long 986b\n\t"					\
-	".popsection\n\t"
-
 #define ASM_REACHABLE							\
 	"998:\n\t"							\
 	".pushsection .discard.reachable\n\t"				\
@@ -64,6 +58,8 @@
 	".long " __stringify(x) "\n\t"				\
 	".popsection\n\t"
 
+#define ANNOTATE_NOENDBR	ASM_ANNOTATE(ANNOTYPE_NOENDBR)
+
 #else /* __ASSEMBLY__ */
 
 /*
@@ -122,13 +118,6 @@
 #endif
 .endm
 
-.macro ANNOTATE_NOENDBR
-.Lhere_\@:
-	.pushsection .discard.noendbr
-	.long	.Lhere_\@
-	.popsection
-.endm
-
 /*
  * Use objtool to validate the entry requirement that all code paths do
  * VALIDATE_UNRET_END before RET.
@@ -161,6 +150,8 @@
 	.popsection
 .endm
 
+#define ANNOTATE_NOENDBR	ANNOTATE type=ANNOTYPE_NOENDBR
+
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_OBJTOOL */
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -54,4 +54,9 @@ struct unwind_hint {
 #define UNWIND_HINT_TYPE_SAVE		6
 #define UNWIND_HINT_TYPE_RESTORE	7
 
+/*
+ * Annotate types
+ */
+#define ANNOTYPE_NOENDBR		1
+
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -54,4 +54,9 @@ struct unwind_hint {
 #define UNWIND_HINT_TYPE_SAVE		6
 #define UNWIND_HINT_TYPE_RESTORE	7
 
+/*
+ * Annotate types
+ */
+#define ANNOTYPE_NOENDBR		1
+
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2339,32 +2339,12 @@ static int read_annotate(struct objtool_
 	return 0;
 }
 
-static void __annotate_nop(int type, struct instruction *insn)
+static void __annotate_noendbr(int type, struct instruction *insn)
 {
-}
-
-static int read_noendbr_hints(struct objtool_file *file)
-{
-	struct instruction *insn;
-	struct section *rsec;
-	struct reloc *reloc;
-
-	rsec = find_section_by_name(file->elf, ".rela.discard.noendbr");
-	if (!rsec)
-		return 0;
+	if (type != ANNOTYPE_NOENDBR)
+		return;
 
-	for_each_reloc(rsec, reloc) {
-		insn = find_insn(file, reloc->sym->sec,
-				 reloc->sym->offset + reloc_addend(reloc));
-		if (!insn) {
-			WARN("bad .discard.noendbr entry");
-			return -1;
-		}
-
-		insn->noendbr = 1;
-	}
-
-	return 0;
+	insn->noendbr = 1;
 }
 
 static int read_retpoline_hints(struct objtool_file *file)
@@ -2637,12 +2617,10 @@ static int decode_sections(struct objtoo
 	if (ret)
 		return ret;
 
-	ret = read_annotate(file, __annotate_nop);
-
 	/*
 	 * Must be before read_unwind_hints() since that needs insn->noendbr.
 	 */
-	ret = read_noendbr_hints(file);
+	ret = read_annotate(file, __annotate_noendbr);
 	if (ret)
 		return ret;
 



