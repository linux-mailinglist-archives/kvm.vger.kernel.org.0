Return-Path: <kvm+bounces-41758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64851A6CA07
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 13:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF3B9883EB8
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 12:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2223A21B9D5;
	Sat, 22 Mar 2025 12:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pfVWZLGf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9947B1F237D
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 12:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742645169; cv=none; b=oB8gmgQh3wJlrcG8is21df/1RtPgkFraWQbPoxAMtKz8jARfLEIvkXcTK5X520n3XBnTxLUp8CaGB6+BsW0pDdNr+ehAQyquODBeVv2zSimgEe7PL8iCrjVgT5+PcT9vCwTcSD3Jar8TWawXEu5jpC2mCdbeFVSnItbSU4XtW+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742645169; c=relaxed/simple;
	bh=oOwIic0xoWcK/W7bScwvvNxG27FtWKsUDiBHcGLGMEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cd6WAdB4dqwuKHm/DGGevl+Y8E3NJxHcnGFtxrzH6b+quH33/d0PLNIdFpMKfdgY/gWfYZEcQpkZoMlHGlOYRrGMIcQeElBT1EQYLFwZXQ83g4rD47ADEGvlejPmVkxnWicFrgCe/Rp5CNucZ/7dsRmBchcUl/pG+jGV5eNhQ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=pfVWZLGf; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4393dc02b78so18983625e9.3
        for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 05:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742645166; x=1743249966; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZKCRWgSlF1v0cutxAi8x3LCFESHSHWoNhfvIYKSJItY=;
        b=pfVWZLGfHoQsMmWHi54ghr7KbiyyJFpAMemHA4DI398Vhpz1z/JsE643sFQ1ehK9zl
         Clw4wgHobbHkiCQXGyiU7Eqj6nStsGZz5jalsceV3p31r5hpN89/3D39dBQCN672KKhY
         SlT2poaxnVeXaFVC5PpFbax3DQh5ipvKlna28PGbWmGvwKg60CnFyq4GuSViWAbNAaHE
         b6nQbieQAmhXUuyUeZL+6TAJtCS7BfvAmIsFfE8Xt8GwYRtvBdSwVUzyjIulhBEqH10m
         8CmvdvayXOc0Vo+uLQJ+81AL56LPVMRdXEh24EohL+YfeAwVv85vSlJfwMRS6/HhLA0B
         DoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742645166; x=1743249966;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKCRWgSlF1v0cutxAi8x3LCFESHSHWoNhfvIYKSJItY=;
        b=avIiJ1ub09fixeGezScI1xVquhYTyYt4b3AQiHHsUjBtYKOXmsuS4uRS4M3lG3jTFS
         PWkj9+O0uyy838BfZFj6z48M7RCqxa80OB3xXHgHlcJtELYR6djg3wWyZtOpGGnABdBV
         LpDeD//YmAWz86ofbxguph25ZYSoFCuUANciVJ3aSsovx2ZpCHKzCD7vgGA8Reop03qw
         zWD9NCjEAkSCMXkh3CFE5XIpX7LttAMJf2p3Ijq8oTLTiRWYa+hxsrPHOGlfGggiluJz
         n7KLe2hfGb/MG9MJEqzjIMQMUrPzpvjKqp3gdIYEpFe3CvPLV0jfsGKhFO6HQ2DQc5qH
         bhYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUN3PiIK6AQNnEc60/VIM34Qzn9MwEzorJ6okEVZHnlEoKJfcuFUjvrAfdR1Btq7vQdQEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YynC60QaPn7UmFjPz1HNI9pas9X8YuCqdoXLL75q+8QfQkkyX45
	emIPVCu9C5ZkxNi+C0Gt/hsAlwG3ophbjNwnJXh85J4mJIJ3At3XEI7qQQIcR+E=
X-Gm-Gg: ASbGncuwfSiLZnhE0xVDxI9xP6qTP+6vo7sRhZ4gEikN1LZ/3Ug8CK0lfKIFnLAlxe+
	tvoX4SGMRvR+kdhOa3z394O0rIFDxivxviV+CPZPceCDIGzrHxJUiMkGYVroPJCrfNIU5OKFAtf
	BqGOQ2OirozpBRLe9ZBpC/UasgrsMO9708LpVJ56yNd/YyRCiXrLxYGhCQJVYmVNWyvVqDiM1+T
	LRXGaVWvKJ1oZ6qjduB5tCCwYploesklFucl1cnRT09+4JN1v7ezc2P/1lCPL0T+uFYwyc5VLDj
	Rc+T1h/VoyrE/WkFX209MLBjCmpkoqPzbs5Z9MGKsSWvwsxuY/ARzLDK+GBs6SO7SBcuoKe1OA=
	=
X-Google-Smtp-Source: AGHT+IFTfC3V3Y+aXvtwsAGDzN2r/TELBK33hItKDRr/I6qX4Pf8OQOcC8wMhwn6dPn+tHwLQGn1PA==
X-Received: by 2002:a05:600c:470f:b0:43c:fe15:41e1 with SMTP id 5b1f17b1804b1-43d509e190fmr61771675e9.4.1742645165642;
        Sat, 22 Mar 2025 05:06:05 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9ef23esm4932401f8f.81.2025.03.22.05.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Mar 2025 05:06:05 -0700 (PDT)
Date: Sat, 22 Mar 2025 13:06:04 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v4 02/18] riscv: sbi: add new SBI error mappings
Message-ID: <20250322-cce038c88db88dd119a49846@orel>
References: <20250317170625.1142870-1-cleger@rivosinc.com>
 <20250317170625.1142870-3-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317170625.1142870-3-cleger@rivosinc.com>

On Mon, Mar 17, 2025 at 06:06:08PM +0100, Clément Léger wrote:
> A few new errors have been added with SBI V3.0, maps them as close as
> possible to errno values.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/sbi.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index bb077d0c912f..d11d22717b49 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -536,11 +536,20 @@ static inline int sbi_err_map_linux_errno(int err)
>  	case SBI_SUCCESS:
>  		return 0;
>  	case SBI_ERR_DENIED:
> +	case SBI_ERR_DENIED_LOCKED:
>  		return -EPERM;
>  	case SBI_ERR_INVALID_PARAM:
> +	case SBI_ERR_INVALID_STATE:
> +	case SBI_ERR_BAD_RANGE:
>  		return -EINVAL;
>  	case SBI_ERR_INVALID_ADDRESS:
>  		return -EFAULT;
> +	case SBI_ERR_NO_SHMEM:
> +		return -ENOMEM;
> +	case SBI_ERR_TIMEOUT:
> +		return -ETIME;
> +	case SBI_ERR_IO:
> +		return -EIO;
>  	case SBI_ERR_NOT_SUPPORTED:
>  	case SBI_ERR_FAILURE:
>  	default:
> -- 
> 2.47.2
>

I'm not a huge fan sbi_err_map_linux_errno() since the mappings seem a bit
arbitrary, but if we're going to do it, then these look pretty good to me.
Only other thought I had was E2BIG for bad-range, but nah...

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew

