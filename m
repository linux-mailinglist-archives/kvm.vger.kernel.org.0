Return-Path: <kvm+bounces-5664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED34824794
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 18:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 052A2B22171
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 17:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83B328DBA;
	Thu,  4 Jan 2024 17:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VAVOj3qk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9E3286B3;
	Thu,  4 Jan 2024 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704389921; x=1735925921;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3udya00K0HYS8sw10m47vAtCLMcEtftTF6aI4a13CZA=;
  b=VAVOj3qkc58j39ZI7yc7iHNBLIhn578HeILANvRb4sXLNgU2FR8a2gbN
   9/fVnkhSLaTQW3r/9bGKAA3myE8edsZ2q6DQVXgz61PxAZH+XtMMNvK71
   sgaL5LnPWnV5Q6dmBSsuYdjlf7DRPb1aFSTVrDtwjXhjLU/leHmYgFuFq
   1bJXCawVxNxBmqmZDJcR9Qlm+KwCETHJopkyp53N8006cMMfZjzsjZpmW
   XOMHJJ+8Q6dmtTm3fCb4jGzs1utuT72fbU8PIUhu9RTIxQKQi628FW0qU
   EtdJNCTlmx1O4gYZcZ53VB1gZ5MTxkokTkD6J55iSLYFlUEEnoScrnveD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="401101398"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="401101398"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 09:38:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="14972645"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 09:38:40 -0800
Received: from [10.209.154.172] (kliang2-mobl1.ccr.corp.intel.com [10.209.154.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id CD27B580BF8;
	Thu,  4 Jan 2024 09:38:37 -0800 (PST)
Message-ID: <a327286a-36a6-4cdc-92bd-777fb763d88a@linux.intel.com>
Date: Thu, 4 Jan 2024 12:38:36 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/pmu: fix masking logic for
 MSR_CORE_PERF_GLOBAL_CTRL
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: peterz@infradead.org, linux-perf-users@vger.kernel.org,
 leitao@debian.org, acme@kernel.org, mingo@redhat.com,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org,
 Like Xu <like.xu.linux@gmail.com>
References: <20240104153939.129179-1-pbonzini@redhat.com>
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20240104153939.129179-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-01-04 10:39 a.m., Paolo Bonzini wrote:
> When commit c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE
> MSR emulation for extended PEBS") switched the initialization of
> cpuc->guest_switch_msrs to use compound literals, it screwed up
> the boolean logic:
> 
> +	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
> ...
> -	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> -	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
> +               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> 
> Before the patch, the value of arr[0].guest would have been intel_ctrl &
> ~cpuc->intel_ctrl_host_mask & ~pebs_mask.  The intent is to always treat
> PEBS events as host-only because, while the guest runs, there is no way
> to tell the processor about the virtual address where to put PEBS records
> intended for the host.
> 
> Unfortunately, the new expression can be expanded to
> 
> 	(intel_ctrl & ~cpuc->intel_ctrl_host_mask) | (intel_ctrl & ~pebs_mask)
> 
> which makes no sense; it includes any bit that isn't *both* marked as
> exclude_guest and using PEBS.  So, reinstate the old logic.  

I think the old logic will completely disable the PEBS in guest
capability. Because the counter which is assigned to a guest PEBS event
will also be set in the pebs_mask. The old logic disable the counter in
GLOBAL_CTRL in guest. Nothing will be counted.

Like once proposed a fix in the intel_guest_get_msrs().
https://lore.kernel.org/lkml/20231129095055.88060-1-likexu@tencent.com/
It should work for the issue.

Ideally, we should prevent the host PEBS from profiling a guest via
rejecting the event creation in the perf. But I couldn't find a good way
to distinguish host-created PEBS and guest-created PEBS. So Like's
proposal should be a good alternative so far.

Thanks,
Kan

> Another
> way to write it could be "intel_ctrl & ~(cpuc->intel_ctrl_host_mask |
> pebs_mask)", presumably the intention of the author of the faulty.
> However, I personally find the repeated application of A AND NOT B to
> be a bit more readable.
> 
> This shows up as guest failures when running concurrent long-running
> perf workloads on the host, and was reported to happen with rcutorture.
> All guests on a given host would die simultaneously with something like an
> instruction fault or a segmentation violation.
> 
> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> Analyzed-by: Sean Christopherson <seanjc@google.com>
> Tested-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/events/intel/core.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index ce1c777227b4..0f2786d4e405 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -4051,12 +4051,17 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
>  	int global_ctrl, pebs_enable;
>  
> +	/*
> +	 * In addition to obeying exclude_guest/exclude_host, remove bits being
> +	 * used for PEBS when running a guest, because PEBS writes to virtual
> +	 * addresses (not physical addresses).
> +	 */
>  	*nr = 0;
>  	global_ctrl = (*nr)++;
>  	arr[global_ctrl] = (struct perf_guest_switch_msr){
>  		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
>  		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> -		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> +		.guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask & ~pebs_mask,
>  	};
>  
>  	if (!x86_pmu.pebs)

