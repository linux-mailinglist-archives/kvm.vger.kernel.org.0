Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA747CC98F
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 19:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbjJQRLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 13:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343848AbjJQRLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 13:11:09 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3871EF0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 10:11:08 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c9d4f08d7cso10935ad.0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 10:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697562667; x=1698167467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYRiu9lSScYzjuPNTRfPjUaha4Cty0VP8HNHJXHNDls=;
        b=f9BfZTs+Pi2SUD2ka9gdvp43f2h0weZ1Gr/dq4t7nuaI6rckMfNq6gq0TmEQ/kvBh4
         8RyTGcPtrBd8F0Q94Veb/2eeL0eMIY+Bgxi8hBxER7T8xcH84MHZ2vdtg2+O1qCv0EtC
         H/bSjExOjnW0ASHQu5Oy65Mj84cyIZOuYcpzRZx9OYypLRnr6uGLQTFrjrbWlNa7z+GP
         SEtzzpWIoF0b4OARQuzPgrGrSMlaTs2Nk81UJjUuVBI3JEqVXlND8qdGaSl3RGJjNNFK
         NX2DCtWIQU8EsRJn/m61raks0iO+BTTOfnujj5O7cYBhPWsOFWM0KFL64fBypZtV5vKL
         ELvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697562667; x=1698167467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYRiu9lSScYzjuPNTRfPjUaha4Cty0VP8HNHJXHNDls=;
        b=OqIjAAzBjq4LNsZHZrsfWEynZTRhSqExVQyvrxFHffPJB8/dlnH5/uA6yh/no4M1W2
         H6/Kvg9LGy13oClJuB3V37peLlsOfcWygC70LIxz/Vqx+71Ks3oknbX7HuHXw5WIXf1M
         LmIv5x3Qfj5rRFD4JtorNW05yIbL/Dz4HnjyBQ43h/rZGZgpNwpDf+6B1pnyifexvtZc
         f2tHGFL5U2GAqgxb+4y7GQSFZzcBkrIXZOf6cS0BTTIQvE0/nF8JUhOuHtlzdGfsybbz
         5dtvfLljSA2G1nKNck2jELmaI8WijQyiWRbkK0coJ2LGjbj1IimtoOrbsBubTJz6Hy4C
         KFkQ==
X-Gm-Message-State: AOJu0YxY+bUyuW6BRmcbSPJlwhAkmCQ9EVIyqFgFdlN+RlG+qHqgCN+y
        TqgfCUDoXG/Kf3JZR6UF+hVJOck5qanj+ZsinwoTgg==
X-Google-Smtp-Source: AGHT+IFRYWvFaJ0WInRTJyr+F9zMf0+RQKXl4mnaUaW2eO670fDT8aRdRXn0jZoCF3qiP5KSAr97AZqkZIqNS1w8Bx0=
X-Received: by 2002:a17:902:6b47:b0:1c9:d7d8:862c with SMTP id
 g7-20020a1709026b4700b001c9d7d8862cmr17098plt.10.1697562667428; Tue, 17 Oct
 2023 10:11:07 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com>
 <e0fdb0ea-2f08-6343-1765-afe32510f3a7@redhat.com>
In-Reply-To: <e0fdb0ea-2f08-6343-1765-afe32510f3a7@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 17 Oct 2023 10:10:55 -0700
Message-ID: <CAJHc60wQuCM_H_ksSWUdCjJj30Stzn1aEr4=jvzqM0ZvhuN5gQ@mail.gmail.com>
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
To:     Sebastian Ott <sebott@redhat.com>
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 8:48=E2=80=AFAM Sebastian Ott <sebott@redhat.com> w=
rote:
>
> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> > +static void guest_code(uint64_t expected_pmcr_n)
> > +{
> > +     uint64_t pmcr, pmcr_n;
> > +
> > +     __GUEST_ASSERT(expected_pmcr_n <=3D ARMV8_PMU_MAX_GENERAL_COUNTER=
S,
> > +                     "Expected PMCR.N: 0x%lx; ARMv8 general counters: =
0x%lx",
> > +                     expected_pmcr_n, ARMV8_PMU_MAX_GENERAL_COUNTERS);
> > +
> > +     pmcr =3D read_sysreg(pmcr_el0);
> > +     pmcr_n =3D get_pmcr_n(pmcr);
> > +
> > +     /* Make sure that PMCR_EL0.N indicates the value userspace set */
> > +     __GUEST_ASSERT(pmcr_n =3D=3D expected_pmcr_n,
> > +                     "Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
> > +                     pmcr_n, expected_pmcr_n);
>
> Expected vs read value is swapped.
>
Good catch! I'll fix this in v8.
>
> Also, since the kernel has special handling for this, should we add a
> test like below?
>
> +static void immutable_test(void)
> +{
> +       struct kvm_vcpu *vcpu;
> +       uint64_t sp, pmcr, pmcr_n;
> +       struct kvm_vcpu_init init;
> +
> +       create_vpmu_vm(guest_code);
> +
> +       vcpu =3D vpmu_vm.vcpu;
> +
> +       /* Save the initial sp to restore them later to run the guest aga=
in */
> +       vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
> +
> +       vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
> +       pmcr_n =3D get_pmcr_n(pmcr);
> +
> +       run_vcpu(vcpu, pmcr_n);
> +
> +       vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> +       init.features[0] |=3D (1 << KVM_ARM_VCPU_PMU_V3);
> +       aarch64_vcpu_setup(vcpu, &init);
> +       vcpu_init_descriptor_tables(vcpu);
> +       vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
> +       vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code)=
;
> +
> +       /* Update the PMCR_EL0.N after the VM ran once */
> +       set_pmcr_n(&pmcr, 0);
> +       vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
> +
> +       /* Verify that the guest still gets the unmodified value */
> +       run_vcpu(vcpu, pmcr_n);
> +
> +       destroy_vpmu_vm();
> +}
Thanks for the suggestion! I'll add this test case in v8.

- Raghavendra
>
