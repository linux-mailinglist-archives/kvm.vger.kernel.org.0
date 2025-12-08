Return-Path: <kvm+bounces-65480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A0685CAC017
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 05:07:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3CED6302B778
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 04:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5CA2FB0BC;
	Mon,  8 Dec 2025 04:07:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BDB4243954;
	Mon,  8 Dec 2025 04:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765166831; cv=none; b=SYYy96zo5/ZISKMHwEfm2K4JYaWNOXE2LvfN6+eOPLsBnJm1YUxQRcrkCbbNGi0W+7asGZnjTzP/PwQVtje0n8rFoh5KLUOiK+bNkWRt2qM4R8Z0wQZPaHlMwLGN8ypbbZWD54g8pytWlYMAysXTb8Twlnr3Gj+QNaqVa/muUwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765166831; c=relaxed/simple;
	bh=Ry+Ls0JFPtJcHfFomJRpM7w2s8zc0IvwkNQzTqqW0wc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fLC6ZBu8smU8vA+yqoHIiTwMjaS7mZL1hus3WCtXbJfAZlwNJlOUJnoHWLAt2Kzj4BmNGQ6pnm3O13PJz4o87oqkiLqfkLf2w0zteet1CVyyQ8m24TsJ+6hCAY+E7eytHyiHZ6r4JJ7tNsvIOKYFB35KErR3Lt3JegCrhtDZyqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxndLiTjZp4SgsAA--.29054S3;
	Mon, 08 Dec 2025 12:06:58 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxVOTgTjZpveZGAQ--.64659S3;
	Mon, 08 Dec 2025 12:06:58 +0800 (CST)
Subject: Re: [PATCH v3 4/4] LongArch: KVM: Add dintc inject msi to the dest
 vcpu
To: Song Gao <gaosong@loongson.cn>, chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev, kernel@xen0n.name,
 linux-kernel@vger.kernel.org, lixianglai@loongson.cn
References: <20251206064658.714100-1-gaosong@loongson.cn>
 <20251206064658.714100-5-gaosong@loongson.cn>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <7e938812-1d02-ec1d-6f3c-dd0db3e74d9a@loongson.cn>
Date: Mon, 8 Dec 2025 12:04:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251206064658.714100-5-gaosong@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxVOTgTjZpveZGAQ--.64659S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxuF4xKw1kWryfAw1DGFyfAFc_yoW5tF47pF
	yDuas5WrWrGr17G343Jan09rs8ZrZ2gr12qFyakFy3Kr1qvrn8XFW8Kr9rAFy5G3y0qF1I
	v3WFk3ZI9a1DtwbCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8l3
	8UUUUUU==



On 2025/12/6 下午2:46, Song Gao wrote:
> Implement irqfd deliver msi to vcpu and
> vcpu dintc inject irq.
> 
> Signed-off-by: Song Gao <gaosong@loongson.cn>
> ---
>   arch/loongarch/include/asm/kvm_host.h |  5 +++
>   arch/loongarch/kvm/interrupt.c        |  1 +
>   arch/loongarch/kvm/vcpu.c             | 55 +++++++++++++++++++++++++++
>   3 files changed, 61 insertions(+)
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 26a90f4146ac..8099dd3f71dd 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -258,6 +258,11 @@ struct kvm_vcpu_arch {
>   	} st;
>   };
>   
> +void loongarch_dintc_inject_irq(struct kvm_vcpu *vcpu);
> +int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
> +				struct kvm_vcpu *vcpu,
> +				u32 vector, int level);
> +
>   static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
>   {
>   	return csr->csrs[reg];
> diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
> index a6d42d399a59..c74e7af3e772 100644
> --- a/arch/loongarch/kvm/interrupt.c
> +++ b/arch/loongarch/kvm/interrupt.c
> @@ -33,6 +33,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int priority)
>   		irq = priority_to_irq[priority];
>   
>   	if (cpu_has_msgint && (priority == INT_AVEC)) {
> +		loongarch_dintc_inject_irq(vcpu);
>   		set_gcsr_estat(irq);
>   		return 1;
>   	}
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 6d833599ef2e..356d288799ac 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -13,6 +13,61 @@
>   #define CREATE_TRACE_POINTS
>   #include "trace.h"
>   
> +void loongarch_dintc_inject_irq(struct kvm_vcpu *vcpu)
> +{
> +	struct dintc_state *ds = &vcpu->arch.dintc_state;
> +	unsigned int i;
> +	unsigned long temp[4], old;
> +
> +	if (!ds)
> +		return;
> +
> +	for (i = 0; i < 4; i++) {
> +		old = atomic64_read(&(ds->vector_map[i]));
> +		if (old)
> +			temp[i] = atomic64_xchg(&(ds->vector_map[i]), 0);
> +	}
> +
> +	if (temp[0]) {
> +		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR0);
> +		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR0, temp[0]|old);
> +	}
should there be one extra space line between two if() sentenses?
> +	if (temp[1]) {
> +		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR1);
> +		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR1, temp[1]|old);
> +	}
ditto
> +	if (temp[2]) {
> +		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR2);
> +		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR2, temp[2]|old);
> +	}
ditto

the other looks good to me.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> +	if (temp[3]) {
> +		old = kvm_read_hw_gcsr(LOONGARCH_CSR_ISR3);
> +		kvm_write_hw_gcsr(LOONGARCH_CSR_ISR3, temp[3]|old);
> +	}
> +}
> +
> +int kvm_loongarch_deliver_msi_to_vcpu(struct kvm *kvm,
> +				struct kvm_vcpu *vcpu,
> +				u32 vector, int level)
> +{
> +	struct kvm_interrupt vcpu_irq;
> +	struct dintc_state *ds;
> +
> +	if (!level)
> +		return 0;
> +	if (!vcpu || vector >= 256)
> +		return -EINVAL;
> +	ds = &vcpu->arch.dintc_state;
> +	if (!ds)
> +		return -ENODEV;
> +	set_bit(vector, (unsigned long *)&ds->vector_map);
> +	vcpu_irq.irq = INT_AVEC;
> +	kvm_vcpu_ioctl_interrupt(vcpu, &vcpu_irq);
> +	kvm_vcpu_kick(vcpu);
> +	return 0;
> +}
> +
> +
>   const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>   	KVM_GENERIC_VCPU_STATS(),
>   	STATS_DESC_COUNTER(VCPU, int_exits),
> 


