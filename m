Return-Path: <kvm+bounces-43609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4513A93224
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 08:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6FC18E5B6B
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 06:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AFB0269AFA;
	Fri, 18 Apr 2025 06:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDB6cTas"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4B6255E23;
	Fri, 18 Apr 2025 06:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744957989; cv=none; b=cAe+q1tMvg1GCWUWhWHPDVHEOb5ifFx9BeD25Uw9DIEu4H9qXNWL5W8Egjhknky5j9zHRWP7S3YjIQj88IoNq37eJ14lhIqu/OzzdCz0hlAo2kWJF5XkcLEbqlrygEY4kFXH2zJlnGOJRq8BvfJVve/ZQfUQTtLgUxxOrdwGnaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744957989; c=relaxed/simple;
	bh=/Hsg/wIAip3bXNiSNJ1fUrWPjc6vdLW/C5QDVAAVH/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVmamcO1K5+mZDtz1tBCwaG8NsYB/gJj48oU5stzf73XApCe9MrkVENC0OltgIKcKm1vJ7HTTm5JbK206NfWAdx2YNrZcObm/Kf31XIXxxB226oc0vAse8OA0A2kN2tyWj4zrPt+SaviOdyUTvF3PJ428hjlOUAW53IWq73SsWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDB6cTas; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D54C4CEE7;
	Fri, 18 Apr 2025 06:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744957988;
	bh=/Hsg/wIAip3bXNiSNJ1fUrWPjc6vdLW/C5QDVAAVH/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fDB6cTas7MpmIUNXLReHxeCEJW+YiHQTxAb5KF0YomPXB6llTHu3OYGfLNBwFtTO8
	 VLM1Xw6sNHca2y8L6v0LacS1bElaZ9WIE9VDVnapTvj3jt77NUrdL8Vj4FlMFKmb9Y
	 pZEHl49jmyV6sAQnGoRNTljnBydFEZoAND0ezMLGODN7VjCOB8sby0db6wnGbH8Q8A
	 yiCJMaOhVCov3l4+uLPrKufVLGcyx4yoL2OlhdSSn3AIip5gpjYwFnLpn9gYPCq4aK
	 +ao7+U39Gfozhoigyybw3yK/5IqeAw/TzeEV23bmkzx8Khis6QjxYRsa+VTfX7s8YG
	 jwGYJYnVkbd0Q==
Date: Fri, 18 Apr 2025 08:33:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <aAHyHuwbmhjWmDqc@gmail.com>
References: <Z_rDdnlSs0rts3b9@gmail.com>
 <20250413080858.743221-1-rppt@kernel.org>
 <20250417162206.GA104424@ax162>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417162206.GA104424@ax162>


* Nathan Chancellor <nathan@kernel.org> wrote:

> Hi Mike,
> 
> On Sun, Apr 13, 2025 at 11:08:58AM +0300, Mike Rapoport wrote:
> ...
> >  arch/x86/kernel/e820.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> > index 57120f0749cc..5f673bd6c7d7 100644
> > --- a/arch/x86/kernel/e820.c
> > +++ b/arch/x86/kernel/e820.c
> > @@ -1300,6 +1300,14 @@ void __init e820__memblock_setup(void)
> >  		memblock_add(entry->addr, entry->size);
> >  	}
> >  
> > +	/*
> > +	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
> > +	 * to even less without it.
> > +	 * Discard memory after max_pfn - the actual limit detected at runtime.
> > +	 */
> > +	if (IS_ENABLED(CONFIG_X86_32))
> > +		memblock_remove(PFN_PHYS(max_pfn), -1);
> > +
> >  	/* Throw away partial pages: */
> >  	memblock_trim_memory(PAGE_SIZE);
> 
> Our CI noticed a boot failure after this change as commit 1e07b9fad022
> ("x86/e820: Discard high memory that can't be addressed by 32-bit
> systems") in -tip when booting i386_defconfig with a simple buildroot
> initrd.

I've zapped this commit from tip:x86/urgent for the time being:

  1e07b9fad022 ("x86/e820: Discard high memory that can't be addressed by 32-bit systems")

until these bugs are better understood.

Thanks,

	Ingo

