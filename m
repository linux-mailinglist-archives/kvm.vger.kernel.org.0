Return-Path: <kvm+bounces-70552-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YN5nBBBniGnepAQAu9opvQ
	(envelope-from <kvm+bounces-70552-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 11:36:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80956108608
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 11:35:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 82D4E300C803
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 10:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0880346A07;
	Sun,  8 Feb 2026 10:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHI2emSy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D659020DE3;
	Sun,  8 Feb 2026 10:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770546954; cv=none; b=a+8oEagyQGz24LmdHbdM5nqTTwbYPcUQI6fmA7dfR6mwSz61qRPZE0lum9f1LGZj/mXH+PWpHjbrZFNDy3JBRTRGlvQgvvdJUvs63rrgZjfq0fCjbInx0wqa8wIwRxSPGiprOmcbnADLybEwvtcB9+Qp+IOE99XCOy9EB9Y9ndk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770546954; c=relaxed/simple;
	bh=NCs3O9G0c7KmfcC7DUEEfBaavqJKwtKWSCCSSJCxCXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNqCfXU1f9yHBy3xsiASkpk/XRBOBmtPc+/PiAv9OxcU5rY8g6/ldkpHby8YqSXUZ+djQhATAc+zYqpV80uostpQGAZSl9Zr+Sb3OdKCHE3Xhm59tEtsyy7bY2KxgYq70Q4f0MsX/rfv9WdQgAhmHT+dAUNSn1hAHahehRhptIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHI2emSy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44937C4CEF7;
	Sun,  8 Feb 2026 10:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770546954;
	bh=NCs3O9G0c7KmfcC7DUEEfBaavqJKwtKWSCCSSJCxCXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DHI2emSyf/h9KNTv2IQa99c6pbUNy9Y3CyumFJhfQM9X9sNJK2YKz96xu4+MvoShI
	 chp7QJ63k+b7JYA5WIljxUYJ1tO9iCEPCP4fW3j4FC7/5mrQnZvqltsS2DOdYrxwMU
	 o9leLokeK6IE5wXm8Hi30/fuUWxWLyiUokHEL+NA7GVobITxA1AMqAFGOFAoNR2Azp
	 Ac0vKsyJ+LvNPFNJOWsWwWkdq5Y0XswOIHqlARomtxWu1vODPKYBYCyiLmnNZmEeGm
	 2MqT4sQDHyGPGQ2ZD9UlJ1/V+LqIPtVvLHnboQUcjkAhbWf0SBrwqAGjF+L/1h6ABA
	 bCW+eewRE9VIA==
Date: Sun, 8 Feb 2026 12:35:43 +0200
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
Subject: Re: [PATCH RFC 10/17] shmem, userfaultfd: implement shmem uffd
 operations using vm_uffd_ops
Message-ID: <aYhm_4difwN5XXxe@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-11-rppt@kernel.org>
 <aYIzCuh8cjd09zrP@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYIzCuh8cjd09zrP@x1.local>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70552-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 80956108608
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 12:40:26PM -0500, Peter Xu wrote:
> On Tue, Jan 27, 2026 at 09:29:29PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Add filemap_add() and filemap_remove() methods to vm_uffd_ops and use
> > them in __mfill_atomic_pte() to add shmem folios to page cache and
> > remove them in case of error.
> > 
> > Implement these methods in shmem along with vm_uffd_ops->alloc_folio()
> > and drop shmem_mfill_atomic_pte().
> > 
> > Since userfaultfd now does not reference any functions from shmem, drop
> > include if linux/shmem_fs.h from mm/userfaultfd.c
> > 
> > mfill_atomic_install_pte() is not used anywhere outside of
> > mm/userfaultfd, make it static.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> This patch looks like a real nice cleanup on its own, thanks Mike!
> 
> I guess I never tried to read into shmem accountings, now after I read some
> of the codes I don't see any issue with your change.  We can also wait for
> some shmem developers double check those.  Comments inline below on
> something I spot.
> 
> > 
> > fixup
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> [unexpected lines can be removed here]

Sure :)
 
> > ---
> >  include/linux/shmem_fs.h      |  14 ----
> >  include/linux/userfaultfd_k.h |  20 +++--
> >  mm/shmem.c                    | 148 ++++++++++++----------------------
> >  mm/userfaultfd.c              |  79 +++++++++---------
> >  4 files changed, 106 insertions(+), 155 deletions(-)
> > 
> > diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> > index e2069b3179c4..754f17e5b53c 100644
> > --- a/include/linux/shmem_fs.h
> > +++ b/include/linux/shmem_fs.h
> > @@ -97,6 +97,21 @@ struct vm_uffd_ops {
> >  	 */
> >  	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
> >  				     unsigned long addr);
> > +	/*
> > +	 * Called during resolution of UFFDIO_COPY request.
> > +	 * Should lock the folio and add it to VMA's page cache.
> > +	 * Returns 0 on success, error code on failre.
> 
> failure

Thanks, will fix.
 
> > +	 */
> > +	int (*filemap_add)(struct folio *folio, struct vm_area_struct *vma,
> > +			 unsigned long addr);
> > +	/*
> > +	 * Called during resolution of UFFDIO_COPY request on the error
> > +	 * handling path.
> > +	 * Should revert the operation of ->filemap_add().
> > +	 * The folio should be unlocked, but the reference to it should not be
> > +	 * dropped.
> 
> Might be slightly misleading to explicitly mention this?  As page cache
> also holds references and IIUC they need to be dropped there.  But I get
> your point, on keeping the last refcount due to allocation.
> 
> IMHO the "should revert the operation of ->filemap_add()" is good enough
> and accurately describes it.

Yeah, sounds good.
 
> > +	 */
> > +	void (*filemap_remove)(struct folio *folio, struct vm_area_struct *vma);
> >  };
> >  
> >  /* A combined operation mode + behavior flags. */

...

> > +static int shmem_mfill_filemap_add(struct folio *folio,
> > +				   struct vm_area_struct *vma,
> > +				   unsigned long addr)
> > +{
> > +	struct inode *inode = file_inode(vma->vm_file);
> > +	struct address_space *mapping = inode->i_mapping;
> > +	pgoff_t pgoff = linear_page_index(vma, addr);
> > +	gfp_t gfp = mapping_gfp_mask(mapping);
> > +	int err;
> > +
> >  	__folio_set_locked(folio);
> >  	__folio_set_swapbacked(folio);
> > -	__folio_mark_uptodate(folio);
> > -
> > -	ret = -EFAULT;
> > -	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
> > -	if (unlikely(pgoff >= max_off))
> > -		goto out_release;
> >  
> > -	ret = mem_cgroup_charge(folio, dst_vma->vm_mm, gfp);
> > -	if (ret)
> > -		goto out_release;
> > -	ret = shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp);
> > -	if (ret)
> > -		goto out_release;
> > +	err = shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp);
> > +	if (err)
> > +		goto err_unlock;
> >  
> > -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> > -				       &folio->page, true, flags);
> > -	if (ret)
> > -		goto out_delete_from_cache;
> > +	if (shmem_inode_acct_blocks(inode, 1)) {
> 
> We used to do this early before allocation, IOW, I think we still have an
> option to leave this to alloc_folio() hook.  However I don't see an issue
> either keeping it in filemap_add(). Maybe this movement should better be
> spelled out in the commit message anyway on how this decision is made.
> 
> IIUC it's indeed safe we move this acct_blocks() here, I even see Hugh
> mentioned such in an older commit 3022fd7af96, but Hugh left uffd alone at
> that time:
> 
>     Userfaultfd is a foreign country: they do things differently there, and
>     for good reason - to avoid mmap_lock deadlock.  Leave ordering in
>     shmem_mfill_atomic_pte() untouched for now, but I would rather like to
>     mesh it better with shmem_get_folio_gfp() in the future.
> 
> I'm not sure if that's also what you wanted to do - to make userfaultfd
> code work similarly like what shmem_alloc_and_add_folio() does right now.
> Maybe you want to mention that too somewhere in the commit log when posting
> a formal patch.
> 
> One thing not directly relevant is, shmem_alloc_and_add_folio() also does
> proper recalc of inode allocation info when acct_blocks() fails here.  But
> if that's a problem, that's pre-existing for userfaultfd, so IIUC we can
> also leave it alone until someone (maybe quota user) complains about shmem
> allocation failures on UFFDIO_COPY.. It's just that it looks similar
> problem here in userfaultfd path.

I actually wanted to have ordering as close as possible to
shmem_alloc_and_add_folio(), that's the first reason on moving acct_blocks
to ->filemap_add().
Another reason, is that it simplifies rollback in case of a failure, as
shmem_recalc_inode(inode, 0, 0); in ->filemap_remove() takes care of the
block accounting as well.

> > +		err = -ENOMEM;
> > +		goto err_delete_from_cache;
> > +	}
> >  
> > +	folio_add_lru(folio);
> 
> This change is pretty separate from the work, but looks correct to me: IIUC
> we moved the lru add earlier now, and it should be safe as long as we're
> holding folio lock all through the process, and folio_put() (ultimately,
> __page_cache_release()) will always properly undo the lru change.  Please
> help double check if my understanding is correct.

This follows shmem_alloc_and_add_folio(), and my understanding as well that
this is safe as long as we hold folio lock.

> > +static void shmem_mfill_filemap_remove(struct folio *folio,
> > +				       struct vm_area_struct *vma)
> > +{
> > +	struct inode *inode = file_inode(vma->vm_file);
> > +
> > +	filemap_remove_folio(folio);
> > +	shmem_recalc_inode(inode, 0, 0);
> >  	folio_unlock(folio);
> > -	folio_put(folio);
> > -out_unacct_blocks:
> > -	shmem_inode_unacct_blocks(inode, 1);
> 
> This looks wrong, or maybe I miss somewhere we did the unacct_blocks()?

This is handled by shmem_recalc_inode(inode, 0, 0).
 
> > @@ -401,6 +397,9 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
> >  
> >  	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
> >  
> > +	if (page_in_cache)
> > +		folio_unlock(folio);
> 
> Nitpick: another small change that looks correct, but IMHO would be nice to
> either make it a small separate patch, or mention in the commit message.

I'll address this in the commit log, 
 
> > +
> >  	/* No need to invalidate - it was non-present before */
> >  	update_mmu_cache(dst_vma, dst_addr, dst_pte);
> >  	ret = 0;

-- 
Sincerely yours,
Mike.

