Return-Path: <kvm+bounces-70547-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAayCUJciGlKowQAu9opvQ
	(envelope-from <kvm+bounces-70547-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 10:49:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD6F108450
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 10:49:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A31093015708
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 09:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E4B34677A;
	Sun,  8 Feb 2026 09:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hz7CIBWk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA310487BE;
	Sun,  8 Feb 2026 09:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770544178; cv=none; b=RY2HdYKEFo8BFOLVgRBj0Ssv6ibPCUTQBemkDOJRrcyIcETgyakpvibP42JZK3vCy4lpqu1oIjvj7Wuwp9gho76f9Qw99b392s6T0lddC7F5F1lvPZlWWsrBADs2+WWoV768GvtHPTRJfJ1vnv8YenyY8ujOXfon5xVQ0tdUCHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770544178; c=relaxed/simple;
	bh=dad1qQG14Id6LY4XasdkZA/u/K3SW5eX6EZX2zBf4BM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h4bAAJVvfaH5hCqiaWrzBgVe1UbW6ouJcy1wtO3wu/JlUWYX/7GszRhXnculg34gvq5GBB6FaII5DZ/rEkietZcdxiyS6SPvzfT8jEP+BMD6ndggZyEZeDvvSoMdNMHbi6XCukbXkvl6zd6ZCehkBc9NmwTdcSytND7aiXHUc1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hz7CIBWk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649B7C4CEF7;
	Sun,  8 Feb 2026 09:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770544178;
	bh=dad1qQG14Id6LY4XasdkZA/u/K3SW5eX6EZX2zBf4BM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hz7CIBWk+BanWnWsjwmGQuuBnJ6GS1FGyOLDJGQ6voZfjDwkbQPPVzj7mof+SYYku
	 aZJZQWvuySWH9WBmsc5GVAry8qs4nFCtuWtttSVxzxoPDgpwjzYgg+xobfkrpqARR6
	 yhmN2j6+GacCPdoL8CnXX3l/J6OuHmbMtnDHR0LDesuHToOppkkaIoyoTTGoLA6SHw
	 Se/YmgMtvCoJHuiNd3WkaRPy5yyoNdl18MPxXLjXnjaiDLgepDWeYkwJmR5Bf5gNzk
	 6feyIqqMfoHSexciIygXgmQrXIAonUw05Nko9juey1Bh8uOoF6h/C1tlSGlXY+lFpb
	 wevcUFtyXv0Bw==
Date: Sun, 8 Feb 2026 11:49:27 +0200
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
Subject: Re: [PATCH RFC 01/17] userfaultfd: introduce
 mfill_copy_folio_locked() helper
Message-ID: <aYhcJy86AYesUSEe@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-2-rppt@kernel.org>
 <aYI0HmP-XZNBI-gb@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYI0HmP-XZNBI-gb@x1.local>
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
	TAGGED_FROM(0.00)[bounces-70547-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 9BD6F108450
X-Rspamd-Action: no action

Hi Peter,

On Tue, Feb 03, 2026 at 12:45:02PM -0500, Peter Xu wrote:
> On Tue, Jan 27, 2026 at 09:29:20PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Split copying of data when locks held from mfill_atomic_pte_copy() into
> > a helper function mfill_copy_folio_locked().
> > 
> > This makes improves code readability and makes complex
> > mfill_atomic_pte_copy() function easier to comprehend.
> > 
> > No functional change.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> The movement looks all fine,
> 
> Acked-by: Peter Xu <peterx@redhat.com>

Thanks!
 
> Just one pure question to ask.
> 
> > ---
> >  mm/userfaultfd.c | 59 ++++++++++++++++++++++++++++--------------------
> >  1 file changed, 35 insertions(+), 24 deletions(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index e6dfd5f28acd..a0885d543f22 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -238,6 +238,40 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
> >  	return ret;
> >  }
> >  
> > +static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> > +{
> > +	void *kaddr;
> > +	int ret;
> > +
> > +	kaddr = kmap_local_folio(folio, 0);
> > +	/*
> > +	 * The read mmap_lock is held here.  Despite the
> > +	 * mmap_lock being read recursive a deadlock is still
> > +	 * possible if a writer has taken a lock.  For example:
> > +	 *
> > +	 * process A thread 1 takes read lock on own mmap_lock
> > +	 * process A thread 2 calls mmap, blocks taking write lock
> > +	 * process B thread 1 takes page fault, read lock on own mmap lock
> > +	 * process B thread 2 calls mmap, blocks taking write lock
> > +	 * process A thread 1 blocks taking read lock on process B
> > +	 * process B thread 1 blocks taking read lock on process A
> 
> While moving, I wonder if we need this complex use case to describe the
> deadlock.  Shouldn't this already happen with 1 process only?
> 
>   process A thread 1 takes read lock (e.g. reaching here but
>                      before copy_from_user)
>   process A thread 2 calls mmap, blocks taking write lock
>   process A thread 1 goes on copy_from_user(), trigger page fault,
>                      then tries to re-take the read lock
> 
> IIUC above should already cause deadlock when rwsem prioritize the write
> lock here.

We surely can improve the description here, but it should be a separate
patch with its own changelog and it's out of scope of this series.
 
> > +	 *
> > +	 * Disable page faults to prevent potential deadlock
> > +	 * and retry the copy outside the mmap_lock.
> > +	 */
> > +	pagefault_disable();
> > +	ret = copy_from_user(kaddr, (const void __user *) src_addr,
> > +			     PAGE_SIZE);
> > +	pagefault_enable();
> > +	kunmap_local(kaddr);

-- 
Sincerely yours,
Mike.

