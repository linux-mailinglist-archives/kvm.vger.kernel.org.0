Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFDE459525
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhKVS4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238838AbhKVSz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:55:59 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E787BC061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:52:52 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id s14so19154746ilv.10
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f/NdVuX5spHbc6P/VzCT2ltBqXcr+X7sWBYW0mi6yxQ=;
        b=H7TMBxQ5SBi8qRq7ykr0f6x78QpQS94WRtF/OPOMiQ4rSkFbfV/ZOoaX/QTzF6AMtO
         lUTLDSZN53lOMWp+ClaZ4HL7jEFOhVTRfx1O/5JOkN5G8ASrcMZsfQxGeBIDg/69Jxka
         53UuBHcnCpodm2uHVE5T++2xpdBPDWxPGBCtsc6xhsTF5xjjE8tqspH1WAZettUanwGz
         k4Yr+cpVMgXcUIFDospsk4gw/SVKJRfdNaY4Kcn0oVjAXJnZiO9BCsEscPa6ZLypUa/8
         pbseipwDF3C4qCFgQ/ogg4nSwFrWAvf4ucod7m1StKiWskl2UX8c8uwgHsMbqEoyauPp
         TQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f/NdVuX5spHbc6P/VzCT2ltBqXcr+X7sWBYW0mi6yxQ=;
        b=2CwyEQwbVANBvZMa68swjJcBs5fhmhH/uwd3ZvabtVOXknQ3oQudu9GhIStfv4dQ06
         vX4UgHaCKHtdIULD3JU7Wy25Sa41g11vx59zmB2Az4uxq9KFWlXoGzGx98IZFemXhfZE
         Tah4iJTVVAwHA+7h+LjBMje0HSw/fvfpWmOgRqvgVs8MY/FYleYJh67kMvn6YtXzpHfn
         C/3kn4BAGQXHTbOLaKODG/jEXdtTE8ttm216LScEhWbifgYdcAOPao+nnWU/zzbO7n4/
         Y+p4kg5hSkSNOMuNJ10DbYwaXMm6xi7qxwVrFxD5jzANLQyGi78tzTlbaAcWAYcusKsl
         yd/w==
X-Gm-Message-State: AOAM530bcoXdw6x3UWjzg7s8dmhvCukSyoUPJbPTmr4k2miYqcsOTsVD
        SdbKIoBrm7cW4DdTJrnh1OIZoet6507YDF4QMxVFxw==
X-Google-Smtp-Source: ABdhPJzFXituynjQ9c0c8NXYsUFcHxnIPYqNVy5CwUZDd3vlz3CDyOT0r1eFWaUv6pst+TCworyFuRfKyRgarRIoxhU=
X-Received: by 2002:a05:6e02:1809:: with SMTP id a9mr21271523ilv.203.1637607172162;
 Mon, 22 Nov 2021 10:52:52 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-4-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-4-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:52:41 -0800
Message-ID: <CANgfPd_uoM930c1LsQbRX_JRz9+ofnCxzHs6t9O6a7LSCYCaYg@mail.gmail.com>
Subject: Re: [RFC PATCH 03/15] KVM: x86/mmu: Automatically update
 iter->old_spte if cmpxchg fails
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
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

On Fri, Nov 19, 2021 at 3:58 PM David Matlack <dmatlack@google.com> wrote:
>
> Consolidate a bunch of code that was manually re-reading the spte if the
> cmpxchg fails. There is no extra cost of doing this because we already
> have the spte value as a result of the cmpxchg (and in fact this
> eliminates re-reading the spte), and none of the call sites depend on
> iter->old_spte retaining the stale spte value.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 56 ++++++++++++--------------------------
>  1 file changed, 18 insertions(+), 38 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 377a96718a2e..cc9fe33c9b36 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -492,16 +492,22 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   * and handle the associated bookkeeping.  Do not mark the page dirty
>   * in KVM's dirty bitmaps.
>   *
> + * If setting the SPTE fails because it has changed, iter->old_spte will be
> + * updated with the updated value of the spte.
> + *
>   * @kvm: kvm instance
>   * @iter: a tdp_iter instance currently on the SPTE that should be set
>   * @new_spte: The value the SPTE should be set to
>   * Returns: true if the SPTE was set, false if it was not. If false is returned,
> - *         this function will have no side-effects.
> + *          this function will have no side-effects other than updating
> + *          iter->old_spte to the latest value of spte.
>   */
>  static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>                                            struct tdp_iter *iter,
>                                            u64 new_spte)
>  {
> +       u64 old_spte;
> +
>         lockdep_assert_held_read(&kvm->mmu_lock);
>
>         /*
> @@ -515,9 +521,11 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>          * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
>          * does not hold the mmu_lock.
>          */
> -       if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
> -                     new_spte) != iter->old_spte)
> +       old_spte = cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte, new_spte);

This probably deserves a comment:

/*
 * If the old_spte values differ, the cmpxchg failed. Update
iter->old_spte with the value inserted by
 * another thread.
 */

> +       if (old_spte != iter->old_spte) {
> +               iter->old_spte = old_spte;
>                 return false;
> +       }
>
>         __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
>                               new_spte, iter->level, true);
> @@ -747,14 +755,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                 if (!shared) {
>                         tdp_mmu_set_spte(kvm, &iter, 0);
>                         flush = true;
> -               } else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
> -                       /*
> -                        * The iter must explicitly re-read the SPTE because
> -                        * the atomic cmpxchg failed.
> -                        */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));

I think kernel style is to include the curly braces on the else if, if
the if had them.


> +               } else if (!tdp_mmu_zap_spte_atomic(kvm, &iter))
>                         goto retry;
> -               }
>         }
>
>         rcu_read_unlock();
> @@ -978,13 +980,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                     is_large_pte(iter.old_spte)) {
>                         if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
>                                 break;
> -
> -                       /*
> -                        * The iter must explicitly re-read the spte here
> -                        * because the new value informs the !present
> -                        * path below.
> -                        */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
>                 }
>
>                 if (!is_shadow_present_pte(iter.old_spte)) {
> @@ -1190,14 +1185,9 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>
>                 new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
>
> -               if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
> -                       /*
> -                        * The iter must explicitly re-read the SPTE because
> -                        * the atomic cmpxchg failed.
> -                        */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +               if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
>                         goto retry;
> -               }
> +
>                 spte_set = true;
>         }
>
> @@ -1258,14 +1248,9 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>                                 continue;
>                 }
>
> -               if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
> -                       /*
> -                        * The iter must explicitly re-read the SPTE because
> -                        * the atomic cmpxchg failed.
> -                        */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +               if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
>                         goto retry;
> -               }
> +
>                 spte_set = true;
>         }
>
> @@ -1391,14 +1376,9 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
>                                                             pfn, PG_LEVEL_NUM))
>                         continue;
>
> -               if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
> -                       /*
> -                        * The iter must explicitly re-read the SPTE because
> -                        * the atomic cmpxchg failed.
> -                        */
> -                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +               if (!tdp_mmu_zap_spte_atomic(kvm, &iter))
>                         goto retry;
> -               }
> +
>                 flush = true;
>         }
>
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
