Return-Path: <kvm+bounces-11289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF178874BC9
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 11:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EF6A1C2175F
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 10:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C17212BF25;
	Thu,  7 Mar 2024 10:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZpFrp9NJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB9D8527D
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 10:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709805610; cv=none; b=fgZ4OeSUb9XmPhqhw0Z7GMcGU3yK2pjAQFCSY2jxM3XP52HOCDRHmD+5r0N2ggwKgHQmAsSfeHkGVS8tgbyYyZua0YaqNNdnDEgEHKDWhhjy6VTbvsg5cUGZf8kfqcWL7Y6rxEZYuqUeHL1A/PZt4BNhX90YTPzjWmZ1sT02Nig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709805610; c=relaxed/simple;
	bh=VBZbhynZP/YoW9lrIYmG9AK6R3+aW+whTlC4okMhH74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rEt6r42EVAmL8PGUfwmKCd5oToqGAqJKQQvWHo1jTiYKMZtNjNVmSNoX9uOb854e+L5ovI1/CuKtxdPSEb4kWw11wRawjUVV1O2vmSen6fmYSQwC3j1JZqH2D6J2JLfb1CDcasY1U7dGPvEj06dUIYM8xBXAUvmeHlll9toCBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZpFrp9NJ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709805609; x=1741341609;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VBZbhynZP/YoW9lrIYmG9AK6R3+aW+whTlC4okMhH74=;
  b=ZpFrp9NJ38mcqeAiEQbBU86yiS3pQ/PF8th8mbaY9ysnj4dl3g2Etitk
   qBE8/TTtZiF4iQJrxfxMS637Xrqj0dxBe9ldPRReXZuu2ibSbWUB9o3lb
   afon2v4sE2HkjwdGQyxTUkYLUGIh+vx6Cfj/9ornbwRCCLf8VtcVokYa4
   qu7jJgmv9y2Tos/XUXzyu44q/xXI8YF1CUTiotVMz0fHPtYdphjR6r+4D
   +tRITXgxij7KKJ4VicXYL2F2dLbnOvZzycCwtVWP93cSeoPZwlek/wjjP
   xlSYk7s/cfzk3norz+GRGwP9v5AvZCYbHgzaHg/JDI1YfxKX+cOn/Ui9+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4635123"
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="4635123"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 02:00:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="10127844"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 02:00:04 -0800
Message-ID: <66fcde26-0052-453e-bd97-eee7383025cc@linux.intel.com>
Date: Thu, 7 Mar 2024 18:00:00 +0800
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

After introducing the "Ignored adaptive" check and expanding the 
pebs_data_cfg, there would be almost 1800 test case, it's not easy to 
read the test output and locate a certain test case, we'd better add 
extra print at the beginning of each start_value to distinguish them.


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

