Return-Path: <kvm+bounces-8625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D70878533BE
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 15:55:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 926A128C216
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 14:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD3B5EE6D;
	Tue, 13 Feb 2024 14:54:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A8754FB9
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707836077; cv=none; b=XBww6XLHgnv+KMYEJNAdcXA+i69LaJDerlkm9icnzf/h9lUcUS6+HQkq3qI/0rkJAs9A7qRE6ghxoZF6zjabXjrg9KaWLqTsyWNTOwl0PeDkETS5/vMnhUyN4CFunDu7L3kWhkvQ6NkctcCMRqRMgWZwHZERs2F4HwXSTrK1PTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707836077; c=relaxed/simple;
	bh=8WlPc1CMmvGh2RZq/fSlwm1pfE7aApKAHmu79Ql5YBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghOmBXhvkXt/1WCIodxuFI8cRz6j8VOMR2LuvGuUjaklmTougR/6PA8aOhzkAw4dtUTc+pNvOX+B7AOZCPrNi0Hf5GsHdNEazMJKGIZR+iPBylmljoVnGsKfbaMDTg47NsvKvAi118FMID8f5VEnPv683PD81OnE1RtXr7FZTT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB8B3DA7;
	Tue, 13 Feb 2024 06:55:16 -0800 (PST)
Received: from [10.57.50.4] (unknown [10.57.50.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29B583F7B4;
	Tue, 13 Feb 2024 06:54:34 -0800 (PST)
Message-ID: <0593516b-2419-49b7-83aa-fe189ffad0c2@arm.com>
Date: Tue, 13 Feb 2024 14:54:32 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: cpufeatures: Only check for NV1 if NV is
 present
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20240212144736.1933112-1-maz@kernel.org>
 <CGME20240212144758eucas1p1345ba6f2000c10a4b33f8575f0a8d22b@eucas1p1.samsung.com>
 <20240212144736.1933112-3-maz@kernel.org>
 <5b2d8fee-9d0f-48f7-b9ec-b86e95387a61@samsung.com>
 <86bk8k5ts3.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86bk8k5ts3.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13/02/2024 14:21, Marc Zyngier wrote:
> On Tue, 13 Feb 2024 11:14:37 +0000,
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>>
>> Hi
>>
>> On 12.02.2024 15:47, Marc Zyngier wrote:
>>> We handle ID_AA64MMFR4_EL1.E2H0 being 0 as NV1 being present.
>>> However, this is only true if FEAT_NV is implemented.
>>>
>>> Add the required check to has_nv1(), avoiding spuriously advertising
>>> NV1 on HW that doesn't have NV at all.
>>>
>>> Fixes: da9af5071b25 ("arm64: cpufeature: Detect HCR_EL2.NV1 being RES0")
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>
>> This patch in turn introduces the following warning during boot
>> (observed on today's linux-next):
>>
>> CPU: All CPU(s) started at EL2
>> CPU features: detected: 32-bit EL0 Support
>> CPU features: detected: 32-bit EL1 Support
>> CPU features: detected: CRC32 instructions
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 1 at arch/arm64/kernel/cpufeature.c:3369
>> this_cpu_has_cap+0x18/0x70
>> Modules linked in:
>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.8.0-rc4-next-20240213 #8014
>> Hardware name: Khadas VIM3 (DT)
>> pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : this_cpu_has_cap+0x18/0x70
>> lr : has_nv1+0x24/0xcc
>> ...
>> Call trace:
>>    this_cpu_has_cap+0x18/0x70
>>    update_cpu_capabilities+0x50/0x134
>>    setup_system_features+0x30/0x120
>>    smp_cpus_done+0x48/0xb4
>>    smp_init+0x7c/0x8c
>>    kernel_init_freeable+0x18c/0x4e4
>>    kernel_init+0x20/0x1d8
>>    ret_from_fork+0x10/0x20
>> irq event stamp: 2846
>> hardirqs last  enabled at (2845): [<ffff80008012cf5c>]
>> console_unlock+0x164/0x190
>> hardirqs last disabled at (2846): [<ffff80008123a078>] el1_dbg+0x24/0x8c
>> softirqs last  enabled at (2842): [<ffff800080010a60>]
>> __do_softirq+0x4a0/0x4e8
>> softirqs last disabled at (2827): [<ffff8000800169b0>]
>> ____do_softirq+0x10/0x1c
>> ---[ end trace 0000000000000000 ]---
>> alternatives: applying system-wide alternatives
> 
> This is nothing short of embarrassing. It looks like I somehow managed
> to drop CONFIG_PREEMPT from my test config, making it impossible to
> identify these issues. Apologies for that.
> 
> The following patch fixes it for me. Could you please give it a go?
> 
> Thanks,
> 
> 	M.
> 
>  From cd75279d3b6c387c13972b61c486a203d9652e97 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Tue, 13 Feb 2024 13:37:57 +0000
> Subject: [PATCH] arm64: cpufeatures: Fix FEAT_NV check when checking for
>   FEAT_NV1
> 
> Using this_cpu_has_cap() has the potential to go wrong when
> used system-wide on a preemptible kernel. Instead, use the
> __system_matches_cap() helper when checking for FEAT_NV in the
> FEAT_NV1 probing helper.
> 
> Fixes: 3673d01a2f55 ("arm64: cpufeatures: Only check for NV1 if NV is present")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kernel/cpufeature.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 3421b684d340..f309fd542c20 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1812,7 +1812,7 @@ static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
>   		{}
>   	};
>   
> -	return (this_cpu_has_cap(ARM64_HAS_NESTED_VIRT) &&
> +	return (__system_matches_cap(ARM64_HAS_NESTED_VIRT) &&

Even though this change now uses SYSTEM scope for NESTED_VIRT, that is 
the correct choice. Ideally, we should use the scope that was passed 
into "has_v1", but as we have seen SCOPE_LOCAL is not safe. SYSTEM
schope works fine as both NV1 and NESTED_VIRT are SYSTEM scope. The only 
time we run them SCOPE_LOCAL is for hotplugged in CPUs, at which point 
the SYSTEM wide caps are finalized and will use the right value.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



>   		!(has_cpuid_feature(entry, scope) ||
>   		  is_midr_in_range_list(read_cpuid_id(), nv1_ni_list)));
>   }


