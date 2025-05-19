Return-Path: <kvm+bounces-47051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 439FAABCB87
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CCC04A5D8A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382C5220F56;
	Mon, 19 May 2025 23:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="QrnPNhRF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D6821A45D
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697528; cv=none; b=PJCDTbMly1ai5Ru2Fq168nB/MvIRTiIP3A7tDid5AUd3E/wk4wVS1qeh9c76v76+eqwdZaXXbQzgdq5tHAfC3XS0rzWD5JKDjlRIuI3gRZpjDfohLYPnRf5Tt77GnrhmkV37bJIhb/aY1W67LMMS2ed1pYEpdF5VMcshwR8QJPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697528; c=relaxed/simple;
	bh=MuZecVDV8WFQM7jhq4WavtkULWOpjeUqMx1UI6H0F2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tj8qjUF5SFyNRaKJX51Tc9F9f83ZFWDGN2+di2yDq49/Z9M10ybiOb3lX4KprNZQWHSfRHC4VQFetxnY48U9l/YMiDpKxy1o8W9aopWTyRDNUxYKKPbtZzB7uW0hFOmAhq+awH3MzgkQj3QpI4iX+9ZRmUroooQw45481eBgYVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=QrnPNhRF; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-742c46611b6so2781244b3a.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747697525; x=1748302325; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QOyUGS8X8xHimjiVikyyoBlw5XuU3QFPDBQZu8PO5T8=;
        b=QrnPNhRF2voJgX9mgJ3TxWdTCIXOY8ju90E8BZzIhPDNYpBtUY3ngn1rmYvM3GSGOC
         rqA4oxWY3Bm8QEoWSROOtPPPMF0mRVcHYw8qM4aQPQ7foUKK/mfUmzm7OEJ8+wJW4hqA
         HkWGsVn4ju/R7yBnk/jpjfZvT6Wv6tWWMjFrim+cYwKOcZl+w09/Pn9G46+o/XV9XaHt
         LD9gsnz6kgAd8eY0f1MDo0lje/Itj5HZpmmPCZmiICitILHEwSLlf+mZd38s2KJxA4X4
         SLUglUspZuC30STtgT0AK562Awlq+axbaZrZxF7jYtaO31xO8FSzDTJb/5n1oDH2AMNr
         lCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697525; x=1748302325;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QOyUGS8X8xHimjiVikyyoBlw5XuU3QFPDBQZu8PO5T8=;
        b=VBziF3B35EL1lbIEHdi8JnNz6m3O8bhBofBCoa/j0A4XZvRI+eJ2xXdu/EW4Lgzn+q
         G1CSIfWjEDYNIc1Z0TquHqBAwDckJgxl+XKWrvcwkKFRRkK/AVT0x+IQvEIARrronns0
         mPAy9YsdEEburxzWtsL+wI1zN7jpgDGIoyPMF3VANjzoz8hjowbomL84tPJjqsHt+Snt
         VVtUE62QdfRu4fph4TeEWfq9ryMyoGDI1AbMEM+EuinpavQape1Ww9QTrNizyIZk+wTI
         vT0wutiMhHP2T1TAfKNb0I53ngROOr0nBsB4ZlBv2cOPEtTL9b/UHM1TJEPUp2AnAje+
         f6MA==
X-Forwarded-Encrypted: i=1; AJvYcCVVgcI6bn/E0c6Kr/+mkMxCUR9QY8IRXk8+6vnKJnPNhs48qQBgBIOwFCVYyCymz7/ynZA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2EmF7jQquNHZQ7iDuDcD92/kidWjuys3Bt7z0HB5zCCqtxsdL
	WVgc5dbsAgyiU8THQotrRsKAAunhTZTfwcKrHF6D18KIf310fy+PUNwg5TsaetHzR60=
X-Gm-Gg: ASbGncsz94ch4+L3ikGA5NyDxaG1npK1kJvUtlmsZ0D84/1GfA4tBiJhPbyDsA+e9zR
	LBhq+iK6u03nPTD7BhsK33moxKAJK1886vrceCvRrCd4hQcW3hhDio3vLX4cE8mX4iBaKMGCDKQ
	CVSbU+DAMKAYq6lLBOxC8tK+hO1WRm4HK4m66fTljRTkRDbvsID3hMxCE0LwUbhHszZZ+UeBNdF
	Q+pc79UL6bflXVCeBO9Aj53gNw85vtk4fuYO8ejv6Tj34F51EzaBbErBFrA7/G43VQO+iGFj2F3
	DkF7MPDn9La4zlFOe4PkbZIBaMvC2Fo9MBQDWfSP92VkwJo=
X-Google-Smtp-Source: AGHT+IF/UpnfYd87Wg38QzExFJepdbUZBdK8n48P10QCBwcJgibQDw+FN+/Y6470diBydPdUYMEijg==
X-Received: by 2002:a05:6a20:3d1c:b0:1ee:d418:f764 with SMTP id adf61e73a8af0-2170ce33ad3mr22022427637.38.1747697524568;
        Mon, 19 May 2025 16:32:04 -0700 (PDT)
Received: from ghost ([2601:647:6700:64d0:5f9c:a71e:a2da:158d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb0a9893sm6875885a12.72.2025.05.19.16.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 16:32:03 -0700 (PDT)
Date: Mon, 19 May 2025 16:32:01 -0700
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
Subject: Re: [PATCH v7 09/14] riscv: misaligned: move emulated access
 uniformity check in a function
Message-ID: <aCu_ce-kVQsyjrh5@ghost>
References: <20250515082217.433227-1-cleger@rivosinc.com>
 <20250515082217.433227-10-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250515082217.433227-10-cleger@rivosinc.com>

On Thu, May 15, 2025 at 10:22:10AM +0200, Clément Léger wrote:
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
> index e551ba17f557..287ec37021c8 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -647,6 +647,18 @@ bool __init check_vector_unaligned_access_emulated_all_cpus(void)
>  }
>  #endif
>  
> +static bool all_cpus_unaligned_scalar_access_emulated(void)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu)
> +		if (per_cpu(misaligned_access_speed, cpu) !=

misaligned_access_speed is only defined when
CONFIG_RISCV_SCALAR_MISALIGNED. This function should return false when
!CONFIG_RISCV_SCALAR_MISALIGNED and only use this logic otherwise.

- Charlie

> +		    RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
> +			return false;
> +
> +	return true;
> +}
> +
>  #ifdef CONFIG_RISCV_SCALAR_MISALIGNED
>  
>  static bool unaligned_ctl __read_mostly;
> @@ -685,8 +697,6 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
>  
>  bool __init check_unaligned_access_emulated_all_cpus(void)
>  {
> -	int cpu;
> -
>  	/*
>  	 * We can only support PR_UNALIGN controls if all CPUs have misaligned
>  	 * accesses emulated since tasks requesting such control can run on any
> @@ -694,10 +704,8 @@ bool __init check_unaligned_access_emulated_all_cpus(void)
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
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

