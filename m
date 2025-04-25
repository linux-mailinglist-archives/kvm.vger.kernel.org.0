Return-Path: <kvm+bounces-44304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30BBFA9C8E8
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AF971BC68BE
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339E4248879;
	Fri, 25 Apr 2025 12:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="F2KNt6Ri"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0AF235C14
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745583955; cv=none; b=Jiz+LJLoyw6+PQd+kU0FHHWe5dBXszj/dWpYXBblhdKW6mym1OZsE+VswHsspCnOGcCUMF2HGHKSyXsm4EdjtJOtnQzNPPw+ivTps2mvoKoO873mlfBwbP06gPBxzWyjroaxvEQRJ9eGCWZhxDMnifhepKlHMFGyhS7bzt7NTPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745583955; c=relaxed/simple;
	bh=xDmAOpOqL3LygDbnUqk9t6TyvqUUPKkzdtgHRC+C+uU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlYU+bNBO7+j1iM+LgcRMnjJUvxsOkaWrvyKRltgrZjIH9LehsgohtqpxYbRDB0ZUWzhIq/jxziHo1e934KBIME7aHoQMufq3MrBSO0Vcsi1mhYHKO9trvNUl6FdIqxqgQ9HZ75hmTQ633LNjg22hAy5I35SuJ2tPptP77w/wMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=F2KNt6Ri; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39ac9aea656so2613043f8f.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745583952; x=1746188752; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E30j/Ju/tL1nRGU7lbNX0XTt8cr938jN8P3lGRQEHzc=;
        b=F2KNt6Ri+2Ru2Q5mhOpxTAjDE8VyV1XksrNNJPoQg7Vin9XBQneu8KCinMTk3e1nMT
         wwnRpQ7s4yuA7LIHFINRbloz3o8HSbA+VM9zEh3ukf/0xHSPo2CW3ke8WTb9De+rWT4/
         AzAfuSH4CfjL1zS+3Oo2Y4L8BChQ8rnOJfSZ7/GO7PAWr7LZWy/HlMtJiLhmvOHzWUYf
         Fq4CD3fv1eZ3+FZouu4D6zY6/1y3B2wQy8M05rdpo6cyFFhp3h0bg4WPEmbTrf19nh94
         PEzMhzWKKf/uLJSRxDo63W5DUqtXFQ/Lnp0KCPoEQpMguJ4UrT3cqCDN7Z6oUKJsabr8
         e/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745583952; x=1746188752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E30j/Ju/tL1nRGU7lbNX0XTt8cr938jN8P3lGRQEHzc=;
        b=J/tfLehL4ZEjU1V0XKJzZ8/DnMasFxpRfwJj3whVh1E7CHrOpFTIjfOjTpHsfINVLx
         MAcgos57TevWZ8qKFH9xVeSS/nCroomrdFO4maAzJSjEQ0/DEA0u9gvXN38+6UoNwqA/
         7ezMcO0pwrCIFCxOKM4Wqv0B7dlE4hRQxAN15rKZDZpMuct2f0UwrHZzMAVMWXbXsB5k
         8tV0CPuemqB0nt8AtKuWyR2BdXIBs674RCTeq6WrS42EP36Zb04U7MVhqvt/WTnRoiXx
         QjHIu6nJeCGXbOV8DbK0M78EFut2e5ySjoyOse/Dm6pdGPd+JoF6ZKUdgzeOpiMIttTp
         zcjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9GxiCYDykyf8mLj8uD1ZUpW+nLUcI6ckKdGwLY9qAHkwMmDb5BlpQRusrJbblK5ShJtg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVtfSap+5amV7aa0gNCapo2Wdld2IJswuYvMgOiV2PzT0j07/j
	J3hGa0ubmflaCe539OdTfj+HTF6uVLDnkN8GJKWAYz8NTynvhqgB0pkWSTDyQE0=
X-Gm-Gg: ASbGncsgFoS6Z8pUYf7g4kkhVkI6hS3o3zx1JZNkw5V5HlxT6tF21EUK29E/mQV1347
	B5aRZXutkDv3pukXq2glLYR3sr/MpTth5SFKn5JZk/2usLK6crbnZFp6kIN7Dy35uX20VtxkRa9
	rbSDmK+WhYUcVKsrnKiow8YslD20d81xVU1cKHZbCLs0lggX5rigwIE/fXuh2aVzNvCYUSn943v
	zVRsF/e3mOad8E8nDfwbNb4r1JArXYLYYea3c1ivdpopujegO6d2mFVQSpdpa91VLKoYacTRcUY
	V/yZ7rjlBqOpiI7Ns2L4ivHHvBmD
X-Google-Smtp-Source: AGHT+IGPKvkSQpqyUSmbPo9ZQDeLn7h8rGnb1gxwXGGZ5wV+kUMjXkxVSFOwVN9p+4UzxmM5ReoiEw==
X-Received: by 2002:a05:6000:1a8a:b0:39c:268e:ae04 with SMTP id ffacd0b85a97d-3a074d901cbmr1567706f8f.0.1745583951687;
        Fri, 25 Apr 2025 05:25:51 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d29b9cfsm55882455e9.1.2025.04.25.05.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:25:51 -0700 (PDT)
Date: Fri, 25 Apr 2025 14:25:50 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 09/10] riscv: Add cpu-type command-line option
Message-ID: <20250425-790f8e451d35a989332ab3ad@orel>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
 <20250424153159.289441-10-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424153159.289441-10-apatel@ventanamicro.com>

On Thu, Apr 24, 2025 at 09:01:58PM +0530, Anup Patel wrote:
> Currently, the KVMTOOL always creates a VM with all available
> ISA extensions virtualized by the in-kernel KVM module.
> 
> For better flexibility, add cpu-type command-line option using
> which users can select one of the available CPU types for VM.
> 
> There are two CPU types supported at the moment namely "min"
> and "max". The "min" CPU type implies VCPU with rv[64|32]imafdc
> ISA whereas the "max" CPU type implies VCPU with all available
> ISA extensions.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/aia.c                         |  2 +-
>  riscv/fdt.c                         | 68 +++++++++++++++++++++++++----
>  riscv/include/kvm/kvm-arch.h        |  2 +
>  riscv/include/kvm/kvm-config-arch.h | 10 +++++
>  4 files changed, 73 insertions(+), 9 deletions(-)
> 
> diff --git a/riscv/aia.c b/riscv/aia.c
> index 21d9704..cad53d4 100644
> --- a/riscv/aia.c
> +++ b/riscv/aia.c
> @@ -209,7 +209,7 @@ void aia__create(struct kvm *kvm)
>  		.flags = 0,
>  	};
>  
> -	if (kvm->cfg.arch.ext_disabled[KVM_RISCV_ISA_EXT_SSAIA])
> +	if (riscv__isa_extension_disabled(kvm, KVM_RISCV_ISA_EXT_SSAIA))
>  		return;
>  
>  	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &aia_device);
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index c741fd8..5d9b9bf 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -13,16 +13,17 @@ struct isa_ext_info {
>  	const char *name;
>  	unsigned long ext_id;
>  	bool single_letter;
> +	bool min_enabled;
>  };
>  
>  struct isa_ext_info isa_info_arr[] = {
>  	/* single-letter ordered canonically as "IEMAFDQCLBJTPVNSUHKORWXYZG" */
> -	{"i",		KVM_RISCV_ISA_EXT_I,	.single_letter = true},
> -	{"m",		KVM_RISCV_ISA_EXT_M,	.single_letter = true},
> -	{"a",		KVM_RISCV_ISA_EXT_A,	.single_letter = true},
> -	{"f",		KVM_RISCV_ISA_EXT_F,	.single_letter = true},
> -	{"d",		KVM_RISCV_ISA_EXT_D,	.single_letter = true},
> -	{"c",		KVM_RISCV_ISA_EXT_C,	.single_letter = true},
> +	{"i",		KVM_RISCV_ISA_EXT_I,	.single_letter = true, .min_enabled = true},
> +	{"m",		KVM_RISCV_ISA_EXT_M,	.single_letter = true, .min_enabled = true},
> +	{"a",		KVM_RISCV_ISA_EXT_A,	.single_letter = true, .min_enabled = true},
> +	{"f",		KVM_RISCV_ISA_EXT_F,	.single_letter = true, .min_enabled = true},
> +	{"d",		KVM_RISCV_ISA_EXT_D,	.single_letter = true, .min_enabled = true},
> +	{"c",		KVM_RISCV_ISA_EXT_C,	.single_letter = true, .min_enabled = true},
>  	{"v",		KVM_RISCV_ISA_EXT_V,	.single_letter = true},
>  	{"h",		KVM_RISCV_ISA_EXT_H,	.single_letter = true},
>  	/* multi-letter sorted alphabetically */
> @@ -89,6 +90,56 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"zvkt",	KVM_RISCV_ISA_EXT_ZVKT},
>  };
>  
> +static bool __isa_ext_disabled(struct kvm *kvm, struct isa_ext_info *info)
> +{
> +	if (kvm->cfg.arch.cpu_type == RISCV__CPU_TYPE_MIN &&
> +	    !info->min_enabled)
> +		return true;
> +
> +	return kvm->cfg.arch.ext_disabled[info->ext_id];
> +}
> +
> +static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa_ext_info *info)
> +{
> +	if (kvm->cfg.arch.cpu_type == RISCV__CPU_TYPE_MIN &&
> +	    !info->min_enabled)
> +		return false;
> +
> +	return true;
> +}
> +
> +bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
> +{
> +	struct isa_ext_info *info = NULL;
> +	unsigned long i;
> +
> +	for (i = 0; i < ARRAY_SIZE(isa_info_arr); i++) {
> +		if (isa_info_arr[i].ext_id == isa_ext_id) {
> +			info = &isa_info_arr[i];
> +		break;

indentation is off here

> +		}
> +	}
> +	if (!info)
> +		return true;
> +
> +	return __isa_ext_disabled(kvm, info);
> +}
> +
> +int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset)
> +{
> +	struct kvm *kvm = opt->ptr;
> +
> +	if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(arg) != 3)
> +		die("Invalid CPU type %s\n", arg);
> +
> +	if (!strcmp(arg, "max"))
> +		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MAX;
> +	else
> +		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MIN;
> +
> +	return 0;
> +}
> +
>  static void dump_fdt(const char *dtb_file, void *fdt)
>  {
>  	int count, fd;
> @@ -139,9 +190,10 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  				/* This extension is not available in hardware */
>  				continue;
>  
> -			if (kvm->cfg.arch.ext_disabled[isa_info_arr[i].ext_id]) {
> +			if (__isa_ext_disabled(kvm, &isa_info_arr[i])) {
>  				isa_ext_out = 0;
> -				if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
> +				if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0 &&
> +				    __isa_ext_warn_disable_failure(kvm, &isa_info_arr[i]))
>  					pr_warning("Failed to disable %s ISA exension\n",
>  						   isa_info_arr[i].name);
>  				continue;
> diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> index f0f469f..1bb2d32 100644
> --- a/riscv/include/kvm/kvm-arch.h
> +++ b/riscv/include/kvm/kvm-arch.h
> @@ -90,6 +90,8 @@ enum irqchip_type {
>  	IRQCHIP_AIA
>  };
>  
> +bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long ext_id);
> +
>  extern enum irqchip_type riscv_irqchip;
>  extern bool riscv_irqchip_inkernel;
>  extern void (*riscv_irqchip_trigger)(struct kvm *kvm, int irq,
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index 7e54d8a..6d9a29a 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -3,7 +3,13 @@
>  
>  #include "kvm/parse-options.h"
>  
> +enum riscv__cpu_type {
> +	RISCV__CPU_TYPE_MAX = 0,
> +	RISCV__CPU_TYPE_MIN
> +};
> +
>  struct kvm_config_arch {
> +	enum riscv__cpu_type cpu_type;
>  	const char	*dump_dtb_filename;
>  	u64		suspend_seconds;
>  	u64		custom_mvendorid;
> @@ -13,8 +19,12 @@ struct kvm_config_arch {
>  	bool		sbi_ext_disabled[KVM_RISCV_SBI_EXT_MAX];
>  };
>  
> +int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset);
> +
>  #define OPT_ARCH_RUN(pfx, cfg)						\
>  	pfx,								\
> +	OPT_CALLBACK('\0', "cpu-type", NULL, "min or max",		\
> +		     "Choose the cpu type (default is max).", riscv__cpu_type_parser, kvm),\
>  	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
>  		   ".dtb file", "Dump generated .dtb to specified file"),\
>  	OPT_U64('\0', "suspend-seconds",				\
> -- 
> 2.43.0
>

Other than the indentation issue,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

