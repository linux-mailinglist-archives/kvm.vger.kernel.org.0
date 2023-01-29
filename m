Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7329D67FEE7
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 13:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjA2MeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 07:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjA2MeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 07:34:16 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749A322001
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:34:14 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g11so8514008eda.12
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 04:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yC1ZVzAzDf/aBZibreOVSzWXlxaYIBd7WvOisdNT7VA=;
        b=qioVjfNFel+z8e1jsIAR4Xn72T1hGd4nypq3J3AXlahG4IAoERmpJsKfTiv3WNQy7Z
         zFFGaR6KrrVqWUgk+rKp0RMnYXaBgXq0vYc84MvZbatoTYzTPXM3sQv80LJmDF7yYFLI
         i1wl08URz3cjse6mbslWFKmVAv70rWX7YVBBqNJQNnluaMiGzIG8nDFDUG1Op8KaPPU/
         q8tgNLdeB+dgeCH9b+wcxduKrhCjb+ia9noW9SGr2L5Bj3CAMz4T00r/JNTo1kkueluR
         +V6/bHItfKm0TJj7PEWwTK1bL/xtSgpaANpl9UIHzoIMGZmRCbOY9Akk7NVeiQ1MZ3SJ
         EcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yC1ZVzAzDf/aBZibreOVSzWXlxaYIBd7WvOisdNT7VA=;
        b=gJUohv8LtQoH1ytEVZjQ2uo6W8mEXqCruT9m8KXBAU90b0ajtfQefYzObbg8RM3tq3
         0UM1sDl/2vyy0IQKeE0uVgnLygaYSS3/FMkXqh5B32hsjk4DLyrIghNShmRBSoaBlQJr
         qsVChmaWj17biBjMSxPgA5YPNvDPSovLQkZVlLFkZm0wrH0bgvccljLMlwyEgIqR5cKE
         AWnQCPhGFZKF3LZYsZRmuvHIhn4BJcs060oQri5faV+UthH1sVKp9ysja80O1J91r+NH
         Nmk225tBmBUnbpDmuCeyltenSoMo+vCpD9nNzcB1COtVpjN1ue5atvabh7UuFPNJ0EeN
         7V3g==
X-Gm-Message-State: AFqh2kp0uxVPYFPzGMBLJsAkvHILw6yxA9qcUoRtC5cA9Jru9Z8HxLqm
        u/Ki7MEiCl1nPKgv1qjV+WOZ3kGW63ovZweaI7SjZQ==
X-Google-Smtp-Source: AMrXdXumZIj7SGhctuNfaDc2qWvtYehKUwqt8979HMLFD3CVyFWnjV0PLsHmeH1Uj9pYMdi3GForP1iAC/77hwhazLY=
X-Received: by 2002:a05:6402:1008:b0:499:f0f:f788 with SMTP id
 c8-20020a056402100800b004990f0ff788mr8081610edu.25.1674995652901; Sun, 29 Jan
 2023 04:34:12 -0800 (PST)
MIME-Version: 1.0
References: <20230127182558.2416400-1-atishp@rivosinc.com> <20230127182558.2416400-9-atishp@rivosinc.com>
In-Reply-To: <20230127182558.2416400-9-atishp@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sun, 29 Jan 2023 18:04:01 +0530
Message-ID: <CAAhSdy1RK=ambgNYDdKYW-+qVE--Wv8=9vrxLe48u7_DL6gF1w@mail.gmail.com>
Subject: Re: [PATCH v3 08/14] RISC-V: KVM: Add SBI PMU extension support
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:56 PM Atish Patra <atishp@rivosinc.com> wrote:
>
> SBI PMU extension allows KVM guests to configure/start/stop/query about
> the PMU counters in virtualized enviornment as well.
>
> In order to allow that, KVM implements the entire SBI PMU extension.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/Makefile       |  2 +-
>  arch/riscv/kvm/vcpu_sbi.c     | 11 +++++
>  arch/riscv/kvm/vcpu_sbi_pmu.c | 86 +++++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+), 1 deletion(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_pmu.c
>
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 5de1053..278e97c 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -25,4 +25,4 @@ kvm-y += vcpu_sbi_base.o
>  kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_hsm.o
>  kvm-y += vcpu_timer.o
> -kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
> +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o vcpu_sbi_pmu.o
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index aa42da6..04a3b4b 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -20,6 +20,16 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
>  };
>  #endif
>
> +#ifdef CONFIG_RISCV_PMU_SBI
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu;
> +#else
> +static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> +       .extid_start = -1UL,
> +       .extid_end = -1UL,
> +       .handler = NULL,
> +};
> +#endif
> +
>  static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>         &vcpu_sbi_ext_v01,
>         &vcpu_sbi_ext_base,
> @@ -28,6 +38,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>         &vcpu_sbi_ext_rfence,
>         &vcpu_sbi_ext_srst,
>         &vcpu_sbi_ext_hsm,
> +       &vcpu_sbi_ext_pmu,
>         &vcpu_sbi_ext_experimental,
>         &vcpu_sbi_ext_vendor,
>  };
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> new file mode 100644
> index 0000000..73aab30
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -0,0 +1,86 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023 Rivos Inc
> + *
> + * Authors:
> + *     Atish Patra <atishp@rivosinc.com>
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/kvm_host.h>
> +#include <asm/csr.h>
> +#include <asm/sbi.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +
> +static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +                                  struct kvm_vcpu_sbi_ext_data *edata,
> +                                  struct kvm_cpu_trap *utrap)
> +{
> +       int ret = 0;
> +       struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +       unsigned long funcid = cp->a6;
> +       uint64_t temp;
> +
> +       /* Return not supported if PMU is not initialized */
> +       if (!kvpmu->init_done)
> +               return -EINVAL;
> +
> +       switch (funcid) {
> +       case SBI_EXT_PMU_NUM_COUNTERS:
> +               ret = kvm_riscv_vcpu_pmu_num_ctrs(vcpu, edata);
> +               break;
> +       case SBI_EXT_PMU_COUNTER_GET_INFO:
> +               ret = kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, edata);
> +               break;
> +       case SBI_EXT_PMU_COUNTER_CFG_MATCH:
> +#if defined(CONFIG_32BIT)
> +               temp = ((uint64_t)cp->a5 << 32) | cp->a4;
> +#else
> +               temp = cp->a4;
> +#endif
> +               /*
> +                * This can fail if perf core framework fails to create an event.
> +                * Forward the error to the user space because its an error happened
> +                * within host kernel. The other option would be convert this to
> +                * an SBI error and forward to the guest.
> +                */
> +               ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
> +                                                      cp->a2, cp->a3, temp, edata);
> +               break;
> +       case SBI_EXT_PMU_COUNTER_START:
> +#if defined(CONFIG_32BIT)
> +               temp = ((uint64_t)cp->a4 << 32) | cp->a3;
> +#else
> +               temp = cp->a3;
> +#endif
> +               ret = kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->a1, cp->a2,
> +                                                  temp, edata);
> +               break;
> +       case SBI_EXT_PMU_COUNTER_STOP:
> +               ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, edata);
> +               break;
> +       case SBI_EXT_PMU_COUNTER_FW_READ:
> +               ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, edata);
> +               break;
> +       default:
> +               edata->err_val = SBI_ERR_NOT_SUPPORTED;
> +       }
> +
> +       return ret;
> +}
> +
> +unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +       return kvpmu->init_done;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> +       .extid_start = SBI_EXT_PMU,
> +       .extid_end = SBI_EXT_PMU,
> +       .handler = kvm_sbi_ext_pmu_handler,
> +       .probe = kvm_sbi_ext_pmu_probe,
> +};
> --
> 2.25.1
>
