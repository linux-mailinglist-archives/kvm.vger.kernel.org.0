Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AE7304C81
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbhAZWp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394586AbhAZSSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 13:18:33 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8E3C0613D6
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 10:17:52 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id n2so35533771iom.7
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 10:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oHm7L4oHD+rcZGnN69gO7FdD4O6QxIDjciuAvpNaxX0=;
        b=cwJv+Tz1+h7eMjfh5/Rl5UEC0x0hh/FqrrpOaZ4bCdczQ8z8TVpMtj0Rl2Nwto7wnA
         AEbyDFHNZFTRFiN5IYjf77lHon0A4jjhHA28FhkKuMqqUhfXWshuwv6dJbq9Sxv1s0LZ
         aNerBoT4il2eLBQS3tJMBSHNNN5fEI38m8934upyxQxkuqm5aSYvnEruQm8oZN9FtJ34
         npE1xMHb3HB8VX9vMyWzn8KttwaPxalL6XvkbVADoOaWtYn/h5Aqe+2wwkFpyTXqcya4
         i4hXyo4VjrtYZnYyY8E7QjTJ2/RHp4SeYh1MjoIP5tl6s2AOjbtEUUKXQ10CH+1EjgOs
         Wupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oHm7L4oHD+rcZGnN69gO7FdD4O6QxIDjciuAvpNaxX0=;
        b=ES9h6dIuEZhUENOiD+2mNHZbJaenDtC/lzgMSAYSfGInifgnKz+purITOfsNehivjc
         LaZ3oj2ohgAE2dFtwd/cJEdDQFSUtQp0CUCWbd2gswuoWcInroQFyVvgoDCDtjNhHJ9K
         /wcZtmY0ZSIwOD0siAjS7nsEOvmScYZFuRG0Alsp2+Oc+EyY67r4wUhKfnfUrFv//dyr
         vHFEuQ2Px/FJHgDcnFVE8JuGoUqvQnJdFRb/Y1ECB/crPQrKVvTRJn42UstaaJSrQ7NT
         nfd2KDqXaI6ztq43412PEORcCDmjfplhEAQPg63xCJ0oowhHji0Ba7WU8Fzt/CirBhjx
         NH9Q==
X-Gm-Message-State: AOAM532/V6GbBvt1TvALBjiv+gKQWGMBeKUK/MTX2AA6StcJRbZxNZIe
        cFIc0sdCi2TJQnuSVNyyHWk3Iwg7jIANeQBE6jqV3Q==
X-Google-Smtp-Source: ABdhPJy4F3lelY4nfexddTF5bOKxInp3Io/TZGJMRkdclnPqP73EqmEsa75IMWfNtKsCbKzmONRdFvBSEITYOj7Hy40=
X-Received: by 2002:a02:c76b:: with SMTP id k11mr5847857jao.57.1611685071272;
 Tue, 26 Jan 2021 10:17:51 -0800 (PST)
MIME-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com> <20210112181041.356734-13-bgardon@google.com>
 <YAsaIAhbjzoKcQlR@google.com>
In-Reply-To: <YAsaIAhbjzoKcQlR@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 26 Jan 2021 10:17:40 -0800
Message-ID: <CANgfPd8kVn8Oho+CXJ_4RY6Jn7MLo8hUh_8JkuMF3NgMQq3cag@mail.gmail.com>
Subject: Re: [PATCH 12/24] kvm: x86/kvm: RCU dereference tdp mmu page table links
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 22, 2021 at 10:32 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jan 12, 2021, Ben Gardon wrote:
> > In order to protect TDP MMU PT memory with RCU, ensure that page table
> > links are properly rcu_derefenced.
> >
> > Reviewed-by: Peter Feiner <pfeiner@google.com>
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_iter.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> > index 87b7e16911db..82855613ffa0 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.c
> > +++ b/arch/x86/kvm/mmu/tdp_iter.c
> > @@ -49,6 +49,8 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
> >   */
> >  u64 *spte_to_child_pt(u64 spte, int level)
> >  {
> > +     u64 *child_pt;
> > +
> >       /*
> >        * There's no child entry if this entry isn't present or is a
> >        * last-level entry.
> > @@ -56,7 +58,9 @@ u64 *spte_to_child_pt(u64 spte, int level)
> >       if (!is_shadow_present_pte(spte) || is_last_spte(spte, level))
> >               return NULL;
> >
> > -     return __va(spte_to_pfn(spte) << PAGE_SHIFT);
> > +     child_pt = __va(spte_to_pfn(spte) << PAGE_SHIFT);
> > +
> > +     return rcu_dereference(child_pt);
>
> This is what bugs me the most about the RCU usage.  We're reaping the functional
> benefits of RCU without doing the grunt work to truly RCU-ify the TDP MMU.  The
> above rcu_dereference() barely scratches the surface of what's being protected
> by RCU.  There are already multiple mechanisms that protect the page tables,
> throwing RCU into the mix without fully integrating RCU makes for simple code
> and avoids reinventing the wheel (big thumbs up), but ends up adding complexity
> to an already complex system.  E.g. the lockless walks in the old MMU are
> complex on the surface, but I find them easier to think through because they
> explicitly rely on the same mechanism (remote TLB flush) that is used to protect
> guest usage of the page tables.
>
> Ideally, I think struct kvm_mmu_page's 'u64 *spt' would be annotated with __rcu,
> as that would provide a high level of enforcement and would also highlight where
> we're using other mechanisms to ensure correctness.  E.g. dereferencing root->spt
> in kvm_tdp_mmu_get_vcpu_root_hpa() relies on the root being pinned by
> get_tdp_mmu_vcpu_root(), and _that_ in turn relies on hold rwlock for write.
> Unfortunately since kvm_mmu_page is shared with the old mmu, annotating ->spt
> that doesn't work well.  We could employ a union to make it work, but that'd
> probably do more harm than good.
>
> The middle ground would be to annotate pt_path and sptep in struct tdp_iter.
> That gets a decent chunk of the enforcement and also helps highlight what's
> being protected with RCU.  Assuming we end up going with RCU, I think this
> single rcu_dereference should be replace with something like the below patch.

Thank you for explaining your thought process here. You make an
excellent point that this results in code that is substantially less
self-documenting than it could be. It seems like your patch below will
substantially improve the automated checker's ability to validate the
RCU usage as well. I'll happily include it in the next version of this
series. I appreciate the way that the patch below makes all references
to the entries of the page table RCU dereferences. Not doing those
dereferences was certainly an error in the original patch.

>
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index 82855613ffa0..e000642d938d 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -12,7 +12,7 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
>  {
>         iter->sptep = iter->pt_path[iter->level - 1] +
>                 SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
> -       iter->old_spte = READ_ONCE(*iter->sptep);
> +       iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
>  }
>
>  static gfn_t round_gfn_for_level(gfn_t gfn, int level)
> @@ -34,7 +34,7 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
>         iter->root_level = root_level;
>         iter->min_level = min_level;
>         iter->level = root_level;
> -       iter->pt_path[iter->level - 1] = root_pt;
> +       iter->pt_path[iter->level - 1] = (tdp_ptep_t)root_pt;
>
>         iter->gfn = round_gfn_for_level(iter->goal_gfn, iter->level);
>         tdp_iter_refresh_sptep(iter);
> @@ -47,9 +47,9 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
>   * address of the child page table referenced by the SPTE. Returns null if
>   * there is no such entry.
>   */
> -u64 *spte_to_child_pt(u64 spte, int level)
> +tdp_ptep_t spte_to_child_pt(u64 spte, int level)
>  {
> -       u64 *child_pt;
> +       tdp_ptep_t child_pt;
>
>         /*
>          * There's no child entry if this entry isn't present or is a
> @@ -58,9 +58,9 @@ u64 *spte_to_child_pt(u64 spte, int level)
>         if (!is_shadow_present_pte(spte) || is_last_spte(spte, level))
>                 return NULL;
>
> -       child_pt = __va(spte_to_pfn(spte) << PAGE_SHIFT);
> +       child_pt = (tdp_ptep_t)__va(spte_to_pfn(spte) << PAGE_SHIFT);
>
> -       return rcu_dereference(child_pt);
> +       return child_pt;
>  }
>
>  /*
> @@ -69,7 +69,7 @@ u64 *spte_to_child_pt(u64 spte, int level)
>   */
>  static bool try_step_down(struct tdp_iter *iter)
>  {
> -       u64 *child_pt;
> +       tdp_ptep_t child_pt;
>
>         if (iter->level == iter->min_level)
>                 return false;
> @@ -78,7 +78,7 @@ static bool try_step_down(struct tdp_iter *iter)
>          * Reread the SPTE before stepping down to avoid traversing into page
>          * tables that are no longer linked from this entry.
>          */
> -       iter->old_spte = READ_ONCE(*iter->sptep);
> +       iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
>
>         child_pt = spte_to_child_pt(iter->old_spte, iter->level);
>         if (!child_pt)
> @@ -112,7 +112,7 @@ static bool try_step_side(struct tdp_iter *iter)
>         iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
>         iter->goal_gfn = iter->gfn;
>         iter->sptep++;
> -       iter->old_spte = READ_ONCE(*iter->sptep);
> +       iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
>
>         return true;
>  }
> @@ -175,11 +175,11 @@ void tdp_iter_refresh_walk(struct tdp_iter *iter)
>         if (iter->gfn > goal_gfn)
>                 goal_gfn = iter->gfn;
>
> -       tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
> +       tdp_iter_start(iter, rcu_dereference(iter->pt_path[iter->root_level - 1]),
>                        iter->root_level, iter->min_level, goal_gfn);
>  }
>
> -u64 *tdp_iter_root_pt(struct tdp_iter *iter)
> +tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter)
>  {
>         return iter->pt_path[iter->root_level - 1];
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 47170d0dc98e..bf882dab8ec5 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -7,6 +7,8 @@
>
>  #include "mmu.h"
>
> +typedef u64 __rcu *tdp_ptep_t;
> +
>  /*
>   * A TDP iterator performs a pre-order walk over a TDP paging structure.
>   */
> @@ -17,9 +19,9 @@ struct tdp_iter {
>          */
>         gfn_t goal_gfn;
>         /* Pointers to the page tables traversed to reach the current SPTE */
> -       u64 *pt_path[PT64_ROOT_MAX_LEVEL];
> +       tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
>         /* A pointer to the current SPTE */
> -       u64 *sptep;
> +       tdp_ptep_t sptep;
>         /* The lowest GFN mapped by the current SPTE */
>         gfn_t gfn;
>         /* The level of the root page given to the iterator */
> @@ -49,12 +51,12 @@ struct tdp_iter {
>  #define for_each_tdp_pte(iter, root, root_level, start, end) \
>         for_each_tdp_pte_min_level(iter, root, root_level, PG_LEVEL_4K, start, end)
>
> -u64 *spte_to_child_pt(u64 pte, int level);
> +tdp_ptep_t spte_to_child_pt(u64 pte, int level);
>
>  void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
>                     int min_level, gfn_t goal_gfn);
>  void tdp_iter_next(struct tdp_iter *iter);
>  void tdp_iter_refresh_walk(struct tdp_iter *iter);
> -u64 *tdp_iter_root_pt(struct tdp_iter *iter);
> +tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter);
>
>  #endif /* __KVM_X86_MMU_TDP_ITER_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 45160ff84e91..27b850904230 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -509,7 +509,7 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>                                            struct tdp_iter *iter,
>                                            u64 new_spte)
>  {
> -       u64 *root_pt = tdp_iter_root_pt(iter);
> +       tdp_ptep_t root_pt = tdp_iter_root_pt(iter);
>         struct kvm_mmu_page *root = sptep_to_sp(root_pt);
>         int as_id = kvm_mmu_page_as_id(root);
>
>
