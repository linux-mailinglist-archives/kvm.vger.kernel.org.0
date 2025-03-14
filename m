Return-Path: <kvm+bounces-41061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B441A6131D
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBFA71B61009
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 13:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F631EB3E;
	Fri, 14 Mar 2025 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gQvd/ZRR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0DE1FFC5F
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741960444; cv=none; b=doDHpOxu9pra01/EILvvH8/lWRXnUG5vs9/8BAA1MfujOStGPzlFKSDRWaukfUE8fSBcltQ0k3uQIjFN4pmx6qB4r2S9djNh11Yh5UOCT+gugls/gUtOSSDU/MDNBsH7kBZy4hCU32wfuCRIRqBw8BLArQLI8dKLkhNW4D9IGKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741960444; c=relaxed/simple;
	bh=hkuxj9Z6LalKPIM3SuTs15HhyoVDZbez+SnQN16sWVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S7SHPIh6t5lDmmlCTndf7uHEs1pXZtWZ+PVYyZ9GsvJ/xaKSGLzGSkXCEQfeFtq0JClQ3oy3fO02U4q4s+cSe0B1YgrVNoFCk0vdUBFHQ6nKbXiSE1yN2vnf1aGcjyGndWvFPtkpkyIl5eyzEJ+EeQDfS1fgaCQ2mJSP2JM2C4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gQvd/ZRR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfdc2c8c9so14372655e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 06:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741960440; x=1742565240; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fagz20QrFuAHZhTQ6FrQZLAd/rBpo65R2q5CpO1e6Ms=;
        b=gQvd/ZRRu6LYDSLMLDmBfNswGH/Et4f+0d3rlUMDhuloBWJEItFLzR5tg6tNiHhXVb
         cDX24d8I4MUBPr4C1p0MyJj2j1p7NPSHSFXzphxvW7NLPQh6nhyLyKyh3OapZdWdvz/N
         vXSg40qKzeC+FJacbQKjWgcFsfXDIQ/ISHkNgoeLNttT4jzLLhq/ekd/hZ63XG8tmr37
         ntYCjx3lLJVGmnvL2RZqzP5tLNGW6PRl0IMPrFbyVRgF0jJlkjfHt3tDh6Jjsnlk8X2O
         c2gtYIeIGQDaKjTHTW9uezxIn167j0zQ3BOVTLMEBIW+jDocyq9GJ65U2EbZWH2ptowr
         VQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741960440; x=1742565240;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fagz20QrFuAHZhTQ6FrQZLAd/rBpo65R2q5CpO1e6Ms=;
        b=qy0nudcowYg4nGBPuV1U4qXjuS+rn33kgokijZZaBgb8nBoFTFcskeKu5cxVpH2ue2
         6wxSFvTpc1BD3MR7YT7YSVMTZ7qQ2OsqH6uDq4Yo6h47rS8vP49XAftX+2pIsohJfyLc
         2jH6KuDHydXVOdhbJZ2QJi1Od7nE8+MtsS1e4YYXv6lEl2r9E6jsMStg3NIKQ8CeFUeO
         hg4pWiH0AH3gsNm/1u4gREEgxiZpiU7XkNrHEu29SlmylFmXvmNiCZCq5PulhxdPYWdx
         lk/HX2B4lQl0LyTeAHc50oKOQo4+FiJPsHmE57RQvAdhff77REGdBQONslrbduVVBOAP
         khXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXG5qX3On8wscIc7PJvoW33HO+gMxAflM+PtQbjSk3Z4UrqsH4m8RP/FsBNTze1KeSsIPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCeDjMnZ1a7lbw5L8zrzgPrpBozPtoVV0tWYVc/rKbD59L3FJ7
	gipV74v2YkokCMYWhhjnhutrSs1ENrK8mrqyBb6xPn10MBEC6CEOmsTu71R1ie4=
X-Gm-Gg: ASbGncuBoLA21Cb8GRq+ZxuBgKcgH0ULSqEp5eodmdgMDHCQso8DH7bqFOv4eB8IrnR
	bYcpedqqPpHnZ6VxFbDfKjVlu3czrjgCca+F+Y1YB+yd+Rjz+47dILpKJ6bs+fL8Jv26jcxVs1P
	CF/dI2yzDebnoeLvTacFV0Cc8D8ogDexkp8UNE/bGpDKWgef5n7409+18ho1MU3kwkDA1FXXtE0
	X9D4TH7NG9SDAsFgbSb7xyNUE3i8035VyHUsTR4gMczuctxzgO7NimX94Hts2uk3YzrqtXR53ng
	kJDJyX88FJRrBg0y3Nzca2JQfJdYsSZnZGs8BbvTPUCDkd5Yab83joQYQKh7kPcSE3lhSHge89S
	7XaQSF86HRp3Jtg==
X-Google-Smtp-Source: AGHT+IFiUfIYzj4rjDfIocFY+Zq89FGHUz0Fh/cjhy+mbnj+WnaTwAetyDwYahJAg/CF95TRVy0QHw==
X-Received: by 2002:a05:6000:2a6:b0:391:1806:e23d with SMTP id ffacd0b85a97d-3971d03d1b7mr3515213f8f.6.1741960439864;
        Fri, 14 Mar 2025 06:53:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7eb8c2sm5503118f8f.85.2025.03.14.06.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 06:53:59 -0700 (PDT)
Message-ID: <ed45849c-12b6-446e-b7ad-3e0469378b4d@rivosinc.com>
Date: Fri, 14 Mar 2025 14:53:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/17] RISC-V: KVM: add SBI extension init()/deinit()
 functions
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-15-cleger@rivosinc.com>
 <20250313-f08cee46c912f729d1829d37@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250313-f08cee46c912f729d1829d37@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 13/03/2025 15:27, Andrew Jones wrote:
> On Mon, Mar 10, 2025 at 04:12:21PM +0100, Clément Léger wrote:
>> The FWFT SBI extension will need to dynamically allocate memory and do
>> init time specific initialization. Add an init/deinit callbacks that
>> allows to do so.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 +++++++++
>>  arch/riscv/kvm/vcpu.c                 |  2 ++
>>  arch/riscv/kvm/vcpu_sbi.c             | 29 +++++++++++++++++++++++++++
>>  3 files changed, 40 insertions(+)
>>
>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
>> index 4ed6203cdd30..bcb90757b149 100644
>> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
>> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
>> @@ -49,6 +49,14 @@ struct kvm_vcpu_sbi_extension {
>>  
>>  	/* Extension specific probe function */
>>  	unsigned long (*probe)(struct kvm_vcpu *vcpu);
>> +
>> +	/*
>> +	 * Init/deinit function called once during VCPU init/destroy. These
>> +	 * might be use if the SBI extensions need to allocate or do specific
>> +	 * init time only configuration.
>> +	 */
>> +	int (*init)(struct kvm_vcpu *vcpu);
>> +	void (*deinit)(struct kvm_vcpu *vcpu);
>>  };
>>  
>>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
>> @@ -69,6 +77,7 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
>>  bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
>>  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>  void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
>> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
>>  
>>  int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
>>  				   unsigned long *reg_val);
>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>> index 60d684c76c58..877bcc85c067 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -185,6 +185,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>  
>>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>  {
>> +	kvm_riscv_vcpu_sbi_deinit(vcpu);
>> +
>>  	/* Cleanup VCPU AIA context */
>>  	kvm_riscv_vcpu_aia_deinit(vcpu);
>>  
>> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
>> index d1c83a77735e..858ddefd7e7f 100644
>> --- a/arch/riscv/kvm/vcpu_sbi.c
>> +++ b/arch/riscv/kvm/vcpu_sbi.c
>> @@ -505,8 +505,37 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
>>  			continue;
>>  		}
>>  
>> +		if (!ext->default_disabled && ext->init &&
>> +		    ext->init(vcpu) != 0) {
>> +			scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
>> +			continue;
>> +		}
> 
> I think this new block should be below the assignment below (and it can
> drop the continue) and it shouldn't check default_disabled (as I've done
> below). IOW, we should always run ext->init when there is one to run here.
> Otherwise, I how will it get run later?

Ok, i did not saw that there was a possibility to enable the extension
at a later time. I'll fix that.

Thanks,

Clément

> 
>> +
>>  		scontext->ext_status[idx] = ext->default_disabled ?
>>  					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
>>  					KVM_RISCV_SBI_EXT_STATUS_ENABLED;
> 
>                 if (ext->init && ext->init(vcpu))
>                     scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
> 
>>  	}
>>  }
>> +
>> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
>> +	const struct kvm_riscv_sbi_extension_entry *entry;
>> +	const struct kvm_vcpu_sbi_extension *ext;
>> +	int idx, i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
>> +		entry = &sbi_ext[i];
>> +		ext = entry->ext_ptr;
>> +		idx = entry->ext_idx;
>> +
>> +		if (idx < 0 || idx >= ARRAY_SIZE(scontext->ext_status))
>> +			continue;
>> +
>> +		if (scontext->ext_status[idx] == KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE ||
>> +		    !ext->deinit)
>> +			continue;
>> +
>> +		ext->deinit(vcpu);
>> +	}
>> +}
>> -- 
>> 2.47.2
>>
> 
> Thanks,
> drew


