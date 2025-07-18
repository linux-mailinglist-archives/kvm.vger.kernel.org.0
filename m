Return-Path: <kvm+bounces-52836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82779B099DE
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CAFD1C448A7
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA8F1C5D4B;
	Fri, 18 Jul 2025 02:38:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B102E1A9B53;
	Fri, 18 Jul 2025 02:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752806325; cv=none; b=epA9RTKu/1pdnav0LT1SuxDV92Iks07exfY7HMHgCzIKvbb+bntRnI0jW1XuWErRa8RkgZVM+hU+1iFewDPBrpv39oyYeiWWT9WQPxPXWAElHjl/LHYJGEiAlI3BcxttcVLPucFSSFWM0Y6Ieu9EWe0ANKZ1w0rGhqKoqzxyE+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752806325; c=relaxed/simple;
	bh=YZcLFfsFSR5FdKJhywtA6fwgWDEvD/NUMszA99XaFuE=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fDzqa+3Lp3rFvlyvklRnihAbJMWm5vo9seru3sWWe9B/VY79Kbd682vxHPlW4EVowyTs4byR0B/wc8stJfH5CiDflzYmAkezDgJduJM+IiUDhoEsGNTBYiEbK9tDgi5OzzYNi3O5zBrZVvYlIXBKAUViJSmcb8oZ2/xmcDY98w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxCeGws3lo854sAQ--.50950S3;
	Fri, 18 Jul 2025 10:38:40 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxT+aus3lo5sMbAA--.16638S3;
	Fri, 18 Jul 2025 10:38:40 +0800 (CST)
Subject: Re: [PATCH 2/2] LoongArch: KVM:: simplify kvm_deliver_intr()
To: Yury Norov <yury.norov@gmail.com>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250716165929.22386-1-yury.norov@gmail.com>
 <20250716165929.22386-3-yury.norov@gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <3b5ad9c2-23ad-4f3b-412a-fe6c1a4c855a@loongson.cn>
Date: Fri, 18 Jul 2025 10:37:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250716165929.22386-3-yury.norov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxT+aus3lo5sMbAA--.16638S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7CFWUGFW8XrWrtF47CrW3urX_yoW8AF4rp3
	yrC347Zr4rGr17K3s0qan5XF4jqrWkKFs2yrZrC34fKr1aqF1qvFy8CrykXFy7Ca97G3yf
	Xr1Sk348ua4DXrbCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8wN
	VDUUUUU==



On 2025/7/17 上午12:59, Yury Norov wrote:
> From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
> 
> The function opencodes for_each_set_bit() macro, which makes it bulky.
> Using the proper API makes all the housekeeping code going away.
> 
> Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> ---
>   arch/loongarch/kvm/interrupt.c | 25 ++++---------------------
>   1 file changed, 4 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/interrupt.c b/arch/loongarch/kvm/interrupt.c
> index 4c3f22de4b40..8462083f0301 100644
> --- a/arch/loongarch/kvm/interrupt.c
> +++ b/arch/loongarch/kvm/interrupt.c
> @@ -83,28 +83,11 @@ void kvm_deliver_intr(struct kvm_vcpu *vcpu)
>   	unsigned long *pending = &vcpu->arch.irq_pending;
>   	unsigned long *pending_clr = &vcpu->arch.irq_clear;
>   
> -	if (!(*pending) && !(*pending_clr))
> -		return;
> -
> -	if (*pending_clr) {
> -		priority = __ffs(*pending_clr);
> -		while (priority <= INT_IPI) {
> -			kvm_irq_clear(vcpu, priority);
> -			priority = find_next_bit(pending_clr,
> -					BITS_PER_BYTE * sizeof(*pending_clr),
> -					priority + 1);
> -		}
> -	}
> +	for_each_set_bit(priority, pending_clr, INT_IPI + 1)
> +		kvm_irq_clear(vcpu, priority);
>   
> -	if (*pending) {
> -		priority = __ffs(*pending);
> -		while (priority <= INT_IPI) {
> -			kvm_irq_deliver(vcpu, priority);
> -			priority = find_next_bit(pending,
> -					BITS_PER_BYTE * sizeof(*pending),
> -					priority + 1);
> -		}
> -	}
> +	for_each_set_bit(priority, pending, INT_IPI + 1)
> +		kvm_irq_deliver(vcpu, priority);
>   }
>   
>   int kvm_pending_timer(struct kvm_vcpu *vcpu)
> 
Hi Yury,

Thanks for your patch. And it looks good to me.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>

Regards
Bibo Mao


