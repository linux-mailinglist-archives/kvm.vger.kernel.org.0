Return-Path: <kvm+bounces-57984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D20B83254
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 08:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 831A11B20C2F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 06:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7E92D877E;
	Thu, 18 Sep 2025 06:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CCAYw/BK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A48265630
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 06:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758177066; cv=none; b=V0eW0hOBhPDJ7Vd6Pns2Q0Pwfzs5D3f9vduvxj1CsRhmd8r6chkebqJcxkeOH0pro4zfX+zmqFbSKZetkCFrSO911FE29YmmsrUPGIYkWyZ/NrJri6kpOtlNKr6W6IOJjoXKk7wq9BLu9cUKpHP+F0uGiewBJdL6pPET/tI0AvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758177066; c=relaxed/simple;
	bh=1ESgdimDNbdXFB+WfS9IWJsgtjPJ0aG5/dKUvYiS78w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F5K+g7Fcm8gPwruQ+8R6LmS+aaF+Q+zmzcd1/8Kxxxdb4jV1fLm1Qwjt9jGJ5a42egGoEZnA0NDgqioD6/ZCg7het90YWaUfdbsgqnmykhXFFnTD1/xDAMZCptDqzRi/Uruahj4NttALLtat6mwfnt6he1olL/0LfMcS3CwS7yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CCAYw/BK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so579907a91.3
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 23:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758177063; x=1758781863; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zYw7ATyO+FbNb+44lQoltDz9PEwp1UWJIGjKMOTdpb4=;
        b=CCAYw/BKzSAVfP411cx+fhiXGYmztinxkoWQCOnq7oiv31cG0BIytvmrE4lVt3Z9mT
         JekBHqpJ+ih8LY2US9ytszgGIo2WJTXYNNYfW4Mbcm3s69kbTZqNe9pOZSejx2XuFIFn
         fVQsP+NzYoxYxzxrZlygOxZncW8WJelqcv370T5RSm1cQTK1KZUAy6C2jcYdq6Knrf5h
         87o/qHyMOcY0qzSi8du1UDY/c9dQTxdFMveLALTDIbNHdp+zNK0hNdF9fHRAoSP6ctk5
         JNM6rmEaVX5g+ltNBf86FOxPiQkhCCHeU/zml4QDDOvBBc1X5RwSuI6GbzKKA/ABHSnZ
         Wg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758177063; x=1758781863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYw7ATyO+FbNb+44lQoltDz9PEwp1UWJIGjKMOTdpb4=;
        b=kAtE+qxSAW9CKVYS/hwTm1XYhyCiyZ3erHfs+sjhGCCIeuTx+aQJhH+IekWXc1P1UD
         fVw2jTXJ/ZnrzTkdFPOdymsALFXLj3rfRGkaVEgtYGcCPZTekx/OaBmq2abmYr2ZzK7l
         P69GxEjODVb0ZmKb9IP0JBYB1wy0L+BLV45kYcOAk9BlWuTqnwf7PPpTKan6txmjPINd
         TBwU27+owbSANXo6AXreupwuxwUtH0WAgwujZHYyzsjleU5LoCCm9shL+scbD3FNecfR
         13zDv2G2K+OzAv75McbICOmTCRkYBJqdByftWNPnF4PLGIo2kyat933BxyRxRjkZfMx+
         OEGQ==
X-Gm-Message-State: AOJu0Yw0/mj5SBWddYa1slPdQ8IONeBa8zgVmbU2P7nPuZWHdjFeAbr/
	Hy7KZiB2y826mAr6g6jwim+JojcZqi44WVC2Kope56YxFAU2av/BT0YdLLc5VQkxLeCug+ODj9B
	8r0y3M4HpqIGJ0FBYgem8V2FvOw==
X-Google-Smtp-Source: AGHT+IG8r6Hh7ieBZNhEHWEonWxugVqZ2GsgcsPqQV0BbYfLkp6mgTeqw5ZShceR0hVG0T5MXwZgGvkkREJdhdBrSQ==
X-Received: from pjvv5.prod.google.com ([2002:a17:90b:5885:b0:32b:58d1:a610])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5788:b0:32d:dffc:7ad6 with SMTP id 98e67ed59e1d1-32ee3f8c588mr6178959a91.33.1758177063484;
 Wed, 17 Sep 2025 23:31:03 -0700 (PDT)
Date: Thu, 18 Sep 2025 06:31:01 +0000
In-Reply-To: <20250916233335.wv2lf4fiejlw53o2@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-2-michael.roth@amd.com> <diqztt1vf198.fsf@google.com> <20250916233335.wv2lf4fiejlw53o2@amd.com>
Message-ID: <diqzo6r8p90a.fsf@google.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	vannapurve@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"

Michael Roth <michael.roth@amd.com> writes:

> On Mon, Aug 25, 2025 at 04:08:19PM -0700, Ackerley Tng wrote:
>> Michael Roth <michael.roth@amd.com> writes:
>> 
>> > guest_memfd currently uses the folio uptodate flag to track:
>> >
>> >   1) whether or not a page had been cleared before initial usage
>> >   2) whether or not the architecture hooks have been issued to put the
>> >      page in a private state as defined by the architecture
>> >
>> > In practice, 2) is only actually being tracked for SEV-SNP VMs, and
>> > there do not seem to be any plans/reasons that would suggest this will
>> > change in the future, so this additional tracking/complexity is not
>> > really providing any general benefit to guest_memfd users. Future plans
>> > around in-place conversion and hugepage support, where the per-folio
>> > uptodate flag is planned to be used purely to track the initial clearing
>> > of folios, whereas conversion operations could trigger multiple
>> > transitions between 'prepared' and 'unprepared' and thus need separate
>> > tracking, will make the burden of tracking this information within
>> > guest_memfd even more complex, since preparation generally happens
>> > during fault time, on the "read-side" of any global locks that might
>> > protect state tracked by guest_memfd, and so may require more complex
>> > locking schemes to allow for concurrent handling of page faults for
>> > multiple vCPUs where the "preparedness" state tracked by guest_memfd
>> > might need to be updated as part of handling the fault.
>> >
>> > Instead of keeping this current/future complexity within guest_memfd for
>> > what is essentially just SEV-SNP, just drop the tracking for 2) and have
>> > the arch-specific preparation hooks get triggered unconditionally on
>> > every fault so the arch-specific hooks can check the preparation state
>> > directly and decide whether or not a folio still needs additional
>> > preparation. In the case of SEV-SNP, the preparation state is already
>> > checked again via the preparation hooks to avoid double-preparation, so
>> > nothing extra needs to be done to update the handling of things there.
>> >
>> > Signed-off-by: Michael Roth <michael.roth@amd.com>
>> > ---
>> >  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
>> >  1 file changed, 15 insertions(+), 32 deletions(-)
>> >
>> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> > index 35f94a288e52..cc93c502b5d8 100644
>> > --- a/virt/kvm/guest_memfd.c
>> > +++ b/virt/kvm/guest_memfd.c
>> > @@ -421,11 +421,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>> >  	return 0;
>> >  }
>> >  
>> > -static inline void kvm_gmem_mark_prepared(struct folio *folio)
>> > -{
>> > -	folio_mark_uptodate(folio);
>> > -}
>> > -
>> >  /*
>> >   * Process @folio, which contains @gfn, so that the guest can use it.
>> >   * The folio must be locked and the gfn must be contained in @slot.
>> > @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>> >  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  				  gfn_t gfn, struct folio *folio)
>> >  {
>> > -	unsigned long nr_pages, i;
>> >  	pgoff_t index;
>> > -	int r;
>> > -
>> > -	nr_pages = folio_nr_pages(folio);
>> > -	for (i = 0; i < nr_pages; i++)
>> > -		clear_highpage(folio_page(folio, i));
>> >  
>> >  	/*
>> >  	 * Preparing huge folios should always be safe, since it should
>> > @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>> 
>> While working on HugeTLB support for guest_memfd, I added a test that
>> tries to map a non-huge-page-aligned gmem.pgoff to a huge-page aligned
>> gfn.
>> 
>> I understand that config would destroy the performance advantages of
>> huge pages, but I think the test is necessary since Yan brought up the
>> use case here [1].
>> 
>> The conclusion in that thread, I believe, was to allow binding of
>> unaligned GFNs to offsets, but disallow large pages in that case. The
>> next series for guest_memfd HugeTLB support will include a fix similar
>> to this [2].
>> 
>> While testing, I hit this WARN_ON with a non-huge-page-aligned
>> gmem.pgoff.
>> 
>> >  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
>> 
>> Do you all think this WARN_ON can be removed?
>
> I think so.. I actually ended up dropping this WARN_ON() for a similar
> reason:
>

Thanks for confirming!

>   https://github.com/AMDESE/linux/commit/c654cd144ad0d823f4db8793ebf9b43a3e8a7c48
>
> but in that case it was to deal with memslots where most of the GPA
> ranges are huge-page aligned to the gmemfd, and it's just that the start/end
> GPA ranges have been split up and associated with other memslots. In that case
> I still try to allow hugepages but force order 0 in kvm_gmem_get_pfn()
> for the start/end ranges.
>
> I haven't really considered the case where entire GPA range is misaligned
> with gmemfd hugepage offsets but the proposed handling seems reasonable
> to me... I need to take a closer look at whether the above-mentioned
> logic is at odds with what is/will be implemented in
> kvm_alloc_memslot_metadata() however as that seems a bit more restrictive.
>

Does this help? [1] (from a WIP patch series).

KVM already checks that the guest base address (base_gfn) and the
userspace virtual address (userspace_addr) are aligned relative to each
other for each large page level. If they are not, large pages are
disabled for the entire memory slot.

[1] extends that same check for slot->base_gfn and
slot->gmem.pgoff. Hence, guest_memfd is letting KVM manage the
mapping. guest_memfd reports max_order based on what it knows (folio
size, and folio size is also determined by shareability), and KVM
manages the mapping after taking account lpage_info in addition to
max_order.

[1] https://github.com/googleprodkernel/linux-cc/commit/371ed9281e0c9ba41cfdc20b48a6c5566f61a7df

> Thanks,
>
> Mike
>
>> 
>> Also, do you think kvm_gmem_prepare_folio()s interface should perhaps be
>> changed to take pfn, gfn, nr_pages (PAGE_SIZE pages) and level?
>> 
>> I think taking a folio is kind of awkward since we're not really setting
>> up the folio, we're setting up something mapping-related for the
>> folio. Also, kvm_gmem_invalidate() doesn't take folios, which is more
>> aligned with invalidating mappings rather than something folio-related.
>> 
>> [1] https://lore.kernel.org/all/aA7UXI0NB7oQQrL2@yzhao56-desk.sh.intel.com/
>> [2] https://github.com/googleprodkernel/linux-cc/commit/371ed9281e0c9ba41cfdc20b48a6c5566f61a7df
>> 
>> >  	index = gfn - slot->base_gfn + slot->gmem.pgoff;
>> >  	index = ALIGN_DOWN(index, 1 << folio_order(folio));
>> > -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>> > -	if (!r)
>> > -		kvm_gmem_mark_prepared(folio);
>> >  
>> > -	return r;
>> > +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>> >  }
>> >  
>> > 
>> > [...snip...]
>> > 
>> 

