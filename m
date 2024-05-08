Return-Path: <kvm+bounces-17036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 862A58C0453
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 20:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 265F21F248B6
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 18:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D9512C497;
	Wed,  8 May 2024 18:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="igQy+7/1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9807654FAA;
	Wed,  8 May 2024 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715192890; cv=none; b=dihFrhMjJkU6a+n+Npm3fRM0ZNKyF3YNOxDFH4mgcVucRZGbOnBQv22KPt3MXG1ro1Z86X/TbZ9no3yIdVBkXVJlYPLAP3ISypZOuAUPHC095jFWeaLL2rVwVr++wBt/6HIT80S+qot4mtSYGICs1tB8Um0npDlhADxs6okbtRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715192890; c=relaxed/simple;
	bh=I3pkgfo8nvJpvZengN4XKNm18uahoQGeq70WkuA0SCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R+/ePcPslQLOHNHlikQg+uPE5AkoPnmNdN9fbl2jc2fkYLDyMGdkxqwRkdP82sxDoLMAZIM6nnWwZqjYLupLSdzYF3fdHKFaZhxNpLcbZSFlrqgtpbiCNDISs59oCXxg/zDA/Rxfwh75EoVbh+fEqiwUyDCiUsD/jIZ1b5uye+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=igQy+7/1; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715192888; x=1746728888;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I3pkgfo8nvJpvZengN4XKNm18uahoQGeq70WkuA0SCg=;
  b=igQy+7/1CzJo9Bof2j5q7T4wtog5V4foF3BhUErnnyiXdivbLCl1OLiS
   TcyszutTTnWTqcGgd40R5MhwR6UtZZDIPlq86dvatFmdPUoQkBLwPoDUN
   DtzbkmRLDg5g8ZzIVayBg0ok1Cpb076G5jP5gHBSl8AYhcYXRGmdvILZ0
   99xQt3bn/xDRbYB2V/HKFbaX7U5SvmBD2l01I9wUtA0Fwz+9iI5In+Ev1
   DQkbCJYcFho/CZEVh/2W18+o1CuTZ4ynRjoinDCMJ07sb76PlUeEKtVP2
   OouMzwty8syfRQByH3vZkIQXtV614sqy5SXv1XwNOtN3gxAh7x67wn/Vy
   g==;
X-CSE-ConnectionGUID: TCVea47KQwu3vWiibcC21w==
X-CSE-MsgGUID: X8hojD6sTRud9N09i+2KBA==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11231439"
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="11231439"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 11:28:08 -0700
X-CSE-ConnectionGUID: /ArbksKxS466QMq7+rVEVQ==
X-CSE-MsgGUID: 6pEYRgEqS5q+99pf18TJ+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="60142298"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.50]) ([10.24.10.50])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 11:28:07 -0700
Message-ID: <8da387e4-0c44-4402-8103-fc232600cb02@intel.com>
Date: Wed, 8 May 2024 11:28:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 42/54] KVM: x86/pmu: Implement emulated counter
 increment for passthrough PMU
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
 <20240506053020.3911940-43-mizhang@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240506053020.3911940-43-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/5/2024 10:30 PM, Mingwei Zhang wrote:
> @@ -896,6 +924,12 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
>  		return;
>  
>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
> +		if (is_passthrough)
> +			is_pmc_allowed = pmc_speculative_in_use(pmc) &&
> +					 check_pmu_event_filter(pmc);
> +		else
> +			is_pmc_allowed = pmc_event_is_allowed(pmc);
> +

Why don't need to check pmc_is_globally_enabled() in PMU passthrough
case? Sorry if I missed something.

