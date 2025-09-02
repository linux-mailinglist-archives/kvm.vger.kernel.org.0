Return-Path: <kvm+bounces-56594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA226B4003C
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 14:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D20167B4B22
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 12:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78342FAC19;
	Tue,  2 Sep 2025 12:17:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1BA2C11C9;
	Tue,  2 Sep 2025 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756815445; cv=none; b=VahLaEJPZjkLV6ytJmZO18xJBkGlNuVVp4USAv+g76voZOIH9ZNnieuBicPu8aSf5a5QYVEHL8Cud81Zd0vJNs+k0dAnDRHe/voied3vfPmTthyusLUxRIxndAgOovsYgjdllKPXeqCKbHis3ZMLuE1NP1kdLn3H0yJQVDp9EcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756815445; c=relaxed/simple;
	bh=WKeK4TjkDMRS3nDi2iaypR+EoL8NEvPvhPoo5d5rfMI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=k6GMARSfQyRq2fj5iiLXhcVGOla1XLD78IWEVwki6//lj+nOUHNA4At2CJ0kYlfa1lefPoce9lWXlQWOSt7u7M6TPzVbFvllYUMMJw7Ni7chDsNJ8wZdEtxEYn5v9iVIhf1bthSGJZ3A59fHjs84cVp364aM9+NDXhCYw0jOemI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cxbb9K4LZoessFAA--.11075S3;
	Tue, 02 Sep 2025 20:17:14 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxjcFH4LZozO54AA--.64270S3;
	Tue, 02 Sep 2025 20:17:13 +0800 (CST)
Subject: Re: [PATCH 1/4] LoongArch: KVM: Avoid use copy_from_user with lock
 hold in kvm_eiointc_regs_access
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Xianglai Li <lixianglai@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250902094945.2957566-1-maobibo@loongson.cn>
 <20250902094945.2957566-2-maobibo@loongson.cn>
 <CAAhV-H7hCggw_zhQk89uvBrpAPxgHCS_BC5+twsyZdwWkF4A1g@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <4eb3fffa-8330-ad54-8cbc-2cabf6355c74@loongson.cn>
Date: Tue, 2 Sep 2025 20:15:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7hCggw_zhQk89uvBrpAPxgHCS_BC5+twsyZdwWkF4A1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxjcFH4LZozO54AA--.64270S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxtr47uw4rJr4rGr4fJw1xXrc_yoWxGr1fpr
	yUAFsakr4rXry7ZrnFyw1DAr17Aw4xZ3W8Jr18KFyUur1jgrn3tFy8GrW7AF1YkwnxJF1I
	qF1qyF1Yvr1UtwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU92b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AK
	xVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x07jnUUUUUUUU=



On 2025/9/2 下午7:58, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Tue, Sep 2, 2025 at 5:49 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Function copy_from_user() and copy_to_user() may sleep because of page
>> fault, and they cannot be called in spin_lock hold context. Otherwise there
>> will be possible warning such as:
>>
>> BUG: sleeping function called from invalid context at include/linux/uaccess.h:192
>> in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 6292, name: qemu-system-loo
>> preempt_count: 1, expected: 0
>> RCU nest depth: 0, expected: 0
>> INFO: lockdep is turned off.
>> irq event stamp: 0
>> hardirqs last  enabled at (0): [<0000000000000000>] 0x0
>> hardirqs last disabled at (0): [<9000000004c4a554>] copy_process+0x90c/0x1d40
>> softirqs last  enabled at (0): [<9000000004c4a554>] copy_process+0x90c/0x1d40
>> softirqs last disabled at (0): [<0000000000000000>] 0x0
>> CPU: 41 UID: 0 PID: 6292 Comm: qemu-system-loo Tainted: G W 6.17.0-rc3+ #31 PREEMPT(full)
>> Tainted: [W]=WARN
>> Stack : 0000000000000076 0000000000000000 9000000004c28264 9000100092ff4000
>>          9000100092ff7b80 9000100092ff7b88 0000000000000000 9000100092ff7cc8
>>          9000100092ff7cc0 9000100092ff7cc0 9000100092ff7a00 0000000000000001
>>          0000000000000001 9000100092ff7b88 947d2f9216a5e8b9 900010008773d880
>>          00000000ffff8b9f fffffffffffffffe 0000000000000ba1 fffffffffffffffe
>>          000000000000003e 900000000825a15b 000010007ad38000 9000100092ff7ec0
>>          0000000000000000 0000000000000000 9000000006f3ac60 9000000007252000
>>          0000000000000000 00007ff746ff2230 0000000000000053 9000200088a021b0
>>          0000555556c9d190 0000000000000000 9000000004c2827c 000055556cfb5f40
>>          00000000000000b0 0000000000000007 0000000000000007 0000000000071c1d
>> Call Trace:
>> [<9000000004c2827c>] show_stack+0x5c/0x180
>> [<9000000004c20fac>] dump_stack_lvl+0x94/0xe4
>> [<9000000004c99c7c>] __might_resched+0x26c/0x290
>> [<9000000004f68968>] __might_fault+0x20/0x88
>> [<ffff800002311de0>] kvm_eiointc_regs_access.isra.0+0x88/0x380 [kvm]
>> [<ffff8000022f8514>] kvm_device_ioctl+0x194/0x290 [kvm]
>> [<900000000506b0d8>] sys_ioctl+0x388/0x1010
>> [<90000000063ed210>] do_syscall+0xb0/0x2d8
>> [<9000000004c25ef8>] handle_syscall+0xb8/0x158
>>
>> Fixes: 1ad7efa552fd5 ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/intc/eiointc.c | 33 ++++++++++++++++++++-----------
>>   1 file changed, 21 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
>> index 026b139dcff2..2fb5b9c6e8ad 100644
>> --- a/arch/loongarch/kvm/intc/eiointc.c
>> +++ b/arch/loongarch/kvm/intc/eiointc.c
>> @@ -462,19 +462,17 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
>>
>>   static int kvm_eiointc_regs_access(struct kvm_device *dev,
>>                                          struct kvm_device_attr *attr,
>> -                                       bool is_write)
>> +                                       bool is_write, int *data)
>>   {
>>          int addr, cpu, offset, ret = 0;
>>          unsigned long flags;
>>          void *p = NULL;
>> -       void __user *data;
>>          struct loongarch_eiointc *s;
>>
>>          s = dev->kvm->arch.eiointc;
>>          addr = attr->attr;
>>          cpu = addr >> 16;
>>          addr &= 0xffff;
>> -       data = (void __user *)attr->addr;
>>          switch (addr) {
>>          case EIOINTC_NODETYPE_START ... EIOINTC_NODETYPE_END:
>>                  offset = (addr - EIOINTC_NODETYPE_START) / 4;
>> @@ -513,13 +511,10 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
>>          }
>>
>>          spin_lock_irqsave(&s->lock, flags);
>> -       if (is_write) {
>> -               if (copy_from_user(p, data, 4))
>> -                       ret = -EFAULT;
>> -       } else {
>> -               if (copy_to_user(data, p, 4))
>> -                       ret = -EFAULT;
>> -       }
>> +       if (is_write)
>> +               memcpy(p, data, 4);
>> +       else
>> +               memcpy(data, p, 4);
> p is a local variable, data is a parameter, they both have nothing to
> do with s, why memcpy need to be protected?
p is pointer to register buffer rather than local variable. When dump 
extioi register to user space, maybe one vCPU is writing extioi register 
at the same time, so there needs spinlock protection.

> 
> After some thinking I found the code was wrong at the first time.  The
> real code that needs to be protected is not copy_from_user() or
> memcpy(), but the above switch block.
For switch block in function kvm_eiointc_regs_access() for example, it 
is only to get register buffer pointer, not register content. Spinlock 
protection is not necessary in switch block.

Regards
Bibo Mao
> 
> Other patches have similar problems.
> 
> Huacai
> 
>>          spin_unlock_irqrestore(&s->lock, flags);
>>
>>          return ret;
>> @@ -576,9 +571,18 @@ static int kvm_eiointc_sw_status_access(struct kvm_device *dev,
>>   static int kvm_eiointc_get_attr(struct kvm_device *dev,
>>                                  struct kvm_device_attr *attr)
>>   {
>> +       int ret, data;
>> +
>>          switch (attr->group) {
>>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
>> -               return kvm_eiointc_regs_access(dev, attr, false);
>> +               ret = kvm_eiointc_regs_access(dev, attr, false, &data);
>> +               if (ret)
>> +                       return ret;
>> +
>> +               if (copy_to_user((void __user *)attr->addr, &data, 4))
>> +                       ret = -EFAULT;
>> +
>> +               return ret;
>>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
>>                  return kvm_eiointc_sw_status_access(dev, attr, false);
>>          default:
>> @@ -589,11 +593,16 @@ static int kvm_eiointc_get_attr(struct kvm_device *dev,
>>   static int kvm_eiointc_set_attr(struct kvm_device *dev,
>>                                  struct kvm_device_attr *attr)
>>   {
>> +       int data;
>> +
>>          switch (attr->group) {
>>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL:
>>                  return kvm_eiointc_ctrl_access(dev, attr);
>>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS:
>> -               return kvm_eiointc_regs_access(dev, attr, true);
>> +               if (copy_from_user(&data, (void __user *)attr->addr, 4))
>> +                       return -EFAULT;
>> +
>> +               return kvm_eiointc_regs_access(dev, attr, true, &data);
>>          case KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS:
>>                  return kvm_eiointc_sw_status_access(dev, attr, true);
>>          default:
>> --
>> 2.39.3
>>


