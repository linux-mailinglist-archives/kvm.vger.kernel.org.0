Return-Path: <kvm+bounces-29666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7428B9AF31A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 21:57:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFE6BB214C3
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 19:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1AA19CC09;
	Thu, 24 Oct 2024 19:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SM3MHoK8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23621189B8A;
	Thu, 24 Oct 2024 19:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729799846; cv=none; b=PIP4NQ6MctDlmGmKqcCZ4wNSob46rpWv2HiUWdskNvY/mac4sMqKBps6jkQwYmM5QU0dlY58Je+6QE463Z3CskF0C187akxrTjNXmPaEg/sZ9aogKoxhSeYyt0VsyJ3d4PpuM24X/+b7o0FpvFK9d4DVNrhPJCmWC1YUQUYz5hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729799846; c=relaxed/simple;
	bh=2ycrIazf4u5BYLKCn3pwWm4BN43SefVCD1rhJF6Q9pg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rMTEOn5dvNBqbkOIvt37b+WsPu7Okm84oFjPZdulJsNiRqD+EPwju+DDOIx1eUVrHD+Ew2XpEOwqEb2oovJyhv1HSaa8lRAgXREppRVmmHcwUjV8l5Q8U928ZyLu5sQTCw6CE3JoM8sJMQp8hYktfj8ENJC5cn4Omt4Q0J6MMAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SM3MHoK8; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729799844; x=1761335844;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2ycrIazf4u5BYLKCn3pwWm4BN43SefVCD1rhJF6Q9pg=;
  b=SM3MHoK8ZJsTba+P51swwmBLzyWLwFQ1PQ5yuSi/ibtdyJnB86hMwSM+
   u58XMmw9hcK5ZvEK8b0LF+FSrniniY5N5sPRYfUHlSbpnOywURmCE/dUV
   TT1Fg+4B/O9812t6trJ1tlZPZQMczHepHK26bZweYaduxIAI9jmZagT/T
   hoKGZsjy6gAL0jVQgW4m44t4Z4OFoLUbxDxiiOYBbd8niF3DfodO+tH79
   ZkKRFEE0vC1kwQY2GJba1UD9LeO2LDbIJHK9ErD9kzJTCx8LTppANhFXh
   D4EW8eUCNHBEP1bSg+uwoqNsjG1nyDlxmUuBwkK4MmdgvI/J99LbAGMxM
   w==;
X-CSE-ConnectionGUID: 4XOPLehGR56InP+Nv08YHg==
X-CSE-MsgGUID: m6wnEHiLQ5KBGm/tKi5HDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29317014"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29317014"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 12:57:24 -0700
X-CSE-ConnectionGUID: kDP2lGLjR16cC5iaIwzu3w==
X-CSE-MsgGUID: 6JAYzAYyTBaQ9wPgHaQWsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="81523336"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.24.8.117]) ([10.24.8.117])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 12:57:23 -0700
Message-ID: <748e89d0-b27f-49d0-9dba-d4f65503dcf0@intel.com>
Date: Thu, 24 Oct 2024 12:57:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 41/58] KVM: x86/pmu: Add support for PMU context
 switch at VM-exit/enter
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
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-42-mizhang@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240801045907.4010984-42-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> 
> Add correct PMU context switch at VM_entry/exit boundary.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/x86.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dd6d2c334d90..70274c0da017 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11050,6 +11050,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		set_debugreg(0, 7);
>  	}
>  
> +	if (is_passthrough_pmu_enabled(vcpu))
> +		kvm_pmu_restore_pmu_context(vcpu);

Suggest to move is_passthrough_pmu_enabled() into the PMU restore API to
keep x86.c clean. It's up to PMU to decide in what scenarios it needs to
do context switch.

> +
>  	guest_timing_enter_irqoff();
>  
>  	for (;;) {
> @@ -11078,6 +11081,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		++vcpu->stat.exits;
>  	}
>  
> +	if (is_passthrough_pmu_enabled(vcpu))
> +		kvm_pmu_save_pmu_context(vcpu);

ditto.

>  	/*
>  	 * Do this here before restoring debug registers on the host.  And
>  	 * since we do this before handling the vmexit, a DR access vmexit


