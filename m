Return-Path: <kvm+bounces-23035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F00D945DDC
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 14:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 132DEB22405
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 12:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE841E3CC6;
	Fri,  2 Aug 2024 12:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EZAy3bMq"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170FF4C62A;
	Fri,  2 Aug 2024 12:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722602314; cv=none; b=UUbK/DRSEq0RM6HXNXNhY/1kg37m0t8J9k6ETJRwBMd0HPzeU3D4erioDMPxRYQ85fbnLVn9YKoFsdl3J0Jf+azvCm9+bL0SltJpuguzKzrdrTPiMQ3SBJngI6ueLoQKJJEmgl5sgIQY3jTDBFGBaPzGU4F6ZzM8+ch/te/AjAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722602314; c=relaxed/simple;
	bh=t71yf5KI3pImrAkxMTmygMtLIymhmLlch0j+/T2K0I4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEMq6H89RlZxaS6cUC8/FvPYfunzvzBE3sJFU6jWCqLHsmKPQKjiCzoqT8Kmb2uMNOpCfDhbGjYVwdcq6EVBse52Ggk0751LaaTp7E5gB2RDr6jaotWvQq7VmMjaFai2yu9t7D9guF8LP1l0p9WPxcNgb7+/tIaJzcrx2ffXlB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EZAy3bMq; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a2xbx+l3XorIuUZYCisP3R92j0F82O08k/og0JN1IR0=; b=EZAy3bMqVSECnfwHSQ4Wu0uA6q
	xV0U4klQWNuJ8HJ4o4DJkHV3i7ZQsgJzvcTdomKwrDwjn2GkObh0pkOu11soxlKpqx3InSYdzUbc0
	ay5YHfmCZSZVuNqcUWBfSyaERGbgEEv9Y0OP0F+J/u9qUNLsx0s0lbOJ+Eid1eps6v7xkgmH391Wf
	7jj0j+l+ntzSByqfmqqT5rPB86spd7D5USB8d2viqfuVLFIjZPjBEl6A+dfhYSBgbNQHt+wf8/CUr
	OcEacAF/XFzMHrzu6dMueYEpjoGdsB4A3yrtFZhRuc55k4AWNoeJ8WDkP4MEx5zI/ZkyBkz5cJ2mH
	vBWBeFXA==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sZrY3-0000000112T-0NMz;
	Fri, 02 Aug 2024 12:38:19 +0000
Date: Fri, 2 Aug 2024 13:38:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Carsten Stollmaier <stollmc@amazon.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, nh-open-source@amazon.com,
	Peter Xu <peterx@redhat.com>,
	Sebastian Biemueller <sbiemue@amazon.de>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] KVM: x86: Use gfn_to_pfn_cache for steal_time
Message-ID: <ZqzTOvyKRI0qzwCT@casper.infradead.org>
References: <20240802114402.96669-1-stollmc@amazon.com>
 <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>

On Fri, Aug 02, 2024 at 01:03:16PM +0100, David Woodhouse wrote:
> On Fri, 2024-08-02 at 11:44 +0000, Carsten Stollmaier wrote:
> > handle_userfault uses TASK_INTERRUPTIBLE, so it is interruptible by
> > signals. do_user_addr_fault then busy-retries it if the pending signal
> > is non-fatal. This leads to contention of the mmap_lock.

Why does handle_userfault use TASK_INTERRUPTIBLE?  We really don't
want to stop handling a page fault just because somebody resized a
window or a timer went off.  TASK_KILLABLE, sure.

This goes all the way back to Andreas' terse "add new syscall"
patch, so there's no justification for it in the commit logs.

> The busy-loop causes so much contention on mmap_lock that post-copy
> live migration fails to make progress, and is leading to failures. Yes?
> 
> > This patch replaces the use of gfn_to_hva_cache with gfn_to_pfn_cache,
> > as gfn_to_pfn_cache ensures page presence for the memory access,
> > preventing the contention of the mmap_lock.
> > 
> > Signed-off-by: Carsten Stollmaier <stollmc@amazon.com>
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> 
> I think this makes sense on its own, as it addresses the specific case
> where KVM is *likely* to be touching a userfaulted (guest) page. And it
> allows us to ditch yet another explicit asm exception handler.
> 
> We should note, though, that in terms of the original problem described
> above, it's a bit of a workaround. It just means that by using
> kvm_gpc_refresh() to obtain the user page, we end up in
> handle_userfault() without the FAULT_FLAG_INTERRUPTIBLE flag.
> 
> (Note to self: should kvm_gpc_refresh() take fault flags, to allow
> interruptible and killable modes to be selected by its caller?)
> 
> 
> An alternative workaround (which perhaps we should *also* consider)
> looked like this (plus some suitable code comment, of course):
> 
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1304,6 +1304,8 @@ void do_user_addr_fault(struct pt_regs *regs,
>          */
>         if (user_mode(regs))
>                 flags |= FAULT_FLAG_USER;
> +       else
> +               flags &= ~FAULT_FLAG_INTERRUPTIBLE;
>  
>  #ifdef CONFIG_X86_64
>         /*
> 
> 
> That would *also* handle arbitrary copy_to_user/copy_from_user() to
> userfault pages, which could theoretically hit the same busy loop.
> 
> I'm actually tempted to make user access *interruptible* though, and
> either add copy_{from,to}_user_interruptible() or change the semantics
> of the existing ones (which I believe are already killable).
> 
> That would require each architecture implementing interruptible
> exceptions, by doing an extable lookup before the retry. Not overly
> complex, but needs to be done for all architectures (although not at
> once; we could live with not-yet-done architectures just remaining
> killable).
> 
> Thoughts?
> 



