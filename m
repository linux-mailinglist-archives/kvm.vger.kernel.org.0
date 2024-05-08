Return-Path: <kvm+bounces-17066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 523448C0683
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 23:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E755283123
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 21:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672FF1327FE;
	Wed,  8 May 2024 21:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RTyjqf0v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBA738DF2;
	Wed,  8 May 2024 21:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715204893; cv=none; b=MmFDCYY68R/HIDCMyicAb+fgUcaSgVIEGjxIT1I7kIXKmsmKqhzDHoV3Y6iLJivGN1nyWytG6RRp0nzS4YETCuF1R8f9w7w/aFVhe+BURZSVSYix5auLqfowZ6FFtqZVoYRM141af+qrf4yUhHj1Emn8xVDx/EqrzMu1O2M9Auk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715204893; c=relaxed/simple;
	bh=Yplu8PkGhAUTWx6zGSpEd/x3mJqVx0M8Qy6LAVGi0Ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=raY0CkCzFgU/Kv1n1MYdz7O/6afAsYNUYA+yFyoeOGoQImPWFdH3Td/1kuwPKphBSM1IkFj3CO7Nc/XZvyaNGb491F4+Ut8XVfrqDCj3bgZxvQqDEm+KBU6O4yIybpsfuX649xXPiSThmONF/2jjQ99UMMXwyLqjn4yENe5VMpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RTyjqf0v; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715204891; x=1746740891;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yplu8PkGhAUTWx6zGSpEd/x3mJqVx0M8Qy6LAVGi0Ds=;
  b=RTyjqf0vMDiavzIAD/C3Nxl79b4fso38rrnNzoOq5xRlirkNkU4SuA+y
   E7H6RIZSMONs4XxzFJjQeV2P7NFD4+NSjkJ9iynzOjHwTXi0q7rpFAZ6j
   kK7+hQi5T+2//NvydFFwOLKBDzDTvbcxyC12J1T21ucoWsa9ZenVqtNVG
   auEEog4diIcu7oMS1n3uCb3ueuQ+iGlvfw2QGMY3M0eZJ5hxHRkihjLka
   oMKEeuzAphDAe7M5Sw2+3Iu39VfmHwuEWTj962/U+gFTf89pd56Vk7pXu
   u5Km7gamPPuuPok2HVMUZ7V66PHwHyLsVHvWc4vc50Mwj+hL88Ng6dTUq
   A==;
X-CSE-ConnectionGUID: vC33YPQmQKuOe4DcPeHIPw==
X-CSE-MsgGUID: v4kiqk9BQEi108oBwnOj9w==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11219329"
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="11219329"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 14:48:11 -0700
X-CSE-ConnectionGUID: Wg+DWhXQSvaCH2ALLEGu3Q==
X-CSE-MsgGUID: mXbtvMDCQOmZ//2m7XM+Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="28965661"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.50]) ([10.24.10.50])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 14:48:09 -0700
Message-ID: <d19e06e7-ed97-4361-a628-014e5670cf22@intel.com>
Date: Wed, 8 May 2024 14:48:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/54] KVM: x86/pmu: Avoid legacy vPMU code when
 accessing global_ctrl in passthrough vPMU
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-27-mizhang@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240506053020.3911940-27-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
> Avoid calling into legacy/emulated vPMU logic such as reprogram_counters()
> when passthrough vPMU is enabled. Note that even when passthrough vPMU is
> enabled, global_ctrl may still be intercepted if guest VM only sees a
> subset of the counters.
> 
> Suggested-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/pmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index bd94f2d67f5c..e9047051489e 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -713,7 +713,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (pmu->global_ctrl != data) {
>  			diff = pmu->global_ctrl ^ data;
>  			pmu->global_ctrl = data;
> -			reprogram_counters(pmu, diff);
> +			if (!is_passthrough_pmu_enabled(vcpu))
> +				reprogram_counters(pmu, diff);

Since in [PATCH 44/54], reprogram_counters() is effectively skipped in
the passthrough case, is this patch still needed?

>  		}
>  		break;
>  	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:

