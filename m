Return-Path: <kvm+bounces-19649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C23999081D5
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 04:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54251284129
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 02:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0FF018309E;
	Fri, 14 Jun 2024 02:46:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E563201;
	Fri, 14 Jun 2024 02:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718333185; cv=none; b=fQsbQZFj1oA9gMS17QFf5nN0IS6cA8SGHDvr5jmMOeLQ1Mi1YtUwSgX/okX6E/sKN5GjGY28JECQppj8O0HfcB8IIucI0/veKH9Q5BLMn94qLME80laiIla/8k+BiT28+P2W264ePoqqB14SgSQM3yo5LekjDCpeA6wyp8MqTKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718333185; c=relaxed/simple;
	bh=zPvvfcrWiryVVmbdckHsbGSqcaJy4UzIjFMflqZUQQE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YzqAGjjgkMkmATEfxfjjk9eZzbOEV43y2el05vu66lp5IbNJ2kmkba6JlwVu5HBHV+5WLs/SsxIHsqaLOXRg0XQJ4VIY2xApf3rFHfVeXjSQcdpQNb51+6wIpiM4astxfcsE6S81vmIFgBH4J9tLmCSfATLOiJG44N8u5XEnkfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxW+rnrmtmN8AGAA--.27338S3;
	Fri, 14 Jun 2024 10:46:00 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx28bkrmtmnKUfAA--.11909S3;
	Fri, 14 Jun 2024 10:45:59 +0800 (CST)
Subject: Re: [PATCH] KVM: Remove duplicated zero clear with dirty_bitmap
 buffer
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240613125407.1126587-1-maobibo@loongson.cn>
 <115973a9-caa6-4d53-a477-dea2d2291598@wanadoo.fr>
From: maobibo <maobibo@loongson.cn>
Message-ID: <fb2da53e-791d-aef7-4dbb-dcf054675f9b@loongson.cn>
Date: Fri, 14 Jun 2024 10:45:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <115973a9-caa6-4d53-a477-dea2d2291598@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Bx28bkrmtmnKUfAA--.11909S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJrW7urWrGr1fGw4furyxXrc_yoW8Zr13pF
	s3tFWUGrW5Jw18Cw17Cwn8W348t3yDtwn7Gr1UJFyUXr1kJr1vqr4IgF10g3WUZr4Iy3Wr
	JF4jqFyUuF1UA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwmhF
	DUUUU



On 2024/6/14 上午3:25, Christophe JAILLET wrote:
> Le 13/06/2024 à 14:54, Bibo Mao a écrit :
>> Since dirty_bitmap pointer is allocated with function __vcalloc(),
>> there is __GFP_ZERO flag set in the implementation about this function
>> __vcalloc_noprof(). It is not necessary to clear dirty_bitmap buffer
>> with zero again.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   virt/kvm/kvm_main.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
> 
> Hi,
> 
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 14841acb8b95..c7d4a041dcfa 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1669,9 +1669,6 @@ static int kvm_prepare_memory_region(struct kvm 
>> *kvm,
>>               r = kvm_alloc_dirty_bitmap(new);
>>               if (r)
>>                   return r;
>> -
>> -            if (kvm_dirty_log_manual_protect_and_init_set(kvm))
>> -                bitmap_set(new->dirty_bitmap, 0, new->npages);
> 
> unless I miss something obvious, this does not clear anything, but set 
> all bits to 1.
> 
> 0 is not for "write 0" (i.e. clear), but for "start at offset 0".
> So all bits are set to 1 in this case.
you are right, I had thought it is to write 0 :(

I do not know whether KVM_DIRTY_LOG_INITIALLY_SET should be enabled on 
LoongArch. If it is set, write protection for second MMU will start one 
by one in function kvm_arch_mmu_enable_log_dirty_pt_masked() when dirty 
log is cleared if it is set, else write protection will start in 
function kvm_arch_commit_memory_region() when flag of memslot is changed.

I do not see the obvious benefits between these two write protect 
stages. Can anyone give me any hints?

Regards
Bibo Mao

> 
> CJ
> 
>>           }
>>       }
>>
>> base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670


