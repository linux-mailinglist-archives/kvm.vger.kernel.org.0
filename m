Return-Path: <kvm+bounces-31463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 487139C3ECE
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:55:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F389A1F22B0A
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50CDA19E980;
	Mon, 11 Nov 2024 12:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hHuSfZU4"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784EF153BED;
	Mon, 11 Nov 2024 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329678; cv=none; b=cMYomgV9AcNeRRV0hunrMzqSiif7caCCX59PfCWH74HtikFHDUl39I5A7+cnxp/N7AyOM7JN+tPaUbVPKQBX8tWxb75e0OxvBOCk7+7W4IbvInGwNaCZ1KwlDW+V6mY0jtYyyOYtSrBUeytytYYtX9713fU/LV1vH6AkyMa+xr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329678; c=relaxed/simple;
	bh=m01SsjIwow88FybogNsi6AHLyy3wvV6DFlakmMfrMvg=;
	h=Message-Id:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Nvtd3tVOivmhrHuzp1hdeWUZTIZl8MweThPnV3WYgO5BswDCxwoQQjw3TOnvKhNCqCh+4HkhQ4ffYjTLkNGJ3SBRvS3C3kEmOVer/cIQYe9ifQ6O6FPR3Dn+OPKRx9lXcPtq/4l/T9hQqQjbycpgmiPnNGRCnGKq44wcUbApHCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hHuSfZU4; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=VOeUTBZ+q/b21Yztg4np/MJbr8kcEsMNi/GgleRqC8c=; b=hHuSfZU4qfshHtFwsRYTWHKlui
	i0T/ToOi/iVVsFknbAo0HOEEbEss/W1BRlPjTIkPN5+9JPDMCpBp6WQDeKlc/RK47w0Q8T2OTNgWV
	vqfl6hZGXJS4mRdJTqdLni+IBLD813TlveU24OeavrJ7IKujxtmf5zYtWE8aJaS/wgcj4vsMIoiQr
	LXpt0F7tMUV6cmJsbXnARn/UNVqcG2QRo+OjNmebMJm7IZX5326/JhZ2vF//YqHrDanXXV1/ov4mg
	RelKt66BKdlOgWcMHuuIpIUtU7erwRgSAc0EsK80n+w4e2yFBYgAwXV6u5k9sQylvrD7+femcxfcH
	DZmnbXfg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATw9-0000000Coeh-2cJi;
	Mon, 11 Nov 2024 12:54:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id C53CB30083E; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111125218.113053713@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:36 +0100
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
Subject: [PATCH v2 01/12] objtool: Generic annotation infrastructure
References: <20241111115935.796797988@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Avoid endless .discard.foo sections for each annotation, create a
single .discard.annotate section that takes an annotation type along
with the instruction.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/objtool.h |   18 ++++++++++++++++++
 tools/objtool/check.c   |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -57,6 +57,13 @@
 	".long 998b\n\t"						\
 	".popsection\n\t"
 
+#define ASM_ANNOTATE(x)						\
+	"911:\n\t"						\
+	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
+	".long 911b - .\n\t"					\
+	".long " __stringify(x) "\n\t"				\
+	".popsection\n\t"
+
 #else /* __ASSEMBLY__ */
 
 /*
@@ -146,6 +153,14 @@
 	.popsection
 .endm
 
+.macro ANNOTATE type:req
+.Lhere_\@:
+	.pushsection .discard.annotate,"M",@progbits,8
+	.long	.Lhere_\@ - .
+	.long	\type
+	.popsection
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_OBJTOOL */
@@ -155,6 +170,7 @@
 #define UNWIND_HINT(type, sp_reg, sp_offset, signal) "\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
+#define ASM_ANNOTATE(x)
 #define ANNOTATE_NOENDBR
 #define ASM_REACHABLE
 #else
@@ -167,6 +183,8 @@
 .endm
 .macro REACHABLE
 .endm
+.macro ANNOTATE type:req
+.endm
 #endif
 
 #endif /* CONFIG_OBJTOOL */
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2373,6 +2373,50 @@ static int read_unwind_hints(struct objt
 	return 0;
 }
 
+static int read_annotate(struct objtool_file *file, void (*func)(int type, struct instruction *insn))
+{
+	struct section *rsec, *sec;
+	struct instruction *insn;
+	struct reloc *reloc;
+	int type;
+
+	rsec = find_section_by_name(file->elf, ".rela.discard.annotate");
+	if (!rsec)
+		return 0;
+
+	sec = find_section_by_name(file->elf, ".discard.annotate");
+	if (!sec)
+		return 0;
+
+	if (sec->sh.sh_entsize != 8) {
+		static bool warn = false;
+		if (!warn) {
+			WARN("%s: dodgy linker, sh_entsize != 8", sec->name);
+			warn = true;
+		}
+		sec->sh.sh_entsize = 8;
+	}
+
+	for_each_reloc(rsec, reloc) {
+		insn = find_insn(file, reloc->sym->sec,
+				 reloc->sym->offset + reloc_addend(reloc));
+		if (!insn) {
+			WARN("bad .discard.annotate entry: %d", reloc_idx(reloc));
+			return -1;
+		}
+
+		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
+
+		func(type, insn);
+	}
+
+	return 0;
+}
+
+static void __annotate_nop(int type, struct instruction *insn)
+{
+}
+
 static int read_noendbr_hints(struct objtool_file *file)
 {
 	struct instruction *insn;
@@ -2670,6 +2714,8 @@ static int decode_sections(struct objtoo
 	if (ret)
 		return ret;
 
+	ret = read_annotate(file, __annotate_nop);
+
 	/*
 	 * Must be before read_unwind_hints() since that needs insn->noendbr.
 	 */



