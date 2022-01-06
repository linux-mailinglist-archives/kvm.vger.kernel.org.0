Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685FF486D79
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 00:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245330AbiAFXBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 18:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245283AbiAFXBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 18:01:24 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6599FC061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 15:01:23 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id k21so9212455lfu.0
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 15:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZ22PYR3/dRtUQ9oWQ8BhD/GwOvblXZFGzyR7cLqU+g=;
        b=AgmG2tul/nA0yW+uFon0cg8iFMORE/DN9c1WA80eNRyIN6YfZM+7GTkXW2uQ6ksDCU
         kKS3YnlOGCvtrcj+dPxKgi2xeY0cUBK2M/yQDfTaAdXo999xWQHQPo2ejMQsKPnJW6U4
         gE3aKH+Nc28kNDRjZma2yT9hM2VuXPYZraYAN62pE+2iV19obHekYFUChdK83QQOcPmV
         zo7ZR/mrRdnsoU2lJhFAER6Zm5iJ4zQo0c1ft4C4h1+PKGLEa9odrcyeJvgHxm6/iqfq
         KqOnGkTopDkhJHTniP2tEbsQNtyvzmTr5M74jpCfgclz4pE/Z9dLHhLCTZV+xpLRaUhq
         pEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZ22PYR3/dRtUQ9oWQ8BhD/GwOvblXZFGzyR7cLqU+g=;
        b=UXurd0NSWCzqMlu467UrKSMOymNhaRRInfpePreAnymdTmHSPA8XevXw98uKmnaCtg
         /TODyAqwQwSXhaB9VCRjHl3xpdmBIakTNX79EgLKahkpsoWu7n9E32vh8TcvvPF7HySZ
         coOD9s+dsc0zLSx+A47PT41DBi7H8G928ahFX8e4shwklrvvs9gkxZ+ZRSklpLeJVRpP
         9081EaydS+Cuh9l/iT3NoGe/CIdz9VrLquujvKyUANjSAd9/MYeDXRaozl/P8SLEahgt
         MQgBl5gzZPXzDWbs3DmvwltCXMBPXf+OPIIDtG3lA5OchdVr+2UHx3TaaLJGlOOq6ms+
         espQ==
X-Gm-Message-State: AOAM530sWRRm+R0++STzSLn/ar1gN7qWHl7neZB35c7XpRuHtHoCpaQg
        IXhzkXy/2On8hgeSa/bRTb4aaGqGZPS7emOdZNWezw==
X-Google-Smtp-Source: ABdhPJx0NfL+wfuv5mAEfHQap36zwXNGxi5+huWmePh+0E3h3f0GkpcEWivE+ZCM/9h9Q7PAr+dqUi8DHc/UBlzkzfk=
X-Received: by 2002:ac2:5388:: with SMTP id g8mr52799648lfh.64.1641510081571;
 Thu, 06 Jan 2022 15:01:21 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-8-dmatlack@google.com>
 <YddUz+SanLUgi+jd@google.com>
In-Reply-To: <YddUz+SanLUgi+jd@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 6 Jan 2022 15:00:55 -0800
Message-ID: <CALzav=cRxn+ce_AOxnRc7TpnH5fkyFf5aM4tWM5THZwRmgvvGQ@mail.gmail.com>
Subject: Re: [PATCH v1 07/13] KVM: x86/mmu: Derive page role from parent
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

On Thu, Jan 6, 2022 at 12:45 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Please include "TDP MMU" somewhere in the shortlog.  It's a nice to have, e.g. not
> worth forcing if there's more interesting info to put in the shortlog, but in this
> case there are plenty of chars to go around.  E.g.
>
>   KVM: x86/mmu: Derive page role for TDP MMU shadow pages from parent
>
> On Mon, Dec 13, 2021, David Matlack wrote:
> > Derive the page role from the parent shadow page, since the only thing
> > that changes is the level. This is in preparation for eagerly splitting
> > large pages during VM-ioctls which does not have access to the vCPU
>
> s/does/do since VM-ioctls is plural.
>
> > MMU context.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 43 ++++++++++++++++++++------------------
> >  1 file changed, 23 insertions(+), 20 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 2fb2d7677fbf..582d9a798899 100644
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
> > -     role.has_4_byte_gpte = false;
> > -     role.access = ACC_ALL;
> > -     role.ad_disabled = !shadow_accessed_mask;
> > -
> > -     return role;
> > -}
> > -
> >  static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > -                                            int level)
> > +                                            union kvm_mmu_page_role role)
> >  {
> >       struct kvm_mmu_page *sp;
> >
> > @@ -181,7 +166,7 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> >       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> >       set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> >
> > -     sp->role.word = page_role_for_level(vcpu, level).word;
> > +     sp->role = role;
> >       sp->gfn = gfn;
> >       sp->tdp_mmu_page = true;
> >
> > @@ -190,6 +175,19 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> >       return sp;
> >  }
> >
> > +static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
>
> Newline please, this is well over 80 chars.
>
> static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu,
>                                                      struct tdp_iter *iter)
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
> >  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >  {
> >       union kvm_mmu_page_role role;
> > @@ -198,7 +196,12 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >
> >       lockdep_assert_held_write(&kvm->mmu_lock);
> >
> > -     role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
> > +     role = vcpu->arch.mmu->mmu_role.base;
> > +     role.level = vcpu->arch.mmu->shadow_root_level;
> > +     role.direct = true;
> > +     role.has_4_byte_gpte = false;
> > +     role.access = ACC_ALL;
> > +     role.ad_disabled = !shadow_accessed_mask;
>
> Hmm, so _all_ of this unnecessary, i.e. this can simply be:
>
>         role = vcpu->arch.mmu->mmu_role.base;
>
> Probably better to handle everything except .level in a separate prep commit.
>
> I'm not worried about the cost, I want to avoid potential confusion as to why the
> TDP MMU is apparently "overriding" these fields.

All great suggestions. I'll include these changes in the next version,
including an additional patch to eliminate the redundant role
overrides.
