Return-Path: <kvm+bounces-43646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B33AA93506
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 11:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D793464EF0
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 09:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF79026FDA0;
	Fri, 18 Apr 2025 09:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVvgjuXU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82E510942;
	Fri, 18 Apr 2025 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744966910; cv=none; b=GXyUTAg3rNkThshSIgQHn4mlpPgNR/fG9qLSZXveNSUvPAAyg16U2ZkCsXwfwHJ87UgH5ykvwQ4HZ7XX4cpTwOjtZ/IoGLP/elwcYDqgnAvx+ZNcOJHk3McPcVNKNLXOF000b55xd0y0gLWe8vn0L7clkm9kEcTwBAiAQFSduGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744966910; c=relaxed/simple;
	bh=aZKGynxr/IJhFrNTczmbjc2tIFX13hW2EFcghTmecUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKE3iAqnveBEcDOBP5juKdvqYAhQWgyQE0lGI33+EiiDX1gb1WfWSjmL0kV4SFDgDdsTpKbpF6ONU3qaPZLNn0mioyQmj40IuLyJpBdiFC68javD6LsDzWW9yzM5DzHIo5/0TP2liLJjSGV5McH3dqpnFiIvAaM7vGUmS+emSVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVvgjuXU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43337C4CEE2;
	Fri, 18 Apr 2025 09:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744966910;
	bh=aZKGynxr/IJhFrNTczmbjc2tIFX13hW2EFcghTmecUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dVvgjuXUBlGyMRL/SPU1UdG7X4VnBqnKGzl+TSta9EIJfOPK3kZf2YhUAOnlaZXzL
	 /l9nKneKDRfsKv5Uy3tyDeiSn/Zf0BIMYvHGhuqS45x4kqDBGzk/l+Ggmt1qsFpJkS
	 G357HSNi5mEt2NSIYcS+mr3NDAXNwY9mZGj9UNUaF/1ZFPITaNLZKfpfL0pGZyQnb/
	 izMDaDa2b1A07V41oaa+laTZy0SPQfI9OefnMtTJUiumDpuBWVjsWdpHl66UKtxbxN
	 hLET73Hde5IqZ2RSzfW2NwewFlCLnwJ+J1R6UvQmcbQDFZWOxm4yArWcuctOHw3eUE
	 Ef1Oq5L+HVatw==
Date: Fri, 18 Apr 2025 12:01:40 +0300
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
Message-ID: <aAIU9LHAr_BGb5Jl@kernel.org>
References: <Z_rDdnlSs0rts3b9@gmail.com>
 <20250413080858.743221-1-rppt@kernel.org>
 <20250417162206.GA104424@ax162>
 <aAHyHuwbmhjWmDqc@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAHyHuwbmhjWmDqc@gmail.com>

On Fri, Apr 18, 2025 at 08:33:02AM +0200, Ingo Molnar wrote:
> 
> * Nathan Chancellor <nathan@kernel.org> wrote:
> 
> > Hi Mike,
> > 
> > On Sun, Apr 13, 2025 at 11:08:58AM +0300, Mike Rapoport wrote:
> > ...
> > >  arch/x86/kernel/e820.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> > > index 57120f0749cc..5f673bd6c7d7 100644
> > > --- a/arch/x86/kernel/e820.c
> > > +++ b/arch/x86/kernel/e820.c
> > > @@ -1300,6 +1300,14 @@ void __init e820__memblock_setup(void)
> > >  		memblock_add(entry->addr, entry->size);
> > >  	}
> > >  
> > > +	/*
> > > +	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
> > > +	 * to even less without it.
> > > +	 * Discard memory after max_pfn - the actual limit detected at runtime.
> > > +	 */
> > > +	if (IS_ENABLED(CONFIG_X86_32))
> > > +		memblock_remove(PFN_PHYS(max_pfn), -1);
> > > +
> > >  	/* Throw away partial pages: */
> > >  	memblock_trim_memory(PAGE_SIZE);
> > 
> > Our CI noticed a boot failure after this change as commit 1e07b9fad022
> > ("x86/e820: Discard high memory that can't be addressed by 32-bit
> > systems") in -tip when booting i386_defconfig with a simple buildroot
> > initrd.
> 
> I've zapped this commit from tip:x86/urgent for the time being:
> 
>   1e07b9fad022 ("x86/e820: Discard high memory that can't be addressed by 32-bit systems")
> 
> until these bugs are better understood.

With X86_PAE disabled phys_addr_t is 32 bit, PFN_PHYS(MAX_NONPAE_PFN)
overflows and we get memblock_remove(0, -1) :(

Using max_pfn instead of MAX_NONPAE_PFN would work because there's a hole
under 4G and max_pfn should never overflow.

Another option is to skip e820 entries above 4G and not add them to
memblock at the first place, e.g.

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 57120f0749cc..2b617f36f11a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1297,6 +1297,17 @@ void __init e820__memblock_setup(void)
 		if (entry->type != E820_TYPE_RAM)
 			continue;
 
+#ifdef CONFIG_X86_32
+		/*
+		 * Discard memory above 4GB because 32-bit systems are limited
+		 * to 4GB of memory even with HIGHMEM.
+		 */
+		if (entry->addr > SZ_4G)
+			continue;
+		if (entry->addr + entry->size > SZ_4G)
+			entry->size = SZ_4G - entry->addr;
+#endif
+
 		memblock_add(entry->addr, entry->size);
 	}
 
 
> Thanks,
> 
> 	Ingo

-- 
Sincerely yours,
Mike.

