Return-Path: <kvm+bounces-21624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4628C930DE4
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA149281510
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D501836CD;
	Mon, 15 Jul 2024 06:21:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25701E89C;
	Mon, 15 Jul 2024 06:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721024508; cv=none; b=gjEG2+AdPsGpHW7OdCq6gcuyUnPpkZOtddEPnQfcs4PGdegIx/Eh/xSUQqDMBO0MYk/qVUN0zhyYYvcN/ZwTHLZ+3HLYp5rhAJXLeosKLen3zDGE3OcKrXv+d27TLyjqXKzRSvfVdMX9GoRSHonGOfvH+s0aJbxz3YZrWlDNrqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721024508; c=relaxed/simple;
	bh=GUCN0HnevjduCOtHf4PXly+F9rjU0JV2kimt48vjMto=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lMgQntHIOVSIMtPGABzF8f5Prxibn/dcNUAn0qCmEJjfmP2BAK5OGxpSDaBQ2lz3OrRP5563LtmxaQHQCoart2/GuV5Uop26OWu1HoV8vItC+jAHAgl1X6kwlrwO34CzG7sNG0igq6+tKTTy+cDykxBJFJgQvv50ZszOUWBM/t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Dxdur2v5RmZoEEAA--.2892S3;
	Mon, 15 Jul 2024 14:21:42 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx08Tzv5Rma2JJAA--.24215S3;
	Mon, 15 Jul 2024 14:21:41 +0800 (CST)
Subject: Re: [PATCH 10/11] LoongArch: KVM: Add PCHPIC user mode read and write
 functions
To: Xianglai Li <lixianglai@loongson.cn>, linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, Min Zhou <zhoumin@loongson.cn>,
 Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
 <20240705023854.1005258-11-lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <25ff4e20-158d-d09b-14a4-7cbbabadf7c9@loongson.cn>
Date: Mon, 15 Jul 2024 14:21:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240705023854.1005258-11-lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Bx08Tzv5Rma2JJAA--.24215S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Wr4fJF47CFyrWFyDGw4DGFX_yoW7ZrWkpF
	WUAa93Ar4kGryxurn7X3WDu34xXws7uw1S9asxXayFkr4qvr95JF1ktrsFvFy5t3ykJF1I
	qanYkF1Y9a1qy3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8I3
	8UUUUUU==



On 2024/7/5 上午10:38, Xianglai Li wrote:
> Implements the communication interface between the user mode
> program and the kernel in PCHPIC interrupt control simulation,
> which is used to obtain or send the simulation data of the
> interrupt controller in the user mode process, and is used
> in VM migration or VM saving and restoration.
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
>   arch/loongarch/include/uapi/asm/kvm.h |   4 +
>   arch/loongarch/kvm/intc/pch_pic.c     | 128 +++++++++++++++++++++++++-
>   2 files changed, 130 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index 6d5ad95fcb75..ba7f473bc8b6 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -113,4 +113,8 @@ struct kvm_iocsr_entry {
>   
>   #define KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS	1
>   
> +#define KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL	0
> +#define KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT	0
> +#define KVM_DEV_LOONGARCH_PCH_PIC_GRP_REGS	1
> +
>   #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
> diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
> index 4ad85277fced..abb7bab84f2d 100644
> --- a/arch/loongarch/kvm/intc/pch_pic.c
> +++ b/arch/loongarch/kvm/intc/pch_pic.c
> @@ -313,16 +313,140 @@ static const struct kvm_io_device_ops kvm_loongarch_pch_pic_ops = {
>   	.write	= kvm_loongarch_pch_pic_write,
>   };
>   
> +static int kvm_loongarch_pch_pic_init(struct kvm_device *dev, u64 addr)
> +{
> +	int ret;
> +	struct loongarch_pch_pic *s = dev->kvm->arch.pch_pic;
> +	struct kvm_io_device *device;
> +	struct kvm *kvm = dev->kvm;
> +
> +	s->pch_pic_base = addr;
> +	device = &s->device;
> +	/* init device by pch pic writing and reading ops */
> +	kvm_iodevice_init(device, &kvm_loongarch_pch_pic_ops);
> +	mutex_lock(&kvm->slots_lock);
> +	/* register pch pic device */
> +	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, addr, PCH_PIC_SIZE, device);
> +	mutex_unlock(&kvm->slots_lock);
> +	if (ret < 0)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/* used by user space to get or set pch pic registers */
> +static int kvm_loongarch_pch_pic_regs_access(struct kvm_device *dev,
> +					struct kvm_device_attr *attr,
> +					bool is_write)
> +{
> +	int addr, len = 8, ret = 0;
> +	void __user *data;
> +	void *p = NULL;
> +	struct loongarch_pch_pic *s;
> +
> +	s = dev->kvm->arch.pch_pic;
> +	addr = attr->attr;
> +	data = (void __user *)attr->addr;
> +
> +	spin_lock(&s->lock);
> +	/* get pointer to pch pic register by addr */
> +	switch (addr) {
> +	case PCH_PIC_MASK_START:
> +		p = &s->mask;
> +		break;
> +	case PCH_PIC_HTMSI_EN_START:
> +		p = &s->htmsi_en;
> +		break;
> +	case PCH_PIC_EDGE_START:
> +		p = &s->edge;
> +		break;
> +	case PCH_PIC_AUTO_CTRL0_START:
> +		p = &s->auto_ctrl0;
> +		break;
> +	case PCH_PIC_AUTO_CTRL1_START:
> +		p = &s->auto_ctrl1;
> +		break;
> +	case PCH_PIC_ROUTE_ENTRY_START:
> +		p = s->route_entry;
> +		len = 64;
Can we use macro rather than hard-coded 64 here?

> +		break;
> +	case PCH_PIC_HTMSI_VEC_START:
> +		p = s->htmsi_vector;
> +		len = 64;
Ditto

> +		break;
> +	case PCH_PIC_INT_IRR_START:
> +		p = &s->irr;
> +		break;
> +	case PCH_PIC_INT_ISR_START:
> +		p = &s->isr;
> +		break;
> +	case PCH_PIC_POLARITY_START:
> +		p = &s->polarity;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
Do we need check default path and return directly here?

> +	/* write or read value according to is_write */
> +	if (is_write) {
> +		if (copy_from_user(p, data, len))
> +			ret = -EFAULT;
> +	} else {
> +		if (copy_to_user(data, p, len))
> +			ret = -EFAULT;
> +	}
> +
> +	spin_unlock(&s->lock);
Please put spin_unlock() ahead of copy_from_user/copy_to_user

Regards
Bibo Mao
> +	return ret;
> +}
> +
>   static int kvm_loongarch_pch_pic_get_attr(struct kvm_device *dev,
>   				struct kvm_device_attr *attr)
>   {
> -	return 0;
> +	/* only support pch pic group registers */
> +	if (attr->group == KVM_DEV_LOONGARCH_PCH_PIC_GRP_REGS)
> +		return kvm_loongarch_pch_pic_regs_access(dev, attr, false);
> +
> +	return -EINVAL;
>   }
>   
>   static int kvm_loongarch_pch_pic_set_attr(struct kvm_device *dev,
>   				struct kvm_device_attr *attr)
>   {
> -	return 0;
> +	int ret = -EINVAL;
> +	u64 addr;
> +	void __user *uaddr = (void __user *)(long)attr->addr;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_LOONGARCH_PCH_PIC_GRP_CTRL:
> +		switch (attr->attr) {
> +		case KVM_DEV_LOONGARCH_PCH_PIC_CTRL_INIT:
> +			if (copy_from_user(&addr, uaddr, sizeof(addr)))
> +				return -EFAULT;
> +
> +			if (!dev->kvm->arch.pch_pic) {
> +				kvm_err("%s: please create pch_pic irqchip first!\n", __func__);
> +				ret = -EFAULT;
> +				break;
> +			}
> +
> +			ret = kvm_loongarch_pch_pic_init(dev, addr);
> +			break;
> +		default:
> +			kvm_err("%s: unknown group (%d) attr (%lld)\n", __func__, attr->group,
> +					attr->attr);
> +			ret = -EINVAL;
> +			break;
> +		}
> +		break;
> +	case KVM_DEV_LOONGARCH_PCH_PIC_GRP_REGS:
> +		ret = kvm_loongarch_pch_pic_regs_access(dev, attr, true);
> +		break;
> +	default:
> +			break;
> +	}
> +
> +	return ret;
>   }
>   
>   static void kvm_loongarch_pch_pic_destroy(struct kvm_device *dev)
> 


