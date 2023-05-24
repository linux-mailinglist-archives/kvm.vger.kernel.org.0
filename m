Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A01970FC6F
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 19:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjEXRPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 13:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjEXRPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 13:15:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3410E1700
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 10:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684948450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EyHzZjPPIFiS8KYpIWrxQRKT3huMDr2umMnS3bHEjoo=;
        b=Rw1AUTouDBSbLQ5bW7WOFNxMYFZBzX1RCLupyHQtmaUWUqCa+RtiTrxPICD5blXZpDEm9s
        0YYHIcG31E6HArI5iE1gbQrfsVqtq987heVeujja1ggi930dGmni3jBe9a6zYrZYGZjMCt
        zoKyk5bESN47Nz4EC99+827aZDTfnCM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-4EyqNtPLOGuo_eCQY4X0Pw-1; Wed, 24 May 2023 13:14:09 -0400
X-MC-Unique: 4EyqNtPLOGuo_eCQY4X0Pw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3f6c58d57adso546111cf.1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 10:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684948449; x=1687540449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EyHzZjPPIFiS8KYpIWrxQRKT3huMDr2umMnS3bHEjoo=;
        b=hzSAZcIfpHb9dU8K7nxXt03iUMHhtPMfYLKKZWzWGGNjvSvw668HDZyURbJIxOi7U8
         gg6bYvGKnZAS1F1n5n9kFZTcJ0itCeRCf8Dl38lrLGXefUF1CuFLquCmyLP774BMgzOZ
         nM3U+VQQwnps7MTjNTndUJGcVevRHJUlLXcYd6jArTVz7EmA7VnTJQWUBkxDX+8i6eY0
         ORxR97/HCya26W+MMp11mYC98u8rFD7e27aSA+6LyAfhVnyPTy4D9TT9gAo24qeV5e47
         FS9yWNUQV/aIk8DsapqHEAlrN5V4PUWfe8ac598rHLIgnJWY/98np2p9rrJZ4DtqCMgY
         wRZw==
X-Gm-Message-State: AC+VfDwcqqw9SeAz4KhV3qKMw01x+G3/aHyjefFF6xbHq09Ie4/dLo7l
        I8T4DfN4Z99F0KO+R4q/Mbl0xPCxenpcd819HoBVQN0fhts5O8WmYsvVNKrOYFxb82yp+LamdZH
        DNzzi/pg+t8sa
X-Received: by 2002:a05:622a:1813:b0:3f7:df68:7b09 with SMTP id t19-20020a05622a181300b003f7df687b09mr546677qtc.6.1684948448726;
        Wed, 24 May 2023 10:14:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6xtGx76nP2e7ci9cMhYQQ8+ofaA2V0fY49xRSBW32J2t3CuEqII3+T4PPYMGd+CYf9BXSPiQ==
X-Received: by 2002:a05:622a:1813:b0:3f7:df68:7b09 with SMTP id t19-20020a05622a181300b003f7df687b09mr546639qtc.6.1684948448325;
        Wed, 24 May 2023 10:14:08 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-62-70-24-86-62.dsl.bell.ca. [70.24.86.62])
        by smtp.gmail.com with ESMTPSA id h10-20020ac85e0a000000b003f38b4167e5sm1587574qtx.2.2023.05.24.10.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 10:14:07 -0700 (PDT)
Date:   Wed, 24 May 2023 13:14:06 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Stevens <stevensd@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 1/4] KVM: mmu: introduce new gfn_to_pfn_noref functions
Message-ID: <ZG5F3igFgdIAwrn4@x1n>
References: <20230330085802.2414466-1-stevensd@google.com>
 <20230330085802.2414466-2-stevensd@google.com>
 <ZGvUsf7lMkrNDHuE@google.com>
 <ZG45q0xJSnA6NKQN@x1n>
 <ZG4/VdHu2LqLTlct@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZG4/VdHu2LqLTlct@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 09:46:13AM -0700, Sean Christopherson wrote:
> On Wed, May 24, 2023, Peter Xu wrote:
> > On Mon, May 22, 2023 at 01:46:41PM -0700, Sean Christopherson wrote:
> > > As for the flags vs. bools debate (see link above), I think the best approach is
> > > a mix of the two.  Specifically, reuse the FOLL_* flags as-is for inputs, and use
> > > booleans for outputs.  I don't _think_ there are any input bools/flags that don't
> > > map 1:1 with existing FOLL_* flags.
> > > 
> > > As a very, *very* rough sketch, provide APIs that look a bit like this.
> > 
> > Unifying ref vs nonref cases does look a bit cleaner to me too.
> > 
> > > 
> > >   kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll)
> > >   {
> > > 	kvm_pfn_t pfn;
> > > 
> > > 	if (WARN_ON_ONCE(!(foll->flags & FOLL_GET) && !foll.mmu_seq))
> > 
> > IMHO we may not want to rely on mmu_seq==0 either for unlucky very initial
> > mmu_seq being zero, or avoid overflows?
> 
> I was thinking we could initialize mmu_seq to '1' and make it a u64 to avoid
> overflow.

Yeah, that's fine too.

> 
> > I'd say we can stick with FOLL_GET in this case to identify ref vs nonref
> > and always assume mmu_seq a pure random number.
> 
> The intent of checking mmu_seq is to flag cases where the caller doesn't specify
> FOLL_GET and isn't protected by mmu_invalidate_seq, i.e. isn't tapped into the
> mmu_notifiers.  I.e. this is a sanity check, not functionally necessary.
> 
> > 
> > > 		return KVM_PFN_ERR_FAULT;
> > > 
> > > 	pfn = ???;
> > > 
> > > 	if (foll->page && !(foll->flags & FOLL_GET))
> > > 		put_page(foll->page);
> > > 
> > > 	return pfn;
> > >   }
> > > 
> > >   kvm_pfn_t kvm_follow_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, struct page **page)
> > >   {
> > > 	struct kvm_follow_pfn foll = {
> > > 		.flags = FOLL_GET | FOLL_WRITE,
> > > 	};
> > > 
> > > 	<more stuff here?>
> > > 
> > > 	foll.slot = ???;
> > > 	if (!foll.slot || foll.slot->flags & KVM_MEMSLOT_INVALID)
> > > 		return KVM_HVA_ERR_BAD;
> > > 
> > > 	if (memslot_is_readonly(foll.slot))
> > > 		return KVM_HVA_ERR_RO_BAD;
> > > 
> > > 	return __kvm_follow_pfn(&foll);
> > >   }
> > > 
> > > and a few partially converted users
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 67e2ac799aa7..5eaf0395ed87 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -550,12 +550,14 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
> > >  
> > >         if (is_accessed_spte(old_spte) && !is_accessed_spte(new_spte)) {
> > >                 flush = true;
> > > -               kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> > > +               if (is_refcounted_page_pte(old_spte))
> > 
> > One question is how to impl is_refcounted_page_pte() here to identify
> > non-refcountable pages.
> 
> KVM would use a software available bit in its PTEs to explicitly track which SPTEs
> point at refcounted pages.  E.g. I think bit 59 is available for EPT and 64-bit
> paging.  PAE paging doesn't have high available bits, which is why I called out
> that this would have to be 64-bit only.
> 
> > IIUC those pages are mostly identical to a normal page (so !PG_reserved)
> > but it has page_ref_count(page)==0 always, am I right?  I got that roughly
> > from reading f8be156be1 only though, so I could miss a lot of things..
> > 
> > When thinking about that, I'm also wondering whether we can trivially allow
> > kvm to support such mapping (without overhaul of the kvm pfn API) by
> > something like this:
> > 
> > ===8<===
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 51e4882d0873..467acbac1a96 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -192,7 +192,13 @@ struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)
> > 
> >         page = pfn_to_page(pfn);
> >         if (!PageReserved(page))
> > -               return page;
> > +               /*
> > +                * When page_ref_count(page)==0 it might be speical page
> > +                * that do not support refcounting.  Treating them the same
> > +                * as normal reserved (e.g. MMIO) pages by returning NULL,
> > +                * so they're exempt of refcounting.
> > +                */
> > +               return page_ref_count(page) == 0 ? NULL : page;
> 
> Heh, because I got burned by this recently, using page_ref_count() is wrong.  This
> needs to be page_count() so that tail pages of refcounted compound pages are
> properly identified.

:-D

Actually when I was replying I explicitly didn't use page_count() to make
sure we're reading the tail page, but I just noticed that's exactly the way
how we identify the special page with a PageCompound()==true tail page.

Yeah, if we'd like that it needs to be page_count()==0.

> 
> > 
> >         /* The ZERO_PAGE(s) is marked PG_reserved, but is refcounted. */
> >         if (is_zero_pfn(pfn))
> > ===8<===
> > 
> > So that we treat those special pages the same as normal PFNMAP ones by
> > skipping all refcountings on inc/dec.  This is based on the fact that kvm
> > should always hold at least 1 ref on a normal page so a normal page should
> > never hit ref==0 here, but again I could miss something somewhere..
> 
> This would "work" from a functionality perspective, and might be acceptable as an
> out-of-tree patch to unblock the ChromeOS use case, but I don't want to rely on
> this heuristic on the backend in KVM because it will suppress any and all
> use-after-free bugs in KVM's MMU (see patch 4 of this series).  I really want to
> go in the opposite direction and harden KVM against MMU bugs, e.g. I'm planning
> on posting the below (which is how I learned about page_count() vs. page_ref_count()).
> 
> Today, KVM gets partial protection from check_new_page_bad(), which detects *some*
> cases where KVM marks a page dirty after the page is freed.  But it's racy, and
> the detection occurs well after the fact since it fires only when the page is
> re-allocated.
> 
> If we hack kvm_pfn_to_refcounted_page(), then all of those protections are lost
> because KVM would drop its assertions and also skip dirtying pages, i.e. would
> effectively suppress the latent detection by check_new_page_bad().

So it's probably that I totally have no idea what are the attributes for
those special pages so I don't understand enough on why we need to handle
those pages differently from e.g. PFNMAP pages, and also the benefits.

I think what I can tell is that they're pages that doesn't have
PageCompound bits set on either head or tails, however it's still a
multi-2-order large page.  Is there an example on how these pages are used
and allocated?  Why would we need those pages, and whether these pages need
to be set dirty/accessed after all?

> 
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Wed May 17 13:26:54 2023 -0700
> 
>     KVM: Assert that a page's refcount is elevated when marking accessed/dirty
>     
>     Assert that a page's refcount is elevated, i.e. that _something_ holds a
>     reference to the page, when KVM marks a page as accessed and/or dirty.
>     KVM typically doesn't hold a reference to pages that are mapped into the
>     guest, e.g. to allow page migration, compaction, swap, etc., and instead
>     relies on mmu_notifiers to react to changes in the primary MMU.
>     
>     Incorrect handling of mmu_notifier events (or similar mechanisms) can
>     result in KVM keeping a mapping beyond the lifetime of the backing page,
>     i.e. can (and often does) result in use-after-free.  Yelling if KVM marks
>     a freed page as accessed/dirty doesn't prevent badness as KVM usually
>     only does A/D updates when unmapping memory from the guest, i.e. the
>     assertion fires well after an underlying bug has occured, but yelling
>     does help detect, triage, and debug use-after-free bugs.
>     
>     Note, the assertion must use page_count(), NOT page_ref_count()!  For
>     hugepages, the returned struct page may be a tailpage and thus not have
>     its own refcount.
>     
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d1abb331ea68..64f18697096c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2882,6 +2882,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
>  
>  static bool kvm_is_ad_tracked_page(struct page *page)
>  {
> +       /*
> +        * Assert that KVM isn't attempting to mark a freed page as Accessed or
> +        * Dirty, i.e. that KVM's MMU doesn't have a use-after-free bug.  KVM
> +        * (typically) doesn't pin pages that are mapped in KVM's MMU, and
> +        * instead relies on mmu_notifiers to know when a mapping needs to be
> +        * zapped/invalidated.  Unmapping from KVM's MMU must happen _before_
> +        * KVM returns from its mmu_notifier, i.e. the page should have an
> +        * elevated refcount at this point even though KVM doesn't hold a
> +        * reference of its own.
> +        */
> +       if (WARN_ON_ONCE(!page_count(page)))
> +               return false;
> +
>         /*
>          * Per page-flags.h, pages tagged PG_reserved "should in general not be
>          * touched (e.g. set dirty) except by its owner".
> 

This looks like a good thing to have, indeed.  But again it doesn't seem
like anything special to the pages we're discussing here, say, !Compound &&
refcount==0 ones.

-- 
Peter Xu

