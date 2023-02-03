Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50432689322
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 10:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjBCJIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 04:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjBCJIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 04:08:13 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F42C16337
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 01:08:09 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id cr11so3096105pfb.1
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 01:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9hCe7LqUEWeZE/OgEJQeEjnmtgN7ZemsL4+QPvUKJRA=;
        b=ZVk2+2xbB/aWLNr1Loefu3Gdj0GZtzpwTjvssVNCNrunuPoQa7dz8DDdqDBayaVt+k
         R9MJRxlZHIqZ0qeIn5Oe1ukgP2r7CGePcV0Ah8AiMKZyJkhi+JKiMYd4UCuou/X7G7Hk
         4T2ynDCL/jG3XpgRQl1hFn6BDXrVnK3SthMH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9hCe7LqUEWeZE/OgEJQeEjnmtgN7ZemsL4+QPvUKJRA=;
        b=CpcA8EYs9TCgBRbSoqyTSmcoMa/Df5jnL6f4BGMIRxXtV1MLzZTTy6NKXagfcZlGr7
         3HMN8Ag3AU8cwpeWhq4aKfm71xSZ2CTFJHFcHd2Drsv4VM5NTsmhwyuPXxssLsOHJXM+
         mvVtcnxsZc0PiYdPwNPCJ5KrPnxEMqseFjWDdbL2gVLJTZqb+wOly0Uk3AI5PFT7jbqn
         HqxVM6230ijb/JM4VRIGPAtSzSY6yWMz9vKxaBGj03X/fnINWvWxJWGzm3W5qSaBrp5z
         OTBTgGvzpKACbYmI0z6TxZGhGK3ooinA/zTBccmSDpeRMXNHCio4UQeeqsWurPbJ5M79
         /XfQ==
X-Gm-Message-State: AO0yUKVDYBttU7UJbxbcQPTHIqMUW6Ogbxn9xzIIQgihkbqSVsOATBqo
        VRjZ1oMPDxx8egD9DOg7iEJGyKyp8a/2AILmgsF/
X-Google-Smtp-Source: AK7set90iUP5jpoPJ7/sawh5zPeMwXJYzaJvdAZOfpucQSoA1rTYqBgi6FrdrY0Djllor8Pb7T2IOa6zbXKF74fq1I0=
X-Received: by 2002:a63:1941:0:b0:483:f80c:cdf3 with SMTP id
 1-20020a631941000000b00483f80ccdf3mr1660477pgz.70.1675415288579; Fri, 03 Feb
 2023 01:08:08 -0800 (PST)
MIME-Version: 1.0
References: <20230201231250.3806412-1-atishp@rivosinc.com> <20230201231250.3806412-9-atishp@rivosinc.com>
 <20230202172927.jlwjkv6nbvhzcakw@orel>
In-Reply-To: <20230202172927.jlwjkv6nbvhzcakw@orel>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Fri, 3 Feb 2023 01:07:57 -0800
Message-ID: <CAOnJCULStHjnFX70QjVemdt4fqr5HKBiNFaf89nabF19E_kYZw@mail.gmail.com>
Subject: Re: [PATCH v4 08/14] RISC-V: KVM: Add SBI PMU extension support
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Atish Patra <atishp@rivosinc.com>, linux-kernel@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 2, 2023 at 9:29 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Wed, Feb 01, 2023 at 03:12:44PM -0800, Atish Patra wrote:
> > SBI PMU extension allows KVM guests to configure/start/stop/query about
> > the PMU counters in virtualized enviornment as well.
> >
> > In order to allow that, KVM implements the entire SBI PMU extension.
> >
> > Reviewed-by: Anup Patel <anup@brainfault.org>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/kvm/Makefile       |  2 +-
> >  arch/riscv/kvm/vcpu_sbi.c     | 11 +++++
> >  arch/riscv/kvm/vcpu_sbi_pmu.c | 85 +++++++++++++++++++++++++++++++++++
> >  3 files changed, 97 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
> >
> > diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> > index 5de1053..278e97c 100644
> > --- a/arch/riscv/kvm/Makefile
> > +++ b/arch/riscv/kvm/Makefile
> > @@ -25,4 +25,4 @@ kvm-y += vcpu_sbi_base.o
> >  kvm-y += vcpu_sbi_replace.o
> >  kvm-y += vcpu_sbi_hsm.o
> >  kvm-y += vcpu_timer.o
> > -kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
> > +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o vcpu_sbi_pmu.o
> > diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> > index fe2897e..15fde15 100644
> > --- a/arch/riscv/kvm/vcpu_sbi.c
> > +++ b/arch/riscv/kvm/vcpu_sbi.c
> > @@ -20,6 +20,16 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
> >  };
> >  #endif
> >
> > +#ifdef CONFIG_RISCV_PMU_SBI
> > +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> > +#else
> > +static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> > +     .extid_start = -1UL,
> > +     .extid_end = -1UL,
> > +     .handler = NULL,
> > +};
> > +#endif
> > +
> >  static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> >       &vcpu_sbi_ext_v01,
> >       &vcpu_sbi_ext_base,
> > @@ -28,6 +38,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> >       &vcpu_sbi_ext_rfence,
> >       &vcpu_sbi_ext_srst,
> >       &vcpu_sbi_ext_hsm,
> > +     &vcpu_sbi_ext_pmu,
> >       &vcpu_sbi_ext_experimental,
> >       &vcpu_sbi_ext_vendor,
> >  };
> > diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> > new file mode 100644
> > index 0000000..e028b0a
> > --- /dev/null
> > +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> > @@ -0,0 +1,85 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2023 Rivos Inc
> > + *
> > + * Authors:
> > + *     Atish Patra <atishp@rivosinc.com>
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/err.h>
> > +#include <linux/kvm_host.h>
> > +#include <asm/csr.h>
> > +#include <asm/sbi.h>
> > +#include <asm/kvm_vcpu_sbi.h>
> > +
> > +static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > +                                struct kvm_vcpu_sbi_return *retdata)
> > +{
> > +     int ret = 0;
> > +     struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +     unsigned long funcid = cp->a6;
> > +     uint64_t temp;
> > +
> > +     /* Return not supported if PMU is not initialized */
> > +     if (!kvpmu->init_done)
> > +             return -EINVAL;
>
> Shouldn't this be the following?
>
>   if (!kvpmu->init_done)
>      retdata->err_val = SBI_ERR_NOT_SUPPORTED;
>      return 0;
>   }
>

This condition presents an additional sanity check and indicates a bug
in the guest code
where it invokes PMU extension calls when the probe function already
returns NOT_SUPPORTED.

Earlier, I was in two minds whether this should just return not
supported to the guest or report an
error. However, given that it's just a driver in the guest, the error
shouldn't be fatal. It should just
return the sbi error back to the guest.

Thanks for catching this. I have fixed it in v5.

> > +
> > +     switch (funcid) {
> > +     case SBI_EXT_PMU_NUM_COUNTERS:
> > +             ret = kvm_riscv_vcpu_pmu_num_ctrs(vcpu, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_GET_INFO:
> > +             ret = kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_CFG_MATCH:
> > +#if defined(CONFIG_32BIT)
> > +             temp = ((uint64_t)cp->a5 << 32) | cp->a4;
> > +#else
> > +             temp = cp->a4;
> > +#endif
> > +             /*
> > +              * This can fail if perf core framework fails to create an event.
> > +              * Forward the error to the user space because its an error happened
>
> "Forward the error to userspace because it's an error which happened within
>  the host kernel."
>

Fixed.

> > +              * within host kernel. The other option would be convert this to
>                                                                 ^ to
> > +              * an SBI error and forward to the guest.
> > +              */
> > +             ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
> > +                                                    cp->a2, cp->a3, temp, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_START:
> > +#if defined(CONFIG_32BIT)
> > +             temp = ((uint64_t)cp->a4 << 32) | cp->a3;
> > +#else
> > +             temp = cp->a3;
> > +#endif
> > +             ret = kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->a1, cp->a2,
> > +                                                temp, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_STOP:
> > +             ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, retdata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_FW_READ:
> > +             ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
> > +             break;
> > +     default:
> > +             retdata->err_val = SBI_ERR_NOT_SUPPORTED;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +
> > +     return kvpmu->init_done;
> > +}
> > +
> > +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> > +     .extid_start = SBI_EXT_PMU,
> > +     .extid_end = SBI_EXT_PMU,
> > +     .handler = kvm_sbi_ext_pmu_handler,
> > +     .probe = kvm_sbi_ext_pmu_probe,
> > +};
> > --
> > 2.25.1
> >
>
> Thanks,
> drew



-- 
Regards,
Atish
