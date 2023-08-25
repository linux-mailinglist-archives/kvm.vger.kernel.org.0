Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6D97891BE
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 00:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjHYWeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 18:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjHYWeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 18:34:19 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE3526A5
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 15:34:16 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-34bae839382so19215ab.1
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 15:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693002856; x=1693607656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VmGrXf9cYjykgOlg/u6doGW9vtPA8bMLiJ9T7b++na4=;
        b=PAXh1adBUFauZawogz7q389GMBq1WlTduNIc5w2yFy7YwvjAX12asWO89+zph8dr3W
         18RfY+Svstd8+bWMToVytpP3IiVsFkGapddtnpKG8BwIFkFRFeT/w5vzZbc9LZsUa/wl
         8SD1ZwdYAwoS7/sEsIjY6sVgGDjgN21v2+j+IMJ46TJeZTJc40RsAGqeBp5kd1ZAAAxm
         iBy6OXsKj66WVe7MwkHTq9MVQ3R8GoW2pbx/Fj0etosTOK8LkmlPwvTNcYI55eXbAZWJ
         pY7SKwuhhmjsYGDNfKxn0/vyf1R6tYyBVyA0MNlFTZt3fKXqBuGMdu7qjER0RgSAuKXr
         mNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693002856; x=1693607656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VmGrXf9cYjykgOlg/u6doGW9vtPA8bMLiJ9T7b++na4=;
        b=QNlbey9TI+bALFh6L5BmXTV/YcBtN0dUUfxliNHoLS5awspCF1KGZCLJv7ca/XKYfi
         OEBGhTy1s92R+3gniOZmQ6d0xaNSRCF4xyysq9wzuO+of5O7JDxu/vVo+hCO8PrvdxeU
         3q1kgtBfO1gIdUijL7om+TXsoYlx8g34zjpjP8IM986unVAJJpT1peTp8DzwmYjaZyQG
         ICpWqvnJ2zvatg0wxwDjpGtdBCX3N3XcIgQnmrZdM03PS5GDA0TvVDz2wBGCURcJhMxK
         dYL2HhQT3DQXzvQDi+gvjP1/tT5BYY0mVv8HZKACy2uOVmo7gUdRgRcVuQ2eYv3IY+rs
         /FlQ==
X-Gm-Message-State: AOJu0YwqllMlTcrrpvgGqLlm9nKql598R0i0qpPblJj250CiwNhgUjaM
        8KiqLpSR379nDsDB02Qogmb3f25x6W8fKsjEZqjBbQ==
X-Google-Smtp-Source: AGHT+IF3vhd8OdJzn3dbhBkM5wd1Hnk0dkeY4f07ZarV1sUQ5JqtJCGCgpfhgOuwf6tzaRd87yn7tlhJtjLYV3wJxgs=
X-Received: by 2002:a92:cda1:0:b0:347:1b96:9d48 with SMTP id
 g1-20020a92cda1000000b003471b969d48mr28190ild.15.1693002856153; Fri, 25 Aug
 2023 15:34:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <1c6c07af-f6d0-89a6-1b7d-164ca100ac88@redhat.com> <CAJHc60x=rZTpeJ3PDUWmc08Aziow6S+2nndcL90vHfru5GhXtA@mail.gmail.com>
 <a0543866-1fac-6a3f-20cd-43b6d1263c0e@redhat.com>
In-Reply-To: <a0543866-1fac-6a3f-20cd-43b6d1263c0e@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 25 Aug 2023 15:34:04 -0700
Message-ID: <CAJHc60z=+LG8kayRzYEZ6rCZuov7zC-nLMmzAabPiPKY5OhSEg@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 24, 2023 at 1:50=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
>
>
> On 8/24/23 00:06, Raghavendra Rao Ananta wrote:
> > On Tue, Aug 22, 2023 at 3:06=E2=80=AFAM Shaoqin Huang <shahuang@redhat.=
com> wrote:
> >>
> >> Hi Raghavendra,
> >>
> >> On 8/17/23 08:30, Raghavendra Rao Ananta wrote:
> >>> From: Reiji Watanabe <reijiw@google.com>
> >>>
> >>> KVM does not yet support userspace modifying PMCR_EL0.N (With
> >>> the previous patch, KVM ignores what is written by upserspace).
> >>> Add support userspace limiting PMCR_EL0.N.
> >>>
> >>> Disallow userspace to set PMCR_EL0.N to a value that is greater
> >>> than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
> >>> support more event counters than the host HW implements.
> >>> Although this is an ABI change, this change only affects
> >>> userspace setting PMCR_EL0.N to a larger value than the host.
> >>> As accesses to unadvertised event counters indices is CONSTRAINED
> >>> UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
> >>> on every vCPU reset before this series, I can't think of any
> >>> use case where a user space would do that.
> >>>
> >>> Also, ignore writes to read-only bits that are cleared on vCPU reset,
> >>> and RES{0,1} bits (including writable bits that KVM doesn't support
> >>> yet), as those bits shouldn't be modified (at least with
> >>> the current KVM).
> >>>
> >>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >>> ---
> >>>    arch/arm64/include/asm/kvm_host.h |  3 ++
> >>>    arch/arm64/kvm/pmu-emul.c         |  1 +
> >>>    arch/arm64/kvm/sys_regs.c         | 49 +++++++++++++++++++++++++++=
++--
> >>>    3 files changed, 51 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> >>> index 0f2dbbe8f6a7e..c15ec365283d1 100644
> >>> --- a/arch/arm64/include/asm/kvm_host.h
> >>> +++ b/arch/arm64/include/asm/kvm_host.h
> >>> @@ -259,6 +259,9 @@ struct kvm_arch {
> >>>        /* PMCR_EL0.N value for the guest */
> >>>        u8 pmcr_n;
> >>>
> >>> +     /* Limit value of PMCR_EL0.N for the guest */
> >>> +     u8 pmcr_n_limit;
> >>> +
> >>>        /* Hypercall features firmware registers' descriptor */
> >>>        struct kvm_smccc_features smccc_feat;
> >>>        struct maple_tree smccc_filter;
> >>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> >>> index ce7de6bbdc967..39ad56a71ad20 100644
> >>> --- a/arch/arm64/kvm/pmu-emul.c
> >>> +++ b/arch/arm64/kvm/pmu-emul.c
> >>> @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct ar=
m_pmu *arm_pmu)
> >>>         * while the latter does not.
> >>>         */
> >>>        kvm->arch.pmcr_n =3D arm_pmu->num_events - 1;
> >>> +     kvm->arch.pmcr_n_limit =3D arm_pmu->num_events - 1;
> >>>
> >>>        return 0;
> >>>    }
> >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >>> index 2075901356c5b..c01d62afa7db4 100644
> >>> --- a/arch/arm64/kvm/sys_regs.c
> >>> +++ b/arch/arm64/kvm/sys_regs.c
> >>> @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, con=
st struct sys_reg_desc *r,
> >>>        return 0;
> >>>    }
> >>>
> >>> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r,
> >>> +                 u64 val)
> >>> +{
> >>> +     struct kvm *kvm =3D vcpu->kvm;
> >>> +     u64 new_n, mutable_mask;
> >>> +     int ret =3D 0;
> >>> +
> >>> +     new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> >>> +
> >>> +     mutex_lock(&kvm->arch.config_lock);
> >>> +     if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> >>> +             /*
> >>> +              * The vCPU can't have more counters than the PMU
> >>> +              * hardware implements.
> >>> +              */
> >>> +             if (new_n <=3D kvm->arch.pmcr_n_limit)
> >>> +                     kvm->arch.pmcr_n =3D new_n;
> >>> +             else
> >>> +                     ret =3D -EINVAL;
> >>> +     }
> >>> +     mutex_unlock(&kvm->arch.config_lock);
> >>
> >> Another thing I am just wonder is that should we block any modificatio=
n
> >> to the pmcr_n after vm start to run? Like add one more checking
> >> kvm_vm_has_ran_once() at the beginning of the set_pmcr() function.
> >>
> > Thanks for bringing it up. Reiji and I discussed about this. Checking
> > for kvm_vm_has_ran_once() will be a good move, however, it will go
> > against the ABI expectations of setting the PMCR. I'd like others to
> > weigh in on this as well. What do you think?
> >
> > Thank you.
> > Raghavendra
>
> Before this change, kvm not allowed userspace to change the pmcr_n, but
> allowed to change the lower ARMV8_PMU_PMCR_MASK bits. With this change,
> we now allow to change the pmcr_n, we should not block the change to
> ARMV8_PMU_PMCR_MASK after vm start to run, but how about we just block
> the change to ARMV8_PMU_PMCR_N after vm start to run?
>
I believe you are referring to the guest trap access part of it
(access_pmcr()). This patch focuses on the userspace access of PMCR
via the KVM_SET_ONE_REG ioctl. Before this patch, KVM did not control
the writes to the reg and userspace was free to write to any bits at
any time.

Thank you.
Raghavendra
> Thanks,
> Shaoqin
>
> >> Thanks,
> >> Shaoqin
> >>
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     /*
> >>> +      * Ignore writes to RES0 bits, read only bits that are cleared =
on
> >>> +      * vCPU reset, and writable bits that KVM doesn't support yet.
> >>> +      * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
> >>> +      * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the=
 vCPU.
> >>> +      * But, we leave the bit as it is here, as the vCPU's PMUver mi=
ght
> >>> +      * be changed later (NOTE: the bit will be cleared on first vCP=
U run
> >>> +      * if necessary).
> >>> +      */
> >>> +     mutable_mask =3D (ARMV8_PMU_PMCR_MASK | ARMV8_PMU_PMCR_N);
> >>> +     val &=3D mutable_mask;
> >>> +     val |=3D (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
> >>> +
> >>> +     /* The LC bit is RES1 when AArch32 is not supported */
> >>> +     if (!kvm_supports_32bit_el0())
> >>> +             val |=3D ARMV8_PMU_PMCR_LC;
> >>> +
> >>> +     __vcpu_sys_reg(vcpu, r->reg) =3D val;
> >>> +     return 0;
> >>> +}
> >>> +
> >>>    /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers i=
n one go */
> >>>    #define DBG_BCR_BVR_WCR_WVR_EL1(n)                                =
  \
> >>>        { SYS_DESC(SYS_DBGBVRn_EL1(n)),                               =
  \
> >>> @@ -2147,8 +2192,8 @@ static const struct sys_reg_desc sys_reg_descs[=
] =3D {
> >>>        { SYS_DESC(SYS_CTR_EL0), access_ctr },
> >>>        { SYS_DESC(SYS_SVCR), undef_access },
> >>>
> >>> -     { PMU_SYS_REG(PMCR_EL0), .access =3D access_pmcr,
> >>> -       .reset =3D reset_pmcr, .reg =3D PMCR_EL0, .get_user =3D get_p=
mcr },
> >>> +     { PMU_SYS_REG(PMCR_EL0), .access =3D access_pmcr, .reset =3D re=
set_pmcr,
> >>> +       .reg =3D PMCR_EL0, .get_user =3D get_pmcr, .set_user =3D set_=
pmcr },
> >>>        { PMU_SYS_REG(PMCNTENSET_EL0),
> >>>          .access =3D access_pmcnten, .reg =3D PMCNTENSET_EL0 },
> >>>        { PMU_SYS_REG(PMCNTENCLR_EL0),
> >>
> >> --
> >> Shaoqin
> >>
> >
>
> --
> Shaoqin
>
