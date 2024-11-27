Return-Path: <kvm+bounces-32565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7214E9DA6DC
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 12:26:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35436281C69
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 11:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670D31F7592;
	Wed, 27 Nov 2024 11:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="ZYovNeSs"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081881F7580;
	Wed, 27 Nov 2024 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732706799; cv=none; b=Owcr8v8Rj+6yF4udaLMRG41vc+d/VE7E9fPaVDIxRFWKSv/Tq03xj+a+p99F3lr0yP4DSaXxf2iIOELlk5hifs83fXIlrMtDOD5BkSLT2X7ntPOubCQgSHKrZNLBsqcLr/Jx+c5dhOWhQtQuZI/eowHYfb67Ulgd2np1hMVE/tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732706799; c=relaxed/simple;
	bh=D2eQF5mgbsyrxPpbju76xhbJL0GFoW4vkZixO1AN/dQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o/vlHddbJlkWvNb7fbX8+55/gFg0e9crRgs+XpRRf1WGmdaKWqMLy6b+nA9+KW5wsAmUgyKuZPTIr2y7XAelsinKz1ia83glmM1o3dV0YSGPJrXbZzLEZMt0HebE27QG3kmCA6gt4srxxQTWH9P3noIl5jW6Up2h5fK/aNzGX2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=ZYovNeSs; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3b05:0:640:71ba:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 645566149C;
	Wed, 27 Nov 2024 14:26:25 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8011:701:66e1:20a5:ba04:640b] (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id NQXpOa0IdW20-SBv4QkLj;
	Wed, 27 Nov 2024 14:26:24 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1732706784;
	bh=nv3E9lyzcT86UpCM0PKF51rK/xDhCxSUaDkaJMEa42k=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=ZYovNeSs3bTOf0KgYxlyYFjeGpKBlCTaSf50S+O8Q7XyR0Lot/nwRLO57EaTmsAs5
	 cKW3jsbB2VpBxns6XW1+xobxquxakZNx1FnN7Ow8Cy0YPW77LVayQNbWO2ThImJQut
	 DVmPwoPSmW5PmrmwbJwk9agSX03D1W/yDbCgHscU=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <0ad3de06-19b1-4be4-968c-ad6ba072097c@yandex-team.ru>
Date: Wed, 27 Nov 2024 14:26:23 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86: KVM: Advertise AMD's speculation control
 features
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 babu.moger@amd.com, seanjc@google.com, mingo@redhat.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 pbonzini@redhat.com
References: <20241126094424.943192-1-davydov-max@yandex-team.ru>
 <20241126094424.943192-3-davydov-max@yandex-team.ru>
 <CALMp9eS5VzbqthF03tQoXkKK+hRYsH4sxuL3hwY-vud6Vez8xQ@mail.gmail.com>
Content-Language: en-US
From: Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <CALMp9eS5VzbqthF03tQoXkKK+hRYsH4sxuL3hwY-vud6Vez8xQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/26/24 20:11, Jim Mattson wrote:
> On Tue, Nov 26, 2024 at 1:45 AM Maksim Davydov
> <davydov-max@yandex-team.ru> wrote:
>>
>> It seems helpful to expose to userspace some speculation control features
>> from 0x80000008_EBX function:
>> * 16 bit. IBRS always on. Indicates whether processor prefers that
>>    IBRS is always on. It simplifies speculation managing.
>> * 18 bit. IBRS is preferred over software solution. Indicates that
>>    software mitigations can be replaced with more performant IBRS.
>> * 19 bit. IBRS provides Same Mode Protection. Indicates that when IBRS
>>    is set indirect branch predictions are not influenced by any prior
>>    indirect branches.
>> * 29 bit. BTC_NO. Indicates that processor isn't affected by branch type
>>    confusion. It's used during mitigations setting up.
>> * 30 bit. IBPB clears return address predictor. It's used during
>>    mitigations setting up.
>>
>> Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
>> ---
>>   arch/x86/include/asm/cpufeatures.h | 3 +++
>>   arch/x86/kvm/cpuid.c               | 5 +++--
>>   2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index f6be4fd2ead0..ba371d364c58 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -340,7 +340,10 @@
>>   #define X86_FEATURE_AMD_IBPB           (13*32+12) /* Indirect Branch Prediction Barrier */
>>   #define X86_FEATURE_AMD_IBRS           (13*32+14) /* Indirect Branch Restricted Speculation */
>>   #define X86_FEATURE_AMD_STIBP          (13*32+15) /* Single Thread Indirect Branch Predictors */
>> +#define X86_FEATURE_AMD_IBRS_ALWAYS_ON (13*32+16) /* Indirect Branch Restricted Speculation always-on preferred */
>>   #define X86_FEATURE_AMD_STIBP_ALWAYS_ON        (13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
>> +#define X86_FEATURE_AMD_IBRS_PREFERRED (13*32+18) /* Indirect Branch Restricted Speculation is preferred over SW solution */
>> +#define X86_FEATURE_AMD_IBRS_SMP       (13*32+19) /* Indirect Branch Restricted Speculation provides Same Mode Protection */
> 
> "SMP" is an unfortunate overloading of an acronym with another
> well-known meaning. Perhaps "SAME_MODE"?
> 

Thanks a lot for reviewing!
Yep, you are right. I've missed that "SMP" can confuse someone. So, 
"X86_FEATURE_AMD_IBRS_SAME_MODE" seems pretty good because the similar 
name is used in APM. I'll prepare the third version soon.


>>   #define X86_FEATURE_AMD_PPIN           (13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
>>   #define X86_FEATURE_AMD_SSBD           (13*32+24) /* Speculative Store Bypass Disable */
>>   #define X86_FEATURE_VIRT_SSBD          (13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 30ce1bcfc47f..5b2d52913b18 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -754,8 +754,9 @@ void kvm_set_cpu_caps(void)
>>          kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>>                  F(CLZERO) | F(XSAVEERPTR) |
>>                  F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
>> -               F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
>> -               F(AMD_PSFD)
>> +               F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_IBRS_ALWAYS_ON) |
>> +               F(AMD_STIBP_ALWAYS_ON) | F(AMD_IBRS_PREFERRED) |
>> +               F(AMD_IBRS_SMP) | F(AMD_PSFD) | F(BTC_NO) | F(AMD_IBPB_RET)
>>          );
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>

-- 
Best regards,
Maksim Davydov

