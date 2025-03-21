Return-Path: <kvm+bounces-41722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91357A6C404
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 21:15:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 021BB189E7B6
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A9D422E3E1;
	Fri, 21 Mar 2025 20:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="f1iro6Y3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9321DEFF3
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742588137; cv=none; b=qRLRPb2MmkqWyWDpEbcFQvBoasYa/pru+i4i+I2ABQA2A3Samsiqv9DzCmfOHAAExC/B5vfNAOxeXo0f/Diw31p88vmPJbFRVSgo5+n966f3DDewMASShG4xGCFU3o5SLJxf2BQku78HtnZpJ3QrNpRQMf2qYltzQYsz8EVYkPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742588137; c=relaxed/simple;
	bh=XcsyyZPszvRBSzdZBPDH0TwVxGNvP+iFRi5hAxvk+Wk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A81rXZqL6H2X5Di2jOzz1BcgrVZOlNgZK0vzh91bTx3CG49OfPaF9rZREiGlkgtmRrqZ0SsGY5CZ7s9txiaTKiuslPWu03ixwJQCExN369gwMQqYXhjNIQ3Y2SOakHh0fCqXdQ80mS1rxtaG2/AVwCTWo2cjF6ABHcbR82K0EA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=f1iro6Y3; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cfb6e9031so22274515e9.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 13:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742588133; x=1743192933; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M7Pg06C3rx2edAau3ZDyx94pdNdZUqrs4v4UVmFnuyc=;
        b=f1iro6Y324iVok9XUiOMd9XdOJ1xGVfjPMyOYn3LYqmCPs/aJotcdJL6y1/kNTHOAP
         DjvWVurIcECnjufJRz+Ph+ocPiH9q5TVgAaS4+aYX1FAtuX/1Fgkq63k2kNdwY6ZYuLm
         ZIRSwBM0aPvrpHf1znYSfwrtvpOQHq/VCEIBWOdqlNz4TvEQmDSFJuGLpR2luT9XQTLR
         RlC3UB1/fxfN5iKa8qYKQnFSqijh+sNrpw/5WhK3lXp7puFwLXwNytpN7kIpsrlmSluz
         OlcR8mQt5Yglq2fy4Rbl4mWc6gxzs+JJZT0DlUOYQQRphVdS2hxTGznHEogqGT1YGm7x
         62kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742588133; x=1743192933;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M7Pg06C3rx2edAau3ZDyx94pdNdZUqrs4v4UVmFnuyc=;
        b=Zxw8uFfUgijNf428DcpVvVekI8n1viF9t4tHusg/OR0x3nea6PRjKf6WDxfSGXmfNi
         Zgkn4qKqLxxMv4bJaApSzPtSeW0JOgrxVZmYh/ntCdeV03bFU3Rv8yfPXcggjz/qqh0t
         2eXejJ8oW71BgGX0vvgl0plTTaNGk7MiLjff14eYpDa6sUdrNtqrGbKDIFbOepaGX9ru
         gh/jEWZTfVhkesT+gHsGLmXkuKJaevZSrIiVIhDi8xcw37MjuuJ0C/Te87YXnkzGaQTu
         tpQVmqD/omsA7a6MwcNNI5/tWPVvuor3M8D+FHm+MNzR+o0R8e/ekqOLAAMM7idOueBg
         vU1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUx2KQSvThOFvhfsJEDrfuG/F/4+jW+2OsmxLN2bsgGgBZJMP0HWeSHOjBNeCDVeIttRDo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMUtg37Ma3b7HytDQl+AXnWKw5vdyCzCtkJvctX9dYoZH2FUSk
	q6aBc7JO4ULn2rXDAL688xW07DykCRiFp3FPVwpTNe+iAy1n3KWYj/DuO/LXTqc=
X-Gm-Gg: ASbGncvQvG4tVMA0g5jFNG3Sf7BmvZAw1YHoexdTD474YwYfPBgwZ8K02el9v9FNHli
	NeTkZHv6uZdtAt55aptkR7Ktk7wmVBtC0Jf2Km6jW/TbNQzuSM6P1+s1+j1dXSXG0L4FrKTO+L8
	mnfEScOziSu2c5xLAmgiKSaRzixOoGqbmHWYXlrY4Q4SncyL92PUV4gKERfJl8+662O44vC1V2B
	PhszuYJzhPTX5sErNgxitOTWJSmMTWpo4L/5Lms590UVgM1Kum8J4aamRjsXAixF99Kmxptuau/
	uMXojG6vTWsKs5Tp4YojQvXVxGgS7xzk4eleLwVcR2fsvRysvcoiN5iam3kKVDwM3wYKQ1p5zjf
	HlltAXwxL2IJcbA==
X-Google-Smtp-Source: AGHT+IHUpxa+AFDsalaScWT+PaI/7X8t9Dfe+KZvLu6TKxNkbbHnFux7c9mcWOBJQvf3oEP5okfc7w==
X-Received: by 2002:a05:6000:18af:b0:391:888:f534 with SMTP id ffacd0b85a97d-3997f902e48mr5624942f8f.20.1742588132860;
        Fri, 21 Mar 2025 13:15:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43ecbsm86906665e9.10.2025.03.21.13.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 13:15:32 -0700 (PDT)
Message-ID: <6f30d2a2-0565-42cf-bc9a-e0c35e27627f@rivosinc.com>
Date: Fri, 21 Mar 2025 21:15:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/3] lib/riscv: Also provide sbiret impl
 functions
To: Andrew Jones <andrew.jones@linux.dev>, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: atishp@rivosinc.com, akshaybehl231@gmail.com
References: <20250321165403.57859-5-andrew.jones@linux.dev>
 <20250321165403.57859-6-andrew.jones@linux.dev>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250321165403.57859-6-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 21/03/2025 17:54, Andrew Jones wrote:
> We almost always return sbiret from sbi wrapper functions so
> do that for sbi_get_imp_version() and sbi_get_imp_id(), but
> asserting no error and returning the value is also useful,
> so continue to provide those functions too, just with a slightly
> different name.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/riscv/asm/sbi.h |  6 ++++--
>  lib/riscv/sbi.c     | 18 ++++++++++++++----
>  riscv/sbi-sse.c     |  4 ++--
>  3 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index edaee462c3fa..a5738a5ce209 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -260,9 +260,11 @@ struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
>  struct sbiret sbi_send_ipi_broadcast(void);
>  struct sbiret sbi_set_timer(unsigned long stime_value);
>  struct sbiret sbi_get_spec_version(void);
> -unsigned long sbi_get_imp_version(void);
> -unsigned long sbi_get_imp_id(void);
> +struct sbiret sbi_get_imp_version(void);
> +struct sbiret sbi_get_imp_id(void);
>  long sbi_probe(int ext);
> +unsigned long __sbi_get_imp_version(void);
> +unsigned long __sbi_get_imp_id(void);
>  
>  typedef void (*sbi_sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
>  
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 53d25489f905..2959378f64bb 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -183,21 +183,31 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>  }
>  
> -unsigned long sbi_get_imp_version(void)
> +struct sbiret sbi_get_imp_version(void)
> +{
> +	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_get_imp_id(void)
> +{
> +	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0, 0, 0, 0, 0, 0);
> +}
> +
> +unsigned long __sbi_get_imp_version(void)
>  {
>  	struct sbiret ret;
>  
> -	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0, 0, 0, 0, 0, 0);
> +	ret = sbi_get_imp_version();
>  	assert(!ret.error);
>  
>  	return ret.value;
>  }
>  
> -unsigned long sbi_get_imp_id(void)
> +unsigned long __sbi_get_imp_id(void)
>  {
>  	struct sbiret ret;
>  
> -	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0, 0, 0, 0, 0, 0);
> +	ret = sbi_get_imp_id();
>  	assert(!ret.error);
>  
>  	return ret.value;
> diff --git a/riscv/sbi-sse.c b/riscv/sbi-sse.c
> index 97e07725c359..bc6afaf5481e 100644
> --- a/riscv/sbi-sse.c
> +++ b/riscv/sbi-sse.c
> @@ -1232,8 +1232,8 @@ void check_sse(void)
>  		return;
>  	}
>  
> -	if (sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
> -	    sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7)) {
> +	if (__sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
> +	    __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7)) {
>  		report_skip("OpenSBI < v1.7 detected, skipping tests");
>  		report_prefix_pop();
>  		return;

Hi Andrew,

Looks good to me,

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément


