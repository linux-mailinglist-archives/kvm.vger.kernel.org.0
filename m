Return-Path: <kvm+bounces-40921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B76AEA5F4C5
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 13:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECA181746B1
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 12:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26B42676CB;
	Thu, 13 Mar 2025 12:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="o/GrbqLC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2996B26659C
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 12:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741869861; cv=none; b=i/qDlqOQnfQB/v/WaoFy9eBMgrFg1YNtN1/eVzGEYjcV+kOUk8aIyfLhBgAY+LsEPzZ6y2FvmNmTjmiglRzopciPZRKTsmLeAlzkMV4oLV/gMQps+owOsiWP5O7wrahRQRyZj9VddyjpB6JQDqSHJIcRsWAWvfqkA93mkG34ulg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741869861; c=relaxed/simple;
	bh=EleUDN0p7TORHE0wSEwSE0kj+mfdR9PO/rSWsPpYYTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C931trAEHRiUWgePGEs8EHqTC3nb1/9wMHJ8sa35D0s1Bjz3DN1zO+eZV5EqDurMjzvB8Yy3b/d01gqCYXjmbJ3BxyINCBLhep12+oBwIpEiYLlhS1nWLYWEbG4/UHi36nmmSHbpUFv/GPhSpKjPBunWZ0Wo0Tew7Z8ZQXm3OSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=o/GrbqLC; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3914aba1ce4so736836f8f.2
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741869857; x=1742474657; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p4eBilR3cQKKkUL6iTV1U2gPm+aqkc/I2/ErCrbp51A=;
        b=o/GrbqLCeyyu8Cw/4q1t9rjSCjvoqeKges7sjFAbL8xsEX4XHQpHVCLphDjin3B9OI
         bzH0u6lO2okzsgxF40lvXb5ECkMBJO6/cCjV6DKWv6Kglw7bDGRuvSQCrUntcbN9VjSS
         nQH0avWE+dP1UHHjTjRQ5e4RlCeU4leL0UL107u6LhJYTBUi7fey8r6o3xMEVgwBW+EB
         KFjWy39uxnnNuTrhFMFPiOvmuCqxhDcbXQ9U0Y1+4lHLBJ4+IX6f47JFGM0jPYQOYCiy
         0VBR2fo1zX4/RvWsoHbsxtYsWV8x+Ja7FTK46XSHdb4t66myUDN/WnJX6+2lVUWsnuei
         WYpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741869857; x=1742474657;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p4eBilR3cQKKkUL6iTV1U2gPm+aqkc/I2/ErCrbp51A=;
        b=dhevCIEX5NmcNN5ZKqJLypBNiftjvw+oM8hRIECZLXFUxbFMy2la4xnvJEeArVhfyx
         QYns6J9uaFqvCp5rIruIDFMnIwu2Gk+Mbm7qssVBMf5r+rmroOUXiZmuwZyClHwSAmIk
         fuNK8qYF6q99o4uHaZuPz6sjOmgeE+OKwX5rWkOvAxogqRaJmOTv1FAdRMbEz1yTqHJu
         SwA3OOK3gejqtGOiGpAzv0C3TNeNoN0XJ52/gleiZVvS9ZRd1BtX8P5fnrrQHrAe/9sX
         8NYpIDM7PnXYC1Zhs6En779AMAc2h2akv+39olONlas0OG1qiLBRRlUJ7Y2hXoEMvQzc
         1O/A==
X-Forwarded-Encrypted: i=1; AJvYcCVsSF3ZObEG+XtMygR9ZZgfACV8itdINf16Ca1eDRYnn9VCU8147bfJLZUobgyOFLKQB+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcR4N2gyrDFaFU3RdyFPvSW9znZ3ovrm8IVxZyHqdSN37IY2SV
	9uBlHhBSuWFOgDVtQUlfT7I+6EWhRxvFmqlgtnrzYOOsgyABrsMROgiWiDqaPrY=
X-Gm-Gg: ASbGnctSj7K7eCDZyvBk0D/4S9xhDOZe7OXarC+sQVuGG/FTMESwpVDMrZgBfTAYUOm
	BJeVdVH6Cngq4aUFYV4dWmYc1//37LFoID7Tla5mTxI/qpiJJsZ8dkVWBKbt0pYUT89HJIVpD6d
	89PgOtw1mlUAlNb77i4ns3KcppXOQK1iStinzGCOtv+mjAfSw/C/HQ/hXpio30pDKSsUP8OZV7f
	CFe02r1RSWGa40AzysnuxM6+zYC+xB4kJJxJjHaLOXaXaR5oR5p6iK+5lylmdPP0HMzvk52+XhL
	YGxLaexE4+QZOWCjoxKEnnH0U6rN8ae3nj2cIw5FAoU=
X-Google-Smtp-Source: AGHT+IEVKvciONpN7IaLFK/qsTCvmNWqORyhjjKaAjaSuACjOZk+fDyP3VpTM/ig5PwqolpsjOd7kg==
X-Received: by 2002:a05:6000:1a87:b0:391:1923:5a91 with SMTP id ffacd0b85a97d-39132dc4395mr17992640f8f.55.1741869857406;
        Thu, 13 Mar 2025 05:44:17 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c83b6e87sm2097439f8f.32.2025.03.13.05.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 05:44:16 -0700 (PDT)
Date: Thu, 13 Mar 2025 13:44:16 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v3 03/17] riscv: sbi: add SBI FWFT extension calls
Message-ID: <20250313-ce439653d16b484dba6a8d3e@orel>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-4-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310151229.2365992-4-cleger@rivosinc.com>

On Mon, Mar 10, 2025 at 04:12:10PM +0100, Clément Léger wrote:
> Add FWFT extension calls. This will be ratified in SBI V3.0 hence, it is
> provided as a separate commit that can be left out if needed.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/kernel/sbi.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
> index 256910db1307..af8e2199e32d 100644
> --- a/arch/riscv/kernel/sbi.c
> +++ b/arch/riscv/kernel/sbi.c
> @@ -299,9 +299,19 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
>  	return 0;
>  }
>  
> +static bool sbi_fwft_supported;
> +
>  int sbi_fwft_get(u32 feature, unsigned long *value)
>  {
> -	return -EOPNOTSUPP;
> +	struct sbiret ret;
> +
> +	if (!sbi_fwft_supported)
> +		return -EOPNOTSUPP;
> +
> +	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET,
> +			feature, 0, 0, 0, 0, 0);
> +
> +	return sbi_err_map_linux_errno(ret.error);
>  }
>  
>  /**
> @@ -314,7 +324,15 @@ int sbi_fwft_get(u32 feature, unsigned long *value)
>   */
>  int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags)
>  {
> -	return -EOPNOTSUPP;
> +	struct sbiret ret;
> +
> +	if (!sbi_fwft_supported)
> +		return -EOPNOTSUPP;
> +
> +	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
> +			feature, value, flags, 0, 0, 0);
> +
> +	return sbi_err_map_linux_errno(ret.error);

sbi_err_map_linux_errno() doesn't know about SBI_ERR_DENIED_LOCKED.

>  }
>  
>  struct fwft_set_req {
> @@ -389,6 +407,9 @@ static int sbi_fwft_feature_local_set(u32 feature, unsigned long value,
>  int sbi_fwft_all_cpus_set(u32 feature, unsigned long value, unsigned long flags,
>  			  bool revert_on_fail)
>  {
> +	if (!sbi_fwft_supported)
> +		return -EOPNOTSUPP;
> +
>  	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
>  		return sbi_fwft_set(feature, value, flags);
>  
> @@ -719,6 +740,11 @@ void __init sbi_init(void)
>  			pr_info("SBI DBCN extension detected\n");
>  			sbi_debug_console_available = true;
>  		}
> +		if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&

Should check sbi_mk_version(3, 0)

> +		    (sbi_probe_extension(SBI_EXT_FWFT) > 0)) {
> +			pr_info("SBI FWFT extension detected\n");
> +			sbi_fwft_supported = true;
> +		}
>  	} else {
>  		__sbi_set_timer = __sbi_set_timer_v01;
>  		__sbi_send_ipi	= __sbi_send_ipi_v01;
> -- 
> 2.47.2
>

Thanks,
drew

