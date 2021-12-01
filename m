Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD8D4644E5
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 03:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346162AbhLACdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 21:33:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345986AbhLACdN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 21:33:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638325793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uF9Fy6ni5PnBeiS/CdAuJ/Fft8Orpw66x56ETZ461hk=;
        b=SIuxid9vDBBsUZGlM5LCUV9CRcETDTD3HQQJ8xWkgTgaYXabsSn5r/7xX8ZEETwpy4hp4n
        M8EY8cHF8XOMo7Q8CLS9J4Z26Uh9Y1IMfMeYYEkWz9aLhoqh4AERTEbOZHQjwR/pV2RhlP
        E3xuIYbAapzOF9JLThth7jO6ugHEDV8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-hefOZ1XwOHqL4WwS-iWYsg-1; Tue, 30 Nov 2021 21:29:52 -0500
X-MC-Unique: hefOZ1XwOHqL4WwS-iWYsg-1
Received: by mail-wm1-f70.google.com with SMTP id a85-20020a1c7f58000000b0033ddc0eacc8so12988755wmd.9
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 18:29:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uF9Fy6ni5PnBeiS/CdAuJ/Fft8Orpw66x56ETZ461hk=;
        b=2h20N8QV2myg97MkOoT3OYKf/u9CJBW9V/s6dD3q8ULl/RvA7ON3IXA8mm3yy8NxzS
         n50wwlFWY5tIk/c4xFKIucPQrbom4sa0wm9EK4BWngNyHYmX+rhAvIRMNbWXNgUW0YLf
         pIOLD5lttmIcBD6wRS36mOQFzvlclL0MJNs+t5ALXGjMpxAfdxOparwMXwoRN4rgplcB
         ml3ztMOdsRpuNlHL8AI85KYsswzpUz3XnxuAh17iGNTpfVMHz/bpMrClgCWIoD6M2r7C
         vivbwfc1mhew+TjkwbgHwHWTeNOxfLpikvXA2nNLd/nYFruCPZBTNHqqvGk5Tl5a60tA
         0zPg==
X-Gm-Message-State: AOAM533/kEE61elsiiwzLkuSQxmWf9UkbGDD/Xkvfsrsw/QKNmw1o7IQ
        QrnvlaDtoT2lePenB5Dwm9XParRFXlPomGFL8KytRFazwdthnVz01f41Oyq0xKrwB6bgCG2xL8Y
        HXrkE8b5dgp59
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr3420074wru.366.1638325790253;
        Tue, 30 Nov 2021 18:29:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzC2WmMPEofBjJpY9UNpUzWnlXp8IVrKbGIWga0IuS/0tDmL4KMFzMZD3vDYyVsyGf24fhG5w==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr3420052wru.366.1638325790038;
        Tue, 30 Nov 2021 18:29:50 -0800 (PST)
Received: from xz-m1.local ([64.64.123.10])
        by smtp.gmail.com with ESMTPSA id p2sm4485011wmq.23.2021.11.30.18.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 18:29:49 -0800 (PST)
Date:   Wed, 1 Dec 2021 10:29:41 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
Message-ID: <YabeFZxWqPAuoEtZ@xz-m1.local>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-13-dmatlack@google.com>
 <YaDMg3/xUSwL5+Ei@xz-m1.local>
 <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
 <YabJSdRklj3T6FWJ@google.com>
 <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 05:29:10PM -0800, David Matlack wrote:
> On Tue, Nov 30, 2021 at 5:01 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Nov 30, 2021, David Matlack wrote:
> > > On Fri, Nov 26, 2021 at 4:01 AM Peter Xu <peterx@redhat.com> wrote:
> > > >
> > > > Hi, David,
> > > >
> > > > On Fri, Nov 19, 2021 at 11:57:56PM +0000, David Matlack wrote:
> > > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > > index 2a7564703ea6..432a4df817ec 100644
> > > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > > @@ -1232,6 +1232,9 @@ struct kvm_arch {
> > > > >       hpa_t   hv_root_tdp;
> > > > >       spinlock_t hv_root_tdp_lock;
> > > > >  #endif
> > > > > +
> > > > > +     /* MMU caches used when splitting large pages during VM-ioctls. */
> > > > > +     struct kvm_mmu_memory_caches split_caches;
> > > >
> > > > Are mmu_gfn_array_cache and mmu_pte_list_desc_cache wasted here?  I saw that
> > > > "struct kvm_mmu_memory_cache" still takes up quite a few hundreds of bytes,
> > > > just want to make sure we won't waste them in vain.
> > >
> > > Yes they are wasted right now. But there's a couple of things to keep in mind:
> > >
> > > 1. They are also wasted in every vCPU (in the per-vCPU caches) that
> > > does not use the shadow MMU.
> > > 2. They will (I think) be used eventually when I add Eager Page
> > > Splitting support to the shadow MMU.
> > > 3. split_caches is per-VM so it's only a few hundred bytes per VM.
> > >
> > > If we really want to save the memory the right way forward might be to
> > > make each kvm_mmu_memory_cache a pointer instead of an embedded
> > > struct. Then we can allocate each dynamically only as needed. I can
> > > add that to my TODO list but I don't think it'd be worth blocking this
> > > on it given the points above.

Yeah I never meant to block this series just for this. :)

If there's plan to move forward with shadow mmu support and they'll be needed
at last, then it's good to me to keep it as is.  Maybe before adding the shadow
mmu support we add a comment above the structure?  Depending on whether the
shadow mmu support is in schedule or not, I think.

> > >
> > > >
> > > > [...]
> > > >
> > > > > +int mmu_topup_split_caches(struct kvm *kvm)
> > > > > +{
> > > > > +     struct kvm_mmu_memory_caches *split_caches = &kvm->arch.split_caches;
> > > > > +     int r;
> > > > > +
> > > > > +     assert_split_caches_invariants(kvm);
> > > > > +
> > > > > +     r = kvm_mmu_topup_memory_cache(&split_caches->page_header_cache, 1);
> > > > > +     if (r)
> > > > > +             goto out;
> > > > > +
> > > > > +     r = kvm_mmu_topup_memory_cache(&split_caches->shadow_page_cache, 1);
> > > > > +     if (r)
> > > > > +             goto out;
> > > >
> > > > Is it intended to only top-up with one cache object?  IIUC this means we'll try
> > > > to proactively yield the cpu for each of the huge page split right after the
> > > > object is consumed.
> > > >
> > > > Wondering whether it be more efficient to make it a slightly larger number, so
> > > > we don't overload the memory but also make the loop a bit more efficient.
> > >
> > > IIUC, 1 here is just the min needed for kvm_mmu_topup_memory_cache to
> > > return success. I chose 1 for each because it's the minimum necessary
> > > to make forward progress (split one large page).
> >
> > The @min parameter is minimum number of pages that _must_ be available in the
> > cache, i.e. it's the maximum number of pages that can theoretically be used by
> > whatever upcoming operation is going to be consuming pages from the cache.
> >
> > So '1' is technically correct, but I think it's the wrong choice given the behavior
> > of this code.  E.g. if there's 1 object in the cache, the initial top-up will do
> > nothing,
> 
> This scenario will not happen though, since we free the caches after
> splitting. So, the next time userspace enables dirty logging on a
> memslot and we go to do the initial top-up the caches will have 0
> objects.
> 
> > and then tdp_mmu_split_large_pages_root() will almost immediately drop
> > mmu_lock to topup the cache.  Since the in-loop usage explicitly checks for an
> > empty cache, i.e. any non-zero @min will have identical behavior, I think it makes
> > sense to use KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE _and_ add a comment explaining why.
> 
> If we set the min to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> kvm_mmu_topup_memory_cache will return ENOMEM if it can't allocate at
> least KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE objects, even though we really
> only need 1 to make forward progress.
> 
> It's a total edge case but there could be a scenario where userspace
> sets the cgroup memory limits so tight that we can't allocate
> KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE objects when splitting the last few
> pages and in the end we only needed 1 or 2 objects to finish
> splitting. In this case we'd end up with a spurious pr_warn and may
> not split the last few pages depending on which cache failed to get
> topped up.

IMHO when -ENOMEM happens, instead of keep trying with 1 shadow sp we should
just bail out even earlier.

Say, if we only have 10 (<40) pages left for shadow sp's use, we'd better make
good use of them lazily to be consumed in follow up page faults when the guest
accessed any of the huge pages, rather than we take them all over to split the
next continuous huge pages assuming it'll be helpful..

From that POV I have a slight preference over Sean's suggestion because that'll
make us fail earlier.  But I agree it shouldn't be a big deal.

Thanks,

-- 
Peter Xu

