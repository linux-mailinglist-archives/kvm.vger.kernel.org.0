Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8847667E28
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 19:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbjALSbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 13:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjALSah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 13:30:37 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C542077AE2
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:04:17 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id a30so14376063pfr.6
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 10:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TxWhCwPu5LJsqg+vUhYvruNUByCvr504SVJ2EQlA0KA=;
        b=BTjV8oUa7Ed+ZbWoFOVVgaZTO8KHvYB4mpyDw2hp1beDa6ri8H1s9rmAvwqBSB40/8
         Ajwhv1g2NnEBGu5dfQj1Vzt2N0/+s2WXP4HK0KqqY6h9ql/qRJHto+qLngU6H6rSftsG
         WDd5uTEyEwYCLBiGUSXvHMonkKnb9puFNv2rJDbYWl6MKcW2ceFCVkSx610YhbhzllQE
         rGe6sunHorm2UE/e2q2Hc/i7PddOpS1j5fIpIl5a7U/7UrV0QaaqGvXWhTVwViBWgrVY
         rcsF/ZPZ+OsIGBkmBcTViK54nA4NmxM77OM1EeKCLC2g1ahnDA6P+tOY7jSpr68Zb865
         TJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TxWhCwPu5LJsqg+vUhYvruNUByCvr504SVJ2EQlA0KA=;
        b=lWClNjnhZ8P3uepK8Xc+Zl4qWsvmpjT5JYQjO6zhApcrpxYCxnxmHbPbySKqsjYdWP
         +IT324UHjbJLZi5isY/rm4ybJxQ0J90IIaKNs5Ql2WoVMF19kKQF1Xd7sKir2gszLyao
         uonRIyBOd0RhotuTAfrsBHWRNPfZ6tpl5/x1J5RzbGvnD/bLbU9i/lKEsW5m5DwnQFf3
         s3TkqZm/EUXEP3WX5uqmKro9wE5b59fcHuTlipldh3pZ8fWmZfh6L+FNZfPjwRH+c/xj
         qz0UEPNsiil1xgyuK5iCmmxjzSMXnZHH5DSfzfDR03WZjjetsgtvKGJ4LCxA3yP2T/Sb
         2mhA==
X-Gm-Message-State: AFqh2kr4AfD6DlfNuHUdiIA8XaV3PaPMWarO3SWM/7WJ2b9SKUHyfpi2
        FfDmu3DTxjgdVjXuFEpRFZg7fIbFJ47AJdu/P9ldrQ==
X-Google-Smtp-Source: AMrXdXtAuAvBhytBCvvI2YJ8Ey/sxvh2qUIiwV8yvF5Zt0Wm1fFtJCOPhSydBTaBDLjX8Xxn/GyGRvD2CPXD5pTzxs0=
X-Received: by 2002:a63:104f:0:b0:4ac:d14e:2d01 with SMTP id
 15-20020a63104f000000b004acd14e2d01mr1375022pgq.595.1673546657212; Thu, 12
 Jan 2023 10:04:17 -0800 (PST)
MIME-Version: 1.0
References: <20221215170046.2010255-1-atishp@rivosinc.com> <20221215170046.2010255-8-atishp@rivosinc.com>
 <20230112152948.3vagzedhegbj4jbj@orel>
In-Reply-To: <20230112152948.3vagzedhegbj4jbj@orel>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Thu, 12 Jan 2023 10:04:06 -0800
Message-ID: <CAHBxVyGDun+7XxxnRkTgYYKEWdcZ6UM+N52zUFsRsgma8dyHeg@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] RISC-V: KVM: Add SBI PMU extension support
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

On Thu, Jan 12, 2023 at 7:29 AM Andrew Jones <ajones@ventanamicro.com> wrote:
>
> On Thu, Dec 15, 2022 at 09:00:42AM -0800, Atish Patra wrote:
> > SBI PMU extension allows KVM guests to configure/start/stop/query about
> > the PMU counters in virtualized enviornment as well.
> >
> > In order to allow that, KVM implements the entire SBI PMU extension.
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  arch/riscv/kvm/Makefile       |  2 +-
> >  arch/riscv/kvm/vcpu_sbi.c     | 11 +++++
> >  arch/riscv/kvm/vcpu_sbi_pmu.c | 86 +++++++++++++++++++++++++++++++++++
> >  3 files changed, 98 insertions(+), 1 deletion(-)
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
> > index 50c5472..3b8b84e8 100644
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
> > index 0000000..223752f
> > --- /dev/null
> > +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> > @@ -0,0 +1,86 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2022 Rivos Inc
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
> > +                                struct kvm_vcpu_sbi_ext_data *edata,
> > +                                struct kvm_cpu_trap *utrap)
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
> > +
> > +     switch (funcid) {
> > +     case SBI_EXT_PMU_NUM_COUNTERS:
> > +             ret = kvm_riscv_vcpu_pmu_num_ctrs(vcpu, edata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_GET_INFO:
> > +             ret = kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, edata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_CFG_MATCH:
> > +#if defined(CONFIG_32BIT)
> > +             temp = ((uint64_t)cp->a5 << 32) | cp->a4;
> > +#else
> > +             temp = cp->a4;
> > +#endif
> > +             ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
> > +                                                    cp->a2, cp->a3, temp, edata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_START:
> > +#if defined(CONFIG_32BIT)
> > +             temp = ((uint64_t)cp->a4 << 32) | cp->a3;
> > +#else
> > +             temp = cp->a3;
> > +#endif
> > +             ret = kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->a1, cp->a2,
> > +                                                temp, edata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_STOP:
> > +             ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, edata);
> > +             break;
> > +     case SBI_EXT_PMU_COUNTER_FW_READ:
> > +             ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, edata);
> > +             break;
> > +     default:
> > +             edata->err_val = SBI_ERR_NOT_SUPPORTED;
> > +     }
> > +
> > +
> > +     return ret;
> > +}
> > +
> > +unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu, unsigned long extid)
> > +{
> > +     struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> > +
> > +     /*
> > +      * PMU Extension is only available to guests if privilege mode filtering
> > +      * is available. Otherwise, guest will always count events while the
> > +      * execution is in hypervisor mode.
> > +      */
> > +     return kvpmu->init_done && riscv_isa_extension_available(NULL, SSCOFPMF);
>
> Assuming we're only supporting homogeneous systems, then can't we just
> check for Sscofpmf at PMU init time? When the extension isn't present
> we'd fail to init and then here init_done wouldn't be set.
>

Sure. We can do that too. Will revise it v3.

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
