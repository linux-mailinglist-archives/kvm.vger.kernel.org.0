Return-Path: <kvm+bounces-43119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 044E9A8500E
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 01:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9A901B8006B
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 23:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE3E214815;
	Thu, 10 Apr 2025 23:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3u7Ky+9f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0A320E334
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 23:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744327463; cv=none; b=HIKw1Oe9o0Xuk7wT0BOua9Fu3IOkpUjux3/ks5wacxX5sNL9SXetyzHwzrVJi82EJwGnm2DsWYYNZA+6gGkUQC/NRYaW6OQkTSsRt7e9ZS4xTtozL6nu7CJ3aEyAUeZORj/hH9Zp3FJPDkL/6OJrNo9+k/cp5p+1OlL+MS5c6t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744327463; c=relaxed/simple;
	bh=fRu1wIpBkqC/PAC+6Z3ide0GL77+kwaEESC4lKY2HQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PQU6pZsWA+CPsfvlwZ5Fus+6LFJEsk5ixy5S05G4JC89m+OLE1jh0LM4GMvbgb3xCapr52LFkqICg4zCdPch39euEu+MdGFbcHda8GwvBlgH5Tuq8xdYhGYHbyfdAVAUaHhm1Tu7kLksxLqdfTH2Oqkd9E44vcQ68rceaed57/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3u7Ky+9f; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736c7df9b6cso1623319b3a.3
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 16:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744327461; x=1744932261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+8Hj0FhxYq298MEgk+A50ezX9To9apyasGONCk8/EIY=;
        b=3u7Ky+9frkNfCSvunj3hgyXaCVhwQWpsJbi1kvWmQtcGe+GsRD598bauPycpTprcD6
         XGD+aPRexvyp8B8N5R+Y40IN+xBJMgfvd2vo8wEWcDIFLVunLWkQCGQTP1OF8+5Of5tY
         h4gTalndOQUdDo50dGBtpP9O9VAPvw2fFnSmo1ySO1fzEWNakHbU3PYx2wpMv1Ig9YW5
         v06Qe7baAARVR3deBAk9aM2bEqc2ROzGrDzz6/tvmsLuBFYWsfqD3K2l1WKJX3SnbqDD
         H7Sxc+25sn/E2kpmCWLuUQi/Iq7M8NHLMtgELvTYk+iLGHNJbb+0cw3ePrc8PkUVEz8J
         Ij7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744327461; x=1744932261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+8Hj0FhxYq298MEgk+A50ezX9To9apyasGONCk8/EIY=;
        b=FqjGOShR8r+wsKebql09Q8YFP50ONUMXAdeKNochVNeMLUlm8KyRuUlSq2iahuhDhl
         2RXBDYL5wissojcJTtBCi2TOLjf0z8PfsLST4OL7Ti3k7TRTwgXbn7+sjVTE1LC0DekQ
         OAbCKSVax2BntmQmj94j1Jtn9+5W/DDho5TquBH1BjCCcFDCsJRvc7FfCxKq8/5X+Dxi
         Fd7sJsCeIfKci0+HYhG9/UV+9WDMyb8M0m8SICPOftaKQzIk4J+3mBVu8OSutPOFe3cv
         yJeEtoH7QrW2Ii80KwWiO3jSCbcibKVfgVPY1j8tWF0vCGr8NCrpxTZ6c2Tw8qH1R2Dr
         nFsA==
X-Forwarded-Encrypted: i=1; AJvYcCWDUDZ2IoS7ryBfxb3S+d0jGysIiHWk/gcPLJDmFKpTo38UyyAGQbGvjPnqo6kZNn8gIS8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+KGKASJd3olyNzaJdzjVINZ+aB9BPqC14m9RRnf8BhFjpUBID
	Kt2VNmgD5wMh8Buucr/NxTtDIC2LAGVxcS75aGe6XAwgGsB5Fs/6ffcydNv3VX7LZmUd0SYgFx2
	QPA==
X-Google-Smtp-Source: AGHT+IHWYnK2BwFW7Mr5VmhaaxwX1jXjykj9i9MFxC3vV2mlnL+NePMyv0dJBUjVtFSac3MvKiuBJyLqfxA=
X-Received: from pfbfj37.prod.google.com ([2002:a05:6a00:3a25:b0:730:8b4c:546c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:21c7:b0:736:5c8e:baaa
 with SMTP id d2e1a72fcca58-73bd119427emr706022b3a.2.1744327460939; Thu, 10
 Apr 2025 16:24:20 -0700 (PDT)
Date: Thu, 10 Apr 2025 16:24:19 -0700
In-Reply-To: <20250331082251.3171276-11-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250331082251.3171276-1-xin@zytor.com> <20250331082251.3171276-11-xin@zytor.com>
Message-ID: <Z_hTI8ywa3rTxFaz@google.com>
Subject: Re: [RFC PATCH v1 10/15] KVM: VMX: Use WRMSRNS or its immediate form
 when available
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-edac@vger.kernel.org, kvm@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org, 
	linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, jgross@suse.com, 
	andrew.cooper3@citrix.com, peterz@infradead.org, acme@kernel.org, 
	namhyung@kernel.org, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	kan.liang@linux.intel.com, wei.liu@kernel.org, ajay.kaher@broadcom.com, 
	alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com, 
	tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com, 
	luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com, 
	haiyangz@microsoft.com, decui@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 31, 2025, Xin Li (Intel) wrote:
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> ---
>  arch/x86/include/asm/msr-index.h |  6 ++++++
>  arch/x86/kvm/vmx/vmenter.S       | 28 ++++++++++++++++++++++++----
>  2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index e6134ef2263d..04244c3ba374 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1226,4 +1226,10 @@
>  						* a #GP
>  						*/
>  
> +/* Instruction opcode for WRMSRNS supported in binutils >= 2.40 */
> +#define ASM_WRMSRNS		_ASM_BYTES(0x0f,0x01,0xc6)
> +
> +/* Instruction opcode for the immediate form RDMSR/WRMSRNS */
> +#define ASM_WRMSRNS_RAX		_ASM_BYTES(0xc4,0xe7,0x7a,0xf6,0xc0)
> +
>  #endif /* _ASM_X86_MSR_INDEX_H */
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index f6986dee6f8c..9fae43723c44 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -64,6 +64,29 @@
>  	RET
>  .endm
>  
> +/*
> + * Write EAX to MSR_IA32_SPEC_CTRL.
> + *
> + * Choose the best WRMSR instruction based on availability.
> + *
> + * Replace with 'wrmsrns' and 'wrmsrns %rax, $MSR_IA32_SPEC_CTRL' once binutils support them.
> + */
> +.macro WRITE_EAX_TO_MSR_IA32_SPEC_CTRL
> +	ALTERNATIVE_2 __stringify(mov $MSR_IA32_SPEC_CTRL, %ecx;		\
> +				  xor %edx, %edx;				\
> +				  mov %edi, %eax;				\
> +				  ds wrmsr),					\
> +		      __stringify(mov $MSR_IA32_SPEC_CTRL, %ecx;		\
> +				  xor %edx, %edx;				\
> +				  mov %edi, %eax;				\
> +				  ASM_WRMSRNS),					\
> +		      X86_FEATURE_WRMSRNS,					\
> +		      __stringify(xor %_ASM_AX, %_ASM_AX;			\
> +				  mov %edi, %eax;				\
> +				  ASM_WRMSRNS_RAX; .long MSR_IA32_SPEC_CTRL),	\
> +		      X86_FEATURE_MSR_IMM
> +.endm

This is quite hideous.  I have no objection to optimizing __vmx_vcpu_run(), but
I would much prefer that a macro like this live in generic code, and that it be
generic.  It should be easy enough to provide an assembly friendly equivalent to
__native_wrmsr_constant().


> +
>  .section .noinstr.text, "ax"
>  
>  /**
> @@ -123,10 +146,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
>  	cmp %edi, %esi
>  	je .Lspec_ctrl_done
> -	mov $MSR_IA32_SPEC_CTRL, %ecx
> -	xor %edx, %edx
> -	mov %edi, %eax
> -	wrmsr
> +	WRITE_EAX_TO_MSR_IA32_SPEC_CTRL
>  
>  .Lspec_ctrl_done:
>  
> -- 
> 2.49.0
> 

