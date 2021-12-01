Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFEF464455
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 02:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhLABEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 20:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhLABEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 20:04:22 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C8DC061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 17:01:02 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 133so3575973pgc.12
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 17:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zmFqBEQlvltO6acviVLYEbC1w3hF1kHBhe0mktEwzGk=;
        b=gmUqS/1+VFLEhCIyad8Xcqaqs88aotTEEq/v1N3jGPaCTz0zt4xo5DybyKQ14uJMu5
         d1tcw4XQCBXcesEXtb7GV68bJ6MoS1vTfscgB9ChAatirailMSR7psHutEKyWkfIN5Al
         LMQlxiZ3dDA6TQkSCDNk+tIl1B8w6fXG4wt+kBcNBNcfBcujMO1x4FE5R49f+SfIR9YZ
         Hy5GnV3/IK+Ukcm5mzsVZQiFHTyudUHFkCQ/lzMWQmFFjt1EXiscxFZh9o7t37SBXs43
         kWsKRQ54x8dTsyf5m/oY7ch+/sgdtvFfUH26kPDq+r+ywNsL3Vwo3FE6k7OF6FJcb/6A
         tI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zmFqBEQlvltO6acviVLYEbC1w3hF1kHBhe0mktEwzGk=;
        b=JcoNUg3DVR2cTiweV6+/yquLkn0CPRrau5wkaL2oCYwsBdi98waEc2+pLMpLa8uHn4
         W++4EFvpaJ2hKMWfuM3+zTPuS/qxXOi9zO49Iw5/JuaV8j+S1/+3jLaSh+jUVHUVfypm
         HI4QH3NPv2V3EQE5uwhaH9XcQoiwznURfEEirHMaIrRYSwbqFK1gl+a4VTL5ym7O9X5Z
         XbuPdz3XRsdWWoRGJkF3KtKRMhVM30c2kpnY+IFRkMrdxkQRxbfRFCdygblYGAhD+cX+
         Ppe+kOaTwMDaiPkse/DkWaQCmI0OXrdvQdmI9VEO0hS6UyaKwcEr07bgHrcVg1ZOt27x
         Zbmw==
X-Gm-Message-State: AOAM530899L5KtN3eHJV31iVxQ9H2l5jZm/PBpEzWi6AZ7NsZNjFh01i
        Id49OBTSSR6tYOV0jDCCC8lvWw==
X-Google-Smtp-Source: ABdhPJxS/T8hRfTSUQusFRjWv1dbEuETNftI5GKso8ggTAhLHoWNzSPqJc0b5tiVkEGa9yowTlDHEw==
X-Received: by 2002:a62:dd54:0:b0:4a2:93f7:c20a with SMTP id w81-20020a62dd54000000b004a293f7c20amr2874377pff.46.1638320461624;
        Tue, 30 Nov 2021 17:01:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l9sm1982994pfu.55.2021.11.30.17.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 17:01:01 -0800 (PST)
Date:   Wed, 1 Dec 2021 01:00:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
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
Message-ID: <YabJSdRklj3T6FWJ@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-13-dmatlack@google.com>
 <YaDMg3/xUSwL5+Ei@xz-m1.local>
 <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, David Matlack wrote:
> On Fri, Nov 26, 2021 at 4:01 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > Hi, David,
> >
> > On Fri, Nov 19, 2021 at 11:57:56PM +0000, David Matlack wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 2a7564703ea6..432a4df817ec 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1232,6 +1232,9 @@ struct kvm_arch {
> > >       hpa_t   hv_root_tdp;
> > >       spinlock_t hv_root_tdp_lock;
> > >  #endif
> > > +
> > > +     /* MMU caches used when splitting large pages during VM-ioctls. */
> > > +     struct kvm_mmu_memory_caches split_caches;
> >
> > Are mmu_gfn_array_cache and mmu_pte_list_desc_cache wasted here?  I saw that
> > "struct kvm_mmu_memory_cache" still takes up quite a few hundreds of bytes,
> > just want to make sure we won't waste them in vain.
> 
> Yes they are wasted right now. But there's a couple of things to keep in mind:
> 
> 1. They are also wasted in every vCPU (in the per-vCPU caches) that
> does not use the shadow MMU.
> 2. They will (I think) be used eventually when I add Eager Page
> Splitting support to the shadow MMU.
> 3. split_caches is per-VM so it's only a few hundred bytes per VM.
> 
> If we really want to save the memory the right way forward might be to
> make each kvm_mmu_memory_cache a pointer instead of an embedded
> struct. Then we can allocate each dynamically only as needed. I can
> add that to my TODO list but I don't think it'd be worth blocking this
> on it given the points above.
> 
> >
> > [...]
> >
> > > +int mmu_topup_split_caches(struct kvm *kvm)
> > > +{
> > > +     struct kvm_mmu_memory_caches *split_caches = &kvm->arch.split_caches;
> > > +     int r;
> > > +
> > > +     assert_split_caches_invariants(kvm);
> > > +
> > > +     r = kvm_mmu_topup_memory_cache(&split_caches->page_header_cache, 1);
> > > +     if (r)
> > > +             goto out;
> > > +
> > > +     r = kvm_mmu_topup_memory_cache(&split_caches->shadow_page_cache, 1);
> > > +     if (r)
> > > +             goto out;
> >
> > Is it intended to only top-up with one cache object?  IIUC this means we'll try
> > to proactively yield the cpu for each of the huge page split right after the
> > object is consumed.
> >
> > Wondering whether it be more efficient to make it a slightly larger number, so
> > we don't overload the memory but also make the loop a bit more efficient.
> 
> IIUC, 1 here is just the min needed for kvm_mmu_topup_memory_cache to
> return success. I chose 1 for each because it's the minimum necessary
> to make forward progress (split one large page).

The @min parameter is minimum number of pages that _must_ be available in the
cache, i.e. it's the maximum number of pages that can theoretically be used by
whatever upcoming operation is going to be consuming pages from the cache.

So '1' is technically correct, but I think it's the wrong choice given the behavior
of this code.  E.g. if there's 1 object in the cache, the initial top-up will do
nothing, and then tdp_mmu_split_large_pages_root() will almost immediately drop
mmu_lock to topup the cache.  Since the in-loop usage explicitly checks for an
empty cache, i.e. any non-zero @min will have identical behavior, I think it makes
sense to use KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE _and_ add a comment explaining why.
 
> No matter what you pass for min kvm_mmu_topup_memory_cache() will
> still always try to allocate KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> objects.

No, it will try to allocate KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE if and only if there
are fewer than @min objects in the cache. 
