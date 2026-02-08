Return-Path: <kvm+bounces-70549-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QB1XNypfiGnUowQAu9opvQ
	(envelope-from <kvm+bounces-70549-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 11:02:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 575B010849B
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 11:02:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 830BA30209C9
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 10:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801453451C7;
	Sun,  8 Feb 2026 10:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgFdGLof"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61981B87C0;
	Sun,  8 Feb 2026 10:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770544882; cv=none; b=X21stAWus59XOnXHWMT8CoQN5/LvQnOg1zFzlL9prJaI9cwvrenr2b2zExdnPwSjncAxi97UFQQODeEUqeKFlF2sTap9IaWwi81lU4zPuRtmy4Oz1CIGGtlzKjYXm1x3mE5mEGbjj8JwY8MZIwdhMJtaPopvjc+cU6+KeOPBWww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770544882; c=relaxed/simple;
	bh=rMGNaelkKWjBrekHcrcLc5HycHIOWDJuUOdPyJVDSSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1+IppakaJP9ZVPO0Rd0nQKYqozLwb7GjcM0BaA7RxfErzoOxIc0kdGBhx10pTuH8cw5kTAb2ukqpkE81ZyKyF+i5Ly/xC8/HXnpC0Xnma+NSBd/VG6q/p0gWqqVrtb+UAp3gm8HV0n8VtMzVgF1vHLY1Mriu9yBIEfcIxt30rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgFdGLof; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39F8C116C6;
	Sun,  8 Feb 2026 10:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770544882;
	bh=rMGNaelkKWjBrekHcrcLc5HycHIOWDJuUOdPyJVDSSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TgFdGLof+tmo3Mj4L9Gb66C9SS7fU49Gd2AzwvukepuD9QHDDu8KMd78N6J9OvpKL
	 c2mJQ8C+OHvTBHIZdFrGbTUFKjZbZTKwGOwqXcZyV9A65IIffW35AixZ2rBLIWSdp5
	 k7/W0+4HzUMGc/IyGMqlGe0OyyXpPYyg8W0lVp8C5AXJLjsT9ErEYCCwzdMzdiCZDR
	 4JivQvU4OmGEWAugGh3eZrqCQElyXDba0/rGJOvuSJXpyoipevE4b860k5fPLI0quK
	 RNrMyEJiHsyxU9wE0ykLnfVmdajrtzzxPNJ8hHfrn51RzL6D/NIw+kLVKmn7ieSjTM
	 QuurWg+ZbX6Pg==
Date: Sun, 8 Feb 2026 12:01:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 05/17] userfaultfd: retry copying with locks dropped
 in mfill_atomic_pte_copy()
Message-ID: <aYhe55zEqvuyng8z@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-6-rppt@kernel.org>
 <aYEVxD_vY-qimMNL@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYEVxD_vY-qimMNL@x1.local>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70549-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 575B010849B
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 04:23:16PM -0500, Peter Xu wrote:
> Hi, Mike,
> 
> On Tue, Jan 27, 2026 at 09:29:24PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Implementation of UFFDIO_COPY for anonymous memory might fail to copy
> > data data from userspace buffer when the destination VMA is locked
> > (either with mm_lock or with per-VMA lock).
> > 
> > In that case, mfill_atomic() releases the locks, retries copying the
> > data with locks dropped and then re-locks the destination VMA and
> > re-establishes PMD.
> > 
> > Since this retry-reget dance is only relevant for UFFDIO_COPY and it
> > never happens for other UFFDIO_ operations, make it a part of
> > mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for
> > anonymous memory.
> > 
> > shmem implementation will be updated later and the loop in
> > mfill_atomic() will be adjusted afterwards.
> 
> Thanks for the refactoring.  Looks good to me in general, only some
> nitpicks inline.
> 
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/userfaultfd.c | 70 +++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 46 insertions(+), 24 deletions(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 45d8f04aaf4f..01a2b898fa40 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -404,35 +404,57 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> >  	return ret;
> >  }
> >  
> > +static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
> > +{
> > +	unsigned long src_addr = state->src_addr;
> > +	void *kaddr;
> > +	int err;
> > +
> > +	/* retry copying with mm_lock dropped */
> > +	mfill_put_vma(state);
> > +
> > +	kaddr = kmap_local_folio(folio, 0);
> > +	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
> > +	kunmap_local(kaddr);
> > +	if (unlikely(err))
> > +		return -EFAULT;
> > +
> > +	flush_dcache_folio(folio);
> > +
> > +	/* reget VMA and PMD, they could change underneath us */
> > +	err = mfill_get_vma(state);
> > +	if (err)
> > +		return err;
> > +
> > +	err = mfill_get_pmd(state);
> > +	if (err)
> > +		return err;
> > +
> > +	return 0;
> > +}
> > +
> >  static int mfill_atomic_pte_copy(struct mfill_state *state)
> >  {
> > -	struct vm_area_struct *dst_vma = state->vma;
> >  	unsigned long dst_addr = state->dst_addr;
> >  	unsigned long src_addr = state->src_addr;
> >  	uffd_flags_t flags = state->flags;
> > -	pmd_t *dst_pmd = state->pmd;
> >  	struct folio *folio;
> >  	int ret;
> >  
> > -	if (!state->folio) {
> > -		ret = -ENOMEM;
> > -		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
> > -					dst_addr);
> > -		if (!folio)
> > -			goto out;
> > +	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
> > +	if (!folio)
> > +		return -ENOMEM;
> >  
> > -		ret = mfill_copy_folio_locked(folio, src_addr);
> > +	ret = -ENOMEM;
> > +	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
> > +		goto out_release;
> >  
> > +	ret = mfill_copy_folio_locked(folio, src_addr);
> > +	if (unlikely(ret)) {
> >  		/* fallback to copy_from_user outside mmap_lock */
> > -		if (unlikely(ret)) {
> > -			ret = -ENOENT;
> > -			state->folio = folio;
> > -			/* don't free the page */
> > -			goto out;
> > -		}
> > -	} else {
> > -		folio = state->folio;
> > -		state->folio = NULL;
> > +		ret = mfill_copy_folio_retry(state, folio);
> 
> Yes, I agree this should work and should avoid the previous ENOENT
> processing that might be hard to follow.  It'll move the complexity into
> mfill_state though (e.g., now it's unknown on the vma lock state after this
> function returns..), but I guess it's fine.

When this function returns success VMA is locked. If the function fails it
does not matter if the VMA is locked.
I'll add some comments.
 
> > +		if (ret)
> > +			goto out_release;
> >  	}
> >  
> >  	/*
> > @@ -442,17 +464,16 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
> >  	 */
> >  	__folio_mark_uptodate(folio);
> 
> Since success path should make sure vma lock held when reaching here, but
> now with mfill_copy_folio_retry()'s presence it's not as clear as before,
> maybe we add an assertion for that here before installing ptes?  No strong
> feelings.

I'll add comments.
 
> >  
> > -	ret = -ENOMEM;
> > -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> > -		goto out_release;
> > -
> > -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> > +	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
> >  				       &folio->page, true, flags);
> >  	if (ret)
> >  		goto out_release;
> >  out:
> >  	return ret;
> >  out_release:
> > +	/* Don't return -ENOENT so that our caller won't retry */
> > +	if (ret == -ENOENT)
> > +		ret = -EFAULT;
> 
> I recall the code removed is the only path that can return ENOENT?  Then
> maybe this line isn't needed?

I didn't want to audit all potential errors and this is a temporal safety
measure to avoid breaking biscection. This is anyway removed in the
following patches.
 
> >  	folio_put(folio);
> >  	goto out;
> >  }
> > @@ -907,7 +928,8 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> >  			break;
> >  	}
> >  
> > -	mfill_put_vma(&state);
> > +	if (state.vma)
> 
> I wonder if we should move this check into mfill_put_vma() directly, it
> might be overlooked if we'll put_vma in other paths otherwise.

Yeah, I'll check this.

-- 
Sincerely yours,
Mike.

