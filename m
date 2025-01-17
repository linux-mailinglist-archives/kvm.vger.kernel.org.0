Return-Path: <kvm+bounces-35796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19467A15328
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 774CF3A17EA
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 15:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 758DB19AD8C;
	Fri, 17 Jan 2025 15:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="dz0iJhY+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4A6D530
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737129022; cv=none; b=NMUHO4vlIuDSiFjGO0sXc6gJK8EcMaw0oleLr8In7YLIbEHfFBX1UDD1bAijzSqPmR7ADHtd6cZwU3OmSQChuSaKqlEbMY3QWTrrK5hbI4dGRaJlJvni01zpONLqQpyIDFrfEkut2ULW7lIpI5D9ssQyXM9n0wP429+dbDJp6rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737129022; c=relaxed/simple;
	bh=dclbQA2kv91cOorJaTivwzz7mnR/zYBL6itMyl+l6F4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=koLPbptpyWMaplNw9NRrs3eY2AWH9qSWHc3IqN2YAjcGtIxilGrUHW8H7OrxvDRTGvMJnwJmgjb1gEWVJvKytYZRL6MJHIb2JDnnZSmZUX7S0S3SZTrNqNmJWd8EV6c9CpDaA9iEQh0Iavj0Id4/6m2yAgpcCAq3lyZeYcMLm44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=dz0iJhY+; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3862f32a33eso1055910f8f.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 07:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1737129018; x=1737733818; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cp/GIvJPAqb8LwPhNDqvZSb8wpAapnmNF5gAZrNXtXA=;
        b=dz0iJhY+SaJlzRgU+0IhBXaj+VQYmRdzLCvXev0LiDG27OwqdidS7M0rD8LStIevj0
         fsg+sOrWPYN99qdlTivbqFlR0IuliHlLFM50BcssVwR/dgYwzNgr1Vv6KgjmKRYevW4y
         yAstQ3Z6Ll9ihWrueHOssIVTrh1iQ4lD4IAS3BFIcsXmgtQpTdUsTcCIPFvQr42e3eRB
         Xy8UmCy7GqhOEL92ZolIQGpk+gjZyHDINdV98J5qpXlzWj3By88cNmKVjt8nOIpGvY26
         kGaDyD4WGG9SZ/0IKEWImPTW6J8BgGee+frNdcIwfzY6Ws9yv762Jfyt63LjDcuRU3xb
         7S6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737129018; x=1737733818;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cp/GIvJPAqb8LwPhNDqvZSb8wpAapnmNF5gAZrNXtXA=;
        b=TdsUpJnAe+Brx8fAWxByMVh1CHySgy8IwOFw5NAgpWvvgtVa8CVlBJ0yj+XJ3IX/VT
         BxU4nXSd96CTG4Brei9nBIRMMDa1/nyCXsWXOptDa51MnKwvaq21bsz//YgFgk4FJSe/
         PnJqoc7IYMMgcnp8A7JtkecvILaeYyU1UUaiYMeL/nxOzxMGYzYxq4p6PjDEvn0NCUy9
         U9ucNUf4oRqucZ0Yz5r24PAQsjnhs2fK0bjYNmr0+Afr9Qyl6HebH7dM9W5u4CokjzT4
         EqEevSO7A9M7TDwOnOWWgz9715nm36XPVTeev6a1QhT3GtPV1tOyw0x4jyCxrrelx1pB
         78zg==
X-Forwarded-Encrypted: i=1; AJvYcCUQL0RjS4KnMuBCyOfjMpkCuk3l/YPj0aAoJpApLAmyYhNA6bKiQwMLUlfyUQzQBesoZlE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx02sv4BPi15d4T8jfZ5seHfKTQRCU66c/q5BJLsTPgJD1CIZOV
	ZovAMtQP4d1Md8ufp6dzeduk5YGDU3Hm7+G3vUliG+yJPlrAupIOapthaQi5N6DqkD9y4quWN+2
	a
X-Gm-Gg: ASbGncvL/Tw1Jlw8qS03LuSbuCSq3PCRgb1qW3nbpnI8QJnofeXSNvpqs9NT0ymy7rZ
	bzRDE2o74jN3ghV2s+siaD4oPtGAHbHXmoD/9xAQm3/c4qm8ASbEidL30sL2yGw+gy/Wh6X7slY
	Fw1Pn18+wf/ztIt+FQMJk8l5pbSRajCAK0R/hxY5pKOKJgxAqeL/13bL/GDwH50KbL2M65zKNpU
	MsmJQlsru9kPZOeYO5GmHw7WZqFA4qSxOn0FtWMKiL8/3il0BE0AXU4vjd2ubNalMLm6HpXsPOt
	15FkuEzVYwldVz8fq8FQSS8V2Q==
X-Google-Smtp-Source: AGHT+IG2hMkiEwGdkGXBgxT0aXmQV7q70JaFEOKvaBWwhUvfyCsA51xrLRzqSMURNo7XJP0BjSwJJw==
X-Received: by 2002:a5d:620f:0:b0:38b:d765:7027 with SMTP id ffacd0b85a97d-38bf57a2675mr2269669f8f.41.1737129017614;
        Fri, 17 Jan 2025 07:50:17 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322b51bsm2860493f8f.60.2025.01.17.07.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 07:50:16 -0800 (PST)
Message-ID: <9fdcd0cf-334e-46f9-97c1-305f213d1ad3@rivosinc.com>
Date: Fri, 17 Jan 2025 16:50:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] RISC-V: KVM: add SBI extension init()/deinit()
 functions
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
References: <20250106154847.1100344-1-cleger@rivosinc.com>
 <20250106154847.1100344-4-cleger@rivosinc.com>
 <a6196a16-808e-4a69-bcec-a83d868b726f@sifive.com>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <a6196a16-808e-4a69-bcec-a83d868b726f@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/01/2025 00:42, Samuel Holland wrote:
> Hi Clément,
> 
> On 2025-01-06 9:48 AM, Clément Léger wrote:
>> The FWFT SBI extension will need to dynamically allocate memory and do
>> init time specific initialization. Add an init/deinit callbacks that
>> allows to do so.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 ++++++++
>>  arch/riscv/kvm/vcpu.c                 |  2 ++
>>  arch/riscv/kvm/vcpu_sbi.c             | 31 ++++++++++++++++++++++++++-
>>  3 files changed, 41 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
>> index b96705258cf9..8c465ce90e73 100644
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
>> index e048dcc6e65e..3420a4a62c94 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -180,6 +180,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>>  
>>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>  {
>> +	kvm_riscv_vcpu_sbi_deinit(vcpu);
>> +
>>  	/* Cleanup VCPU AIA context */
>>  	kvm_riscv_vcpu_aia_deinit(vcpu);
>>  
>> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
>> index 6e704ed86a83..d2dbb0762072 100644
>> --- a/arch/riscv/kvm/vcpu_sbi.c
>> +++ b/arch/riscv/kvm/vcpu_sbi.c
>> @@ -486,7 +486,7 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
>>  	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
>>  	const struct kvm_riscv_sbi_extension_entry *entry;
>>  	const struct kvm_vcpu_sbi_extension *ext;
>> -	int idx, i;
>> +	int idx, i, ret;
>>  
>>  	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
>>  		entry = &sbi_ext[i];
>> @@ -501,8 +501,37 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
>>  			continue;
>>  		}
>>  
>> +		if (ext->init) {
>> +			ret = ext->init(vcpu);
>> +			if (ret)
>> +				scontext->ext_status[idx] =
>> +					KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
>> +		}
>> +
>>  		scontext->ext_status[idx] = ext->default_disabled ?
>>  					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
>>  					KVM_RISCV_SBI_EXT_STATUS_ENABLED;
> 
> This will overwrite the KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE set above.

Oh yes indeed, I should add a "continue" under the if above.

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
>> +		if (scontext->ext_status[idx] != KVM_RISCV_SBI_EXT_STATUS_ENABLED || !ext->deinit)
> 
> Given that an extension can be enabled/disabled after initialization, this
> should only skip deinit if the status is UNAVAILABLE.

yeah, make sense as well,

Thanks for the review,

Clément

> 
> Regards,
> Samuel
> 
>> +			continue;
>> +
>> +		ext->deinit(vcpu);
>> +	}
>> +}
> 


