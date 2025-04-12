Return-Path: <kvm+bounces-43191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB89AA86CEC
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 14:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C11998A8537
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 12:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56FE01DE4EC;
	Sat, 12 Apr 2025 12:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Twp87jkd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA7213AD1C
	for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 12:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744461421; cv=none; b=icIou/Fn1lxgGCb7L/OU++XyFhu1Fijv4do3sTakSbohX0+oifktkQY1Iot6m0xv29j/qc19ygxUJ3LuhiipjmwXR0s0aMS5j2CD9b0PxNknriRSzsVypHXPkpsCPwNNt1fM0XahR1SBsGCHzMybeujLXOG4iYlEPpVRIIzh3Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744461421; c=relaxed/simple;
	bh=0LAueQaBDKSWIRcDEzuEMT6tJ7UKMu6JeVDIHdjFXzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSUUZX5NmwB5UgFmpCLq2m3bk+PYkSQEclPXZBxkxcTr3o5ex6opsRvKK9XECC1/aqjZaAjav2IileglK/YHMS3Nexr+PzJYbyr5SGfT9W50GUpVsza/Yzabk/JKfeuGKBGFrfds1MYOKZQ3rYAbtsA950AKM3tcaqU/aCwKLQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Twp87jkd; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43d04ea9d9aso13859165e9.3
        for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 05:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1744461418; x=1745066218; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/1tdUSTul8z3uG62hCB/hUKnbhFABs23IMaLfOAkzGc=;
        b=Twp87jkdjttDvwr8FphT0UChAXm43kUC18MSEGGqegBfPEjx5zN7ZGjhSCjh9RDE41
         Xhh7jH39vr95U9nrkKDchRtFwTWYxve+uJfe1WNbZ3tJOaVHAx3fgJHgLrfnUUHSZV7z
         yoqnYJgtxEXOziO+IPh+e6mTIuzbUOLmiJ0MbA9ze7IKz8obb7aVN7qI4LygXBi5EVbY
         uZ892e6/Xo6+R5IRAH6OSZ/QjJz7kJxdhsY/NUQibZ6IAF3mrZEpCr61JgHlqnxauWEB
         Ug1prkFRAoa4eKOcuGPAo+NlYWDCw0EeNP+BXcrUB4XWD6p9Q1/vl4Y8diuj1K0tMqc5
         YwyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744461418; x=1745066218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/1tdUSTul8z3uG62hCB/hUKnbhFABs23IMaLfOAkzGc=;
        b=liNosCVVLBHj5BmakE8rv6v7Iz1A6md5Js9xDCNjJNR3Wx1pckw3bQw61j4T1y/Uk9
         TQUTNS3+MipvZ5aPtznKYpPhhuTJxCQP4OGLcf3rn1MHdrFoT32i3zOFFDrhytZEfvGX
         mW/4NChsTSwWplT8WWNKotUY1J8A/I9A1G+y0rR4QyzWYWs1yAcwtH9n84tGR2dmbB3V
         6sJmyAJljTnW8NgGvsBukLnos7XCAbBvBs4sLXYSFO04tCY70tKG084sL+yZ6kziasmA
         3pw9sBtk7E0kjutlYLZuWUgu6h3de9fh+lm+45z9j0aIk/oXacFLLLp9HCKiaa6l9YA5
         CR4w==
X-Forwarded-Encrypted: i=1; AJvYcCWNr8BYrw07PjXHu4QECByCkhYh41Nd2P+YO2fnO05WW32/0izBoCvzW2EVC6jSY7D5wE0=@vger.kernel.org
X-Gm-Message-State: AOJu0YysiUdaoDiIYryP+4rHFNxpGZSF14dsW4/sv7jE/EF8YhqvNdXH
	syDp30b5FPH/fmxFV7wc8ynC422SxmVv0i75PaGjGE5THUur6CbgE9XK2CBGang=
X-Gm-Gg: ASbGncuy7UktI+WTqtgaK0xHBDA2L6tikeLil7uTtiyLtRYcYcZb87kcsUyXeG0jEyJ
	EngAcH+bRARXHBHuVzQAkh75JDKR2UznaBXxTjN8Qov84gE6FAQCFNr1LpRLY1zDvQAe5R3S6oQ
	wxoWFwKELppk8FJfqeGIhReR+iqy9yBCMqMxn0p8BG57/iUqzA3tZm9QTwtvXNhC2sYseyFu4Rp
	de19vu2aUr5Cq6BzgoywxXQq4YUJHAnWPV4S59VBdXCUk0PMcJMpGwZYBrXvAUthgBDGREG44dQ
	qyxeDs3G4Ic3mJi4HJHZjx9PPtl3GLCqwyJZ5d5qNRjAQa7gFmzh9KZeTqyapMRHJ2pYpg==
X-Google-Smtp-Source: AGHT+IFWJhMIxLAuhZFAH4iIc1JQxXlXQ42GIrirxlIB2AWxuYEwvVobTKAyVC9cwelW41i1/PuHVA==
X-Received: by 2002:a05:600c:4f90:b0:43c:f689:dd with SMTP id 5b1f17b1804b1-43f3a95aeb3mr16009775e9.19.1744461417526;
        Sat, 12 Apr 2025 05:36:57 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2338d6ebsm119063895e9.2.2025.04.12.05.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 05:36:57 -0700 (PDT)
Date: Sat, 12 Apr 2025 14:36:56 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 08/10] riscv: Include single-letter extensions in
 isa_info_arr[]
Message-ID: <20250412-bafd9ea6c4e3314f8da06a26@orel>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-9-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326065644.73765-9-apatel@ventanamicro.com>

On Wed, Mar 26, 2025 at 12:26:42PM +0530, Anup Patel wrote:
> Currently, the isa_info_arr[] only include multi-letter extensions but
> the KVM ONE_REG interface covers both single-letter and multi-letter
> extensions so extend isa_info_arr[] to include single-letter extensions.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c | 138 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 76 insertions(+), 62 deletions(-)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 251821e..46efb47 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -12,71 +12,81 @@
>  struct isa_ext_info {
>  	const char *name;
>  	unsigned long ext_id;
> +	bool multi_letter;
>  };
>  
>  struct isa_ext_info isa_info_arr[] = {
> -	/* sorted alphabetically */
> -	{"smnpm", KVM_RISCV_ISA_EXT_SMNPM},
> -	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN},
> -	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
> -	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF},
> -	{"ssnpm", KVM_RISCV_ISA_EXT_SSNPM},
> -	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
> -	{"svade", KVM_RISCV_ISA_EXT_SVADE},
> -	{"svadu", KVM_RISCV_ISA_EXT_SVADU},
> -	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
> -	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
> -	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
> -	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
> -	{"zabha", KVM_RISCV_ISA_EXT_ZABHA},
> -	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
> -	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
> -	{"zba", KVM_RISCV_ISA_EXT_ZBA},
> -	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
> -	{"zbc", KVM_RISCV_ISA_EXT_ZBC},
> -	{"zbkb", KVM_RISCV_ISA_EXT_ZBKB},
> -	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
> -	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
> -	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
> -	{"zca", KVM_RISCV_ISA_EXT_ZCA},
> -	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
> -	{"zcd", KVM_RISCV_ISA_EXT_ZCD},
> -	{"zcf", KVM_RISCV_ISA_EXT_ZCF},
> -	{"zcmop", KVM_RISCV_ISA_EXT_ZCMOP},
> -	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
> -	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
> -	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
> -	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
> -	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
> -	{"ziccrse", KVM_RISCV_ISA_EXT_ZICCRSE},
> -	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
> -	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
> -	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
> -	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
> -	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL},
> -	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
> -	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
> -	{"zimop", KVM_RISCV_ISA_EXT_ZIMOP},
> -	{"zknd", KVM_RISCV_ISA_EXT_ZKND},
> -	{"zkne", KVM_RISCV_ISA_EXT_ZKNE},
> -	{"zknh", KVM_RISCV_ISA_EXT_ZKNH},
> -	{"zkr", KVM_RISCV_ISA_EXT_ZKR},
> -	{"zksed", KVM_RISCV_ISA_EXT_ZKSED},
> -	{"zksh", KVM_RISCV_ISA_EXT_ZKSH},
> -	{"zkt", KVM_RISCV_ISA_EXT_ZKT},
> -	{"ztso", KVM_RISCV_ISA_EXT_ZTSO},
> -	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB},
> -	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC},
> -	{"zvfh", KVM_RISCV_ISA_EXT_ZVFH},
> -	{"zvfhmin", KVM_RISCV_ISA_EXT_ZVFHMIN},
> -	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB},
> -	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG},
> -	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED},
> -	{"zvknha", KVM_RISCV_ISA_EXT_ZVKNHA},
> -	{"zvknhb", KVM_RISCV_ISA_EXT_ZVKNHB},
> -	{"zvksed", KVM_RISCV_ISA_EXT_ZVKSED},
> -	{"zvksh", KVM_RISCV_ISA_EXT_ZVKSH},
> -	{"zvkt", KVM_RISCV_ISA_EXT_ZVKT},
> +	/* single-letter */
> +	{"a", KVM_RISCV_ISA_EXT_A, false},
> +	{"c", KVM_RISCV_ISA_EXT_C, false},
> +	{"d", KVM_RISCV_ISA_EXT_D, false},
> +	{"f", KVM_RISCV_ISA_EXT_F, false},
> +	{"h", KVM_RISCV_ISA_EXT_H, false},
> +	{"i", KVM_RISCV_ISA_EXT_I, false},
> +	{"m", KVM_RISCV_ISA_EXT_M, false},
> +	{"v", KVM_RISCV_ISA_EXT_V, false},
> +	/* multi-letter sorted alphabetically */
> +	{"smnpm", KVM_RISCV_ISA_EXT_SMNPM, true},
> +	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN, true},
> +	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA, true},
> +	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF, true},
> +	{"ssnpm", KVM_RISCV_ISA_EXT_SSNPM, true},
> +	{"sstc", KVM_RISCV_ISA_EXT_SSTC, true},
> +	{"svade", KVM_RISCV_ISA_EXT_SVADE, true},
> +	{"svadu", KVM_RISCV_ISA_EXT_SVADU, true},
> +	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL, true},
> +	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT, true},
> +	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT, true},
> +	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC, true},
> +	{"zabha", KVM_RISCV_ISA_EXT_ZABHA, true},
> +	{"zacas", KVM_RISCV_ISA_EXT_ZACAS, true},
> +	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS, true},
> +	{"zba", KVM_RISCV_ISA_EXT_ZBA, true},
> +	{"zbb", KVM_RISCV_ISA_EXT_ZBB, true},
> +	{"zbc", KVM_RISCV_ISA_EXT_ZBC, true},
> +	{"zbkb", KVM_RISCV_ISA_EXT_ZBKB, true},
> +	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC, true},
> +	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX, true},
> +	{"zbs", KVM_RISCV_ISA_EXT_ZBS, true},
> +	{"zca", KVM_RISCV_ISA_EXT_ZCA, true},
> +	{"zcb", KVM_RISCV_ISA_EXT_ZCB, true},
> +	{"zcd", KVM_RISCV_ISA_EXT_ZCD, true},
> +	{"zcf", KVM_RISCV_ISA_EXT_ZCF, true},
> +	{"zcmop", KVM_RISCV_ISA_EXT_ZCMOP, true},
> +	{"zfa", KVM_RISCV_ISA_EXT_ZFA, true},
> +	{"zfh", KVM_RISCV_ISA_EXT_ZFH, true},
> +	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN, true},
> +	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM, true},
> +	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ, true},
> +	{"ziccrse", KVM_RISCV_ISA_EXT_ZICCRSE, true},
> +	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR, true},
> +	{"zicond", KVM_RISCV_ISA_EXT_ZICOND, true},
> +	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR, true},
> +	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI, true},
> +	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL, true},
> +	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE, true},
> +	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM, true},
> +	{"zimop", KVM_RISCV_ISA_EXT_ZIMOP, true},
> +	{"zknd", KVM_RISCV_ISA_EXT_ZKND, true},
> +	{"zkne", KVM_RISCV_ISA_EXT_ZKNE, true},
> +	{"zknh", KVM_RISCV_ISA_EXT_ZKNH, true},
> +	{"zkr", KVM_RISCV_ISA_EXT_ZKR, true},
> +	{"zksed", KVM_RISCV_ISA_EXT_ZKSED, true},
> +	{"zksh", KVM_RISCV_ISA_EXT_ZKSH, true},
> +	{"zkt", KVM_RISCV_ISA_EXT_ZKT, true},
> +	{"ztso", KVM_RISCV_ISA_EXT_ZTSO, true},
> +	{"zvbb", KVM_RISCV_ISA_EXT_ZVBB, true},
> +	{"zvbc", KVM_RISCV_ISA_EXT_ZVBC, true},
> +	{"zvfh", KVM_RISCV_ISA_EXT_ZVFH, true},
> +	{"zvfhmin", KVM_RISCV_ISA_EXT_ZVFHMIN, true},
> +	{"zvkb", KVM_RISCV_ISA_EXT_ZVKB, true},
> +	{"zvkg", KVM_RISCV_ISA_EXT_ZVKG, true},
> +	{"zvkned", KVM_RISCV_ISA_EXT_ZVKNED, true},
> +	{"zvknha", KVM_RISCV_ISA_EXT_ZVKNHA, true},
> +	{"zvknhb", KVM_RISCV_ISA_EXT_ZVKNHB, true},
> +	{"zvksed", KVM_RISCV_ISA_EXT_ZVKSED, true},
> +	{"zvksh", KVM_RISCV_ISA_EXT_ZVKSH, true},
> +	{"zvkt", KVM_RISCV_ISA_EXT_ZVKT, true},

nit: I think I would add a 'misa' boolean member instead of 'multi_letter'
and then rework this table to look like this

	{"a",		KVM_RISCV_ISA_EXT_A, .misa = true	},
	{"c",		KVM_RISCV_ISA_EXT_C, .misa = true	},
	{"d",		KVM_RISCV_ISA_EXT_D, .misa = true	},
	{"f",		KVM_RISCV_ISA_EXT_F, .misa = true	},
	{"h",		KVM_RISCV_ISA_EXT_H, .misa = true	},
	{"i",		KVM_RISCV_ISA_EXT_I, .misa = true	},
	{"m",		KVM_RISCV_ISA_EXT_M, .misa = true	},
	{"v",		KVM_RISCV_ISA_EXT_V, .misa = true	},

	/* multi-letter sorted alphabetically */
	{"smnpm",	KVM_RISCV_ISA_EXT_SMNPM,		},
	{"smstateen",	KVM_RISCV_ISA_EXT_SMSTATEEN,		},
	...

The benefit is that only the misa extensions need another field.

>  };
>  
>  static void dump_fdt(const char *dtb_file, void *fdt)
> @@ -129,6 +139,10 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>  		}
>  
>  		for (i = 0; i < arr_sz; i++) {
> +			/* Skip single-letter extensions since these are taken care */

We should finish the comment with 'of by "whatever takes care of them"'

> +			if (!isa_info_arr[i].multi_letter)
> +				continue;
> +
>  			reg.id = RISCV_ISA_EXT_REG(isa_info_arr[i].ext_id);
>  			reg.addr = (unsigned long)&isa_ext_out;
>  			if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> -- 
> 2.43.0
>

Thanks,
drew

