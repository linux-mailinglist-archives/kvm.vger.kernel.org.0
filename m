Return-Path: <kvm+bounces-11004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C9D8720CA
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:49:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BB31B26C98
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583FA8612E;
	Tue,  5 Mar 2024 13:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Y4D7RTPS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D169D8612C
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646573; cv=none; b=MDv/u860OykSwUFmclEUQWB/o91VyvwsMMA0F8r7HXzr/0Vwab9HwsKu2YVFH2bYa4pFVYPcDhFditlTC+ZsGq8QQIt6Ottvv1LRZw9PmqK7jxSdzOGqfeXRVLifgpKFKKrYLNe8KG2wsziSS+t4nKFj+URuK4vvt41eKvRRMEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646573; c=relaxed/simple;
	bh=+3V5eIcJ7RSQ8h3FNPzN/1p2YaVeJWUj7M9dwSK3ruQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSEd3NOFA+yE0eDJK9CFy1abvcwmk8XUPGWUO82sPruVrm7DG6NrJHsVGgTuLsSQPnXcgpK8fdNE2srEeRExDQa76iD3CrvZcVN2O15UlkGerqYyrSvSjp/itywsE3OYd4ZSykgMXcAAp0p2CkDsYczaYa79Mk3GWJUzoINysC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Y4D7RTPS; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5131c0691feso7279145e87.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709646570; x=1710251370; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+lI5/WVef0AuqTIDyaS6nAGqzzuyjhmCVOul2HNGu74=;
        b=Y4D7RTPSG7mINKa4uGZbmVgSw/oWJqibpjjyPfdgO8xtviLc6cYVYXVHQcAF7J2dt1
         zcYr3Iv6pC0DnCGmNc2hlRoh7GU7sCFlZ0rDb46zc44HtuCrLGXHBbm9qqx/G14dlJCQ
         WIOaU8BubdIL1tEmkj7h4S6yn6eDb3uSVh6Kgch6XH3dPFxVgAxCsEmKE3585FBKWEqm
         h459QOPitq1Vq30k5xmYRQ06gonHE6tLJY8peWNZ/abMsc9fIAlbt/FHwwEGdVfjZRV4
         dcfG26bzPZKvpwwPSWjF9zsVfhCuTs3CAVU0fvpkfcO5jJGANeX12NgfrvqV40Kj8Rks
         FM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646570; x=1710251370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+lI5/WVef0AuqTIDyaS6nAGqzzuyjhmCVOul2HNGu74=;
        b=cnCUyEyxI5zZSK3TtRUkVezem9xSWvO+cykk7XrjLEKuN37dJvCvbbJ47gVC9g0L8P
         vMUdAF2LxVIHUhW5rvIFL1q4yp3Tu0vhIE/CQ0x+ycqvXiY2X5uO+iEnJe/bF0FAbjsB
         Vf3DJNeBwAy1qwMbvZqkC+7LeOvneAqHPn3GTrnQR8DbOlrn0nW2ltSN6EGbSBF/MHPB
         hhTlRWj3eZcB3A4KYsIC7fA4Ornx53lNMOHTBZTAFUfmYhTBhqes9/vFK9IjMgI3NC6e
         H1KiBm/psVHIA3KrDpnD+D+I4YsIag+8JutI890Wk7ANJ2fcx7HtE+43hW9/ITKs0F/I
         oFxg==
X-Forwarded-Encrypted: i=1; AJvYcCUZvy7AQ2N7PskF11VjwtgyW2K1MeL4hjYBNIKfVhe4NLNs1tgx7b/HS8Vv030oQ8Tr1Ae/hZfoZpvjlqpV9siMhXwB
X-Gm-Message-State: AOJu0YwWzxpCXDXrGf3uKt/Q2UnjYo+AHj48mYK6AbxHZD6Jyby031Ml
	mWUQCkMHrlghBCnTl2QnNYLOPe8D855H1vJooWsW+NvRkRQC5jPG/ioSH+hBbr0=
X-Google-Smtp-Source: AGHT+IHGWUZK33gMvH95RBE5HcWK8KOdrIHGU/Z4CewY5sUc3wKP4R2GBUPkSoVUNhEhWCpEMqZTOQ==
X-Received: by 2002:a19:ee04:0:b0:513:4ad1:d89f with SMTP id g4-20020a19ee04000000b005134ad1d89fmr1206974lfb.23.1709646569898;
        Tue, 05 Mar 2024 05:49:29 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id v23-20020a170906565700b00a455ff77e7bsm2054317ejr.88.2024.03.05.05.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 05:49:29 -0800 (PST)
Date: Tue, 5 Mar 2024 14:49:28 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 05/10] riscv: Add vector crypto extensions support
Message-ID: <20240305-c8b0107a805e1edca5fbe797@orel>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
 <20240214122141.305126-6-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214122141.305126-6-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 05:51:36PM +0530, Anup Patel wrote:
> When the vector extensions are available expose them to the guest
> via device tree so that guest can use it. This includes extensions
> Zvbb, Zvbc, Zvkb, Zvkg, Zvkned, Zvknha, Zvknhb, Zvksed, Zvksh,
> and Zvkt.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 10 ++++++++++
>  riscv/include/kvm/kvm-config-arch.h | 30 +++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index be87e9a..44058dc 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -44,6 +44,16 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"zksed", KVM_RISCV_ISA_EXT_ZKSED},
>  	{"zksh", KVM_RISCV_ISA_EXT_ZKSH},
>  	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
> +	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB},
> +	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC},
> +	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB},
> +	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG},
> +	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED},
> +	{"zvknha", KVM_RISCV_ISA_EXT_ZVKNHA},
> +	{"zvknhb", KVM_RISCV_ISA_EXT_ZVKNHB},
> +	{"zvksed", KVM_RISCV_ISA_EXT_ZVKSED},
> +	{"zvksh", KVM_RISCV_ISA_EXT_ZVKSH},
> +	{"zvkt", KVM_RISCV_ISA_EXT_ZVKT},
>  };
>  
>  static void dump_fdt(const char *dtb_file, void *fdt)
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index 3764d7c..ae648ce 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -109,6 +109,36 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zkt",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKT],	\
>  		    "Disable Zkt Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zvbb",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVBB],	\
> +		    "Disable Zvbb Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zvbc",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVBC],	\
> +		    "Disable Zvbc Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zvkb",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKB],	\
> +		    "Disable Zvkb Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zvkg",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKG],	\
> +		    "Disable Zvkg Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zvkned",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKNED],	\
> +		    "Disable Zvkned Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-zvknha",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKNHA],	\
> +		    "Disable Zvknha Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-zvknhb",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKNHB],	\
> +		    "Disable Zvknhb Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-zvksed",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKSED],	\
> +		    "Disable Zvksed Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-zvksh",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKSH],	\
> +		    "Disable Zvksh Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zvkt",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZVKT],	\
> +		    "Disable Zvkt Extension"),				\
>  	OPT_BOOLEAN('\0', "disable-sbi-legacy",				\
>  		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_V01],	\
>  		    "Disable SBI Legacy Extensions"),			\
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

