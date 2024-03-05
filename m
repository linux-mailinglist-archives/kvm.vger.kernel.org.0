Return-Path: <kvm+bounces-10982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F3C787204C
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40C141C22C44
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CFB285C6C;
	Tue,  5 Mar 2024 13:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KbWfAVby"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48AD85C45
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709645709; cv=none; b=Ohbi2aiBDiRZITgoaOpSHEx1LUWu+xYqxncxEaKClWcUEJIgyHO0q8x3qWV2a0nwt8GZadsXuAqyjskTIh3W1hZGLiQQukXcUP8vgCNNDpy8anA+lYdMRVdnOrOGDqBA81/axouqFhuDFrzLoDNBGXUOKLIgTTikl7ZavI3Pngs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709645709; c=relaxed/simple;
	bh=v7c1xsLMInn/5Mchbg4we+VnwJuPNzz5Azawwmq4BXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bypqhDtuPALOrWIoeDLphwzf2wFXWqUWcP9l7d03LUHVc1rP2cYxte5x6eCH11liaB1EEXgA3Sj3l5ZUBGYMgcv/2LF4soc+5Nm3pvQFL0pfesD8ntLvjlvj5T+tfHwn90wEL8ffhZMrgXcOLKFWg46jU35dIZ648n3dfNtISss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KbWfAVby; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a44ad785a44so474868366b.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709645706; x=1710250506; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ae4+Cp+l1bY4RKGHb6iJ6Of9BTh3GCN02weE9qYMRq0=;
        b=KbWfAVbygscMmPAEHW+Jl5Xd8WOKboMtwOtMLypCRXw8MfnycSGk7Cws1Vt0zPiEbL
         RpESpsUES9ExJ1py+jLZLIBVi0JhPSBbt015T9P3H3taHl4buf5Q/g1jrlVGdyR0D7Ci
         3WjkkM8qNLMDPa5dY/Krbd8k+Qq9y4dMQc7gghRpK/gHtrsmi6XWE58QAjCXB8MAq01q
         gA+YepLtDLJu49Vv7f042zbYg70IFgVoY77CC2IZ1TDPhdBJrI3J3wtsWtORZtcMZXnZ
         MNPiQrWpV4eD66wkgWnVpWKTdzI22FyIEM1xn5qp/dP0pR9zvHffR38F9Mq0p5xPK/7h
         iVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709645706; x=1710250506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ae4+Cp+l1bY4RKGHb6iJ6Of9BTh3GCN02weE9qYMRq0=;
        b=sOp4MfDJhtWpERNJ7TdYp4wP7LSsbWwvZPSosMbp+vXy0SfhSc+u5/e1aJuqu2eKR+
         mJRu9Eeuvm81e+mSmOtUGDCVpjTbBoxQpHgp7hDspuOCMRKCVqRK0kvBy4SxVswGpEcS
         NTxDzxaumWUrqwYV5GtuaS+qG/jTkLM3BU6Jt1HCnmKx0NxHuDat4imazZSq3EFqEDZ0
         Tn3UzX1DiwHodz7K//fHLYUbQV08W0NXfRWtvmuXVdMWYA3nw1jcdDaZXAfVTSkqQGO4
         oyJmhVeViFge/c8ePlud50StSJhzFL1rVv2/XYcj2dgpvC/MXYbBa7nTu+Nv3ub72WKR
         Lmrg==
X-Forwarded-Encrypted: i=1; AJvYcCWi45vHe5gPpeW1Ja78p0zOBvm6KuA7u590kBC4hE8cHqsDNjVuiKDkrPE2/ZVlbmynqPAI8rbdCggAPMomKeeFMpdl
X-Gm-Message-State: AOJu0Yyj0LruPGW+RjS9V1+kH1zi5gf5I/oXUYnEB63mV2UOZDOkxXhx
	4lg+CHS5Xo7p7yXJAJ9p8dK/VbhQdBhyVWl05r+eSJ0Kj1T5MT6zQznPxWi1Cn4=
X-Google-Smtp-Source: AGHT+IFueuTAylL1tx9JB8wiH2uMPMK5gbhLA50sOBnahqRee7bniVhxGN24/qoLHwtOXwthJjARqA==
X-Received: by 2002:a17:907:174a:b0:a44:c1bf:a801 with SMTP id lf10-20020a170907174a00b00a44c1bfa801mr7174024ejc.17.1709645705985;
        Tue, 05 Mar 2024 05:35:05 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id x14-20020a170906710e00b00a45769e8e58sm1726285ejj.219.2024.03.05.05.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 05:35:05 -0800 (PST)
Date: Tue, 5 Mar 2024 14:35:04 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 03/10] riscv: Add Zbc extension support
Message-ID: <20240305-8f39b0950d3bcdfd44e0cbe0@orel>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
 <20240214122141.305126-4-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214122141.305126-4-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 05:51:34PM +0530, Anup Patel wrote:
> When the Zbc extension is available expose it to the guest
> via device tree so that guest can use it.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 1 +
>  riscv/include/kvm/kvm-config-arch.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 8485acf..84b6087 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -24,6 +24,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
>  	{"zba", KVM_RISCV_ISA_EXT_ZBA},
>  	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
> +	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
>  	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
>  	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
>  	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index d2fc2d4..6d09eee 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -49,6 +49,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zbb",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBB],	\
>  		    "Disable Zbb Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zbc",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBC],	\
> +		    "Disable Zbc Extension"),				\
>  	OPT_BOOLEAN('\0', "disable-zbs",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
>  		    "Disable Zbs Extension"),				\
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

