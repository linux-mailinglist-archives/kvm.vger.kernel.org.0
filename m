Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ADA68C979
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 23:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjBFWeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 17:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjBFWeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 17:34:07 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD6B18B32
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 14:34:04 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id v10so13180526edi.8
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 14:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u8hK6aDnGas5wTwlB9YPUBcu6UkRBLvZchU/qDz76og=;
        b=EevNMgbk9U4T97qNlnWsGtygl8qMB7c4XLR9I/txerpfKx5PVnGRxFzigNSYs7NYZg
         WLgmPHL0+MGznlHVdb0ddRLKUJyqUHdugQk0gRwt1UYuhXblEQZ85W3IUHRrTXVuetsL
         0CN5R/4jlN/IWKHVNjDjCNJmhX0ySRcbSLETCLsIXLBw4KKN865+2kA5Kr6biOc2NBU1
         Xgbui+TwtpgQgW8WWcdDjhFSvxiCGbVcoXGih8/eceKXPUF0H6qTUSNAXjVpwUsVqyTj
         OM53iCOSNHIHsveRMv1xKw/3xqkXQqYGYmRBLslGn4BFiFqkQrXIGGLWmwTV/LkRg0Ld
         hl/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u8hK6aDnGas5wTwlB9YPUBcu6UkRBLvZchU/qDz76og=;
        b=1OcwgW9zcC0y9MYBNdBg7dLj8bGkJMBoTDjURngrVs/vbQXdfWCD06gWKaK1shEerb
         hc3Jm+mOgufbiW0uFUQ2bOkODBHH3GhMySUi99zwqWjq/kNs5zhXcOY4+HEa+uhCKuiS
         c0a3CQoMJZOU7fPS2QQfb3bohs8lVsDopjL617iuiw69vmwEb+ppY/ifn1D7YZOxnfBw
         E1w2HKhni1ElWi+ZlwLOevKT6fG39KudI7SIMlKTSJNv4eV6+CCMTVH3MK4snlruQXlB
         qBljULexf0GXJ9bZa2ME6WXKrJ70G/kdC2P+/+FbBbBfJEChiUqi8djJH43MfLHGkRra
         tGUA==
X-Gm-Message-State: AO0yUKVZ6/RLiRfeKcCYjeFwulxpVK9KzUaDGhW1+ZbguaVzE7ZJ+WQz
        zRWUT/vrAFkYWeexTjbJtOhlLYHKmNXbuFpHjs5CBw==
X-Google-Smtp-Source: AK7set+H3rGwLjh8NVvvnFI7Dml0OaOooCV26xcKw2FJTaXXdzG0Q/pEmu9yvXMetA9du1JlLANUA8H90NenyJlySqo=
X-Received: by 2002:a50:cd17:0:b0:4a2:7833:e39c with SMTP id
 z23-20020a50cd17000000b004a27833e39cmr24934edi.3.1675722842269; Mon, 06 Feb
 2023 14:34:02 -0800 (PST)
MIME-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com> <20230203192822.106773-6-vipinsh@google.com>
In-Reply-To: <20230203192822.106773-6-vipinsh@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 6 Feb 2023 14:33:50 -0800
Message-ID: <CANgfPd_MKOPrHJUAJQsKX7G0zQBbGNObjmW6ddfPDfuEJcBvnw@mail.gmail.com>
Subject: Re: [Patch v2 5/5] KVM: x86/mmu: Merge all handle_changed_pte* functions.
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 3, 2023 at 11:28 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> __handle_changed_pte() and handle_changed_spte_acc_track() are always
> used together. Merge these two functions and name the new function
> handle_changed_pte(). Remove the existing handle_changed_pte() function
> which just calls __handle_changed_pte and
> handle_changed_spte_acc_track().
>
> This converges SPTEs change handling code to a single place.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 42 +++++++++++---------------------------
>  1 file changed, 12 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index afe0dcb1859e..9b0c81a28f97 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -334,17 +334,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>                                 u64 old_spte, u64 new_spte, int level,
>                                 bool shared);
>
> -static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
> -{
> -       if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
> -               return;
> -
> -       if (is_accessed_spte(old_spte) &&
> -           (!is_shadow_present_pte(new_spte) || !is_accessed_spte(new_spte) ||
> -            spte_to_pfn(old_spte) != spte_to_pfn(new_spte)))
> -               kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> -}
> -
>  static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>         kvm_account_pgtable_pages((void *)sp->spt, +1);
> @@ -487,7 +476,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  }
>
>  /**
> - * __handle_changed_spte - handle bookkeeping associated with an SPTE change
> + * handle_changed_spte - handle bookkeeping associated with an SPTE change
>   * @kvm: kvm instance
>   * @as_id: the address space of the paging structure the SPTE was a part of
>   * @gfn: the base GFN that was mapped by the SPTE
> @@ -501,9 +490,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>   * Handle bookkeeping that might result from the modification of a SPTE.
>   * This function must be called for all TDP SPTE modifications.
>   */
> -static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -                                 u64 old_spte, u64 new_spte, int level,
> -                                 bool shared)
> +static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> +                               u64 old_spte, u64 new_spte, int level,
> +                               bool shared)
>  {
>         bool was_present = is_shadow_present_pte(old_spte);
>         bool is_present = is_shadow_present_pte(new_spte);
> @@ -587,15 +576,10 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>         if (was_present && !was_leaf &&
>             (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
>                 handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> -}
>
> -static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -                               u64 old_spte, u64 new_spte, int level,
> -                               bool shared)
> -{
> -       __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> -                             shared);
> -       handle_changed_spte_acc_track(old_spte, new_spte, level);
> +       if (was_leaf && is_accessed_spte(old_spte) &&
> +           (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
> +               kvm_set_pfn_accessed(spte_to_pfn(old_spte));
>  }
>
>  /*
> @@ -638,9 +622,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
>         if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
>                 return -EBUSY;
>
> -       __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -                             new_spte, iter->level, true);
> -       handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
> +       handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> +                           new_spte, iter->level, true);
>
>         return 0;
>  }
> @@ -705,8 +688,7 @@ static u64 _tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>
>         old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
>
> -       __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> -       handle_changed_spte_acc_track(old_spte, new_spte, level);
> +       handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
>         return old_spte;
>  }
>
> @@ -1273,7 +1255,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>          * Note, when changing a read-only SPTE, it's not strictly necessary to
>          * zero the SPTE before setting the new PFN, but doing so preserves the
>          * invariant that the PFN of a present * leaf SPTE can never change.
> -        * See __handle_changed_spte().
> +        * See handle_changed_spte().
>          */
>         tdp_mmu_set_spte(kvm, iter, 0);
>
> @@ -1298,7 +1280,7 @@ bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>         /*
>          * No need to handle the remote TLB flush under RCU protection, the
>          * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
> -        * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
> +        * shadow page. See the WARN on pfn_changed in handle_changed_spte().
>          */
>         return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
>  }
> --
> 2.39.1.519.gcb327c4b5f-goog
>
