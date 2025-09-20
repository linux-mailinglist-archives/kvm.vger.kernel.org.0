Return-Path: <kvm+bounces-58283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03DBDB8BB37
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 02:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 609607C5971
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68ACF442C;
	Sat, 20 Sep 2025 00:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h+lGoWwP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7576191;
	Sat, 20 Sep 2025 00:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758329207; cv=none; b=CzqPun61ldkmpEND0YP6vJ/F6g1tDvGrg6c+JQXDTFBIo0pMTEd3PJVAr3vA6laUrsohoWLQl86GaKb66dPek2cnTzi3jF6LdH4/bYM9PsX5RaFyaM4QzwOm+2yTxGB8khCy3rrQ7U/Th7jfHpn3Ot8GhzCTzUX2azhYFzdYoUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758329207; c=relaxed/simple;
	bh=obzQh0t/PU5wuTYcn2Iscy4Z9TWyA/duh5twkZ/V3f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VTteqnVatNiTASpnRst0Ntf0QCkCr0mEV2mu0GasW3GrgvM7PWamBVmeoMB7sq9BfMOM/p+RcSaoGps+05bXCA+Fg93ZSStS+2uQ0JMs6ARAvhLSt1pPUfnfsj8eJFw+hqydMPpA5ukT7AYIJSb6FqAVqH5RcwOjIK/2opEX+9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h+lGoWwP; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758329205; x=1789865205;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=obzQh0t/PU5wuTYcn2Iscy4Z9TWyA/duh5twkZ/V3f0=;
  b=h+lGoWwPjOG/hktMtZkPE+V1YfNhsWfoxovCFK4lj/NriIOAjyRDG4ft
   VNHejoigrmZ3oDc4is5+mdeOgsyvFE6qgdyspTGyaorBKnWD4UyDVLOR8
   IpnXPkQoamfTt0VXmw+PXUdCL7eECXu/6rIGNpCGXtxxcbXYVTRehqEdA
   M+nxfLhh6RQY202Jcnnrj5zai9msz9G+L6anzYjTO3XXBPBX6MKpVzITS
   hg7kTjgXHfVUYzbRrwhQw5OrE8DiY7JxcbEqfnV37iHd7xET6GAAMiM5Z
   H8m/++7K2pVA3r8g5t5L35/4vMzzGBpPZcs0kQSECtvbyPD4nbRlKhVg0
   Q==;
X-CSE-ConnectionGUID: i06ez/J3TT+RvGswAH+7qw==
X-CSE-MsgGUID: wC6rWJlMQemIXT4jqAaIZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="60373107"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="60373107"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 17:46:45 -0700
X-CSE-ConnectionGUID: h1aZW+QlRZ6j3q0T20QHnQ==
X-CSE-MsgGUID: L9mSR7O8QrWcnNPUzrTQ1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="176402323"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.233.177]) ([10.124.233.177])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 17:46:43 -0700
Message-ID: <99c6cb2f-1377-4c5b-b1d6-d1c384195cf0@linux.intel.com>
Date: Sat, 20 Sep 2025 08:46:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] KVM: selftests: Track unavailable_mask for PMU
 events as 32-bit value
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yi Lai <yi1.lai@intel.com>
References: <20250919214648.1585683-1-seanjc@google.com>
 <20250919214648.1585683-3-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250919214648.1585683-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 9/20/2025 5:46 AM, Sean Christopherson wrote:
> Track the mask of "unavailable" PMU events as a 32-bit value.  While bits
> 31:9 are currently reserved, silently truncating those bits is unnecessary
> and asking for missed coverage.  To avoid running afoul of the sanity check
> in vcpu_set_cpuid_property(), explicitly adjust the mask based on the
> non-reserved bits as reported by KVM's supported CPUID.
>
> Opportunistically update the "all ones" testcase to pass -1u instead of
> 0xff.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86/pmu_counters_test.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> index 8aaaf25b6111..1ef038c4c73f 100644
> --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> @@ -311,7 +311,7 @@ static void guest_test_arch_events(void)
>  }
>  
>  static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
> -			     uint8_t length, uint8_t unavailable_mask)
> +			     uint8_t length, uint32_t unavailable_mask)
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm;
> @@ -320,6 +320,9 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
>  	if (!pmu_version)
>  		return;
>  
> +	unavailable_mask &= GENMASK(X86_PROPERTY_PMU_EVENTS_MASK.hi_bit,
> +				    X86_PROPERTY_PMU_EVENTS_MASK.lo_bit);
> +
>  	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_arch_events,
>  					 pmu_version, perf_capabilities);
>  
> @@ -630,7 +633,7 @@ static void test_intel_counters(void)
>  			 */
>  			for (j = 0; j <= NR_INTEL_ARCH_EVENTS + 1; j++) {
>  				test_arch_events(v, perf_caps[i], j, 0);
> -				test_arch_events(v, perf_caps[i], j, 0xff);
> +				test_arch_events(v, perf_caps[i], j, -1u);
>  
>  				for (k = 0; k < NR_INTEL_ARCH_EVENTS; k++)
>  					test_arch_events(v, perf_caps[i], j, BIT(k));

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



