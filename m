Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D803746F7
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 19:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbhEERgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 13:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240655AbhEERbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 13:31:53 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C846BC04957F
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 10:01:35 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r9so3986498ejj.3
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 10:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dHdYz151PKTWNs0iwW3G2S7ao71/OuX/lBcR18Vu17c=;
        b=Vn5O+RKhScbNYISKD9Qxf/ZHZMGkFGOrAeHmD389mgDKKu1o1SSgJbZnABvWAy1zK8
         RJ7uEYZnFXavtksWdsnGRNizBcTxLSogY5L+PiS9BJm0sVxgWh+Zp5zANxMhWJQWdph+
         yU4k2PoxDqy455e3McohgsEfshFG7twShBqdJA2AQZ2lhjRk96jzehH2KgkU+d7KNj3o
         EIoDe2gljyWesUE+MNhGl50Gm8oB5E1njXk4l9FhSE414DN7K1DjMm4e8pE1kbZfEaPe
         J84FGlfuiw6XgLJxXPF73dmZOnjDiAlov8AHURk5VwS9Lp0J/rUHWPiU0U7zsW9RWVLB
         GTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dHdYz151PKTWNs0iwW3G2S7ao71/OuX/lBcR18Vu17c=;
        b=jqDNpxSSjQDedKENFlEoQ8GVj4iSco3tK18FF6DphDYh7+ziy35eE+EYTLn4Fhcrib
         djBdOpeT/jE5z/fpaKi1XNh9iIugml5onIPVRCILBLiA5FP9tWb6Sj5Q9xT4V+LMSgMK
         FlK3Z9tu+m9ayxbtx7d8nM3uMTEqyVTxt82sNL2qDi1mf+kY/585gvfOYLxILth5WOA/
         pY2e22cYTAvvcMg1Tif0Ss7rinj8FHKq16KNUWd3YpmH1f5+5UEZYxDOmOxAG00oYKyR
         KDxzhxZfKJyethYfSGB/kjWYF6UMREecSnrebynknlsTVUIpB5myjQwH08OVa+W6pSJy
         7obQ==
X-Gm-Message-State: AOAM5339vCk/NeY+nrhyr1tRMJjTOHsvvLi+vf6PuGCeY2gtKyd4X+8o
        28aQ78z1tCT/v65DIudqti0KV0A3VXgt0EQ5ll/9VQ==
X-Google-Smtp-Source: ABdhPJzmV2+raeJouq5W3ix1ojmG6vTXiEz8csQID7kNdSDeY0I/l2PTI5vlWjeCNwgfd+qp66HSwaw/ysJB3ni1NdA=
X-Received: by 2002:a17:906:4c82:: with SMTP id q2mr28789124eju.80.1620234093994;
 Wed, 05 May 2021 10:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1620200410.git.kai.huang@intel.com> <817eae486273adad0a622671f628c5a99b72a375.1620200410.git.kai.huang@intel.com>
 <CANgfPd_gWZB9NMjzsZ-v61e=p53WytCR1qm_28vRg6bdESD1fQ@mail.gmail.com>
In-Reply-To: <CANgfPd_gWZB9NMjzsZ-v61e=p53WytCR1qm_28vRg6bdESD1fQ@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 5 May 2021 10:01:22 -0700
Message-ID: <CANgfPd-Dv-x9=t1DQrukCpRQJufEcN4ZUTw7mOe=p-zcS=hQDw@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86/mmu: Fix TDP MMU page table level
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 5, 2021 at 9:28 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, May 5, 2021 at 2:38 AM Kai Huang <kai.huang@intel.com> wrote:
> >
> > TDP MMU iterator's level is identical to page table's actual level.  For
> > instance, for the last level page table (whose entry points to one 4K
> > page), iter->level is 1 (PG_LEVEL_4K), and in case of 5 level paging,
> > the iter->level is mmu->shadow_root_level, which is 5.  However, struct
> > kvm_mmu_page's level currently is not set correctly when it is allocated
> > in kvm_tdp_mmu_map().  When iterator hits non-present SPTE and needs to
> > allocate a new child page table, currently iter->level, which is the
> > level of the page table where the non-present SPTE belongs to, is used.
> > This results in struct kvm_mmu_page's level always having its parent's
> > level (excpet root table's level, which is initialized explicitly using
> > mmu->shadow_root_level).  This is kinda wrong, and not consistent with
> > existing non TDP MMU code.  Fortuantely the sp->role.level is only used
> > in handle_removed_tdp_mmu_page(), which apparently is already aware of
> > this, and handles correctly.  However to make it consistent with non TDP
> > MMU code (and fix the issue that both root page table and any child of
> > it having shadow_root_level), fix this by using iter->level - 1 in
> > kvm_tdp_mmu_map().  Also modify handle_removed_tdp_mmu_page() to handle
> > such change.
>
> Ugh. Thank you for catching this. This is going to take me a bit to
> review as I should audit the code more broadly for this problem in the
> TDP MMU.
> It would probably also be a good idea to add a comment on the level
> field to say that it represents the level of the SPTEs in the
> associated page, not the level of the SPTE that links to the
> associated page.
> Hopefully that will prevent similar future misunderstandings.

I went through and manually audited the code. I think the only case
that needs to be added to this is for nx recovery:

--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -31,7 +31,7 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct
kvm *kvm, int as_id,
 }
 static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-       gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
+       gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1);

        /*
         * Don't allow yielding, as the caller may have a flush pending.  Note,

Otherwise we won't zap the full page with this change, resulting in
ineffective or less reliable NX recovery.

>
> >
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index debe8c3ec844..bcfb87e1c06e 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -335,7 +335,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> >
> >         for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> >                 sptep = rcu_dereference(pt) + i;
> > -               gfn = base_gfn + (i * KVM_PAGES_PER_HPAGE(level - 1));
> > +               gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
> >
> >                 if (shared) {
> >                         /*
> > @@ -377,12 +377,12 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
> >                         WRITE_ONCE(*sptep, REMOVED_SPTE);
> >                 }
> >                 handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> > -                                   old_child_spte, REMOVED_SPTE, level - 1,
> > +                                   old_child_spte, REMOVED_SPTE, level,
> >                                     shared);
> >         }
> >
> >         kvm_flush_remote_tlbs_with_address(kvm, gfn,
> > -                                          KVM_PAGES_PER_HPAGE(level));
> > +                                          KVM_PAGES_PER_HPAGE(level + 1));
> >
> >         call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> >  }
> > @@ -1009,7 +1009,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> >                 }
> >
> >                 if (!is_shadow_present_pte(iter.old_spte)) {
> > -                       sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
> > +                       sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> >                         child_pt = sp->spt;
> >
> >                         new_spte = make_nonleaf_spte(child_pt,
> > --
> > 2.31.1
> >
