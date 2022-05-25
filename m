Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A421C5346EF
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 01:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343812AbiEYXMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 19:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiEYXMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 19:12:41 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA529A5AAE
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 16:12:40 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id l32so192129ybe.12
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 16:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3HuIP+nqyRF8L6y+wKn2Kh5on79F68UHyTPuqohrHwM=;
        b=q91bENJS36gM/g/TdQqB4Dce/yHUDCheW9UcqVc+r6FHL58HqxubbiTYJ3FLTW44a2
         +G0B4dqus4vH2qKiK7YGQzVwYjYuZfkgN1tRqGiOFaH1mnar8LzaYXNr7y8YH9U4qnAq
         3FGscSxCQ+AtZXwiAgfpgZsEub7cJo+J8zZ2xzGjRp/l1Ubf+/XGGmHM6NN4IcKXjnyI
         ddy7gxQWa6WevgyCmjZpE79fJPgQjmXMqKRuQrmrksQY+/qh9r50ao0y/GPWmKKSfIgc
         M7DrvoDulU6PKEb6YUv2EigGAlfTeoZrM1pn31EZ5+COO/wq7/ppBRWfwPnVMYHBosQL
         6oOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3HuIP+nqyRF8L6y+wKn2Kh5on79F68UHyTPuqohrHwM=;
        b=i5rgMz1D+C3p20SA2Bp8jX0I21ueXrN+kkmQG7RDDSZAZyc9g4s9Jt+zZ1KUTKZauF
         1imMJKDe+43uUAdPbko8aEBiR86EVwGo8PNVI1eWDj8LURLEb/Pq2qXUouqryir/am6q
         kWAqy+NlbC8SKSwGOoMX8Y9DvvjHRssveKfwfwRriT41d4CVhyaqp+PpxOyGuwJRIVTU
         +ophE4XPTsTwrzat7K12GDCK1WgrlRmgDCZvc18rVlfa8H1kXqBRgAfu/im9EU4PvcFV
         pjS8eQplOOFfPXdrLZ8MLMgLQwUkRxB/KNGQ+hI3ieyKO1o7fM1Ud2Uzahs3uG2GSIVu
         8Vrw==
X-Gm-Message-State: AOAM531rMJsOiUHBLYXAAw1kHifgRLzLDcPQRVqGUZw/3qGtx3qSUqV4
        oppERcYc46J09v1bLkI+WohpkaBtVtyy60hunokmsUTCp9E=
X-Google-Smtp-Source: ABdhPJyrQ2S2TunXpaQgZOmPdY1edI4RpJY11bn4MV/y7D6VHM+K5o1LfXQ3ula+dBT0F+mTxWiYwtQ2cQYobfINZa0=
X-Received: by 2002:a05:6902:1202:b0:64f:5209:f44d with SMTP id
 s2-20020a056902120200b0064f5209f44dmr30345604ybu.562.1653520359638; Wed, 25
 May 2022 16:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220525230904.1584480-1-bgardon@google.com>
In-Reply-To: <20220525230904.1584480-1-bgardon@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 25 May 2022 16:12:28 -0700
Message-ID: <CANgfPd-PiULe2eSaSK1BiHgWZ8z54vJfjbc5GaDfexi8x5eorQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty logging
To:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 4:09 PM Ben Gardon <bgardon@google.com> wrote:
>
> When disabling dirty logging, zap non-leaf parent entries to allow
> replacement with huge pages instead of recursing and zapping all of the
> child, leaf entries. This reduces the number of TLB flushes required.
>
> Currently disabling dirty logging with the TDP MMU is extremely slow.
> On a 96 vCPU / 96G VM backed with gigabyte pages, it takes ~200 seconds
> to disable dirty logging with the TDP MMU, as opposed to ~4 seconds with
> the shadow MMU. This patch reduces the disable dirty log time with the
> TDP MMU to ~3 seconds.
>

After Sean pointed out that I was changing the zapping scheme to zap
non-leaf SPTEs in my in-place promotion series, I started to wonder if
that would provide good-enough performance without the complexity of
in-place promo. Turns out it does! This relatively simple patch gives
essentially the same disable time as the in-place promo series.

The main downside to this approach is that it does cause all the vCPUs
to take page faults, so it may still be worth investigating in-place
promotion.

> Testing:
> Ran KVM selftests and kvm-unit-tests on an Intel Haswell. This
> patch introduced no new failures.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_iter.c |  9 +++++++++
>  arch/x86/kvm/mmu/tdp_iter.h |  1 +
>  arch/x86/kvm/mmu/tdp_mmu.c  | 38 +++++++++++++++++++++++++++++++------
>  3 files changed, 42 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index 6d3b3e5a5533..ee4802d7b36c 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -145,6 +145,15 @@ static bool try_step_up(struct tdp_iter *iter)
>         return true;
>  }
>
> +/*
> + * Step the iterator back up a level in the paging structure. Should only be
> + * used when the iterator is below the root level.
> + */
> +void tdp_iter_step_up(struct tdp_iter *iter)
> +{
> +       WARN_ON(!try_step_up(iter));
> +}
> +
>  /*
>   * Step to the next SPTE in a pre-order traversal of the paging structure.
>   * To get to the next SPTE, the iterator either steps down towards the goal
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index f0af385c56e0..adfca0cf94d3 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -114,5 +114,6 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>                     int min_level, gfn_t next_last_level_gfn);
>  void tdp_iter_next(struct tdp_iter *iter);
>  void tdp_iter_restart(struct tdp_iter *iter);
> +void tdp_iter_step_up(struct tdp_iter *iter);
>
>  #endif /* __KVM_X86_MMU_TDP_ITER_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 841feaa48be5..7b9265d67131 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1742,12 +1742,12 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>         gfn_t start = slot->base_gfn;
>         gfn_t end = start + slot->npages;
>         struct tdp_iter iter;
> +       int max_mapping_level;
>         kvm_pfn_t pfn;
>
>         rcu_read_lock();
>
>         tdp_root_for_each_pte(iter, root, start, end) {
> -retry:
>                 if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>                         continue;
>
> @@ -1755,15 +1755,41 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>                     !is_last_spte(iter.old_spte, iter.level))
>                         continue;
>
> +               /*
> +                * This is a leaf SPTE. Check if the PFN it maps can
> +                * be mapped at a higher level.
> +                */
>                 pfn = spte_to_pfn(iter.old_spte);
> -               if (kvm_is_reserved_pfn(pfn) ||
> -                   iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
> -                                                           pfn, PG_LEVEL_NUM))
> +
> +               if (kvm_is_reserved_pfn(pfn))
>                         continue;
>
> +               max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
> +                               iter.gfn, pfn, PG_LEVEL_NUM);
> +
> +               WARN_ON(max_mapping_level < iter.level);
> +
> +               /*
> +                * If this page is already mapped at the highest
> +                * viable level, there's nothing more to do.
> +                */
> +               if (max_mapping_level == iter.level)
> +                       continue;
> +
> +               /*
> +                * The page can be remapped at a higher level, so step
> +                * up to zap the parent SPTE.
> +                */
> +               while (max_mapping_level > iter.level)
> +                       tdp_iter_step_up(&iter);
> +
>                 /* Note, a successful atomic zap also does a remote TLB flush. */
> -               if (tdp_mmu_zap_spte_atomic(kvm, &iter))
> -                       goto retry;
> +               tdp_mmu_zap_spte_atomic(kvm, &iter);
> +
> +               /*
> +                * If the atomic zap fails, the iter will recurse back into
> +                * the same subtree to retry.
> +                */
>         }
>
>         rcu_read_unlock();
> --
> 2.36.1.124.g0e6072fb45-goog
>
