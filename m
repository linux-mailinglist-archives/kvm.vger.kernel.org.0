Return-Path: <kvm+bounces-20202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9CFF9118DA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 04:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52E34282DFD
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 02:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B5E86267;
	Fri, 21 Jun 2024 02:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="abESTQbC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A6986AE3;
	Fri, 21 Jun 2024 02:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718938325; cv=none; b=Us6nbZ48hbalr6mm1BNQFx7js1z+RNE84bwLtfZEDm1bfoLjJXm1iMGqM75DBGL9tTBnBmjihv+PZ1OVwOK6QiTmN+QrwEpoWvQOUM/cBT0Przk/+FTE4Q/WRwm6oFNaBsodvuhy0sCAARcahoR6yacqpa+AVJ9WKlXK4fZ9K50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718938325; c=relaxed/simple;
	bh=DGduIB8sY43MFmG87XUJOKTYdfhoLGzgOQdTg6q9vAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sTZ0Prz1AjhnJxIkettIcC9ZdfOaI71u8ldyfN97YcVm50W32Rny0a/e8IuqUlImAI9kc8OJbVC3QQJ7JykDwNTpg49DDImQsTiuZ6mGI9rpqzIg/oGOThUUV8naS6t/1DnATsadpbusNwOBPppFBQ0f5HFYucucAUNGAAzN82s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=abESTQbC; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718938323; x=1750474323;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DGduIB8sY43MFmG87XUJOKTYdfhoLGzgOQdTg6q9vAc=;
  b=abESTQbC66z2joJtMwYU6gzy6OxtWINEAiAh3fhpkmGkPbF/4Sr5qStT
   h/vNBSkGIWa9cAjdPh7uAFTFSTSeepgIM6JvOSlgE2lbVyQYCxp5xtI6/
   bMdX1Bgokd0DkfR8wDnyrmbakrGC7csTeeVINqD+JPk87lBq//YSCd2yv
   F1YLEUSaia/dHgYNY00sqDZ+uSuBEoGKwk3vlNUYICNQcAtV7ybY0ORY+
   Z1QbNVI6n1md6tqWTaMIjmgIPnmUJG3iDcF974FDgupHMvD6iG4IVRBxf
   yqBpcV1vjZwD/rvADchEhD3upddfBADPvrdfQxIv4vxKEvehuMWYd/ac4
   A==;
X-CSE-ConnectionGUID: iiaKcrvkQaCAyTSKy0TiPQ==
X-CSE-MsgGUID: hTY0i2ELSzaUsTrLOYaQUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="26550084"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="26550084"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 19:52:03 -0700
X-CSE-ConnectionGUID: vR2FCYRiS0ackf5LXitWHA==
X-CSE-MsgGUID: 96g/uXTbRvOnkI61pg41TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="47635403"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 19:51:59 -0700
Message-ID: <ee06d465-b84b-4c75-9155-3fa5db9f3325@linux.intel.com>
Date: Fri, 21 Jun 2024 10:51:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests: kvm: Reduce verbosity of "Random seed"
 messages
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Yi Lai <yi1.lai@intel.com>
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
 <20240619182128.4131355-3-dapeng1.mi@linux.intel.com>
 <ZnRxQSG_wnZma3H9@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZnRxQSG_wnZma3H9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/21/2024 2:13 AM, Sean Christopherson wrote:
> On Thu, Jun 20, 2024, Dapeng Mi wrote:
>> Huge number of "Random seed:" messages are printed when running
>> pmu_counters_test. It leads to the regular test output is totally
>> flooded by these over-verbose messages.
>>
>> Downgrade "Random seed" message printing level to debug and prevent it
>> to be printed in normal case.
> I completely agree this is annoying, but the whole point of printing the seed is
> so that the seed is automatically captured if a test fails, e.g. so that the
> failure can be reproduced if it is dependent on some random decision.
>
> Rather than simply hiding the message, what if print the seed if and only if it
> changes?

Yeah, it's indeed better.

>
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 20 Jun 2024 10:29:53 -0700
> Subject: [PATCH] KVM: selftests: Print the seed for the guest pRNG iff it has
>  changed

s/iff/if/


>
> Print the guest's random seed during VM creation if and only if the seed
> has changed since the seed was last printed.  The vast majority of tests,
> if not all tests at this point, set the seed during test initialization
> and never change the seed, i.e. printing it every time a VM is created is
> useless noise.
>
> Snapshot and print the seed during early selftest init to play nice with
> tests that use the kselftests harness, at the cost of printing an unused
> seed for tests that change the seed during test-specific initialization,
> e.g. dirty_log_perf_test.  The kselftests harness runs each testcase in a
> separate process that is forked from the original process before creating
> each testcase's VM, i.e. waiting until first VM creation will result in
> the seed being printed by each testcase despite it never changing.  And
> long term, the hope/goal is that setting the seed will be handled by the
> core framework, i.e. that the dirty_log_perf_test wart will naturally go
> away.
>
> Reported-by: Yi Lai <yi1.lai@intel.com>
> Reported-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index ad00e4761886..56b170b725b3 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -21,6 +21,7 @@
>  
>  uint32_t guest_random_seed;
>  struct guest_random_state guest_rng;
> +static uint32_t last_guest_seed;
>  
>  static int vcpu_mmap_sz(void);
>  
> @@ -434,7 +435,10 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
>  	slot0 = memslot2region(vm, 0);
>  	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
>  
> -	pr_info("Random seed: 0x%x\n", guest_random_seed);
> +	if (guest_random_seed != last_guest_seed) {
> +		pr_info("Random seed: 0x%x\n", guest_random_seed);
> +		last_guest_seed = guest_random_seed;
> +	}
>  	guest_rng = new_guest_random_state(guest_random_seed);
>  	sync_global_to_guest(vm, guest_rng);
>  
> @@ -2319,7 +2323,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
>  	/* Tell stdout not to buffer its content. */
>  	setbuf(stdout, NULL);
>  
> -	guest_random_seed = random();
> +	guest_random_seed = last_guest_seed = random();
> +	pr_info("Random seed: 0x%x\n", guest_random_seed);
>  
>  	kvm_selftest_arch_init();
>  }
>
> base-commit: c81b138d5075c6f5ba3419ac1d2a2e7047719c14

