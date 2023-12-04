Return-Path: <kvm+bounces-3310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51DAF802EE1
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 10:40:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D900F280F15
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 09:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821FA1EB4A;
	Mon,  4 Dec 2023 09:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GI9fusMq"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9907BD2;
	Mon,  4 Dec 2023 01:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=H9F+SG0jcXjCMA+hoF+Z9AplgtYJpt1PN/dsuLjAMTg=; b=GI9fusMqIKIMDgOataLeOA6L29
	ELtX3JSwhcqgFDC9EOI33qDJMM4Vur0H0pMdS2WT6/Tfc45bLVdueDVlvK6C8SJHh36tmHIi/t6yh
	g+epxU5qqvQjgQxvaq6Xk0btkrvgB39T5iTjmJCxEAkpAqqlxulpsi5ljenzWUFJyhTrE3w0V+OjN
	DrBCDFuJwRn2fObHlA9ZURdFgSDsd1W37iofnA3cNAv6p7NDx36zBwswl158x7ykTzemSzQeqAUUb
	BheiyAwlrxiGH5U0/ck/BvjhNG2PRfnSPKx9vWKDxQGDue8bcUeOibb2CX/68Hhg1mqdl8CvqWCOx
	cmDljhyg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rA5QZ-000X0c-6w; Mon, 04 Dec 2023 09:39:47 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id AFA29301C36; Mon,  4 Dec 2023 10:39:45 +0100 (CET)
Message-Id: <20231204093732.436930429@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 04 Dec 2023 10:37:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
 peterz@infradead.org,
 x86@kernel.org,
 kvm@vger.kernel.org
Subject: [PATCH 10/11] x86/nospec: JMP_NOSPEC
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
 arch/x86/include/asm/nospec-branch.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -403,6 +403,17 @@ static inline void call_depth_return_thu
 	"call *%[thunk_target]\n",				\
 	X86_FEATURE_RETPOLINE_LFENCE)
 
+# define JMP_NOSPEC						\
+	ALTERNATIVE_2(						\
+	ANNOTATE_RETPOLINE_SAFE					\
+	"jmp *%[thunk_target]\n",				\
+	"jmp __x86_indirect_thunk_%V[thunk_target]\n",		\
+	X86_FEATURE_RETPOLINE,					\
+	"lfence;\n"						\
+	ANNOTATE_RETPOLINE_SAFE					\
+	"jmp *%[thunk_target]\n",				\
+	X86_FEATURE_RETPOLINE_LFENCE)
+
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 
 #else /* CONFIG_X86_32 */
@@ -433,10 +444,31 @@ static inline void call_depth_return_thu
 	"call *%[thunk_target]\n",				\
 	X86_FEATURE_RETPOLINE_LFENCE)
 
+# define JMP_NOSPEC						\
+	ALTERNATIVE_2(						\
+	ANNOTATE_RETPOLINE_SAFE					\
+	"jmp *%[thunk_target]\n",				\
+	"       jmp    901f;\n"					\
+	"       .align 16\n"					\
+	"901:	call   903f;\n"					\
+	"902:	pause;\n"					\
+	"    	lfence;\n"					\
+	"       jmp    902b;\n"					\
+	"       .align 16\n"					\
+	"903:	lea    4(%%esp), %%esp;\n"			\
+	"       pushl  %[thunk_target];\n"			\
+	"       ret;\n"						\
+	X86_FEATURE_RETPOLINE,					\
+	"lfence;\n"						\
+	ANNOTATE_RETPOLINE_SAFE					\
+	"jmp *%[thunk_target]\n",				\
+	X86_FEATURE_RETPOLINE_LFENCE)
+
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
 #endif
 #else /* No retpoline for C / inline asm */
 # define CALL_NOSPEC "call *%[thunk_target]\n"
+# define JMP_NOSPEC "jmp *%[thunk_target]\n"
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
 #endif
 



