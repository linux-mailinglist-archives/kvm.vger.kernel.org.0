Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945A045952F
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhKVTAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 14:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbhKVTAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 14:00:01 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F79C06173E
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:55 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id 14so24618649ioe.2
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZCwF2T7S6E1D0BNcdwX7lIZbWotX8W3x5GSjT7EmrZc=;
        b=ERKIJRbIql03mAwO5FrSUyhNYPi2k09yS4SNrtrsLY37ab+s+bWM30bKjrDIMlA2Vv
         B/HIDxyKIdPLYp/HLTNHtWqO7pjLB5DPtcjEdneqXBNd7H60KoHPKwqpS5gViOK5bMCY
         KqqnNbvGu4uqMziW6aZCzdQxStunSxQbMFqzTKtGaZD3PGUjiKe8lLiV6EgxLtMXa36p
         fxWnnGZLmO3aSLZof2v2gn8KAB4UFM6+oSkpNt8C6H2OC1/DM5eWTsDiXpfCdTVbxoQt
         KPZ2x26OlUzeMcLbnzb0gYiMturOi2/iqdFOImPmgZyvTjNFkNBJY9ooaTUBeBJvMASa
         ZYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZCwF2T7S6E1D0BNcdwX7lIZbWotX8W3x5GSjT7EmrZc=;
        b=bPsOBekh1Ry5ee5GP7gJTQKEHMrAseNVzBKjbp1U1I2Ngr3qN0d7M8O08MDcvNZn+5
         TiAWlUBVYF9rI0xqIIzcDFCKoaBLeTzS1VnBULFmTr6Y7Cd8gUjOyEw6h2Jzfy1pNHk4
         15iQKlgzIwX7yUpKT79Hc54yOBnT/EdtrwFTZQFuL/m364kvG/kY3L0eByxYpQ4d4j/n
         cmVE0t9OU1S8Y435LQerZnpjBVZabjMcCj4n5J3iHHv8nNzgE5f2kn8ky4vP5AD8M9WA
         uYTVtLHivmp6kwMPMLvF2eWkjpuyM1Q9zMN80QkHWVxgFkoKjuY7CqJKNAa4JP4BJXQa
         f6kA==
X-Gm-Message-State: AOAM531Eoj8CRYs1OQWBArzgea2YTSqXHSi98JZbhzW+NsSXX9kJ5Drw
        cX7uYdVugg4x2xhshLvkRtLfhcLwuuwrFwMUivpEtg==
X-Google-Smtp-Source: ABdhPJz/Nd1I32bh6dUHYooxdGX2h3fPAFFuEDE5tdFCNm+r9lxNRI9Q8Pj2KkpbB0kEPoKFckb6EL3hZsIZtWNVCmo=
X-Received: by 2002:a02:70cf:: with SMTP id f198mr50104593jac.124.1637607414513;
 Mon, 22 Nov 2021 10:56:54 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-12-dmatlack@google.com>
In-Reply-To: <20211119235759.1304274-12-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:56:43 -0800
Message-ID: <CANgfPd_xRLwDahhp3136B4_0JC7S=JCo8wZ6E3uPQ9JC-n1eHg@mail.gmail.com>
Subject: Re: [RFC PATCH 11/15] KVM: x86/mmu: Refactor tdp_mmu iterators to
 take kvm_mmu_page root
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
> Instead of passing a pointer to the root page table and the root level
> seperately, pass in a pointer to the kvm_mmu_page that backs the root.
> This reduces the number of arguments by 1, cutting down on line lengths.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_iter.c |  5 ++++-
>  arch/x86/kvm/mmu/tdp_iter.h | 10 +++++-----
>  arch/x86/kvm/mmu/tdp_mmu.c  | 14 +++++---------
>  3 files changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index b3ed302c1a35..92b3a075525a 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -39,9 +39,12 @@ void tdp_iter_restart(struct tdp_iter *iter)
>   * Sets a TDP iterator to walk a pre-order traversal of the paging structure
>   * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
>   */
> -void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
> +void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,

I think this is an artifact of the days when I thought we could avoid
allocating struct kvm_mmu_pages for the TDP MMU.
Trying to do that turned out to be a huge pain though and the memory
savings weren't great.
Happy to see this cleaned up.


>                     int min_level, gfn_t next_last_level_gfn)
>  {
> +       u64 *root_pt = root->spt;
> +       int root_level = root->role.level;
> +
>         WARN_ON(root_level < 1);
>         WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
>
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index b1748b988d3a..ec1f58013428 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -51,17 +51,17 @@ struct tdp_iter {
>   * Iterates over every SPTE mapping the GFN range [start, end) in a
>   * preorder traversal.
>   */
> -#define for_each_tdp_pte_min_level(iter, root, root_level, min_level, start, end) \
> -       for (tdp_iter_start(&iter, root, root_level, min_level, start); \
> +#define for_each_tdp_pte_min_level(iter, root, min_level, start, end) \
> +       for (tdp_iter_start(&iter, root, min_level, start); \
>              iter.valid && iter.gfn < end;                   \
>              tdp_iter_next(&iter))
>
> -#define for_each_tdp_pte(iter, root, root_level, start, end) \
> -       for_each_tdp_pte_min_level(iter, root, root_level, PG_LEVEL_4K, start, end)
> +#define for_each_tdp_pte(iter, root, start, end) \
> +       for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
>
>  tdp_ptep_t spte_to_child_pt(u64 pte, int level);
>
> -void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
> +void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>                     int min_level, gfn_t next_last_level_gfn);
>  void tdp_iter_next(struct tdp_iter *iter);
>  void tdp_iter_restart(struct tdp_iter *iter);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 2221e074d8ea..5ca0fa659245 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -632,7 +632,7 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>  }
>
>  #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
> -       for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
> +       for_each_tdp_pte(_iter, _root, _start, _end)
>
>  #define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end) \
>         tdp_root_for_each_pte(_iter, _root, _start, _end)               \
> @@ -642,8 +642,7 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>                 else
>
>  #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)                \
> -       for_each_tdp_pte(_iter, __va(_mmu->root_hpa),           \
> -                        _mmu->shadow_root_level, _start, _end)
> +       for_each_tdp_pte(_iter, to_shadow_page(_mmu->root_hpa), _start, _end)
>
>  static inline bool tdp_mmu_iter_need_resched(struct kvm *kvm, struct tdp_iter *iter)
>  {
> @@ -738,8 +737,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>
>         rcu_read_lock();
>
> -       for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
> -                                  min_level, start, end) {
> +       for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
>  retry:
>                 if (can_yield &&
>                     tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
> @@ -1201,8 +1199,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>
>         BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
>
> -       for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
> -                                  min_level, start, end) {
> +       for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
>  retry:
>                 if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>                         continue;
> @@ -1450,8 +1447,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
>
>         rcu_read_lock();
>
> -       for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
> -                                  min_level, gfn, gfn + 1) {
> +       for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
>                 if (!is_shadow_present_pte(iter.old_spte) ||
>                     !is_last_spte(iter.old_spte, iter.level))
>                         continue;
> --
> 2.34.0.rc2.393.gf8c9666880-goog
>
