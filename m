Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94154748DCC
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbjGETaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 15:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjGETaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 15:30:21 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87263183
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 12:30:20 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6b8a6ca994eso4971525a34.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 12:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688585420; x=1691177420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dqX3jBV18tBGLew6n5pqhYJHUJdONqGoznuxLJ4bNJo=;
        b=IVPIjuZHat1iuuLvfvSos5iJX/2lmZUo1bmup6rR3K4cb/WS+SVxblPkvKuOdBsjhX
         x60erhF6Wu+2y7bkpcfRoVcfPC94ZOnrpEKh+Of84S1xMYzIYjIklmliHCDcccn5vEGx
         FBb7Df+4BnMn3M67TdKUtR+KhOzdVOsO9wviYUSyMXNY+EZiNOyNawI1TU5wD74UjsKM
         /pBR0auEmosa8w+TlKpDnctX2Lmx04C9ImNP0UITF0yxwoUzUR/u6fWNvtRe6xHDsYCU
         Tj3bmdbw+866QJoXWlWzSm0haJ+/NLGDm0na0dyh3yDeU8uOjFJcAgZde6r5fYWJhnSa
         2N1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688585420; x=1691177420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dqX3jBV18tBGLew6n5pqhYJHUJdONqGoznuxLJ4bNJo=;
        b=hMYLdmjpTspArSVj2O8d8smVNRNs6EmvwRuBJ/RCRHTfNLjW+MM/gC9r0YynT5ZYNq
         1APAeJ5ZTMYjMxaDhWQ1AHHhewWNWQMMN/Xkvser5a+jjPTwtUMjKPMh1F7tVqNg+Hpb
         joDO2qOOPwDjqFk2IxnKBctKIufiiE4MFejvUQ3PLxrO7Vf/iWFx/IE5zXv2hcb2f/5a
         AvXrh6StvoWR3n48WEsNlHyVoRXWHohLFl7etPVAbEC7D4+k/i1KESflCXFrOcuftXiX
         Loa/tknfUXPsGRbidVCEVYNr4hHsLPpmJcWpbwqt82QivsmFPcRXmJ21s/LfWnTWlF9j
         MC8w==
X-Gm-Message-State: ABy/qLZhu2G/N8FvOlJrI60YYxpcnYH/dKZDzAQcRY61VeZDYTqt4PdL
        wS/8GX3XXDucDIPEKl5kj3TQgnVoDcrLGxZ927ST1w==
X-Google-Smtp-Source: ACHHUZ70Gtekf0SGSHttYmgSXUjbdIozILLI5Av5ouRVJwniR1+XidKzHjGrqewMdl4gdeplc7dVaD7g6tf/cwg3JSk=
X-Received: by 2002:a05:6870:b623:b0:1b0:91aa:fcfa with SMTP id
 cm35-20020a056870b62300b001b091aafcfamr21013186oab.55.1688585419752; Wed, 05
 Jul 2023 12:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com>
 <20230607194554.87359-4-jingzhangos@google.com> <ZJnBdtkzeQuPqQGO@linux.dev>
In-Reply-To: <ZJnBdtkzeQuPqQGO@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 5 Jul 2023 12:30:08 -0700
Message-ID: <CAAdAUthHzVZUhymUv6wnwaRXC+88GRyQd6AGtgj8zLOAz_=W6A@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
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

Hi Oliver,

On Mon, Jun 26, 2023 at 9:49=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Jun 07, 2023 at 07:45:53PM +0000, Jing Zhang wrote:
> > Return an error if userspace tries to set SVE field of the register
> > to a value that conflicts with SVE configuration for the guest.
> > SIMD/FP/SVE fields of the requested value are validated according to
> > Arm ARM.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 31 +++++++++++++++++++++++++++++--
> >  1 file changed, 29 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 3964a85a89fe..8f3ad9c12b27 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1509,9 +1509,36 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct=
 kvm_vcpu *vcpu,
> >
> >       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> >
> > +     if (!system_supports_sve())
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
> > +
>
> If the system doesn't support SVE, wouldn't the sanitised system-wide
> value hide the feature as well? A few lines up we already mask this
> field based on whether or not the vCPU has the feature, which is
> actually meaningful.
Yes, you are right. This change is not needed actually.
>
> >       return val;
> >  }
> >
> > +static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > +                            const struct sys_reg_desc *rd,
> > +                            u64 val)
> > +{
> > +     int fp, simd;
> > +     bool has_sve =3D id_aa64pfr0_sve(val);
> > +
> > +     simd =3D cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_=
AdvSIMD_SHIFT);
> > +     fp =3D cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_FP=
_SHIFT);
> > +     /* AdvSIMD field must have the same value as FP field */
> > +     if (simd !=3D fp)
> > +             return -EINVAL;
> > +
> > +     /* fp must be supported when sve is supported */
> > +     if (has_sve && (fp < 0))
> > +             return -EINVAL;
> > +
> > +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_I=
NIT */
> > +     if (vcpu_has_sve(vcpu) ^ has_sve)
> > +             return -EPERM;
>
> Same comment here on cross-field plumbing.
Will fix.
>
> --
> Thanks,
> Oliver

Thanks,
Jing
