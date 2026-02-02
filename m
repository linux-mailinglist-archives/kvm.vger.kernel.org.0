Return-Path: <kvm+bounces-69913-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0EVNKWccgWm0EAMAu9opvQ
	(envelope-from <kvm+bounces-69913-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 22:51:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47486D1DD2
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 22:51:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B74223034E10
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 21:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F989314D0E;
	Mon,  2 Feb 2026 21:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hfF1yLKY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CWHJ+xyU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DC03128D2
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 21:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068957; cv=none; b=qkuQafAqAiZHwr+ut8grf4kmVdKJr8UlC1oIKE+oqopDrbyAFttLTshojPQJrs6DOn3JlCV64ppaljygH7LH3MG09kzsb/dSYfRju0PraD7zEKEW35NfsuLkVdTzj3hwcpmlXpZ5EJ/muL4aIKFROoE+KQ40uNOe+zB8t80uji0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068957; c=relaxed/simple;
	bh=agtCQ9pZwtAROLqQxsM2KH3S9+KhShyu1IMY1wa4cPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lxGshB/OlHU0WMhMuO5gIrTPzb5oI794QCTnlxunQsg5Q4zjwYTIyWqmN8XOm4gSwVUoDCDA0X+HGn0i6Sy5MX37mB2xPAPjZZTxtCwwLRC8wgX+T/rrBk9W+0XjFRUd4Fnq72xONiU/2hDv4lSb8o6OM4Wle2LJclPwsddBVC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hfF1yLKY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CWHJ+xyU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770068954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g5FHEvnvdTlqMH7yVdF7d/M75bDKDwBnGXhGmTp6Y0Q=;
	b=hfF1yLKYtGRLJMUp1DwTJd9AsMilJ2Yrk6950HmA4JPLoXNFjSHpPQEKm6TviBv0EuT5oq
	iIbzZE+ihW+rxXUZe5/SxbppPCtwK6cILoGJ4TnimgF7URsxGrGuYPZz7wl9Q3v/UtYfHg
	inYuunZlDk8GBaPl+btAiMXI6X0Dc50=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-esZnDqKcOvmIAnzvEYH4oQ-1; Mon, 02 Feb 2026 16:49:13 -0500
X-MC-Unique: esZnDqKcOvmIAnzvEYH4oQ-1
X-Mimecast-MFC-AGG-ID: esZnDqKcOvmIAnzvEYH4oQ_1770068952
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-504888a2a1dso108236101cf.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 13:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770068952; x=1770673752; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g5FHEvnvdTlqMH7yVdF7d/M75bDKDwBnGXhGmTp6Y0Q=;
        b=CWHJ+xyUBII2jBt4GavcJzZrJIIbufyeeNNKjI8Iiw+kDqbP4nChIVv6IezF20iHjp
         7TudGIn91aoOBqXB6p5cWER5hWGrjbIVupk2DPAy0Pkqh5yk7TR2a4BiCPO+3ZHTnCOJ
         lKRgPsJ7/Wdj41ceyvdjK7TCTiWdgK2v1oavzcCc925kfYC47hwfRC7qOgyty0nQRqAs
         jZN4j5+pNh7pbwSvLQ0EphOkdcOoaAx0rYRI+3l1vn1ViNXyTW5mSV2s2msfFr95MIs8
         Hv9/lGfI/mNxlF9e6spfO9dl3vE2vU2dUDaIHWhz7mXoWsjlYiavYTQExpFKcHyVp0Zg
         +vjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770068952; x=1770673752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5FHEvnvdTlqMH7yVdF7d/M75bDKDwBnGXhGmTp6Y0Q=;
        b=vms5lSOlaBzkkTLSyHzp30SkwtkuaqnltSS/Go+2wVzlhI2RmOoUEcBObhGmy2MG8v
         BXyygvAsAqnMpmuubZlpuGEiTpWH32m6j13iI8Si0/KP6pt59a6wXvNHVp1afiWcfO+v
         cyPzHtN5UKeDwP+5SYicy3ZQzLwkhigHzb9K590drSrmi5AQFYkuJy8KJs+8I1dHvtbV
         LsWzwnYM+82CrNchjMKnSm+ioiXERaiyqKN5SK2tSutbaxR2VwYEvpdJ7FIB/WPEfat2
         M9iQiSMoPjJ7Ids36qNWVA/08Kb7u0QolP56Z8armEcRlpmgF5dv9Qz27Ki9M+VyT8xn
         TcxA==
X-Forwarded-Encrypted: i=1; AJvYcCUIIrTsmJodWwOEob1u+YY+kIGBBwxNWrP7T448o8eDU267+5GP2CcGUTb9hEJO1ITNma0=@vger.kernel.org
X-Gm-Message-State: AOJu0YynvG8zKGSI8EHDumjNq4hWH/aMwqGrdopSL0eo6u9kxjxH1rtu
	04mqqPxyDAWZUvF3a7RNmlgm/R/TadgMC0IHeB0Aj+/U/Zk+ThmHq21RFZ0c6gQncB+qypmoNHA
	vQpp/I+r1KxUqMAQE3m+o7gCRMmxfJgX9tHBeonTAcWunVphvgfI89w==
X-Gm-Gg: AZuq6aJjqhPSOojWf7lkFxZ22xuJwlmWUK+akfFxzxAQvpLYhAFTdRzwXeYMy1HkhQh
	jcU6wc0rpkLNLzmvofdjlWUqmiFyWjBNW09SLW+MOgN2dzCJ3byeNsNJgzypB8U/uaoPs399zMr
	aOl7x5Y+vQ65T+uIRe5N2pj9UJoazvgt0PxsuogO+t6LBypJUxqEGOtmNcnnKwgpv6M2MhJGTkj
	dG7QSkurKsGox4d1vGH4jjdEUPx1B88WV2Kvphbc839XdTv/YTyutZQbDCup7edVKQslaNF1pEl
	mgQ/ECXs4JcXKe+aZy6xxRQTdFDakQ43AYw2H9HA9brzqL8pBgAHTW3clCbZX6jZk88/f/5vZcm
	0yyo=
X-Received: by 2002:ac8:5a92:0:b0:502:aff1:5689 with SMTP id d75a77b69052e-505d2152eb7mr156388411cf.7.1770068952335;
        Mon, 02 Feb 2026 13:49:12 -0800 (PST)
X-Received: by 2002:ac8:5a92:0:b0:502:aff1:5689 with SMTP id d75a77b69052e-505d2152eb7mr156388151cf.7.1770068951834;
        Mon, 02 Feb 2026 13:49:11 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50337bbbd2csm114145581cf.25.2026.02.02.13.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 13:49:11 -0800 (PST)
Date: Mon, 2 Feb 2026 16:49:09 -0500
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
Subject: Re: [PATCH RFC 04/17] userfaultfd: introduce mfill_get_vma() and
 mfill_put_vma()
Message-ID: <aYEb1RlGWBJWKXNg@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-5-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127192936.1250096-5-rppt@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69913-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 47486D1DD2
X-Rspamd-Action: no action

Hi, Mike,

On Tue, Jan 27, 2026 at 09:29:23PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Split the code that finds, locks and verifies VMA from mfill_atomic()
> into a helper function.
> 
> This function will be used later during refactoring of
> mfill_atomic_pte_copy().
> 
> Add a counterpart mfill_put_vma() helper that unlocks the VMA and
> releases map_changing_lock.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 124 ++++++++++++++++++++++++++++-------------------
>  1 file changed, 73 insertions(+), 51 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 9dd285b13f3b..45d8f04aaf4f 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -157,6 +157,73 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
>  }
>  #endif
>  
> +static void mfill_put_vma(struct mfill_state *state)
> +{
> +	up_read(&state->ctx->map_changing_lock);
> +	uffd_mfill_unlock(state->vma);
> +	state->vma = NULL;
> +}
> +
> +static int mfill_get_vma(struct mfill_state *state)
> +{
> +	struct userfaultfd_ctx *ctx = state->ctx;
> +	uffd_flags_t flags = state->flags;
> +	struct vm_area_struct *dst_vma;
> +	int err;
> +
> +	/*
> +	 * Make sure the vma is not shared, that the dst range is
> +	 * both valid and fully within a single existing vma.
> +	 */
> +	dst_vma = uffd_mfill_lock(ctx->mm, state->dst_start, state->len);
> +	if (IS_ERR(dst_vma))
> +		return PTR_ERR(dst_vma);
> +
> +	/*
> +	 * If memory mappings are changing because of non-cooperative
> +	 * operation (e.g. mremap) running in parallel, bail out and
> +	 * request the user to retry later
> +	 */
> +	down_read(&ctx->map_changing_lock);
> +	err = -EAGAIN;
> +	if (atomic_read(&ctx->mmap_changing))
> +		goto out_unlock;
> +
> +	err = -EINVAL;
> +
> +	/*
> +	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
> +	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
> +	 */
> +	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
> +	    dst_vma->vm_flags & VM_SHARED))
> +		goto out_unlock;
> +
> +	/*
> +	 * validate 'mode' now that we know the dst_vma: don't allow
> +	 * a wrprotect copy if the userfaultfd didn't register as WP.
> +	 */
> +	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
> +		goto out_unlock;
> +
> +	if (is_vm_hugetlb_page(dst_vma))
> +		goto out;
> +
> +	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> +		goto out_unlock;
> +	if (!vma_is_shmem(dst_vma) &&
> +	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> +		goto out_unlock;

IMHO it's a bit weird to check for vma permissions in a get_vma() function.

Also, in the follow up patch it'll be also reused in
mfill_copy_folio_retry() which doesn't need to check vma permission.

Maybe we can introduce mfill_vma_check() for these two checks? Then we can
also drop the slightly weird is_vm_hugetlb_page() check (and "out" label)
above.

> +
> +out:
> +	state->vma = dst_vma;
> +	return 0;
> +
> +out_unlock:
> +	mfill_put_vma(state);
> +	return err;
> +}
> +
>  static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
>  {
>  	pgd_t *pgd;
> @@ -768,8 +835,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  		.src_addr = src_start,
>  		.dst_addr = dst_start,
>  	};
> -	struct mm_struct *dst_mm = ctx->mm;
> -	struct vm_area_struct *dst_vma;
>  	long copied = 0;
>  	ssize_t err;
>  
> @@ -784,57 +849,17 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
>  
>  retry:
> -	/*
> -	 * Make sure the vma is not shared, that the dst range is
> -	 * both valid and fully within a single existing vma.
> -	 */
> -	dst_vma = uffd_mfill_lock(dst_mm, dst_start, len);
> -	if (IS_ERR(dst_vma)) {
> -		err = PTR_ERR(dst_vma);
> +	err = mfill_get_vma(&state);
> +	if (err)
>  		goto out;
> -	}
> -
> -	/*
> -	 * If memory mappings are changing because of non-cooperative
> -	 * operation (e.g. mremap) running in parallel, bail out and
> -	 * request the user to retry later
> -	 */
> -	down_read(&ctx->map_changing_lock);
> -	err = -EAGAIN;
> -	if (atomic_read(&ctx->mmap_changing))
> -		goto out_unlock;
> -
> -	err = -EINVAL;
> -	/*
> -	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
> -	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
> -	 */
> -	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
> -	    dst_vma->vm_flags & VM_SHARED))
> -		goto out_unlock;
> -
> -	/*
> -	 * validate 'mode' now that we know the dst_vma: don't allow
> -	 * a wrprotect copy if the userfaultfd didn't register as WP.
> -	 */
> -	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
> -		goto out_unlock;
>  
>  	/*
>  	 * If this is a HUGETLB vma, pass off to appropriate routine
>  	 */
> -	if (is_vm_hugetlb_page(dst_vma))
> -		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
> +	if (is_vm_hugetlb_page(state.vma))
> +		return  mfill_atomic_hugetlb(ctx, state.vma, dst_start,
>  					     src_start, len, flags);
>  
> -	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> -		goto out_unlock;
> -	if (!vma_is_shmem(dst_vma) &&
> -	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> -		goto out_unlock;
> -
> -	state.vma = dst_vma;
> -
>  	while (state.src_addr < src_start + len) {
>  		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
>  
> @@ -853,8 +878,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  		if (unlikely(err == -ENOENT)) {
>  			void *kaddr;
>  
> -			up_read(&ctx->map_changing_lock);
> -			uffd_mfill_unlock(state.vma);
> +			mfill_put_vma(&state);
>  			VM_WARN_ON_ONCE(!state.folio);
>  
>  			kaddr = kmap_local_folio(state.folio, 0);
> @@ -883,9 +907,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  			break;
>  	}
>  
> -out_unlock:
> -	up_read(&ctx->map_changing_lock);
> -	uffd_mfill_unlock(state.vma);
> +	mfill_put_vma(&state);
>  out:
>  	if (state.folio)
>  		folio_put(state.folio);
> -- 
> 2.51.0
> 

-- 
Peter Xu


