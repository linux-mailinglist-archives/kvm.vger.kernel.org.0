Return-Path: <kvm+bounces-41724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAAAA6C416
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 21:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF8F83ABD9B
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6C2230264;
	Fri, 21 Mar 2025 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="qWQe9iPS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E8A2AD0C
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 20:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742588544; cv=none; b=pDyFk0jBYEHDHvJjdIrgVw5U36PiFPPnDETFcKed6VCC5QxFYPHw9gOM+5qxMY/y2Hi8v/CczqNpzfc+qCi/ldq/VvjhHt93/lsdD4LMjCYEY8I/68rnkFTZz7O6Rk8/35ltF+DsfD6mHYGWVGY5qN6lVauKPQ062czQGZO8bgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742588544; c=relaxed/simple;
	bh=6eEL1fRKLWKiLMnfWEctOTaB8ZCbFFppzO86vyti/WM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fotzYgwEHIT4VPPfWAYbxSklE12IcmCfNh+lDiD+GaaCOtEyMg3gsZbg4eKYuZGly0HNA73ePPRUpoPdFViFVBn9PPUNIVO3bSzYVRw40fa6YZZ6oH/zr2bleqfcPP1Q+yiSyEJbQd70E5/oECwQKukZ5TtVu95lvzErTAaXOEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=qWQe9iPS; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso17840505e9.3
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 13:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742588540; x=1743193340; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lzd4xG+2SwOBDBgUcXXvZKQ1fVJHEBo+Bv/RqZ5W6kU=;
        b=qWQe9iPSzR1m1e3YVNPgo98+Db1tsKWw4r/ELKOXrcdV25eeJvLqvJ24as/OFogtya
         fpX5Rtd+slikPgURzazraA2gdwiltnVunC8YpG+5L8k8XcJyUIwES/fuEP3HMGAwdjEv
         6O3BVQuxCyxAcxOBjDSmQWawVfl/Q1K0GAYFByhcVHkCN2D2rvBcTs4EEzxsSjg/e4H/
         vubkOKtPI929LB4q3vx3P4m2OluviTvnGGhV1bSld1Vp6PLaDHvSpEg6i8QC+xPzQHlD
         vtyyyVTDfe6ZT1pzk44spZq5XQUfeZau9flLYSxHQSOzpNRGL9RU830pl826p2gRvw0T
         zTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742588540; x=1743193340;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lzd4xG+2SwOBDBgUcXXvZKQ1fVJHEBo+Bv/RqZ5W6kU=;
        b=c/A+9qK9NKK7/+N5Zpa7yUpnJF+2G2/519IOsrWpiFX/zAA7g9z0WeSS2kUCsSbEUD
         EIXy+5sEFu4416R0CD2P2XLqh5nH6lIT8Vq9zsH7tvZiZe/c5ZTW/OB0djOzU//6SLtS
         0weEAyaeBb3MzVWchgMgnLi+ISQ1GGKbP3UEqYaUHX4XYEGNzeiLZnUUY4/7AsZJDmdo
         VDDjgLbrMnchUx14cALWUpvTmHYUL5+Q7Q80HgodOQlNS07PjkcPQlXCVKYAkUc19vMs
         34xoIvU0WrNFiE+aii7GG8uFy7RfdGrTpz3fvkjyK+cMEQ7ievmoEPCkGAB3zThLbdgT
         +/Iw==
X-Forwarded-Encrypted: i=1; AJvYcCVXPYypBFCK5f2wcRMejU5GEz5hGGMw3a7aVUOqJEVAtKB6S7U6gL8aPQTOfvHL4Zj20TQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX1D+wmPzLpdflYbyqkcUoKUBmTu7v1pjAxzvi6AqN/BwSNaC8
	p7gwjxycZ/UyqiUtHbLFEcxGTdS8ijjyHB3lve+XUZLeRGTBjWZneH9UyCVUdC0=
X-Gm-Gg: ASbGnculrVw52AmxAzrxCne7Qt3avuTkJgi1d8lor0lqrbkqyvJbMWPXUJRyKsdlGA+
	e2+SbseU/g4MuegCGqLgsbj9pyjam4R61xVDZa1pldCJVlD/M3tn6o9uKBvrzJXtc4oSOoBI+ZC
	pYIV2AdcRG29c8aa0L3Pk3V5Enj0R5Do3LYNqwydVOcttF+FF7t1TC5kXYWQoWAiy2GGEbzjcWU
	cIJX/wwStq36ij/cojbYggcjV5ywH+AqqdZ6UovME+TzVGLk3jiPX7RDwAXbpdVKsAsmQ9dLyjM
	dUzc8OcznFO3T+htuDMn6hZuZIB1t5JGSlByxLu8nPwbt7m4PxVSdNPoRxvME1f1RUB9mdCoLe5
	XbAcFnGFnDEYgPVl+P72uJhsP
X-Google-Smtp-Source: AGHT+IFMDdsZ0mN9HV7XN3ROBaSzzyRHTn5AWR0glOM3qL5vAkyivsz/PmDNRERlqpzG7S9gLmtOaw==
X-Received: by 2002:a05:600c:1548:b0:43c:f513:9591 with SMTP id 5b1f17b1804b1-43d509f73admr46812415e9.14.1742588540177;
        Fri, 21 Mar 2025 13:22:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9e6544sm3302589f8f.68.2025.03.21.13.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 13:22:19 -0700 (PDT)
Message-ID: <dba5ed81-6557-45aa-8246-0c9e6d6c18a0@rivosinc.com>
Date: Fri, 21 Mar 2025 21:22:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 3/3] riscv: sbi: Use kfail for known
 opensbi failures
To: Andrew Jones <andrew.jones@linux.dev>, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: atishp@rivosinc.com, akshaybehl231@gmail.com
References: <20250321165403.57859-5-andrew.jones@linux.dev>
 <20250321165403.57859-8-andrew.jones@linux.dev>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250321165403.57859-8-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 21/03/2025 17:54, Andrew Jones wrote:
> Use kfail for the opensbi s/SBI_ERR_DENIED/SBI_ERR_DENIED_LOCKED/
> change. We expect it to be fixed in 1.7, so only kfail for opensbi
> which has a version less than that. Also change the other uses of
> kfail to only kfail for opensbi versions less than 1.7.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  riscv/sbi-fwft.c | 20 +++++++++++++-------
>  riscv/sbi.c      |  6 ++++--
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/riscv/sbi-fwft.c b/riscv/sbi-fwft.c
> index 3d225997c0ec..c52fbd6e77a6 100644
> --- a/riscv/sbi-fwft.c
> +++ b/riscv/sbi-fwft.c
> @@ -83,19 +83,21 @@ static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
>  
>  	report_prefix_push("locked");
>  
> +	bool kfail = __sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
> +		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
> +
>  	for (int i = 0; i < nr_values; ++i) {
>  		ret = fwft_set(feature, test_values[i], 0);
> -		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> -			"Set to %lu without lock flag", test_values[i]);
> +		sbiret_kfail_error(kfail, &ret, SBI_ERR_DENIED_LOCKED,
> +				   "Set to %lu without lock flag", test_values[i]);
>  
>  		ret = fwft_set(feature, test_values[i], SBI_FWFT_SET_FLAG_LOCK);
> -		sbiret_report_error(&ret, SBI_ERR_DENIED_LOCKED,
> -			"Set to %lu with lock flag", test_values[i]);
> +		sbiret_kfail_error(kfail, &ret, SBI_ERR_DENIED_LOCKED,
> +				   "Set to %lu with lock flag", test_values[i]);
>  	}
>  
>  	ret = fwft_get(feature);
> -	sbiret_report(&ret, SBI_SUCCESS, locked_value,
> -		"Get value %lu", locked_value);
> +	sbiret_report(&ret, SBI_SUCCESS, locked_value, "Get value %lu", locked_value);

Reformatting ?

>  
>  	report_prefix_pop();
>  }
> @@ -103,6 +105,7 @@ static void fwft_feature_lock_test_values(uint32_t feature, size_t nr_values,
>  static void fwft_feature_lock_test(uint32_t feature, unsigned long locked_value)
>  {
>  	unsigned long values[] = {0, 1};
> +

That's some spurious newline here.


>  	fwft_feature_lock_test_values(feature, 2, values, locked_value);
>  }
>  
> @@ -317,7 +320,10 @@ static void fwft_check_pte_ad_hw_updating(void)
>  	report(ret.value == 0 || ret.value == 1, "first get value is 0/1");
>  
>  	enabled = ret.value;
> -	report_kfail(true, !enabled, "resets to 0");
> +
> +	bool kfail = __sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
> +		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
> +	report_kfail(kfail, !enabled, "resets to 0");
>  
>  	install_exception_handler(EXC_LOAD_PAGE_FAULT, adue_read_handler);
>  	install_exception_handler(EXC_STORE_PAGE_FAULT, adue_write_handler);
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 83bc55125d46..edb1a6bef1ac 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -515,10 +515,12 @@ end_two:
>  	sbiret_report_error(&ret, SBI_SUCCESS, "no targets, hart_mask_base is 1");
>  
>  	/* Try the next higher hartid than the max */
> +	bool kfail = __sbi_get_imp_id() == SBI_IMPL_OPENSBI &&
> +		     __sbi_get_imp_version() < sbi_impl_opensbi_mk_version(1, 7);
>  	ret = sbi_send_ipi(2, max_hartid);> -	report_kfail(true, ret.error
== SBI_ERR_INVALID_PARAM, "hart_mask got expected error (%ld)", ret.error);
> +	sbiret_kfail_error(kfail, &ret, SBI_ERR_INVALID_PARAM, "hart_mask");
>  	ret = sbi_send_ipi(1, max_hartid + 1);
> -	report_kfail(true, ret.error == SBI_ERR_INVALID_PARAM, "hart_mask_base got expected error (%ld)", ret.error);
> +	sbiret_kfail_error(kfail, &ret, SBI_ERR_INVALID_PARAM, "hart_mask_base");
>  
>  	report_prefix_pop();
>  

Hi Andrew,

I tried thinking of some way to factorize the version check but can't
really find something elegant. Without the spurious newline:

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément

