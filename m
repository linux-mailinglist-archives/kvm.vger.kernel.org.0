Return-Path: <kvm+bounces-41050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F941A61000
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF2C91B610B4
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC39A1FDA94;
	Fri, 14 Mar 2025 11:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vCtRBqFz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DA51FCFE7
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741952041; cv=none; b=SPCUrcCIUOgL34k8OfWICUe72dCpmjH6jaoiFM20oAhHc4zkWxBIwViAD4ZU7sESE9Evpc9xOnJV7T0DxWxQkfo8bBNWAWC4FV9p+RZ2dHLolcl1Ar/e0lNmt1tGRpOpR8Lz/7IGfM0MNxpL6iaCg4y4bp+Y2l1+6m/Ca8FAy04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741952041; c=relaxed/simple;
	bh=VFo619g1ewrwqe/TdYiWkAB8pKkLXxjuW43KtWiO5EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UWM2Qd8xOqqeiqisk7wCavblkTxyXKqsJHvAghZH25SgEk8BSAqbyR3hCk74o+eUwI2H2IAecamlXctTEA6m3LH+6861x5R84kBXNXd142PyUbW5/6WzCPW0LBpD0a4LrMUjYxIj92ji+QsBdCoSUvzQbD1KRqW399HxxZp6TYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vCtRBqFz; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-390f5f48eafso1168151f8f.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 04:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741952037; x=1742556837; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nsvbx0/e3umNGv5t27NVbjQ76HCEZqmQcUDkEBMQhSw=;
        b=vCtRBqFzOc8z91AC5oBWsRqbEqxKYvRIXZ55bTJ+2REe30JiBEn8OuLpAR+GzOxSjz
         WDSDsPr9CFy8Tl3n6qmu230zpJIIg2UU97T2bKuBWKDiS7c92MzJI03iV62Hz1rTtu9l
         LRA1jv0sEbPDwL4Mxj4JcVUfq4vo5BP6wCpzPaJWyJtBJ/XOqAWzST+LxeoAq+Nt9ps8
         9ePmnTdzDjAl2QIhQ4OHX6il0LHH77Cq/N2DAFhqU3llu5KUt5yJFJuFncEjklLYL9tr
         /6HGxDHusyIHHSIQDjWw/r87Msb1fMfR+o8mB3pTVmKkP/qxqieaNoVnNHcxjOSPAQbS
         1ElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741952037; x=1742556837;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nsvbx0/e3umNGv5t27NVbjQ76HCEZqmQcUDkEBMQhSw=;
        b=PGTdrxj7CKgR4zT8ueCjKgwVRVlArzoJgT/NQ42LZD3l8bkfvkKmDNqRj3S5dG17xD
         Zh1jY2ZUlpnV14rNCM7YcLSUXlo+9N6mZCSXU3Qod5z715i/Rjwhrold0BfMgun2WIht
         1y3tiS7i77ONElMX2tnkyrAIc/FeB5tM9snWv3Y/bX2CxPeYY4/NDJr4AEOflX3WNEZK
         TU74vfZ0zJR+oCHBqd1Jw6u/vB5VkvItlcnwpINcA/4PpIP2IW7LED2wqC/kUSDwtFu+
         Y1syZO3zhqO6bMrRtXWhaUXNU8Rj5FZtp5mdyStFG+o5j8jBV0D9kiabMpd7z2LCGJae
         iBKA==
X-Forwarded-Encrypted: i=1; AJvYcCWf4fGH5vNEjge9AGrAWAlr15F1dk18T8djdI68DUkweBdEUlfmi6G7CU7Ii4PwL22eevQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqflaIb2KvGHT2yMafYFtds8KY97Y5qP/XFqhUMah7yWscPKCm
	41LUaX7Mew8LHS19RY6qg3Tjtpho1v4x0dvuycgZ6H5DXnwwscZ6h/8fgXiSp5o=
X-Gm-Gg: ASbGncs0ihkiqW5BYDIzrbq6j5WIUFJQdv0eF+B5EHhlqH+3lenuEeLiFiybMwFRw/r
	sDy0v66e9gTo6Lcrhrq7ayGItTtTrlONzKsb1sfpIn4GOUmLwLNJ5kpvpU4ReUBZH9v3a7DcBod
	Jexnwv3VoV9fQM3mqa5fB3eF6TeUZoTEXSObM8H1DWar0R+OBikxpgYLviySuq1obtlLAjTgLSu
	TrDSZjcB1fYTPRmDhM09984kAA/h44tAo0jd4Nq1pEkJUIleDULsPNHKieDsFrjdnpqm4XhVxaS
	/6pt4izHV0kvsa9/pzk03yr4PN3XYcL12uM6/zIXFQvZShkV4BT73TJvKHvJfXnrRViuaMRwHvt
	lXJaY60p2MphbNQ==
X-Google-Smtp-Source: AGHT+IGFCS6aHC85bI1G02X5ARi0quKTYrYIojfOtWsQSuEVwoRIcZmL2DpiMo0uOfjcu6utBxTbug==
X-Received: by 2002:a05:6000:4025:b0:391:1139:2653 with SMTP id ffacd0b85a97d-3971ffb3a29mr1899191f8f.52.1741952036756;
        Fri, 14 Mar 2025 04:33:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fe65977sm14993745e9.36.2025.03.14.04.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 04:33:56 -0700 (PDT)
Message-ID: <dad465de-e5da-4ebb-8395-ea9e181a6f57@rivosinc.com>
Date: Fri, 14 Mar 2025 12:33:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/17] riscv: sbi: add FWFT extension interface
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-3-cleger@rivosinc.com>
 <20250313-5c22df0c08337905367fa125@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250313-5c22df0c08337905367fa125@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 13/03/2025 13:39, Andrew Jones wrote:
> On Mon, Mar 10, 2025 at 04:12:09PM +0100, Clément Léger wrote:
>> This SBI extensions enables supervisor mode to control feature that are
>> under M-mode control (For instance, Svadu menvcfg ADUE bit, Ssdbltrp
>> DTE, etc).
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  arch/riscv/include/asm/sbi.h |  5 ++
>>  arch/riscv/kernel/sbi.c      | 97 ++++++++++++++++++++++++++++++++++++
>>  2 files changed, 102 insertions(+)
>>
>> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
>> index bb077d0c912f..fc87c609c11a 100644
>> --- a/arch/riscv/include/asm/sbi.h
>> +++ b/arch/riscv/include/asm/sbi.h
>> @@ -503,6 +503,11 @@ int sbi_remote_hfence_vvma_asid(const struct cpumask *cpu_mask,
>>  				unsigned long asid);
>>  long sbi_probe_extension(int ext);
>>  
>> +int sbi_fwft_all_cpus_set(u32 feature, unsigned long value, unsigned long flags,
>> +			  bool revert_on_failure);
>> +int sbi_fwft_get(u32 feature, unsigned long *value);
>> +int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags);
>> +
>>  /* Check if current SBI specification version is 0.1 or not */
>>  static inline int sbi_spec_is_0_1(void)
>>  {
>> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
>> index 1989b8cade1b..256910db1307 100644
>> --- a/arch/riscv/kernel/sbi.c
>> +++ b/arch/riscv/kernel/sbi.c
>> @@ -299,6 +299,103 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
>>  	return 0;
>>  }
>>  
>> +int sbi_fwft_get(u32 feature, unsigned long *value)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>> +
>> +/**
>> + * sbi_fwft_set() - Set a feature on all online cpus
> 
> copy+paste of description from sbi_fwft_all_cpus_set(). This function
> only sets the feature on the calling hart.
> 
>> + * @feature: The feature to be set
>> + * @value: The feature value to be set
>> + * @flags: FWFT feature set flags
>> + *
>> + * Return: 0 on success, appropriate linux error code otherwise.
>> + */
>> +int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>> +
>> +struct fwft_set_req {
>> +	u32 feature;
>> +	unsigned long value;
>> +	unsigned long flags;
>> +	cpumask_t mask;
>> +};
>> +
>> +static void cpu_sbi_fwft_set(void *arg)
>> +{
>> +	struct fwft_set_req *req = arg;
>> +
>> +	if (sbi_fwft_set(req->feature, req->value, req->flags))
>> +		cpumask_clear_cpu(smp_processor_id(), &req->mask);
>> +}
>> +
>> +static int sbi_fwft_feature_local_set(u32 feature, unsigned long value,
>> +				      unsigned long flags,
>> +				      bool revert_on_fail)
>> +{
>> +	int ret;
>> +	unsigned long prev_value;
>> +	cpumask_t tmp;
>> +	struct fwft_set_req req = {
>> +		.feature = feature,
>> +		.value = value,
>> +		.flags = flags,
>> +	};
>> +
>> +	cpumask_copy(&req.mask, cpu_online_mask);
>> +
>> +	/* We can not revert if features are locked */
>> +	if (revert_on_fail && flags & SBI_FWFT_SET_FLAG_LOCK)
> 
> Should use () around the flags &. I thought checkpatch complained about
> that?
> 
>> +		return -EINVAL;
>> +
>> +	/* Reset value is the same for all cpus, read it once. */
> 
> How do we know we're reading the reset value? sbi_fwft_all_cpus_set() may
> be called multiple times on the same feature. And harts may have had
> sbi_fwft_set() called on them independently. I think we should drop the
> whole prev_value optimization.

That's actually used for revert_on_failure as well not only the
optimization.

> 
>> +	ret = sbi_fwft_get(feature, &prev_value);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Feature might already be set to the value we want */
>> +	if (prev_value == value)
>> +		return 0;
>> +
>> +	on_each_cpu_mask(&req.mask, cpu_sbi_fwft_set, &req, 1);
>> +	if (cpumask_equal(&req.mask, cpu_online_mask))
>> +		return 0;
>> +
>> +	pr_err("Failed to set feature %x for all online cpus, reverting\n",
>> +	       feature);
> 
> nit: I'd let the above line stick out. We have 100 chars.
> 
>> +
>> +	req.value = prev_value;
>> +	cpumask_copy(&tmp, &req.mask);
>> +	on_each_cpu_mask(&req.mask, cpu_sbi_fwft_set, &req, 1);
>> +	if (cpumask_equal(&req.mask, &tmp))
>> +		return 0;
> 
> I'm not sure we want the revert_on_fail support either. What happens when
> the revert fails and we return -EINVAL below? Also returning zero when
> revert succeeds means the caller won't know if we successfully set what
> we wanted or just successfully reverted.

So that might actually be needed for features that needs to be enabled
on all hart or not enabled at all. If we fail to enable all of them,
them the hart will be in some non coherent state between the harts.
The returned error code though is wrong and I'm not sure we would have a
way to gracefully handle revertion failure (except maybe panicking ?).

Thanks,

Clément

> 
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +/**
>> + * sbi_fwft_all_cpus_set() - Set a feature on all online cpus
>> + * @feature: The feature to be set
>> + * @value: The feature value to be set
>> + * @flags: FWFT feature set flags
>> + * @revert_on_fail: true if feature value should be restored to it's orignal
> 
> its original
> 
>> + * 		    value on failure.
> 
> Line 'value' up under 'true'
> 
>> + *
>> + * Return: 0 on success, appropriate linux error code otherwise.
>> + */
>> +int sbi_fwft_all_cpus_set(u32 feature, unsigned long value, unsigned long flags,
>> +			  bool revert_on_fail)
>> +{
>> +	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
>> +		return sbi_fwft_set(feature, value, flags);
>> +
>> +	return sbi_fwft_feature_local_set(feature, value, flags,
>> +					  revert_on_fail);
>> +}
>> +
>>  /**
>>   * sbi_set_timer() - Program the timer for next timer event.
>>   * @stime_value: The value after which next timer event should fire.
>> -- 
>> 2.47.2
> 
> Thanks,
> drew


