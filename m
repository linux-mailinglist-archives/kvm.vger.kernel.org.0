Return-Path: <kvm+bounces-35138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB09A09EE1
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0114188ED0A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D7422331C;
	Fri, 10 Jan 2025 23:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="eb9v4QNQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24092139AC
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 23:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736553348; cv=none; b=W76rkDFqWJXrcMo2nkOgrUiIn9L1EkALKbF/EN/xoiYOAaXWWibLN9EjTEU37sVPJriShwPo9Kz2HZEZt4975AE8y3teVhoJP1AkvtktIlLF4rJ/gbCvaTHWqdziFCrD6HMJ6I1q9gAamnkYOjrPupr/7D01+mX+JFg1B7qAgsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736553348; c=relaxed/simple;
	bh=6WwWPxjEZKQ1xUf1jWLHrZ93xlpPj2Otfo2my453W+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=VjMMSrNM0Jp/dCgvj2Lc0+HYhOLxzL+V4/JXdfnUGnxqft04CXWX4arS0U0CQ3VSKI4pAf2o/jQ7eVieSxhsyV/uC+6ZQMErx1dp0ZYCIdiDS6cg/4puSeuSsIwmS7Mr3qFCPXBw43niofukwcVO75EBUXcQ/12HhrORSGQ7mb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=eb9v4QNQ; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-844ef6275c5so84106839f.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 15:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1736553345; x=1737158145; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=83wRULGvUmj10rdkn50Twrq4N8VlHWb+qzAtMGfh0G4=;
        b=eb9v4QNQendavFA7FJQ4geosQtKaR91Ll1gigMBeiWjedGjNuaQ5uaXW+C1xrSmIe4
         EyNuRvH9W2ojUI7Lzq/7Aq5ccxy+BMW5FcVCfl7LfWtj9dONr/lAv8yoyxNFNDx35j1Q
         Y45MpxOyITk0eGJqqkPUAGBaEX1rJ+07CoJemSvO7iYwobUBYwdBJiLqr9NoEAM0ZAG6
         N/Cn3Q0ubidIZ3wM2uBCanEX0r8WST1twIG7l1kPuN2jMgh8APMYYEaFYRZNh+Z1LCva
         aYtwGQEywlGbP6LeZGvmVeuIrg7d0qz+XzkzvvrzCJ4Nn7r84/TPMoKhZHyfKh3m+qOv
         UmtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736553345; x=1737158145;
        h=content-transfer-encoding:in-reply-to:cc:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=83wRULGvUmj10rdkn50Twrq4N8VlHWb+qzAtMGfh0G4=;
        b=gxWIg2ENlen1//KPEywyLN9TlgjCbrkGr6ECqHtWzoMZHPmBvpmfymB0LnQwUhGAn4
         1TU0dl7HmWcQ8PWuB3NBIj9zgCDNj8HlObkPE/QwQ64/XYzV6g8aM7KHaO46oKuP2hoy
         Dxm2E+IkFjlDOPxeDMFlLpe3LLc1Goi7Iri1b6fH24oEqUel7ngN8/AiHxF0/seUstur
         bgHfvG3act1O5v547trrJlu1lpmblEUyNYVOMABmxFw0iRoTnH0gQpeFnyI5nkZvA6/E
         05l2vV2zU5pQ7e3+dW4FTA+4Bkv2FF9Ovi3aMieDBB2s5vXXShG+KHpvMbVqf6XQWtLC
         7IxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjJPsHhgS2vh1VkuZhQcnSJ6r2zWnwIl9sT6ITBWpBU1X2VqxUu9grnhueY53BUoE8tpU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8aq1tGzyL24ZsxiBTq0Gdwfi4of3OZUXHY/bIs3u3YCrgc2cN
	JfFbp+99DXPudYjUPg9XsI3WGp4D54IIwzRARhTQ6oBi+gX/6cXDrvNbEBnmczI=
X-Gm-Gg: ASbGnctqgDtph8YaHhEbxgmFb8BiEtQCOZyMdjJdWL2FTrni2DVe9DuEIyqRQ+rswut
	Ml+y80HNAK3z1cZ9DSDDZr77wTU33GoHUVw7c9BHVXUBHevf6sFQYGOMSndaOvVLwm8QFAI5nZI
	04JLrF+Apa92O76Ad9p8zMmqLV3/wU65jEjAaDVfHWQs5jQdSJd7D7DvjBJX1cwJJfFfoe0Ypnp
	UgySmjF3xMy00YYRj0khSmPCvmSSG5yhzRGWd5lAzn2cIVylALURE8CJVqe/XFo6ib6morgPU7W
	p1U0
X-Google-Smtp-Source: AGHT+IH0fgQxMOSKadJfIoy2Nj8jc7fKrOvZJO0N4J4fYEHjn0eRwTiFqc8rtxsnNitjP7FoCOy29w==
X-Received: by 2002:a05:6e02:1c81:b0:3a7:6636:eb3b with SMTP id e9e14a558f8ab-3ce3aa5ad65mr87898675ab.17.1736553344919;
        Fri, 10 Jan 2025 15:55:44 -0800 (PST)
Received: from [100.64.0.1] ([165.188.116.9])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce4ad94327sm11932995ab.15.2025.01.10.15.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 15:55:44 -0800 (PST)
Message-ID: <b3f54d34-bc77-46db-88da-70c0c602081f@sifive.com>
Date: Fri, 10 Jan 2025 17:55:43 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] RISC-V: KVM: add support for
 SBI_FWFT_MISALIGNED_DELEG
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
 <20250106154847.1100344-7-cleger@rivosinc.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
In-Reply-To: <20250106154847.1100344-7-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-01-06 9:48 AM, Clément Léger wrote:
> SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
> misaligned load/store exceptions. Save and restore it during CPU
> load/put.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu.c          |  3 +++
>  arch/riscv/kvm/vcpu_sbi_fwft.c | 39 ++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 3420a4a62c94..bb6f788d46f5 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -641,6 +641,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	void *nsh;
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
> +	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>  
>  	vcpu->cpu = -1;
>  
> @@ -666,6 +667,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  		csr->vstval = nacl_csr_read(nsh, CSR_VSTVAL);
>  		csr->hvip = nacl_csr_read(nsh, CSR_HVIP);
>  		csr->vsatp = nacl_csr_read(nsh, CSR_VSATP);
> +		cfg->hedeleg = nacl_csr_read(nsh, CSR_HEDELEG);
>  	} else {
>  		csr->vsstatus = csr_read(CSR_VSSTATUS);
>  		csr->vsie = csr_read(CSR_VSIE);
> @@ -676,6 +678,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  		csr->vstval = csr_read(CSR_VSTVAL);
>  		csr->hvip = csr_read(CSR_HVIP);
>  		csr->vsatp = csr_read(CSR_VSATP);
> +		cfg->hedeleg = csr_read(CSR_HEDELEG);
>  	}
>  }
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
> index 55433e805baa..1e85ff6666af 100644
> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
> @@ -14,6 +14,8 @@
>  #include <asm/kvm_vcpu_sbi.h>
>  #include <asm/kvm_vcpu_sbi_fwft.h>
>  
> +#define MIS_DELEG (1UL << EXC_LOAD_MISALIGNED | 1UL << EXC_STORE_MISALIGNED)
> +
>  static const enum sbi_fwft_feature_t kvm_fwft_defined_features[] = {
>  	SBI_FWFT_MISALIGNED_EXC_DELEG,
>  	SBI_FWFT_LANDING_PAD,
> @@ -35,7 +37,44 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
>  	return false;
>  }
>  
> +static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
> +{
> +	if (!unaligned_ctl_available())

This seems like the wrong condition. Patch 2 requests delegation regardless of
what probing detects. For MISALIGNED_SCALAR_FAST, the delegation likely doesn't
change any actual behavior, because the hardware likely never raises the
exception. But it does ensure M-mode never emulates anything, so if the
exception were to occur, the kernel has the choice whether to handle it. And
this lets us provide the same guarantee to KVM guests. So I think this feature
should also be supported if we successfully delegated the exception on the host
side.

> +		return false;
> +
> +	return true;
> +}
> +
> +static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
> +					struct kvm_sbi_fwft_config *conf,
> +					unsigned long value)
> +{
> +	if (value == 1)
> +		csr_set(CSR_HEDELEG, MIS_DELEG);
> +	else if (value == 0)
> +		csr_clear(CSR_HEDELEG, MIS_DELEG);
> +	else
> +		return SBI_ERR_INVALID_PARAM;
> +
> +	return SBI_SUCCESS;
> +}
> +
> +static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
> +					struct kvm_sbi_fwft_config *conf,
> +					unsigned long *value)
> +{
> +	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) != 0;
> +
> +	return SBI_SUCCESS;
> +}
> +
>  static const struct kvm_sbi_fwft_feature features[] = {
> +	{
> +		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
> +		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
> +		.set = kvm_sbi_fwft_set_misaligned_delegation,
> +		.get = kvm_sbi_fwft_get_misaligned_delegation,
> +	}

nit: Please add a trailing comma here as future patches will extend the array.

Regards,
Samuel

>  };
>  
>  static struct kvm_sbi_fwft_config *


