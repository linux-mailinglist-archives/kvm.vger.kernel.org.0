Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081A462368C
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbiKIW1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbiKIW0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:26:42 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9A420BFF
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:26:38 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id lf15so227149qvb.9
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 14:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BFALFEh11gYbShb1RAGYtj5dFXgHaYyKewnp1K6Oabw=;
        b=nkpPoywYHDX5oTr3GbMz5tTHTbZRWuHW8NsemjQAHKz4xMNyjw9Kw3TWRe27yjr76z
         IBZ1A+/qXFEjCKl27M3fE9pkpDU9I3JTR4zbvOj+4jCI9hqLDgluIov21g9AdxlOvH6f
         6+jQxDfcpBkBuv8/es+JjRYaZuzv05sxFzhJp+iJ0ocYP1bVwD4kNHNJE54E0BHJKzvh
         xm7E8paRC3gDOrz6zKCidGlV55d7khDLjydj3bnP0caZAz7Jv9eySzK7b3Kyiev3SnDD
         pLccJJKiuNRt3H8cIeX8/LTgYv910T61kXFTc8Wa18t+rCI6AekXKlRECex2xYxVMoCn
         GETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BFALFEh11gYbShb1RAGYtj5dFXgHaYyKewnp1K6Oabw=;
        b=7iHceU9k/7OCsQW1aq4uv6Os0wMcoOS8WKfux3ohAVmaw6iL0UKBIjEet4SLaAYi0R
         tF7IVi//dvIcnY82inGX6tI9ogkeZbAjh7LZzUNi5tOqHiNlL1p6T3gXCNJWHhYzHgIu
         jW1JqRig0jmzW+iJoNu6N+VYqfJGgMF71V5Q5Fgd4xH2wC6c0SB73Ae1g+0955dXr5f3
         7kxU0db7efzMo5b1PLnBnkmCeDC552Bj4LFP/6V/MHZHBkK6urpz2RQ4rtE+z/y1uqFp
         yx25+xylTVLgpiFkVAtSinFtV+WzTBR47ghzOqSKBObI5S7sXORGthFjcZbgP1DpG7Ni
         s5eg==
X-Gm-Message-State: ACrzQf1vQikDZRYboFfJ9tkpqrS7g2OUuV/AXv/jQ6NaRnUaWWW32XwQ
        mDA+pC68eQKdD2UjblvbcRqmwwGBB57wbyiY/oqKEw==
X-Google-Smtp-Source: AMsMyM67iMqLmmP+/O0bTNzsRNFWvVwvyyOSZ+AivFDFmfKATCCtpTElHUJLpL1k112VENpp1GALRfF2i5Y8/vcehHM=
X-Received: by 2002:a05:6214:4103:b0:4b6:818c:eb7b with SMTP id
 kc3-20020a056214410300b004b6818ceb7bmr57729500qvb.28.1668032797696; Wed, 09
 Nov 2022 14:26:37 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215644.1895162-11-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-11-oliver.upton@linux.dev>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 9 Nov 2022 14:26:26 -0800
Message-ID: <CANgfPd_XyTuXa6T01tL9v0tdaG7OUp=Mtikvo0tVNtoBW5stAg@mail.gmail.com>
Subject: Re: [PATCH v5 10/14] KVM: arm64: Split init and set for table PTE
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 7, 2022 at 1:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Create a helper to initialize a table and directly call
> smp_store_release() to install it (for now). Prepare for a subsequent
> change that generalizes PTE writes with a helper.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index a34e2050f931..f4dd77c6c97d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -136,16 +136,13 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
>         WRITE_ONCE(*ptep, 0);
>  }
>
> -static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
> -                             struct kvm_pgtable_mm_ops *mm_ops)
> +static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops *mm_ops)
>  {
> -       kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
> +       kvm_pte_t pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
>
>         pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
>         pte |= KVM_PTE_VALID;
> -
> -       WARN_ON(kvm_pte_valid(old));

Is there any reason to drop this warning?


> -       smp_store_release(ptep, pte);
> +       return pte;
>  }
>
>  static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
> @@ -413,7 +410,7 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                           enum kvm_pgtable_walk_flags visit)
>  {
> -       kvm_pte_t *childp;
> +       kvm_pte_t *childp, new;
>         struct hyp_map_data *data = ctx->arg;
>         struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>
> @@ -427,8 +424,10 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
>         if (!childp)
>                 return -ENOMEM;
>
> -       kvm_set_table_pte(ctx->ptep, childp, mm_ops);
> +       new = kvm_init_table_pte(childp, mm_ops);
>         mm_ops->get_page(ctx->ptep);
> +       smp_store_release(ctx->ptep, new);
> +
>         return 0;
>  }
>
> @@ -796,7 +795,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>                                 struct stage2_map_data *data)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> -       kvm_pte_t *childp;
> +       kvm_pte_t *childp, new;
>         int ret;
>
>         ret = stage2_map_walker_try_leaf(ctx, data);
> @@ -821,8 +820,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         if (stage2_pte_is_counted(ctx->old))
>                 stage2_put_pte(ctx, data->mmu, mm_ops);
>
> -       kvm_set_table_pte(ctx->ptep, childp, mm_ops);
> +       new = kvm_init_table_pte(childp, mm_ops);
>         mm_ops->get_page(ctx->ptep);
> +       smp_store_release(ctx->ptep, new);
>
>         return 0;
>  }
> --
> 2.38.1.431.g37b22c650d-goog
>
