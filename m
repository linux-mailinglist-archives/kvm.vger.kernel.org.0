Return-Path: <kvm+bounces-11281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4102A874A63
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 10:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 652141C208DF
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007A982D74;
	Thu,  7 Mar 2024 09:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PpR+6VzC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE4151C54
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 09:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709802545; cv=none; b=IKXHwOHHmZs58QMm8xjjMhhpsvaWwUEZty/SefEvMdPYor/Ek5YVQAg6WbkvMge9+a85zmqJ3AvnBaxOB6KMnJHAGdxJuFd4BvJ0uwMd8rY5K+a7Fg2zQ+xKqts0loTY2oT4G2v2zpjv2N51zPaQ7H+OtpHqedOeL8X5j0D7t7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709802545; c=relaxed/simple;
	bh=GCMYFgmTGwePL2B54zP2l03hc3B3GZOKbPtUMnRYUFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BGgkK3K/xRBYHbnWb5akOgtapGe1wCXiAIJxkoC0NK2kbK7SHucUaBz6ZvDv/oiVjNrNWHpzmro18p4Mt2788+bWYG3o1+HewztbsVZ2oy7y4d99zvxesLsLjaz2ovPEeUF4wXbz5y5xqi92x1V91foNj07eVxtBeC0fBz9eUY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PpR+6VzC; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e5b1c6daa3so517443b3a.1
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 01:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709802543; x=1710407343; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/JzmIoBcG4qTz6RzDOh4SYJl2e9JPACLg8B5zsSa24U=;
        b=PpR+6VzCd1rPlh+y9zhMCQ96ods6W1dZ6KN0Og03wGQDU+tR2rD1A65Zm/8fURyuiV
         oQzdMJY19ExWEkAQQASLdODOhKqqAOFYFABi4GFJboz1E1fl9sfXPYBKq1vwYS6bE/61
         4txT48beGNDLcsWFk9XuPct35Yog0W5ip6FPUaq5dOBegjGrXw8gGBbPf014yUsIBIiZ
         mUGt01fYqB2DXVVpBYiWKlVyuQzGfqUTan72xBAzkYesMLNqR0ILStKqtlsd9vE9Sl6+
         X5XLUkFjV6eoBX9/4FV59iazX1qb7/DBsptOU8muiwTqxisLG9AR5Bao3yW636jpvheV
         cZig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709802543; x=1710407343;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/JzmIoBcG4qTz6RzDOh4SYJl2e9JPACLg8B5zsSa24U=;
        b=GYyFxyEmKhQbcSNtByAIhAJVfW6P5G4kjoRQByMEtm9YTqm3mFVMEAALZ1gXNccOvU
         h3oMyvXSJrt8/q64u7TuQg7cmHkAV2NfEiRDvTnRpbUf8KG3jamosxUTBSrcmGLz1sPR
         OKsjlZfuEIFlth3jb3nNDY9hzlN1Rbl5wh4tQR0z/vRU6+owULuXM7NRQ3cpuka3CQb3
         hqoz1kd2erqNcRoeEVvweucd79cvFgz2PjyC5jRAAH750CsRgUjnj2Fvq4URl7/9hsIX
         HjB3WfF6vbiC6cfMxnMPOTlxE3LWaT8RFvSHvYZjlfMcW7b1kWeyC9uCcZgDRgb347+7
         h6kQ==
X-Gm-Message-State: AOJu0YzjnGc3KY15E8mAWvjtz90mo36ZFHkBj6mPo2EC0BJ+I1DEo2BX
	/0zex/OLZH7WMZz2LGfC0aA9vKcG/RoSF4H8ciVqTt9g9MSk16QnlbMWe+d1qOyRmA==
X-Google-Smtp-Source: AGHT+IHof7k6fOTZDsX73ZQ8hTlS/nmtjiakES/9IXMba4QeI53RIsk8IawkuTKUOoIaNyG47QN/lw==
X-Received: by 2002:a05:6a00:9084:b0:6e5:dadd:6e11 with SMTP id jo4-20020a056a00908400b006e5dadd6e11mr21432746pfb.33.1709802542737;
        Thu, 07 Mar 2024 01:09:02 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id w184-20020a6262c1000000b006e65214cce6sm2020499pfb.209.2024.03.07.01.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 01:09:02 -0800 (PST)
Message-ID: <4d652125-69fa-4fb8-ae09-8076c46211d4@gmail.com>
Date: Thu, 7 Mar 2024 17:08:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 3/4] x86/pmu: Test adaptive PEBS without
 any adaptive counters
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20240306230153.786365-1-seanjc@google.com>
 <20240306230153.786365-4-seanjc@google.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20240306230153.786365-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/2024 7:01 am, Sean Christopherson wrote:
> If adaptive PEBS is supported, verify that only basic PEBS records are
> generated for counters without their ADAPTIVE flag set.  Per the SDM,
> adaptive records are generated if and only if both the per-counter flag
> *and* the global enable(s) in MSR_PEBS_DATA_CFG are set.
> 
>    IA32_PERFEVTSELx.Adaptive_Record[34]: If this bit is set and
>    IA32_PEBS_ENABLE.PEBS_EN_PMCx is set for the corresponding GP counter,
>    an overflow of PMCx results in generation of an adaptive PEBS record
>    with state information based on the selections made in MSR_PEBS_DATA_CFG.
>    If this bit is not set, a basic record is generated.
> 
> and
> 
>    IA32_FIXED_CTR_CTRL.FCx_Adaptive_Record: If this bit is set and
>    IA32_PEBS_ENABLE.PEBS_EN_FIXEDx is set for the corresponding Fixed
>    counter, an overflow of FixedCtrx results in generation of an adaptive
>    PEBS record with state information based on the selections made in
>    MSR_PEBS_DATA_CFG. If this bit is not set, a basic record is generated.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

This test case is awesome. Also, I checked that this part of the behaviour
has not changed since the first version of the specification description.

Reviewed-by: Like Xu <likexu@tencent.com>

> ---
>   x86/pmu_pebs.c | 74 ++++++++++++++++++++++++++------------------------
>   1 file changed, 38 insertions(+), 36 deletions(-)
> 
> diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
> index dff1ed26..0e8d60c3 100644
> --- a/x86/pmu_pebs.c
> +++ b/x86/pmu_pebs.c
> @@ -89,11 +89,11 @@ static u64 counter_start_values[] = {
>   	0xffffffffffff,
>   };
>   
> -static unsigned int get_adaptive_pebs_record_size(u64 pebs_data_cfg)
> +static unsigned int get_pebs_record_size(u64 pebs_data_cfg, bool use_adaptive)
>   {
>   	unsigned int sz = sizeof(struct pebs_basic);
>   
> -	if (!has_baseline)
> +	if (!use_adaptive)
>   		return sz;
>   
>   	if (pebs_data_cfg & PEBS_DATACFG_MEMINFO)
> @@ -199,10 +199,10 @@ static void free_buffers(void)
>   		free_page(pebs_buffer);
>   }
>   
> -static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
> +static void pebs_enable(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive)
>   {
>   	static struct debug_store *ds;
> -	u64 baseline_extra_ctrl = 0, fixed_ctr_ctrl = 0;
> +	u64 adaptive_ctrl = 0, fixed_ctr_ctrl = 0;
>   	unsigned int idx;
>   
>   	if (has_baseline)
> @@ -212,15 +212,15 @@ static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
>   	ds->pebs_index = ds->pebs_buffer_base = (unsigned long)pebs_buffer;
>   	ds->pebs_absolute_maximum = (unsigned long)pebs_buffer + PAGE_SIZE;
>   	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
> -		get_adaptive_pebs_record_size(pebs_data_cfg);
> +		get_pebs_record_size(pebs_data_cfg, use_adaptive);
>   
>   	for (idx = 0; idx < pmu.nr_fixed_counters; idx++) {
>   		if (!(BIT_ULL(FIXED_CNT_INDEX + idx) & bitmask))
>   			continue;
> -		if (has_baseline)
> -			baseline_extra_ctrl = BIT(FIXED_CNT_INDEX + idx * 4);
> +		if (use_adaptive)
> +			adaptive_ctrl = BIT(FIXED_CNT_INDEX + idx * 4);
>   		wrmsr(MSR_PERF_FIXED_CTRx(idx), ctr_start_val);
> -		fixed_ctr_ctrl |= (0xbULL << (idx * 4) | baseline_extra_ctrl);
> +		fixed_ctr_ctrl |= (0xbULL << (idx * 4) | adaptive_ctrl);
>   	}
>   	if (fixed_ctr_ctrl)
>   		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, fixed_ctr_ctrl);
> @@ -228,10 +228,10 @@ static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
>   	for (idx = 0; idx < max_nr_gp_events; idx++) {
>   		if (!(BIT_ULL(idx) & bitmask))
>   			continue;
> -		if (has_baseline)
> -			baseline_extra_ctrl = ICL_EVENTSEL_ADAPTIVE;
> +		if (use_adaptive)
> +			adaptive_ctrl = ICL_EVENTSEL_ADAPTIVE;
>   		wrmsr(MSR_GP_EVENT_SELECTx(idx), EVNTSEL_EN | EVNTSEL_OS | EVNTSEL_USR |
> -						 intel_arch_events[idx] | baseline_extra_ctrl);
> +						 intel_arch_events[idx] | adaptive_ctrl);
>   		wrmsr(MSR_GP_COUNTERx(idx), ctr_start_val);
>   	}
>   
> @@ -268,11 +268,11 @@ static void pebs_disable(unsigned int idx)
>   	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>   }
>   
> -static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
> +static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive)
>   {
>   	struct pebs_basic *pebs_rec = (struct pebs_basic *)pebs_buffer;
>   	struct debug_store *ds = (struct debug_store *)ds_bufer;
> -	unsigned int pebs_record_size = get_adaptive_pebs_record_size(pebs_data_cfg);
> +	unsigned int pebs_record_size;
>   	unsigned int count = 0;
>   	bool expected, pebs_idx_match, pebs_size_match, data_cfg_match;
>   	void *cur_record;
> @@ -293,12 +293,9 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
>   	do {
>   		pebs_rec = (struct pebs_basic *)cur_record;
>   		pebs_record_size = pebs_rec->format_size >> RECORD_SIZE_OFFSET;
> -		pebs_idx_match =
> -			pebs_rec->applicable_counters & bitmask;
> -		pebs_size_match =
> -			pebs_record_size == get_adaptive_pebs_record_size(pebs_data_cfg);
> -		data_cfg_match =
> -			(pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
> +		pebs_idx_match = pebs_rec->applicable_counters & bitmask;
> +		pebs_size_match = pebs_record_size == get_pebs_record_size(pebs_data_cfg, use_adaptive);
> +		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
>   		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
>   		report(expected,
>   		       "PEBS record (written seq %d) is verified (including size, counters and cfg).", count);
> @@ -311,56 +308,57 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
>   			printf("FAIL: The applicable_counters (0x%lx) doesn't match with pmc_bitmask (0x%lx).\n",
>   			       pebs_rec->applicable_counters, bitmask);
>   		if (!pebs_size_match)
> -			printf("FAIL: The pebs_record_size (%d) doesn't match with MSR_PEBS_DATA_CFG (%d).\n",
> -			       pebs_record_size, get_adaptive_pebs_record_size(pebs_data_cfg));
> +			printf("FAIL: The pebs_record_size (%d) doesn't match with expected record size (%d).\n",
> +			       pebs_record_size, get_pebs_record_size(pebs_data_cfg, use_adaptive));
>   		if (!data_cfg_match)
> -			printf("FAIL: The pebs_data_cfg (0x%lx) doesn't match with MSR_PEBS_DATA_CFG (0x%lx).\n",
> -			       pebs_rec->format_size & 0xffffffffffff, pebs_data_cfg);
> +			printf("FAIL: The pebs_data_cfg (0x%lx) doesn't match with the effective MSR_PEBS_DATA_CFG (0x%lx).\n",
> +			       pebs_rec->format_size & 0xffffffffffff, use_adaptive ? pebs_data_cfg : 0);
>   	}
>   }
>   
> -static void check_one_counter(enum pmc_type type,
> -			      unsigned int idx, u64 pebs_data_cfg)
> +static void check_one_counter(enum pmc_type type, unsigned int idx,
> +			      u64 pebs_data_cfg, bool use_adaptive)
>   {
>   	int pebs_bit = BIT_ULL(type == FIXED ? FIXED_CNT_INDEX + idx : idx);
>   
>   	report_prefix_pushf("%s counter %d (0x%lx)",
>   			    type == FIXED ? "Extended Fixed" : "GP", idx, ctr_start_val);
>   	reset_pebs();
> -	pebs_enable(pebs_bit, pebs_data_cfg);
> +	pebs_enable(pebs_bit, pebs_data_cfg, use_adaptive);
>   	workload();
>   	pebs_disable(idx);
> -	check_pebs_records(pebs_bit, pebs_data_cfg);
> +	check_pebs_records(pebs_bit, pebs_data_cfg, use_adaptive);
>   	report_prefix_pop();
>   }
>   
>   /* more than one PEBS records will be generated. */
> -static void check_multiple_counters(u64 bitmask, u64 pebs_data_cfg)
> +static void check_multiple_counters(u64 bitmask, u64 pebs_data_cfg,
> +				    bool use_adaptive)
>   {
>   	reset_pebs();
> -	pebs_enable(bitmask, pebs_data_cfg);
> +	pebs_enable(bitmask, pebs_data_cfg, use_adaptive);
>   	workload2();
>   	pebs_disable(0);
> -	check_pebs_records(bitmask, pebs_data_cfg);
> +	check_pebs_records(bitmask, pebs_data_cfg, use_adaptive);
>   }
>   
> -static void check_pebs_counters(u64 pebs_data_cfg)
> +static void check_pebs_counters(u64 pebs_data_cfg, bool use_adaptive)
>   {
>   	unsigned int idx;
>   	u64 bitmask = 0;
>   
>   	for (idx = 0; has_baseline && idx < pmu.nr_fixed_counters; idx++)
> -		check_one_counter(FIXED, idx, pebs_data_cfg);
> +		check_one_counter(FIXED, idx, pebs_data_cfg, use_adaptive);
>   
>   	for (idx = 0; idx < max_nr_gp_events; idx++)
> -		check_one_counter(GP, idx, pebs_data_cfg);
> +		check_one_counter(GP, idx, pebs_data_cfg, use_adaptive);
>   
>   	for (idx = 0; has_baseline && idx < pmu.nr_fixed_counters; idx++)
>   		bitmask |= BIT_ULL(FIXED_CNT_INDEX + idx);
>   	for (idx = 0; idx < max_nr_gp_events; idx += 2)
>   		bitmask |= BIT_ULL(idx);
>   	report_prefix_pushf("Multiple (0x%lx)", bitmask);
> -	check_multiple_counters(bitmask, pebs_data_cfg);
> +	check_multiple_counters(bitmask, pebs_data_cfg, use_adaptive);
>   	report_prefix_pop();
>   }
>   
> @@ -408,7 +406,7 @@ int main(int ac, char **av)
>   
>   	for (i = 0; i < ARRAY_SIZE(counter_start_values); i++) {
>   		ctr_start_val = counter_start_values[i];
> -		check_pebs_counters(0);
> +		check_pebs_counters(0, false);
>   		if (!has_baseline)
>   			continue;
>   
> @@ -419,7 +417,11 @@ int main(int ac, char **av)
>   				pebs_data_cfg |= ((MAX_NUM_LBR_ENTRY -1) << PEBS_DATACFG_LBR_SHIFT);
>   
>   			report_prefix_pushf("Adaptive (0x%lx)", pebs_data_cfg);
> -			check_pebs_counters(pebs_data_cfg);
> +			check_pebs_counters(pebs_data_cfg, true);
> +			report_prefix_pop();
> +
> +			report_prefix_pushf("Ignored Adaptive (0x%lx)", pebs_data_cfg);
> +			check_pebs_counters(pebs_data_cfg, false);
>   			report_prefix_pop();
>   		}
>   	}

