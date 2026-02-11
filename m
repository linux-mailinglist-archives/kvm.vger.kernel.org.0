Return-Path: <kvm+bounces-70825-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BSvG/IbjGnEgwAAu9opvQ
	(envelope-from <kvm+bounces-70825-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 07:04:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F07C21218CD
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 07:04:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F08BC305F222
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 06:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEC63451BD;
	Wed, 11 Feb 2026 06:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xu5Mobm0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD771373;
	Wed, 11 Feb 2026 06:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770789861; cv=none; b=CUotEKFLWO+tJxcB9rmTUKaZSDLv/RRKEvA5yPhCDdRjcvOEHnxKJ6IFeNyoHlqFN+g/zw5ZlqOhJw21T6roHPWWdcrvb3qoHJWRUKPbqQox8lmevPubA+ftC/0w+0aiVJHc5KzNqHCGWMSSa0bhTyt83z7VOPhh1voTQRyuzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770789861; c=relaxed/simple;
	bh=1ba4HtqH6wJILWm4/0xJUBvvlpODk4MGkINVKN5zbxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJ/P/iMkhtcUDH3TN0mci1qiVStGOFwmOkwsyuSj8+hutK4MxMa3uqKreRuWBqSZ54fNc/hqrHZsS4NwjBMWauDf1uUCd8g4SbtffCf66a/r5CIbiACKZXpyWwdg3298cdOViGQ0zGstn4VuAlZSAxiT9MAg+VOSWuPFNi67pdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xu5Mobm0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB967C4CEF7;
	Wed, 11 Feb 2026 06:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770789860;
	bh=1ba4HtqH6wJILWm4/0xJUBvvlpODk4MGkINVKN5zbxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xu5Mobm0F8wyhieAmIGzh63x8lptqVNcvo43aLWfKj6Tzv+Zl/kKchoY9ZdsHpeY9
	 7VY7AX4De2TIfQU33FMKPr6fbkei4k9WsONs2oo7VhZtr3CQp7M+FrWIMR0CcEV2Bw
	 idpILaIQ8PtxB+tqtiZhDkYCY0OamXU/ZQC6DQvOWE0CgBDJ4sBAW/xcziwr/oevAp
	 ATuo35V/KFJp1kLKUH/ym/DEQd7QymS16+vW/OsOhdX9h0EfVKeWyVrw07I45sDb7d
	 0FXA6azSR3Rqcixdu+T53iaoPlH+4auPPf+s5B2tud/yLWQPikgXkLOxXx/3AwixPf
	 Fpqc4cdK//yzQ==
Date: Wed, 11 Feb 2026 08:04:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
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
Subject: Re: [PATCH RFC 00/17] mm, kvm: allow uffd suppot in guest_memfd
Message-ID: <aYwb2XgRiFayzBXS@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <aYJg5lT9MG0BQFkG@x1.local>
 <0032ac8b-06ba-4f4b-ad66-f0195eea1c15@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0032ac8b-06ba-4f4b-ad66-f0195eea1c15@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70825-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rppt@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F07C21218CD
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 04:35:47PM +0100, David Hildenbrand (Arm) wrote:
> On 2/3/26 21:56, Peter Xu wrote:
>
> > +static vm_fault_t fault_process_userfaultfd(struct vm_fault *vmf)
> > +{
> > +	struct vm_area_struct *vma = vmf->vma;
> > +	struct inode *inode = file_inode(vma->vm_file);
> > +	/*
> > +	 * NOTE: we could double check this hook present when
> > +	 * UFFDIO_REGISTER on MISSING or MINOR for a file driver.
> > +	 */
> > +	struct folio *folio =
> > +	    vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pgoff);
> > +
> > +	if (!IS_ERR_OR_NULL(folio)) {
> > +		/*
> > +		 * TODO: provide a flag for get_folio_noalloc() to avoid
> > +		 * locking (or even the extra reference?)
> > +		 */
> > +		folio_unlock(folio);
> > +		folio_put(folio);
> > +		if (userfaultfd_minor(vma))
> > +			return handle_userfault(vmf, VM_UFFD_MINOR);
> > +	} else {
> > +		return handle_userfault(vmf, VM_UFFD_MISSING);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >   /*
> >    * The mmap_lock must have been held on entry, and may have been
> >    * released depending on flags and vma->vm_ops->fault() return value.
> > @@ -5370,16 +5397,20 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
> >   			return VM_FAULT_OOM;
> >   	}
> > +	/*
> > +	 * If this is an userfaultfd trap, process it in advance before
> > +	 * triggering the genuine fault handler.
> > +	 */
> > +	if (userfaultfd_missing(vma) || userfaultfd_minor(vma)) {
> > +		ret = fault_process_userfaultfd(vmf);
> > +		if (ret)
> > +			return ret;
> > +	}

I agree this is neater than handling VM_FAULT_UFFD.
I'd just move the checks for userfaultfd_minor() and userfaultfd_missing()
inside fault_process_userfaultfd().

> > +
> >   	ret = vma->vm_ops->fault(vmf);
> >   	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
> > -			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR |
> > -			    VM_FAULT_UFFD_MISSING))) {
> > -		if (ret & VM_FAULT_UFFD_MINOR)
> > -			return handle_userfault(vmf, VM_UFFD_MINOR);
> > -		if (ret & VM_FAULT_UFFD_MISSING)
> > -			return handle_userfault(vmf, VM_UFFD_MISSING);
> > +			    VM_FAULT_DONE_COW)))
> >   		return ret;
> > -	}
> >   	folio = page_folio(vmf->page);
> >   	if (unlikely(PageHWPoison(vmf->page))) {
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index eafd7986fc2ec..5286f28b3e443 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2484,13 +2484,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> >   	fault_mm = vma ? vma->vm_mm : NULL;
> >   	folio = filemap_get_entry(inode->i_mapping, index);
> > -	if (folio && vma && userfaultfd_minor(vma)) {
> > -		if (!xa_is_value(folio))
> > -			folio_put(folio);
> > -		*fault_type = VM_FAULT_UFFD_MINOR;
> > -		return 0;
> > -	}
> > -
> >   	if (xa_is_value(folio)) {
> >   		error = shmem_swapin_folio(inode, index, &folio,
> >   					   sgp, gfp, vma, fault_type);
> > @@ -2535,11 +2528,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> >   	 * Fast cache lookup and swap lookup did not find it: allocate.
> >   	 */
> > -	if (vma && userfaultfd_missing(vma)) {
> > -		*fault_type = VM_FAULT_UFFD_MISSING;
> > -		return 0;
> > -	}
> > -
> >   	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
> >   	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
> >   	if (orders > 0) {
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 14cca057fc0ec..bd0de685f42f8 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -421,26 +421,6 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> >   	folio = __filemap_get_folio(inode->i_mapping, vmf->pgoff,
> >   				    FGP_LOCK | FGP_ACCESSED, 0);
> > -	if (userfaultfd_armed(vmf->vma)) {
> > -		/*
> > -		 * If userfaultfd is registered in minor mode and a folio
> > -		 * exists, return VM_FAULT_UFFD_MINOR to trigger the
> > -		 * userfaultfd handler.
> > -		 */
> > -		if (userfaultfd_minor(vmf->vma) && !IS_ERR_OR_NULL(folio)) {
> > -			ret = VM_FAULT_UFFD_MINOR;
> > -			goto out_folio;
> > -		}
> > -
> > -		/*
> > -		 * Check if userfaultfd is registered in missing mode. If so,
> > -		 * check if a folio exists in the page cache. If not, return
> > -		 * VM_FAULT_UFFD_MISSING to trigger the userfaultfd handler.
> > -		 */
> > -		if (userfaultfd_missing(vmf->vma) && IS_ERR_OR_NULL(folio))
> > -			return VM_FAULT_UFFD_MISSING;
> > -	}
> > -
> >   	/* folio not in the pagecache, try to allocate */
> >   	if (IS_ERR(folio))
> >   		folio = __kvm_gmem_folio_alloc(inode, vmf->pgoff);
> 
> That looks better in general. We should likely find a better/more consistent
> name for fault_process_userfaultfd().

__do_userfault()? :)
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

