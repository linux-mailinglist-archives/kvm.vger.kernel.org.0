Return-Path: <kvm+bounces-40931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90A96A5F579
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 14:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 743AB4206AB
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 13:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9762267B0B;
	Thu, 13 Mar 2025 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pOF+MY8E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4D326773A
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 13:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741871244; cv=none; b=EE343Jnzixd01NK4e3QKotYD3igcZc9/XZC04hMrS876c3+JaQ1edDgdyDhLTYVPw2nZUYdVkhiGFwkoSWnEtbVXNpfZEaJjlcB4UXV2jbzd9uvqa6KEYkCDKF1etUcWETIuhikmvwQKNdRuK2VeIWPcvAiazV3ECjyaPIdVaJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741871244; c=relaxed/simple;
	bh=ePOGO+hf+gquyZ0RYyw7U39AF4wEnWB02GOCC4MwDag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PwQ0VflTMEO07v9NJKn60ucVndlx2KZrvkZEQuIDhwVGXCjMXjJz0heNX7BZBxOtcl2cfT1c+WnXiQt8Qu1F/1RmEWsVxiddZq8O0z/01ViePSpqZP1Hp47pFBbUfHNGRmoLkkoBp03dR2a48rewXkYg/A9KKA9qqLGBXSIiRAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=pOF+MY8E; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38f403edb4eso522564f8f.3
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 06:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741871239; x=1742476039; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kL64DFiTXok1q71S+zi/kYHeS1QK7/sbz4oMoXWMASU=;
        b=pOF+MY8EZRyPaaP7WZ3sOxNWl3uNUObMOz4vWlBTP3DowPKgOJq3FTev1pEYNbDmvs
         RsN1h31pTtEWX4/hu0dEJF7JtSNA5RAPeEmi1k8QRNh72iGDGyOfOhsLt8vC6MpsQomY
         Ex/WVwdj+YLjeEDcHx+VGele3Qe8o6uy79svrcFp1zOMzBLr1U2wO/fl6/pe+MyfuMbS
         81+LGnKkA4J/oHlS+MqoHrimRBK3l7QxVtydJ9bsSUO3debEti2lLX8ueghjoGsvZDa5
         s08nw2+okNl1ZMygu24qJzgXFO80YjfPTe3awzICSBlre8voBGkQtC+wEgX23S/r0SX1
         aK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741871239; x=1742476039;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kL64DFiTXok1q71S+zi/kYHeS1QK7/sbz4oMoXWMASU=;
        b=h20TgEXDlgbL0I3bbeIkQyYchpCOZBTc5cYQgYQ272mpTcZihaX0eSlLBzC/rn73X/
         isLAECxyiz72gCr2Tf5s6uyBf25nqRI+etddIcMqyEHvcycHSGkejeQdCocD4pedI7/J
         GHGIuZZgr90a4mHJwbv0HyPIZANCwSGB5SK+q5AoDqwxJuoDOJtu6mVIPURQz92csj+p
         jhjtznwyTIGsLjEJDlk23UfWmd59wE9JQWq5coTRBCsT676kOjvmyp5meaekGTOrHfUL
         LZ2tVjDk+l15Q0DKEUulhnjVYO202bVS3HaI9OCLbayqvVnDApxpYclL22Rlj0sFt0GV
         vw2w==
X-Forwarded-Encrypted: i=1; AJvYcCWvWDPdMS3NUpqjCEmqSATaJ2w5a+TNwGIptLaOr2nBqTBuTnd7u1NXbMXH1Axg30zqBPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCFEXFtQ7PEZ/iquzyovv36nbyvTEVu0YH5pgQf/tx9iKWOAW0
	CXYw7yA+rQwvdJ6/b6ul2Yu6oCOVy36KqDCpD4ksEJD0X55eXEbHwZ4USSdiHyQ=
X-Gm-Gg: ASbGncuCq7sSbs4rnLbTLJAVjCmq0qLTI23ie0PJuBM0ejQGqMP2BwH+xX6pJvD70le
	w5VWsjod2x1ELue3T4/095lZuHUhXMU8j74kv3qwteSzkEzR8+FTeqVCZxF+TYu/Bs6p/RMrEFI
	gy/hIOuphgESJ3MqgZGV7pJN+hUsr3fIYW3tA+IqqJLwwSzO9J4AeW9kYLYKuxTIL3bjWrkTjOh
	qqFlGVqR9Fjk/Tc5Dz3nwWsyFkoGH/836lV4eQiRp1cxkgWPVCAiJx0BLFD8CMgFSRCSSqbALTk
	jNu0JAZJRGcQz3X/ZiEgxHSrXbLaZrs3
X-Google-Smtp-Source: AGHT+IFa3kUJDoicJ8fhht/dP0MNLzwH7jshhQs0/MiP3cN1RHdBOvdNu6RA1GEeL6KH0hkbmig8fQ==
X-Received: by 2002:a05:6000:18a3:b0:390:e7c1:59d3 with SMTP id ffacd0b85a97d-39132d16de1mr20255337f8f.2.1741871239342;
        Thu, 13 Mar 2025 06:07:19 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebbc3sm2013164f8f.88.2025.03.13.06.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 06:07:18 -0700 (PDT)
Date: Thu, 13 Mar 2025 14:07:18 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v3 07/17] riscv: misaligned: move emulated access
 uniformity check in a function
Message-ID: <20250313-89b46bd06fbea0072ac4932f@orel>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-8-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310151229.2365992-8-cleger@rivosinc.com>

On Mon, Mar 10, 2025 at 04:12:14PM +0100, Clément Léger wrote:
> Split the code that check for the uniformity of misaligned accesses
> performance on all cpus from check_unaligned_access_emulated_all_cpus()
> to its own function which will be used for delegation check. No
> functional changes intended.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/kernel/traps_misaligned.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
> index 7fe25adf2539..db31966a834e 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -673,10 +673,20 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
>  	return 0;
>  }
>  
> -bool check_unaligned_access_emulated_all_cpus(void)
> +static bool all_cpus_unaligned_scalar_access_emulated(void)
>  {
>  	int cpu;
>  
> +	for_each_online_cpu(cpu)
> +		if (per_cpu(misaligned_access_speed, cpu) !=
> +		    RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
> +			return false;
> +
> +	return true;
> +}
> +
> +bool check_unaligned_access_emulated_all_cpus(void)
> +{
>  	/*
>  	 * We can only support PR_UNALIGN controls if all CPUs have misaligned
>  	 * accesses emulated since tasks requesting such control can run on any
> @@ -684,10 +694,8 @@ bool check_unaligned_access_emulated_all_cpus(void)
>  	 */
>  	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
>  
> -	for_each_online_cpu(cpu)
> -		if (per_cpu(misaligned_access_speed, cpu)
> -		    != RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
> -			return false;
> +	if (!all_cpus_unaligned_scalar_access_emulated())
> +		return false;
>  
>  	unaligned_ctl = true;
>  	return true;
> -- 
> 2.47.2
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

