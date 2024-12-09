Return-Path: <kvm+bounces-33299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C5989E9390
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 13:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27643282D0A
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 12:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3CE227564;
	Mon,  9 Dec 2024 12:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="gfJntC8e"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D92226ED1;
	Mon,  9 Dec 2024 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733746295; cv=none; b=VRsltNs3S0FV6zAvqSxoaVt4DMMUzz6ufljc7WbCzGvVQjAC2A0i+V4nN1C598ff0AEXE1ZUVOHiyqBsm4VJdKm3XT8S8iIcdS2v/q7YxRCqf9EB6xetChGesk8PxY8JZgp8UmUrIwDMqid0gt55ixfhIjTxv0E6Ml6ghmGcMv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733746295; c=relaxed/simple;
	bh=nLJIyW85n0iG/LGd0OlFrIef41P6XBUUwdj9WHcaJKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jgW+IxjjIaWxLaaaTbHwTV1NsKtJ9Uc7KrDrI76GLrn7MPSRHgWgleFpznfF+zxr1MTOT0PWPHtphs8juOLI3Vw61U3ig4/nnHc4dE0zT33A1pMbuI19qn3afAeRA6mmZIXTokAv+vSTAbwtCsoCnhDQVq5VEjE3EHDheNfgvzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=gfJntC8e; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:b1cb:0:640:2a1e:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 3300A608FD;
	Mon,  9 Dec 2024 15:11:13 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b538::1:36] (unknown [2a02:6b8:b081:b538::1:36])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 8Bkmmc2Ika60-5Egy2zMB;
	Mon, 09 Dec 2024 15:11:12 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1733746272;
	bh=1Vsfc9wfTmLL+2IpExTUiXquTUYyLpZZYOFXY08eRyw=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=gfJntC8eAeQw1nnucT0s9zfyGmY0qCO/pBgXO+4L3YnilPRDVZ8pK0VOKHyx55hGe
	 /jdz9z4O/72LCcPMOrTnyMWxvlW7NqzGXCeFg1m1hje684j9LQypMraKuHdrq0PWYR
	 gY/s//Uq3xYpOx4IarIhLZSd90Wn2BQreaH4RGvs=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <c05ea1c3-28ae-4c31-b204-05db59b626d6@yandex-team.ru>
Date: Mon, 9 Dec 2024 15:11:08 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to
 userspace
To: "Moger, Babu" <bmoger@amd.com>, Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 babu.moger@amd.com, seanjc@google.com, mingo@redhat.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 pbonzini@redhat.com
References: <20241204134345.189041-1-davydov-max@yandex-team.ru>
 <20241204134345.189041-2-davydov-max@yandex-team.ru>
 <CALMp9eRa3yJ=-azTVtsapHsfCFTo74mTMQXPkguxD3P8upYchg@mail.gmail.com>
 <69fa0014-a5bd-4e1f-94b6-f22e9688ab71@amd.com>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <69fa0014-a5bd-4e1f-94b6-f22e9688ab71@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 12/6/24 21:11, Moger, Babu wrote:
> 
> On 12/4/2024 10:57 AM, Jim Mattson wrote:
>> On Wed, Dec 4, 2024 at 5:43 AM Maksim Davydov
>> <davydov-max@yandex-team.ru>  wrote:
>>> Fast short REP STOSB and fast short CMPSB support on AMD processors are
>>> provided in other CPUID function in comparison with Intel processors:
>>> * FSRS: 10 bit in 0x80000021_EAX
>>> * FSRC: 11 bit in 0x80000021_EAX
>> I have to wonder why these bits aren't documented in the APM. I assume
>> you pulled them out of some PPR? I would be hesitant to include CPUID
>> bit definitions that may be microarchitecture-specific rather than
>> architectural.
>>
>> Perhaps someone from AMD should at least ACK this change?
> 
> APM updates are in progress right now, but haven’t been able to get an ETA.
> 
> Will confirm once APM is released.
>

Thanks a lot!
It means that this series should be sent as 2 independent parts:
1. FSRS and FSRC will wait for updated APM
2. Speculation control bits will be sent as a separate patch

>>> AMD bit numbers differ from existing definition of FSRC and
>>> FSRS. So, the new appropriate values have to be added with new names.
>>>
>>> It's safe to advertise these features to userspace because they are a part
>>> of CPU model definition and they can't be disabled (as existing Intel
>>> features).
>>>
>>> Fixes: 2a4209d6a9cb ("KVM: x86: Advertise fast REP string features inherent to the CPU")
>>> Signed-off-by: Maksim Davydov<davydov-max@yandex-team.ru>
>>> ---
>>>   arch/x86/include/asm/cpufeatures.h | 2 ++
>>>   arch/x86/kvm/cpuid.c               | 4 ++--
>>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>>> index 17b6590748c0..45f87a026bba 100644
>>> --- a/arch/x86/include/asm/cpufeatures.h
>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>> @@ -460,6 +460,8 @@
>>>   #define X86_FEATURE_NULL_SEL_CLR_BASE  (20*32+ 6) /* Null Selector Clears Base */
>>>   #define X86_FEATURE_AUTOIBRS           (20*32+ 8) /* Automatic IBRS */
>>>   #define X86_FEATURE_NO_SMM_CTL_MSR     (20*32+ 9) /* SMM_CTL MSR is not present */
>>> +#define X86_FEATURE_AMD_FSRS           (20*32+10) /* AMD Fast short REP STOSB supported */
>>> +#define X86_FEATURE_AMD_FSRC           (20*32+11) /* AMD Fast short REP CMPSB supported */
>>>
>>>   #define X86_FEATURE_SBPB               (20*32+27) /* Selective Branch Prediction Barrier */
>>>   #define X86_FEATURE_IBPB_BRTYPE                (20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 097bdc022d0f..7bc095add8ee 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -799,8 +799,8 @@ void kvm_set_cpu_caps(void)
>>>
>>>          kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
>>>                  F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
>>> -               F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
>>> -               F(WRMSR_XX_BASE_NS)
>>> +               F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | F(AMD_FSRS) |
>>> +               F(AMD_FSRC) | 0 /* PrefetchCtlMsr */ | F(WRMSR_XX_BASE_NS)
>>>          );
>>>
>>>          kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
>>> --
>>> 2.34.1
>>>

-- 
Best regards,
Maksim Davydov

