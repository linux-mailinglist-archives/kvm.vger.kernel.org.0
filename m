Return-Path: <kvm+bounces-41174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BCEEA64524
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A4B418932A0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472D221CFF6;
	Mon, 17 Mar 2025 08:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="HwmXmbxd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2898321C17D
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742199633; cv=none; b=L7vn1V+T4XYe+O670DfmEkFa5th2rEvoDqtEblBIRkxh2UfH9Wh7uha59gIl18v26CgB6j0x8NOUmzatruBm/F3zz515VIl8XP1DGZL5r049UzHQBXSes+j+T+/zb7S9h1o02Mv0MJTYg17gbme7n1TzdBlxfQaQJj4BpwcD7K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742199633; c=relaxed/simple;
	bh=PtnfXgn4p1apcWC9JTtWgE+fq48hFfI4Si1TMbfP1gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B/LNLGq3yjCW0NA/kw7IXlIvFYyleiN+ZtjGxWaUKEre3lAa88s9QRd+wtMiTH4UcTx4mvuVvCk00NSWpJFKUSI+3WijyPM3cH3ZWLYvtLOzv3q6Os8jpeYisKyspgFdCHjsYTuPMY+AcEsokPa26eWV1z3BIUPsqUYMoN1ZeXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=HwmXmbxd; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4394036c0efso11086345e9.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 01:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742199629; x=1742804429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=idnmgT1eccdSyu/OPhC/7TS6BosnFKLbpT5XHoKTMw8=;
        b=HwmXmbxdunY1HVQBo6E5+mI+wHWctFOlucqKULGNCZ/wCxCNrgxdiIa3ifPxPCru+9
         ZdnEb+9Vh0rJyMPXab20LqdXsNNtCEwnrO48dVW0zcBZ81uvZL1fYzlt+tERMREo15y4
         Pw09pL/cUL6SvSEemzmfIEnw6h99Bd4QFSMjI0gqAW/geOO4eb9WKTLZ2O/4rDJZLpiZ
         VjXk/nwCuUOS2X1G5FLcedQj5MEvWFNYR3jxoisjqdUU5N+LvMwV2c5p1oTvcshs0EMB
         shJ0aYcAK64cMdeJTinXZwyGL3v2p0uGWqDmSCHYnSZT85CdAsYPc03wngq0/mhETtgh
         V14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742199629; x=1742804429;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=idnmgT1eccdSyu/OPhC/7TS6BosnFKLbpT5XHoKTMw8=;
        b=b8QEne9ooOpqdaSbeIrptXQaMPfumfvkGnsRpKwE0gN7n0Ka6DTKBwleahUxWauQyu
         cDocvawwHoClQvy2jsmSLzChsvYyroG1ybuGfs5HHsR5pDfxUeNBxjUI4fpwgY0ziZF8
         ncCtupmgLNwbbepBk/7vD4slxDXj+L/UamKvyTobMe8DeofFQps5EOgYhjPuTZC1BdoJ
         JIp1oIkqxjgA37ejYIenyeiW4IkDygCnCHsgXQdBRH98Fv/7Ev8VLP7OJXoIItbAUR2x
         GR8N7uQv7lT/9AytjGuA9t9FgGX37w9mwv6Zf0vil49HNJU5Viej2aJL4BZGLpWqN7kU
         SGSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAlPgaIHxg+qR06wl7riT6oZerT3xXxeZaYTyHrFQJ7WYg1JLaDo18Fz+A3J8oNx9IcKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPLGcoWZW58irJfD3l3aSwtysZJ/UBOjqzvf0363tZJ9BXdhYN
	7ek7JJtf8izc9r+J1wznQl+dh1ZGfUFKw9nxHNHXbHdGrftDe1DcMN5CNXwbBxQ=
X-Gm-Gg: ASbGncviCUezIrL7i9/V/6QedHieT+yMqQBRIRRvUYg9vsrhIiNRgmCkrEBcf/2yXWa
	eWwpcXFEyB7djSRXJO+NuHSSis1KxflYbm/nNrL8UzaS/pIWW3azyZee/zcABaf372a/8ICyatO
	ENEcAcCTFDeauC1OTF38+LKstMKbjw5KCs4vUvbsHvtw66jjbUZeAcWqYoPGmNKGb1MjwYHayeo
	XpiSi8BrVpfec3NXhPQQ5cb19WRvmV+aM1HOfRqmUVJmdcn+gzLvgGDuU3y2MHurFbvOvB7xhRr
	+s3fYmVmBFSf29J8F2mfIa2P2uMSOrVBbzkeGXe785zzkNGo1WUqLZQlNzpcymNG9qXbyV1R+ne
	LtsrAQYzy+pe39w==
X-Google-Smtp-Source: AGHT+IGJYSIRgCC95ZnDvgK8g/TyVxpNIVMRDb7KV6pIjoedYcKGDCvgwjfG30dI57OPAJvFlLiHtQ==
X-Received: by 2002:a5d:598d:0:b0:391:3cb7:d441 with SMTP id ffacd0b85a97d-3971ddd6091mr15025035f8f.25.1742199629442;
        Mon, 17 Mar 2025 01:20:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fdda29esm98866085e9.7.2025.03.17.01.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:20:28 -0700 (PDT)
Message-ID: <0432fb3a-98db-45c5-8630-43ad52f27769@rivosinc.com>
Date: Mon, 17 Mar 2025 09:20:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] riscv: Refactor SBI FWFT lock tests
To: Akshay Behl <akshaybehl231@gmail.com>, kvm@vger.kernel.org
Cc: andrew.jones@linux.dev, atishp@rivosinc.com
References: <20250316123209.100561-1-akshaybehl231@gmail.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250316123209.100561-1-akshaybehl231@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 16/03/2025 13:32, Akshay Behl wrote:
> This patch adds a generic function for lock tests for all
> the sbi fwft features. It expects the feature is already
> locked before being called and tests the locked feature.
> 
> Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>
> ---
>  riscv/sbi-fwft.c | 48 ++++++++++++++++++++++++++++++++----------------
>  1 file changed, 32 insertions(+), 16 deletions(-)
> 
> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> index 581cbf6b..5c0a7f6f 100644
> --- a/riscv/sbi-fwft.c
> +++ b/riscv/sbi-fwft.c
> @@ -74,6 +74,33 @@ static void fwft_check_reset(uint32_t feature, unsigned long reset)
>  	sbiret_report(&ret, SBI_SUCCESS, reset, "resets to %lu", reset);
>  }
>  
> +/* Must be called after locking the feature using SBI_FWFT_SET_FLAG_LOCK */
> +static void fwft_feature_lock_test(int32_t feature, unsigned long locked_value)
> +{
> +    struct sbiret ret;
> +    unsigned long alt_value = locked_value ? 0 : 1;

Hi Akshay,

This will work for boolean FWFT features but might not work for PMLEN
for instance. It could be good to pass the alt value (or values for
PMLEN) as an argument to this function.

Thanks,

Clément

> +
> +    ret = fwft_set(feature, locked_value, 0);
> +    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> +        "Set locked feature to %lu without lock", locked_value);
> +
> +    ret = fwft_set(feature, locked_value, SBI_FWFT_SET_FLAG_LOCK);
> +    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> +        "Set locked feature to %lu with lock", locked_value);
> +
> +    ret = fwft_set(feature, alt_value, 0);
> +    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> +        "Set locked feature to %lu without lock", alt_value);
> +
> +    ret = fwft_set(feature, alt_value, SBI_FWFT_SET_FLAG_LOCK);
> +    sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> +        "Set locked feature to %lu with lock", alt_value);
> +
> +    ret = fwft_get(feature);
> +    sbiret_report(&ret, SBI_SUCCESS, locked_value,
> +        "Get locked feature value %lu", locked_value);
> +}
> +
>  static void fwft_check_base(void)
>  {
>  	report_prefix_push("base");
> @@ -181,11 +208,9 @@ static void fwft_check_misaligned_exc_deleg(void)
>  	/* Lock the feature */
>  	ret = fwft_misaligned_exc_set(0, SBI_FWFT_SET_FLAG_LOCK);
>  	sbiret_report_error(&ret, SBI_SUCCESS, "Set misaligned deleg feature value 0 and lock");
> -	ret = fwft_misaligned_exc_set(1, 0);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> -			    "Set locked misaligned deleg feature to new value");
> -	ret = fwft_misaligned_exc_get();
> -	sbiret_report(&ret, SBI_SUCCESS, 0, "Get misaligned deleg locked value 0");
> +
> +	/* Test feature lock */
> +	fwft_feature_lock_test(SBI_FWFT_MISALIGNED_EXC_DELEG, 0);
>  
>  	report_prefix_pop();
>  }
> @@ -326,17 +351,8 @@ adue_inval_tests:
>  	else
>  		enabled = !enabled;
>  
> -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 0);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d without lock", !enabled);
> -
> -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, !enabled, 1);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d with lock", !enabled);
> -
> -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, enabled, 0);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d without lock", enabled);
> -
> -	ret = fwft_set(SBI_FWFT_PTE_AD_HW_UPDATING, enabled, 1);
> -	sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED, "set locked to %d with lock", enabled);
> +	/* Test the feature lock */
> +	fwft_feature_lock_test(SBI_FWFT_PTE_AD_HW_UPDATING, enabled);
>  
>  adue_done:
>  	install_exception_handler(EXC_LOAD_PAGE_FAULT, NULL);


