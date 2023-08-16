Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4C277E784
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 19:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345197AbjHPRYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 13:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345203AbjHPRX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 13:23:58 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFC026A9
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 10:23:57 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2b9f48b6796so103567551fa.3
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 10:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692206635; x=1692811435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PN9U96sXQ/WhiZQpYWPMVe4BliphD8Rxbde/Icx+5GY=;
        b=3vCMtSNBvuTAdBXCc6sG59/G95pF+bcwRLTaLl0+A+RoE7y5JkvVhWXuV+2msQYTW5
         fT/ueq2vahIb4KQqCzkJcQSbgxUZa8KO6JGgJ2kguacmllPqRLJGgQjutWURVSgGK9Zq
         adCBaucGEX6BhAR3CYJ1d4rQkS7YtZcUlEl1y6RkpGaWhSUiG5+m2jZuSrE1JlrdZBjQ
         TGe2J90BeKNRJAuvnFC50HVKmN5xHhx7qvJZzwx39u/G4AHpRxSHCeZUWIivNZKx6Kma
         o52/6KfMnnxyR5CzNMGPXDtXzK9ThW8nWV5phFFqyPmxwORO2u0xTMFK20et7EGloK72
         oDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692206635; x=1692811435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PN9U96sXQ/WhiZQpYWPMVe4BliphD8Rxbde/Icx+5GY=;
        b=CTKw1OawpHHKRM5e0fqfzNwI7foZbhUN8XVALU1YIG5b7UwZT+e5SABt7qJ1g5Jguf
         Ei+cicIlCjPuNhavhND9Au3CtO8T1822Pab4yBsycBvuiQlMiAgdWZiBgm2oNjpmADo2
         f84yA92oT8WGfIdcJNw8WD4B/Wq9JBcI4tzYwEpC4LVGXlAa/765x0A53QO7undsA3w0
         YqmNW9GKF9tqr/s4TFyfVuMvon0AE7g3jYeDfEbsWEo5j19j7Tn/FVHUqQorB7b/AjB2
         MAI01ktppsnkcGR9AlLxqOXvC7f9bhkpppIpjRxm0X43Z/JZLeYdLLNUylKTYHmWqvRM
         2NMw==
X-Gm-Message-State: AOJu0YxWUJtFC1I3GBtoXnXhQsp98mRn4j24EWqsDfeQj/9MAXMZg4r7
        +YCajODd4Gqz1r4bS7+F2kDSEwrBmOyCtzCqmTSqNQ==
X-Google-Smtp-Source: AGHT+IF4RUG2j9sLmcTd2hL11fGmibz3EFlXCoe4A3lVSlT8nFACvdbT546I78Gp4RBecCTFJVE21OgKXGhMdNQjWY0=
X-Received: by 2002:a2e:90cb:0:b0:2b8:3a1e:eec9 with SMTP id
 o11-20020a2e90cb000000b002b83a1eeec9mr1955969ljg.36.1692206635158; Wed, 16
 Aug 2023 10:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-12-jingzhangos@google.com> <268054f7-e2f5-37fb-187c-3b2cca41b31a@redhat.com>
In-Reply-To: <268054f7-e2f5-37fb-187c-3b2cca41b31a@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 16 Aug 2023 10:23:43 -0700
Message-ID: <CAAdAUthLunQxN+q+PQxLp1cB=cSn5q_y5DM8av+GTKgkZw+sbQ@mail.gmail.com>
Subject: Re: [PATCH v8 11/11] KVM: arm64: selftests: Test for setting ID
 register from usersapce
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
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
        Cornelia Huck <cohuck@redhat.com>
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

Hi Shaoqin,

On Tue, Aug 15, 2023 at 11:58=E2=80=AFPM Shaoqin Huang <shahuang@redhat.com=
> wrote:
>
> Hi Jing,
>
> On 8/8/23 00:22, Jing Zhang wrote:
> > Add tests to verify setting ID registers from userapce is handled
> > correctly by KVM. Also add a test case to use ioctl
> > KVM_ARM_GET_REG_WRITABLE_MASKS to get writable masks.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >   tools/testing/selftests/kvm/Makefile          |   1 +
> >   .../selftests/kvm/aarch64/set_id_regs.c       | 453 +++++++++++++++++=
+
> >   2 files changed, 454 insertions(+)
> >   create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
> >
> > +
> > +static void test_guest_reg_read(struct kvm_vcpu *vcpu)
> > +{
> > +     struct ucall uc;
> > +     bool done =3D false;
> > +
> > +     while (!done) {
> > +             vcpu_run(vcpu);
> > +
> > +             switch (get_ucall(vcpu, &uc)) {
> > +             case UCALL_ABORT:
> > +                     REPORT_GUEST_ASSERT(uc);
> > +                     break;
> > +             case UCALL_SYNC:
> > +                     uint64_t val;
> aarch64/set_id_regs.c:408:4: error: a label can only be part of a
> statement and a declaration is not a statement.
>
> I can encounter a compiler error at this line. Why not just put the
> uint64_t at the beginning of the function.

Sure. Will move it to the beginning of the function.

>
> Thanks,
> Shaoqin
>
> > +
> > +                     /* Make sure the written values are seen by guest=
 */
> > +                     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(uc.args[2]),=
 &val);
> > +                     ASSERT_EQ(val, uc.args[3]);
> > +                     break;
> > +             case UCALL_DONE:
> > +                     done =3D true;
> > +                     break;
> > +             default:
> > +                     TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
> > +             }
> > +     }
> > +}
> > +
> > +int main(void)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_vm *vm;
> > +     bool aarch64_only;
> > +     uint64_t val, el0;
> > +     int ftr_cnt;
> > +
> > +     vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
> > +
> > +     /* Check for AARCH64 only system */
> > +     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
> > +     el0 =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), val);
> > +     aarch64_only =3D (el0 =3D=3D ID_AA64PFR0_EL1_ELx_64BIT_ONLY);
> > +
> > +     ksft_print_header();
> > +
> > +     ftr_cnt =3D ARRAY_SIZE(ftr_id_aa64dfr0_el1) + ARRAY_SIZE(ftr_id_d=
fr0_el1)
> > +               + ARRAY_SIZE(ftr_id_aa64pfr0_el1) + ARRAY_SIZE(ftr_id_a=
a64mmfr0_el1)
> > +               + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) + ARRAY_SIZE(ftr_id_=
aa64mmfr2_el1)
> > +               + ARRAY_SIZE(ftr_id_aa64mmfr3_el1) - ARRAY_SIZE(test_re=
gs);
> > +
> > +     ksft_set_plan(ftr_cnt);
> > +
> > +     test_user_set_reg(vcpu, aarch64_only);
> > +     test_guest_reg_read(vcpu);
> > +
> > +     kvm_vm_free(vm);
> > +
> > +     ksft_finished();
> > +}
>
> --
> Shaoqin
>

Thanks,
Jing
