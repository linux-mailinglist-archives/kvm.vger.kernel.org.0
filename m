Return-Path: <kvm+bounces-49959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E36AE0205
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 11:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64DC83AAFB9
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 09:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC72822127B;
	Thu, 19 Jun 2025 09:48:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D33F21C161;
	Thu, 19 Jun 2025 09:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750326539; cv=none; b=akyi6YgP/KYHKEXWFnKx7ke2/E1uV/BVJJx+hq16XGIr57mHalVnYiFsPUpu0ptTzctbCEUprBhiep+ScjzeDlDC7TSoOJuret2XF4yGHwx6C51BrQNf56MNifKqiQ+A43Oq8CMF3oCzqon0ZI3f9hciY+XCuwq+H/0s+plet/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750326539; c=relaxed/simple;
	bh=pQaQfvfkymPyxbo/McQRSxkUjty96tFS2NmlDh7MURs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DcRK7kMwZOmchl8qvJHZ0gNaNPWT/LYYzJnxYP40Ru8DWLRdCRYi/E/iSZPVqha+NMV9tzl01qaR67mhtIMsCzqS0kF7uiQvxo4XID4oJbST/qHmXDxjUlnN17N2IkOF56zeH1pIra5OpabkYa4fSosz1GQ2o2pPbYlSBlUE57M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxnOL93FNoCr4ZAQ--.23424S3;
	Thu, 19 Jun 2025 17:48:45 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBxLsf33FNoCe8gAQ--.38807S3;
	Thu, 19 Jun 2025 17:48:41 +0800 (CST)
Subject: Re: [PATCH v3 9/9] LoongArch: KVM: INTC: Add address alignment check
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250611014651.3042734-1-maobibo@loongson.cn>
 <20250611015145.3042884-1-maobibo@loongson.cn>
 <CAAhV-H6Eru5e6+_i+4DY9qwshibY43hjbS-QC-fhLD04-4mOGw@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <189ff8c8-2a34-770c-9a0f-8d99b46884dc@loongson.cn>
Date: Thu, 19 Jun 2025 17:47:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6Eru5e6+_i+4DY9qwshibY43hjbS-QC-fhLD04-4mOGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxLsf33FNoCe8gAQ--.38807S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr43Wry7uw43Kr1DXFy3Jrc_yoW5Ww48pr
	WUAFs8ua1rZry7X3sxtwn0g3WjqwsYgF1UZry7tFWS9F4rZF17JryrC3yYvFyjka4ftF40
	qF4Yqrn3uF45t3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU24SoDUUU
	U



On 2025/6/19 下午4:47, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Jun 11, 2025 at 9:51 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> IOCSR instruction supports 1/2/4/8 bytes access, the address should
>> be naturally aligned with its access size. Here address alignment
>> check is added in eiointc kernel emulation.
>>
>> At the same time len must be 1/2/4/8 bytes from iocsr exit emulation
>> function kvm_emu_iocsr(), remove the default case in switch case
>> statements.
> Robust code doesn't depend its callers do things right, so I suggest
> keeping the default case, which means we just add the alignment check
> here.
ok, will keep the default case.
> 
> And I think this patch should also Cc stable and add a Fixes tag.
ok, will add Cc stabe and Fixes tag.

Regards
Bibo Mao
> 
> 
> Huacai
> 
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/intc/eiointc.c | 21 +++++++++++++--------
>>   1 file changed, 13 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
>> index 8b0d9376eb54..4e9d12300cc4 100644
>> --- a/arch/loongarch/kvm/intc/eiointc.c
>> +++ b/arch/loongarch/kvm/intc/eiointc.c
>> @@ -311,6 +311,12 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>>                  return -EINVAL;
>>          }
>>
>> +       /* len must be 1/2/4/8 from function kvm_emu_iocsr() */
>> +       if (addr & (len - 1)) {
>> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
>> +               return -EINVAL;
>> +       }
>> +
>>          vcpu->stat.eiointc_read_exits++;
>>          spin_lock_irqsave(&eiointc->lock, flags);
>>          switch (len) {
>> @@ -323,12 +329,9 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>>          case 4:
>>                  ret = loongarch_eiointc_readl(vcpu, eiointc, addr, val);
>>                  break;
>> -       case 8:
>> +       default:
>>                  ret = loongarch_eiointc_readq(vcpu, eiointc, addr, val);
>>                  break;
>> -       default:
>> -               WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
>> -                                               __func__, addr, len);
>>          }
>>          spin_unlock_irqrestore(&eiointc->lock, flags);
>>
>> @@ -682,6 +685,11 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>>                  return -EINVAL;
>>          }
>>
>> +       if (addr & (len - 1)) {
>> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
>> +               return -EINVAL;
>> +       }
>> +
>>          vcpu->stat.eiointc_write_exits++;
>>          spin_lock_irqsave(&eiointc->lock, flags);
>>          switch (len) {
>> @@ -694,12 +702,9 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>>          case 4:
>>                  ret = loongarch_eiointc_writel(vcpu, eiointc, addr, val);
>>                  break;
>> -       case 8:
>> +       default:
>>                  ret = loongarch_eiointc_writeq(vcpu, eiointc, addr, val);
>>                  break;
>> -       default:
>> -               WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
>> -                                               __func__, addr, len);
>>          }
>>          spin_unlock_irqrestore(&eiointc->lock, flags);
>>
>> --
>> 2.39.3
>>


