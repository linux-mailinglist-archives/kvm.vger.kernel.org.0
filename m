Return-Path: <kvm+bounces-31984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E43F9CFDBE
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 11:06:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 078D9B25ECF
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 10:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E6FB1946BA;
	Sat, 16 Nov 2024 10:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cQ54leWf"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA4F1917FE;
	Sat, 16 Nov 2024 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731751575; cv=none; b=Ew5GAi095AnHs+YEjqnK4rQqq+hzM+hiKV9jfkmeEZDDqf/qyqfkHnTqJq8nEdAHj6B+eqdygXwjzTEcQObaF59WnXqncYl5H4hcvJF+TZoaEk9YhrnQ+7ek2FkeBcvHu3vsEBKvh7V5r7nN0FZGHsZ011kbZ7FB366yf5fNsxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731751575; c=relaxed/simple;
	bh=0AlUv8R0EdPfdkhvkv09pu347pdjeQT4rOr+EcKQVIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VOAzI8jmUITpozaNZJSCueGb7KgFihRNzQh16mxKwjsqCtazB1jMfkA4mDkv1xQo/nVaozULkvlh8BJHThn+zhJ7mgLybCHAA306ebO2yMMtY27o6OQXkTATzm75HHKhE1EuLoK3YGdlIxV5YlupdeyLKzw/GS2FI68+MZP+3Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cQ54leWf; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A5rIWctTKXuF4Q5ODaGsX9C9QZC4g6I69X0S4tWU3dw=; b=cQ54leWfIGl4QHJw/pyvgH/6hc
	WCmOXIpOSjmMZ0DUj4ZeqCPTQO0XUXCjs3/dh+ad+cwdJv7OTflBTDk+NOTH98VsOGU/EMlRBzjfw
	1o/8aNKpZTWyd2qRrLo5I3BbxpatWmb8nzQeYOTGXAIhTUDcbZMI3wDTwnZRJuC8XCz5XjoGXzWB1
	btVJw3Zm7h8HNDhKdCNRYwXjmqbGwjnJINRo6pNJCi1FbXr0Rvev7mYh2BGt5ZkpC1vYgJ+XL6vOx
	wX9aPs+vAz2bc3sbtSIKV/Z3IMNMFW3cQar0zXD+BNUJ5cyFAWLfLy217E8SOrevYUnv4xQrKRjaq
	H9nq1FFw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tCFgw-000000000gF-46s6;
	Sat, 16 Nov 2024 10:06:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9D9C9300472; Sat, 16 Nov 2024 11:06:10 +0100 (CET)
Date: Sat, 16 Nov 2024 11:06:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 04/12] objtool: Convert instrumentation_{begin,end}()
 to ANNOTATE
Message-ID: <20241116100610.GN22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.469665219@infradead.org>
 <20241115184008.ek774neoqkvczxz4@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115184008.ek774neoqkvczxz4@jpoimboe>

On Fri, Nov 15, 2024 at 10:40:08AM -0800, Josh Poimboeuf wrote:
> On Mon, Nov 11, 2024 at 12:59:39PM +0100, Peter Zijlstra wrote:
> > +++ b/include/linux/objtool.h
> > @@ -51,13 +51,16 @@
> >  	".long 998b\n\t"						\
> >  	".popsection\n\t"
> >  
> > -#define ASM_ANNOTATE(x)						\
> > -	"911:\n\t"						\
> > +#define __ASM_ANNOTATE(s, x)					\
> >  	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> > -	".long 911b - .\n\t"					\
> > +	".long " __stringify(s) "b - .\n\t"			\
> 
> It would probably be better for __ASM_ANNOTATE's callers to pass in the
> full label name (e.g. '911b') since they know where the label is?  It
> could even be a named label.

This seems to work.

--- a/include/linux/instrumentation.h
+++ b/include/linux/instrumentation.h
@@ -6,11 +6,12 @@
 
 #include <linux/objtool.h>
 #include <linux/stringify.h>
+#include <linux/args.h>
 
 /* Begin/end of an instrumentation safe region */
 #define __instrumentation_begin(c) ({					\
 	asm volatile(__stringify(c) ": nop\n\t"				\
-		     __ASM_ANNOTATE(c, ANNOTYPE_INSTR_BEGIN)		\
+		     __ASM_ANNOTATE(CONCATENATE(c, b), ANNOTYPE_INSTR_BEGIN)	\
 		     : : "i" (c));					\
 })
 #define instrumentation_begin() __instrumentation_begin(__COUNTER__)
@@ -48,7 +49,7 @@
  */
 #define __instrumentation_end(c) ({					\
 	asm volatile(__stringify(c) ": nop\n\t"				\
-		     __ASM_ANNOTATE(c, ANNOTYPE_INSTR_END)		\
+		     __ASM_ANNOTATE(CONCATENATE(c, b), ANNOTYPE_INSTR_END)		\
 		     : : "i" (c));					\
 })
 #define instrumentation_end() __instrumentation_end(__COUNTER__)
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -53,13 +53,13 @@
 
 #define __ASM_ANNOTATE(s, x)					\
 	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
-	".long " __stringify(s) "b - .\n\t"			\
+	".long " __stringify(s) " - .\n\t"			\
 	".long " __stringify(x) "\n\t"				\
 	".popsection\n\t"
 
 #define ASM_ANNOTATE(x)						\
 	"911:\n\t"						\
-	__ASM_ANNOTATE(911, x)
+	__ASM_ANNOTATE(911b, x)
 
 #define ANNOTATE_NOENDBR	ASM_ANNOTATE(ANNOTYPE_NOENDBR)
 

