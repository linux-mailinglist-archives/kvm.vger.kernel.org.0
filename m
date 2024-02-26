Return-Path: <kvm+bounces-9622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 675E3866BB7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B1E11C215AD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AED71C6B9;
	Mon, 26 Feb 2024 08:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="fEEdMIEu"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA8D1C686;
	Mon, 26 Feb 2024 08:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708934842; cv=none; b=GrqijzWijuibYDp1tOD41SpTaACCUXraR38Z9imok+xCDjUTNewGoQLhc+krx4F+O6NVRpFOLKt4I7Dns2lbs2ox0igcUAyIRLAPPb9K+pTxj4GAclBBV3fE3Kh/jWPz664eHSHiXDpcnVltmpRcOOMi/aKzG1eLS+VqmlvfUxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708934842; c=relaxed/simple;
	bh=BdJKa40zvLo1lKD1wA98PMD1d9vAA8KjsTeiEusFwbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XLZ344tSsQQ9XxATBs767MAU68NqSLY51IAKAZOozlMnuoZ/itY2YL3uWh9x0qwuuRyZhyjZyoi3nMY22765sASecBcRBZOTDrquZCMd2AtA58WTIsvVB/Jrlfw2Ugh0l2wvH+gDp6KTV95A1olAtyc5mw3HDVTGamyAcpYZ81g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=fEEdMIEu; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708934837; bh=BdJKa40zvLo1lKD1wA98PMD1d9vAA8KjsTeiEusFwbY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fEEdMIEu8ctBtnEMUbUHo4wLchcss85VZ+PzON08zglwDaUvXylLcoYivW2bJbu0l
	 L1NizWea9ynARlB69vLBpXvk+qjl8tXtALKVESi7GGd8lIUmeSEGCGHUik1/E1T+lu
	 AtarTBfq+OIgmbLph4GNNN5FoGBEhGFRloHs9UYs=
Received: from [28.0.0.1] (unknown [101.230.251.34])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id CAFD860120;
	Mon, 26 Feb 2024 16:07:16 +0800 (CST)
Message-ID: <704f58e2-f7ce-4d8d-b40d-52d773d13220@xen0n.name>
Date: Mon, 26 Feb 2024 16:07:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
To: maobibo <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
 <d8994f0f-d789-46d2-bc4d-f9b37fb396ff@xen0n.name>
 <0fa41323-0071-aa97-21fb-3ad859d0a9b4@loongson.cn>
Content-Language: en-US
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <0fa41323-0071-aa97-21fb-3ad859d0a9b4@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/26/24 16:00, maobibo wrote:
> 
> 
> On 2024/2/26 下午1:25, WANG Xuerui wrote:
>> Hi,
>>
>> On 2/26/24 10:04, maobibo wrote:
>>> On 2024/2/24 下午5:13, Huacai Chen wrote:
>>>> Hi, Bibo,
>>>>
>>>> On Thu, Feb 22, 2024 at 11:28 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>
>>>>> Instruction cpucfg can be used to get processor features. And there
>>>>> is trap exception when it is executed in VM mode, and also it is
>>>>> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
>>>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
>>>>> for KVM hypervisor to privide PV features, and the area can be 
>>>>> extended
>>>>> for other hypervisors in future. This area will never be used for
>>>>> real HW, it is only used by software.
>>>> After reading and thinking, I find that the hypercall method which is
>>>> used in our productive kernel is better than this cpucfg method.
>>>> Because hypercall is more simple and straightforward, plus we don't
>>>> worry about conflicting with the real hardware.
>>> No, I do not think so. cpucfg is simper than hypercall, hypercall can
>>> be in effect when system runs in guest mode. In some scenario like 
>>> TCG mode, hypercall is illegal intruction, however cpucfg can work.
>>
>> While the CPUCFG instruction is universally available, it's also 
>> unprivileged, so any additional CPUCFG behavior also automatically 
>> becomes UAPI, which likely isn't what you expect. Hypervisor 
>> implementation details shouldn't be leaked to userland because it has 
>> no reason to care -- even though userland learns about the 
>> capabilities, it cannot actually access the resources, because 
>> relevant CSRs and/or instructions are privileged. Worse, the 
>> unnecessary exposure of information could be a problem security-wise.
> cpucfg is read-only and used to represent current hw cpu features,
> why do you think there is security issue?  Is there security issue about 
> cpucfg2 and cpucfg6 since it can be accessed in user space also?
> 
> PMU feature is defined in cpucfg6, PMU driver is written in kernel mode.

These CPUCFG leaves were added before existence of LoongArch were 
publicized, without community review. If early drafts of the manual were 
available to community reviewers, at least I would strongly NAK it.

>>
>> A possible way to preserve the unprivileged CPUCFG behavior would be 
>> acting differently based on guest CSR.CRMD.PLV: only returning data 
>> for the new configuration space when guest is not in PLV3. But this 
>> behavior isn't explicitly allowed nor disallowed in the LoongArch 
>> manuals, and is in my opinion unnecessarily complex.
>>
>> And regarding the lack of hypcall support from QEMU system mode 
>> emulation on TCG, I'd argue it's simply a matter of adding support in 
>> target/loongarch64. This would be attractive because it will enable 
>> easy development and testing of hypervisor software with QEMU -- both 
>> locally and in CI.
> Hypercall is part of hardware assisted virtualization LVZ, do you think
> only adding hypercall instruction withou LVZ is possible?

I cannot comment on the actual feasibility of doing so, because I don't 
have access to the LVZ manuals which *still* isn't publicly available. 
But from my intuition it should be a more-or-less trivial processor mode 
transition like with syscall -- whether that's indeed the case I can't 
(dis)prove.

>>> Extioi virtualization extension will be added later, cpucfg can be 
>>> used to get extioi features. It is unlikely that extioi driver 
>>> depends on PARA_VIRT macro if hypercall is used to get features.
>> And the EXTIOI feature too isn't something usable from unprivileged 
>> code, so I don't think it will affect the conclusions above.
> Sorry, I do not know what do you mean.

I was just saying this example provided no additional information at 
least for me -- while it's appreciated that you informed the community 
of your intended future use case, like what I stated in the first 
paragraph in my reply, it looked essentially the same because both PV 
and EXTIOI are privileged things.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


