Return-Path: <kvm+bounces-37084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E46A24EB4
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 15:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32D2F7A24F2
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 14:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CBE51FAC38;
	Sun,  2 Feb 2025 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g8jVjB+t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A5D1D90AD
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738507156; cv=none; b=hVeeYF80TRl8qYgHIxCKboeDXg5udi4PeRqIdvyyDn5M1jADqjlo7tG+FEvYMnbqJT1hqWRyOUSWxtUYATonOmwg9OjxwuSyeloq2nkcQBiiUutOiNayZ1AtbRWNQded6j47h1FKt55/SF2JSvfYothcmEb0yfQt/U5soMwuRs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738507156; c=relaxed/simple;
	bh=iPIUexgfl/nH+sknvP912xNQqEwXm19jPq4R/uL8ufs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kppBqYt/bgiSydEWoAfRJv6J+kwkebPoGHIFobDak+U9mWx24a9nYrr2Zw3Z7fPgtARCj7ukGuhdMovMEh69zhYAv2o1UBD3ZNRUPqNHDzbnvSnxixzHy+nx+44ZFI98wik9jeNG39uQnol02UaiPVnErY6nvx7mzrigIPEw8dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g8jVjB+t; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738507154; x=1770043154;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iPIUexgfl/nH+sknvP912xNQqEwXm19jPq4R/uL8ufs=;
  b=g8jVjB+t32joXY29HariClXHeD6R8TVF0fCX+wrBoJ0bCjj60rEmOS9b
   Dzc10W53lcSwX1tpG5Y4bFTG6+qwhXs//z0/dqSzJMXALIqYmvgGCfzAY
   fHLsnXip+EKtK2wEVpio3ANUDpH7wdvyXVdixFjnOQlUIHc/eo7yOYJaD
   pZEmOuza0xbv0VlXrODJXA2PdxFKWP5MP5BTjD6TSIo5auuziq6E9AZ1l
   V2K+aPjgDkMDHNbIFswdWiJ9f5etPgKRbT/ttt1bJqkTCJQ0l71EvnnF6
   +hL4dv+wLFhV76gQfCgSIHIC2xNX8ff9s8r4EJfSr/0DBE1kS0MaHFXUM
   g==;
X-CSE-ConnectionGUID: FwTcU/B7TCywMZemmzosnA==
X-CSE-MsgGUID: JNbiTbBWQG+X1ARoeohFKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11334"; a="39167032"
X-IronPort-AV: E=Sophos;i="6.13,254,1732608000"; 
   d="scan'208";a="39167032"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2025 06:39:14 -0800
X-CSE-ConnectionGUID: B+mnSoiAQZ28uG1kztDMSQ==
X-CSE-MsgGUID: CMjMRBjdRye/bMKwn2Av7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,254,1732608000"; 
   d="scan'208";a="115066821"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2025 06:39:10 -0800
Message-ID: <774945ce-04e2-42d5-83fc-97ad08647101@intel.com>
Date: Sun, 2 Feb 2025 22:39:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 51/52] i386/tdx: Validate phys_bits against host value
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-52-xiaoyao.li@intel.com>
 <CABgObfb5ruVO2sxLCbZobiaqX-3h9Q+UKOZnp_hhxfJA=T-OJA@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CABgObfb5ruVO2sxLCbZobiaqX-3h9Q+UKOZnp_hhxfJA=T-OJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/1/2025 2:27 AM, Paolo Bonzini wrote:
> On Fri, Jan 24, 2025 at 2:40 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> For TDX guest, the phys_bits is not configurable and can only be
>> host/native value.
>>
>> Validate phys_bits inside tdx_check_features().
> 
> Hi Xiaoyao,
> 
> to avoid
> 
> qemu-kvm: TDX requires guest CPU physical bits (48) to match host CPU
> physical bits (52)
> 
> I need options like
> 
> -cpu host,phys-bits=52,guest-phys-bits=52,host-phys-bits-limit=52,-kvm-asyncpf-int
> 
> to start a TDX guest, is that intentional?

"-cpu host" should be sufficient and should not hit the error.

why did you get "guest CPU physical bits (48)"?

> Thanks,
> 
> Paolo
> 
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   target/i386/host-cpu.c | 2 +-
>>   target/i386/host-cpu.h | 1 +
>>   target/i386/kvm/tdx.c  | 8 ++++++++
>>   3 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
>> index 3e4e85e729c8..8a15af458b05 100644
>> --- a/target/i386/host-cpu.c
>> +++ b/target/i386/host-cpu.c
>> @@ -15,7 +15,7 @@
>>   #include "system/system.h"
>>
>>   /* Note: Only safe for use on x86(-64) hosts */
>> -static uint32_t host_cpu_phys_bits(void)
>> +uint32_t host_cpu_phys_bits(void)
>>   {
>>       uint32_t eax;
>>       uint32_t host_phys_bits;
>> diff --git a/target/i386/host-cpu.h b/target/i386/host-cpu.h
>> index 6a9bc918baa4..b97ec01c9bec 100644
>> --- a/target/i386/host-cpu.h
>> +++ b/target/i386/host-cpu.h
>> @@ -10,6 +10,7 @@
>>   #ifndef HOST_CPU_H
>>   #define HOST_CPU_H
>>
>> +uint32_t host_cpu_phys_bits(void);
>>   void host_cpu_instance_init(X86CPU *cpu);
>>   void host_cpu_max_instance_init(X86CPU *cpu);
>>   bool host_cpu_realizefn(CPUState *cs, Error **errp);
>> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
>> index bb75eb06dad9..c906a76c4c0e 100644
>> --- a/target/i386/kvm/tdx.c
>> +++ b/target/i386/kvm/tdx.c
>> @@ -24,6 +24,7 @@
>>
>>   #include "cpu.h"
>>   #include "cpu-internal.h"
>> +#include "host-cpu.h"
>>   #include "hw/i386/e820_memory_layout.h"
>>   #include "hw/i386/x86.h"
>>   #include "hw/i386/tdvf.h"
>> @@ -838,6 +839,13 @@ static int tdx_check_features(X86ConfidentialGuest *cg, CPUState *cs)
>>           return -1;
>>       }
>>
>> +    if (cpu->phys_bits != host_cpu_phys_bits()) {
>> +        error_report("TDX requires guest CPU physical bits (%u) "
>> +                     "to match host CPU physical bits (%u)",
>> +                     cpu->phys_bits, host_cpu_phys_bits());
>> +        exit(1);
>> +    }
>> +
>>       return 0;
>>   }
>>
>> --
>> 2.34.1
>>
> 
> 


