Return-Path: <kvm+bounces-11243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B149C8745A7
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 02:33:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A0E2285C9A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 01:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3C14C9B;
	Thu,  7 Mar 2024 01:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KF2OKjJN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F01F17FF;
	Thu,  7 Mar 2024 01:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709775183; cv=none; b=U+ZNkXyGE+PvB6mPN2DfGGbihU0Fp/pW28Lb0tOc7mUy73OJ34f7HV2Di7GHJUyHe3euZdxJjtBS1jsGtx4SKExZVP0US/TCyOFyOnnLK7H0dsC8fHKJRkbdjhd6SZ5cZCJ5zEk7iEI0Hz67JdS73MxLlGpAffqGAJFPUzR05Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709775183; c=relaxed/simple;
	bh=mjmYP687cuzepXscK5lOXpxeHVtnf7bE0v5IA6pa3qY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jw0kJrQC41J+Gmv3ZRHAWYHOJ68eAa33s9tNvuJThXAD4bUQPYoubM/SC1ik6iogwWUzVc5Y8KYAjpOajaO+iEhDNndaxOGV7RZPWe1dPeQFi4it9pPZulN4KZldCKzdmmqv0sWG0RNivLRRz/4Yaeu4u3+JAgGIVmKsl1ycj0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KF2OKjJN; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709775181; x=1741311181;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mjmYP687cuzepXscK5lOXpxeHVtnf7bE0v5IA6pa3qY=;
  b=KF2OKjJNKiAwZNr8jdqN2I+G46CFnFEz8AObEq6nDHG6+95UW6uUtbUG
   YnFPbcONJm7LlIi5S5svotIR3NUCBsR/NvxrYu5lNMzq0Gh/V/U002l91
   w9LAUEwDDbzwZZZDSqJxl58Ck8HI1V9JX397hmShPSv/9dLJCbE6HC8JK
   pHrR3fRo0GwH73Ju/iH5k1pQQzKUd799cDxARYh9yOHNsvGHNiLFAqIBf
   9n615jdPvorZQmKuwmzDde0IyI6jfm3/F8GREpQX/xm+TJkI2zSohYNu3
   Fglq0T1npK0QahmIkgzmWNc7++pkGdD7PchRFH2Q9XokIWqBjvk5F+0gB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="8241266"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="8241266"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 17:33:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="10015044"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 17:32:58 -0800
Message-ID: <ce74e815-6979-4ac3-9ec2-43f982da9f7c@linux.intel.com>
Date: Thu, 7 Mar 2024 09:32:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/pmu: Disable support for adaptive PEBS
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong
 <xiong.y.zhang@intel.com>, Lv Zhiyuan <zhiyuan.lv@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Jim Mattson <jmattson@google.com>
References: <20240307005833.827147-1-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240307005833.827147-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/7/2024 8:58 AM, Sean Christopherson wrote:
> Drop support for virtualizing adaptive PEBS, as KVM's implementation is
> architecturally broken without an obvious/easy path forward, and because
> exposing adaptive PEBS can leak host LBRs to the guest, i.e. can leak
> host kernel addresses to the guest.
>
> Bug #1 is that KVM doesn't doesn't account for the upper 32 bits of

"doesn't doesn't" -> "doesn't"?


> IA32_FIXED_CTR_CTRL when (re)programming fixed counters, e.g
> fixed_ctrl_field() drops the upper bits, reprogram_fixed_counters()
> stores local variables as u8s and truncates the upper bits too, etc.
>
> Bug #2 is that, because KVM _always_ sets precise_ip to a non-zero value
> for PEBS events, perf will _always_ generate an adaptive record, even if
> the guest requested a basic record.  Note, KVM will also enable adaptive
> PEBS in individual *counter*, even if adaptive PEBS isn't exposed to the
> guest, but this is benign as MSR_PEBS_DATA_CFG is guaranteed to be zero,
> i.e. the guest will only ever see Basic records.
>
> Bug #3 is in perf.  intel_pmu_disable_fixed() doesn't clear the upper
> bits either, i.e. leaves ICL_FIXED_0_ADAPTIVE set, and
> intel_pmu_enable_fixed() effectively doesn't clear ICL_FIXED_0_ADAPTIVE
> either.  I.e. perf _always_ enables ADAPTIVE counters, regardless of what
> KVM requests.

I would talk with Liang Kan and prepare a patch to clear the 
"adaptive_pebs" bit when disabling GP & fixed counters.


>
> Bug #4 is that adaptive PEBS *might* effectively bypass event filters set
> by the host, as "Updated Memory Access Info Group" records information
> that might be disallowed by userspace via KVM_SET_PMU_EVENT_FILTER.
>
> Bug #5 is that KVM doesn't ensure LBR MSRs hold guest values (or at least
> zeros) when entering a vCPU with adaptive PEBS, which allows the guest
> to read host LBRs, i.e. host RIPs/addresses, by enabling "LBR Entries"
> records.
>
> Disable adaptive PEBS support as an immediate fix due to the severity of
> the LBR leak in particular, and because fixing all of the bugs will be
> non-trivial, e.g. not suitable for backporting to stable kernels.
>
> Note!  This will break live migration, but trying to make KVM play nice
> with live migration would be quite complicated, wouldn't be guaranteed to
> work (i.e. KVM might still kill/confuse the guest), and it's not clear
> that there are any publicly available VMMs that support adaptive PEBS,
> let alone live migrate VMs that support adaptive PEBS, e.g. QEMU doesn't
> support PEBS in any capacity.
>
> Link: https://lore.kernel.org/all/20240306230153.786365-1-seanjc@google.com
> Link: https://lore.kernel.org/all/ZeepGjHCeSfadANM@google.com
> Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
> Cc: stable@vger.kernel.org
> Cc: Like Xu <like.xu.linux@gmail.com>
> Cc: Mingwei Zhang <mizhang@google.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhang Xiong <xiong.y.zhang@intel.com>
> Cc: Lv Zhiyuan <zhiyuan.lv@intel.com>
> Cc: Dapeng Mi <dapeng1.mi@intel.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 24 ++++++++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7a74388f9ecf..641a7d5bf584 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7864,8 +7864,28 @@ static u64 vmx_get_perf_capabilities(void)
>   
>   	if (vmx_pebs_supported()) {
>   		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
> -		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
> -			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
> +
> +		/*
> +		 * Disallow adaptive PEBS as it is functionally broken, can be
> +		 * used by the guest to read *host* LBRs, and can be used to
> +		 * bypass userspace event filters.  To correctly and safely
> +		 * support adaptive PEBS, KVM needs to:
> +		 *
> +		 * 1. Account for the ADAPTIVE flag when (re)programming fixed
> +		 *    counters.
> +		 *
> +		 * 2. Gain support from perf (or take direct control of counter
> +		 *    programming) to support events without adaptive PEBS
> +		 *    enabled for the hardware counter.
> +		 *
> +		 * 3. Ensure LBR MSRs cannot hold host data on VM-Entry with
> +		 *    adaptive PEBS enabled and MSR_PEBS_DATA_CFG.LBRS=1.
> +		 *
> +		 * 4. Document which PMU events are effectively exposed to the
> +		 *    guest via adaptive PEBS, and make adaptive PEBS mutually
> +		 *    exclusive with KVM_SET_PMU_EVENT_FILTER if necessary.
> +		 */
> +		perf_cap &= ~PERF_CAP_PEBS_BASELINE;
>   	}
>   
>   	return perf_cap;
>
> base-commit: 0c64952fec3ea01cb5b09f00134200f3e7ab40d5

