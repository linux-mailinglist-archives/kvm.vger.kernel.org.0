Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0F5769F8F
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 19:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjGaRhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 13:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjGaRhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 13:37:00 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1DA1B7
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:36:59 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1bbb3195013so12475ad.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 10:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690825019; x=1691429819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqwUjf4srHS0GmV2PrhboWOP/pK2frD9PFN9eIO2JAw=;
        b=PW7uXs8te+DjBD/konvGzLWP8g1fMK7bveuEGlOTMiFVF5fJOURsOxjYwDa4V8/7PN
         GfxiTdGyn4gNxwwJEsgm5Sa3Z07XoIws8zOegDuEUNdgEakGsCpulFVJ68YDWRx8hG7J
         pHEIHY9NNGcOKqt3EcY+H5XjDJYzQb9r6s9KF29xhh5Zs48JdBGHLJzvx9IIdfAb6DL2
         uvolYf+4ofy8X/EQBFsrD9bL5wC/3Jo2GpoHAsbLgZmiKj7F/6zz+pRJOqtmGCUykUqb
         cXxdJcVUj2aUL7x0X6KpmqFqe34XSu2p4AB041J8zGtZ22s2J/6FLShweArcanRRNTIu
         x2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690825019; x=1691429819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqwUjf4srHS0GmV2PrhboWOP/pK2frD9PFN9eIO2JAw=;
        b=SNqPfkRkmDd6egwiDVi4k+lO3ZFZvPOgARnnc3h8/AXoOWb/KzUNmnvOBRvKavmn09
         hkAyugp6JBdTEOmfMES+WsAo/83zR3vnTTwDBnZRwiyIU3A/1wseLN30Yes7SWnaO32H
         viFEYgjzxxv6Qqcli8AOs34UYvKd1arV2UPEXx2FSbZ0p1t6H5TGTMr25PRdsbbKegGE
         cEKmZub7sDXJSX7dUrpcjsDT7mNJ890G/O6ii7Jazfqv1SvyrEUdPPZZxiOmQc+yslkF
         9BVlJ0ehDhh+yFTwQeKBUxRIsH8Lb4LCeDYVlmw5ildg0MOpgKaDl0UKJuc1ueUnGddB
         kflA==
X-Gm-Message-State: ABy/qLZX/HZuN6AE+cm9LTTKBzA+vsH7AkFA/xd0kOX8d7tevdI1fITI
        Eb4ujf1u17S9+BccoJmateyCzrm0/xUz8EuSw8pMGw==
X-Google-Smtp-Source: APBJJlFkMuLyTHjACrkUI9ojOs57IF7oGguBdj8b71/dF8frxz4uOZLWejmA7Zhtt9x/0OUhO69yCloZOMPgYxPCZgE=
X-Received: by 2002:a17:902:c410:b0:1b8:82c6:9e11 with SMTP id
 k16-20020a170902c41000b001b882c69e11mr381793plk.0.1690825018566; Mon, 31 Jul
 2023 10:36:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-7-rananta@google.com>
 <87r0otr579.wl-maz@kernel.org>
In-Reply-To: <87r0otr579.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 31 Jul 2023 10:36:47 -0700
Message-ID: <CAJHc60zqOeWXf3kh5hKL6DL3g4znmHaH-TqC0QDcBrWPsHAEXQ@mail.gmail.com>
Subject: Re: [PATCH v7 06/12] arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
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
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
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

On Thu, Jul 27, 2023 at 3:58=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Sat, 22 Jul 2023 03:22:45 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Currently, the core TLB flush functionality of __flush_tlb_range()
> > hardcodes vae1is (and variants) for the flush operation. In the
> > upcoming patches, the KVM code reuses this core algorithm with
> > ipas2e1is for range based TLB invalidations based on the IPA.
> > Hence, extract the core flush functionality of __flush_tlb_range()
> > into its own macro that accepts an 'op' argument to pass any
> > TLBI operation, such that other callers (KVM) can benefit.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >  arch/arm64/include/asm/tlbflush.h | 109 +++++++++++++++---------------
> >  1 file changed, 56 insertions(+), 53 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm=
/tlbflush.h
> > index 412a3b9a3c25..f7fafba25add 100644
> > --- a/arch/arm64/include/asm/tlbflush.h
> > +++ b/arch/arm64/include/asm/tlbflush.h
> > @@ -278,14 +278,62 @@ static inline void flush_tlb_page(struct vm_area_=
struct *vma,
> >   */
> >  #define MAX_TLBI_OPS PTRS_PER_PTE
> >
> > +/* When the CPU does not support TLB range operations, flush the TLB
> > + * entries one by one at the granularity of 'stride'. If the TLB
> > + * range ops are supported, then:
>
> Comment format (the original was correct).
>
Isn't the format the same as original? Or are you referring to the
fact that it needs to be placed inside the macro definition?
> > + *
> > + * 1. If 'pages' is odd, flush the first page through non-range
> > + *    operations;
> > + *
> > + * 2. For remaining pages: the minimum range granularity is decided
> > + *    by 'scale', so multiple range TLBI operations may be required.
> > + *    Start from scale =3D 0, flush the corresponding number of pages
> > + *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
> > + *    until no pages left.
> > + *
> > + * Note that certain ranges can be represented by either num =3D 31 an=
d
> > + * scale or num =3D 0 and scale + 1. The loop below favours the latter
> > + * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
> > + */
> > +#define __flush_tlb_range_op(op, start, pages, stride,                =
       \
> > +                             asid, tlb_level, tlbi_user)             \
>
> If you make this a common macro, please document the parameters, and
> what the constraints are. For example, what does tlbi_user mean for an
> IPA invalidation?
>
Sure, I'll document the parameters. That'll be helpful.

- Raghavendra
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
