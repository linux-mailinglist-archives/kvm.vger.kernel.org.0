Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80957CC948
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 18:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343638AbjJQQ6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 12:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234913AbjJQQ61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 12:58:27 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409F3AB
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:58:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c9d4f08d7cso7915ad.0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697561901; x=1698166701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmPJRnpivnS9Ld3ifHaIxKEN+4gdJjCgtDpfk6S2hXE=;
        b=2L6mAl14VlXNgBTdAeiI02k9MwHXmJE9UQV5MZL9VCENvj6D1mevT2fEXAhjVX8EfG
         45RyGf0w7m0g+uwJOjJE0rxL8jW5V56485TckBhhBi+FejNVTzvk3X82z7JbEHVZsNL4
         kwC30yu3Iz8WiqNGjXBmiuxpCuJewbnNvaBTFk4aNvAxBBRPZp+IsgY+uXesxlS7C4oN
         RpFWfCezO25f3ZCvQ2utcTzxsi7N7gdSCluzfZJtkPcc/NXIBYruurXxHET1B9p518vD
         vmAOuzH/zdwitvzj1Ro4SRiktu4xHu5mkrKXWUm07XDjKR8RyJoG7KwoRs8hp00zmS4B
         aSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697561901; x=1698166701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cmPJRnpivnS9Ld3ifHaIxKEN+4gdJjCgtDpfk6S2hXE=;
        b=Hvd8aI4DokSVi+jRUAGAezQ3TZHlkaFfuK4GwWoPM/p8w76rnQVv8hl3OOeNnf5E00
         tmCz+6bDrMcd0OhajK9EG8ShZS+oSfyz8huVr1rLlBAjG3FhARZMl2QGmQT4XlwdTTRm
         bct0i8mq3zBWudrvtAfCLVuxbgKHQLIQP+Z/Z1DE8JIpf8TmUG7KCl4ujxGmiCdqW+Kl
         cFXYxb/p/9mLVVZjnCzSNIUyIrfJaM1if3Mb4NrMXKE5HD6wdLTup/Gm/RRRtO6Ui3QC
         zpPm6zYKtTPZHbyo69GBiI2I3iovvq2jCReqXh9Z6dd+pygv+/OL1QKhbkQ7rGFk8u+G
         ErRQ==
X-Gm-Message-State: AOJu0YyCfEGnQYjhKf4R1LDXQwbtpknOcOEsSXokTI5FG9OKEHXJAqdg
        alMK0f/19huU+5sMwx+qfw/ZZ5qVnSzKBdQy0QSatg==
X-Google-Smtp-Source: AGHT+IFdak6zKVvjh5pTE9PJ2mNYXu9g1c5yLqvHo5vfOMsPNjzinB8Vi5laVHN/edB4nVpOLqI1r90pCnv5KDaCrls=
X-Received: by 2002:a17:903:290:b0:1ca:16b8:b541 with SMTP id
 j16-20020a170903029000b001ca16b8b541mr6265plr.24.1697561900478; Tue, 17 Oct
 2023 09:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com> <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev> <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
 <ZS4hGL5RIIuI1KOC@linux.dev>
In-Reply-To: <ZS4hGL5RIIuI1KOC@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 17 Oct 2023 09:58:08 -0700
Message-ID: <CAJHc60zQb0akx2Opbh3_Q8JShBC_9NFNvtAE+bPNi9QqXUGncA@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 10:52=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Mon, Oct 16, 2023 at 02:35:52PM -0700, Raghavendra Rao Ananta wrote:
>
> [...]
>
> > > What's the point of doing this in the first place? The implementation=
 of
> > > kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped val=
ue.
> > >
> > I guess originally the change replaced read_sysreg(pmcr_el0) with
> > kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
> > But if you and Sebastian feel that it's an overkill and directly
> > getting the value via vcpu->kvm->arch.pmcr_n is more readable, I'm
> > happy to make the change.
>
> No, I'd rather you delete the line where PMCR_EL0.N altogether.
> reset_pmcr() tries to initialize the field, but your
> kvm_vcpu_read_pmcr() winds up replacing it with pmcr_n.
>
I didn't get this comment. We still do initialize pmcr, but using the
pmcr.n read via kvm_vcpu_read_pmcr() instead of the actual system
register.

Thank you.
Raghavendra
> > @@ -1105,8 +1109,16 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
> >  /**
> >   * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
> >   * @vcpu: The vcpu pointer
> > + *
> > + * The function returns the value of PMCR.N based on the per-VM tracke=
d
> > + * value (kvm->arch.pmcr_n). This is to ensure that the register field
> > + * remains consistent for the VM, even on heterogeneous systems where
> > + * the value may vary when read from different CPUs (during vCPU reset=
).
>
> Since I'm looking at this again, I don't believe the comment is adding
> much. KVM doesn't read pmcr_el0 directly anymore, and kvm_arch is
> clearly VM-scoped context.
>
> >   */
> >  u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> >  {
> > -     return __vcpu_sys_reg(vcpu, PMCR_EL0);
> > +     u64 pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0) &
> > +                     ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT=
);
> > +
> > +     return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SH=
IFT);
> >  }
>
>
> --
> Thanks,
> Oliver
