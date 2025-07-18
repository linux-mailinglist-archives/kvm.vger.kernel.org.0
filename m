Return-Path: <kvm+bounces-52834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB978B099C0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:27:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A11287A1AD0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E01E19E7F7;
	Fri, 18 Jul 2025 02:27:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAF04C9D;
	Fri, 18 Jul 2025 02:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752805651; cv=none; b=UEE8lScVCRQlNwDPkBHCgS4i+rdWxsqJUUe1G/olnoyaEzxIMJ4u0VwnJXe+OlWeztG/X9jQP/3i6JM99fWbIzpHOAjC5vV2djZxHag7/mJT2H4WIyP+jtAZz3me/fSZh/PfgPT2Q40FL+upd0AD494DoDCswxQcvkIN30imBgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752805651; c=relaxed/simple;
	bh=ftURKMxGNqYyR2he5weADE6SNvzMQrh7e4/H/8Bxh0Y=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hqRGyhXg7bJwDfWcK6i0R69CyWWIuznQNHj8Wm1IcL1C2L62Qi6l4W60jTxVIh/8cgUP7Z2mwrQoBznstVT3d8hvPKFKNFB9nACmaTxDtqd4SH5knVUrTAGwxlRFzcSNqu11guFydNof/f79Dl9RNxkuOjd6CV3rEoWBYrKpbtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cx_eIMsXloNJ0sAQ--.51531S3;
	Fri, 18 Jul 2025 10:27:24 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxdOQKsXloJcEbAA--.17119S3;
	Fri, 18 Jul 2025 10:27:24 +0800 (CST)
Subject: Re: [PATCH 1/2] LoongArch: KVM: rework kvm_send_pv_ipi()
To: Yury Norov <yury.norov@gmail.com>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250716165929.22386-1-yury.norov@gmail.com>
 <20250716165929.22386-2-yury.norov@gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <a70dba22-c18e-3b28-6d2e-1eb7a4688a1d@loongson.cn>
Date: Fri, 18 Jul 2025 10:25:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250716165929.22386-2-yury.norov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxdOQKsXloJcEbAA--.17119S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7CFWUZw1UWF4kJr1xKF4UAwc_yoW8Kry8pw
	4fCw4agr45GF13Gwn0qayvqF47XF4kKFn3ZrZ7Ja95Wrn0qFn5Xr40kF95Ja4fKa4rAF4S
	vFy5t3sI9a1DJ3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8xu
	ctUUUUU==



On 2025/7/17 上午12:59, Yury Norov wrote:
> From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
> 
> The function in fact traverses a "bitmap" stored in GPR regs A1 and A2,
> but does it in a non-obvious way by creating a single-word bitmap twice.
> 
> This patch switches the function to create a single 2-word bitmap, and
> also employs for_each_set_bit() macro, as it helps to drop most of
> housekeeping code.
> 
> While there, convert the function to return void to not confuse readers
> with unchecked result.
> 
> Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> ---
>   arch/loongarch/kvm/exit.c | 31 ++++++++++++-------------------
>   1 file changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index fa52251b3bf1..359afa909cee 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -821,32 +821,25 @@ static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu, int ecode)
>   	return RESUME_GUEST;
>   }
>   
> -static int kvm_send_pv_ipi(struct kvm_vcpu *vcpu)
> +static void kvm_send_pv_ipi(struct kvm_vcpu *vcpu)
>   {
> -	unsigned int min, cpu, i;
> -	unsigned long ipi_bitmap;
> +	DECLARE_BITMAP(ipi_bitmap, BITS_PER_LONG * 2) = {
> +		kvm_read_reg(vcpu, LOONGARCH_GPR_A1),
> +		kvm_read_reg(vcpu, LOONGARCH_GPR_A2)
> +	};
> +	unsigned int min, cpu;
>   	struct kvm_vcpu *dest;
>   
>   	min = kvm_read_reg(vcpu, LOONGARCH_GPR_A3);
> -	for (i = 0; i < 2; i++, min += BITS_PER_LONG) {
> -		ipi_bitmap = kvm_read_reg(vcpu, LOONGARCH_GPR_A1 + i);
> -		if (!ipi_bitmap)
> +	for_each_set_bit(cpu, ipi_bitmap, BITS_PER_LONG * 2) {
> +		dest = kvm_get_vcpu_by_cpuid(vcpu->kvm, cpu + min);
> +		if (!dest)
>   			continue;
>   
> -		cpu = find_first_bit((void *)&ipi_bitmap, BITS_PER_LONG);
> -		while (cpu < BITS_PER_LONG) {
> -			dest = kvm_get_vcpu_by_cpuid(vcpu->kvm, cpu + min);
> -			cpu = find_next_bit((void *)&ipi_bitmap, BITS_PER_LONG, cpu + 1);
> -			if (!dest)
> -				continue;
> -
> -			/* Send SWI0 to dest vcpu to emulate IPI interrupt */
> -			kvm_queue_irq(dest, INT_SWI0);
> -			kvm_vcpu_kick(dest);
> -		}
> +		/* Send SWI0 to dest vcpu to emulate IPI interrupt */
> +		kvm_queue_irq(dest, INT_SWI0);
> +		kvm_vcpu_kick(dest);
>   	}
> -
> -	return 0;
>   }
>   
>   /*
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


