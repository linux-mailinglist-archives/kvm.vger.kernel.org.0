Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB024667983
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbjALPjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240527AbjALPih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:38:37 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB543E870
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 07:29:51 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id cf18so39288150ejb.5
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 07:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8/isyiyYelhWoqLBrchcU6kVdh+9vrvHgcSQ4B34VDk=;
        b=EHXEPMdHmrWk+ItDBSbevZ7FKIVT2z/y/V/evYel++jimsmR9bFWMPp7WqE6UN+YvL
         RDbux7qimlEb1uerL46yDQtO4G6x0y1GHxlawDNfRZSDxM9b7KMZSJqztnGI7iOjMev3
         1v1MuXtk2iw64DJofXWodWqeFolVm68ptqoUp0Y6FBlWq6Vutpj0hAkv3wLVotql+pqy
         nXF/xzccAL7R82rNoeAGa+6cdwCAl2ZzbV8mYFX9tOyfIIMtCkjRdNITIfUhXespCOgA
         VIp6DD5fOeR8UtvqFw8VlK0XN39nCmQanhi86vdD78YcjEQ2IItfm/VuatWl427DHlOQ
         UaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/isyiyYelhWoqLBrchcU6kVdh+9vrvHgcSQ4B34VDk=;
        b=5nIXyZrZKMrSjUTUnw1+H4eG7rjVQNEyUDU9E89LQhrX+C/eyktvgD3E0eblUPC6Yy
         UEn/U6Lp2pNkSgAGNRPhv3RaEtDCFTnnM5q7mNpv/1hxuIJ0LtnufUuV1JM01U8DBFes
         jJ310fxfeObQYYwCtjew1fs3SwYXX8QcmbxHxakCkJ+TEutDEi3jlhdlr/RzjoA34B6f
         UVHX6e45X1LBHOJ6njxOjSgp8f/HEpbLP4evaeVJFBGhuUpG8UEhfR4LLv4JSMEkmyec
         Q3McP0DdgNHMrbRz3BPq2nm9RZVrRTvqNFgGhg1ESetAED5yD1qYlin+b1vqPQI3ftCm
         z/hQ==
X-Gm-Message-State: AFqh2ko8dYUgNSGZQ++mpsn7Hqbr4xy8ey+1p8SZr34dkqebx+H/eDEe
        g/y1bMDQ2RjyDjpS50derCbGOg==
X-Google-Smtp-Source: AMrXdXtLIWC/6uofx+GH6S+slsg0mbN3K3oswo4+1Ak1svK8dtWQlCW6M2ef7Eyxexwr//lJ8Goyrg==
X-Received: by 2002:a17:907:a643:b0:83c:7308:b2ed with SMTP id vu3-20020a170907a64300b0083c7308b2edmr67733986ejc.17.1673537389632;
        Thu, 12 Jan 2023 07:29:49 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id u21-20020a1709064ad500b00855d6ed60desm3551043ejt.192.2023.01.12.07.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 07:29:49 -0800 (PST)
Date:   Thu, 12 Jan 2023 16:29:48 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 07/11] RISC-V: KVM: Add SBI PMU extension support
Message-ID: <20230112152948.3vagzedhegbj4jbj@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-8-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215170046.2010255-8-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 09:00:42AM -0800, Atish Patra wrote:
> SBI PMU extension allows KVM guests to configure/start/stop/query about
> the PMU counters in virtualized enviornment as well.
> 
> In order to allow that, KVM implements the entire SBI PMU extension.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
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
> index 50c5472..3b8b84e8 100644
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
> index 0000000..223752f
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -0,0 +1,86 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022 Rivos Inc
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
> +				   struct kvm_vcpu_sbi_ext_data *edata,
> +				   struct kvm_cpu_trap *utrap)
> +{
> +	int ret = 0;
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	unsigned long funcid = cp->a6;
> +	uint64_t temp;
> +
> +	/* Return not supported if PMU is not initialized */
> +	if (!kvpmu->init_done)
> +		return -EINVAL;
> +
> +	switch (funcid) {
> +	case SBI_EXT_PMU_NUM_COUNTERS:
> +		ret = kvm_riscv_vcpu_pmu_num_ctrs(vcpu, edata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_GET_INFO:
> +		ret = kvm_riscv_vcpu_pmu_ctr_info(vcpu, cp->a0, edata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_CFG_MATCH:
> +#if defined(CONFIG_32BIT)
> +		temp = ((uint64_t)cp->a5 << 32) | cp->a4;
> +#else
> +		temp = cp->a4;
> +#endif
> +		ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
> +						       cp->a2, cp->a3, temp, edata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_START:
> +#if defined(CONFIG_32BIT)
> +		temp = ((uint64_t)cp->a4 << 32) | cp->a3;
> +#else
> +		temp = cp->a3;
> +#endif
> +		ret = kvm_riscv_vcpu_pmu_ctr_start(vcpu, cp->a0, cp->a1, cp->a2,
> +						   temp, edata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_STOP:
> +		ret = kvm_riscv_vcpu_pmu_ctr_stop(vcpu, cp->a0, cp->a1, cp->a2, edata);
> +		break;
> +	case SBI_EXT_PMU_COUNTER_FW_READ:
> +		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, edata);
> +		break;
> +	default:
> +		edata->err_val = SBI_ERR_NOT_SUPPORTED;
> +	}
> +
> +
> +	return ret;
> +}
> +
> +unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu, unsigned long extid)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +	/*
> +	 * PMU Extension is only available to guests if privilege mode filtering
> +	 * is available. Otherwise, guest will always count events while the
> +	 * execution is in hypervisor mode.
> +	 */
> +	return kvpmu->init_done && riscv_isa_extension_available(NULL, SSCOFPMF);

Assuming we're only supporting homogeneous systems, then can't we just
check for Sscofpmf at PMU init time? When the extension isn't present
we'd fail to init and then here init_done wouldn't be set.

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

Thanks,
drew
