Return-Path: <kvm+bounces-62141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAD5C38AB1
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 02:14:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8380189966E
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 01:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3B91F5820;
	Thu,  6 Nov 2025 01:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a4hr2rgb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E941EEA5D
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 01:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762391527; cv=none; b=DgqxKVEYW+yjOJ0Zt6l8apL3BAoiLllPQPOsKq+HpoVavPMRii792jsCrv/JJnfEyAouQ+nslFnGjj5hd2C1BhfvoIfI6zkLwRmCCEtGvqZnk97FuyWr6G5ilB78aEb0cAe1gu6oSURya0ujFpypEZpIeJ3PusHJpcwz3jwGmFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762391527; c=relaxed/simple;
	bh=JFanjHbbLwb5uHWb9hkMmEsFRF+9A56LzAFzGKiegec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=temYJWS4wLPU+gBY5XPUF8GoghH7hxT9uvJdyMbGXg41b2Th7A2UN0AIKgt+OaV7yTC6ThPRej2XphVSGWmGqDKHC+EfzfzIdrZYBzShPzV0fLvr1Z4TB476pzw3tF0VLv+FZSBHqdC9Cbxr0nrx2IYxNYl13dYQ/PaRBTqlMuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a4hr2rgb; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2930e2e8e7fso5425635ad.2
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 17:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762391524; x=1762996324; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ATDrY9pnr/Exq7p+ImQ6l1ONiv9lIJFXXdONPuERRRI=;
        b=a4hr2rgbOpaadNnqnXdg/3Z+yCC3hxhbZNzGhBsm2vhfW0axPd/58OWan75dYgCPxK
         bZG/YM4ayHAkVY4HTZEd8mWOrCENdpUPvV0snFTfH8GZAde8ZZaJWhq8c+/OD7XLlCLY
         xAyeESdLQ5wwqfX/r8oi7Tw8aFv9JuEpy8BjzB0gxBmAT8YVESz5Go6aOSKviNyIsLFj
         qeuBhHXu4Jz82SWTl3VGxr//g7M7chYg0UaA+T3L86/p8SwzfpyOvmOhIOpkGqjJHIj3
         poS9bH1bhULSf4bLTFNO1fPsDSrdPL9vLtvPwWWF3AxnyXlM4Z47NtQIJ+tI4HB7GI3C
         EJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762391524; x=1762996324;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ATDrY9pnr/Exq7p+ImQ6l1ONiv9lIJFXXdONPuERRRI=;
        b=mS8O5was5gxq7cDj8AFllJ0D7z5uxf3szj84Vazu4zHVGydro43rMUwCL785DGGSpw
         ZCn3plb7NlxO11Pp/cVp7WTV7jj9VrSl4xL4m/92gRG7/WEdtJ184pM81xqLc+5nXGVO
         MD6RlPHyeRzKRm7NQkgJayEkJyFyVGiYp47KOCZv66Kz6aUN8ONmXwQC7q+Tm2Ao0tmU
         kSOmEVyVWStTENyp3kSLYH66TWxrPNvmYgixmSYcbM00+ecWXN/WakZbENDs73H4VicQ
         Lhsc7srtIu2Vru1y4puhFFEMXhXPN8ytyWrZQKhazbQoAm1edd00/x+97XRXzYrWNaRD
         s8VA==
X-Gm-Message-State: AOJu0YxrL9O9qhEFXc+jGxXOMnbE+0XEpoyYoseW5EKm4NJOIM70uBbJ
	1bz9Oz3zAJX4HLnVbTrfrB/yb1bHQOeapcyQHWqWJHvUOO4a43IM72OKu1YM3DD7EzBHGYjRj5a
	WuEqJRA==
X-Google-Smtp-Source: AGHT+IFU8dVy3+C8h5H/JSEcFYx+3vw6lAHXCrtYhjVhwrTs7NO7K+KQeCc61ZdcJOxJbbS8jvKyp34an1I=
X-Received: from plks11.prod.google.com ([2002:a17:903:2cb:b0:295:445a:2a7c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:40cc:b0:295:9cb5:ae57
 with SMTP id d9443c01a7336-2962aead085mr56511175ad.60.1762391524202; Wed, 05
 Nov 2025 17:12:04 -0800 (PST)
Date: Wed, 5 Nov 2025 17:12:02 -0800
In-Reply-To: <CAFULd4Y6W0hJbA8Ki2yB60537mC8+ohXyUgxD+HuKDQhq7zGmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807063733.6943-1-ubizjak@gmail.com> <aKSRbjgtp7Nk8-sb@google.com>
 <CAFULd4ZOtj7WZkSSKqLjxCJ-yBr20AYrqzCpxj2K_=XmrX1QZg@mail.gmail.com>
 <aKTI1WOJAKDnkRyu@google.com> <CAFULd4ZR6TPVqq5TXToR-0HbX5oM=NEdw126kcDe5LNDdxZ++w@mail.gmail.com>
 <CAFULd4Y6W0hJbA8Ki2yB60537mC8+ohXyUgxD+HuKDQhq7zGmA@mail.gmail.com>
Message-ID: <aQv14mmAkUPL-Fap@google.com>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize SPEC_CTRL handling in __vmx_vcpu_run()
From: Sean Christopherson <seanjc@google.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025, Uros Bizjak wrote:
> On Wed, Aug 20, 2025 at 8:10=E2=80=AFAM Uros Bizjak <ubizjak@gmail.com> w=
rote:

...

> VMX patch is at [1]. SVM patch is a bit more involved, because new
> 32-bit code needs to clobber one additional register. The SVM patch is
> attached to this message, but while I compile tested it, I have no
> means of testing it with runtime tests. Can you please put it through
> your torture tests?
>=20
> [1] https://lore.kernel.org/lkml/20250820100007.356761-1-ubizjak@gmail.co=
m/

Finally got around to testing this (such a pain to test this code).  I hack=
ed
a host to allow any value for MSR_IA32_SPEC_CTRL, and then ran in a VM to v=
erify
KVM could actually save/restore 64-bit values (and that KVM elides the WRMS=
Rs
when possible).

The VMX patch looks good (I'll get it applied shortly).  The SVM version ha=
s a
bug, but I've got it working and will post a patch shortly.
=20
>=20
> Uros.

> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 235c4af6b692..a1b9f2ac713c 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -52,11 +52,23 @@
>  	 * there must not be any returns or indirect branches between this code
>  	 * and vmentry.
>  	 */
> -	movl SVM_spec_ctrl(%_ASM_DI), %eax
> -	cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
> +#ifdef CONFIG_X86_64
> +	mov SVM_spec_ctrl(%rdi), %rdx
> +	cmp PER_CPU_VAR(x86_spec_ctrl_current), %rdx
> +	je 801b
> +	movl %edx, %eax
> +	shr $32, %rdx
> +#else
> +	mov SVM_spec_ctrl(%edi), %eax
> +	mov PER_CPU_VAR(x86_spec_ctrl_current), %ecx
> +	xor %eax, %ecx
> +	mov SVM_spec_ctrl + 4(%edi), %edx
> +	mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %esi
> +	xor %edx, %esi
> +	or %esi, %ecx
>  	je 801b
> +#endif
>  	mov $MSR_IA32_SPEC_CTRL, %ecx
> -	xor %edx, %edx
>  	wrmsr
>  	jmp 801b
>  .endm
> @@ -80,14 +92,31 @@
>  	cmpb $0, \spec_ctrl_intercepted
>  	jnz 998f
>  	rdmsr
> -	movl %eax, SVM_spec_ctrl(%_ASM_DI)
> +#ifdef CONFIG_X86_64
> +	shl $32, %rdx
> +	or %rax, %rdx
> +	mov %rdx, SVM_spec_ctrl(%rdi)
>  998:

To avoid defining the 998 label separately for 64-bit vs. 32-bit, I think i=
t's
worth making two 32-bit writes to svm->spec_ctrl even on 64-bit kernels, e.=
g.

	cmpb $0, \spec_ctrl_intercepted
	jnz 998f
	rdmsr
	movl %eax, SVM_spec_ctrl(%_ASM_DI)
	movl %edx, SVM_spec_ctrl + 4(%_ASM_DI)
998:
	/* Now restore the host value of the MSR if different from the guest's.  *=
/
> -
>  	/* Now restore the host value of the MSR if different from the guest's.=
  */
> -	movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
> -	cmp SVM_spec_ctrl(%_ASM_DI), %eax
> +	mov SVM_spec_ctrl(%rdi), %rdx
> +	cmp PER_CPU_VAR(x86_spec_ctrl_current), %rdx
>  	je 901b
> -	xor %edx, %edx
> +	movl %edx, %eax
> +	shr $32, %rdx
> +#else
> +	mov %eax, SVM_spec_ctrl(%edi)
> +	mov %edx, SVM_spec_ctrl + 4(%edi)
> +998:
> +	/* Now restore the host value of the MSR if different from the guest's.=
  */
> +	mov SVM_spec_ctrl(%edi), %eax
> +	mov PER_CPU_VAR(x86_spec_ctrl_current), %esi
> +	xor %eax, %esi
> +	mov SVM_spec_ctrl + 4(%edi), %edx
> +	mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %edi
> +	xor %edx, %edi
> +	or %edi, %esi
> +	je 901b

This particular flow is backwards, in that it loads the guest value into ED=
X:EAX
instead of the host values.

> +#endif
>  	wrmsr
>  	jmp 901b
>  .endm


