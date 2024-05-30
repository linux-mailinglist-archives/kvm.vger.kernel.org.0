Return-Path: <kvm+bounces-18427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ED228D4F64
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 17:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01521C23061
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 15:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE17B208A9;
	Thu, 30 May 2024 15:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WVdSqWHi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79321D69E
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 15:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717084100; cv=none; b=IYJIdNK3jvH/9jvdJAvQ9Dp4lq1VXRRJrNfCjbrksMpoWYXacbYuI7NIXVlrnV4Hrx6kWTFwFNhlGv2xtMYpKuSCYepsVUviyJJd1i8Ydq9LdZYBmg90DSAemjCeB6DaWKh7Lf/0Ht6DOAafnZauD54X35sOBcClPLxKw91OEpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717084100; c=relaxed/simple;
	bh=uiGOFfneORywVqa7KwbGbVLdPn3xrlFWKiXYGWlSZWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YjLd/PD4OHnts54mVpiszM58VUCPkTdhvyakzaVl7bp0KWebP+F5MY91Nk1Z9ImI0xHVcxzKBYKgoPeTOaMzUL5zOQ5IPnoyOHk0GDfcqLlzlwoxE3nvoaGBms9wp6yn/+Gok16z3MNfzwed1ymygE0dPhJRljt9S3PtW8C4iEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=WVdSqWHi; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f6262c0a22so3033015ad.1
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 08:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717084097; x=1717688897; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z2/9YXup/8RbMNmyLIVK+PNdaz2WPXgvrHbc/uuCS+s=;
        b=WVdSqWHiu5sKaDLWZCxaBXUV31ZBsthCdZZZutKEkDcX0e61rFlvsCJTLb3B04m05m
         dAIH+HyiM647olGbM+CDjUCzUmEg/4RI2zyqBxMj+yoqLTxMhXWbYt9bSf7YKAAtZ/8q
         1HO5hyaXQilQrcmuveR7lGVHRGN20WpXFNlyoFsjJE0heqSPm1sB+d54c6GmwhKAIfk2
         G3SHZNVzMW9nmYz1Ah4ZfpOylk9AsCrkiceqrqohFTErQ2RHMvO3JQ445W7+8jY/szIZ
         b0c3UV0yO7SK/xyD6NBOgb7iuVJC+7Dd4XPGCQsEnGfkEDIUwASlnGrfRigBExCYzm70
         PKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717084097; x=1717688897;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z2/9YXup/8RbMNmyLIVK+PNdaz2WPXgvrHbc/uuCS+s=;
        b=RZnyTzAkxSutRTkuRpncfcQ+8WGtxFAjEN1cOR4xWJVR2C44itqcYJsvp5VQDcYadi
         CKTMkRmkqxrUq5mDdKkG4vw6UnSqdogcXqHF2D/NPiQY2G+9Hg1bdUThpiv7BbyBsviR
         x9FANcJmZyG4RlHFjmWLEZf14+Hf/x6I54GKB75GF5PoLYxJ8gd2UnXIitJZZz24gyiL
         0HpA0DyuytmwHx4y5IgQsGgP5k0knZyalrPH++4vjOu0juVyUwoblltypfwM3hG98J9W
         FdCBjPJ/FYloySUUiCukYP7+7xvkJaanFyMfbDF5myyaNtkc2Ay2BM+JwCnmmlTBWRBI
         FelQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlbVBP2qDXeA42GSydtqXyTawtPgtslcFTHEAPsMXw5pisbqGFI/v8n/gtyA4Ul+DpeTda1A4nZzW+En+wi381+Bt/
X-Gm-Message-State: AOJu0YzqKRJnvqyfvm4uhMZDJQUGUrabvtQQ7QbdOWWOyXOIDo/4Mg23
	LkUJecWfPgde60KgNQkpVighfOcW31Cwb/zOJ6ireJEGqxr6M22zTIEUq+LLY78=
X-Google-Smtp-Source: AGHT+IFEoPjpm6Eoux4dPoJuolosadGpX2I41dVnCKtavoFPe5puywtXMZkqH8FzHI7me3wq7SDgqA==
X-Received: by 2002:a17:902:db09:b0:1f4:9468:38b6 with SMTP id d9443c01a7336-1f61c1ba67dmr29549475ad.34.1717084096975;
        Thu, 30 May 2024 08:48:16 -0700 (PDT)
Received: from ghost ([50.145.13.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f4d6fe4775sm49803095ad.257.2024.05.30.08.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:48:16 -0700 (PDT)
Date: Thu, 30 May 2024 08:48:13 -0700
From: Charlie Jenkins <charlie@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>, Shuah Khan <shuah@kernel.org>,
	Atish Patra <atishp@atishpatra.org>, linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 13/16] riscv: add ISA extension parsing for Zcmop
Message-ID: <ZlifvXUiHeNnEJqq@ghost>
References: <20240517145302.971019-1-cleger@rivosinc.com>
 <20240517145302.971019-14-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240517145302.971019-14-cleger@rivosinc.com>

On Fri, May 17, 2024 at 04:52:53PM +0200, Clément Léger wrote:
> Add parsing for Zcmop ISA extension which was ratified in commit
> b854a709c00 ("Zcmop is ratified/1.0") of the riscv-isa-manual.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/hwcap.h | 1 +
>  arch/riscv/kernel/cpufeature.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index a5836fa6b998..aaaf23f204ac 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -85,6 +85,7 @@
>  #define RISCV_ISA_EXT_ZCB		76
>  #define RISCV_ISA_EXT_ZCD		77
>  #define RISCV_ISA_EXT_ZCF		78
> +#define RISCV_ISA_EXT_ZCMOP		79
>  
>  #define RISCV_ISA_EXT_XLINUXENVCFG	127
>  
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 3bb2ef52a38b..0a40fa1faa04 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -290,6 +290,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>  	__RISCV_ISA_EXT_DATA_VALIDATE(zcb, RISCV_ISA_EXT_ZCB, riscv_ext_zca_depends),
>  	__RISCV_ISA_EXT_DATA_VALIDATE(zcd, RISCV_ISA_EXT_ZCD, riscv_ext_zcd_validate),
>  	__RISCV_ISA_EXT_DATA_VALIDATE(zcf, RISCV_ISA_EXT_ZCF, riscv_ext_zcf_validate),
> +	__RISCV_ISA_EXT_DATA_VALIDATE(zcmop, RISCV_ISA_EXT_ZCMOP, riscv_ext_zca_depends),
>  	__RISCV_ISA_EXT_DATA(zba, RISCV_ISA_EXT_ZBA),
>  	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
>  	__RISCV_ISA_EXT_DATA(zbc, RISCV_ISA_EXT_ZBC),
> -- 
> 2.43.0
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>


