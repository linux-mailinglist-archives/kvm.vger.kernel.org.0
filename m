Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E5A4597CE
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 23:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhKVWqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 17:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbhKVWqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 17:46:43 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C404AC061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:43:36 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id f9so25274464ioo.11
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 14:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ComYlenxaepNqQIxy+QFZ0BFnYdXo64QG/JnK43FRy0=;
        b=h38s99y6uk/SeVcv7IxePi2lhYNhs/X0nKDk+s2OvV+jqlahCpWnWK2Ea9LeAz74DZ
         8IicNWGZ/Sx2ipurlpdu3+1jI1u3WaIxDqMbDBEVK6aWnixNAnfSu+X0N8MjKHgNSQQi
         IC1qZ+t4xg5WbSec9tKuajID4jIH8qF80Uip5lABh6vEvAXVH7gQ5aR6IkzZxy0/gx+3
         tBMnIO5ifxGlF2KMVOLynZauAYvtJjhttFgV/J1T8rQu3TUvn75Tu7A/dt/SBX2L5c2g
         jdJWoQxFfE2evCG64G8Bx/8TEEv7yntfdXiBsrpB7WkEI1GuAExwWBSAUttLJPyYKQcC
         Ea8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ComYlenxaepNqQIxy+QFZ0BFnYdXo64QG/JnK43FRy0=;
        b=IDx/MaSUuWRXZFO9AbuQUrzZUKurOIWX8u30JjsGR2gTFTI+6hn2jAcrxLrEDvXrcX
         fzgGFG9+avekeO4845fEWT/YO6pPr7ZgHx2ewj/3eH27EQSQD8BHzuqNawA73D/whqHW
         aJHHbjjMoPWxtIy8kGM9nPufRIwl+XG8lgD5h7DBF8xfdwxdXsqIPsvuj13U2ihRDj1K
         9K14SBJwQsSgKdQvPw4ZI/29sbEO6Xi+PVqQo78lQ2jgKQ/pHHDGzDsAkHa7jW96FaMR
         2UWHKlUw73Jxx9U2Fa7zhlR1r3uA0fOUVybJbAQ+xZOGcMBqUh7M4X5cRP6EO1ZmqNLf
         tK+A==
X-Gm-Message-State: AOAM533bzK1c/6qGrG4hjPn6aGsiYNEHBhzfyLvdt+piqtLEIkK8mB+M
        ZYsR+Xd4z0GOh83ujh+xc0Yzaucjq9DZaqjvJG/4Ng==
X-Google-Smtp-Source: ABdhPJwdJYp/4niQRGC35vYZphY9Pz2gxrGA0Dc/7LaeQFuB1sk3FmijlHbIBEd3qNuTRheI5Pi2gELcJ9wZA4potPA=
X-Received: by 2002:a6b:5c05:: with SMTP id z5mr393798ioh.181.1637621015971;
 Mon, 22 Nov 2021 14:43:35 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-20-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-20-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 14:43:24 -0800
Message-ID: <CANgfPd83h4dXa-bFY96dkwHfJsdqu65BAzbqztgEhiRcHFquJw@mail.gmail.com>
Subject: Re: [PATCH 19/28] KVM: x86/mmu: Zap only the target TDP MMU shadow
 page in NX recovery
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

On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> When recovering a potential hugepage that was shattered for the iTLB
> multihit workaround, precisely zap only the target page instead of
> iterating over the TDP MMU to find the SP that was passed in.  This will
> allow future simplification of zap_gfn_range() by having it zap only
> leaf SPTEs.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu_internal.h |  7 ++++++-
>  arch/x86/kvm/mmu/tdp_iter.h     |  2 --
>  arch/x86/kvm/mmu/tdp_mmu.c      | 28 ++++++++++++++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.h      | 18 +-----------------
>  4 files changed, 33 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 52c6527b1a06..8ede43a826af 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -30,6 +30,8 @@ extern bool dbg;
>  #define INVALID_PAE_ROOT       0
>  #define IS_VALID_PAE_ROOT(x)   (!!(x))
>
> +typedef u64 __rcu *tdp_ptep_t;
> +
>  struct kvm_mmu_page {
>         /*
>          * Note, "link" through "spt" fit in a single 64 byte cache line on
> @@ -59,7 +61,10 @@ struct kvm_mmu_page {
>                 refcount_t tdp_mmu_root_count;
>         };
>         unsigned int unsync_children;
> -       struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
> +       union {
> +               struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
> +               tdp_ptep_t ptep;
> +       };
>         DECLARE_BITMAP(unsync_child_bitmap, 512);
>
>         struct list_head lpage_disallowed_link;
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 9c04d8677cb3..0693f1fdb81e 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -7,8 +7,6 @@
>
>  #include "mmu.h"
>
> -typedef u64 __rcu *tdp_ptep_t;
> -
>  /*
>   * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
>   * to be zapped while holding mmu_lock for read.  Holding RCU isn't required for
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7d354344924d..ea6651e735c2 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -318,12 +318,16 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>   *
>   * @kvm: kvm instance
>   * @sp: the new page
> + * @sptep: pointer to the new page's SPTE (in its parent)
>   * @account_nx: This page replaces a NX large page and should be marked for
>   *             eventual reclaim.
>   */
>  static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> -                             bool account_nx)
> +                             tdp_ptep_t sptep, bool account_nx)
>  {
> +       WARN_ON_ONCE(sp->ptep);
> +       sp->ptep = sptep;
> +
>         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>         list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
>         if (account_nx)
> @@ -755,6 +759,26 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
>         return false;
>  }
>
> +bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +       u64 old_spte;
> +
> +       rcu_read_lock();
> +
> +       old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
> +       if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte))) {
> +               rcu_read_unlock();
> +               return false;
> +       }
> +
> +       __tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> +                          sp->gfn, sp->role.level + 1, true, true);
> +
> +       rcu_read_unlock();
> +
> +       return true;
> +}
> +

Ooooh this makes me really nervous. There are a lot of gotchas to
modifying SPTEs in a new context without traversing the paging
structure like this. For example, we could modify an SPTE under an
invalidated root here. I don't think that would be a problem since
we're just clearing it, but it makes the code more fragile. Another
approach to this would be to do in-place promotion / in-place
splitting once the patch sets David and I just sent out are merged.
That would avoid causing extra page faults here to bring in the page
after this zap, but it probably wouldn't be safe if we did it under an
invalidated root.
I'd rather avoid this extra complexity and just tolerate the worse
performance on the iTLB multi hit mitigation at this point since new
CPUs seem to be moving past that vulnerability.
If you think this is worth the complexity, it'd be nice to do a little
benchmarking to make sure it's giving us a substantial improvement.

>  /*
>   * Tears down the mappings for the range of gfns, [start, end), and frees the
>   * non-root pages mapping GFNs strictly within that range. Returns true if
> @@ -1062,7 +1086,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                                                      !shadow_accessed_mask);
>
>                         if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
> -                               tdp_mmu_link_page(vcpu->kvm, sp,
> +                               tdp_mmu_link_page(vcpu->kvm, sp, iter.sptep,
>                                                   fault->huge_page_disallowed &&
>                                                   fault->req_level >= iter.level);
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index ced6d8e47362..8ad1717f4a1d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -31,24 +31,8 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
>  {
>         return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
>  }
> -static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> -{
> -       gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1);
> -
> -       /*
> -        * Don't allow yielding, as the caller may have a flush pending.  Note,
> -        * if mmu_lock is held for write, zapping will never yield in this case,
> -        * but explicitly disallow it for safety.  The TDP MMU does not yield
> -        * until it has made forward progress (steps sideways), and when zapping
> -        * a single shadow page that it's guaranteed to see (thus the mmu_lock
> -        * requirement), its "step sideways" will always step beyond the bounds
> -        * of the shadow page's gfn range and stop iterating before yielding.
> -        */
> -       lockdep_assert_held_write(&kvm->mmu_lock);
> -       return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
> -                                          sp->gfn, end, false, false);
> -}
>
> +bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm,
>                                       struct list_head *invalidated_roots);
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
