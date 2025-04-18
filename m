Return-Path: <kvm+bounces-43659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4314A93789
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 14:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4C734600BA
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B926327603D;
	Fri, 18 Apr 2025 12:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsHtkRXk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0607274FFD;
	Fri, 18 Apr 2025 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744981152; cv=none; b=uZ9JYLRPjeqia0nLS5o9Da84ZI2zILFkMys8IkBnwsm23i+qlqlso8W6NjjXjYY2qcsMP6tKvheHQ5Lu5noLng195+oi92EI2GY43M+I/yhwXQm97bXUJAlVGkd8175VzPrhnqKjOJqLPpF+3Ot48gYYncZO7Oa/4KB3irEKzkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744981152; c=relaxed/simple;
	bh=do6/KBzZAyspAbFJ5VurXRB1jqU3G/xqMfVut3BMCuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=paivMzkXPSKOXiEpI7JxtMc7p+0O0eVBnQhgFaIzx9v/ihY770y5l+DYYzRP8zqs3+MFe25KgBxSX2GUoVaG+WCMYN65rwd2IMx2WMkVKi+2xWhkPH0q6/bRzaA4gamapol6wEP2IDMO6fPgP+zrGQE68s8Qt2+XFGj5c91tVD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsHtkRXk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C9DC4CEE2;
	Fri, 18 Apr 2025 12:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744981151;
	bh=do6/KBzZAyspAbFJ5VurXRB1jqU3G/xqMfVut3BMCuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lsHtkRXkjvjmrsKmkVbhLzwe6FfMvqBWvGVWXswr0y8mLgclfQDnjhDjFoPiugtf6
	 9lpQVsJUk1yGjSpB1vQuQOo4BbD1a/+2XF9Gnk/k5qiFb9mexxdZ7GOQ43rDdmwaud
	 VfXH6MTE7jk49NrGkQOCeiQAClm98IEs0x/ICZVyYrHzx/7ISXk38GYJeWIYdGFLTb
	 vB44jiMM0qS6upMHg2zS0sVcrUelUFFgCRXilgk/AMGyZTYK5nGNmS4VEAusUmvtSQ
	 WxH7FSpTV4wUhZUtFSYAqJ30/9m55LMAhrLDqy+uwv96Z+QaeX4pA6Dn7v4/ON5oNn
	 HqJ3cvtPzv6vQ==
Date: Fri, 18 Apr 2025 14:59:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
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
Message-ID: <aAJMmQKTglGc7N-K@gmail.com>
References: <Z_rDdnlSs0rts3b9@gmail.com>
 <20250413080858.743221-1-rppt@kernel.org>
 <20250417162206.GA104424@ax162>
 <aAHyHuwbmhjWmDqc@gmail.com>
 <aAIU9LHAr_BGb5Jl@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAIU9LHAr_BGb5Jl@kernel.org>


* Mike Rapoport <rppt@kernel.org> wrote:

> On Fri, Apr 18, 2025 at 08:33:02AM +0200, Ingo Molnar wrote:
> > 
> > * Nathan Chancellor <nathan@kernel.org> wrote:
> > 
> > > Hi Mike,
> > > 
> > > On Sun, Apr 13, 2025 at 11:08:58AM +0300, Mike Rapoport wrote:
> > > ...
> > > >  arch/x86/kernel/e820.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> > > > index 57120f0749cc..5f673bd6c7d7 100644
> > > > --- a/arch/x86/kernel/e820.c
> > > > +++ b/arch/x86/kernel/e820.c
> > > > @@ -1300,6 +1300,14 @@ void __init e820__memblock_setup(void)
> > > >  		memblock_add(entry->addr, entry->size);
> > > >  	}
> > > >  
> > > > +	/*
> > > > +	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
> > > > +	 * to even less without it.
> > > > +	 * Discard memory after max_pfn - the actual limit detected at runtime.
> > > > +	 */
> > > > +	if (IS_ENABLED(CONFIG_X86_32))
> > > > +		memblock_remove(PFN_PHYS(max_pfn), -1);
> > > > +
> > > >  	/* Throw away partial pages: */
> > > >  	memblock_trim_memory(PAGE_SIZE);
> > > 
> > > Our CI noticed a boot failure after this change as commit 1e07b9fad022
> > > ("x86/e820: Discard high memory that can't be addressed by 32-bit
> > > systems") in -tip when booting i386_defconfig with a simple buildroot
> > > initrd.
> > 
> > I've zapped this commit from tip:x86/urgent for the time being:
> > 
> >   1e07b9fad022 ("x86/e820: Discard high memory that can't be addressed by 32-bit systems")
> > 
> > until these bugs are better understood.
> 
> With X86_PAE disabled phys_addr_t is 32 bit, PFN_PHYS(MAX_NONPAE_PFN)
> overflows and we get memblock_remove(0, -1) :(
> 
> Using max_pfn instead of MAX_NONPAE_PFN would work because there's a hole
> under 4G and max_pfn should never overflow.

So why don't we use max_pfn like your -v1 fix did IIRC?

	Ingo

