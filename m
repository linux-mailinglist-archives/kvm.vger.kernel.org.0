Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7B4678D18
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 02:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjAXBDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 20:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjAXBDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 20:03:37 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8707930B1C
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:03:36 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y11so16594197edd.6
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kdLCNu5g0MEWkTl6tJScXbNxCMJ8U+qIEm3Aol/ITa0=;
        b=URLmVirikmUa4T1zkW6InNmOqlSKCTmsD0IbC2AiBdaR7g8gxec2vugC7lXJ8h7a0C
         ouoHs2GZF2cMMR+/UpM1c8dXPKHVGrIIIX3a675dp6P1wMZf2wJRWt2Ips27f5/GxmJL
         zKHys07lF/E0xpp7BplTG95jfkd0Obo/oz8WClok8umhcgYOTMr1whh4eT6gKXkVTbUr
         4IxRJGAM/8ZIV73L5HmHA6JjtKUib7sNCJCZTEYPkCt+1GQDsEoWFBsfr+nvDKhqfZ01
         8dVdcII1EMPuWAlzGARCmYlyDX/RAFQgh98QaKLqGmRh9w4nc9mtp0EoowA0vj6Q/AZh
         fFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kdLCNu5g0MEWkTl6tJScXbNxCMJ8U+qIEm3Aol/ITa0=;
        b=2gsi0MlREuqgrE0ax0GKXBlyouwgYKKLT6c3Foa/evNYS8fIRXjzDupi3pIhNSIldi
         vav+FHNmlJWCki968/dBWBENZeBWcRnJFA3mEYhTR04yvjaU2vDjSDU7tNRzodkjKrkB
         by06nb6LMZWB4mt2htl/XH/V4HIMYA7EbWDT1QlF5HvWcLioMJZZ9jamDd+KgLPLNiha
         idNzx+MzhF13OVYfp3qY04reMzRA5ImchbITVv+upou0gonjXvnB8Z4su+A3jSGx9svI
         gdpQLCsM7XxWHlBmJFJOUm7RSPxIZ52p6iWMhbL+RRN5lnLlO7SfYXlJR7ZYqIttZHhL
         3nfw==
X-Gm-Message-State: AFqh2koT68ArhH0h5Pa1h7k6ghFhADfdLUOtQ5uA41HxrEcv02YaTwzH
        QqE8tfutZxax+LGmifo/jYY4Z1RU4w6z2EA9SUG4nw==
X-Google-Smtp-Source: AMrXdXtkBsLV+yHlXs66c/nt+Q3Yj/xqGrGw5sOBktBjaUUwEdx1r0FKYFwPaUx6lcJPb2Gde+GQpnjUGQOJLAs7Wp8=
X-Received: by 2002:a05:6402:40a:b0:49d:aca5:9ae0 with SMTP id
 q10-20020a056402040a00b0049daca59ae0mr3275286edv.106.1674522214798; Mon, 23
 Jan 2023 17:03:34 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-4-ricarkol@google.com>
In-Reply-To: <20230113035000.480021-4-ricarkol@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 23 Jan 2023 17:03:23 -0800
Message-ID: <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Ricardo Koller <ricarkol@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
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

On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> range of huge pages. This will be used for eager-splitting huge pages
> into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> on write-protection faults, and instead use this function to do it
> ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> a time).
>
> No functional change intended. This new function will be used in a
> subsequent commit.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 29 ++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 67 ++++++++++++++++++++++++++++
>  2 files changed, 96 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 8ad78d61af7f..5fbdc1f259fd 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -644,6 +644,35 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
>   */
>  int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>
> +/**
> + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> + *                             to PAGE_SIZE guest pages.
> + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @addr:      Intermediate physical address from which to split.
> + * @size:      Size of the range.
> + * @mc:                Cache of pre-allocated and zeroed memory from which to allocate
> + *             page-table pages.
> + *
> + * @addr and the end (@addr + @size) are effectively aligned down and up to
> + * the top level huge-page block size. This is an exampe using 1GB

Nit: example

> + * huge-pages and 4KB granules.
> + *
> + *                          [---input range---]
> + *                          :                 :
> + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> + *                          :                 :
> + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> + *                          :                 :
> + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> + *                          :                 :
> + *
> + * Return: 0 on success, negative error code on failure. Note that
> + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> + * blocks in the input range as allowed by the size of the memcache. It
> + * will fail it wasn't able to break any block.
> + */
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> +
>  /**
>   * kvm_pgtable_walk() - Walk a page-table.
>   * @pgt:       Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0dee13007776..db9d1a28769b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1229,6 +1229,73 @@ int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
>         return 0;
>  }
>
> +struct stage2_split_data {
> +       struct kvm_s2_mmu               *mmu;
> +       void                            *memcache;
> +};
> +
> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +                              enum kvm_pgtable_walk_flags visit)
> +{
> +       struct stage2_split_data *data = ctx->arg;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +       kvm_pte_t pte = ctx->old, new, *childp;
> +       enum kvm_pgtable_prot prot;
> +       void *mc = data->memcache;
> +       u32 level = ctx->level;
> +       u64 phys;
> +       int ret;
> +
> +       /* Nothing to split at the last level */

Would it be accurate to say:
/* No huge pages can exist at the root level, so there's nothing to
split here. */

I think of "last level" as the lowest/leaf/4k level but
KVM_PGTABLE_MAX_LEVELS - 1 is 3? Does ARM do the level numbering in
reverse order to x86?

> +       if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> +               return 0;
> +
...
