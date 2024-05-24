Return-Path: <kvm+bounces-18112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA768CE442
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 12:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59EEF1C2163E
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 10:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A108625A;
	Fri, 24 May 2024 10:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Izdjb+t3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A9185C74
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 10:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716546810; cv=none; b=qx1FabSUsG9Cb0wfV/8yujMKtEqzc0jGbrXSxFY1rwHJWkzwdxwdvM3RF0b1qj6tFJ5Z/x1LsGndUagrByHQRtHRJDAOp2ICdwX8q6dm3YQP/bL4rE7YYoCDg+7O8ABzQkYML17E/DrtC3ql3irIi2NBuO42Ku/MppwfLvQQkwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716546810; c=relaxed/simple;
	bh=s3bZSvbcC9wrgqNoKe/S6GdQv7f0Lxmp7zX/K+0Cw6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=br605MaFKWCZP10+ThQ5eg1sWPNFl4qiZk93ZcPE9YVg1HUyg+YKeIukOsAOKn1LEkX2qXLM7RkNzcLWA8nfAXQX7x3mBticz6bG+rHWqqg1m+4aG4P3TlzWYU6QqTMP0HNeTEYELgYJw3ZecxMRXuKdMqa1YZz2UnT3xfdm9/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Izdjb+t3; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-354dfe54738so2100993f8f.3
        for <kvm@vger.kernel.org>; Fri, 24 May 2024 03:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1716546806; x=1717151606; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bezuu5Iyms0JAB/yOIWcVSdOFPDSfhBHlUlD06FMFZM=;
        b=Izdjb+t3O/ba3nYn5mabZkoYcgFeU0Qz971itnSdiSNh5pSIVeHwHqVZRaVB0ubHoO
         aO2fY+g2NXPX8VmrWkXEzib0wJ959WT3MWP5aY758nNFzifFnjs84+UjkqoHouEpYfca
         xp/VU7SzhXiBPyaAWCmbyzJ84DrJGPIVYVr4Lc/I1iX3TJrrCwe889NApuCMPt+RdIRW
         kO3WpbE2IGx3XfFQSe3dplJCgdjhPkuHwCneqAnPnWbZgmp1p4l3TIgGXmXG7DLeTg3o
         ++LX6Ubcnt9v1Fe+2t0Z0795RzRs2QM4iLULjx6Y29QK0x9zuBcozhQN3JYDbMX9gnpD
         XIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716546806; x=1717151606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bezuu5Iyms0JAB/yOIWcVSdOFPDSfhBHlUlD06FMFZM=;
        b=bMRti8wZZwhfju2bqA4gy7sbrokjZjpw80K0INVgZJxtm+CSVz/vNU+g2n7b9TyCUS
         vo3FUJZATVAz0waNStbOsCEnsCmTh7IhjMTzVpXBX5kaYCDLdXAMoFq9vAVZodJBjdh6
         7K06gmmwc5r7pQs/aA+6hpckHucu/JyyZiJpwDuxCpqha7odt/fRQHkBU4Ra2+bTYgLA
         MANq5ZIFxPyPIUWfbNOH/xzzEL3AalxiuDn88gxGUtck5ugxjbIIs+MZyAkyQgNaqdlP
         uiQs1JeK31xgIDBxiz2TeC6bF3yE8A4VNzhYa33hCv2a3QLe/iwffBHEkUHNRG9WmXvk
         MQ7A==
X-Forwarded-Encrypted: i=1; AJvYcCXeDj3BGqyfQdXGaPDw+4FFi/jgGMRsPK32+WqRO0Sv97yBZc54amhrNMPtYx+Hd5PvSnpJSKWa79GFKMvqZ7ChFAA3
X-Gm-Message-State: AOJu0YxCs/8FzyEampei8JIln+BbJrM4TcgvgxnLojWB7yeaQ9FIH5LA
	I26ed2SHeEQ+qLC1oXZhbNYIobKrAy8MAeBbhOBM0rAC/X5S1VH82bWxgcWg5Y8=
X-Google-Smtp-Source: AGHT+IEbf6NyprqrbPKmNzs6zKnnsPDzfVN11IuVqiVJZXo64JcMOu4TScsbATSjLLOyAitmdmWwjw==
X-Received: by 2002:a5d:598b:0:b0:356:4bb7:b205 with SMTP id ffacd0b85a97d-3564bb7b370mr374048f8f.1.1716546806244;
        Fri, 24 May 2024 03:33:26 -0700 (PDT)
Received: from localhost (cst2-173-81.cust.vodafone.cz. [31.30.173.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35579d7dd33sm1283459f8f.11.2024.05.24.03.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 03:33:25 -0700 (PDT)
Date: Fri, 24 May 2024 12:33:24 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Shaoqing Qin <qinshaoqing@bosc.ac.cn>
Cc: Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Bonzini <pbonzini@redhat.com>, Patra <atishp@atishpatra.org>, 
	Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Patel <apatel@ventanamicro.com>, =?utf-8?B?546L54S2?= <wangran@bosc.ac.cn>, 
	=?utf-8?B?5byg5YGl?= <zhangjian@bosc.ac.cn>
Subject: Re: [v2][kvmtool PATCH 1/1] riscv: Add zacas extension
Message-ID: <20240524-0b829950649ff4b154a57284@orel>
References: <228d4ce6.49.18fa881fced.Coremail.qinshaoqing@bosc.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <228d4ce6.49.18fa881fced.Coremail.qinshaoqing@bosc.ac.cn>

On Fri, May 24, 2024 at 10:50:42AM GMT, Shaoqing Qin wrote:
> Add parsing for Zacas ISA extension which was ratified recently in the
> riscv-zacas manual.
> The tests are based on the 6.9 version of the kernel
> 
> Signed-off-by: Shaoqing Qin <qinshaoqing@bosc.ac.cn>
> ---
> Changed from v1:
> 1. modify ZACAS enum number.
> 2. modify the code location,just for formatting.
> ---
>  riscv/fdt.c                         | 1 +
>  riscv/include/asm/kvm.h             | 1 +
>  riscv/include/kvm/kvm-config-arch.h | 3 +++
>  3 files changed, 5 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index cc8070d..6dfc25b 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -22,6 +22,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
>  	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
>  	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
> +	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
>  	{"zba", KVM_RISCV_ISA_EXT_ZBA},
>  	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
>  	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
> diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
> index 7499e88..6b2cbe7 100644
> --- a/riscv/include/asm/kvm.h
> +++ b/riscv/include/asm/kvm.h
> @@ -135,6 +135,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_ZBS,
>  	KVM_RISCV_ISA_EXT_ZICNTR,
>  	KVM_RISCV_ISA_EXT_ZICSR,
> +	KVM_RISCV_ISA_EXT_ZACAS,

This should be updated with util/update_headers.sh

>  	KVM_RISCV_ISA_EXT_ZIFENCEI,
>  	KVM_RISCV_ISA_EXT_ZIHPM,
>  	KVM_RISCV_ISA_EXT_SMSTATEEN,
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index e562d71..e5343a6 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -43,6 +43,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-svpbmt",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
>  		    "Disable Svpbmt Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-zacas",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
> +		    "Disable Zacas Extension"),			\
>  	OPT_BOOLEAN('\0', "disable-zba",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBA],	\
>  		    "Disable Zba Extension"),				\
> -- 
> 2.43.0

But, we don't need this patch since Zacas was posted along with Ztso here

https://lore.kernel.org/all/20240514054928.854419-1-apatel@ventanamicro.com/

Thanks,
drew

