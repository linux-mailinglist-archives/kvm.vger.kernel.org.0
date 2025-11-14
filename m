Return-Path: <kvm+bounces-63214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E30AC5E288
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 56CC23A15CF
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 15:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3C63451AF;
	Fri, 14 Nov 2025 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cp7YVkHa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D361032ED3F
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 15:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763132815; cv=none; b=Kvujmc7zvQzZgYAJPBYTviI0Au/bOgkdjuoHHyG2Aycsc0+2HJ86IKZawHh4caHj/DlVoIVtNf1Ww3Yo99i8BddR3qUrwttx6QmxLYjqIPZDC1tVjC6wbbLqdfZdVgHfq4gnMS02cdoevZTAD8ChWFBx4tVhRAVibWin1M5WV/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763132815; c=relaxed/simple;
	bh=D56h290Ek9vvElhgVjxQluMmQW8tvFbHYxFhWv/sfw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XxaiqXuicWc26qPYr/PnQEGh8AtOaX++06EGM6kc5TnFbWxRvtPT3s19aVPGn5riMX+Igr+X+XvET2nCgs9eJt4k2m8cjesHE6pVnILAOa1dHI9puBi/TLBGyTSB7cJeb1i2FFsZRDSbUueBtoqrwsSPd9LRY95FWH5s14ZB+Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cp7YVkHa; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso5043901a12.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 07:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763132812; x=1763737612; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q7E3ToA9iZqjwIG/5taD504oxZsvjvFhSQsDiDa3eMI=;
        b=cp7YVkHaQ5uKuZDM4uYEHZ3zrfrIcnf1Px7Ghd/a/xQrfP+CJYAW8dQ3I7DP7NRaQ2
         cmYtpciOhtbI3xvi0yT8yxvEpLd3n+hIp8m3+Ho2oH/scFrDckRhRetpp6ICs/XTgM2R
         IZBo6qk4sQpbqs/1pvkMHYcRkNUpVOvk44Wjzgz9h4AQcgkMzQNHDMEYVvDNzMTrS1ik
         So3dvdeCX0bv3KMoBDmbpfE5jXhOn3CFFw81Fwj8QPIdhHqVWXPtUhchvyBzxQWXRM/1
         39rFsByaZaOdT+SwiGjmt/tjxgOwAc3s+poPqXA9ivYrWaPeX1x8MKwg64fPWoSNV7f/
         wIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763132812; x=1763737612;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7E3ToA9iZqjwIG/5taD504oxZsvjvFhSQsDiDa3eMI=;
        b=Ej0O6mwNgmefH0DK9pBa44/6d3ExcUDRuy7ONcsPnlJkFw/beAElrgP+0qkVpksE45
         mzGgBC0VA1eCL9F8jyfC0olDmZCj6sUhkgB+Br89ivmChCL1mEyD9aovUX1Nbz3p2vrG
         2EjMLv2QDU6IqtklRGXJVwpomfhd3RMmiEij/FU3PVLWpl7U4n2g3U2+OGU6Ox0XANzz
         Y9pSn7VoQbrqd4ZMb4zLDVDSN3AZ2jaRbhvmcLT1HAZgU03ZIPbD9gb3pqbdAoTz5Pi1
         DVrwUbsCVW0LhdYDdtRfe5ZUb9KcOT8AQe4ByyAn3OE6ElDbagzQCtpIU6FE/IzwKdMI
         9gxw==
X-Gm-Message-State: AOJu0YzafYuAx30HX3SI7W7EVZrYwStOIjwDwZIDyBy5gOzgxTaM5F+r
	TdmChcC+fwLEdGZgcfsnp29tvYKUbO8BHv9UrZ8VAopLkVSrrN/v0sGD
X-Gm-Gg: ASbGncu7/xo1xB48Qx7veALOsPEHBy3K2/3QcZArdoe/R9pqnckQqK/lqXNlngNVQz7
	rW2gacqykAWK63hLM5PDru4rkcTi7spB8gJ0b3BORay+e6BIYVjlCx4y5u5iytva/m5zlBIWI15
	mat6oAAjr781aoQ1gPbqm6hwfIto7QnJsT7KrFARIL1Qy+e1fdC0jmJoLfUkcmY95lAkNRIlGiC
	V9MgF87PCDm0NWKFpsi17nClF0jH+fqIlW+SvpTxf/VWtK2YDJVHCY2z0JSVZSDQ0VEuDFbxCBW
	pMrRhOZFn19Vj1ZXD/BbsX4z3IlGmhCMnaE9wAZ5L++wP3IvZC66fi3VKur1pfxDdAdR8DTZkVu
	okJl+b1ro+O2hYi0IButJVNO9VG4wwQpFhnL9HVs8OKZM9i3EbTxRjh1oqqLZlKPJdDpf7+jdoa
	zblWXBfYpTYtIK
X-Google-Smtp-Source: AGHT+IEqp3XPnQlVmncqAy8qGsHjlsVQbXzmmI3wquskxoRRCFzFDoZdwXXiK8aYDamw/aJPCPgKqQ==
X-Received: by 2002:a17:907:3ea9:b0:b70:b9b6:9a94 with SMTP id a640c23a62f3a-b7365af93e3mr433058466b.23.1763132811837;
        Fri, 14 Nov 2025 07:06:51 -0800 (PST)
Received: from [192.168.1.100] ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fd8099asm408170166b.43.2025.11.14.07.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 07:06:50 -0800 (PST)
Message-ID: <6908a285-b7b7-457a-baaf-fd01c55fe571@gmail.com>
Date: Fri, 14 Nov 2025 16:06:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/9] KVM: VMX: Use on-stack copy of @flags in
 __vmx_vcpu_run()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Brendan Jackman <jackmanb@google.com>
References: <20251113233746.1703361-1-seanjc@google.com>
 <20251113233746.1703361-2-seanjc@google.com>
Content-Language: en-US
From: Uros Bizjak <ubizjak@gmail.com>
In-Reply-To: <20251113233746.1703361-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/14/25 00:37, Sean Christopherson wrote:
> When testing for VMLAUNCH vs. VMRESUME, use the copy of @flags from the
> stack instead of first moving it to EBX, and then propagating
> VMX_RUN_VMRESUME to RFLAGS.CF (because RBX is clobbered with the guest
> value prior to the conditional branch to VMLAUNCH).  Stashing information
> in RFLAGS is gross, especially with the writer and reader being bifurcated
> by yet more gnarly assembly code.
> 
> Opportunistically drop the SHIFT macros as they existed purely to allow
> the VM-Enter flow to use Bit Test.
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/run_flags.h | 10 +++-------
>   arch/x86/kvm/vmx/vmenter.S   | 13 ++++---------
>   2 files changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> index 2f20fb170def..6a87a12135fb 100644
> --- a/arch/x86/kvm/vmx/run_flags.h
> +++ b/arch/x86/kvm/vmx/run_flags.h
> @@ -2,12 +2,8 @@
>   #ifndef __KVM_X86_VMX_RUN_FLAGS_H
>   #define __KVM_X86_VMX_RUN_FLAGS_H
>   
> -#define VMX_RUN_VMRESUME_SHIFT				0
> -#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
> -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
> -
> -#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
> -#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
> +#define VMX_RUN_VMRESUME			BIT(0)
> +#define VMX_RUN_SAVE_SPEC_CTRL			BIT(1)
> +#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(2)
>   
>   #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 574159a84ee9..93cf2ca7919a 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -92,7 +92,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
>   	/* Save @vmx for SPEC_CTRL handling */
>   	push %_ASM_ARG1
>   
> -	/* Save @flags for SPEC_CTRL handling */
> +	/* Save @flags (used for VMLAUNCH vs. VMRESUME and mitigations). */
>   	push %_ASM_ARG3
>   
>   	/*
> @@ -101,9 +101,6 @@ SYM_FUNC_START(__vmx_vcpu_run)
>   	 */
>   	push %_ASM_ARG2
>   
> -	/* Copy @flags to EBX, _ASM_ARG3 is volatile. */
> -	mov %_ASM_ARG3L, %ebx
> -
>   	lea (%_ASM_SP), %_ASM_ARG2
>   	call vmx_update_host_rsp
>   
> @@ -147,9 +144,6 @@ SYM_FUNC_START(__vmx_vcpu_run)
>   	/* Load @regs to RAX. */
>   	mov (%_ASM_SP), %_ASM_AX
>   
> -	/* Check if vmlaunch or vmresume is needed */
> -	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
> -
>   	/* Load guest registers.  Don't clobber flags. */
>   	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
>   	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
> @@ -173,8 +167,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
>   	/* Clobbers EFLAGS.ZF */
>   	CLEAR_CPU_BUFFERS
>   
> -	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
> -	jnc .Lvmlaunch
> +	/* Check @flags to see if vmlaunch or vmresume is needed. */
> +	testl $VMX_RUN_VMRESUME, WORD_SIZE(%_ASM_SP)
> +	jz .Lvmlaunch


You could use TESTB instead of TESTL in the above code to save 3 bytes
of code and some memory bandwidth.

Assembler will report unwanted truncation if VMX_RUN_VRESUME ever
becomes larger than 255.

BR,
Uros.

