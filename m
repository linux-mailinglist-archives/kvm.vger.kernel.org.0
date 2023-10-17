Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BA77CCF79
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 23:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344217AbjJQVnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 17:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344196AbjJQVnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 17:43:12 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECBAED
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 14:43:09 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c9c496c114so29245ad.0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 14:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697578989; x=1698183789; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OqEU0VDTQ7eG96oTfFfOGVQk9AB8sJWfy0TKB7/r4uQ=;
        b=PfE5sww66MKWhn5Xn2TQW/EzdPelOZOnBTlPsXk8/5s4UkQk7rIUyFDyb2evVwEHS3
         okYLlWmltBGTlI1y/9ZQMCJP7zIHCzozUPzgpg2pDbUJQUIVrBeGNmwqVYLuLblnhycD
         UkThdii2cNnnEIs8NrdIoyMOF61eKnExagv4YUyP03B2cgqlCcF2Esq4Xlofk04Rvm/6
         HEFzSbRHutZ742EoK/n4QdQ0mkQpnW2S7yOQ+GFGjWXVba4dS4B+POuzxDatNjrjCxzX
         SFdlwWdp4W7JLG+Zy8EPEQDkhl0KPx3JQ8xXVUJC7S7uOhQPD14EXGIN1DU0BlI9+kOl
         5Ubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697578989; x=1698183789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OqEU0VDTQ7eG96oTfFfOGVQk9AB8sJWfy0TKB7/r4uQ=;
        b=H6hNjsw6VdRSrvLXApVIhtEqJOqUA/tcaehEtcI4D4IohmZdhtFdvH6ot/0kpB4Vq3
         hRyJJOS6rvgVGrpJFjT3W8kWoUvUBAl3eL7lcrbvEjq5Y6nIuxnhqjHGrEXsAodXvzDa
         W4ZTr3Q6pSvugoVjweeQusY7zMCSCUVmLGKNIeWEJRqd61HLgzoI7R5uMVoKXhjG1x6L
         wLyofJd4FJqMScjzhJbWP2ij97ERZYN/y+B4Qm7osdjVFHZxyAXl/9hgJIzG85RKIFff
         qgN1CdpEV53W/1o91hL5cuemVZZP3lJp7bpCAA8dGEENhV5LmzvoOZ491xMTw+eNJvcF
         RudA==
X-Gm-Message-State: AOJu0YxWR9ndrrjR6G9DL5dYL0HVdBorhea5cq27ddnHu60md8Da/CGf
        K634Ql5AcQ+fxg+/lBQ51m6QQhGrSm6tRiOK/SjpiA==
X-Google-Smtp-Source: AGHT+IG+vdEaodVTkJl3dJxT7ZYDVzPK2gJXxbgZ7u9uHTCIiANynrZhHJZaZXhXIoywvucN/H2hVv3LyZdjsRDDBQ4=
X-Received: by 2002:a17:902:e5d0:b0:1ca:209c:d7b9 with SMTP id
 u16-20020a170902e5d000b001ca209cd7b9mr99275plf.2.1697578989056; Tue, 17 Oct
 2023 14:43:09 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-12-rananta@google.com>
 <6a83ce25-7e45-5b71-86e4-58e905e490ea@redhat.com>
In-Reply-To: <6a83ce25-7e45-5b71-86e4-58e905e490ea@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 17 Oct 2023 14:42:57 -0700
Message-ID: <CAJHc60yeiVtXe3MdwJ7DK=3+nUeFsoLaRCdbkna1-9dZpiffEQ@mail.gmail.com>
Subject: Re: [PATCH v7 11/12] KVM: selftests: aarch64: vPMU register test for
 implemented counters
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

On Tue, Oct 17, 2023 at 11:54=E2=80=AFAM Eric Auger <eauger@redhat.com> wro=
te:
>
> Hi Raghavendra,
>
> On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Add a new test case to the vpmu_counter_access test to check if PMU
> > registers or their bits for implemented counters on the vCPU are
> > readable/writable as expected, and can be programmed to count events.>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../kvm/aarch64/vpmu_counter_access.c         | 270 +++++++++++++++++-
> >  1 file changed, 268 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c =
b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > index 58949b17d76e..e92af3c0db03 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > @@ -5,7 +5,8 @@
> >   * Copyright (c) 2022 Google LLC.
> >   *
> >   * This test checks if the guest can see the same number of the PMU ev=
ent
> > - * counters (PMCR_EL0.N) that userspace sets.
> > + * counters (PMCR_EL0.N) that userspace sets, and if the guest can acc=
ess
> > + * those counters.
> >   * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the hos=
t.
> >   */
> >  #include <kvm_util.h>
> > @@ -37,6 +38,259 @@ static void set_pmcr_n(uint64_t *pmcr, uint64_t pmc=
r_n)
> >       *pmcr |=3D (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> >  }
> >
> > +/* Read PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
> > +static inline unsigned long read_sel_evcntr(int sel)
> > +{
> > +     write_sysreg(sel, pmselr_el0);
> > +     isb();
> > +     return read_sysreg(pmxevcntr_el0);
> > +}> +
> > +/* Write PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
> > +static inline void write_sel_evcntr(int sel, unsigned long val)
> > +{
> > +     write_sysreg(sel, pmselr_el0);
> > +     isb();
> > +     write_sysreg(val, pmxevcntr_el0);
> > +     isb();
> > +}
> > +
> > +/* Read PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
> > +static inline unsigned long read_sel_evtyper(int sel)
> > +{
> > +     write_sysreg(sel, pmselr_el0);
> > +     isb();
> > +     return read_sysreg(pmxevtyper_el0);
> > +}
> > +
> > +/* Write PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
> > +static inline void write_sel_evtyper(int sel, unsigned long val)
> > +{
> > +     write_sysreg(sel, pmselr_el0);
> > +     isb();
> > +     write_sysreg(val, pmxevtyper_el0);
> > +     isb();
> > +}
> > +
> > +static inline void enable_counter(int idx)
> > +{
> > +     uint64_t v =3D read_sysreg(pmcntenset_el0);
> > +
> > +     write_sysreg(BIT(idx) | v, pmcntenset_el0);
> > +     isb();
> > +}
> > +
> > +static inline void disable_counter(int idx)
> > +{
> > +     uint64_t v =3D read_sysreg(pmcntenset_el0);
> > +
> > +     write_sysreg(BIT(idx) | v, pmcntenclr_el0);
> > +     isb();
> > +}
> > +
> > +static void pmu_disable_reset(void)
> > +{
> > +     uint64_t pmcr =3D read_sysreg(pmcr_el0);
> > +
> > +     /* Reset all counters, disabling them */
> > +     pmcr &=3D ~ARMV8_PMU_PMCR_E;
> > +     write_sysreg(pmcr | ARMV8_PMU_PMCR_P, pmcr_el0);
> > +     isb();
> > +> +
> > +#define RETURN_READ_PMEVCNTRN(n) \
> > +     return read_sysreg(pmevcntr##n##_el0)
> > +static unsigned long read_pmevcntrn(int n)
> > +{
> > +     PMEVN_SWITCH(n, RETURN_READ_PMEVCNTRN);
> > +     return 0;
> > +}
> > +
> > +#define WRITE_PMEVCNTRN(n) \
> > +     write_sysreg(val, pmevcntr##n##_el0)
> > +static void write_pmevcntrn(int n, unsigned long val)
> > +{
> > +     PMEVN_SWITCH(n, WRITE_PMEVCNTRN);
> > +     isb();
> > +}
> > +
> > +#define READ_PMEVTYPERN(n) \
> > +     return read_sysreg(pmevtyper##n##_el0)
> > +static unsigned long read_pmevtypern(int n)
> > +{
> > +     PMEVN_SWITCH(n, READ_PMEVTYPERN);
> > +     return 0;
> > +}
> > +
> > +#define WRITE_PMEVTYPERN(n) \
> > +     write_sysreg(val, pmevtyper##n##_el0)
> > +static void write_pmevtypern(int n, unsigned long val)
> > +{
> > +     PMEVN_SWITCH(n, WRITE_PMEVTYPERN);
> > +     isb();
> > +}
> > +
> > +/*
> > + * The pmc_accessor structure has pointers to PMEVT{CNTR,TYPER}<n>_EL0
> > + * accessors that test cases will use. Each of the accessors will
> > + * either directly reads/writes PMEVT{CNTR,TYPER}<n>_EL0
> > + * (i.e. {read,write}_pmev{cnt,type}rn()), or reads/writes them throug=
h
> > + * PMXEV{CNTR,TYPER}_EL0 (i.e. {read,write}_sel_ev{cnt,type}r()).
> > + *
> > + * This is used to test that combinations of those accessors provide
> > + * the consistent behavior.
> > + */
> > +struct pmc_accessor {
> > +     /* A function to be used to read PMEVTCNTR<n>_EL0 */
> > +     unsigned long   (*read_cntr)(int idx);
> > +     /* A function to be used to write PMEVTCNTR<n>_EL0 */
> > +     void            (*write_cntr)(int idx, unsigned long val);
> > +     /* A function to be used to read PMEVTYPER<n>_EL0 */
> > +     unsigned long   (*read_typer)(int idx);
> > +     /* A function to be used to write PMEVTYPER<n>_EL0 */
> > +     void            (*write_typer)(int idx, unsigned long val);
> > +};
> > +
> > +struct pmc_accessor pmc_accessors[] =3D {
> > +     /* test with all direct accesses */
> > +     { read_pmevcntrn, write_pmevcntrn, read_pmevtypern, write_pmevtyp=
ern },
> > +     /* test with all indirect accesses */
> > +     { read_sel_evcntr, write_sel_evcntr, read_sel_evtyper, write_sel_=
evtyper },
> > +     /* read with direct accesses, and write with indirect accesses */
> > +     { read_pmevcntrn, write_sel_evcntr, read_pmevtypern, write_sel_ev=
typer },
> > +     /* read with indirect accesses, and write with direct accesses */
> > +     { read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevt=
ypern },
> > +};
> what is the rationale behing testing both direct and indirect accesses
> and any combinations? I think this would deserve some
> comments/justification.
Basically, the idea is to test if, with PMCR.N being constantly
updated, we are able to access the registers successfully or not. At
this point it may not fully justify to test all these combinations
(just one direct set and one indirect set should do). However, I do
have some more test patches which add more functional testing of the
vPMU.
I can add some comment about this.
> > +
> > +/*
> > + * Convert a pointer of pmc_accessor to an index in pmc_accessors[],
> > + * assuming that the pointer is one of the entries in pmc_accessors[].
> > + */
> > +#define PMC_ACC_TO_IDX(acc)  (acc - &pmc_accessors[0])
> > +
> > +#define GUEST_ASSERT_BITMAP_REG(regname, mask, set_expected)          =
        \
> > +{                                                                     =
        \
> > +     uint64_t _tval =3D read_sysreg(regname);                         =
          \
> > +                                                                      =
        \
> > +     if (set_expected)                                                =
        \
> > +             __GUEST_ASSERT((_tval & mask),                           =
        \
> > +                             "tval: 0x%lx; mask: 0x%lx; set_expected: =
0x%lx", \
> > +                             _tval, mask, set_expected);              =
        \
> > +     else                                                             =
        \
> > +             __GUEST_ASSERT(!(_tval & mask),                          =
        \
> > +                             "tval: 0x%lx; mask: 0x%lx; set_expected: =
0x%lx", \
> > +                             _tval, mask, set_expected);              =
        \
> > +}
> > +
> > +/*
> > + * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
> > + * are set or cleared as specified in @set_expected.
> > + */
> > +static void check_bitmap_pmu_regs(uint64_t mask, bool set_expected)
> > +{
> > +     GUEST_ASSERT_BITMAP_REG(pmcntenset_el0, mask, set_expected);
> > +     GUEST_ASSERT_BITMAP_REG(pmcntenclr_el0, mask, set_expected);
> > +     GUEST_ASSERT_BITMAP_REG(pmintenset_el1, mask, set_expected);
> > +     GUEST_ASSERT_BITMAP_REG(pmintenclr_el1, mask, set_expected);
> > +     GUEST_ASSERT_BITMAP_REG(pmovsset_el0, mask, set_expected);
> > +     GUEST_ASSERT_BITMAP_REG(pmovsclr_el0, mask, set_expected);
> > +}
> > +
> > +/*
> > + * Check if the bit in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers corr=
esponding
> > + * to the specified counter (@pmc_idx) can be read/written as expected=
.
> > + * When @set_op is true, it tries to set the bit for the counter in
> > + * those registers by writing the SET registers (the bit won't be set
> > + * if the counter is not implemented though).
> > + * Otherwise, it tries to clear the bits in the registers by writing
> > + * the CLR registers.
> > + * Then, it checks if the values indicated in the registers are as exp=
ected.
> > + */
> > +static void test_bitmap_pmu_regs(int pmc_idx, bool set_op)
> > +{
> > +     uint64_t pmcr_n, test_bit =3D BIT(pmc_idx);
> > +     bool set_expected =3D false;
> > +
> > +     if (set_op) {
> > +             write_sysreg(test_bit, pmcntenset_el0);
> > +             write_sysreg(test_bit, pmintenset_el1);
> > +             write_sysreg(test_bit, pmovsset_el0);
> > +
> > +             /* The bit will be set only if the counter is implemented=
 */
> > +             pmcr_n =3D get_pmcr_n(read_sysreg(pmcr_el0));
> > +             set_expected =3D (pmc_idx < pmcr_n) ? true : false;
> > +     } else {
> > +             write_sysreg(test_bit, pmcntenclr_el0);
> > +             write_sysreg(test_bit, pmintenclr_el1);
> > +             write_sysreg(test_bit, pmovsclr_el0);
> > +     }
> > +     check_bitmap_pmu_regs(test_bit, set_expected);
> > +}
> > +
> > +/*
> > + * Tests for reading/writing registers for the (implemented) event cou=
nter
> > + * specified by @pmc_idx.
> > + */
> > +static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx=
)
> > +{
> > +     uint64_t write_data, read_data;
> > +
> > +     /* Disable all PMCs and reset all PMCs to zero. */
> > +     pmu_disable_reset();
> > +
> > +
> nit: double empty line
The double-empty lines were introduced to separate out the test
'phases'. But if it feels too much, I can remove one.
> > +     /*
> > +      * Tests for reading/writing {PMCNTEN,PMINTEN,PMOVS}{SET,CLR}_EL1=
.
> > +      */
> > +
> > +     /* Make sure that the bit in those registers are set to 0 */
> > +     test_bitmap_pmu_regs(pmc_idx, false);
> > +     /* Test if setting the bit in those registers works */
> > +     test_bitmap_pmu_regs(pmc_idx, true);
> > +     /* Test if clearing the bit in those registers works */
> > +     test_bitmap_pmu_regs(pmc_idx, false);
> > +
> > +
> same here
> > +     /*
> > +      * Tests for reading/writing the event type register.
> > +      */
> > +
> > +     read_data =3D acc->read_typer(pmc_idx);
> not needed I think
You are right. It's redundant. I'll remove it.
> > +     /*
> > +      * Set the event type register to an arbitrary value just for tes=
ting
> > +      * of reading/writing the register.
> > +      * ArmARM says that for the event from 0x0000 to 0x003F,
> nit s/ArmARM/Arm ARM
> > +      * the value indicated in the PMEVTYPER<n>_EL0.evtCount field is
> > +      * the value written to the field even when the specified event
> > +      * is not supported.
> > +      */
> > +     write_data =3D (ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMUV3_PERFCTR_INST_=
RETIRED);
> > +     acc->write_typer(pmc_idx, write_data);
> > +     read_data =3D acc->read_typer(pmc_idx);
> > +     __GUEST_ASSERT(read_data =3D=3D write_data,
> > +                    "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx;=
 write_data: 0x%lx",
> > +                    pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_dat=
a);
> > +
> > +
> > +     /*
> > +      * Tests for reading/writing the event count register.
> > +      */
> > +
> > +     read_data =3D acc->read_cntr(pmc_idx);
> > +
> > +     /* The count value must be 0, as it is not used after the reset *=
/
> s/not used/disabled and reset?
> > +     __GUEST_ASSERT(read_data =3D=3D 0,
> > +                    "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx"=
,
> > +                    pmc_idx, PMC_ACC_TO_IDX(acc), read_data);
> > +
> > +     write_data =3D read_data + pmc_idx + 0x12345;
> > +     acc->write_cntr(pmc_idx, write_data);
> > +     read_data =3D acc->read_cntr(pmc_idx);
> > +     __GUEST_ASSERT(read_data =3D=3D write_data,
> > +                    "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx;=
 write_data: 0x%lx",
> > +                    pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_dat=
a);
> > +}
> > +
> >  static void guest_sync_handler(struct ex_regs *regs)
> >  {
> >       uint64_t esr, ec;
> > @@ -49,11 +303,14 @@ static void guest_sync_handler(struct ex_regs *reg=
s)
> >  /*
> >   * The guest is configured with PMUv3 with @expected_pmcr_n number of
> >   * event counters.
> > - * Check if @expected_pmcr_n is consistent with PMCR_EL0.N.
> > + * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
> > + * if reading/writing PMU registers for implemented counters can work
> s/can work/works
> > + * as expected.
> >   */
> >  static void guest_code(uint64_t expected_pmcr_n)
> >  {
> >       uint64_t pmcr, pmcr_n;
> > +     int i, pmc;
> >
> >       __GUEST_ASSERT(expected_pmcr_n <=3D ARMV8_PMU_MAX_GENERAL_COUNTER=
S,
> >                       "Expected PMCR.N: 0x%lx; ARMv8 general counters: =
0x%lx",
> > @@ -67,6 +324,15 @@ static void guest_code(uint64_t expected_pmcr_n)
> >                       "Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
> >                       pmcr_n, expected_pmcr_n);
> >
> > +     /*
> > +      * Tests for reading/writing PMU registers for implemented counte=
rs.
> > +      * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor func=
tions.
> > +      */
> > +     for (i =3D 0; i < ARRAY_SIZE(pmc_accessors); i++) {
> > +             for (pmc =3D 0; pmc < pmcr_n; pmc++)
> > +                     test_access_pmc_regs(&pmc_accessors[i], pmc);
> > +     }
> > +
> >       GUEST_DONE();
> >  }
> >
I'll address all the other nits.

Thank you.
Raghavendra
> Thanks
>
> Eric
>
