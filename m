Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E90623676
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiKIWXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiKIWXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:23:41 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C4E1CB12
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:23:38 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id fz10so48811qtb.3
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 14:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uJg+kpvNkPD030tpMMGmVHe2gjQx4qRtyPNBYhTi0Do=;
        b=spArdvT5xfNKFKqJhO//PlvjWcnhvTF2+ViWLb1H96v+OMZm56WD/DL3FTv1+ByYEN
         lsgdE+x7WHSdiZJoLNMKj10oOzlPFVH7OOqJ3Jyl5kqmK/M/sL+IkOQM+KUYRBnDS+Am
         BC+jNOVK5u7F88DAPQFuRMrP8sNj8OpZ35wpepJFStMGQbp7Oicy1zBJOnz2SHSZDpbi
         iZIdImQTkj60o6FYxDzctqMSs5CpMqWSbgDo03a2UfLWnKiqGab805LagiU7qMPRCfXE
         Sq2ANew7d5NwsmA7OWYYkZd+UB7ov+92nWYlaeLE/MXNuAxohNyYD8KzCxJoTSOA58/c
         HdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uJg+kpvNkPD030tpMMGmVHe2gjQx4qRtyPNBYhTi0Do=;
        b=48KbK2pFy/dfDq02861Y8b7H4p1kAs7Xc/t/GlY0emMnx8Lgjwe/nodltq5wQMHmh1
         +sGr2RiGk+VNwGdHQgDVhigqt+6E+0hOAV4gWga7QztRYPAIvh6zaugqdvYqFEZzj+RD
         HAjADwPNGETWsq71kVEgyQOSl8A3FUt/LzjQxlrltDb2WoBq8wWNp4utuZxWpwnRShB7
         phYtgVQ83CNY/3Qa3jy8FRjc4jn2DzYmepYDBnp9ukiXFZ74Drg7kfCQS4GUzvZMTkam
         ECFj4y4jjlcYzGQgLfAdd5ODNIhRsXAD4nurL5qVBgWxf1P8XrNSF8ghU6ZMah25TWg/
         pZwQ==
X-Gm-Message-State: ACrzQf1pmwNDShXlbnL8WfmqgeH+kla9A+NnEtk0fhjuFy/uvwyDNkHp
        bxDY/S5GAlD5/Oj8wgkJ0dtsBONqS4MrBk34xeLBEQ==
X-Google-Smtp-Source: AMsMyM4tGmioPPwHHbmDR56b9nxo9rsvbynmSavlKkjED5lHQQmrp870AqPkMfEw30VQwHWm31A/vU+rVcf7R8CSS1Q=
X-Received: by 2002:ac8:7d4d:0:b0:3a5:5987:432b with SMTP id
 h13-20020ac87d4d000000b003a55987432bmr26351094qtb.566.1668032617470; Wed, 09
 Nov 2022 14:23:37 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215644.1895162-5-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-5-oliver.upton@linux.dev>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 9 Nov 2022 14:23:26 -0800
Message-ID: <CANgfPd_RXJXGQDWrzT-ZCYLOkK_J_LMP3mFkmGsnVAPsqr7KdQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/14] KVM: arm64: Don't pass kvm_pgtable through kvm_pgtable_walk_data
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

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> In order to tear down page tables from outside the context of
> kvm_pgtable (such as an RCU callback), stop passing a pointer through
> kvm_pgtable_walk_data.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Ben Gardon <bgardon@google.com>


> ---
>  arch/arm64/kvm/hyp/pgtable.c | 18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index db25e81a9890..93989b750a26 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -50,7 +50,6 @@
>  #define KVM_MAX_OWNER_ID               1
>
>  struct kvm_pgtable_walk_data {
> -       struct kvm_pgtable              *pgt;
>         struct kvm_pgtable_walker       *walker;
>
>         u64                             addr;
> @@ -88,7 +87,7 @@ static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
>         return (data->addr >> shift) & mask;
>  }
>
> -static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
> +static u32 kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>  {
>         u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
>         u64 mask = BIT(pgt->ia_bits) - 1;
> @@ -96,11 +95,6 @@ static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>         return (addr & mask) >> shift;
>  }
>
> -static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
> -{
> -       return __kvm_pgd_page_idx(data->pgt, data->addr);
> -}
> -
>  static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>  {
>         struct kvm_pgtable pgt = {
> @@ -108,7 +102,7 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>                 .start_level    = start_level,
>         };
>
> -       return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
> +       return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
>  }
>
>  static bool kvm_pte_table(kvm_pte_t pte, u32 level)
> @@ -255,11 +249,10 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>         return ret;
>  }
>
> -static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
> +static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_data *data)
>  {
>         u32 idx;
>         int ret = 0;
> -       struct kvm_pgtable *pgt = data->pgt;
>         u64 limit = BIT(pgt->ia_bits);
>
>         if (data->addr > limit || data->end > limit)
> @@ -268,7 +261,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
>         if (!pgt->pgd)
>                 return -EINVAL;
>
> -       for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
> +       for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
>                 kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
>
>                 ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
> @@ -283,13 +276,12 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>                      struct kvm_pgtable_walker *walker)
>  {
>         struct kvm_pgtable_walk_data walk_data = {
> -               .pgt    = pgt,
>                 .addr   = ALIGN_DOWN(addr, PAGE_SIZE),
>                 .end    = PAGE_ALIGN(walk_data.addr + size),
>                 .walker = walker,
>         };
>
> -       return _kvm_pgtable_walk(&walk_data);
> +       return _kvm_pgtable_walk(pgt, &walk_data);
>  }
>
>  struct leaf_walk_data {
> --
> 2.38.1.431.g37b22c650d-goog
>
