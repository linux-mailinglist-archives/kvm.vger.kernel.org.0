Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97C17D3E59
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 19:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjJWRxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 13:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjJWRxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 13:53:41 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E160A97
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 10:53:38 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-3575826ba20so7485ab.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 10:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698083618; x=1698688418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qw5+2AMntm7pXpxFSU/tC2f7FyRYAShkL6ADVOeD7Gg=;
        b=NrrvvsQguV6UPHGzI2le4Kowy1j1+MZguedVVTImwL+36wgJyYU8mHtot92nUFvx+i
         Ubc2y+fFvplvNPvBuKxbG0ySdU5YhBUploUCg3BdgzMjZECl7Q8PqHA3dr66roHUkSaw
         4fFUF3A0Yi2bRGcoIGcJPpzrhhA5Q4AEyK2A5NqU9blhjomCGpPOXuCwNSHleCKKPIU9
         wBEUv5Zk266gGyDm5HvZSwZ2eag0RFa3es2azH1urXD4n4QozOOFDB3XMS6yvB7UJkhp
         y4JQfRZvS1raV82D73SyxSH2BfpBVhGNiBdeYuUPLnunmTQ5GkRdrk4jvKClIc4rYVXg
         P7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698083618; x=1698688418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qw5+2AMntm7pXpxFSU/tC2f7FyRYAShkL6ADVOeD7Gg=;
        b=r8fCihW4Ry2spkhhj1iBO9t6NNzIarnhOahedGwkQXOT+Pp9lVnVx1O1GLSVUWSNoN
         n+hfbyejmQUEQS2T2B+qv4pGwC7nzULBGSGIfGz07+PEyNLZQ0HajXBH+3Sqqiw3taxl
         68i7iY/E9SqUgQL21v5CJYZq7smlCDUV1ltVgvnXuz/kF1Mwv85jTyqkv7u+IhcHnhRY
         ju5TARuEE4iBlg6Aj40fSn5yPFK1pPho3jEjAG0ic3VPV5kOaBBJ5PZabOkbe06ZViFt
         CXIdIwG502FMRFH1vK7saYzV5lzFGknFX7AWWpOGcxiiIOh7wDEL4pLxBRIOHN5Srxu2
         ODKA==
X-Gm-Message-State: AOJu0YxCyDwdQb8a6OcxFybPRkfH3FHUbSCVeQAiPy/nF+x5GsZteLrV
        ASpm1E9N94XoWJ23hkI2+6hMcjuj8rHDwGoZ6MX41w==
X-Google-Smtp-Source: AGHT+IFV/wV+YiqC2ESFSCZyhGd5/1czX6ES97uEK8dmHs+iO3CFpGy9bZwE/bMLxg9BgKoj5YeSuetyfNLaXMByK5g=
X-Received: by 2002:a92:8e42:0:b0:357:cdca:d0b1 with SMTP id
 k2-20020a928e42000000b00357cdcad0b1mr28845ilh.8.1698083618114; Mon, 23 Oct
 2023 10:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-8-rananta@google.com>
 <86wmvd4hp9.wl-maz@kernel.org>
In-Reply-To: <86wmvd4hp9.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 23 Oct 2023 10:53:26 -0700
Message-ID: <CAJHc60zh40KpU4+-ttdeE3vyH-CAw1BWEFf1YSR7cB0zfWjfqQ@mail.gmail.com>
Subject: Re: [PATCH v8 07/13] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 6:00=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 20 Oct 2023 22:40:47 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > KVM does not yet support userspace modifying PMCR_EL0.N (With
> > the previous patch, KVM ignores what is written by userspace).
> > Add support userspace limiting PMCR_EL0.N.
> >
> > Disallow userspace to set PMCR_EL0.N to a value that is greater
> > than the host value as KVM doesn't support more event counters
> > than what the host HW implements. Also, make this register
> > immutable after the VM has started running. To maintain the
> > existing expectations, instead of returning an error, KVM
> > returns a success for these two cases.
> >
> > Finally, ignore writes to read-only bits that are cleared on
> > vCPU reset, and RES{0,1} bits (including writable bits that
> > KVM doesn't support yet), as those bits shouldn't be modified
> > (at least with the current KVM).
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 57 +++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 55 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 2e5d497596ef8..a2c5f210b3d6b 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1176,6 +1176,59 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r,
> >       return 0;
> >  }
> >
> > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
> > +                 u64 val)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +     u64 new_n, mutable_mask;
>
> Really, this lacks consistency. Either you make N a u8 everywhere, or
> a u64 everywhere. I don't mind either, but the type confusion is not
> great.
>
Sorry about that. I'll make it u8 across the board.

> > +
> > +     mutex_lock(&kvm->arch.config_lock);
> > +
> > +     /*
> > +      * Make PMCR immutable once the VM has started running, but
> > +      * do not return an error to meet the existing expectations.
> > +      */
> > +     if (kvm_vm_has_ran_once(vcpu->kvm)) {
> > +             mutex_unlock(&kvm->arch.config_lock);
> > +             return 0;
> > +     }
> > +
> > +     new_n =3D (val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK=
;
> > +     if (new_n !=3D kvm->arch.pmcr_n) {
>
> Why do we need to check this?
>
Hmm, it may be redundant. I guess we can skip this, check for the
limit, and directly write new_n to kvm->arch.pmcr_n.

> > +             u8 pmcr_n_limit =3D kvm_arm_pmu_get_max_counters(kvm);
>
> Can you see why I'm annoyed?
>
Yes. I'll make these consistent.

> > +
> > +             /*
> > +              * The vCPU can't have more counters than the PMU hardwar=
e
> > +              * implements. Ignore this error to maintain compatibilit=
y
> > +              * with the existing KVM behavior.
> > +              */
> > +             if (new_n <=3D pmcr_n_limit)
>
> Isn't this the only thing that actually matters?
>
Yes, I'll remove the above check.

> > +                     kvm->arch.pmcr_n =3D new_n;
> > +     }
> > +     mutex_unlock(&kvm->arch.config_lock);
> > +
> > +     /*
> > +      * Ignore writes to RES0 bits, read only bits that are cleared on
> > +      * vCPU reset, and writable bits that KVM doesn't support yet.
> > +      * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
> > +      * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the v=
CPU.
> > +      * But, we leave the bit as it is here, as the vCPU's PMUver migh=
t
> > +      * be changed later (NOTE: the bit will be cleared on first vCPU =
run
> > +      * if necessary).
> > +      */
> > +     mutable_mask =3D (ARMV8_PMU_PMCR_MASK |
> > +                     (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT)=
);
>
> Why is N part of the 'mutable' mask? The only bits that should make it
> into the register are ARMV8_PMU_PMCR_MASK.
>
> > +     val &=3D mutable_mask;
> > +     val |=3D (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
> > +
> > +     /* The LC bit is RES1 when AArch32 is not supported */
> > +     if (!kvm_supports_32bit_el0())
> > +             val |=3D ARMV8_PMU_PMCR_LC;
> > +
> > +     __vcpu_sys_reg(vcpu, r->reg) =3D val;
> > +     return 0;
>
> I think this should be rewritten as:
>
>         val &=3D ARMV8_PMU_PMCR_MASK;
>         /* The LC bit is RES1 when AArch32 is not supported */
>         if (!kvm_supports_32bit_el0())
>                 val |=3D ARMV8_PMU_PMCR_LC;
>
>         __vcpu_sys_reg(vcpu, r->reg) =3D val;
>         return 0;
>
> And that's it. Drop this 'mutable_mask' nonsense, as we should be
> getting the correct value (merge of the per-vcpu register and VM-wide
> N) since patch 4.
>
Sure, I'll consider this.

Thank you.
Raghavendra
