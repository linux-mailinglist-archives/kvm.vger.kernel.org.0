Return-Path: <kvm+bounces-13314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE328948DF
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96152284241
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 01:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC65D531;
	Tue,  2 Apr 2024 01:44:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74D48F7D;
	Tue,  2 Apr 2024 01:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022251; cv=none; b=sDOO7/7VWU+u263wt6VWIG+opSw0v0NHbBQM3O51K0xlkEEBuicuWpZs1c7s+e6i0peIgT4/GcEtV3SPcHewUoOE1LhycEJgPPmGGuJ+thPFLq5gsSczGEHwaS7rwnl5lejmbfyRSx1Zsuacz1paVlfJPFY9DgmBxmz7uswHtUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022251; c=relaxed/simple;
	bh=FMcrAiDM9GDhgLUPo0dWEmrQBaq4UYLXE5VjE9+WkDM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QqNkxABS+A6UMuZSWKRhBxUakIGHfR5ujGu0hAFxy1Yj1UiA2POtMyLp4WX88DPBynqQsGHHP3FGFMPGX0nMts4SFqEbP66Tc9noeKYVIugYgRLx0GViix63ARTSYLqYeLhI/X7ejdE3BSARgrgt6gJ/YR7HFEd2FL+EhvxRnHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxnuvlYgtmECoiAA--.12657S3;
	Tue, 02 Apr 2024 09:44:05 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxX8_fYgtmckZxAA--.22052S3;
	Tue, 02 Apr 2024 09:44:01 +0800 (CST)
Subject: Re: [PATCH v7 3/7] LoongArch: KVM: Add cpucfg area for kvm hypervisor
To: WANG Xuerui <kernel@xen0n.name>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240315080710.2812974-1-maobibo@loongson.cn>
 <20240315080710.2812974-4-maobibo@loongson.cn>
 <4668e606-a7b5-49b7-a68d-1c2af86f7d76@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <57e66ff5-1cb6-06bd-ee6f-a3c3dadd6aef@loongson.cn>
Date: Tue, 2 Apr 2024 09:43:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4668e606-a7b5-49b7-a68d-1c2af86f7d76@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxX8_fYgtmckZxAA--.22052S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxAFW5Gry8CrWDAFyfZw4xGrX_yoWrZryUpF
	WSkFnxCr4kJFs3Awn3Ca17WFyrJrs5GrW3GF90kryDCrs8ur1Iyw1I9rWq9F9rCw4fCw1j
	vr4jqFy093Z8A3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8uc_3UUUU
	U==



On 2024/3/24 上午3:02, WANG Xuerui wrote:
> On 3/15/24 16:07, Bibo Mao wrote:
>> Instruction cpucfg can be used to get processor features. And there
>> is trap exception when it is executed in VM mode, and also it is
>> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
>> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
>> for KVM hypervisor to privide PV features, and the area can be extended
>> for other hypervisors in future. This area will never be used for
>> real HW, it is only used by software.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/inst.h      |  1 +
>>   arch/loongarch/include/asm/loongarch.h | 10 +++++
>>   arch/loongarch/kvm/exit.c              | 59 +++++++++++++++++++-------
>>   3 files changed, 54 insertions(+), 16 deletions(-)
>>
> 
> Sorry for the late reply, but I think it may be a bit non-constructive 
> to repeatedly submit the same code without due explanation in our 
> previous review threads. Let me try to recollect some of the details 
> though...
Because your review comments about hypercall method is wrong, I need not 
adopt it.
> 
> If I remember correctly, during the previous reviews, it was mentioned 
> that the only upsides of using CPUCFG were:
> 
> - it was exactly identical to the x86 approach,
> - it would not require access to the LoongArch Reference Manual Volume 3 
> to use, and
> - it was plain old data.
> 
> But, for the first point, we don't have to follow x86 convention after 
X86 virtualization is successfully and widely applied in our life and 
products. It it normal to follow it if there is not obvious issues.

> all. The second reason might be compelling, but on the one hand that's 
> another problem orthogonal to the current one, and on the other hand 
> HVCL is:
> 
> - already effectively public because of the fact that this very patchset 
> is public,
> - its semantics is trivial to implement even without access to the LVZ 
> manual, because of its striking similarity with SYSCALL, and
> - by being a function call, we reserve the possibility for hypervisors 
> to invoke logic for self-identification purposes, even if this is likely 
> overkill from today's perspective.
> 
> And, even if we decide that using HVCL for self-identification is 
> overkill after all, we still have another choice that's IOCSR. We 
> already read LOONGARCH_IOCSR_FEATURES (0x8) for its bit 11 (IOCSRF_VM) 
> to populate the CPU_FEATURE_HYPERVISOR bit, and it's only natural that 
> we put the identification word in the IOCSR space. As far as I can see, 
> the IOCSR space is plenty and equally available for making reservations; 
> it can only be even easier when it's done by a Loongson team.
IOCSR method is possible also, about chip design CPUCFG is used for cpu 
features and IOCSR is for device featurs. Here CPUCFG method is 
selected, I am KVM LoongArch maintainer and I can decide to select 
methods if the method works well. Is that right?

If you are interested in KVM LoongArch, you can submit more patches and 
become maintainer or write new hypervisor support such xen/xvisor etc, 
and use your method.

Also you are interested in Linux kernel, there are some issues. Can you 
help to improve it?

1. T0-T7 are scratch registers during SYSCALL ABI, this is what you 
suggest, does there exist information leaking to user space from T0-T7 
registers?

2. LoongArch KVM depends on AS_HAS_LVZ_EXTENSION, which requires the 
latest binutils. It is also what you suggest. Some kernel developers 
does not have the latest binutils and common kvm code is modified and 
LoongArch KVM fails to compile. But they can not find it since their 
LoongArch cross-compile is old and LoongArch KVM is disabled. This issue 
can be found at https://lkml.org/lkml/2023/11/15/828.

Regards
Bibo Mao
> 
> Finally, I've mentioned multiple times, that varying CPUCFG behavior 
> based on PLV is not something well documented on the manuals, hence not 
> friendly to low-level developers. Devs of third-party firmware and/or 
> kernels do exist, I've personally spoken to some of them on the 
> 2023-11-18 3A6000 release event; in order for the varying CPUCFG 
> behavior approach to pass for me, at the very least, the LoongArch 
> reference manual must be amended to explicitly include an explanation of 
> it, and a reference to potential use cases.
> 


