Return-Path: <kvm+bounces-30965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F749BF126
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98E541C21DD1
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52F5202620;
	Wed,  6 Nov 2024 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tR7XncwZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113E11E0480;
	Wed,  6 Nov 2024 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730905493; cv=none; b=FQgtf2VE8xhtEH2z9XfL7q1j7zwm5WPDkfqsvjWaJ96RZ2t0bb+s6g7TTra0sCZTQmr8tyTw0Vsdgnm8dl0gOenoRjbhPPgdmOSeNMrVvOq8DG5TnxgA+8F86SbShj4KqEIW7t9z4B8I5JFuqR8smGc79AsTv9pVKN/D8R7whM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730905493; c=relaxed/simple;
	bh=FgUB69GjBGhR7mtYoK8NiSuG3E7h3U1HW3b8tBJGSWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q33/BxYMTO24+bLQ2hVFkRNEL6CT4F+Qrnd/jD4YqCQbLjbxRWWh+G5A2IXJ0kByXzFK6d0OKgxrgR4lHkjcWGuhANfDh1VqxBF2JPto8TtCw1VU7bgC7V+gvY6eiqB/0OXy/MkGFrRBe9aSnZGEr+0DIXq2xQFMQn4T5EFFjn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tR7XncwZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F57EC4CEC6;
	Wed,  6 Nov 2024 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730905492;
	bh=FgUB69GjBGhR7mtYoK8NiSuG3E7h3U1HW3b8tBJGSWA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tR7XncwZ7MeQpAvlF9dYV/3JYfHO8m+3dZK2QBl/wqpfxWxP8uTj4irojcinql1GI
	 +jEKslG4S+djuOuIMck2/JpWje1+T7DpZxiTD6x5RSQPXeSdx0Abw+s2WhIPtdI0WW
	 4oCz2siyaqhnEAWAFsj4ti5MYPFSARQN1xzmJ1muoxWVMPx6B1dWCW856NaR2VQk0D
	 BTzq8iWygM38lxxbrEoaSF66y6S9EkB9oCwABo2TGmfDfQH43eaJq+Fw/D82WRelgi
	 ZIIvB5ZcYnwlyR5ETiME2Maxbf2dreqv7HObT0ZLBQm7YK68OnzBbxlo94mPXJD0Fc
	 E7zvLVDq9eMCg==
Message-ID: <fb72d616-dba8-410f-a377-3774aa7a5295@kernel.org>
Date: Wed, 6 Nov 2024 09:04:49 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4
 client
To: Sean Christopherson <seanjc@google.com>
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
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <ZyuFMtYSneOFrsvs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/2024 09:03, Sean Christopherson wrote:
> +KVM, given that this quite obviously affects KVM...
> 
> On Tue, Nov 05, 2024, Mario Limonciello wrote:
>> From: Mario Limonciello <mario.limonciello@amd.com>
>>
>> A number of Zen4 client SoCs advertise the ability to use virtualized
>> VMLOAD/VMSAVE, but using these instructions is reported to be a cause
>> of a random host reboot.
>>
>> These instructions aren't intended to be advertised on Zen4 client
>> so clear the capability.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=219009
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>>   arch/x86/kernel/cpu/amd.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index 015971adadfc7..ecd42c2b3242e 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -924,6 +924,17 @@ static void init_amd_zen4(struct cpuinfo_x86 *c)
>>   {
>>   	if (!cpu_has(c, X86_FEATURE_HYPERVISOR))
>>   		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT);
>> +
>> +	/*
>> +	 * These Zen4 SoCs advertise support for virtualized VMLOAD/VMSAVE
>> +	 * in some BIOS versions but they can lead to random host reboots.
> 
> Uh, CPU bug?  Erratum?

BIOS bug.  Those shouldn't have been advertised.

> 
>> +	 */
>> +	switch (c->x86_model) {
>> +	case 0x18 ... 0x1f:
>> +	case 0x60 ... 0x7f:
>> +		clear_cpu_cap(c, X86_FEATURE_V_VMSAVE_VMLOAD);
>> +		break;
>> +	}
>>   }
>>   
>>   static void init_amd_zen5(struct cpuinfo_x86 *c)
>> -- 
>> 2.43.0
>>


