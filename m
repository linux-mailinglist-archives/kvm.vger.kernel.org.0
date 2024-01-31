Return-Path: <kvm+bounces-7528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D24CD8434AB
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 04:48:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 115441C20AF7
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 03:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1966E1642A;
	Wed, 31 Jan 2024 03:48:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFD9125B9;
	Wed, 31 Jan 2024 03:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706672908; cv=none; b=oODvdFvTPeXJzcBzrNFY8/+Ub3BeywcgAZm+vEE2wKUHc2i9Om5k4uB/Dequu4rYK5DqOPRqz8PgvLkxTtjN8yJCcSwkOvVcU9/1V68mEJGtxU4fecLIyG7L7SSp9bGmAEqXIRb9dEZPRbSaeU89BKlrx3+yDCXFOnW2l2tfPJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706672908; c=relaxed/simple;
	bh=WjJKpyNGS1blPKAfbNn8MquKPZSqvebdPCEZMuXh/+M=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=F3PxKJT5E/202J2KYP5FSbKj8tDggvSswL+AtDF8Ut/c0yc89WDlznGghuqsGmmdwZahxPhEGW+grrVBk4myFzt4hc9+S3OY/hKbimUrToMtnLxqbZB++n8M3ZzGkrzd+91NPhvxUVjz7pVx32OgkvQ9C/iUPhRMC7fyLAOqVlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxVfECw7llcsMIAA--.26966S3;
	Wed, 31 Jan 2024 11:48:18 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxjhMAw7llOn0pAA--.40142S3;
	Wed, 31 Jan 2024 11:48:18 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Remove unnecessary CSR register saving
 during enter guest
From: maobibo <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240112035039.833974-1-maobibo@loongson.cn>
Message-ID: <b7c08e0d-bd7d-aea9-250e-1649e95599b7@loongson.cn>
Date: Wed, 31 Jan 2024 11:48:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240112035039.833974-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxjhMAw7llOn0pAA--.40142S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoWrKFyrur4rGrW5tr17ur1ruFX_yoWDGwb_X3
	WIkw4Dur4fJa17u3yF9r98Xw1jq3WkG39a9ry8ZryxJa4FqrZ8Xr47Aa1rAw13KFWUJ3yf
	ArWxKrZ3ur1ayosvyTuYvTs0mTUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbxAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j8yCJU
	UUUU=

slightly ping :)

On 2024/1/12 上午11:50, Bibo Mao wrote:
> Some CSR registers like CRMD/PRMD are saved during enter VM mode. However
> they are not restored for actual use, saving for these CSR registers
> can be removed.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   arch/loongarch/kvm/switch.S | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index 0ed9040307b7..905b90de50e8 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -213,12 +213,6 @@ SYM_FUNC_START(kvm_enter_guest)
>   	/* Save host GPRs */
>   	kvm_save_host_gpr a2
>   
> -	/* Save host CRMD, PRMD to stack */
> -	csrrd	a3, LOONGARCH_CSR_CRMD
> -	st.d	a3, a2, PT_CRMD
> -	csrrd	a3, LOONGARCH_CSR_PRMD
> -	st.d	a3, a2, PT_PRMD
> -
>   	addi.d	a2, a1, KVM_VCPU_ARCH
>   	st.d	sp, a2, KVM_ARCH_HSP
>   	st.d	tp, a2, KVM_ARCH_HTP
> 
> base-commit: de927f6c0b07d9e698416c5b287c521b07694cac
> 


