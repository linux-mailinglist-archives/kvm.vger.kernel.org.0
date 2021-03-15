Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDD633C3CE
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 18:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbhCORNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 13:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235670AbhCORNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 13:13:24 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35835C06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 10:13:24 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id z9so10084415iln.1
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 10:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rfDbdkDQbAV8D9MnmqeF04sVAETWTF4diqfpFSj3GuM=;
        b=mh87IsnwyATZnkWvHRV901OnhlV0ndWi9QiyGmhg/JSdBpKN8MUTGUm7jVwkF0hPyq
         uUC/0Wa2Sge+ye3Hr9AzSFTJdqH6w7V8JXM6NXmk9+9zMDVY4m9HtTg0aSuuOWCxWuqt
         zvs3cQFUvrxQ39ZKkk2+7ZlWJHe5B/aiuDdK0c63Q63BYyLt0DJRFqqK1VNZkRa7CZyP
         U390eZxrS6p29Z/8nDNQqonAhITg/2K/oW7qlq+YsHscKh3E6mSdgBviVAPNbeChYzaa
         +wYPwAMj+Ulwe+1rqgVPLnsG+qwAd5aLAwmIth/3UFKPO6cIxlNHm7/MzdQlFYXaIHtu
         R5BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rfDbdkDQbAV8D9MnmqeF04sVAETWTF4diqfpFSj3GuM=;
        b=UYwYOOGxWaUqmjJ1YnXBPSXySTFUEhMt/zhtRdWdmpATiDRK1k07ROQyhM/fAD+qx+
         TAKi11PHAM6nPNKDoLDkBI/qKVxsL3Uc0vTlkF9dpWeckEjj7gtVsDXZXOG82tS5Hn1A
         atQPc3Pg7nDBADI4CnLtSelx3E89HAp7KdWe/a7HHsQMjKvxIdMzEHJoIYpx1DJiiDtj
         u7nC7lrqTo3yK7hwo1M2DbH+lEfmwj4bJJgjii6g79641kq5vG8EBVUTXa5eF9oWyvTy
         ipk3KqUmQw9wb3Oh4D2813M7fSZnm4tIi/RzgpE1WXPvtWrlzguwwHLu6Y3BSeAvglTB
         AuDA==
X-Gm-Message-State: AOAM531OyKWQJJ0Zn6oCwKPpeg4zS3hIuwY8QJ5wvDM3zK/iCTo4QJYo
        gHmtE7abO3WG7K3N1Rz34ZATRX5JkOI+20WDYcQDsg==
X-Google-Smtp-Source: ABdhPJxIfyyiN2zi+IvBq17XijS7BVxQcqtP3My+ZWqfNHAOH+hkUbv/q5AHgVx7OH1dXI8se3QAuYN8lTFHYTPS8bw=
X-Received: by 2002:a92:d843:: with SMTP id h3mr518368ilq.306.1615828403498;
 Mon, 15 Mar 2021 10:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210311231658.1243953-1-bgardon@google.com> <20210311231658.1243953-3-bgardon@google.com>
 <YEuVVpySnR4Fg6bh@google.com>
In-Reply-To: <YEuVVpySnR4Fg6bh@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 15 Mar 2021 10:13:12 -0700
Message-ID: <CANgfPd_oi7GMeMNCJccuesxofQCPa1WPtzK=OnJXiR_-VR5mbA@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: x86/mmu: Fix RCU usage for tdp_iter_root_pt
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 8:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 11, 2021, Ben Gardon wrote:
> > The root page table in the TDP MMU paging structure is not protected
> > with RCU, but rather by the root_count in the associated SP. As a result
> > it is safe for tdp_iter_root_pt to simply return a u64 *. This sidesteps
> > the complexities assoicated with propagating the __rcu annotation
> > around.
> >
> > Reported-by: kernel test robot <lkp@xxxxxxxxx>
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_iter.c | 10 ++++++++--
> >  arch/x86/kvm/mmu/tdp_iter.h |  2 +-
> >  arch/x86/kvm/mmu/tdp_mmu.c  |  4 ++--
> >  3 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> > index e5f148106e20..8e2c053533b6 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.c
> > +++ b/arch/x86/kvm/mmu/tdp_iter.c
> > @@ -159,8 +159,14 @@ void tdp_iter_next(struct tdp_iter *iter)
> >       iter->valid = false;
> >  }
> >
> > -tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter)
> > +u64 *tdp_iter_root_pt(struct tdp_iter *iter)
> >  {
> > -     return iter->pt_path[iter->root_level - 1];
> > +     /*
> > +      * Though it is stored in an array of tdp_ptep_t for convenience,
> > +      * the root PT is not actually protected by RCU, but by the root
> > +      * count on the associated struct kvm_mmu_page. As a result it's
> > +      * safe to rcu_dereference and return the value here.
>
> I'm not a big fan of this comment.  It implies that calling tdp_iter_root_pt()
> without RCU protection is completely ok, but that's not true, as rcu_dereferecne()
> will complain when CONFIG_PROVE_RCU=1.
>
> There's also a good opportunity to streamline the the helper here, since both
> callers use the root only to get to the associated shadow page, and that's only
> done to get the as_id.  If we provide tdp_iter_as_id() then the need for a
> comment goes away and we shave a few lines of code.

This is a good suggestion. I have a change to do this in another
series I was preparing to send out, but your suggestion below is even
better, so I'll add that to this series.

>
> That being said, an even better option would be to store as_id in the TDP iter.
> The cost on the stack is negligible, and while the early sptep->as_id lookup
> will be unnecessary in some cases, it will be a net win when setting multiple
> sptes, e.g. in mmu_notifier callbacks.
>
> Compile tested only...
>
> From 02fb9cd2aa52d0afd318e93661d0212ccdb54218 Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 12 Mar 2021 08:12:21 -0800
> Subject: [PATCH] KVM: x86/mmu: Store the address space ID in the TDP iterator
>
> Store the address space ID in the TDP iterator so that it can be
> retrieved without having to bounce through the root shadow page.  This
> streamlines the code and fixes a Sparse warning about not properly using
> rcu_dereference() when grabbing the ID from the root on the fly.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
>  arch/x86/kvm/mmu/tdp_iter.c     |  7 +------
>  arch/x86/kvm/mmu/tdp_iter.h     |  3 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 23 +++++------------------
>  4 files changed, 13 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index ec4fc28b325a..e844078d2374 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -119,6 +119,11 @@ static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
>         return !sp->root_count;
>  }
>
> +static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
> +{
> +       return sp->role.smm ? 1 : 0;
> +}
> +
>  /*
>   * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
>   *
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index e5f148106e20..55d0ce2185a5 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -40,6 +40,7 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
>         iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
>         tdp_iter_refresh_sptep(iter);
>
> +       iter->as_id = kvm_mmu_page_as_id(sptep_to_sp(root_pt));
>         iter->valid = true;
>  }
>
> @@ -158,9 +159,3 @@ void tdp_iter_next(struct tdp_iter *iter)
>         } while (try_step_up(iter));
>         iter->valid = false;
>  }
> -
> -tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter)
> -{
> -       return iter->pt_path[iter->root_level - 1];
> -}
> -
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 4cc177d75c4a..df9c84713f5b 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -36,6 +36,8 @@ struct tdp_iter {
>         int min_level;
>         /* The iterator's current level within the paging structure */
>         int level;
> +       /* The address space ID, i.e. SMM vs. regular. */
> +       int as_id;
>         /* A snapshot of the value at sptep */
>         u64 old_spte;
>         /*
> @@ -62,6 +64,5 @@ tdp_ptep_t spte_to_child_pt(u64 pte, int level);
>  void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
>                     int min_level, gfn_t next_last_level_gfn);
>  void tdp_iter_next(struct tdp_iter *iter);
> -tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter);
>
>  #endif /* __KVM_X86_MMU_TDP_ITER_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 21cbbef0ee57..9f436aa14663 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -190,11 +190,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>                                 u64 old_spte, u64 new_spte, int level,
>                                 bool shared);
>
> -static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
> -{
> -       return sp->role.smm ? 1 : 0;
> -}
> -
>  static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
>  {
>         if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
> @@ -472,10 +467,6 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>                                            struct tdp_iter *iter,
>                                            u64 new_spte)
>  {
> -       u64 *root_pt = tdp_iter_root_pt(iter);
> -       struct kvm_mmu_page *root = sptep_to_sp(root_pt);
> -       int as_id = kvm_mmu_page_as_id(root);
> -
>         lockdep_assert_held_read(&kvm->mmu_lock);
>
>         /*
> @@ -489,8 +480,8 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>                       new_spte) != iter->old_spte)
>                 return false;
>
> -       handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
> -                           iter->level, true);
> +       handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> +                           new_spte, iter->level, true);
>
>         return true;
>  }
> @@ -544,10 +535,6 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>                                       u64 new_spte, bool record_acc_track,
>                                       bool record_dirty_log)
>  {
> -       tdp_ptep_t root_pt = tdp_iter_root_pt(iter);
> -       struct kvm_mmu_page *root = sptep_to_sp(root_pt);
> -       int as_id = kvm_mmu_page_as_id(root);
> -
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
>         /*
> @@ -561,13 +548,13 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
>
>         WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
>
> -       __handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
> -                             iter->level, false);
> +       __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> +                             new_spte, iter->level, false);
>         if (record_acc_track)
>                 handle_changed_spte_acc_track(iter->old_spte, new_spte,
>                                               iter->level);
>         if (record_dirty_log)
> -               handle_changed_spte_dirty_log(kvm, as_id, iter->gfn,
> +               handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
>                                               iter->old_spte, new_spte,
>                                               iter->level);
>  }
> --
