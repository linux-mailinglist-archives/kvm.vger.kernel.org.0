Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5AB666F1C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 11:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbjALKLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 05:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234286AbjALKKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 05:10:30 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C741570B
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 02:06:11 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ss4so36200676ejb.11
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 02:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2FzLDjGkwbhuRQdpsg4AAAIh21LPvTEV60KRnfA4Jnk=;
        b=c8cyrMUfQkoP30ETg/O6NgjXEBCDgTHm8T8oKW9kELRVBL/fVwclVGkWLYOOFE2hge
         aXtDnYw7aVgBKltkKi8BdGvdct8z3iLb/4k5ip1Ldx25Pu9TOfy0fo02B4N8ELD/U4ZS
         OvysFV+RknEgOdumM2/7RP66BpLW+9pG8yNPwVx8QtgMqZFAbsaiwKU2Fq+qJsxnizi/
         1CYvmvm849kV87PoeOpSUUrxTET3UKjnGBjlxlQ60/P55iTiE0g+tFOQbYSb/2cdD093
         uToVbp68M7R/0GJJC0A1LarDFnJTatRrulYR7jECVQWACtb8HgMmmiMd/5vqbGWhl0Yh
         Vgsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FzLDjGkwbhuRQdpsg4AAAIh21LPvTEV60KRnfA4Jnk=;
        b=7ekapMUoleNqoC3H5CeIidtlsK0jqkRXalaygBJ5GK6bPm0V4Jc6m0Bzo2B9METC7+
         Lt20hp6GjF5wihmZY+cAv/mjsd3DkBO8T7hlHYlDcxsLJj3Jkym9+cZvG/19DayeQVEj
         A0jCCm6clcjutTDSZNEbXAQTPr0Lo+Nmk8Cv/EECrw4s5+v+JhfBVmvhDgcw6ucS6ywA
         +UiYmP4V723rBJ3ubteSY4HY/jUzr7bYwSQAjIlIMiogpUUzlMK4+mJsbC/e1R2Zsh1z
         tgbYlY0318vJ4VQ8ee2d4EWjqrD2ICNNXy7W62tjTmPJeatpJiRqZFGe5+CsV1hS8RN8
         8Lgw==
X-Gm-Message-State: AFqh2kpLGjl7XuWz9VKN3paloCA6TAEIfO/9fd/X4dp7FTl8VrQVgSeO
        p6FlIwzcRda7+Q5nBlXPH0ohLw==
X-Google-Smtp-Source: AMrXdXs/WIUvWHYBGtlKjFpe5/QF+W/ylKh723CV4K5yq93k6pAAfRONTqMObmzHu4G+fNBxudjkiw==
X-Received: by 2002:a17:906:2a10:b0:854:956:1438 with SMTP id j16-20020a1709062a1000b0085409561438mr8720886eje.25.1673517969665;
        Thu, 12 Jan 2023 02:06:09 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id b21-20020a17090630d500b0084f7d38713esm3812925ejb.108.2023.01.12.02.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 02:06:09 -0800 (PST)
Date:   Thu, 12 Jan 2023 11:06:08 +0100
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
Subject: Re: [PATCH v2 01/11] RISC-V: Define helper functions expose hpm
 counter width and count
Message-ID: <20230112100608.d7tnvhbotjfctlgk@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-2-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215170046.2010255-2-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 09:00:36AM -0800, Atish Patra wrote:
> KVM module needs to know how many hardware counters and the counter
> width that the platform supports. Otherwise, it will not be able to show
> optimal value of virtual counters to the guest. The virtual hardware
> counters also need to have the same width as the logical hardware
> counters for simplicity. However, there shouldn't be mapping between
> virtual hardware counters and logical hardware counters. As we don't
> support hetergeneous harts or counters with different width as of now,
> the implementation relies on the counter width of the first available
> programmable counter.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  drivers/perf/riscv_pmu_sbi.c   | 35 +++++++++++++++++++++++++++++++++-
>  include/linux/perf/riscv_pmu.h |  3 +++
>  2 files changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 3852c18..65d4aa4 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -49,6 +49,9 @@ static const struct attribute_group *riscv_pmu_attr_groups[] = {
>  static union sbi_pmu_ctr_info *pmu_ctr_list;
>  static unsigned int riscv_pmu_irq;
>  
> +/* Cache the available counters in a bitmask */
> +unsigned long cmask;

I presume this can be static since it's not getting added to the header.
And don't we need this to be a long long for rv32? We should probably
just use u64.

> +
>  struct sbi_pmu_event_data {
>  	union {
>  		union {
> @@ -264,6 +267,37 @@ static bool pmu_sbi_ctr_is_fw(int cidx)
>  	return (info->type == SBI_PMU_CTR_TYPE_FW) ? true : false;
>  }
>  
> +/*
> + * Returns the counter width of a programmable counter and number of hardware
> + * counters. As we don't support heterneous CPUs yet, it is okay to just

heterogeneous

> + * return the counter width of the first programmable counter.
> + */
> +int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr)
> +{
> +	int i;
> +	union sbi_pmu_ctr_info *info;
> +	u32 hpm_width = 0, hpm_count = 0;
> +
> +	if (!cmask)
> +		return -EINVAL;
> +
> +	for_each_set_bit(i, &cmask, RISCV_MAX_COUNTERS) {
> +		info = &pmu_ctr_list[i];
> +		if (!info)
> +			continue;
> +		if (!hpm_width && (info->csr != CSR_CYCLE) && (info->csr != CSR_INSTRET))

nit: No need for () around the != expressions

> +			hpm_width = info->width;
> +		if (info->type == SBI_PMU_CTR_TYPE_HW)
> +			hpm_count++;
> +	}
> +
> +	*hw_ctr_width = hpm_width;
> +	*num_hw_ctr = hpm_count;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(riscv_pmu_get_hpm_info);

EXPORT_SYMBOL_GPL ?

> +
>  static int pmu_sbi_ctr_get_idx(struct perf_event *event)
>  {
>  	struct hw_perf_event *hwc = &event->hw;
> @@ -798,7 +832,6 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
>  static int pmu_sbi_device_probe(struct platform_device *pdev)
>  {
>  	struct riscv_pmu *pmu = NULL;
> -	unsigned long cmask = 0;
>  	int ret = -ENODEV;
>  	int num_counters;
>  
> diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
> index e17e86a..a1c3f77 100644
> --- a/include/linux/perf/riscv_pmu.h
> +++ b/include/linux/perf/riscv_pmu.h
> @@ -73,6 +73,9 @@ void riscv_pmu_legacy_skip_init(void);
>  static inline void riscv_pmu_legacy_skip_init(void) {};
>  #endif
>  struct riscv_pmu *riscv_pmu_alloc(void);
> +#ifdef CONFIG_RISCV_PMU_SBI
> +int riscv_pmu_get_hpm_info(u32 *hw_ctr_width, u32 *num_hw_ctr);
> +#endif
>  
>  #endif /* CONFIG_RISCV_PMU */
>  
> -- 
> 2.25.1
> 

Thanks,
drew
