Return-Path: <kvm+bounces-31985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0709A9CFE34
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 11:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86BB5B21AD4
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 10:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E47519048A;
	Sat, 16 Nov 2024 10:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="pkSUlc7d"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ABA191484;
	Sat, 16 Nov 2024 10:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731753284; cv=none; b=Fz5bcZ4Od0+A3dRxO4QfeFMr6TMCY+YXl7mi/K9DF1QUJtRYjIk4SLVwiaXZorNqvEww914WG2fiYV9MCiG5Ki+SktAbfaehI/coN0/gixUswmBb/00oFta58R0Kwlq9qSRhsxXFl4pFMT5rLdUVkqH099KSr3ZRE/nhvvivCjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731753284; c=relaxed/simple;
	bh=wIVyp/7ICbtsn8aYA9PY6NhVFUFy2o5cyVtdv3OTLOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tlgREXzG1S5MPjQ0iY/AZtGrP7hgZD/wv+HvtQd+BdrsRNgOwDz2GzAFv+5C7oKjlkTtelHzkdlVgXZ6M/IsM9OrK8QqzOETM98ej0n+6gYXz+xYHgJHdHmqLWXdg3Ob6Ofc3pvkHvi9KT0DkTeZHqdgQqB4RyCI1dDfH9qrJ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=pkSUlc7d; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:4fa4:0:640:dbe3:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id D615460AA4;
	Sat, 16 Nov 2024 13:34:29 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:31::1:15] (unknown [2a02:6b8:b081:31::1:15])
	by mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id RYLQ1T0Ie4Y0-6g18ZEEY;
	Sat, 16 Nov 2024 13:34:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731753269;
	bh=yV+Y83OPVDgDA1jP5vd1HgYLCL54HObfQfH9dqmEPQU=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=pkSUlc7d0xicoc9zN55XELzByTGbbO5rjPs4d8wxL0+mnyM9xXPBnmgr5gzo7y85/
	 6DfeRU7KK3n/URcOgkM2guZ/FWEYCO2RIaE3Nv3vam6Y+s59IXWwc+TAvKHgu+H18Z
	 BsA/gIPtZOgMpLcpVw2I/62hsJ03ix45HVOP2pP0=
Authentication-Results: mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <a9549e7a-4808-4020-852f-db5a19291da4@yandex-team.ru>
Date: Sat, 16 Nov 2024 13:34:27 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to userspace
To: babu.moger@amd.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 seanjc@google.com, sandipan.das@amd.com, bp@alien8.de, mingo@redhat.com,
 tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 pbonzini@redhat.com
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
 <20241113133042.702340-2-davydov-max@yandex-team.ru>
 <5267175a-27ed-9293-c780-ed22b13bb8ca@amd.com>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <5267175a-27ed-9293-c780-ed22b13bb8ca@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi!

On 11/15/24 22:51, Moger, Babu wrote:
> Hi Maksim,
> 
> On 11/13/2024 7:30 AM, Maksim Davydov wrote:
>> Fast short REP STOSB and fast short CMPSB support on AMD processors are
>> provided in other CPUID function in comparison with Intel processors:
>> * FSRS: 10 bit in 0x80000021_EAX
>> * FSRC: 11 bit in 0x80000021_EAX
>>
>> AMD bit numbers differ from existing definition of FSRC and
>> FSRS. So, the new appropriate values have to be added with new names.
>>
>> It's safe to advertise these features to userspace because they are a 
>> part
>> of CPU model definition and they can't be disabled (as existing Intel
>> features).
>>
>> Fixes: 2a4209d6a9cb ("KVM: x86: Advertise fast REP string features 
>> inherent to the CPU")
>> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
>> ---
>>   arch/x86/include/asm/cpufeatures.h | 2 ++
>>   arch/x86/kvm/cpuid.c               | 4 ++--
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h 
>> b/arch/x86/include/asm/cpufeatures.h
>> index 913fd3a7bac6..2f8a858325a4 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -457,6 +457,8 @@
>>   #define X86_FEATURE_NULL_SEL_CLR_BASE    (20*32+ 6) /* Null Selector 
>> Clears Base */
>>   #define X86_FEATURE_AUTOIBRS        (20*32+ 8) /* Automatic IBRS */
>>   #define X86_FEATURE_NO_SMM_CTL_MSR    (20*32+ 9) /* SMM_CTL MSR is 
>> not present */
>> +#define X86_FEATURE_AMD_FSRS            (20*32+10) /* AMD Fast short 
>> REP STOSB supported */
>> +#define X86_FEATURE_AMD_FSRC        (20*30+11) /* AMD Fast short REP 

Sorry
I made a mistake (30 instead of 32) while preparing the patch.
I'll prepare the new version.

>> CMPSB supported */
>>   #define X86_FEATURE_SBPB        (20*32+27) /* Selective Branch 
>> Prediction Barrier */
>>   #define X86_FEATURE_IBPB_BRTYPE        (20*32+28) /* 
>> MSR_PRED_CMD[IBPB] flushes all branch type predictions */
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 41786b834b16..30ce1bcfc47f 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -793,8 +793,8 @@ void kvm_set_cpu_caps(void)
>>       kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
>>           F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
>> -        F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
>> -        F(WRMSR_XX_BASE_NS)
>> +        F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | F(AMD_FSRS) |
>> +        F(AMD_FSRC) | 0 /* PrefetchCtlMsr */ | F(WRMSR_XX_BASE_NS)
> 
> KVM still does not report AMD_FSRC.
> 
> The KVM_GET_SUPPORTED_CPUID output for the function 0x80000021.
> 
> {0x80000021, 0000, eax = 0x1800074f, ebx= 0000000000, ecx = 0000000000, 
> edx= 0000000000}, /* 0 */
> 
> 
> 
>>       );
>>       kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
> 

-- 
Best regards,
Maksim Davydov

