Return-Path: <kvm+bounces-21623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3C1D930DCB
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:03:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B8AC1F2166F
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABC7183099;
	Mon, 15 Jul 2024 06:03:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA3F1DFF8;
	Mon, 15 Jul 2024 06:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721023423; cv=none; b=OuYakharhmvh3hO4KuzkQj+YxRGHBTSUl2cLg+y/NWjBjJ0ASoWsfIMiu1gCebs3J+NVsiNLCkArHBjNTSEUaqe+bMqeG1XLGwqcJerd4ZFPMGt3JkBvN0z3DfY5FlNGK94T/7p/PigVJZDxbvPY6FM3up4JVe1VW2F4/G4/SBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721023423; c=relaxed/simple;
	bh=Wn1iaI82ls/VCR/7cJLTGyYxv3u9BCx39jkddzgvlGQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=eLMS/hKKuIbNiwF6KY5RNyMZuGbWxfkO/iqCrAuGNlvDt6YLvDDxftET6GQTdbDAz/u4FK94LuXcxyAQ6Fr/dCrAHvLghQdiQTg+IaKokbvu+C+eTGmODY8P3vsDB8uHXPkULxIJM/3a3ZYQSrWukTaOdudCQbk5bnK64QJKYf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxDOu2u5RmfYAEAA--.11923S3;
	Mon, 15 Jul 2024 14:03:34 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxosSxu5Rmml1JAA--.23921S3;
	Mon, 15 Jul 2024 14:03:31 +0800 (CST)
Subject: Re: [PATCH 08/11] LoongArch: KVM: Add PCHPIC device support
To: Xianglai Li <lixianglai@loongson.cn>, linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, Min Zhou <zhoumin@loongson.cn>,
 Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
 <20240705023854.1005258-9-lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <25fbdb6c-1e68-0cc2-88fd-88ba24e162c5@loongson.cn>
Date: Mon, 15 Jul 2024 14:03:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240705023854.1005258-9-lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxosSxu5Rmml1JAA--.23921S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKF4fGF4kGw43Gr45Xw15ZFc_yoW3CF15pF
	WkAFn5Gr4rWr1xWr1kX3Z8Zr93Xws7Gw1S9a4avryUCrsFvryrXrykGrWDZF1DG3ykGF1I
	qF4fK3WYqa1UtabCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
	6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jepB-UUUUU=



On 2024/7/5 上午10:38, Xianglai Li wrote:
> Added device model for PCHPIC interrupt controller,
> implemented basic create destroy interface,
> and registered device model to kvm device table.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: kvm@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: Min Zhou <zhoumin@loongson.cn>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Xianglai li <lixianglai@loongson.cn>
> 
>   arch/loongarch/include/asm/kvm_host.h    |   2 +
>   arch/loongarch/include/asm/kvm_pch_pic.h |  30 +++++++
>   arch/loongarch/kvm/Makefile              |   1 +
>   arch/loongarch/kvm/intc/pch_pic.c        | 100 +++++++++++++++++++++++
>   arch/loongarch/kvm/main.c                |   6 ++
>   include/uapi/linux/kvm.h                 |   2 +
>   6 files changed, 141 insertions(+)
>   create mode 100644 arch/loongarch/include/asm/kvm_pch_pic.h
>   create mode 100644 arch/loongarch/kvm/intc/pch_pic.c
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 5c2adebd16b2..31891f884cee 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -21,6 +21,7 @@
>   #include <asm/loongarch.h>
>   #include <asm/kvm_ipi.h>
>   #include <asm/kvm_extioi.h>
> +#include <asm/kvm_pch_pic.h>
>   
>   /* Loongarch KVM register ids */
>   #define KVM_GET_IOC_CSR_IDX(id)		((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
> @@ -115,6 +116,7 @@ struct kvm_arch {
>   	struct kvm_context __percpu *vmcs;
>   	struct loongarch_ipi *ipi;
>   	struct loongarch_extioi *extioi;
> +	struct loongarch_pch_pic *pch_pic;
>   };
>   
>   #define CSR_MAX_NUMS		0x800
> diff --git a/arch/loongarch/include/asm/kvm_pch_pic.h b/arch/loongarch/include/asm/kvm_pch_pic.h
> new file mode 100644
> index 000000000000..5aef0e4e3863
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_pch_pic.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2024 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef LOONGARCH_PCH_PIC_H
> +#define LOONGARCH_PCH_PIC_H
> +
> +#include <kvm/iodev.h>
> +
> +struct loongarch_pch_pic {
> +	spinlock_t lock;
> +	struct kvm *kvm;
> +	struct kvm_io_device device;
> +	uint64_t mask; /* 1:disable irq, 0:enable irq */
> +	uint64_t htmsi_en; /* 1:msi */
> +	uint64_t edge; /* 1:edge triggered, 0:level triggered */
> +	uint64_t auto_ctrl0; /* only use default value 00b */
> +	uint64_t auto_ctrl1; /* only use default value 00b */
> +	uint64_t last_intirr; /* edge detection */
> +	uint64_t irr; /* interrupt request register */
> +	uint64_t isr; /* interrupt service register */
> +	uint64_t polarity; /* 0: high level trigger, 1: low level trigger */
> +	uint8_t  route_entry[64]; /* default value 0, route to int0: extioi */
> +	uint8_t  htmsi_vector[64]; /* irq route table for routing to extioi */
> +	uint64_t pch_pic_base;
> +};
> +
> +int kvm_loongarch_register_pch_pic_device(void);
> +#endif /* LOONGARCH_PCH_PIC_H */
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index a481952e3855..165ecb4d408f 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -20,5 +20,6 @@ kvm-y += vcpu.o
>   kvm-y += vm.o
>   kvm-y += intc/ipi.o
>   kvm-y += intc/extioi.o
> +kvm-y += intc/pch_pic.o
>   
>   CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
> diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
> new file mode 100644
> index 000000000000..4097c00e8294
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/pch_pic.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2024 Loongson Technology Corporation Limited
> + */
> +
> +#include <asm/kvm_extioi.h>
> +#include <asm/kvm_pch_pic.h>
> +#include <asm/kvm_vcpu.h>
> +#include <linux/count_zeros.h>
> +
> +static int kvm_loongarch_pch_pic_write(struct kvm_vcpu *vcpu,
> +					struct kvm_io_device *dev,
> +					gpa_t addr, int len, const void *val)
> +{
> +	return 0;
> +}
> +
> +static int kvm_loongarch_pch_pic_read(struct kvm_vcpu *vcpu,
> +					struct kvm_io_device *dev,
> +					gpa_t addr, int len, void *val)
> +{
> +	return 0;
> +}
> +
> +static const struct kvm_io_device_ops kvm_loongarch_pch_pic_ops = {
> +	.read	= kvm_loongarch_pch_pic_read,
> +	.write	= kvm_loongarch_pch_pic_write,
> +};
> +
> +static int kvm_loongarch_pch_pic_get_attr(struct kvm_device *dev,
> +				struct kvm_device_attr *attr)
> +{
> +	return 0;
> +}
> +
> +static int kvm_loongarch_pch_pic_set_attr(struct kvm_device *dev,
> +				struct kvm_device_attr *attr)
> +{
> +	return 0;
> +}
> +
> +static void kvm_loongarch_pch_pic_destroy(struct kvm_device *dev)
> +{
> +	struct kvm *kvm;
> +	struct loongarch_pch_pic *s;
> +	struct kvm_io_device *device;
> +
> +	if (!dev)
> +		return;
> +
> +	kvm = dev->kvm;
> +	if (!kvm)
> +		return;
> +
> +	s = kvm->arch.pch_pic;
> +	if (!s)
> +		return;
How about something like this?
	if (!dev || !dev->kvm || ! dev->kvm->arch.pch_pic)
		return;
> +
> +	device = &s->device;
> +	/* unregister pch pic device and free it's memory */
> +	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, device);
> +	kfree(s);
> +}
> +
> +static int kvm_loongarch_pch_pic_create(struct kvm_device *dev, u32 type)
> +{
> +	struct loongarch_pch_pic *s;
> +	struct kvm *kvm = dev->kvm;
> +
> +	/* pch pic should not has been created */
> +	if (kvm->arch.pch_pic)
> +		return -EINVAL;
> +
> +	s = kzalloc(sizeof(struct loongarch_pch_pic), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&s->lock);
> +	s->kvm = kvm;
> +
> +
The above two blank lines are unnecessary.
> +	kvm->arch.pch_pic = s;
> +
> +	kvm_info("create pch pic device successfully\n");
kvm_info is unnecessary here.

Regards
Bibo Mao
> +	return 0;
> +}
> +
> +static struct kvm_device_ops kvm_loongarch_pch_pic_dev_ops = {
> +	.name = "kvm-loongarch-pch-pic",
> +	.create = kvm_loongarch_pch_pic_create,
> +	.destroy = kvm_loongarch_pch_pic_destroy,
> +	.set_attr = kvm_loongarch_pch_pic_set_attr,
> +	.get_attr = kvm_loongarch_pch_pic_get_attr,
> +};
> +
> +int kvm_loongarch_register_pch_pic_device(void)
> +{
> +	return kvm_register_device_ops(&kvm_loongarch_pch_pic_dev_ops,
> +					KVM_DEV_TYPE_LA_IOAPIC);
> +}
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index b5da4341006a..285bd4126e54 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -10,6 +10,7 @@
>   #include <asm/cpufeature.h>
>   #include <asm/kvm_csr.h>
>   #include <asm/kvm_extioi.h>
> +#include <asm/kvm_pch_pic.h>
>   #include "trace.h"
>   
>   unsigned long vpid_mask;
> @@ -375,6 +376,11 @@ static int kvm_loongarch_env_init(void)
>   
>   	/* Register loongarch extioi interrupt controller interface. */
>   	ret = kvm_loongarch_register_extioi_device();
> +	if (ret)
> +		return ret;
> +
> +	/* Register loongarch pch pic interrupt controller interface. */
> +	ret = kvm_loongarch_register_pch_pic_device();
>   
>   	return ret;
>   }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 607895ea450f..35560522a252 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1142,6 +1142,8 @@ enum kvm_device_type {
>   #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
>   	KVM_DEV_TYPE_RISCV_AIA,
>   #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
> +	KVM_DEV_TYPE_LA_IOAPIC,
> +#define KVM_DEV_TYPE_LA_IOAPIC		KVM_DEV_TYPE_LA_IOAPIC
>   	KVM_DEV_TYPE_LA_IPI,
>   #define KVM_DEV_TYPE_LA_IPI		KVM_DEV_TYPE_LA_IPI
>   	KVM_DEV_TYPE_LA_EXTIOI,
> 


