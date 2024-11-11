Return-Path: <kvm+bounces-31460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C749C3EC8
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAD9C282B94
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1356919E83D;
	Mon, 11 Nov 2024 12:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ibVwk2A9"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7853615853B;
	Mon, 11 Nov 2024 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731329678; cv=none; b=jLnuK1htfIjprsxY3/fs27yI81SeFNg06Mc/SCr2FzylImBcxZqIFjimqt1D59WIJ/skL5mxqg2FxbfsvrjSjRV60bsMTwlrXbyoXKGZ9cNj8pcojxHMexFFSg0SQMMH94zXMyoK5hfi4KellEpLf6APzf5gH8ZpUvD9WnO+CkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731329678; c=relaxed/simple;
	bh=re7YlqIlSiYJgwFG46YU4SbL85meBq6Fe4HTgqcFdvk=;
	h=Message-Id:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=QfKa9jnJsBihnKM9g8/LdOe71RERj6FmiNdbfcM7Qhai0vxcVuJKkIZoXuPPlbCBZNG+K5aqzSx62bAQmthfYrUXHa9LvatrGunvFFtbB+irSysoRtlMt7BwQnzFE5yIINix3d8rRUwzTmfDRb5FDlyiRQLkYgDGMPaZeoIGYzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ibVwk2A9; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
	Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To;
	bh=5G7tZh92XjzM00TzgErAKrW0ED3Ua0OvGoNXzUhcSY0=; b=ibVwk2A9uRdQ5Dm4vPQYhrvld0
	L4VN0NGeWV0uHk24mDyhPoyF2y7YF6XhDybzQj/2zpEyqUgMYAv1KFMNpWCYayl+MLRsmBgNQkmSQ
	Pa9OY6HyVG3Oh79AuiMtkomYkteCcvz6gEcVNPresdIqJpZYjJE1FVfFAgmFz3NH5JBqkEwjx1mX3
	+E9gANxKibfLsdY0fXtEwOk3BBb9tKlxggcBepR5VFEHnitlfywbFbKQqRkd5YlUvHKvquzl4u4cK
	KqDn8C+UOYarHprqt9AOxC2A0B3thkqtQa4axNRbob2iIFSxNOFEIEbA/qzD6D+SU0kb8gG1HR5Qz
	3ejlvmIg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tATwA-0000000Coer-207x;
	Mon, 11 Nov 2024 12:54:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 0)
	id E56AB3021DA; Mon, 11 Nov 2024 13:54:32 +0100 (CET)
Message-Id: <20241111125219.033699387@infradead.org>
User-Agent: quilt/0.65
Date: Mon, 11 Nov 2024 12:59:44 +0100
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
Subject: [PATCH v2 09/12] x86/nospec: JMP_NOSPEC
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
+	"       lfence;\n"					\
+	"       jmp    902b;\n"					\
+	"       .align 16\n"					\
+	"903:	lea    4(%%esp), %%esp;\n"			\
+	"       pushl  %[thunk_target];\n"			\
+	"       ret;\n",					\
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
 



