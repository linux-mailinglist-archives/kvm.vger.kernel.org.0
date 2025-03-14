Return-Path: <kvm+bounces-41049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4E1A60FDB
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:22:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AED0C1B607A1
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 311991FECAB;
	Fri, 14 Mar 2025 11:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="bqbPhERJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506881FE44E
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741951289; cv=none; b=M0uzNvB6eGu3VfzDgjtGdI4xwEHImMEdif2c8PUoyFvzH3jJq3Nx2PV4tBQmlb2ZbwICiHB9uFvn9mNLIKB4Ttl2q1ysIChBCOJf8PODzCpt8tKl2FOcx8t3QH8HmCxQ8GtX6aMMtolEfVL3TJq65VkMnzd+4TyP2Ji79vjVv3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741951289; c=relaxed/simple;
	bh=CxQhkQEHcVp50sqGLhhVeW5rEWOlyU0IM4BxFtlaXac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FvTUHJi/6zqG8/snssD2wfNwumY0ZjRmFqZ/k3o41FDmXCgq8/WjA8W7qI6Pie7QBliuJURcZ/n0XUfyB1FaCHudQRtOZaNgEHjHRkna6Y9rydV2y1fEzrh7ynpKPQFUjj56jo0KaaWQiU/R9RPSa9uiwoFclPUqMLqoUIbL43Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=bqbPhERJ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43ce70f9afbso17876275e9.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 04:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741951286; x=1742556086; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A6XtzYhqUw84uSezb9doRczkUr+a5kXQaPrl1FQvJuA=;
        b=bqbPhERJhaprC4ZfVm+Gk5HBFmD7bbvxPLmobJO2El7zfnDpyfiecoHumIqThd1N9M
         iBBL+b5bpcuY3EbOAzIPRvhW6Vd16Pa5IaRf/lZRJCqYAT8Ts4AKezOLRvVj5ELk4xT3
         wPjLpNH8Vegf/e0OyB9D2d8KG1ycm1+VV6Odtbi7kgtyhawG31/6qmxoLret/r15zUnD
         PtaQSzLbbjcrthDqFSCSdvkRed7WGWe6TLrwFb+Ovn7UfGss3YVastAAicQQQlaMDxd/
         75SVmd80NoiH13GOgyzR0zBqCR/1nTfZeNzHJag0+8yj4wzntj2OyXJ7bTp0x7gPdY86
         UPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741951286; x=1742556086;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A6XtzYhqUw84uSezb9doRczkUr+a5kXQaPrl1FQvJuA=;
        b=wy7DZONWHo6T2R7o7inbAxKr8yQgg090asEnhHoqd7lwK+tlxm4SnL1V/gby2WTVso
         kTkb9bjBTzeG4XDTxg3t3TjsONh1QI9njISfA7Fy0bHxwxT2Pd+aNOqx+SL8jfMZcOfZ
         tDDT0XcVO/Jc88j5mRy8BhqiB4gbTBY9DIJO4ZWMxG7uSmYgWPoTeqSNGkIS55eaTm8W
         sJ3OXk2BcZ21fGdsl6eRJ2ARPotGVk7VyqCpzjKaqCF82kzHjpxS9v+0okSuy18A0Lgt
         CxnEfmimk0r02Me9Fo7qNJVfTeUMimTfWFY+AfiEVhoumqUTXFQ1l+4JAWxPqqW9c5fe
         HJcA==
X-Forwarded-Encrypted: i=1; AJvYcCVblEIfJtgMFXq4AA7GGTOjHxZ2yJy6WP8zUGirVAYS7UoUzvI7oOifFLIb0gmwVrVUktg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu4xWX/iz9uRLNgzizpB785DgfVuL9rXtsWUk8MKCIhvvEDpOr
	pCip7oqj+N8ESwTIjDa5uh4zzNF3Vmbeu1SPFg0xrfbXOsUBL/94i5lzTB9P4yM=
X-Gm-Gg: ASbGnct3QCJ6slf8V6L2+H3ICXFT1QFQtmukMxDnhyN+ECViIVUQikAKgGMawnmbm3v
	NjjSsoWLOURqsLpx8O0XliYdGYUd8lpVI30bJiBipBKVLNFVCOAWfXze8LfyV+1WX9oCjoZntn6
	f8rSr9jnl0M1WVrtsnGYRMZkjIK2z1G7AYxWXrdY0XP7SHgsposrmsTdtQ1SloS9D66ZIRM71sC
	YJdPdoXVlqz7tJhYaKgKwkqEII8UoreCWZgo1s57ebrQT1RcuJmMzs6Pwm+lNd4Yo0Jwr3mrnaW
	Yl591mfLhGt9O9f4KhQsCfg3qeIbKU6B+FlTYUP/x/dtj+qzom/JBuyeF/mB2pMgxTJ2pGQ1/v1
	Vj1mbhEp5VDG5uA==
X-Google-Smtp-Source: AGHT+IEYaWqqZpuQnf2ljZyi0dtBkuDfK6pK0aoroD3vMSUCfCqdnElivAtTAt81Xq+zCSEqCysJ0Q==
X-Received: by 2002:a05:600c:190e:b0:43c:f513:9585 with SMTP id 5b1f17b1804b1-43d1ec808ebmr27086195e9.13.1741951285516;
        Fri, 14 Mar 2025 04:21:25 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d200fac7asm14341405e9.28.2025.03.14.04.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 04:21:25 -0700 (PDT)
Message-ID: <c411446b-e161-48fa-a94b-e04c00f62b01@rivosinc.com>
Date: Fri, 14 Mar 2025 12:21:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/17] riscv: sbi: add SBI FWFT extension calls
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-4-cleger@rivosinc.com>
 <20250313-ce439653d16b484dba6a8d3e@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250313-ce439653d16b484dba6a8d3e@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 13/03/2025 13:44, Andrew Jones wrote:
> On Mon, Mar 10, 2025 at 04:12:10PM +0100, Clément Léger wrote:
>> Add FWFT extension calls. This will be ratified in SBI V3.0 hence, it is
>> provided as a separate commit that can be left out if needed.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  arch/riscv/kernel/sbi.c | 30 ++++++++++++++++++++++++++++--
>>  1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
>> index 256910db1307..af8e2199e32d 100644
>> --- a/arch/riscv/kernel/sbi.c
>> +++ b/arch/riscv/kernel/sbi.c
>> @@ -299,9 +299,19 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
>>  	return 0;
>>  }
>>  
>> +static bool sbi_fwft_supported;
>> +
>>  int sbi_fwft_get(u32 feature, unsigned long *value)
>>  {
>> -	return -EOPNOTSUPP;
>> +	struct sbiret ret;
>> +
>> +	if (!sbi_fwft_supported)
>> +		return -EOPNOTSUPP;
>> +
>> +	ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_GET,
>> +			feature, 0, 0, 0, 0, 0);
>> +
>> +	return sbi_err_map_linux_errno(ret.error);
>>  }
>>  
>>  /**
>> @@ -314,7 +324,15 @@ int sbi_fwft_get(u32 feature, unsigned long *value)
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
> 
> sbi_err_map_linux_errno() doesn't know about SBI_ERR_DENIED_LOCKED.

Not only it doesn't knows about DENIED_LOCKED but also another bunch of
errors. I'll add them in a separate commit.

> 
>>  }
>>  
>>  struct fwft_set_req {
>> @@ -389,6 +407,9 @@ static int sbi_fwft_feature_local_set(u32 feature, unsigned long value,
>>  int sbi_fwft_all_cpus_set(u32 feature, unsigned long value, unsigned long flags,
>>  			  bool revert_on_fail)
>>  {
>> +	if (!sbi_fwft_supported)
>> +		return -EOPNOTSUPP;
>> +
>>  	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
>>  		return sbi_fwft_set(feature, value, flags);
>>  
>> @@ -719,6 +740,11 @@ void __init sbi_init(void)
>>  			pr_info("SBI DBCN extension detected\n");
>>  			sbi_debug_console_available = true;
>>  		}
>> +		if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
> 
> Should check sbi_mk_version(3, 0)

Oh yes that was for testing purpose and I incorrectly squashed it.

> 
>> +		    (sbi_probe_extension(SBI_EXT_FWFT) > 0)) {
>> +			pr_info("SBI FWFT extension detected\n");
>> +			sbi_fwft_supported = true;
>> +		}
>>  	} else {
>>  		__sbi_set_timer = __sbi_set_timer_v01;
>>  		__sbi_send_ipi	= __sbi_send_ipi_v01;
>> -- 
>> 2.47.2
>>
> 

Thanks,

Clément

> Thanks,
> drew


