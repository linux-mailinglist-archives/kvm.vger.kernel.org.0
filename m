Return-Path: <kvm+bounces-8636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5B6853BE3
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 21:06:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 587EC1F22E22
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 20:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61FE60B95;
	Tue, 13 Feb 2024 20:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kLymQsER"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B6C60B80
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 20:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707854801; cv=none; b=FmcyvtuinFK+ev01dU+nP1n69OXfZFf7KjUEJuHgwfHFoPtkFbE/HVxaiToUcEJvAnRuBWeYPKJ72hSASutQyfSg4RssU3nwInQd5BnQ19dOsW7HoQISnKPDRY5l2m1EFpES87AfHy+LbvZR3fkf6p5+Vvg9tVa1ScV5VMeXtU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707854801; c=relaxed/simple;
	bh=j4NZKdmm9EOjXmYzn7ZbNmbhcvaAGReQoCAKUi/qhTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=oun9LTQnceE+HQ47/7AZvpxSp1lGG1ubFtmATs6/b+xn0rY2bI+vqIlnmG86XdBVJ+mCMYphAyx2lt5N2Zn5TuiYv07hPEPBfQNVIlZk8CTs/bQB7P3Wr05Wb1hIk4cxihSvkLZ5DdQ7BcqBG6RQwXbINRUpeGtJQMXvT92LsbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kLymQsER; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240213200631euoutp023ab5866bcc2950ac5a36810b6046adea~zhOJp-sTb2246022460euoutp02a
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 20:06:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240213200631euoutp023ab5866bcc2950ac5a36810b6046adea~zhOJp-sTb2246022460euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707854791;
	bh=6tmeoBcathNp/2I0xkfvRosW+2NQYjaHTQF1/lue730=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=kLymQsERsjjMa+c07fHh1i7uMOETy2Bo2vttY30ZwXPOt0QtgcPolRl2nrlLFHtMg
	 6h4huR6AofR20UFBTJM5nIaYIRIHy1/JjWVWzCDqVBvR0uZPK+NcDkkXeMt7Fby//v
	 1rNlwh7Ubt2SRh5++eyEgg0npfQCCXq9YtYsZif8=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240213200631eucas1p266784e57810dd2bc2a353dae084c9c53~zhOJBhwgv2639526395eucas1p2s;
	Tue, 13 Feb 2024 20:06:31 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 6E.09.09814.6CBCBC56; Tue, 13
	Feb 2024 20:06:30 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240213200629eucas1p1a1cbe42417e32b86d6288db99f850560~zhOH2fP4B2933629336eucas1p1x;
	Tue, 13 Feb 2024 20:06:29 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240213200629eusmtrp2fc435ee09d6ebe47b72d16bd95227fc9~zhOH10ql11823018230eusmtrp2K;
	Tue, 13 Feb 2024 20:06:29 +0000 (GMT)
X-AuditID: cbfec7f4-727ff70000002656-ea-65cbcbc6abec
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 1E.C8.10702.5CBCBC56; Tue, 13
	Feb 2024 20:06:29 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240213200629eusmtip1e658606fff4108cabbcf763cd5a0bc97~zhOHPyXHZ2571925719eusmtip1h;
	Tue, 13 Feb 2024 20:06:29 +0000 (GMT)
Message-ID: <1c3ad9f8-41ee-4fe0-bd9c-ca1212129cbf@samsung.com>
Date: Tue, 13 Feb 2024 21:06:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: cpufeatures: Only check for NV1 if NV is
 present
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
	Deacon <will@kernel.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <86bk8k5ts3.wl-maz@kernel.org>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7djP87rHTp9ONZj938zi/bIeRov7+5Yz
	WcyZWmjxasthFotNj6+xWuycc5LVYurPN2wWM2/fZrRouWNqcXPpBnYHLo8189YwerQcecvq
	sWlVJ5vHwoapzB6bl9R7vNg8k9Hj8ya5APYoLpuU1JzMstQifbsErow1N14yFeyUrbjc1MXS
	wHhCoouRk0NCwETiZM9B9i5GLg4hgRWMEuemzmSDcL4wShye9oYJpEpI4DOjxOPN7DAdXb8n
	sUAULWeU2HJkBVTHR0aJHTs3MYNU8QrYSexedpcRxGYRUJW4eW0KVFxQ4uTMJywgtqiAvMT9
	WzPApgoLBEkcWLUFrEZEQFHi04WTjCBDmQX2M0lM/nCLFSTBLCAucevJfLCT2AQMJbredrGB
	2JwC2hK3tmxlgaiRl2jeOpsZpFlC4D+HxOHfy5gg7naR+PRxCiuELSzx6vgWqH9kJP7vBBkK
	0tDOKLHg930oZwKjRMPzW4wQVdYSd879AlrHAbRCU2L9Ln0QU0LAUWJmZw6EySdx460gxA18
	EpO2TWeGCPNKdLQJQcxQk5h1fB3c1oMXLjFPYFSahRQss5B8OQvJN7MQ1i5gZFnFKJ5aWpyb
	nlpslJdarlecmFtcmpeul5yfu4kRmLBO/zv+ZQfj8lcf9Q4xMnEwHmKU4GBWEuG9NONEqhBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXFe1RT5VCGB9MSS1OzU1ILUIpgsEwenVANT+Q/Fxy9zGa5F
	7X2VVBw8I2F/w9+YO1H8lZH873nsuER+TmmKVEw/nf/mdsOvzlV1nLybZzxhXW6ZFSFavOTR
	B3v9+Yc4Znw/9ML+8YPAwPZrOZkCKTPVT7GenHDhV86/JwuNA73T+Nc29PlNW+1YZfS3KCRK
	/c+JgnsGKQrLNPYvrXW7JlDxild269oH8f4FLn/ykry52t7VvCme/jou5MLB5dxHg6esPKo/
	a++PSe57SgqWbJ3/c9YrkYtf+nNCLu5ZtebCcdFJEtILklmTdpXP5whYuocjMf33L4cjzBcL
	f86573JiMfsRB1H3bI8HT+qEY7JN6v2OT77zJfaa4tLMh+cK+3hemk1R2Za0T4mlOCPRUIu5
	qDgRAOn/en7HAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t/xu7pHT59ONfjaqmrxflkPo8X9fcuZ
	LOZMLbR4teUwi8Wmx9dYLXbOOclqMfXnGzaLmbdvM1q03DG1uLl0A7sDl8eaeWsYPVqOvGX1
	2LSqk81jYcNUZo/NS+o9XmyeyejxeZNcAHuUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWe
	obF5rJWRqZK+nU1Kak5mWWqRvl2CXsaaGy+ZCnbKVlxu6mJpYDwh0cXIySEhYCLR9XsSSxcj
	F4eQwFJGib+n1rFDJGQkTk5rYIWwhSX+XOtigyh6zyjxfPNaFpAEr4CdxO5ldxlBbBYBVYmb
	16YwQ8QFJU7OfAJWIyogL3H/1gywocICQRIHVm0BqxERUJT4dOEkWC+zwH4miY2vVSEWdDNJ
	ND95B5UQl7j1ZD4TiM0mYCjR9RbkCk4OTgFtiVtbtrJA1JhJdG3tgqqXl2jeOpt5AqPQLCR3
	zEIyahaSlllIWhYwsqxiFEktLc5Nzy020itOzC0uzUvXS87P3cQIjNFtx35u2cG48tVHvUOM
	TByMhxglOJiVRHgvzTiRKsSbklhZlVqUH19UmpNafIjRFBgYE5mlRJPzgUkiryTe0MzA1NDE
	zNLA1NLMWEmc17OgI1FIID2xJDU7NbUgtQimj4mDU6qBqWfzB49Ksw/p/dceGu8o+X5ySZSV
	/Yq+jAm7D33jf+nztLHNqJErZPcXmRe3Q5Nrze1Fn60/NGv+QdkXzGXfvYS2vqg8ajXvt9aq
	ViuBsxqt971klxXNf3wxK29Gk3Dll+1npih+P7MxpzFHbWXkpo2rN5z0keL1/G99bHPl9MhZ
	HwUCHy6Vu6+uKP2uWqu5OLjuZbpmwaQNAaEHQ6Le1B7d4udau32x//qpXzyVljm0rvjwcf3q
	R6u1bVlPNWy8Ur52IiPLY1Pt5S/V283Lrp19mLyn9LP1L7FPanNLl4gKx5SI7Jj53iKeZ5ez
	uv9KKZFX2lFe5+O992xdt/NHcPOLMo6QlR0+ad4BoaynZimxFGckGmoxFxUnAgBcO3F4WgMA
	AA==
X-CMS-MailID: 20240213200629eucas1p1a1cbe42417e32b86d6288db99f850560
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20240212144758eucas1p1345ba6f2000c10a4b33f8575f0a8d22b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240212144758eucas1p1345ba6f2000c10a4b33f8575f0a8d22b
References: <20240212144736.1933112-1-maz@kernel.org>
	<CGME20240212144758eucas1p1345ba6f2000c10a4b33f8575f0a8d22b@eucas1p1.samsung.com>
	<20240212144736.1933112-3-maz@kernel.org>
	<5b2d8fee-9d0f-48f7-b9ec-b86e95387a61@samsung.com>
	<86bk8k5ts3.wl-maz@kernel.org>

On 13.02.2024 15:21, Marc Zyngier wrote:
> On Tue, 13 Feb 2024 11:14:37 +0000,
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>> On 12.02.2024 15:47, Marc Zyngier wrote:
>>> We handle ID_AA64MMFR4_EL1.E2H0 being 0 as NV1 being present.
>>> However, this is only true if FEAT_NV is implemented.
>>>
>>> Add the required check to has_nv1(), avoiding spuriously advertising
>>> NV1 on HW that doesn't have NV at all.
>>>
>>> Fixes: da9af5071b25 ("arm64: cpufeature: Detect HCR_EL2.NV1 being RES0")
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
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
> This is nothing short of embarrassing. It looks like I somehow managed
> to drop CONFIG_PREEMPT from my test config, making it impossible to
> identify these issues. Apologies for that.
>
> The following patch fixes it for me. Could you please give it a go?

Works fine for me.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

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
>   		!(has_cpuid_feature(entry, scope) ||
>   		  is_midr_in_range_list(read_cpuid_id(), nv1_ni_list)));
>   }

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


