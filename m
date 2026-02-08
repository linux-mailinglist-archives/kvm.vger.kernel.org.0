Return-Path: <kvm+bounces-70551-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +HzSNRhkiGmnpAQAu9opvQ
	(envelope-from <kvm+bounces-70551-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 11:23:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3503C108598
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 11:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7DEA63008D31
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 10:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2907F346795;
	Sun,  8 Feb 2026 10:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFIlpYuV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDA930E826;
	Sun,  8 Feb 2026 10:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770546183; cv=none; b=Z3HyQF37LWS39eUprBcK8ykUqaLjzEvLsoQgOIOKVsi1yqABmOpctEoYkD78Nij6e0b+bGVs/aObO1+9EDx+/8pbo//6aIXO/cmo6Xkz+p4cBjg5OaWYbn2PUhMDatDy4aLDeB5vS7qdPa3NZKmJtVFSuHW8bpMs0SQaJ314qyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770546183; c=relaxed/simple;
	bh=X40rdyS6Y6fl2CRiDiW77eJoxxt8y+6p1hMAAnDEfLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l01qUAoWgHRypOicbzDt2E6xBKJCrhs9n9RBZ2budvhefXKf2bUwJxVHd6AufHHPYHoypRBjZ/GydB9sSQ2S352uCUsT00V2xie9Zu8JSce6GCFPGZsEsr6R7Ru0ZurqtDnuJyqMQwP9nu1ZgcrSNkZUzno1rcQ2AcYoCe4TWfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFIlpYuV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001AFC4CEF7;
	Sun,  8 Feb 2026 10:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770546183;
	bh=X40rdyS6Y6fl2CRiDiW77eJoxxt8y+6p1hMAAnDEfLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hFIlpYuV5D2Emx0Q2sDypBVW+AhWi8fSuO40+NXrjL28KqRmx6A6QX5FXeeOTE2lp
	 6vMssip5iI0KL66gFswfQfau4ZitOqeDjeJPa5ij89+dq4dttWgDU68XSnzlha4G9f
	 LTAWMWKeN1Z54We7+CPufJwweWX/BWwB+W/BOGIgIDkmowaq+fRqHccfv5EgbnMUUr
	 IEeSng43gd7rVXZgTs/6sXTfjTo0xIdTvGOXB2DRzi2krxzvdH8dqRYbYcOmrYKZu0
	 JiSwbNAXpr6U01oLDpnksOIAJDuhD6t0mXS6fR4uz+MuX72J1xltL3Z2pLZXcGmATE
	 /Uj7w4dxYwc2w==
Date: Sun, 8 Feb 2026 12:22:52 +0200
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
Subject: Re: [PATCH RFC 09/17] userfaultfd: introduce
 vm_uffd_ops->alloc_folio()
Message-ID: <aYhj_H2X141wU3oF@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-10-rppt@kernel.org>
 <aYEhgA1dY0biVYb8@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYEhgA1dY0biVYb8@x1.local>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70551-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
X-Rspamd-Queue-Id: 3503C108598
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 05:13:20PM -0500, Peter Xu wrote:
> On Tue, Jan 27, 2026 at 09:29:28PM +0200, Mike Rapoport wrote:
> 
> [...]
> 
> > -static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
> > -					 struct vm_area_struct *dst_vma,
> > -					 unsigned long dst_addr)
> > +static int mfill_atomic_pte_copy(struct mfill_state *state)
> >  {
> > -	struct folio *folio;
> > -	int ret = -ENOMEM;
> > -
> > -	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
> > -	if (!folio)
> > -		return ret;
> > -
> > -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> > -		goto out_put;
> > +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> >  
> > -	/*
> > -	 * The memory barrier inside __folio_mark_uptodate makes sure that
> > -	 * zeroing out the folio become visible before mapping the page
> > -	 * using set_pte_at(). See do_anonymous_page().
> > -	 */
> > -	__folio_mark_uptodate(folio);
> > +	return __mfill_atomic_pte(state, ops);
> > +}
> >  
> > -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> > -				       &folio->page, true, 0);
> > -	if (ret)
> > -		goto out_put;
> > +static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
> > +{
> > +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> >  
> > -	return 0;
> > -out_put:
> > -	folio_put(folio);
> > -	return ret;
> > +	return __mfill_atomic_pte(state, ops);
> >  }
> >  
> >  static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> > @@ -542,7 +546,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> >  	int ret;
> >  
> >  	if (mm_forbids_zeropage(dst_vma->vm_mm))
> > -		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
> > +		return mfill_atomic_pte_zeroed_folio(state);
> 
> After this patch, mfill_atomic_pte_zeroed_folio() should be 100% the same
> impl with mfill_atomic_pte_copy(), so IIUC we can drop it.

It will be slightly different after the next patch to emphasize that
copying into MAP_PRIVATE actually creates anonymous memory.
 
> >  	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
> >  					 dst_vma->vm_page_prot));
> > -- 
> > 2.51.0
> > 
> 
> -- 
> Peter Xu
> 

-- 
Sincerely yours,
Mike.

