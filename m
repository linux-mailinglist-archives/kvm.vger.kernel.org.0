Return-Path: <kvm+bounces-44130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C6AA9AD8D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A5EF1892542
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BD227A92B;
	Thu, 24 Apr 2025 12:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="CV874tSA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27AE27A126
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 12:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745498107; cv=none; b=fvww0DMfrCJq7g/ER5wJeShWmNVIZuD/BnTxo3y9P1uGMVmt1PElJcOuik1PzsGrFJxmW3dVRAH7QzplbDCnLrAPI4yV9VUlb4f6SBiuB+ejdycOS/BuYePfAmmzlIyoL0/ooTDwJBQq7yfcqq39zK1JeC8HMAwe708l5nCMz1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745498107; c=relaxed/simple;
	bh=6IMg657M64uQmwN+jh4utQmYgOvUnVhFe0GlDIgoHdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ubXqjpERz3Yc6zBPLucMPDSmNcu3r5lyoaiMg0TpEmlIusmrqPp25xLl6hDj/Lakv0WRu/BF1tDkUFbVbY0vFN1+eJdzExRXkf/uxsUsxwI09xhnshmJ+FN3VomwJX+Fk5qvpMuXUoOeb+DHw35CK+Idl1c8Sr3QZFYXRZ5gEuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=CV874tSA; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf034d4abso9232995e9.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 05:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745498104; x=1746102904; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RNMAR2ow2m6nJc7QSxTl3I9Uc8Pm3w7ZW7eElxL9kzk=;
        b=CV874tSAThAe0Q8AGgsz2fCdMzfBqAqSPPVo0p2ZDGgV9llwVZRTwQps3gvfaXQTDa
         kkUuO2b/cfBdZ2UoxdeRsx5vA1PyNrAX8WvPfAE3YOz3YfWySMV5t4YevWxIVYEXMfUN
         CfH/MouZGAT74/G5lcdL1+VGu2GvVlJvH/JwC+OKyEKp37sfB8VAVMKPwZOwuIvB78DM
         qJanJ5YVKw7c2cGpV7GNSvWewii2CXwDPnX1A0xK8q9x48oMv1xquqgg4fLb52wxgku/
         /YvT86ItqK+X3EsyL5Q+hH3zGz6aiddUPQhxvXKaUjXlgGsbvN8fmhzCn4vPY7JmfYBX
         mjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745498104; x=1746102904;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RNMAR2ow2m6nJc7QSxTl3I9Uc8Pm3w7ZW7eElxL9kzk=;
        b=Cpx5SwxjJaUv8Th8oWNzMkh0K3PCa3BAK/HqjvAELhwWmDEP1ELITEOz+iU+WR26/4
         46uTv645AmRXrKeISuJN0Umtigp3xPGrlU9nPdxgw9YiuIQPSb6s6/rzhX9jRT8byEGy
         DVTQ/vHsamV8uuKzOpT0O7fD65fMbc/jAFQXCQXhHGLfN+Voe4VvMGmxNjmxMbMzJrkW
         OQousAlTh8fBBI3+F+Ra5JKXJpsveanqAe1P/rRyyOQ5AMNjAudqSqTFRbDSuoHIvRbG
         0Tdil2G2Wza5w2ksCXDrvUM2cpjIU0xureTWQOMqhOUyC3jbE6rGjVpfEvKi1pUesxve
         nUBg==
X-Forwarded-Encrypted: i=1; AJvYcCXEp/5WT6mE7wD6AyJV8k73a3LDx4+TVxuavQjkZlHOqkNBEdKy07yILw+MBuj0UYN8LK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVbZslDobDwZ9V2lL6nWs91uhQBDciuaa3sW/5L0JDdB7SF3Y5
	k2aEI8DEvdbqA0QmeV3vRa3F78wixfx//WPl9/eYb5Te5F26CglBVbr6rsg58R0=
X-Gm-Gg: ASbGncsIUMt6+NXlqxu+OCywKOSkck+Q2VO6dwKoMnFSoccmgnXwhpG1B/Y/8Ho6DKj
	vL9l1oGidKkXKpDL+ic3fdi2df03FQCK3Ke+WCvuQzbrjs4hm4MU3NxXRG+tdBvfK5DnOzxHcca
	+ByBDrsD88zKR6/2M/4SrdGUpJOyEOkof+tHRnrxSeQ0Ioi0VYWnKAEwX0Jq7R3CWEkFvfRGhGP
	178in4LxiqNY4gyxrBiHfIFhvru4iZqLfgbDYTL/tblPNhIybYEMfLf0m666kH1f2C8vuQmTrQD
	Qa8Dkt1MP4TNugW9ubAKsiPE6blF7Egaa+7NFds9sMlNBxsFZYz8dl488cTkNCHeBcmxqzxs58M
	Gji4BGcdRvw==
X-Google-Smtp-Source: AGHT+IGVtiMSUESCXxVr8lAA6TW/b8o7vs1YUH21uoFbmNmUInqOubAKtgP45r/urKl+RsY3D8dRJg==
X-Received: by 2002:a05:600c:1c8d:b0:43c:ed61:2c26 with SMTP id 5b1f17b1804b1-4409bd1f46cmr23664385e9.17.1745498103920;
        Thu, 24 Apr 2025 05:35:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2a2e59sm19303745e9.16.2025.04.24.05.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 05:35:03 -0700 (PDT)
Message-ID: <f6c5c92d-73aa-41a7-99bb-f95e388ea294@rivosinc.com>
Date: Thu, 24 Apr 2025 14:35:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/13] riscv: sbi: add SBI FWFT extension calls
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>
References: <20250417122337.547969-1-cleger@rivosinc.com>
 <20250417122337.547969-5-cleger@rivosinc.com>
 <20250424-c0700f89bcd29438d6d8d65c@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250424-c0700f89bcd29438d6d8d65c@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 24/04/2025 13:06, Andrew Jones wrote:
> On Thu, Apr 17, 2025 at 02:19:51PM +0200, Clément Léger wrote:
>> Add FWFT extension calls. This will be ratified in SBI V3.0 hence, it is
>> provided as a separate commit that can be left out if needed.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  arch/riscv/kernel/sbi.c | 20 +++++++++++++++++++-
>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
>> index 379981c2bb21..7b062189b184 100644
>> --- a/arch/riscv/kernel/sbi.c
>> +++ b/arch/riscv/kernel/sbi.c
>> @@ -299,6 +299,8 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
>>  	return 0;
>>  }
>>  
>> +static bool sbi_fwft_supported;
> 
> At some point we may want an SBI extension bitmap, but this is only the
> second SBI extension supported boolean that I'm aware of, so I guess we're
> still OK for now.

That seems reasonable to have a bitmap rather than duplicating
*ext*_supported. If that's something that bothers you, I can take care
of it and use a bitmap. SSE will also have a sse_supported boolean but
in it's own driver file though.

> 
>> +
>>  /**
>>   * sbi_fwft_set() - Set a feature on the local hart
>>   * @feature: The feature ID to be set
>> @@ -309,7 +311,15 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
>>   */
>>  int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags)
>>  {
>> -	return -EOPNOTSUPP;
>> +	struct sbiret ret;
>> +
>> +	if (!sbi_fwft_supported)
>> +		return -EOPNOTSUPP;
>> +
>> +	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET,
>> +			feature, value, flags, 0, 0, 0);
>> +
>> +	return sbi_err_map_linux_errno(ret.error);
>>  }
>>  
>>  struct fwft_set_req {
>> @@ -348,6 +358,9 @@ int sbi_fwft_local_set_cpumask(const cpumask_t *mask, u32 feature,
>>  		.error = ATOMIC_INIT(0),
>>  	};
>>  
>> +	if (!sbi_fwft_supported)
>> +		return -EOPNOTSUPP;
>> +
>>  	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
>>  		return -EINVAL;
>>  
>> @@ -679,6 +692,11 @@ void __init sbi_init(void)
>>  			pr_info("SBI DBCN extension detected\n");
>>  			sbi_debug_console_available = true;
>>  		}
>> +		if ((sbi_spec_version >= sbi_mk_version(3, 0)) &&
>> +		    (sbi_probe_extension(SBI_EXT_FWFT) > 0)) {
> 
> Unnecessary (), but I see it's consistent with the expressions above.

I can fix the other ones as well in another commit.

> 
>> +			pr_info("SBI FWFT extension detected\n");
>> +			sbi_fwft_supported = true;
>> +		}
>>  	} else {
>>  		__sbi_set_timer = __sbi_set_timer_v01;
>>  		__sbi_send_ipi	= __sbi_send_ipi_v01;
>> -- 
>> 2.49.0
>>

Thanks,

Clément

> 
> Besides the () nit
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


