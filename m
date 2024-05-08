Return-Path: <kvm+bounces-17068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A08C8C06A9
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 23:56:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1782AB20C12
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 21:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1B313281F;
	Wed,  8 May 2024 21:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j93MIPcQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B257D3FB;
	Wed,  8 May 2024 21:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715205333; cv=none; b=gag/x4nSw4uDM1HNjB+qN+YZP1TZ3kj/FWy2His+vZlbEj3C4MYR9W/mB+rH8NHPM8/q+dFbE6BcR/bYUCVmMqjjoaDXYpD4b+docvuLsH2NuUIpOG2MfB/J1XF6nAsXrxfWpAkUrPJdDc9NXhj75Wz7ePfp0SrWhuO0sdeut8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715205333; c=relaxed/simple;
	bh=AhEr9ODtYq0DPPaUr0ELaI28ZIJZJPti4CJCCXGKJVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o3tSIZMaQLLW9lQk784ZpDqLqRMRgfEilQWE/KilvPp5Nl2SKZZTzKDfA0/CshV4Y9UKVpP4ZEUqt2X75O20aMbV/Ikf/fxdtuQyNPnqou6PYnBC6WWUvWIIj/vUhfDaDFylfavcFssyhwdkGWdOoYMPFlAe25rSLjDBEIqyULw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j93MIPcQ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715205332; x=1746741332;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AhEr9ODtYq0DPPaUr0ELaI28ZIJZJPti4CJCCXGKJVI=;
  b=j93MIPcQAwx5ru631rd6Ue5vT9xfjPwfMUOpfI70NIGfh6MBiNQY1ACf
   Ps6QIXhilak375tzbr/XEZcEPPRc4JOPvdhwcOuAuJn8Kl4AuDWsGTAGn
   BevrV18xZXCS3umf6Ny0XMERSn09s/B54aYFKDZDn4I023DVX4/16kvGm
   reFooSeNOxHLXCfGKAhVttzNy5up+dORa6mhsIr1QYFJX4Mc8/cZIoEwn
   R+1T5MdQPzRG2U1CCs1s2qFkDZerEwDp2VoG9ivbRlGIe/X+eyBXbAaNe
   lZ0RY82jl3p5kgVtejF0AyMI4k8ljq+tzfpxaW+l/IY/c+eS5gfddbHLV
   Q==;
X-CSE-ConnectionGUID: YdI/NI7SThucBDLFLh4xSA==
X-CSE-MsgGUID: 0vYh6CcrRHGBEJbkKiMHXg==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11221205"
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="11221205"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 14:55:32 -0700
X-CSE-ConnectionGUID: mV9RG+m2TYWtdoVb5JWURw==
X-CSE-MsgGUID: po30VTPXTQuWFVsJ1rZyhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,145,1712646000"; 
   d="scan'208";a="33502695"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.50]) ([10.24.10.50])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 14:55:30 -0700
Message-ID: <f2a9d5ba-e0ae-41fb-ae54-2456c826ac2c@intel.com>
Date: Wed, 8 May 2024 14:55:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/54] KVM: x86/pmu: Allow RDPMC pass through when all
 counters exposed to guest
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
 <20240506053020.3911940-21-mizhang@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240506053020.3911940-21-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a5024b7b0439..a18ba5ae5376 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7860,6 +7860,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		vmx->msr_ia32_feature_control_valid_bits &=
>  			~FEAT_CTL_SGX_LC_ENABLED;
>  
> +	if (kvm_pmu_check_rdpmc_passthrough(&vmx->vcpu))
> +		exec_controls_clearbit(vmx, CPU_BASED_RDPMC_EXITING);
> +	else
> +		exec_controls_setbit(vmx, CPU_BASED_RDPMC_EXITING);
> +

Seems it's cleaner to put the code inside vmx_set_perf_global_ctrl(),
and change the name to reflect that it handles all the PMU related VMCS
controls.

>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
>  }

