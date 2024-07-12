Return-Path: <kvm+bounces-21482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4354E92F6D4
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 10:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8644B21923
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729F3143732;
	Fri, 12 Jul 2024 08:21:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B371411E3;
	Fri, 12 Jul 2024 08:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720772484; cv=none; b=eq607lZp48MD/6rKOG9SZHjEtqwgXp8Y2RUXkb4F2Mn/GytKbM/8mdOieeZSOHx9OGsCOfGx9XUcGb71PmvnP52TQ9QDE0VNJDjaAC5/ta/O0vYizeBk9w/6iKgDJ9GdRZFGqaIuSkBDmOnJvIKk2nS/pS0rBu+zvS6ZshVhnmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720772484; c=relaxed/simple;
	bh=BwY0ZsxCEZcN7WG84LYPg6O2hxoZlhgLIraA6ElD1Fw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ZY30pOVEDZVYUqCmH/uieZ1LXO+yEgc+h0xI9i32Pt5uO62H1aNpkmQ4Cj8UWQu0cG5fXa2mG0/tTs28ZZaqAn/WiONRL9ImsJyNQAS4PkaWkfSZA8HMmqBl8Ot1NHJqymWmvhDDxhi/TDZF8palAhiUXRdL4ijkTi6+ChbzD8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxxOl955BmuZsDAA--.1182S3;
	Fri, 12 Jul 2024 16:21:17 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxJMV555BmhZ1FAA--.17179S3;
	Fri, 12 Jul 2024 16:21:15 +0800 (CST)
Subject: Re: [PATCH 05/11] LoongArch: KVM: Add EXTIOI device support
To: Xianglai Li <lixianglai@loongson.cn>, linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, Min Zhou <zhoumin@loongson.cn>,
 Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
 <20240705023854.1005258-6-lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <995820e9-2a51-414a-83d6-9921386dd655@loongson.cn>
Date: Fri, 12 Jul 2024 16:21:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240705023854.1005258-6-lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxJMV555BmhZ1FAA--.17179S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKF4fKw1rKr4xurW5JF43Jwc_yoWftFW3pF
	yDCFZ5Gr45Ww1xWr1qq3Z8ZryDXws3Ww1a9a42qa4fCFnFvry8KrykKr9FqFn8GaykCay0
	qFyfG3Z09F4Dt3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4oGQDUUUU



On 2024/7/5 上午10:38, Xianglai Li wrote:
> Added device model for EXTIOI interrupt controller,
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
>   arch/loongarch/include/asm/kvm_extioi.h |  78 +++++++++++++++++
>   arch/loongarch/include/asm/kvm_host.h   |   2 +
>   arch/loongarch/kvm/Makefile             |   1 +
>   arch/loongarch/kvm/intc/extioi.c        | 111 ++++++++++++++++++++++++
>   arch/loongarch/kvm/main.c               |   6 +-
>   include/uapi/linux/kvm.h                |   2 +
>   6 files changed, 199 insertions(+), 1 deletion(-)
>   create mode 100644 arch/loongarch/include/asm/kvm_extioi.h
>   create mode 100644 arch/loongarch/kvm/intc/extioi.c
> 
> diff --git a/arch/loongarch/include/asm/kvm_extioi.h b/arch/loongarch/include/asm/kvm_extioi.h
> new file mode 100644
> index 000000000000..48a117b2be5d
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_extioi.h
> @@ -0,0 +1,78 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2024 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef LOONGARCH_EXTIOI_H
> +#define LOONGARCH_EXTIOI_H
> +
> +#include <kvm/iodev.h>
> +
> +#define EXTIOI_IRQS			256
> +#define EXTIOI_ROUTE_MAX_VCPUS		256
> +#define EXTIOI_IRQS_U8_NUMS		(EXTIOI_IRQS / 8)
> +#define EXTIOI_IRQS_U32_NUMS		(EXTIOI_IRQS_U8_NUMS / 4)
> +#define EXTIOI_IRQS_U64_NUMS		(EXTIOI_IRQS_U32_NUMS / 2)
> +/* map to ipnum per 32 irqs */
> +#define EXTIOI_IRQS_NODETYPE_COUNT	16
> +
> +#define EXTIOI_BASE			0x1400
> +#define EXTIOI_SIZE			0x900
> +
> +#define LS3A_INTC_IP			8
How about rename LS3A_INTC_IP with something like CPU_IP_NUM?

> +
> +struct loongarch_extioi {
> +	spinlock_t lock;
> +	struct kvm *kvm;
> +	struct kvm_io_device device;
> +	/* hardware state */
> +	union nodetype {
> +		u64 reg_u64[EXTIOI_IRQS_NODETYPE_COUNT / 4];
> +		u32 reg_u32[EXTIOI_IRQS_NODETYPE_COUNT / 2];
> +		uint16_t reg_u16[EXTIOI_IRQS_NODETYPE_COUNT];
> +		u8 reg_u8[EXTIOI_IRQS_NODETYPE_COUNT * 2];
> +	} nodetype;
> +
> +	/* one bit shows the state of one irq */
> +	union bounce {
> +		u64 reg_u64[EXTIOI_IRQS_U64_NUMS];
> +		u32 reg_u32[EXTIOI_IRQS_U32_NUMS];
> +		u8 reg_u8[EXTIOI_IRQS_U8_NUMS];
> +	} bounce;
> +
> +	union isr {
> +		u64 reg_u64[EXTIOI_IRQS_U64_NUMS];
> +		u32 reg_u32[EXTIOI_IRQS_U32_NUMS];
> +		u8 reg_u8[EXTIOI_IRQS_U8_NUMS];
> +	} isr;
> +	union coreisr {
> +		u64 reg_u64[EXTIOI_ROUTE_MAX_VCPUS][EXTIOI_IRQS_U64_NUMS];
> +		u32 reg_u32[EXTIOI_ROUTE_MAX_VCPUS][EXTIOI_IRQS_U32_NUMS];
> +		u8 reg_u8[EXTIOI_ROUTE_MAX_VCPUS][EXTIOI_IRQS_U8_NUMS];
> +	} coreisr;
> +	union enable {
> +		u64 reg_u64[EXTIOI_IRQS_U64_NUMS];
> +		u32 reg_u32[EXTIOI_IRQS_U32_NUMS];
> +		u8 reg_u8[EXTIOI_IRQS_U8_NUMS];
> +	} enable;
> +
> +	/* use one byte to config ipmap for 32 irqs at once */
> +	union ipmap {
> +		u64 reg_u64;
> +		u32 reg_u32[EXTIOI_IRQS_U32_NUMS / 4];
> +		u8 reg_u8[EXTIOI_IRQS_U8_NUMS / 4];
> +	} ipmap;
> +	/* use one byte to config coremap for one irq */
> +	union coremap {
> +		u64 reg_u64[EXTIOI_IRQS / 8];
> +		u32 reg_u32[EXTIOI_IRQS / 4];
> +		u8 reg_u8[EXTIOI_IRQS];
> +	} coremap;
> +
> +	DECLARE_BITMAP(sw_coreisr[EXTIOI_ROUTE_MAX_VCPUS][LS3A_INTC_IP], EXTIOI_IRQS);
> +	uint8_t  sw_coremap[EXTIOI_IRQS];
> +};
> +
> +void extioi_set_irq(struct loongarch_extioi *s, int irq, int level);
> +int kvm_loongarch_register_extioi_device(void);
> +#endif /* LOONGARCH_EXTIOI_H */
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index b28487975336..0e4e46e06420 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -20,6 +20,7 @@
>   #include <asm/kvm_mmu.h>
>   #include <asm/loongarch.h>
>   #include <asm/kvm_ipi.h>
> +#include <asm/kvm_extioi.h>
>   
>   /* Loongarch KVM register ids */
>   #define KVM_GET_IOC_CSR_IDX(id)		((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
> @@ -111,6 +112,7 @@ struct kvm_arch {
>   	s64 time_offset;
>   	struct kvm_context __percpu *vmcs;
>   	struct loongarch_ipi *ipi;
> +	struct loongarch_extioi *extioi;
>   };
>   
>   #define CSR_MAX_NUMS		0x800
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index 36c3009fe89c..a481952e3855 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -19,5 +19,6 @@ kvm-y += tlb.o
>   kvm-y += vcpu.o
>   kvm-y += vm.o
>   kvm-y += intc/ipi.o
> +kvm-y += intc/extioi.o
>   
>   CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
> diff --git a/arch/loongarch/kvm/intc/extioi.c b/arch/loongarch/kvm/intc/extioi.c
> new file mode 100644
> index 000000000000..2f1b93e95f97
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/extioi.c
> @@ -0,0 +1,111 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2024 Loongson Technology Corporation Limited
> + */
> +
> +#include <asm/kvm_extioi.h>
> +#include <asm/kvm_vcpu.h>
> +#include <linux/count_zeros.h>
> +
> +static int kvm_loongarch_extioi_write(struct kvm_vcpu *vcpu,
> +				struct kvm_io_device *dev,
> +				gpa_t addr, int len, const void *val)
> +{
> +	return 0;
> +}
> +
> +static int kvm_loongarch_extioi_read(struct kvm_vcpu *vcpu,
> +				struct kvm_io_device *dev,
> +				gpa_t addr, int len, void *val)
> +{
> +	return 0;
> +}
> +
> +static const struct kvm_io_device_ops kvm_loongarch_extioi_ops = {
> +	.read	= kvm_loongarch_extioi_read,
> +	.write	= kvm_loongarch_extioi_write,
> +};
> +
> +static int kvm_loongarch_extioi_get_attr(struct kvm_device *dev,
> +				struct kvm_device_attr *attr)
> +{
> +	return 0;
> +}
> +
> +static int kvm_loongarch_extioi_set_attr(struct kvm_device *dev,
> +				struct kvm_device_attr *attr)
> +{
> +	return 0;
> +}
> +
> +static void kvm_loongarch_extioi_destroy(struct kvm_device *dev)
> +{
> +	struct kvm *kvm;
> +	struct loongarch_extioi *extioi;
> +	struct kvm_io_device *device;
> +
> +	if (!dev)
> +		return;
> +
> +	kvm = dev->kvm;
> +	if (!kvm)
> +		return;
> +
> +	extioi = kvm->arch.extioi;
> +	if (!extioi)
> +		return;
How about the sentence like this?
	if (!dev || !dev->kvm || !dev->kvm->arch.extioi)
		return;
> +
> +	device = &extioi->device;
> +	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, device);
> +	kfree(extioi);
> +}
> +
> +static int kvm_loongarch_extioi_create(struct kvm_device *dev, u32 type)
> +{
> +	int ret;
> +	struct loongarch_extioi *s;
> +	struct kvm_io_device *device;
> +	struct kvm *kvm = dev->kvm;
> +
> +	/* extioi has been created */
> +	if (kvm->arch.extioi)
> +		return -EINVAL;
> +
> +	s = kzalloc(sizeof(struct loongarch_extioi), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +	spin_lock_init(&s->lock);
> +	s->kvm = kvm;
> +
> +	/*
> +	 * Initialize IOCSR device
> +	 */
> +	device = &s->device;
> +	kvm_iodevice_init(device, &kvm_loongarch_extioi_ops);
> +	mutex_lock(&kvm->slots_lock);
> +	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS, EXTIOI_BASE, EXTIOI_SIZE, device);
> +	mutex_unlock(&kvm->slots_lock);
> +	if (ret < 0) {
> +		kfree(s);
> +		return -EFAULT;
Return value ret rather than -EFAULT?

> +	}
> +
> +	kvm->arch.extioi = s;
> +
Empty line can be removed
> +	kvm_info("create extioi device successfully\n");
kvm_info() need be removed.
> +	return 0;
> +}
> +
> +static struct kvm_device_ops kvm_loongarch_extioi_dev_ops = {
> +	.name = "kvm-loongarch-extioi",
> +	.create = kvm_loongarch_extioi_create,
> +	.destroy = kvm_loongarch_extioi_destroy,
> +	.set_attr = kvm_loongarch_extioi_set_attr,
> +	.get_attr = kvm_loongarch_extioi_get_attr,
For simplity, it can be it kvm_extioi_xxx if you like.

> +};
> +
> +int kvm_loongarch_register_extioi_device(void)
> +{
> +	return kvm_register_device_ops(&kvm_loongarch_extioi_dev_ops,
> +					KVM_DEV_TYPE_LA_EXTIOI);
> +}
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 36efc7b38f83..b5da4341006a 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -9,6 +9,7 @@
>   #include <asm/cacheflush.h>
>   #include <asm/cpufeature.h>
>   #include <asm/kvm_csr.h>
> +#include <asm/kvm_extioi.h>
>   #include "trace.h"
>   
>   unsigned long vpid_mask;
> @@ -372,7 +373,10 @@ static int kvm_loongarch_env_init(void)
>   	if (ret)
>   		return ret;
>   
> -	return 0;
> +	/* Register loongarch extioi interrupt controller interface. */
> +	ret = kvm_loongarch_register_extioi_device();
> +
empty line can be removed here.

Regards
Bibo Mao
> +	return ret;
>   }
>   
>   static void kvm_loongarch_env_exit(void)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 341fc9d5f3ec..607895ea450f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1144,6 +1144,8 @@ enum kvm_device_type {
>   #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
>   	KVM_DEV_TYPE_LA_IPI,
>   #define KVM_DEV_TYPE_LA_IPI		KVM_DEV_TYPE_LA_IPI
> +	KVM_DEV_TYPE_LA_EXTIOI,
> +#define KVM_DEV_TYPE_LA_EXTIOI		KVM_DEV_TYPE_LA_EXTIOI
>   
>   	KVM_DEV_TYPE_MAX,
>   
> 


