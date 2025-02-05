Return-Path: <kvm+bounces-37324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 800E3A2880E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:31:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78C903AC576
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C48222B5AC;
	Wed,  5 Feb 2025 10:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a2lhbdNQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6C422B8A5
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 10:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738751369; cv=none; b=fDuVtRVahkPJJ4ApWqgzLrKz86jsIvegPxnEFleR573YCyazIIlQB0AwF7wn1Do9YI2BGcQhCmI6mAG4F75b+zeg0V9/qUKLZImuTI7fweUXsseL4KCrV8kEQ85ZTWZ8FMHtwPi4p0hwq0lsZA0/W8lZ50YzirUp3YkjY0YtHt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738751369; c=relaxed/simple;
	bh=XTPxn9WRGlrKBXY4J7ul9HEN574LaZ3V1oKkkycRmZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rOIk6nufu1j6bxeT77Ug8A41IqgY4T36sBOSn4vPJ0ZB/X+yRK4+nKPU0uBnbVRHVZWV+Dc0kBbZyCpiI7qBZNyX0Oc6KggV8QTl1CzcmOsPppqKguivRMe5sWl8f6jlopp59Nh5adNPxmp1IsPqe6DH0kK+HFliu+dv05G9yJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a2lhbdNQ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738751368; x=1770287368;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XTPxn9WRGlrKBXY4J7ul9HEN574LaZ3V1oKkkycRmZQ=;
  b=a2lhbdNQZomxSKmSW3eWv36wduuOxcVYnPFj9KMyq39LfwTgUWW4OKqr
   0JPGUlR1s088JWmmHOo8I7GWitcXLrDYecg2MGMjLdSc/88gz6ieT1g4B
   IbxRFMS00KX5NZP7wQsYFwNJ1aFXdnAwVgPfW8hyreXQPcggmMN/Klqc8
   HAdrPY/kxyjHYz6JXMtXNvvjJEM08hheS38NbIVU1RILwllZ6kmzgVYp7
   1/WyoWpZ9Y83eY5WlaF1IQszBX1gvqz0FmpYSu5JnImI8t+1yDgh/578l
   +N5c8Z4lBpBBTwtbpLmGERF2OXQqA4Oe/UrwwMPuyo3i1IzgYcxh27zIW
   g==;
X-CSE-ConnectionGUID: A9verpnCSda+H02WtI0eLg==
X-CSE-MsgGUID: pG028hTyQUiquWowIIOOjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="49561800"
X-IronPort-AV: E=Sophos;i="6.13,261,1732608000"; 
   d="scan'208";a="49561800"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 02:29:27 -0800
X-CSE-ConnectionGUID: 0eTPcpoOR5C+FjvqLlBKmg==
X-CSE-MsgGUID: FTmLxHUGSa2Wf0Otyey+dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,261,1732608000"; 
   d="scan'208";a="110758770"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 02:29:22 -0800
Message-ID: <3633ee44-1e16-4e87-8f6d-4fed9e1f3a29@intel.com>
Date: Wed, 5 Feb 2025 18:29:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 48/52] i386/tdx: Fetch and validate CPUID of TD guest
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Eric Blake <eblake@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-49-xiaoyao.li@intel.com>
 <87o6zg3fl2.fsf@pond.sub.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87o6zg3fl2.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/5/2025 5:28 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
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
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/cpu.c     | 33 ++++++++++++++-
>>   target/i386/cpu.h     |  7 +++
>>   target/i386/kvm/tdx.c | 99 +++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 137 insertions(+), 2 deletions(-)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index f1330627adbb..a948fd0bd674 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -5482,8 +5482,8 @@ static bool x86_cpu_have_filtered_features(X86CPU *cpu)
>>       return false;
>>   }
>>   
>> -static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
>> -                                      const char *verbose_prefix)
>> +void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
>> +                               const char *verbose_prefix)
>>   {
>>       CPUX86State *env = &cpu->env;
>>       FeatureWordInfo *f = &feature_word_info[w];
>> @@ -5510,6 +5510,35 @@ static void mark_unavailable_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
>>       }
>>   }
>>   
>> +void mark_forced_on_features(X86CPU *cpu, FeatureWord w, uint64_t mask,
>> +                             const char *verbose_prefix)
>> +{
>> +    CPUX86State *env = &cpu->env;
>> +    FeatureWordInfo *f = &feature_word_info[w];
>> +    int i;
>> +
>> +    if (!cpu->force_features) {
>> +        env->features[w] |= mask;
>> +    }
>> +
>> +    cpu->forced_on_features[w] |= mask;
>> +
>> +    if (!verbose_prefix) {
>> +        return;
>> +    }
>> +
>> +    for (i = 0; i < 64; ++i) {
>> +        if ((1ULL << i) & mask) {
>> +            g_autofree char *feat_word_str = feature_word_description(f);
> 
> Does not compile for me:
> 
>      ../target/i386/cpu.c: In function ‘mark_forced_on_features’:
>      ../target/i386/cpu.c:5531:46: error: too few arguments to function ‘feature_word_description’
>       5531 |             g_autofree char *feat_word_str = feature_word_description(f);
>            |                                              ^~~~~~~~~~~~~~~~~~~~~~~~
>      ../target/i386/cpu.c:5451:14: note: declared here
>       5451 | static char *feature_word_description(FeatureWordInfo *f, uint32_t bit)
>            |              ^~~~~~~~~~~~~~~~~~~~~~~~

As mentioned in the cover letter, this series depends on a minor one:

https://lore.kernel.org/qemu-devel/20241217123932.948789-1-xiaoyao.li@intel.com/

>> +            warn_report("%s: %s%s%s [bit %d]",
>> +                        verbose_prefix,
>> +                        feat_word_str,
>> +                        f->feat_names[i] ? "." : "",
>> +                        f->feat_names[i] ? f->feat_names[i] : "", i);
>> +        }
>> +    }
>> +}
>> +
>>   static void x86_cpuid_version_get_family(Object *obj, Visitor *v,
>>                                            const char *name, void *opaque,
>>                                            Error **errp)
> 
> [...]
> 


