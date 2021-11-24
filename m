Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E6445CC55
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 19:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350837AbhKXSph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 13:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244105AbhKXSph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 13:45:37 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B32C061574
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 10:42:27 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so4796692pjj.0
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 10:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pwawpo+EkZcExcPupTRBfhHZjZb8wx99L5UgcOvQmyI=;
        b=hDEg/2nTH95H0650g/Do8ANLNdzsQ9P5yAFwCSDyQ9YCjuvtsVKt3uNhvZ42ai5B9b
         yDtRhJ1kQC/yMevOU05TSAk0eD8HkNeA5/Kuzp1SzxCSbyNwfa2+7vIxEZZIkcZOCbaZ
         bI7sOEPTqj+v22ztLE5mFP6OJMLvZBkXhSqCyekaQrvS3sloGevpS/6kKqjSgxFZzcyb
         9kMAAHQu1VUacZbfui3Xm+6612MgAbXPx63kls7BS31eW0ewrs6tZSdnw4Rz2DFtswjH
         Mz7ndkgy8EkOuRmf1UnReRZVWaVfo/wjUix0IFsH7na9U9Rjw4aOOg2pnjZcgFgN2Vif
         FpiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pwawpo+EkZcExcPupTRBfhHZjZb8wx99L5UgcOvQmyI=;
        b=BcCnswW4oap2KmzMQL9VLEecxpAoMPk/q8utzVuTELYE988boP7YgXFCboQHdVUfTi
         5y037dfbQhR4GxXC05OiOUf8zZiDy+LpyRmxLQGIRLZtdLo7k2IVejRyI9vJiEMMOQmP
         CStpX0wQysArSZ/QxvzkeHifeR5uI+y7QluKw1LJ1SvLvXn6HnU4zD+tnLASu9BemefR
         vMbiWxR3v/RdpAUmXcfkD/J4Bcr9b68S0G06xbh4odezHYbYPif2HhvhLHWCnH2K3BA6
         3Z+uPbXy1mhEmV93dPkdM8epIqVCVxYmxUdyp5r64nljjXJItK6eAsvFuHR8SnnHeeeJ
         fhDg==
X-Gm-Message-State: AOAM533Qky/xOe5ZQYMPPGfP6QK7QpSopvNBMBxPnW7MJHBAla8jAwFy
        DdUcJUwBMmGiAlq4nSW4AhOfvg==
X-Google-Smtp-Source: ABdhPJw4qQRHMemr78TrNM8jzAWD2iXcYZVw/RKJ1cb794L0c0BhidicVrJTDPPZPpvzWwtGliAQKg==
X-Received: by 2002:a17:90b:4c4d:: with SMTP id np13mr11842377pjb.233.1637779346639;
        Wed, 24 Nov 2021 10:42:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m15sm411819pfk.186.2021.11.24.10.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 10:42:25 -0800 (PST)
Date:   Wed, 24 Nov 2021 18:42:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Subject: Re: [PATCH 27/28] KVM: x86/mmu: Do remote TLB flush before dropping
 RCU in TDP MMU resched
Message-ID: <YZ6HjoPKftW3QLqr@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-28-seanjc@google.com>
 <CANgfPd-MNnx0GVZCHcDYUyx5kqAQSr=s_QGr8zDyw8Wnz0devQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-MNnx0GVZCHcDYUyx5kqAQSr=s_QGr8zDyw8Wnz0devQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 23, 2021, Ben Gardon wrote:
> On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > When yielding in the TDP MMU iterator, service any pending TLB flush
> > before  dropping RCU protections in anticipation of using the callers RCU
> > "lock" as a proxy for vCPUs in the guest.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> 
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 79a52717916c..55c16680b927 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -732,11 +732,11 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
> >                 return false;
> >
> >         if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> > -               rcu_read_unlock();
> > -
> >                 if (flush)
> >                         kvm_flush_remote_tlbs(kvm);
> >
> > +               rcu_read_unlock();
> > +
> 
> Just to check my understanding:
> Theoretically PT memory could be freed as soon as we release the RCU
> lock, if this is the only thread in a read critical section.In order
> to ensure that we can use RCU as a proxy for TLB flushes we need to
> flush the TLBs while still holding the RCU read lock. Without this
> change (and with the next one) we could wind up in a situation where
> we drop the RCU read lock, then the RCU callback runs and frees the
> memory, and then the guest does a lookup through the paging structure
> caches and we get a use-after-free bug. By flushing in an RCU critical
> section, we ensure that the TLBs will have been flushed by the time
> the RCU callback runs to free the memory. Clever!

Yep, exactly.
