Return-Path: <kvm+bounces-43196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F32CA86D58
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 15:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C6EC189034D
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 13:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD4978C91;
	Sat, 12 Apr 2025 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OxtYueHu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A0B2B9BF
	for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 13:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744465586; cv=none; b=aRXGqdwS7gy8yuOVbB9cWflt2j+ncobfXk7xqCyysHvgzKoJbaiVW0XGfv0hKuerJY5PGRVOpj7wwvN1X/AKiaxS7QUSO42JwdlmO1BqKvHfSSC1cuxWV7h3ClzNeY7okiCuFK3dgZp/+351GA2C/zi3mpkdj5EztTMAKUnhl3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744465586; c=relaxed/simple;
	bh=cgctAH7hjHjJ+Mjbyiw3Ga2JKg8UcnJE8B56BNVUpHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WQM/O/fIpq/0qbaMqUpqIViBcJvGMm72tQuxP+K5d3GA6hIc/WDLa238sBBDD+Ll7anpXMXeEWcCSNPh7oFUwOVbv1w1p5FoClR1I/7JNQTB+GQARcsZNb11y5WNv0T7rcM6utUCiNwqjdtj8VIv2PgoBVCA1MyP7UfItGWmZXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=OxtYueHu; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so31274125e9.3
        for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 06:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1744465583; x=1745070383; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ItMj6JnKUsr/qeQhHS3wPbqAcg3n4FcqCoPgQhbG4k=;
        b=OxtYueHuDkJMI8xe3ajRp8fy0DgFdWG2zjYhAqv/pSfwHXotpbJ0QSiCtLSYJzMUEG
         PMVKF0xJlsFRkQGWGcCHzo87SG1dDFICzpUai65c6g35ILg3oyUDZkuHlSAHpqVVaUl+
         6vzh8/K6f3XUSR43zpcB66JTgiENdXzXFdOeHQ9gqSWlCTUxyRaquo+PCJJ8JEuQlm6k
         5hfYs9yw/4bZ34pxQc1KzWud8lrNoE5OOEoldYmxsaBD+JfUZvlRmMYEYMe8ZtDwLhyM
         Ke0ZtiSqOZYxU1Kq2Gh1qEeO+jpjwmy4uW3AB94Gf8fHp5x/Q3e1SKRzHvHnQw6BuYSJ
         lSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744465583; x=1745070383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ItMj6JnKUsr/qeQhHS3wPbqAcg3n4FcqCoPgQhbG4k=;
        b=ZZm9OvgTs8U+nMR15W5Lb+gs6tXACr3x8tupL6vmI8O7XxmkaUnbGJFPXpmrQcEcxc
         pg+MWCiJoOVy3s1GvQWjD7Ms5fp39KVftcsWSD4veZmxOpPoKuzjU7Fbz+CB3nDHFBSS
         MDkXbhIkij8bO/ZECj3x1Bzst8PhAUqO3k7TmajdTTaUZAs2YOiFhcPsi1LUEvpiuTG7
         ABZ0+sd5L1rrhXuR3raJKKT4RK9zDz2tQIhr9UU9F9/qeWWivavL1FYvscz5Qb88OApg
         n5yyyoYDNZAans6SLskhu7sWNoogGHelLXq53sZ2fJowvHnrOeLDO0cUmpEpEeGEfHzL
         VrNA==
X-Forwarded-Encrypted: i=1; AJvYcCVke4n7N54krRz6nApPR76cG8GGDcCC2qpVWAMWykje3jdUAcGB6mtE1vNbMDXDUll4qfw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7yiGnVUijq+0GIy3Wh72yjsAgN4R2hY5OM0GjT3ymUPyNUOuu
	X3AttJZ8DxnADq1cN8ck7xXYr2Uwlavpr8rC2MUPJc7C+hcfKqUSc5lfWnzsDUc=
X-Gm-Gg: ASbGncsdCKwa1sfvfKiEQ2w6OSLnIJAVigepp6h/1dyMqLmpWCfWxl3D3uxc6GL1CRH
	8y8AoAAkPy8K1Zg2MX6dK6NnUgq9JwtAdf87/eQizqnEa5VtA+1zy0oY8DEq2+st84vq2uj98f6
	yuA+A7g8BaWxP2ypYU0ZOjC7D5CDUenZLRfHzrOggchfTduyR1JukYVu6zJYSx+ZUhHpbB01n44
	CaRzJ9u6FKlxXP82UaDg03Fih/xxswS8bndpVAhVqlNwfBx7eZ//2IsCIe6WMzRR8FyhoOJBwIC
	Pk3ik46aenJrLx9ReOxCuEr5HXk020f+/t41tIPFvGMuuYMWQs8krmpIPPzJ0Vi++9lkAQ==
X-Google-Smtp-Source: AGHT+IGhIj51K0rBZGmzAELools4onnOSFFF+wLV9YmwrbiQoYSzdN6+y8+uscQg379NDDj7DXmFoQ==
X-Received: by 2002:a05:600c:354f:b0:43d:2230:300f with SMTP id 5b1f17b1804b1-43f3a7db98bmr54874755e9.0.1744465582816;
        Sat, 12 Apr 2025 06:46:22 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eaf447777sm5016740f8f.100.2025.04.12.06.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 06:46:22 -0700 (PDT)
Date: Sat, 12 Apr 2025 15:46:21 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 04/10] riscv: Add Ziccrse extension support
Message-ID: <20250412-85ac68d1bc912d739c511ccf@orel>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-5-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326065644.73765-5-apatel@ventanamicro.com>

On Wed, Mar 26, 2025 at 12:26:38PM +0530, Anup Patel wrote:
> When the Ziccrse extension is available expose it to the guest
> via device tree so that guest can use it.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 1 +
>  riscv/include/kvm/kvm-config-arch.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index ddd0b28..3ee20a9 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -48,6 +48,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
>  	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
>  	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
> +	{"ziccrse", KVM_RISCV_ISA_EXT_ZICCRSE},
>  	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
>  	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
>  	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index d86158d..5badb74 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -121,6 +121,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zicboz",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOZ],	\
>  		    "Disable Zicboz Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-ziccrse",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICCRSE],	\
> +		    "Disable Ziccrse Extension"),			\
>  	OPT_BOOLEAN('\0', "disable-zicntr",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICNTR],	\
>  		    "Disable Zicntr Extension"),			\
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

