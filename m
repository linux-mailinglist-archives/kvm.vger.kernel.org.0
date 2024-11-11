Return-Path: <kvm+bounces-31465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17FF09C3ED0
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D15412838A2
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922C11A0734;
	Mon, 11 Nov 2024 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HWkCkwGw"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909D01850AF;
	Mon, 11 Nov 2024 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329678; cv=none; b=bcm2TtidgbHk5Ern4qDBLvpWhgQ+/Bsr1hFw+FCVCXFkpuIuTIUZ4NlT6WK3DxPyG2OgLWn2duML+CHWxojs/wSenAwUhi0Cae6gA4ZBJdru3I2hv6DoyzcxDsXT9OVu/c2VwY52Vg/j2bPKDN+RYgI8hwXNbc4TRXfmqhmcD4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329678; c=relaxed/simple;
	bh=njWlbghBF0JH2VFA38VkKHvuHFbC5tXgU00ibS8oZCU=;
	h=Message-Id:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=H2EuOebJwqfrgbwB1mAIjsg1IAe6T++RA0o2TyMou4dDpPqBYvfnWn941jR19FBEb75TyMxSA6cW4M8X/tigWVOWh6/rt2YTYNE5oRxo5gRwBeMqNhle8qYRRrGDC/aHV52du0xqn2m8sHsXFmh3xsgOMLy47yp15ui7czoLfIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HWkCkwGw; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=VD8wRttp+FatX9b+/O+oQABiC0DBtKQAPEWfVxMeFu0=; b=HWkCkwGwu54kQmqDRRp5thWhRy
	q/Cg0HbirAnYelPnYcOMQ7J4qfUpaRLqVAEPP55JHrFi63/arieiI0UUx8NS//qxe4fwFLOEefZX3
	POv2oUk7HT7mp38LoXXiZFyJdHMoBdsi6b8t3iSnBzBvIethWw1VxSdY6AN3UjJOpokR4XzjzzrVS
	yp+B/oxlvvzNorpb0/VPCGL5PGf3vh/WzTZWeB+zpjMeas1i2GxQeI2sT7ZP8d13CIZqYPs1oT8lX
	EpUWofcELOTEgLn3GmMNcbyyL4if2ysXyiXqRjzMFPPZwW0jPyQU+gzPhJ93BY/a899OxzwmoT1DF
	DB8wySfw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATwA-0000000Cqjp-1yP1;
	Mon, 11 Nov 2024 12:54:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id ED37930221D; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111125219.248649120@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:46 +0100
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
Subject: [PATCH v2 11/12] x86/kvm/emulate: Implement test_cc() in C
References: <20241111115935.796797988@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Current test_cc() uses the fastop infrastructure to test flags using
SETcc instructions. However, int3_emulate_jcc() already fully
implements the flags->CC mapping, use that.

Removes a pile of gnarly asm.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/text-patching.h |   20 +++++++++++++-------
 arch/x86/kvm/emulate.c               |   34 ++--------------------------------
 2 files changed, 15 insertions(+), 39 deletions(-)

--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -176,9 +176,9 @@ void int3_emulate_ret(struct pt_regs *re
 }
 
 static __always_inline
-void int3_emulate_jcc(struct pt_regs *regs, u8 cc, unsigned long ip, unsigned long disp)
+bool __emulate_cc(unsigned long flags, u8 cc)
 {
-	static const unsigned long jcc_mask[6] = {
+	static const unsigned long cc_mask[6] = {
 		[0] = X86_EFLAGS_OF,
 		[1] = X86_EFLAGS_CF,
 		[2] = X86_EFLAGS_ZF,
@@ -191,15 +191,21 @@ void int3_emulate_jcc(struct pt_regs *re
 	bool match;
 
 	if (cc < 0xc) {
-		match = regs->flags & jcc_mask[cc >> 1];
+		match = flags & cc_mask[cc >> 1];
 	} else {
-		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
-			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
+		match = ((flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
+			((flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
 		if (cc >= 0xe)
-			match = match || (regs->flags & X86_EFLAGS_ZF);
+			match = match || (flags & X86_EFLAGS_ZF);
 	}
 
-	if ((match && !invert) || (!match && invert))
+	return (match && !invert) || (!match && invert);
+}
+
+static __always_inline
+void int3_emulate_jcc(struct pt_regs *regs, u8 cc, unsigned long ip, unsigned long disp)
+{
+	if (__emulate_cc(regs->flags, cc))
 		ip += disp;
 
 	int3_emulate_jmp(regs, ip);
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -26,6 +26,7 @@
 #include <asm/debugreg.h>
 #include <asm/nospec-branch.h>
 #include <asm/ibt.h>
+#include <asm/text-patching.h>
 
 #include "x86.h"
 #include "tss.h"
@@ -416,31 +417,6 @@ static int fastop(struct x86_emulate_ctx
 	ON64(FOP3E(op##q, rax, rdx, cl)) \
 	FOP_END
 
-/* Special case for SETcc - 1 instruction per cc */
-#define FOP_SETCC(op) \
-	FOP_FUNC(op) \
-	#op " %al \n\t" \
-	FOP_RET(op)
-
-FOP_START(setcc)
-FOP_SETCC(seto)
-FOP_SETCC(setno)
-FOP_SETCC(setc)
-FOP_SETCC(setnc)
-FOP_SETCC(setz)
-FOP_SETCC(setnz)
-FOP_SETCC(setbe)
-FOP_SETCC(setnbe)
-FOP_SETCC(sets)
-FOP_SETCC(setns)
-FOP_SETCC(setp)
-FOP_SETCC(setnp)
-FOP_SETCC(setl)
-FOP_SETCC(setnl)
-FOP_SETCC(setle)
-FOP_SETCC(setnle)
-FOP_END;
-
 FOP_START(salc)
 FOP_FUNC(salc)
 "pushf; sbb %al, %al; popf \n\t"
@@ -1064,13 +1040,7 @@ static int em_bsr_c(struct x86_emulate_c
 
 static __always_inline u8 test_cc(unsigned int condition, unsigned long flags)
 {
-	u8 rc;
-	void (*fop)(void) = (void *)em_setcc + FASTOP_SIZE * (condition & 0xf);
-
-	flags = (flags & EFLAGS_MASK) | X86_EFLAGS_IF;
-	asm("push %[flags]; popf; " CALL_NOSPEC
-	    : "=a"(rc), ASM_CALL_CONSTRAINT : [thunk_target]"r"(fop), [flags]"r"(flags));
-	return rc;
+	return __emulate_cc(flags, condition & 0xf);
 }
 
 static void fetch_register_operand(struct operand *op)



