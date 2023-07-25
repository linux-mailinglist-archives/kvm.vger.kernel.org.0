Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5D0762004
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 19:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjGYRXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 13:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjGYRXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 13:23:43 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468141BD5
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 10:23:42 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-346099c6f43so7305ab.0
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 10:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690305821; x=1690910621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qF3sszjf/FrquSylk/9mRr73+l28Kpb/a/YUFbhXNsk=;
        b=VmZvA+x2brUzUH+KemvgtyWwYjvTwhjT3qLhjqHCM5bFgErI9zEQJ5eH5IgUVUpAuJ
         b+y16Wv3NEhx/j+7Unp82pY5Vlw17+m4FTPZTo6mdUi6NypfKOnYIhc8vDN4l44FXi3b
         MFLRNodUMeYL0Kj9YFOQrc0mCabxXY/OS0kDtSKlGU8lqYa1xYO3SjiXTF4BYODs63pR
         CXLjuByBS0nPQrgo6HpGRCT+iPfUUHg5qQkLM2C8QX/J73/FSAuXRdruClViIWGwOcQu
         +MCXVT09fW9Hz1MwOxPP7fQmrftT/DyGhQg/4VS0HI9BnUNvVceAcD94kWujSD3OrOrJ
         uOrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690305821; x=1690910621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qF3sszjf/FrquSylk/9mRr73+l28Kpb/a/YUFbhXNsk=;
        b=LpskSAisRJ+CP4kZEnklmClCKomKJTctp6WhWJFU0ipTEyShzLlEF4ilL5lxm7YF4W
         ydKrwizybzt+/SuaB8Pnkil/dTvTGxNWr2o3Hce97NOZHGFWqBHlFeLX0OQC6b6eFCyH
         rVulzSfd4kg7ja9nwjdMr9/ZgV5+0KKrgf00t82d3CUu9rbrNvh21sa4zjX6tNi43Eo9
         0I5WfoVSz5KCQZcH5mPsO4AAaBd50s5J6ZojDFfVkr2I1IxBtRwvoUpWFdF2bCDjXt5T
         cMhBcVL8KIVPismuuPbucs4EwUyoAVA5qkWj3uwu93ZoFItAvxQZ2f897c8d2iER3KyU
         pX1w==
X-Gm-Message-State: ABy/qLZBr3tu7zpbmCkZByxl44yoM/xPAMYQLhaPc4eosEEvczB5W7b/
        Bl1xJeaC76j1U2V4e7h5PBtO/NkE55iua99LbSFwqQ==
X-Google-Smtp-Source: APBJJlHnKSkz23cMqgDihmAd3S7ocw9dOBIQVbbrr7YrGS16ZbyRrVTTCw1N5MJAqbqik5Kvt4D4vMItqdgr32+IthU=
X-Received: by 2002:a05:6e02:1c83:b0:346:676f:350d with SMTP id
 w3-20020a056e021c8300b00346676f350dmr211797ill.11.1690305821406; Tue, 25 Jul
 2023 10:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-13-rananta@google.com>
 <0841aca6-2824-6a1b-a568-119f8bd220de@redhat.com> <CAJHc60znT5ThqKE3TgTW-0Us3oNv8+KF=81TSK0PbG3tTyJLFQ@mail.gmail.com>
 <7ea9e7a0-508d-0f00-09ae-ae468f111437@redhat.com>
In-Reply-To: <7ea9e7a0-508d-0f00-09ae-ae468f111437@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 25 Jul 2023 10:23:29 -0700
Message-ID: <CAJHc60xaygC8tX8yFnoFM9YqWg8iE6r5d+kugGwO5KZxDtG3rQ@mail.gmail.com>
Subject: Re: [PATCH v7 12/12] KVM: arm64: Use TLBI range-based intructions for unmap
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
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

Hi Shaoqin,

On Mon, Jul 24, 2023 at 7:32=E2=80=AFPM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
>
>
> On 7/25/23 00:47, Raghavendra Rao Ananta wrote:
> > On Mon, Jul 24, 2023 at 2:35=E2=80=AFAM Shaoqin Huang <shahuang@redhat.=
com> wrote:
> >>
> >> Hi Raghavendra,
> >>
> >> On 7/22/23 10:22, Raghavendra Rao Ananta wrote:
> >>> The current implementation of the stage-2 unmap walker traverses
> >>> the given range and, as a part of break-before-make, performs
> >>> TLB invalidations with a DSB for every PTE. A multitude of this
> >>> combination could cause a performance bottleneck on some systems.
> >>>
> >>> Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
> >>> invalidations until the entire walk is finished, and then
> >>> use range-based instructions to invalidate the TLBs in one go.
> >>> Condition deferred TLB invalidation on the system supporting FWB,
> >>> as the optimization is entirely pointless when the unmap walker
> >>> needs to perform CMOs.
> >>>
> >>> Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
> >>> now serves the stage-2 unmap walker specifically, rather than
> >>> acting generic.
> >>>
> >>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >>> ---
> >>>    arch/arm64/kvm/hyp/pgtable.c | 67 +++++++++++++++++++++++++++++++-=
----
> >>>    1 file changed, 58 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtabl=
e.c
> >>> index 5ef098af1736..cf88933a2ea0 100644
> >>> --- a/arch/arm64/kvm/hyp/pgtable.c
> >>> +++ b/arch/arm64/kvm/hyp/pgtable.c
> >>> @@ -831,16 +831,54 @@ static void stage2_make_pte(const struct kvm_pg=
table_visit_ctx *ctx, kvm_pte_t n
> >>>        smp_store_release(ctx->ptep, new);
> >>>    }
> >>>
> >>> -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, =
struct kvm_s2_mmu *mmu,
> >>> -                        struct kvm_pgtable_mm_ops *mm_ops)
> >>> +struct stage2_unmap_data {
> >>> +     struct kvm_pgtable *pgt;
> >>> +     bool defer_tlb_flush_init;
> >>> +};
> >>> +
> >>> +static bool __stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
> >>> +{
> >>> +     /*
> >>> +      * If FEAT_TLBIRANGE is implemented, defer the individual
> >>> +      * TLB invalidations until the entire walk is finished, and
> >>> +      * then use the range-based TLBI instructions to do the
> >>> +      * invalidations. Condition deferred TLB invalidation on the
> >>> +      * system supporting FWB, as the optimization is entirely
> >>> +      * pointless when the unmap walker needs to perform CMOs.
> >>> +      */
> >>> +     return system_supports_tlb_range() && stage2_has_fwb(pgt);
> >>> +}
> >>> +
> >>> +static bool stage2_unmap_defer_tlb_flush(struct stage2_unmap_data *u=
nmap_data)
> >>> +{
> >>> +     bool defer_tlb_flush =3D __stage2_unmap_defer_tlb_flush(unmap_d=
ata->pgt);
> >>> +
> >>> +     /*
> >>> +      * Since __stage2_unmap_defer_tlb_flush() is based on alternati=
ve
> >>> +      * patching and the TLBIs' operations behavior depend on this,
> >>> +      * track if there's any change in the state during the unmap se=
quence.
> >>> +      */
> >>> +     WARN_ON(unmap_data->defer_tlb_flush_init !=3D defer_tlb_flush);
> >>> +     return defer_tlb_flush;
> >>> +}
> >>> +
> >>> +static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx =
*ctx,
> >>> +                             struct kvm_s2_mmu *mmu,
> >>> +                             struct kvm_pgtable_mm_ops *mm_ops)
> >>>    {
> >>> +     struct stage2_unmap_data *unmap_data =3D ctx->arg;
> >>> +
> >>>        /*
> >>> -      * Clear the existing PTE, and perform break-before-make with
> >>> -      * TLB maintenance if it was valid.
> >>> +      * Clear the existing PTE, and perform break-before-make if it =
was
> >>> +      * valid. Depending on the system support, the TLB maintenance =
for
> >>> +      * the same can be deferred until the entire unmap is completed=
.
> >>>         */
> >>>        if (kvm_pte_valid(ctx->old)) {
> >>>                kvm_clear_pte(ctx->ptep);
> >>> -             kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, =
ctx->level);
> >>> +
> >>> +             if (!stage2_unmap_defer_tlb_flush(unmap_data))
> >> Why not directly check (unmap_data->defer_tlb_flush_init) here?
> >>
> > (Re-sending the reply as the previous one was formatted as HTML and
> > was blocked by many lists)
> >
> > No particular reason per say, but I was just going with the logic of
> > determining if we need to defer the flush and the WARN_ON() parts
> > separate.
> > Any advantage if we directly check in stage2_unmap_put_pte() that I
> > missed or is this purely for readability?
>
> Hi Raghavendra,
>
> I just wondering if before the stage2 walk, we want to defer the tlb
> flush, but if when walk the stage2, the stage2_unmap_defer_tlb_flush()
> trigger the WARN_ON() and return don't defer the tlb flush, it will
> flush the ctx->addr's tlb. But before the WARN_ON() triggered, these tlb
> will not be flushed, since when walk stage2 done in the
> kvm_pgtable_stage2_unmap(), the stage2_unmap_defer_tlb_flush() still
> trigger the WARN_ON() and don't use the tlb range-based flush. Thus some
> of the tlb are not flushed.
>
Excellent point!
> If we directly check the (unmap_data->defer_tlb_flush_init), this isn't
> change during walking the stage2, so the WARN_ON() should only trigger
> in kvm_pgtable_stage2_unmap()->stage2_unmap_defer_tlb_flush().
>
> I'm not sure if it's right since I just think once we set up use the
> TLBI range-based flush, the result of the
> __stage2_unmap_defer_tlb_flush() shouldn't change. Otherwise there must
> have some stale TLB entry.
>
One solution that I can think of is, if the code triggers the
WARN_ON(), we flush the entire VM's TLB using
kvm_call_hyp(__kvm_tlb_flush_vmid) after the entire walk is finished.
In this special/rare situation, it'll be a little expensive, but we
will at least be correct, leaving no stale TLBs behind. WDYT?

Thank you.
Raghavendra
> Thanks,
> Shaoqin
>
> >
> >>> +                     kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> >>> +                                     ctx->addr, ctx->level);
> >> Small indent hint. The ctx->addr can align with __kvm_tlb_flush_vmid_i=
pa.
> >>
> > Ah, yes. I'll adjust this if I send out a v8.
> >
> > Thank you.
> > Raghavendra
> >> Thanks,
> >> Shaoqin
> >>>        }
> >>>
> >>>        mm_ops->put_page(ctx->ptep);
> >>> @@ -1070,7 +1108,8 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgt=
able *pgt, u64 addr, u64 size,
> >>>    static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx =
*ctx,
> >>>                               enum kvm_pgtable_walk_flags visit)
> >>>    {
> >>> -     struct kvm_pgtable *pgt =3D ctx->arg;
> >>> +     struct stage2_unmap_data *unmap_data =3D ctx->arg;
> >>> +     struct kvm_pgtable *pgt =3D unmap_data->pgt;
> >>>        struct kvm_s2_mmu *mmu =3D pgt->mmu;
> >>>        struct kvm_pgtable_mm_ops *mm_ops =3D ctx->mm_ops;
> >>>        kvm_pte_t *childp =3D NULL;
> >>> @@ -1098,7 +1137,7 @@ static int stage2_unmap_walker(const struct kvm=
_pgtable_visit_ctx *ctx,
> >>>         * block entry and rely on the remaining portions being faulte=
d
> >>>         * back lazily.
> >>>         */
> >>> -     stage2_put_pte(ctx, mmu, mm_ops);
> >>> +     stage2_unmap_put_pte(ctx, mmu, mm_ops);
> >>>
> >>>        if (need_flush && mm_ops->dcache_clean_inval_poc)
> >>>                mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old=
, mm_ops),
> >>> @@ -1112,13 +1151,23 @@ static int stage2_unmap_walker(const struct k=
vm_pgtable_visit_ctx *ctx,
> >>>
> >>>    int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u6=
4 size)
> >>>    {
> >>> +     int ret;
> >>> +     struct stage2_unmap_data unmap_data =3D {
> >>> +             .pgt =3D pgt,
> >>> +             .defer_tlb_flush_init =3D __stage2_unmap_defer_tlb_flus=
h(pgt),
> >>> +     };
> >>>        struct kvm_pgtable_walker walker =3D {
> >>>                .cb     =3D stage2_unmap_walker,
> >>> -             .arg    =3D pgt,
> >>> +             .arg    =3D &unmap_data,
> >>>                .flags  =3D KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_T=
ABLE_POST,
> >>>        };
> >>>
> >>> -     return kvm_pgtable_walk(pgt, addr, size, &walker);
> >>> +     ret =3D kvm_pgtable_walk(pgt, addr, size, &walker);
> >>> +     if (stage2_unmap_defer_tlb_flush(&unmap_data))
> >>> +             /* Perform the deferred TLB invalidations */
> >>> +             kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
> >>> +
> >>> +     return ret;
> >>>    }
> >>>
> >>>    struct stage2_attr_data {
> >>
> >> --
> >> Shaoqin
> >>
> >
>
> --
> Shaoqin
>
