Return-Path: <kvm+bounces-16961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E40E28BF534
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:19:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8D2B285D64
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 04:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F08E16419;
	Wed,  8 May 2024 04:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/0/iP7L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EFD8F6C;
	Wed,  8 May 2024 04:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715141947; cv=none; b=FOUfvuKCH3wV1RyNePueCrwmBquf4sHfe4w5SFEnenh6HArMSKsMBpDX1xWGU3yLjQSkZarRlllK1WIPGufbPEgKRL6LOK2gSVVwQwhYTUqtqwrkoaYBcXmlB1xr7ijcsHPesg5JvQSwNxB6Phy48ZwFefd/KYRyi5iKPQu+kx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715141947; c=relaxed/simple;
	bh=PA0FG8h64ouTNuuBxW1825vkEfAWFhuYHn+EgyIJNdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s6y5+9lMfgPZ91zAQhrhxoiCsHeJsoWENSQqNYjXGC2rV3hhbCvxz50hg8PMtNeh6wfw4PlDldeUy/D0umEDPeU9hClUHizM+5Bt03aJsDeRY8NwGUgD01mjSwH1yx1tE4Tu3jFWp7/BQZYYoO/8cQiZ4r8qliXnLR/FmPnpIRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/0/iP7L; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715141946; x=1746677946;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PA0FG8h64ouTNuuBxW1825vkEfAWFhuYHn+EgyIJNdE=;
  b=i/0/iP7LJO+F9mG6CUjv0Fcc8I+lazJeAgCTmuf5IoCEqwUdDZwV+WB1
   /ATZ7egRLMntfhLEJDjorDu9znRRugqPJZSnxCo2+hS5zfQ3PYsC9Iann
   IUMyNA3R56CO0MqNKttSw9ldxp6KxtCmbOVvl19JoSoLerepnn9szDDjj
   P76koQm4HAlcHQ97IQtYiFnTbJvl+CUljNq3/a+3eRJHM8t33153/kwFN
   r80qrzTwD/LemFuuEayMlctHUT6S9dBwSfX4PkdnJH6gk1+HDt8lXKOiG
   W8FA/PB2QJ4FrIoowpHllQIIoggH80bWTZFluMsnPZWcnRBmJ5xc16hX/
   g==;
X-CSE-ConnectionGUID: Arv4Jwa0RUSF4XmAZ76rvg==
X-CSE-MsgGUID: Zhh812dUSFaD+xPzQ/0Gbw==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="11421637"
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="11421637"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 21:19:05 -0700
X-CSE-ConnectionGUID: leyrursISkGD4qZRF5pLKg==
X-CSE-MsgGUID: dg8aogLSSH+7yfzMvYP/Mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,144,1712646000"; 
   d="scan'208";a="28845054"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 21:19:00 -0700
Message-ID: <3eb01add-3776-46a8-87f7-54144692d7d7@linux.intel.com>
Date: Wed, 8 May 2024 12:18:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/54] KVM: x86/pmu: Always set global enable bits in
 passthrough mode
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-18-mizhang@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240506053020.3911940-18-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/6/2024 1:29 PM, Mingwei Zhang wrote:
> From: Sandipan Das <sandipan.das@amd.com>
>
> Currently, the global control bits for a vcpu are restored to the reset
> state only if the guest PMU version is less than 2. This works for
> emulated PMU as the MSRs are intercepted and backing events are created
> for and managed by the host PMU [1].
>
> If such a guest in run with passthrough PMU, the counters no longer work
> because the global enable bits are cleared. Hence, set the global enable
> bits to their reset state if passthrough PMU is used.
>
> A passthrough-capable host may not necessarily support PMU version 2 and
> it can choose to restore or save the global control state from struct
> kvm_pmu in the PMU context save and restore helpers depending on the
> availability of the global control register.
>
> [1] 7b46b733bdb4 ("KVM: x86/pmu: Set enable bits for GP counters in PERF_GLOBAL_CTRL at "RESET"");
> Reported-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> [removed the fixes tag]
> ---
>  arch/x86/kvm/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 5768ea2935e9..e656f72fdace 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -787,7 +787,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  	 * in the global controls).  Emulate that behavior when refreshing the
>  	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
>  	 */
> -	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)
> +	if ((pmu->passthrough || kvm_pmu_has_perf_global_ctrl(pmu)) && pmu->nr_arch_gp_counters)

The logic seems not correct. we could support perfmon version 1 for
meidated vPMU (passthrough vPMU) as well in the future.  pmu->passthrough
is ture doesn't guarantee GLOBAL_CTRL MSR always exists.


>  		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
>  }
>  

