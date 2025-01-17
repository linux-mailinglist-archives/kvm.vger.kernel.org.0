Return-Path: <kvm+bounces-35801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 863D5A153B6
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EDEC1881D1D
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0C0199FA4;
	Fri, 17 Jan 2025 16:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="GyzbGLfn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3103615852E
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737129919; cv=none; b=nvaeOUfrL+Dkq89jFW3jr7GqqsCIt6xslVg5k0uVpWsjDIhW1/l7k9RotHJIvjeL0Fzb1jPM3bm0TX6cox/sbKJkq9U3vM7x8k6TDE3vGElHOc7goQ+BfEgq1VfjMQQymRLzOrJ5JaL7+AIwj0MBI9X4UJDT5LtBXdBOX8gd70E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737129919; c=relaxed/simple;
	bh=EYLm5v7oOPjdKvcj5PKDtD5IHLL4Ov9Rnk0LuHg8dVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NA2Qa0WMpYUcCV5xlktSGAk2Ve9l+UGSHgD+3LJ84wWz2AaXhpTPb/8B4yZtpw7l068gmKepvDifJojQdAcx9uSn1i8Xbm1EfQmz/+nnrtYx6oLnMRZbwVlFsAWxM4JAC/KAcnvBKgptVZClPQqd1owMg37MrYuITcTzmlg5Rjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=GyzbGLfn; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-436202dd7f6so24990995e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737129914; x=1737734714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KIKm+b7x8ZPOGG0s06oIRZ9t7O2YmNWgG+lZbVw+Ia8=;
        b=GyzbGLfn0bF47I/VrVMygT/5f1a1bTGJMgqXpCB6iGz1jmtCj/KnLm+d5YShNVO71d
         +3Gy23+KotKmsIcpsdmwHAfgRBPpdAdY6sw/9YDQSDnSkwFUjbj5yJnMy4sn/3quBqWP
         VAjsmnBQeOovN+k1Samvd7HEKZOtCEXNmuhbM/iQJrbpdK2ZZytXiPAzdX2KAScgihEP
         4niuG97L0On9/tA56h/pw5LgqMseYo/Pc32CiLu4DzbEThBweAU9EeXxAcdgSt3W6DaH
         cbnl5g+/TRiZfIA08R/NaWKZz1oncZHex8Q/mhOfjMy89k7fujgDbUlRwSIp7t7zdx/K
         DhNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737129914; x=1737734714;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KIKm+b7x8ZPOGG0s06oIRZ9t7O2YmNWgG+lZbVw+Ia8=;
        b=m/eRljEY4x47SFLIqlOpyCudDQov0gURES5gFrOYwC9WUnRul19wxqFw561SkknVdc
         flwXGOLHJNG+fBq+tK8xelPgpGCNyD1KApVCg4y0dsmlclYAn9cUqM0LkIfoClZ93JS0
         6FIDN7Hw2tkiMu/9j3zJ5a/tx3a8CfNuIEf2zASWAa++ZQ+aji3iOBZoQx3pvSBtVDfu
         t7A3BA9tMGtZAtM5pJYhjfpvXfp3T4hy+/N2IbePxVOIVrN6/WBpmr1xOrcfqPipp9WQ
         2aXGEpXgBdhg2VlxEhYXjY21k+VJZ99LhjvYgANz2zDAz9iePHzqr08Jus76aRSQT0fJ
         somw==
X-Forwarded-Encrypted: i=1; AJvYcCVw8euzpMlhltpcUbsZZplDGg+thUI7QraGjysazosF8sx2p1HSTnQxJtaDbSvEFMNRkLI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5SeguEjLepuA6bYYMOnyGSvVF1jS74dh6hjRCoJDkf2MxamAG
	6vUQmuCcZkZ4fLDxiWtSF6Ikf1FHs9UjLxlqWyJqQpee664V/KQQ1gVIseX6Rhg=
X-Gm-Gg: ASbGncvqftAfFWAgXpTyVOtBoNWIgjkkgtHlNg+cqsFyHEZtXVpr77rZur+usRSUyoG
	IklcjNom/Fp2w93/+ZQD2VLVOMBH5osCsu+845fh5LvVsCe/xmv9wN2QBXt6og1OIpUA2VoLSEG
	L+Tne63hRWmJn7wX4Bst5qA8scI4QdSgPaannsj1CaanMP8UMoGOftK1acvssyrhO9VsgnDQoew
	eor50DSamcM2W5eHubZNXR/XDkN2cYnKVPmz425XgEjLQCzCGj/6ti1ox7BZqrwSOh+hXIj8PK7
	XIIR8gkvAnxcEuZKXlMRQWHv9g==
X-Google-Smtp-Source: AGHT+IEo/qRGSopdNCymFI4uatmcJLeEtoysYWzXy3BlYUa/so7QnTZc8ShIOgGoZZx4+/0Qsn2jCA==
X-Received: by 2002:a5d:648a:0:b0:385:f349:fffb with SMTP id ffacd0b85a97d-38bf57bfba2mr3199279f8f.45.1737129914326;
        Fri, 17 Jan 2025 08:05:14 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322ac88sm2916424f8f.54.2025.01.17.08.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 08:05:13 -0800 (PST)
Message-ID: <dec723d7-fc16-4edb-b684-1844b08391ba@rivosinc.com>
Date: Fri, 17 Jan 2025 17:05:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] RISC-V: KVM: add support for
 SBI_FWFT_MISALIGNED_DELEG
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
References: <20250106154847.1100344-1-cleger@rivosinc.com>
 <20250106154847.1100344-7-cleger@rivosinc.com>
 <b3f54d34-bc77-46db-88da-70c0c602081f@sifive.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <b3f54d34-bc77-46db-88da-70c0c602081f@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/01/2025 00:55, Samuel Holland wrote:
> On 2025-01-06 9:48 AM, Clément Léger wrote:
>> SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
>> misaligned load/store exceptions. Save and restore it during CPU
>> load/put.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  arch/riscv/kvm/vcpu.c          |  3 +++
>>  arch/riscv/kvm/vcpu_sbi_fwft.c | 39 ++++++++++++++++++++++++++++++++++
>>  2 files changed, 42 insertions(+)
>>
>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>> index 3420a4a62c94..bb6f788d46f5 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -641,6 +641,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  {
>>  	void *nsh;
>>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>> +	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>>  
>>  	vcpu->cpu = -1;
>>  
>> @@ -666,6 +667,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  		csr->vstval = nacl_csr_read(nsh, CSR_VSTVAL);
>>  		csr->hvip = nacl_csr_read(nsh, CSR_HVIP);
>>  		csr->vsatp = nacl_csr_read(nsh, CSR_VSATP);
>> +		cfg->hedeleg = nacl_csr_read(nsh, CSR_HEDELEG);
>>  	} else {
>>  		csr->vsstatus = csr_read(CSR_VSSTATUS);
>>  		csr->vsie = csr_read(CSR_VSIE);
>> @@ -676,6 +678,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  		csr->vstval = csr_read(CSR_VSTVAL);
>>  		csr->hvip = csr_read(CSR_HVIP);
>>  		csr->vsatp = csr_read(CSR_VSATP);
>> +		cfg->hedeleg = csr_read(CSR_HEDELEG);
>>  	}
>>  }
>>  
>> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
>> index 55433e805baa..1e85ff6666af 100644
>> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
>> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
>> @@ -14,6 +14,8 @@
>>  #include <asm/kvm_vcpu_sbi.h>
>>  #include <asm/kvm_vcpu_sbi_fwft.h>
>>  
>> +#define MIS_DELEG (1UL << EXC_LOAD_MISALIGNED | 1UL << EXC_STORE_MISALIGNED)
>> +
>>  static const enum sbi_fwft_feature_t kvm_fwft_defined_features[] = {
>>  	SBI_FWFT_MISALIGNED_EXC_DELEG,
>>  	SBI_FWFT_LANDING_PAD,
>> @@ -35,7 +37,44 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
>>  	return false;
>>  }
>>  
>> +static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
>> +{
>> +	if (!unaligned_ctl_available())
> 
> This seems like the wrong condition. Patch 2 requests delegation regardless of
> what probing detects. For MISALIGNED_SCALAR_FAST, the delegation likely doesn't> change any actual behavior, because the hardware likely never raises the
> exception. But it does ensure M-mode never emulates anything, so if the
> exception were to occur, the kernel has the choice whether to handle it. And
> this lets us provide the same guarantee to KVM guests. So I think this feature
> should also be supported if we successfully delegated the exception on the host
> side.

Not sure to completely follow you here but patch 2 actually does the
reverse of what you said. We request delegation from SBI *before*
probing so that allows probing to see if we (kernel) receives misaligned
accesses traps and thus set MISALIGNED_SCALAR_EMULATED.

But if I understood correctly, you mean that guest delegation should
also be available to guest in case misaligned access were delegated by
the SBI to the host which I agree. I think this condition should be
reworked to report the delegation status itself and not the misaligned
access speed that was detected

Thanks,

Clément


> 
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>> +static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
>> +					struct kvm_sbi_fwft_config *conf,
>> +					unsigned long value)
>> +{
>> +	if (value == 1)
>> +		csr_set(CSR_HEDELEG, MIS_DELEG);
>> +	else if (value == 0)
>> +		csr_clear(CSR_HEDELEG, MIS_DELEG);
>> +	else
>> +		return SBI_ERR_INVALID_PARAM;
>> +
>> +	return SBI_SUCCESS;
>> +}
>> +
>> +static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
>> +					struct kvm_sbi_fwft_config *conf,
>> +					unsigned long *value)
>> +{
>> +	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) != 0;
>> +
>> +	return SBI_SUCCESS;
>> +}
>> +
>>  static const struct kvm_sbi_fwft_feature features[] = {
>> +	{
>> +		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
>> +		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
>> +		.set = kvm_sbi_fwft_set_misaligned_delegation,
>> +		.get = kvm_sbi_fwft_get_misaligned_delegation,
>> +	}
> 
> nit: Please add a trailing comma here as future patches will extend the array.
> 
> Regards,
> Samuel
> 
>>  };
>>  
>>  static struct kvm_sbi_fwft_config *
> 


