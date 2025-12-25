Return-Path: <kvm+bounces-66682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 34EE1CDD62F
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 07:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0967301EC4B
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 06:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800122D592A;
	Thu, 25 Dec 2025 06:50:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E112F872;
	Thu, 25 Dec 2025 06:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766645446; cv=none; b=B5ABb5ba4Dcy2k9M3FtEeSNAhV3a/Rhibw6u4VqHQsM/u1zbGaLL/HpI4t57dXK4ktnFfguPcQROxw6RodSwnOZy7+KTiyBLOZvJJz4pPo1cXJ+1EEpUV+qDjuHvIq4fg/T+n28x8t/bzvIvgtEUL72zSzLJFN+3d9AmOPnP0ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766645446; c=relaxed/simple;
	bh=/3rvzGf7R9xZx92B6AGzNh9JalTAcxAWU9GtoN3ygTM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=sgXgDwkIRbi01S2AUvhfmqQVvUhSYvXQwZ4HnqVom7K8G36vfsYtBrBKvm5VgnitX7GV8d0qhnCCpDb7CFyghZotTgzykjVQD9+Z/OPHLl5fbCixr9VsgHdirpzHK1l6lY/17d+j7zTFxExVIBYFNvs4P8/gcJS4Ck1ydXhU63o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Axz8O_3kxpqRIDAA--.10183S3;
	Thu, 25 Dec 2025 14:50:39 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxzsK63kxpPqUEAA--.13655S3;
	Thu, 25 Dec 2025 14:50:37 +0800 (CST)
Subject: Re: [PATCH v4 1/3] LongArch: KVM: Add DMSINTC device support
To: Song Gao <gaosong@loongson.cn>, chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev, kernel@xen0n.name,
 linux-kernel@vger.kernel.org
References: <20251218111822.975455-1-gaosong@loongson.cn>
 <20251218111822.975455-2-gaosong@loongson.cn>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <83440865-63e1-d8bc-ccb1-9617e5ef33e5@loongson.cn>
Date: Thu, 25 Dec 2025 14:48:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251218111822.975455-2-gaosong@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxzsK63kxpPqUEAA--.13655S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3WrWxAr47tr4DXFWrJr47trc_yoW3CrWDpF
	9rAFs5Gr48Wr1xCrn7G3Z8ZrnxAr4fGw129FyUWFW5CrnIqr95JrykKr9rZFnxJay8GF4I
	qa4S93WY9a1Dt3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU70Pf
	DUUUU



On 2025/12/18 下午7:18, Song Gao wrote:
> Add device model for DMSINTC interrupt controller, implement basic
> create/destroy/set_attr interfaces, and register device model to kvm
> device table.
> 
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_dmsintc.h |  21 +++++
>   arch/loongarch/include/asm/kvm_host.h    |   3 +
>   arch/loongarch/include/uapi/asm/kvm.h    |   4 +
>   arch/loongarch/kvm/Makefile              |   1 +
>   arch/loongarch/kvm/intc/dmsintc.c        | 110 +++++++++++++++++++++++
>   arch/loongarch/kvm/main.c                |   5 ++
>   include/uapi/linux/kvm.h                 |   2 +
>   7 files changed, 146 insertions(+)
>   create mode 100644 arch/loongarch/include/asm/kvm_dmsintc.h
>   create mode 100644 arch/loongarch/kvm/intc/dmsintc.c
> 
> diff --git a/arch/loongarch/include/asm/kvm_dmsintc.h b/arch/loongarch/include/asm/kvm_dmsintc.h
> new file mode 100644
> index 000000000000..1d4f66996f3c
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_dmsintc.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __ASM_KVM_DMSINTC_H
> +#define __ASM_KVM_DMSINTC_H
> +
> +
> +struct loongarch_dmsintc  {
> +	struct kvm *kvm;
> +	uint64_t msg_addr_base;
> +	uint64_t msg_addr_size;
> +};
> +
> +struct dmsintc_state {
> +	atomic64_t  vector_map[4];
> +};
> +
> +int kvm_loongarch_register_dmsintc_device(void);
> +#endif
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index e4fe5b8e8149..5e9e2af7312f 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -22,6 +22,7 @@
>   #include <asm/kvm_ipi.h>
>   #include <asm/kvm_eiointc.h>
>   #include <asm/kvm_pch_pic.h>
> +#include <asm/kvm_dmsintc.h>
>   #include <asm/loongarch.h>
>   
>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -134,6 +135,7 @@ struct kvm_arch {
>   	struct loongarch_ipi *ipi;
>   	struct loongarch_eiointc *eiointc;
>   	struct loongarch_pch_pic *pch_pic;
> +	struct loongarch_dmsintc *dmsintc;
>   };
>   
>   #define CSR_MAX_NUMS		0x800
> @@ -244,6 +246,7 @@ struct kvm_vcpu_arch {
>   	struct kvm_mp_state mp_state;
>   	/* ipi state */
>   	struct ipi_state ipi_state;
> +	struct dmsintc_state dmsintc_state;
>   	/* cpucfg */
>   	u32 cpucfg[KVM_MAX_CPUCFG_REGS];
>   
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index de6c3f18e40a..0a370d018b08 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -154,4 +154,8 @@ struct kvm_iocsr_entry {
>   #define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL	        0x40000006
>   #define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT	        0
>   
> +#define KVM_DEV_LOONGARCH_DMSINTC_CTRL			0x40000007
> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE		0x0
> +#define KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE		0x1
> +
>   #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index cb41d9265662..6e184e24443c 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -19,6 +19,7 @@ kvm-y += vm.o
>   kvm-y += intc/ipi.o
>   kvm-y += intc/eiointc.o
>   kvm-y += intc/pch_pic.o
> +kvm-y += intc/dmsintc.o
>   kvm-y += irqfd.o
>   
>   CFLAGS_exit.o	+= $(call cc-disable-warning, override-init)
> diff --git a/arch/loongarch/kvm/intc/dmsintc.c b/arch/loongarch/kvm/intc/dmsintc.c
> new file mode 100644
> index 000000000000..3fdea81a08c8
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/dmsintc.c
> @@ -0,0 +1,110 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2025 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_dmsintc.h>
> +#include <asm/kvm_vcpu.h>
> +
> +static int kvm_dmsintc_ctrl_access(struct kvm_device *dev,
> +				struct kvm_device_attr *attr,
> +				bool is_write)
> +{
> +	int addr = attr->attr;
> +	void __user *data;
> +	struct loongarch_dmsintc *s = dev->kvm->arch.dmsintc;
> +	u64 tmp;
> +
> +	data = (void __user *)attr->addr;
> +	switch (addr) {
> +	case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_BASE:
> +		if (is_write) {
> +			if (copy_from_user(&tmp, data, sizeof(s->msg_addr_base)))
> +				return -EFAULT;
> +			if (s->msg_addr_base) {
> +				/* Duplicate setting are not allowed. */
> +				return -EFAULT;
> +			}
> +			if ((tmp & (BIT(AVEC_CPU_SHIFT) - 1)) == 0)
> +				s->msg_addr_base = tmp;
> +			else
> +				return  -EFAULT;
> +		}
> +		break;
> +	case KVM_DEV_LOONGARCH_DMSINTC_MSG_ADDR_SIZE:
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
> +		kvm_err("%s: unknown dmsintc register, addr = %d\n", __func__, addr);
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int kvm_dmsintc_set_attr(struct kvm_device *dev,
> +			struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_LOONGARCH_DMSINTC_CTRL:
> +		return kvm_dmsintc_ctrl_access(dev, attr, true);
> +	default:
> +		kvm_err("%s: unknown group (%d)\n", __func__, attr->group);
> +		return -EINVAL;
> +	}
> +}
> +
> +static int kvm_dmsintc_create(struct kvm_device *dev, u32 type)
> +{
> +	struct kvm *kvm;
> +	struct loongarch_dmsintc *s;
> +
> +	if (!dev) {
> +		kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	kvm = dev->kvm;
> +	if (kvm->arch.dmsintc) {
> +		kvm_err("%s: LoongArch DMSINTC has already been created!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	s = kzalloc(sizeof(struct loongarch_dmsintc), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	s->kvm = kvm;
> +	kvm->arch.dmsintc = s;
> +	return 0;
> +}
> +
> +static void kvm_dmsintc_destroy(struct kvm_device *dev)
> +{
> +
> +	if (!dev || !dev->kvm || !dev->kvm->arch.dmsintc)
> +		return;
> +
> +	kfree(dev->kvm->arch.dmsintc);
> +}
> +
> +static struct kvm_device_ops kvm_dmsintc_dev_ops = {
> +	.name = "kvm-loongarch-dmsintc",
> +	.create = kvm_dmsintc_create,
> +	.destroy = kvm_dmsintc_destroy,
> +	.set_attr = kvm_dmsintc_set_attr,
> +};
> +
> +int kvm_loongarch_register_dmsintc_device(void)
> +{
> +	return kvm_register_device_ops(&kvm_dmsintc_dev_ops, KVM_DEV_TYPE_LOONGARCH_DMSINTC);
> +}
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 80ea63d465b8..2e26d4fd9000 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -408,6 +408,11 @@ static int kvm_loongarch_env_init(void)
>   
>   	/* Register LoongArch PCH-PIC interrupt controller interface. */
>   	ret = kvm_loongarch_register_pch_pic_device();
> +	if (ret)
> +		return ret;
> +
> +	/* Register LoongArch DMSINTC interrupt contrroller interface */
> +	ret = kvm_loongarch_register_dmsintc_device();
I think it will be better if cpu_has_msgint() is added, in theory 
dmsintc cannot be added on 3C5000 host machine, and KVM cannot prevent 
VMM executing FUZZ ioctl commands.

Regards
Bibo Mao
>   
>   	return ret;
>   }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..7c56e7e36265 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1209,6 +1209,8 @@ enum kvm_device_type {
>   #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
>   	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
>   #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
> +	KVM_DEV_TYPE_LOONGARCH_DMSINTC,
> +#define KVM_DEV_TYPE_LOONGARCH_DMSINTC   KVM_DEV_TYPE_LOONGARCH_DMSINTC
>   
>   	KVM_DEV_TYPE_MAX,
>   
> 


