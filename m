Return-Path: <kvm+bounces-42095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E10A3A72905
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 04:17:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFA31189B009
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 03:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B9360DCF;
	Thu, 27 Mar 2025 03:17:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4E9747F;
	Thu, 27 Mar 2025 03:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743045458; cv=none; b=cQMSZ2SyxZVVoEh5gmrg4/Y6vrovojYja+j7uZze0ZaeqV5KRloHTahtLNCqmrb2a9KF8iRO2dN3Ch3FkhE3ouKrg0ccSBXPMED4cdhr42pkeBxxjL36W2dHzhzGXvegzE3ozIsKfyCjujD9dRBPitessfias6BdE/iClBz0+k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743045458; c=relaxed/simple;
	bh=LK3FQ677kjKnN1Ua1i6ZrGTNdvICfBNZt8mRjKi4gdY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=L3dS5FiTHriGX8rRizzN/3J4NVBHD98JM+adHBQpJm7J5uZlUbNBcVhO6ocD0msk4My3B8Kjgo8X5Wu4NsoqVQYu/Nb6KOWnVv9kNfs+Cn/op7rbLsYie+gR2LDA/5aPRIr8lHD8tHzHYeDt9WTHnSyCmbNicYreGPKDInhsiOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxdWlJw+RnvsanAA--.19431S3;
	Thu, 27 Mar 2025 11:17:29 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBxb8csw+Rnm35iAA--.30518S3;
	Thu, 27 Mar 2025 11:17:25 +0800 (CST)
Subject: Re: [RFC V2] LoongArch: KVM: Handle interrupt early before enabling
 irq
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250311074737.3160546-1-maobibo@loongson.cn>
 <c220d043-2314-85bb-e99d-dc2c609aa739@loongson.cn>
 <Z-QYwWxhBH_nvmWH@google.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <310c31c9-226a-3417-2a76-e7cbc97f169f@loongson.cn>
Date: Thu, 27 Mar 2025 11:16:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Z-QYwWxhBH_nvmWH@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxb8csw+Rnm35iAA--.30518S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZw15GF1xJF45Cw1UJr4fZwc_yoW5Xr4fpa
	y7Ca4vkr4DXFyIva9Fyw1IvF13Aw4kJrW5AFWkC34jv39xCw1vqr1UGayUtF9xCrykGa1j
	qr18Ka48Was8AFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6F4UJVW0owAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUc0eHDUUUU


On 2025/3/26 下午11:09, Sean Christopherson wrote:
> On Tue, Mar 25, 2025, bibo mao wrote:
>> Hi Paolo, Sean
>>
>> This idea comes from x86, do you have any guidance or suggestion about it?
>>
>> Also I notice that there is such irq_enable()/irq_disable() pair on x86, I
>> do not know why it is so.
> 
> Because on AMD (SVM), IRQ VM-Exits don't consume the IRQ, i.e. the exit is purely
> a notification.  KVM still needs to enable IRQs to actually handle the pending IRQ.
Good design. Previously only on some realtime HW platforms HW interrupt 
can be configured with high priority event. So with this, IRQ will 
trigger VM-Exits however no IRQ context since it is treated async event.

> And if the IRQ that triggered VM-Exit is for the host's tick, then it's desirable
> to handle the tick IRQ before guest_timing_exit_irqoff() so that the timeslice is
> accounted to the guest, not the host (the tick IRQ arrived while the guest was
> active).
> 
> On Intel (VMX), KVM always runs in a mode where the VM-Exit acknowledge/consumes
> the IRQ, and so KVM _must_ manually call into the appropriate interrupt handler.
> 
>>      local_irq_enable();
>>      ++vcpu->stat.exits;
>>      local_irq_disable();
>>      guest_timing_exit_irqoff();
>>      local_irq_enable();
>>
>> Regards
>> Bibo Mao
>>
>> On 2025/3/11 下午3:47, Bibo Mao wrote:
>>> If interrupt arrive when vCPU is running, vCPU will exit because of
>>> interrupt exception. Currently interrupt exception is handled after
>>> local_irq_enable() is called, and it is handled by host kernel rather
>>> than KVM hypervisor. It will introduce extra another interrupt
>>> exception and then host will handle irq.
>>>
>>> If KVM hypervisor detect that it is interrupt exception, interrupt
>>> can be handle early in KVM hypervisor before local_irq_enable() is
>>> called.
> 
> The correctness of this depends on how LoongArch virtualization processes IRQs.
> If the IRQ is consumed by the VM-Exit, then manually handling the IRQ early is
> both optimal and necessary for correctness.  If the IRQ is NOT consumed by the
LoongArch KVM is similiar with Intel vmx, host intterrupt causes 
VM-Exit, and also there will be extra interrupt exception if 
local_irq_enable() is called in VM-Exit path.


> VM-Exit, then manually calling the interrupt handler from KVM will result in every
> IRQ effectively happening twice: once on the manual call, and against when KVM
By test on LoongArch platform, manual call about IRQ handler at early 
stage will lower interrupt level and ack IRQ. IRQ will not trigger 
again. So I think it is consumed by the VM-Exit.

And thanks for your guidance.

Regards
Bibo Mao
> enables IRQs and the "real" IRQ fires.
> 


