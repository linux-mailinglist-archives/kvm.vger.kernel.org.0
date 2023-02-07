Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A3768DFA9
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 19:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjBGSPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 13:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjBGSPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 13:15:36 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAE03A876
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 10:15:34 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id d6-20020a17090ae28600b00230aa72904fso7545563pjz.5
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 10:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ki5DOsdj+I7V0iQm8c+gc68aPy9B9pJYIHBnvaR1rFo=;
        b=A07E34blrOf+RFVP72blgH8SbduWvX6cBnnfjRZ2CzllY/8fAJkqPEVNWtIK9VHV3G
         NbHsgqj7AkQ+2sRd9xHvgd5/iJ54AgAJlVf+Z2/iPcX5oXc2Xzkk02jNKgu+6/TL5ugC
         9uo6rAd8z6K0yL55sIIsjZmh+dM5biPINJZdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ki5DOsdj+I7V0iQm8c+gc68aPy9B9pJYIHBnvaR1rFo=;
        b=i9kHMWVJDx/6UqLgnltJYvpxx6zXLdzXHA51sKZQWjJGTnppgVaJ0gte0hnRGzLR/1
         eS4Kspa4ampJ7HyEM4BYjDALaeHoQ4sfIDI77BiLmJxCPrQCPrzfJBA344FzwqnFi48/
         g/+d5pDiOcFQ1A1I0pRAjeH5rAqFlfthQAZgQZSlWAj+/vuInlGZsskR/ATZjdpOqOvc
         zw93o/IUffTvJtKjzCpIT3etBSocHrCKMyu6+jpoJUgzXq2kVqtPkAEd3THw9rFSs4vX
         Z4dj4/m3Wzq6EEfXVHFxBbLJQganE9DjFxBNltWR1Rs/jJ9HVpVTbe/wqr1IuYJpVVwx
         l31A==
X-Gm-Message-State: AO0yUKU42tUhDgYXRbY4Zwg54TsclryLklOPa1sbBTkvDPnOdRzXM19w
        q9OZ9oSjNh1i9ovpMuf6P6Rv3GUr2yMLvghwt04m
X-Google-Smtp-Source: AK7set/YrPhx5DtOD8Hema0OE/cOhtAcN2EmCieWwUvZ0K1SqOrSl8cw8V7VYiGAiEYa2sV/BqvLr1rX2qChP/KNeGA=
X-Received: by 2002:a17:902:d889:b0:199:21af:cba0 with SMTP id
 b9-20020a170902d88900b0019921afcba0mr992775plz.23.1675793734355; Tue, 07 Feb
 2023 10:15:34 -0800 (PST)
MIME-Version: 1.0
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
 <CAK9=C2X8C4yswGhDwe1OzQXTELXQxp8=ayiFxh1aVMk4TxeDjw@mail.gmail.com> <Y+KS16ZNXrDU+xun@spud>
In-Reply-To: <Y+KS16ZNXrDU+xun@spud>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 7 Feb 2023 10:15:22 -0800
Message-ID: <CAOnJCUKKRRCrKN17ytczYXVLTcMkFaZsg6QXKjPUuSk=PqL6JQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
To:     Conor Dooley <conor@kernel.org>,
        Stephano Cetola <stephano@riscv.org>,
        Jeff Scheel <jeff@riscv.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, pbonzini@redhat.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 7, 2023 at 10:05 AM Conor Dooley <conor@kernel.org> wrote:
>
> Hey Anup, Palmer,
>
> On Fri, Feb 03, 2023 at 05:31:01PM +0530, Anup Patel wrote:
> > On Fri, Feb 3, 2023 at 5:54 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
> > >
> > > On Fri, 27 Jan 2023 23:27:32 PST (-0800), apatel@ventanamicro.com wrote:
> > > > We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs)
> > > > and Ssaia (S-mode AIA CSRs).
> > >
> > > This has pretty much the same problem that we had with the other
> > > AIA-related ISA string patches, where there's that ambiguity with the
> > > non-ratified chapters.  IIRC when this came up in GCC the rough idea was
> > > to try and document that we're going to interpret the standard ISA
> > > strings that way, but now that we're doing custom ISA extensions it
> > > seems saner to just define on here that removes the ambiguity.
> > >
> > > I just sent
> > > <https://lore.kernel.org/r/20230203001201.14770-1-palmer@rivosinc.com/>
> > > which documents that.
> >
> > I am not sure why you say that these are custom extensions.
> >
> > Multiple folks have clarified that both Smaia and Ssaia are frozen
> > ISA extensions as-per RVI process. The individual chapters which
> > are in the draft state have nothing to do with Smaia and Ssaia CSRs.
> >
> > Please refer:
> > https://github.com/riscv/riscv-aia/pull/36
> > https://lists.riscv.org/g/tech-aia/message/336
> > https://lists.riscv.org/g/tech-aia/message/337
>
> All of these links seem to discuss the draft chapters somehow being
> incompatible with the non-draft ones. I would very expect that that,
> as pointed out in several places there, that the draft chapters
> finalisation would not lead to meaningful (and incompatible!) changes
> being made to the non-draft chapters.
>

Here is the status of all RVI specs. It states that the Smaia, Ssaia
extensions are frozen (i.e. public review complete).
https://wiki.riscv.org/display/HOME/Specification+Status

I have added stephano/Jeff to confirm the same.

AFAIK, IOMMU spec is close to the public review phase and should be
frozen in this or next quarter.
IIRC, this chapter in AIA will be frozen along with IOMMU spec.

Anup: Please correct me if that's not correct.

> Maybe yourself and Palmer are looking at this from different
> perspectives? Looking at his patch from Friday:
> https://lore.kernel.org/linux-riscv/20230203001201.14770-1-palmer@rivosinc.com/
> He specifically mentioned this aspect, as opposed to the aspect that
> your links refer to.
>
> Surely a duo-plic, if that ever comes to be, could be detected from
> compatible strings in DT or w/e - but how do you intend differentiating
> between an implementation of S*aia that contains the IOMMU support in
> Chapter 9 in a finalised form, versus an implementation that may make
> "different decisions" when it comes to that chapter of the spec?

We will most likely have an extension specific to iommu spec as well.

> I thought that would be handled by extension versions, but I am told
> that those are not a thing any more.
> If that's not true, and there'll be a version number that we can pull in
> from a DT and parse which will distinguish between the two, then please
> correct my misunderstanding here!
>
> Thanks,
> Conor.
>
> > > > We extend the ISA string parsing to detect Smaia and Ssaia extensions.
> > > >
> > > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > > > ---
> > > >  arch/riscv/include/asm/hwcap.h | 2 ++
> > > >  arch/riscv/kernel/cpu.c        | 2 ++
> > > >  arch/riscv/kernel/cpufeature.c | 2 ++
> > > >  3 files changed, 6 insertions(+)
> > > >
> > > > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> > > > index 86328e3acb02..341ef30a3718 100644
> > > > --- a/arch/riscv/include/asm/hwcap.h
> > > > +++ b/arch/riscv/include/asm/hwcap.h
> > > > @@ -59,6 +59,8 @@ enum riscv_isa_ext_id {
> > > >       RISCV_ISA_EXT_ZIHINTPAUSE,
> > > >       RISCV_ISA_EXT_SSTC,
> > > >       RISCV_ISA_EXT_SVINVAL,
> > > > +     RISCV_ISA_EXT_SMAIA,
> > > > +     RISCV_ISA_EXT_SSAIA,
> > > >       RISCV_ISA_EXT_ID_MAX
> > > >  };
> > > >  static_assert(RISCV_ISA_EXT_ID_MAX <= RISCV_ISA_EXT_MAX);
> > > > diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> > > > index 1b9a5a66e55a..a215ec929160 100644
> > > > --- a/arch/riscv/kernel/cpu.c
> > > > +++ b/arch/riscv/kernel/cpu.c
> > > > @@ -162,6 +162,8 @@ arch_initcall(riscv_cpuinfo_init);
> > > >   *    extensions by an underscore.
> > > >   */
> > > >  static struct riscv_isa_ext_data isa_ext_arr[] = {
> > > > +     __RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
> > > > +     __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> > >
> > > This will conflict with that ISA string refactoring I just merged.  It
> > > should be a pretty mechanical merge conflict, but if you want we can do
> > > a shared tag with the first few patches and I can handle the merge
> > > conflict locally.
> >
> > I am planning to send this series as a second PR for Linux-6.3 after your
> > PR (which includes ISA string refactoring) is merged. Is that okay with you?
> >
> > With that said, it would request you to ACK this patch as well.
> >
> > >
> > > >       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> > > >       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> > > >       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> > > > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> > > > index 93e45560af30..3c5b51f519d5 100644
> > > > --- a/arch/riscv/kernel/cpufeature.c
> > > > +++ b/arch/riscv/kernel/cpufeature.c
> > > > @@ -228,6 +228,8 @@ void __init riscv_fill_hwcap(void)
> > > >                               SET_ISA_EXT_MAP("zihintpause", RISCV_ISA_EXT_ZIHINTPAUSE);
> > > >                               SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
> > > >                               SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
> > > > +                             SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SMAIA);
> > > > +                             SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SSAIA);
> > > >                       }
> > > >  #undef SET_ISA_EXT_MAP
> > > >               }
> >
> > Thanks,
> > Anup



-- 
Regards,
Atish
