Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16F26AFD4E
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 04:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCHDPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 22:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCHDPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 22:15:44 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE0695BF9
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 19:15:40 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id a9so16401610plh.11
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 19:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678245339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8KLtOtqIOku6+uBljLyZ+IqwdfXOpvVBsa3QjdNH7SI=;
        b=tgihNc5yOKSPh0ZzINtG7H0j9M/j1GVyE7wa3RYbV/FwmMo7YWI2XQx2lveRIo0G0+
         G8wF1DwEkZvHjGc6fz8GuQ33mwbC95BoOE9HlXkYBQp7aOCCu39q6qKJjrSIR1G/gZT9
         7jDY6ZZPKeeO/54gBJrfHZWVu0xlTUe8vPJwlngrWxZgYS8ubElrpjX/1/hAte42k9Ei
         O1Gr5J4GTa7qcLZYxA9t+gtbGyEpkOQg9lnWQqD5gIOFieJgREtU+m8pEPnN5CLU1GmL
         8j8zFgzXAJ7pbGsyxgsEOp3zciTFw2SoUXV2iEEljKJfkArhOiPveZEUqGqPTXyxOMko
         HUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678245339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8KLtOtqIOku6+uBljLyZ+IqwdfXOpvVBsa3QjdNH7SI=;
        b=mqShLeN/l9+c1Kp0v0t3yzWuwWQXPTQCzzcllMaXeycZdwcvvaswBOh4nGJZZ7yBCh
         dGs9l3ti2935Yp3aNulU+CC95BJRZOJOpmxlnvCGiaY07YRxb8ie5oFgphyiuq7Qbtm/
         +YdBNTs5JIJ+tJmUkF23N+BFbgG8ilhPi7VEVrQa4jg+yP0ROITBuG8yOo+5HSF4iZ2g
         /AgD9lWSDa2jd+8+bC6AUfrpiL20wQQqdhWaKwci5+iGGqMyiU6t8fm5Nu24BwExCyUp
         eoPo34xQQ7QD+djVxj7wniiDruGa3oQgCM5UCRnpmbGGRivbNi/0SNQMUtOjq7dXpug+
         sxjA==
X-Gm-Message-State: AO0yUKXKuM8rNJSPHNmeLlfS7whENCx9kCFROZqSiwrATeKyQ2DJB+5a
        FxUokWo6MrNMIxoT/g6TmB1Br/2tGSpZdPFTDrWk8Q==
X-Google-Smtp-Source: AK7set87QoRQVLy6vDriYzYfoiOmWlVTVUGUN2kXf1H2zM/7/OLmxw44WQa80T6nXG0RwsaZBlmfoqVDPLlBJedT33g=
X-Received: by 2002:a17:902:6846:b0:19c:9999:e922 with SMTP id
 f6-20020a170902684600b0019c9999e922mr6471879pln.5.1678245339412; Tue, 07 Mar
 2023 19:15:39 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-14-rananta@google.com>
In-Reply-To: <20230215010717.3612794-14-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 7 Mar 2023 19:15:23 -0800
Message-ID: <CAAeT=Fw5Y3yqh4gfYH+1G0a11Uced-HV15fcWq=q7n0x-j9FQQ@mail.gmail.com>
Subject: Re: [REPOST PATCH 13/16] selftests: KVM: aarch64: Test chained events
 for PMU
To:     Raghavendra Rao Ananta <rananta@google.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HI Raghu,


On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Extend the vPMU's vCPU migration test to validate
> chained events, and their overflow conditions.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vpmu_test.c | 76 ++++++++++++++++++-
>  1 file changed, 75 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/test=
ing/selftests/kvm/aarch64/vpmu_test.c
> index 066dc17fa3906..de725f4339ad5 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> @@ -23,7 +23,7 @@
>   * migrating the guest vCPU to random pCPUs in the system, and check
>   * if the vPMU is still behaving as expected. The sub-tests include
>   * testing basic functionalities such as basic counters behavior,
> - * overflow, and overflow interrupts.
> + * overflow, overflow interrupts, and chained events.
>   *
>   * Copyright (c) 2022 Google LLC.
>   *
> @@ -61,6 +61,8 @@
>  #define PRE_OVERFLOW_32                (GENMASK(31, 0) - COUNT_TO_OVERFL=
OW + 1)
>  #define PRE_OVERFLOW_64                (GENMASK(63, 0) - COUNT_TO_OVERFL=
OW + 1)
>
> +#define ALL_SET_64             GENMASK(63, 0)
> +
>  #define GICD_BASE_GPA  0x8000000ULL
>  #define GICR_BASE_GPA  0x80A0000ULL
>
> @@ -639,6 +641,75 @@ static void test_cycles_count(bool expect_count, boo=
l test_overflow)
>         pmu_disable_reset();
>  }
>
> +static void test_chained_count(int pmc_idx)
> +{
> +       int i, chained_pmc_idx;
> +       struct pmc_accessor *acc;
> +       uint64_t pmcr_n, cnt, cntr_val;
> +
> +       /* The test needs at least two PMCs */
> +       pmcr_n =3D get_pmcr_n();
> +       GUEST_ASSERT_1(pmcr_n >=3D 2, pmcr_n);

Nit: As the architecture doesn't require this, rather than causing the
test failure, I would suggest gracefully skipping this test case or
make this the requirement of the test.

Thanks,
Reiji


> +
> +       /*
> +        * The chained counter's idx is always chained with (pmc_idx + 1)=
.
> +        * pmc_idx should be even as the chained event doesn't count on
> +        * odd numbered counters.
> +        */
> +       GUEST_ASSERT_1(pmc_idx % 2 =3D=3D 0, pmc_idx);
> +
> +       /*
> +        * The max counter idx that the chained counter can occupy is
> +        * (pmcr_n - 1), while the actual event sits on (pmcr_n - 2).
> +        */
> +       chained_pmc_idx =3D pmc_idx + 1;
> +       GUEST_ASSERT(chained_pmc_idx < pmcr_n);
> +
> +       enable_counter(chained_pmc_idx);
> +       pmu_irq_init(chained_pmc_idx);
> +
> +       /* Configure the chained event using all the possible ways*/
> +       for (i =3D 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> +               acc =3D &pmc_accessors[i];
> +
> +               /* Test if the chained counter increments when the base e=
vent overflows */
> +
> +               cntr_val =3D 1;
> +               acc->write_cntr(chained_pmc_idx, cntr_val);
> +               acc->write_typer(chained_pmc_idx, ARMV8_PMUV3_PERFCTR_CHA=
IN);
> +
> +               /* Chain the counter with pmc_idx that's configured for a=
n overflow */
> +               test_instructions_count(pmc_idx, true, true);
> +
> +               /*
> +                * pmc_idx is also configured to run for all the ARRAY_SI=
ZE(pmc_accessors)
> +                * combinations. Hence, the chained chained_pmc_idx is ex=
pected to be
> +                * cntr_val + ARRAY_SIZE(pmc_accessors).
> +                */
> +               cnt =3D acc->read_cntr(chained_pmc_idx);
> +               GUEST_ASSERT_4(cnt =3D=3D cntr_val + ARRAY_SIZE(pmc_acces=
sors),
> +                               pmc_idx, i, cnt, cntr_val + ARRAY_SIZE(pm=
c_accessors));
> +
> +               /* Test for the overflow of the chained counter itself */
> +
> +               cntr_val =3D ALL_SET_64;
> +               acc->write_cntr(chained_pmc_idx, cntr_val);
> +
> +               test_instructions_count(pmc_idx, true, true);
> +
> +               /*
> +                * At this point, an interrupt should've been fired for t=
he chained
> +                * counter (which validates the overflow bit), and the co=
unter should've
> +                * wrapped around to ARRAY_SIZE(pmc_accessors) - 1.
> +                */
> +               cnt =3D acc->read_cntr(chained_pmc_idx);
> +               GUEST_ASSERT_4(cnt =3D=3D ARRAY_SIZE(pmc_accessors) - 1,
> +                               pmc_idx, i, cnt, ARRAY_SIZE(pmc_accessors=
));
> +       }
> +
> +       pmu_irq_exit(chained_pmc_idx);
> +}
> +
>  static void test_event_count(uint64_t event, int pmc_idx, bool expect_co=
unt)
>  {
>         switch (event) {
> @@ -665,6 +736,9 @@ static void test_basic_pmu_functionality(void)
>         /* Test overflow with interrupts on generic and cycle counters */
>         test_instructions_count(0, true, true);
>         test_cycles_count(true, true);
> +
> +       /* Test chained events */
> +       test_chained_count(0);
>  }
>
>  /*
> --
> 2.39.1.581.gbfd45094c4-goog
>
