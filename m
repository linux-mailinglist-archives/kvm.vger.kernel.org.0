Return-Path: <kvm+bounces-8950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0074C858D09
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 04:04:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D4201C2146D
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 03:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90AD1BDCD;
	Sat, 17 Feb 2024 03:04:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB4E14F70;
	Sat, 17 Feb 2024 03:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708139083; cv=none; b=WSH0E3cfh3n36MKGGFkzko1C0UbhlWi5MZP3LfNHZI2/ZbuxmElBWkJ2VE3lpYtX095KwgnjH6YEx5XHEteNSCiNQLyNldyZbxW3pDTmnkf0x9LBb8mHgMECkInPGivzCvQTpixz/PKhbI99bevleY/kq4sZeZb7lES1F2R66lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708139083; c=relaxed/simple;
	bh=0IxgJN7KNQuoucanQanncHLPgZXjr8o5pny+hYclB+E=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=owB+O689KnRTkzNcXIHho42hYNt3aYFsPQ3y8QcpjjeWxcnaTl4ODTFNsTSzPlkzSXx9mMkE3cToqeKFjuiJuyoCiSQ8rXllRSWfqyfh1cDxGmmsBr+xXDfbDCS0Yc9TIBReV+Mharw2sNcjF6Duc+nk/zqm3V/C9w7LvS6chtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxHOvmIdBlK_ENAA--.27430S3;
	Sat, 17 Feb 2024 11:03:02 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxXs3iIdBl0do4AA--.10286S3;
	Sat, 17 Feb 2024 11:03:01 +0800 (CST)
Subject: Re: [PATCH for-6.8 v3 1/3] LoongArch: KVM: Fix input validation of
 _kvm_get_cpucfg and kvm_check_cpucfg
To: WANG Xuerui <kernel@xen0n.name>, Paolo Bonzini <pbonzini@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 WANG Xuerui <git@xen0n.name>
References: <20240216085822.3032984-1-kernel@xen0n.name>
 <20240216085822.3032984-2-kernel@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <412ea29b-7a53-1f91-1cdb-5a256e74826b@loongson.cn>
Date: Sat, 17 Feb 2024 11:03:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240216085822.3032984-2-kernel@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxXs3iIdBl0do4AA--.10286S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXr15Ary3uw4DGFWDWrWrXrc_yoW5Cw4rpF
	W3XF43WrWUKr4xA3s3tw1kGr45Zr4DKrsrXF9Yka4kZF47Ar4rJr4rKFZavry3C3s3Jr4I
	qF4UJa1S9an0yacCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1EksDUU
	UUU==

Hi Xuerui,

Good catch, and thank for your patch.

On 2024/2/16 下午4:58, WANG Xuerui wrote:
> From: WANG Xuerui <git@xen0n.name>
> 
> The range check for the CPUCFG ID is wrong (should have been a ||
> instead of &&); it is conceptually simpler to just express the check
> as another case of the switch statement on the ID. As it turns out to be
> the case, the userland (currently only the QEMU/KVM target code) expects
> to set CPUCFG IDs 0 to 20 inclusive, but only CPUCFG2 values are being
> validated.
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
> Signed-off-by: WANG Xuerui <git@xen0n.name>
> ---
>   arch/loongarch/kvm/vcpu.c | 33 +++++++++++++++------------------
>   1 file changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 27701991886d..56da0881fc94 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -300,11 +300,6 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>   
>   static int _kvm_get_cpucfg(int id, u64 *v)
>   {
> -	int ret = 0;
> -
> -	if (id < 0 && id >= KVM_MAX_CPUCFG_REGS)
> -		return -EINVAL;
> -
yes, it had better be removed since the same thing is done in function 
kvm_check_cpucfg().

>   	switch (id) {
>   	case 2:
>   		/* Return CPUCFG2 features which have been supported by KVM */
> @@ -324,31 +319,33 @@ static int _kvm_get_cpucfg(int id, u64 *v)
>   		if (cpu_has_lasx)
>   			*v |= CPUCFG2_LASX;
>   
> -		break;
> +		return 0;
> +	case 0 ... 1:
> +	case 3 ... KVM_MAX_CPUCFG_REGS - 1:
> +		/* no restrictions on other CPUCFG IDs' values */
> +		*v = U64_MAX;
> +		return 0;
how about something like this?
	default:
		/* no restrictions on other CPUCFG IDs' values */
		*v = U64_MAX;
		return 0;

Regards
Bibo Mao
>   	default:
> -		ret = -EINVAL;
> -		break;
> +		return -EINVAL;
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
> +		/* Unsupported features should not be set */
> +		return -EINVAL;
> +
>   	switch (id) {
>   	case 2:
>   		/* CPUCFG2 features checking */
> -		if (val & ~mask)
> -			/* The unsupported features should not be set */
> -			ret = -EINVAL;
>   		else if (!(val & CPUCFG2_LLFTP))
>   			/* The LLFTP must be set, as guest must has a constant timer */
>   			ret = -EINVAL;
> 


