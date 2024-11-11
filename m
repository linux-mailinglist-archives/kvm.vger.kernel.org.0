Return-Path: <kvm+bounces-31466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E1F9C3ED2
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23AFD1C21B0E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5F31A073F;
	Mon, 11 Nov 2024 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fgfgYhAo"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43C619B3EE;
	Mon, 11 Nov 2024 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329678; cv=none; b=bojob/cg+pYunfHn9HXDuaX/yKZq17+uCZ4mz6XuvukE+oi51FcF/PIwNtDpD9/3j0VzZ+FO1o8Qu8QjAHZo8NBtHJEm/spRjnCEE5mQw/yp6usrXFzk3ZBc+6rWtiG0Y9NGUQjjC62P+UTLV/30GU25FsbLyr+1xsbZZFM/rMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329678; c=relaxed/simple;
	bh=Yn8q4QXUFlxAK46m/412Srx0seyBg8HOXUGBVXU1ZX4=;
	h=Message-Id:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=f35ly1jmbPHYfbWGs+OZ0SnpmXNCPH+2Zw2jfMKMBpSVc0oex/DEFa7zOoqPiQl4a0i9S7K665yN1rbObfLCcg3bNdySMzh2MkRVilBHIulq7FIBO7b9s2yrdZVy+quw0JPckrDgVRenNOD9nS6eABz2VlTKtETcAA9UrElHtAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fgfgYhAo; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=v+L6BbfOg0jwO5KFbIbrKS0ECVjAfimoVQrz+6GrR9E=; b=fgfgYhAojh5l7OFcvabZtkuelJ
	SvRXnmQxVkY1TOKWuBUL1X6PIhn2CUA8tEI0y6DouOGHmNcY+8AI7BPYVIglWJ0nrq4Nb7OmnDozr
	nj37M9SBSEshZ5s0PtuhRNYTpf6IhipDGA6MqzSX0f8nMYFp1HdH216nihk9HmjRGI0QT6+6+vjCL
	KYXS7rONdbPAmHXS8BHEwvBnbR7dRPHUXlhASkSp3kEy/+33/zAk0PHCEHzHKCqMMH0qcPCwrU/qL
	CaJonk9RIrRDAknTlyoS37ZEqfkLF6RlPV0SVw5QU2LmbtmIKEAb/MpH2aG8T9YsE03NKc+hND4Lf
	72CdLj0A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATwA-0000000Coek-18VT;
	Mon, 11 Nov 2024 12:54:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id D57A7300F1A; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111125218.580632025@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:40 +0100
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
Subject: [PATCH v2 05/12] objtool: Convert VALIDATE_UNRET_BEGIN to ANNOTATE
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
 include/linux/objtool.h             |    9 +++------
 include/linux/objtool_types.h       |    1 +
 tools/include/linux/objtool_types.h |    1 +
 tools/objtool/check.c               |   28 +++++-----------------------
 4 files changed, 10 insertions(+), 29 deletions(-)

--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -128,15 +128,12 @@
  * NOTE: The macro must be used at the beginning of a global symbol, otherwise
  * it will be ignored.
  */
-.macro VALIDATE_UNRET_BEGIN
 #if defined(CONFIG_NOINSTR_VALIDATION) && \
 	(defined(CONFIG_MITIGATION_UNRET_ENTRY) || defined(CONFIG_MITIGATION_SRSO))
-.Lhere_\@:
-	.pushsection .discard.validate_unret
-	.long	.Lhere_\@ - .
-	.popsection
+#define VALIDATE_UNRET_BEGIN	ANNOTATE type=ANNOTYPE_UNRET_BEGIN
+#else
+#define VALIDATE_UNRET_BEGIN
 #endif
-.endm
 
 .macro REACHABLE
 .Lhere_\@:
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -61,5 +61,6 @@ struct unwind_hint {
 #define ANNOTYPE_RETPOLINE_SAFE		2
 #define ANNOTYPE_INSTR_BEGIN		3
 #define ANNOTYPE_INSTR_END		4
+#define ANNOTYPE_UNRET_BEGIN		5
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -61,5 +61,6 @@ struct unwind_hint {
 #define ANNOTYPE_RETPOLINE_SAFE		2
 #define ANNOTYPE_INSTR_BEGIN		3
 #define ANNOTYPE_INSTR_END		4
+#define ANNOTYPE_UNRET_BEGIN		5
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2450,33 +2450,15 @@ static int __annotate_instr(int type, st
 	return 0;
 }
 
-static int read_validate_unret_hints(struct objtool_file *file)
+static int __annotate_unret(int type, struct instruction *insn)
 {
-	struct section *rsec;
-	struct instruction *insn;
-	struct reloc *reloc;
-
-	rsec = find_section_by_name(file->elf, ".rela.discard.validate_unret");
-	if (!rsec)
+	if (type != ANNOTYPE_UNRET_BEGIN)
 		return 0;
 
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
-		insn->unret = 1;
-	}
-
+	insn->unret = 1;
 	return 0;
-}
 
+}
 
 static int read_intra_function_calls(struct objtool_file *file)
 {
@@ -2697,7 +2679,7 @@ static int decode_sections(struct objtoo
 	if (ret)
 		return ret;
 
-	ret = read_validate_unret_hints(file);
+	ret = read_annotate(file, __annotate_unret);
 	if (ret)
 		return ret;
 



