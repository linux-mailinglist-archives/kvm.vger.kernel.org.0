Return-Path: <kvm+bounces-31977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CCE29CFD7B
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 10:34:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 493ECB246A4
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 09:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BD7195B1A;
	Sat, 16 Nov 2024 09:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ACNRohWX"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563A4194AEE;
	Sat, 16 Nov 2024 09:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731749621; cv=none; b=swbIHQ22znjlvy3g3XwpvIL2aUnfW7Ffz1/e6NaNN8eSGMbOlU6d7mSbGkLDVvX4XMGtdZBRFA4RgoH3Dk4o+GbiVwMveYKlac1gnYDehT5ZAfsv+Jbi2e6jeaLPL69NkxDOC4XXmPgGamzjUMffw9OWorTu+HRPdYWT7YrHAcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731749621; c=relaxed/simple;
	bh=L29d4WYAwCnOipR2Lo/vS0KouaT4rXVdIo9GGbGY9kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obaIre+DwrpqFREU7qU9HZNA6+Z0yZOxN2HeoAZfztVI+OVoiusJQy0Rw55KAN8fq4zgiWSwoWyqfF/PTNKPUEFBWo4Pn9xDtkU2ZIrNOo+5ngP4NfFMu45hvnC+BZzQuPBT0SKlOLz7fCFth+alpoeCV7exBnpGK9V/eWUmYeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ACNRohWX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yqZ5dKc7iRnfwB3kyjg/tN6YSKNFmSbCahFY3Y+gZNg=; b=ACNRohWX7wE7M/5XoBRMrjublh
	3NDqCbp6z+a0HueXikWVqiVNYOEADIguIRITCYn7LsfauzTvj2c1zjjAQu4xFOYt3iCnR6mh2ygYw
	ZHRyiaYwif9cK+VNtvUe0/Z8o/tLzFcC8eJAokckRY3+RbML9LO3hgEhVPcuF+5oe9b3SPNwpCgZA
	tjsOd5C54MGYsLUYfdOw+71koNm6e47ZKi9Jn6y+AHlGyh2j7YdfFdWosa2zDfS5C6iyhw7XaH/h5
	Lsil0ahmnZFv1eWLErJUVpXiMvmKMnDXtzl33K1A7wc4cTVGzDSl0uBEkqF68kk9JPofYFUjzulM0
	gd2iPe7A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tCFBL-000000013fo-0EIC;
	Sat, 16 Nov 2024 09:33:32 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 783F1300472; Sat, 16 Nov 2024 10:33:31 +0100 (CET)
Date: Sat, 16 Nov 2024 10:33:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 01/12] objtool: Generic annotation infrastructure
Message-ID: <20241116093331.GG22801@noisy.programming.kicks-ass.net>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.113053713@infradead.org>
 <20241115183828.6cs64mpbp5cqtce4@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115183828.6cs64mpbp5cqtce4@jpoimboe>

On Fri, Nov 15, 2024 at 10:38:28AM -0800, Josh Poimboeuf wrote:
> On Mon, Nov 11, 2024 at 12:59:36PM +0100, Peter Zijlstra wrote:
> > +#define ASM_ANNOTATE(x)						\
> > +	"911:\n\t"						\
> > +	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> > +	".long 911b - .\n\t"					\
> > +	".long " __stringify(x) "\n\t"				\
> > +	".popsection\n\t"
> 
> Why mergeable and progbits?

In order to get sh_entsize ?

> > +static int read_annotate(struct objtool_file *file, void (*func)(int type, struct instruction *insn))
> > +{
> > +	struct section *rsec, *sec;
> > +	struct instruction *insn;
> > +	struct reloc *reloc;
> > +	int type;
> > +
> > +	rsec = find_section_by_name(file->elf, ".rela.discard.annotate");
> > +	if (!rsec)
> > +		return 0;
> > +
> > +	sec = find_section_by_name(file->elf, ".discard.annotate");
> > +	if (!sec)
> > +		return 0;
> 
> Instead of looking for .rela.discard.annotate you can just get it from
> sec->rsec.

Oh, indeed.

> > +
> > +	if (sec->sh.sh_entsize != 8) {
> > +		static bool warn = false;
> 
> "warned" ?

Sure.

> > +		if (!warn) {
> > +			WARN("%s: dodgy linker, sh_entsize != 8", sec->name);
> > +			warn = true;
> > +		}
> 
> Any reason not to make this a fatal error?

lld is currently suffering from this, it would get us build failures on
llvm builds. Once that's fixed, then yes, this should become fatal.

  https://github.com/ClangBuiltLinux/linux/issues/2057

> > +		sec->sh.sh_entsize = 8;
> > +	}
> > +
> > +	for_each_reloc(rsec, reloc) {
> > +		insn = find_insn(file, reloc->sym->sec,
> > +				 reloc->sym->offset + reloc_addend(reloc));
> > +		if (!insn) {
> > +			WARN("bad .discard.annotate entry: %d", reloc_idx(reloc));
> > +			return -1;
> > +		}
> 
> Would be nice to print the type here as well.

Sure.

> > @@ -2670,6 +2714,8 @@ static int decode_sections(struct objtoo
> >  	if (ret)
> >  		return ret;
> >  
> > +	ret = read_annotate(file, __annotate_nop);
> > +
> 
> 'ret' is ignored here (not that it matters much as this goes away in the
> next patch)

Right..

