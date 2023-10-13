Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA4F7C8EBA
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 23:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjJMVFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 17:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjJMVFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 17:05:44 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2057BD8
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 14:05:43 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1c9c496c114so19635ad.0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 14:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697231142; x=1697835942; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9loeVc7ZCpz1U3HtoGFGkfvxqtu4wzzEKlz442ZZopc=;
        b=2LwReX0F3nCKV99+jdz0k4S0dJbvw+0Mk4xfx/FwvOFNcaZqXGP1XAwOc8hZw8ORhn
         1KbW6N0KKxoYGZYVmstxeMe1pPBA4LpZexkvJtP2rWIAuabqu8Br8gmyqM6x3ad+3fcE
         kgnFpxOSCFs6uw3iPCbDnPSiB2reoYnuUd86Jaaoe/VZB7z3WKfEyGrCKZkMQ3hhv/a/
         YynDLOY++f5gyTKJj22bfjVMbyfhWqoLNQjil9IsqxRAzPBrORlxLbtVHxUpuCx8MTaY
         hHbVg4r79cC+bm7Ij0+24+x5+e4eI34OsF5iLwpGWlPeruzHP4L5TccoYbCK94rF4FV7
         VSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697231142; x=1697835942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9loeVc7ZCpz1U3HtoGFGkfvxqtu4wzzEKlz442ZZopc=;
        b=EAeV+9ll2Z5lCcKrOtjWQIE8bg9MPUg0OgiukeDiz8u4jPSFLqpQc0NmPAvMz/rBUw
         hoJkevj7bo8naaewp9GPcd1PulyIrdqXNz4LRXZcHIxYKMMiDo+jyGBG3LPkeuTwBgqD
         z2pgl4i936B4I7MO79IBuyWbyV/jTKDqdkeCzrkvA9AflpLjY/5qjMBzvOykVp4LGN2k
         exXqoNHanmtJ1zbmqWC+ZGm3dRvLkoLXJQhQ9iI3+q6KdvRYNe+XKvIGu1A2c1Mq9+1Z
         FAO1RvWKAh4RRiOSoDVYleFCTGP3R3Nut54nn4FsFhs0NSwHqP05bOV7Xkj3J/gX+bh4
         sU0g==
X-Gm-Message-State: AOJu0YzJznEhJBxiYrX5kXdPx60DGH4J13Q2TLZJPisH0rfZxDYCegYy
        S3iLDYHHSbSSOQliMPOryb7evbMaHDYM6XeJKo0GKQ==
X-Google-Smtp-Source: AGHT+IGmE2kcxknf3VOjyjldKQegv7yUhYk/0p3emwCC3aA8BQ87FBHfp4RjlB3evF/TEAo1u443JbP1ExLaV/9nlDw=
X-Received: by 2002:a17:902:f788:b0:1c5:6691:4931 with SMTP id
 q8-20020a170902f78800b001c566914931mr42007pln.12.1697231142284; Fri, 13 Oct
 2023 14:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com>
 <44608d30-c97a-c725-e8b2-0c5a81440869@redhat.com> <65b8bbdb-2187-3c85-0e5d-24befcf01333@redhat.com>
In-Reply-To: <65b8bbdb-2187-3c85-0e5d-24befcf01333@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 13 Oct 2023 14:05:29 -0700
Message-ID: <CAJHc60zPc6eM+t7pOM19aKbf_9cMvj_LnPnG1EO35=EP0jG+Tg@mail.gmail.com>
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
To:     Sebastian Ott <sebott@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>,
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

On Thu, Oct 12, 2023 at 8:02=E2=80=AFAM Sebastian Ott <sebott@redhat.com> w=
rote:
>
> On Thu, 12 Oct 2023, Sebastian Ott wrote:
> > On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> >>  +/* Create a VM that has one vCPU with PMUv3 configured. */
> >>  +static void create_vpmu_vm(void *guest_code)
> >>  +{
> >>  +   struct kvm_vcpu_init init;
> >>  +   uint8_t pmuver, ec;
> >>  +   uint64_t dfr0, irq =3D 23;
> >>  +   struct kvm_device_attr irq_attr =3D {
> >>  +           .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> >>  +           .attr =3D KVM_ARM_VCPU_PMU_V3_IRQ,
> >>  +           .addr =3D (uint64_t)&irq,
> >>  +   };
> >>  +   struct kvm_device_attr init_attr =3D {
> >>  +           .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> >>  +           .attr =3D KVM_ARM_VCPU_PMU_V3_INIT,
> >>  +   };
> >>  +
> >>  +   /* The test creates the vpmu_vm multiple times. Ensure a clean st=
ate
> >>  */
> >>  +   memset(&vpmu_vm, 0, sizeof(vpmu_vm));
> >>  +
> >>  +   vpmu_vm.vm =3D vm_create(1);
> >>  +   vm_init_descriptor_tables(vpmu_vm.vm);
> >>  +   for (ec =3D 0; ec < ESR_EC_NUM; ec++) {
> >>  +           vm_install_sync_handler(vpmu_vm.vm, VECTOR_SYNC_CURRENT, =
ec,
> >>  +                                   guest_sync_handler);
> >>  +   }
> >>  +
> >>  +   /* Create vCPU with PMUv3 */
> >>  +   vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> >>  +   init.features[0] |=3D (1 << KVM_ARM_VCPU_PMU_V3);
> >>  +   vpmu_vm.vcpu =3D aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_cod=
e);
> >>  +   vcpu_init_descriptor_tables(vpmu_vm.vcpu);
> >>  +   vpmu_vm.gic_fd =3D vgic_v3_setup(vpmu_vm.vm, 1, 64,
> >>  +                                   GICD_BASE_GPA, GICR_BASE_GPA);
> >>  +
> >>  +   /* Make sure that PMUv3 support is indicated in the ID register *=
/
> >>  +   vcpu_get_reg(vpmu_vm.vcpu,
> >>  +                KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
> >>  +   pmuver =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0=
);
> >>  +   TEST_ASSERT(pmuver !=3D ID_AA64DFR0_PMUVER_IMP_DEF &&
> >>  +               pmuver >=3D ID_AA64DFR0_PMUVER_8_0,
> >>  +               "Unexpected PMUVER (0x%x) on the vCPU with PMUv3",
> >>  pmuver);
> >>  +
> >>  +   /* Initialize vPMU */
> >>  +   vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
> >>  +   vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
> >>  +}
> >
> > This one fails to build for me:
> > aarch64/vpmu_counter_access.c: In function =E2=80=98create_vpmu_vm=E2=
=80=99:
> > aarch64/vpmu_counter_access.c:456:47: error: =E2=80=98ID_AA64DFR0_PMUVE=
R_MASK=E2=80=99
> > undeclared (first use in this function); did you mean
> > =E2=80=98ID_AA64DFR0_EL1_PMUVer_MASK=E2=80=99?
> >   456 |         pmuver =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMU=
VER),
> >   dfr0);
>
> Looks like there's a clash with
> "KVM: arm64: selftests: Import automatic generation of sysreg defs"
> from:
>         https://lore.kernel.org/r/20231003230408.3405722-12-oliver.upton@=
linux.dev
Thanks for the pointer, Sebastian! Surprisingly, I don't see the patch
when I sync to kvmarm/next.

Oliver,

Aren't the selftest patches from the 'Enable writable ID regs' series
[1] merged into kvmarm/next? Looking at the log, I couldn't find them
and the last patch that went from the series was [2]. Am I missing
something?

Thank you.
Raghavendra

[1]: https://lore.kernel.org/all/169644154288.3677537.15121340860793882283.=
b4-ty@linux.dev/
[2]: https://lore.kernel.org/all/20231003230408.3405722-11-oliver.upton@lin=
ux.dev/
