Return-Path: <kvm+bounces-11287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A908874ADA
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 10:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EC4D1C21317
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A903583A0B;
	Thu,  7 Mar 2024 09:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IzprY2yf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1FB76C8D
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 09:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709803733; cv=none; b=AM4RHULwCDG7MT0TuuS4Y1eJM/3KmjmXXnNgrurWDNeIMYPNR0DFeIdu7A3c5FHbE88S3HaWpCfevvPMrIiL0vDxGcisbHSPAks2D02CcYT4vN4Q5KRh7v7X/9V4rjDOdiF0TMWcMJyPLYxLeQbCOAEPi7xEsJ9JObvC7njj4oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709803733; c=relaxed/simple;
	bh=qp8iie7LZUhNJXlE/8m7+RM+vwScs3ihit2dY+zi6hM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lvN49NRIY1SNMUB7RKT9moKuZfBGocdP2w7BO8o06nISLHFzq0gu/cE/ywh2yDA/lbVA+3FIDROnH/qcukFucxx6GOfKbIZcmJdFLr0SKgFnN71a+z8cOmiGbB877X5aW201lEmu/QzX8YaXlUJeZCxX33vRu6x/Mi8ud1vQXiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IzprY2yf; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709803732; x=1741339732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qp8iie7LZUhNJXlE/8m7+RM+vwScs3ihit2dY+zi6hM=;
  b=IzprY2yfe69OtC9DZuWd0CYwT2HIidPbLwYYg3d/VU6rSMUiiIHXsukg
   RYFBQstopuFJ2rk9mlfnxlPObDI9HaNIA0xX1Ho3KMBVYT7dbFMOK5HDZ
   w4x/BUAOLiFj3XaZcVPbY1Mqi3M+B65NUKTpxm3dJ+FZ20dGChJtURTgO
   itAzx9h0wBKaWhCV3hw0QXu+4yaIzzdaVmOk7DLw5LSOg/DdzjroVYZvC
   W7oTxLmJvAHMLMaYqVv1hUw2Sy55OactWGXrksOoJWgAY+3WUKTgIDyDw
   f2sg+wiE1jakIwu3bAYPjuiKQsnPXePLdnFcqSc0c2rwkpd9cKM+FENFo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="8222297"
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="8222297"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 01:28:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="10139661"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 01:28:49 -0800
Message-ID: <0624663e-ea7c-470f-ab34-c934a9ab31be@linux.intel.com>
Date: Thu, 7 Mar 2024 17:28:46 +0800
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
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>,
 Mingwei Zhang <mizhang@google.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Zhang Xiong <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>
References: <20240306230153.786365-1-seanjc@google.com>
 <20240306230153.786365-4-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240306230153.786365-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/7/2024 7:01 AM, Sean Christopherson wrote:
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

Since there is already a macro RECORD_SIZE_OFFSET, we'd better use 
"RECORD_SIZE_OFFSET - 1" to replace the magic number 47.


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
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

