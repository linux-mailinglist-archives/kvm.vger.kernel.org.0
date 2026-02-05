Return-Path: <kvm+bounces-70319-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gFmFMhmChGl/3AMAu9opvQ
	(envelope-from <kvm+bounces-70319-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 12:42:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C4B5F1FB8
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 12:42:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C1C87300614C
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 11:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6CAE3B5302;
	Thu,  5 Feb 2026 11:42:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10733A7F5D;
	Thu,  5 Feb 2026 11:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770291731; cv=none; b=sYRttrmW3IO7AmHj4eJrUdYKxzVR9q7ccQWZOrpo92AeZexTsSafc3ZhwUpJjadn2dNNdh5kMzyEOS9bTwYKroRloV/7mJmTFiEKbtvLgZhB7WYDFGoL1E3iCb7vgIxqvorLhyeE0KhcJvzu4v6Ruk2DTpiYzH2JEAPlGMu44XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770291731; c=relaxed/simple;
	bh=vHL+E3uxxnhFuaa6PISDD3la3/3ftmgbCRpBwX9kRBM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=sV40391wcU7J9+Nimrjy0wNXMYmrAk4shCJJmx8EjHiSn326afJ6L8XJMiPgVaAnmkJsUmMYEcMaOl/hJUWtsAwOZ3e2+bgWXHPZViVqKyZfQ+zlLQuCQ7NmlhakI9GXEC+SqJiALOU+boc6fOkIgnRmgG5giilEMYJwWVUfYb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.239])
	by gateway (Coremail) with SMTP id _____8BxnsMNgoRpvhoQAA--.52406S3;
	Thu, 05 Feb 2026 19:42:06 +0800 (CST)
Received: from [10.20.42.239] (unknown [10.20.42.239])
	by front1 (Coremail) with SMTP id qMiowJBxLMIJgoRp1mdAAA--.52533S3;
	Thu, 05 Feb 2026 19:42:03 +0800 (CST)
Subject: Re: [PATCH v5 1/2] LongArch: KVM: Add DMSINTC device support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: maobibo@loongson.cn, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kernel@xen0n.name, linux-kernel@vger.kernel.org
References: <20251225091224.2893389-1-gaosong@loongson.cn>
 <20251225091224.2893389-2-gaosong@loongson.cn>
 <CAAhV-H5h2LioH6SZD8RUNewb4De3LWM9g2PJFUnTTkX+GG4cdw@mail.gmail.com>
From: gaosong <gaosong@loongson.cn>
Message-ID: <373e1c37-07f2-8a20-c305-03a88b573001@loongson.cn>
Date: Thu, 5 Feb 2026 19:43:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5h2LioH6SZD8RUNewb4De3LWM9g2PJFUnTTkX+GG4cdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJBxLMIJgoRp1mdAAA--.52533S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Jr1xJF13AF1kXFyUKw1UXFc_yoWfJFyUpF
	9rAFs8Gr48WryxCrn2gas8urnFvr4fKr129FyjgFW5ArnFvryrJry8Kr9ruF9xXa18Gr10
	vFyS93WY9a1Ut3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jjwZcUUUUU=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.988];
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
	TAGGED_FROM(0.00)[bounces-70319-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6C4B5F1FB8
X-Rspamd-Action: no action

Hi,

在 2026/1/15 下午3:43, Huacai Chen 写道:
> Hi, Song,
>
> On Thu, Dec 25, 2025 at 5:37 PM Song Gao <gaosong@loongson.cn> wrote:
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
>>   arch/loongarch/kvm/intc/dmsintc.c        | 110 +++++++++++++++++++++++
>>   arch/loongarch/kvm/main.c                |   6 ++
>>   include/uapi/linux/kvm.h                 |   2 +
>>   7 files changed, 147 insertions(+)
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
>> index 000000000000..3fdea81a08c8
>> --- /dev/null
>> +++ b/arch/loongarch/kvm/intc/dmsintc.c
>> @@ -0,0 +1,110 @@
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
> No need to call kvm_io_bus_unregister_dev()? And it seems you need to
> kfree(dev) if this series is correct:
Yes , need  kfree(dev), I will correct it on v6.

but no need kvm_io_bus_unregister_dev()
dmsintc did't use kvm_io_bus_register_dev().

Thanks.
Song Gao
> https://lore.kernel.org/loongarch/99826cf9-356d-235b-9c7c-9d51d36e53c3@loongson.cn/T/#t
>
> Huacai
>
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


