Return-Path: <kvm+bounces-35375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC13A10752
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71DDD3A723E
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 13:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25071234D1B;
	Tue, 14 Jan 2025 13:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VI3otu/F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDB0236A91
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 13:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736859844; cv=none; b=jfwL8RsXidTqhqrc77A00QvJdBAYmHnBnSqVnN5sMxH3QxVMfeuWBMhwkfn5Or2VxkWdP9fTwi5zNu1sjwAue+aLcoWBIytKd9oJo6RP9atvCQbe8j0Aa/W1Aac29Z7tKliEAbbF+UlJjLqLxeJaAdWnzWmv71bQogUpbzPYFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736859844; c=relaxed/simple;
	bh=ILshQhygwdY6A9R7RYwHI2SkUDpcqX6WPA541tutJCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a1LS0F0fDwd8laJp3G7bO0bqzcvQxVQmsVYjYEApdWRJOuHXPv8s/GR+KOUmtU093ZabKhs5iMLm3gMoMzNR5heCj2jm8+T/B0c9GsLg3JpOdJWsEeKLePYRAasJGxISOsytVnb52GyMzjltr4d4ob4KZtz7ykSSpnZf/kmO86I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VI3otu/F; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736859843; x=1768395843;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ILshQhygwdY6A9R7RYwHI2SkUDpcqX6WPA541tutJCo=;
  b=VI3otu/FXYgx5F0BA2UbRFsfyjLOd/LlwcI1H1oVxhcfbdkQtZ7fpMU/
   A51JaORsXOpTn+a4sFqprGXNj/rejQzOnBfwWLtv+DOpC9E3jpfrzkX5C
   zRV2Bh3yu+zp5JLmZcOhWcougRhiWsGZWMEg5Z7B0Fpm1Vz1nYlglm0cU
   1t7SBXxMkz/r4zOiputRYpX+vRs8Y9TYIwv1kzTcM0MU7U5oMhmB2XI/R
   auy92LwtpCieM4E6NCkUZV7J1ogXDnSTlQJuFmXq9+BjssxUHDRObW77l
   /LoKDZrPvZDFX0ZiUb4dgCcbhW9uGs6TyR/j6rWPWrryW2cp9A5DD/xyj
   w==;
X-CSE-ConnectionGUID: nEaeC6LGRAqpO1KSKyN1zQ==
X-CSE-MsgGUID: q4Js2+U7SBa5mb6010HF1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37040748"
X-IronPort-AV: E=Sophos;i="6.12,314,1728975600"; 
   d="scan'208";a="37040748"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 05:04:02 -0800
X-CSE-ConnectionGUID: LCvE05rNS7qCnCmroWHyjQ==
X-CSE-MsgGUID: lVI+7ydwQ/u4U6ZMk9Pb3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,314,1728975600"; 
   d="scan'208";a="104739425"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 05:03:57 -0800
Message-ID: <8bc79ae4-a9e9-4911-9af3-0b9964886511@intel.com>
Date: Tue, 14 Jan 2025 21:03:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 55/60] i386/tdx: Fetch and validate CPUID of TD guest
To: Ira Weiny <ira.weiny@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-56-xiaoyao.li@intel.com>
 <Z1si66iUjsqCoUgL@iweiny-mobl>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z1si66iUjsqCoUgL@iweiny-mobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/2024 1:52 AM, Ira Weiny wrote:
> On Tue, Nov 05, 2024 at 01:24:03AM -0500, Xiaoyao Li wrote:
>> Use KVM_TDX_GET_CPUID to get the CPUIDs that are managed and enfored
>> by TDX module for TD guest. Check QEMU's configuration against the
>> fetched data.
>>
>> Print wanring  message when 1. a feature is not supported but requested
>> by QEMU or 2. QEMU doesn't want to expose a feature while it is enforced
>> enabled.
>>
>> - If cpu->enforced_cpuid is not set, prints the warning message of both
>> 1) and 2) and tweak QEMU's configuration.
>>
>> - If cpu->enforced_cpuid is set, quit if any case of 1) or 2).
> 
> Patches 52, 53, 54, and this one should probably be squashed
> 
> 53's commit message is non-existent and really only makes sense because the
> function is used here.  52's commit message is pretty thin.  Both 52 and 53 are
> used here, the size of this patch is not adversely affected, and the reason for
> the changes are more clearly shown in this patch.

It's my fault to forget adding the commit message for patch 53 before 
posting.

> 54 somewhat stands on its own.  But really it is just calling the functionality
> of this patch.  So I don't see a big reason for it to be on its own but up to
> you.

I'll squash patch 52 and 53 into this one and leave patch 54 as-is.

>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/kvm/tdx.c | 81 +++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 81 insertions(+)
>>
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index e7e0f073dfc9..9cb099e160e4 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -673,6 +673,86 @@ static uint32_t tdx_adjust_cpuid_features(X86ConfidentialGuest *cg,
>>       return value;
>>   }
>>   
>> +
>> +static void tdx_fetch_cpuid(CPUState *cpu, struct kvm_cpuid2 *fetch_cpuid)
>> +{
>> +    int r;
>> +
>> +    r = tdx_vcpu_ioctl(cpu, KVM_TDX_GET_CPUID, 0, fetch_cpuid);
>> +    if (r) {
>> +        error_report("KVM_TDX_GET_CPUID failed %s", strerror(-r));
>> +        exit(1);
>> +    }
>> +}
>> +
>> +static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
>> +{
>> +    uint64_t actual, requested, unavailable, forced_on;
>> +    g_autofree struct kvm_cpuid2 *fetch_cpuid;
>> +    const char *forced_on_prefix = NULL;
>> +    const char *unav_prefix = NULL;
>> +    struct kvm_cpuid_entry2 *entry;
>> +    X86CPU *cpu = X86_CPU(cs);
>> +    CPUX86State *env = &cpu->env;
>> +    FeatureWordInfo *wi;
>> +    FeatureWord w;
>> +    bool mismatch = false;
>> +
>> +    fetch_cpuid = g_malloc0(sizeof(*fetch_cpuid) +
>> +                    sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
> 
> Is this a memory leak?  I don't see fetch_cpuid returned or free'ed.  If so, it
> might be better to use g_autofree() for this allocation.
> 
> Alternatively, this allocation size is constant, could this be on the heap and
> not allocated at all?  (I assume it is big enough that a stack allocation is
> unwanted.)
> 
> Ira
> 
>> +    tdx_fetch_cpuid(cs, fetch_cpuid);
>> +
>> +    if (cpu->check_cpuid || cpu->enforce_cpuid) {
>> +        unav_prefix = "TDX doesn't support requested feature";
>> +        forced_on_prefix = "TDX forcibly sets the feature";
>> +    }
>> +
>> +    for (w = 0; w < FEATURE_WORDS; w++) {
>> +        wi = &feature_word_info[w];
>> +        actual = 0;
>> +
>> +        switch (wi->type) {
>> +        case CPUID_FEATURE_WORD:
>> +            entry = cpuid_find_entry(fetch_cpuid, wi->cpuid.eax, wi->cpuid.ecx);
>> +            if (!entry) {
>> +                /*
>> +                 * If KVM doesn't report it means it's totally configurable
>> +                 * by QEMU
>> +                 */
>> +                continue;
>> +            }
>> +
>> +            actual = cpuid_entry_get_reg(entry, wi->cpuid.reg);
>> +            break;
>> +        case MSR_FEATURE_WORD:
>> +            /*
>> +             * TODO:
>> +             * validate MSR features when KVM has interface report them.
>> +             */
>> +            continue;
>> +        }
>> +
>> +        requested = env->features[w];
>> +        unavailable = requested & ~actual;
>> +        mark_unavailable_features(cpu, w, unavailable, unav_prefix);
>> +        if (unavailable) {
>> +            mismatch = true;
>> +        }
>> +
>> +        forced_on = actual & ~requested;
>> +        mark_forced_on_features(cpu, w, forced_on, forced_on_prefix);
>> +        if (forced_on) {
>> +            mismatch = true;
>> +        }
>> +    }
>> +
>> +    if (cpu->enforce_cpuid && mismatch) {
>> +        return -1;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
>>   {
>>       if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
>> @@ -1019,4 +1099,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
>>       x86_klass->cpu_instance_init = tdx_cpu_instance_init;
>>       x86_klass->cpu_realizefn = tdx_cpu_realizefn;
>>       x86_klass->adjust_cpuid_features = tdx_adjust_cpuid_features;
>> +    x86_klass->check_features = tdx_check_features;
>>   }
>> -- 
>> 2.34.1
>>


