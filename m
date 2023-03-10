Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8236B53A8
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 23:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjCJWBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 17:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjCJWBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 17:01:02 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529C914DA0C
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:57:53 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id l16-20020a9d4c10000000b006944b17058cso3728712otf.2
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678485472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AeIS/hX102ukmJS8xgD/xrU31xoW7ub6pr0GI//iWBw=;
        b=HrvxL7K2qURy9tLwhez34OOj4omHJOkLLSEEQPzVvl/kEnTkp9JlKWyX0jcMy70L3y
         P+ZGb1hUWX87iprPkfepunE3NgxqBN0k8CsCFcShB0ACTaLI//wXITh13mKMRIOKoyQv
         +hh7IveFgK6Le+en4/01Y0aO4/vOAx08zknwLAUtBcgUZdlaNXXJKpA7xbcoknQLfoMQ
         6dMalZvGLZicvIkkwCHKPbONrkc2YVKpDRNz1SfaDKARFuMyFD5cE0rnyinCCEVKErxT
         uYU/YeqPL2mGuT0G5Ky0TmDSo9wjr7AtJ2L0VUMf5vnUHUraEgLxID5r/z1z2nPpwexy
         k+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678485472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AeIS/hX102ukmJS8xgD/xrU31xoW7ub6pr0GI//iWBw=;
        b=3/1w047nevl2a0nf4/Ab44BieJdwLQ2giuiIx0qUnSx+n/nNrAQH2fS3atgyVkJk67
         1O+NQiSzRkClBxk92GsqX6LdkVyotDCx/cYCxD8hP5aqPO4HYErOkx2AvVfbIEvrOuOC
         SU/vt/B42hHtsHA7aT4lQ8DWrhyL6/Qp+i/8k+NQ4Pt8rImJR/g7WuAvrBSoVJ7WOR3u
         W9V9CnPoahjqF4dyvF89P97JYIhFG1tJ+iNzlUKWQtyMC13ATlOh8+7/wR3/9gQ32KoY
         YgpAsHqhK7lGUb5gOB2tIe2Mq24sNtRC6JqrpRvekgIV3UJrm0aPmL+KnlEmJtwMkGYA
         iCSA==
X-Gm-Message-State: AO0yUKWqE6sC78hD2yUV2vliauJY1aAcVj4EUg7IxADh3zPb8MYLp0ID
        Bs9VRckNOqfOjZTCvcisWijP62Tku4gLqeHkAqJqQg==
X-Google-Smtp-Source: AK7set/pdnnnpuGYoYxAloqsQEQlaBoZEeCpF0YMrMc3RfS/fMRYvi92R15O+Ql9PPnNW4njON4exqROkJzCpu/d9Zs=
X-Received: by 2002:a05:6830:3094:b0:693:c521:f86d with SMTP id
 g20-20020a056830309400b00693c521f86dmr9498674ots.6.1678485472503; Fri, 10 Mar
 2023 13:57:52 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-11-rananta@google.com>
 <CAAeT=FyCQxhhFqhfWbFQB9uAcUxmktRa3SC_Yfne2f_MEeXOJw@mail.gmail.com>
In-Reply-To: <CAAeT=FyCQxhhFqhfWbFQB9uAcUxmktRa3SC_Yfne2f_MEeXOJw@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 10 Mar 2023 13:57:41 -0800
Message-ID: <CAJHc60zLvbMczhqZ_6CMcr+rsVx817xj-tnfUHg1hvbbex2N9g@mail.gmail.com>
Subject: Re: [REPOST PATCH 10/16] selftests: KVM: aarch64: Add KVM EVTYPE
 filter PMU test
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
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

On Mon, Mar 6, 2023 at 5:19=E2=80=AFPM Reiji Watanabe <reijiw@google.com> w=
rote:
>
> Hi Raghu,
>
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > KVM doest't allow the guests to modify the filter types
> > such counting events in nonsecure/secure-EL2, EL3, and
> > so on. Validate the same by force-configuring the bits
> > in PMXEVTYPER_EL0, PMEVTYPERn_EL0, and PMCCFILTR_EL0
> > registers.
> >
> > The test extends further by trying to create an event
> > for counting only in EL2 and validates if the counter
> > is not progressing.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vpmu_test.c | 85 +++++++++++++++++++
> >  1 file changed, 85 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/te=
sting/selftests/kvm/aarch64/vpmu_test.c
> > index 3dfb770b538e9..5c166df245589 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > @@ -15,6 +15,10 @@
> >   * of allowing or denying the events. The guest validates it by
> >   * checking if it's able to count only the events that are allowed.
> >   *
> > + * 3. KVM doesn't allow the guest to count the events attributed with
> > + * higher exception levels (EL2, EL3). Verify this functionality by
> > + * configuring and trying to count the events for EL2 in the guest.
> > + *
> >   * Copyright (c) 2022 Google LLC.
> >   *
> >   */
> > @@ -23,6 +27,7 @@
> >  #include <test_util.h>
> >  #include <vgic.h>
> >  #include <asm/perf_event.h>
> > +#include <linux/arm-smccc.h>
> >  #include <linux/bitfield.h>
> >  #include <linux/bitmap.h>
> >
> > @@ -259,6 +264,7 @@ struct vpmu_vm {
> >  enum test_stage {
> >         TEST_STAGE_COUNTER_ACCESS =3D 1,
> >         TEST_STAGE_KVM_EVENT_FILTER,
> > +       TEST_STAGE_KVM_EVTYPE_FILTER,
> >  };
> >
> >  struct guest_data {
> > @@ -678,6 +684,70 @@ static void guest_event_filter_test(unsigned long =
*pmu_filter)
> >         }
> >  }
> >
> > +static void guest_evtype_filter_test(void)
> > +{
> > +       int i;
> > +       struct pmc_accessor *acc;
> > +       uint64_t typer, cnt;
> > +       struct arm_smccc_res res;
> > +
> > +       pmu_enable();
> > +
> > +       /*
> > +        * KVM blocks the guests from creating events for counting in S=
ecure/Non-Secure Hyp (EL2),
> > +        * Monitor (EL3), and Multithreading configuration. It applies =
the mask
> > +        * ARMV8_PMU_EVTYPE_MASK against guest accesses to PMXEVTYPER_E=
L0, PMEVTYPERn_EL0,
> > +        * and PMCCFILTR_EL0 registers to prevent this. Check if KVM ho=
nors this using all possible
> > +        * ways to configure the EVTYPER.
> > +        */
>
> I would prefer to break long lines into multiple lines for these comments
> (or other comments in these patches), as "Linux kernel coding style"
> suggests.
> ---
> [https://www.kernel.org/doc/html/latest/process/coding-style.html#breakin=
g-long-lines-and-strings]
>
> The preferred limit on the length of a single line is 80 columns.
>
> Statements longer than 80 columns should be broken into sensible
> chunks, unless exceeding 80 columns significantly increases
> readability and does not hide information.
> ---
>
Sure, I'll fix it.
> > +       for (i =3D 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> > +               acc =3D &pmc_accessors[i];
> > +
> > +               /* Set all filter bits (31-24), readback, and check aga=
inst the mask */
> > +               acc->write_typer(0, 0xff000000);
> > +               typer =3D acc->read_typer(0);
> > +
> > +               GUEST_ASSERT_2((typer | ARMV8_PMU_EVTYPE_EVENT) =3D=3D =
ARMV8_PMU_EVTYPE_MASK,
> > +                               typer | ARMV8_PMU_EVTYPE_EVENT, ARMV8_P=
MU_EVTYPE_MASK);
>
> It appears that bits[29:26] don't have to be zero depending on
> feature availability to the guest (Those bits needs to be zero
> only when relevant features are not available on the guest).
> So, the expected value must be changed depending on the feature
> availability if the test checks those bits.
> I have the same comment for the cycle counter.
>
But doesn't KVM (and the ARM PMU driver) ignore these bits upon write
using ARMV8_PMU_EVTYPE_MASK?
> > +
> > +               /*
> > +                * Regardless of ARMV8_PMU_EVTYPE_MASK, KVM sets perf a=
ttr.exclude_hv
> > +                * to not count NS-EL2 events. Verify this functionalit=
y by configuring
> > +                * a NS-EL2 event, for which the couunt shouldn't incre=
ment.
> > +                */
> > +               typer =3D ARMV8_PMUV3_PERFCTR_INST_RETIRED;
> > +               typer |=3D ARMV8_PMU_INCLUDE_EL2 | ARMV8_PMU_EXCLUDE_EL=
1 | ARMV8_PMU_EXCLUDE_EL0;
> > +               acc->write_typer(0, typer);
> > +               acc->write_cntr(0, 0);
> > +               enable_counter(0);
> > +
> > +               /* Issue a hypercall to enter EL2 and return */
> > +               memset(&res, 0, sizeof(res));
> > +               smccc_hvc(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0, 0, 0, 0, =
0, &res);
> > +
> > +               cnt =3D acc->read_cntr(0);
> > +               GUEST_ASSERT_3(cnt =3D=3D 0, cnt, typer, i);
> > +       }
> > +
> > +       /* Check the same sequence for the Cycle counter */
> > +       write_pmccfiltr(0xff000000);
> > +       typer =3D read_pmccfiltr();
> > +       GUEST_ASSERT_2((typer | ARMV8_PMU_EVTYPE_EVENT) =3D=3D ARMV8_PM=
U_EVTYPE_MASK,
> > +                               typer | ARMV8_PMU_EVTYPE_EVENT, ARMV8_P=
MU_EVTYPE_MASK);
> > +
> > +       typer =3D ARMV8_PMU_INCLUDE_EL2 | ARMV8_PMU_EXCLUDE_EL1 | ARMV8=
_PMU_EXCLUDE_EL0;
> > +       write_pmccfiltr(typer);
> > +       reset_cycle_counter();
> > +       enable_cycle_counter();
> > +
> > +       /* Issue a hypercall to enter EL2 and return */
> > +       memset(&res, 0, sizeof(res));
> > +       smccc_hvc(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res)=
;
> > +
> > +       cnt =3D read_cycle_counter();
>
> Perhaps it's worth considering having the helpers for PMC registers
> (e.g. write_cntr()) accepting the cycle counter as the index=3D=3D31
> to simplify the test code implementation ?
>
> Thank you,
> Reiji
>
> > +       GUEST_ASSERT_2(cnt =3D=3D 0, cnt, typer);
> > +}
> > +
> >  static void guest_code(void)
> >  {
> >         switch (guest_data.test_stage) {
> > @@ -687,6 +757,9 @@ static void guest_code(void)
> >         case TEST_STAGE_KVM_EVENT_FILTER:
> >                 guest_event_filter_test(guest_data.pmu_filter);
> >                 break;
> > +       case TEST_STAGE_KVM_EVTYPE_FILTER:
> > +               guest_evtype_filter_test();
> > +               break;
> >         default:
> >                 GUEST_ASSERT_1(0, guest_data.test_stage);
> >         }
> > @@ -1014,10 +1087,22 @@ static void run_kvm_event_filter_test(void)
> >         run_kvm_event_filter_error_tests();
> >  }
> >
> > +static void run_kvm_evtype_filter_test(void)
> > +{
> > +       struct vpmu_vm *vpmu_vm;
> > +
> > +       guest_data.test_stage =3D TEST_STAGE_KVM_EVTYPE_FILTER;
> > +
> > +       vpmu_vm =3D create_vpmu_vm(guest_code, NULL);
> > +       run_vcpu(vpmu_vm->vcpu);
> > +       destroy_vpmu_vm(vpmu_vm);
> > +}
> > +
> >  static void run_tests(uint64_t pmcr_n)
> >  {
> >         run_counter_access_tests(pmcr_n);
> >         run_kvm_event_filter_test();
> > +       run_kvm_evtype_filter_test();
> >  }
> >
> >  /*
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >
