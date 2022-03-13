Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F327E4D7779
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 19:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiCMSmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 14:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiCMSmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 14:42:04 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194C87C175
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 11:40:56 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id g8so7609939qke.2
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 11:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9bPraKHQSPApCS4zXrLsYTAtSP08ox4AHFZsxX+X+So=;
        b=S4+eaGwZ5G3TOxNsf27mR/klfpGd/1SZF8zUpfws/QhFN3TRVDtTBPSC9CmiQjk5vy
         /Bj6EvLcklgupojIvXEsCpIOEtHB426sXWBVwQGUJFwsFLeC6rWxTViIy/G+hggjvnEA
         RkFzxSgEbG3NRK0hY8d/tgjYuBsi4jR1kjeoalL4AHCWO+ShN1Bi944vf7PH/yMnBSqc
         h8WCr/vp7FUwGQmgS7kyPjPQF60Eb35rwdwjIAA0ZXaTMKuvNDzcLBxqcirIUdy9aNC3
         NuN2y/cw129VbXUXeb9ucw9t5Kowz19SF80iMxsi7V9ruiSPhU2Tr6tBILq5xixvshZa
         AA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9bPraKHQSPApCS4zXrLsYTAtSP08ox4AHFZsxX+X+So=;
        b=rhVw42XCnCQ/PgxZ84nz0803vntSI9y192oWHfeKgtWOXtDOI1Bs4WpYaPzCmA/dX7
         9jotffpzT1Axv+fGToiAT9r1SCn5JHrLWCASWhXXe5NHKoF9cW+tATms1Un3DO74ihjn
         de0SJ+By8FnFLXA1vH8Ry1EN1xy3agtFXg2uk8OX+pG3u2Yw0jcmmHOhX7YeP+mbBPfX
         14bsrQJpB0BevNNbEWOgZOLmwQ4VMXSvHlZvVZF5/pLERW/P0jhcJzhXvkOBwBbRbEhU
         rLtw8qFnBdg1P0uGJmO2ZK2aYCsfaC7h4zoepxiy62ImjvkI54jj3VD/dT3LQts+mAQi
         XpeA==
X-Gm-Message-State: AOAM530vY2beX5zZ+I3NcKCruw3qK0LugbLIqBxV5Kb1ixuksxq+ITM7
        e2572OLQ5YftzETxCkysW5zw6ArTeuymGvBx2x0z+A==
X-Google-Smtp-Source: ABdhPJxSnBoZFlouaq675FevDv7Qawrsa0Z7dS5iR5AKNJEdPBmi5KmTIvd8LfLeBq9XCr2+52dBWuoz6h0Cb7Hjv4Y=
X-Received: by 2002:a37:b2c3:0:b0:67b:118d:81ea with SMTP id
 b186-20020a37b2c3000000b0067b118d81eamr12754466qkf.148.1647196855017; Sun, 13
 Mar 2022 11:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220303193842.370645-1-pbonzini@redhat.com> <20220303193842.370645-19-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-19-pbonzini@redhat.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Sun, 13 Mar 2022 11:40:44 -0700
Message-ID: <CAL715WJc3QdFe4gkbefW5zHPaYZfErG9vQmOLsbXz=kbaB-6uw@mail.gmail.com>
Subject: Re: [PATCH v4 18/30] KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 3, 2022 at 11:39 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Zap only leaf SPTEs in the TDP MMU's zap_gfn_range(), and rename various
> functions accordingly.  When removing mappings for functional correctness
> (except for the stupid VFIO GPU passthrough memslots bug), zapping the
> leaf SPTEs is sufficient as the paging structures themselves do not point
> at guest memory and do not directly impact the final translation (in the
> TDP MMU).
>
> Note, this aligns the TDP MMU with the legacy/full MMU, which zaps only
> the rmaps, a.k.a. leaf SPTEs, in kvm_zap_gfn_range() and
> kvm_unmap_gfn_range().
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Message-Id: <20220226001546.360188-18-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  4 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 41 ++++++++++----------------------------
>  arch/x86/kvm/mmu/tdp_mmu.h |  8 +-------
>  3 files changed, 14 insertions(+), 39 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8408d7db8d2a..febdcaaa7b94 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5834,8 +5834,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>
>         if (is_tdp_mmu_enabled(kvm)) {
>                 for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -                       flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
> -                                                         gfn_end, flush);
> +                       flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
> +                                                     gfn_end, true, flush);
>         }
>
>         if (flush)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index f3939ce4a115..c71debdbc732 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -834,10 +834,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  }
>
>  /*
> - * Tears down the mappings for the range of gfns, [start, end), and frees the
> - * non-root pages mapping GFNs strictly within that range. Returns true if
> - * SPTEs have been cleared and a TLB flush is needed before releasing the
> - * MMU lock.
> + * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
> + * have been cleared and a TLB flush is needed before releasing the MMU lock.
>   *
>   * If can_yield is true, will release the MMU lock and reschedule if the
>   * scheduler needs the CPU or there is contention on the MMU lock. If this
> @@ -845,42 +843,25 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   * the caller must ensure it does not supply too large a GFN range, or the
>   * operation can cause a soft lockup.
>   */
> -static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> -                         gfn_t start, gfn_t end, bool can_yield, bool flush)
> +static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> +                             gfn_t start, gfn_t end, bool can_yield, bool flush)
>  {
> -       bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
>         struct tdp_iter iter;
>
> -       /*
> -        * No need to try to step down in the iterator when zapping all SPTEs,
> -        * zapping the top-level non-leaf SPTEs will recurse on their children.
> -        */
> -       int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
> -
>         end = min(end, tdp_mmu_max_gfn_host());
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
>         rcu_read_lock();
>
> -       for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
> +       for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
>                 if (can_yield &&
>                     tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
>                         flush = false;
>                         continue;
>                 }
>
> -               if (!is_shadow_present_pte(iter.old_spte))
> -                       continue;
> -
> -               /*
> -                * If this is a non-last-level SPTE that covers a larger range
> -                * than should be zapped, continue, and zap the mappings at a
> -                * lower level, except when zapping all SPTEs.
> -                */
> -               if (!zap_all &&
> -                   (iter.gfn < start ||
> -                    iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
> +               if (!is_shadow_present_pte(iter.old_spte) ||
>                     !is_last_spte(iter.old_spte, iter.level))
>                         continue;
>
> @@ -898,13 +879,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   * SPTEs have been cleared and a TLB flush is needed before releasing the
>   * MMU lock.
>   */
> -bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> -                                gfn_t end, bool can_yield, bool flush)
> +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
> +                          bool can_yield, bool flush)
>  {
>         struct kvm_mmu_page *root;
>
>         for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> -               flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
> +               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);

hmm, I think we might have to be very careful here. If we only zap
leafs, then there could be side effects. For instance, the code in
disallowed_hugepage_adjust() may not work as intended. If you check
the following condition in arch/x86/kvm/mmu/mmu.c:2918

if (cur_level > PG_LEVEL_4K &&
    cur_level == fault->goal_level &&
    is_shadow_present_pte(spte) &&
    !is_large_pte(spte)) {

If we previously use 4K mappings in this range due to various reasons
(dirty logging etc), then afterwards, we zap the range. Then the guest
touches a 4K and now we should map the range with whatever the maximum
level we can for the guest.

However, if we just zap only the leafs, then when the code comes to
the above location, is_shadow_present_pte(spte) will return true,
since the spte is a non-leaf (say a regular PMD entry). The whole if
statement will be true, then we never allow remapping guest memory
with huge pages.

>
>         return flush;
>  }
> @@ -1202,8 +1183,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>                                  bool flush)
>  {
> -       return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
> -                                          range->end, range->may_block, flush);
> +       return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
> +                                    range->end, range->may_block, flush);
>  }
>
>  typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 5e5ef2576c81..54bc8118c40a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -15,14 +15,8 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
>  void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>                           bool shared);
>
> -bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
> +bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
>                                  gfn_t end, bool can_yield, bool flush);
> -static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
> -                                            gfn_t start, gfn_t end, bool flush)
> -{
> -       return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
> -}
> -
>  bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
> --
> 2.31.1
>
>
