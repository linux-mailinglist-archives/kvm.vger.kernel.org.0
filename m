Return-Path: <kvm+bounces-1306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E85027E64BE
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:51:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 250521C209A7
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 07:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2B5101C3;
	Thu,  9 Nov 2023 07:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jF7VlWae"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D721D282
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:51:27 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCDE2D5B;
	Wed,  8 Nov 2023 23:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699516287; x=1731052287;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0cMfRpPIb3ZyoA5ygGU0b4uzcRMvInU28zeRmynKs4k=;
  b=jF7VlWae7MlLgR9ywvrw2SGnkma5XaPq1/QTp6PmpY2NWiA2fNM4Exdu
   ZpxOckuJyECJVG3m78tAKqZjcabXJhMzDD2TYQzRQDXoakvLf0sbv3iJw
   pqCJ4HEVOmIZMS3Lq/u9DdKCWSmsEn+Q5yjyWb081/HnHRhSAxM3SiOIo
   bJ7FtIIepX90axuPHRL9BGEQyBtub6EIgUSne/tEcl11UM0p54LHu8QCu
   7MjZeSHOxr+ETTX7wuXP55gOVsQq28hBfGs9VIJ9nw0nMI1qy2avFSrng
   YmbhOskhUd9hMLXJ73HxZob8Z913I52tlYrJNbGuZFP8Hmo4embQW1SmQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="370139107"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="370139107"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:51:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="739765343"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="739765343"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:51:23 -0800
Message-ID: <93a3da96-2e36-4ee9-a384-9dcc28c9f4ba@linux.intel.com>
Date: Thu, 9 Nov 2023 15:51:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 19/19] KVM: selftests: Test PMC virtualization with
 forced emulation
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231108003135.546002-1-seanjc@google.com>
 <20231108003135.546002-20-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20231108003135.546002-20-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/8/2023 8:31 AM, Sean Christopherson wrote:
> Extend the PMC counters test to use forced emulation to verify that KVM
> emulates counter events for instructions retired and branches retired.
> Force emulation for only a subset of the measured code to test that KVM
> does the right thing when mixing perf events with emulated events.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 44 +++++++++++++------
>   1 file changed, 30 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index d775cc7e8fab..09332b3c0a69 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -21,6 +21,7 @@
>   
>   static uint8_t kvm_pmu_version;
>   static bool kvm_has_perf_caps;
> +static bool is_forced_emulation_enabled;
>   
>   static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>   						  void *guest_code,
> @@ -34,6 +35,7 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>   	vcpu_init_descriptor_tables(*vcpu);
>   
>   	sync_global_to_guest(vm, kvm_pmu_version);
> +	sync_global_to_guest(vm, is_forced_emulation_enabled);
>   
>   	/*
>   	 * Set PERF_CAPABILITIES before PMU version as KVM disallows enabling
> @@ -138,37 +140,50 @@ static void guest_assert_event_count(uint8_t idx,
>    * If CLFUSH{,OPT} is supported, flush the cacheline containing (at least) the
>    * start of the loop to force LLC references and misses, i.e. to allow testing
>    * that those events actually count.
> + *
> + * If forced emulation is enabled (and specified), force emulation on a subset
> + * of the measured code to verify that KVM correctly emulates instructions and
> + * branches retired events in conjunction with hardware also counting said
> + * events.
>    */
> -#define GUEST_MEASURE_EVENT(_msr, _value, clflush)				\
> +#define GUEST_MEASURE_EVENT(_msr, _value, clflush, FEP)				\
>   do {										\
>   	__asm__ __volatile__("wrmsr\n\t"					\
>   			     clflush "\n\t"					\
>   			     "mfence\n\t"					\
>   			     "1: mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"	\
> -			     "loop .\n\t"					\
> -			     "mov %%edi, %%ecx\n\t"				\
> -			     "xor %%eax, %%eax\n\t"				\
> -			     "xor %%edx, %%edx\n\t"				\
> +			     FEP "loop .\n\t"					\
> +			     FEP "mov %%edi, %%ecx\n\t"				\
> +			     FEP "xor %%eax, %%eax\n\t"				\
> +			     FEP "xor %%edx, %%edx\n\t"				\
>   			     "wrmsr\n\t"					\
>   			     :: "a"((uint32_t)_value), "d"(_value >> 32),	\
>   				"c"(_msr), "D"(_msr)				\
>   	);									\
>   } while (0)
>   
> +#define GUEST_TEST_EVENT(_idx, _event, _pmc, _pmc_msr, _ctrl_msr, _value, FEP)	\
> +do {										\
> +	wrmsr(pmc_msr, 0);							\
> +										\
> +	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT))				\
> +		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflushopt 1f", FEP);	\
> +	else if (this_cpu_has(X86_FEATURE_CLFLUSH))				\
> +		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflush 1f", FEP);	\
> +	else									\
> +		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "nop", FEP);		\
> +										\
> +	guest_assert_event_count(_idx, _event, _pmc, _pmc_msr);			\
> +} while (0)
> +
>   static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature event,
>   				    uint32_t pmc, uint32_t pmc_msr,
>   				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
>   {
> -	wrmsr(pmc_msr, 0);
> +	GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
>   
> -	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT))
> -		GUEST_MEASURE_EVENT(ctrl_msr, ctrl_msr_value, "clflushopt 1f");
> -	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
> -		GUEST_MEASURE_EVENT(ctrl_msr, ctrl_msr_value, "clflush 1f");
> -	else
> -		GUEST_MEASURE_EVENT(ctrl_msr, ctrl_msr_value, "nop");
> -
> -	guest_assert_event_count(idx, event, pmc, pmc_msr);
> +	if (is_forced_emulation_enabled)
> +		GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
>   }
>   
>   #define X86_PMU_FEATURE_NULL						\
> @@ -545,6 +560,7 @@ int main(int argc, char *argv[])
>   
>   	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
>   	kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
> +	is_forced_emulation_enabled = kvm_is_forced_emulation_enabled();
>   
>   	test_intel_counters();
>   

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



