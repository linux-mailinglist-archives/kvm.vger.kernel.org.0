Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840E97CCAF5
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbjJQSpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbjJQSpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:45:36 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63F7B0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 11:45:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1c9b70b9671so23905ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 11:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697568333; x=1698173133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gqavKeNNzn95rvZivCvxVtN3hspWT+sEglrWLEE2E/M=;
        b=KoXIWT1KC+LONyWvyYQvWptWxQU3g4Mvy8fmtzHOqEfpL3xlAA9IeDy/LhUtaN0peS
         mjtVpzmrJkLu5lS6VxYFCMTa1mnAsNvfdedrNzbz9xa/bX8FiEZNA1zc6qS5DIeI41jC
         i50scSk7lvMRaTNGYLoAlgs8g40WpY8rsAf1oAtAh7cF+2SZBbOQr+E30fd8cf9cdegX
         aQGarw9O4zh8H8P/wlu9v1a78EEa5TwmP3x35mIPfrPgdkmNo4TcJ/DFj8hyKho9Z7gQ
         VYR655WpRnKyRWrF1kjMPcjdaeflxNYiNVAWH3792UWAF/fk4kSYtnPCM2XS805/SIuT
         +rXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697568333; x=1698173133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqavKeNNzn95rvZivCvxVtN3hspWT+sEglrWLEE2E/M=;
        b=ZL5FDv8FPPknXyPGBSiUMdhx9yV8F+gJFrU8OnHWi7YVQV3cwuXKeFC+yqv7iXPiZl
         nXsafk3zsbSQ/dAWc//idfPzb3FNeSJ4Lk6JSUwkgob8Koeq30GheiuVoiLY/syX8sP7
         ZvOjJ3IF5K82QF9x1UCk2+gSSOUXArFiXbbxDimLuMoMVEbWt2Ld0Tf/3xfkJNvhLTHF
         zfQQmy3qA+F7qYEteN1eP88sbyzfR4n1zB4RDn4+iZiGzlI4XswrRcO3eg/Gh7yjueSc
         5gG6E0dyfIokM96G+g8eU+in7krWmBSv+IyVQqdOcUVax232EckVAKxNJYyJlMMcfJDv
         Z+Wg==
X-Gm-Message-State: AOJu0YwIO59dDKaQGYdap6z2qJaDgB1b5dBgX0nX4ma8u2r89CpgcXtP
        s46FmROyO7K6VWNFCkNqNrkHLtcx3qnvkxbPz9PNiA==
X-Google-Smtp-Source: AGHT+IEvnrKElYIr+WwV++S1q681XL7zbfbJLiJziy9CXgLJP0/YH3N3e7BkeqvohOyFpDrX7yf5F7P2Gg3U3PXN12Q=
X-Received: by 2002:a17:903:54:b0:1b9:d96c:bca7 with SMTP id
 l20-20020a170903005400b001b9d96cbca7mr35746pla.25.1697568333106; Tue, 17 Oct
 2023 11:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com> <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev> <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
 <ZS4hGL5RIIuI1KOC@linux.dev> <CAJHc60zQb0akx2Opbh3_Q8JShBC_9NFNvtAE+bPNi9QqXUGncA@mail.gmail.com>
 <ZS6_tdkS6GyNlt4l@linux.dev> <CAJHc60w-CsqdYX8JG-CRutwg0UyWmvk1TyoR-y9JBV_mqWUVKw@mail.gmail.com>
 <ZS7OLRy6BwJljOV8@linux.dev>
In-Reply-To: <ZS7OLRy6BwJljOV8@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 17 Oct 2023 11:45:20 -0700
Message-ID: <CAJHc60w5oipHoOVbnYv_9zbHZbXZQRPUVX0+5nxD5HUjp5pA6A@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Tue, Oct 17, 2023 at 11:11=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Oct 17, 2023 at 10:25:50AM -0700, Raghavendra Rao Ananta wrote:
> > On Tue, Oct 17, 2023 at 10:09=E2=80=AFAM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
> > >
> > > On Tue, Oct 17, 2023 at 09:58:08AM -0700, Raghavendra Rao Ananta wrot=
e:
> > > > On Mon, Oct 16, 2023 at 10:52=E2=80=AFPM Oliver Upton <oliver.upton=
@linux.dev> wrote:
> > > > >
> > > > > On Mon, Oct 16, 2023 at 02:35:52PM -0700, Raghavendra Rao Ananta =
wrote:
> > > > >
> > > > > [...]
> > > > >
> > > > > > > What's the point of doing this in the first place? The implem=
entation of
> > > > > > > kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-sc=
oped value.
> > > > > > >
> > > > > > I guess originally the change replaced read_sysreg(pmcr_el0) wi=
th
> > > > > > kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
> > > > > > But if you and Sebastian feel that it's an overkill and directl=
y
> > > > > > getting the value via vcpu->kvm->arch.pmcr_n is more readable, =
I'm
> > > > > > happy to make the change.
> > > > >
> > > > > No, I'd rather you delete the line where PMCR_EL0.N altogether.
> > > > > reset_pmcr() tries to initialize the field, but your
> > > > > kvm_vcpu_read_pmcr() winds up replacing it with pmcr_n.
> > > > >
> > > > I didn't get this comment. We still do initialize pmcr, but using t=
he
> > > > pmcr.n read via kvm_vcpu_read_pmcr() instead of the actual system
> > > > register.
> > >
> > > You have two bits of code trying to do the exact same thing:
> > >
> > >  1) reset_pmcr() initializes __vcpu_sys_reg(vcpu, PMCR_EL0) with the =
N
> > >     field set up.
> > >
> > >  2) kvm_vcpu_read_pmcr() takes whatever is in __vcpu_sys_reg(vcpu, PM=
CR_EL0),
> > >     *masks out* the N field and re-initializes it with vcpu->kvm->arc=
h.pmcr_n
> > >
> > > Why do you need (1) if you do (2)?
> > >
> > Okay, I see what you mean now. In that case, let reset_pmcr():
> > - Initialize 'pmcr' using  vcpu->kvm->arch.pmcr_n
> > - Set ARMV8_PMU_PMCR_LC as appropriate in 'pmcr'
> > - Write 'pmcr' to the vcpu reg
> >
> > From here on out, kvm_vcpu_read_pmcr() would read off of this
> > initialized value, unless of course, userspace updates the pmcr.n.
> > Is this the flow that you were suggesting?
>
> Just squash this in:
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d1db1f292645..7b54c7843bef 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -743,10 +743,8 @@ static u64 reset_pmselr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r)
>
>  static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r)
>  {
> -       u64 pmcr;
> +       u64 pmcr =3D 0;
>
> -       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> -       pmcr =3D kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK << ARM=
V8_PMU_PMCR_N_SHIFT);
>         if (!kvm_supports_32bit_el0())
>                 pmcr |=3D ARMV8_PMU_PMCR_LC;
>
>
Oh, I get the redundancy that you were suggesting to get rid of!
Thanks for the diff. It helped.

- Raghavendra
> --
> Thanks,
> Oliver
