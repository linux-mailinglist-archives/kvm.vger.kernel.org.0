Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAA479A19B
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 05:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjIKDDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Sep 2023 23:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjIKDDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Sep 2023 23:03:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B425CB0
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 20:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694401427; x=1725937427;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RQYiTm8AhLncuIEatLHFNlNqhcOGUFqztznPKbf6R4Q=;
  b=agCYxDEPFLVtQfjfXQ3dnQxsrEFlXKurq0BnYzhaFPpNNL3OrGzdD8kG
   +NlkP/FL/0BRoXq115k1+w5WqDD8APfvfZSuKmnw2V4ZjYu4XhbPc0wMP
   tyoY4KOIYmK7rHSOUzQZaSYFdEvkHcjw8ZsKgjGLvSNAF87qoPJfVEwh+
   suBnF1O2ktQ6B7mLI42j1h1fmSEDHyB74H/tDD0gmHD2dbpIHtioTOSIz
   3vRCMPNiJEvBnqFL7FfkQzSKbY36xm11bwOyZzR9dudSdEeIJsMylcz8O
   7VfFF7RwTdt5i0txCP/7l69ojJO8kUUT2DXaPNjhcGx+QdXy0fRI9WWTi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="358284022"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="358284022"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2023 20:03:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="833332868"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="833332868"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.20.184]) ([10.93.20.184])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2023 20:03:45 -0700
Message-ID: <f94d2d9c-3f20-b024-bc7d-cb1611eae86b@linux.intel.com>
Date:   Mon, 11 Sep 2023 11:03:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 9/9] KVM: selftests: Add fixed counters enumeration test
 case
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-10-xiong.y.zhang@intel.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20230901072809.640175-10-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/2023 3:28 PM, Xiong Zhang wrote:
> vPMU v5 adds fixed counter enumeration, which allows user space to
> specify which fixed counters are supported through emulated
> CPUID.0Ah.ECX.
>
> This commit adds a test case which specify the max fixed counter
> supported only, so guest can access the max fixed counter only, #GP
> exception will be happen once guest access other fixed counters.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 84 +++++++++++++++++++
>   1 file changed, 84 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> index ebbcb0a3f743..e37dc39164fe 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c


since we added new test cases  in this file, this file is not just test 
'perf_capablities' anymore, we may change the file name 
vmx_pmu_caps_test.c to a more generic name like "vmx_pmu_test.c" or 
something else.

> @@ -18,6 +18,8 @@
>   #include "kvm_util.h"
>   #include "vmx.h"
>   
> +uint8_t fixed_counter_num;
> +
>   union perf_capabilities {
>   	struct {
>   		u64	lbr_format:6;
> @@ -233,6 +235,86 @@ static void test_lbr_perf_capabilities(union perf_capabilities host_cap)
>   	kvm_vm_free(vm);
>   }
>   
> +static void guest_v5_code(void)
> +{
> +	uint8_t  vector, i;
> +	uint64_t val;
> +
> +	for (i = 0; i < fixed_counter_num; i++) {
> +		vector = rdmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, &val);
> +
> +		/*
> +		 * Only the max fixed counter is supported, #GP will be generated
> +		 * when guest access other fixed counters.
> +		 */
> +		if (i == fixed_counter_num - 1)
> +			__GUEST_ASSERT(vector != GP_VECTOR,
> +				       "Max Fixed counter is accessible, but get #GP");
> +		else
> +			__GUEST_ASSERT(vector == GP_VECTOR,
> +				       "Fixed counter isn't accessible, but access is ok");
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +#define PMU_NR_FIXED_COUNTERS_MASK  0x1f
> +
> +static void test_fixed_counter_enumeration(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int r;
> +	struct kvm_cpuid_entry2 *ent;
> +	struct ucall uc;
> +	uint32_t fixed_counter_bit_mask;
> +
> +	if (kvm_cpu_property(X86_PROPERTY_PMU_VERSION) != 5)
> +		return;


We'd better check if the version is less than 5 here, since we might 
have higher version than 5 in the future.


> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_v5_code);
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vcpu);
> +
> +	ent = vcpu_get_cpuid_entry(vcpu, 0xa);
> +	fixed_counter_num = ent->edx & PMU_NR_FIXED_COUNTERS_MASK;
> +	TEST_ASSERT(fixed_counter_num > 0, "fixed counter isn't supported");
> +	fixed_counter_bit_mask = (1ul << fixed_counter_num) - 1;
> +	TEST_ASSERT(ent->ecx == fixed_counter_bit_mask,
> +		    "cpuid.0xa.ecx != %x", fixed_counter_bit_mask);
> +
> +	/* Fixed counter 0 isn't in ecx, but in edx, set_cpuid should be error. */
> +	ent->ecx &= ~0x1;
> +	r = __vcpu_set_cpuid(vcpu);
> +	TEST_ASSERT(r, "Setting in-consistency cpuid.0xa.ecx and edx success");
> +
> +	if (fixed_counter_num == 1) {
> +		kvm_vm_free(vm);
> +		return;
> +	}
> +
> +	/* Support the max Fixed Counter only */
> +	ent->ecx = 1UL << (fixed_counter_num - 1);
> +	ent->edx &= ~(u32)PMU_NR_FIXED_COUNTERS_MASK;
> +
> +	r = __vcpu_set_cpuid(vcpu);
> +	TEST_ASSERT(!r, "Setting modified cpuid.0xa.ecx and edx failed");
> +
> +	vcpu_run(vcpu);
> +
> +	switch (get_ucall(vcpu, &uc)) {
> +	case UCALL_ABORT:
> +		REPORT_GUEST_ASSERT(uc);
> +		break;
> +	case UCALL_DONE:
> +		break;
> +	default:
> +		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
> +	}
> +
> +	kvm_vm_free(vm);
> +}
> +
>   int main(int argc, char *argv[])
>   {
>   	union perf_capabilities host_cap;
> @@ -253,4 +335,6 @@ int main(int argc, char *argv[])
>   	test_immutable_perf_capabilities(host_cap);
>   	test_guest_wrmsr_perf_capabilities(host_cap);
>   	test_lbr_perf_capabilities(host_cap);
> +
> +	test_fixed_counter_enumeration();
>   }
