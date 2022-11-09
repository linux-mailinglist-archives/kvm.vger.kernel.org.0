Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C315C62368B
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 23:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiKIW06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 17:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiKIW0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 17:26:41 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEC22EF72
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 14:26:31 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id cg5so28870qtb.12
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 14:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oAUOBMxP8dB8Ir4YssWbNkMVg9cZDpEfU9BX91rgGak=;
        b=VeneRhq1xpr9sS7YxPejbDBhvhUuXA02tdqAXvI4g0QCXwvd8iv715JsOCFB1ba/YM
         hh30GYXP4CeXVDi8TiUJB0eOSF0Njs91ayxyuzLheDPSeJPYN8BkKE4Fo7X9fbYRvS5x
         6PgQXKofa/HI12TNokqBYytIhXXjkqCujYKqJ4EEPtccpU/KiLDNg71HIaoWzKKovBIX
         MRciazrFLm49uyl/LlGZlXs3CKly5WesDB/GkiystWQbyFBIX86FhWMzox4t9nKyMtA1
         gUfHFE7acbAQkU3/k+67fke7tx2eaHCLmJM827CJVY8y4btUbC0Ps4xHRoz/79XLe7O+
         K8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oAUOBMxP8dB8Ir4YssWbNkMVg9cZDpEfU9BX91rgGak=;
        b=CQuA9htfvnHXlIfg3fp8MBiLP55K/z00rxZdaJjIjZcejULo5BA4/B9andOlLXqC8r
         eUyvSx6uKa4LXz7PNLRwNYWEMCPTZYUJZ2DqVO1EMfuFsJtpjBCeV5WNQWmQHwbc4F88
         swu6EYBli1GwU5ZNllniUkgbYsQHCYrCvxQjMOY1lqaY7cxCiY7X8E0//W9mmPwjSB9K
         GRTO4JDAeTTd2m2EfNq5w+64HkiVD/EkDdUx+YwIZALXUp+Hty7Z2TjlDNh/CPexSLAY
         N2URA9FJ8M0luFzXJZYt3EqrJbzwqMmSL5a3oKMq2pA6OOVfTSeI7DPy1OU1CFXKCFn/
         6WjA==
X-Gm-Message-State: ACrzQf2qz66BArI8K10lRCx80X9gTlXGUpFD3JA6qawp3l+uQZ9d/m71
        If9INfMZiw8HsJoss6ZH7R6g7HkXIkrkP5ztG7Q9UA==
X-Google-Smtp-Source: AMsMyM5Arj5J8c++baYRrsSAnGqOSTXeqtq+H9LxLTEfx8wPShN5wDgxrWhBJQMRLwIIQoeb2vb9+dRXg347LtQre4o=
X-Received: by 2002:ac8:7d4d:0:b0:3a5:5987:432b with SMTP id
 h13-20020ac87d4d000000b003a55987432bmr26360282qtb.566.1668032790527; Wed, 09
 Nov 2022 14:26:30 -0800 (PST)
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215644.1895162-10-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-10-oliver.upton@linux.dev>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 9 Nov 2022 14:26:19 -0800
Message-ID: <CANgfPd9SK=9jUYh+aMXwYCf2-JtoJtSZ_BDmbjiZX=nvG-9uXA@mail.gmail.com>
Subject: Re: [PATCH v5 09/14] KVM: arm64: Atomically update stage 2 leaf
 attributes in parallel walks
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
> The stage2 attr walker is already used for parallel walks. Since commit
> f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission relaxation
> during dirty logging"), KVM acquires the read lock when
> write-unprotecting a PTE. However, the walker only uses a simple store
> to update the PTE. This is safe as the only possible race is with
> hardware updates to the access flag, which is benign.
>
> However, a subsequent change to KVM will allow more changes to the stage
> 2 page tables to be done in parallel. Prepare the stage 2 attribute
> walker by performing atomic updates to the PTE when walking in parallel.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d8d963521d4e..a34e2050f931 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -185,7 +185,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>                                       kvm_pteref_t pteref, u32 level)
>  {
>         enum kvm_pgtable_walk_flags flags = data->walker->flags;
> -       kvm_pte_t *ptep = kvm_dereference_pteref(pteref, false);
> +       kvm_pte_t *ptep = kvm_dereference_pteref(pteref, flags & KVM_PGTABLE_WALK_SHARED);
>         struct kvm_pgtable_visit_ctx ctx = {
>                 .ptep   = ptep,
>                 .old    = READ_ONCE(*ptep),
> @@ -675,6 +675,16 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>         return !!pte;
>  }
>
> +static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
> +{
> +       if (!kvm_pgtable_walk_shared(ctx)) {
> +               WRITE_ONCE(*ctx->ptep, new);
> +               return true;
> +       }
> +
> +       return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
> +}
> +
>  static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
>                            struct kvm_pgtable_mm_ops *mm_ops)
>  {
> @@ -986,7 +996,9 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                     stage2_pte_executable(pte) && !stage2_pte_executable(ctx->old))
>                         mm_ops->icache_inval_pou(kvm_pte_follow(pte, mm_ops),
>                                                   kvm_granule_size(ctx->level));
> -               WRITE_ONCE(*ctx->ptep, pte);
> +
> +               if (!stage2_try_set_pte(ctx, pte))
> +                       return -EAGAIN;
>         }
>
>         return 0;
> @@ -995,7 +1007,7 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>                                     u64 size, kvm_pte_t attr_set,
>                                     kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
> -                                   u32 *level)
> +                                   u32 *level, enum kvm_pgtable_walk_flags flags)
>  {
>         int ret;
>         kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
> @@ -1006,7 +1018,7 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>         struct kvm_pgtable_walker walker = {
>                 .cb             = stage2_attr_walker,
>                 .arg            = &data,
> -               .flags          = KVM_PGTABLE_WALK_LEAF,
> +               .flags          = flags | KVM_PGTABLE_WALK_LEAF,
>         };
>
>         ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> @@ -1025,14 +1037,14 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>         return stage2_update_leaf_attrs(pgt, addr, size, 0,
>                                         KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
> -                                       NULL, NULL);
> +                                       NULL, NULL, 0);
>  }
>
>  kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
>  {
>         kvm_pte_t pte = 0;
>         stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> -                                &pte, NULL);
> +                                &pte, NULL, 0);
>         dsb(ishst);
>         return pte;
>  }
> @@ -1041,7 +1053,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
>  {
>         kvm_pte_t pte = 0;
>         stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
> -                                &pte, NULL);
> +                                &pte, NULL, 0);
>         /*
>          * "But where's the TLBI?!", you scream.
>          * "Over in the core code", I sigh.
> @@ -1054,7 +1066,7 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
>  bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
>  {
>         kvm_pte_t pte = 0;
> -       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL);
> +       stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, 0);

Would be nice to have an enum for KVM_PGTABLE_WALK_EXCLUSIVE so this
doesn't just have to pass 0.


>         return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
>  }
>
> @@ -1077,7 +1089,8 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>         if (prot & KVM_PGTABLE_PROT_X)
>                 clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
>
> -       ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
> +       ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
> +                                      KVM_PGTABLE_WALK_SHARED);
>         if (!ret)
>                 kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
>         return ret;
> --
> 2.38.1.431.g37b22c650d-goog
>
