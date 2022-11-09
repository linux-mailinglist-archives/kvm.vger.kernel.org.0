Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DA762368E
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiKIW1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiKIW06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:26:58 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8339E140C1
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:26:55 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id x13so238474qvn.6
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 14:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mIH/gnU14scU0A1hyWtmYd9lzDy4ZgiwB42b18TqphI=;
        b=HFR4OdnxHrsQVbCXJcHORcKq3LD310hCms8AAWUb9x0WfZhWqQ6vfgIdCi9y6aMJqn
         ntUPcIVnrCEAomqTv2G9Op/3FygLTY8aQ7k5Q14ornuw1MbBp3zItwYfOhDBr4hO9zYR
         dmqKIWyBZP6xhWegZrdSKiyCzjlEXbKqWVZBKi/iv9zcWqpz6Uwg0C8hAIs+dvXcT/vS
         qv0A+h+egVI/qNJXzGyz/FXaq0evLNo44P9eBJ8RQdkcUbwVRfgHQkZT7ltKYHgnceUO
         KfNxgVRovf/22rKLGQkhf7NNqjEpo5AwVF46ehyydkzYwjQojxIopV/Pxc55C3hjJ41v
         x+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mIH/gnU14scU0A1hyWtmYd9lzDy4ZgiwB42b18TqphI=;
        b=LVVWsC28vRexOjUXcQ7z/BT/2yGu9NG5McosVZ/i02J7IrSKdUF8/OafIYS6ohuVzp
         Bh+oUGy/8rMPW+vU3FO7FFpYqIHYljH3gFJ0Yl2GQNm0oqPJOUJ67PA+TemTyrj4KOr7
         p+CxDKONhaZgzLhkhY9OJpDpvUnNqF6ZxBbco8+gWAjJybJrA7pcg5Mxfl6nOtEqN5EH
         0nys7UZK8l7E0Lh26Vw7Pz+xLQyq12uPrr+YqR1wurl7/ufgz0GLH3l3FDFbQD7Q+A9J
         7EHUuiUKHjKnfi0PLoz9wSTtzwAPImW8RWzAHvSpmvrp9GO1hBeAZju4TGgD969poAzy
         ANug==
X-Gm-Message-State: ACrzQf1JdB9h4qXjkHpDSPKrsuAIRsVJihcJA+gwo7RTfe5zODVVQgXT
        DAoCc+rGJLAJBTRQh4TfJfGUho4TyONTtFCAiGME0w==
X-Google-Smtp-Source: AMsMyM5J4JGxdLxEvM+TDclGKxrd4EGyAN5hOkeEDZV0xVYhb9vkBF6uFdXqxyk3atCKOBNJ2lAaV7B4qRWzA01q8BA=
X-Received: by 2002:a05:6214:21a6:b0:4bb:85b4:fd96 with SMTP id
 t6-20020a05621421a600b004bb85b4fd96mr56203622qvc.28.1668032814598; Wed, 09
 Nov 2022 14:26:54 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215934.1895478-1-oliver.upton@linux.dev>
In-Reply-To: <20221107215934.1895478-1-oliver.upton@linux.dev>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 9 Nov 2022 14:26:43 -0800
Message-ID: <CANgfPd8b+JZq5AAvasY=GaRjLPyEN87irg2HkcYvaBxdRhZgdA@mail.gmail.com>
Subject: Re: [PATCH v5 12/14] KVM: arm64: Make leaf->leaf PTE changes parallel-aware
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

On Mon, Nov 7, 2022 at 1:59 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Convert stage2_map_walker_try_leaf() to use the new break-before-make
> helpers, thereby making the handler parallel-aware. As before, avoid the
> break-before-make if recreating the existing mapping. Additionally,
> retry execution if another vCPU thread is modifying the same PTE.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b9f0d792b8d9..238f29389617 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -804,18 +804,17 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         else
>                 new = kvm_init_invalid_leaf_owner(data->owner_id);
>
> -       if (stage2_pte_is_counted(ctx->old)) {
> -               /*
> -                * Skip updating the PTE if we are trying to recreate the exact
> -                * same mapping or only change the access permissions. Instead,
> -                * the vCPU will exit one more time from guest if still needed
> -                * and then go through the path of relaxing permissions.
> -                */
> -               if (!stage2_pte_needs_update(ctx->old, new))
> -                       return -EAGAIN;
> +       /*
> +        * Skip updating the PTE if we are trying to recreate the exact
> +        * same mapping or only change the access permissions. Instead,
> +        * the vCPU will exit one more time from guest if still needed
> +        * and then go through the path of relaxing permissions.
> +        */
> +       if (!stage2_pte_needs_update(ctx->old, new))
> +               return -EAGAIN;
>
> -               stage2_put_pte(ctx, data->mmu, mm_ops);
> -       }
> +       if (!stage2_try_break_pte(ctx, data->mmu))
> +               return -EAGAIN;
>
>         /* Perform CMOs before installation of the guest stage-2 PTE */
>         if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> @@ -825,9 +824,8 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>         if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
>                 mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>
> -       smp_store_release(ctx->ptep, new);
> -       if (stage2_pte_is_counted(new))
> -               mm_ops->get_page(ctx->ptep);
> +       stage2_make_pte(ctx, new);
> +
>         if (kvm_phys_is_valid(phys))
>                 data->phys += granule;
>         return 0;
> --
> 2.38.1.431.g37b22c650d-goog
>
