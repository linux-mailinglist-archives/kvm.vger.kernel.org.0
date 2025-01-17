Return-Path: <kvm+bounces-35823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07948A15468
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA2EA3AA524
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5CD19F111;
	Fri, 17 Jan 2025 16:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="WYU9o+Wy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCA019CC27
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737131473; cv=none; b=qESsiu1wDKVnEBEvrvTMiH5EoDDTErLCpUnzJVap6OOD/ujXSf1YMZtwEebfY1Sxqixm06X2l7rQjs2kS5K6J32bzF/42V9GyHTBEOoWVnZAp0CAFiktSBvGRWkLqy3bSWoikqwXX0oTKx0w8xYl5ILN2ateIMZSEMteACODzhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737131473; c=relaxed/simple;
	bh=mxqFj7Cbt7mFEh8WMnbue8M2/6bNKGAQaEo8QmVgDjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rvfE+VuHzAATlLemCni+Z7WFMqhPOgwfFP/uovpRYqPGl2jp9MAWP+IwKex9cMbVdXMqszdA2D9cetm60vNib6hCrEhZNqYXEaqiMgM3A3JiOsJEnZIKpQmFxGZ9p3STeoiNQVplCGNtcwKdfekZ+FxotFE/O93DJTfjGzA9PWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=WYU9o+Wy; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso18977115ab.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 08:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1737131469; x=1737736269; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2LgnsHnmS3fh5mDGhqIRf5OGV7HMImqUQ/i0e8Ovvcw=;
        b=WYU9o+WyKze7Qv+kqWOhSKa1Z6veT/IJgs2nZLMgqPsT4nLn4GKuZrP8Pmf2yWNgVL
         tviLW83q3ZHgVj2DCC8/0p2/hYDe+fwmQ42qnHeP9EEE0E5xPN0uH5anV4hk9aCknfF0
         7hutgy41kH4yj4waJLKh7isE+GA/G1ZxVdNsCPBp6wkCRNfnWr0lJm/xNzwz/J/oXyoN
         aBPIzix/b7I/4QQBrJmD/lgeAr6cK9KiUDUAEpqLR36Gsnt5w4lSnnj4+1YAFLR/gmP/
         IDv0CF0ggqfq6y8xc2CU9Do102skyRJXtmzA6jq2/7Dsy2ylQGZ8syCY77mWcKt9YTjq
         UOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737131469; x=1737736269;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2LgnsHnmS3fh5mDGhqIRf5OGV7HMImqUQ/i0e8Ovvcw=;
        b=eIo2j8uWpFMLbh7G7rcvuqLWHfQ/5hrRz1WLHD2yC5VGNPAVMKsyG07hrmbzi9SDc5
         Pts4ERKfRHA5TUX9v3NLe7JVVpTMHPRyQgzvNuqziGgFEDgPC29n7mf/+lTvfI8w5mNd
         ImQMfNho9G3LVZ53867RgfkbAezgfLhXZ/1jIN/Pj3160cunRKGubKAsGRA34rrJdelV
         f1JfxxOXQlLkTSVZhq5jUjc+k7C+VoY2zY52eroVL69gczsQMBmWHGhrNrM4E6KstddR
         VUlpeSW2rEHpWGaiYwmEsOxUytHAxDxc2LqZ/zBlia0wccroh6EkAyN3Rq9NPtaje3aU
         Knmw==
X-Forwarded-Encrypted: i=1; AJvYcCUZaYgvJaSgS1/p+6Ao8NlOH8X/jsd7Psb39YchFCcDA/MZ8nw7QxmqmQIS1Cc6E71gjFg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYvIY79AoikpR+jtyD+K0gQ6Rh/KJNyXdwk/e4LAWzxng41KWl
	TjjYkUuDWy+fEttT5Q9QPDBSVEMgf5SVXVhG/+c9p7I2EL0yd1ypyMrLKY3OlwY=
X-Gm-Gg: ASbGncsNb+LYsAlZuaJyIPP9KYED6zJ01ggTWoWVYD4f0DRUEc4zqRsBbHRTwu1l7Z7
	SvmhpZsPvZCmO0PESiYdnzewpvKuXRXJrGkY+Z/PW3o0s8xIkIWGrv3bJ4DcpLIjB2zQd43xiy8
	0JCN9QpmRh43IHThcMI4DEvZdHfPNFYHBg2mGs40nAHqzKA8SS/icHtxCoEc1FoeSnNSUeUDHem
	DwnCYDCwbCFvAAgpXHi8xM/NK/5pIbl9fdmQztPIsYf0RQY9TlrE4AyoQTIkO/rK0Ij8QnM8MuZ
	cTqc
X-Google-Smtp-Source: AGHT+IFnKYDZSdNxxP6fjbNh6IOeT1lfl9g/Gyt6iEwmsb06hqBZJxurWC5Tjc8A5f2CPYlVAQFeaA==
X-Received: by 2002:a05:6e02:214d:b0:3a7:e7bd:9f09 with SMTP id e9e14a558f8ab-3cf743b447dmr25305575ab.5.1737131469361;
        Fri, 17 Jan 2025 08:31:09 -0800 (PST)
Received: from [100.64.0.1] ([165.188.116.9])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea7566e4a0sm695782173.121.2025.01.17.08.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 08:31:08 -0800 (PST)
Message-ID: <dff019ec-79dc-4be6-b1f4-02e48d84ebc2@sifive.com>
Date: Fri, 17 Jan 2025 10:31:08 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] RISC-V: KVM: add support for
 SBI_FWFT_MISALIGNED_DELEG
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
References: <20250106154847.1100344-1-cleger@rivosinc.com>
 <20250106154847.1100344-7-cleger@rivosinc.com>
 <b3f54d34-bc77-46db-88da-70c0c602081f@sifive.com>
 <dec723d7-fc16-4edb-b684-1844b08391ba@rivosinc.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <dec723d7-fc16-4edb-b684-1844b08391ba@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Clément,

On 2025-01-17 10:05 AM, Clément Léger wrote:
> On 11/01/2025 00:55, Samuel Holland wrote:
>> On 2025-01-06 9:48 AM, Clément Léger wrote:
>>> SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
>>> misaligned load/store exceptions. Save and restore it during CPU
>>> load/put.
>>>
>>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>>> ---
>>>  arch/riscv/kvm/vcpu.c          |  3 +++
>>>  arch/riscv/kvm/vcpu_sbi_fwft.c | 39 ++++++++++++++++++++++++++++++++++
>>>  2 files changed, 42 insertions(+)
>>>
>>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>>> index 3420a4a62c94..bb6f788d46f5 100644
>>> --- a/arch/riscv/kvm/vcpu.c
>>> +++ b/arch/riscv/kvm/vcpu.c
>>> @@ -641,6 +641,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>>  {
>>>  	void *nsh;
>>>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>>> +	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>>>  
>>>  	vcpu->cpu = -1;
>>>  
>>> @@ -666,6 +667,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>>  		csr->vstval = nacl_csr_read(nsh, CSR_VSTVAL);
>>>  		csr->hvip = nacl_csr_read(nsh, CSR_HVIP);
>>>  		csr->vsatp = nacl_csr_read(nsh, CSR_VSATP);
>>> +		cfg->hedeleg = nacl_csr_read(nsh, CSR_HEDELEG);
>>>  	} else {
>>>  		csr->vsstatus = csr_read(CSR_VSSTATUS);
>>>  		csr->vsie = csr_read(CSR_VSIE);
>>> @@ -676,6 +678,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>>  		csr->vstval = csr_read(CSR_VSTVAL);
>>>  		csr->hvip = csr_read(CSR_HVIP);
>>>  		csr->vsatp = csr_read(CSR_VSATP);
>>> +		cfg->hedeleg = csr_read(CSR_HEDELEG);
>>>  	}
>>>  }
>>>  
>>> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
>>> index 55433e805baa..1e85ff6666af 100644
>>> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
>>> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
>>> @@ -14,6 +14,8 @@
>>>  #include <asm/kvm_vcpu_sbi.h>
>>>  #include <asm/kvm_vcpu_sbi_fwft.h>
>>>  
>>> +#define MIS_DELEG (1UL << EXC_LOAD_MISALIGNED | 1UL << EXC_STORE_MISALIGNED)
>>> +
>>>  static const enum sbi_fwft_feature_t kvm_fwft_defined_features[] = {
>>>  	SBI_FWFT_MISALIGNED_EXC_DELEG,
>>>  	SBI_FWFT_LANDING_PAD,
>>> @@ -35,7 +37,44 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
>>>  	return false;
>>>  }
>>>  
>>> +static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
>>> +{
>>> +	if (!unaligned_ctl_available())
>>
>> This seems like the wrong condition. Patch 2 requests delegation regardless of
>> what probing detects. For MISALIGNED_SCALAR_FAST, the delegation likely doesn't> change any actual behavior, because the hardware likely never raises the
>> exception. But it does ensure M-mode never emulates anything, so if the
>> exception were to occur, the kernel has the choice whether to handle it. And
>> this lets us provide the same guarantee to KVM guests. So I think this feature
>> should also be supported if we successfully delegated the exception on the host
>> side.
> 
> Not sure to completely follow you here but patch 2 actually does the
> reverse of what you said. We request delegation from SBI *before*
> probing so that allows probing to see if we (kernel) receives misaligned
> accesses traps and thus set MISALIGNED_SCALAR_EMULATED.

Ah, right, that makes sense.

> But if I understood correctly, you mean that guest delegation should
> also be available to guest in case misaligned access were delegated by
> the SBI to the host which I agree. I think this condition should be

Yes, your understanding is correct.

> reworked to report the delegation status itself and not the misaligned
> access speed that was detected

Agreed, with the nuance that delegation may have been enabled by a FWFT call, or
it may have been pre-existing, as detected by MISALIGNED_SCALAR_EMULATED or
MISALIGNED_VECTOR_EMULATED. For example, I would consider a platform where the
hardware supports misaligned scalar accesses (MISALIGNED_SCALAR_FAST) but not
vector accesses, and M-mode doesn't emulate them (MISALIGNED_VECTOR_EMULATED) to
be delegated for the purposes of this check, even if M-mode doesn't implement
the FWFT extension.

Regards,
Samuel

>>> +		return false;
>>> +
>>> +	return true;
>>> +}
>>> +
>>> +static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
>>> +					struct kvm_sbi_fwft_config *conf,
>>> +					unsigned long value)
>>> +{
>>> +	if (value == 1)
>>> +		csr_set(CSR_HEDELEG, MIS_DELEG);
>>> +	else if (value == 0)
>>> +		csr_clear(CSR_HEDELEG, MIS_DELEG);
>>> +	else
>>> +		return SBI_ERR_INVALID_PARAM;
>>> +
>>> +	return SBI_SUCCESS;
>>> +}
>>> +
>>> +static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
>>> +					struct kvm_sbi_fwft_config *conf,
>>> +					unsigned long *value)
>>> +{
>>> +	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) != 0;
>>> +
>>> +	return SBI_SUCCESS;
>>> +}
>>> +
>>>  static const struct kvm_sbi_fwft_feature features[] = {
>>> +	{
>>> +		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
>>> +		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
>>> +		.set = kvm_sbi_fwft_set_misaligned_delegation,
>>> +		.get = kvm_sbi_fwft_get_misaligned_delegation,
>>> +	}
>>
>> nit: Please add a trailing comma here as future patches will extend the array.
>>
>> Regards,
>> Samuel
>>
>>>  };
>>>  
>>>  static struct kvm_sbi_fwft_config *
>>
> 


