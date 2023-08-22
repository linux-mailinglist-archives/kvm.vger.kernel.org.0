Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECF5784974
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 20:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjHVSf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 14:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjHVSf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 14:35:27 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA66CD8
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 11:35:24 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2bcc331f942so23280731fa.0
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 11:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692729323; x=1693334123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZG8/FKpT+5ZMPFMf3XneVJf41+qrLWykYFB8Mroi2p0=;
        b=hBOpE32r3X0stLup3zJ47ajL9A3rBNXNiV3E6065k2zRuMHXcc2qeRBznkkK9jaVlb
         mXHE0QjQdww7Behkc6OxdFIf79q2MJ4L7RsubvntRwLmQnrrTg1cT9d8pyUw8qEi7p+M
         yAzFTIwy12LM9c0cAPQfJVXbFSoRjKC+wdHLqGUpWgRWR+CCZMQ1BNAeqK2Tt+qbp7mo
         LWTevvOk3ZEX9tUbJCPVTITMasMl/xdUVcqC1wnYRdfb62QxaOAMrlIbz+0/JUHLmN83
         4Fb0fNRNj2UgpPrcZpJ5BzlF8o1ZEyoC+NWiug6323PwBztsFF7/er0oLVx2e8iLR3uF
         zg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692729323; x=1693334123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZG8/FKpT+5ZMPFMf3XneVJf41+qrLWykYFB8Mroi2p0=;
        b=XMotm5+o/egNfeTtmCXaJqU1B6UKqJ8xBXkJKMfppZ1CBCkOVAitr43Gn/mWV/0ywT
         thL4o6voWS2ZmZBrZSXsesCBPO8wMvb6G2agzVfqTfMsNrwMlyfcZCa3xV4c6ZeFZOjx
         VT28v1lW95KYNf8/9VXhbVUlNyVCPBbptSCOYsqDYJ3ONjjUtbnEt5G1Vtzz4kphFyaq
         MX28Zr2KgFoT5eMFJj4GPHmQDQSO+Iw4LW+lliSNmdLBDY1UDFBhU5CCgQOSmCCcy/Jy
         D9KcE28zCNuEvI83zlLowjEL9kvSpTjFmEqvH5azghETI7/U8GDu6k3lSYPGODeLN7Mw
         MvNA==
X-Gm-Message-State: AOJu0YxODYWhnizwgzkT5hnhkzGuBU0g7cX8JORXdit9mhiWqO0WNTPe
        UPIprVFim3MODwQbP/S/0O7ELjD9Ol8yWqtmaxVCOLwgy7b9ebMjz8SMMw==
X-Google-Smtp-Source: AGHT+IHLjbjdpPtuGDgzItCHCjngA7+Qq5HGzx0ZodQ01Ijp53K1+QI7cmm5rC7QJqm8zCwp9G/pj+yHfDMxXCsrv2g=
X-Received: by 2002:a2e:2e06:0:b0:2b6:d0fa:7023 with SMTP id
 u6-20020a2e2e06000000b002b6d0fa7023mr3893380lju.24.1692729322972; Tue, 22 Aug
 2023 11:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
 <20230821212243.491660-6-jingzhangos@google.com> <878ra3pndw.wl-maz@kernel.org>
In-Reply-To: <878ra3pndw.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 22 Aug 2023 11:35:12 -0700
Message-ID: <CAAdAUti8qSf0PVnWkp4Jua-te6i0cjQKJm=8dt5vWqT0Q6w4iQ@mail.gmail.com>
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

On Tue, Aug 22, 2023 at 12:06=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Mon, 21 Aug 2023 22:22:37 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> > from userspace with this change.
> > RES0 fields and those fields hidden by KVM are not writable.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index afade7186675..20fc38bad4e8 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1931,6 +1931,8 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
> >       return true;
> >  }
> >
> > +#define ID_AA64DFR0_EL1_RES0_MASK (GENMASK(59, 56) | GENMASK(27, 24) |=
 GENMASK(19, 16))
> > +
> >  /*
> >   * Architected system registers.
> >   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> > @@ -2006,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .set_user =3D set_id_dfr0_el1,
> >         .visibility =3D aa32_id_visibility,
> >         .reset =3D read_sanitised_id_dfr0_el1,
> > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > +       .val =3D GENMASK(31, 0), },
>
> Can you *please* look at the register and realise that we *don't*
> support writing to the whole of the low 32 bits? What does it mean to
> allow selecting the M-profile debug? Or the memory-mapped trace?
>
> You are advertising a lot of crap to userspace, and that's definitely
> not on.
>
> >       ID_HIDDEN(ID_AFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > @@ -2055,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .get_user =3D get_id_reg,
> >         .set_user =3D set_id_aa64dfr0_el1,
> >         .reset =3D read_sanitised_id_aa64dfr0_el1,
> > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > +       .val =3D ~(ID_AA64DFR0_EL1_PMSVer_MASK | ID_AA64DFR0_EL1_RES0_M=
ASK), },
>
> And it is the same thing here. Where is the handling code to deal with
> variable breakpoint numbers? Oh wait, there is none. Really, the only
> thing we support writing to are the PMU and Debug versions. And
> nothing else.
>
> What does it mean for userspace? Either the write will be denied
> despite being advertised a writable field (remember the first patch of
> the series???), or we'll blindly accept the write and further ignore
> the requested values. Do you really think any of this is acceptable?
>
> This is the *9th* version of this series, and we're still battling
> over some extremely basic userspace issues... I don't think we can
> merge this series as is stands.

I removed sanity checks across multiple fields after the discussion
here: https://lore.kernel.org/all/ZKRC80hb4hXwW8WK@thinky-boi/
I might have misunderstood the discussion. I thought we'd let VMM do
more complete sanity checks.

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Jing
