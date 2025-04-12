Return-Path: <kvm+bounces-43192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A66A86D28
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 15:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12D6419E7D50
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 13:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8A31D79A0;
	Sat, 12 Apr 2025 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="G6x2F6nf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32D9B666
	for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 13:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744463716; cv=none; b=MAXhlPylYcGSLRi+/LoTjujb0hT+nFEj6+UOrGwQRDtCkWwUSG2zHvICXZdSL0CO5FX6zqBdTE7zBMnv6CFh9k9HJGPkGC07J9YE3Drg32bZAtB9sObXntxWX0+5pUyEbCnwItnKuvYmPKt/I6QypuSvbzabhINUYM6ZtcLyF08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744463716; c=relaxed/simple;
	bh=GX3lgo9o1hiJfWCatVOflanvWz3ihcAqnWu/9noSrTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HO0GgS+q/DL3atYB8HJ45mVM4SVYD4cekCd8zJQK+8EOhgu2RTa//dV4K3BFB5OBcqLrcOgtZhcXkZlbHHmgYhKri+hAENQec/o6PJPmI1UQJEyWeASlft50Ks8KxGcAfSldUKUpBN8cXcLgjRy0FjcR6I0tiZ9JLB8d4gzYRwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=G6x2F6nf; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3965c995151so1258554f8f.1
        for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 06:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1744463712; x=1745068512; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vk9M9cv/yZtQ1Q/cI8rdvJlhirTLHRA9AIIrEpRwkgA=;
        b=G6x2F6nfzk1/+SfAh+j8cSDPISnmvuI0lrXLDCKbU7fQylbctH6tiSoWroTEaF2nrd
         WOqbvoXCZIgHFzRN3uy6itYrqMohHgoyVfemmxSUculU7m1rtNMV7FV3imabt1Kj3tRV
         fkI6QyWRdaJYYYspHVKcBCMVDVTgZBOemO+956DPNQrYNNuyWStWXvL5ryVBwvdmi5GK
         wAT6k6ibbsG/n/RdY82gNDS8ihHCCN/jnFwpWtOLTtdEL7kHvcE48bxi1MSWBr6YDKOw
         3i6D7uMM3RAesJyZ78Grc1oT9xj96PcdVFVKvsUcCmZZetIFuzJVf+DkGDknlWYFlMvo
         HLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744463712; x=1745068512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vk9M9cv/yZtQ1Q/cI8rdvJlhirTLHRA9AIIrEpRwkgA=;
        b=EUUw/cBWulYhmU1ENIbNKtynomlDG19ZKsuNKpQztJ/JuZBZLUO+QhOCqpKhAOKCTE
         /sGUeGNnXNfOtlQ33gBcYvZWq5I4by/LYhPt9JPI7umroyhqlNcG9za9JDclXhJrnC1D
         6ilEM/pPMKqnHqV1hGLBpc+nEnFXMUQOiHAeox3b8+hOMjh57ThcUHOTw0X65DPdI1Xd
         D4FGb1gBm88YRILQYxGneKrJbIVNevf3p/HPXfLVQXfwMxt2O9iv2YyFEp/1AogjzYpM
         EdIjXHHl8OKPkH3qndXmhD5942H3ou8KhD3LtHZ/zgNXhgiEC5ieRtX9k1X0Vuc+1WL1
         Lb2w==
X-Forwarded-Encrypted: i=1; AJvYcCXng2BBPyq9MqRNQ0kcMKfQjm4TV7jmtaJOqdTIMFJI9kSVLE59QWMxYRoIDaIDJfKML4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9FE3SXFiD01EOPdfwjhapUjqKtkFuCICSd6ah0Ow9OaGYZwxp
	FHj2xL02P0DmhEXPLnU1/Q1Xt/qQIu2VpBHppPkXYwFZba26Reo1og04n9AM4KY=
X-Gm-Gg: ASbGncs9FW4R0G1CCoq15sPXYeB1N3ljU3Qg/u59CW1YopwYnltfWM5g5MFTgAcrLhk
	y6uik+SOy6Xge+0rtqCjjBcrut++OoP7lNShde5kPhc/1PSw1KGiJ2vNh2dRM1OQJ2QfiXu87m3
	vdaK7RVRFOP4fTF9c4qkIaY7vjtXFrBTvMYuALhdCx7uAxt5OyRZ/cj/6qQ4KFIKtWoxo1fCE80
	MtNumOjZhETlZ34y7YH4+Hlj8NqeOOWCNDBzmQhaPPe4cpa7nLF/PqejrTciTv04st3E0J0K8hy
	8pxCKqIYpiVRvLy6gkircfMLvKb0vE2OS/eV7mD1fuutbb/8ObwbbP7R/KsFSvmFYzIm9g==
X-Google-Smtp-Source: AGHT+IE9OkevdIYrGwJunEmMap5IGHkQ2yzwRVq7OO6cwa+zFIHDZ9wb3Q5aKAqPtVNGxVyInCUcUg==
X-Received: by 2002:a05:6000:4305:b0:385:fd07:8616 with SMTP id ffacd0b85a97d-39e9f3c933amr4770129f8f.0.1744463711955;
        Sat, 12 Apr 2025 06:15:11 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eae96bf97sm4968707f8f.25.2025.04.12.06.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 06:15:11 -0700 (PDT)
Date: Sat, 12 Apr 2025 15:15:10 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 09/10] riscv: Add cpu-type command-line option
Message-ID: <20250412-6eb18b693df1bd8959bcdfc6@orel>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-10-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326065644.73765-10-apatel@ventanamicro.com>

On Wed, Mar 26, 2025 at 12:26:43PM +0530, Anup Patel wrote:
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
>  riscv/aia.c                         |   2 +-
>  riscv/fdt.c                         | 220 +++++++++++++++++-----------
>  riscv/include/kvm/kvm-arch.h        |   2 +
>  riscv/include/kvm/kvm-config-arch.h |   5 +
>  riscv/kvm.c                         |   2 +
>  5 files changed, 143 insertions(+), 88 deletions(-)
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
> index 46efb47..4c018c8 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -13,82 +13,134 @@ struct isa_ext_info {
>  	const char *name;
>  	unsigned long ext_id;
>  	bool multi_letter;
> +	bool min_cpu_included;
>  };
>  
>  struct isa_ext_info isa_info_arr[] = {
> -	/* single-letter */
> -	{"a", KVM_RISCV_ISA_EXT_A, false},
> -	{"c", KVM_RISCV_ISA_EXT_C, false},
> -	{"d", KVM_RISCV_ISA_EXT_D, false},
> -	{"f", KVM_RISCV_ISA_EXT_F, false},
> -	{"h", KVM_RISCV_ISA_EXT_H, false},
> -	{"i", KVM_RISCV_ISA_EXT_I, false},
> -	{"m", KVM_RISCV_ISA_EXT_M, false},
> -	{"v", KVM_RISCV_ISA_EXT_V, false},
> +	/* single-letter ordered canonically as "IEMAFDQCLBJTPVNSUHKORWXYZG" */

The comment change and the tabulation should go in the previous patch.

> +	{"i",		KVM_RISCV_ISA_EXT_I,		false, true},
> +	{"m",		KVM_RISCV_ISA_EXT_M,		false, true},
> +	{"a",		KVM_RISCV_ISA_EXT_A,		false, true},
> +	{"f",		KVM_RISCV_ISA_EXT_F,		false, true},
> +	{"d",		KVM_RISCV_ISA_EXT_D,		false, true},
> +	{"c",		KVM_RISCV_ISA_EXT_C,		false, true},
> +	{"v",		KVM_RISCV_ISA_EXT_V,		false, false},
> +	{"h",		KVM_RISCV_ISA_EXT_H,		false, false},

To avoid keeping track of which boolean means what (and taking my .misa
suggestion from the last patch), we can write these as, e.g.

  {"c",		KVM_RISCV_ISA_EXT_C, .misa = true, .min_enabled = true	},
  {"v",		KVM_RISCV_ISA_EXT_V, .misa = true,			},

(Also renamed min_cpu_included to min_enabled since it better matches
 the enabled/disabled concept we use everywhere else.)

And we don't need to change any of the multi-letter extension entries
since we're adding something false for them.

>  	/* multi-letter sorted alphabetically */
> -	{"smnpm", KVM_RISCV_ISA_EXT_SMNPM, true},
...
>  };
>  
> +static bool __isa_ext_disabled(struct kvm *kvm, struct isa_ext_info *info)
> +{
> +	if (!strncmp(kvm->cfg.arch.cpu_type, "min", 3) &&

kvm->cfg.arch.cpu_type can never be anything other than NULL, "min",
"max", so we can just use strcmp.

> +	    !info->min_cpu_included)
> +		return true;

If 'min_cpu_included' (or 'min_enabled') is all we plan to check for
whether or not an extension is enabled for the 'min' cpu type, then
we should write this as

 if (!strcmp(kvm->cfg.arch.cpu_type, "min"))
    return !info->min_enabled;

Otherwise when min_enabled is true we'd still check
kvm->cfg.arch.ext_disabled[info->ext_id].

> +
> +	return kvm->cfg.arch.ext_disabled[info->ext_id];
> +}
> +
> +static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa_ext_info *info)
> +{
> +	if (!strncmp(kvm->cfg.arch.cpu_type, "min", 3) &&

same strcmp comment

> +	    !info->min_cpu_included)
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
> +			break;
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
> +	if (!strncmp(arg, "max", 3))
> +		kvm->cfg.arch.cpu_type = "max";
> +
> +	if (!strncmp(arg, "min", 3))

We can use strcmp for these two checks since we already checked strlen
above. We also already know it's either 'min' or 'max' so we can just
check one and default to the other.

> +		kvm->cfg.arch.cpu_type = "min";
> +
> +	return 0;
> +}
> +
>  static void dump_fdt(const char *dtb_file, void *fdt)
>  {
>  	int count, fd;
> @@ -108,10 +160,8 @@ static void dump_fdt(const char *dtb_file, void *fdt)
>  #define CPU_NAME_MAX_LEN 15
>  static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  {
> -	int cpu, pos, i, index, valid_isa_len;
> -	const char *valid_isa_order = "IEMAFDQCLBJTPVNSUHKORWXYZG";
> -	int arr_sz = ARRAY_SIZE(isa_info_arr);
>  	unsigned long cbom_blksz = 0, cboz_blksz = 0, satp_mode = 0;
> +	int i, cpu, pos, arr_sz = ARRAY_SIZE(isa_info_arr);
>  
>  	_FDT(fdt_begin_node(fdt, "cpus"));
>  	_FDT(fdt_property_cell(fdt, "#address-cells", 0x1));
> @@ -131,18 +181,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  
>  		snprintf(cpu_isa, CPU_ISA_MAX_LEN, "rv%ld", vcpu->riscv_xlen);
>  		pos = strlen(cpu_isa);
> -		valid_isa_len = strlen(valid_isa_order);
> -		for (i = 0; i < valid_isa_len; i++) {
> -			index = valid_isa_order[i] - 'A';
> -			if (vcpu->riscv_isa & (1 << (index)))
> -				cpu_isa[pos++] = 'a' + index;
> -		}
>  
>  		for (i = 0; i < arr_sz; i++) {
> -			/* Skip single-letter extensions since these are taken care */
> -			if (!isa_info_arr[i].multi_letter)
> -				continue;
> -
>  			reg.id = RISCV_ISA_EXT_REG(isa_info_arr[i].ext_id);
>  			reg.addr = (unsigned long)&isa_ext_out;
>  			if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> @@ -151,9 +191,10 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  				/* This extension is not available in hardware */
>  				continue;
>  
> -			if (kvm->cfg.arch.ext_disabled[isa_info_arr[i].ext_id]) {
> +			if (__isa_ext_disabled(kvm, &isa_info_arr[i])) {
>  				isa_ext_out = 0;
> -				if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
> +				if ((ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0) &&

Unnecessary () around the first expression.

> +				     __isa_ext_warn_disable_failure(kvm, &isa_info_arr[i]))
>  					pr_warning("Failed to disable %s ISA exension\n",
>  						   isa_info_arr[i].name);
>  				continue;
> @@ -178,8 +219,13 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  					   isa_info_arr[i].name);
>  				break;
>  			}
> -			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "_%s",
> -					isa_info_arr[i].name);
> +
> +			if (isa_info_arr[i].multi_letter)
> +				pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "_%s",
> +						isa_info_arr[i].name);
> +			else
> +				pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "%s",
> +						isa_info_arr[i].name);

Can write this as

                        pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN - pos, "%s%s",
                                        isa_info_arr[i].misa ? "" : "_",
					isa_info_arr[i].name);

>  		}
>  		cpu_isa[pos] = '\0';
>  
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
> index 7e54d8a..26b1b50 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -4,6 +4,7 @@
>  #include "kvm/parse-options.h"
>  
>  struct kvm_config_arch {
> +	const char	*cpu_type;
>  	const char	*dump_dtb_filename;
>  	u64		suspend_seconds;
>  	u64		custom_mvendorid;
> @@ -13,8 +14,12 @@ struct kvm_config_arch {
>  	bool		sbi_ext_disabled[KVM_RISCV_SBI_EXT_MAX];
>  };
>  
> +int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset);
> +
>  #define OPT_ARCH_RUN(pfx, cfg)						\
>  	pfx,								\
> +	OPT_CALLBACK('\0', "cpu-type", kvm, "min or max",		\
> +		     "Choose the cpu type (default is max).", riscv__cpu_type_parser, kvm),\

I had to look ahead at the next patch to understand why we're setting kvm
as the opt pointer here. I think it should be added in the next patch
where it's used. Also, we don't use opt->value so we cna set that to NULL.

>  	OPT_STRING('\0', "dump-dtb", &(cfg)->dump_dtb_filename,		\
>  		   ".dtb file", "Dump generated .dtb to specified file"),\
>  	OPT_U64('\0', "suspend-seconds",				\
> diff --git a/riscv/kvm.c b/riscv/kvm.c
> index 1d49479..6a1b154 100644
> --- a/riscv/kvm.c
> +++ b/riscv/kvm.c
> @@ -20,6 +20,8 @@ u64 kvm__arch_default_ram_address(void)
>  
>  void kvm__arch_validate_cfg(struct kvm *kvm)
>  {
> +	if (!kvm->cfg.arch.cpu_type)
> +		kvm->cfg.arch.cpu_type = "max";
>  }

Hmm, seems like we're missing the right place for this. A validate
function shouln't be setting defaults. I think we should rename
kvm__arch_default_ram_address() to

  void kvm__arch_set_defaults(struct kvm_config *cfg)

and set cfg->ram_addr inside it. Then add the cpu_type default
setting to riscv's impl.

Thanks,
drew

>  
>  bool kvm__arch_cpu_supports_vm(void)
> -- 
> 2.43.0
> 

