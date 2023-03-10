Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B0D6B561B
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 00:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjCJX7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 18:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjCJX7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 18:59:05 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217CFE6FF3
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 15:59:02 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id g73-20020a9d12cf000000b006943a7df072so3840091otg.11
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 15:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678492741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgU7O+JWkqfQwYoFzDQvPs9F0sf+Tn/hIwPPty7VN1c=;
        b=GJ1UHlFeSHEfYRW6RIlHlFf6qWPI4LpmckLrvJDWEgakwnrDOOe5OPhVNd4PMyX4yK
         HzseS4qMd9PA2Qi5yoxgUBN/wdc35CsNsDM0+JcQ2dntcBYs8VUxjYkerdy874ncTMkY
         9Cz07zT9AZoPckU7P0P+Elw1uDsKKRmLA0811HhzHifBH+kbhkZk54Mg0XSMUjsQHOgl
         94xIOW7lCSWuJXGZDUclQzOl9qwZwembIu3et8QyrDue1nBivsUpv21zSFBBXOuuxRjD
         fD2Qx892lSy2SjDj9qh7VBcH4hMztFy2rbmF+mqEm5hyNg94IfSYiKQ1mf6LDTRlTZgG
         rJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678492741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pgU7O+JWkqfQwYoFzDQvPs9F0sf+Tn/hIwPPty7VN1c=;
        b=7RTcd/QUMoIaDUIyxe6BwIDYhkApb5Eqxy90e72ETj0IXla42rmnA6PDxamz1WZz7G
         7UI+tqNnuG5El9VSMUGTKWszFovgpyH95z9HEa/oBLxP1U1T7QzSYMajfWBztSO2Zs7c
         mj2erhQerBOg+CMYW60H0CyMPrdnAq7r8nmTUYg/L88jlUCrSRkky69hwGOaNpUXSUoU
         PWVFIkNrAh3Ql1hANs/6c3ByEKLICosxsrNAQ7A45uDxfLZQ3bjAsH1gwaFz8j4vzyzu
         QE28qtgX0a7bH2i6OVxz5y59cQQu40Cksqr9rFjhYUqKOwm+YPxmInq+FuIQtimxirdN
         u+4A==
X-Gm-Message-State: AO0yUKWonKrGTX3QlcLzHilFNbVaaaAI7cN0WLehBCNlwVx3D8ubGA7w
        8TlW2EGaQImJFDWyXtTK0qXCAiVQemK8kV1tQHkOMw==
X-Google-Smtp-Source: AK7set/2BG2C1n3xweDsPR+qqFSaTU4z/IJhn1IdadFN9XfO2dBasUFE7pugWGCToX4Cu14dGS2fjRqxzc/G9Xe1XDY=
X-Received: by 2002:a05:6830:40b0:b0:694:3ac6:712 with SMTP id
 x48-20020a05683040b000b006943ac60712mr8828864ott.6.1678492741136; Fri, 10 Mar
 2023 15:59:01 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-13-rananta@google.com>
 <CAAeT=Fyy-3fsN3aWRtX9AoBoHVXyWmY+TJAOuty3Tz=kH5HmJA@mail.gmail.com>
In-Reply-To: <CAAeT=Fyy-3fsN3aWRtX9AoBoHVXyWmY+TJAOuty3Tz=kH5HmJA@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 10 Mar 2023 15:58:49 -0800
Message-ID: <CAJHc60xMyywVJzbg7sUR6kyQJL81rLDiwkFsWGJfMbNJyQ6jzg@mail.gmail.com>
Subject: Re: [REPOST PATCH 12/16] selftests: KVM: aarch64: Test PMU
 overflow/IRQ functionality
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

Hi Reiji,

On Mon, Mar 6, 2023 at 10:10=E2=80=AFPM Reiji Watanabe <reijiw@google.com> =
wrote:
>
> Hi Raghu,
>
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Extend the vCPU migration test to also validate the vPMU's
> > functionality when set up for overflow conditions.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vpmu_test.c | 223 ++++++++++++++++--
> >  1 file changed, 198 insertions(+), 25 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/te=
sting/selftests/kvm/aarch64/vpmu_test.c
> > index 0c9d801f4e602..066dc17fa3906 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > @@ -21,7 +21,9 @@
> >   *
> >   * 4. Since the PMU registers are per-cpu, stress KVM by frequently
> >   * migrating the guest vCPU to random pCPUs in the system, and check
> > - * if the vPMU is still behaving as expected.
> > + * if the vPMU is still behaving as expected. The sub-tests include
> > + * testing basic functionalities such as basic counters behavior,
> > + * overflow, and overflow interrupts.
> >   *
> >   * Copyright (c) 2022 Google LLC.
> >   *
> > @@ -41,13 +43,27 @@
> >  #include <sys/sysinfo.h>
> >
> >  #include "delay.h"
> > +#include "gic.h"
> > +#include "spinlock.h"
> >
> >  /* The max number of the PMU event counters (excluding the cycle count=
er) */
> >  #define ARMV8_PMU_MAX_GENERAL_COUNTERS (ARMV8_PMU_MAX_COUNTERS - 1)
> >
> > +/* The cycle counter bit position that's common among the PMU register=
s */
> > +#define ARMV8_PMU_CYCLE_COUNTER_IDX    31
> > +
> >  /* The max number of event numbers that's supported */
> >  #define ARMV8_PMU_MAX_EVENTS           64
> >
> > +#define PMU_IRQ                                23
> > +
> > +#define COUNT_TO_OVERFLOW      0xFULL
> > +#define PRE_OVERFLOW_32                (GENMASK(31, 0) - COUNT_TO_OVER=
FLOW + 1)
> > +#define PRE_OVERFLOW_64                (GENMASK(63, 0) - COUNT_TO_OVER=
FLOW + 1)
> > +
> > +#define GICD_BASE_GPA  0x8000000ULL
> > +#define GICR_BASE_GPA  0x80A0000ULL
> > +
> >  #define msecs_to_usecs(msec)           ((msec) * 1000LL)
> >
> >  /*
> > @@ -162,6 +178,17 @@ static inline void write_sel_evtyper(int sel, unsi=
gned long val)
> >         isb();
> >  }
> >
> > +static inline void write_pmovsclr(unsigned long val)
> > +{
> > +       write_sysreg(val, pmovsclr_el0);
> > +       isb();
> > +}
> > +
> > +static unsigned long read_pmovsclr(void)
> > +{
> > +       return read_sysreg(pmovsclr_el0);
> > +}
> > +
> >  static inline void enable_counter(int idx)
> >  {
> >         uint64_t v =3D read_sysreg(pmcntenset_el0);
> > @@ -178,11 +205,33 @@ static inline void disable_counter(int idx)
> >         isb();
> >  }
> >
> > +static inline void enable_irq(int idx)
> > +{
> > +       uint64_t v =3D read_sysreg(pmcntenset_el0);
> > +
> > +       write_sysreg(BIT(idx) | v, pmintenset_el1);
> > +       isb();
> > +}
> > +
> > +static inline void disable_irq(int idx)
> > +{
> > +       uint64_t v =3D read_sysreg(pmcntenset_el0);
> > +
> > +       write_sysreg(BIT(idx) | v, pmintenclr_el1);
> > +       isb();
> > +}
> > +
> >  static inline uint64_t read_cycle_counter(void)
> >  {
> >         return read_sysreg(pmccntr_el0);
> >  }
> >
> > +static inline void write_cycle_counter(uint64_t v)
> > +{
> > +       write_sysreg(v, pmccntr_el0);
> > +       isb();
> > +}
> > +
> >  static inline void reset_cycle_counter(void)
> >  {
> >         uint64_t v =3D read_sysreg(pmcr_el0);
> > @@ -289,6 +338,15 @@ struct guest_data {
> >
> >  static struct guest_data guest_data;
> >
> > +/* Data to communicate among guest threads */
> > +struct guest_irq_data {
> > +       uint32_t pmc_idx_bmap;
> > +       uint32_t irq_received_bmap;
> > +       struct spinlock lock;
> > +};
> > +
> > +static struct guest_irq_data guest_irq_data;
> > +
> >  #define VCPU_MIGRATIONS_TEST_ITERS_DEF         1000
> >  #define VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS 2
> >
> > @@ -322,6 +380,79 @@ static void guest_sync_handler(struct ex_regs *reg=
s)
> >         expected_ec =3D INVALID_EC;
> >  }
> >
> > +static void guest_validate_irq(int pmc_idx, uint32_t pmovsclr, uint32_=
t pmc_idx_bmap)
>
> Can you please add a comment about what is pmc_idx_bmap ?
>
Of course! Now that I see, it's not that clear. It's actually the
bitmap of the PMC(s) that we should expect an interrupt from. I'll a
comment in v2.
>
> > +{
> > +       /*
> > +        * Fail if there's an interrupt from unexpected PMCs.
> > +        * All the expected events' IRQs may not arrive at the same tim=
e.
> > +        * Hence, check if the interrupt is valid only if it's expected=
.
> > +        */
> > +       if (pmovsclr & BIT(pmc_idx)) {
> > +               GUEST_ASSERT_3(pmc_idx_bmap & BIT(pmc_idx), pmc_idx, pm=
ovsclr, pmc_idx_bmap);
> > +               write_pmovsclr(BIT(pmc_idx));
> > +       }
> > +}
> > +
> > +static void guest_irq_handler(struct ex_regs *regs)
> > +{
> > +       uint32_t pmc_idx_bmap;
> > +       uint64_t i, pmcr_n =3D get_pmcr_n();
> > +       uint32_t pmovsclr =3D read_pmovsclr();
> > +       unsigned int intid =3D gic_get_and_ack_irq();
> > +
> > +       /* No other IRQ apart from the PMU IRQ is expected */
> > +       GUEST_ASSERT_1(intid =3D=3D PMU_IRQ, intid);
> > +
> > +       spin_lock(&guest_irq_data.lock);
>
> Could you explain why this lock is required in this patch ??
> If this is used to serialize the interrupt context code and
> the normal (non-interrupt) context code, you might want to
> disable the IRQ ?  Using the spin lock won't work well for
> that if the interrupt handler is invoked while the normal
> context code grabs the lock.
> Having said that, since execute_precise_instrs() disables the PMU
>  via PMCR, and does isb after that, I don't think the overflow
> interrupt is delivered while the normal context code is in
> pmu_irq_*() anyway.
>
I think you are right. At least in the current state of the patch, we
don't need this lock, nor do we explicitly have to enable/disable IRQs
to deal with a race. I've checked further patches as well, and even in
the case of multi-vCPU config, we wouldn't need it as the
guest_irq_data is per-cpu.
(Probably I introduced it by forward-thinking things). Thanks for
catching this. I'll remove it in v2.

> > +       pmc_idx_bmap =3D READ_ONCE(guest_irq_data.pmc_idx_bmap);
> > +
> > +       for (i =3D 0; i < pmcr_n; i++)
> > +               guest_validate_irq(i, pmovsclr, pmc_idx_bmap);
> > +       guest_validate_irq(ARMV8_PMU_CYCLE_COUNTER_IDX, pmovsclr, pmc_i=
dx_bmap);
> > +
> > +       /* Mark IRQ as recived for the corresponding PMCs */
> > +       WRITE_ONCE(guest_irq_data.irq_received_bmap, pmovsclr);
> > +       spin_unlock(&guest_irq_data.lock);
> > +
> > +       gic_set_eoi(intid);
> > +}
> > +
> > +static int pmu_irq_received(int pmc_idx)
> > +{
> > +       bool irq_received;
> > +
> > +       spin_lock(&guest_irq_data.lock);
> > +       irq_received =3D READ_ONCE(guest_irq_data.irq_received_bmap) & =
BIT(pmc_idx);
> > +       WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc=
_idx_bmap & ~BIT(pmc_idx));
> > +       spin_unlock(&guest_irq_data.lock);
> > +
> > +       return irq_received;
> > +}
> > +
> > +static void pmu_irq_init(int pmc_idx)
> > +{
> > +       write_pmovsclr(BIT(pmc_idx));
> > +
> > +       spin_lock(&guest_irq_data.lock);
> > +       WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc=
_idx_bmap & ~BIT(pmc_idx));
> > +       WRITE_ONCE(guest_irq_data.pmc_idx_bmap, guest_irq_data.pmc_idx_=
bmap | BIT(pmc_idx));
> > +       spin_unlock(&guest_irq_data.lock);
> > +
> > +       enable_irq(pmc_idx);
> > +}
> > +
> > +static void pmu_irq_exit(int pmc_idx)
> > +{
> > +       write_pmovsclr(BIT(pmc_idx));
> > +
> > +       spin_lock(&guest_irq_data.lock);
> > +       WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc=
_idx_bmap & ~BIT(pmc_idx));
> > +       WRITE_ONCE(guest_irq_data.pmc_idx_bmap, guest_irq_data.pmc_idx_=
bmap & ~BIT(pmc_idx));
> > +       spin_unlock(&guest_irq_data.lock);
> > +
> > +       disable_irq(pmc_idx);
> > +}
> > +
> >  /*
> >   * Run the given operation that should trigger an exception with the
> >   * given exception class. The exception handler (guest_sync_handler)
> > @@ -420,12 +551,20 @@ static void execute_precise_instrs(int num, uint3=
2_t pmcr)
> >         precise_instrs_loop(loop, pmcr);
> >  }
> >
> > -static void test_instructions_count(int pmc_idx, bool expect_count)
> > +static void test_instructions_count(int pmc_idx, bool expect_count, bo=
ol test_overflow)
> >  {
> >         int i;
> >         struct pmc_accessor *acc;
> > -       uint64_t cnt;
> > -       int instrs_count =3D 100;
> > +       uint64_t cntr_val =3D 0;
> > +       int instrs_count =3D 500;
>
> Can we set instrs_count based on the value we set for cntr_val?
> (so that instrs_count can be adjusted automatically when we change the
> value of cntr_val ?)
>
Sure, I can do that to keep things safe.

> > +
> > +       if (test_overflow) {
> > +               /* Overflow scenarios can only be tested when a count i=
s expected */
> > +               GUEST_ASSERT_1(expect_count, pmc_idx);
> > +
> > +               cntr_val =3D PRE_OVERFLOW_32;
> > +               pmu_irq_init(pmc_idx);
> > +       }
> >
> >         enable_counter(pmc_idx);
> >
> > @@ -433,41 +572,68 @@ static void test_instructions_count(int pmc_idx, =
bool expect_count)
> >         for (i =3D 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> >                 acc =3D &pmc_accessors[i];
> >
> > -               pmu_disable_reset();
> > -
> > +               acc->write_cntr(pmc_idx, cntr_val);
> >                 acc->write_typer(pmc_idx, ARMV8_PMUV3_PERFCTR_INST_RETI=
RED);
> >
> > -               /* Enable the PMU and execute precisely number of instr=
uctions as a workload */
> > -               execute_precise_instrs(instrs_count, read_sysreg(pmcr_e=
l0) | ARMV8_PMU_PMCR_E);
> > +               /*
> > +                * Enable the PMU and execute a precise number of instr=
uctions as a workload.
> > +                * Since execute_precise_instrs() disables the PMU at t=
he end, 'instrs_count'
> > +                * should have enough instructions to raise an IRQ.
> > +                */
> > +               execute_precise_instrs(instrs_count, ARMV8_PMU_PMCR_E);
> >
> > -               /* If a count is expected, the counter should be increa=
sed by 'instrs_count' */
> > -               cnt =3D acc->read_cntr(pmc_idx);
> > -               GUEST_ASSERT_4(expect_count =3D=3D (cnt =3D=3D instrs_c=
ount),
> > -                               i, expect_count, cnt, instrs_count);
> > +               /*
> > +                * If an overflow is expected, only check for the overf=
lag flag.
> > +                * As overflow interrupt is enabled, the interrupt woul=
d add additional
> > +                * instructions and mess up the precise instruction cou=
nt. Hence, measure
> > +                * the instructions count only when the test is not set=
 up for an overflow.
> > +                */
> > +               if (test_overflow) {
> > +                       GUEST_ASSERT_2(pmu_irq_received(pmc_idx), pmc_i=
dx, i);
> > +               } else {
> > +                       uint64_t cnt =3D acc->read_cntr(pmc_idx);
> > +
> > +                       GUEST_ASSERT_4(expect_count =3D=3D (cnt =3D=3D =
instrs_count),
> > +                                       pmc_idx, i, cnt, expect_count);
> > +               }
> >         }
> >
> > -       disable_counter(pmc_idx);
> > +       if (test_overflow)
> > +               pmu_irq_exit(pmc_idx);
> >  }
> >
> > -static void test_cycles_count(bool expect_count)
> > +static void test_cycles_count(bool expect_count, bool test_overflow)
> >  {
> >         uint64_t cnt;
> >
> > -       pmu_enable();
> > -       reset_cycle_counter();
> > +       if (test_overflow) {
> > +               /* Overflow scenarios can only be tested when a count i=
s expected */
> > +               GUEST_ASSERT(expect_count);
> > +
> > +               write_cycle_counter(PRE_OVERFLOW_64);
> > +               pmu_irq_init(ARMV8_PMU_CYCLE_COUNTER_IDX);
> > +       } else {
> > +               reset_cycle_counter();
> > +       }
> >
> >         /* Count cycles in EL0 and EL1 */
> >         write_pmccfiltr(0);
> >         enable_cycle_counter();
> >
> > +       /* Enable the PMU and execute precisely number of instructions =
as a workload */
>
> Can you please add a comment why we do this (500 times) iterations ?
> Can we set the iteration number based on the initial value of the
> cycle counter ?
>
I believe I have a comment explaining it in the upcoming patches.
Should've had it on this
one though. I'll move it in v2.

> > +       execute_precise_instrs(500, read_sysreg(pmcr_el0) | ARMV8_PMU_P=
MCR_E);
> >         cnt =3D read_cycle_counter();
>   >
> >         /*
> >          * If a count is expected by the test, the cycle counter should=
 be increased by
> > -        * at least 1, as there is at least one instruction between ena=
bling the
> > +        * at least 1, as there are a number of instructions between en=
abling the
> >          * counter and reading the counter.
> >          */
>
> "at least 1" doesn't seem to be consistent with the GUEST_ASSERT_2 below
> when test_overflow is true, considering the initial value of the cycle co=
unter.
> Shouldn't this GUEST_ASSERT_2 be executed only if test_overflow is false =
?
> (Or do you want to adjust the comment ?)
>
Yes, I may have to tweak the comment to make things clear.

> >         GUEST_ASSERT_2(expect_count =3D=3D (cnt > 0), cnt, expect_count=
);
> > +       if (test_overflow) {
> > +               GUEST_ASSERT_2(pmu_irq_received(ARMV8_PMU_CYCLE_COUNTER=
_IDX), cnt, expect_count);
> > +               pmu_irq_exit(ARMV8_PMU_CYCLE_COUNTER_IDX);
> > +       }
> >
> >         disable_cycle_counter();
> >         pmu_disable_reset();
> > @@ -477,19 +643,28 @@ static void test_event_count(uint64_t event, int =
pmc_idx, bool expect_count)
> >  {
> >         switch (event) {
> >         case ARMV8_PMUV3_PERFCTR_INST_RETIRED:
> > -               test_instructions_count(pmc_idx, expect_count);
> > +               test_instructions_count(pmc_idx, expect_count, false);
> >                 break;
> >         case ARMV8_PMUV3_PERFCTR_CPU_CYCLES:
> > -               test_cycles_count(expect_count);
> > +               test_cycles_count(expect_count, false);
> >                 break;
> >         }
> >  }
> >
> >  static void test_basic_pmu_functionality(void)
> >  {
> > +       local_irq_disable();
> > +       gic_init(GIC_V3, 1, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GP=
A);
> > +       gic_irq_enable(PMU_IRQ);
> > +       local_irq_enable();
> > +
> >         /* Test events on generic and cycle counters */
> > -       test_instructions_count(0, true);
> > -       test_cycles_count(true);
> > +       test_instructions_count(0, true, false);
> > +       test_cycles_count(true, false);
> > +
> > +       /* Test overflow with interrupts on generic and cycle counters =
*/
> > +       test_instructions_count(0, true, true);
> > +       test_cycles_count(true, true);
> >  }
> >
> >  /*
> > @@ -813,9 +988,6 @@ static void guest_code(void)
> >         GUEST_DONE();
> >  }
> >
> > -#define GICD_BASE_GPA  0x8000000ULL
> > -#define GICR_BASE_GPA  0x80A0000ULL
> > -
> >  static unsigned long *
> >  set_event_filters(struct kvm_vcpu *vcpu, struct kvm_pmu_event_filter *=
pmu_event_filters)
> >  {
> > @@ -866,7 +1038,7 @@ create_vpmu_vm(void *guest_code, struct kvm_pmu_ev=
ent_filter *pmu_event_filters)
> >         struct kvm_vcpu *vcpu;
> >         struct kvm_vcpu_init init;
> >         uint8_t pmuver, ec;
> > -       uint64_t dfr0, irq =3D 23;
> > +       uint64_t dfr0, irq =3D PMU_IRQ;
> >         struct vpmu_vm *vpmu_vm;
> >         struct kvm_device_attr irq_attr =3D {
> >                 .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> > @@ -883,6 +1055,7 @@ create_vpmu_vm(void *guest_code, struct kvm_pmu_ev=
ent_filter *pmu_event_filters)
> >
> >         vpmu_vm->vm =3D vm =3D vm_create(1);
> >         vm_init_descriptor_tables(vm);
> > +       vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_=
handler);
> >
> >         /* Catch exceptions for easier debugging */
> >         for (ec =3D 0; ec < ESR_EC_NUM; ec++) {
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >
>
> Thanks,
> Reiji
>
