Return-Path: <kvm+bounces-21906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3ED937176
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 02:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64618282186
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 00:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA0323A0;
	Fri, 19 Jul 2024 00:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="D4AgumoR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A06BECC
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 00:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721348527; cv=none; b=i/vxYrvRUbW2WuSRYwzeM0DM61Y6QD8x6GxV6JnGDL0v611G6q7AmriQcYrt/jCO5pB5DafbigYyLj76mXXfgbEnlUwZyvhM5nsuv2Xd3EPiYiqI+kZ5Nlo0gpubOJUzqYEZx5cm+klSof5f+Vjab7YdP6G5v1pYit5lhiu37U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721348527; c=relaxed/simple;
	bh=pHgqTGtSnIHhc3JWuBlkLRK3QVusWeqEshmxIbO03Qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m/skElb3jSdPX3VANfJR+vSgVBB+m/iOGqGPGgtzgTCLKvMmr5yDGER6Ewuha7miucJsUCP3JpRW5suJJrUYJcQ0S3X5caoAeA2A0XYE6bFh7ie5HxmtnH63ICz2qBGYa/UK3cCOOkJD72sqxCmwZ4kZL1vtZoFYUg0Bv5gd948=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=D4AgumoR; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7fd3dbc01deso58837039f.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 17:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721348524; x=1721953324; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+uKIGXWYWIXloeHuuBuqBxGxPLL0P2YhrQYu7M9WpbQ=;
        b=D4AgumoREx5sQVOlIbnc/SqADcjb5zcwpuLHZiyStv4TyCI7e+ijeWK36/4xlkNmE3
         0N0FhksBkQDPOp66UTXsDAhyjM7zFcRMiZnMoq2t0hnzz44Iuo3hTLTpJDiGLsdmzozA
         p9yyZIyMyxcEo43qDTTFs538XCnfA/z8FPBcSBtRJt1tS3T5wEc0xsdf0vq8ODRMvHR7
         6sNxAXZfpdFfr6RIRW6Uv9JB6+XzNM61zrW1hS62KejZpL86D2rn1YlLRLFm8Z0fOj/s
         tRYdRC61hR7v+qJDJjdJuvbIm48HhfhVlxT2UgqOK906iwpCNgDwiJG9zOWjmgLQ2gEv
         qRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721348524; x=1721953324;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+uKIGXWYWIXloeHuuBuqBxGxPLL0P2YhrQYu7M9WpbQ=;
        b=tz0DDaEjljdBq+Fc/x4W1PNdlrTY4R/U6nd9WlN91viJ5kvdVLpPeIHR46I1FNcHBw
         VyqiG4PEPesfde7DbpnnxI3MlqTnhwMr6UTd/4g58r5Umm7D7rpJ5L9hc6/CjG52XPvy
         67/dwLfkUAiwLBonB7qySAyatnKvSHZAXxhX2W45ijiY8kZZ79VNOGhwEO6n068BIsvG
         aEfNE3Ymp1Hg1imBPMLXCM6fOm5ibChWEC2+66G8u15SLczVakLaG/4ErIxQNJS1wi2g
         aCFk5QjDq5Gu3Haupcf2qSOz7TwMf6wLZykyzxpioxpADASTv3cyJLjwM0tonkSjuZfI
         natQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTGvhdn+8pIpePloPL6IYkjv0sGuVDjuRZNrVVpPX8xXHuv/fjPb2AmmkuZgE8K0yTRGEcJi3kNXsTKCG98x0Tb9NU
X-Gm-Message-State: AOJu0Yx6vpbZX425l749hebXcRKH1IPTbJf/PivNNln8WwNcUF4tV2e+
	TpSzklQc3vsd+SXRmJLyd0GYBxQMNu4Cv792vYF8lpmf3E/uxJTv85y60gJMw7k=
X-Google-Smtp-Source: AGHT+IGZOYKaYajrW+wJeRqu8lvZxt7wFW370je39V0cIuR/Fg8Tkc/xud3IhBJspqPatG5aLX9hUg==
X-Received: by 2002:a05:6602:3fd2:b0:806:31ee:132 with SMTP id ca18e2360f4ac-81710137c5emr919977239f.4.1721348524401;
        Thu, 18 Jul 2024 17:22:04 -0700 (PDT)
Received: from [100.64.0.1] ([147.124.94.167])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c2343d2e8esm92265173.129.2024.07.18.17.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 17:22:03 -0700 (PDT)
Message-ID: <60555952-7307-41ed-bd6f-17a179089596@sifive.com>
Date: Thu, 18 Jul 2024 19:22:02 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/4] RISC-V: KVM: Add Svade and Svadu Extensions
 Support for Guest/VM
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: greentime.hu@sifive.com, vincent.chen@sifive.com,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
References: <20240712083850.4242-1-yongxuan.wang@sifive.com>
 <20240712083850.4242-4-yongxuan.wang@sifive.com>
Content-Language: en-US
From: Samuel Holland <samuel.holland@sifive.com>
In-Reply-To: <20240712083850.4242-4-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Yong-Xuan,

On 2024-07-12 3:38 AM, Yong-Xuan Wang wrote:
> We extend the KVM ISA extension ONE_REG interface to allow VMM tools to
> detect and enable Svade and Svadu extensions for Guest/VM. Since the
> henvcfg.ADUE is read-only zero if the menvcfg.ADUE is zero, the Svadu
> extension is available for Guest/VM and the Svade extension is allowed
> to disabledonly when arch_has_hw_pte_young() is true.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |  2 ++
>  arch/riscv/kvm/vcpu.c             |  3 +++
>  arch/riscv/kvm/vcpu_onereg.c      | 15 +++++++++++++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index e878e7cc3978..a5e0c35d7e9a 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -168,6 +168,8 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZTSO,
>  	KVM_RISCV_ISA_EXT_ZACAS,
>  	KVM_RISCV_ISA_EXT_SSCOFPMF,
> +	KVM_RISCV_ISA_EXT_SVADE,
> +	KVM_RISCV_ISA_EXT_SVADU,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 17e21df36cc1..64a15af459e0 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -540,6 +540,9 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
>  	if (riscv_isa_extension_available(isa, ZICBOZ))
>  		cfg->henvcfg |= ENVCFG_CBZE;
>  
> +	if (riscv_isa_extension_available(isa, SVADU))
> +		cfg->henvcfg |= ENVCFG_ADUE;

This is correct for now because patch 1 ensures the host (and therefore also the
guest) never has both Svade and Svadu available. When that changes, this check
will need to add an "&& !riscv_isa_extension_available(isa, SVADE)" condition so
it matches the behavior described in the DT binding. There's no need to resend
to make this addition, but if you do, it wouldn't hurt to include it so it's not
forgotten later. (It looks maybe like v6 only partially implemented Andrew's
suggestion?)

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>

> +
>  	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)) {
>  		cfg->hstateen0 |= SMSTATEEN0_HSENVCFG;
>  		if (riscv_isa_extension_available(isa, SSAIA))
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 62874fbca29f..474fdeafe9fe 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -15,6 +15,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cpufeature.h>
>  #include <asm/kvm_vcpu_vector.h>
> +#include <asm/pgtable.h>
>  #include <asm/vector.h>
>  
>  #define KVM_RISCV_BASE_ISA_MASK		GENMASK(25, 0)
> @@ -38,6 +39,8 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(SSAIA),
>  	KVM_ISA_EXT_ARR(SSCOFPMF),
>  	KVM_ISA_EXT_ARR(SSTC),
> +	KVM_ISA_EXT_ARR(SVADE),
> +	KVM_ISA_EXT_ARR(SVADU),
>  	KVM_ISA_EXT_ARR(SVINVAL),
>  	KVM_ISA_EXT_ARR(SVNAPOT),
>  	KVM_ISA_EXT_ARR(SVPBMT),
> @@ -105,6 +108,12 @@ static bool kvm_riscv_vcpu_isa_enable_allowed(unsigned long ext)
>  		return __riscv_isa_extension_available(NULL, RISCV_ISA_EXT_SSAIA);
>  	case KVM_RISCV_ISA_EXT_V:
>  		return riscv_v_vstate_ctrl_user_allowed();
> +	case KVM_RISCV_ISA_EXT_SVADU:
> +		/*
> +		 * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero.
> +		 * Guest OS can use Svadu only when host os enable Svadu.
> +		 */
> +		return arch_has_hw_pte_young();
>  	default:
>  		break;
>  	}
> @@ -167,6 +176,12 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	/* Extensions which can be disabled using Smstateen */
>  	case KVM_RISCV_ISA_EXT_SSAIA:
>  		return riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN);
> +	case KVM_RISCV_ISA_EXT_SVADE:
> +		/*
> +		 * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero.
> +		 * Svade is not allowed to disable when the platform use Svade.
> +		 */
> +		return arch_has_hw_pte_young();
>  	default:
>  		break;
>  	}


