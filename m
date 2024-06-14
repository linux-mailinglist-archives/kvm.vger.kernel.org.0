Return-Path: <kvm+bounces-19651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 29283908238
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 04:58:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCEE81F239D8
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 02:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8691836C2;
	Fri, 14 Jun 2024 02:58:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1606D801;
	Fri, 14 Jun 2024 02:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718333898; cv=none; b=s4BVW3oOg7fUduZ8LmGZ7p9VDR8Zpyi4Gq35oQN4Z1p2W2Dogtpdv/iC9YNK01VvHWQ5lSqvGpO6pw9Z58UwbhYJzkbRf/S5cHzFdKmTD2lYDO17vuA8GIm5XGliqZ/DoS4EugW6+JVBWEZ4+0mrAsb6Gm+NnNFhDNid/bRNoTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718333898; c=relaxed/simple;
	bh=/qaUwTmFTohtImbhL/sGW1eeZWtwNzwPZFtjccd2G7s=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YLWzsc1gYdlK64nb3o25vf9vmvwUbJTKOS96JcLKKZ/4n3PK1K+yW9l2LYYXATKzpeOTdfS4X3pOOeVOGvTIXPE5aFvQathPrpWHwJdU3kQjSHNGIghoARmsezhIBbBEHtTWeyOxQhRbdff1ZuGnZkRUR/S+domw55xwr5q1qGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxvOrDsWtmKMEGAA--.27070S3;
	Fri, 14 Jun 2024 10:58:11 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDMfBsWtmRakfAA--.12078S3;
	Fri, 14 Jun 2024 10:58:11 +0800 (CST)
Subject: Re: [PATCH] KVM: Discard zero mask with function kvm_dirty_ring_reset
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240613122803.1031511-1-maobibo@loongson.cn>
 <Zmsg8ciwSp1a_864@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <3cf851a2-be51-f227-82a4-090de01bc8be@loongson.cn>
Date: Fri, 14 Jun 2024 10:58:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Zmsg8ciwSp1a_864@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxDMfBsWtmRakfAA--.12078S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7CF4fKr43CFWxAF1xWF47Jrc_yoW8Cw17pF
	s3t3WkGF4Svas0g39xAw1DXrnIv392qFykJFyDGw4DK3sIyr15W3WUta40vrnruF1xAFyf
	AF4aqF47ZF17CwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7Mmh
	UUUUU



On 2024/6/14 上午12:43, Sean Christopherson wrote:
> On Thu, Jun 13, 2024, Bibo Mao wrote:
>> Function kvm_reset_dirty_gfn may be called with parameters cur_slot /
>> cur_offset / mask are all zero, it does not represent real dirty page.
>> It is not necessary to clear dirty page in this condition. Also return
>> value of macro __fls() is undefined if mask is zero which is called in
>> funciton kvm_reset_dirty_gfn(). Here just discard it.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   virt/kvm/dirty_ring.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
>> index 86d267db87bb..05f4c1c40cc7 100644
>> --- a/virt/kvm/dirty_ring.c
>> +++ b/virt/kvm/dirty_ring.c
>> @@ -147,14 +147,16 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>>   				continue;
>>   			}
>>   		}
>> -		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>> +		if (mask)
>> +			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>>   		cur_slot = next_slot;
>>   		cur_offset = next_offset;
>>   		mask = 1;
>>   		first_round = false;
>>   	}
>>   
>> -	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>> +	if (mask)
>> +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> 
> Given that mask must be checked before __fls(), just do:
That is ok for me. To be frankly I am not familiar with kvm common code,
I submit this patch just when I look through the migration source code.

Regards
Bibo Mao
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 86d267db87bb..7bc74969a819 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -55,6 +55,9 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
>          struct kvm_memory_slot *memslot;
>          int as_id, id;
>   
> +       if (!mask)
> +               return;
> +
>          as_id = slot >> 16;
>          id = (u16)slot;
> 


