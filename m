Return-Path: <kvm+bounces-41224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B80ABA64F9C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:47:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC3C418895A2
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B678F2356B0;
	Mon, 17 Mar 2025 12:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="p5i/4v81"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3014A1C
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742215643; cv=none; b=V2RxBKB9mm26p/dWqXmBm4KAMBYp8zVHuXdp4mWgSUy0oZ88abyEdQQeVdscILGoin07LoumvImlf4HeTKPhrqhRE/jhk/GdWF3KNoWFquNL/hcIdrRtlpPerAvbHEgR1lQCrJ+CyRY6W38CLWb2wIeoz1e8y+dHrwPMMk8Whz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742215643; c=relaxed/simple;
	bh=7KbwmA1jco05VCKAjBTC1QJtc2BxEfjKaLyzWSdYCUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ufuWfAEg5Euqg9GO+WjpZa6L20JloybEg26rCZuKfw5xEEAgEuuESR1EuMNejA0bkQZ+5eUJtNhiTxVD2t6OLByHvna33xxwtk63fEilovyyHD4WaxZeB9WhMJEuRBo1/4nqxz8qOjR+49xpRGBJ3962E75X0ozgCl+Hb+5ciaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=p5i/4v81; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39727fe912cso964205f8f.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 05:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742215639; x=1742820439; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vNJD2cRSyRbB5NBj1+laiOZcJuLA5D201yQLNYffdog=;
        b=p5i/4v81x2YriVrXqVNEfYovWgmcLUda4drNK5xg6rQIc/IBGJCj18rQ12BS/yxWOz
         q4JySFtHCOXT7ag7p082nsHIlDgKZ5NcdSBVJnafUdAaGXSx7QRByh96oz8rbtauQFzg
         hyTubGKIDSQcFHX7pN2Sjtt2OgRehzbI1DPB5wAyNianhBVE6lJ3pKcesB/S+GCD0W6N
         Z8JWfNFANK4il6sTKqGN5Oj1nIaS6yi3h00ifIhfMDR21qotS/mj0io+B9W7CHxvfYHw
         nDbcrjpdQR6om2y5gEPJ/KIJtKxCCIHCAnEQukhGcO3uKVyesPyaB/Jr1BHE1dzIZUVr
         VaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742215639; x=1742820439;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vNJD2cRSyRbB5NBj1+laiOZcJuLA5D201yQLNYffdog=;
        b=vGPx2l3j6hyb8q3fQAeWWvCQZX3gmPBUYJ9LdDljbNr/HquFNUv1U8017iYuNzFdm2
         0KhJ4OCRUq/kJNLnUOqPGcAikUVyHcSQLI8CmiCQCyuKGXYUVM3we5B0uwfvfqEKXBjQ
         1dYGdYyn5hsUtuexeLo/Tx6czPK0CqXWr1uqCju4lh5mIJNp+QbGaRwjHAArUHp93+T4
         DLE0UajX/0//UdoEaOlAd2myFOES/fT/GhXlHpHnuelZlW7Uzsp+ecbk1y8bQxBivy7q
         axDaMjLginxUrAsMG/8au+B7Ioi83XIMx9dG4giQCnKgSvRJWUNxdBJbsWZLzigHwgO6
         d/bw==
X-Gm-Message-State: AOJu0YzC/903igrVqtiASccjJDQrs9nuDLNgtHPxJkLQKULguWA0hlGE
	xI81eIBG02HcuRuGfzS6FDtsT2VHqzIBcW4i1w0FVvPRDl69r+sPMRzN0SbORa0=
X-Gm-Gg: ASbGnct7OPek2IXNLZEMq7EoUlpQbq2QQfAXBD0/DDJ2nbwJJkD6tWe2Ng7rez2yMzW
	18nGIs0pI7aUNgN01dVCie9zaD0Fp7q4aW0j2ecnIBQJJUX5DRpVTssRDDV4yz0JqIEY+KNkJBW
	/nZFbQsyFG8Lp53oJMWEXb0wrhhwGR5rZkUmW6wace6xiiC7/AtclFVNg9fjFxfTWLbhwAG2ZjV
	QiQVuM00zlFKwHP/jEnpGmFWHRDxVT11WCUQPtZlA0+AnN2d9GXrQcwDfC0wRUs8adgjRJmzQJw
	96fXchPI/CAWdmDDT09rpeOUvt+mfjsddR7jpYQIOcsK0MFVpBeINSYuOW/VwaSC+bDX3ZLDNwC
	FiizX1WPZZ7JUFg==
X-Google-Smtp-Source: AGHT+IEpuZB6qKXRMWj6Y8pohvlV6juT354mMXjwcMi8bCRONHm/KMR9R3MClLuFKOqk4e3NYgN1FQ==
X-Received: by 2002:a5d:6484:0:b0:38f:23f4:2d7a with SMTP id ffacd0b85a97d-3971f9e79fcmr14508312f8f.40.1742215638546;
        Mon, 17 Mar 2025 05:47:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7ebaa5sm14812406f8f.87.2025.03.17.05.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 05:47:18 -0700 (PDT)
Message-ID: <2214520b-4ee8-4147-806b-d25f3fc324fe@rivosinc.com>
Date: Mon, 17 Mar 2025 13:47:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v10 5/8] lib: riscv: add functions to get
 implementer ID and version
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250317101956.526834-1-cleger@rivosinc.com>
 <20250317101956.526834-6-cleger@rivosinc.com>
 <20250317-a53b74017397269b474dd6b9@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250317-a53b74017397269b474dd6b9@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 17/03/2025 13:46, Andrew Jones wrote:
> On Mon, Mar 17, 2025 at 11:19:51AM +0100, Clément Léger wrote:
>> These function will be used by SSE tests to check for a specific opensbi
>> version. sbi_impl_check() is an helper allowing to check for a specific
>> SBI implementor without needing to check for ret.error.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  lib/riscv/asm/sbi.h | 30 ++++++++++++++++++++++++++++++
>>  lib/riscv/sbi.c     | 10 ++++++++++
>>  2 files changed, 40 insertions(+)
>>
>> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
>> index 197288c7..06bcec16 100644
>> --- a/lib/riscv/asm/sbi.h
>> +++ b/lib/riscv/asm/sbi.h
>> @@ -18,6 +18,19 @@
>>  #define SBI_ERR_IO			-13
>>  #define SBI_ERR_DENIED_LOCKED		-14
>>  
>> +#define SBI_IMPL_BBL		0
>> +#define SBI_IMPL_OPENSBI	1
>> +#define SBI_IMPL_XVISOR		2
>> +#define SBI_IMPL_KVM		3
>> +#define SBI_IMPL_RUSTSBI	4
>> +#define SBI_IMPL_DIOSIX		5
>> +#define SBI_IMPL_COFFER		6
>> +#define SBI_IMPL_XEN Project	7
> 
> s/Project//
> 
>> +#define SBI_IMPL_POLARFIRE_HSS	8
>> +#define SBI_IMPL_COREBOOT	9
>> +#define SBI_IMPL_OREBOOT	10
>> +#define SBI_IMPL_BHYVE		11
>> +
>>  /* SBI spec version fields */
>>  #define SBI_SPEC_VERSION_DEFAULT	0x1
>>  #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
>> @@ -123,6 +136,10 @@ static inline unsigned long sbi_mk_version(unsigned long major, unsigned long mi
>>  		| (minor & SBI_SPEC_VERSION_MINOR_MASK);
>>  }
>>  
>> +static inline unsigned long sbi_impl_opensbi_mk_version(unsigned long major, unsigned long minor)
>> +{
>> +	return ((major << 16) | (minor));
> 
> Should at least mask minor, best to mask both.
> 
>> +}
>>  
>>  struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>>  			unsigned long arg1, unsigned long arg2,
>> @@ -139,7 +156,20 @@ struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
>>  struct sbiret sbi_send_ipi_broadcast(void);
>>  struct sbiret sbi_set_timer(unsigned long stime_value);
>>  struct sbiret sbi_get_spec_version(void);
>> +struct sbiret sbi_get_imp_version(void);
>> +struct sbiret sbi_get_imp_id(void);
>>  long sbi_probe(int ext);
>>  
>> +static inline bool sbi_check_impl(unsigned long impl)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_get_imp_id();
>> +	if (ret.error)
>> +		return false;
>> +
>> +	return ret.value == impl;
> 
> Or, more tersely,
> 
> struct sbiret ret = sbi_get_imp_id();
> return !ret.error && ret.value == impl;
> 
> but an assert would make more sense, since get-impl-id really shouldn't
> fail, unless the SBI version is 0.1, which we don't support.
> 
>> +}
>> +
>>  #endif /* !__ASSEMBLER__ */
>>  #endif /* _ASMRISCV_SBI_H_ */
>> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
>> index 3c395cff..9cb5757e 100644
>> --- a/lib/riscv/sbi.c
>> +++ b/lib/riscv/sbi.c
>> @@ -107,6 +107,16 @@ struct sbiret sbi_set_timer(unsigned long stime_value)
>>  	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
>>  }
>>  
>> +struct sbiret sbi_get_imp_version(void)
>> +{
>> +	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_VERSION, 0, 0, 0, 0, 0, 0);
>> +}
>> +
>> +struct sbiret sbi_get_imp_id(void)
>> +{
>> +	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_IMP_ID, 0, 0, 0, 0, 0, 0);
>> +}
> 
> Going with error asserts, then we can just put the asserts in these
> functions and return ret.value directly, like sbi_probe() does, which
> means sbi_check_impl() can be dropped.

Ack, I'll modify that.

Thanks,

Clément

> 
> Thanks,
> drew
> 
>> +
>>  struct sbiret sbi_get_spec_version(void)
>>  {
>>  	return sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
>> -- 
>> 2.47.2
>>


