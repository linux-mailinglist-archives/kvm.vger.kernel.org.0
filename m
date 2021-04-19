Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BCB363D29
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 10:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbhDSILw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 04:11:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5137 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhDSILv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 04:11:51 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FNzx14r1WzYXv3;
        Mon, 19 Apr 2021 16:09:09 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 19 Apr 2021 16:11:19 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 19 Apr 2021 16:11:19 +0800
Subject: Re: [PATCH v5 06/16] KVM: x86/pmu: Reprogram PEBS event to emulate
 guest PEBS counter
To:     Like Xu <like.xu@linux.intel.com>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
References: <20210415032016.166201-1-like.xu@linux.intel.com>
 <20210415032016.166201-7-like.xu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <607D3B26.5020904@huawei.com>
Date:   Mon, 19 Apr 2021 16:11:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20210415032016.166201-7-like.xu@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/15 11:20, Like Xu wrote:
> When a guest counter is configured as a PEBS counter through
> IA32_PEBS_ENABLE, a guest PEBS event will be reprogrammed by
> configuring a non-zero precision level in the perf_event_attr.
>
> The guest PEBS overflow PMI bit would be set in the guest
> GLOBAL_STATUS MSR when PEBS facility generates a PEBS
> overflow PMI based on guest IA32_DS_AREA MSR.
>
> Even with the same counter index and the same event code and
> mask, guest PEBS events will not be reused for non-PEBS events.
>
> Originally-by: Andi Kleen <ak@linux.intel.com>
> Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/pmu.c | 34 ++++++++++++++++++++++++++++++++--
>   1 file changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 827886c12c16..0f86c1142f17 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -74,11 +74,21 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
>   {
>   	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
>   	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +	bool skip_pmi = false;
>   
>   	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
> -		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> +		if (perf_event->attr.precise_ip) {
> +			/* Indicate PEBS overflow PMI to guest. */
> +			skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
> +						      (unsigned long *)&pmu->global_status);
> +		} else {
> +			__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> +		}
>   		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>   
> +		if (skip_pmi)
> +			return;
> +
>   		/*
>   		 * Inject PMI. If vcpu was in a guest mode during NMI PMI
>   		 * can be ejected on a guest mode re-entry. Otherwise we can't
> @@ -99,6 +109,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>   				  bool exclude_kernel, bool intr,
>   				  bool in_tx, bool in_tx_cp)
>   {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
>   	struct perf_event *event;
>   	struct perf_event_attr attr = {
>   		.type = type,
> @@ -110,6 +121,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>   		.exclude_kernel = exclude_kernel,
>   		.config = config,
>   	};
> +	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
>   

pebs_enable is defined in patch 07, but used here(in patch 06).
Maybe we can change the patches order in next patch version if necessary.

>   	attr.sample_period = get_sample_period(pmc, pmc->counter);
>   
> @@ -124,9 +136,23 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>   		attr.sample_period = 0;
>   		attr.config |= HSW_IN_TX_CHECKPOINTED;
>   	}
> +	if (pebs) {
> +		/*
> +		 * The non-zero precision level of guest event makes the ordinary
> +		 * guest event becomes a guest PEBS event and triggers the host
> +		 * PEBS PMI handler to determine whether the PEBS overflow PMI
> +		 * comes from the host counters or the guest.
> +		 *
> +		 * For most PEBS hardware events, the difference in the software
> +		 * precision levels of guest and host PEBS events will not affect
> +		 * the accuracy of the PEBS profiling result, because the "event IP"
> +		 * in the PEBS record is calibrated on the guest side.
> +		 */
> +		attr.precise_ip = 1;
> +	}
>   
>   	event = perf_event_create_kernel_counter(&attr, -1, current,
> -						 intr ? kvm_perf_overflow_intr :
> +						 (intr || pebs) ? kvm_perf_overflow_intr :
>   						 kvm_perf_overflow, pmc);
>   	if (IS_ERR(event)) {
>   		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
> @@ -161,6 +187,10 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>   			      get_sample_period(pmc, pmc->counter)))
>   		return false;
>   
> +	if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
> +	    pmc->perf_event->attr.precise_ip)
> +		return false;
> +
>   	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
>   	perf_event_enable(pmc->perf_event);
>   

