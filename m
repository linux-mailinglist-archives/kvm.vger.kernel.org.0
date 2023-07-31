Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FDB76A05C
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 20:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjGaS0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 14:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjGaS0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 14:26:23 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DD9E79
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:26:22 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-348c7075afcso12485ab.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690827981; x=1691432781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6LZEdaDlAMdQP6JhmjsArIuxox1zxEtjjTY2SzD6PsU=;
        b=5fgkkTfZTjvrkPsV2OAsWS7fGDKlkOo6NBkGxlUad6Djf9YF4mNXTcZwmQCCLJ1nBy
         ytvPZa3KoE6pLMDaS1L4gdmZaOfNzKXtsa1fikLeZSNL0jSNWYpUTY8GHiEMpPSUIhEf
         GKZr2wZjg6oExHWyVPblSGkoydBcnRJu278I6bHizaXll85ZaXfkAb9ISQ34veJLXVin
         H4LgRU66ITkpG1C45xmAlPZe5ifFrojIcI163nCjGKu3BAHmTrdfA2g91PJ4XmMzNAwE
         6qNdJbd/ZgVe0FTRRBae2q8TCC7NnJ6KmTDr6JnJgqJf5rkyLUFJCut3v7Lu9kIPHxwj
         tGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690827981; x=1691432781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6LZEdaDlAMdQP6JhmjsArIuxox1zxEtjjTY2SzD6PsU=;
        b=IYLSuUikl+cZrY9Vv1QVVBBo9+w2rDDNeG/79I9uBsCEIUJHgMaK+3KNLrxDRni9G5
         kv8Hklyi8Rb1S8x3psZNYhJsXE9gL+7xNpk6sRpDRGUIAiEi2HeBKKdkQd5K7hchaUfI
         A6+5VpUedkCS8FwhQekDeFGmeXXPF0SzYhcCc58Au9J9xcW3wTKzOJIMnPY8819Ot8ke
         m124LmrI8WrXohwbcP23MGuKtKYjOOyFo6Pt7YzL5TDA1lxWa7VRVM4WIrGH3n5I42mC
         Gu7eBahdvhRyHwBvQs8fyn15ireHmUNkE6fn9AZMAryLFVAajGlhXPjTB+ljwuhLEiMs
         PMsg==
X-Gm-Message-State: ABy/qLZmVV9XffLwOtJGJz+mpsDA3FAdBzyCW/JXRQiUFEfDbjd7BRlU
        ZNB/We5z/2ltB9vW2d6KB0p2ix8daq0z+uPERUQeA9nxTBz5AXg9GU9sr2jZ
X-Google-Smtp-Source: APBJJlHJ2q+Ibhsyd21GC77gr96XZana1MhNnQDJBDO6Init3JyGxBHBc9FYe6705xtGHxT1vNNwqYdqSlhzUk4wwtA=
X-Received: by 2002:a05:6e02:16c5:b0:345:dcdf:206b with SMTP id
 5-20020a056e0216c500b00345dcdf206bmr693992ilx.25.1690827981339; Mon, 31 Jul
 2023 11:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-13-rananta@google.com>
 <87jzulqz0v.wl-maz@kernel.org>
In-Reply-To: <87jzulqz0v.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 31 Jul 2023 11:26:09 -0700
Message-ID: <CAJHc60zGzAqWw2iZwNEG_bWERXkz_io7ae-K_tf_kh6xcOBxLA@mail.gmail.com>
Subject: Re: [PATCH v7 12/12] KVM: arm64: Use TLBI range-based intructions for unmap
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 6:12=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Sat, 22 Jul 2023 03:22:51 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > The current implementation of the stage-2 unmap walker traverses
> > the given range and, as a part of break-before-make, performs
> > TLB invalidations with a DSB for every PTE. A multitude of this
> > combination could cause a performance bottleneck on some systems.
> >
> > Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
> > invalidations until the entire walk is finished, and then
> > use range-based instructions to invalidate the TLBs in one go.
> > Condition deferred TLB invalidation on the system supporting FWB,
> > as the optimization is entirely pointless when the unmap walker
> > needs to perform CMOs.
> >
> > Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
> > now serves the stage-2 unmap walker specifically, rather than
> > acting generic.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 67 +++++++++++++++++++++++++++++++-----
> >  1 file changed, 58 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 5ef098af1736..cf88933a2ea0 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -831,16 +831,54 @@ static void stage2_make_pte(const struct kvm_pgta=
ble_visit_ctx *ctx, kvm_pte_t n
> >       smp_store_release(ctx->ptep, new);
> >  }
> >
> > -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, st=
ruct kvm_s2_mmu *mmu,
> > -                        struct kvm_pgtable_mm_ops *mm_ops)
> > +struct stage2_unmap_data {
> > +     struct kvm_pgtable *pgt;
> > +     bool defer_tlb_flush_init;
> > +};
> > +
> > +static bool __stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
> > +{
> > +     /*
> > +      * If FEAT_TLBIRANGE is implemented, defer the individual
> > +      * TLB invalidations until the entire walk is finished, and
> > +      * then use the range-based TLBI instructions to do the
> > +      * invalidations. Condition deferred TLB invalidation on the
> > +      * system supporting FWB, as the optimization is entirely
> > +      * pointless when the unmap walker needs to perform CMOs.
> > +      */
> > +     return system_supports_tlb_range() && stage2_has_fwb(pgt);
> > +}
> > +
> > +static bool stage2_unmap_defer_tlb_flush(struct stage2_unmap_data *unm=
ap_data)
> > +{
> > +     bool defer_tlb_flush =3D __stage2_unmap_defer_tlb_flush(unmap_dat=
a->pgt);
> > +
> > +     /*
> > +      * Since __stage2_unmap_defer_tlb_flush() is based on alternative
> > +      * patching and the TLBIs' operations behavior depend on this,
> > +      * track if there's any change in the state during the unmap sequ=
ence.
> > +      */
> > +     WARN_ON(unmap_data->defer_tlb_flush_init !=3D defer_tlb_flush);
> > +     return defer_tlb_flush;
>
> I really don't understand what you're testing here. The ability to
> defer TLB invalidation is a function of the system capabilities
> (range+FWB) and a single flag that is only set on the host for pKVM.
>
> How could that change in the middle of the life of the system? if
> further begs the question about the need for the unmap_data data
> structure.
>
> It looks to me that we could simply pass the pgt pointer around and be
> done with it. Am I missing something obvious?
>
From one of the previous comments [1] (used in a different context),
I'm given to understand that since these feature checks are governed
by alternative patching, they can potentially change (at runtime?). Is
that not the case and I have misunderstood the idea in comment [1]
entirely? Is it solely used for optimization purposes and set only
once?
If that's the case, I can get rid of the WARN_ON() and unmap_data.

- Raghavendra

[1]: https://lore.kernel.org/all/ZGPPj1AXS0Uah2Ug@linux.dev/
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
