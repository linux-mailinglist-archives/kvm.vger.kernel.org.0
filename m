Return-Path: <kvm+bounces-43679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B593A93E2D
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 21:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40F451B6065C
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 19:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9157022D4C8;
	Fri, 18 Apr 2025 19:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uND/UnMm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25242F43;
	Fri, 18 Apr 2025 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745004323; cv=none; b=UrnRBIi3n87H3zz6GOL2zPqUZGDene3XPK4RrJOktA6SD7B/MX+Eif6MltaLZ7vzSjLA5Ex9q4T44ty58NfLFwZUYX6ambkpORQpyltDzhkgiqq5CK5smhJMzd/tDzZbz4HPr/6EVN6mGi+bjZPcEganvvUIXbzy0dYV+Y7XDdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745004323; c=relaxed/simple;
	bh=55dXAFxLMVHRfoFsJTMy3eIBe0r/r/yTP10VrK09pxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRB9bn4oPn2U8/U645jnn+tCrMKWIccv1B++FjtYEYTBQhmizEahI93r5+ylzn8sWySfFzLj8m5RnomrI5x+XlIvQQr8Fem2JVM/mOSdBB207i2H5Er8sx6Kp8j+Nfz2J08SR4UdwS7INcOuwLEQwGqT+bHTLWZ+nw2B2yyG3BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uND/UnMm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361B1C4CEE2;
	Fri, 18 Apr 2025 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745004323;
	bh=55dXAFxLMVHRfoFsJTMy3eIBe0r/r/yTP10VrK09pxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uND/UnMm2Oybk3m0NxC2Yr/019abG7xwm06yBfAWBqCk+7ew5mkXEJQ6cjxoyaKxW
	 JOpM+0wKBLAQiYsHQNI87QLYtidXyhwOUyGE5m5gvy7yZ3noNLzzAe46Wc9xJcQebW
	 DtMK9Op8AjXkybICppceZ7JA0hHh1RaQSv69d3KzKFKF5jBV7KaQyJeIC1FNLba6PU
	 aGDKvhMqIRnx12Yce8KzGIXNCbrDK3oS25ka+HikkLsJJPAQdkKCz9u+SqzK30vsBN
	 gA31K73I1T/JeWx65VqDaB/DbvgzSSNYcnj+DfmDIZvqJBsuL12vdv1zV/MX+vJRKt
	 aT4xiu5eBdhqw==
Date: Fri, 18 Apr 2025 22:25:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Andy Shevchenko <andy@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Arnd Bergmann <arnd@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/e820: discard high memory that can't be addressed by
 32-bit systems
Message-ID: <aAKnGbajVRKanGem@kernel.org>
References: <Z_rDdnlSs0rts3b9@gmail.com>
 <20250413080858.743221-1-rppt@kernel.org>
 <20250417162206.GA104424@ax162>
 <aAHyHuwbmhjWmDqc@gmail.com>
 <aAIU9LHAr_BGb5Jl@kernel.org>
 <aAJMmQKTglGc7N-K@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAJMmQKTglGc7N-K@gmail.com>

On Fri, Apr 18, 2025 at 02:59:05PM +0200, Ingo Molnar wrote:
> 
> * Mike Rapoport <rppt@kernel.org> wrote:
> 
> > On Fri, Apr 18, 2025 at 08:33:02AM +0200, Ingo Molnar wrote:
> > > 
> > > * Nathan Chancellor <nathan@kernel.org> wrote:
> > > 
> > > > Hi Mike,
> > > > 
> > > > On Sun, Apr 13, 2025 at 11:08:58AM +0300, Mike Rapoport wrote:
> > > > ...
> > > > >  arch/x86/kernel/e820.c | 8 ++++++++
> > > > >  1 file changed, 8 insertions(+)
> > > > > 
> > > > > diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> > > > > index 57120f0749cc..5f673bd6c7d7 100644
> > > > > --- a/arch/x86/kernel/e820.c
> > > > > +++ b/arch/x86/kernel/e820.c
> > > > > @@ -1300,6 +1300,14 @@ void __init e820__memblock_setup(void)
> > > > >  		memblock_add(entry->addr, entry->size);
> > > > >  	}
> > > > >  
> > > > > +	/*
> > > > > +	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
> > > > > +	 * to even less without it.
> > > > > +	 * Discard memory after max_pfn - the actual limit detected at runtime.
> > > > > +	 */
> > > > > +	if (IS_ENABLED(CONFIG_X86_32))
> > > > > +		memblock_remove(PFN_PHYS(max_pfn), -1);
> > > > > +
> > > > >  	/* Throw away partial pages: */
> > > > >  	memblock_trim_memory(PAGE_SIZE);
> > > > 
> > > > Our CI noticed a boot failure after this change as commit 1e07b9fad022
> > > > ("x86/e820: Discard high memory that can't be addressed by 32-bit
> > > > systems") in -tip when booting i386_defconfig with a simple buildroot
> > > > initrd.
> > > 
> > > I've zapped this commit from tip:x86/urgent for the time being:
> > > 
> > >   1e07b9fad022 ("x86/e820: Discard high memory that can't be addressed by 32-bit systems")
> > > 
> > > until these bugs are better understood.
> > 
> > With X86_PAE disabled phys_addr_t is 32 bit, PFN_PHYS(MAX_NONPAE_PFN)
> > overflows and we get memblock_remove(0, -1) :(
> > 
> > Using max_pfn instead of MAX_NONPAE_PFN would work because there's a hole
> > under 4G and max_pfn should never overflow.
> 
> So why don't we use max_pfn like your -v1 fix did IIRC?

Dave didn't like max_pfn. I don't feel strongly about using max_pfn or
skipping e820 ranges above 4G and not adding them to memblock.
 
> 	Ingo

-- 
Sincerely yours,
Mike.

