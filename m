Return-Path: <kvm+bounces-30708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCAD49BC954
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:35:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E7C5B23498
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241361D2232;
	Tue,  5 Nov 2024 09:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GYWbQkam"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CCF1D2211
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 09:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730799221; cv=none; b=OlUbANvSQ8lY3D0qP1aSwahfn3mNu6lZ5zpCIn0wrOyLlGJ7JqKW/iG4jP0TKCq7R4UlzIMQjim1tjySVfha4jNfTmTYNZRZnKKKifBQLT9niz3TwyLSmi0WzydxdGqE9nAPd1SJpoQLx1Ck0t7gC4cF/iQTsxCAS0KcJIm5Xdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730799221; c=relaxed/simple;
	bh=w64hPHh98IYSd/WCdWEVevsIAclFSM5mXCV/+w34kIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m4CgkyyTsVxRczJgECC9uuSbqhaJpnLrKjxeRCk+1C20NP+50g4xSORQ/AIuVB5mRgRLFz2Z8tF0T3g0XSw8yCXmVy6gLjibrrDTKDm2iSrUwsEmk7PnBl+eaSg6rVJkqQPHVr7wJR9ZpWpCH4GEbbDIr2v/7ov9V/qddo/JTtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GYWbQkam; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730799219; x=1762335219;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=w64hPHh98IYSd/WCdWEVevsIAclFSM5mXCV/+w34kIQ=;
  b=GYWbQkami+DFDplZ6e9Z493o7Iph6pYeVxFHt3eznpnvYJO+CesVJ4rW
   Y9CLy9aEgv0sQ/pzVRMxBPi3NPluiWfshMG7lTntCdRrSY89JiyEkWqVm
   wRPzcFLw+MrjtDYAk0RlfQihBfkywojn+A79xszC2YjRxVPkKhxA6TbXj
   EFcSz+SvCCmQSg+eo3OUYI5mh/kNlWw68lX0Ck16i5LE8IK9x7qXlloPA
   vRBuYA8YYLwQrVwQMjwI98g4/rnHLZ44G/QhcBa/b4OeKhXbMLPXHbMk0
   MJVcFqseRWc8jCMDtk6p48HDJDOHqlnAvSozIIN/Rpzpmw7H7Laiu/jVw
   w==;
X-CSE-ConnectionGUID: 6dja0wEQQta5cC1Uacc8yA==
X-CSE-MsgGUID: b7y4EKcsQESWJYku+5Lcdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="29956341"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="29956341"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 01:33:38 -0800
X-CSE-ConnectionGUID: qG0qnis7R5qNFTMbQjiHsQ==
X-CSE-MsgGUID: GaN+Cy+ZQxmtfI+cSd+6kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="89083274"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 01:33:33 -0800
Message-ID: <08939cf7-f27b-44c2-93cf-d0951d2d2141@intel.com>
Date: Tue, 5 Nov 2024 17:33:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 59/60] i386/cpu: Set up CPUID_HT in x86_cpu_realizefn()
 instead of cpu_x86_cpuid()
To: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-60-xiaoyao.li@intel.com>
 <9601f5a1-f1f1-47ab-a240-30331946b584@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <9601f5a1-f1f1-47ab-a240-30331946b584@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/2024 5:12 PM, Paolo Bonzini wrote:
> On 11/5/24 07:24, Xiaoyao Li wrote:
>> Otherwise, it gets warnings like below when number of vcpus > 1:
>>
>>    warning: TDX enforces set the feature: CPUID.01H:EDX.ht [bit 28]
>>
>> This is because x86_confidential_guest_check_features() checks
>> env->features[] instead of the cpuid date set up by cpu_x86_cpuid()
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/cpu.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 472ab206d8fe..214a1b00a815 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -6571,7 +6571,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t 
>> index, uint32_t count,
>>           *edx = env->features[FEAT_1_EDX];
>>           if (threads_per_pkg > 1) {
>>               *ebx |= threads_per_pkg << 16;
>> -            *edx |= CPUID_HT;
>>           }
>>           if (!cpu->enable_pmu) {
>>               *ecx &= ~CPUID_EXT_PDCM;
>> @@ -7784,6 +7783,8 @@ static void x86_cpu_realizefn(DeviceState *dev, 
>> Error **errp)
>>       Error *local_err = NULL;
>>       unsigned requested_lbr_fmt;
>> +    qemu_early_init_vcpu(cs);
>> +
>>   #if defined(CONFIG_TCG) && !defined(CONFIG_USER_ONLY)
>>       /* Use pc-relative instructions in system-mode */
>>       tcg_cflags_set(cs, CF_PCREL);
>> @@ -7851,6 +7852,14 @@ static void x86_cpu_realizefn(DeviceState *dev, 
>> Error **errp)
>>           }
>>       }
>> +    /*
>> +     * It needs to called after feature filter because KVM doesn't 
>> report HT
>> +     * as supported
> 
> Does it, since kvm_arch_get_supported_cpuid() has the following line?
> 
>      if (function == 1 && reg == R_EDX) {
>          ...
>          /* KVM never reports CPUID_HT but QEMU can support when vcpus > 
> 1 */
>          ret |= CPUID_HT;
> 
> ?

It seems I mixed it up with no_autoenable_flags. /faceplam

CPUID_HT doesn't get enabled by x86_cpu_expand_features() for "-cpu 
host/max". It won't be filtered by x86_cpu_filter_features() either 
because QEMU sets it in kvm_arch_get_supported_cpuid().

yes, the comment is wrong and comment needs to be dropped. The code can 
be move up to just below x86_cpu_expand_features() or inside it?

> Paolo
> 
>> +     */
>> +    if (cs->nr_cores * cs->nr_threads > 1) {
>> +        env->features[FEAT_1_EDX] |= CPUID_HT;
>> +    }
> 


