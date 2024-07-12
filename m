Return-Path: <kvm+bounces-21474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7231492F617
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95B311C221EB
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 07:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D625B13DDC3;
	Fri, 12 Jul 2024 07:22:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B29F32C8B;
	Fri, 12 Jul 2024 07:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720768920; cv=none; b=CYfZYMGtAYNUpvshdKxO4ufaNh+Gstcii1O73nVeBPoP7Vgo/VrV18coqwjwuYq6LbTdn/NAgVc3aWKQSAnwMGn0iZKysJLuVyH/imMr2kspjJpM71rVlHCO7W4q2U4gQlKgzoG/IgmZ5p8qcZlwKHirafbeo3c1UGvO+2YxnxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720768920; c=relaxed/simple;
	bh=cGV8YB/Dhw2RHz4MJOPO8jG1r1ZdV6t6wiyIq5RBftA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=D9C08CHNAERfmPzGOOwG4uf3MsgJq9A0hx8qViNMPfxBhqDqU33YRl0W48Thv1Cgo4rfY0PdvNzC1DyWQ/5Lak0nsqru19xeGItBjqXZ3+PA+MBVTQvu+U3QFD/xCYPRIgq/q033uUXDQsh+AZ1Z3kFf28bseZwWToGq/lsvDr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cxo+mS2ZBmXJcDAA--.1161S3;
	Fri, 12 Jul 2024 15:21:54 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxmsaO2ZBmeopFAA--.27914S3;
	Fri, 12 Jul 2024 15:21:52 +0800 (CST)
Subject: Re: [PATCH 02/11] LoongArch: KVM: Add IPI device support
To: Xianglai Li <lixianglai@loongson.cn>, linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, Min Zhou <zhoumin@loongson.cn>,
 Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
 <20240705023854.1005258-3-lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <b1f597c5-1c10-57ec-9216-12e8dd5ff252@loongson.cn>
Date: Fri, 12 Jul 2024 15:21:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240705023854.1005258-3-lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxmsaO2ZBmeopFAA--.27914S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Cw18CF17ur1xWw47Gr1xWFX_yoWDXF43pF
	ZruFs5GrWrWr1xWryDX3Z8Zryqgw40gw1S9a43WFWFkr4jqr95tFyvkrWDAas8J3ykGa40
	q3WfG3WYvF4jv3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zw
	Z7UUUUU==


Hi xianglai,

On 2024/7/5 上午10:38, Xianglai Li wrote:
> Added device model for IPI interrupt controller,
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
>   arch/loongarch/include/asm/kvm_host.h |   4 +
>   arch/loongarch/include/asm/kvm_ipi.h  |  36 ++++++
>   arch/loongarch/kvm/Makefile           |   1 +
>   arch/loongarch/kvm/intc/ipi.c         | 155 ++++++++++++++++++++++++++
>   arch/loongarch/kvm/main.c             |   7 +-
>   arch/loongarch/kvm/vcpu.c             |   3 +
>   include/uapi/linux/kvm.h              |   4 +
>   7 files changed, 209 insertions(+), 1 deletion(-)
>   create mode 100644 arch/loongarch/include/asm/kvm_ipi.h
>   create mode 100644 arch/loongarch/kvm/intc/ipi.c
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index c87b6ea0ec47..4f6ccc688c1b 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -19,6 +19,7 @@
>   #include <asm/inst.h>
>   #include <asm/kvm_mmu.h>
>   #include <asm/loongarch.h>
> +#include <asm/kvm_ipi.h>
>   
>   /* Loongarch KVM register ids */
>   #define KVM_GET_IOC_CSR_IDX(id)		((id & KVM_CSR_IDX_MASK) >> LOONGARCH_REG_SHIFT)
> @@ -107,6 +108,7 @@ struct kvm_arch {
>   
>   	s64 time_offset;
>   	struct kvm_context __percpu *vmcs;
> +	struct loongarch_ipi *ipi;
>   };
>   
>   #define CSR_MAX_NUMS		0x800
> @@ -199,6 +201,8 @@ struct kvm_vcpu_arch {
>   	int last_sched_cpu;
>   	/* mp state */
>   	struct kvm_mp_state mp_state;
> +	/* ipi state */
> +	struct ipi_state ipi_state;
>   	/* cpucfg */
>   	u32 cpucfg[KVM_MAX_CPUCFG_REGS];
>   };
> diff --git a/arch/loongarch/include/asm/kvm_ipi.h b/arch/loongarch/include/asm/kvm_ipi.h
> new file mode 100644
> index 000000000000..875a93008802
> --- /dev/null
> +++ b/arch/loongarch/include/asm/kvm_ipi.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2024 Loongson Technology Corporation Limited
> + */
> +
> +#ifndef __LS3A_KVM_IPI_H
> +#define __LS3A_KVM_IPI_H
__ASM_KVM_IPI_H rather than __LS3A_KVM_IPI_H, it should be capital 
letter from string "asm/kvm_ipi.h"

> +
> +#include <kvm/iodev.h>
> +
> +#define LARCH_INT_IPI			12
> +
> +struct loongarch_ipi {
> +	spinlock_t lock;
> +	struct kvm *kvm;
> +	struct kvm_io_device device;
> +	struct kvm_io_device mail_dev;
> +};
> +
> +struct ipi_state {
> +	spinlock_t lock;
> +	uint32_t status;
> +	uint32_t en;
> +	uint32_t set;
> +	uint32_t clear;
> +	uint64_t buf[4];
> +};
> +
> +#define SMP_MAILBOX			0x1000
> +#define KVM_IOCSR_IPI_ADDR_SIZE		0x48
> +
> +#define MAIL_SEND_ADDR			(SMP_MAILBOX + IOCSR_MAIL_SEND)
> +#define KVM_IOCSR_MAIL_ADDR_SIZE	0x118
> +
> +int kvm_loongarch_register_ipi_device(void);
> +#endif
> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
> index b2f4cbe01ae8..36c3009fe89c 100644
> --- a/arch/loongarch/kvm/Makefile
> +++ b/arch/loongarch/kvm/Makefile
> @@ -18,5 +18,6 @@ kvm-y += timer.o
>   kvm-y += tlb.o
>   kvm-y += vcpu.o
>   kvm-y += vm.o
> +kvm-y += intc/ipi.o
>   
>   CFLAGS_exit.o	+= $(call cc-option,-Wno-override-init,)
> diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
> new file mode 100644
> index 000000000000..a9dc0aaec502
> --- /dev/null
> +++ b/arch/loongarch/kvm/intc/ipi.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2024 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_ipi.h>
> +#include <asm/kvm_vcpu.h>
> +
> +static int kvm_loongarch_ipi_write(struct kvm_vcpu *vcpu,
> +			struct kvm_io_device *dev,
> +			gpa_t addr, int len, const void *val)
> +{
> +	return 0;
> +}
> +
> +static int kvm_loongarch_ipi_read(struct kvm_vcpu *vcpu,
> +			struct kvm_io_device *dev,
> +			gpa_t addr, int len, void *val)
> +{
> +	return 0;
> +}
> +
> +static int kvm_loongarch_mail_write(struct kvm_vcpu *vcpu,
> +			struct kvm_io_device *dev,
> +			gpa_t addr, int len, const void *val)
> +{
> +	return 0;
> +}
> +
> +static const struct kvm_io_device_ops kvm_loongarch_ipi_ops = {
> +	.read	= kvm_loongarch_ipi_read,
> +	.write	= kvm_loongarch_ipi_write,
> +};
> +
> +static const struct kvm_io_device_ops kvm_loongarch_mail_ops = {
> +	.write	= kvm_loongarch_mail_write,
> +};
> +
> +static int kvm_loongarch_ipi_get_attr(struct kvm_device *dev,
> +			struct kvm_device_attr *attr)
> +{
> +	return 0;
> +}
> +
> +static int kvm_loongarch_ipi_set_attr(struct kvm_device *dev,
> +			struct kvm_device_attr *attr)
> +{
> +	return 0;
> +}
> +
> +static void kvm_loongarch_ipi_destroy(struct kvm_device *dev)
> +{
> +	struct kvm *kvm;
> +	struct loongarch_ipi *ipi;
> +	struct kvm_io_device *device;
> +
> +	if (!dev)
> +		return;
> +
> +	kvm = dev->kvm;
> +	if (!kvm)
> +		return;
> +
> +	ipi = kvm->arch.ipi;
> +	if (!ipi)
> +		return;
> +
> +	device = &ipi->device;
> +	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, device);
> +
> +	device = &ipi->mail_dev;
> +	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, device);
Variable device seems be not much useful, how about something like this?
	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &ipi->device);
	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &ipi->mail_dev);
> +
Empty line can be removed.
> +	kfree(ipi);
> +}
> +
> +static int kvm_loongarch_ipi_create(struct kvm_device *dev, u32 type)
> +{
> +	struct kvm *kvm;
> +	struct loongarch_ipi *s;
> +	unsigned long addr;
> +	struct kvm_io_device *device;
> +	int ret;
> +
> +	kvm_info("begin create loongarch ipi in kvm ...\n");
It is a noise for kvm_info(), every time VM is created there will too 
much printing log.
> +	if (!dev) {
> +		kvm_err("%s: kvm_device ptr is invalid!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	kvm = dev->kvm;
> +	if (kvm->arch.ipi) {
> +		kvm_err("%s: loongarch ipi has been created!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	s = kzalloc(sizeof(struct loongarch_ipi), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +	spin_lock_init(&s->lock);
> +	s->kvm = kvm;
> +
> +	/*
> +	 * Initialize IOCSR device
> +	 */
> +	device = &s->device;
> +	kvm_iodevice_init(device, &kvm_loongarch_ipi_ops);
> +	addr = SMP_MAILBOX;
> +	mutex_lock(&kvm->slots_lock);
> +	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS, addr,
> +			KVM_IOCSR_IPI_ADDR_SIZE, device);
> +	mutex_unlock(&kvm->slots_lock);
> +	if (ret < 0) {
> +		kvm_err("%s: initialize IOCSR dev failed, ret = %d\n", __func__, ret);
> +		goto err;
> +	}
> +
> +	device = &s->mail_dev;
> +	kvm_iodevice_init(device, &kvm_loongarch_mail_ops);
> +	addr = MAIL_SEND_ADDR;
> +	mutex_lock(&kvm->slots_lock);
> +	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS, addr,
> +			KVM_IOCSR_MAIL_ADDR_SIZE, device);
> +	mutex_unlock(&kvm->slots_lock);
> +	if (ret < 0) {
> +		device = &s->device;
> +		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, device);
Should it be kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device)?
> +		kvm_err("%s: initialize mail box dev failed, ret = %d\n", __func__, ret);
> +		goto err;
> +	}
> +
> +	kvm->arch.ipi = s;
> +	kvm_info("create loongarch ipi in kvm done!\n");
kvm_info should be removed.
> +
Empty line can be removed.
> +	return 0;
> +
> +err:
> +	kfree(s);
> +	return -EFAULT;
> +}
> +
> +static struct kvm_device_ops kvm_loongarch_ipi_dev_ops = {
> +	.name = "kvm-loongarch-ipi",
> +	.create = kvm_loongarch_ipi_create,
> +	.destroy = kvm_loongarch_ipi_destroy,
> +	.set_attr = kvm_loongarch_ipi_set_attr,
> +	.get_attr = kvm_loongarch_ipi_get_attr,
> +};
> +
> +int kvm_loongarch_register_ipi_device(void)
> +{
> +	return kvm_register_device_ops(&kvm_loongarch_ipi_dev_ops,
> +					KVM_DEV_TYPE_LA_IPI);
> +}
> diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
> index 86a2f2d0cb27..36efc7b38f83 100644
> --- a/arch/loongarch/kvm/main.c
> +++ b/arch/loongarch/kvm/main.c
> @@ -312,7 +312,7 @@ void kvm_arch_hardware_disable(void)
>   
>   static int kvm_loongarch_env_init(void)
>   {
> -	int cpu, order;
> +	int cpu, order, ret;
>   	void *addr;
>   	struct kvm_context *context;
>   
> @@ -367,6 +367,11 @@ static int kvm_loongarch_env_init(void)
>   
>   	kvm_init_gcsr_flag();
>   
> +	/* Register loongarch ipi interrupt controller interface. */
> +	ret = kvm_loongarch_register_ipi_device();
> +	if (ret)
> +		return ret;
> +
how about "return ret;" directly without the if judgement sentence?

Regards
Bibo Mao
>   	return 0;
>   }
>   
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 9e8030d45129..1d369b92a84d 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -1013,6 +1013,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   	/* Init */
>   	vcpu->arch.last_sched_cpu = -1;
>   
> +	/* Init ipi_state lock */
> +	spin_lock_init(&vcpu->arch.ipi_state.lock);
> +
>   	/*
>   	 * Initialize guest register state to valid architectural reset state.
>   	 */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d03842abae57..341fc9d5f3ec 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1142,7 +1142,11 @@ enum kvm_device_type {
>   #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
>   	KVM_DEV_TYPE_RISCV_AIA,
>   #define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
> +	KVM_DEV_TYPE_LA_IPI,
> +#define KVM_DEV_TYPE_LA_IPI		KVM_DEV_TYPE_LA_IPI
> +
>   	KVM_DEV_TYPE_MAX,
> +
>   };
>   
>   struct kvm_vfio_spapr_tce {
> 


