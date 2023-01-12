Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E43A667E56
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 19:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbjALSpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 13:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjALSpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 13:45:00 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED2D20C
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:18:17 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 200so8242461pfx.7
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=imZPqnzDLF2i+5vb28S1oLdL2hZHuB+mTkpveovIShk=;
        b=8VPUwINSyiSI8p+IdNef4gnXqazXTASW8rBSVLlDYvmPraC9doolFMbw3zp/AJjK6m
         Rf7FeuSH8EFiRzhi8a2coSTBWG6ltnJghPB4eoWhm645OGLNdAbbP0i3HCo+H7/+/R+h
         +3QmsyeDcsezIxnvJ/Bux8S2zdsvWQBPmE1Z2/XCBemjEz1NAd1qMe6yF7K4ormQQJwm
         nVWCX4gWlYISWrLoo03A7nPZIkgjtpVyNAZOZJ3PKyvMPuz6/ibPdUHSXJaVI5Mokhdb
         FOFv8/88KlRvqTyZaxBzoOcZ7KQWg6A/RhfCMAXEySD2Num6gP/vrdCa/hkP0F5cLPx5
         +jIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=imZPqnzDLF2i+5vb28S1oLdL2hZHuB+mTkpveovIShk=;
        b=INBDgDcXzO6C0Tt42VPZsCcywTvUzI2W5Hqfy0L18VTdEq6fSV7CPgpFHwgknV2+HL
         FvrsUFP2eaX9rAGRk3tm/UPTX62gZiNcZ7yuiTVhw45oZCyahbnfAO9lvSzhYZYQrAyr
         6nByiBe3rtzCbMn15r+N0PZ6kPOWFgFK51CXG86+jT9yaEm2pKTFPhOOtWItTlGvCd0d
         SO8Krx+sXoSGULFyX4zlQhRILHivvc/QxsbIBrmB5bWixNhtSJTXPk/AFUxVVG/9UlZe
         AaWT2IpwCluZt4SovwXAOMpdDbC7PoWt0gCMG7hmcVmiC1rwEB5shHCVHd+7qHSG+C7V
         9pdA==
X-Gm-Message-State: AFqh2krpsveSmw0HKtQhg1qGjrpTjtHLqQpG+RtIGauwUlTYnZFfAu46
        Gidb0FR0HiUmsJyrougorXa/ntiIjT8hYEHsB8bIfQ==
X-Google-Smtp-Source: AMrXdXs4LmKDqs/bftcofPxFVGYVQUr5DcCTiOz9NFVAYiCNRH8NqmJaD8MgxRimG8MqrplGeje8Ej8e82AA9dGt8Vs=
X-Received: by 2002:a63:d902:0:b0:490:597e:1c0a with SMTP id
 r2-20020a63d902000000b00490597e1c0amr3599808pgg.309.1673547496600; Thu, 12
 Jan 2023 10:18:16 -0800 (PST)
MIME-Version: 1.0
References: <20221215170046.2010255-1-atishp@rivosinc.com> <20221215170046.2010255-2-atishp@rivosinc.com>
 <20230112100608.d7tnvhbotjfctlgk@orel>
In-Reply-To: <20230112100608.d7tnvhbotjfctlgk@orel>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Thu, 12 Jan 2023 10:18:05 -0800
Message-ID: <CAHBxVyESkQ9Krmn-44f-A8hYzMrZBtBfq15fdx-sHDQfkBMtKQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] RISC-V: Define helper functions expose hpm
 counter width and count
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 2:06 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Dec 15, 2022 at 09:00:36AM -0800, Atish Patra wrote:
> > KVM module needs to know how many hardware counters and the counter
> > width that the platform supports. Otherwise, it will not be able to show
> > optimal value of virtual counters to the guest. The virtual hardware
> > counters also need to have the same width as the logical hardware
> > counters for simplicity. However, there shouldn't be mapping between
> > virtual hardware counters and logical hardware counters. As we don't
> > support hetergeneous harts or counters with different width as of now,
> > the implementation relies on the counter width of the first available
> > programmable counter.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  drivers/perf/riscv_pmu_sbi.c   | 35 +++++++++++++++++++++++++++++++++-
> >  include/linux/perf/riscv_pmu.h |  3 +++
> >  2 files changed, 37 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> > index 3852c18..65d4aa4 100644
> > --- a/drivers/perf/riscv_pmu_sbi.c
> > +++ b/drivers/perf/riscv_pmu_sbi.c
> > @@ -49,6 +49,9 @@ static const struct attribute_group *riscv_pmu_attr_groups[] = {
> >  static union sbi_pmu_ctr_info *pmu_ctr_list;
> >  static unsigned int riscv_pmu_irq;
> >
> > +/* Cache the available counters in a bitmask */
> > +unsigned long cmask;
>
> I presume this can be static since it's not getting added to the header.
> And don't we need this to be a long long for rv32? We should probably
> just use u64.
>

Yeah. u64 would be better. I will change it along with static. Thanks.

> > +
> >  struct sbi_pmu_event_data {
> >       union {
> >               union {
> > @@ -264,6 +267,37 @@ static bool pmu_sbi_ctr_is_fw(int cidx)
> >       return (info->type == SBI_PMU_CTR_TYPE_FW) ? true : false;
> >  }
> >
> > +/*
> > + * Returns the counter width of a programmable counter and number of hardware
> > + * counters. As we don't support heterneous CPUs yet, it is okay to just
>
> heterogeneous
>

Fixed.

> > + * return the counter width of the first programmable counter.
> > + */
> > +int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr)
> > +{
> > +     int i;
> > +     union sbi_pmu_ctr_info *info;
> > +     u32 hpm_width = 0, hpm_count = 0;
> > +
> > +     if (!cmask)
> > +             return -EINVAL;
> > +
> > +     for_each_set_bit(i, &cmask, RISCV_MAX_COUNTERS) {
> > +             info = &pmu_ctr_list[i];
> > +             if (!info)
> > +                     continue;
> > +             if (!hpm_width && (info->csr != CSR_CYCLE) && (info->csr != CSR_INSTRET))
>
> nit: No need for () around the != expressions
>

Fixed.

> > +                     hpm_width = info->width;
> > +             if (info->type == SBI_PMU_CTR_TYPE_HW)
> > +                     hpm_count++;
> > +     }
> > +
> > +     *hw_ctr_width = hpm_width;
> > +     *num_hw_ctr = hpm_count;
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL(riscv_pmu_get_hpm_info);
>
> EXPORT_SYMBOL_GPL ?
>

Is that mandatory ? I have seen usage of both in arch/riscv and other
places though.
I am also not sure if any other non-GPL module should/need access to this.

> > +
> >  static int pmu_sbi_ctr_get_idx(struct perf_event *event)
> >  {
> >       struct hw_perf_event *hwc = &event->hw;
> > @@ -798,7 +832,6 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
> >  static int pmu_sbi_device_probe(struct platform_device *pdev)
> >  {
> >       struct riscv_pmu *pmu = NULL;
> > -     unsigned long cmask = 0;
> >       int ret = -ENODEV;
> >       int num_counters;
> >
> > diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
> > index e17e86a..a1c3f77 100644
> > --- a/include/linux/perf/riscv_pmu.h
> > +++ b/include/linux/perf/riscv_pmu.h
> > @@ -73,6 +73,9 @@ void riscv_pmu_legacy_skip_init(void);
> >  static inline void riscv_pmu_legacy_skip_init(void) {};
> >  #endif
> >  struct riscv_pmu *riscv_pmu_alloc(void);
> > +#ifdef CONFIG_RISCV_PMU_SBI
> > +int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr);
> > +#endif
> >
> >  #endif /* CONFIG_RISCV_PMU */
> >
> > --
> > 2.25.1
> >
>
> Thanks,
> drew
