Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313816678EF
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 16:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjALPTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 10:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbjALPSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 10:18:20 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8254B3FCA0
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 07:10:41 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id vm8so45494588ejc.2
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 07:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jLLJWMe/etMnB0XFHhWv0pgNgjlw6kBpIYizp5pdhBk=;
        b=F8WibSMfT0fxh4GwifXFqmywM/iurMQK+vhMbIbIHx8HA9P2DdaY7roAuokOBrkcAY
         LsYUmpfpvYwQK+vUsaWoQx24El2NejzlvNBKjvqpb6ZZdb1jS4KRlmVYqvntUBhrXqLc
         ZsdYRorZtesgnxWqGhgyjetUq4IQ5zFE+3XLDG7OT4OboB8oy95B4umFBdbEvM5YeHlR
         P+tr1zhXkkVFbEX4muiwpwSg76dt/C8eHaNDznjp48+KSu1zJLerpK87s344FYkgM78N
         JkpKJcu9BmLrOoaDyi+ucGYy6e/So3DPi1eLvxegw8k5emKUYcREqKVN6qirIFiU/IcY
         buMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLLJWMe/etMnB0XFHhWv0pgNgjlw6kBpIYizp5pdhBk=;
        b=c8+MQVRtFU28TPslaABr8Vz2+ijKbLR8aSqlot0L59bUFeFSFdLogGGJZjTRWxqZEg
         nRkIA6fEUumRW0X1LPRJ6bl2ElNE2tKlqJFBMpCNHHUtoXt5hju0lhCJZncYbVSSDu64
         m1GtAc9G9TR4sVeblgHlqzXMRdNtJehZW3qwgRTSYobPeX2jpQa1l5ovdIsYT/LSMIP2
         oNFfH4qG4LnHn4pk73KUXHzK/8JK8sUzL+fZ2j+/qkSnvpd2PNep0jLhf3/0qVyAxDBl
         ItjptWlAA2JukFKvP2zcY4iHN1YmeIv4Sng8MqTjCNMfmg0LpZF0bbEn0JS72DzM35SM
         zdLQ==
X-Gm-Message-State: AFqh2koInPSik81ihQNFpqPmIBeq6Tknj7QTM8wASe/v4X1n9fOJp1yW
        84sOzYmBF4i1zxILFvmlSVQBgPL5Tuft2GQf
X-Google-Smtp-Source: AMrXdXs+xfTp0qJObqX+uWr6uEg91QneZ6Sf6WY8rsMh/j1G4HgHcNeiHuR+aciN3wXC84Zpp7g+Nw==
X-Received: by 2002:a17:906:54d1:b0:84d:3819:79b9 with SMTP id c17-20020a17090654d100b0084d381979b9mr18654340ejp.71.1673536240021;
        Thu, 12 Jan 2023 07:10:40 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id kz11-20020a17090777cb00b007aece68483csm7545186ejc.193.2023.01.12.07.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 07:10:39 -0800 (PST)
Date:   Thu, 12 Jan 2023 16:10:38 +0100
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
Subject: Re: [PATCH v2 06/11] RISC-V: KVM: Add skeleton support for perf
Message-ID: <20230112151038.vhpn5mzw6nqjwk7o@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-7-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215170046.2010255-7-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 09:00:41AM -0800, Atish Patra wrote:
> This patch only adds barebore structure of perf implementation. Most of
> the function returns zero at this point and will be implemented
> fully in the future.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_host.h     |   3 +
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  76 ++++++++++++++
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/vcpu.c                 |   5 +
>  arch/riscv/kvm/vcpu_insn.c            |   2 +-
>  arch/riscv/kvm/vcpu_pmu.c             | 142 ++++++++++++++++++++++++++
>  6 files changed, 228 insertions(+), 1 deletion(-)
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_pmu.h
>  create mode 100644 arch/riscv/kvm/vcpu_pmu.c
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 93f43a3..f9874b4 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -18,6 +18,7 @@
>  #include <asm/kvm_vcpu_insn.h>
>  #include <asm/kvm_vcpu_sbi.h>
>  #include <asm/kvm_vcpu_timer.h>
> +#include <asm/kvm_vcpu_pmu.h>
>  
>  #define KVM_MAX_VCPUS			1024
>  
> @@ -228,6 +229,8 @@ struct kvm_vcpu_arch {
>  
>  	/* Don't run the VCPU (blocked) */
>  	bool pause;
> +
> +	struct kvm_pmu pmu;
>  };
>  
>  static inline void kvm_arch_hardware_unsetup(void) {}
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> new file mode 100644
> index 0000000..6a8c0f7
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -0,0 +1,76 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2022 Rivos Inc
> + *
> + * Authors:
> + *     Atish Patra <atishp@rivosinc.com>
> + */
> +
> +#ifndef __KVM_VCPU_RISCV_PMU_H
> +#define __KVM_VCPU_RISCV_PMU_H
> +
> +#include <linux/perf/riscv_pmu.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +#include <asm/sbi.h>
> +
> +#ifdef CONFIG_RISCV_PMU_SBI
> +#define RISCV_KVM_MAX_FW_CTRS 32
> +#define RISCV_MAX_COUNTERS      64
> +
> +/* Per virtual pmu counter data */
> +struct kvm_pmc {
> +	u8 idx;
> +	struct perf_event *perf_event;
> +	uint64_t counter_val;
> +	union sbi_pmu_ctr_info cinfo;
> +	/* Event monitoring status */
> +	bool started;
> +};
> +
> +/* PMU data structure per vcpu */
> +struct kvm_pmu {
> +	struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
> +	/* Number of the virtual firmware counters available */
> +	int num_fw_ctrs;
> +	/* Number of the virtual hardware counters available */
> +	int num_hw_ctrs;
> +	/* A flag to indicate that pmu initialization is done */
> +	bool init_done;
> +	/* Bit map of all the virtual counter used */
> +	DECLARE_BITMAP(pmc_in_use, RISCV_MAX_COUNTERS);
> +};
> +
> +#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
> +#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
> +
> +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				 unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> +				 struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				unsigned long ctr_mask, unsigned long flag,
> +				struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				     unsigned long ctr_mask, unsigned long flag,
> +				     unsigned long eidx, uint64_t edata,
> +				     struct kvm_vcpu_sbi_ext_data *extdata);

How about replacing 'edata' with 'evtdata' and then using 'edata' for the
struct kvm_vcpu_sbi_ext_data pointer in order to keep the struct pointer
name consistent with the other functions?

> +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				struct kvm_vcpu_sbi_ext_data *edata);
> +int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
> +
> +#else
> +struct kvm_pmu {
> +};
> +
> +static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
> +#endif
> +#endif

nit: it'd be nice to have

 #endif /* CONFIG_RISCV_PMU_SBI */
 #endif /* !__KVM_VCPU_RISCV_PMU_H */

> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 019df920..5de1053 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -25,3 +25,4 @@ kvm-y += vcpu_sbi_base.o
>  kvm-y += vcpu_sbi_replace.o
>  kvm-y += vcpu_sbi_hsm.o
>  kvm-y += vcpu_timer.o
> +kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7c08567..b746f21 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -137,6 +137,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  
>  	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
>  	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> +	kvm_riscv_vcpu_pmu_reset(vcpu);
>  
>  	vcpu->arch.hfence_head = 0;
>  	vcpu->arch.hfence_tail = 0;
> @@ -194,6 +195,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	/* Setup VCPU timer */
>  	kvm_riscv_vcpu_timer_init(vcpu);
>  
> +	/* setup performance monitoring */
> +	kvm_riscv_vcpu_pmu_init(vcpu);
> +
>  	/* Reset VCPU */
>  	kvm_riscv_reset_vcpu(vcpu);
>  
> @@ -216,6 +220,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	/* Cleanup VCPU timer */
>  	kvm_riscv_vcpu_timer_deinit(vcpu);
>  
> +	kvm_riscv_vcpu_pmu_deinit(vcpu);
>  	/* Free unused pages pre-allocated for G-stage page table mappings */
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  }
> diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
> index 0bb5276..1ff2649 100644
> --- a/arch/riscv/kvm/vcpu_insn.c
> +++ b/arch/riscv/kvm/vcpu_insn.c
> @@ -213,7 +213,7 @@ struct csr_func {
>  		    unsigned long wr_mask);
>  };
>  
> -static const struct csr_func csr_funcs[] = { };
> +static const struct csr_func csr_funcs[] = {};

Stray change

>  
>  /**
>   * kvm_riscv_vcpu_csr_return -- Handle CSR read/write after user space
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> new file mode 100644
> index 0000000..0f0748f1
> --- /dev/null
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -0,0 +1,142 @@
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
> +#include <linux/perf/riscv_pmu.h>
> +#include <asm/csr.h>
> +#include <asm/kvm_vcpu_sbi.h>
> +#include <asm/kvm_vcpu_pmu.h>
> +#include <linux/kvm_host.h>
> +
> +#define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> +
> +int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu, struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +	edata->out_val = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;

 edata->out_val = kvm_pmu_num_counters(kvpmu); 

> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +	if ((cidx > RISCV_MAX_COUNTERS) || (cidx == 1)) {

nit: No need for () around the expressions

> +		edata->err_val = SBI_ERR_INVALID_PARAM;
> +		return 0;
> +	}
> +
> +	edata->out_val = kvpmu->pmc[cidx].cinfo.value;
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				 unsigned long ctr_mask, unsigned long flag, uint64_t ival,
> +				 struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +	/* TODO */
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				unsigned long ctr_mask, unsigned long flag,
> +				struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +	/* TODO */
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
> +				     unsigned long ctr_mask, unsigned long flag,
> +				     unsigned long eidx, uint64_t edata,
> +				     struct kvm_vcpu_sbi_ext_data *extdata)
> +{
> +	/* TODO */
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
> +				struct kvm_vcpu_sbi_ext_data *edata)
> +{
> +	/* TODO */
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
> +{
> +	int i = 0, num_fw_ctrs, ret, num_hw_ctrs = 0, hpm_width = 0;
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +
> +	ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!hpm_width || !num_hw_ctrs) {
> +		pr_err("Can not initialize PMU for vcpu with NULL hpmcounter width/count\n");
                        ^ Cannot                   ^ VCPU                         ^ or number counters

> +		return -EINVAL;
> +	}
> +
> +	if ((num_hw_ctrs + RISCV_KVM_MAX_FW_CTRS) > RISCV_MAX_COUNTERS)

Shouldn't we warn about this condition? Presumably it means Linux selected
RISCV_MAX_COUNTERS too small, so a warning would let us know we need to
bump it up.

> +		num_fw_ctrs = RISCV_MAX_COUNTERS - num_hw_ctrs;
> +	else
> +		num_fw_ctrs = RISCV_KVM_MAX_FW_CTRS;
> +
> +	kvpmu->num_hw_ctrs = num_hw_ctrs;
> +	kvpmu->num_fw_ctrs = num_fw_ctrs;

nit: add blank line here

> +	/*
> +	 * There is no corelation betwen the logical hardware counter and virtual counters.

correlation 

> +	 * However, we need to encode a hpmcounter CSR in the counter info field so that
> +	 * KVM can trap n emulate the read. This works well in the migraiton usecase as

migration

> +	 * KVM doesn't care if the actual hpmcounter is available in the hardware or not.
> +	 */
> +	for (i = 0; i < kvm_pmu_num_counters(kvpmu); i++) {
> +		/* TIME CSR shouldn't be read from perf interface */
> +		if (i == 1)
> +			continue;
> +		kvpmu->pmc[i].idx = i;
> +		if (i < kvpmu->num_hw_ctrs) {
> +			kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_HW;
> +			if (i < 3)
> +				/* CY, IR counters */
> +				kvpmu->pmc[i].cinfo.width = 63;
> +			else
> +				kvpmu->pmc[i].cinfo.width = hpm_width;
> +			/*
> +			 * The CSR number doesn't have any relation with the logical
> +			 * hardware counters. The CSR numbers are encoded sequentially
> +			 * to avoid maintaining a map between the virtual counter
> +			 * and CSR number.
> +			 */
> +			kvpmu->pmc[i].cinfo.csr = CSR_CYCLE + i;
> +		} else {
> +			kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_FW;
> +			kvpmu->pmc[i].cinfo.width = BITS_PER_LONG - 1;
> +		}
> +	}
> +
> +	kvpmu->init_done = true;
> +
> +	return 0;
> +}
> +
> +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> +{
> +	/* TODO */
> +}
> +
> +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
> +{
> +	/* TODO */
> +}
> +
> -- 
> 2.25.1
>

Thanks,
drew
