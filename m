Return-Path: <kvm+bounces-9385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB43085F7C5
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 13:11:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 188091C234A8
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 12:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6AF5FBAC;
	Thu, 22 Feb 2024 12:11:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9F45789F;
	Thu, 22 Feb 2024 12:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708603883; cv=none; b=UBfZ70c3fTv4jXo1OFshU5QowB3EHxlQenKK3IYQeKX7gxAdp8jZNxBonN652ySVFYqGGfySsvvvcE91CvOmJ6rteXv8i4U8odlpoPY5hRg5URot96SW6dgAl7jiTFpp2uphqP1rxpqE7Yul3PfU833I4MNDHi7lDX7vDhsiksE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708603883; c=relaxed/simple;
	bh=mCi8+XxhULFtYlGGHGY0wqqU3zZCjmarzxh4FL+3HgE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=sNbUYbY+l0slrhVdwUcUQhuH8ZVMUFwYw++V61Gjmofx0FEWgOM/ZAWccYkN6YannptX1u6DLxKM6LJOxCmi0uvctNRBDPPjPC/u8Dwl4QJth61gP/nezfsiWMO2tIVwr6SuVmV3dE8v1yx0LZlFiw2cyWObq9pAM91Q3RniG+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8AxuujlOddlMjUQAA--.22305S3;
	Thu, 22 Feb 2024 20:11:17 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxVMziOddlQcs+AA--.36218S3;
	Thu, 22 Feb 2024 20:11:16 +0800 (CST)
Subject: Re: [PATCH for-6.8 v4 3/3] LoongArch: KVM: Streamline
 kvm_check_cpucfg and improve comments
To: WANG Xuerui <kernel@xen0n.name>, Paolo Bonzini <pbonzini@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 WANG Xuerui <git@xen0n.name>
References: <20240222105109.2042732-1-kernel@xen0n.name>
 <20240222105109.2042732-4-kernel@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <719c1a92-6ddc-f73a-0609-aa5d40dbee8a@loongson.cn>
Date: Thu, 22 Feb 2024 20:11:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240222105109.2042732-4-kernel@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxVMziOddlQcs+AA--.36218S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXFWfWFW5uFW7urWkWFWfZwc_yoW5ZF4DpF
	y3WwsxX3y5KryxJws29w1kXr45Ar4kGFnrXFZ5A3sYvw47ArnrGr40ya9av347C393AF1U
	WF4DWay3CayDAagCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F
	4j6r4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU
	cCD7UUUUU



On 2024/2/22 下午6:51, WANG Xuerui wrote:
> From: WANG Xuerui <git@xen0n.name>
> 
> All the checks currently done in kvm_check_cpucfg can be realized with
> early returns, so just do that to avoid extra cognitive burden related
> to the return value handling.
> 
> While at it, clean up comments of _kvm_get_cpucfg_mask and
> kvm_check_cpucfg, by removing comments that are merely restatement of
> the code nearby, and paraphrasing the rest so they read more natural
> for English speakers (that likely are not familiar with the actual
> Chinese-influenced grammar).
> 
> No functional changes intended.
> 
> Signed-off-by: WANG Xuerui <git@xen0n.name>
> ---
>   arch/loongarch/kvm/vcpu.c | 42 +++++++++++++++++++--------------------
>   1 file changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 9f63bbaf19c1..128b89d00ced 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -305,20 +305,16 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>   
>   	switch (id) {
>   	case 2:
> -		/* Return CPUCFG2 features which have been supported by KVM */
> +		/* CPUCFG2 features unconditionally supported by KVM */
>   		*v = CPUCFG2_FP     | CPUCFG2_FPSP  | CPUCFG2_FPDP     |
>   		     CPUCFG2_FPVERS | CPUCFG2_LLFTP | CPUCFG2_LLFTPREV |
>   		     CPUCFG2_LAM;
>   		/*
> -		 * If LSX is supported by CPU, it is also supported by KVM,
> -		 * as we implement it.
> +		 * For the ISA extensions listed below, if one is supported
> +		 * by the host, then it is also supported by KVM.
>   		 */
>   		if (cpu_has_lsx)
>   			*v |= CPUCFG2_LSX;
> -		/*
> -		 * if LASX is supported by CPU, it is also supported by KVM,
> -		 * as we implement it.
> -		 */
>   		if (cpu_has_lasx)
>   			*v |= CPUCFG2_LASX;
>   
> @@ -349,24 +345,26 @@ static int kvm_check_cpucfg(int id, u64 val)
>   
>   	switch (id) {
>   	case 2:
> -		/* CPUCFG2 features checking */
>   		if (!(val & CPUCFG2_LLFTP))
> -			/* The LLFTP must be set, as guest must has a constant timer */
> -			ret = -EINVAL;
> -		else if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
> -			/* Single and double float point must both be set when enable FP */
> -			ret = -EINVAL;
> -		else if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
> -			/* FP should be set when enable LSX */
> -			ret = -EINVAL;
> -		else if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
> -			/* LSX, FP should be set when enable LASX, and FP has been checked before. */
> -			ret = -EINVAL;
> -		break;
> +			/* Guests must have a constant timer */
> +			return -EINVAL;
> +		if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
> +			/* Single and double float point must both be set when FP is enabled */
> +			return -EINVAL;
> +		if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
> +			/* LSX architecturally implies FP but val does not satisfy that */
> +			return -EINVAL;
> +		if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
> +			/* LASX architecturally implies LSX and FP but val does not satisfy that */
> +			return -EINVAL;
> +		return 0;
>   	default:
> -		break;
> +		/*
> +		 * Values for the other CPUCFG IDs are not being further validated
> +		 * besides the mask check above.
> +		 */
> +		return 0;
>   	}
> -	return ret;
>   }
>   
>   static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
> 
Reviewed-by: Bibo Mao <maobibo@loongson.cn>


