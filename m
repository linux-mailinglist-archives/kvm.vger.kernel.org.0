Return-Path: <kvm+bounces-34571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D3FAA01CFA
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 02:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B316A1883946
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 01:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C93370811;
	Mon,  6 Jan 2025 01:13:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDE179C8;
	Mon,  6 Jan 2025 01:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736126024; cv=none; b=NqT/+UNeu9W0yzsdW1UxhBbcZ7TBgcMAVayYxasfysT+Us6idsysGjstbNHx444fk5f46Fb5gI2wW/2sdscnnGjvP3Jv9x3EIs08Afhg9WT3gBNCeeolD2B9dtoPlDGKT5tTXMShUrVarATSuVoslhcYT+hXXv/OCCUNmxkmpXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736126024; c=relaxed/simple;
	bh=XxeqAeEo5wpYu4CkQPF8l6eADs8tZ2fdC5Oc++KTmtM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=T8N9Qg4VR6R1n5pUZIYB6DpKuiLHBaYtUL18vud39t41F0Ct1aAshTIR7U09EnveNFlm9TTFNAFAuyJNBLgEgcKZlvAmiWp0hSARnK/Mmmm2QvaMxA9JSyDLEJf0YxMIBPaxTKLTYbT9+vL8dqlQBsQAMgEPF1Cpcnk3VDEH7f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxK6xALntnvnReAA--.366S3;
	Mon, 06 Jan 2025 09:13:36 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxncU9Lntnt9QVAA--.30125S3;
	Mon, 06 Jan 2025 09:13:34 +0800 (CST)
Subject: Re: [RFC 0/5] LoongArch: KVM: Add separate vmid support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241113031727.2815628-1-maobibo@loongson.cn>
 <CAAhV-H5VH0k6byAX4U0e4rv4tdjtzTSrokXt3tjqpSFRzpU7gg@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <ac42e531-26b1-0d4f-60e5-2fbb6ac92c17@loongson.cn>
Date: Mon, 6 Jan 2025 09:12:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5VH0k6byAX4U0e4rv4tdjtzTSrokXt3tjqpSFRzpU7gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxncU9Lntnt9QVAA--.30125S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tw1UJF4UXw1kZryDJw17XFc_yoW8ZF1fpa
	y7uFn5Gr4kGrsFy3sIqwnrXrn5tw18GFWSqa4ayryFkF1qqw1UJrWkXrWkuF98X3yfJFyI
	qF1rKF9F9a1UAacCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8xuctUU
	UUU==

Huacai,

On 2025/1/4 下午10:09, Huacai Chen wrote:
> Hi, Bibo,
> 
> Any update on this?
Sorry for not update it in time.

This patch is basic memory relative, it is only test on 3A6000 with 4 
cores. I hope it is fully tested on 3C6000 servers with numa support. 
When new machines arrive and the test is done, I will refresh the patch.

Regards
Bibo Mao
> 
> Huacai
> 
> On Wed, Nov 13, 2024 at 11:17 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> LoongArch KVM hypervisor supports two-level MMU, vpid index is used
>> for stage1 MMU and vmid index is used for stage2 MMU.
>>
>> On 3A5000, vmid must be the same with vpid. On 3A6000 platform vmid
>> may separate from vpid. There are such advantages if separate vpid
>> is supported.
>>    1. One VM uses one vmid, vCPUs on the same VM can share the same vmid.
>>    2. If one vCPU switch between different physical CPU, old vmid can be
>>       still usefil if old vmid is not expired
>>    3. For remote tlb flush, only vmid need update and vpid need not
>> update.
>>
>> Here add separate vmid feature support, vmid feature detecting method
>> is not implemented since it depends on HW implementation, detecting
>> method will be added when HW is ready.
>>
>> ---
>> Bibo Mao (5):
>>    LoongArch: KVM: Add vmid support for stage2 MMU
>>    LoongArch: KVM: Add separate vmid feature support
>>    LoongArch: KVM: implement vmid updating logic
>>    LoongArch: KVM: Add remote tlb flushing support
>>    LoongArch: KVM: Enable separate vmid feature
>>
>>   arch/loongarch/include/asm/kvm_host.h  | 10 ++++
>>   arch/loongarch/include/asm/loongarch.h |  2 +
>>   arch/loongarch/kernel/asm-offsets.c    |  1 +
>>   arch/loongarch/kvm/main.c              | 76 ++++++++++++++++++++++++--
>>   arch/loongarch/kvm/mmu.c               | 17 ++++++
>>   arch/loongarch/kvm/switch.S            |  5 +-
>>   arch/loongarch/kvm/tlb.c               | 19 ++++++-
>>   arch/loongarch/kvm/vcpu.c              |  7 ++-
>>   8 files changed, 128 insertions(+), 9 deletions(-)
>>
>>
>> base-commit: 2d5404caa8c7bb5c4e0435f94b28834ae5456623
>> --
>> 2.39.3
>>


