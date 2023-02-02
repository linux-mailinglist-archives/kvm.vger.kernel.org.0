Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C13A68855A
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 18:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjBBR3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 12:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjBBR3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 12:29:32 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749426A325
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 09:29:30 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id l8so1996932wms.3
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 09:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lvGM9eziJ1k68OFs57HK7CmX4C1pnuT0xXcx3RcWcoc=;
        b=AdT20GUynTqEAjFWLRiwJDHeTg9OVyD/NJx9CgNz8Nlabhgr7vIqAIqn0wehQPVmKj
         MkpQI6O+zVIB2ssvkkqSRM7nidGXAdW5Ml1fLRot2Z7+f40QA/syC6OVYpI1M29JNY3V
         7HrhV44UVIMSnhgS0vKtf+FnKr0Gb1+xetdmAXVA74prNxxVlWYTY88dcJcFPBfR9VdW
         hnlkPI2c/bhXdqanOQl3kR8uKImrZpnMVNuKTknasGegwq80QK4CxqCETteuNPb0CID/
         sWNV/EsztYc1SwXMa8JmSskggVj4ejzy+InL1+CLUvAJzozAe4CsmlmAj21VO5cvfldM
         l/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvGM9eziJ1k68OFs57HK7CmX4C1pnuT0xXcx3RcWcoc=;
        b=kgB8lecIBOzEZSRCE0S4tjI1Q1p1wg+P2qC/8tD0ILxlP4KaQ71SUG+pym2oArNfWg
         WP48NZuuEKeOHU6eYkto4eP+6OSGesv0SqYH7KRCSQBRdDZUYcBFJzUUOs5Sy7oqW8vs
         cuhBJwIvZ/G6Uv+WDVt/8COUer0RianzA9P/sHi9Z5xLckWZlH07GtF5fNYXLOkg02Ej
         FOIe6KGvYLwQWkJXebxtGFamrpxB2fXaOEY5RJcDTH+GDoisJNnWr6mOXn/JAbAsppHV
         aPXBwt2TPoT4mnyqErxDeH3Hg7MtBDexmnke3/K3WR26iiKa79+O6KtAteoyMNfA9Mdt
         Jv7w==
X-Gm-Message-State: AO0yUKUoD4lQPddPjFkYvXRohWze120Q4mL4+rWTkLbwych6H7RJ6ZrP
        bluUeqVsFDx4hGN/koQI8aUH+A==
X-Google-Smtp-Source: AK7set9OffKgGD/0Kym8zdS6nkp8afzuz712+XsVPxnijRxeLh4Z15DP54mnav51F0CiusbcHI2IEw==
X-Received: by 2002:a05:600c:19cd:b0:3dc:42d2:aedc with SMTP id u13-20020a05600c19cd00b003dc42d2aedcmr7019867wmq.23.1675358968993;
        Thu, 02 Feb 2023 09:29:28 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id p30-20020a1c545e000000b003de2fc8214esm364845wmi.20.2023.02.02.09.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 09:29:28 -0800 (PST)
Date:   Thu, 2 Feb 2023 18:29:27 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 08/14] RISC-V: KVM: Add SBI PMU extension support
Message-ID: <20230202172927.jlwjkv6nbvhzcakw@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-9-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-9-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 03:12:44PM -0800, Atish Patra wrote:
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
>  arch/riscv/kvm/vcpu_sbi_pmu.c | 85 +++++++++++++++++++++++++++++++++++
>  3 files changed, 97 insertions(+), 1 deletion(-)
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
> index 0000000..e028b0a
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -0,0 +1,85 @@
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
> +	uint64_t temp;
> +
> +	/* Return not supported if PMU is not initialized */
> +	if (!kvpmu->init_done)
> +		return -EINVAL;

Shouldn't this be the following?

  if (!kvpmu->init_done)
     retdata->err_val = SBI_ERR_NOT_SUPPORTED;
     return 0;
  }

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
> +		 * Forward the error to the user space because its an error happened

"Forward the error to userspace because it's an error which happened within
 the host kernel."
                                        
> +		 * within host kernel. The other option would be convert this to
                                                                ^ to
> +		 * an SBI error and forward to the guest.
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
> +unsigned long kvm_sbi_ext_pmu_probe(struct kvm_vcpu *vcpu)
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

Thanks,
drew
