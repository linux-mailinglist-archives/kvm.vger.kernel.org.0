Return-Path: <kvm+bounces-9383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D868C85F798
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 12:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A97F61C23C00
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009A24652D;
	Thu, 22 Feb 2024 11:57:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A687E41212;
	Thu, 22 Feb 2024 11:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708603063; cv=none; b=Tlv1JsZ87hVJSv8U3XRperxugre7M4cgVA7CPTZmvZK9q70gsQLLtHaAglTKkmLCTf3HMBLEnQGqyH1/OiuJMwpE0+06eLvQwF8EIxhonWgYtGHtq1k8iV4qu5ZSZxS/QPXUwEsjgshHI4wg00jykJD3rywFj6suYM0nvXNHpxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708603063; c=relaxed/simple;
	bh=i1O0ek0muCYta3v4M3Z2ogeYhe937+UsWe85/PlS70A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gpSlj0igf6NLpd9BI6XmxvBEi4NpVaEXB4B1GU5COnKDud/QA3L9ZbbheKVbpqC3V93xLIRrI6A/hZxavvV2lNP0H/sZvVWfI9VPDbvyGNTA5VA/8kIcYcaAgjSKqNxnAORycZV+lQiC3/k1MPFZL6yjz7jFydtNFnKPVd1kGPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Ax++ixNtdlODMQAA--.22333S3;
	Thu, 22 Feb 2024 19:57:37 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxXs2sNtdlncg+AA--.28783S3;
	Thu, 22 Feb 2024 19:57:35 +0800 (CST)
Subject: Re: [PATCH for-6.8 v4 1/3] LoongArch: KVM: Fix input validation of
 _kvm_get_cpucfg and kvm_check_cpucfg
To: WANG Xuerui <kernel@xen0n.name>, Paolo Bonzini <pbonzini@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 WANG Xuerui <git@xen0n.name>
References: <20240222105109.2042732-1-kernel@xen0n.name>
 <20240222105109.2042732-2-kernel@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <e9bccf86-2ae0-64f1-7236-27278bf36c2e@loongson.cn>
Date: Thu, 22 Feb 2024 19:57:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240222105109.2042732-2-kernel@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxXs2sNtdlncg+AA--.28783S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXFWxAF4fCFyrJw13JF4DJrc_yoW5AF1fpF
	43WF43XFW8Kr1xZasaq34DGw15urW8KrZ7ZFnYkasYvr47Jr4UGr48KFZaqryfC393Jr48
	XF4UXa1akan0yacCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F
	4j6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU
	cVc_UUUUU



On 2024/2/22 下午6:51, WANG Xuerui wrote:
> From: WANG Xuerui <git@xen0n.name>
> 
> The range check for the CPUCFG ID is wrong (should have been a ||
> instead of &&) and useless in effect, so fix the obvious mistake.
> 
> Furthermore, the juggling of the temp return value is unnecessary,
> because it is semantically equivalent and more readable to just
> return at every switch case's end. This is done too to avoid potential
> bugs in the future related to the unwanted complexity.
> 
> Also, the return value of _kvm_get_cpucfg is meant to be checked, but
> this was not done, so bad CPUCFG IDs wrongly fall back to the default
> case and 0 is incorrectly returned; check the return value to fix the
> UAPI behavior.
> 
> While at it, also remove the redundant range check in kvm_check_cpucfg,
> because out-of-range CPUCFG IDs are already rejected by the -EINVAL
> as returned by _kvm_get_cpucfg.
> 
> Fixes: db1ecca22edf ("LoongArch: KVM: Add LSX (128bit SIMD) support")
> Fixes: 118e10cd893d ("LoongArch: KVM: Add LASX (256bit SIMD) support")
> Signed-off-by: WANG Xuerui <git@xen0n.name>
> ---
>   arch/loongarch/kvm/vcpu.c | 35 ++++++++++++++++++-----------------
>   1 file changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 27701991886d..7fd32de6656b 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -300,9 +300,7 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>   
>   static int _kvm_get_cpucfg(int id, u64 *v)
>   {
> -	int ret = 0;
> -
> -	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
> +	if (id < 0 || id >= KVM_MAX_CPUCFG_REGS)
>   		return -EINVAL;
>   
>   	switch (id) {
> @@ -324,32 +322,35 @@ static int _kvm_get_cpucfg(int id, u64 *v)
>   		if (cpu_has_lasx)
>   			*v |= CPUCFG2_LASX;
>   
> -		break;
> +		return 0;
>   	default:
> -		ret = -EINVAL;
> -		break;
> +		/*
> +		 * No restrictions on other valid CPUCFG IDs' values, but
> +		 * CPUCFG data is limited to 32 bits as the LoongArch ISA
> +		 * manual says (Volume 1, Section 2.2.10.5 "CPUCFG").
> +		 */
> +		*v = U32_MAX;
> +		return 0;
>   	}
> -	return ret;
>   }
>   
>   static int kvm_check_cpucfg(int id, u64 val)
>   {
> -	u64 mask;
> -	int ret = 0;
> -
> -	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
> -		return -EINVAL;
> +	u64 mask = 0;
> +	int ret;
>   
> -	if (_kvm_get_cpucfg(id, &mask))
> +	ret = _kvm_get_cpucfg(id, &mask);
> +	if (ret)
>   		return ret;
>   
> +	if (val & ~mask)
> +		/* Unsupported features and/or the higher 32 bits should not be set */
> +		return -EINVAL;
> +
>   	switch (id) {
>   	case 2:
>   		/* CPUCFG2 features checking */
> -		if (val & ~mask)
> -			/* The unsupported features should not be set */
> -			ret = -EINVAL;
> -		else if (!(val & CPUCFG2_LLFTP))
> +		if (!(val & CPUCFG2_LLFTP))
>   			/* The LLFTP must be set, as guest must has a constant timer */
>   			ret = -EINVAL;
>   		else if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
> 

Thanks for your contributions -:)

Reviewed-by: Bibo Mao <maobibo@loongson.cn>


