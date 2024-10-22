Return-Path: <kvm+bounces-29425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 515C59AB490
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 18:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 809D01C2308D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 16:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D5DD1BD007;
	Tue, 22 Oct 2024 16:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A8W+Kt2x"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BB81BC9F5;
	Tue, 22 Oct 2024 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729616389; cv=none; b=LMx19gcrCHWDNsuvIF4hJ8E7oQJQPm8GfvEOFNYcTLstqCwLacG9Qshh1L5TQRA44eZJKShCo9KPqgCSCvpdDsd0OC0O1D/1LIWrDt6wruD8tFw1Rs4d7hICw0I/b+4zVyH2A/5gzvM0QDSLZyKQaouJkWUKYZXAzIcVpoZgOXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729616389; c=relaxed/simple;
	bh=VwKa+WbiBqrWRWS5cjfvU15kXhvt5HsDR7HGZdhNcA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQNfQ5yEhPvhagd86qgUbJoJypdzYAlbX1FK1nZcc4RgLPWTuUPRrUfig45ynrEuJPhXx8e14klRjWXpXgZKX3C3OiYSPyL2EpKiSQyj+/7Snp8/3ohoy6fsguePiOweZnfymha+chhBM0j0AklBAoF8sBc9O4Hh1r0UjsQIPZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A8W+Kt2x; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M3403l0++IC5vLibquK9W7dEl1jgdPyJMeNaJ8pe8Uc=; b=A8W+Kt2xkOU0oftggZLkqP2b7l
	7LLOyP22CczZYEpkuT60nFiydOm4HBeusR+5hwVnnBNvlXOoJgb29xJ6XIQ3VaBRbQLwa6+TZEe8o
	o0oMCLPO1LpwlF6aGur6JlQ9DbRi2zMpa23n3SgxchjVzp9329qt1JA2l66KLQMfjIf46RJXJu/+N
	EsUo9bCl1ICOHlH9CkZMGNDSTSZPJ3yPXql/W8pgVxTSmVLAXBTx3FkIruD1ltX2JPcs13CkVvzel
	0xlsMWn75NcsG9vpRTMij6SPA1Zw2Ng+4YDJDEO0RBReAM2Y0w/B2gJ4NJ/b42jA0Zlt7hSdEqRur
	W4FLD3FQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t3IEP-00000001pLb-1W8R;
	Tue, 22 Oct 2024 16:59:41 +0000
Date: Tue, 22 Oct 2024 17:59:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] mm: page_alloc: move mlocked flag clearance into
 free_pages_prepare()
Message-ID: <ZxfZ_VSeOo2Vnmmg@casper.infradead.org>
References: <20241021173455.2691973-1-roman.gushchin@linux.dev>
 <Zxa60Ftbh8eN1MG5@casper.infradead.org>
 <ZxcKjwhMKmnHTX8Q@google.com>
 <ZxcgR46zpW8uVKrt@casper.infradead.org>
 <ZxcrJHtIGckMo9Ni@google.com>
 <CAJD7tkb2oUre-tgVyW6XgUaNfGQSSKp=QNAfB0iZoTvHcc0n0w@mail.gmail.com>
 <ZxfHNo1dUVcOLJYK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxfHNo1dUVcOLJYK@google.com>

On Tue, Oct 22, 2024 at 08:39:34AM -0700, Sean Christopherson wrote:
> On Tue, Oct 22, 2024, Yosry Ahmed wrote:
> > Even if we don't want mlock() to err in this case, shouldn't we just do
> > nothing?
> 
> Ideally, yes.

Agreed.  There's no sense in having this count against the NR_MLOCK
stats, for example.

> > I see a lot of checks at the beginning of mlock_fixup() to check
> > whether we should operate on the vma, perhaps we should also check for
> > these KVM vmas?
> 
> Definitely not.  KVM may be doing something unexpected, but the VMA certainly
> isn't unique enough to warrant mm/ needing dedicated handling.
> 
> Focusing on KVM is likely a waste of time.  There are probably other subsystems
> and/or drivers that .mmap() kernel allocated memory in the same way.  Odds are
> good KVM is just the messenger, because syzkaller knows how to beat on KVM.  And
> even if there aren't any other existing cases, nothing would prevent them from
> coming along in the future.

They all need to be fixed.  How to do that is not an answer I have at
this point.  Ideally we can fix them without changing them all immediately
(but they will all need to be fixed eventually because pages will no
longer have a refcount and so get_page() will need to go away ...)

> > Trying to or maybe set VM_SPECIAL in kvm_vcpu_mmap()? I am not
> > sure tbh, but this doesn't seem right.
> 
> Agreed.  VM_DONTEXPAND is the only VM_SPECIAL flag that is remotely appropriate,
> but setting VM_DONTEXPAND could theoretically break userspace, and other than
> preventing mlock(), there is no reason why the VMA can't be expanded.  I doubt
> any userspace VMM is actually remapping and expanding a vCPU mapping, but trying
> to fudge around this outside of core mm/ feels kludgy and has the potential to
> turn into a game of whack-a-mole.

Actually, VM_PFNMAP is probably ideal.  We're not really mapping pages
here (I mean, they are pages, but they're not filesystem pages or
anonymous pages ... there's no rmap to them).  We're mapping blobs of
memory whose refcount is controlled by the vma that maps them.  We don't
particularly want to be able to splice() this memory, or do RDMA to it.
We probably do want gdb to be able to read it (... yes?) which might be
a complication with a PFNMAP VMA.

We've given a lot of flexibility to device drivers about how they
implement mmap() and I think that's now getting in the way of some
important improvements.  I want to see a simpler way of providing the
same functionality, and I'm not quite there yet.

