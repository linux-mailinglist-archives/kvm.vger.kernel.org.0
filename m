Return-Path: <kvm+bounces-31472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 368049C3ED6
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDD7B283A1E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF6B1A0AEA;
	Mon, 11 Nov 2024 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tKMoI+CP"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FA219CC22;
	Mon, 11 Nov 2024 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329679; cv=none; b=EjezGO8zd7tGLkIZdalUHw0kyJuGTf6ObJiltdLJLYf3wagdvJR6DQAUQHMfkeOq9atOoG4WLY0Gj4ZGP2u6s7UhHCRG1IbpgRZwrSrBFJCSpq9fNQ+OGtUB7f+QpLx8mQHeHLBJ4L4/qnyVEAtFgLhX4wHR9l1y9Ue6fAYyqk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329679; c=relaxed/simple;
	bh=m4wNEd9VZkRxLFzfitrd/BccDMwMsl2i+sWH+ZJYUu8=;
	h=Message-Id:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Z3PUyF+yTCxwd7QmRcFm9St+T6e/1e7nxSvxxOjhlDbDp04orY1oLoicpZBFFtpG0TTg8cKsrz9CB+ul5VU4dtsuHAz66Gjf6jiKSho2cUyjgfrAbMD8smqWOu5myGM5/bMNIcKqgS/QeIsqzwPEomn+Qv7QXSjTry0tNVDm1zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tKMoI+CP; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=6BeHqEa2jz3IbAPf4WR7i0ahbBf1txiVvqLKV6vDwuM=; b=tKMoI+CP/PLxiqcur0M0UoG0pN
	xYxe/ni2cjlN/+mDic/H+036MOmGoS0rMmgC4CyxiRpz4slRc2GJj7BS7DqRU592VLyTselmcyqat
	bFGRHrM1uh5Gcxl0DmhUybDQI1cSQqTjF/MTcAclqKeOnK+mUgcyJ2KW2woK6AVqGOoWCn3wxrOuc
	OGdzlmA+09HDpJsmjzVBo3AIGrMI4leOt+TIX8n8TEodWuRol+vaNxTvjpjp2dKWFtcL5u3SK89Jk
	gsax5mCH5oTMS4vbH4qGZ/N3+cdb/TpROmlAl9ficPHXRevmGQHuT1pm0yz829b02yhaVyS7XfO0R
	AM46fd/Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATwA-0000000Coes-1zxz;
	Mon, 11 Nov 2024 12:54:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id E98873021E5; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111125219.140262800@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:45 +0100
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
Subject: [PATCH v2 10/12] x86,nospec: Simplify {JMP,CALL}_NOSPEC (part 2)
References: <20241111115935.796797988@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Counterpart to 09d09531a51a ("x86,nospec: Simplify
{JMP,CALL}_NOSPEC"), x86_64 will rewrite all this anyway, see
apply_retpoline.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/nospec-branch.h |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -429,31 +429,24 @@ static inline void call_depth_return_thu
 
 #ifdef CONFIG_X86_64
 
+#define __CS_PREFIX						\
+	".irp rs,r8,r9,r10,r11,r12,r13,r14,r15\n"		\
+	".ifc %V[thunk_target],\\rs\n"				\
+	".byte 0x2e\n"						\
+	".endif\n"						\
+	".endr\n"
+
 /*
  * Inline asm uses the %V modifier which is only in newer GCC
  * which is ensured when CONFIG_MITIGATION_RETPOLINE is defined.
  */
 # define CALL_NOSPEC						\
-	ALTERNATIVE_2(						\
-	ANNOTATE_RETPOLINE_SAFE					\
-	"call *%[thunk_target]\n",				\
-	"call __x86_indirect_thunk_%V[thunk_target]\n",		\
-	X86_FEATURE_RETPOLINE,					\
-	"lfence;\n"						\
-	ANNOTATE_RETPOLINE_SAFE					\
-	"call *%[thunk_target]\n",				\
-	X86_FEATURE_RETPOLINE_LFENCE)
+	__CS_PREFIX						\
+	"call __x86_indirect_thunk_%V[thunk_target]\n"
 
 # define JMP_NOSPEC						\
-	ALTERNATIVE_2(						\
-	ANNOTATE_RETPOLINE_SAFE					\
-	"jmp *%[thunk_target]\n",				\
-	"jmp __x86_indirect_thunk_%V[thunk_target]\n",		\
-	X86_FEATURE_RETPOLINE,					\
-	"lfence;\n"						\
-	ANNOTATE_RETPOLINE_SAFE					\
-	"jmp *%[thunk_target]\n",				\
-	X86_FEATURE_RETPOLINE_LFENCE)
+	__CS_PREFIX						\
+	"jmp __x86_indirect_thunk_%V[thunk_target]\n"
 
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 



