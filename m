Return-Path: <kvm+bounces-31279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8159C2022
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:13:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B2381C220CE
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 15:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD31D1F6660;
	Fri,  8 Nov 2024 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pJsaR6uO"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A5D1F4FC8;
	Fri,  8 Nov 2024 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731078822; cv=none; b=nMFVOJShtjcMAZSSe2AgDhZrlSY+8EKV8GqG8ODKXlvC506riCfZkbDnxt6ps1pcUEA3dWQrphN56BeBEy3BafVVXHlltrX+TqfO1m9WuBmPqxLJnkzNIAZAqShz9cVumrVXvoP6K3JikDZFWqnWvsQB05JO1wayJF6yAbePjJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731078822; c=relaxed/simple;
	bh=3r7xZK+cnyxCIUhmCO7JDwOTXvuhlBk3z62KWQXwkzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gW0MJWrIKl7BdvZA7f2+/LbHHYJ4Vrg5XOFyBVECLUvUhcXFZ2v+ZSsCB8BCQwXHzFqb2zK42nsWDLRCzuMEbDLt6s/sDM6eS/3a/3/SdE2fy6S0rf4oArpSsNfmLG47dvuoZAb7g887VNhE570LMRtijwp03LA8MtVv3l7sgpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pJsaR6uO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+Sg40T9b35S825tpW2ULb0mqYo7ceLM00Jqrjyl1LD4=; b=pJsaR6uOgvqCmd0VngJ7YVkhLj
	U6RmYDfnSQK9wrW1MuGCS1RdXLh5P6V51nGqPICAmT6iJZXvAJSjuo2o3bK2F8jxJ6QNAi40zuOAu
	MguC2u9aeT5SWaxCzh0XF0QjnFO7CPS/Qi5csuvMFKt3iXXihGb/04oV1VVAGtOKbYfLEr7L3kgiu
	PI5qj1c4+xlDMl5SUP5kHwgh577aWFKuyRpsrtwT3KkcQP/eSdqo+d6HH++aT6nQm5iCJdkD37uWt
	zSlIMn1aT5vdl0m0lBo83RyQZ4mDg3CXGzxWo1zBroEY8aDIP4x3tkTevBPkGNKV1+WEAsx4kz7/T
	ffTrjB6w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t9Qfz-00000008zAO-2uVh;
	Fri, 08 Nov 2024 15:13:32 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8E36830049D; Fri,  8 Nov 2024 16:13:31 +0100 (CET)
Date: Fri, 8 Nov 2024 16:13:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Fangrui Song <i@maskray.me>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, ndesaulniers@google.com,
	morbo@google.com, justinstitt@google.com, llvm@lists.linux.dev
Subject: Re: [PATCH 01/11] objtool: Generic annotation infrastructure
Message-ID: <20241108151331.GC6497@noisy.programming.kicks-ass.net>
References: <20231204093702.989848513@infradead.org>
 <20231204093731.356358182@infradead.org>
 <20241108141600.GB6497@noisy.programming.kicks-ass.net>
 <20241108145716.GA2564051@thelio-3990X>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108145716.GA2564051@thelio-3990X>

On Fri, Nov 08, 2024 at 07:57:16AM -0700, Nathan Chancellor wrote:
> On Fri, Nov 08, 2024 at 03:16:00PM +0100, Peter Zijlstra wrote:
> > On Mon, Dec 04, 2023 at 10:37:03AM +0100, Peter Zijlstra wrote:
> > > Avoid endless .discard.foo sections for each annotation, create a
> > > single .discard.annotate section that takes an annotation type along
> > > with the instruction.
> > > 
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > ---
> > > --- a/include/linux/objtool.h
> > > +++ b/include/linux/objtool.h
> > > @@ -57,6 +57,13 @@
> > >  	".long 998b\n\t"						\
> > >  	".popsection\n\t"
> > >  
> > > +#define ASM_ANNOTATE(x)						\
> > > +	"911:\n\t"						\
> > > +	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> > > +	".long 911b - .\n\t"					\
> > > +	".long " __stringify(x) "\n\t"				\
> > > +	".popsection\n\t"
> > > +
> > >  #else /* __ASSEMBLY__ */
> > >  
> > >  /*
> > > @@ -146,6 +153,14 @@
> > >  	.popsection
> > >  .endm
> > >  
> > > +.macro ANNOTATE type:req
> > > +.Lhere_\@:
> > > +	.pushsection .discard.annotate,"M",@progbits,8
> > > +	.long	.Lhere_\@ - .
> > > +	.long	\type
> > > +	.popsection
> > > +.endm
> > > +
> > >  #endif /* __ASSEMBLY__ */
> > >  
> > >  #else /* !CONFIG_OBJTOOL */
> > > @@ -167,6 +182,8 @@
> > >  .endm
> > >  .macro REACHABLE
> > >  .endm
> > > +.macro ANNOTATE
> > > +.endm
> > >  #endif
> > >  
> > >  #endif /* CONFIG_OBJTOOL */
> > > --- a/tools/objtool/check.c
> > > +++ b/tools/objtool/check.c
> > > @@ -2308,6 +2308,41 @@ static int read_unwind_hints(struct objt
> > >  	return 0;
> > >  }
> > >  
> > > +static int read_annotate(struct objtool_file *file, void (*func)(int type, struct instruction *insn))
> > > +{
> > > +	struct section *rsec, *sec;
> > > +	struct instruction *insn;
> > > +	struct reloc *reloc;
> > > +	int type;
> > > +
> > > +	rsec = find_section_by_name(file->elf, ".rela.discard.annotate");
> > > +	if (!rsec)
> > > +		return 0;
> > > +
> > > +	sec = find_section_by_name(file->elf, ".discard.annotate");
> > > +	if (!sec)
> > > +		return 0;
> > > +
> > > +	for_each_reloc(rsec, reloc) {
> > > +		insn = find_insn(file, reloc->sym->sec,
> > > +				 reloc->sym->offset + reloc_addend(reloc));
> > > +		if (!insn) {
> > > +			WARN("bad .discard.annotate entry: %d", reloc_idx(reloc));
> > > +			return -1;
> > > +		}
> > > +
> > > +		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
> > > +
> > > +		func(type, insn);
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > 
> > So... ld.lld hates this :-(
> > 
> > From an LLVM=-19 build we can see that:
> > 
> > $ readelf -WS tmp-build/arch/x86/kvm/vmx/vmenter.o | grep annotate
> >   [13] .discard.annotate PROGBITS        0000000000000000 00028c 000018 08   M  0   0  1
> > 
> > $ readelf -WS tmp-build/arch/x86/kvm/kvm-intel.o | grep annotate
> >   [ 3] .discard.annotate PROGBITS        0000000000000000 069fe0 0089d0 00   M  0   0  1
> > 
> > Which tells us that the translation unit itself has a sh_entsize of 8,
> > while the linked object has sh_entsize of 0.
> > 
> > This then completely messes up the indexing objtool does, which relies
> > on it being a sane number.
> > 
> > GCC/binutils very much does not do this, it retains the 8.
> > 
> > Dear clang folks, help?
> 
> Perhaps Fangrui has immediate thoughts, since this appears to be an
> ld.lld thing? Otherwise, I will see if I can dig into this in the next
> couple of weeks (I have an LF webinar on Wednesday that I am still
> prepping for). Is this reproducible with just defconfig or something
> else?

I took the .config from the report you pointed me at yesterday.

  https://lore.kernel.org/202411071743.HZsCuurm-lkp@intel.com/

And specifically the kvm build targets from:

$ make O=tmp-build/ LLVM=-19 arch/x86/kvm/

show this problem.

I just ran a defconfig, and that seems to behave properly. Notably,
vmlinux.o (definitely a link target) has entsize=8 for the relevant
section.

I'm not sure how the kvm targets might be 'special'.

