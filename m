Return-Path: <kvm+bounces-32736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 68B119DB43B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 09:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFCACB22953
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 08:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096BE155A4E;
	Thu, 28 Nov 2024 08:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RrDl2oSw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718C5153838
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 08:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732783834; cv=none; b=t9r1ZnO8oKNYVFst2W/zpX3jSNO5k6kpDTi8WJxYTZqbIrs41hCG+Rrl8554DapU6Dj+98TrsCSK3tWGICag3lg/SvvVXTOqd5KKp69e0BM+UjnLe6itSr2bXrEEBEP21fekPvH6jWTqx56hsfI2c7O28DiabPsYFzRvTLU7zwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732783834; c=relaxed/simple;
	bh=B5t0AMedGldpOU0H3E5hI5JtAqjpENBbuqduwus8zS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I20AyrhesgNgCvkaqwWUpYUimCdAqUVfHKCgBPmbYAHqBEFYua3zmzXr8OYRCUVVXS51Scj57ltH8epVWefzW772/kvoM+EwbUuktBt2zw04TYmu6iUpvpIOOJkiA2ojMS5vJhrcRKgagz0/0Pe1v+tKQcIBTVuWwHgJfjstssQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RrDl2oSw; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3822ba3cdbcso391258f8f.0
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732783831; x=1733388631; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QECfFTmNEKncBrHJdBggIZG8ZqozV1xvM8dgwyM0qgs=;
        b=RrDl2oSwCnYEp7oECYNcxSauyK6XRiGyM3KuRBy3ZyDSkk2c0CRQpsJ5Z50dSA6p+x
         uyithzBEEtg4MTHMi9w23wtsmXKcpWvU3OWVgXXYLHtOmdUEeJ5pkl/Lnj8qLh1eJbNv
         xiz3b+WEaP+3EQ1wGHJp1ACfJcSuHn91+fkCjWKNmKFq6MOa6yBpjDm4xwvvqbAMYtYA
         olz5wssDge7gJWM2GFL0aqTf9frmn5uf2P3hzDjxRyd8jQCyBhvooqxSZy5rc6azqWVz
         iZixorUSExxUhIPW6MX30seFMulAJzAcSIrjh71rqCeb+m8I8CtizXwGCoKWNXmIa3Tb
         UJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732783831; x=1733388631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QECfFTmNEKncBrHJdBggIZG8ZqozV1xvM8dgwyM0qgs=;
        b=Ww/uNehdiBsDD4kpn/F0HkAfoPcv1vKgUWZFj1cUBKtv6XTyE/glKG90G6HMhE+tQ2
         Bo8mP2kddevWBHQ9M1D0DwDkNrR7EDpU0Kzzh7MDb/Eeeu/EvK1jl2QuoaT290l4tbm8
         e0ajG3izhq2+A2PXt2OWDDcMcezOTp03MfqMnwWLYDKORT4oe23kK0w+rlhI2kDu6xvB
         Vs+B1rgPOr76jorC5gD91Pt5Ap6Kixw41IrlfeMlVZvqOADlIbskdeGy5zH/xhb8GfcX
         IiB3gIcRJv0l4gjxKwUQx+8wpPhUrQ8OHIDG2mmWUSmOB3r20UhzeN+m74F05kzGgu24
         x8pg==
X-Forwarded-Encrypted: i=1; AJvYcCWpUKkSzZy9C3/cnELa+IIrgJXlgN2TTuvVaMawTo22s12mcPs3PyMYDNvDH/5G8F0Z3Ac=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcdcZWiCBm5EEf6uE9BSGJynIfMt6PB2QZs4jlGnQqp3YBekz+
	P1OPUDsM7fGop+WrtgUVo5gBTUiG99XssGYuX3qIWxcQLY3GdM9vJolI8RLXiAk=
X-Gm-Gg: ASbGnctBSDUGwcRqeQrWJbX9wUQQ0nGIVhihTaO9Uw0Ydh4J0ukOKNe39UP1qRtDbkN
	cir9bc8V9UAuI18WJzgYQTlMMuyfuLq01x9UaK5Lkl7KcLc6oy952PHkf7tOJNIiKtrOqdBWCMb
	N65MQwIXlmtQ+EoXjf/OZdcDGECryViu+2xa7hLLjxkGTg7Bv0kb25gIl5NP+s2BnRSo2jh4y0m
	EVEXnQ4vAvwUceKkvtdf9gI1iltv1tUSiv4MCnYRdzVsHfrlSrQLYIHEFuZ4Nbf5NkBvHfFn3Fe
	bkdV6lJaW74J0PBNKG5w676ROF9CR4qgiEk=
X-Google-Smtp-Source: AGHT+IG+6tIq/ymmeTyN+HZZy4E/zimUHRxIE/bdOFPe6GsuR8aMA9Q+PN66vVJzXIjP6nnnerBmMg==
X-Received: by 2002:a5d:6dab:0:b0:37d:9476:45f6 with SMTP id ffacd0b85a97d-385c6eb8e19mr5105817f8f.7.1732783830638;
        Thu, 28 Nov 2024 00:50:30 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0f7148fsm14832265e9.41.2024.11.28.00.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 00:50:30 -0800 (PST)
Date: Thu, 28 Nov 2024 09:50:29 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 1/4] RISC-V: KVM: Allow Svvptc extension for Guest/VM
Message-ID: <20241128-1e20d2226e4be72c121df6fc@orel>
References: <cover.1732762121.git.zhouquan@iscas.ac.cn>
 <35d9c91a69ebcb81b40dc4f7f51e290c3d94b2d9.1732762121.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35d9c91a69ebcb81b40dc4f7f51e290c3d94b2d9.1732762121.git.zhouquan@iscas.ac.cn>

On Thu, Nov 28, 2024 at 11:21:15AM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Svvptc extension for Guest/VM.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 4f24201376b1..9db33f52f56e 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -177,6 +177,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZAWRS,
>  	KVM_RISCV_ISA_EXT_SMNPM,
>  	KVM_RISCV_ISA_EXT_SSNPM,
> +	KVM_RISCV_ISA_EXT_SVVPTC,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 5b68490ad9b7..67965feb5b74 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -41,6 +41,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(SSNPM),
>  	KVM_ISA_EXT_ARR(SSTC),
>  	KVM_ISA_EXT_ARR(SVINVAL),
> +	KVM_ISA_EXT_ARR(SVVPTC),

Alphabetic order, please.

>  	KVM_ISA_EXT_ARR(SVNAPOT),
>  	KVM_ISA_EXT_ARR(SVPBMT),
>  	KVM_ISA_EXT_ARR(ZACAS),
> @@ -135,6 +136,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_SSNPM:
>  	case KVM_RISCV_ISA_EXT_SSTC:
>  	case KVM_RISCV_ISA_EXT_SVINVAL:
> +	case KVM_RISCV_ISA_EXT_SVVPTC:

Same comment as above.

>  	case KVM_RISCV_ISA_EXT_SVNAPOT:
>  	case KVM_RISCV_ISA_EXT_ZACAS:
>  	case KVM_RISCV_ISA_EXT_ZAWRS:
> -- 
> 2.34.1
> 

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew

