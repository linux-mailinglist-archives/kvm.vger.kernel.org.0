Return-Path: <kvm+bounces-31987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 966849CFEB2
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 12:51:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04B2FB2739A
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 11:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5436372;
	Sat, 16 Nov 2024 11:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="L5RpzLVG"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D508191F79;
	Sat, 16 Nov 2024 11:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731757893; cv=none; b=Yx0XWQJnU6NMmeWS+ph06NsuH9ZNtLW9ZL3DYjmcfydG7JLs5fktiHnALIgWgBhmOkYGBqKdWkmPgMA0k8PaTIIuyZTcb/C2JPqUk3maWqL2OvKeo06w8LdWgh+VCwlafVKY5gpi3K3ozDQ+5dZ620WVB+JRArOBRXzsjS9NqBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731757893; c=relaxed/simple;
	bh=zjSieOGSsTlLTPpNO6omIXwm9Z/p2nQc687IZdk4QMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSUfyjjl5z3vAn37hjlPi4Wza9bo2yl1BlGNrf53hGx3UlNqsZE36/juXUI82RU5FSfvXV4zm+Adas40UAZRsyb97q5keA3si08m5ciu+toF9Sekb/bfV071uY1BjdJ3j2zo6EsCHykQjsf5SyCe69s82RyjsZSkwr+zv8upmLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=L5RpzLVG; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:3012:0:640:8a85:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 0F18760DE7;
	Sat, 16 Nov 2024 14:51:23 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:31::1:15] (unknown [2a02:6b8:b081:31::1:15])
	by mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id KpMb544IeW20-gFRURnEk;
	Sat, 16 Nov 2024 14:51:22 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731757882;
	bh=mLKf107S93FqCQbbr24sJjIFfMKG7H9cyJuCevJGsvE=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=L5RpzLVG6T8lr/LDHxEuMCXU2j2t3QKpJjPNWP+kUqmBqyf/1+brskCCiTRua0N7e
	 CgNgXrhjBH8YSbKEhdydXJWozEuT2zNuhPqip1kpbumPTPoFnpAwU6FnhLD8WzofF8
	 KEbXhezhJhhd5bWnQmUiIv/ouZqAwulupH9I5n3w=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <8160befa-322b-4f61-97e0-9caa32defc2a@yandex-team.ru>
Date: Sat, 16 Nov 2024 14:51:20 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] x86: KVM: Advertise AMD's speculation control
 features
To: babu.moger@amd.com, Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 seanjc@google.com, sandipan.das@amd.com, bp@alien8.de, mingo@redhat.com,
 tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 pbonzini@redhat.com
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
 <20241113133042.702340-3-davydov-max@yandex-team.ru>
 <2813ba0d-7e5d-03d4-26df-d5283b9c0549@amd.com>
 <CALMp9eT2RMe9ej_UbbeoKb+1hqWypxWswqg2aGodZHC0Vgoc=Q@mail.gmail.com>
 <3d182f98-d717-ff12-9640-f691a3840fbe@amd.com>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <3d182f98-d717-ff12-9640-f691a3840fbe@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi!

On 11/16/24 00:29, Moger, Babu wrote:
> 
> 
> On 11/15/2024 2:32 PM, Jim Mattson wrote:
>> On Fri, Nov 15, 2024 at 12:13 PM Moger, Babu <bmoger@amd.com> wrote:
>>>
>>> Hi Maksim,
>>>
>>>
>>> On 11/13/2024 7:30 AM, Maksim Davydov wrote:
>>>> It seems helpful to expose to userspace some speculation control 
>>>> features
>>>> from 0x80000008_EBX function:
>>>> * 16 bit. IBRS always on. Indicates whether processor prefers that
>>>>     IBRS is always on. It simplifies speculation managing.
>>>
>>> Spec say bit 16 is reserved.
>>>
>>> 16 Reserved
>>>
>>> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
>>
>> The APM volume 3 ( 24594—Rev. 3.36—March 2024) declares this bit as
>> "Processor prefers that STIBP be left on." Once a bit has been
>> documented like that, you have to assume that software has been
>> written that expects those semantics. AMD does not have the option of
>> undocumenting the bit.  You can deprecate it, but it now has the
>> originally documented semantics until the end of time.
> 
> Yes. Agreed.
> 
>>
>>>> * 18 bit. IBRS is preferred over software solution. Indicates that
>>>>     software mitigations can be replaced with more performant IBRS.
>>>> * 19 bit. IBRS provides Same Mode Protection. Indicates that when IBRS
>>>>     is set indirect branch predictions are not influenced by any prior
>>>>     indirect branches.
>>>> * 29 bit. BTC_NO. Indicates that processor isn't affected by branch 
>>>> type
>>>>     confusion. It's used during mitigations setting up.
>>>> * 30 bit. IBPB clears return address predictor. It's used during
>>>>     mitigations setting up.
>>>>
>>>> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
>>>> ---
>>>>    arch/x86/include/asm/cpufeatures.h | 3 +++
>>>>    arch/x86/kvm/cpuid.c               | 5 +++--
>>>>    2 files changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/cpufeatures.h 
>>>> b/arch/x86/include/asm/cpufeatures.h
>>>> index 2f8a858325a4..f5491bba75fc 100644
>>>> --- a/arch/x86/include/asm/cpufeatures.h
>>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>>> @@ -340,7 +340,10 @@
>>>>    #define X86_FEATURE_AMD_IBPB                (13*32+12) /* 
>>>> Indirect Branch Prediction Barrier */
>>>>    #define X86_FEATURE_AMD_IBRS                (13*32+14) /* 
>>>> Indirect Branch Restricted Speculation */
>>>>    #define X86_FEATURE_AMD_STIBP               (13*32+15) /* Single 
>>>> Thread Indirect Branch Predictors */
>>>> +#define X86_FEATURE_AMD_IBRS_ALWAYS_ON       (13*32+16) /* Indirect 
>>>> Branch Restricted Speculation always-on preferred */
>>>
>>> You might have to remove this.
>>
>> No; it's fine. The bit can never be used for anything else.
> 
> That is true.
> But, Hardware does not report this bit yet (at least on my system). So, 
> I am thinking it may not be required to add at this point.
> 

Yes, I used information about bits from "AMD64 Architecture Programmer’s 
Manual". So I thought, if the bit is defined in this manual, it can be 
used in any processor.
I've checked PPRs for EPYC Rome, Milan and Genoa and the 16 bit is 
reserved for all of these processors. But I don't know if there are any 
other processors with the 16 bit set.

>>
>>>>    #define X86_FEATURE_AMD_STIBP_ALWAYS_ON     (13*32+17) /* Single 
>>>> Thread Indirect Branch Predictors always-on preferred */
>>>> +#define X86_FEATURE_AMD_IBRS_PREFERRED       (13*32+18) /* Indirect 
>>>> Branch Restricted Speculation is preferred over SW solution */
>>>> +#define X86_FEATURE_AMD_IBRS_SMP     (13*32+19) /* Indirect Branch 
>>>> Restricted Speculation provides Same Mode Protection */
>>>>    #define X86_FEATURE_AMD_PPIN                (13*32+23) /* 
>>>> "amd_ppin" Protected Processor Inventory Number */
>>>>    #define X86_FEATURE_AMD_SSBD                (13*32+24) /* 
>>>> Speculative Store Bypass Disable */
>>>>    #define X86_FEATURE_VIRT_SSBD               (13*32+25) /* 
>>>> "virt_ssbd" Virtualized Speculative Store Bypass Disable */
>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>> index 30ce1bcfc47f..5b2d52913b18 100644
>>>> --- a/arch/x86/kvm/cpuid.c
>>>> +++ b/arch/x86/kvm/cpuid.c
>>>> @@ -754,8 +754,9 @@ void kvm_set_cpu_caps(void)
>>>>        kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>>>>                F(CLZERO) | F(XSAVEERPTR) |
>>>>                F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) 
>>>> | F(VIRT_SSBD) |
>>>> -             F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
>>>> -             F(AMD_PSFD)
>>>> +             F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_IBRS_ALWAYS_ON) |
>>>> +             F(AMD_STIBP_ALWAYS_ON) | F(AMD_IBRS_PREFERRED) |
>>>> +             F(AMD_IBRS_SMP) | F(AMD_PSFD) | F(BTC_NO) | 
>>>> F(AMD_IBPB_RET)
>>>>        );
>>>>
>>>>        /*
>>>
>>> -- 
>>> - Babu Moger
>>>
>>
> 

-- 
Best regards,
Maksim Davydov

