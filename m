Return-Path: <kvm+bounces-44117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A4FA9AA92
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C9331941AE6
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8217F23A9AE;
	Thu, 24 Apr 2025 10:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ZFQbXmZ2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE0A230BF8
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745490947; cv=none; b=V5PBBIs0/fg/VgwxE6jUd8iTK0onFiDSoMJxcSGVE/7Bd5b6Tt28h71D5VoPNs9lPbNGVzWmg3RipNM962d0HDWrQMGm5vcaNUCPRf8Ig36U16T7nU8f+9JepAr32tX2Nj/EUriKaTfPRMawX4wA/DWnx0zJbn3WL/avmBKw2JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745490947; c=relaxed/simple;
	bh=B0ZiRolrSfi+H6wyYXiznygVH1gb8LyA5qmriNgEOfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TQwIR0TagMpc4Qx+TCoznJpmJFL4rSIBaT9TP50Gltp5O45Fn2yfEAgFLynP3Qk4A0oW5JRB/3agrJrFPIblRoCMhMC8yhXP9kp2hNjcvh0s1uM93+BxqhW78uIsz1MwO98dwxhyeU877VsyxMS6LYnWEKChWenfMQqgbJ6glDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ZFQbXmZ2; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3913958ebf2so662449f8f.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 03:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745490943; x=1746095743; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IUR+h4PX+3NwGH8BQZC0fWxB3CoxerSbNXDHvlU8Qy0=;
        b=ZFQbXmZ2pgZiTTwC8vIgEVrWdleenTd89g3orkew/QSipa8UVf+VNYI3jl31pjpW28
         8Kxt/6F+GF+cvHEZ5nRUZ4oWcvhHAiDxfSXvv9FeEQ12bVYudrbcCZ9hp8zBIRF3AXYg
         BFHApXv65WomT6OKxDoHcdfW6tia9GmZ56JUWZ+Coek9/DqcQA+3RSn+z9u1WjgQYHkQ
         VmFF8bPKvrncxBmPf5+DkeBbIzihTKqvIEhdwTVDfXC6zg4pYSveQNVSV7F38U3C0gbt
         53ELJ6sMijN1ZrzRHNp8u8Mn4BwCkwxph+YAgrKb1bRAZgOEsZOiwQTsz3dS19lpLsYr
         txDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745490943; x=1746095743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IUR+h4PX+3NwGH8BQZC0fWxB3CoxerSbNXDHvlU8Qy0=;
        b=ABEj6lHu4zacQWxFivJTtTQ0xmCqBSVRnbQmet3gRHSKSGp2jbSoEQdCGGfv8FLdbu
         d/nDa1kp1ojYNz3iV+eygsrVslbC7w5CUWDnx4sCyluF9SQkUNoFYOzbRGSZTRv8Ptb9
         WKgBf55O/tU+kWdOGSplGRFpZcIUbhRKvQfgdUqls97jjyCC0cl4LvE8TFdi1G7Z3NBV
         Coev1MGylUTNknyZUN72gRl8rZK5tf5Dw1DNPgB2MXZsvTPHLCLeusfBnvfriPye6YHC
         fvWZeRQ1Y+zric+2d0QhZpCWiqGSvmJNCK+f4sGmW4f2Crjd4AwOEFg66OlHXEdNp9p4
         HgYA==
X-Forwarded-Encrypted: i=1; AJvYcCV2PPUtmTQoIq5aW1vFeHXjRx/nMeJ4MEIbWMkWgKbxY3ll68gVyAVRZnPiUUWFL4NpEQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOyBVd0U/2IHImCC+tu70O8SuAFtn28OS0Ex+kavL+ttM//rHt
	ZETHeS3of3hFUvXoIE9hzWbEt/zzTP7T5WXwgZ+8A9nGpO22lYfN+3WAFYg79+Q=
X-Gm-Gg: ASbGncupmz9N674J+22nfg8cFxCWwM0IfDAUoFXnRauj/4fzqJdc++HB+j60fFpbmwi
	y4t23Wpam2+/DOIkMQvut2s6TtspTXU+WmtPuptMFY8RcX4iDRZ03D3Q3hr/iq1W0pTrvSJEKRW
	zNGg50eAbHPirPV031yUbq7uCoWEE9FOqCu373RAjS6y3zPPf9TLqpwM431DQk1qLGsNI6jRrMf
	/avvOAWQXo9LTszVkDlNQveG+qa80n7nH7vYSn1W2C9RmlSRRueH/+SdJ4AVmfsKS0ITc7gej0j
	+dVBWbtITv7FsFI4VdLRQkIcydKw
X-Google-Smtp-Source: AGHT+IEMMNUAVFSZJW72EDWo3VFnQwnHK3P23aJgYipjy3Fyv7YBKouXm/RCEBGe7MUaHxg7wn5VXw==
X-Received: by 2002:a05:6000:4022:b0:39c:1f11:bb2 with SMTP id ffacd0b85a97d-3a06cf5ee5amr1527452f8f.22.1745490942932;
        Thu, 24 Apr 2025 03:35:42 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4c30ccsm1653633f8f.49.2025.04.24.03.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 03:35:42 -0700 (PDT)
Date: Thu, 24 Apr 2025 12:35:41 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 1/3] riscv: Fix typo EXRACT -> EXTRACT
Message-ID: <20250424-93c64fdbb15c142ee458d857@orel>
References: <20250422082545.450453-1-alexghiti@rivosinc.com>
 <20250422082545.450453-2-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422082545.450453-2-alexghiti@rivosinc.com>

On Tue, Apr 22, 2025 at 10:25:43AM +0200, Alexandre Ghiti wrote:
> Simply fix a typo.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>  arch/riscv/include/asm/insn.h | 2 +-
>  arch/riscv/kernel/vector.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
> index 09fde95a5e8f..2a589a58b291 100644
> --- a/arch/riscv/include/asm/insn.h
> +++ b/arch/riscv/include/asm/insn.h
> @@ -352,7 +352,7 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
>  	({typeof(x) x_ = (x); RV_X(x_, RVFDQ_FL_FS_WIDTH_OFF, \
>  				   RVFDQ_FL_FS_WIDTH_MASK); })
>  
> -#define RVV_EXRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
> +#define RVV_EXTRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
>  
>  /*
>   * Get the immediate from a J-type instruction.
> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> index 184f780c932d..901e67adf576 100644
> --- a/arch/riscv/kernel/vector.c
> +++ b/arch/riscv/kernel/vector.c
> @@ -93,7 +93,7 @@ bool insn_is_vector(u32 insn_buf)
>  		return true;
>  	case RVV_OPCODE_VL:
>  	case RVV_OPCODE_VS:
> -		width = RVV_EXRACT_VL_VS_WIDTH(insn_buf);
> +		width = RVV_EXTRACT_VL_VS_WIDTH(insn_buf);
>  		if (width == RVV_VL_VS_WIDTH_8 || width == RVV_VL_VS_WIDTH_16 ||
>  		    width == RVV_VL_VS_WIDTH_32 || width == RVV_VL_VS_WIDTH_64)
>  			return true;
> -- 
> 2.39.2
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

