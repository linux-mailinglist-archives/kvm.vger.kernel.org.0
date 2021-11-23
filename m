Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CB745ACF0
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 20:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240224AbhKWUBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 15:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240214AbhKWUBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 15:01:45 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8D4C06173E
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 11:58:36 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id z26so117972iod.10
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 11:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BHhgVimLghHGaM7w3MkAMc5zWA8/CQFZPL3XAEVPaJI=;
        b=dz8HFhZejqxqXfIrYb1STlzyNt0zyN+2hVGbO6A5DICUbIB7E9VN3Hq0fmZNI0hQrz
         7zlYfSksiPhsWKE8HspLguE/bS3R3me8UJxv0+nwXLjh4efSe+cBiZ8o1LI3gXyzcKkg
         Jj/tJ137//ZX/JOQxFEBcN8Dqp5YD0qKk6W70CBhx3fozu8m/Xv7SVrUeRmp+soXNxNj
         HJeRv3HWecbOPlA1YzG2cgKvj3yIewwWI1CapjuyZ/KE6dN0tQ1CQ9x4ojeoJClj//th
         YKrG3qBY6F3MFa/oXLW1BgBlW0JDzMRbNiI8oD2g24wsAXUBBLbsxwKbbcF6MUJc+5MK
         M9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BHhgVimLghHGaM7w3MkAMc5zWA8/CQFZPL3XAEVPaJI=;
        b=0dO+xS7sHhk/0gbsKQfHSSAXI39SfLk2IxSUWEupqze9Qo9soUQTPx9oUKS9S3wSgY
         1/v5yXAFaBtiJbDFqX5t56X0BFXYyRg8UtVX8iTk75/1exBnsoIrBU4q7xwpvgbOVX04
         gZ3Av2I9brPLksqvfMUURTUmlg/onSbKbksXGVl8w+5IGAF6wtjunuGIZnLf9ySEwwgs
         RBCAg8etllrFnfDfHxhHGMdmeKWdrgxofEuRlr50OEv2VlEahSQu8dckKTJWzte17vOP
         H7Dv0vi/H99wPkr7v1XbmGxViMlIewCfvwejE1WvrcAr2h4OUSEGg/pntQVzv8E0Jjff
         F3jg==
X-Gm-Message-State: AOAM532JBGXXEeZs8Uyc/w7g7YgJR6qT0nceieQMlEG3EiujMN5JJSgX
        ppI6rAGsRJKHyEReqWXOd8RojS4kbj6o2Vbv8L0SQg==
X-Google-Smtp-Source: ABdhPJzjZjk6xmJDwthrcEkSE6QSSppbZqd3X6fzr12S5cSfcnu94GM7kJJRH+bjANWCIWn5EDUzpEi7xTYu8unYT4U=
X-Received: by 2002:a05:6638:4087:: with SMTP id m7mr9812368jam.112.1637697515799;
 Tue, 23 Nov 2021 11:58:35 -0800 (PST)
MIME-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com> <20211120045046.3940942-27-seanjc@google.com>
In-Reply-To: <20211120045046.3940942-27-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 23 Nov 2021 11:58:25 -0800
Message-ID: <CANgfPd_1dQWOKwiojBcvnYf8Zf87zVv07gtGW9c6rYtyxC+A1g@mail.gmail.com>
Subject: Re: [PATCH 26/28] KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
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
> Zap only leaf SPTEs in the TDP MMU's zap_gfn_range(), and rename various
> functions according.  When removing mappings for functional correctness
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

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/x86/kvm/mmu/mmu.c     |  4 ++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 41 ++++++++++----------------------------
>  arch/x86/kvm/mmu/tdp_mmu.h |  8 +-------
>  3 files changed, 14 insertions(+), 39 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e3cd330c9532..ef689b8bab12 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5796,8 +5796,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
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
> index 926e92473e92..79a52717916c 100644
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
> @@ -845,18 +843,11 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
> @@ -864,24 +855,14 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>         rcu_read_lock();
>
>         for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
> -                                  min_level, start, end) {
> +                                  PG_LEVEL_4K, start, end) {
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
> @@ -899,13 +880,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
>         for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
> -               flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
> +               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
>
>         return flush;
>  }
> @@ -1147,8 +1128,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
> index 8ad1717f4a1d..6e7c32170608 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -24,14 +24,8 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
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
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm,
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
