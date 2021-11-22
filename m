Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152EA459744
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 23:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhKVWXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 17:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhKVWXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 17:23:47 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8341CC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:20:40 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id k1so19682128ilo.7
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CmqVwNzUDpZoH6bsvYXYEHqpdVF8n0sF5oZqJr68Q4U=;
        b=VZ7G7DGSBqNwZxgA1/jlUhqnZYwGAuwK2WI3FO+X16sMxle36ROOGVqbwi1rdH2QIt
         mluxaznXS+wc6uixdPJYoEVZNcl7nBC/Y1uPTwRBEfH1BMLzhLyNkGlHewNg411x8qAs
         hfHdR6gvln/6iDNUB5XfSC1w3u5WfgaB9+sbxBODrMtiieMIgsIQ3hBcF2dk3qdLT7et
         tzueWVazZ33ofncYXMJgkTJ0e2gvkxDoFwTx00sUwVs/lUliEs4Gnghz/omakritVkrY
         w/MCH3IpgCC8FWZfiyXKSk6nrN4ZHu1d/JNg3FsZTxl292f7J4oo+3yJRMA2Zg1+16us
         du0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CmqVwNzUDpZoH6bsvYXYEHqpdVF8n0sF5oZqJr68Q4U=;
        b=CKD4iFj+ZzeDfaxMvBw3JQcB8WG23bCusExTz4nD8Qhe540v1x3iqhtSQkA0UcT6pK
         0Yffjv5lGmdwVKpHH8imgeCQsEJoBvIizqFNwdh8Kge7vjtUkf+Z56qgN4kim0soKh+x
         AicGpwz/JpfeZ+kn1T0SwCFAnrbQeE9CANLbWExbHKA0Tsnxe8fl+FkfDKUQHsGAUOUu
         G5DE4kit9hyqQgPpaNIJMIupSkQt+OFT+lgjwUWZ5LzpTIWBuaxlR2vpzRxt5Q61yEcD
         Y7AQR5nR1fZpXW6gx8aoxCu/Y2pa1IU9wg0XfBMVxjAll1VqAHI8hYoMmMOA0BLDjZLt
         c6ew==
X-Gm-Message-State: AOAM530zSVG2R6KQWAmdho9tWRTOxUj5tHB7P10RKjhnjiirCLPl/2cm
        xVS7XEz9DWtGEf8H0H1YV8wERJSuyns3CYwq8CGAbA==
X-Google-Smtp-Source: ABdhPJwQfNtrZU53DDgpMGF+qBzdFfBhgZzG+fcOicmOqJ5ekfYzoNXN1wbndukW/B6rvBydRBIEtF61G0bahf1a9OM=
X-Received: by 2002:a92:cda2:: with SMTP id g2mr402777ild.2.1637619639542;
 Mon, 22 Nov 2021 14:20:39 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-16-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-16-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 14:20:28 -0800
Message-ID: <CANgfPd8Kz41FpvooznGW2VLp8GZFei28FCjonr2+YEZoturi0A@mail.gmail.com>
Subject: Re: [PATCH 15/28] KVM: x86/mmu: Take TDP MMU roots off list when
 invalidating all roots
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"/

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Take TDP MMU roots off the list of roots when they're invalidated instead
> of walking later on to find the roots that were just invalidated.  In
> addition to making the flow more straightforward, this allows warning
> if something attempts to elevate the refcount of an invalid root, which
> should be unreachable (no longer on the list so can't be reached by MMU
> notifier, and vCPUs must reload a new root before installing new SPTE).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

There are a bunch of awesome little cleanups and unrelated fixes
included in this commit that could be factored out.

I'm skeptical of immediately moving the invalidated roots into another
list as that seems like it has a lot of potential for introducing
weird races. I'm not sure it actually solves a problem either. Part of
the motive from the commit description "this allows warning if
something attempts to elevate the refcount of an invalid root" can be
achieved already without moving the roots into a separate list.

Maybe this would seem more straightforward with some of the little
cleanups factored out, but this feels more complicated to me.

> ---
>  arch/x86/kvm/mmu/mmu.c     |   6 +-
>  arch/x86/kvm/mmu/tdp_mmu.c | 171 ++++++++++++++++++++-----------------
>  arch/x86/kvm/mmu/tdp_mmu.h |  14 ++-
>  3 files changed, 108 insertions(+), 83 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e00e46205730..e3cd330c9532 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5664,6 +5664,8 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>   */
>  static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  {
> +       LIST_HEAD(invalidated_roots);
> +
>         lockdep_assert_held(&kvm->slots_lock);
>
>         write_lock(&kvm->mmu_lock);
> @@ -5685,7 +5687,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>          * could drop the MMU lock and yield.
>          */
>         if (is_tdp_mmu_enabled(kvm))
> -               kvm_tdp_mmu_invalidate_all_roots(kvm);
> +               kvm_tdp_mmu_invalidate_all_roots(kvm, &invalidated_roots);
>
>         /*
>          * Notify all vcpus to reload its shadow page table and flush TLB.
> @@ -5703,7 +5705,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>
>         if (is_tdp_mmu_enabled(kvm)) {
>                 read_lock(&kvm->mmu_lock);
> -               kvm_tdp_mmu_zap_invalidated_roots(kvm);
> +               kvm_tdp_mmu_zap_invalidated_roots(kvm, &invalidated_roots);
>                 read_unlock(&kvm->mmu_lock);
>         }
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ca6b30a7130d..085f6b09e5f3 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -94,9 +94,17 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>
>         WARN_ON(!root->tdp_mmu_page);
>
> -       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -       list_del_rcu(&root->link);
> -       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +       /*
> +        * Remove the root from tdp_mmu_roots, unless the root is invalid in
> +        * which case the root was pulled off tdp_mmu_roots when it was
> +        * invalidated.  Note, this must be an RCU-protected deletion to avoid
> +        * use-after-free in the yield-safe iterator!
> +        */
> +       if (!root->role.invalid) {
> +               spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +               list_del_rcu(&root->link);
> +               spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +       }
>
>         /*
>          * A TLB flush is not necessary as KVM performs a local TLB flush when
> @@ -105,18 +113,23 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>          * invalidates any paging-structure-cache entries, i.e. TLB entries for
>          * intermediate paging structures, that may be zapped, as such entries
>          * are associated with the ASID on both VMX and SVM.
> +        *
> +        * WARN if a flush is reported for an invalid root, as its child SPTEs
> +        * should have been zapped by kvm_tdp_mmu_zap_invalidated_roots(), and
> +        * inserting new SPTEs under an invalid root is a KVM bug.
>          */
> -       (void)zap_gfn_range(kvm, root, 0, -1ull, true, false, shared);
> +       if (zap_gfn_range(kvm, root, 0, -1ull, true, false, shared))
> +               WARN_ON_ONCE(root->role.invalid);
>
>         call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
>
>  /*
> - * Finds the next valid root after root (or the first valid root if root
> - * is NULL), takes a reference on it, and returns that next root. If root
> - * is not NULL, this thread should have already taken a reference on it, and
> - * that reference will be dropped. If no valid root is found, this
> - * function will return NULL.
> + * Finds the next root after @prev_root (or the first root if @prev_root is NULL
> + * or invalid), takes a reference on it, and returns that next root.  If root is
> + * not NULL, this thread should have already taken a reference on it, and that
> + * reference will be dropped. If no valid root is found, this function will
> + * return NULL.
>   */
>  static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>                                               struct kvm_mmu_page *prev_root,
> @@ -124,6 +137,27 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  {
>         struct kvm_mmu_page *next_root;
>
> +       lockdep_assert_held(&kvm->mmu_lock);
> +
> +       /*
> +        * Restart the walk if the previous root was invalidated, which can
> +        * happen if the caller drops mmu_lock when yielding.  Restarting the
> +        * walke is necessary because invalidating a root also removes it from

Nit: *walk

> +        * tdp_mmu_roots.  Restarting is safe and correct because invalidating
> +        * a root is done if and only if _all_ roots are invalidated, i.e. any
> +        * root on tdp_mmu_roots was added _after_ the invalidation event.
> +        */
> +       if (prev_root && prev_root->role.invalid) {
> +               kvm_tdp_mmu_put_root(kvm, prev_root, shared);
> +               prev_root = NULL;
> +       }
> +
> +       /*
> +        * Finding the next root must be done under RCU read lock.  Although
> +        * @prev_root itself cannot be removed from tdp_mmu_roots because this
> +        * task holds a reference, its next and prev pointers can be modified
> +        * when freeing a different root.  Ditto for tdp_mmu_roots itself.
> +        */

I'm not sure this is correct with the rest of the changes in this
patch. The new version of invalidate_roots removes roots from the list
immediately, even if they have a non-zero ref-count.

>         rcu_read_lock();
>
>         if (prev_root)
> @@ -230,10 +264,13 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>         root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
>         refcount_set(&root->tdp_mmu_root_count, 1);
>
> -       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -       list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
> -       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> -
> +       /*
> +        * Because mmu_lock must be held for write to ensure that KVM doesn't
> +        * create multiple roots for a given role, this does not need to use
> +        * an RCU-friendly variant as readers of tdp_mmu_roots must also hold
> +        * mmu_lock in some capacity.
> +        */

I doubt we're doing it now, but in principle we could allocate new
roots with mmu_lock in read + tdp_mmu_pages_lock. That might be better
than depending on the write lock.

> +       list_add(&root->link, &kvm->arch.tdp_mmu_roots);
>  out:
>         return __pa(root->spt);
>  }
> @@ -814,28 +851,6 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>                 kvm_flush_remote_tlbs(kvm);
>  }
>
> -static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
> -                                                 struct kvm_mmu_page *prev_root)
> -{
> -       struct kvm_mmu_page *next_root;
> -
> -       if (prev_root)
> -               next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
> -                                                 &prev_root->link,
> -                                                 typeof(*prev_root), link);
> -       else
> -               next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
> -                                                  typeof(*next_root), link);
> -
> -       while (next_root && !(next_root->role.invalid &&
> -                             refcount_read(&next_root->tdp_mmu_root_count)))
> -               next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
> -                                                 &next_root->link,
> -                                                 typeof(*next_root), link);
> -
> -       return next_root;
> -}
> -
>  /*
>   * Since kvm_tdp_mmu_zap_all_fast has acquired a reference to each
>   * invalidated root, they will not be freed until this function drops the
> @@ -844,22 +859,21 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
>   * only has to do a trivial amount of work. Since the roots are invalid,
>   * no new SPTEs should be created under them.
>   */
> -void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
> +void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm,
> +                                      struct list_head *invalidated_roots)
>  {
> -       struct kvm_mmu_page *next_root;
> -       struct kvm_mmu_page *root;
> +       struct kvm_mmu_page *root, *tmp;
>
> +       lockdep_assert_held(&kvm->slots_lock);
>         lockdep_assert_held_read(&kvm->mmu_lock);
>
> -       rcu_read_lock();
> -
> -       root = next_invalidated_root(kvm, NULL);
> -
> -       while (root) {
> -               next_root = next_invalidated_root(kvm, root);
> -
> -               rcu_read_unlock();
> -
> +       /*
> +        * Put the ref to each root, acquired by kvm_tdp_mmu_put_root().  The

Nit: s/kvm_tdp_mmu_put_root/kvm_tdp_mmu_get_root/

> +        * safe variant is required even though kvm_tdp_mmu_put_root() doesn't
> +        * explicitly remove the root from the invalid list, as this task does
> +        * not take rcu_read_lock() and so the list object itself can be freed.
> +        */
> +       list_for_each_entry_safe(root, tmp, invalidated_roots, link) {
>                 /*
>                  * A TLB flush is unnecessary, invalidated roots are guaranteed
>                  * to be unreachable by the guest (see kvm_tdp_mmu_put_root()
> @@ -870,49 +884,50 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>                  * blip and not a functional issue.
>                  */
>                 (void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
> -
> -               /*
> -                * Put the reference acquired in
> -                * kvm_tdp_mmu_invalidate_roots
> -                */
>                 kvm_tdp_mmu_put_root(kvm, root, true);
> -
> -               root = next_root;
> -
> -               rcu_read_lock();
>         }
> -
> -       rcu_read_unlock();
>  }
>
>  /*
> - * Mark each TDP MMU root as invalid so that other threads
> - * will drop their references and allow the root count to
> - * go to 0.
> + * Mark each TDP MMU root as invalid so that other threads will drop their
> + * references and allow the root count to go to 0.
>   *
> - * Also take a reference on all roots so that this thread
> - * can do the bulk of the work required to free the roots
> - * once they are invalidated. Without this reference, a
> - * vCPU thread might drop the last reference to a root and
> - * get stuck with tearing down the entire paging structure.
> + * Take a reference on each root and move it to a local list so that this task
> + * can do the actual work required to free the roots once they are invalidated,
> + * e.g. zap the SPTEs and trigger a remote TLB flush. Without this reference, a
> + * vCPU task might drop the last reference to a root and get stuck with tearing
> + * down the entire paging structure.
>   *
> - * Roots which have a zero refcount should be skipped as
> - * they're already being torn down.
> - * Already invalid roots should be referenced again so that
> - * they aren't freed before kvm_tdp_mmu_zap_all_fast is
> - * done with them.
> + * Roots which have a zero refcount are skipped as they're already being torn
> + * down.  Encountering a root that is already invalid is a KVM bug, as this is
> + * the only path that is allowed to invalidate roots and (a) it's proteced by

Nit: protected

> + * slots_lock and (b) pulls each root off tdp_mmu_roots.
>   *
> - * This has essentially the same effect for the TDP MMU
> - * as updating mmu_valid_gen does for the shadow MMU.
> + * This has essentially the same effect for the TDP MMU as updating
> + * mmu_valid_gen does for the shadow MMU.
>   */
> -void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
> +void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm,
> +                                     struct list_head *invalidated_roots)
>  {
> -       struct kvm_mmu_page *root;
> +       struct kvm_mmu_page *root, *tmp;
>
> +       /*
> +        * mmu_lock must be held for write, moving entries off an RCU-protected
> +        * list is not safe, entries can only be deleted.   All accesses to
> +        * tdp_mmu_roots are required to hold mmu_lock in some capacity, thus
> +        * holding it for write ensures there are no concurrent readers.
> +        */
>         lockdep_assert_held_write(&kvm->mmu_lock);
> -       list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
> -               if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
> -                       root->role.invalid = true;
> +
> +       list_for_each_entry_safe(root, tmp, &kvm->arch.tdp_mmu_roots, link) {
> +               if (!kvm_tdp_mmu_get_root(root))
> +                       continue;
> +
> +               list_move_tail(&root->link, invalidated_roots);
> +
> +               WARN_ON_ONCE(root->role.invalid);
> +               root->role.invalid = true;
> +       }
>  }
>
>  /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 599714de67c3..ced6d8e47362 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -9,7 +9,13 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
>
>  __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
>  {
> -       if (root->role.invalid)
> +       /*
> +        * Acquiring a reference on an invalid root is a KVM bug.  Invalid roots
> +        * are supposed to be reachable only by references that were acquired
> +        * before the invalidation, and taking an additional reference to an
> +        * invalid root is not allowed.
> +        */
> +       if (WARN_ON_ONCE(root->role.invalid))
>                 return false;
>
>         return refcount_inc_not_zero(&root->tdp_mmu_root_count);
> @@ -44,8 +50,10 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  }
>
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> -void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
> -void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
> +void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm,
> +                                     struct list_head *invalidated_roots);
> +void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm,
> +                                      struct list_head *invalidated_roots);
>
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
