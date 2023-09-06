Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E542979339C
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 04:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbjIFCNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 22:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjIFCNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 22:13:53 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5FFDA
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 19:13:49 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2bceb02fd2bso47513511fa.1
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 19:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693966427; x=1694571227; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Q4jcgCF7ftimzz25g+kmUfJSzk3mh2KbzYLL9jx8Tk=;
        b=xk5y0q90bNjLCxa/OvSNX6NUZq4VLbbv29RH/kNyVFz0d31BrYx38kKLQ+gWUKgJbC
         De+t6QeP4DhuR47/6E/xeSOKkwBcxea5dFHIUnRRq/N/+cNhcQf4LsWkt7Wwnq4GYpsG
         CPx2LLAGcnzoiXRaMxO8FybD1rtNJu3dnd5iETI7ujAE0g8ll3/Tl3wFivtFVnc+IWcL
         ofdTbqgSvwKRymQYNKUlckMvqIz/r9k2vqugetidA9jDoOEdKdVWyGe0ocaEF3n47obs
         UApAJpbMgOtU1HEGDwEE2OdPB+UIJLcw9esaUf66MgX0s3MVZSfN7fp4MzXJIwwvVU+t
         K+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693966427; x=1694571227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Q4jcgCF7ftimzz25g+kmUfJSzk3mh2KbzYLL9jx8Tk=;
        b=MgmuRrn4VFAAPCS2fNS8wvEv0pgf6cnAqTiy0Vpgg9DMqwZyOlD5cr7ShGTeWb34kd
         ybmaEoro0AK1sslZ7H2zNKJQAY6fOOBMDGjY7OCrEfpabFX7OzDPiAU/xB6DXGRgFqkc
         xZ6MZjZuu0KHJ4iYcA5X/+R2jLrMPnGKcefSKR8FXAuNvVWYuvK15y2IFoIdPCglE1fC
         /EYyq8x2Edgh/ttGL/IKJSD/Mh+JLLOXFP38J9HFtsIceB0UsfxvNQl1sl6uuAiPljuy
         JVAojQDDbYjjcgZINeK/qwJ7t1D7rx0SIPVikNvwtq8K2RlaYD9Y96uYCZc+NdOpwQgq
         pjRg==
X-Gm-Message-State: AOJu0YyXijnleUdNJ3PpgZIriLtt/P1xYfDi/MbvDw/Pbl0+hqJmw0hL
        ZKJVdxxe56Nk8KSdfojU3Bjosali/5O1GB9H+cdqtA==
X-Google-Smtp-Source: AGHT+IGFwNjv/ZMr8vBZsHgoHcuJi3gsGToAZdjZjs//eJMz6WPWhT7WHmBCHRgewVNQuYU4Usnm1YB78ZoVR9rcExQ=
X-Received: by 2002:a2e:8890:0:b0:2bc:e470:1412 with SMTP id
 k16-20020a2e8890000000b002bce4701412mr1193707lji.43.1693966427422; Tue, 05
 Sep 2023 19:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
 <20230821212243.491660-6-jingzhangos@google.com> <878ra3pndw.wl-maz@kernel.org>
 <CAAdAUti8qSf0PVnWkp4Jua-te6i0cjQKJm=8dt5vWqT0Q6w4iQ@mail.gmail.com>
 <86a5uef55n.wl-maz@kernel.org> <CAAdAUtiNeVrPxThddhFPNNWjyf1hebYkXugdfV2K8LNnT0yaQg@mail.gmail.com>
In-Reply-To: <CAAdAUtiNeVrPxThddhFPNNWjyf1hebYkXugdfV2K8LNnT0yaQg@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 5 Sep 2023 19:13:35 -0700
Message-ID: <CAAdAUtj386UcK+BBJDf+_00yYd1cbiQigSdAbssaJBmb+v32ng@mail.gmail.com>
Subject: Re: [PATCH v9 05/11] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Sun, Aug 27, 2023 at 12:31=E2=80=AFPM Jing Zhang <jingzhangos@google.com=
> wrote:
>
> Hi Marc,
>
> On Sat, Aug 26, 2023 at 3:51=E2=80=AFAM Marc Zyngier <maz@kernel.org> wro=
te:
> >
> > On Tue, 22 Aug 2023 19:35:12 +0100,
> > Jing Zhang <jingzhangos@google.com> wrote:
> > >
> > > Hi Marc,
> > >
> > > On Tue, Aug 22, 2023 at 12:06=E2=80=AFAM Marc Zyngier <maz@kernel.org=
> wrote:
> > > >
> > > > On Mon, 21 Aug 2023 22:22:37 +0100,
> > > > Jing Zhang <jingzhangos@google.com> wrote:
> > > > >
> > > > > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> > > > > from userspace with this change.
> > > > > RES0 fields and those fields hidden by KVM are not writable.
> > > > >
> > > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/sys_regs.c | 6 ++++--
> > > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.=
c
> > > > > index afade7186675..20fc38bad4e8 100644
> > > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > > @@ -1931,6 +1931,8 @@ static bool access_spsr(struct kvm_vcpu *vc=
pu,
> > > > >       return true;
> > > > >  }
> > > > >
> > > > > +#define ID_AA64DFR0_EL1_RES0_MASK (GENMASK(59, 56) | GENMASK(27,=
 24) | GENMASK(19, 16))
> > > > > +
> > > > >  /*
> > > > >   * Architected system registers.
> > > > >   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op=
2
> > > > > @@ -2006,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_de=
scs[] =3D {
> > > > >         .set_user =3D set_id_dfr0_el1,
> > > > >         .visibility =3D aa32_id_visibility,
> > > > >         .reset =3D read_sanitised_id_dfr0_el1,
> > > > > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > > > > +       .val =3D GENMASK(31, 0), },
> > > >
> > > > Can you *please* look at the register and realise that we *don't*
> > > > support writing to the whole of the low 32 bits? What does it mean =
to
> > > > allow selecting the M-profile debug? Or the memory-mapped trace?
> > > >
> > > > You are advertising a lot of crap to userspace, and that's definite=
ly
> > > > not on.
> > > >
> > > > >       ID_HIDDEN(ID_AFR0_EL1),
> > > > >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> > > > >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > > > > @@ -2055,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_de=
scs[] =3D {
> > > > >         .get_user =3D get_id_reg,
> > > > >         .set_user =3D set_id_aa64dfr0_el1,
> > > > >         .reset =3D read_sanitised_id_aa64dfr0_el1,
> > > > > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > > > > +       .val =3D ~(ID_AA64DFR0_EL1_PMSVer_MASK | ID_AA64DFR0_EL1_=
RES0_MASK), },
> > > >
> > > > And it is the same thing here. Where is the handling code to deal w=
ith
> > > > variable breakpoint numbers? Oh wait, there is none. Really, the on=
ly
> > > > thing we support writing to are the PMU and Debug versions. And
> > > > nothing else.
> > > >
> > > > What does it mean for userspace? Either the write will be denied
> > > > despite being advertised a writable field (remember the first patch=
 of
> > > > the series???), or we'll blindly accept the write and further ignor=
e
> > > > the requested values. Do you really think any of this is acceptable=
?
> > > >
> > > > This is the *9th* version of this series, and we're still battling
> > > > over some extremely basic userspace issues... I don't think we can
> > > > merge this series as is stands.
> > >
> > > I removed sanity checks across multiple fields after the discussion
> > > here: https://lore.kernel.org/all/ZKRC80hb4hXwW8WK@thinky-boi/
> > > I might have misunderstood the discussion. I thought we'd let VMM do
> > > more complete sanity checks.
> >
> > The problem is that you don't even have a statement about how this is
> > supposed to be handled. What are the rules? How can the VMM author
> > *know*?
> >
> > That's my real issue with this series: at no point do we state when an
> > ID register can be written, what are the rules that must be followed,
> > where is the split in responsibility between KVM and the VMM, and what
> > is the expected behaviour when the VMM exposes something that is
> > completely outlandish to the guest (such as the M-profile debug).
> >
> > Do you see the issue? We can always fix the code. But once we've
> > exposed that to userspace, there is no going back. And I really want
> > everybody's buy-in on that front, including the VMM people.
>
> Understood.
> Looks like it would be less complicated to have KVM do all the sanity
> checks to determine if a feature field is configured correctly.
> The determination can be done by following rules:
> 1. Architecture constraints from ARM ARM.
> 2. KVM constraints. (Those features not exposed by KVM should be read-onl=
y)
> 3. VCPU features. (The write mask needs to be determined on-the-fly)

Does this sound good to you to have all sanity checks in KVM?

Thanks,
Jing

>
> Thanks,
> Jing
>
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
