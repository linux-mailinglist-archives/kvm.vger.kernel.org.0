Return-Path: <kvm+bounces-35952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF0CFA1682E
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 09:26:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7D9A3A2533
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 08:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 758A5194096;
	Mon, 20 Jan 2025 08:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="dcld3/uv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498971922F5
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 08:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737361560; cv=none; b=q/yZoY5JBkUSRuWYnayVgJ+wDSZex4m66KQscJQu1GLLIOh25rO3kNZXMkr5UbQMdM+ZYeFhtpd7mc6zi9Tf3QyrbsZypAvnpz5v5WhWptaM6SFndltC5P3Tbbo5IcJu5ggCWDXwfTHzUpopC/hg8bWoie1XLyoqcwXOQPigfJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737361560; c=relaxed/simple;
	bh=87G0kCSaRwRHfBd20jUkwfe3/V2mZafC580D/FqNXb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NmB0j0vidatpGiI7I0XabfUV3AvkHFdJXKhPmmZQpCE79I04xnKtIIUJNwryaSwfVCJlkj4pYCCefVqf1n1a+l+P9TcPRTR/E0LXE4aAjiH2U2+GPTd7CYwUk8981UuI3B14me3tXGN2XjRsAyxcqTpKfqsqghn2thovw75cf8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=dcld3/uv; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-385de59c1a0so2367598f8f.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 00:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737361556; x=1737966356; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EYI2a3QsYIeA00En1YZrm2v2A4qBik72ZkUV/Otsri0=;
        b=dcld3/uv5X0d2wfU9Ra1zkT+4+q/z6TPTkd0ryrr9cAYwh4iWv2JTSiezJMmHKUt3k
         9LxeBCTVYv49hJN3yMCrHCaioQdxjAUsYgHAIwQzDvUytwpzZLNFFawgVInLGhxeZFNQ
         eiy5DQkUYVbHqfNqwC1MPfegB/Tw/H3TZDTBvuiF76KiM16sRwvFZdZTQMfIaKJzN5yy
         Stx0+57bBW/mDx6BLR1xRivPb4DFpDFCUXJO3G2oQ5O6L44hDL9ME7ueNqRXreXVZGt/
         sVPIc7UiHjaR9DN2ExEqkHjlBV2tw8K8c54G730kYz0BT2swHqbzhD5I/AWD/B6ynRk+
         /GeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737361556; x=1737966356;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EYI2a3QsYIeA00En1YZrm2v2A4qBik72ZkUV/Otsri0=;
        b=okdyZDU0g5t/dmkYHwZCMFQpPVRfTcf6ZWNHqviqzrG9/tfc8R0zZORCoVSZdAvAMJ
         Y053+jLkKjaQnKaN7Gs4FvxIcylYW0OxE3Vmd8PuiR1X61YmrJqkOTwmsDWTjnNUVmyz
         Y38FXDz7V/sR1U/58IRG0mnXyiL5suYKXsl6oN6nPmJfVFwf2ylSXjB5UywnhMoLx8tQ
         HPTQMuTjToufsKBz0Omm73rdBEH1aiGibSEubi8HKbIgzw9GKn3UqD/DuHjOlh1Crp7J
         K64QqmCGKauvIM48+lu+eGj1JCzkm3QP7oTli8yFGEZmhtleXop2nfyu3MG6LNrSuyJB
         8PpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnhQk3WCjt2g7UVUNdk+ZfsdigRTh7jY467GNmt7HxbgfOBSV53DYcdIn04vGH/c9Q190=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz0atBFeDQDlVNxIatnaf79j1c7K5iD1hQO9H90Dy1Nhm6Ucx9
	qnt7xJj3MmSPx9jXBh2QQdNm0wDyt5j2UVNPiW2+kR1TQJtgOq0Z0stYVNugCeE=
X-Gm-Gg: ASbGncugamghdbAKN+haduZEkZg1dOkU5cg7LKRrl5HwEHWhV+zJlKyMewwio/icSyu
	dOaiVLhTAUQhnnZ9ohysYvQ+gIHzaZh93boX4qekFi75U0fwoiPoknXvol4bb/S4MEF24vHd49w
	VDPRnTDxOKKSQGThXdO07JNgt2lhuC/DIpEuqSFPg6be67Ev1Req43e2N4pdyg6x+IjRIOT9mtQ
	ULD6KV14bjy7TpdJUZPb7t0L1xNQDgfiaMbMNw8yXFQ1oUuM4Vb8J30SkWX0s4GQi+uaG/UrHQz
	BwyDbkIYH8DQv6BLo4WCBqAd3hPiDQCFpXoN1Ds=
X-Google-Smtp-Source: AGHT+IH4TndOh+PlXJGqlB2TWiZ55c/1n03gu+vWFDOVEsEqCanQ4rIbEsNvQgPQ/XMlsmWRjDZFoQ==
X-Received: by 2002:a5d:5848:0:b0:385:e37a:2a56 with SMTP id ffacd0b85a97d-38bf57c0551mr10581702f8f.52.1737361556266;
        Mon, 20 Jan 2025 00:25:56 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221b5asm9529892f8f.21.2025.01.20.00.25.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 00:25:55 -0800 (PST)
Message-ID: <daf2d06e-2c5a-4659-87d4-e96913bd461b@rivosinc.com>
Date: Mon, 20 Jan 2025 09:25:54 +0100
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
 <dec723d7-fc16-4edb-b684-1844b08391ba@rivosinc.com>
 <dff019ec-79dc-4be6-b1f4-02e48d84ebc2@sifive.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <dff019ec-79dc-4be6-b1f4-02e48d84ebc2@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 17/01/2025 17:31, Samuel Holland wrote:
> Hi Clément,
> 
> On 2025-01-17 10:05 AM, Clément Léger wrote:
>> On 11/01/2025 00:55, Samuel Holland wrote:
>>> On 2025-01-06 9:48 AM, Clément Léger wrote:
>>>> SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
>>>> misaligned load/store exceptions. Save and restore it during CPU
>>>> load/put.
>>>>
>>>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>>>> ---
>>>>  arch/riscv/kvm/vcpu.c          |  3 +++
>>>>  arch/riscv/kvm/vcpu_sbi_fwft.c | 39 ++++++++++++++++++++++++++++++++++
>>>>  2 files changed, 42 insertions(+)
>>>>
>>>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>>>> index 3420a4a62c94..bb6f788d46f5 100644
>>>> --- a/arch/riscv/kvm/vcpu.c
>>>> +++ b/arch/riscv/kvm/vcpu.c
>>>> @@ -641,6 +641,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>>>  {
>>>>  	void *nsh;
>>>>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>>>> +	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>>>>  
>>>>  	vcpu->cpu = -1;
>>>>  
>>>> @@ -666,6 +667,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>>>  		csr->vstval = nacl_csr_read(nsh, CSR_VSTVAL);
>>>>  		csr->hvip = nacl_csr_read(nsh, CSR_HVIP);
>>>>  		csr->vsatp = nacl_csr_read(nsh, CSR_VSATP);
>>>> +		cfg->hedeleg = nacl_csr_read(nsh, CSR_HEDELEG);
>>>>  	} else {
>>>>  		csr->vsstatus = csr_read(CSR_VSSTATUS);
>>>>  		csr->vsie = csr_read(CSR_VSIE);
>>>> @@ -676,6 +678,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>>>  		csr->vstval = csr_read(CSR_VSTVAL);
>>>>  		csr->hvip = csr_read(CSR_HVIP);
>>>>  		csr->vsatp = csr_read(CSR_VSATP);
>>>> +		cfg->hedeleg = csr_read(CSR_HEDELEG);
>>>>  	}
>>>>  }
>>>>  
>>>> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
>>>> index 55433e805baa..1e85ff6666af 100644
>>>> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
>>>> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
>>>> @@ -14,6 +14,8 @@
>>>>  #include <asm/kvm_vcpu_sbi.h>
>>>>  #include <asm/kvm_vcpu_sbi_fwft.h>
>>>>  
>>>> +#define MIS_DELEG (1UL << EXC_LOAD_MISALIGNED | 1UL << EXC_STORE_MISALIGNED)
>>>> +
>>>>  static const enum sbi_fwft_feature_t kvm_fwft_defined_features[] = {
>>>>  	SBI_FWFT_MISALIGNED_EXC_DELEG,
>>>>  	SBI_FWFT_LANDING_PAD,
>>>> @@ -35,7 +37,44 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
>>>>  	return false;
>>>>  }
>>>>  
>>>> +static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	if (!unaligned_ctl_available())
>>>
>>> This seems like the wrong condition. Patch 2 requests delegation regardless of
>>> what probing detects. For MISALIGNED_SCALAR_FAST, the delegation likely doesn't> change any actual behavior, because the hardware likely never raises the
>>> exception. But it does ensure M-mode never emulates anything, so if the
>>> exception were to occur, the kernel has the choice whether to handle it. And
>>> this lets us provide the same guarantee to KVM guests. So I think this feature
>>> should also be supported if we successfully delegated the exception on the host
>>> side.
>>
>> Not sure to completely follow you here but patch 2 actually does the
>> reverse of what you said. We request delegation from SBI *before*
>> probing so that allows probing to see if we (kernel) receives misaligned
>> accesses traps and thus set MISALIGNED_SCALAR_EMULATED.
> 
> Ah, right, that makes sense.
> 
>> But if I understood correctly, you mean that guest delegation should
>> also be available to guest in case misaligned access were delegated by
>> the SBI to the host which I agree. I think this condition should be
> 
> Yes, your understanding is correct.
> 
>> reworked to report the delegation status itself and not the misaligned
>> access speed that was detected
> 
> Agreed, with the nuance that delegation may have been enabled by a FWFT call, or
> it may have been pre-existing, as detected by MISALIGNED_SCALAR_EMULATED or
> MISALIGNED_VECTOR_EMULATED. For example, I would consider a platform where the
> hardware supports misaligned scalar accesses (MISALIGNED_SCALAR_FAST) but not
> vector accesses, and M-mode doesn't emulate them (MISALIGNED_VECTOR_EMULATED) to
> be delegated for the purposes of this check, even if M-mode doesn't implement
> the FWFT extension.

Ah yeah indeed, I did not pictured that one particular case !

Thanks,

Clément

> 
> Regards,
> Samuel
> 
>>>> +		return false;
>>>> +
>>>> +	return true;
>>>> +}
>>>> +
>>>> +static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
>>>> +					struct kvm_sbi_fwft_config *conf,
>>>> +					unsigned long value)
>>>> +{
>>>> +	if (value == 1)
>>>> +		csr_set(CSR_HEDELEG, MIS_DELEG);
>>>> +	else if (value == 0)
>>>> +		csr_clear(CSR_HEDELEG, MIS_DELEG);
>>>> +	else
>>>> +		return SBI_ERR_INVALID_PARAM;
>>>> +
>>>> +	return SBI_SUCCESS;
>>>> +}
>>>> +
>>>> +static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
>>>> +					struct kvm_sbi_fwft_config *conf,
>>>> +					unsigned long *value)
>>>> +{
>>>> +	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) != 0;
>>>> +
>>>> +	return SBI_SUCCESS;
>>>> +}
>>>> +
>>>>  static const struct kvm_sbi_fwft_feature features[] = {
>>>> +	{
>>>> +		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
>>>> +		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
>>>> +		.set = kvm_sbi_fwft_set_misaligned_delegation,
>>>> +		.get = kvm_sbi_fwft_get_misaligned_delegation,
>>>> +	}
>>>
>>> nit: Please add a trailing comma here as future patches will extend the array.
>>>
>>> Regards,
>>> Samuel
>>>
>>>>  };
>>>>  
>>>>  static struct kvm_sbi_fwft_config *
>>>
>>
> 


