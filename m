Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5451E7CC953
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 18:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbjJQQ74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 12:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjJQQ7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 12:59:53 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F1394
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:59:52 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c9b70b9671so2745ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697561992; x=1698166792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5yMNU4rPFpkkiYfIDqG4Wx36aOJ+fPY9zqBtHEee9ps=;
        b=OdlaQq4Nozh6+WwkM4dpFLikoxGvlg3FfYFWF5oVKunOjV1l3Elo8yzNTJ4HT9OySq
         OOUErA/K4nPohzlwM4kfryIVobetgKktVFvjcqHWXMZjPD+4uQoUgdxFPofIvZoCW9N4
         AUg1QrhDxCCFt3yQtidA++IGywvPcuGhz/oQh2x0pNUAVHY0dEihj7h/skTabcw02YYF
         32fFFG18Cz53jd0mPHgoDzoigm1l9xh4NhJWgCRP5LYA9josBICsyv8jiiensvCCKbN3
         fSC4jodXJfJu0d2eIpGZbRxIjKJaqb+iMvPOo0rLXZhITd79bbS6Cyg5aYYILOfOyOP6
         ycQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697561992; x=1698166792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5yMNU4rPFpkkiYfIDqG4Wx36aOJ+fPY9zqBtHEee9ps=;
        b=gF+RssbsaSNsIr2rP/aZZpkMwfeZb5VK7jPUkBmLYg/c+nlo4HBO0ZPHNcpjh1sAgi
         kA43n4p3GZi6AGCFSZu2nNiL5u5XAaeXU/uWw8YoaisYAuw7kqclybRif+Z4lUnN7AVV
         eZE4BnPgBGR1XCf1cGU0kZ+qCsds4LIyHsVJ7+GOdpeFrWRyA85l9Oxn7AzXnAB43Jeb
         Nl87ffLDNIN2C2pkKiGPC8rZBo5QHFYIpvRetOzux1f7b9z+fgABXMS+oU3IU6R4Bcf2
         xoMhjx0OTqZzQ7+WJVUYrYJM8Dwwlp1ISDbViUR6K1+w4X/Kk4tB0ZDql1cYeuDjGkh6
         /Uvg==
X-Gm-Message-State: AOJu0YxkHqiA7Jjk9M1FBwMn4fLwP04ofLsqNbbnO9FCnsxKuA9CaPCE
        9V2H1Y3J8eDwKmGkRLwDDxxK1zactF5f4iv/kt2PAA==
X-Google-Smtp-Source: AGHT+IEwRmI28DmtYEWCZFKuGUo5CoFAqIKSbqXw7iZ5appdMW5bDM7BRVBP4wf/lwdI59wdYM4cFsO+Yk5Xpfh0Cd0=
X-Received: by 2002:a17:902:9b98:b0:1c7:1fbc:b9e8 with SMTP id
 y24-20020a1709029b9800b001c71fbcb9e8mr10033plp.10.1697561991580; Tue, 17 Oct
 2023 09:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com> <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
 <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com>
In-Reply-To: <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 17 Oct 2023 09:59:39 -0700
Message-ID: <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
To:     Eric Auger <eauger@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
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

Hi Eric,
On Tue, Oct 17, 2023 at 2:23=E2=80=AFAM Eric Auger <eauger@redhat.com> wrot=
e:
>
> Hi,
> On 10/16/23 23:28, Raghavendra Rao Ananta wrote:
> > On Mon, Oct 16, 2023 at 12:45=E2=80=AFPM Eric Auger <eauger@redhat.com>=
 wrote:
> >>
> >> Hi Raghavendra,
> >>
> >> On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> >>> From: Reiji Watanabe <reijiw@google.com>
> >>>
> >>> On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
> >>> PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
> >> PMOVS{SET,CLR}_EL0?
> > Ah, yes. It should be PMOVS{SET,CLR}_EL0.
> >
> >>> This function clears RAZ bits of those registers corresponding
> >>> to unimplemented event counters on the vCPU, and sets bits
> >>> corresponding to implemented event counters to a predefined
> >>> pseudo UNKNOWN value (some bits are set to 1).
> >>>
> >>> The function identifies (un)implemented event counters on the
> >>> vCPU based on the PMCR_EL0.N value on the host. Using the host
> >>> value for this would be problematic when KVM supports letting
> >>> userspace set PMCR_EL0.N to a value different from the host value
> >>> (some of the RAZ bits of those registers could end up being set to 1)=
.
> >>>
> >>> Fix this by clearing the registers so that it can ensure
> >>> that all the RAZ bits are cleared even when the PMCR_EL0.N value
> >>> for the vCPU is different from the host value. Use reset_val() to
> >>> do this instead of fixing reset_pmu_reg(), and remove
> >>> reset_pmu_reg(), as it is no longer used.
> >> do you intend to restore the 'unknown' behavior at some point?
> >>
> > I believe Reiji's (original author) intention was to keep them
> > cleared, which would still imply an 'unknown' behavior. Do you think
> > there's an issue with this?
> Then why do we bother using reset_unknown in the other places if
> clearing the bits is enough here?
>
Hmm. Good point. I can bring back reset_unknown to keep the original behavi=
or.

Thank you.
Raghavendra
> Thanks
>
> Eric
> >
> > Thank you.
> > Raghavendra
> >> Thanks
> >>
> >> Eric
> >>>
> >>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >>> ---
> >>>  arch/arm64/kvm/sys_regs.c | 21 +--------------------
> >>>  1 file changed, 1 insertion(+), 20 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >>> index 818a52e257ed..3dbb7d276b0e 100644
> >>> --- a/arch/arm64/kvm/sys_regs.c
> >>> +++ b/arch/arm64/kvm/sys_regs.c
> >>> @@ -717,25 +717,6 @@ static unsigned int pmu_visibility(const struct =
kvm_vcpu *vcpu,
> >>>       return REG_HIDDEN;
> >>>  }
> >>>
> >>> -static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg=
_desc *r)
> >>> -{
> >>> -     u64 n, mask =3D BIT(ARMV8_PMU_CYCLE_IDX);
> >>> -
> >>> -     /* No PMU available, any PMU reg may UNDEF... */
> >>> -     if (!kvm_arm_support_pmu_v3())
> >>> -             return 0;
> >>> -
> >>> -     n =3D read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> >>> -     n &=3D ARMV8_PMU_PMCR_N_MASK;
> >>> -     if (n)
> >>> -             mask |=3D GENMASK(n - 1, 0);
> >>> -
> >>> -     reset_unknown(vcpu, r);
> >>> -     __vcpu_sys_reg(vcpu, r->reg) &=3D mask;
> >>> -
> >>> -     return __vcpu_sys_reg(vcpu, r->reg);
> >>> -}
> >>> -
> >>>  static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_re=
g_desc *r)
> >>>  {
> >>>       reset_unknown(vcpu, r);
> >>> @@ -1115,7 +1096,7 @@ static bool access_pmuserenr(struct kvm_vcpu *v=
cpu, struct sys_reg_params *p,
> >>>         trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
> >>>
> >>>  #define PMU_SYS_REG(name)                                           =
 \
> >>> -     SYS_DESC(SYS_##name), .reset =3D reset_pmu_reg,                =
   \
> >>> +     SYS_DESC(SYS_##name), .reset =3D reset_val,                    =
   \
> >>>       .visibility =3D pmu_visibility
> >>>
> >>>  /* Macro to expand the PMEVCNTRn_EL0 register */
> >>
> >
>
