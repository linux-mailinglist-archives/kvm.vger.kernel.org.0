Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED9968BC12
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 12:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBFLvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 06:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjBFLvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 06:51:01 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8829ED2
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 03:51:00 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id ba1so6036686wrb.5
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 03:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J+0TXtPqnhTCHG5tLP0V+UKCmicCtT1byKpeIgk+wJs=;
        b=U+n4+hwgjFGv5eLWPnRS4ScUnBmN9S+Zn+3x55kWpORsAsEBktPiGn0ABD6+v7yhoE
         34ZR2ZF0qJcBBxrnKAxSjMv8q5jlmVZzCtoCH3mQJ/CPU8NnhC+whiqCimyzwgKyD7/H
         L3zUwVcVFmhgMlJ/igk1Ss96K11g7Zp1yMbwPYWRmF02SDF709i8uNkMcbTBZY9PdmFq
         Et2jsPa3nGRGCjsA6hzt/haUBga2yNXD0GhTwpgx7OxPaRhYWcVPNT5j9g55oNkNNZ5C
         CBtOiElEV5OZwPssovWgqUT4x4OxVKtMWm25jmMj0TUapdj2V0JC8u0bPdKT+nb+t4W7
         SvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+0TXtPqnhTCHG5tLP0V+UKCmicCtT1byKpeIgk+wJs=;
        b=p7U5w95vTdzOD0wt3z5/6cHgOztQ/3HMAkvN5RwJedRZrmLYvycQmUqeGJsCcQMJGT
         gyomZ0Tk+GzwcvgksKyJ/LX+MprUQw/o2qOiGvzBmKxuejrV872pLTpgDudTO/qekEpB
         RPuI2dSWAZuiPH8TUOvkFK7h+wDvogM6t8OA0jx9M5Ay4iPjQH0462x+Cc9ulEJ0BMK9
         mSSYiy5L3EJwwXrQTRlWIVsmV3EdZIwYHKz3e7+4pviZd2O6MTXk6s8l/8StpgECS2ya
         mz52FXSm2ndfCv+Zpy4DsPEkHEhImM/kNk5R5Pd/Xo8b5ICI/YSkau5JVp1ZaiiZNTKz
         FwQA==
X-Gm-Message-State: AO0yUKWHO8vFttYrVTNJsKKvHWV3pRWWj6qLkvIpEHuT0ePNFFBInymU
        5fpHg8KrOkR7sR1XMYLJVET2Lw==
X-Google-Smtp-Source: AK7set/Mj4P7MptErA0D7w2ixA+AYLqVQICv/N0G3LI2IUjJqSpH7eWx/c4TzCu5tGp00fsZrP8m6g==
X-Received: by 2002:a5d:5c13:0:b0:2bf:f027:3c30 with SMTP id cc19-20020a5d5c13000000b002bff0273c30mr18141110wrb.56.1675684258803;
        Mon, 06 Feb 2023 03:50:58 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id e2-20020a5d5002000000b002c3be6ae0b1sm8636933wrt.65.2023.02.06.03.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 03:50:58 -0800 (PST)
Date:   Mon, 6 Feb 2023 12:50:57 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 08/14] RISC-V: KVM: Add SBI PMU extension support
Message-ID: <20230206115057.n37ea5rbqp44dkjo@orel>
References: <20230205011515.1284674-1-atishp@rivosinc.com>
 <20230205011515.1284674-9-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205011515.1284674-9-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 04, 2023 at 05:15:09PM -0800, Atish Patra wrote:
> SBI PMU extension allows KVM guests to configure/start/stop/query about
> the PMU counters in virtualized enviornment as well.
> 
> In order to allow that, KVM implements the entire SBI PMU extension.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/Makefile       |  2 +-
>  arch/riscv/kvm/vcpu_sbi.c     | 11 +++++
>  arch/riscv/kvm/vcpu_sbi_pmu.c | 87 +++++++++++++++++++++++++++++++++++
>  3 files changed, 99 insertions(+), 1 deletion(-)
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
> index fe2897e..15fde15 100644
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
> +	.extid_start = -1UL,
> +	.extid_end = -1UL,
> +	.handler = NULL,
> +};
> +#endif
> +
>  static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>  	&vcpu_sbi_ext_v01,
>  	&vcpu_sbi_ext_base,
> @@ -28,6 +38,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>  	&vcpu_sbi_ext_rfence,
>  	&vcpu_sbi_ext_srst,
>  	&vcpu_sbi_ext_hsm,
> +	&vcpu_sbi_ext_pmu,
>  	&vcpu_sbi_ext_experimental,
>  	&vcpu_sbi_ext_vendor,
>  };
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> new file mode 100644
> index 0000000..9fdc1e1
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -0,0 +1,87 @@
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
> +				   struct kvm_vcpu_sbi_return *retdata)
> +{
> +	int ret = 0;
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	unsigned long funcid = cp->a6;
> +	u64 temp;
> +
> +	/* Return not supported if PMU is not initialized */

This comment isn't necessary, it's just stating what the code
clearly states.

> +	if (!kvpmu->init_done) {
> +		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
> +		return 0;
> +	}
> +
> +	switch (funcid) {
> +	case SBI_EXT_PMU_NUM_COUNTERS:
> +		ret = kvm_riscv_vcpu_pmu_num_ctrs(vcpu, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_GET_INFO:
> +		ret = kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_CFG_MATCH:
> +#if defined(CONFIG_32BIT)
> +		temp = ((uint64_t)cp->a5 << 32) | cp->a4;
> +#else
> +		temp = cp->a4;
> +#endif
> +		/*
> +		 * This can fail if perf core framework fails to create an event.
> +		 * Forward the error to userspace because it's an error happened
                                                                       ^ which

> +		 * within the host kernel. The other option would be to convert
> +		 * this an SBI error and forward to the guest.
                       ^ to

> +		 */
> +		ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
> +						       cp->a2, cp->a3, temp, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_START:
> +#if defined(CONFIG_32BIT)
> +		temp = ((uint64_t)cp->a4 << 32) | cp->a3;
> +#else
> +		temp = cp->a3;
> +#endif
> +		ret = kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->a1, cp->a2,
> +						   temp, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_STOP:
> +		ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, retdata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_FW_READ:
> +		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
> +		break;
> +	default:
> +		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
> +	}
> +
> +	return ret;
> +}
> +
> +static unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +	return kvpmu->init_done;
> +}
> +
> +const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
> +	.extid_start = SBI_EXT_PMU,
> +	.extid_end = SBI_EXT_PMU,
> +	.handler = kvm_sbi_ext_pmu_handler,
> +	.probe = kvm_sbi_ext_pmu_probe,
> +};
> -- 
> 2.25.1
>

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
