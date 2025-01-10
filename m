Return-Path: <kvm+bounces-35136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F3EAA09ECC
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B85A3AA5C2
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 23:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2693422258F;
	Fri, 10 Jan 2025 23:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="PgcqoVv1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFC922069F
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 23:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736552525; cv=none; b=uI1dlOkDl8xIADPVoxqUxBcVlSPT14JMS2iKU+v1Sb5C1bttnyST19RYYbna1RZtg4s5PXxOcrQlSK0A3iBsmpEmvVoaPa3FmaWho6PUwJJ8m5yPNGz26yqjT9NbbC8M3oI4PXWfZr08ncNqWMt5rgnnKbEd7LliDa3osIX+nvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736552525; c=relaxed/simple;
	bh=rIg33OnS0yCiFLFpnOIjwRwhKwMC1og1QwRWPimH85c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=bmqIq8AVWBkHN21Qdwz0d7WqiZiAKJ4TmnhFmL+lJA59KxgArVYz1ArUtLBbmQXXPwU/RJa6cw6RJXQxacCTIqYBIbObmQH1uqk7eGCSHXKVvB/9VYOpTxS0ioKqhJxnBZmIpfCFZgKArsO3Gx9x19wqVxd1SPEpznAbiGBfhCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=PgcqoVv1; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-844ee166150so81949139f.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 15:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1736552523; x=1737157323; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y41MK1nXhHF98Zje9jhZUfIRHZr079NmtrcL30tPVwU=;
        b=PgcqoVv1u8bNKof9sQlJjzDxOcek2ysOWgyFB59nD6hrNB8oOHxVGD8yQ9PFy8mI1G
         YmGullwLsLjqEOOgxownYIGVZbVPm2JgN/ycpd6GaL7hU1y5/sV5flJh6a2VcBGTEKPl
         3p1pws2eaDBCCoAPDzQESfFHm7B6yArTP/bfTrKuGiuSi2kDWmNbFfyP/fUbO0IwBMhJ
         OX8VCUdKXdoNJJrrrJP4lfzWFPHNzgB44xevB/YimHIHIsgbH2M0LjXVF/rDUyVm3xgu
         VLbbYM9PXrGOoT8IfSMnGJmRmJUsBhJM5X8/2cMx8ujCvS1NfBpIp7B+gx6Fj31iLJ09
         cBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736552523; x=1737157323;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y41MK1nXhHF98Zje9jhZUfIRHZr079NmtrcL30tPVwU=;
        b=KljXLWBM4knJiLP9Ljvqv5eCkYCpigjNgz+RzntGHpjlz8oQLoytDUtju6SNutT/yT
         aTzbszA+TqkhJQ3IXL8HBP3rSoAomw4EMaF+ToEufYnLCG7xF6urI8DtOa9GhnPwjaEe
         gdDHLZ1VphNu4bNyqD+SZk8ioDoa2O4psIeJTzBggg//B+vtqWgfl4GTbfVHrBX6zc84
         epNQL5Sr+Ug/mGQc2UTko5ovmDEZzRwDvaElrIGBAGA5CaewLeEgvJqTCgcTDrWcLxDj
         dg+yMIBMp6Og8sa3Jj4pDdyqLbAwUyN9WbzcE8AA3ZjAzLoNZO7KHkn5vGHdboFEWBNC
         t7ng==
X-Forwarded-Encrypted: i=1; AJvYcCUHLz5179XDrR2sb/QAGHLeCcquNFuboZbukUUClMypaw20/usn+S5EqyMYHIFeWrIPjz8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg7PtLdGX9SyEeQkXxco78DmesZb72WTcK/g6O1BaTaHZtUbFv
	8A4zldSxuv2wLTNtNzW2fBRNSvvzQozsu47Y9SA/EcdKJsI/4cc5InvMXATGaZo=
X-Gm-Gg: ASbGncvxegB4jsjFIDSZ5pYYBF/7/st2305PgsX6iE/qV6TCONIYXFfR/hVrqIDhBNi
	glROhYgD25dWnflvWLQMwm4xPIBElx6tyDTFU72DOHlkAmd85giTwpgHxZFTztV4KkL65750PmK
	8eSYYZpqzp8dRnAQ7w6EzAzIEpljZ2f7ypOoycXMBN1E4r9t5I23l9ICc7FmUqFGjEHB/gfvqmM
	BemnSpe+FEV/x8WAjc7T49bGjxSJD1PbngsTRxVePmjOsfX4k5H760DoepQ61Tbp+EEI9f+yK4m
	0FS1
X-Google-Smtp-Source: AGHT+IEvcdQ6WJ2GPTcAtzPp+zU0y4cUD8oHRoixv++8yvMOyxwbuZNKeY1IICJwtAM7OPu+Ww0QiQ==
X-Received: by 2002:a05:6602:3787:b0:843:ea9a:acc4 with SMTP id ca18e2360f4ac-84ce01254c3mr1252136939f.8.1736552522737;
        Fri, 10 Jan 2025 15:42:02 -0800 (PST)
Received: from [100.64.0.1] ([165.188.116.9])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84d4faee16bsm113381339f.4.2025.01.10.15.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 15:42:02 -0800 (PST)
Message-ID: <a6196a16-808e-4a69-bcec-a83d868b726f@sifive.com>
Date: Fri, 10 Jan 2025 17:42:00 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] RISC-V: KVM: add SBI extension init()/deinit()
 functions
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
 <20250106154847.1100344-4-cleger@rivosinc.com>
Content-Language: en-US
From: Samuel Holland <samuel.holland@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org
In-Reply-To: <20250106154847.1100344-4-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Clément,

On 2025-01-06 9:48 AM, Clément Léger wrote:
> The FWFT SBI extension will need to dynamically allocate memory and do
> init time specific initialization. Add an init/deinit callbacks that
> allows to do so.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 ++++++++
>  arch/riscv/kvm/vcpu.c                 |  2 ++
>  arch/riscv/kvm/vcpu_sbi.c             | 31 ++++++++++++++++++++++++++-
>  3 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index b96705258cf9..8c465ce90e73 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -49,6 +49,14 @@ struct kvm_vcpu_sbi_extension {
>  
>  	/* Extension specific probe function */
>  	unsigned long (*probe)(struct kvm_vcpu *vcpu);
> +
> +	/*
> +	 * Init/deinit function called once during VCPU init/destroy. These
> +	 * might be use if the SBI extensions need to allocate or do specific
> +	 * init time only configuration.
> +	 */
> +	int (*init)(struct kvm_vcpu *vcpu);
> +	void (*deinit)(struct kvm_vcpu *vcpu);
>  };
>  
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> @@ -69,6 +77,7 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
>  bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
>  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
>  
>  int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
>  				   unsigned long *reg_val);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e048dcc6e65e..3420a4a62c94 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -180,6 +180,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> +	kvm_riscv_vcpu_sbi_deinit(vcpu);
> +
>  	/* Cleanup VCPU AIA context */
>  	kvm_riscv_vcpu_aia_deinit(vcpu);
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 6e704ed86a83..d2dbb0762072 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -486,7 +486,7 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
>  	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
>  	const struct kvm_riscv_sbi_extension_entry *entry;
>  	const struct kvm_vcpu_sbi_extension *ext;
> -	int idx, i;
> +	int idx, i, ret;
>  
>  	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
>  		entry = &sbi_ext[i];
> @@ -501,8 +501,37 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
>  			continue;
>  		}
>  
> +		if (ext->init) {
> +			ret = ext->init(vcpu);
> +			if (ret)
> +				scontext->ext_status[idx] =
> +					KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
> +		}
> +
>  		scontext->ext_status[idx] = ext->default_disabled ?
>  					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
>  					KVM_RISCV_SBI_EXT_STATUS_ENABLED;

This will overwrite the KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE set above.

>  	}
>  }
> +
> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> +	const struct kvm_riscv_sbi_extension_entry *entry;
> +	const struct kvm_vcpu_sbi_extension *ext;
> +	int idx, i;
> +
> +	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +		entry = &sbi_ext[i];
> +		ext = entry->ext_ptr;
> +		idx = entry->ext_idx;
> +
> +		if (idx < 0 || idx >= ARRAY_SIZE(scontext->ext_status))
> +			continue;
> +
> +		if (scontext->ext_status[idx] != KVM_RISCV_SBI_EXT_STATUS_ENABLED || !ext->deinit)

Given that an extension can be enabled/disabled after initialization, this
should only skip deinit if the status is UNAVAILABLE.

Regards,
Samuel

> +			continue;
> +
> +		ext->deinit(vcpu);
> +	}
> +}


