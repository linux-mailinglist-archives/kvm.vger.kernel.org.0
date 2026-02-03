Return-Path: <kvm+bounces-70027-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JAfBuozgmlsQgMAu9opvQ
	(envelope-from <kvm+bounces-70027-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 18:44:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6836FDD00D
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 18:44:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 142DA310D0D3
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 17:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2147F36165E;
	Tue,  3 Feb 2026 17:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YU1ha99e";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OTQ4N8Vh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D9534D3B2
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770140436; cv=none; b=ieZl/kfzZ3PyjBybU/LbQa1EAjaB+1Tc/vTbPvmeJtymIS01Ld0yG7xEVduZXJm3EVGt9jtT97GXHH5mPLbxqbh8qvJbFO9M/v1Mhwu/0qjjcENXmapKIj4RfPd/0GAPZOMfRcK/rGOU3W2Yugci/qAfqasOfW7te5IvwxwFSs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770140436; c=relaxed/simple;
	bh=nPQ04KCgPzRBUY6zc9JevtSOo4Ne8+iCg79jSSWnDMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tB7AXkkUSxal0PkLneGbDHuB61FfznXHoRJU4tvCXnYAvABzvhR3EYckQ6qXOmD75FQx6QTPMx7jpv7G5PHQpD/jrSTB69MypXAWPuNQLqNxnOuTGY8qlrWlHqJsEgxdq9ml2FNoX3HqBmc3xPKynyHnovMcxomLRAM3jSi/Rr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YU1ha99e; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OTQ4N8Vh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770140432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nmSl7/1tMINHvaZwWji7tBNR9y3eOnNMtJc0andbC/g=;
	b=YU1ha99eXA0xt0f1i3tOWVLWRxM5Nvf74Jdp5xGyfP7i8iyAuVFZPv4jmP5aBC7+ga2h6I
	Oe+H59C2/NKn6M5z+NAKR7fVDj5CtM0G2wqL3qD7FfLGfMXeIWMqQrtmB4/CuzIT2gVPke
	iUGccXqW6b9OMMF3SZzLpRN3FnJISfU=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-t1ziGSgiPtG6mOx-aKv_PQ-1; Tue, 03 Feb 2026 12:40:31 -0500
X-MC-Unique: t1ziGSgiPtG6mOx-aKv_PQ-1
X-Mimecast-MFC-AGG-ID: t1ziGSgiPtG6mOx-aKv_PQ_1770140430
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8c1cffa1f2dso12122585a.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 09:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770140430; x=1770745230; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nmSl7/1tMINHvaZwWji7tBNR9y3eOnNMtJc0andbC/g=;
        b=OTQ4N8VhFRpPexKMarR/TJNLWyi2E6Gi1ktSFoo4NXqTmCP2nJldqR7odDyHtoALVX
         18P5KCYVkNz00aa2796+zQ0rcHYfxOCWUA02So4I65gHjBaZa5V4JoGnnDvTl1ibaTZI
         1uhojB1Y2iVh4TC5HApEkhv2WtcZAt9DOOM8tXDmcDUrS4FS7xMfDb9M0iQPQVQkv7qq
         k2CZSv+9WqphgV9fxkwxytw0G2nD6eopZXZ+73xCAH1vEKszfnU3dFUqAIg/MnqmNKK/
         GxSpUlto/hN4lvFmIVriun0iMpeppBSaryl3TW4UMdLUCSc3I5fQIYBmZozIVp2FtWfe
         bnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770140430; x=1770745230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nmSl7/1tMINHvaZwWji7tBNR9y3eOnNMtJc0andbC/g=;
        b=eajaGjiXXJCSCKdiLuZyI73YeZoYXQYMFiUfbGWaLV7i5/ft8LCYOs8tgSNuHRr7Vp
         gU5WvN2/afdQNBHx6aiDxgWhFL/CPEGhsgPbitWVaTOcL01oCrC5bJTvEuUKeId+amwa
         Smrz4rEwME0y4dD9KlQ+jILXCQFF/U/v4Yjkv7jl61e2vHMJ5Mtgo59g2uikEP2fN4M0
         aal5p893ue6hS4+ViaV5xBAl7TTvWAMAxgE9cvneZJ1fSMaZ6KcGUu1YT6dWZpF0bscJ
         pvp0I57sNTXxds4HZdaeQsA+P4/b0XQVxMLP4RwsJtmgPvLzdSi76vMdRCQib22mJ66/
         AQFg==
X-Forwarded-Encrypted: i=1; AJvYcCUsotJ++6URim8mQlyri1Ief25vs7T3VVxBQf0IQuqlfg1nRiVXBueE46hozKPMqG3JSUs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1lLpI55lztv1feRUFPK4cRp4gCXj8sjy459Hh2JHckgkgFHxY
	HJk2RcqIk1xiL94dTtmI5D8+THvKHf91ku6n+b7WFjimvzfSng+/dL2wvzs4Xzhbc/gR3GLRoRt
	QBa7HoFS27aDf+mPYEC0g1xJHR/cTbHdpHwb364WElssNRE0hBz8Rzg==
X-Gm-Gg: AZuq6aIIUjw2KzRk+L9/RDMbi3dneyN6YG4TeKSGTWw2sIkHasmsDHzvpbrGXt9VfH2
	69FYU/GxjbcK5rVTFaxY7kCJcMi/1AqXBM9ckEFU38aVq22iQF+7598wduyxLCBxRpOuJlfbdex
	2Lx7Oc1GNEUD9NVVJ7OyD/Ng3tBCTUTFGdjW3SHsw1kLPbQK7MkFtseqz0w/quJcFGzAVlMCvQk
	y20jh/N/IiVHlJxUfWk3U+4gwWjWDEd3/vcY5rEs6ODqJvcfgflsWFqLqT33HFbtAliNVZbDXVA
	eMMOruGJyuo2xweO88LfqrvK8Xejh6kPK/KQGQv18F5TCXQd1uveyMqefdOUI++QK1UQ/bpA1DQ
	5ipw=
X-Received: by 2002:a05:620a:2910:b0:8c5:3045:854f with SMTP id af79cd13be357-8ca204ca94dmr428083385a.30.1770140430245;
        Tue, 03 Feb 2026 09:40:30 -0800 (PST)
X-Received: by 2002:a05:620a:2910:b0:8c5:3045:854f with SMTP id af79cd13be357-8ca204ca94dmr428079185a.30.1770140429666;
        Tue, 03 Feb 2026 09:40:29 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ca2fd56420sm16357985a.54.2026.02.03.09.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 09:40:29 -0800 (PST)
Date: Tue, 3 Feb 2026 12:40:26 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
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
Message-ID: <aYIzCuh8cjd09zrP@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-11-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127192936.1250096-11-rppt@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70027-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,x1.local:mid]
X-Rspamd-Queue-Id: 6836FDD00D
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 09:29:29PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Add filemap_add() and filemap_remove() methods to vm_uffd_ops and use
> them in __mfill_atomic_pte() to add shmem folios to page cache and
> remove them in case of error.
> 
> Implement these methods in shmem along with vm_uffd_ops->alloc_folio()
> and drop shmem_mfill_atomic_pte().
> 
> Since userfaultfd now does not reference any functions from shmem, drop
> include if linux/shmem_fs.h from mm/userfaultfd.c
> 
> mfill_atomic_install_pte() is not used anywhere outside of
> mm/userfaultfd, make it static.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

This patch looks like a real nice cleanup on its own, thanks Mike!

I guess I never tried to read into shmem accountings, now after I read some
of the codes I don't see any issue with your change.  We can also wait for
some shmem developers double check those.  Comments inline below on
something I spot.

> 
> fixup
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

[unexpected lines can be removed here]

> ---
>  include/linux/shmem_fs.h      |  14 ----
>  include/linux/userfaultfd_k.h |  20 +++--
>  mm/shmem.c                    | 148 ++++++++++++----------------------
>  mm/userfaultfd.c              |  79 +++++++++---------
>  4 files changed, 106 insertions(+), 155 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index e2069b3179c4..754f17e5b53c 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -223,20 +223,6 @@ static inline pgoff_t shmem_fallocend(struct inode *inode, pgoff_t eof)
>  
>  extern bool shmem_charge(struct inode *inode, long pages);
>  
> -#ifdef CONFIG_USERFAULTFD
> -#ifdef CONFIG_SHMEM
> -extern int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
> -				  struct vm_area_struct *dst_vma,
> -				  unsigned long dst_addr,
> -				  unsigned long src_addr,
> -				  uffd_flags_t flags,
> -				  struct folio **foliop);
> -#else /* !CONFIG_SHMEM */
> -#define shmem_mfill_atomic_pte(dst_pmd, dst_vma, dst_addr, \
> -			       src_addr, flags, foliop) ({ BUG(); 0; })
> -#endif /* CONFIG_SHMEM */
> -#endif /* CONFIG_USERFAULTFD */
> -
>  /*
>   * Used space is stored as unsigned 64-bit value in bytes but
>   * quota core supports only signed 64-bit values so use that
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 4d8b879eed91..75d5b09f2560 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -97,6 +97,21 @@ struct vm_uffd_ops {
>  	 */
>  	struct folio *(*alloc_folio)(struct vm_area_struct *vma,
>  				     unsigned long addr);
> +	/*
> +	 * Called during resolution of UFFDIO_COPY request.
> +	 * Should lock the folio and add it to VMA's page cache.
> +	 * Returns 0 on success, error code on failre.

failure

> +	 */
> +	int (*filemap_add)(struct folio *folio, struct vm_area_struct *vma,
> +			 unsigned long addr);
> +	/*
> +	 * Called during resolution of UFFDIO_COPY request on the error
> +	 * handling path.
> +	 * Should revert the operation of ->filemap_add().
> +	 * The folio should be unlocked, but the reference to it should not be
> +	 * dropped.

Might be slightly misleading to explicitly mention this?  As page cache
also holds references and IIUC they need to be dropped there.  But I get
your point, on keeping the last refcount due to allocation.

IMHO the "should revert the operation of ->filemap_add()" is good enough
and accurately describes it.

> +	 */
> +	void (*filemap_remove)(struct folio *folio, struct vm_area_struct *vma);
>  };
>  
>  /* A combined operation mode + behavior flags. */
> @@ -130,11 +145,6 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
>  /* Flags controlling behavior. These behavior changes are mode-independent. */
>  #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
>  
> -extern int mfill_atomic_install_pte(pmd_t *dst_pmd,
> -				    struct vm_area_struct *dst_vma,
> -				    unsigned long dst_addr, struct page *page,
> -				    bool newly_allocated, uffd_flags_t flags);
> -
>  extern ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  				 unsigned long src_start, unsigned long len,
>  				 uffd_flags_t flags);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 87cd8d2fdb97..6f0485f76cb8 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3169,118 +3169,73 @@ static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
>  #endif /* CONFIG_TMPFS_QUOTA */
>  
>  #ifdef CONFIG_USERFAULTFD
> -int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
> -			   struct vm_area_struct *dst_vma,
> -			   unsigned long dst_addr,
> -			   unsigned long src_addr,
> -			   uffd_flags_t flags,
> -			   struct folio **foliop)
> -{
> -	struct inode *inode = file_inode(dst_vma->vm_file);
> -	struct shmem_inode_info *info = SHMEM_I(inode);
> +static struct folio *shmem_mfill_folio_alloc(struct vm_area_struct *vma,
> +					     unsigned long addr)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
>  	struct address_space *mapping = inode->i_mapping;
> +	struct shmem_inode_info *info = SHMEM_I(inode);
> +	pgoff_t pgoff = linear_page_index(vma, addr);
>  	gfp_t gfp = mapping_gfp_mask(mapping);
> -	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
> -	void *page_kaddr;
>  	struct folio *folio;
> -	int ret;
> -	pgoff_t max_off;
> -
> -	if (shmem_inode_acct_blocks(inode, 1)) {
> -		/*
> -		 * We may have got a page, returned -ENOENT triggering a retry,
> -		 * and now we find ourselves with -ENOMEM. Release the page, to
> -		 * avoid a BUG_ON in our caller.
> -		 */
> -		if (unlikely(*foliop)) {
> -			folio_put(*foliop);
> -			*foliop = NULL;
> -		}
> -		return -ENOMEM;
> -	}
>  
> -	if (!*foliop) {
> -		ret = -ENOMEM;
> -		folio = shmem_alloc_folio(gfp, 0, info, pgoff);
> -		if (!folio)
> -			goto out_unacct_blocks;
> +	if (unlikely(pgoff >= DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE)))
> +		return NULL;
>  
> -		if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY)) {
> -			page_kaddr = kmap_local_folio(folio, 0);
> -			/*
> -			 * The read mmap_lock is held here.  Despite the
> -			 * mmap_lock being read recursive a deadlock is still
> -			 * possible if a writer has taken a lock.  For example:
> -			 *
> -			 * process A thread 1 takes read lock on own mmap_lock
> -			 * process A thread 2 calls mmap, blocks taking write lock
> -			 * process B thread 1 takes page fault, read lock on own mmap lock
> -			 * process B thread 2 calls mmap, blocks taking write lock
> -			 * process A thread 1 blocks taking read lock on process B
> -			 * process B thread 1 blocks taking read lock on process A
> -			 *
> -			 * Disable page faults to prevent potential deadlock
> -			 * and retry the copy outside the mmap_lock.
> -			 */
> -			pagefault_disable();
> -			ret = copy_from_user(page_kaddr,
> -					     (const void __user *)src_addr,
> -					     PAGE_SIZE);
> -			pagefault_enable();
> -			kunmap_local(page_kaddr);
> -
> -			/* fallback to copy_from_user outside mmap_lock */
> -			if (unlikely(ret)) {
> -				*foliop = folio;
> -				ret = -ENOENT;
> -				/* don't free the page */
> -				goto out_unacct_blocks;
> -			}
> +	folio = shmem_alloc_folio(gfp, 0, info, pgoff);
> +	if (!folio)
> +		return NULL;
>  
> -			flush_dcache_folio(folio);
> -		} else {		/* ZEROPAGE */
> -			clear_user_highpage(&folio->page, dst_addr);
> -		}
> -	} else {
> -		folio = *foliop;
> -		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
> -		*foliop = NULL;
> +	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL)) {
> +		folio_put(folio);
> +		return NULL;
>  	}
>  
> -	VM_BUG_ON(folio_test_locked(folio));
> -	VM_BUG_ON(folio_test_swapbacked(folio));
> +	return folio;
> +}
> +
> +static int shmem_mfill_filemap_add(struct folio *folio,
> +				   struct vm_area_struct *vma,
> +				   unsigned long addr)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +	struct address_space *mapping = inode->i_mapping;
> +	pgoff_t pgoff = linear_page_index(vma, addr);
> +	gfp_t gfp = mapping_gfp_mask(mapping);
> +	int err;
> +
>  	__folio_set_locked(folio);
>  	__folio_set_swapbacked(folio);
> -	__folio_mark_uptodate(folio);
> -
> -	ret = -EFAULT;
> -	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
> -	if (unlikely(pgoff >= max_off))
> -		goto out_release;
>  
> -	ret = mem_cgroup_charge(folio, dst_vma->vm_mm, gfp);
> -	if (ret)
> -		goto out_release;
> -	ret = shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp);
> -	if (ret)
> -		goto out_release;
> +	err = shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp);
> +	if (err)
> +		goto err_unlock;
>  
> -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> -				       &folio->page, true, flags);
> -	if (ret)
> -		goto out_delete_from_cache;
> +	if (shmem_inode_acct_blocks(inode, 1)) {

We used to do this early before allocation, IOW, I think we still have an
option to leave this to alloc_folio() hook.  However I don't see an issue
either keeping it in filemap_add(). Maybe this movement should better be
spelled out in the commit message anyway on how this decision is made.

IIUC it's indeed safe we move this acct_blocks() here, I even see Hugh
mentioned such in an older commit 3022fd7af96, but Hugh left uffd alone at
that time:

    Userfaultfd is a foreign country: they do things differently there, and
    for good reason - to avoid mmap_lock deadlock.  Leave ordering in
    shmem_mfill_atomic_pte() untouched for now, but I would rather like to
    mesh it better with shmem_get_folio_gfp() in the future.

I'm not sure if that's also what you wanted to do - to make userfaultfd
code work similarly like what shmem_alloc_and_add_folio() does right now.
Maybe you want to mention that too somewhere in the commit log when posting
a formal patch.

One thing not directly relevant is, shmem_alloc_and_add_folio() also does
proper recalc of inode allocation info when acct_blocks() fails here.  But
if that's a problem, that's pre-existing for userfaultfd, so IIUC we can
also leave it alone until someone (maybe quota user) complains about shmem
allocation failures on UFFDIO_COPY.. It's just that it looks similar
problem here in userfaultfd path.

> +		err = -ENOMEM;
> +		goto err_delete_from_cache;
> +	}
>  
> +	folio_add_lru(folio);

This change is pretty separate from the work, but looks correct to me: IIUC
we moved the lru add earlier now, and it should be safe as long as we're
holding folio lock all through the process, and folio_put() (ultimately,
__page_cache_release()) will always properly undo the lru change.  Please
help double check if my understanding is correct.

>  	shmem_recalc_inode(inode, 1, 0);
> -	folio_unlock(folio);
> +
>  	return 0;
> -out_delete_from_cache:
> +
> +err_delete_from_cache:
>  	filemap_remove_folio(folio);
> -out_release:
> +err_unlock:
> +	folio_unlock(folio);
> +	return err;
> +}
> +
> +static void shmem_mfill_filemap_remove(struct folio *folio,
> +				       struct vm_area_struct *vma)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +
> +	filemap_remove_folio(folio);
> +	shmem_recalc_inode(inode, 0, 0);
>  	folio_unlock(folio);
> -	folio_put(folio);
> -out_unacct_blocks:
> -	shmem_inode_unacct_blocks(inode, 1);

This looks wrong, or maybe I miss somewhere we did the unacct_blocks()?

> -	return ret;
>  }
>  #endif /* CONFIG_USERFAULTFD */
>  
> @@ -5317,6 +5272,9 @@ static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
>  static const struct vm_uffd_ops shmem_uffd_ops = {
>  	.can_userfault		= shmem_can_userfault,
>  	.get_folio_noalloc	= shmem_get_folio_noalloc,
> +	.alloc_folio		= shmem_mfill_folio_alloc,
> +	.filemap_add		= shmem_mfill_filemap_add,
> +	.filemap_remove		= shmem_mfill_filemap_remove,
>  };
>  #endif
>  
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index b3c12630769c..54aa195237ba 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -14,7 +14,6 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/hugetlb.h>
> -#include <linux/shmem_fs.h>
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -337,10 +336,10 @@ static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
>   * This function handles both MCOPY_ATOMIC_NORMAL and _CONTINUE for both shmem
>   * and anon, and for both shared and private VMAs.
>   */
> -int mfill_atomic_install_pte(pmd_t *dst_pmd,
> -			     struct vm_area_struct *dst_vma,
> -			     unsigned long dst_addr, struct page *page,
> -			     bool newly_allocated, uffd_flags_t flags)
> +static int mfill_atomic_install_pte(pmd_t *dst_pmd,
> +				    struct vm_area_struct *dst_vma,
> +				    unsigned long dst_addr, struct page *page,
> +				    uffd_flags_t flags)
>  {
>  	int ret;
>  	struct mm_struct *dst_mm = dst_vma->vm_mm;
> @@ -384,9 +383,6 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>  		goto out_unlock;
>  
>  	if (page_in_cache) {
> -		/* Usually, cache pages are already added to LRU */
> -		if (newly_allocated)
> -			folio_add_lru(folio);
>  		folio_add_file_rmap_pte(folio, page, dst_vma);
>  	} else {
>  		folio_add_new_anon_rmap(folio, dst_vma, dst_addr, RMAP_EXCLUSIVE);
> @@ -401,6 +397,9 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>  
>  	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
>  
> +	if (page_in_cache)
> +		folio_unlock(folio);

Nitpick: another small change that looks correct, but IMHO would be nice to
either make it a small separate patch, or mention in the commit message.

> +
>  	/* No need to invalidate - it was non-present before */
>  	update_mmu_cache(dst_vma, dst_addr, dst_pte);
>  	ret = 0;
> @@ -507,13 +506,22 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>  	 */
>  	__folio_mark_uptodate(folio);
>  
> +	if (ops->filemap_add) {
> +		ret = ops->filemap_add(folio, state->vma, state->dst_addr);
> +		if (ret)
> +			goto err_folio_put;
> +	}
> +
>  	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
> -				       &folio->page, true, flags);
> +				       &folio->page, flags);
>  	if (ret)
> -		goto err_folio_put;
> +		goto err_filemap_remove;
>  
>  	return 0;
>  
> +err_filemap_remove:
> +	if (ops->filemap_remove)
> +		ops->filemap_remove(folio, state->vma);
>  err_folio_put:
>  	folio_put(folio);
>  	/* Don't return -ENOENT so that our caller won't retry */
> @@ -526,6 +534,18 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
>  {
>  	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
>  
> +	/*
> +	 * The normal page fault path for a MAP_PRIVATE mapping in a
> +	 * file-backed VMA will invoke the fault, fill the hole in the file and
> +	 * COW it right away. The result generates plain anonymous memory.
> +	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
> +	 * generate anonymous memory directly without actually filling the
> +	 * hole. For the MAP_PRIVATE case the robustness check only happens in
> +	 * the pagetable (to verify it's still none) and not in the page cache.
> +	 */
> +	if (!(state->vma->vm_flags & VM_SHARED))
> +		ops = &anon_uffd_ops;
> +
>  	return __mfill_atomic_pte(state, ops);
>  }
>  
> @@ -545,7 +565,8 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
>  	spinlock_t *ptl;
>  	int ret;
>  
> -	if (mm_forbids_zeropage(dst_vma->vm_mm))
> +	if (mm_forbids_zeropage(dst_vma->vm_mm) ||
> +	    (dst_vma->vm_flags & VM_SHARED))
>  		return mfill_atomic_pte_zeroed_folio(state);
>  
>  	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
> @@ -600,11 +621,10 @@ static int mfill_atomic_pte_continue(struct mfill_state *state)
>  	}
>  
>  	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> -				       page, false, flags);
> +				       page, flags);
>  	if (ret)
>  		goto out_release;
>  
> -	folio_unlock(folio);
>  	return 0;
>  
>  out_release:
> @@ -827,41 +847,18 @@ extern ssize_t mfill_atomic_hugetlb(struct userfaultfd_ctx *ctx,
>  
>  static __always_inline ssize_t mfill_atomic_pte(struct mfill_state *state)
>  {
> -	struct vm_area_struct *dst_vma = state->vma;
> -	unsigned long src_addr = state->src_addr;
> -	unsigned long dst_addr = state->dst_addr;
> -	struct folio **foliop = &state->folio;
>  	uffd_flags_t flags = state->flags;
> -	pmd_t *dst_pmd = state->pmd;
> -	ssize_t err;
>  
>  	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
>  		return mfill_atomic_pte_continue(state);
>  	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
>  		return mfill_atomic_pte_poison(state);
> +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
> +		return mfill_atomic_pte_copy(state);
> +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
> +		return mfill_atomic_pte_zeropage(state);
>  
> -	/*
> -	 * The normal page fault path for a shmem will invoke the
> -	 * fault, fill the hole in the file and COW it right away. The
> -	 * result generates plain anonymous memory. So when we are
> -	 * asked to fill an hole in a MAP_PRIVATE shmem mapping, we'll
> -	 * generate anonymous memory directly without actually filling
> -	 * the hole. For the MAP_PRIVATE case the robustness check
> -	 * only happens in the pagetable (to verify it's still none)
> -	 * and not in the radix tree.
> -	 */
> -	if (!(dst_vma->vm_flags & VM_SHARED)) {
> -		if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
> -			err = mfill_atomic_pte_copy(state);
> -		else
> -			err = mfill_atomic_pte_zeropage(state);
> -	} else {
> -		err = shmem_mfill_atomic_pte(dst_pmd, dst_vma,
> -					     dst_addr, src_addr,
> -					     flags, foliop);
> -	}

It's great to merge these otherwise.

Thanks!

> -
> -	return err;
> +	return -EOPNOTSUPP;
>  }
>  
>  static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> -- 
> 2.51.0
> 

-- 
Peter Xu


