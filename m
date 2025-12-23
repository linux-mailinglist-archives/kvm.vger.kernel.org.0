Return-Path: <kvm+bounces-66636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ADEF8CDADA1
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:46:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 837CC304B718
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC0B2EC0B5;
	Tue, 23 Dec 2025 23:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cz1CQEbg"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E77E1A2C0B
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766533556; cv=none; b=fD2NNjaNfaZobvT0kGicHPzXxd4iK+iBfDG/tmtXJUyAiz/M14kXWOCQOYtXoRwGgwAKDn/fxd4H1j0tvfJhIUXgCLSCNfbHLxHC8xyDgxmWhPpBCNem8pBYrUnoPV3ugtXZ5f6i+gj+4hrpsJv19T3zPFfcd03Z516ygo5L+WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766533556; c=relaxed/simple;
	bh=ZkOgRjEf8p2sDCPuZPixd1hLoZ8sN8cC9vsV88355TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WvbreypycjNK3XO/j70gVjapSprDi7IfLmFln93MhipOZPgqeSQtQ65oA/ZvgtqTCIe7XKQ7tuxxe8I62d5z5UwToLZFlDlTftrU3LinErXJRUp1qsl3zkp0JaKLYaONDptjqPOnac3SFxnpJbB091utiVFfs+YKu9hb8ty6VO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cz1CQEbg; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 23 Dec 2025 23:45:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766533540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pS2EYUbR1JvkfYZsgBCkquGjYGcLrjAibCHEHzRzdm4=;
	b=Cz1CQEbguuwkD5lj5B+zrZbe5XqDAd1N8LOeMvuNPRN17LuyOh/6jWRHSrfbcnjJXnRCzL
	syrqm4kOR5nS5AhyX9aPa6iLADImfbGmAqvCbPy68imdhR91eTUmxJbW1HVvzGWZEMLvWa
	5b+CSWR8pnkiIkxbBvE1hJ7/gandcTU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/16] KVM: selftests: Reuse virt mapping functions
 for nested EPTs
Message-ID: <2sw7xjtjh4ianp2dz7p24cht2v6u55wcdac4xlrxn5vjgqti77@4ohtwtywinmi>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-11-yosry.ahmed@linux.dev>
 <aUshyQad7LjdhYAY@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUshyQad7LjdhYAY@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 23, 2025 at 03:12:09PM -0800, Sean Christopherson wrote:
> On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> > __tdp_pg_map() bears a lot of resemblence to __virt_pg_map(). The
> > main differences are:
> > - It uses the EPT struct overlay instead of the PTE masks.
> > - It always assumes 4-level EPTs.
> > 
> > To reuse __virt_pg_map(), initialize the PTE masks in nested MMU with
> > EPT PTE masks. EPTs have no 'present' or 'user' bits, so use the
> > 'readable' bit instead like shadow_{present/user}_mask, ignoring the
> > fact that entries can be present and not readable if the CPU has
> > VMX_EPT_EXECUTE_ONLY_BIT.  This is simple and sufficient for testing.
> 
> Ugh, no.  I am strongly against playing the same insane games KVM itself plays
> with overloading protectin/access bits.  There's no reason for selftests to do
> the same, e.g. selftests aren't shadowing guest PTEs and doing permission checks
> in hot paths and so don't need to multiplex a bunch of things into an inscrutable
> (but performant!) system.

I was trying to stay consistent with the KVM code (rather than care
about performance), but if you'd rather simplify things here then I am
fine with that too.

> 
> > Add an executable bitmask and update __virt_pg_map() and friends to set
> > the bit on newly created entries to match the EPT behavior. It's a nop
> > for x86 page tables.
> > 
> > Another benefit of reusing the code is having separate handling for
> > upper-level PTEs vs 4K PTEs, which avoids some quirks like setting the
> > large bit on a 4K PTE in the EPTs.
> > 
> > No functional change intended.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  .../selftests/kvm/include/x86/processor.h     |   3 +
> >  .../testing/selftests/kvm/lib/x86/processor.c |  12 +-
> >  tools/testing/selftests/kvm/lib/x86/vmx.c     | 115 ++++--------------
> >  3 files changed, 33 insertions(+), 97 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
> > index fb2b2e53d453..62e10b296719 100644
> > --- a/tools/testing/selftests/kvm/include/x86/processor.h
> > +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> > @@ -1447,6 +1447,7 @@ struct pte_masks {
> >  	uint64_t dirty;
> >  	uint64_t huge;
> >  	uint64_t nx;
> > +	uint64_t x;
> 
> To be consistent with e.g. writable, call this executable.

Was trying to be consistent with 'nx' :) 

> 
> >  	uint64_t c;
> >  	uint64_t s;
> >  };
> > @@ -1464,6 +1465,7 @@ struct kvm_mmu {
> >  #define PTE_DIRTY_MASK(mmu) ((mmu)->pte_masks.dirty)
> >  #define PTE_HUGE_MASK(mmu) ((mmu)->pte_masks.huge)
> >  #define PTE_NX_MASK(mmu) ((mmu)->pte_masks.nx)
> > +#define PTE_X_MASK(mmu) ((mmu)->pte_masks.x)
> >  #define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
> >  #define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
> >  
> > @@ -1474,6 +1476,7 @@ struct kvm_mmu {
> >  #define pte_dirty(mmu, pte) (!!(*(pte) & PTE_DIRTY_MASK(mmu)))
> >  #define pte_huge(mmu, pte) (!!(*(pte) & PTE_HUGE_MASK(mmu)))
> >  #define pte_nx(mmu, pte) (!!(*(pte) & PTE_NX_MASK(mmu)))
> > +#define pte_x(mmu, pte) (!!(*(pte) & PTE_X_MASK(mmu)))
> 
> And then here to not assume PRESENT == READABLE, just check if the MMU even has
> a PRESENT bit.  We may still need changes, e.g. the page table builders actually
> need to verify a PTE is _writable_, not just present, but that's largely an
> orthogonal issue.

Not sure what you mean? How is the PTE being writable relevant to
assuming PRESENT == READABLE?

> 
> #define is_present_pte(mmu, pte)		\
> 	(PTE_PRESENT_MASK(mmu) ?		\
> 	 !!(*(pte) & PTE_PRESENT_MASK(mmu)) :	\
> 	 !!(*(pte) & (PTE_READABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu))))

and then Intel will introduce VMX_EPT_WRITE_ONLY_BIT :P

> 
> And to properly capture the relationship between NX and EXECUTABLE:
> 
> #define is_executable_pte(mmu, pte)	\
> 	((*(pte) & (PTE_EXECUTABLE_MASK(mmu) | PTE_NX_MASK(mmu))) == PTE_EXECUTABLE_MASK(mmu))

Yeah that's a lot better.

> 
> #define is_nx_pte(mmu, pte)		(!is_executable_pte(mmu, pte))
> 
> >  #define pte_c(mmu, pte) (!!(*(pte) & PTE_C_MASK(mmu)))
> >  #define pte_s(mmu, pte) (!!(*(pte) & PTE_S_MASK(mmu)))
> >  
> > diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
> > index bff75ff05364..8b0e17f8ca37 100644
> > --- a/tools/testing/selftests/kvm/lib/x86/processor.c
> > +++ b/tools/testing/selftests/kvm/lib/x86/processor.c
> > @@ -162,8 +162,7 @@ struct kvm_mmu *mmu_create(struct kvm_vm *vm, int pgtable_levels,
> >  	struct kvm_mmu *mmu = calloc(1, sizeof(*mmu));
> >  
> >  	TEST_ASSERT(mmu, "-ENOMEM when allocating MMU");
> > -	if (pte_masks)
> > -		mmu->pte_masks = *pte_masks;
> > +	mmu->pte_masks = *pte_masks;
> 
> Rather than pass NULL (and allow NULL here) in the previous patch, pass an
> empty pte_masks.  That avoids churning the MMU initialization code, and allows
> for a better TODO in the previous patch.

Makes sense.

> 
> > +	/*
> > +	 * EPTs do not have 'present' or 'user' bits, instead bit 0 is the
> > +	 * 'readable' bit. In some cases, EPTs can be execute-only and an entry
> > +	 * is present but not readable. However, for the purposes of testing we
> > +	 * assume 'present' == 'user' == 'readable' for simplicity.
> > +	 */
> > +	pte_masks = (struct pte_masks){
> > +		.present	=	BIT_ULL(0),
> > +		.user		=	BIT_ULL(0),
> > +		.writable	=	BIT_ULL(1),
> > +		.x		=	BIT_ULL(2),
> > +		.accessed	=	BIT_ULL(5),
> > +		.dirty		=	BIT_ULL(6),
> > +		.huge		=	BIT_ULL(7),
> > +		.nx		=	0,
> > +	};
> > +
> >  	/* EPTP_PWL_4 is always used */
> 
> Make this a TODO, e.g.
> 
> 	/* TODO: Add support for 5-level paging. */
> 
> so that it's clear this is a shortcoming, not some fundamental property of
> selftests.

Makes sense.

