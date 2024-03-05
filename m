Return-Path: <kvm+bounces-11007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DC88720CF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7701B2592F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542798612C;
	Tue,  5 Mar 2024 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DwEYo5Fz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69F1762DF
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646677; cv=none; b=jk1g0nrNJik2AhDmXczXn3grhyvHfQYOByQlFIVxtytP2h1gi0w68ycc5tBU1irtCkKAClXriMQwh37NRfbo5oe5MfzAG/qnC1gvkKibOxxJuMkTfnFWCPv00wrFBah3hg9faGgDeN3CfcfMd66mXepNPncRSgTNmQFREkQEbNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646677; c=relaxed/simple;
	bh=ZSVAWeBbn48sJqHBkZbP/qtS8dLpjYyVczvukpL94Hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRUji4Sa0KlA6NtbkX8Df16HsyM+u0jxpPBPMd9XQ52tkyO//0Jkd/Y/rDWBnwzimMmKngcZ7QrJfWpfz02bUf9oupSji4h2qOmM2IGxuvvNMKvvgWiL/lee8qROZEXZ2TU2nNyqMCufKvpki+2VUhFWOIjlspFDWW0c5EdstAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DwEYo5Fz; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a293f2280c7so986300766b.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709646674; x=1710251474; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QoJySAlngTL38uqeHCkYgGQivhF2ClPZk87wMCtFNZ4=;
        b=DwEYo5Fzv/NH+iaREz+/3ALhvaxCEycK/CS9XfiBWLuyqJSDFgezVCOuY/Sq8fXYL1
         56n5GaBIy6he8+kp48M2qkP3xh1bEZtM3tRPuykLDC6Aznvhuq5f6Ucawy30MSKHYnKc
         7Ja+m5c4THbcFuahyTmqo8djpmJAQYerNaMJMjClt1Qs+Mal8fVNmO7eA+l+fnS7YvkZ
         yFFm8cD570B493Yvsszdo25IcvSy/ZsIqUXJDyLoa5d6Gvi8ojM3CklgAlUYwRVup2J1
         o4yQCEHIefpuRwpzXn0U/0MwKgKc+mRycPXWpfVMaSWYKgG90VKz9zZgvgIH/K9ZE9IK
         /53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646674; x=1710251474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QoJySAlngTL38uqeHCkYgGQivhF2ClPZk87wMCtFNZ4=;
        b=nEnKQIqnhQMMJmbY9dT4j2binQ9av+iYYRfS7sAiTLhKyoEBuy7SAJsA4mhGSvRb0J
         S+DsX9rtIH+OpSkRGDN1GrxKhu1LbiMs6cYodoK8ymNy2/5evuBOQESNOPMYmMQlpieY
         VJ4X+azKfgiqZhZjBkzhX5bxi4uJeGcQtogdhdo1ZgtoFUISm0CBwTdlNHM8esvgLStS
         4P4MzB5iDvMCeBnvkbIh+n/8P/UGu2gx6sZZqSDYlxTg+L+ejXpuDEewq9tkVGeDFsMl
         +QGgLtjQLH3VUr2zDPEVLnP/26trLtOl/l1gJTZyYTFRvAqSb31oshxoGBjnWudyVkhe
         gtKA==
X-Forwarded-Encrypted: i=1; AJvYcCUjBwy8XUbV3IRxmy69e95hLDTkL6qQmMo6yGLlT3KsJ08Vww1jb1U+iPanpFvEy2yY2L1T+1Y7fixEahIKWoKPmwI1
X-Gm-Message-State: AOJu0YzqrDoMMbHrLU3D5xR0kXIaJYMQPcqqr9NQ4yT766mcayjNWCKn
	u5jOTvYnesCLkQ/17E3xDUWY/CKeHlMObIfA6yCX78gwq2dc7qqcPmYNUkilfCY=
X-Google-Smtp-Source: AGHT+IFvYuR18xjfy26uWtfGzmi2SXw5QIpghWRnDEmGwMWyyTmRYUdhKnUsxfcA/tkNWh0kh1n/FQ==
X-Received: by 2002:a17:906:3b17:b0:a45:47c6:84d8 with SMTP id g23-20020a1709063b1700b00a4547c684d8mr3900936ejf.13.1709646674175;
        Tue, 05 Mar 2024 05:51:14 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id gc20-20020a170906c8d400b00a451d07711csm2916987ejb.82.2024.03.05.05.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 05:51:13 -0800 (PST)
Date: Tue, 5 Mar 2024 14:51:12 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 08/10] riscv: Add Zvfh[min] extensions support
Message-ID: <20240305-a214dac1647c2e16211736a9@orel>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
 <20240214122141.305126-9-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214122141.305126-9-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 05:51:39PM +0530, Anup Patel wrote:
> When the Zvfh[min] extensions are available expose it to the guest
> via device tree so that guest can use it.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 2 ++
>  riscv/include/kvm/kvm-config-arch.h | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 80e045d..005301e 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -49,6 +49,8 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
>  	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB},
>  	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC},
> +	{"zvfh", KVM_RISCV_ISA_EXT_ZVFH},
> +	{"zvfhmin", KVM_RISCV_ISA_EXT_ZVFHMIN},
>  	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB},
>  	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG},
>  	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED},
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index 2935c01..10ca3b8 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -124,6 +124,12 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zvbc",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVBC],	\
>  		    "Disable Zvbc Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zvfh",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVFH],	\
> +		    "Disable Zvfh Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zvfhmin",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVFHMIN],	\
> +		    "Disable Zvfhmin Extension"),			\
>  	OPT_BOOLEAN('\0', "disable-zvkb",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKB],	\
>  		    "Disable Zvkb Extension"),				\
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

