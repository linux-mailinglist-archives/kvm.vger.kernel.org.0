Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E560E6D6AEB
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 19:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbjDDRwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 13:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbjDDRwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 13:52:17 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBE43AAC
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 10:52:14 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-17ebba88c60so35496721fac.3
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 10:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680630733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNm7ut5xw3YZveb3bi0ZcN2eShh+vdiK3vTRJbWEvZA=;
        b=h2tJpzO+g3ZA7Mm7KbV9GPDwwOmXm1vnpvbntR367mW0dQav+pdZcj+f50RJIi6beM
         tVxQJoFUESXI9XyuMrhwrLaOBoK0n+pJvu+rtplmt2eErJQNf032DN6A4hI9pGU7nOqV
         rA4QUKDX2VY4sFlKjFptHf+4iiEDFyv7prc6Q5h2TOLHRM3Q7b77VNFimBQ+9XvOveN1
         DzO6yQYD9660QaKaDSCGQc7rJrxfjCPklNv041UJdiHriaz9/nvtuSsG5es7QrCwbPOP
         cHsKzjlv8Og+hpT6y5ROIw53CeSSVBe8AverjDtAy1Hc7sxC/vZQE8D2m+d8fvdnbtuF
         cmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680630733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yNm7ut5xw3YZveb3bi0ZcN2eShh+vdiK3vTRJbWEvZA=;
        b=h1BWHCbq5kEQ2hZPu/PKoU9Foi4312U0qi2VstjpyiEGc7tvylnpefSZ/XqcS1foib
         Mu/rCJcfvOSsuBYhFCiGa/X+flMMz5Xf3wgW7X+73Us5TGqktM0GC5NR8RAZyRGytIJF
         /2oYzO7N8r337g0548h8h4e7mw20Uf8w4a7xIM6cVmkDBLkkPEFKylnXciWGPMBRZ/R2
         lg48yQCQ8lH00ty/Mg0aDK07H5TWyrd/Xx/Y5oY8pTfDLAQA6oh2ep0VITg4sn/KdfbL
         CIjfxQ9dD3UHaT3VMzyJ5PhGomqsS7cqpmvDeobzp/kOGRogj7ncf81hrZPJhIOcJJqT
         m10A==
X-Gm-Message-State: AAQBX9cyDtutlaXYuGJOQsNUYeo1B32dwGI1C4MKeBjiyizKRuu3Lwq5
        mf/u/mi/3EdRRGALjFmsq2w+8wBlJ4q89+5/4eS2cA==
X-Google-Smtp-Source: AKy350aclrbPOzMya2Gmn5/BEKwLirIrj5w/kNKlHrChJIP3iEcRqHMaSM3SVKUi/0+yDBbwgDgjPwtuU+n5OtrvPAs=
X-Received: by 2002:a05:6870:57:b0:17e:e396:cce0 with SMTP id
 23-20020a056870005700b0017ee396cce0mr1672458oaz.9.1680630733248; Tue, 04 Apr
 2023 10:52:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-8-rananta@google.com>
 <ZCTa5wfVtGScLQEa@linux.dev>
In-Reply-To: <ZCTa5wfVtGScLQEa@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 4 Apr 2023 10:52:01 -0700
Message-ID: <CAJHc60xvSFpUs+o84fR14Rghd6rruBJkCMBtroeCeLDtjJg=gw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] KVM: arm64: Create a fast stage-2 unmap path
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 5:42=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Feb 06, 2023 at 05:23:40PM +0000, Raghavendra Rao Ananta wrote:
> > The current implementation of the stage-2 unmap walker
> > traverses the entire page-table to clear and flush the TLBs
> > for each entry. This could be very expensive, especially if
> > the VM is not backed by hugepages. The unmap operation could be
> > made efficient by disconnecting the table at the very
> > top (level at which the largest block mapping can be hosted)
> > and do the rest of the unmapping using free_removed_table().
> > If the system supports FEAT_TLBIRANGE, flush the entire range
> > that has been disconnected from the rest of the page-table.
> >
> > Suggested-by: Ricardo Koller <ricarkol@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 44 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index 0858d1fa85d6b..af3729d0971f2 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1017,6 +1017,49 @@ static int stage2_unmap_walker(const struct kvm_=
pgtable_visit_ctx *ctx,
> >       return 0;
> >  }
> >
> > +/*
> > + * The fast walker executes only if the unmap size is exactly equal to=
 the
> > + * largest block mapping supported (i.e. at KVM_PGTABLE_MIN_BLOCK_LEVE=
L),
> > + * such that the underneath hierarchy at KVM_PGTABLE_MIN_BLOCK_LEVEL c=
an
> > + * be disconnected from the rest of the page-table without the need to
> > + * traverse all the PTEs, at all the levels, and unmap each and every =
one
> > + * of them. The disconnected table is freed using free_removed_table()=
.
> > + */
> > +static int fast_stage2_unmap_walker(const struct kvm_pgtable_visit_ctx=
 *ctx,
> > +                            enum kvm_pgtable_walk_flags visit)
> > +{
> > +     struct kvm_pgtable_mm_ops *mm_ops =3D ctx->mm_ops;
> > +     kvm_pte_t *childp =3D kvm_pte_follow(ctx->old, mm_ops);
> > +     struct kvm_s2_mmu *mmu =3D ctx->arg;
> > +
> > +     if (!kvm_pte_valid(ctx->old) || ctx->level !=3D KVM_PGTABLE_MIN_B=
LOCK_LEVEL)
> > +             return 0;
> > +
> > +     if (!stage2_try_break_pte(ctx, mmu))
> > +             return -EAGAIN;
> > +
> > +     /*
> > +      * Gain back a reference for stage2_unmap_walker() to free
> > +      * this table entry from KVM_PGTABLE_MIN_BLOCK_LEVEL - 1.
> > +      */
> > +     mm_ops->get_page(ctx->ptep);
>
> Doesn't this run the risk of a potential UAF if the refcount was 1 before
> calling stage2_try_break_pte()? IOW, stage2_try_break_pte() will drop
> the refcount to 0 on the page before this ever gets called.
>
> Also, AFAICT this misses the CMOs that are required on systems w/o
> FEAT_FWB. Without them it is possible that the host will read something
> other than what was most recently written by the guest if it is using
> noncacheable memory attributes at stage-1.
>
> I imagine the actual bottleneck is the DSB required after every
> CMO/TLBI. Theoretically, the unmap path could be updated to:
>
>  - Perform the appropriate CMOs for every valid leaf entry *without*
>    issuing a DSB.
>
>  - Elide TLBIs entirely that take place in the middle of the walk
>
>  - After the walk completes, dsb(ish) to guarantee that the CMOs have
>    completed and the invalid PTEs are made visible to the hardware
>    walkers. This should be done implicitly by the TLBI implementation
>
>  - Invalidate the [addr, addr + size) range of IPAs
>
> This would also avoid over-invalidating stage-1 since we blast the
> entire stage-1 context for every stage-2 invalidation. Thoughts?
>
Correct me if I'm wrong, but if we invalidate the TLB after the walk
is complete, don't you think there's a risk of race if the guest can
hit in the TLB even though the page was unmapped?

Thanks,
Raghavendra

Raghavendra
> > +     mm_ops->free_removed_table(childp, ctx->level);
> > +     return 0;
> > +}
> > +
>
> --
> Thanks,
> Oliver
