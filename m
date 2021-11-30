Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EEE464365
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 00:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbhK3Xf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 18:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345844AbhK3Xfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 18:35:30 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD56C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:32:10 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id m27so57874642lfj.12
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PyavSs+C0Q6vOcm+8BKbJUFNSTKELgNZOkPjGxwwaWU=;
        b=U3j383zRODj+KYisDCQ3atMDw6TVxgHkfW+CT2/wukUCJIAOxWyY22R5176Ty3VUYH
         AjJ/ilDsNtarO16M728pF0XWZD5Cv7L03frP6dP9w+d/p9yiNJxtooyyRjZ9x8Mg9R9+
         xcTeCY8wIl3QYWZnHcdbfpRMyADbgD7dmIg9lW9cBgm/qPNW2stl4nrwJJUD8/g7Y2jx
         NPrache7oLL30IW0PwtIwS0vtgjQK6Rsz9tIghk+1POfpz1/VtYIMc8oCVHq/Vxxlwhn
         4biGUGm5ceL/uEoV36wev/Ptfm2LFzKpiOnuIatMfBHHorh+S7PblB7PuzYbBr59G/5M
         mo/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PyavSs+C0Q6vOcm+8BKbJUFNSTKELgNZOkPjGxwwaWU=;
        b=DSfItFRSXYnYk5sziK6+PNyrnu94qAX/ZsyNmfk/vnNnD9KZ21qAgcbohAw5Tepcpj
         e5Txz6xn8xJHK+2qtq1zg3nrisTtdZ7BEJajVh68Zv4jYO9gzy4i5tXFGoiTIb7aN8Pl
         QZI4/oIfkOhIsEwW+4HV2z7JDacAZqZS38XNHJWoPvb5+eq2tmlXQlDdg6iQoxiXimf7
         VaCYlOWZ8OqmoIICVnE8RqYvHs2hxdKF4s28+KFB3nAWdiustHWs1AF0KCa0p6wI2pGU
         vyNdhrhsHbU+1t3G4PEJTXFmvCAVeKoP7ixvChSa0lh+cGD2w4bmdGCrM7qgpGlkkV52
         TDIA==
X-Gm-Message-State: AOAM531IRzDFoe6On4dbb9xD+94jrMlEK6yn6OxEv4YNPLcwsVGU+u4L
        H7KTXFftDfStEuS/GPsqs5zf9NO1cGJYjMTYzaH3JQ==
X-Google-Smtp-Source: ABdhPJxahVmYthnRVOW1iyUvt2UQUMTcgxDe3na0u0pLsMQnpJlMz4VwcOfEBIFrVbYPDnOVwV8wdo/lS+gX0tNP0BM=
X-Received: by 2002:a05:6512:11e5:: with SMTP id p5mr2183602lfs.537.1638315128732;
 Tue, 30 Nov 2021 15:32:08 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-7-dmatlack@google.com>
 <62bd6567-bde5-7bb3-ec73-abf0e2874706@redhat.com>
In-Reply-To: <62bd6567-bde5-7bb3-ec73-abf0e2874706@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 15:31:42 -0800
Message-ID: <CALzav=d59jLY6CNL9U8_Lh_pe-BviL_oKZGCAhJcnKxGGAMF6g@mail.gmail.com>
Subject: Re: [RFC PATCH 06/15] KVM: x86/mmu: Derive page role from parent
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 20, 2021 at 4:53 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/20/21 00:57, David Matlack wrote:
> > Derive the page role from the parent shadow page, since the only thing
> > that changes is the level. This is in preparation for eagerly splitting
> > large pages during VM-ioctls which does not have access to the vCPU
> > MMU context.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >   arch/x86/kvm/mmu/tdp_mmu.c | 43 ++++++++++++++++++++------------------
> >   1 file changed, 23 insertions(+), 20 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index b70707a7fe87..1a409992a57f 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -157,23 +157,8 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
> >               if (kvm_mmu_page_as_id(_root) != _as_id) {              \
> >               } else
> >
> > -static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
> > -                                                int level)
> > -{
> > -     union kvm_mmu_page_role role;
> > -
> > -     role = vcpu->arch.mmu->mmu_role.base;
> > -     role.level = level;
> > -     role.direct = true;
> > -     role.gpte_is_8_bytes = true;
> > -     role.access = ACC_ALL;
> > -     role.ad_disabled = !shadow_accessed_mask;
> > -
> > -     return role;
> > -}
> > -
> >   static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > -                                            int level)
> > +                                            union kvm_mmu_page_role role)
> >   {
> >       struct kvm_mmu_memory_caches *mmu_caches;
> >       struct kvm_mmu_page *sp;
> > @@ -184,7 +169,7 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> >       sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
> >       set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> >
> > -     sp->role.word = page_role_for_level(vcpu, level).word;
> > +     sp->role = role;
> >       sp->gfn = gfn;
> >       sp->tdp_mmu_page = true;
> >
> > @@ -193,6 +178,19 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> >       return sp;
> >   }
> >
> > +static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
> > +{
> > +     struct kvm_mmu_page *parent_sp;
> > +     union kvm_mmu_page_role role;
> > +
> > +     parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
> > +
> > +     role = parent_sp->role;
> > +     role.level--;
> > +
> > +     return alloc_tdp_mmu_page(vcpu, iter->gfn, role);
> > +}
> > +
> >   hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >   {
> >       union kvm_mmu_page_role role;
> > @@ -201,7 +199,12 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >
> >       lockdep_assert_held_write(&kvm->mmu_lock);
> >
> > -     role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
> > +     role = vcpu->arch.mmu->mmu_role.base;
> > +     role.level = vcpu->arch.mmu->shadow_root_level;
> > +     role.direct = true;
> > +     role.gpte_is_8_bytes = true;
> > +     role.access = ACC_ALL;
> > +     role.ad_disabled = !shadow_accessed_mask;
>
> I have a similar patch for the old MMU, but it was also replacing
> shadow_root_level with shadow_root_role.  I'll see if I can adapt it to
> the TDP MMU, since the shadow_root_role is obviously the same for both.

While I was writing this patch it got me wondering if we can do an
even more general refactor and replace root_hpa and shadow_root_level
with a pointer to the root kvm_mmu_page struct. But I didn't get a
chance to look into it further.


>
> Paolo
>
> >       /* Check for an existing root before allocating a new one. */
> >       for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> > @@ -210,7 +213,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >                       goto out;
> >       }
> >
> > -     root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
> > +     root = alloc_tdp_mmu_page(vcpu, 0, role);
> >       refcount_set(&root->tdp_mmu_root_count, 1);
> >
> >       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > @@ -1028,7 +1031,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                       if (is_removed_spte(iter.old_spte))
> >                               break;
> >
> > -                     sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> > +                     sp = alloc_child_tdp_mmu_page(vcpu, &iter);
> >                       if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx))
> >                               break;
> >               }
> >
