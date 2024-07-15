Return-Path: <kvm+bounces-21611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B189930D1B
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B30EB1F213C2
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 04:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423E8183099;
	Mon, 15 Jul 2024 04:01:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C371A2D;
	Mon, 15 Jul 2024 04:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721016064; cv=none; b=FGgAeT9jtojMdaCcDHQZM7JcjtRUzB2UdKZrdy+q+eFcKHIHTI4ES3j9SZMUIDDFAW1BC5zq/FPcoM9LIe0BBi7jSIpd9Tnh5VCl6PzH3PMhv84FF6uM8S++GAjF3V7YQncoNHInJkO5NKIfRyikhvJTHTCplnyIUAWfcmiXRuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721016064; c=relaxed/simple;
	bh=Y36iKDFghyfh/pTNpcEkPX0rKqj4MzQJFHwvYvmnBaQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=L0IxPf0XEN88ClXNdHJAsGgv479TJczwkttvto1eooSKC2dsKy6i6GbIB7/wnZ0Ntv240sPTxLLMdjpT8CQgA0HfeORqm+2APXl7oR2SFwl8dHrlYS8kFQN/Iv9j1R0CaI+0Kc3c7BOY5hXMWUptFrY1dnq1/LdB0shT9EIJBvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxDOv7npRmNXgEAA--.11868S3;
	Mon, 15 Jul 2024 12:00:59 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxnsf3npRmAEVJAA--.34933S3;
	Mon, 15 Jul 2024 12:00:57 +0800 (CST)
Subject: Re: [PATCH 07/11] LoongArch: KVM: Add EXTIOI user mode read and write
 functions
To: Xianglai Li <lixianglai@loongson.cn>, linux-kernel@vger.kernel.org
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, Min Zhou <zhoumin@loongson.cn>,
 Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
 <20240705023854.1005258-8-lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <51594e6c-6ab0-4476-3623-1fa2fd3db654@loongson.cn>
Date: Mon, 15 Jul 2024 12:00:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240705023854.1005258-8-lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Bxnsf3npRmAEVJAA--.34933S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Wr4fJF4fJw4fArWrCFyfuFX_yoW7Ww4UpF
	WUCa4fCr48Gr17GryDta4Dury7Jrsagr12vFyaqa4fCr1q9ryrGrykKr9FvFyYk34kG3Wv
	qFn3t3WY9F4qyrXCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzZ2-
	UUUUU



On 2024/7/5 上午10:38, Xianglai Li wrote:
> Implements the communication interface between the user mode
> program and the kernel in EXTIOI interrupt control simulation,
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
>   arch/loongarch/include/uapi/asm/kvm.h |   2 +
>   arch/loongarch/kvm/intc/extioi.c      | 103 +++++++++++++++++++++++++-
>   2 files changed, 103 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index ec39a3cd4f22..9cdcb5e2a731 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -110,4 +110,6 @@ struct kvm_iocsr_entry {
>   
>   #define KVM_DEV_LOONGARCH_IPI_GRP_REGS		1
>   
> +#define KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS	1
> +
>   #endif /* __UAPI_ASM_LOONGARCH_KVM_H */
> diff --git a/arch/loongarch/kvm/intc/extioi.c b/arch/loongarch/kvm/intc/extioi.c
> index dd18b7a7599a..48141823aaa3 100644
> --- a/arch/loongarch/kvm/intc/extioi.c
> +++ b/arch/loongarch/kvm/intc/extioi.c
> @@ -47,6 +47,26 @@ static void extioi_update_irq(struct loongarch_extioi *s, int irq, int level)
>   	kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
>   }
>   
> +static void extioi_set_sw_coreisr(struct loongarch_extioi *s)
> +{
> +	int ipnum, cpu, irq_index, irq_mask, irq;
> +
> +	for (irq = 0; irq < EXTIOI_IRQS; irq++) {
> +		ipnum = s->ipmap.reg_u8[irq / 32];
> +		ipnum = count_trailing_zeros(ipnum);
> +		ipnum = (ipnum >= 0 && ipnum < 4) ? ipnum : 0;
> +		irq_index = irq / 32;
> +		/* length of accessing core isr is 4 bytes */
> +		irq_mask = 1 << (irq & 0x1f);
> +
> +		cpu = s->coremap.reg_u8[irq];
> +		if (!!(s->coreisr.reg_u32[cpu][irq_index] & irq_mask))
> +			set_bit(irq, s->sw_coreisr[cpu][ipnum]);
> +		else
> +			clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
> +	}
> +}
> +
>   void extioi_set_irq(struct loongarch_extioi *s, int irq, int level)
>   {
>   	unsigned long *isr = (unsigned long *)s->isr.reg_u8;
> @@ -599,16 +619,95 @@ static const struct kvm_io_device_ops kvm_loongarch_extioi_ops = {
>   	.write	= kvm_loongarch_extioi_write,
>   };
>   
> +static int kvm_loongarch_extioi_regs_access(struct kvm_device *dev,
> +					struct kvm_device_attr *attr,
> +					bool is_write)
> +{
> +	int len, addr;
> +	void __user *data;
> +	void *p = NULL;
> +	struct loongarch_extioi *s;
> +	unsigned long flags;
> +
> +	s = dev->kvm->arch.extioi;
> +	addr = attr->attr;
> +	data = (void __user *)attr->addr;
> +
> +	loongarch_ext_irq_lock(s, flags);
What does it protect about 
loongarch_ext_irq_lock/loongarch_ext_irq_unlock here?
> +	switch (addr) {
> +	case EXTIOI_NODETYPE_START:
> +		p = s->nodetype.reg_u8;
> +		len = sizeof(s->nodetype);
> +		break;
> +	case EXTIOI_IPMAP_START:
> +		p = s->ipmap.reg_u8;
> +		len = sizeof(s->ipmap);
> +		break;
> +	case EXTIOI_ENABLE_START:
> +		p = s->enable.reg_u8;
> +		len = sizeof(s->enable);
> +		break;
> +	case EXTIOI_BOUNCE_START:
> +		p = s->bounce.reg_u8;
> +		len = sizeof(s->bounce);
> +		break;
> +	case EXTIOI_ISR_START:
> +		p = s->isr.reg_u8;
> +		len = sizeof(s->isr);
> +		break;
> +	case EXTIOI_COREISR_START:
> +		p = s->coreisr.reg_u8;
> +		len = sizeof(s->coreisr); > +		break;
> +	case EXTIOI_COREMAP_START:
> +		p = s->coremap.reg_u8;
> +		len = sizeof(s->coremap);
> +		break;
> +	case EXTIOI_SW_COREMAP_FLAG:
> +		p = s->sw_coremap;
> +		len = sizeof(s->sw_coremap);
> +		break;
Do we need save/restore SW_COREMAP ? It should be parsed from 
EXTIOI_COREMAP like sw_coreisr.

Regards
Bibo Mao
> +	default:
> +		loongarch_ext_irq_unlock(s, flags);
> +		kvm_err("%s: unknown extioi register, addr = %d\n", __func__, addr);
> +		return -EINVAL;
> +	}
> +
> +	loongarch_ext_irq_unlock(s, flags);
> +
> +	if (is_write) {
> +		if (copy_from_user(p, data, len))
> +			return -EFAULT;
> +	} else {
> +		if (copy_to_user(data, p, len))
> +			return -EFAULT;
> +	}
> +
> +	if ((addr == EXTIOI_COREISR_START) && is_write) {
> +		loongarch_ext_irq_lock(s, flags);
> +		extioi_set_sw_coreisr(s);
> +		loongarch_ext_irq_unlock(s, flags);
> +	}
> +
> +	return 0;
> +}
> +
>   static int kvm_loongarch_extioi_get_attr(struct kvm_device *dev,
>   				struct kvm_device_attr *attr)
>   {
> -	return 0;
> +	if (attr->group == KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS)
> +		return kvm_loongarch_extioi_regs_access(dev, attr, false);
> +
> +	return -EINVAL;
>   }
>   
>   static int kvm_loongarch_extioi_set_attr(struct kvm_device *dev,
>   				struct kvm_device_attr *attr)
>   {
> -	return 0;
> +	if (attr->group == KVM_DEV_LOONGARCH_EXTIOI_GRP_REGS)
> +		return kvm_loongarch_extioi_regs_access(dev, attr, true);
> +
> +	return -EINVAL;
>   }
>   
>   static void kvm_loongarch_extioi_destroy(struct kvm_device *dev)
> 


