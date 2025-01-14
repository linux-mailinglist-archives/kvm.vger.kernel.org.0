Return-Path: <kvm+bounces-35372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA5CCA10717
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 13:51:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03CF9162896
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 12:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433AA234D13;
	Tue, 14 Jan 2025 12:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cx9ghwEq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81628234CF7
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 12:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736859102; cv=none; b=JNyeMkcPk4YOM6jKDdeZq96+iK8kXYsTYkBORrk7L1eNW4szCnIOmc5RO2iirK7uJOIFcIPJTbaWawUkPQF3cPNimSWcugHLKdCvZsPxLHIH/w5bM409KGi0BR4w8I0ivM8h+yFQIff4Qy9UIwdJmtUQwi2FNfWcldGkdx9cNqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736859102; c=relaxed/simple;
	bh=gkfpF34uGftelqQ/DygtALvPegVAvMiRQAn2L35vbAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NS9Vj9eNX6yGXO9mrQL89WtwZQTTtWMD7BYo1sWPSShTYmxbjO4q0ESFIfQMiR+NCZl0ZfovhyInl5ocSvT6MIEvnSyYNO/PGnBr8cmW1cZxdrC0DXLVeUwSTNHGjxdX8FL6FmI55lar8cx6RjUWVTDFZo7NnRq16DqLbFmGp7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cx9ghwEq; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736859100; x=1768395100;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gkfpF34uGftelqQ/DygtALvPegVAvMiRQAn2L35vbAQ=;
  b=Cx9ghwEqTmQPVOOegSKyu8gu24LfpY/Tl5QhxJXbkH6YWFBBbSvYlxOn
   +K0vfNy/52j4B9TWIOVRQdBPCrPTFFz+TB4CuGorcasCkR1WvUQocsDcw
   PF8gPManp8AB4W/r5ZYwaTUr+BRcDnAsf1sh8dVyUh6TBZ9g5R239+JwA
   IMYjKxMvmbIEh7x/2zeTtHflnH2BJmWJzRPpzVV3P/v9wFyKTRbMbD6k0
   iEqJT4mGV5Pbcp75WgI0nLKtmhCWML96K9FkeaMcCgZ7w9NPlxFXiGEwq
   GrwVMxjBmWvqRhaNPw8oTf7h0W9W3CnvGFV0QkbkySPx6pXsTYDITtli4
   g==;
X-CSE-ConnectionGUID: uOKKjcZmR+6IFcXmNxyzuQ==
X-CSE-MsgGUID: l5+fuVQpQAmLFHO2Xfiouw==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="24753381"
X-IronPort-AV: E=Sophos;i="6.12,314,1728975600"; 
   d="scan'208";a="24753381"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 04:51:40 -0800
X-CSE-ConnectionGUID: hyA2s042ThasaEtnxdFrbQ==
X-CSE-MsgGUID: 5Dl0wuMbQpyiUcwsRt4FGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,314,1728975600"; 
   d="scan'208";a="104621201"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 04:51:37 -0800
Message-ID: <916034d2-7e02-49ad-9ae1-6201870a15eb@intel.com>
Date: Tue, 14 Jan 2025 20:51:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 35/60] i386/cpu: Introduce enable_cpuid_0x1f to force
 exposing CPUID 0x1f
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
 <20241105062408.3533704-36-xiaoyao.li@intel.com>
 <Z1tgvQdLeafHKXIe@iweiny-mobl>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <Z1tgvQdLeafHKXIe@iweiny-mobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/2024 6:16 AM, Ira Weiny wrote:
> On Tue, Nov 05, 2024 at 01:23:43AM -0500, Xiaoyao Li wrote:
>> Currently, QEMU exposes CPUID 0x1f to guest only when necessary, i.e.,
>> when topology level that cannot be enumerated by leaf 0xB, e.g., die or
>> module level, are configured for the guest, e.g., -smp xx,dies=2.
>>
>> However, TDX architecture forces to require CPUID 0x1f to configure CPU
>> topology.
>>
>> Introduce a bool flag, enable_cpuid_0x1f, in CPU for the case that
>> requires CPUID leaf 0x1f to be exposed to guest.
>>
>> Introduce a new function x86_has_cpuid_0x1f(), which is the warpper of
>> cpu->enable_cpuid_0x1f and x86_has_extended_topo() to check if it needs
>> to enable cpuid leaf 0x1f for the guest.
> 
> Could you elaborate on the relation between cpuid_0x1f and the extended
> topology support?  I feel like x86_has_cpuid_0x1f() is a poor name for this
> check.

CPUID leaf 0xb is "Exteneded Topology Enumeration leaf", which can only 
enumerate topology level of thread and core.

CPUID leaf 0x1f is "v2 Extended Topology Enumeration leaf" which can 
enumerate more level than leaf 0xb, e.g., module, tile, die.

QEMU enumerates CPUID leaf to 0x1f to guest only when necessary. i.e., 
when the topology of the guest is configured to have levels beyond 
thread and core. However, TDX mandates to use CPUID leaf 0x1f for 
topology configuration.

So this patch defines "enable_cpuid_0x1f" to expose CPUID leaf 0x1f even 
when only thread and core level topology are configured.

(BTW, x86_has_extended_topo() actually mean x86_has_v2_extended_topo())

> Perhaps I'm just not understanding what is required here?
> 
> Ira
> 
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/cpu.c     | 4 ++--
>>   target/i386/cpu.h     | 9 +++++++++
>>   target/i386/kvm/kvm.c | 2 +-
>>   3 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 1ffbafef03e7..119b38bcb0c1 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -6731,7 +6731,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>>           break;
>>       case 0x1F:
>>           /* V2 Extended Topology Enumeration Leaf */
>> -        if (!x86_has_extended_topo(env->avail_cpu_topo)) {
>> +        if (!x86_has_cpuid_0x1f(cpu)) {
>>               *eax = *ebx = *ecx = *edx = 0;
>>               break;
>>           }
>> @@ -7588,7 +7588,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>>            * cpu->vendor_cpuid_only has been unset for compatibility with older
>>            * machine types.
>>            */
>> -        if (x86_has_extended_topo(env->avail_cpu_topo) &&
>> +        if (x86_has_cpuid_0x1f(cpu) &&
>>               (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
>>               x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
>>           }
>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>> index 59959b8b7a4d..dcc673262c06 100644
>> --- a/target/i386/cpu.h
>> +++ b/target/i386/cpu.h
>> @@ -2171,6 +2171,9 @@ struct ArchCPU {
>>       /* Compatibility bits for old machine types: */
>>       bool enable_cpuid_0xb;
>>   
>> +    /* Force to enable cpuid 0x1f */
>> +    bool enable_cpuid_0x1f;
>> +
>>       /* Enable auto level-increase for all CPUID leaves */
>>       bool full_cpuid_auto_level;
>>   
>> @@ -2431,6 +2434,12 @@ void host_cpuid(uint32_t function, uint32_t count,
>>                   uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx);
>>   bool cpu_has_x2apic_feature(CPUX86State *env);
>>   
>> +static inline bool x86_has_cpuid_0x1f(X86CPU *cpu)
>> +{
>> +    return cpu->enable_cpuid_0x1f ||
>> +           x86_has_extended_topo(cpu->env.avail_cpu_topo);
>> +}
>> +
>>   /* helper.c */
>>   void x86_cpu_set_a20(X86CPU *cpu, int a20_state);
>>   void cpu_sync_avx_hflag(CPUX86State *env);
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index dea0f83370d5..022809bad36e 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -1874,7 +1874,7 @@ uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
>>               break;
>>           }
>>           case 0x1f:
>> -            if (!x86_has_extended_topo(env->avail_cpu_topo)) {
>> +            if (!x86_has_cpuid_0x1f(env_archcpu(env))) {
>>                   cpuid_i--;
>>                   break;
>>               }
>> -- 
>> 2.34.1
>>


