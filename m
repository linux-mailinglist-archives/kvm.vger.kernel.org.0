Return-Path: <kvm+bounces-43195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBACEA86D57
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 15:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2B44189C65B
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 13:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F572B9BF;
	Sat, 12 Apr 2025 13:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="aXBwIKQb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72892367C1
	for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 13:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744465575; cv=none; b=sQbElJtw6W9OlCwZAKdVlnp8wNnBShkFMpFo8eZrVfG9fOgykh0sODwKBOgS9q6/xypCzzza0QdwK9faGTqs0TOkatr2KNy+nulJErUs7wjQ6c/CNrZKyD9FEzEo8Q44UxCp45a9cNCJt3MC85WEO+biYIPng/27VJSQMl5oiCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744465575; c=relaxed/simple;
	bh=JyUxxihd8AEuRPPdnS2IgKYpW0GEIHu1YzYBBX4M2Tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sS30KkO0V/OuWKqxUf1uql0JhCVXZelRxOVjtzN4g794U+6TxMC5v6+bomE+whcy3c7vNKnwLIUXJ+N4pPIxN1EzUxAAGjWGkXLWqM2tIJM/8DHspbYaSUSNkI06wnfDPhWet6ctotuDbrPZXkoV9HSEkcGKtYjMruwuD2hRzq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=aXBwIKQb; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so31273195e9.3
        for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 06:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1744465572; x=1745070372; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pitnifmNf4kMzEs+q5r7fxhBWT8usl06IrcAwntd8FM=;
        b=aXBwIKQb9KGbZj5zDO51rZG5zTzJLhr4pm7eIzIZ/6+f4pV7Q9mwH5BAZ/f0PHLz8w
         X5jKnDqjhAAnGwznmcDdUg3E1hw2fdJCIbiEro4+4vUJtyn+QG401Aeq2cCfBXU/6xkj
         fA8+BYEflWbw99PwIo2uxQawLq1lXl8JJVELjY0NxxOvw4nTwQzr0BYiL+f1nWq0JlKP
         BojL1B1NGeFXCg5ZOwpAfRS3vH22TolzIKAzHVPOEqIYlJhv+EKk3541a7EfZL1msQi9
         LPo8x6O1fGVQdOlxfEZqZTzA0k9MRsHdTdUv8zEpzB/2CFmv2qG4ueM23LuUQ1MgXgLf
         F1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744465572; x=1745070372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pitnifmNf4kMzEs+q5r7fxhBWT8usl06IrcAwntd8FM=;
        b=PLsCAvjypymvYmIQdDGSicWW0ras/qKfvweQakclkvC6g97TxtM0T+pT0tvuc6wPvV
         isogS1EseTTEt5lM+yWJpmSpoyUSixyfw+wzoMwZp9Em+muV+v/SSkhrC7EFygWJRAf7
         Fu5t0Phrrtol8sa2gK7ZJrEwj+dqqB8Tr42WVlH7K35QiX6jkNCr6X98S7rz3S8oJvCw
         A9bve6WD1qHwuZichkbLMU8v6p8OqrwUtLmQOd1VHhS2xubgn2Pck+V1D676nhNMutYd
         5sr19Pg9aJyY3qV+UeiFr7J0YgZuDnYTAJ3szbWqI22gT8ccnAN28hYJbV6TPLKEmSRj
         3udw==
X-Forwarded-Encrypted: i=1; AJvYcCVugvHcp8wBOU0d+Qoro7EUSl2bv5uA+wBOS0EBSB0Npu14l9TmRBsYImRolet04P7jqYw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt1d6+REx91YqxutZmz1hT1Fo9SQJ3M7Wy1cdH21xA4aR5pMA3
	SC/h8Fq9RKaOjwLM1EU1pxMkPy8rycmzePd8uxswlU+mWl+GWuDyG5QFdaaQvz0=
X-Gm-Gg: ASbGncvCbRQG8ncUBGcTbmEVu+LOQ4bviy/OqXnAtVb8u/itncu7zYVT+zDl3VIGGIO
	AmBjxHtRot2njTx4lPSmXOz6vvQklwntaRNkDznUmolF9wt9Ck7pMdESCzGMmntR74CG2tKlhV5
	/67Xx2UAtB0hqIkRObxt+eN+EXmXUU9HRZilB7c+IOYAfqbOwAtcotaJ6I5d1eYnP7mTkXnoHge
	xKqrFjQHfWG6AT3ht3q5OG7mVnjRLptc+/Qct/bKeaYJ+CqSLVZ45RTrEWCF60UUP1dbQM8SqGF
	BNTSjOgH09bpwDF/fg4ypfEHaWxyz3rXy64zSKsWGkBKCjkdQYJcsuMQ4c/i6gJJubFgig==
X-Google-Smtp-Source: AGHT+IEEfKZXQzF5xxNDAExHM/RckYjiaix54vXqc46g8bDQqlznMi+1kxTn/hVnb2+QbKsuB71RaQ==
X-Received: by 2002:a5d:6d82:0:b0:39c:141a:6c67 with SMTP id ffacd0b85a97d-39eaaed2101mr5690530f8f.45.1744465571790;
        Sat, 12 Apr 2025 06:46:11 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eae979637sm5176021f8f.53.2025.04.12.06.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 06:46:11 -0700 (PDT)
Date: Sat, 12 Apr 2025 15:46:10 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 03/10] riscv: Add Zabha extension support
Message-ID: <20250412-23464c54bfc11b04c8f4cefd@orel>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-4-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326065644.73765-4-apatel@ventanamicro.com>

On Wed, Mar 26, 2025 at 12:26:37PM +0530, Anup Patel wrote:
> When the Zabha extension is available expose it to the guest
> via device tree so that guest can use it.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 1 +
>  riscv/include/kvm/kvm-config-arch.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index c1e688d..ddd0b28 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -28,6 +28,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
>  	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
>  	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
> +	{"zabha", KVM_RISCV_ISA_EXT_ZABHA},
>  	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
>  	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
>  	{"zba", KVM_RISCV_ISA_EXT_ZBA},
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index ae01e14..d86158d 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -61,6 +61,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-svvptc",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVVPTC],	\
>  		    "Disable Svvptc Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-zabha",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZABHA],	\
> +		    "Disable Zabha Extension"),				\
>  	OPT_BOOLEAN('\0', "disable-zacas",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
>  		    "Disable Zacas Extension"),				\
> -- 
> 2.43.0
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

