Return-Path: <kvm+bounces-53795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC76B17059
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 13:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A38117AE904
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 11:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3E52C08C2;
	Thu, 31 Jul 2025 11:26:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9CE2BDC38;
	Thu, 31 Jul 2025 11:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753961176; cv=none; b=FE1f2YajQM8FYILencBygLaf382DmvVJamZ/IxJBdzv6zMxHN2cIB7tC+T7ROacu5FB283cMiB82ojCYEgUAar52FYrMZf5Obhbntl2UosEGMNoNLpwvoe8KGhcXthXWTIV095hDszMl9D/bPzeOAyZIoK9x4Ua0/5cmAXMEnQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753961176; c=relaxed/simple;
	bh=S48CgpWZHaB5oVhimlLTvU+OcBZXvcIO2aF5mZSrlI8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TK8oL7EViFyqbgE14qbyl3AEwmgFHfCP6i6nagP+hRzRAhaw0PRerIl519AcDUjk8jIFSbugAsLZZH+HPUXq05WrgfvRdDd2isq0HCtSFSllT5be5NaV4apwqfxz0F04ZHvcBY1UUXiLOKNwZCYaDtBcFKfefqdjMiYezWa83bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxzOLQUotooes1AQ--.41131S3;
	Thu, 31 Jul 2025 19:26:08 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDx_8PNUototGEvAA--.39900S3;
	Thu, 31 Jul 2025 19:26:07 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Access mailbox directly in mail_send()
To: Yanteng Si <si.yanteng@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250731075907.189847-1-maobibo@loongson.cn>
 <3fdcce8e-dff6-4871-82b3-571144a26c51@linux.dev>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <6793e1a8-00f6-c653-3a8a-5943c0471bb1@loongson.cn>
Date: Thu, 31 Jul 2025 19:24:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3fdcce8e-dff6-4871-82b3-571144a26c51@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDx_8PNUototGEvAA--.39900S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Zr1fKF1DAFWfZryUuF45Arc_yoW8KrWUpr
	ykJrWDJFW5GFn3WrWDtwn8XFy5Xw1kta4Dtr10qFW5ArW5Kr1FqF1UXr9a9r17Ww4xJr1I
	qF1UGrsxZr1UJwbCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j1WlkU
	UUUU=



On 2025/7/31 下午5:30, Yanteng Si wrote:
> 在 7/31/25 3:59 PM, Bibo Mao 写道:
>> With function mail_send(), it is to write mailbox of other VCPUs.
>> Existing simple APIs read_mailbox/write_mailbox can be used directly
>> rather than send command on IOCSR address.
> Hmm, that's indeed a feasible approach. However, I'm
> curious: what is the purpose of designing IOCSR in
> LoongArch? Is it merely to make things "complicated"?

I am not chip designer -:). MMIO address space is ok from my side, 
however I do not know how to solve multi-chip problem with MMIO method.

Regards
Bibo Mao
> 
> Thanks,
> Yanteng
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/intc/ipi.c | 16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/intc/ipi.c 
>> b/arch/loongarch/kvm/intc/ipi.c
>> index fe734dc062ed..832b2d4aa2ef 100644
>> --- a/arch/loongarch/kvm/intc/ipi.c
>> +++ b/arch/loongarch/kvm/intc/ipi.c
>> @@ -134,7 +134,8 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, 
>> gpa_t addr, uint64_t data)
>>   static int mail_send(struct kvm *kvm, uint64_t data)
>>   {
>> -    int cpu, mailbox, offset;
>> +    int i, cpu, mailbox, offset;
>> +    uint32_t val = 0, mask = 0;
>>       struct kvm_vcpu *vcpu;
>>       cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
>> @@ -144,9 +145,18 @@ static int mail_send(struct kvm *kvm, uint64_t data)
>>           return -EINVAL;
>>       }
>>       mailbox = ((data & 0xffffffff) >> 2) & 0x7;
>> -    offset = IOCSR_IPI_BASE + IOCSR_IPI_BUF_20 + mailbox * 4;
>> +    offset = IOCSR_IPI_BUF_20 + mailbox * 4;
>> +    if ((data >> 27) & 0xf) {
>> +        val = read_mailbox(vcpu, offset, 4);
>> +        for (i = 0; i < 4; i++)
>> +            if (data & (BIT(27 + i)))
>> +                mask |= (0xff << (i * 8));
>> +        val &= mask;
>> +    }
>> -    return send_ipi_data(vcpu, offset, data);
>> +    val |= ((uint32_t)(data >> 32) & ~mask);
>> +    write_mailbox(vcpu, offset, val, 4);
>> +    return 0;
>>   }
>>   static int any_send(struct kvm *kvm, uint64_t data)
>>
>> base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
> 


