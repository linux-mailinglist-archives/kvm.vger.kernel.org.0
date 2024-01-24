Return-Path: <kvm+bounces-6883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CEDE83B459
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 22:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 561A928AADB
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 21:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D75A13540B;
	Wed, 24 Jan 2024 21:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwGw/amC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367351353E4
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 21:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706133502; cv=none; b=Whm53fyFNhUxSbc1aw6pFihXZlp2u5IML9mlDiE9bYW1BvwC3vPp9KhAPn0AUUYuIEu2ntgbsvwDR9KsZ11+BG2E4ilGEiA2z3UxIb938DGv/xebTdt1zR0S7n850CZ/RQxI109gxitj5EKB6WhdmcXeleQW1oIa8DQzGOChL1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706133502; c=relaxed/simple;
	bh=uMwDhQCLwA5wgNwX3/sL+vg/75j1pnH7swf2g38L7iA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3KwATea5/tOR/BR8+MoBwpfNj7qXKFhNMxEt6SsX2Dqozq+fbg2guF4eo5zTCN/KzTnosg6F4GEOkdNKOwSHv+qqeZ6TZdlVBIVeaVYYZRTvcj21/OYw6iJWxVkpsPfWY+dg5HXv3wurdessYekG3t96YMu4l83OhFBwuKuiYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qwGw/amC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B9AC433F1;
	Wed, 24 Jan 2024 21:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706133502;
	bh=uMwDhQCLwA5wgNwX3/sL+vg/75j1pnH7swf2g38L7iA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qwGw/amCMosOG55RuQMEK2Yz0wSPIw1pZbIEsKN9uTeRG3CiSLi52NkdDNFevblHH
	 kTqzMbIWc0xaXGcrM2zXvxo7WUKI/S4ZnGCRs+NkSA1GWFAMQHOfFrWWDITpZf+HDK
	 MRsG7RWYUWalvluSa6ejyoTltRWZMXHqY/WPN9Cw6vUxe1m2eTxDiPQ5qrYNekVGa4
	 tPI2bqHKOGoHYqeCyUaSmDEYc921ME9rPqfrBG5J47YgIJjoBOpQyPsCwLeH1YM5j5
	 RffoC356pdS1+HKCIv9dD/OzOek/qDzhV8UxjgD6XD1LTmUKvVf1iGT1g3s3fyZgW1
	 qbiwiiFW0sZkg==
Date: Wed, 24 Jan 2024 13:58:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andy Chiu <andy.chiu@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
	Nelson Chu <nelson.chu@sifive.com>, linux-riscv@lists.infradead.org,
	anup@brainfault.org, atishp@atishpatra.org,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com,
	guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
	aou@eecs.berkeley.edu, ndesaulniers@google.com, trix@redhat.com
Subject: Re: [PATCH -next v21 23/27] riscv: detect assembler support for
 .option arch
Message-ID: <20240124215818.GB1088@sol.localdomain>
References: <20240121011341.GA97368@sol.localdomain>
 <mhng-e4b5de69-859d-43ea-b35d-b568e6a621ef@palmer-ri-x1c9>
 <CABgGipW0pZCESu7dyiUdta2JtrpeMsJ3EABNjj_0GO9fbbTwQg@mail.gmail.com>
 <20240121181009.GA1469@sol.localdomain>
 <20240122222918.GA141255@dev-fedora.aadp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122222918.GA141255@dev-fedora.aadp>

On Mon, Jan 22, 2024 at 03:29:18PM -0700, Nathan Chancellor wrote:
> On Sun, Jan 21, 2024 at 10:10:09AM -0800, Eric Biggers wrote:
> > On Sun, Jan 21, 2024 at 10:32:59PM +0800, Andy Chiu wrote:
> > > 
> > > Maybe what we really should do is to upgrade the condition check to a
> > > one liner shell script and grep if "Warning" is being printed. Sadly
> > > this warning is not failing the compilation with -Werror.
> > > 
> > > I can try forming a patch on this if it feels alright to people.
> > 
> > What about -Wa,--fatal-warnings ?
> 
> I suspect that would work, the following diff appears to work for me
> with a version of clang that does and does not support '.option arch',
> (although I am not sure if adding -Wa,--fatal-warnings will have any
> other consequences):
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index bffbd869a068..e3142ce531a0 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -315,7 +315,6 @@ config AS_HAS_OPTION_ARCH
>  	# https://reviews.llvm.org/D123515
>  	def_bool y
>  	depends on $(as-instr, .option arch$(comma) +m)
> -	depends on !$(as-instr, .option arch$(comma) -i)
>  
>  source "arch/riscv/Kconfig.socs"
>  source "arch/riscv/Kconfig.errata"
> diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
> index 5a84b6443875..3ee8ecfb8c04 100644
> --- a/scripts/Kconfig.include
> +++ b/scripts/Kconfig.include
> @@ -33,7 +33,7 @@ ld-option = $(success,$(LD) -v $(1))
>  
>  # $(as-instr,<instr>)
>  # Return y if the assembler supports <instr>, n otherwise
> -as-instr = $(success,printf "%b\n" "$(1)" | $(CC) $(CLANG_FLAGS) -c -x assembler-with-cpp -o /dev/null -)
> +as-instr = $(success,printf "%b\n" "$(1)" | $(CC) $(CLANG_FLAGS) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o /dev/null -)
>  
>  # check if $(CC) and $(LD) exist
>  $(error-if,$(failure,command -v $(CC)),C compiler '$(CC)' not found)

It looks good to me as long as none of the as-instr users turn out to have any
expected warnings.

Maybe send the change to scripts/Kconfig.include as a separate patch?

- Eric

