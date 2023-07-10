Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8C374DFD8
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 22:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjGJUzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 16:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjGJUzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 16:55:00 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F329E98
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 13:54:58 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6b87d505e28so3977894a34.2
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 13:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689022498; x=1691614498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBIy9U5euos68Ioe2CrWIhGDyG7Iu4LaGu80DwtO+UU=;
        b=0uFnyoSlD9e9Pqno9Cj3zBzBokPvPTN9nnR0ZH1aOMeDpCmFfgLqqGqI/4QLzTAH5j
         Zoy4YJ6vhm8jqkg9AKvMryFf+WXwrWNdbyDJfmx9dHjwyUopP3TzT9Az1nT9h3N88SGO
         qPJ6D1MpwpoIS+7JJSzxDUmDbW3OlwmCVNH56yt9uc7FPmruOHOTUJlfOhvNY8xbi7eL
         39YYtw6/FPauq6INlrIxs9h8frwLA7stwjaMai3Ixoyf43/chZ02sefZbfP+sp4agKWE
         2Iep0P04hIePO+biGk8SPE/vwEO6WACfmSAyy/oh/JL+LPb7SqthspKPaI87ElmeW0T5
         raLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689022498; x=1691614498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SBIy9U5euos68Ioe2CrWIhGDyG7Iu4LaGu80DwtO+UU=;
        b=RQSJSdiTn3AEff32dVea2YUUdMiapwuI4mvIB1PR+qoGNzIRfeaPvyllHNNf1b/wqE
         Nui/6OyJNWjC1qeYoh7TPrgfVV0gaahtRlr3hzXvOR6jSi4fx9/chjsjCm0fIv7lMVr5
         iDmYppKGoOALiIdx4oBhp4axAVODcMUMpceu0XLjOAOwOUeq8ktLfi3M45ObXbLHJhZ1
         dpD/eC6UnWbRRu9bSwNuFKS+jgZ91urTcb0eTiQPCdkrQ/+N6FQ+7JSOdPGg7qfLD2xs
         D4koueaJY381HLRT+Pct6mi+6Ayc/zA6NiWShVITuum8yny3/+lwm6l04uX3k88Ez1vC
         eO6g==
X-Gm-Message-State: ABy/qLad0CgMM1311e2+eeSvqsyMngQgxgRQ88wXBJ+pYdrox9L7QNVF
        edHl1BW9avnu+HpsJWMPLYMhFlONRxdqfQbufG0z4Q==
X-Google-Smtp-Source: APBJJlHbwMgpuYCM62wvrmc7Y7DUTz2Yb3NfLRrk9RXPdkhcJ8bweakuc8XVp4gdphMJtKYHuW+D4qD5w2BrMGElZ1E=
X-Received: by 2002:a05:6870:a107:b0:1b0:43b6:e13b with SMTP id
 m7-20020a056870a10700b001b043b6e13bmr14830764oae.54.1689022498207; Mon, 10
 Jul 2023 13:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
 <20230710192430.1992246-4-jingzhangos@google.com> <ZKxnp6Tm3WwXupXw@linux.dev>
In-Reply-To: <ZKxnp6Tm3WwXupXw@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 10 Jul 2023 13:54:46 -0700
Message-ID: <CAAdAUtiKmRwPwWp7wPcejn+j1YbDxO7zyXVXTTV2d5BjLixCZw@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] KVM: arm64: Reject attempts to set invalid debug
 arch version
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Mon, Jul 10, 2023 at 1:18=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Jing,
>
> On Mon, Jul 10, 2023 at 07:24:26PM +0000, Jing Zhang wrote:
> > From: Oliver Upton <oliver.upton@linux.dev>
> >
> > The debug architecture is mandatory in ARMv8, so KVM should not allow
> > userspace to configure a vCPU with less than that. Of course, this isn'=
t
> > handled elegantly by the generic ID register plumbing, as the respectiv=
e
> > ID register fields have a nonzero starting value.
> >
> > Add an explicit check for debug versions less than v8 of the
> > architecture.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>
> This patch should be ordered before the change that permits writes to
> the DebugVer field (i.e. the previous patch). While we're at it, there's
> another set of prerequisites for actually making the field writable.
>
> As Suraj pointed out earlier, we need to override the type of the field
> to be FTR_LOWER_SAFE instead of EXACT. Beyond that, KVM limits the field
> to 0x6, which is the minimum value for an ARMv8 implementation. We can
> relax this limitation up to v8p8, as I believe all of the changes are to
> external debug and wouldn't affect a KVM guest.
>
> Below is my (untested) diff on top of your series for both of these
> changes.
>
> --
> Thanks,
> Oliver
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 78ccc95624fa..35c4ab8cb5c8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1216,8 +1216,14 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const =
struct arm64_ftr_bits *ftrp,
>         /* Some features have different safe value type in KVM than host =
features */
>         switch (id) {
>         case SYS_ID_AA64DFR0_EL1:
> -               if (kvm_ftr.shift =3D=3D ID_AA64DFR0_EL1_PMUVer_SHIFT)
> +               switch (kvm_ftr.shift) {
> +               case ID_AA64DFR0_EL1_PMUVer_SHIFT:
>                         kvm_ftr.type =3D FTR_LOWER_SAFE;
> +                       break;
> +               case ID_AA64DFR0_EL1_DebugVer_SHIFT:
> +                       kvm_ftr.type =3D FTR_LOWER_SAFE;
> +                       break;
> +               }
>                 break;
>         case SYS_ID_DFR0_EL1:
>                 if (kvm_ftr.shift =3D=3D ID_DFR0_EL1_PerfMon_SHIFT)
> @@ -1466,14 +1472,22 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct =
kvm_vcpu *vcpu,
>         return val;
>  }
>
> +#define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)                 =
               \
> +({                                                                      =
       \
> +       u64 __f_val =3D FIELD_GET(reg##_##field##_MASK, val);            =
         \
> +       (val) &=3D ~reg##_##field##_MASK;                                =
         \
> +       (val) |=3D FIELD_PREP(reg##_##field##_MASK,                      =
         \
> +                         min(__f_val, (u64)reg##_##field##_##limit));   =
       \
> +       (val);                                                           =
       \
> +})
> +
>  static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>                                           const struct sys_reg_desc *rd)
>  {
>         u64 val =3D read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
>
>         /* Limit debug to ARMv8.0 */
> -       val &=3D ~ID_AA64DFR0_EL1_DebugVer_MASK;
> -       val |=3D SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DebugVer, IMP);
> +       val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V=
8P8);
>
>         /*
>          * Only initialize the PMU version if the vCPU was configured wit=
h one.
> @@ -1529,6 +1543,8 @@ static u64 read_sanitised_id_dfr0_el1(struct kvm_vc=
pu *vcpu,
>         u8 perfmon =3D pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
>         u64 val =3D read_sanitised_ftr_reg(SYS_ID_DFR0_EL1);
>
> +       val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8=
p8);
> +
>         val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
>         if (kvm_vcpu_has_pmu(vcpu))
>                 val |=3D SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
>
Thanks for the details. Will improve it in the next version.

Jing
