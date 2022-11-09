Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FC5623674
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiKIWXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiKIWX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:23:29 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2860641C
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:23:27 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id l15so45552qtv.4
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 14:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f8bRiU9QsUNxRrjmnqo5nu0oOUJ7u7f5pLtcyoBElm8=;
        b=PaR4wCkDSedOfsgj4lfJbIWyVZ6s+goYn/CoRqWCEQl4vJ6D5ePrvZvh7Yi3ZuQRBp
         D6tw3ikutrtb4M0GxbS5GBuXO33cwY4is/9La36GbqUckCfFmSoqucGCcF3/tHLff8km
         ir4t6RKxUnyHToAjnPmgd2GaslEJgf9XCxk1TC3GuxqJVt9oSyIjWnmDU/Wau2ErtiYo
         XLFy2KJ8+6+qR6qZ1M7kTAfTzzPNWSOnBYj9sBBsWNy9d4wW/uAwPAEyoTHNH6m7ootb
         Wu9nDApO1lJBfjBA/2Z37bYRk+lGLH/OyTFoJ1ZBS9Dqeosb6TgKt4fvgzgh11OLqlva
         yXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f8bRiU9QsUNxRrjmnqo5nu0oOUJ7u7f5pLtcyoBElm8=;
        b=lmT/oH8CjpkEhvkWAG9jz7pDe9taDb15zif/3oUWApcsue3B7HpcLtW3WgQQ3mUlG4
         V1pFOPzKLCy2hqG2Q03TyJXojZ4Tx6tq2oUJguN/ACwXT4qPze67f+VN/JR+1FyKOvIa
         F/0osQpRCXom6XAnyR2vRqfr2yJqwdrjzEArhM931pdpB38wS3pGywk6JelwBFipgRpT
         CSum4gdrW9xEbSQSLL8QaccJVDTlRUV2HETtBp240LZBStPDkd+xygbHsECTuP6GCsGB
         sHcULmkBsqY/EO+Q/Ek3HcuSzcw5t11n7h3aEUrzMI74qx2tPQtcZBM2Z7vHRVzrWGMa
         Z0Rg==
X-Gm-Message-State: ACrzQf1O1aseHakRQon34+FE6qoy5/JoT+YzugEcwBX/7+sa4xdXjQkw
        mPKxsQQQaNuJ3UzHmlJKb9xK4cXouqaRxMLuytL/iQ==
X-Google-Smtp-Source: AMsMyM4yHV7HlSQ0pIwYsLHcbc+sjF32Id7ZcZxuJS/1RWoJoIQaFQrbnFrx0hHyJah49N1rUqspL4eySFTIUkdxvZA=
X-Received: by 2002:ac8:7d4d:0:b0:3a5:5987:432b with SMTP id
 h13-20020ac87d4d000000b003a55987432bmr26350506qtb.566.1668032606823; Wed, 09
 Nov 2022 14:23:26 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215644.1895162-3-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-3-oliver.upton@linux.dev>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 9 Nov 2022 14:23:16 -0800
Message-ID: <CANgfPd-mkSjiEVKBA6DCPLdwGoB=YYjQRB32jXSNB9JkJD2YUA@mail.gmail.com>
Subject: Re: [PATCH v5 02/14] KVM: arm64: Stash observed pte value in visitor context
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Rather than reading the ptep all over the shop, read the ptep once from
> __kvm_pgtable_visit() and stick it in the visitor context. Reread the
> ptep after visiting a leaf in case the callback installed a new table
> underneath.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Looks good to me.
Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/arm64/include/asm/kvm_pgtable.h  |  1 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  5 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c       |  7 +--
>  arch/arm64/kvm/hyp/pgtable.c          | 86 +++++++++++++--------------
>  4 files changed, 48 insertions(+), 51 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 607f9bb8aab4..14d4b68a1e92 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -201,6 +201,7 @@ enum kvm_pgtable_walk_flags {
>
>  struct kvm_pgtable_visit_ctx {
>         kvm_pte_t                               *ptep;
> +       kvm_pte_t                               old;
>         void                                    *arg;
>         u64                                     addr;
>         u64                                     end;
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 8f5b6a36a039..d21d1b08a055 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -421,12 +421,11 @@ static int __check_page_state_visitor(const struct kvm_pgtable_visit_ctx *ctx,
>                                       enum kvm_pgtable_walk_flags visit)
>  {
>         struct check_walk_data *d = ctx->arg;
> -       kvm_pte_t pte = *ctx->ptep;
>
> -       if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
> +       if (kvm_pte_valid(ctx->old) && !addr_is_memory(kvm_pte_to_phys(ctx->old)))
>                 return -EINVAL;
>
> -       return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
> +       return d->get_page_state(ctx->old) == d->desired ? 0 : -EPERM;
>  }
>
>  static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index a293cf5eba1b..6af443c9d78e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -192,10 +192,9 @@ static int finalize_host_mappings_walker(const struct kvm_pgtable_visit_ctx *ctx
>         struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
>         enum kvm_pgtable_prot prot;
>         enum pkvm_page_state state;
> -       kvm_pte_t pte = *ctx->ptep;
>         phys_addr_t phys;
>
> -       if (!kvm_pte_valid(pte))
> +       if (!kvm_pte_valid(ctx->old))
>                 return 0;
>
>         /*
> @@ -210,7 +209,7 @@ static int finalize_host_mappings_walker(const struct kvm_pgtable_visit_ctx *ctx
>         if (ctx->level != (KVM_PGTABLE_MAX_LEVELS - 1))
>                 return -EINVAL;
>
> -       phys = kvm_pte_to_phys(pte);
> +       phys = kvm_pte_to_phys(ctx->old);
>         if (!addr_is_memory(phys))
>                 return -EINVAL;
>
> @@ -218,7 +217,7 @@ static int finalize_host_mappings_walker(const struct kvm_pgtable_visit_ctx *ctx
>          * Adjust the host stage-2 mappings to match the ownership attributes
>          * configured in the hypervisor stage-1.
>          */
> -       state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
> +       state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(ctx->old));
>         switch (state) {
>         case PKVM_PAGE_OWNED:
>                 return host_stage2_set_owner_locked(phys, PAGE_SIZE, pkvm_hyp_id);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 900c8b9c0cfc..fb3696b3a997 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -189,6 +189,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>         enum kvm_pgtable_walk_flags flags = data->walker->flags;
>         struct kvm_pgtable_visit_ctx ctx = {
>                 .ptep   = ptep,
> +               .old    = READ_ONCE(*ptep),
>                 .arg    = data->walker->arg,
>                 .addr   = data->addr,
>                 .end    = data->end,
> @@ -196,16 +197,16 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>                 .flags  = flags,
>         };
>         int ret = 0;
> -       kvm_pte_t *childp, pte = *ptep;
> -       bool table = kvm_pte_table(pte, level);
> +       kvm_pte_t *childp;
> +       bool table = kvm_pte_table(ctx.old, level);
>
>         if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE))
>                 ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_TABLE_PRE);
>
>         if (!table && (ctx.flags & KVM_PGTABLE_WALK_LEAF)) {
>                 ret = kvm_pgtable_visitor_cb(data, &ctx, KVM_PGTABLE_WALK_LEAF);
> -               pte = *ptep;
> -               table = kvm_pte_table(pte, level);
> +               ctx.old = READ_ONCE(*ptep);
> +               table = kvm_pte_table(ctx.old, level);
>         }
>
>         if (ret)
> @@ -217,7 +218,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>                 goto out;
>         }
>
> -       childp = kvm_pte_follow(pte, data->pgt->mm_ops);
> +       childp = kvm_pte_follow(ctx.old, data->pgt->mm_ops);
>         ret = __kvm_pgtable_walk(data, childp, level + 1);
>         if (ret)
>                 goto out;
> @@ -299,7 +300,7 @@ static int leaf_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  {
>         struct leaf_walk_data *data = ctx->arg;
>
> -       data->pte   = *ctx->ptep;
> +       data->pte   = ctx->old;
>         data->level = ctx->level;
>
>         return 0;
> @@ -388,7 +389,7 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
>  static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>                                     struct hyp_map_data *data)
>  {
> -       kvm_pte_t new, old = *ctx->ptep;
> +       kvm_pte_t new;
>         u64 granule = kvm_granule_size(ctx->level), phys = data->phys;
>
>         if (!kvm_block_mapping_supported(ctx, phys))
> @@ -396,11 +397,11 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>
>         data->phys += granule;
>         new = kvm_init_valid_leaf_pte(phys, data->attr, ctx->level);
> -       if (old == new)
> +       if (ctx->old == new)
>                 return true;
> -       if (!kvm_pte_valid(old))
> +       if (!kvm_pte_valid(ctx->old))
>                 data->mm_ops->get_page(ctx->ptep);
> -       else if (WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
> +       else if (WARN_ON((ctx->old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
>                 return false;
>
>         smp_store_release(ctx->ptep, new);
> @@ -461,16 +462,16 @@ struct hyp_unmap_data {
>  static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                             enum kvm_pgtable_walk_flags visit)
>  {
> -       kvm_pte_t pte = *ctx->ptep, *childp = NULL;
> +       kvm_pte_t *childp = NULL;
>         u64 granule = kvm_granule_size(ctx->level);
>         struct hyp_unmap_data *data = ctx->arg;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
> -       if (!kvm_pte_valid(pte))
> +       if (!kvm_pte_valid(ctx->old))
>                 return -EINVAL;
>
> -       if (kvm_pte_table(pte, ctx->level)) {
> -               childp = kvm_pte_follow(pte, mm_ops);
> +       if (kvm_pte_table(ctx->old, ctx->level)) {
> +               childp = kvm_pte_follow(ctx->old, mm_ops);
>
>                 if (mm_ops->page_count(childp) != 1)
>                         return 0;
> @@ -538,15 +539,14 @@ static int hyp_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                            enum kvm_pgtable_walk_flags visit)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
> -       kvm_pte_t pte = *ctx->ptep;
>
> -       if (!kvm_pte_valid(pte))
> +       if (!kvm_pte_valid(ctx->old))
>                 return 0;
>
>         mm_ops->put_page(ctx->ptep);
>
> -       if (kvm_pte_table(pte, ctx->level))
> -               mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
> +       if (kvm_pte_table(ctx->old, ctx->level))
> +               mm_ops->put_page(kvm_pte_follow(ctx->old, mm_ops));
>
>         return 0;
>  }
> @@ -691,7 +691,7 @@ static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s
>          * Clear the existing PTE, and perform break-before-make with
>          * TLB maintenance if it was valid.
>          */
> -       if (kvm_pte_valid(*ctx->ptep)) {
> +       if (kvm_pte_valid(ctx->old)) {
>                 kvm_clear_pte(ctx->ptep);
>                 kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
>         }
> @@ -722,7 +722,7 @@ static bool stage2_leaf_mapping_allowed(const struct kvm_pgtable_visit_ctx *ctx,
>  static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>                                       struct stage2_map_data *data)
>  {
> -       kvm_pte_t new, old = *ctx->ptep;
> +       kvm_pte_t new;
>         u64 granule = kvm_granule_size(ctx->level), phys = data->phys;
>         struct kvm_pgtable *pgt = data->mmu->pgt;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> @@ -735,14 +735,14 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         else
>                 new = kvm_init_invalid_leaf_owner(data->owner_id);
>
> -       if (stage2_pte_is_counted(old)) {
> +       if (stage2_pte_is_counted(ctx->old)) {
>                 /*
>                  * Skip updating the PTE if we are trying to recreate the exact
>                  * same mapping or only change the access permissions. Instead,
>                  * the vCPU will exit one more time from guest if still needed
>                  * and then go through the path of relaxing permissions.
>                  */
> -               if (!stage2_pte_needs_update(old, new))
> +               if (!stage2_pte_needs_update(ctx->old, new))
>                         return -EAGAIN;
>
>                 stage2_put_pte(ctx, data->mmu, mm_ops);
> @@ -773,7 +773,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>         if (!stage2_leaf_mapping_allowed(ctx, data))
>                 return 0;
>
> -       data->childp = kvm_pte_follow(*ctx->ptep, data->mm_ops);
> +       data->childp = kvm_pte_follow(ctx->old, data->mm_ops);
>         kvm_clear_pte(ctx->ptep);
>
>         /*
> @@ -790,11 +790,11 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>                                 struct stage2_map_data *data)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> -       kvm_pte_t *childp, pte = *ctx->ptep;
> +       kvm_pte_t *childp;
>         int ret;
>
>         if (data->anchor) {
> -               if (stage2_pte_is_counted(pte))
> +               if (stage2_pte_is_counted(ctx->old))
>                         mm_ops->put_page(ctx->ptep);
>
>                 return 0;
> @@ -819,7 +819,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>          * a table. Accesses beyond 'end' that fall within the new table
>          * will be mapped lazily.
>          */
> -       if (stage2_pte_is_counted(pte))
> +       if (stage2_pte_is_counted(ctx->old))
>                 stage2_put_pte(ctx, data->mmu, mm_ops);
>
>         kvm_set_table_pte(ctx->ptep, childp, mm_ops);
> @@ -844,7 +844,7 @@ static int stage2_map_walk_table_post(const struct kvm_pgtable_visit_ctx *ctx,
>                 data->childp = NULL;
>                 ret = stage2_map_walk_leaf(ctx, data);
>         } else {
> -               childp = kvm_pte_follow(*ctx->ptep, mm_ops);
> +               childp = kvm_pte_follow(ctx->old, mm_ops);
>         }
>
>         mm_ops->put_page(childp);
> @@ -954,23 +954,23 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>         struct kvm_pgtable *pgt = ctx->arg;
>         struct kvm_s2_mmu *mmu = pgt->mmu;
>         struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> -       kvm_pte_t pte = *ctx->ptep, *childp = NULL;
> +       kvm_pte_t *childp = NULL;
>         bool need_flush = false;
>
> -       if (!kvm_pte_valid(pte)) {
> -               if (stage2_pte_is_counted(pte)) {
> +       if (!kvm_pte_valid(ctx->old)) {
> +               if (stage2_pte_is_counted(ctx->old)) {
>                         kvm_clear_pte(ctx->ptep);
>                         mm_ops->put_page(ctx->ptep);
>                 }
>                 return 0;
>         }
>
> -       if (kvm_pte_table(pte, ctx->level)) {
> -               childp = kvm_pte_follow(pte, mm_ops);
> +       if (kvm_pte_table(ctx->old, ctx->level)) {
> +               childp = kvm_pte_follow(ctx->old, mm_ops);
>
>                 if (mm_ops->page_count(childp) != 1)
>                         return 0;
> -       } else if (stage2_pte_cacheable(pgt, pte)) {
> +       } else if (stage2_pte_cacheable(pgt, ctx->old)) {
>                 need_flush = !stage2_has_fwb(pgt);
>         }
>
> @@ -982,7 +982,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>         stage2_put_pte(ctx, mmu, mm_ops);
>
>         if (need_flush && mm_ops->dcache_clean_inval_poc)
> -               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
> +               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
>                                                kvm_granule_size(ctx->level));
>
>         if (childp)
> @@ -1013,11 +1013,11 @@ struct stage2_attr_data {
>  static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                               enum kvm_pgtable_walk_flags visit)
>  {
> -       kvm_pte_t pte = *ctx->ptep;
> +       kvm_pte_t pte = ctx->old;
>         struct stage2_attr_data *data = ctx->arg;
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>
> -       if (!kvm_pte_valid(pte))
> +       if (!kvm_pte_valid(ctx->old))
>                 return 0;
>
>         data->level = ctx->level;
> @@ -1036,7 +1036,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                  * stage-2 PTE if we are going to add executable permission.
>                  */
>                 if (mm_ops->icache_inval_pou &&
> -                   stage2_pte_executable(pte) && !stage2_pte_executable(*ctx->ptep))
> +                   stage2_pte_executable(pte) && !stage2_pte_executable(ctx->old))
>                         mm_ops->icache_inval_pou(kvm_pte_follow(pte, mm_ops),
>                                                   kvm_granule_size(ctx->level));
>                 WRITE_ONCE(*ctx->ptep, pte);
> @@ -1142,13 +1142,12 @@ static int stage2_flush_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  {
>         struct kvm_pgtable *pgt = ctx->arg;
>         struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> -       kvm_pte_t pte = *ctx->ptep;
>
> -       if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
> +       if (!kvm_pte_valid(ctx->old) || !stage2_pte_cacheable(pgt, ctx->old))
>                 return 0;
>
>         if (mm_ops->dcache_clean_inval_poc)
> -               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
> +               mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
>                                                kvm_granule_size(ctx->level));
>         return 0;
>  }
> @@ -1200,15 +1199,14 @@ static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                               enum kvm_pgtable_walk_flags visit)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = ctx->arg;
> -       kvm_pte_t pte = *ctx->ptep;
>
> -       if (!stage2_pte_is_counted(pte))
> +       if (!stage2_pte_is_counted(ctx->old))
>                 return 0;
>
>         mm_ops->put_page(ctx->ptep);
>
> -       if (kvm_pte_table(pte, ctx->level))
> -               mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
> +       if (kvm_pte_table(ctx->old, ctx->level))
> +               mm_ops->put_page(kvm_pte_follow(ctx->old, mm_ops));
>
>         return 0;
>  }
> --
> 2.38.1.431.g37b22c650d-goog
>
