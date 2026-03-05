Return-Path: <kvm+bounces-72818-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHfzGOl5qWl77wAAu9opvQ
	(envelope-from <kvm+bounces-72818-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:41:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D563A211DA8
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 13:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 746FD309A3DA
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 12:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8056A384239;
	Thu,  5 Mar 2026 12:37:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A3D39B4B7;
	Thu,  5 Mar 2026 12:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772714259; cv=none; b=SwxJ55agylwpNwCl0OQHDjArFuJUYHS4agoYHL1iGmK4a3Ey7e6vWINqEefOeyN2pzfFD3dGNqQiBmJJWh0qg4NKgM5vgl7xXUw2PbpZta4TIMSLQ0R3kddt3gs7xewB2yRkMi7kgFguaRYjN4h/i+0opUcjeRZCqEVSEVxaTHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772714259; c=relaxed/simple;
	bh=nv9gh6ezBxJOvp0uZ1L0GbmfqjP40BJ9xqxfgSclWzA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hbWhRSne+2KAIjiq8D+hlRNf4EicEV/wT/hbJlICbhXJCJKibOeN23vOIkRCP/TTC764COwb58Y4Gx4+uSHRlRqNfpsZoa74T1ORlBj9S4Z0YzKTP+zz9QvalHZg+ZTEHMv+0OUyKX3SzR5ubvB+RahGONqgGLrR4VVaPHXBI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.239])
	by gateway (Coremail) with SMTP id _____8BxnsMGealpH8UXAA--.6288S3;
	Thu, 05 Mar 2026 20:37:26 +0800 (CST)
Received: from [10.20.42.239] (unknown [10.20.42.239])
	by front1 (Coremail) with SMTP id qMiowJBxbcIDealpx9tOAA--.16675S3;
	Thu, 05 Mar 2026 20:37:25 +0800 (CST)
Subject: Re: [PATCH v6 1/2] LongArch: KVM: Add DMSINTC device support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kernel@xen0n.name, linux-kernel@vger.kernel.org
References: <20260206012028.3318291-1-gaosong@loongson.cn>
 <20260206012028.3318291-2-gaosong@loongson.cn>
 <CAAhV-H4a=c7CmwtK95rF-3hwq=6c2DYv1dvEdrHKM_+MKFPK-g@mail.gmail.com>
From: gaosong <gaosong@loongson.cn>
Message-ID: <24a9fd42-37ab-fa09-4571-c91df946da10@loongson.cn>
Date: Thu, 5 Mar 2026 20:38:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4a=c7CmwtK95rF-3hwq=6c2DYv1dvEdrHKM_+MKFPK-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJBxbcIDealpx9tOAA--.16675S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3JFyDJr4xAw1UGw1rCr18tFc_yoWfWry5pF
	9rAFs5Gr48WryxCrn2gas8urnFvr4fKr129FyYgFyUArnFvrykAry8Kr9ruFy3Xa18Gr10
	vFya93WY9a1Ut3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8j-
	e5UUUUU==
X-Rspamd-Queue-Id: D563A211DA8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.960];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gaosong@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72818-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Action: no action

Hi, Huacai

在 2026/3/5 下午3:31, Huacai Chen 写道:
> Hi, Song,
>
> On Fri, Feb 6, 2026 at 9:45 AM Song Gao <gaosong@loongson.cn> wrote:
>> Add device model for DMSINTC interrupt controller, implement basic
>> create/destroy/set_attr interfaces, and register device model to kvm
>> device table.
>>
>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>> Signed-off-by: Song Gao <gaosong@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_dmsintc.h |  21 +++++
>>   arch/loongarch/include/asm/kvm_host.h    |   3 +
>>   arch/loongarch/include/uapi/asm/kvm.h    |   4 +
>>   arch/loongarch/kvm/Makefile              |   1 +
>>   arch/loongarch/kvm/intc/dmsintc.c        | 111 +++++++++++++++++++++++
>>   arch/loongarch/kvm/main.c                |   6 ++
>>   include/uapi/linux/kvm.h                 |   2 +
>>   7 files changed, 148 insertions(+)
>>   create mode 100644 arch/loongarch/include/asm/kvm_dmsintc.h
>>   create mode 100644 arch/loongarch/kvm/intc/dmsintc.c
>>
>> diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/include/asm/kvm_dmsintc.h
>> new file mode 100644
>> index 000000000000..1d4f66996f3c
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_dmsintc.h
>> @@ -0,0 +1,21 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2025 Loongson Technology Corporation Limited
>> + */
>> +
>> +#ifndef __ASM_KVM_DMSINTC_H
>> +#define __ASM_KVM_DMSINTC_H
>> +
>> +
>> +struct loongarch_dmsintc  {
> Here is an extra space.
I'll correct it on v7.
>> +       struct kvm *kvm;
>> +       uint64_t msg_addr_base;
>> +       uint64_t msg_addr_size;
>> +};
>> +
>> +struct dmsintc_state {
>> +       atomic64_t  vector_map[4];
>> +};
>> +
>> +int kvm_loongarch_register_dmsintc_device(void);
>> +#endif
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index e4fe5b8e8149..5e9e2af7312f 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -22,6 +22,7 @@
>>   #include <asm/kvm_ipi.h>
>>   #include <asm/kvm_eiointc.h>
>>   #include <asm/kvm_pch_pic.h>
>> +#include <asm/kvm_dmsintc.h>
>>   #include <asm/loongarch.h>
>>
>>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>> @@ -134,6 +135,7 @@ struct kvm_arch {
>>          struct loongarch_ipi *ipi;
>>          struct loongarch_eiointc *eiointc;
>>          struct loongarch_pch_pic *pch_pic;
>> +       struct loongarch_dmsintc *dmsintc;
>>   };
>>
>>   #define CSR_MAX_NUMS           0x800
>> @@ -244,6 +246,7 @@ struct kvm_vcpu_arch {
>>          struct kvm_mp_state mp_state;
>>          /* ipi state */
>>          struct ipi_state ipi_state;
>> +       struct dmsintc_state dmsintc_state;
>>          /* cpucfg */
>>          u32 cpucfg[KVM_MAX_CPUCFG_REGS];
>>
>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>> index de6c3f18e40a..0a370d018b08 100644
>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>> @@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
>>   #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL             0x40000006
>>   #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT            0
>>
>> +#define KVM_DEV_LOONGARCH_DMSINTC_CTRL                 0x40000007
>> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE                0x0
>> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE                0x1
>> +
>>   #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
>> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
>> index cb41d9265662..6e184e24443c 100644
>> --- a/arch/loongarch/kvm/Makefile
>> +++ b/arch/loongarch/kvm/Makefile
>> @@ -19,6 +19,7 @@ kvm-y += vm.o
>>   kvm-y += intc/ipi.o
>>   kvm-y += intc/eiointc.o
>>   kvm-y += intc/pch_pic.o
>> +kvm-y += intc/dmsintc.o
>>   kvm-y += irqfd.o
>>
>>   CFLAGS_exit.o  += $(call cc-disable-warning, override-init)
>> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/dmsintc.c
>> new file mode 100644
>> index 000000000000..00e401de0464
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/intc/dmsintc.c
>> @@ -0,0 +1,111 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2025 Loongson Technology Corporation Limited
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <asm/kvm_dmsintc.h>
>> +#include <asm/kvm_vcpu.h>
>> +
>> +static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
>> +                               struct kvm_device_attr *attr,
>> +                               bool is_write)
>> +{
>> +       int addr = attr->attr;
>> +       void __user *data;
>> +       struct loongarch_dmsintc *s = dev->kvm->arch.dmsintc;
>> +       u64 tmp;
>> +
>> +       data = (void __user *)attr->addr;
>> +       switch (addr) {
>> +       case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE:
>> +               if (is_write) {
>> +                       if (copy_from_user(&tmp, data, sizeof(s->msg_addr_base)))
>> +                               return -EFAULT;
>> +                       if (s->msg_addr_base) {
>> +                               /* Duplicate setting are not allowed. */
>> +                               return -EFAULT;
>> +                       }
>> +                       if ((tmp & (BIT(AVEC_CPU_SHIFT) - 1)) == 0)
>> +                               s->msg_addr_base = tmp;
>> +                       else
>> +                               return  -EFAULT;
>> +               }
>> +               break;
>> +       case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
>> +               if (is_write) {
>> +                       if (copy_from_user(&tmp, data, sizeof(s->msg_addr_size)))
>> +                               return -EFAULT;
>> +                       if (s->msg_addr_size) {
>> +                               /*Duplicate setting are not allowed. */
>> +                               return -EFAULT;
>> +                       }
>> +                       s->msg_addr_size = tmp;
>> +               }
>> +               break;
>> +       default:
>> +               kvm_err("%s: unknown dmsintc register, addr = %d\n", __func__, addr);
>> +               return -ENXIO;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int kvm_dmsintc_set_attr(struct kvm_device *dev,
>> +                       struct kvm_device_attr *attr)
>> +{
>> +       switch (attr->group) {
>> +       case KVM_DEV_LOONGARCH_DMSINTC_CTRL:
>> +               return kvm_dmsintc_ctrl_access(dev, attr, true);
>> +       default:
>> +               kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
>> +               return -EINVAL;
>> +       }
>> +}
>> +
>> +static int kvm_dmsintc_create(struct kvm_device *dev, u32 type)
>> +{
>> +       struct kvm *kvm;
>> +       struct loongarch_dmsintc *s;
>> +
>> +       if (!dev) {
>> +               kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
>> +               return -EINVAL;
>> +       }
>> +
>> +       kvm = dev->kvm;
>> +       if (kvm->arch.dmsintc) {
>> +               kvm_err("%s: LoongArch DMSINTC has already been created!\n", __func__);
>> +               return -EINVAL;
>> +       }
>> +
>> +       s = kzalloc(sizeof(struct loongarch_dmsintc), GFP_KERNEL);
>> +       if (!s)
>> +               return -ENOMEM;
>> +
>> +       s->kvm = kvm;
>> +       kvm->arch.dmsintc = s;
>> +       return 0;
>> +}
>> +
>> +static void kvm_dmsintc_destroy(struct kvm_device *dev)
>> +{
>> +
>> +       if (!dev || !dev->kvm || !dev->kvm->arch.dmsintc)
>> +               return;
>> +
>> +       kfree(dev->kvm->arch.dmsintc);
>> +       kfree(dev);
>> +}
>> +
>> +static struct kvm_device_ops kvm_dmsintc_dev_ops = {
>> +       .name = "kvm-loongarch-dmsintc",
>> +       .create = kvm_dmsintc_create,
>> +       .destroy = kvm_dmsintc_destroy,
>> +       .set_attr = kvm_dmsintc_set_attr,
>> +};
>> +
>> +int kvm_loongarch_register_dmsintc_device(void)
>> +{
>> +       return kvm_register_device_ops(&kvm_dmsintc_dev_ops, KVM_DEV_TYPE_LOONGARCH_DMSINTC);
>> +}
>> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
>> index 80ea63d465b8..f363a3b24903 100644
>> --- a/arch/loongarch/kvm/main.c
>> +++ b/arch/loongarch/kvm/main.c
>> @@ -408,6 +408,12 @@ static int kvm_loongarch_env_init(void)
>>
>>          /* Register LoongArch PCH-PIC interrupt controller interface. */
>>          ret = kvm_loongarch_register_pch_pic_device();
>> +       if (ret)
>> +               return ret;
>> +
>> +       /* Register LoongArch DMSINTC interrupt contrroller interface */
>> +       if (cpu_has_msgint)
> I'm not sure, but there is kvm_guest_has_msgint(), I don't know which
> one is really needed.
>
It should be cpu_has_msgint.

1.kvm_loongarch_env_init is part of module initialization, runs when KVM 
module is loaded.
  At that time, no VM or vCPU objects exist yet.
2.cpu_has_msgint is a global flag indicating physical CPU capability 
(detected early, e.g., via cpucfg).
3.kvm_guest_has_msgint() typically depends on a specific vCPU's 
configuration (e.g., whether the guest has PMU enabled via userspace 
settings).
It requires a valid vCPU pointer and cannot be used before any vCPU is 
created.

Thanks.
Song Gao
> Huacai
>
>> +               ret = kvm_loongarch_register_dmsintc_device();
>>
>>          return ret;
>>   }
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index dddb781b0507..7c56e7e36265 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1209,6 +1209,8 @@ enum kvm_device_type {
>>   #define KVM_DEV_TYPE_LOONGARCH_EIOINTC KVM_DEV_TYPE_LOONGARCH_EIOINTC
>>          KVM_DEV_TYPE_LOONGARCH_PCHPIC,
>>   #define KVM_DEV_TYPE_LOONGARCH_PCHPIC  KVM_DEV_TYPE_LOONGARCH_PCHPIC
>> +       KVM_DEV_TYPE_LOONGARCH_DMSINTC,
>> +#define KVM_DEV_TYPE_LOONGARCH_DMSINTC   KVM_DEV_TYPE_LOONGARCH_DMSINTC
>>
>>          KVM_DEV_TYPE_MAX,
>>
>> --
>> 2.39.3
>>
>>


