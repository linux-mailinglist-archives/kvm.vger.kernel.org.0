Return-Path: <kvm+bounces-1297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8C87E6496
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2F4B2810C6
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 07:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADEEF9F3;
	Thu,  9 Nov 2023 07:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n1W4wyBG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D357F2
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:45:23 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8906B268D;
	Wed,  8 Nov 2023 23:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699515923; x=1731051923;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CQXefVxHkEVXDq9bg6d3WKLLq6LhFUtDc30/jArcaq0=;
  b=n1W4wyBGPCoS4L615eKQxLGYeYiQm7G+/x4yOZEqC/kfIcklwaJg10a/
   4TlponTkPQS/A2h1Z0vMOpsMguqf2Y4cEPQWIF9mp3gc3u+zwG5Mm0NjZ
   2AnEI++eT4f5b8J+MG1YTCWe/AjyfmxNYJ/yVsTfrk319pFQ3G2KPi8S4
   gVKLvY5dpYzYR5+IAV5FZQkmepSKj3RV7SfKTjZmw8NignTE5kUsJhDg2
   apNFr4Fkg1lox2zB1q2WKf7gh+2dUeZlWLbRXVEClUFvE7L5/vf98EJB/
   YLq2att9rM52JqVc3rxXUCDxWdIs/xgu+pbOcV/i0LzhV3yKfZFzy2GTt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="370137927"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="370137927"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:45:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="853999242"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="853999242"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.5.53]) ([10.93.5.53])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:45:20 -0800
Message-ID: <94011a6d-fc3e-4cd7-a025-a00222ef4d98@linux.intel.com>
Date: Thu, 9 Nov 2023 15:45:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 15/19] KVM: selftests: Add a helper to query if the PMU
 module param is enabled
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>,
 Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>,
 Like Xu <likexu@tencent.com>
References: <20231108003135.546002-1-seanjc@google.com>
 <20231108003135.546002-16-seanjc@google.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20231108003135.546002-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/8/2023 8:31 AM, Sean Christopherson wrote:
> Add a helper to problem KVM's "enable_pmu" param, open coding strings in
> multiple places is just asking for a false negatives and/or runtime errors
> due to typos.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/include/x86_64/processor.h     | 5 +++++
>   tools/testing/selftests/kvm/x86_64/pmu_counters_test.c     | 2 +-
>   tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 2 +-
>   tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c     | 2 +-
>   4 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 64aecb3dcf60..c261e0941dfe 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -1216,6 +1216,11 @@ static inline uint8_t xsetbv_safe(uint32_t index, uint64_t value)
>   
>   bool kvm_is_tdp_enabled(void);
>   
> +static inline bool kvm_is_pmu_enabled(void)
> +{
> +	return get_kvm_param_bool("enable_pmu");
> +}
> +
>   uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
>   				    int *level);
>   uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index 90381382c51f..d775cc7e8fab 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -537,7 +537,7 @@ static void test_intel_counters(void)
>   
>   int main(int argc, char *argv[])
>   {
> -	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> +	TEST_REQUIRE(kvm_is_pmu_enabled());
>   
>   	TEST_REQUIRE(host_cpu_is_intel);
>   	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 7ec9fbed92e0..fa407e2ccb2f 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -867,7 +867,7 @@ int main(int argc, char *argv[])
>   	struct kvm_vcpu *vcpu, *vcpu2 = NULL;
>   	struct kvm_vm *vm;
>   
> -	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> +	TEST_REQUIRE(kvm_is_pmu_enabled());
>   	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
>   	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
>   
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> index ebbcb0a3f743..562b0152a122 100644
> --- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
> @@ -237,7 +237,7 @@ int main(int argc, char *argv[])
>   {
>   	union perf_capabilities host_cap;
>   
> -	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> +	TEST_REQUIRE(kvm_is_pmu_enabled());
>   	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
>   
>   	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

