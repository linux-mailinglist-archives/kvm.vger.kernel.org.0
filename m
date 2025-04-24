Return-Path: <kvm+bounces-44081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D76F7A9A2EB
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE57A19468E6
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B4B1EFFAB;
	Thu, 24 Apr 2025 07:07:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF241DED52;
	Thu, 24 Apr 2025 07:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745478422; cv=none; b=kxOdmd/gkjuT0jr1dNPl1iY8L7ojtjBL9m9WC86RdHpUwXSbZ15VFhPpAf5BnUbOxCKXhYcVntQfqYkBZnU8Kzcwf+JRCjAplE2rc/T4m/Y9HoljWrkU5+0nVgZWyOZ0eUsrwU/rJ2O/5ReQ3ZIFv9mifL2NlEB2SIf1YliYdPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745478422; c=relaxed/simple;
	bh=Cm/cNrvc88Dk3pDmdPfKEoW8B86JZMfXK8wzgIhwaQA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TPR70XSnlZc8AVE5Yp4Ig7z293KhPtzTAs8NXTEJvfX4BcYTLty9ESrh12PWSx758tq9xAIWCZM4N1wJAhKct5HHslBMMpnkrg1+oTdHvpPNm+RGUt4wkcjO7bsxI1Xv4Ybq2JpPnxiCDLG79AeC2Bgoq82xssyU2qYP8wiYtKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxzOIP4wloriLFAA--.64601S3;
	Thu, 24 Apr 2025 15:06:55 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBxn8UN4wloXSGTAA--.40573S3;
	Thu, 24 Apr 2025 15:06:55 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Fully clear some registers when VM reboot
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250424063846.3927992-1-maobibo@loongson.cn>
 <CAAhV-H51WRgk8Bs5dsF1LrgdaqL7dk9ioy7H79voZKapov9U2g@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <883cb562-9236-f161-71fa-0b963db22a11@loongson.cn>
Date: Thu, 24 Apr 2025 15:05:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H51WRgk8Bs5dsF1LrgdaqL7dk9ioy7H79voZKapov9U2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxn8UN4wloXSGTAA--.40573S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7uw1kKrWUXFWkGFyktF48KrX_yoW8uF1Dpr
	yjkF1UWr48WrnrG3W7XrsYgFyYgrZ7Kr48ZF9IqF9Fkrn0v34DKF40krWayF98J348JF1S
	vFy5C3yS9F4qy3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v2
	6r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIev
	Ja73UjIFyTuYvjxU24SoDUUUU



On 2025/4/24 下午2:53, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Thu, Apr 24, 2025 at 2:38 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Some registers such as LOONGARCH_CSR_ESTAT and LOONGARCH_CSR_GINTC
>> are partly cleared with function _kvm_set_csr(). This comes from hardware
> I cannot find the _kvm_set_csr() function, maybe it's a typo?
oop, it is _kvm_setcsr(), will refresh in next version.

> And the tile can be "LoongArch: KVM: Fully clear some CSRs when VM reboot"
yeap, this title is more suitable.

Regards
Bibo Mao
> 
> Huacai
> 
>> specification, some bits are read only in VM mode, and however it can be
>> written in host mode. So it is partly cleared in VM mode, and can be fully
>> cleared in host mode.
>>
>> These read only bits show pending interrupt or exception status. When VM
>> reset, the read-only bits should be cleared, otherwise vCPU will receive
>> unknown interrupts in boot stage.
>>
>> Here registers LOONGARCH_CSR_ESTAT/LOONGARCH_CSR_GINTC are fully cleared
>> in ioctl KVM_REG_LOONGARCH_VCPU_RESET vCPU reset path.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/vcpu.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 8e427b379661..80b2316d6f58 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -902,6 +902,14 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
>>                          vcpu->arch.st.guest_addr = 0;
>>                          memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
>>                          memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
>> +
>> +                       /*
>> +                        * When vCPU reset, clear the ESTAT and GINTC registers
>> +                        * And the other CSR registers are cleared with function
>> +                        * _kvm_set_csr().
>> +                        */
>> +                       kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_GINTC, 0);
>> +                       kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_ESTAT, 0);
>>                          break;
>>                  default:
>>                          ret = -EINVAL;
>>
>> base-commit: 9d7a0577c9db35c4cc52db90bc415ea248446472
>> --
>> 2.39.3
>>
>>


