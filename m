Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D625250A551
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiDUQ1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390582AbiDUQOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:14:38 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82342B241
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:11:48 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id m132so9611341ybm.4
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9h79Dam9UnF7WuVSpGPR0fKcSCWthUWAHVVa4W5NH1Q=;
        b=P1q2oMu+LcPYjFpBImXpUU3WKyFrHl+pRUsD7F4zni8JefspRBqHLsgxE8tox5tnPI
         7fdcxpf96zptR8sH+Ks/+pTd2OJHPHketV67C1qNU442AGmBI/UbbQxsOchYTB1CYbIt
         0ZjXqq/npJKyA/O+FbCZeF2L1scB/7QCDktQlRF/279tdm0nbt9qTIWrwZk9dL6TbW9O
         H8t8aMTTKaQC8yhmv4+Kaha0ZeviiYEaKe0DHCGwnKaszP31r3g3jD3BjXRkqy/JC/og
         uIvQ2XqMdPRiTZxNwszFbx4xWjxTlLYpE00ye5/gSOhJ43/NrsoER/cAI1fvU8/kH2P7
         yMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9h79Dam9UnF7WuVSpGPR0fKcSCWthUWAHVVa4W5NH1Q=;
        b=AhUgYSy2sazyC/dKmckeaNv1pCaZZkw9XpsTgho944DRwD7o99Y5mkABd65rYKGmpF
         NOfWub9fY7GnERkgMHLZo3LBtRpUo2NERAujbOJM8v4Rb+zxm6LSJ/y1Xv7plMGJdiuo
         hm4J7rDncp+0TnEnaxgPr/OrOt9siBPGlX6GsmCPd+lqr6A+xDvq8UChKh2nNsgVWdoj
         2IQscDl8B169fb2oRFf+3KPGWNz8Y/5/WEgySP1QScw4YAk2raa+a/hMsx42iVHDueQa
         EJUQyCUp4dxEsoE3cPQZT9MSjHKOUWiucUZg6ervcXDCaxF0+dPzZ+nQQVmJWZlb6scw
         9q0g==
X-Gm-Message-State: AOAM53313FCepE3k2uMMtGhxqJGCNljw1JF+uie4bP5+uVYXxUkDkGf4
        sPBwabrlD8m88ShiDbYPH1JmB7SJF3tiF88oC4QN5A==
X-Google-Smtp-Source: ABdhPJz2cRZxZNHSPgU0ZKYBBHbqFE34lNJqe83C4OuSK2Sxd9ItKpzi7ayjSqm1qNcCzjtbCUQaDanXSmvgvbpX1oQ=
X-Received: by 2002:a25:94a:0:b0:615:7cf4:e2cd with SMTP id
 u10-20020a25094a000000b006157cf4e2cdmr401275ybm.227.1650557507772; Thu, 21
 Apr 2022 09:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <20220415215901.1737897-11-oupton@google.com>
In-Reply-To: <20220415215901.1737897-11-oupton@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 21 Apr 2022 09:11:37 -0700
Message-ID: <CANgfPd-LZf1tkSiFTkJ-rww4Cmaign4bJRsg1KWm5eA2P5=j+A@mail.gmail.com>
Subject: Re: [RFC PATCH 10/17] KVM: arm64: Assume a table pte is already owned
 in post-order traversal
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
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

On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
>
> For parallel walks that collapse a table into a block KVM ensures a
> locked invalid pte is visible to all observers in pre-order traversal.
> As such, there is no need to try breaking the pte again.

When you're doing the pre and post-order traversals, are they
implemented as separate traversals from the root, or is it a kind of
pre and post-order where non-leaf nodes are visited on the way down
and on the way up?
I assume either could be made to work, but the re-traversal from the
root probably minimizes TLB flushes, whereas the pre-and-post-order
would be a more efficient walk?

>
> Directly set the pte if it has already been broken.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 146fc44acf31..121818d4c33e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -924,7 +924,7 @@ static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
>  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>                                       kvm_pte_t *ptep, kvm_pte_t old,
>                                       struct stage2_map_data *data,
> -                                     bool shared)
> +                                     bool shared, bool locked)
>  {
>         kvm_pte_t new;
>         u64 granule = kvm_granule_size(level), phys = data->phys;
> @@ -948,7 +948,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>         if (!stage2_pte_needs_update(old, new))
>                 return -EAGAIN;
>
> -       if (!stage2_try_break_pte(ptep, old, addr, level, shared, data))
> +       if (!locked && !stage2_try_break_pte(ptep, old, addr, level, shared, data))
>                 return -EAGAIN;
>
>         /* Perform CMOs before installation of the guest stage-2 PTE */
> @@ -987,7 +987,8 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  }
>
>  static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> -                               kvm_pte_t *old, struct stage2_map_data *data, bool shared)
> +                               kvm_pte_t *old, struct stage2_map_data *data, bool shared,
> +                               bool locked)
>  {
>         struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>         kvm_pte_t *childp, pte;
> @@ -998,10 +999,13 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>                 return 0;
>         }
>
> -       ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data, shared);
> +       ret = stage2_map_walker_try_leaf(addr, end, level, ptep, *old, data, shared, locked);
>         if (ret != -E2BIG)
>                 return ret;
>
> +       /* We should never attempt installing a table in post-order */
> +       WARN_ON(locked);
> +
>         if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
>                 return -EINVAL;
>
> @@ -1048,7 +1052,13 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>                 childp = data->childp;
>                 data->anchor = NULL;
>                 data->childp = NULL;
> -               ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
> +
> +               /*
> +                * We are guaranteed exclusive access to the pte in post-order
> +                * traversal since the locked value was made visible to all
> +                * observers in stage2_map_walk_table_pre.
> +                */
> +               ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared, true);
>         } else {
>                 childp = kvm_pte_follow(*old, mm_ops);
>         }
> @@ -1087,7 +1097,7 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_
>         case KVM_PGTABLE_WALK_TABLE_PRE:
>                 return stage2_map_walk_table_pre(addr, end, level, ptep, old, data, shared);
>         case KVM_PGTABLE_WALK_LEAF:
> -               return stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared);
> +               return stage2_map_walk_leaf(addr, end, level, ptep, old, data, shared, false);
>         case KVM_PGTABLE_WALK_TABLE_POST:
>                 return stage2_map_walk_table_post(addr, end, level, ptep, old, data, shared);
>         }
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
