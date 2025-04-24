Return-Path: <kvm+bounces-44131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9046DA9AD9F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86C90189E07D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 12:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B4627BF87;
	Thu, 24 Apr 2025 12:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="O7BVL9J0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE91C701A
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 12:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745498236; cv=none; b=gQ3Oqz20DNni9lLwKKImohsOkqxkUvpZO5pGgMJKT7UdYFigta+ewU6l0ZKK1ZmJf77samjwuFWv0XvO6987nZoiYnbBDbt6p/nxhFYpS11Uyd7CDSORK03eU9GuwGpu1jEVv4BRd3Y+5LSPmKlnUeK8rK57XOygif+I/GiP86k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745498236; c=relaxed/simple;
	bh=RtF0Ii7968sqtIEiSOoOHmfF6UJG7nfCpDcEL14f2h0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TzUbblvzT20E7IvDMb/4TxfwE9WtLz1ikbQUbNd6vLp5Gk5hSXHjwkHRK1nvYjAp23peIYi2NWjgOHUWiDUlHaUrQ84vMeLzJW3k4ThjZ9h7kFZS9BGNs422kPemsBzt1scB/GAiKfPz+pEApmWZgQ7/hlwSy5pRuy5tglCD9CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=O7BVL9J0; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39129fc51f8so784037f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 05:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745498232; x=1746103032; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mXBQ/2qXvZB57eFvN07u42A0vH9tPCFMfppvAtJvXGM=;
        b=O7BVL9J0y6luUTGtyNRrQ+tsxebF2HkhxkgKSpGAY7xQoaVwcq9Pl2s3BKJt3W3P7A
         wrJ3W7zkl2iFLH74pOv6watRy0SsK1b2hLGVQ09DL5mf6HP/3DYmgiuEta3WP87Lh6PX
         O45YZcjhvX0JMiFJJCYlKz0afof5jBVQp1rpdkIokeQ+q04Hv9VtsEIpsntNlNsaDSIG
         tLwup6sV5AR3xtOAEckVeW479kbfQteBQSAArAnxrmpMt89rR+Gr9ofNdSb4dJ/7+7Ec
         H25LlR8BJAEnmL5hmw18OD0qUicNhf54+438iE5w/CtZ0dj/0QoPlF3A2vbpO7sqp+Mq
         U6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745498232; x=1746103032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mXBQ/2qXvZB57eFvN07u42A0vH9tPCFMfppvAtJvXGM=;
        b=Wo2AwTRNvVhql7GPZxnBUESmkaAOPUblUv4AdZbZxKjKQ9/i2BSi5h9sVLlBppJH/h
         tHNofzu5+Q8nLyxFzN7xrhbLCDCOjX5IlAN18ETwSoGnVvthKstN6PxTv+Iv9afQ2Ywn
         lMGiz8rv4FWnMFk6GPH3wqH8zKjWISJCwTc/k2Id1cQ005HnPJZ66HWykD0x48BkVrcC
         +OjUyTv1bdBv8KHfFIX5B92sqR4/m9u5STTxiNTm2ufgLTKBbhcG0dySqXah0ljNmALN
         F6AS5Pl9lOofQYexzhhqbygrwiy7RnZSCySg7U6YP95KSZt52rWOJTVfT7osRdXI+xIG
         1pUw==
X-Forwarded-Encrypted: i=1; AJvYcCVv7vFhbLWiGEi/z+owzKN3+XPO59se9M9EIggLP0rYPVWpa2rtrJU3UOTzB3ByTjKxCDI=@vger.kernel.org
X-Gm-Message-State: AOJu0YywPaO5UF3imTCS6DKW4ooC3iTunJ8ZVKRU6G4k/QLPR/QiGRBc
	Yw9kXRS7W9lYaccVQxUJ15AjPYHv3h6mQby16bDDg14rNI0EhK+SUkeOOjP3WjY=
X-Gm-Gg: ASbGncv6IScqlPDqSsRdPHltTBiqIQYQgiP2FQFmcMKtwqGCnUGYCZv0WrSV3kQ4DxO
	xBIzW8huAc52GVbWbGT2JB/eBe3245vPmG3BftfKHxeqseUNElf/psHy/QieVqePZsxe1R/DMKv
	3SH5M7yWNlqrNgfROLnWhRduA3QtUWQUo4O/Dp78g69Ghwep6F87YQDl3up0uVafX21qnPGB2O3
	8BlUnJl7gHxqGOiJbZ9qWWFkc2JiOHeATj9cHxMdJaMAGB63QJVeHRnQ/K4C70L3tn65ng+ugnd
	8ASZ6yH2rmoSnWHyKBgeRWEIOFBBjxs8O38ds+QI9n2yuYwuFBN0JF/BdNMtew1QfSSqIXM0r6s
	TnsDGtY9TDA==
X-Google-Smtp-Source: AGHT+IFQHcJdwFRaXmEWb0g3t5DToUnDgaUuyc1wuadZLcOAY6FK4EOtEA/saYPalIta+MsOsrAKYA==
X-Received: by 2002:a05:6000:18a8:b0:391:241d:a13e with SMTP id ffacd0b85a97d-3a06cfab52fmr1726627f8f.48.1745498232082;
        Thu, 24 Apr 2025 05:37:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d532551sm2004598f8f.65.2025.04.24.05.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 05:37:11 -0700 (PDT)
Message-ID: <ddd4ba8a-27cf-4174-a578-b28961bdf1a5@rivosinc.com>
Date: Thu, 24 Apr 2025 14:37:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/13] RISC-V: KVM: add support for
 SBI_FWFT_MISALIGNED_DELEG
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>,
 Deepak Gupta <debug@rivosinc.com>
References: <20250417122337.547969-1-cleger@rivosinc.com>
 <20250417122337.547969-14-cleger@rivosinc.com>
 <20250424-ae24464169f7143c509cbab5@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250424-ae24464169f7143c509cbab5@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 24/04/2025 13:34, Andrew Jones wrote:
> On Thu, Apr 17, 2025 at 02:20:00PM +0200, Clément Léger wrote:
>> SBI_FWFT_MISALIGNED_DELEG needs hedeleg to be modified to delegate
>> misaligned load/store exceptions. Save and restore it during CPU
>> load/put.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> Reviewed-by: Deepak Gupta <debug@rivosinc.com>
>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>> ---
>>  arch/riscv/kvm/vcpu.c          |  3 +++
>>  arch/riscv/kvm/vcpu_sbi_fwft.c | 36 ++++++++++++++++++++++++++++++++++
>>  2 files changed, 39 insertions(+)
>>
>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>> index 542747e2c7f5..d98e379945c3 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -646,6 +646,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  {
>>  	void *nsh;
>>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>> +	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>>  
>>  	vcpu->cpu = -1;
>>  
>> @@ -671,6 +672,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  		csr->vstval = nacl_csr_read(nsh, CSR_VSTVAL);
>>  		csr->hvip = nacl_csr_read(nsh, CSR_HVIP);
>>  		csr->vsatp = nacl_csr_read(nsh, CSR_VSATP);
>> +		cfg->hedeleg = nacl_csr_read(nsh, CSR_HEDELEG);
>>  	} else {
>>  		csr->vsstatus = csr_read(CSR_VSSTATUS);
>>  		csr->vsie = csr_read(CSR_VSIE);
>> @@ -681,6 +683,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>  		csr->vstval = csr_read(CSR_VSTVAL);
>>  		csr->hvip = csr_read(CSR_HVIP);
>>  		csr->vsatp = csr_read(CSR_VSATP);
>> +		cfg->hedeleg = csr_read(CSR_HEDELEG);
>>  	}
>>  }
>>  
>> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
>> index b0f66c7bf010..237edaefa267 100644
>> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
>> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
>> @@ -14,6 +14,8 @@
>>  #include <asm/kvm_vcpu_sbi.h>
>>  #include <asm/kvm_vcpu_sbi_fwft.h>
>>  
>> +#define MIS_DELEG (BIT_ULL(EXC_LOAD_MISALIGNED) | BIT_ULL(EXC_STORE_MISALIGNED))
>> +
>>  struct kvm_sbi_fwft_feature {
>>  	/**
>>  	 * @id: Feature ID
>> @@ -68,7 +70,41 @@ static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
>>  	return false;
>>  }
>>  
>> +static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
>> +{
>> +	return misaligned_traps_can_delegate();
>> +}
>> +
>> +static long kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
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
>> +static long kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
>> +					struct kvm_sbi_fwft_config *conf,
>> +					unsigned long *value)
>> +{
>> +	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) != 0;
> 
> This should be
> 
>   (csr_read(CSR_HEDELEG) & MIS_DELEG) == MIS_DELEG;

Hum yeah indeed, I didn't thought that someone would ony delegate load
or stores.

I'll fix that,

Thanks,

Clément

> 
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
>> +	},
>>  };
>>  
>>  static struct kvm_sbi_fwft_config *
>> -- 
>> 2.49.0
>>
> 
> Thanks,
> drew


