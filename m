Return-Path: <kvm+bounces-18203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A12FC8D183C
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 12:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00A78B228D6
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 10:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7BC916B724;
	Tue, 28 May 2024 10:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="iEW19tZ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0C013D89D
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 10:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716891316; cv=none; b=c9wgJkqcmlLDqE8wtAplst452z8jxhVj8eZ3F+a2PpqEkNRWysllz6kpE8rivMWMyIAm3t7fAppMAXDdkhK6Fmp4wqsNp999MtaN6gpmnbBciun5n0AJsTXyvq3nXwNV9LKTAj26vC3/3HQ97//ZXl84GRYDv1z5j60SyI55GRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716891316; c=relaxed/simple;
	bh=E7sKFLfev1mNkIg5WjRCuKqrgXi1JgkmqpVqr6lz4Bs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q9uZiY0DIqPkAyVH9EeAzTK+pBamGCfTAMvrRFyqM9lctr36+92Xme2NsjYj7mtLCkszBZ54OqH8abNvgzIm0Yp30NvjgEuWw1vqybG7CJLEKk9CsutAnjtaX3//xuVwuCrZQkhEfFVkvjr7sdfTPt3EUrCdkhGudW3oXAUTkO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=iEW19tZ8; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2e95a73c622so320341fa.2
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 03:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1716891312; x=1717496112; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KJo11HxnJz9bNWmT6d/DDh++L1djwhjY6e39n68+9tM=;
        b=iEW19tZ8ty/EWCD26onWEnqxICI99g3aN81564s9xkENO7t7zMXn9qXSCDxWAG1lPo
         G3D2/22QvPa336pHIyPoPdGLolsgxBAg1lDON6ncIph2TENlljhMLMCTh5NS1F0Ztx/G
         4LgGo7WuQS4WebmtGkgKRuVmkMGc2Vuq64Vc4vMoOMYGYeiI3OCsHwvqhOXOMJcYIbtp
         lX9gXNcmuZz9NUXyZcJEPpmwUZz2LkrDFYvXtW4Vj5HXy5gb7cGOuOMk0gO0lII0MeHS
         a1fK/IeCOD9WgTbz78C+uprrAuFY1ckvvivtFz0Go+n6dAbBVfDj6Qtqs8tx93SwNKWj
         4t3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716891312; x=1717496112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KJo11HxnJz9bNWmT6d/DDh++L1djwhjY6e39n68+9tM=;
        b=GXSgWvw9gm+AboRmWZho8Q8Fkit5PzjYFEyFroVli/Q13II8GwdpZKxXo7uy0KopiD
         qObDHaLC6IQc2LzkFm9FcAgJJ/w/HhSn3E8CDr2jY9QrYFaFt2Ysv4uJtp6gSrnGhYOh
         QHKJypWjg+RtwcakAT+e8lTwMSFs4Ejo09bJeGhOooaq4iEEADupWgdaglhTC7ftkBo9
         Ooe5PoAttQEge+dX5bGMqOVIXPl0s5H7zfsih0J4nMQ0T7YpHpQIjgcRRgAgBSLgpHkr
         lzfM5qIFnqgtRp416eIynImn8dM9uYMsC1B14n30S8qQawr0JdcG2ixDsz/sVlnumQXg
         /BAw==
X-Forwarded-Encrypted: i=1; AJvYcCXSj7U6IzZ/mpawUNbkMrO7HLYsKDTy20ThTbv07dX7n/ZKYONwYDaDy4IcaidJPhRYUZsHQUXE5BoeTUOhWtOtxyil
X-Gm-Message-State: AOJu0Yycql7zHf62XR2SmgCtGTTxpVE6aChO73ILKFhf7QPsNviN2Uiq
	8aNWx/f2leES1U81QbqOWP0gDlzqFx9WrJ8S8EfXoI25kquUwE3XFdz51AJ/rOA=
X-Google-Smtp-Source: AGHT+IGJQCkm1zvi3G2nkrY7snFxSIlGT1jUS1f8uJE8FtpINZx4K4WXRaEt0TWwggZ5ofXJB3NyLA==
X-Received: by 2002:a05:651c:2106:b0:2de:42d0:faf8 with SMTP id 38308e7fff4ca-2e95b33028cmr80465331fa.5.1716891310532;
        Tue, 28 May 2024 03:15:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:999:a3a0:deaf:e457:42a:ab9? ([2a01:e0a:999:a3a0:deaf:e457:42a:ab9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35586a15f56sm11303694f8f.109.2024.05.28.03.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 03:15:10 -0700 (PDT)
Message-ID: <40da6797-faab-41f3-b4bd-766e6a117468@rivosinc.com>
Date: Tue, 28 May 2024 12:15:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/5] RISC-V: KVM: add support for
 SBI_FWFT_PTE_AD_HW_UPDATING
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com, alex@ghiti.fr,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 linux-kernel@vger.kernel.org
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-5-yongxuan.wang@sifive.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20240524103307.2684-5-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 24/05/2024 12:33, Yong-Xuan Wang wrote:
> Add support for SBI_FWFT_PTE_AD_HW_UPDATING to set the PTE A/D bits
> updating behavior for Guest/VM.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  2 +-
>  arch/riscv/kvm/vcpu_sbi_fwft.c             | 38 +++++++++++++++++++++-
>  2 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> index 7b7bcc5c8fee..3614a44e0a4a 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
> @@ -11,7 +11,7 @@
>  
>  #include <asm/sbi.h>
>  
> -#define KVM_SBI_FWFT_FEATURE_COUNT	1
> +#define KVM_SBI_FWFT_FEATURE_COUNT	2
>  
>  struct kvm_sbi_fwft_config;
>  struct kvm_vcpu;
> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
> index 89ec263c250d..14ef74023340 100644
> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
> @@ -71,6 +71,36 @@ static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
>  	return SBI_SUCCESS;
>  }
>  
> +static int kvm_sbi_fwft_adue_supported(struct kvm_vcpu *vcpu)
> +{
> +	if (!riscv_isa_extension_available(vcpu->arch.isa, SVADU))
> +		return SBI_ERR_NOT_SUPPORTED;
> +
> +	return 0;
> +}
> +
> +static int kvm_sbi_fwft_set_adue(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf,
> +				 unsigned long value)
> +{
> +	if (value)
> +		vcpu->arch.cfg.henvcfg |= ENVCFG_ADUE;
> +	else
> +		vcpu->arch.cfg.henvcfg &= ~ENVCFG_ADUE;
> +
> +	return SBI_SUCCESS;
> +}
> +
> +static int kvm_sbi_fwft_get_adue(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf,
> +				 unsigned long *value)
> +{
> +	if (!riscv_isa_extension_available(vcpu->arch.isa, SVADU))
> +		return SBI_ERR_NOT_SUPPORTED;
> +
> +	*value = !!(vcpu->arch.cfg.henvcfg & ENVCFG_ADUE);
> +
> +	return SBI_SUCCESS;
> +}

Hi Yong-Xuan,

vcpu->arch.cfg.henvcfg seems to be used to update the HENVCFG CSR  only
during vcpu_load()/vcpu_put(). So if this extension updates it there and
stays in the execution loop (kvm_arch_vcpu_ioctl_run()) then, it seems
like the HENVCFG CSR won't be updated immediately but on the next
vcpu_load(). Is there something I'm missing ?

Thanks,

Clément Léger

> +
>  static struct kvm_sbi_fwft_config *
>  kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t feature)
>  {
> @@ -177,7 +207,13 @@ static const struct kvm_sbi_fwft_feature features[] = {
>  		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
>  		.set = kvm_sbi_fwft_set_misaligned_delegation,
>  		.get = kvm_sbi_fwft_get_misaligned_delegation,
> -	}
> +	},
> +	{
> +		.id = SBI_FWFT_PTE_AD_HW_UPDATING,
> +		.supported = kvm_sbi_fwft_adue_supported,
> +		.set = kvm_sbi_fwft_set_adue,
> +		.get = kvm_sbi_fwft_get_adue,
> +	},
>  };
>  
>  static_assert(ARRAY_SIZE(features) == KVM_SBI_FWFT_FEATURE_COUNT);

