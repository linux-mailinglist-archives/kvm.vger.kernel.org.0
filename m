Return-Path: <kvm+bounces-47610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB1DBAC29CF
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 20:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A77317F5DB
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 18:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE74E29B23C;
	Fri, 23 May 2025 18:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rhEIa+hf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681752989A5
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 18:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748025051; cv=none; b=a5PBGok3G5QCWv8svecI+GbxYLHgFvDgWd6My/mensqjbQJc6OU3Tlo5ATiwTmdAU9+EG1AbT7yCQcg4d/97YGpPCKe1WdDzLuBVARdVoBX7/CaH3gtK4OyBRmP3wnZgEJfbhPbRwtF0UVwz0J6Q3P/BbQlBM0va1b5QcfqC7vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748025051; c=relaxed/simple;
	bh=JbUIjDHozqFZ2+ZIIgiUMiStVmYqgccKErpZffZ0FfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6VLdJkrJBuqrNC+8j1QVBSB9ayeEbASIT7hnl/mS2xTUCNaSjD1dWpuegCj4k3aTtnF6tABr7GboM8MtkxxYkQh2ixxWgFB74WKN79cvkVldH3kKHTJDgWA72wDHEsSFkz6qoEYDckxt4i8mGjQT9GMQokfL+ch8Etll/RcAxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=rhEIa+hf; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b1f7357b5b6so106966a12.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 11:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748025047; x=1748629847; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gWbUHPNgvAgT5G9XCmvjzlBHTlpN3kX1yERm+5eFQko=;
        b=rhEIa+hf27Y0eogw4f14fmL/RUgsPCjErP4boL5tqlV8qiJU5oNRGebUrW3BfBg/pl
         HcXzZRCbqoSNCxHmt5M/FEFoY1vQIAA6gMLKstDImwuioj4yJOyHcPMujIPE8CuC3Rk4
         lkWcWTRYa1V5brIK/1fGVlHa7Bhyqf5ZHS4762XOzAg9nL1gAkAbunOSfhjyz2FMTimR
         9WHgPUMo+OOTOGAxDz4nXBQflbBr40xR1HDB2OB6DAkp0RfSjT/F3wE8KXMMvXV/43wD
         5f0TZVNHIaevd7EJhxS7SD3x+qXkh4caexYLB3t/x5pf92rZqDsiWfotAhwq/uEtN45Q
         8IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748025047; x=1748629847;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gWbUHPNgvAgT5G9XCmvjzlBHTlpN3kX1yERm+5eFQko=;
        b=OmkGu9D9H7mqO0ulk6yQ3yfPM2oExvNioeqRIurZMwwR+epgBMbq1DGgk5AQkqxJxQ
         0nyTTSnhGz1YFHKEKGqMf3PUt02U75ALjX/JE4pEE+PM52OBdPITtRV8inDS7V6hQ9EN
         OKE9dnyp2HdE+62FmImieDQGTpva2ofYf/4vsRKjqeiFjPxep2XHRUwjtwYwFSystJ1W
         ZfJoa7nRpeiAmkPFoxiick9bY0q1W7xSzlURC8KwLJYWv7okXhizAjZ2FjXUCmlmtRVd
         /vG5eZc8iHCLZQ/3ztljVULndA/rlNvrtIlkq472jgBedZtWKJJnCAFhNj+Jt/a4/CCK
         XgQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUI8V6aHADipxs3MWIbT3VargMUikzKaAlmGAjHBqBC4VLx6cUrQz9wlN6TsCQ7U5hsag=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb/UtIsYA10GkUPOHbM9l0vlhlsnVf2pLOHj3Mo5KgMOLFh5ig
	sVHhIOCtUnMpM2IfO3Oe20iiNd/w+cvCYyZHmdkLbf6w0etQf6XtaJHulMa6ONpizb0=
X-Gm-Gg: ASbGncuIi8X87cEhYxIrWAa205KRL0LjFNkzTWX0t42lf7oNfAty/VVgaEyV+mvmQiv
	9EpsQ0QTL76ZcTXjh8T6npQBWkswE0ViA33T4hyP0CNNAi4vv1uGCxJ1rpEG7dtVdv1l2IT4jHs
	0xMoW3ZBKhsl6LtdcKPrEPM141RmsXuVR36F8HxuSmX9WLZce/lom6yJpj0cwf0gLFwCEuI5KBy
	4qR9ekHlIl99Uw+FMgL5t9RY7Einqv3N50jxNDDihJxPNdhUlkXDGhedtKkwne9esUZCMnDoLOW
	5nXMsJbzHAMAjvqfyk92Zm6FYMThyPAqC2Xd6KXoomfInt4=
X-Google-Smtp-Source: AGHT+IF6EgWK2eUC5Xu5iRop7pXN3/Fhxf1IfDgAGTEelKq535OUbR+gaTA3ptsvLBrT9R7jy18zfQ==
X-Received: by 2002:a17:90b:17c1:b0:310:c46c:ee6b with SMTP id 98e67ed59e1d1-31111a4c866mr121461a91.33.1748025046448;
        Fri, 23 May 2025 11:30:46 -0700 (PDT)
Received: from ghost ([2601:647:6700:64d0:bb2c:c7d9:9014:13ab])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-310f7eb53a9sm1014559a91.12.2025.05.23.11.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 11:30:45 -0700 (PDT)
Date: Fri, 23 May 2025 11:30:42 -0700
From: Charlie Jenkins <charlie@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>
Subject: Re: [PATCH v8 09/14] riscv: misaligned: move emulated access
 uniformity check in a function
Message-ID: <aDC-0qe5STR7ow4m@ghost>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
 <20250523101932.1594077-10-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250523101932.1594077-10-cleger@rivosinc.com>

On Fri, May 23, 2025 at 12:19:26PM +0200, Clément Léger wrote:
> Split the code that check for the uniformity of misaligned accesses
> performance on all cpus from check_unaligned_access_emulated_all_cpus()
> to its own function which will be used for delegation check. No
> functional changes intended.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kernel/traps_misaligned.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
> index f1b2af515592..7ecaa8103fe7 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -645,6 +645,18 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
>  }
>  #endif
>  
> +static bool all_cpus_unaligned_scalar_access_emulated(void)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu)
> +		if (per_cpu(misaligned_access_speed, cpu) !=
> +		    RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
> +			return false;
> +
> +	return true;
> +}

This ends up wasting time when !CONFIG_RISCV_SCALAR_MISALIGNED since it
will always return false in that case. Maybe there is a way to simplify
the ifdefs and still have performant code, but I don't think this is a
big enough problem to prevent this patch from merging.

Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>

> +
>  #ifdef CONFIG_RISCV_SCALAR_MISALIGNED
>  
>  static bool unaligned_ctl __read_mostly;
> @@ -683,8 +695,6 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
>  
>  bool __init check_unaligned_access_emulated_all_cpus(void)
>  {
> -	int cpu;
> -
>  	/*
>  	 * We can only support PR_UNALIGN controls if all CPUs have misaligned
>  	 * accesses emulated since tasks requesting such control can run on any
> @@ -692,10 +702,8 @@ bool __init check_unaligned_access_emulated_all_cpus(void)
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
> 2.49.0
> 

