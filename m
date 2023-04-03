Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827186D5378
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 23:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbjDCV0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 17:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbjDCV0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 17:26:06 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79AF46AB
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 14:26:01 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id f24-20020a4aeb18000000b0053b78077c9dso4856317ooj.12
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 14:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680557161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kj5a1Gjv5u3ed9nScVQuCJw/TrKNl0CS2e9DPpgpMXA=;
        b=mgVL+rENIqJd9I9v7V0Guir9ljCZePQyRnCXisG5f1mOrzACjXVqszlL/X48Vanzo1
         CjSAKSQ0mdQ3p/mVUVSOmzOOqszaQHXxfclviPRo7GCBAmHcdoGZhoxlEQaU8vjkjidC
         JWA048aq1fb0aq47KQ58KMM30zZ5KBhy6EsFxZzk0M2LfmX4jpgE6Ql0UflKmsqGB0qR
         Z9m3xzs0lYj8z/0uAiioNURmyO3StSqsmubWQ0qfIG9mfMR9plqhEZixLkCYodxZuzUN
         GB0dBemlcOud2MslvusZ4ZQYOnAkm0OQ8dplUsrUoKquub/JZFFSyNLdq6+HzrSlFfeF
         DNrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kj5a1Gjv5u3ed9nScVQuCJw/TrKNl0CS2e9DPpgpMXA=;
        b=Y5rP23agGrtf4c3cUisPjObzNyJqW48PyNxXJBDxD/tdTxUlSFFXEWIxkTur3T/ni8
         +5Jplm4gExxkCpDqqT3wYQj2FCg4JsZYFvDIQ5FL1KkpLIkO0g27NSfBmT1RwnFkP+e+
         hXdkNp8c8R4yhB0ydGpPZCNRUXZyk4dlcus/zkkjPskUXLT3+yS1MKaHscB6meSFUbEc
         2mww9tCshcT6muZRNWSGR7CcdIWSmordRChWljOBiUBoKqVmIizPMzmVBOskWu8iao9N
         x+FHzuw/iD6DHGvvlsDqHlM9qCS3eJpZLOfdeUmVIT7ytFSBLRfkdXdN4IEkxcHSATMO
         5vSw==
X-Gm-Message-State: AAQBX9eKB4uXEeLsIWSxneB2SF/g95sD6zz+NTTREwdb0Asc9qEFhGWj
        Hb0LoOhto/SFwwCZWI+PzDiweX/WZ2H2lSaF7vyiWw==
X-Google-Smtp-Source: AKy350Zqul6mVyvawVN/gE10vGUZ571dKlqpaiOYYFKigQGJiSFxqug/tZdueykq19XibUWA6mbqM9ZFY60UoL6xlFM=
X-Received: by 2002:a4a:a406:0:b0:53e:944:8896 with SMTP id
 v6-20020a4aa406000000b0053e09448896mr354553ool.0.1680557160674; Mon, 03 Apr
 2023 14:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-7-rananta@google.com>
 <ZCTVFYd2oJnGR6O+@linux.dev>
In-Reply-To: <ZCTVFYd2oJnGR6O+@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 3 Apr 2023 14:25:49 -0700
Message-ID: <CAJHc60wfkYiO95c-oY1jSNyRBLtjBvr6bDDbBw26DxqiY4MSmA@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Break the table entries using TLBI
 range instructions
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

On Wed, Mar 29, 2023 at 5:17=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> nit: s/break/invalidate/g
>
> There is a rather important degree of nuance there. 'Break' as it
> relates to break-before-make implies that the PTE is made invalid and
> visible to hardware _before_ a subsequent invalidation. There will be
> systems that relax this requirement and also support TLBIRANGE.
>
> On Mon, Feb 06, 2023 at 05:23:39PM +0000, Raghavendra Rao Ananta wrote:
>
> Some nitpicking on the changelog:
>
> > Currently, when breaking up the stage-2 table entries, KVM
>
> 'breaking up stage-2 table entries' is rather ambiguous. Instead
> describe the operation taking place on the page tables (i.e. hugepage
> collapse).
>
> > would flush the entire VM's context using 'vmalls12e1is'
> > TLBI operation. One of the problematic situation is collapsing
> > table entries into a hugepage, specifically if the VM is
> > faulting on many hugepages (say after dirty-logging). This
> > creates a performance penality for the guest whose pages have
>
> typo: penalty
>
> > already been faulted earlier as they would have to refill their
> > TLBs again.
> >
> > Hence, if the system supports it, use __kvm_tlb_flush_range_vmid_ipa()
>
> > to flush only the range of pages governed by the table entry,
> > while leaving other TLB entries alone. An upcoming patch also
> > takes advantage of this when breaking up table entries during
> > the unmap operation.
>
> Language regarding an upcoming patch isn't necessary, as this one stands
> on its own (implements and uses a range-based invalidation helper).
>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.=
c
> > index b11cf2c618a6c..0858d1fa85d6b 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -686,6 +686,20 @@ static bool stage2_try_set_pte(const struct kvm_pg=
table_visit_ctx *ctx, kvm_pte_
> >       return cmpxchg(ctx->ptep, ctx->old, new) =3D=3D ctx->old;
> >  }
> >
> > +static void kvm_pgtable_stage2_flush_range(struct kvm_s2_mmu *mmu, u64=
 start, u64 end,
> > +                                             u32 level, u32 tlb_level)
> > +{
> > +     if (system_supports_tlb_range())
>
> You also check this in __kvm_tlb_flush_range(), ideally this should be
> done exactly once per call.
>
> > +             kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, mmu, start, =
end, level, tlb_level);
> > +     else
> > +             /*
> > +              * Invalidate the whole stage-2, as we may have numerous =
leaf
> > +              * entries below us which would otherwise need invalidati=
ng
> > +              * individually.
> > +              */
> > +             kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > +}
> > +
> >  /**
> >   * stage2_try_break_pte() - Invalidates a pte according to the
> >   *                       'break-before-make' requirements of the
> > @@ -721,10 +735,13 @@ static bool stage2_try_break_pte(const struct kvm=
_pgtable_visit_ctx *ctx,
> >        * Perform the appropriate TLB invalidation based on the evicted =
pte
> >        * value (if any).
> >        */
> > -     if (kvm_pte_table(ctx->old, ctx->level))
> > -             kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > -     else if (kvm_pte_valid(ctx->old))
> > +     if (kvm_pte_table(ctx->old, ctx->level)) {
> > +             u64 end =3D ctx->addr + kvm_granule_size(ctx->level);
> > +
> > +             kvm_pgtable_stage2_flush_range(mmu, ctx->addr, end, ctx->=
level, 0);
> > +     } else if (kvm_pte_valid(ctx->old)) {
> >               kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ct=
x->level);
> > +     }
> >
> >       if (stage2_pte_is_counted(ctx->old))
> >               mm_ops->put_page(ctx->ptep);
> > --
> > 2.39.1.519.gcb327c4b5f-goog
> >
> >
ACK on all of the comments. I'll address them in next revision.

Thank you.
Raghavendra
>
> --
> Thanks,
> Oliver
