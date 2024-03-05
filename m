Return-Path: <kvm+bounces-11006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0C68720CE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C934A1F2389A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAAA8593E;
	Tue,  5 Mar 2024 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="jyLM6Clq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED0D85642
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646628; cv=none; b=hAT2mTUHIzNjHrI+Dqy22tf9qpZGOR4Rv1xGjOEhRwHcJRaDhDMuUTLisUKjVgayfpLmW2uPaWPTOoI0ZCuyumQHqZiRCu6Pt/mPfR27AMvXJpYosl83/kz6EUL91Dz3IcDy2W9FbIMYZwK9K+3+B4ENz8Kf1aAPLtbMsEGdRXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646628; c=relaxed/simple;
	bh=E/6R7fQQEv9SwZl1OxEiKMEiWcspV/CtPEeC5/2W4xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZInum5EYASospA87Ew1dRjCnxigDZCwKgVCCmE0YiqlkLCPK+xXbG4PVJYTpO/5zLXD3fIsdYiZdWyyTOlhU4IOLCCdNNHgOFa1xke7hsD834YchQOQ//EYKFQ2ISYQuluCNxbxkyb1dPr9fHUkyO+xR22R9i5UM+GnrJkz2xTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=jyLM6Clq; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-565a3910f86so8508349a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709646625; x=1710251425; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eCAQ0R+giHUnO0JzFB7XbKEgNY7Y0hnBrpuPfjXwziw=;
        b=jyLM6ClqzxVur+Pdwn8QPtJSHlNH/h64o36TkASceKr6C9Rd6yJnYGnJ+YUztelbRO
         YGAnp8aoCnZXTikCOINhRB6OSZ3Rp1n2U7hz8agMWtcHJ7X+Rdf257hdRwB9pmMd4ac6
         IW9Z2HIblM7PQ92/lgUMqbmGntJfw/XI6pGM5StT4pMWKTiaikIs74RGNKxsUDYJ7lB9
         yNsLASdMpfYcNi+Huhknpc3GQgcmJg9HgNjJ8nKyCj1y+ATpnaDcZf/w2upTJn1Z/6T2
         l/rWRVwKcJTCGwexVLLDo8yWMHTwgEoik7OzNN9FRZV5OcMBWLWU5BpgFEHVd7H5KAGW
         XK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646625; x=1710251425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eCAQ0R+giHUnO0JzFB7XbKEgNY7Y0hnBrpuPfjXwziw=;
        b=DpB455JrwVY4urW/ZHuOHJl87JVA+pWf8fTmkFRjvEheX8gRCL21fHFDTnbeYiFrou
         plfKKuZHDbE7U5E5m6GTTktEdlEewDplePHL8XzUh3wFI648Miq3yGfZ6bDHoqX7KfKT
         1IwGGchRunWbHOrsABgP6RpqJTY2gcNB5H0lcpb5ewyuykHzwXCc/dBwLAvjnj3ClP+y
         /IItgmSGpdl9/Z2hKXUzxUVvK2cET1GjfAjmBBbJzQGmnkbC/hGaj8BA1BRa9yyQX5cN
         +7YaIVw0BqXRJe0VnvSYDdBRPLygGUg81IX5ROXV4mt8TlG/qP/g20xXXXgqFHh1+DTR
         gmGA==
X-Forwarded-Encrypted: i=1; AJvYcCWWUNqNhKPINam6AOf82j+vLhKm9koxWxbsfUsr/V72mlxOVxmM6viX5HU0EgnPOoJFgEqiWb7Jir5sQwlv7vc/AF33
X-Gm-Message-State: AOJu0YyNExfNiEkPQ9vST/rPT3Vt45eu5bMBjSDH1xCgNz9OF3K11cZG
	vB3idHbRlKpiVRKt6cpjXq03Ag25KoARR1BLKAaIefGYOQpoYU/3S91wi/rBocI=
X-Google-Smtp-Source: AGHT+IGz7o88O4IAvKlzvLHpFn1pSq5Z1zeyW79j6xPtObe6zQEZw/2qnUQorrs2IsHIBWEbSH1q2Q==
X-Received: by 2002:a05:6402:2150:b0:564:54c6:6903 with SMTP id bq16-20020a056402215000b0056454c66903mr7778382edb.7.1709646625352;
        Tue, 05 Mar 2024 05:50:25 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id fd25-20020a056402389900b00567bada100asm123067edb.71.2024.03.05.05.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 05:50:24 -0800 (PST)
Date: Tue, 5 Mar 2024 14:50:23 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 07/10] riscv: Add Zihintntl extension support
Message-ID: <20240305-c8ae803906b11fea9bc35461@orel>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
 <20240214122141.305126-8-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214122141.305126-8-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 05:51:38PM +0530, Anup Patel wrote:
> When the Zihintntl extension is available expose it to the guest
> via device tree so that guest can use it.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 1 +
>  riscv/include/kvm/kvm-config-arch.h | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 7687624..80e045d 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -37,6 +37,7 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
>  	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
>  	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
> +	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL},
>  	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
>  	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
>  	{"zknd", KVM_RISCV_ISA_EXT_ZKND},
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index f1ac56b..2935c01 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -88,6 +88,9 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zifencei",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIFENCEI],	\
>  		    "Disable Zifencei Extension"),			\
> +	OPT_BOOLEAN('\0', "disable-zihintntl",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTNTL],	\
> +		    "Disable Zihintntl Extension"),			\
>  	OPT_BOOLEAN('\0', "disable-zihintpause",			\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
>  		    "Disable Zihintpause Extension"),			\
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

