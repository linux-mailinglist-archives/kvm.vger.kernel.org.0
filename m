Return-Path: <kvm+bounces-57779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0ECAB5A169
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 21:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 832EC166DBA
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259D931E895;
	Tue, 16 Sep 2025 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="meoOMH4h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D862DE707
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 19:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758050783; cv=none; b=nqLUpCkNoLRQveRfDqNMSEcVxSEp5Ddg/zs25A7j2mOrVRrZkDcXtk7do+cPpPRMkRrDjD4cuqlzw2BgrEvI5lRPChR3r3ilFvTSImtFTuD1zJSsX2WwUNLB4zmPNV5XwWQ59ZWjS0hkn85na3S4J70l0raKTE/BxUun2r9a13E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758050783; c=relaxed/simple;
	bh=+QYDaiEM2KG21MiXx/+wdmt5lXglM/W/LVWxjswsAt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OSMhrCsFNnUZP7lDbaWu16LzOE+gI/BUXAM3m9tn8GxbeDUBmJuUIRkm5KI0UsbgXFIj3tF/mEWr3mRagYjpdYiQwwbmNYyV5bk62hrvSA/w3/Ubbxyknvb0pBVisDry7OMqU5pLqsSeYRlvBSGlRseK84GgsUCD7u7sc4lByDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=meoOMH4h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CD8C4CEEB;
	Tue, 16 Sep 2025 19:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758050783;
	bh=+QYDaiEM2KG21MiXx/+wdmt5lXglM/W/LVWxjswsAt0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=meoOMH4h+VQ4HH0jQtpdXelt1Q0BKdo3e0+i8xNpxvjnTMhHkgmoHdz6bRkVLAdE4
	 ra4uVKBzNymnLe8Ac477HEYw5E+DtbMKmmOqy0ruppmnv/pNzzY0bnerwKStO92v/l
	 7hyf3+PQ5AgIlVT4goLDPFKz4oEhR5bsZe0nnjVh5c/AWerRo3AAeYsRGoLA4ImOL/
	 oNlz5yTM61h1f401dKpim8lWZRH2LiavpXUvFjuEBDktftwj4A15rTo2coW8kDBopl
	 9bITvgRS7qhiy3/rNtiHV7yEKwGIe5diVs4dOJGvc3hMOrhpuuSRUdTaZ3qSNamtrI
	 REvQrQiTyPsiw==
Message-ID: <fa63be53-8769-4761-b878-556f20e1fbfc@kernel.org>
Date: Tue, 16 Sep 2025 14:26:21 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/5] KVM: SVM: Stop warning if x2AVIC feature bit
 alone is enabled
To: Naveen N Rao <naveen@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Vasant Hegde <vasant.hegde@amd.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
References: <cover.1756993734.git.naveen@kernel.org>
 <62c338a17fe5127215efbfd8f7c5322b7b49a294.1756993734.git.naveen@kernel.org>
 <aMhxaAh6a3Eps_NJ@google.com>
 <wo2sfg7sxkpnemiznpjtjou4xc6alad2muewkjulqk2wr2lc5q@vlb7m34ez2il>
 <f9d43ba5-0655-4a4e-b911-30b11615361d@kernel.org>
 <aMlrewJeXm-_ierH@google.com>
 <villgy3ehps5puo3grrs2zoknbr7oyuy3jikr2cvikm4xrdgtd@ftkyxrfmptsl>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <villgy3ehps5puo3grrs2zoknbr7oyuy3jikr2cvikm4xrdgtd@ftkyxrfmptsl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/25 1:37 PM, Naveen N Rao wrote:
> On Tue, Sep 16, 2025 at 06:51:55AM -0700, Sean Christopherson wrote:
>> On Tue, Sep 16, 2025, Mario Limonciello wrote:
>>> On 9/16/25 2:14 AM, Naveen N Rao wrote:
>>>> On Mon, Sep 15, 2025 at 01:04:56PM -0700, Sean Christopherson wrote:
>>>>> On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
>>>>>> A platform can choose to disable AVIC by turning off the AVIC CPUID
>>>>>> feature bit, while keeping x2AVIC CPUID feature bit enabled to indicate
>>>>>> AVIC support for the x2APIC MSR interface. Since this is a valid
>>>>>> configuration, stop printing a warning.
>>>>>>
>>>>>> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
>>>>>> ---
>>>>>>    arch/x86/kvm/svm/avic.c | 8 +-------
>>>>>>    1 file changed, 1 insertion(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>>>>>> index a34c5c3b164e..346cd23a43a9 100644
>>>>>> --- a/arch/x86/kvm/svm/avic.c
>>>>>> +++ b/arch/x86/kvm/svm/avic.c
>>>>>> @@ -1101,14 +1101,8 @@ bool avic_hardware_setup(void)
>>>>>>    	if (!npt_enabled)
>>>>>>    		return false;
>>>>>> -	/* AVIC is a prerequisite for x2AVIC. */
>>>>>> -	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
>>>>>> -		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
>>>>>> -			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
>>>>>> -			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
>>>>>
>>>>> I agree with the existing code, KVM should treat this as a firmware bug, where
>>>>> "firmware" could also be the host VMM.  AIUI, x2AVIC can't actualy work without
>>>>> AVIC support, so enumerating x2AVIC without AVIC is pointless and unexpected.
>>>>
>>>> There are platforms where this is the case though:
>>>>
>>>> $ cpuid -1 -l 0x8000000A | grep -i avic
>>>>         AVIC: AMD virtual interrupt controller  = false
>>>>         X2AVIC: virtualized X2APIC              = true
>>>>         extended LVT AVIC access changes        = true
>>>>
>>>> The above is from Zen 4 (Phoenix), and my primary concern is that we
>>>> will start printing a warning by default. Besides, there isn't much a
>>>> user can do here (except start using force_avic, which will taint the
>>>> kernel). Maybe we can warn only if AVIC is being explicitly enabled?
>>
>> Uh, get that platform to not ship with a broken setup?
>>
>>> I'd say if you need to say something downgrade it to info instead and not
>>> mark it as firmware bug.
>>
>> How is the above not a "firmware" bug?
> 
> Ok, looking at AVIC-related CPUID feature bits:
> 1. Fn8000_000A_EDX[AVIC] (bit 13) representing core AVIC support
> 2. Fn8000_000A_EDX[x2AVIC] (bit 18) for x2APIC MSR support
> 3. Fn8000_000A_EDX[ExtLvtAvicAccessChg] (bit 27) for change to AVIC
> handling of eLVT registers
> 4. Fn8000_000A_ECX[x2AVIC_EXT] (bit 6) for x2AVIC 4k vCPU support
> 
> The latter three are dependent on the first feature being enabled. If a
> platform wants to disable AVIC for whatever reason, it could:
> - disable (1), and leave the rest of the three feature bits on as a way
>    to advertise support for those (OR)
> - disable all the four CPUID feature bits above
> 
> I think you are saying that the former is wrong and the right way to
> disable AVIC would be to turn off all the four CPUID feature bits above?
> 
> I don't know enough about x86/CPUIDs to argue about that ;)
> 
> However, it appears to me that the former approach of only disabling the
> base AVIC CPUID feature bit is helpful in advertising the platform
> capabilities.
> 
> Assuming AVIC was disabled due to a harware erratum, those who are _not_
> affected by the erratum can meaningfully force-enable AVIC and also have
> x2AVIC (and other related AVIC features and extensions) get enabled
> automatically.  If all AVIC related CPUID feature bits were to be
> disabled, then force_avic will serve a limited role unless it is
> extended.
> 
> I don't know if there is precedence for this, or if it is at all ok,
> just that it may be helpful.
> 
> Also, those platforms are unlikely to be fixed (client/desktop systems
> that are unlikely to receive updates).
> 
> The current warning suggests passing force_avic, but that will just
> taint the kernel and potentially break more things assuming AVIC was
> turned off for a good reason. Or, users can start explicitly disabling
> AVIC by passing "avic=0" if they want to turn off the warning. Both of
> these don't seem helpful, especially on client platforms.
> 
> So, if you still think that we should retain that warning, should we
> tweak it not to suggest force_avic?
> 
> 
> - Naveen
> 

I suppose another alternative is to just clear X86_FEATURE_X2AVIC if 
X86_FEATURE_AVIC is not set and force_avic isn't set.


