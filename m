Return-Path: <kvm+bounces-38077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 296C4A34AF2
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 17:56:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1354118965A5
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 16:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA45423A9AD;
	Thu, 13 Feb 2025 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZL3vGrU6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A2328A2CF
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739465346; cv=none; b=tDp/Lv6jly9rADAKhA5MUAftUzeOaKpEXvpGxro40g0hZ2+Rl4Y9idHag1k+bbrBgTZpSNZjuO77bKzzotF/3f+wjNpeZaLuTWa1E6K80+lSkGWYroc6poFYzxJg6SfdKP6LqGbmkgyKOhI5PO0+A0dZFNlee3ktcOpCKKsllic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739465346; c=relaxed/simple;
	bh=stjsMCoXmAOuqNoWr54apqYrZ9Lu1dlfD+lCCAbl6FM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNpwyz7UGR95jn4KVnUohHfv2VOOuoepmRBPTgFmaVpIxZgDNd/1uCWJF0yV76KIMZPgxuye0xSr6jQY/K+jHtLwn403EO9C5BfbvZzIEltTXfwMGr7K146fc+xFRG5pGShQ8gj3dG7ou6ZaNGOUaBKL9Xgr9bH9l4nd5dJiLNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZL3vGrU6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739465343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JROJFeKJG/7QhErL5KNFi8pxb9777JdDet+vnroXIfk=;
	b=ZL3vGrU6c9ZoM0y2gJutAFcYnrNZDGKizWA/zq3bss1xcrT4ErR1YhgI6k7tVizcnkavxT
	4vqv4ZaqJxa+anGIpsOYF5kyBtB1vu8GQKSmFAUQ64MF+agg2SyIB5pLTUqbT3YYSB17rK
	WqMK9zo7pt6i4bgqYWEiZXU8C8jSVAE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-xEBWyluCP-y3MK8_dyzxKQ-1; Thu, 13 Feb 2025 11:49:02 -0500
X-MC-Unique: xEBWyluCP-y3MK8_dyzxKQ-1
X-Mimecast-MFC-AGG-ID: xEBWyluCP-y3MK8_dyzxKQ_1739465342
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-47197ef01dcso11333981cf.0
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 08:49:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739465342; x=1740070142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JROJFeKJG/7QhErL5KNFi8pxb9777JdDet+vnroXIfk=;
        b=OsTHdzyBDAgwGtRQ3OStDqTQPwQOeEv9RPPFjw+Xr/1ixKKx16njloWN0XT1t6QvoR
         cO8kftwejb28VStxWimykJdFbIdbdA5OkeFQLGKu25ZVuMq4KUYlkzDI2046yrajhRW4
         0GS9mCXYC9Y4FNiiq+TKll4Pm5LDEg5DR+mLw/jR2qUSU5BYeyhSTDcHOHj7L4hg7OZI
         c2QsAeYlXikluKVFp/MXU3Covc9Pe3ZRH+g6gONn1fFgiNaEbrZq2npZbGeMupV55JfI
         6+KZEgcnFjef7ghgSLh/fSlcPBwh8YwnTviCkrL+HYsSAaUNwh7wAaywom5nmX378Zvm
         VHvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWS7q7Tu92g4z1JcwyLcWqqZG5uSpz/UNm118WODdBNVy2qmggemh1GGgiJo/MXM12nzVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBiFgDQJ3wibPOzs6WlFwTLoJ7DomqtKRVdcPqMz6tcM9yPnsr
	4PCg8eQN5EHOKLtkOLh68ctnExrCwBHZEni4u4wJ8h08PSPIGnh1hE1DM7ahnQHczdhUPmMhFWe
	ENYN6JB4mO+BLYgFkDPik2C5sLj/bQAENB4+a9uiB79HziQBswA==
X-Gm-Gg: ASbGncuR0cOVnbUz5Vmnlwpj8NRkwZMldCoj/KBKCnWpKqE+3CpAxE2Ebtgh+D1jhdf
	rBwBxPOsBx/phlf/aCSZP8dlcPwUZ5E8vcjPDYjgNHLn7vYmISLgquxIYDdvIHZtc15l7IMW/WO
	K5Pjtx4ME6a3ttviYb2+k3VuVF7/RZ939IAWjhK1+HjH071bUpi/n5evD8QDzmJ+XOkztvYoxKf
	dHwIvlYhbSOhMNwvptkat0mMYXZsIG8sNnGAaMdDj1OvpIL/X0HUglD83Q=
X-Received: by 2002:a05:622a:19a7:b0:471:97ef:28c2 with SMTP id d75a77b69052e-471bee88bf9mr76398551cf.50.1739465341914;
        Thu, 13 Feb 2025 08:49:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGH90wp0Io4FsbD9Y9r1xlzUmOh6kR8o9MWqYgVTnqP+eNEwiXXiw94ZJu2zck2E6XolQdT0w==
X-Received: by 2002:a05:622a:19a7:b0:471:97ef:28c2 with SMTP id d75a77b69052e-471bee88bf9mr76397931cf.50.1739465341491;
        Thu, 13 Feb 2025 08:49:01 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471c2af36f2sm9540111cf.54.2025.02.13.08.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 08:49:00 -0800 (PST)
Date: Thu, 13 Feb 2025 11:48:57 -0500
From: Peter Xu <peterx@redhat.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk,
	jgg@nvidia.com, david@redhat.com, rientjes@google.com,
	fvdl@google.com, jthoughton@google.com, seanjc@google.com,
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com,
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev,
	mike.kravetz@oracle.com, erdemaktas@google.com,
	vannapurve@google.com, qperret@google.com, jhubbard@nvidia.com,
	willy@infradead.org, shuah@kernel.org, brauner@kernel.org,
	bfoster@redhat.com, kent.overstreet@linux.dev, pvorel@suse.cz,
	rppt@kernel.org, richard.weiyang@gmail.com, anup@brainfault.org,
	haibo1.xu@intel.com, ajones@ventanamicro.com, vkuznets@redhat.com,
	maciej.wieczor-retman@intel.com, pgonda@google.com,
	oliver.upton@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-fsdevel@kvack.org
Subject: Re: [RFC PATCH 15/39] KVM: guest_memfd: hugetlb: allocate and
 truncate from hugetlb
Message-ID: <Z64ieVfqTL2Wtqa5@x1.local>
References: <Z0yjGA25b8TfLMnd@x1n>
 <diqz8qqa9t84.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <diqz8qqa9t84.fsf@ackerleytng-ctop.c.googlers.com>

On Thu, Feb 13, 2025 at 07:52:43AM +0000, Ackerley Tng wrote:
> Peter Xu <peterx@redhat.com> writes:
> 
> > On Tue, Sep 10, 2024 at 11:43:46PM +0000, Ackerley Tng wrote:
> >> +static struct folio *kvm_gmem_hugetlb_alloc_folio(struct hstate *h,
> >> +						  struct hugepage_subpool *spool)
> >> +{
> >> +	bool memcg_charge_was_prepared;
> >> +	struct mem_cgroup *memcg;
> >> +	struct mempolicy *mpol;
> >> +	nodemask_t *nodemask;
> >> +	struct folio *folio;
> >> +	gfp_t gfp_mask;
> >> +	int ret;
> >> +	int nid;
> >> +
> >> +	gfp_mask = htlb_alloc_mask(h);
> >> +
> >> +	memcg = get_mem_cgroup_from_current();
> >> +	ret = mem_cgroup_hugetlb_try_charge(memcg,
> >> +					    gfp_mask | __GFP_RETRY_MAYFAIL,
> >> +					    pages_per_huge_page(h));
> >> +	if (ret == -ENOMEM)
> >> +		goto err;
> >> +
> >> +	memcg_charge_was_prepared = ret != -EOPNOTSUPP;
> >> +
> >> +	/* Pages are only to be taken from guest_memfd subpool and nowhere else. */
> >> +	if (hugepage_subpool_get_pages(spool, 1))
> >> +		goto err_cancel_charge;
> >> +
> >> +	nid = kvm_gmem_get_mpol_node_nodemask(htlb_alloc_mask(h), &mpol,
> >> +					      &nodemask);
> >> +	/*
> >> +	 * charge_cgroup_reservation is false because we didn't make any cgroup
> >> +	 * reservations when creating the guest_memfd subpool.
> >
> > Hmm.. isn't this the exact reason to set charge_cgroup_reservation==true
> > instead?
> >
> > IIUC gmem hugetlb pages should participate in the hugetlb cgroup resv
> > charge as well.  It is already involved in the rest cgroup charges, and I
> > wonder whether it's intended that the patch treated the resv accounting
> > specially.
> >
> > Thanks,
> >
> 
> Thank you for your careful reviews!
> 
> I misunderstood charging a cgroup for hugetlb reservations when I was
> working on this patch.
> 
> Before this, I thought hugetlb_cgroup_charge_cgroup_rsvd() was only for
> resv_map reservations, so I set charge_cgroup_reservation to false since
> guest_memfd didn't use resv_map, but I understand better now. Please
> help me check my understanding:
> 
> + All reservations are made at the hstate
> + In addition, every reservation is associated with a subpool (through
>   spool->rsv_hpages) or recorded in a resv_map
>     + Reservations are either in a subpool or in a resv_map but not both
> + hugetlb_cgroup_charge_cgroup_rsvd() is for any reservation
> 
> Regarding the time that a cgroup is charged for reservations:
> 
> + If a reservation is made during subpool creation, the cgroup is not
>   charged during the reservation by the subpool, probably by design
>   since the process doing the mount may not be the process using the
>   pages

Exactly.

> + Charging a cgroup for the reservation happens in
>   hugetlb_reserve_pages(), which is called at mmap() time.

Yes, or if it's not charged in hugetlb_reserve_pages() it needs to be
charged at folio allocation as of now.

> 
> For guest_memfd, I see two options:
> 
> Option 1: Charge cgroup for reservations at fault time
> 
> Pros:
> 
> + Similar in behavior to a fd on a hugetlbfs mount, where the cgroup of
>   the process calling fallocate() is charged for the reservation.
> + Symmetric approach, since uncharging happens when the hugetlb folio is
>   freed.
> 
> Cons:
> 
> + Room for allocation failure after guest_memfd creation. Even though
>   this guest_memfd had been created with a subpool and pages have been
>   reserved, there is a chance of hitting the cgroup's hugetlb
>   reservation cap and failing to allocate a page.
> 
> Option 2 (preferred): Charge cgroup for reservations at guest_memfd
> creation time
> 
> Pros:
> 
> + Once guest_memfd file is created, a page is guaranteed at fault time.

This would definitely be nice, that whatever that can block the guest from
using the memory should be a fault upfront when a VM boots if ever possible
(e.g. this is not a mmap() interface, so user yet doesn't allow NORESERVE).

It'll be slightly different from the spool use case of mount points, but I
think it's a new use case anyway, so IIUC we can define its behavior to
best suite the use case.

> + Simplifies/doesn't carry over the complexities of the hugetlb(fs)
>   reservation system
> 
> Cons:
> 
> + The cgroup being charged is the cgroup of the process creating
>   guest_memfd, which might be an issue if users expect the process
>   faulting the page to be charged.

Right, though I can't picture such use case yet.

I'm guessing multiple processes use of guest-memfd is still very far away.
When it happens, I would expect these tasks be put into the same cgroup..
Maybe kubevirt already have some of such use, I can go and have a check.

If they're not in the same cgroup, it's still more reasonable to always
charge that at the VM instance, rather than whatever other process that may
operate on the guest memory.

So it could be that we don't see major cons in solution 2.  In general, I
agree with your preference.

> 
> Implementation:
> 
> + At guest_memfd creation time, when creating the subpool, charge the
>   cgroups for everything:
>    + for hugetlb usage

I suppose here you meant the global reservation?  If so, I agree.

IIUC the new code shouldn't need to worry on this if the subpool is created
by the API, as that API does the global charging, like we discussed
elsewhere.

If you meant hugetlb_cgroup_commit_charge(),IMHO it should still be left
done until allocation.  In guest-memfd case, when fallocate().  AFAICT,
that's the only reason why we need two of such anyway..

>    + hugetlb reservation usage and

Agree on this one.

>    + hugetlb usage by page count (as in mem_cgroup_charge_hugetlb(),
>      which is new since [1])

This one should, IMHO, also be done only during allocation.

Thanks,

> + Refactoring in [1] would be focused on just dequeueing a folio or
>   failing which, allocating a surplus folio.
>    + After allocation, don't set cgroup on the folio so that the freeing
>      process doesn't uncharge anything
> + Uncharge when the file is closed
> 
> Please let me know if anyone has any thoughts/suggestions!
> 
> >> +	 *
> >> +	 * use_hstate_resv is true because we reserved from global hstate when
> >> +	 * creating the guest_memfd subpool.
> >> +	 */
> >> +	folio = hugetlb_alloc_folio(h, mpol, nid, nodemask, false, true);
> >> +	mpol_cond_put(mpol);
> >> +
> >> +	if (!folio)
> >> +		goto err_put_pages;
> >> +
> >> +	hugetlb_set_folio_subpool(folio, spool);
> >> +
> >> +	if (memcg_charge_was_prepared)
> >> +		mem_cgroup_commit_charge(folio, memcg);
> >> +
> >> +out:
> >> +	mem_cgroup_put(memcg);
> >> +
> >> +	return folio;
> >> +
> >> +err_put_pages:
> >> +	hugepage_subpool_put_pages(spool, 1);
> >> +
> >> +err_cancel_charge:
> >> +	if (memcg_charge_was_prepared)
> >> +		mem_cgroup_cancel_charge(memcg, pages_per_huge_page(h));
> >> +
> >> +err:
> >> +	folio = ERR_PTR(-ENOMEM);
> >> +	goto out;
> >> +}
> 
> [1] https://lore.kernel.org/all/7348091f4c539ed207d9bb0f3744d0f0efb7f2b3.1726009989.git.ackerleytng@google.com/
> 

-- 
Peter Xu


