Return-Path: <kvm+bounces-59463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF61BB745B
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 17:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A960548567A
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 15:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A62D623B618;
	Fri,  3 Oct 2025 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fb+pcPxO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5672778F4A
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759503759; cv=none; b=jWq+q/N9Wfpbg0BP3j3/NYUKrhvG6BD4qcl399KkhubXdBrVKoAQ53RT3L1zL58vcYX1lUb5zFbo5Xug2NDJxGMXK7pz2jqHNR8v2M5FBSXI7uXAGDbBb7rNcfuxaj0VFIb0CZ5A6/Soa/kGycyaPcHk1VS2WUAHn5+/iNHT+B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759503759; c=relaxed/simple;
	bh=BON7ZLgEkt1iDODoys9xHbWPGh2KxPus2qs97vxbhnI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fc4zz3mxpPHFVU+swV0C9QKgZw/3aBOQzDlwckO3JGXfmItVuIU7y85MTpP1Tbx+11E7WHItZumzsIsNT0r5H+kHy8e2UbsuZki9cQqEkDf7+mJ8iUxJVqX0kItE86bFhJqsXZGMxDtcGik3xa+QFkLgW7LPg89oC2rpYYhZvRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fb+pcPxO; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b55283ff3fcso1801306a12.3
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 08:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759503757; x=1760108557; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K0wDuhcL+HFHK9SNYF6Zl0qzqMkBdhZwVr5fMqCakwM=;
        b=fb+pcPxOsoJhZJ58kQCEExbIlXg7dJwa1i9CP75K6eirAAMg7jePhCrd/FgpKsJh++
         +aGFdydeZVAbst2yezOn4KdE0SqvqJQKMoLAne9f9bu/MHagCYs1vomoai9kfbIB4X8B
         i97Z8caRoiNwtGwzmZBeWFWeAYz6EEvin1jPueE3FGaZHMDm/7ofyKIOov+aQzQs+nJ8
         F5pm/KHQrL44j8Z95Y5dGyp8BabodDkRmr5fVyebetis2sa3pRM78nCYZdDQMXD1Epbi
         a6G+El/C5LEQcEVQhjKvmOTMeZNuElpTh0xBtqFYDpUHngUEpw3B+OVEdfLTNsPjSl+7
         /lRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759503757; x=1760108557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K0wDuhcL+HFHK9SNYF6Zl0qzqMkBdhZwVr5fMqCakwM=;
        b=a4Z+mwt4m6ou4c1JRnPmvNJA0G2Yuw5HKwWeHuITsIhVqmJdmAuJvPg9kwvSzMz+OZ
         KAIUnR5dVWRU00ClIOaWtSvWvCidoWW2rAhG0DDS5q2PTtFNzEnyDDdcpr0g5gcqfDiU
         kK3DH6itmnXvQXvgqpAB+3flsf5Xz/WkNJBd/lBHQZC4FSJ6/6B+E6fq2VPvNxAv87S7
         AcSBvMsSstigMPLVqg8PMcgXOU5Utpa8bQzr0YJtXQ13Ya/4hv1zOmvzhTKqvbfvZPtY
         dXKokdxKJnGuC52byn2qsjrcwiuDqTDwom74gShDmab5kf0+f/KMQhz2iyhJS3Aja5XP
         L7ag==
X-Gm-Message-State: AOJu0YwPnt6bLhjbeKDH8hal1AhcfsmiNXntXD0SJGPYFvJlneZrLDpW
	4QKQ+Qg8APHrGKKKo/KODUjkSRpH/MpRkIi8ojr0/DdDre5JhBgqu4YBW0tHWbglstAD35O5lsl
	Q1go7GA==
X-Google-Smtp-Source: AGHT+IFVDlLHkijqYvW2+0fFGYYR1+C6mGqgdJR3Wrx5+wOsGLv9/K2lzb4ZvmMqRl2iwWCMgZwpd8Pj/gg=
X-Received: from pjus13.prod.google.com ([2002:a17:90a:d48d:b0:330:5945:699e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d09:b0:327:9e88:7714
 with SMTP id 98e67ed59e1d1-339c27b5508mr5030575a91.37.1759503756354; Fri, 03
 Oct 2025 08:02:36 -0700 (PDT)
Date: Fri, 3 Oct 2025 08:02:34 -0700
In-Reply-To: <e9aaf20d31281d00861b1805404dbed40024f824.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <e9aaf20d31281d00861b1805404dbed40024f824.1747264138.git.ackerleytng@google.com>
Message-ID: <aN_liua2oaAyyuL_@google.com>
Subject: Re: [RFC PATCH v2 33/51] KVM: guest_memfd: Allocate and truncate from
 custom allocator
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

Trimmed Cc to KVM/guest_memfd again.

On Wed, May 14, 2025, Ackerley Tng wrote:
> If a custom allocator is requested at guest_memfd creation time, pages
> from the custom allocator will be used to back guest_memfd.
> 
> Change-Id: I59df960b3273790f42fe5bea54a234f40962eb75
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  mm/memory.c            |   1 +
>  virt/kvm/guest_memfd.c | 142 +++++++++++++++++++++++++++++++++++++----
>  2 files changed, 132 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ba3ea0a82f7f..3af45e96913c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7249,6 +7249,7 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>  	else
>  		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
>  }
> +EXPORT_SYMBOL_GPL(folio_zero_user);

This needs to be in a separate patch.

>  static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
>  				   unsigned long addr_hint,
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index c65d93c5a443..24d270b9b725 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -478,15 +478,13 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>   * leaking host data and the up-to-date flag is set.
>   */
>  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> -				  gfn_t gfn, struct folio *folio)
> +				  gfn_t gfn, struct folio *folio,
> +				  unsigned long addr_hint)
>  {
> -	unsigned long nr_pages, i;
>  	pgoff_t index;
>  	int r;
>  
> -	nr_pages = folio_nr_pages(folio);
> -	for (i = 0; i < nr_pages; i++)
> -		clear_highpage(folio_page(folio, i));
> +	folio_zero_user(folio, addr_hint);

As does this.

>  	/*
>  	 * Preparing huge folios should always be safe, since it should
> @@ -554,7 +552,9 @@ static int kvm_gmem_filemap_add_folio(struct address_space *mapping,
>   */
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  {
> +	size_t allocated_size;
>  	struct folio *folio;
> +	pgoff_t index_floor;
>  	int ret;
>  
>  repeat:
> @@ -581,8 +581,10 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  			return ERR_PTR(ret);
>  		}
>  	}
> +	allocated_size = folio_size(folio);
>  
> -	ret = kvm_gmem_filemap_add_folio(inode->i_mapping, folio, index);
> +	index_floor = round_down(index, folio_nr_pages(folio));
> +	ret = kvm_gmem_filemap_add_folio(inode->i_mapping, folio, index_floor);
>  	if (ret) {
>  		folio_put(folio);
>  
> @@ -598,7 +600,17 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  		return ERR_PTR(ret);
>  	}
>  
> -	__folio_set_locked(folio);
> +	spin_lock(&inode->i_lock);
> +	inode->i_blocks += allocated_size / 512;

???  If anything needs a comment, it's this.

> +	spin_unlock(&inode->i_lock);
> +
> +	/*
> +	 * folio is the one that is allocated, this gets the folio at the
> +	 * requested index.
> +	 */
> +	folio = page_folio(folio_file_page(folio, index));
> +	folio_lock(folio);
> +
>  	return folio;
>  }

...

> +static void kvm_gmem_truncate_inode_range(struct inode *inode, loff_t lstart,
> +					  loff_t lend)
> +{
> +	pgoff_t full_hpage_start;
> +	size_t nr_per_huge_page;
> +	pgoff_t full_hpage_end;
> +	size_t nr_pages;
> +	pgoff_t start;
> +	pgoff_t end;
> +	void *priv;
> +
> +	priv = kvm_gmem_allocator_private(inode);
> +	nr_per_huge_page = kvm_gmem_allocator_ops(inode)->nr_pages_in_folio(priv);
> +
> +	start = lstart >> PAGE_SHIFT;
> +	end = min(lend, i_size_read(inode)) >> PAGE_SHIFT;
> +
> +	full_hpage_start = round_up(start, nr_per_huge_page);
> +	full_hpage_end = round_down(end, nr_per_huge_page);

This is where the layer of indirection completely breaks down.  This is blatantly
specific to hugepages, but presented as if it's some generic logic.

> +
> +	if (start < full_hpage_start) {
> +		pgoff_t zero_end = min(full_hpage_start, end);
> +
> +		kvm_gmem_zero_range(inode->i_mapping, start, zero_end);
> +	}
> +
> +	if (full_hpage_end > full_hpage_start) {
> +		nr_pages = full_hpage_end - full_hpage_start;
> +		kvm_gmem_truncate_inode_aligned_pages(inode, full_hpage_start,
> +						      nr_pages);
> +	}
> +
> +	if (end > full_hpage_end && end > full_hpage_start) {
> +		pgoff_t zero_start = max(full_hpage_end, start);
> +
> +		kvm_gmem_zero_range(inode->i_mapping, zero_start, end);
> +	}
> +}
> +
>  static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  {
>  	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
> @@ -752,7 +850,12 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  	list_for_each_entry(gmem, gmem_list, entry)
>  		kvm_gmem_invalidate_begin(gmem, start, end);
>  
> -	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
> +	if (kvm_gmem_has_custom_allocator(inode)) {
> +		kvm_gmem_truncate_inode_range(inode, offset, offset + len);
> +	} else {
> +		/* Page size is PAGE_SIZE, so use optimized truncation function. */

For cases like this, put the comment outside of the if-statement.  Because what
you're documenting isn't just the call to truncate_inode_pages_range(), it's the
pivot on a "custom" allocator.

E.g. this should look more like:

	/* Comment about why KVM needs custom code for hugetlb. */
	if (kvm_gmem_is_hugetlb(inode))
		kvm_gmem_truncate_inode_range(...);
	else
		truncate_inode_pages_range(...);

> +		truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
> +	}
>  
>  	list_for_each_entry(gmem, gmem_list, entry)
>  		kvm_gmem_invalidate_end(gmem, start, end);
> @@ -776,6 +879,16 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>  
>  	start = offset >> PAGE_SHIFT;
>  	end = (offset + len) >> PAGE_SHIFT;
> +	if (kvm_gmem_has_custom_allocator(inode)) {
> +		size_t nr_pages;
> +		void *p;
> +
> +		p = kvm_gmem_allocator_private(inode);
> +		nr_pages = kvm_gmem_allocator_ops(inode)->nr_pages_in_folio(p);
> +
> +		start = round_down(start, nr_pages);
> +		end = round_down(end, nr_pages);
> +	}

This adds sooo much noise to a stupidly simple thing.  The per-gmem page size is
constant, just add gmem_inode.page_size and gmem_inode.page_shift then this becomes:

	start = offset >> gi->page_shift;
	start = (offset + len) >> gi->page_shift;

We can do that even if we end up with a layer of indirection (which the more I
look at this, the more I'm convinced that's completely unnecessary).

