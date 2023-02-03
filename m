Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9DB6894E7
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 11:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbjBCKO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 05:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjBCKO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 05:14:26 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D798E68D
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 02:14:24 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id y1so4192049wru.2
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 02:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=giEhO8XAaminWR9p0s3t8pSgAtiWCy3Wzk/E8kNGc1Y=;
        b=WaFawZsXXNk+S05B2RJH6Xpj+AjFIAFYZQ9eI2j1lq3Ib9ShUWz1fdkxQ7CRttLcb2
         fspQeu2I0KT59qlCQLMkhqf1EExy271w7jTYyJVZjPfWRO1AinW8fxXWymyyZsxMCXUk
         bmyYwta+5WpES1kTs+HCBDzcfm5Azb2M4qnsRmMO/EZooWxaDxcmPS0uY/j7DmS6WT7+
         XT3eoyXEZN/Jnelr06XAq7ni8FCqCZ2loGzv+XJfENtu3XMKrDWCDJMUm7PK3lQzGcJ5
         +jgGgEnByJfNJ0mtCW495Na6HdV3hnSTc3VpJcMnYosCnoIM7YLW0H3I8fNj4e88GQ27
         FOtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giEhO8XAaminWR9p0s3t8pSgAtiWCy3Wzk/E8kNGc1Y=;
        b=JlJ2VPGBXvaa4gQWcDYirH84nmhgFZmebnkjWmTSZVKkT5+RTKvNuBsOpmJEedK6AD
         A9ccfhpNjsyL1aaEgXB7McfakZahAZlK0QCfxZLLiAyReKV3OU2tGZeI9LOObGXE75RD
         zveKYRi8+W1cz7p0Dphh15ey3J4AyTjI+wTo1hoasIgTgLv5R+sG1Nj5ZYLtZQVaU/ik
         SUKonoBKqwlN1K840yVAxftvJu8+HgQntyIEykExAgFTqEuMaVEmBYyKu4463dr1Fsly
         J4KUDQuUKEAxdbpxekKLDf2X35euxAcn91j2fQryagKw6Z45AOsJHvePa200sSsnv7fW
         qNIQ==
X-Gm-Message-State: AO0yUKVynhi4wUrHY0qingPlIEq+Qknvr0qETOq1G4mEeLKBXsW20qVD
        n/CIGp7sHQj/QiLCUQ+5paL9zZ1qfBtw9R1Y
X-Google-Smtp-Source: AK7set/1vZENHaapNhdc1YtPq+8LEt7/jHhvN6cKIRFGmCrmRyG6HWl60iz69Ym3jHhPt/TsxybiHA==
X-Received: by 2002:adf:fb92:0:b0:2b5:47ab:6fa0 with SMTP id a18-20020adffb92000000b002b547ab6fa0mr8178851wrr.38.1675419262563;
        Fri, 03 Feb 2023 02:14:22 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id e8-20020adffc48000000b002bdc3f5945dsm1596252wrs.89.2023.02.03.02.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 02:14:22 -0800 (PST)
Date:   Fri, 3 Feb 2023 11:14:21 +0100
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
Subject: Re: [PATCH v4 13/14] RISC-V: KVM: Support firmware events
Message-ID: <20230203101421.gykyklow3sbllaou@orel>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
 <20230201231250.3806412-14-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201231250.3806412-14-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 03:12:49PM -0800, Atish Patra wrote:
> SBI PMU extension defines a set of firmware events which can provide
> useful information to guests about the number of SBI calls. As
> hypervisor implements the SBI PMU extension, these firmware events
> correspond to ecall invocations between VS->HS mode. All other firmware
> events will always report zero if monitored as KVM doesn't implement them.
> 
> This patch adds all the infrastructure required to support firmware
> events.
> 
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_pmu.h |  17 +++
>  arch/riscv/kvm/vcpu_pmu.c             | 142 ++++++++++++++++++++------
>  2 files changed, 125 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> index 2afaaf5..a1d8b7d 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
> @@ -22,6 +22,14 @@
>  
>  #define RISCV_MAX_COUNTERS      64
>  
> +struct kvm_fw_event {
> +	/* Current value of the event */
> +	unsigned long value;
> +
> +	/* Event monitoring status */
> +	bool started;
> +};
> +
>  /* Per virtual pmu counter data */
>  struct kvm_pmc {
>  	u8 idx;
> @@ -30,11 +38,14 @@ struct kvm_pmc {
>  	union sbi_pmu_ctr_info cinfo;
>  	/* Event monitoring status */
>  	bool started;
> +	/* Monitoring event ID */
> +	unsigned long event_idx;
>  };
>  
>  /* PMU data structure per vcpu */
>  struct kvm_pmu {
>  	struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
> +	struct kvm_fw_event fw_event[RISCV_KVM_MAX_FW_CTRS];
>  	/* Number of the virtual firmware counters available */
>  	int num_fw_ctrs;
>  	/* Number of the virtual hardware counters available */
> @@ -57,6 +68,7 @@ struct kvm_pmu {
>  { .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
>  #endif
>  
> +int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid);
>  int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
>  				unsigned long *val, unsigned long new_val,
>  				unsigned long wr_mask);
> @@ -87,6 +99,11 @@ struct kvm_pmu {
>  { .base = 0,      .count = 0, .func = NULL },
>  
>  static inline void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu) {}
> +static inline int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)
> +{
> +	return 0;
> +}
> +
>  static inline void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu) {}
>  #endif /* CONFIG_RISCV_PMU_SBI */
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 473ad80..dd16e60 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -202,12 +202,15 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
>  	struct kvm_pmc *pmc;
>  	u64 enabled, running;
> +	int fevent_code;
>  
>  	pmc = &kvpmu->pmc[cidx];
> -	if (!pmc->perf_event)
> -		return -EINVAL;
>  
> -	pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
> +	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
> +		fevent_code = get_event_code(pmc->event_idx);
> +		pmc->counter_val = kvpmu->fw_event[fevent_code].value;
> +	} else if (pmc->perf_event)
> +		pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);

We also need 

       else {
           return -EINVAL;
       }

>  	*out_val = pmc->counter_val;
>  
>  	return 0;
> @@ -223,6 +226,55 @@ static int kvm_pmu_validate_counter_mask(struct kvm_pmu *kvpmu, unsigned long ct
>  	return 0;
>  }
>  
> +static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, int ctr_idx,
> +				     struct perf_event_attr *attr, unsigned long flag,
> +				     unsigned long eidx, unsigned long evtdata)
> +{
> +	struct perf_event *event;
> +
> +	kvm_pmu_release_perf_event(pmc);
> +	pmc->idx = ctr_idx;
> +
> +	attr->config = kvm_pmu_get_perf_event_config(eidx, evtdata);
> +	if (flag & SBI_PMU_CFG_FLAG_CLEAR_VALUE) {
> +		//TODO: Do we really want to clear the value in hardware counter
> +		pmc->counter_val = 0;
> +	}
> +
> +	/*
> +	 * Set the default sample_period for now. The guest specified value
> +	 * will be updated in the start call.
> +	 */
> +	attr->sample_period = kvm_pmu_get_sample_period(pmc);
> +
> +	event = perf_event_create_kernel_counter(attr, -1, current, NULL, pmc);
> +	if (IS_ERR(event)) {
> +		pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
> +		return PTR_ERR(event);
> +	}
> +
> +	pmc->perf_event = event;
> +	if (flag & SBI_PMU_CFG_FLAG_AUTO_START)
> +		perf_event_enable(pmc->perf_event);
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)
> +{
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	struct kvm_fw_event *fevent;
> +
> +	if (!kvpmu || fid >= SBI_PMU_FW_MAX)
> +		return -EINVAL;
> +
> +	fevent = &kvpmu->fw_event[fid];
> +	if (fevent->started)
> +		fevent->value++;
> +
> +	return 0;
> +}
> +
>  int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
>  				unsigned long *val, unsigned long new_val,
>  				unsigned long wr_mask)
> @@ -289,6 +341,7 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
>  	int i, pmc_index, sbiret = 0;
>  	struct kvm_pmc *pmc;
> +	int fevent_code;
>  
>  	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
>  		sbiret = SBI_ERR_INVALID_PARAM;
> @@ -303,7 +356,22 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  		pmc = &kvpmu->pmc[pmc_index];
>  		if (flag & SBI_PMU_START_FLAG_SET_INIT_VALUE)
>  			pmc->counter_val = ival;
> -		if (pmc->perf_event) {
> +		if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
> +			fevent_code = get_event_code(pmc->event_idx);
> +			if (fevent_code >= SBI_PMU_FW_MAX) {
> +				sbiret = SBI_ERR_INVALID_PARAM;
> +				goto out;
> +			}
> +
> +			/* Check if the counter was already started for some reason */
> +			if (kvpmu->fw_event[fevent_code].started) {
> +				sbiret = SBI_ERR_ALREADY_STARTED;
> +				continue;
> +			}
> +
> +			kvpmu->fw_event[fevent_code].started = true;
> +			kvpmu->fw_event[fevent_code].value = pmc->counter_val;
> +		} else if (pmc->perf_event) {
>  			if (unlikely(pmc->started)) {
>  				sbiret = SBI_ERR_ALREADY_STARTED;
>  				continue;
> @@ -330,6 +398,7 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  	int i, pmc_index, sbiret = 0;
>  	u64 enabled, running;
>  	struct kvm_pmc *pmc;
> +	int fevent_code;
>  
>  	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
>  		sbiret = SBI_ERR_INVALID_PARAM;
> @@ -342,7 +411,18 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
>  			continue;
>  		pmc = &kvpmu->pmc[pmc_index];
> -		if (pmc->perf_event) {
> +		if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
> +			fevent_code = get_event_code(pmc->event_idx);
> +			if (fevent_code >= SBI_PMU_FW_MAX) {
> +				sbiret = SBI_ERR_INVALID_PARAM;
> +				goto out;
> +			}
> +
> +			if (!kvpmu->fw_event[fevent_code].started)
> +				sbiret = SBI_ERR_ALREADY_STOPPED;
> +
> +			kvpmu->fw_event[fevent_code].started = false;
> +		} else if (pmc->perf_event) {
>  			if (pmc->started) {
>  				/* Stop counting the counter */
>  				perf_event_disable(pmc->perf_event);
> @@ -355,11 +435,14 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  				pmc->counter_val += perf_event_read_value(pmc->perf_event,
>  									  &enabled, &running);
>  				kvm_pmu_release_perf_event(pmc);
> -				clear_bit(pmc_index, kvpmu->pmc_in_use);
>  			}
>  		} else {
>  			sbiret = SBI_ERR_INVALID_PARAM;
>  		}
> +		if (flag & SBI_PMU_STOP_FLAG_RESET) {
> +			pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
> +			clear_bit(pmc_index, kvpmu->pmc_in_use);
> +		}
>  	}
>  
>  out:
> @@ -373,12 +456,12 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  				     unsigned long eidx, uint64_t evtdata,
>  				     struct kvm_vcpu_sbi_return *retdata)
>  {
> -	int ctr_idx, sbiret = 0;
> -	u64 config;
> +	int ctr_idx, ret, sbiret = 0;
> +	bool is_fevent;
> +	unsigned long event_code;
>  	u32 etype = kvm_pmu_get_perf_event_type(eidx);
>  	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> -	struct perf_event *event;
> -	struct kvm_pmc *pmc;
> +	struct kvm_pmc *pmc = NULL;

I don't think this change initializing pmc is necessary, but OK.

>  	struct perf_event_attr attr = {
>  		.type = etype,
>  		.size = sizeof(struct perf_event_attr),
> @@ -399,7 +482,9 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  		goto out;
>  	}
>  
> -	if (kvm_pmu_is_fw_event(eidx)) {
> +	event_code = get_event_code(eidx);
> +	is_fevent = kvm_pmu_is_fw_event(eidx);
> +	if (is_fevent && event_code >= SBI_PMU_FW_MAX) {
>  		sbiret = SBI_ERR_NOT_SUPPORTED;
>  		goto out;
>  	}
> @@ -424,33 +509,18 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  	}
>  
>  	pmc = &kvpmu->pmc[ctr_idx];
> -	kvm_pmu_release_perf_event(pmc);
> -	pmc->idx = ctr_idx;
> -
> -	config = kvm_pmu_get_perf_event_config(eidx, evtdata);
> -	attr.config = config;
> -	if (flag & SBI_PMU_CFG_FLAG_CLEAR_VALUE) {
> -		//TODO: Do we really want to clear the value in hardware counter
> -		pmc->counter_val = 0;
> -	}
> -
> -	/*
> -	 * Set the default sample_period for now. The guest specified value
> -	 * will be updated in the start call.
> -	 */
> -	attr.sample_period = kvm_pmu_get_sample_period(pmc);
> -
> -	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
> -	if (IS_ERR(event)) {
> -		pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
> -		return PTR_ERR(event);
> +	if (is_fevent) {
> +		if (flag & SBI_PMU_CFG_FLAG_AUTO_START)
> +			kvpmu->fw_event[event_code].started = true;
> +	} else {
> +		ret = kvm_pmu_create_perf_event(pmc, ctr_idx, &attr, flag, eidx, evtdata);
> +		if (ret)
> +			return ret;
>  	}
>  
>  	set_bit(ctr_idx, kvpmu->pmc_in_use);
> -	pmc->perf_event = event;
> -	if (flag & SBI_PMU_CFG_FLAG_AUTO_START)
> -		perf_event_enable(pmc->perf_event);
>  
> +	pmc->event_idx = eidx;
>  	retdata->out_val = ctr_idx;
>  out:
>  	retdata->err_val = sbiret;
> @@ -494,6 +564,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  	 */
>  	kvpmu->num_hw_ctrs = num_hw_ctrs;
>  	kvpmu->num_fw_ctrs = RISCV_KVM_MAX_FW_CTRS;
> +	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
>  
>  	/*
>  	 * There is no correlation between the logical hardware counter and virtual counters.
> @@ -507,6 +578,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  			continue;
>  		pmc = &kvpmu->pmc[i];
>  		pmc->idx = i;
> +		pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
>  		if (i < kvpmu->num_hw_ctrs) {
>  			pmc->cinfo.type = SBI_PMU_CTR_TYPE_HW;
>  			if (i < 3)
> @@ -543,8 +615,10 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
>  		pmc = &kvpmu->pmc[i];
>  		pmc->counter_val = 0;
>  		kvm_pmu_release_perf_event(pmc);
> +		pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
>  	}
>  	bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
> +	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
>  }
>  
>  void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> -- 
> 2.25.1
>

Thanks,
drew
