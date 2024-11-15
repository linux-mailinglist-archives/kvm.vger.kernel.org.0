Return-Path: <kvm+bounces-31954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EDEC9CF4A2
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 20:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D345B3D638
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC2A1DD0C7;
	Fri, 15 Nov 2024 18:38:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C3185B58;
	Fri, 15 Nov 2024 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731695910; cv=none; b=S2QsLVu3E+f1HFn20qAhg5IsMv4LUpPGwKwyJUH/xHZ+hpGnIV4i6N/YFJU9HNngYhaztlADsfac9a+eIYN3oV8ygOYXjOHc/ORb7FKfJoG4nQBuNxKfZrmQj0K9jc5Lr/dsXnR+3k+rmh77vBsndlyqenLkkOZ+dH4wj5aWU+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731695910; c=relaxed/simple;
	bh=52OCNaGNpSXj6THnhmxwmGZ3xzy9AHo5k80qQqIBILE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hIUniGGsGcm83Accl0BpAZtGyNohBOOv4XsjZPYIeN39wuENMnz2VLGs3GDbDkMr8rxjuAn1Ptg9bQi5h6JYELzsNIWeEdfN1DyxdcmAwsbxN2FueN46Q4nxdKQNProyukZAVAMm954liP6094ZBPi9B+9zzz2ojRETv8uFTrdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BF3C4CECF;
	Fri, 15 Nov 2024 18:38:29 +0000 (UTC)
Date: Fri, 15 Nov 2024 10:38:28 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 01/12] objtool: Generic annotation infrastructure
Message-ID: <20241115183828.6cs64mpbp5cqtce4@jpoimboe>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.113053713@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111125218.113053713@infradead.org>

On Mon, Nov 11, 2024 at 12:59:36PM +0100, Peter Zijlstra wrote:
> +#define ASM_ANNOTATE(x)						\
> +	"911:\n\t"						\
> +	".pushsection .discard.annotate,\"M\",@progbits,8\n\t"	\
> +	".long 911b - .\n\t"					\
> +	".long " __stringify(x) "\n\t"				\
> +	".popsection\n\t"

Why mergeable and progbits?

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

Instead of looking for .rela.discard.annotate you can just get it from
sec->rsec.


> +
> +	if (sec->sh.sh_entsize != 8) {
> +		static bool warn = false;

"warned" ?

> +		if (!warn) {
> +			WARN("%s: dodgy linker, sh_entsize != 8", sec->name);
> +			warn = true;
> +		}

Any reason not to make this a fatal error?

> +		sec->sh.sh_entsize = 8;
> +	}
> +
> +	for_each_reloc(rsec, reloc) {
> +		insn = find_insn(file, reloc->sym->sec,
> +				 reloc->sym->offset + reloc_addend(reloc));
> +		if (!insn) {
> +			WARN("bad .discard.annotate entry: %d", reloc_idx(reloc));
> +			return -1;
> +		}

Would be nice to print the type here as well.

> @@ -2670,6 +2714,8 @@ static int decode_sections(struct objtoo
>  	if (ret)
>  		return ret;
>  
> +	ret = read_annotate(file, __annotate_nop);
> +

'ret' is ignored here (not that it matters much as this goes away in the
next patch)

-- 
Josh

