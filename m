Return-Path: <kvm+bounces-31273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAACD9C1EF7
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0894284EA4
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 14:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7BA31F12FD;
	Fri,  8 Nov 2024 14:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BS/oIG0L"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36DF1DEFC2;
	Fri,  8 Nov 2024 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731075368; cv=none; b=o/MiTv8LAyfK5jXouWsOmx9cHLsO61g0ZVKgr47vx2FI72otvEQl9NujAfyvzfIIjZtCLw6jkllE+cyHD4mCkTMm3rc1Swd9l7gUbcr3srY4L/YrI8mMygdlMnxoYeFuDo6yrUMVPRqpvJExmZRrH7YONwsj/kCyYRmebSUuFVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731075368; c=relaxed/simple;
	bh=ZnOt/QBmN1/tJrQ/3Ih9wNC/mk8h0EJmGW6KeJIZjfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlzMwRq0hBA6Z43fH8AqSgFd5r1QtB1THwdMU2zbQn6gzsIJpCX5U5WUjIOCixBQwFkWDvijlQcZ1PilPlugi1aQrcfmoFI3+2uY3ObE23auzPOTtXorsjVPluLEiKDl4ojnMPaXKk4Q2kQYWLrYnJzSAo1OSjg8oIGX5p+wpw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BS/oIG0L; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bf0kE6+Ar36RvohAg6YRzI2xJ5Dk2ufrDqR36SfdFtk=; b=BS/oIG0L6u2qu4IT+nvicJo3bl
	EzKKkF7xuJ9NoUQbwGS0NpDdMsIW24TsJ+ioexmMsMstnryDo2rdBWqpUXAzMb7A/2Oo9goftSSKz
	pp0ZQpuU77sxHoT86vG4UIhCWVReIvwd+ucA+0KZ0t6QoklysJrY1T6JiAYcSOzblu+g/jgok4uLB
	EMFYzwYpzcPfm/ku8fgA/u/+VcsRTLegs8+TVj3kz2Ae4GG4ytZeQW50uLodUf1gLX04oFf0RVWY2
	3T0QfiW3vh0oFgN/mG4RIIgMkcqH9i6KWL1o9j0yVBLTIZkoXQsE9Xc7/Ovy08/c3G4CD6zvDzvlH
	46gGWkXg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t9PmK-0000000CJzi-44m2;
	Fri, 08 Nov 2024 14:16:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4496730049D; Fri,  8 Nov 2024 15:16:00 +0100 (CET)
Date: Fri, 8 Nov 2024 15:16:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
	justinstitt@google.com, llvm@lists.linux.dev
Subject: Re: [PATCH 01/11] objtool: Generic annotation infrastructure
Message-ID: <20241108141600.GB6497@noisy.programming.kicks-ass.net>
References: <20231204093702.989848513@infradead.org>
 <20231204093731.356358182@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204093731.356358182@infradead.org>

On Mon, Dec 04, 2023 at 10:37:03AM +0100, Peter Zijlstra wrote:
> Avoid endless .discard.foo sections for each annotation, create a
> single .discard.annotate section that takes an annotation type along
> with the instruction.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
> --- a/include/linux/objtool.h
> +++ b/include/linux/objtool.h
> @@ -57,6 +57,13 @@
>  	".long 998b\n\t"						\
>  	".popsection\n\t"
>  
> +#define ASM_ANNOTATE(x)						\
> +	"911:\n\t"						\
> +	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> +	".long 911b - .\n\t"					\
> +	".long " __stringify(x) "\n\t"				\
> +	".popsection\n\t"
> +
>  #else /* __ASSEMBLY__ */
>  
>  /*
> @@ -146,6 +153,14 @@
>  	.popsection
>  .endm
>  
> +.macro ANNOTATE type:req
> +.Lhere_\@:
> +	.pushsection .discard.annotate,"M",@progbits,8
> +	.long	.Lhere_\@ - .
> +	.long	\type
> +	.popsection
> +.endm
> +
>  #endif /* __ASSEMBLY__ */
>  
>  #else /* !CONFIG_OBJTOOL */
> @@ -167,6 +182,8 @@
>  .endm
>  .macro REACHABLE
>  .endm
> +.macro ANNOTATE
> +.endm
>  #endif
>  
>  #endif /* CONFIG_OBJTOOL */
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -2308,6 +2308,41 @@ static int read_unwind_hints(struct objt
>  	return 0;
>  }
>  
> +static int read_annotate(struct objtool_file *file, void (*func)(int type, struct instruction *insn))
> +{
> +	struct section *rsec, *sec;
> +	struct instruction *insn;
> +	struct reloc *reloc;
> +	int type;
> +
> +	rsec = find_section_by_name(file->elf, ".rela.discard.annotate");
> +	if (!rsec)
> +		return 0;
> +
> +	sec = find_section_by_name(file->elf, ".discard.annotate");
> +	if (!sec)
> +		return 0;
> +
> +	for_each_reloc(rsec, reloc) {
> +		insn = find_insn(file, reloc->sym->sec,
> +				 reloc->sym->offset + reloc_addend(reloc));
> +		if (!insn) {
> +			WARN("bad .discard.annotate entry: %d", reloc_idx(reloc));
> +			return -1;
> +		}
> +
> +		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
> +
> +		func(type, insn);
> +	}
> +
> +	return 0;
> +}

So... ld.lld hates this :-(

From an LLVM=-19 build we can see that:

$ readelf -WS tmp-build/arch/x86/kvm/vmx/vmenter.o | grep annotate
  [13] .discard.annotate PROGBITS        0000000000000000 00028c 000018 08   M  0   0  1

$ readelf -WS tmp-build/arch/x86/kvm/kvm-intel.o | grep annotate
  [ 3] .discard.annotate PROGBITS        0000000000000000 069fe0 0089d0 00   M  0   0  1

Which tells us that the translation unit itself has a sh_entsize of 8,
while the linked object has sh_entsize of 0.

This then completely messes up the indexing objtool does, which relies
on it being a sane number.

GCC/binutils very much does not do this, it retains the 8.

Dear clang folks, help?

