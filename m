Return-Path: <kvm+bounces-25656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83121968115
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 09:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 347F4280F46
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 07:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8A118595B;
	Mon,  2 Sep 2024 07:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j6L36sKh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B59183088;
	Mon,  2 Sep 2024 07:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725263770; cv=none; b=XqWtm6WZdSjA2h1WEOyG3alRfQrhxpCuY8o6e/7jKNmiT4FV3iSR+DLa94+6Y0zdGElDNLbny6AJGHWDWcBBKtkInw3kItwbw0tEV8ig3kZpKknNXXxq57MTEjkAaKu9ww/Tf+wE8Tm6W1jQbSoF9gpSpqVBZWWOrcYr+dD7cM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725263770; c=relaxed/simple;
	bh=mNVd9yMxaPlxyRQ5E4mBicL71m6tQvJDfRSneOUiyUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tTY9A4jcAotzLYys3GAdLrpd1tQiqu+w9IwWdBrBowHQVWlBIGgk7cW5r5Q5P7Jr/Im5xlmqGEB+c3sFXI4L+8dwDpUDd5yJS4/hqKPAAkYxx1CLmsWK9aVhQpmtJw2kbPeFmyFYv4t/O4d7QnPgql8WQcsaoChz92dQERDK/4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j6L36sKh; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725263769; x=1756799769;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mNVd9yMxaPlxyRQ5E4mBicL71m6tQvJDfRSneOUiyUI=;
  b=j6L36sKhbeU9bMQ/Vq39lWOsaQN6sFU006qEZ59Mhg+yOOXugjbAO3rk
   RyrTLbuDEjQWrkhxxUzCLLdzSV/f9JBsLtuWS8nHcvEZTFnk7+s4vK+xL
   BUmq1WnTfb42k/2wTYpcn6YtRzbvcHhWdatp4On8Gqmr9i1I/Si0rmNls
   aRbnHzWi29DyhswtYihPaEjbLNZeoPpiins9S8PUeE2EFUtebhEj8RWoR
   eDYwBmNfItYPaAArnQIbw17LEFJGnqZ0nJ18cEiO0x94IXYcTk5Qfyzt7
   pGa54e2C/mp7sKC4DaL3ceMLfw76cfbWImq2cyf5/KfEIo2ThrVicmWyI
   A==;
X-CSE-ConnectionGUID: vAQQH+A8QpCiEYgv6syxUQ==
X-CSE-MsgGUID: poyKx7iORiSR7mJNf2SdQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="23708472"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="23708472"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 00:56:08 -0700
X-CSE-ConnectionGUID: RgNGk6W5RvC0iMQ7EfpUYw==
X-CSE-MsgGUID: g0s6D3ZhQ3+Z8kGNO9J0eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="65257887"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.233.125]) ([10.124.233.125])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 00:56:03 -0700
Message-ID: <79bef05f-34f8-4540-ae64-f1aa8e2b9f63@linux.intel.com>
Date: Mon, 2 Sep 2024 15:56:00 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 16/58] perf/x86: Forbid PMI handler when guest own
 PMU
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-17-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240801045907.4010984-17-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
> If a guest PMI is delivered after VM-exit, the KVM maskable interrupt will
> be held pending until EFLAGS.IF is set. In the meantime, if the logical
> processor receives an NMI for any reason at all, perf_event_nmi_handler()
> will be invoked. If there is any active perf event anywhere on the system,
> x86_pmu_handle_irq() will be invoked, and it will clear
> IA32_PERF_GLOBAL_STATUS. By the time KVM's PMI handler is invoked, it will
> be a mystery which counter(s) overflowed.
>
> When LVTPC is using KVM PMI vecotr, PMU is owned by guest, Host NMI let
> x86_pmu_handle_irq() run, x86_pmu_handle_irq() restore PMU vector to NMI
> and clear IA32_PERF_GLOBAL_STATUS, this breaks guest vPMU passthrough
> environment.
>
> So modify perf_event_nmi_handler() to check perf_in_guest per cpu variable,
> and if so, to simply return without calling x86_pmu_handle_irq().
>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/events/core.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index b17ef8b6c1a6..cb5d8f5fd9ce 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -52,6 +52,8 @@ DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
>  	.pmu = &pmu,
>  };
>  
> +DEFINE_PER_CPU(bool, pmi_vector_is_nmi) = true;
> +
>  DEFINE_STATIC_KEY_FALSE(rdpmc_never_available_key);
>  DEFINE_STATIC_KEY_FALSE(rdpmc_always_available_key);
>  DEFINE_STATIC_KEY_FALSE(perf_is_hybrid);
> @@ -1733,6 +1735,24 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
>  	u64 finish_clock;
>  	int ret;
>  
> +	/*
> +	 * When guest pmu context is loaded this handler should be forbidden from
> +	 * running, the reasons are:
> +	 * 1. After perf_guest_enter() is called, and before cpu enter into
> +	 *    non-root mode, NMI could happen, but x86_pmu_handle_irq() restore PMU
> +	 *    to use NMI vector, which destroy KVM PMI vector setting.
> +	 * 2. When VM is running, host NMI other than PMI causes VM exit, KVM will
> +	 *    call host NMI handler (vmx_vcpu_enter_exit()) first before KVM save
> +	 *    guest PMU context (kvm_pmu_save_pmu_context()), as x86_pmu_handle_irq()
> +	 *    clear global_status MSR which has guest status now, then this destroy
> +	 *    guest PMU status.
> +	 * 3. After VM exit, but before KVM save guest PMU context, host NMI other
> +	 *    than PMI could happen, x86_pmu_handle_irq() clear global_status MSR
> +	 *    which has guest status now, then this destroy guest PMU status.
> +	 */
> +	if (!this_cpu_read(pmi_vector_is_nmi))
> +		return 0;

0 -> NMI_DONE


> +
>  	/*
>  	 * All PMUs/events that share this PMI handler should make sure to
>  	 * increment active_events for their events.
> @@ -2675,11 +2695,14 @@ static bool x86_pmu_filter(struct pmu *pmu, int cpu)
>  
>  static void x86_pmu_switch_interrupt(bool enter, u32 guest_lvtpc)
>  {
> -	if (enter)
> +	if (enter) {
>  		apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
>  			   (guest_lvtpc & APIC_LVT_MASKED));
> -	else
> +		this_cpu_write(pmi_vector_is_nmi, false);
> +	} else {
>  		apic_write(APIC_LVTPC, APIC_DM_NMI);
> +		this_cpu_write(pmi_vector_is_nmi, true);
> +	}
>  }
>  
>  static struct pmu pmu = {

