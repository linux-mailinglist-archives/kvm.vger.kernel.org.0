Return-Path: <kvm+bounces-23602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AF6694B7B0
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 09:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4209C28B9B3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 07:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14A6189524;
	Thu,  8 Aug 2024 07:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AB8LuRzy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EAF18950E
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 07:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723101608; cv=none; b=WrEoZrn+iBYG6kKevpZD2z/dF68ZiKUM7XyTjGQ4shX713CvfO15CenH7iJmDE08ITvt2EPLUCJ1ccgG8mcjYz1KhGEHIA9P7o8yy3fpeahYGrwMLoUJh4FsqtbpMyN8xJBPmmKQZf/Aj+ksgUyuhwFh7y9QFtX1ceNYXHRaxCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723101608; c=relaxed/simple;
	bh=b/kpH/3tmPauPmCl8Zu5mF23kdDNk69dX/Z2CiAKZro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/mryH5ubvcB4lW6GxH4SM67hthGFbj1/P7uCC5bx/e8rRShefntH4/EENW8cl51Lb/7MYn1PwJDGlcDfL0d1e4rhp6oq/2nwz/asf70Id0f4C4stKF9s5MM+mB6UQx/nlX8gyYPiZ+2Q7/9g5WWkTUoFT0V2qdM1/hKz1gaC4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AB8LuRzy; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-6e7e23b42c3so542916a12.1
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 00:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723101606; x=1723706406; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=61Dq28Nf3F9g5/Td//Ft/plKsDILKvExnLDG0dDTx/E=;
        b=AB8LuRzy29xI84BeiLd/4uq6HTCy7sClT09hQFyfBz1DjcFmbz5Xqd3qc6gQoOskys
         61cgOqMrtnPe3wjKLpC0OjGdRfs6WZpAGK1svRO3DwHaqF6ev+2vOBtzBk6enR01WAUW
         MFaSLPlLakAPPTXQDyhd3T1LZbnRIS+hBtxCHZDuPW3x8sNW4+bwSX5K7ai6VUIxvfiv
         5b+rpdfMiwwVHmbXIR1agDiXRb1lggvkpKw3GV724X7TkROv7dB5YH5hwjTmkuKQzzB1
         8+JpRxKFFiv86Xs8VBO4XIq88Txz6L/xA0eYXKnccAohz3GWcdGrkO8UOz1LqagU6gc/
         Gwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723101606; x=1723706406;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61Dq28Nf3F9g5/Td//Ft/plKsDILKvExnLDG0dDTx/E=;
        b=r2R3gg8SAgjpWsMDsYoIoUyiiufnAZwFdPSJ20UYoAgrzKIP+cf/lN1sA4lpRtvUI1
         aNC5wVKA1FmhNaZ/Jh87ln2R/Osb2Miysf+MgG7WCAwl1v3DsgAClUz3LVySNJ+EiCaQ
         ckw2vf06HtfvW8kDbU78gTx7OIN0T+G0YDAuzuXxh9wa8+FLGJNVdUbPDAzimgtUmBsW
         yy9v7sq5oGlPllq2uL7ryBd3vTQnQzn9nVQ1OWwfK8F1IkmAXW+D+QkLVr4LOzCtlVaz
         s7AZ3nnVlCyYazhnrlX7ex7r/RtXHOeRNfkhXbUvWaWNICCL8x+Maq6ZZCdxbXO9mrbv
         LbQA==
X-Forwarded-Encrypted: i=1; AJvYcCUQq+S4MC1kuGE00UJqS551EwZBT4WtaiEbGwWCyewVioIQgnFaRcU0KlxekucrAQe0MXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeEawnk4w+WEqU6PdeGmB5/+fkfSGuZNOgpZv1ZyNeZNNd72sF
	GYCkUmngl2P7WLb0f6Dbuc6YghiJ4zdLw/3rcvGWDwS453WI5Y3ksFbmMWfm8ZLFkjGka+Y1p+h
	0
X-Google-Smtp-Source: AGHT+IHVwhaQmB+d14u8C5u0Db/YHWcOUNGK2FDbdbISVxJ0Yl/Gk9DnzZRjMnbItZYZ8mQzqORc6A==
X-Received: by 2002:a05:6a21:328c:b0:1c4:986a:de71 with SMTP id adf61e73a8af0-1c6fcf82a90mr1091067637.35.1723101605996;
        Thu, 08 Aug 2024 00:20:05 -0700 (PDT)
Received: from localhost ([122.172.84.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710cb2e74fbsm572565b3a.168.2024.08.08.00.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 00:20:05 -0700 (PDT)
Date: Thu, 8 Aug 2024 12:50:03 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Arnd Bergmann <arnd@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Enforce dependency on an ARMv8.4-aware
 toolchain
Message-ID: <20240808072003.3r6cfgaxbcvayhrg@vireshk-i7>
References: <20240807115144.3237260-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807115144.3237260-1-maz@kernel.org>

On 07-08-24, 12:51, Marc Zyngier wrote:
> With the NV support of TLBI-range operations, KVM makes use of
> instructions that are only supported by binutils versions >= 2.30.
> 
> This breaks the build for very old toolchains.
> 
> Make KVM support conditional on having ARMv8.4 support in the
> assembler, side-stepping the issue.
> 
> Fixes: 5d476ca57d7d ("KVM: arm64: nv: Add handling of range-based TLBI operations")
> Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
> Suggested-by: Arnd Bergmann <arnd@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 58f09370d17e..8304eb342be9 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -19,6 +19,7 @@ if VIRTUALIZATION
>  
>  menuconfig KVM
>  	bool "Kernel-based Virtual Machine (KVM) support"
> +	depends on AS_HAS_ARMV8_4
>  	select KVM_COMMON
>  	select KVM_GENERIC_HARDWARE_ENABLING
>  	select KVM_GENERIC_MMU_NOTIFIER

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>

(Build only).

-- 
viresh

