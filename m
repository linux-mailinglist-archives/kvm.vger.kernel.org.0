Return-Path: <kvm+bounces-65478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1435CABFF0
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 04:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1334B3008FB9
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 03:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F352C15A9;
	Mon,  8 Dec 2025 03:57:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7668C231827;
	Mon,  8 Dec 2025 03:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765166239; cv=none; b=Zuof6ODQ+Cq/f5HHz3kTCm43S7VOdTjYsrXsu/EARHjQ2yPRIEi35Q5xIZ3VptJEetEbJgrmNkdwFOfUueaF6xBDvgEvJRiLPgacoEPd3W5gZV0232FWtwV4plI8AF2VQflx8jtgDp+CpFSqM8fEPl9/bzryavmxaxub4opwDT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765166239; c=relaxed/simple;
	bh=KGgxEg8uYIdQsUva+MeWwdYvnBcoEVBelfk2LGLq6bg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=eSkRpNvdk1jsQFxEGwyVIgXRTY/wMLdL/W2FqP6IOr3s+w3uUMQp9IZAVYT/S/jx1UjPgvGF8g4mbhYpz47vRLigrYBM2MmMaujPy6hPa4LtGJEAZv/wrdqIhm2QZydG8V/bii1CBkQC5KyrFCRTeqR4m4spqQhc/gEy7m8TeUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxK9KZTDZpVygsAA--.26981S3;
	Mon, 08 Dec 2025 11:57:13 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCx2sCVTDZpG+ZGAQ--.34533S3;
	Mon, 08 Dec 2025 11:57:12 +0800 (CST)
Subject: Re: [PATCH v3 2/4] LongArch: KVM: Add DINTC device support
To: Song Gao <gaosong@loongson.cn>, chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev, kernel@xen0n.name,
 linux-kernel@vger.kernel.org, lixianglai@loongson.cn
References: <20251206064658.714100-1-gaosong@loongson.cn>
 <20251206064658.714100-3-gaosong@loongson.cn>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <81aaba55-daf2-e455-fd0f-a0b62cc38015@loongson.cn>
Date: Mon, 8 Dec 2025 11:54:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251206064658.714100-3-gaosong@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCx2sCVTDZpG+ZGAQ--.34533S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Gr1rur18WrW5ZrWUWrW8KrX_yoW3WrW3pF
	yDAFs5Gr4rWr1xCr17t3Z8Zrnayr4xWw129a43WFWYkFsFvryrArykKr9rZFnxG3ykGr4I
	qF9Yk3WYga1DtwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU2nYF
	DUUUU



On 2025/12/6 下午2:46, Song Gao wrote:
> Add device model for AVEC interrupt controller, implement basic
> create/destroy/set_attr interfaces, and register device model to kvm
> device table.
> 
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_dintc.h |  21 +++++
>   arch/loongarch/include/asm/kvm_host.h  |   3 +
>   arch/loongarch/include/uapi/asm/kvm.h  |   4 +
>   arch/loongarch/kvm/Makefile            |   1 +
>   arch/loongarch/kvm/intc/dintc.c        | 110 +++++++++++++++++++++++++
>   arch/loongarch/kvm/main.c              |   5 ++
>   include/uapi/linux/kvm.h               |   2 +
>   7 files changed, 146 insertions(+)
>   create mode 100644 arch/loongarch/include/asm/kvm_dintc.h
>   create mode 100644 arch/loongarch/kvm/intc/dintc.c
> 
> diff --git a/arch/loongarch/include/asm/kvm_dintc.h b/arch/loongarch/include/asm/kvm_dintc.h
> new file mode 100644
> index 000000000000..d980d39c0344
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_dintc.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_KVM_DINTC_H
> +#define __ASM_KVM_DINTC_H
> +
> +
> +struct loongarch_dintc  {
> +	struct kvm *kvm;
> +	uint64_t msg_addr_base;
> +	uint64_t msg_addr_size;
> +};
> +
> +struct dintc_state {
> +	atomic64_t  vector_map[4];
> +};
> +
> +int kvm_loongarch_register_dintc_device(void);
> +#endif
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index e4fe5b8e8149..26a90f4146ac 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -22,6 +22,7 @@
>   #include <asm/kvm_ipi.h>
>   #include <asm/kvm_eiointc.h>
>   #include <asm/kvm_pch_pic.h>
> +#include <asm/kvm_dintc.h>
>   #include <asm/loongarch.h>
>   
>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -134,6 +135,7 @@ struct kvm_arch {
>   	struct loongarch_ipi *ipi;
>   	struct loongarch_eiointc *eiointc;
>   	struct loongarch_pch_pic *pch_pic;
> +	struct loongarch_dintc *dintc;
>   };
>   
>   #define CSR_MAX_NUMS		0x800
> @@ -244,6 +246,7 @@ struct kvm_vcpu_arch {
>   	struct kvm_mp_state mp_state;
>   	/* ipi state */
>   	struct ipi_state ipi_state;
> +	struct dintc_state dintc_state;
>   	/* cpucfg */
>   	u32 cpucfg[KVM_MAX_CPUCFG_REGS];
>   
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index de6c3f18e40a..07da84f7002c 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
>   #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL	        0x40000006
>   #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT	        0
>   
> +#define KVM_DEV_LOONGARCH_DINTC_CTRL			0x40000007
> +#define KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_BASE		0x0
> +#define KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_SIZE		0x1
> +
>   #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index cb41d9265662..fe984bf1cbdb 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -19,6 +19,7 @@ kvm-y += vm.o
>   kvm-y += intc/ipi.o
>   kvm-y += intc/eiointc.o
>   kvm-y += intc/pch_pic.o
> +kvm-y += intc/dintc.o
>   kvm-y += irqfd.o
>   
>   CFLAGS_exit.o	+= $(call cc-disable-warning, override-init)
> diff --git a/arch/loongarch/kvm/intc/dintc.c b/arch/loongarch/kvm/intc/dintc.c
> new file mode 100644
> index 000000000000..cd6cc9392adc
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/dintc.c
> @@ -0,0 +1,110 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_dintc.h>
> +#include <asm/kvm_vcpu.h>
> +
> +static int kvm_dintc_ctrl_access(struct kvm_device *dev,
> +				struct kvm_device_attr *attr,
> +				bool is_write)
> +{
> +	int addr = attr->attr;
> +	void __user *data;
> +	struct loongarch_dintc *s = dev->kvm->arch.dintc;
> +	u64 tmp;
> +
> +	data = (void __user *)attr->addr;
> +	switch (addr) {
> +	case KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_BASE:
> +		if (is_write) {
> +			if (copy_from_user(&tmp, data, sizeof(s->msg_addr_base)))
> +				return -EFAULT;
> +			if (s->msg_addr_base) {
> +				/* Duplicate setting are not allowed. */
> +				return -EFAULT;
> +			}
> +			if (tmp > (1UL << AVEC_CPU_SHIFT))
The address check should be (tmp & (BIT(AVEC_CPU_SHIFT) - 1) == 0 ?
otherwise look good to me.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> +				s->msg_addr_base = tmp;
> +			else
> +				return  -EFAULT;
> +		}
> +		break;
> +	case KVM_DEV_LOONGARCH_DINTC_MSG_ADDR_SIZE:
> +		if (is_write) {
> +			if (copy_from_user(&tmp, data, sizeof(s->msg_addr_size)))
> +				return -EFAULT;
> +			if (s->msg_addr_size) {
> +				/*Duplicate setting are not allowed. */
> +				return -EFAULT;
> +			}
> +			s->msg_addr_size = tmp;
> +		}
> +		break;
> +	default:
> +		kvm_err("%s: unknown dintc register, addr = %d\n", __func__, addr);
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int kvm_dintc_set_attr(struct kvm_device *dev,
> +			struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_LOONGARCH_DINTC_CTRL:
> +		return kvm_dintc_ctrl_access(dev, attr, true);
> +	default:
> +		kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
> +		return -EINVAL;
> +	}
> +}
> +
> +static int kvm_dintc_create(struct kvm_device *dev, u32 type)
> +{
> +	struct kvm *kvm;
> +	struct loongarch_dintc *s;
> +
> +	if (!dev) {
> +		kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	kvm = dev->kvm;
> +	if (kvm->arch.dintc) {
> +		kvm_err("%s: LoongArch DINTC has already been created!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	s = kzalloc(sizeof(struct loongarch_dintc), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	s->kvm = kvm;
> +	kvm->arch.dintc = s;
> +	return 0;
> +}
> +
> +static void kvm_dintc_destroy(struct kvm_device *dev)
> +{
> +
> +	if (!dev || !dev->kvm || !dev->kvm->arch.dintc)
> +		return;
> +
> +	kfree(dev->kvm->arch.dintc);
> +}
> +
> +static struct kvm_device_ops kvm_dintc_dev_ops = {
> +	.name = "kvm-loongarch-dintc",
> +	.create = kvm_dintc_create,
> +	.destroy = kvm_dintc_destroy,
> +	.set_attr = kvm_dintc_set_attr,
> +};
> +
> +int kvm_loongarch_register_dintc_device(void)
> +{
> +	return kvm_register_device_ops(&kvm_dintc_dev_ops, KVM_DEV_TYPE_LOONGARCH_DINTC);
> +}
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 80ea63d465b8..d18d9f4d485c 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -408,6 +408,11 @@ static int kvm_loongarch_env_init(void)
>   
>   	/* Register LoongArch PCH-PIC interrupt controller interface. */
>   	ret = kvm_loongarch_register_pch_pic_device();
> +	if (ret)
> +		return ret;
> +
> +	/* Register LoongArch DINTC interrupt contrroller interface */
> +	ret = kvm_loongarch_register_dintc_device();
>   
>   	return ret;
>   }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..ebf86a65eef1 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1209,6 +1209,8 @@ enum kvm_device_type {
>   #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
>   	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
>   #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
> +	KVM_DEV_TYPE_LOONGARCH_DINTC,
> +#define KVM_DEV_TYPE_LOONGARCH_DINTC   KVM_DEV_TYPE_LOONGARCH_DINTC
>   
>   	KVM_DEV_TYPE_MAX,
>   
> 


