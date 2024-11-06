Return-Path: <kvm+bounces-30991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F0859BF25A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 829601C211B1
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8023204090;
	Wed,  6 Nov 2024 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9f+ZY9P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157A6190075;
	Wed,  6 Nov 2024 15:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730908735; cv=none; b=GOny56BcqE5pUGOod8cxa9jCMh/CSwgiAbcWGo7lzu1WkNUbXCUbO0oAe1CD4KvN2eCUEqgcCIU8XzsU9iSeP5EIjt+jFib3HoYOobt2MWimdc/LUUnuSdCAx/4ou16yMDbm6SAb7lerYXfSELTNAtsH+itvnm1/ZPqzMKo6RGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730908735; c=relaxed/simple;
	bh=lJ/zVRLaD2B+GIjj76Oiwxiimgq9k2sk/k+O6CfQnyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mq7SlvHfot5Msl4Pu42LjHQvN/8CDpkqt7EZL9bkkKBHHSLQrgKJCU0ApPglFRMYZ8zzHOeFcmyGOCdn2FiAztQdlNdffhymFxKCwwzIiIhQar847uVB86KXsiHSrZefkFrfTqvuW1eqTYpfdXJC35nO+hDOGsM4jdjtdLYN2gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9f+ZY9P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB8CC4CEC6;
	Wed,  6 Nov 2024 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730908734;
	bh=lJ/zVRLaD2B+GIjj76Oiwxiimgq9k2sk/k+O6CfQnyg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y9f+ZY9PUZYhBQfzvrYnow5xTstjRwDd7BMlKn01PeO09pt+pUOilrqP4SyEJHy0m
	 VbNW0Bci263WY1CBB0gy2pz86MFHzr40wyiu6bV7xFfDkl+DdYgU/g4SwgI8Zb5uLA
	 XOY4Wb5BvU/f8VzbQyDxyptjJi4Ilq6wNMHQ5vmDv8R79/cfFguBsuPmCe5XBUSQoc
	 Rv8khRmaaUTAzrlHbJg6nYr/FXC5ZH7WJ190act9L95lJAd/tZLH0+jymWS3NjF8BZ
	 VuiiKIXxrCgMzGM9QR+kgWCqsGIbV0J2ZjKipA/eqaM1z1DJGz1yN6SWvo9M+2cBQd
	 KkTTENrR30a5g==
Message-ID: <65fdc558-21e9-4311-b2b0-8b35131c7aac@kernel.org>
Date: Wed, 6 Nov 2024 09:58:51 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4
 client
To: Maxim Levitsky <mlevitsk@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H . Peter Anvin" <hpa@zytor.com>, Nikolay Borisov <nik.borisov@suse.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Brijesh Singh
 <brijesh.singh@amd.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>, Mario Limonciello
 <mario.limonciello@amd.com>, kvm@vger.kernel.org
References: <20241105160234.1300702-1-superm1@kernel.org>
 <ZyuFMtYSneOFrsvs@google.com>
 <fb72d616-dba8-410f-a377-3774aa7a5295@kernel.org>
 <ZyuIINwBdiztWhi3@google.com>
 <37b73861cb86508a337b299a5ae77ab875638fe4.camel@redhat.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <37b73861cb86508a337b299a5ae77ab875638fe4.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/2024 09:48, Maxim Levitsky wrote:
> On Wed, 2024-11-06 at 07:15 -0800, Sean Christopherson wrote:
>> On Wed, Nov 06, 2024, Mario Limonciello wrote:
>>> On 11/6/2024 09:03, Sean Christopherson wrote:
>>>> +KVM, given that this quite obviously affects KVM...
>>>>
>>>> On Tue, Nov 05, 2024, Mario Limonciello wrote:
>>>>> From: Mario Limonciello <mario.limonciello@amd.com>
>>>>>
>>>>> A number of Zen4 client SoCs advertise the ability to use virtualized
>>>>> VMLOAD/VMSAVE, but using these instructions is reported to be a cause
>>>>> of a random host reboot.
>>>>>
>>>>> These instructions aren't intended to be advertised on Zen4 client
>>>>> so clear the capability.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=219009
>>>>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>>>>> ---
>>>>>    arch/x86/kernel/cpu/amd.c | 11 +++++++++++
>>>>>    1 file changed, 11 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>>>>> index 015971adadfc7..ecd42c2b3242e 100644
>>>>> --- a/arch/x86/kernel/cpu/amd.c
>>>>> +++ b/arch/x86/kernel/cpu/amd.c
>>>>> @@ -924,6 +924,17 @@ static void init_amd_zen4(struct cpuinfo_x86 *c)
>>>>>    {
>>>>>    	if (!cpu_has(c, X86_FEATURE_HYPERVISOR))
>>>>>    		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT);
>>>>> +
>>>>> +	/*
>>>>> +	 * These Zen4 SoCs advertise support for virtualized VMLOAD/VMSAVE
>>>>> +	 * in some BIOS versions but they can lead to random host reboots.
>>>>
>>>> Uh, CPU bug?  Erratum?
>>>
>>> BIOS bug.  Those shouldn't have been advertised.
> 
> Hi!
> 
> My question is, why would AMD drop support intentionally for VLS on client machines?
> 
> I understand that there might be a errata, and I don't object disabling the
> feature because of this.
> 
> But hearing that 'These instructions aren't intended to be advertised' means that
> AMD intends to stop supporting virtualization on client systems or at least partially
> do so.

Don't read into it too far.  It's just a BIOS problem with those 
instructions "specifically" on the processors indicated here.  Other 
processors (for example Zen 5 client processors) do correctly advertise 
support where applicable.

When they launched those bits weren't supposed to be set to indicate 
support, but BIOS did set them.

> 
> That worries me. So far AMD was much better that Intel supporting most of the
> features across all of the systems which is very helpful in various scenarios,
> and this is very appreciated by the community.
> 
> Speaking strictly personally here, as a AMD fan.
> 
 > Best regards,> 	Maxim Levitsky
> 
> 
>>
>> Why not?  "but they can lead to random host reboots" is a description of the
>> symptom, not an explanation for why KVM is unable to use a feature that is
>> apparently support by the CPU.
>>
>> And if the CPU doesn't actually support virtualized VMLOAD/VMSAVE, then this is
>> a much bigger problem, because it means KVM is effectively giving the guest read
>> and write access to all of host memory.
>>
> 
> 

I'm gathering that what supported means to you and what it means to me 
are different things.  "Architecturally" the instructions for 
virtualized VMLOAD/VMSAVE exist.  There are problems with them on these 
processors, and for that reason the BIOS was not supposed to set those 
bits but it did.


