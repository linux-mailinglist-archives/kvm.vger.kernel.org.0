Return-Path: <kvm+bounces-31470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3239C3ED4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:56:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D8CA1C21B1D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36671A08DC;
	Mon, 11 Nov 2024 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OMijxigB"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD9C19CD0B;
	Mon, 11 Nov 2024 12:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329679; cv=none; b=HpFqKAkeXF30StgKIYTpgO+slo0sUBWOIOMFEhLWCYD+umwW3w2nS6NiNCR/y2SMzoiRSFCinDhE7Dg/ezYgFpi0gXGPTON91w1VtQWdR1Q5fS/RZfg904nSlm6c84vdEWSYC/nBP5ENm4RCvZWobNGATUBKdp6p6dRUHQt850o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329679; c=relaxed/simple;
	bh=jybyn6XZ2fRp0B9YYZfk+IZqXuh7HT6e1Vw11iBq/m4=;
	h=Message-Id:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=PLJRwlpNYJQX7lyWZlmApa7vHXGgEcJJ7QNq/dw5fveWCl5q4zUWXuFRsUjLksB6L7ofoSU9PQkyscSca7pV+GDYSjZMfe9obRh3Z7lrhOv2X84BBDayPn+TykLg5yLauKAlK/CnXsu/CMc+tpmzsvRLkViOY1K4P0U7a5mLJN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OMijxigB; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=8ZmAUMpjWfI1B/Ma4euS1POKJrZM+zq/pwDtgORWvEc=; b=OMijxigB62AK9YJX8h2s49/609
	SlOn+fs2Y+kKMXv5BRm155kzL7xXcU/z48hB8rjGwQocaEJZduO7lWfurmIeqU80zVz7mDLB8mJuW
	GMOUGZJPNYKvrn9J7Dy+zd5H0Y5tOGXlwxqQ/3/MShgOhzE5uxCzn/u8/BfuOWxspcGnRaujRjKK6
	a8eg+5oeEvnx44Nsaf2jjNK3F/m3klo/j+XbLmxfVbuNWci0jMO3VeLVEn2iM6DYWZbGeAdJsIZpq
	lEjdp/LzqOlEjrz7WrGArJbWQxU6gD+/O0C6bZsdjZsYU+sLpfZ3GEJGK1aJhkFZsKAUqaUbMWsR5
	KcLgfsBg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATwA-0000000Cqjo-1utq;
	Mon, 11 Nov 2024 12:54:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id E19963021D3; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111125218.921110073@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:43 +0100
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
Subject: [PATCH v2 08/12] objtool: Collapse annotate sequences
References: <20241111115935.796797988@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Reduce read_annotate() runs by collapsing subsequent runs into a
single call.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 tools/objtool/check.c |   87 ++++++++++++++++++--------------------------------
 1 file changed, 32 insertions(+), 55 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2308,21 +2308,24 @@ static int read_annotate(struct objtool_
 	return 0;
 }
 
-static int __annotate_ignore_alts(struct objtool_file *file, int type, struct instruction *insn)
+static int __annotate_early(struct objtool_file *file, int type, struct instruction *insn)
 {
-	if (type != ANNOTYPE_IGNORE_ALTS)
-		return 0;
+	switch (type) {
+	case ANNOTYPE_IGNORE_ALTS:
+		insn->ignore_alts = true;
+		break;
 
-	insn->ignore_alts = true;
-	return 0;
-}
+	/*
+	 * Must be before read_unwind_hints() since that needs insn->noendbr.
+	 */
+	case ANNOTYPE_NOENDBR:
+		insn->noendbr = 1;
+		break;
 
-static int __annotate_noendbr(struct objtool_file *file, int type, struct instruction *insn)
-{
-	if (type != ANNOTYPE_NOENDBR)
-		return 0;
+	default:
+		break;
+	}
 
-	insn->noendbr = 1;
 	return 0;
 }
 
@@ -2356,26 +2359,21 @@ static int __annotate_ifc(struct objtool
 	return 0;
 }
 
-static int __annotate_retpoline_safe(struct objtool_file *file, int type, struct instruction *insn)
+static int __annotate_late(struct objtool_file *file, int type, struct instruction *insn)
 {
-	if (type != ANNOTYPE_RETPOLINE_SAFE)
-		return 0;
-
-	if (insn->type != INSN_JUMP_DYNAMIC &&
-	    insn->type != INSN_CALL_DYNAMIC &&
-	    insn->type != INSN_RETURN &&
-	    insn->type != INSN_NOP) {
-		WARN_INSN(insn, "retpoline_safe hint not an indirect jump/call/ret/nop");
-		return -1;
-	}
+	switch (type) {
+	case ANNOTYPE_RETPOLINE_SAFE:
+		if (insn->type != INSN_JUMP_DYNAMIC &&
+		    insn->type != INSN_CALL_DYNAMIC &&
+		    insn->type != INSN_RETURN &&
+		    insn->type != INSN_NOP) {
+			WARN_INSN(insn, "retpoline_safe hint not an indirect jump/call/ret/nop");
+			return -1;
+		}
 
-	insn->retpoline_safe = true;
-	return 0;
-}
+		insn->retpoline_safe = true;
+		break;
 
-static int __annotate_instr(struct objtool_file *file, int type, struct instruction *insn)
-{
-	switch (type) {
 	case ANNOTYPE_INSTR_BEGIN:
 		insn->instr++;
 		break;
@@ -2384,6 +2382,10 @@ static int __annotate_instr(struct objto
 		insn->instr--;
 		break;
 
+	case ANNOTYPE_UNRET_BEGIN:
+		insn->unret = 1;
+		break;
+
 	default:
 		break;
 	}
@@ -2391,16 +2393,6 @@ static int __annotate_instr(struct objto
 	return 0;
 }
 
-static int __annotate_unret(struct objtool_file *file, int type, struct instruction *insn)
-{
-	if (type != ANNOTYPE_UNRET_BEGIN)
-		return 0;
-
-	insn->unret = 1;
-	return 0;
-
-}
-
 /*
  * Return true if name matches an instrumentation function, where calls to that
  * function from noinstr code can safely be removed, but compilers won't do so.
@@ -2507,14 +2499,7 @@ static int decode_sections(struct objtoo
 	add_ignores(file);
 	add_uaccess_safe(file);
 
-	ret = read_annotate(file, __annotate_ignore_alts);
-	if (ret)
-		return ret;
-
-	/*
-	 * Must be before read_unwind_hints() since that needs insn->noendbr.
-	 */
-	ret = read_annotate(file, __annotate_noendbr);
+	ret = read_annotate(file, __annotate_early);
 	if (ret)
 		return ret;
 
@@ -2560,15 +2545,7 @@ static int decode_sections(struct objtoo
 	if (ret)
 		return ret;
 
-	ret = read_annotate(file, __annotate_retpoline_safe);
-	if (ret)
-		return ret;
-
-	ret = read_annotate(file, __annotate_instr);
-	if (ret)
-		return ret;
-
-	ret = read_annotate(file, __annotate_unret);
+	ret = read_annotate(file, __annotate_late);
 	if (ret)
 		return ret;
 



