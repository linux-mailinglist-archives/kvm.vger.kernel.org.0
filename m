Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617316695E6
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 12:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241466AbjAMLvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 06:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234853AbjAMLvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 06:51:15 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3531789A
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 03:45:05 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v30so30813982edb.9
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 03:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VbcFVb2aBp4RKMVYxwMqTDhGWE6q9X2qGacstyFopTo=;
        b=DIMnrcrJPBWc7Hx+/xE0WI8jYebht+6NhXmbHUYPvx1b5HZbUu1T5yUVKt/39u61pd
         qgMjpwDwz0914j08WRrrhcWwyD22aGsTPCQWIWWC6kxT/71gqnV9KzGLGZuUEnYLyqEl
         mFr6+Jf8k9FKh6e769NwNvWGgDURjqa6Opm0C8ClT6RY24d5mrYQa1LMCfh8zayofreM
         EsDrBXSzm/XVhgNcTPjNhdjBosHvG5Uy72b8feyTAUkxSTCzWO5hgJtgJTBwM/Wdzb3U
         mIFW3F0AqtEXPMU5Rglk7khaWRqHE4Kww6I/cOWTx0bHOrPYN3INXd+DsWWpotKeN7EQ
         0uig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbcFVb2aBp4RKMVYxwMqTDhGWE6q9X2qGacstyFopTo=;
        b=lKcVqJ8UXX73rfiiBxvXqZTw8GrNGi7a0QpsOH+/NBvYpgEnX7CdDEz/Uk0OPx5aA7
         9K6frXsJUjUxuia0j6IsZ3bdc3nht6aMmo1C39I27+62gGT8K7RuE4U4hnb7rfTAJYGW
         Hnhd6JqaY48R51T+v1BbP75b6uY4gZtX4Fb9AEAvtdSfhdQPQst39iZZnMbZ+bsrQQBR
         T82IHpW0nA9JicAuszClGBsG+iez7Be4rFnEDN8Hy7rgtkPO6sYLubiY5bsuZ4UGVvHh
         pGek4UkhIlm1Z2DKJLA+91mvfuiXX4GUGCkIPM4KD02vfOZF8GHkkv/+wrIIZ5ihifPS
         J73g==
X-Gm-Message-State: AFqh2kqdVj7RMDAStTIpyOF0QW3UGxPca9K4+mwi2H15HnmWukusdyJf
        70VHGqqy6g/eaRFgulM2gnZOvw==
X-Google-Smtp-Source: AMrXdXtFbb14tCDgJ8WK7pmrpC5nz51jWIGRQKXLfkfXfoEYVv0d4xWaxWb5vK49sc243JonhPdlgg==
X-Received: by 2002:a05:6402:f04:b0:46d:ca42:2e59 with SMTP id i4-20020a0564020f0400b0046dca422e59mr77052505eda.11.1673610303410;
        Fri, 13 Jan 2023 03:45:03 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id g11-20020a056402428b00b004722d7e8c7csm8068431edc.14.2023.01.13.03.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 03:45:03 -0800 (PST)
Date:   Fri, 13 Jan 2023 12:45:02 +0100
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
Subject: Re: [PATCH v2 10/11] RISC-V: KVM: Implement perf support without
 sampling
Message-ID: <20230113114502.hiebgkujduwcmsuk@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-11-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215170046.2010255-11-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 09:00:45AM -0800, Atish Patra wrote:
> RISC-V SBI PMU & Sscofpmf ISA extension allows supporting perf in
> the virtualization enviornment as well. KVM implementation
> relies on SBI PMU extension for most the most part while trapping

s/most the most/the most/

> & emulating the CSRs read for counter access.
> 
> This patch doesn't have the event sampling support yet.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_pmu.c | 358 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 342 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index 53c4163..21c1f0f 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -12,10 +12,163 @@
>  #include <linux/perf/riscv_pmu.h>
>  #include <asm/csr.h>
>  #include <asm/kvm_vcpu_sbi.h>
> +#include <asm/bitops.h>
>  #include <asm/kvm_vcpu_pmu.h>
>  #include <linux/kvm_host.h>
>  
>  #define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
> +#define get_event_type(x) ((x & SBI_PMU_EVENT_IDX_TYPE_MASK) >> 16)
> +#define get_event_code(x) (x & SBI_PMU_EVENT_IDX_CODE_MASK)

Should put () around x

> +
> +static inline u64 pmu_get_sample_period(struct kvm_pmc *pmc)

I'd rather we use kvm_pmu_ for the prefix instead of just pmu for
this and all the other functions.

Also I'd drop the inline attribute here and in other functions below to
let the compiler completely decide what to do.

> +{
> +	u64 counter_val_mask = GENMASK(pmc->cinfo.width, 0);
> +	u64 sample_period;
> +
> +	if (!pmc->counter_val)
> +		sample_period = counter_val_mask;
> +	else
> +		sample_period = (-pmc->counter_val) & counter_val_mask;

I probably don't understand this, since I see arm64/kvm doing the same
thing, but if sample_period is the number of remaining counts a counter
has, then I'd write it as

  sample_period = counter_val_mask - (pmc->counter_val & counter_val_mask);

As it stands, the pmc->counter_val == 0 case would be the same, but
the other case differs by 1. arm64/kvm doesn't appear to handle the
zero case.

> +
> +	return sample_period;
> +}
> +
> +static u32 pmu_get_perf_event_type(unsigned long eidx)
> +{
> +	enum sbi_pmu_event_type etype = get_event_type(eidx);
> +	u32 type;
> +
> +	if (etype == SBI_PMU_EVENT_TYPE_HW)
> +		type = PERF_TYPE_HARDWARE;
> +	else if (etype == SBI_PMU_EVENT_TYPE_CACHE)
> +		type = PERF_TYPE_HW_CACHE;
> +	else if (etype == SBI_PMU_EVENT_TYPE_RAW || etype == SBI_PMU_EVENT_TYPE_FW)
> +		type = PERF_TYPE_RAW;
> +	else
> +		type = PERF_TYPE_MAX;

nit: This might look nicer as a switch

> +
> +	return type;
> +}
> +
> +static inline bool pmu_is_fw_event(unsigned long eidx)
> +{
> +

extra blank line here

> +	return get_event_type(eidx) == SBI_PMU_EVENT_TYPE_FW;
> +}
> +
> +static void pmu_release_perf_event(struct kvm_pmc *pmc)
> +{
> +	if (pmc->perf_event) {
> +		perf_event_disable(pmc->perf_event);
> +		perf_event_release_kernel(pmc->perf_event);
> +		pmc->perf_event = NULL;
> +	}
> +}
> +
> +static u64 pmu_get_perf_event_hw_config(u32 sbi_event_code)
> +{
> +	/* SBI PMU HW event code is offset by 1 from perf hw event codes */
> +	return (u64)sbi_event_code - 1;

This is probably fine to do since we're mapping specified codes to UAPI
codes, so it's unlikely something will change this relationship, but if we
expose the mapping explicitly it'll give code readers a chance to see
what's what without looking stuff up elsewhere. How about creating an
array indexed by sbi_event_code with the mapping?

  enum perf_hw_id hw_event_perf_map[SBI_PMU_HW_GENERAL_MAX] = {
  [SBI_PMU_HW_CPU_CYCLES] = PERF_COUNT_HW_CPU_CYCLES,
  ...
  };

> +}
> +
> +static u64 pmu_get_perf_event_cache_config(u32 sbi_event_code)
> +{
> +	u64 config = U64_MAX;
> +	unsigned int cache_type, cache_op, cache_result;
> +
> +	/* All the cache event masks lie within 0xFF. No separate masking is necesssary */
> +	cache_type = (sbi_event_code & SBI_PMU_EVENT_CACHE_ID_CODE_MASK) >> 3;

It'd be nice to have a define for that 3 shift.

> +	cache_op = (sbi_event_code & SBI_PMU_EVENT_CACHE_OP_ID_CODE_MASK) >> 1;

Also for this 1 shift.

> +	cache_result = sbi_event_code & SBI_PMU_EVENT_CACHE_RESULT_ID_CODE_MASK;
> +
> +	if (cache_type >= PERF_COUNT_HW_CACHE_MAX ||
> +	    cache_op >= PERF_COUNT_HW_CACHE_OP_MAX ||
> +	    cache_result >= PERF_COUNT_HW_CACHE_RESULT_MAX)
> +		return config;
> +
> +	config = cache_type | (cache_op << 8) | (cache_result << 16);
> +
> +	return config;
> +}
> +
> +static u64 pmu_get_perf_event_config(unsigned long eidx, uint64_t evt_data)
> +{
> +	enum sbi_pmu_event_type etype = get_event_type(eidx);
> +	u32 ecode = get_event_code(eidx);
> +	u64 config = U64_MAX;
> +
> +	if (etype == SBI_PMU_EVENT_TYPE_HW)
> +		config = pmu_get_perf_event_hw_config(ecode);
> +	else if (etype == SBI_PMU_EVENT_TYPE_CACHE)
> +		config = pmu_get_perf_event_cache_config(ecode);
> +	else if (etype == SBI_PMU_EVENT_TYPE_RAW)
> +		config = evt_data & RISCV_PMU_RAW_EVENT_MASK;
> +	else if ((etype == SBI_PMU_EVENT_TYPE_FW) && (ecode < SBI_PMU_FW_MAX))
> +		config = (1ULL << 63) | ecode;

nit: switch?

> +
> +	return config;
> +}
> +
> +static int pmu_get_fixed_pmc_index(unsigned long eidx)
> +{
> +	u32 etype = pmu_get_perf_event_type(eidx);
> +	u32 ecode = get_event_code(eidx);
> +	int ctr_idx;
> +
> +	if (etype != SBI_PMU_EVENT_TYPE_HW)
> +		return -EINVAL;
> +
> +	if (ecode == SBI_PMU_HW_CPU_CYCLES)
> +		ctr_idx = 0;
> +	else if (ecode == SBI_PMU_HW_INSTRUCTIONS)
> +		ctr_idx = 2;

nit: Could drop the ctr_idx variable and return directly

> +	else
> +		return -EINVAL;
> +
> +	return ctr_idx;
> +}
> +
> +static int pmu_get_programmable_pmc_index(struct kvm_pmu *kvpmu, unsigned long eidx,
> +					  unsigned long cbase, unsigned long cmask)
> +{
> +	int ctr_idx = -1;
> +	int i, pmc_idx;
> +	int min, max;
> +
> +	if (pmu_is_fw_event(eidx)) {
> +		/* Firmware counters are mapped 1:1 starting from num_hw_ctrs for simplicity */
> +		min = kvpmu->num_hw_ctrs;
> +		max = min + kvpmu->num_fw_ctrs;
> +	} else {
> +		/* First 3 counters are reserved for fixed counters */
> +		min = 3;
> +		max = kvpmu->num_hw_ctrs;
> +	}
> +
> +	for_each_set_bit(i, &cmask, BITS_PER_LONG) {
> +		pmc_idx = i + cbase;
> +		if ((pmc_idx >= min && pmc_idx < max) &&
> +		    !test_bit(pmc_idx, kvpmu->pmc_in_use)) {
> +			ctr_idx = pmc_idx;
> +			break;

nit: Could drop the ctr_idx variable and return directly

> +		}
> +	}
> +
> +	return ctr_idx;
> +}
> +
> +static int pmu_get_pmc_index(struct kvm_pmu *pmu, unsigned long eidx,
> +			     unsigned long cbase, unsigned long cmask)
> +{
> +	int ret;
> +
> +	/* Fixed counters need to be have fixed mapping as they have different width */
> +	ret = pmu_get_fixed_pmc_index(eidx);
> +	if (ret >= 0)
> +		return ret;
> +
> +	return pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask);
> +}
>  
>  static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>  			unsigned long *out_val)
> @@ -82,7 +235,41 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  				 unsigned long ctr_mask, unsigned long flag, uint64_t ival,
>  				 struct kvm_vcpu_sbi_ext_data *edata)
>  {
> -	/* TODO */
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	int i, num_ctrs, pmc_index, sbiret = 0;
> +	struct kvm_pmc *pmc;
> +
> +	num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;

We can put kvm_pmu_num_counters(kvpmu) in its one use below and
drop num_ctrs.

> +	if (ctr_base + __fls(ctr_mask) >= num_ctrs) {

__fls is undefined when ctr_mask is zero, so we should check it first,
unless the caller of this function is required to check it.

(Same two comments for the functions below that have the same check.)

> +		sbiret = SBI_ERR_INVALID_PARAM;
> +		goto out;
> +	}
> +
> +	/* Start the counters that have been configured and requested by the guest */
> +	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
> +		pmc_index = i + ctr_base;
> +		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
> +			continue;
> +		pmc = &kvpmu->pmc[pmc_index];
> +		if (flag & SBI_PMU_START_FLAG_SET_INIT_VALUE)
> +			pmc->counter_val = ival;
> +		if (pmc->perf_event) {
> +			if (unlikely(pmc->started)) {
> +				sbiret = SBI_ERR_ALREADY_STARTED;
> +				continue;
> +			}
> +			perf_event_period(pmc->perf_event, pmu_get_sample_period(pmc));
> +			perf_event_enable(pmc->perf_event);
> +			pmc->started = true;
> +		} else {
> +			kvm_debug("Can not start counter due to invalid confiugartion\n");
                                   ^ Cannot                             ^ configuration

> +			sbiret = SBI_ERR_INVALID_PARAM;
> +		}
> +	}

Possibly a spec oversight is that we continue to try and start counters,
even when we've seen errors. The problem with implementing that is that
if we have both errors we only return the last one. I.e. one counter
was already started and another counter resulted in invalid-param, we
only return invalid-param. We also don't say anything about the number
of failures / successes. I think we should bail on the first error and
even stop counters that we started. Callers can then try again after
correcting their input without potentially getting already-started errors.
We'd need to change the spec to do that though.

> +
> +out:
> +	edata->err_val = sbiret;
> +
>  	return 0;
>  }
>  
> @@ -90,16 +277,142 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  				unsigned long ctr_mask, unsigned long flag,
>  				struct kvm_vcpu_sbi_ext_data *edata)
>  {
> -	/* TODO */
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	int i, num_ctrs, pmc_index, sbiret = 0;
> +	u64 enabled, running;
> +	struct kvm_pmc *pmc;
> +
> +	num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
> +	if ((ctr_base + __fls(ctr_mask)) >= num_ctrs) {

nit: Can drop ()

> +		sbiret = SBI_ERR_INVALID_PARAM;
> +		goto out;
> +	}
> +
> +	/* Stop the counters that have been configured and requested by the guest */
> +	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
> +		pmc_index = i + ctr_base;
> +		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
> +			continue;
> +		pmc = &kvpmu->pmc[pmc_index];
> +		if (pmc->perf_event) {
> +			if (pmc->started) {
> +				/* Stop counting the counter */
> +				perf_event_disable(pmc->perf_event);
> +				pmc->started = false;
> +			} else
> +				sbiret = SBI_ERR_ALREADY_STOPPED;
> +
> +			if (flag & SBI_PMU_STOP_FLAG_RESET) {
> +				/* Relase the counter if this is a reset request */
> +				pmc->counter_val += perf_event_read_value(pmc->perf_event,
> +									  &enabled, &running);
> +				pmu_release_perf_event(pmc);
> +				clear_bit(pmc_index, kvpmu->pmc_in_use);
> +			}
> +		} else {
> +			kvm_debug("Can not stop counter due to invalid confiugartion\n");
                                   ^Cannot                             ^ configuration

> +			sbiret = SBI_ERR_INVALID_PARAM;
> +		}
> +	}

Same comment about the multiple errors problem.

> +
> +out:
> +	edata->err_val = sbiret;
> +
>  	return 0;
>  }
>  
>  int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_base,
>  				     unsigned long ctr_mask, unsigned long flag,
> -				     unsigned long eidx, uint64_t edata,
> -				     struct kvm_vcpu_sbi_ext_data *extdata)
> +				     unsigned long eidx, uint64_t evt_data,
> +				     struct kvm_vcpu_sbi_ext_data *ext_data)

This should be part of the skeleton patch.

>  {
> -	/* TODO */
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	struct perf_event *event;
> +	struct perf_event_attr attr;
> +	int num_ctrs, ctr_idx;
> +	u32 etype = pmu_get_perf_event_type(eidx);
> +	u64 config;
> +	struct kvm_pmc *pmc;
> +	int sbiret = 0;
> +
> +
> +	num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
> +	if (etype == PERF_TYPE_MAX || (ctr_base + __fls(ctr_mask) >= num_ctrs)) {
> +		sbiret = SBI_ERR_INVALID_PARAM;
> +		goto out;
> +	}
> +
> +	if (pmu_is_fw_event(eidx)) {
> +		sbiret = SBI_ERR_NOT_SUPPORTED;
> +		goto out;
> +	}
> +
> +	/*
> +	 * SKIP_MATCH flag indicates the caller is aware of the assigned counter
> +	 * for this event. Just do a sanity check if it already marked used.
> +	 */
> +	if (flag & SBI_PMU_CFG_FLAG_SKIP_MATCH) {
> +		if (!test_bit(ctr_base, kvpmu->pmc_in_use)) {
> +			sbiret = SBI_ERR_FAILURE;
> +			goto out;

I see this is the same way OpenSBI implements this, but I don't really
understand it. The spec says

"""
NOTE: When SBI_PMU_CFG_FLAG_SKIP_MATCH is set in config_flags, the SBI
implementation will unconditionally select the first counter from the set
of counters specified by the counter_idx_base and counter_idx_mask.
"""

which doesn't say anything about the caller just wanting to confirm the
counter is in use. Indeed, the spec says this function is for

"""
Find and configure a counter from a set of counters which is not started
(or enabled) and can monitor the specified event.
"""

which would imply errors should returned anytime we match something
already started, rather than the opposite.

Also, I think we should be using ctr_base + first-set-bit(ctr_mask),
because the spec says to look at both the base and the mask, and take
the first counter.

Finally, the spec doesn't have SBI_ERR_FAILURE listed as a possible
error.

> +		}
> +		ctr_idx = ctr_base;
> +		goto match_done;

nit: We don't need the match_done label and goto. We can just use
an if-else.

> +	}
> +
> +	ctr_idx = pmu_get_pmc_index(kvpmu, eidx, ctr_base, ctr_mask);
> +	if (ctr_idx < 0) {
> +		sbiret = SBI_ERR_NOT_SUPPORTED;
> +		goto out;
> +	}
> +
> +match_done:
> +	pmc = &kvpmu->pmc[ctr_idx];
> +	pmu_release_perf_event(pmc);
> +	pmc->idx = ctr_idx;
> +
> +	config = pmu_get_perf_event_config(eidx, evt_data);
> +	memset(&attr, 0, sizeof(struct perf_event_attr));

At the top of the function we can use

        struct perf_event_attr attr = {
          .type = etype,
          .size = sizeof(struct perf_event_attr),

	  /* anything else we know at the top */

	};

instead of the memset and some of the assignments here.

> +	attr.type = etype;
> +	attr.size = sizeof(attr);
> +	attr.pinned = true;
> +
> +	/*
> +	 * It should never reach here if the platform doesn't support sscofpmf extensio
                                                                     ^ the     ^ extension

> +	 * as mode filtering won't work without it.
> +	 */
> +	attr.exclude_host = true;
> +	attr.exclude_hv = true;
> +	attr.exclude_user = !!(flag & SBI_PMU_CFG_FLAG_SET_UINH);
> +	attr.exclude_kernel = !!(flag & SBI_PMU_CFG_FLAG_SET_SINH);
> +	attr.config = config;
> +	attr.config1 = RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS;
> +	if (flag & SBI_PMU_CFG_FLAG_CLEAR_VALUE) {
> +		//TODO: Do we really want to clear the value in hardware counter
> +		pmc->counter_val = 0;
> +	}
> +
> +	/*
> +	 * Set the default sample_period for now. The guest specified value
> +	 * will be updated in the start call.
> +	 */
> +	attr.sample_period = pmu_get_sample_period(pmc);
> +
> +	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
> +	if (IS_ERR(event)) {
> +		pr_err("kvm pmu event creation failed event %pe for eidx %lx\n", event, eidx);
> +		return -EOPNOTSUPP;

event is an error, so we shouldn't call it an event in the error message.
How about

  pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));

and then PTR_ERR(event) intead of -EOPNOTSUPP.

> +	}
> +
> +	set_bit(ctr_idx, kvpmu->pmc_in_use);
> +	pmc->perf_event = event;
> +	if (flag & SBI_PMU_CFG_FLAG_AUTO_START)
> +		perf_event_enable(pmc->perf_event);
> +
> +	ext_data->out_val = ctr_idx;
> +out:
> +	ext_data->err_val = sbiret;
> +
>  	return 0;
>  }
>  
> @@ -119,6 +432,7 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  {
>  	int i = 0, num_fw_ctrs, ret, num_hw_ctrs = 0, hpm_width = 0;
>  	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
>  
>  	ret = riscv_pmu_get_hpm_info(&hpm_width, &num_hw_ctrs);
>  	if (ret < 0)
> @@ -134,6 +448,7 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  	else
>  		num_fw_ctrs = RISCV_KVM_MAX_FW_CTRS;
>  
> +	bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);

Could move this bitmap clearing to deinit as it should be clear the
first time already since vcpus are allocated with __GFP_ZERO.

>  	kvpmu->num_hw_ctrs = num_hw_ctrs;
>  	kvpmu->num_fw_ctrs = num_fw_ctrs;
>  	/*
> @@ -146,24 +461,26 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  		/* TIME CSR shouldn't be read from perf interface */
>  		if (i == 1)
>  			continue;
> -		kvpmu->pmc[i].idx = i;
> +		pmc = &kvpmu->pmc[i];
> +		pmc->idx = i;
> +		pmc->counter_val = 0;

Also could be moved to deinit.

>  		if (i < kvpmu->num_hw_ctrs) {
>  			kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_HW;
>  			if (i < 3)
>  				/* CY, IR counters */
> -				kvpmu->pmc[i].cinfo.width = 63;
> +				pmc->cinfo.width = 63;
>  			else
> -				kvpmu->pmc[i].cinfo.width = hpm_width;
> +				pmc->cinfo.width = hpm_width;
>  			/*
>  			 * The CSR number doesn't have any relation with the logical
>  			 * hardware counters. The CSR numbers are encoded sequentially
>  			 * to avoid maintaining a map between the virtual counter
>  			 * and CSR number.
>  			 */
> -			kvpmu->pmc[i].cinfo.csr = CSR_CYCLE + i;
> +			pmc->cinfo.csr = CSR_CYCLE + i;
>  		} else {
> -			kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_FW;
> -			kvpmu->pmc[i].cinfo.width = BITS_PER_LONG - 1;
> +			pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
> +			pmc->cinfo.width = BITS_PER_LONG - 1;

Almost all of these changes can be avoided by using the pmc pointer in the
skeleton patch from the start.

>  		}
>  	}
>  
> @@ -172,13 +489,22 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
> +void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
>  {
> -	/* TODO */
> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	int i;
> +
> +	if (!kvpmu)
> +		return;
> +
> +	for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_MAX_COUNTERS) {
> +		pmc = &kvpmu->pmc[i];
> +		pmu_release_perf_event(pmc);
> +	}
>  }
>  
> -void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
> +void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
>  {
> -	/* TODO */
> +	kvm_riscv_vcpu_pmu_deinit(vcpu);

The skeleton patch could put deinit and reset in the right order to avoid
this change.

>  }
> -
> -- 
> 2.25.1
> 

Thanks,
drew
