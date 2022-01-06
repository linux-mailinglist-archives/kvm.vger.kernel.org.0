Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4F8486D71
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 23:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245320AbiAFW63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 17:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245153AbiAFW62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 17:58:28 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6B7C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 14:58:28 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id h7so9116963lfu.4
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 14:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KzV3X4HF5H2XBrWXeY4lDbXwiRVuoJ/mFlMHfdbyUZs=;
        b=jnujIWWxxG90dPL9I/+PJGsJV4v5eGMQmIL5+1biKXqY351uoLZKgCe4WdD8iDsB9h
         rN3Kzj3N68N+VKiXq4vgN7a+/M/Pqck7+St7xhcDeULo6uVNZGpTHH7BEl17GmRfzq8p
         CVZ3Bgc9b/eABX/LpZAa65hUHDgN/LXi3W2YTyozV2fMRObchAaORN65qJO6j9u2ZO+N
         FUJL+xVNaQMmdIsOOMi4dOiBB6y4ya+rH1+aqkLyqA5PN5zMjm5mJzlDAaRnyifHmTcP
         wCX72RlxPtHtYV9ZNqW7E+uox3r2wYmlTTGTiOT7KZ6CPIbZaKUFB2D1w7Ggi25CM44W
         dd2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KzV3X4HF5H2XBrWXeY4lDbXwiRVuoJ/mFlMHfdbyUZs=;
        b=dqEqNU5tqX7bEvpmV11g3+w/8amtNYPYPcWnJVCgc9+j6H26LyvgvbdiF7dbQDpezs
         axMSBf+fXABiwwGNAgTIv79B9OnXIhsTeSNQ3zv9B/V55SulZuPIU3CZLh3o/JtPDuib
         d6B74LQEurVgBBRnjHGM9rWwquPt5mzH9fy5/3dUPW+3oKF2Xk6PLg4lnHeY4u5Z0n4G
         CyI2YceNcVlyT7/gTfjdGt5r7I7DaJq0SnGlUML/jF3fQNF3ZkzmXRqiFs2XASmLmtlt
         VPc8JzH+nSX04m18+ytx4PaWIY0izX9BjJZKd/pYupuq2QTOYSapxkygZ5uzHaR1eK+2
         AiVg==
X-Gm-Message-State: AOAM533j+cLVRX0ZFb88avKf7WofBFaCFI7t4UVTfnhb6MzsujuVDdQT
        SJwhIwhfKb9SSlOEfFSaWlKjLqDpz9+w+XLDU2LsLgkXO4s=
X-Google-Smtp-Source: ABdhPJyX4QOfkiJspZOa0OIrnIQ92Db3pcaDHPhvk58O2duwxMBzUfeVV1ZJ6MEkfTea1qYzh3kWxIueGXIZsItCaFE=
X-Received: by 2002:a2e:a78c:: with SMTP id c12mr45521619ljf.223.1641509906568;
 Thu, 06 Jan 2022 14:58:26 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-6-dmatlack@google.com>
 <YddQutP4wnCylJwn@google.com>
In-Reply-To: <YddQutP4wnCylJwn@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 6 Jan 2022 14:58:00 -0800
Message-ID: <CALzav=eo6yWU-yLRO7Uox9Ls9aCNCbhf6N=aufbDY-tT7hR3Lg@mail.gmail.com>
Subject: Re: [PATCH v1 05/13] KVM: x86/mmu: Move restore_acc_track_spte to spte.c
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 6, 2022 at 12:27 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 13, 2021, David Matlack wrote:
> > restore_acc_track_spte is purely an SPTE manipulation, making it a good
> > fit for spte.c. It is also needed in spte.c in a follow-up commit so we
> > can construct child SPTEs during large page splitting.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c  | 18 ------------------
> >  arch/x86/kvm/mmu/spte.c | 18 ++++++++++++++++++
> >  arch/x86/kvm/mmu/spte.h |  1 +
> >  3 files changed, 19 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 8b702f2b6a70..3c2cb4dd1f11 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -646,24 +646,6 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
> >       return __get_spte_lockless(sptep);
> >  }
> >
> > -/* Restore an acc-track PTE back to a regular PTE */
> > -static u64 restore_acc_track_spte(u64 spte)
> > -{
> > -     u64 new_spte = spte;
> > -     u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
> > -                      & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
> > -
> > -     WARN_ON_ONCE(spte_ad_enabled(spte));
> > -     WARN_ON_ONCE(!is_access_track_spte(spte));
> > -
> > -     new_spte &= ~shadow_acc_track_mask;
> > -     new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
> > -                   SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
> > -     new_spte |= saved_bits;
> > -
> > -     return new_spte;
> > -}
> > -
> >  /* Returns the Accessed status of the PTE and resets it at the same time. */
> >  static bool mmu_spte_age(u64 *sptep)
> >  {
> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index 8a7b03207762..fd34ae5d6940 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -268,6 +268,24 @@ u64 mark_spte_for_access_track(u64 spte)
> >       return spte;
> >  }
> >
> > +/* Restore an acc-track PTE back to a regular PTE */
> > +u64 restore_acc_track_spte(u64 spte)
> > +{
> > +     u64 new_spte = spte;
> > +     u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
> > +                      & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
>
> Obviously not your code, but this could be:
>
>         u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT) &
>                          SHADOW_ACC_TRACK_SAVED_BITS_MASK;
>
>         WARN_ON_ONCE(spte_ad_enabled(spte));
>         WARN_ON_ONCE(!is_access_track_spte(spte));
>
>         spte &= ~shadow_acc_track_mask;
>         spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
>                   SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
>         spte |= saved_bits;
>
>         return spte;
>
> which is really just an excuse to move the ampersand up a line :-)
>
> And looking at the two callers, the WARNs are rather silly.  The spte_ad_enabled()
> WARN is especially pointless because that's also checked by is_access_track_spte().
> I like paranoid WARNs as much as anyone, but I don't see why this code warrants
> extra checking relative to the other SPTE helpers that have more subtle requirements.
>
> At that point, make make this an inline helper?
>
>   static inline u64 restore_acc_track_spte(u64 spte)
>   {
>         u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT) &
>                          SHADOW_ACC_TRACK_SAVED_BITS_MASK;
>
>         spte &= ~shadow_acc_track_mask;
>         spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
>                   SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
>         spte |= saved_bits;
>
>         return spte;
>   }

That all sounds reasonable. I'll include some additional patches in
the next version to include these cleanups.
>
> > +     WARN_ON_ONCE(spte_ad_enabled(spte));
> > +     WARN_ON_ONCE(!is_access_track_spte(spte));
> > +
> > +     new_spte &= ~shadow_acc_track_mask;
> > +     new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
> > +                   SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
> > +     new_spte |= saved_bits;
> > +
> > +     return new_spte;
> > +}
> > +
> >  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
> >  {
> >       BUG_ON((u64)(unsigned)access_mask != access_mask);
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index a4af2a42695c..9b0c7b27f23f 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -337,6 +337,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
> >  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
> >  u64 mark_spte_for_access_track(u64 spte);
> > +u64 restore_acc_track_spte(u64 spte);
> >  u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
> >
> >  void kvm_mmu_reset_all_pte_masks(void);
> > --
> > 2.34.1.173.g76aa8bc2d0-goog
> >
