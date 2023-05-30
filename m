Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1BA716F97
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 23:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjE3VWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 17:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjE3VWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 17:22:36 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A286E8
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 14:22:35 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-33b7f217dd0so61105ab.0
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 14:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685481754; x=1688073754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYWGHENv8zybDdaEJH6tmDMPpV6HDylna2LuYPkQz90=;
        b=utiJnvqO5LQbYUs2KvkRBvD+rdL3UUtmYQDdEcGZmxA4W34/p9G/E0QMhRZ6w1Dbz2
         7sJZ15VbabKqPv2CtaUcdF0SnWI+zAWV4R0USBdoShANZmu2mPjAMKyuTPbB/JvU+8BC
         A6C5lxH5v82vOfY/hBSJmgZUBZUOZSQWdi/NwRdfkGAmzbxjHAON66foarJqgzcgX0Jz
         ruP9yxFejGiHArv1WllUChi3T/6zY3kzPpjuE3nHOWEQi5HCg+akMTi8aiZvzCyHKUB5
         H4qHTHqHaxbGjMyrd/xOVKTOrSvjBsVI5ZBpbE+5jENDObUKakf+C6f/nUyoa78FxHRN
         +1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685481754; x=1688073754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jYWGHENv8zybDdaEJH6tmDMPpV6HDylna2LuYPkQz90=;
        b=J42kcurl2wfL1wY18fP1aRq/gebPjbsZXq8TO+yqSN60OjJM486btdhxYPJAzs8RF6
         xl+1zObvXabJvGTL8ayiqK6QmdCxF9uZt9BwX0uwx7SqvDgzkbsNTJPv4pulAXSTUCTd
         HUteu6xVsn9quR+/cMxbKy8bCm6GUHwt1UmUlCbos1vITvLPfdO1D5BcL/FS+jAtXbn9
         q5dscxuWsLvEcPExXcfEUEGA60T6UglJAzQmCcAcyupi8MBcKX0mLydBbitvM31pKvgt
         Jl+luhzuOTwfm0JX3LwlEB2Lyuh02QNm/5YS0GX5wphLACJkQ3lh5DCoococgW3Ac87G
         tomg==
X-Gm-Message-State: AC+VfDzsJhPrVA9dMbaBH71O2qZqrpAzhasG+8zsneeFugkGnb2Sulra
        fnRjdhRtyNtQVbYz3ffbKgSNb0K/MIW+oF2WugNaHQ==
X-Google-Smtp-Source: ACHHUZ79g66ZY7C9FY4DInfxll0iOglDkWH3MDSs5ouUxNpRff1YYDmAepJA6yxLXjQdVa0YaQS8C4MWJDCtrTGIolA=
X-Received: by 2002:a05:6e02:170c:b0:335:6626:9f38 with SMTP id
 u12-20020a056e02170c00b0033566269f38mr40933ill.0.1685481754376; Tue, 30 May
 2023 14:22:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com> <20230519005231.3027912-4-rananta@google.com>
 <87v8gbjkzn.wl-maz@kernel.org>
In-Reply-To: <87v8gbjkzn.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 30 May 2023 14:22:23 -0700
Message-ID: <CAJHc60x0iFWOFxcCYpH6bG+CinBM2TmYxvADKwOqDsUFJCr0AA@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Mon, May 29, 2023 at 7:00=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 19 May 2023 01:52:28 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Implement kvm_arch_flush_remote_tlbs_range() for arm64
> > to invalidate the given range in the TLB.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  3 +++
> >  arch/arm64/kvm/hyp/nvhe/tlb.c     |  4 +---
> >  arch/arm64/kvm/mmu.c              | 11 +++++++++++
> >  3 files changed, 15 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 81ab41b84f436..343fb530eea9c 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1081,6 +1081,9 @@ struct kvm *kvm_arch_alloc_vm(void);
> >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> >  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >
> > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages);
> > +
> >  static inline bool kvm_vm_is_protected(struct kvm *kvm)
> >  {
> >       return false;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tl=
b.c
> > index d4ea549c4b5c4..d2c7c1bc6d441 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > @@ -150,10 +150,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu =
*mmu,
> >               return;
> >       }
> >
> > -     dsb(ishst);
> > -
> >       /* Switch to requested VMID */
> > -     __tlb_switch_to_guest(mmu, &cxt);
> > +     __tlb_switch_to_guest(mmu, &cxt, false);
>
> This hunk is in the wrong patch, isn't it?
>
Ah, you are right. It should be part of the previous patch. I think I
introduced it accidentally when I rebased the series. I'll remove it
in the next spin.


> >
> >       __flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false=
);
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index d0a0d3dca9316..e3673b4c10292 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -92,6 +92,17 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> >       return 0;
> >  }
> >
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages)
> > +{
> > +     phys_addr_t start, end;
> > +
> > +     start =3D start_gfn << PAGE_SHIFT;
> > +     end =3D (start_gfn + pages) << PAGE_SHIFT;
> > +
> > +     kvm_call_hyp(__kvm_tlb_flush_vmid_range, &kvm->arch.mmu, start, e=
nd);
>
> So that's the point that I think is not right. It is the MMU code that
> should drive the invalidation method, and not the HYP code. The HYP
> code should be as dumb as possible, and the logic should be kept in
> the MMU code.
>
> So when a range invalidation is forwarded to HYP, it's a *valid* range
> invalidation. not something that can fallback to VMID-wide invalidation.
>
I'm guessing that you are referring to patch-2. Do you recommend
moving the 'pages >=3D MAX_TLBI_RANGE_PAGES' logic here and simply
return an error? How about for the other check:
system_supports_tlb_range()?
The idea was for __kvm_tlb_flush_vmid_range() to also implement a
fallback mechanism in case the system doesn't support the range-based
instructions. But if we end up calling __kvm_tlb_flush_vmid_range()
from multiple cases, we'd end up duplicating the checks. WDYT?


> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
