Return-Path: <kvm+bounces-52287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE873B03B8B
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EA203B1768
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A0D24397B;
	Mon, 14 Jul 2025 09:59:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29C7242D82;
	Mon, 14 Jul 2025 09:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752487144; cv=none; b=i54LT9PGKGS/WtDmpSeNPgWzvwtB9LwOIZdwr8xK9/snHQNqeDSYNbtAnssdAgn3e4pTCOuHIiALBpFoclgdByav0qwBz1BD9RJXX/fIucbU2LWeKrw5S02jwZkpHyTYITf1nlbqrgMr1GbnWVuBgXQKzTMHHhrPZQ/MxLD2r/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752487144; c=relaxed/simple;
	bh=lHk2IUnwJuUw4LIROoT7XX5z7h9Wq0IAV/QNY3bBi7k=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AzXsFRqKSfXraaeK3oWWwUMTvcMPCom4UEv7C2tfJdk5bdW439HEF2zVMk0MZqGDUmJUSwceevIjyCaNYGEUDK5A0n/vJbbSqTex4uwQ/kdBVZvc89TRFDs9Mj8VRLAfS/rmfVsJNCTC3X04VKHhlJ1GHVnSBtqSepEMyiwO854=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bx22ri1HRovSopAQ--.51104S3;
	Mon, 14 Jul 2025 17:58:59 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJCxH8Lf1HRoTqsWAA--.5040S3;
	Mon, 14 Jul 2025 17:58:57 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Add some feature detection on host with
 3C6000
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250707035143.1979013-1-maobibo@loongson.cn>
Message-ID: <de4c715f-db47-70b5-91a7-a436bf3a1c1b@loongson.cn>
Date: Mon, 14 Jul 2025 17:57:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250707035143.1979013-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxH8Lf1HRoTqsWAA--.5040S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Kry5CF17Kr4Uuw4DXw4UKFX_yoW8Aw17pF
	yDAF4kJr4Fkr1fAan5tw1q9r43Xa1Ikr4Fga429rW5Arn0qrykAr1kKr9ruFy5tw4rW34x
	uFnYkw4Yva1qqwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6F4UJVW0owAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AK
	xVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8uuWJUUUUU==

Maybe it is too early to submit such patch :(

At least there is new CSR registers about AVEC feature which are not 
saved and restored in vCPU context switch function. And the AVEC feature 
in KVM is not tested also.

Regards
Bibo Mao

On 2025/7/7 上午11:51, Bibo Mao wrote:
> With 3C6000 hardware platform, hardware page table walking and avec
> features are supported on host. Here add these two feature detection
> on KVM host.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   arch/loongarch/include/uapi/asm/kvm.h | 2 ++
>   arch/loongarch/kvm/vm.c               | 8 ++++++++
>   2 files changed, 10 insertions(+)
> 
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index 5f354f5c6847..0b9feb6c0d53 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -103,6 +103,8 @@ struct kvm_fpu {
>   #define  KVM_LOONGARCH_VM_FEAT_PMU		5
>   #define  KVM_LOONGARCH_VM_FEAT_PV_IPI		6
>   #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
> +#define  KVM_LOONGARCH_VM_FEAT_PTW		8
> +#define  KVM_LOONGARCH_VM_FEAT_AVEC		9
>   
>   /* Device Control API on vcpu fd */
>   #define KVM_LOONGARCH_VCPU_CPUCFG	0
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> index edccfc8c9cd8..728b24a62f1e 100644
> --- a/arch/loongarch/kvm/vm.c
> +++ b/arch/loongarch/kvm/vm.c
> @@ -146,6 +146,14 @@ static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr
>   		if (kvm_pvtime_supported())
>   			return 0;
>   		return -ENXIO;
> +	case KVM_LOONGARCH_VM_FEAT_PTW:
> +		if (cpu_has_ptw)
> +			return 0;
> +		return -ENXIO;
> +	case KVM_LOONGARCH_VM_FEAT_AVEC:
> +		if (cpu_has_avecint)
> +			return 0;
> +		return -ENXIO;
>   	default:
>   		return -ENXIO;
>   	}
> 


