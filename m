Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CFD1D026D
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 00:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgELWgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 18:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELWge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 18:36:34 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B19DC061A0C
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 15:36:34 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id t8so5359955uap.3
        for <kvm@vger.kernel.org>; Tue, 12 May 2020 15:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VPTKMB09cHORert/2ezDwhBpCl19xy+i4noiHdfj35Q=;
        b=PHCigFzdCazuwMNmC8luK1D8z8UE5Do3lGIB9CWaZPwhkuw2HfqQKZHDj62DMEXKj5
         FjeaV9wjlnqnkcwznaFBfwkHSjI5JgLvXXYzlyeR9diJU8yk5FR+dliVWxZPpXCPVniz
         s0i522HKomwrUdyGTWnIVgclCFvxFEUaqDXd39Rs0qPaFNYu13sREl465CyRAgZAW4rc
         CaggSHeMeHZMeU/V/nn0t1lIoTiER+l2X4gOmcp20rQMolg/X75EnEFUmsRO0OxRG+2i
         2WdZczRjP+GXp1GOmZz5DtWPkBoYSwsTZVqtgx1NLVpea/s2lJvBgDm8rNbLNctcEc3B
         Vg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VPTKMB09cHORert/2ezDwhBpCl19xy+i4noiHdfj35Q=;
        b=cg5lWrMr6wEexmAkrsM9ZtIpu7YGezop4tROtwt+ek8y7MWcM1OOwMALMbcpeEUBcX
         WLusB5cYUvxsp85uR/PeNDdjwfyKqZgiaLYP+596eFlFk6oBvzporY9nD1N0ZWQL6cHp
         NtR1sBBXDvPOG6ejB8zPTACMdzA93qa0GDBW99z4YL8obFsH2DJXArPQhXVljDaq271K
         2+J/pk5Gif97Vtoin9Ptm6TkghZXBLozSYUybAJzZZABc8F5xRc9mOjxGXlNAwCtmt5N
         vXSyMbN5sJJ6b8z96MDzXx3cR1SKNMK5smLwexzEzBxjP5cVmSi3fjkgz5ittgDhxaqe
         MA/w==
X-Gm-Message-State: AGi0PuaWvY9/OxmcODLbdS3dUdxfZVSBEabB7xshb1VQ6O3VtwxfB+tM
        StRx+lBtLzZpZJXerHV/OQNIE8X0nGyUHcoMxMfmHg==
X-Google-Smtp-Source: APiQypL4H9VMuvTjs5TnhWmb6R5MoHG6wHj4r0ylzdzOSTekmyuXP5kf5xlhSkXXLFCy6dDxupf+XdqQQ6aTEgiudR4=
X-Received: by 2002:ab0:7392:: with SMTP id l18mr18621820uap.90.1589322993334;
 Tue, 12 May 2020 15:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200508182425.69249-1-jcargill@google.com> <20200508201355.GS27052@linux.intel.com>
In-Reply-To: <20200508201355.GS27052@linux.intel.com>
From:   Peter Feiner <pfeiner@google.com>
Date:   Tue, 12 May 2020 15:36:21 -0700
Message-ID: <CAM3pwhEw+KYq9AD+z8wPGyG10Bex7xLKaPM=yVV-H+W_eHTW4w@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86 mmu: avoid mmu_page_hash lookup for
 direct_map-only VM
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 8, 2020 at 1:14 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, May 08, 2020 at 11:24:25AM -0700, Jon Cargille wrote:
> > From: Peter Feiner <pfeiner@google.com>
> >
> > Optimization for avoiding lookups in mmu_page_hash. When there's a
> > single direct root, a shadow page has at most one parent SPTE
> > (non-root SPs have exactly one; the root has none). Thus, if an SPTE
> > is non-present, it can be linked to a newly allocated SP without
> > first checking if the SP already exists.
>
> Some mechanical comments below.  I'll think through the actual logic next
> week, my brain needs to be primed anytime the MMU is involved :-)
>
> > This optimization has proven significant in batch large SP shattering
> > where the hash lookup accounted for 95% of the overhead.
> >
> > Signed-off-by: Peter Feiner <pfeiner@google.com>
> > Signed-off-by: Jon Cargille <jcargill@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> >
> > ---
> >  arch/x86/include/asm/kvm_host.h | 13 ++++++++
> >  arch/x86/kvm/mmu/mmu.c          | 55 +++++++++++++++++++--------------
> >  2 files changed, 45 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index a239a297be33..9b70d764b626 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -913,6 +913,19 @@ struct kvm_arch {
> >       struct kvm_page_track_notifier_node mmu_sp_tracker;
> >       struct kvm_page_track_notifier_head track_notifier_head;
> >
> > +     /*
> > +      * Optimization for avoiding lookups in mmu_page_hash. When there's a
> > +      * single direct root, a shadow page has at most one parent SPTE
> > +      * (non-root SPs have exactly one; the root has none). Thus, if an SPTE
> > +      * is non-present, it can be linked to a newly allocated SP without
> > +      * first checking if the SP already exists.
> > +      *
> > +      * False initially because there are no indirect roots.
> > +      *
> > +      * Guarded by mmu_lock.
> > +      */
> > +     bool shadow_page_may_have_multiple_parents;
>
> Why make this a one-way bool?  Wouldn't it be better to let this transition
> back to '0' once all nested guests go away?

I made it one way because I didn't know how the shadow MMU worked in
2015 :-) I was concerned about not quite getting the transition back
to '0' at the right point. I.e., what's the necessary set of
conditions where we never have to look for a parent SP? Is it just
when there are no indirect roots? Or could we be building some
internal part of the tree despite there not being roots? TBH, now that
it's been 12 months since I last thought _hard_ about the KVM MMU,
it'd take some time for me to review these questions.

>
> And maybe a shorter name that reflects what it tracks instead of how its
> used, e.g. has_indirect_mmu or indirect_mmu_count.

Good idea.

>
> > +
> >       struct list_head assigned_dev_head;
> >       struct iommu_domain *iommu_domain;
> >       bool iommu_noncoherent;
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e618472c572b..d94552b0ed77 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2499,35 +2499,40 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >               quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
> >               role.quadrant = quadrant;
> >       }
> > -     for_each_valid_sp(vcpu->kvm, sp, gfn) {
> > -             if (sp->gfn != gfn) {
> > -                     collisions++;
> > -                     continue;
> > -             }
> >
> > -             if (!need_sync && sp->unsync)
> > -                     need_sync = true;
> > +     if (vcpu->kvm->arch.shadow_page_may_have_multiple_parents ||
> > +         level == vcpu->arch.mmu->root_level) {
>
> Might be worth a goto to preserve the for-loop.

Or factor out the guts of the loop into a function.

>
> > +             for_each_valid_sp(vcpu->kvm, sp, gfn) {
> > +                     if (sp->gfn != gfn) {
> > +                             collisions++;
> > +                             continue;
> > +                     }
> >
> > -             if (sp->role.word != role.word)
> > -                     continue;
> > +                     if (!need_sync && sp->unsync)
> > +                             need_sync = true;
> >
> > -             if (sp->unsync) {
> > -                     /* The page is good, but __kvm_sync_page might still end
> > -                      * up zapping it.  If so, break in order to rebuild it.
> > -                      */
> > -                     if (!__kvm_sync_page(vcpu, sp, &invalid_list))
> > -                             break;
> > +                     if (sp->role.word != role.word)
> > +                             continue;
> >
> > -                     WARN_ON(!list_empty(&invalid_list));
> > -                     kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > -             }
> > +                     if (sp->unsync) {
> > +                             /* The page is good, but __kvm_sync_page might
> > +                              * still end up zapping it.  If so, break in
> > +                              * order to rebuild it.
> > +                              */
> > +                             if (!__kvm_sync_page(vcpu, sp, &invalid_list))
> > +                                     break;
> >
> > -             if (sp->unsync_children)
> > -                     kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > +                             WARN_ON(!list_empty(&invalid_list));
> > +                             kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > +                     }
> >
> > -             __clear_sp_write_flooding_count(sp);
> > -             trace_kvm_mmu_get_page(sp, false);
> > -             goto out;
> > +                     if (sp->unsync_children)
> > +                             kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > +
> > +                     __clear_sp_write_flooding_count(sp);
> > +                     trace_kvm_mmu_get_page(sp, false);
> > +                     goto out;
> > +             }
> >       }
> >
> >       ++vcpu->kvm->stat.mmu_cache_miss;
> > @@ -3735,6 +3740,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
> >       gfn_t root_gfn, root_pgd;
> >       int i;
> >
> > +     spin_lock(&vcpu->kvm->mmu_lock);
> > +     vcpu->kvm->arch.shadow_page_may_have_multiple_parents = true;
> > +     spin_unlock(&vcpu->kvm->mmu_lock);
>
> Taking the lock every time is unnecessary, even if this is changed to a
> refcount type variable, e.g.
>
>         if (!has_indirect_mmu) {
>                 lock_and_set
>         }
>
> or
>
>         if (atomic_inc_return(&indirect_mmu_count) == 1)
>                 lock_and_unlock;
>
>

Indeed. Good suggestion.

> > +
> >       root_pgd = vcpu->arch.mmu->get_guest_pgd(vcpu);
> >       root_gfn = root_pgd >> PAGE_SHIFT;
> >
> > --
> > 2.26.2.303.gf8c07b1a785-goog
> >
