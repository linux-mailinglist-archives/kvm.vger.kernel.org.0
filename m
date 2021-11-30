Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD114643B1
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 00:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345449AbhLAAAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 19:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345453AbhLAAAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 19:00:03 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E92CC061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:56:43 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id u22so44416721lju.7
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w1Ec/woL20Dh6SzY5jPxmMIXOOwE5qipB4fbit+a0aw=;
        b=c23QyhP7dL8PmytSki5TMVXw+iSXPp0s1OQkL0yMBHRxdJ1niFPegi1c+iHjehQk4K
         pc/B+al0XvPdpcIihZPyvS6S3oBwNXFXM03PLTHLH++dK9mF5PoGv5NJaPeDkjLZPi70
         6CIbbgVU+bynJSKB7x+/qUqMkRCMy2ObYEZEOuX3fn4vCcsrLzF0ZGVL/Hzl50zPWqAe
         o7eD3OaO+g1aQvDc5T9uMUl6RY4tWYTjbHq/Ll/89YA6F/Pg4XqxbHLZaAnq9bOvyoN6
         TMt86aY3CPK2GLrj47/4ey+xnTPcWGdy3PEDZ8V6aNbQBYgQySQ568VU/CvVGMXh+rDy
         9SBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w1Ec/woL20Dh6SzY5jPxmMIXOOwE5qipB4fbit+a0aw=;
        b=j6tJG8IqevG5MHhuWpbmjnM/BKeXW7sDZwpN65KY6Y2BwmW8qyNlcpj8wicWulqikb
         ob1NAgLBXbKEDSO5xze1duVUQHG4EEdBs4YhPgW4G3pU6e589/RasOvksuz+LITMxfdh
         veVanKLGoDs38228ZJkFJHlLnJKhiQ6q2pfQdWHKq9v/OauDpkexvoRt8cumWrQfpSMy
         ncFsjjqQEOeZoWts6SsksN/eCcKADEu8GFdeFdCeDwMst8oz3ML2qEWbbYMy1378NWX+
         iZwWdsSR+QqQKM0wE4LzCV0VN3F04wZ/ucvOM+9r2ddCz8CvutqSaLyduMhNtLZtrOR1
         +j7g==
X-Gm-Message-State: AOAM530ld/Z42MhQypRl2q0QcJVN8T4TIrNQiFF3jrYRW1XjDJygYu//
        0xQKJoSOlBHCps5OEa/FlN1Ujcseq3lzNU7k0MamhQ==
X-Google-Smtp-Source: ABdhPJwWZj2I31SMfJTRiUxfMq5F9oMc4JLNbfvzySyfIgyleL8rU2Mh4hNLig/qUFRdFRLymlaUyF0cjVBmBE8/KVA=
X-Received: by 2002:a2e:8895:: with SMTP id k21mr2062660lji.331.1638316601575;
 Tue, 30 Nov 2021 15:56:41 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-13-dmatlack@google.com>
 <YaDMg3/xUSwL5+Ei@xz-m1.local>
In-Reply-To: <YaDMg3/xUSwL5+Ei@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 15:56:15 -0800
Message-ID: <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26, 2021 at 4:01 AM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, David,
>
> On Fri, Nov 19, 2021 at 11:57:56PM +0000, David Matlack wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 2a7564703ea6..432a4df817ec 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1232,6 +1232,9 @@ struct kvm_arch {
> >       hpa_t   hv_root_tdp;
> >       spinlock_t hv_root_tdp_lock;
> >  #endif
> > +
> > +     /* MMU caches used when splitting large pages during VM-ioctls. */
> > +     struct kvm_mmu_memory_caches split_caches;
>
> Are mmu_gfn_array_cache and mmu_pte_list_desc_cache wasted here?  I saw that
> "struct kvm_mmu_memory_cache" still takes up quite a few hundreds of bytes,
> just want to make sure we won't waste them in vain.

Yes they are wasted right now. But there's a couple of things to keep in mind:

1. They are also wasted in every vCPU (in the per-vCPU caches) that
does not use the shadow MMU.
2. They will (I think) be used eventually when I add Eager Page
Splitting support to the shadow MMU.
3. split_caches is per-VM so it's only a few hundred bytes per VM.

If we really want to save the memory the right way forward might be to
make each kvm_mmu_memory_cache a pointer instead of an embedded
struct. Then we can allocate each dynamically only as needed. I can
add that to my TODO list but I don't think it'd be worth blocking this
on it given the points above.

>
> [...]
>
> > +int mmu_topup_split_caches(struct kvm *kvm)
> > +{
> > +     struct kvm_mmu_memory_caches *split_caches = &kvm->arch.split_caches;
> > +     int r;
> > +
> > +     assert_split_caches_invariants(kvm);
> > +
> > +     r = kvm_mmu_topup_memory_cache(&split_caches->page_header_cache, 1);
> > +     if (r)
> > +             goto out;
> > +
> > +     r = kvm_mmu_topup_memory_cache(&split_caches->shadow_page_cache, 1);
> > +     if (r)
> > +             goto out;
>
> Is it intended to only top-up with one cache object?  IIUC this means we'll try
> to proactively yield the cpu for each of the huge page split right after the
> object is consumed.
>
> Wondering whether it be more efficient to make it a slightly larger number, so
> we don't overload the memory but also make the loop a bit more efficient.

IIUC, 1 here is just the min needed for kvm_mmu_topup_memory_cache to
return success. I chose 1 for each because it's the minimum necessary
to make forward progress (split one large page).

No matter what you pass for min kvm_mmu_topup_memory_cache() will
still always try to allocate KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
objects.


>
> > +
> > +     return 0;
> > +
> > +out:
> > +     pr_warn("Failed to top-up split caches. Will not split large pages.\n");
> > +     return r;
> > +}
>
> Thanks,
>
> --
> Peter Xu
>
