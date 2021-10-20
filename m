Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BD74342D5
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 03:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhJTB0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 21:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhJTB0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 21:26:14 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F316BC061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 18:24:00 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t11so14955170plq.11
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 18:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XBiL1+Vl4EIWz6otoAM83emtBnaUQE6re7Zy4F/Tl+c=;
        b=jzeiEr+S9aqIMWjCIxkL3Vz/2qUZyF/ErkeZvyr/HpMW/YUa4nzLSMVZLl4Uk7RM9J
         GFU9arnMgMlJUjmHO3BtrgTOlxkcsmXYfSw9e7G3jCYCxB5j9GiciLGHDPG2bfJIyLSF
         d/4PzOVWxoNxMAFMp1rqcbEThM3R0+iTH6SLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XBiL1+Vl4EIWz6otoAM83emtBnaUQE6re7Zy4F/Tl+c=;
        b=Us9wPC+LFlA+mMggIT5aKx/DUPNwGe7WYKYjPrv3i6yA66dSbYFdereqQMwMeCGjIe
         qHgV+rGiBbW/WZZZjmtEGTbMulq65Y2N9NnCxRmsaQgT3iG9HFz5HcY5axgHtqC9E8Ab
         rORkiLWL2Im4fFTP2ucUUqoR9vDKSLYp65HvilnWTRoUMNQ0Yhmv3kcdpr+CXeXd+Ae3
         D/nWwBLzefRqbX0c9TyYmYsT/+/0a/D0rle0IZysPf13QmqR2Xp3B5BPmbaUI2kOuSZB
         04rLuzeyspHtC7izjjUyt7W7J9kKXMST4fdXlngONeo8Hfgnp4O7mFUAvQHbl0V3XrgS
         l7+g==
X-Gm-Message-State: AOAM530WPfADmPIIHub4Ra2Yo+KDGRGpMvzOMwkLRlu+rM7fb4BiYWgo
        rgb/Xqdut59khU618Pd0tFLa5Q==
X-Google-Smtp-Source: ABdhPJyHsTnt8CO2I4siTq9gz2mS3EIOy0HlQCeT4J7kNCw9lXcsEO8FgTyCvhnVA8pGiJR7+vBWjg==
X-Received: by 2002:a17:90b:248:: with SMTP id fz8mr3702172pjb.157.1634693040458;
        Tue, 19 Oct 2021 18:24:00 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:490f:f89:7449:e615])
        by smtp.gmail.com with ESMTPSA id y1sm428665pfo.104.2021.10.19.18.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 18:23:59 -0700 (PDT)
Date:   Wed, 20 Oct 2021 10:23:54 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     David Matlack <dmatlack@google.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHV2 1/3] KVM: x86: introduce kvm_mmu_pte_prefetch structure
Message-ID: <YW9vqgwU+/iVooXj@google.com>
References: <20211019153214.109519-1-senozhatsky@chromium.org>
 <20211019153214.109519-2-senozhatsky@chromium.org>
 <CALzav=cLXXZYBSH6iJifkqVijLAU5EvgVg2W4HKhqke2JBa+yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cLXXZYBSH6iJifkqVijLAU5EvgVg2W4HKhqke2JBa+yg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/10/19 15:44), David Matlack wrote:
> On Tue, Oct 19, 2021 at 8:32 AM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > kvm_mmu_pte_prefetch is a per-VCPU structure that holds a PTE
> > prefetch pages array, lock and the number of PTE to prefetch.
> >
> > This is needed to turn PTE_PREFETCH_NUM into a tunable VM
> > parameter.
> >
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 12 +++++++
> >  arch/x86/kvm/mmu.h              |  4 +++
> >  arch/x86/kvm/mmu/mmu.c          | 57 ++++++++++++++++++++++++++++++---
> >  arch/x86/kvm/x86.c              |  9 +++++-
> >  4 files changed, 77 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 5271fce6cd65..11400bc3c70d 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -607,6 +607,16 @@ struct kvm_vcpu_xen {
> >         u64 runstate_times[4];
> >  };
> >
> > +struct kvm_mmu_pte_prefetch {
> > +       /*
> > +        * This will be cast either to array of pointers to struct page,
> > +        * or array of u64, or array of u32
> > +        */
> > +       void *ents;
> > +       unsigned int num_ents;
> > +       spinlock_t lock;
> 
> The spinlock is overkill. I'd suggest something like this:
> - When VM-ioctl is invoked to update prefetch count, store it in
> kvm_arch. No synchronization with vCPUs needed.
> - When a vCPU takes a fault: Read the prefetch count from kvm_arch. If
> different than count at last fault, re-allocate vCPU prefetch array.
> (So you'll need to add prefetch array and count to kvm_vcpu_arch as
> well.)
> 
> No extra locks are needed. vCPUs that fault after the VM-ioctl will
> get the new prefetch count. We don't really care if a prefetch count
> update races with a vCPU fault as long as vCPUs are careful to only
> read the count once (i.e. use READ_ONCE(vcpu->kvm.prefetch_count)) and
> use that. Assuming prefetch count ioctls are rare, the re-allocation
> on the fault path will be rare as well.

So reallocation from the faul-path should happen before vCPU takes the
mmu_lock? And READ_ONCE(prefetch_count) should also happen before vCPU
takes mmu_lock, I assume, so we need to pass it as a parameter to all
the functions that will access prefetch array.

> Note: You could apply this same approach to a module param, except
> vCPUs would be reading the module param rather than vcpu->kvm during
> each fault.
> 
> And the other alternative, like you suggested in the other patch, is
> to use a vCPU ioctl. That would side-step the synchronization issue
> because vCPU ioctls require the vCPU mutex. So the reallocation could
> be done in the ioctl and not at fault time.

One more idea, wonder what do you think:

There is an upper limit on the number of PTEs we prefault, which is 128 as of
now, but I think 64 will be good enough, or maybe even 32. So we can always
allocate MAX_PTE_PREFETCH_NUM arrays in vcpu->arch and ioctl() will change
->num_ents only, which is always in (0, MAX_PTE_PREFETCH_NUM - 1] range. This
way we never have to reallocate anything, we just adjust the "maximum index"
value.

> Taking a step back, can you say a bit more about your usecase?

We are looking at various ways of reducing the number of vm-exits. There
is only one VM running on the device (a pretty low-end laptop).
