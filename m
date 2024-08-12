Return-Path: <kvm+bounces-23818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05EC694E46D
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 03:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53B481F21F5A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 01:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F5D10A14;
	Mon, 12 Aug 2024 01:10:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82594C7B;
	Mon, 12 Aug 2024 01:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723425058; cv=none; b=ASdSwbMab9ChTTbJDc8IG8kqLk7Us4Z/EdCGbQ65brbvVN9ax2/I1fcZafreBcaAn8OYzFwNYUQYEgiBsMcjc4wbNgP9rg+tocvQyPThEOZjHWgwnkjDMhgDcUEp2Fp9cxWJCdTlKxi9rL20gs6TT2s6orSF1XUtOS9A3DRXbZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723425058; c=relaxed/simple;
	bh=rJrFm7yEqlB7PpqcS2AkAo08q2R8lUg3ybyZjtiWt9k=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=f6JiNSRIE2IaGlqOwBt7d7MjYAP9pYB+0YOyV0UR1uw09aicUKI5niaqB4nUMr6TMPE6vGoTdG7SW/Rjn9PALS7OwIfPxEIpdJcuSudurww2g77mtiYPI+KROEsBIPl2IfWBOWUjuAYxI8L0JUSCZGUeg1Jo3+yAHmi25NbWgl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bxa+ocYblmfzgQAA--.41743S3;
	Mon, 12 Aug 2024 09:10:52 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMDxkeEZYblmzYkPAA--.8190S3;
	Mon, 12 Aug 2024 09:10:49 +0800 (CST)
Subject: Re: [PATCH v5 3/3] irqchip/loongson-eiointc: Add extioi virt
 extension support
To: Thomas Gleixner <tglx@linutronix.de>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, x86@kernel.org,
 Song Gao <gaosong@loongson.cn>
References: <20240805073546.668475-1-maobibo@loongson.cn>
 <20240805073546.668475-4-maobibo@loongson.cn> <87wmkortqo.ffs@tglx>
From: maobibo <maobibo@loongson.cn>
Message-ID: <09d4ad7a-0548-28e6-f60e-c1b68c8c20b5@loongson.cn>
Date: Mon, 12 Aug 2024 09:10:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <87wmkortqo.ffs@tglx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxkeEZYblmzYkPAA--.8190S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tw4DCFWxurykJrWfWF47Jrc_yoW8Aw4kpF
	W8tFsI9w4DtryavwsYqrn7JF1FvrsxJFWUK3W8KayrJa9rZryrtFnYvFy3A3WDC348AasI
	qFW5JF4j9a4SyrXCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UU
	UUU==



On 2024/8/11 上午4:46, Thomas Gleixner wrote:
> On Mon, Aug 05 2024 at 15:35, Bibo Mao wrote:
> 
>> Interrupts can be routed to maximal four virtual CPUs with one external
>> hardware interrupt. Add the extioi virt extension support so that
>> Interrupts can be routed to 256 vcpus on hypervisor mode.
> 
> interrupts .... 256 vCPUs in hypervisor mode.
will modify in next version.

> 
>>   static int cpu_to_eio_node(int cpu)
>>   {
>> -	return cpu_logical_map(cpu) / CORES_PER_EIO_NODE;
>> +	int cores;
>> +
>> +	if (kvm_para_available() && kvm_para_has_feature(KVM_FEATURE_VIRT_EXTIOI))
> 
> Why isn't that kvm_para_available() check inside of
> kvm_para_has_feature() instead of inflicting it on every usage site?
> That's just error prone.
I had the same idea but not sure about it, it is to follow the 
implemantion of x86.

Yeap, it is better to put kvm_para_available() in function 
kvm_para_has_feature(), one api for caller is simple and enough.

Will do in next version.
> 
>> +		cores = CORES_PER_VEIO_NODE;
>> +	else
>> +		cores = CORES_PER_EIO_NODE;
>> +	return cpu_logical_map(cpu) / cores;
>>   }
> 
>> @@ -105,18 +144,24 @@ static int eiointc_set_irq_affinity(struct irq_data *d, const struct cpumask *af
>> @@ -140,17 +185,23 @@ static int eiointc_index(int node)
>>   
>>   static int eiointc_router_init(unsigned int cpu)
>>   {
>> -	int i, bit;
>> -	uint32_t data;
>> -	uint32_t node = cpu_to_eio_node(cpu);
>> -	int index = eiointc_index(node);
>> +	uint32_t data, node;
>> +	int i, bit, cores, index;
> 
> Is it so hard to follow:
> 
>    https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#variable-declarations
> 
> ?
Sorry to have the same coding style issue for the second time. I am not 
familiar with it.

Will do in next version.

Regards
Bibo Mao
> 
> Thanks,
> 
>          tglx
> 


