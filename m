Return-Path: <kvm+bounces-21164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1618692B39E
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 11:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86816B2240D
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 09:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D321552FC;
	Tue,  9 Jul 2024 09:23:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0B4154BE8;
	Tue,  9 Jul 2024 09:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720516986; cv=none; b=bDx+n1+f0ueWM5N4EkJgeJFMjRqHuHDq6QCFl4YEo8C0JSP2HbEuZZnNnuXlc/HSIMjl3jPeo/yg85mXi3tyh6v5PMlg74v4dsTq7rsuipv+nqNYRybL1gIxfDF0VnB+aDPQBwgQJLiiYHFMHxl7m2EqdoLgvxItcvRsnDgr4Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720516986; c=relaxed/simple;
	bh=Mg/A831yLmDsApgW71u2EDNhhGRIX5UWXSlgAY7Jyvo=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=kH9CY4PAZcXKVMCZOv9smnyE1cqVu/lnIP6/NNN61Nv1+NJih1lKnplm26b3toqwhBqhUEaEZ2JjbvaQDTnW9RspHMQMqyuRD5WvZazPdDPTs4jb5LMWAcSy3+rIOK6dNItOFf8sVKnTxSdHclIzdI9Bk+OY68Ck9ObqsDnibrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cx7+tyAY1msFwCAA--.7080S3;
	Tue, 09 Jul 2024 17:22:58 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxusZwAY1mitJAAA--.18510S3;
	Tue, 09 Jul 2024 17:22:58 +0800 (CST)
Subject: Re: [PATCH v2] LoongArch: KVM: Implement feature passing from user
 space
From: maobibo <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240611123655.4169939-1-maobibo@loongson.cn>
Message-ID: <5b568152-7912-c613-588e-7b2bf1491ee5@loongson.cn>
Date: Tue, 9 Jul 2024 17:22:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240611123655.4169939-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxusZwAY1mitJAAA--.18510S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Aw1UGrWfKw4rWry3ArykXrc_yoW7Cr4kpF
	y7AFn5Gr4rKryfCw1ktws8ur47XFs7Gr129Fy2g3y5AF4j9r18Jr1kKrZrXFy5Jw48Z3WI
	qF1Fkwn0va1qvwbCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j8
	yCJUUUUU=

Gently ping.

On 2024/6/11 下午8:36, Bibo Mao wrote:
> Currently features defined in cpucfg CPUCFG_KVM_FEATURE come from
> kvm kernel mode only. However KVM is not aware of user-space VMM
> features which makes it hard to employ optimizations. Here interface
> is added to update register CPUCFG_KVM_FEATURE from user space,
> only bit 24 - 31 is valid, so that VM can detect features implemented
> in user-space VMM.
> 
> A new feature bit KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI is added which
> can be set from user space. This feature indicates that the virt EXTIOI
> can route interrupts to 256 vCPUs, rather than 4 vCPUs like with real HW.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
> v1 ... v2:
>    1. Update changelog suggested by WangXuerui.
>    2. Fix typo issue in function kvm_loongarch_cpucfg_set_attr(), usr_features
> should be assigned directly, also suggested by WangXueRui.
> ---
>   arch/loongarch/include/asm/kvm_host.h  |  4 +++
>   arch/loongarch/include/asm/loongarch.h |  5 ++++
>   arch/loongarch/include/uapi/asm/kvm.h  |  2 ++
>   arch/loongarch/kvm/exit.c              |  1 +
>   arch/loongarch/kvm/vcpu.c              | 36 +++++++++++++++++++++++---
>   5 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 88023ab59486..8fa50d757247 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -135,6 +135,9 @@ enum emulation_result {
>   #define KVM_LARCH_HWCSR_USABLE	(0x1 << 4)
>   #define KVM_LARCH_LBT		(0x1 << 5)
>   
> +#define KVM_LOONGARCH_USR_FEAT_MASK			\
> +	BIT(KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI)
> +
>   struct kvm_vcpu_arch {
>   	/*
>   	 * Switch pointer-to-function type to unsigned long
> @@ -210,6 +213,7 @@ struct kvm_vcpu_arch {
>   		u64 last_steal;
>   		struct gfn_to_hva_cache cache;
>   	} st;
> +	unsigned int usr_features;
>   };
>   
>   static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
> index 7a4633ef284b..4d9837512c19 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -167,9 +167,14 @@
>   
>   #define CPUCFG_KVM_SIG			(CPUCFG_KVM_BASE + 0)
>   #define  KVM_SIGNATURE			"KVM\0"
> +/*
> + * BIT 24 - 31 is features configurable by user space vmm
> + */
>   #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
>   #define  KVM_FEATURE_IPI		BIT(1)
>   #define  KVM_FEATURE_STEAL_TIME		BIT(2)
> +/* With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs */
> +#define  KVM_FEATURE_VIRT_EXTIOI	BIT(24)
>   
>   #ifndef __ASSEMBLY__
>   
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
> index ed12e509815c..dd141259de48 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -99,6 +99,8 @@ struct kvm_fpu {
>   
>   /* Device Control API on vcpu fd */
>   #define KVM_LOONGARCH_VCPU_CPUCFG	0
> +/* For CPUCFG_KVM_FEATURE register */
> +#define  KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI	24
>   #define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
>   #define  KVM_LOONGARCH_VCPU_PVTIME_GPA	0
>   
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index e1bd81d27fd8..ab2dcc76784a 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -53,6 +53,7 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
>   		ret = KVM_FEATURE_IPI;
>   		if (sched_info_on())
>   			ret |= KVM_FEATURE_STEAL_TIME;
> +		ret |= vcpu->arch.usr_features;
>   		vcpu->arch.gprs[rd] = ret;
>   		break;
>   	default:
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 3783151fde32..4a06a9e96e4e 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -832,6 +832,8 @@ static int kvm_loongarch_cpucfg_has_attr(struct kvm_vcpu *vcpu,
>   	switch (attr->attr) {
>   	case 2:
>   		return 0;
> +	case CPUCFG_KVM_FEATURE:
> +		return 0;
>   	default:
>   		return -ENXIO;
>   	}
> @@ -865,9 +867,18 @@ static int kvm_loongarch_get_cpucfg_attr(struct kvm_vcpu *vcpu,
>   	uint64_t val;
>   	uint64_t __user *uaddr = (uint64_t __user *)attr->addr;
>   
> -	ret = _kvm_get_cpucfg_mask(attr->attr, &val);
> -	if (ret)
> -		return ret;
> +	switch (attr->attr) {
> +	case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
> +		ret = _kvm_get_cpucfg_mask(attr->attr, &val);
> +		if (ret)
> +			return ret;
> +		break;
> +	case CPUCFG_KVM_FEATURE:
> +		val = vcpu->arch.usr_features & KVM_LOONGARCH_USR_FEAT_MASK;
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
>   
>   	put_user(val, uaddr);
>   
> @@ -896,7 +907,24 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcpu *vcpu,
>   static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
>   					 struct kvm_device_attr *attr)
>   {
> -	return -ENXIO;
> +	u64 __user *user = (u64 __user *)attr->addr;
> +	u64 val, valid_flags;
> +
> +	switch (attr->attr) {
> +	case CPUCFG_KVM_FEATURE:
> +		if (get_user(val, user))
> +			return -EFAULT;
> +
> +		valid_flags = KVM_LOONGARCH_USR_FEAT_MASK;
> +		if (val & ~valid_flags)
> +			return -EINVAL;
> +
> +		vcpu->arch.usr_features = val;
> +		return 0;
> +
> +	default:
> +		return -ENXIO;
> +	}
>   }
>   
>   static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
> 
> base-commit: 2df0193e62cf887f373995fb8a91068562784adc
> 


