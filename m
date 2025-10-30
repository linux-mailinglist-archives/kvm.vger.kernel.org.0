Return-Path: <kvm+bounces-61481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E6BC201DC
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 13:57:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 628F442779A
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 12:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4915343D6A;
	Thu, 30 Oct 2025 12:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lvkbmCIu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04933340283
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 12:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761828736; cv=none; b=jzeaKoc0jXCyARC/XTTHGfv1UICl9jEJT5WK3IQtxA2HbCyk1ejsps61Yygsuv3b8gwb48HFvf+ytABekqEjumdTg8+kcqWssyxsK1O0P86BGIK2YBWVzdh4REIcD09pH9HzQGKAfmGGKG3cJTVAiqe5fb5FIIEGnt8mAZsoq3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761828736; c=relaxed/simple;
	bh=he4LxVFkkpMi41Qrh1SjstXT2W26FeQsM6DgFGNcIwU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OkSdgE9yYyrwrpkNiq6DANEyYGRr/wQ1egG0EA1VqZIpNzhT58rbhhshVhznp5ZtIIKBWFElC5WbjJT79xsq+nvJ5z2N2q+n8a5l60J4P/tEqmTy9SWWhcaMLzF+9li5LGL7DzpD/WNTVZclBWi6X9hfSSjjEiPvkqqZX82EW/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lvkbmCIu; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-475da25c4c4so8842755e9.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 05:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761828733; x=1762433533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rHgpoz4cxoeHenIxNUy7GMjmXnJo6tTAuygN8GMPj0M=;
        b=lvkbmCIu59J0gK8KN1pKsXVOFpUDHWSEeA+6cEQ1jMImRUy/QAQYYz0eUAOKYIbizl
         3YuPxLIBHkop/cenDzZA1zJaqNfeC/EHJ0WLBeuPSTzoPnDDyzZOqdbTKC4IenvEXwoU
         MAsjsTDNvEDNg3X4M1+NtWDQenTOYHJaugy3jtM6oyNnJc+99obn5F7bDxYEIf5V6sua
         Fh9zB4k3sqi0T/QOS/UaMnoIlRRSKEJ1I0fiosNxHIf1podKd3RHaLg7Tnyk1fWNrrJJ
         i5ctKgo2fatpVNs4uNm02sRx75gcscWsPt1VatC+QFmnXm6yjP/JW7pJ2SMbsBK3FJlw
         TaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761828733; x=1762433533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rHgpoz4cxoeHenIxNUy7GMjmXnJo6tTAuygN8GMPj0M=;
        b=xCgw+YjUG3TTOCWORK3QzcYhaDBRYjyL5rFQrafzg0pJIkx0o/KZqiFjUkuCZpv2NC
         R8kOBkkfsdHLSljUHlZpi2XtQ4x1O3ftq2dBfk/gaMtU1A5H9PgF9kV9nDvGXgTMih17
         TscWSa5rSUsH0K6j4FLzgVE9hCcIPXpIKrYd0l9/+V6h13wP4Ks4DOW6bLoBL9bCndDb
         lreIMweHyfB/ErKIYfANhtN6kaxntoBEOCPJtMKf3fcXbDURUh07tPEf9EULQkvQUu1Z
         gVyXZEtXVSOjI1RXlMhFRXl8yuEBdW26+BeIg1kReF68Ux3GaH+C1eVlXFou07xJu1mK
         3xTw==
X-Forwarded-Encrypted: i=1; AJvYcCXsWpEYN/GCzWZmlBhgOamUj+DIXKElmCVqpIUkJ6VECY3TmNMpUtCFRBxtuJtC5EmImaE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo9CZAG6cfA86lSMiMEPZpD+luN74bj4zKZVHoiSaehSqFk5E9
	M+wFddcprEv10u4Xfo6uT4U1/L2KObV8ZLYoFc5RwySGj/GIHyyIkZmb8uBkTZWInUKZjhT9kGy
	N3AXAfpaIZS+bCQ==
X-Google-Smtp-Source: AGHT+IHtJojA9a8H0GTtF3u4RfBibttIhjKKsesXh4ybzME6J3TFIQJ9be3Df3xCtjKfPhVNOQ/64I5mCxN6+w==
X-Received: from wmbjj10.prod.google.com ([2002:a05:600c:6a0a:b0:471:2040:98dd])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:81c9:b0:46e:3cd9:e56f with SMTP id 5b1f17b1804b1-4771e166d8fmr65138425e9.6.1761828733440;
 Thu, 30 Oct 2025 05:52:13 -0700 (PDT)
Date: Thu, 30 Oct 2025 12:52:12 +0000
In-Reply-To: <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com> <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDVO5U7JZF4F.1WXXE8IYML140@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
From: Brendan Jackman <jackmanb@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, 
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed Oct 29, 2025 at 9:26 PM UTC, Pawan Gupta wrote:
> When a system is only affected by MMIO Stale Data, VERW mitigation is
> currently handled differently than other data sampling attacks like
> MDS/TAA/RFDS, that do the VERW in asm. This is because for MMIO Stale Data,
> VERW is needed only when the guest can access host MMIO, this was tricky to
> check in asm.
>
> Refactoring done by:
>
>   83ebe7157483 ("KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps
>   MMIO into the guest")
>
> now makes it easier to execute VERW conditionally in asm based on
> VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO.
>
> Unify MMIO Stale Data mitigation with other VERW-based mitigations and only
> have single VERW callsite in __vmx_vcpu_run(). Remove the now unnecessary
> call to x86_clear_cpu_buffer() in vmx_vcpu_enter_exit().
>
> This also untangles L1D Flush and MMIO Stale Data mitigation. Earlier, an
> L1D Flush would skip the VERW for MMIO Stale Data. Now, both the
> mitigations are independent of each other. Although, this has little
> practical implication since there are no CPUs that are affected by L1TF and
> are *only* affected by MMIO Stale Data (i.e. not affected by MDS/TAA/RFDS).
> But, this makes the code cleaner and easier to maintain.
>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/run_flags.h | 12 ++++++------
>  arch/x86/kvm/vmx/vmenter.S   |  5 +++++
>  arch/x86/kvm/vmx/vmx.c       | 26 ++++++++++----------------
>  3 files changed, 21 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> index 2f20fb170def8b10c8c0c46f7ba751f845c19e2c..004fe1ca89f05524bf3986540056de2caf0abbad 100644
> --- a/arch/x86/kvm/vmx/run_flags.h
> +++ b/arch/x86/kvm/vmx/run_flags.h
> @@ -2,12 +2,12 @@
>  #ifndef __KVM_X86_VMX_RUN_FLAGS_H
>  #define __KVM_X86_VMX_RUN_FLAGS_H
>  
> -#define VMX_RUN_VMRESUME_SHIFT				0
> -#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
> -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
> +#define VMX_RUN_VMRESUME_SHIFT			0
> +#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT		1
> +#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT		2
>  
> -#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
> -#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
> +#define VMX_RUN_VMRESUME		BIT(VMX_RUN_VMRESUME_SHIFT)
> +#define VMX_RUN_SAVE_SPEC_CTRL		BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> +#define VMX_RUN_CLEAR_CPU_BUFFERS	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
>  
>  #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 0dd23beae207795484150698d1674dc4044cc520..ec91f4267eca319ffa8e6079887e8dfecc7f96d8 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -137,6 +137,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Load @regs to RAX. */
>  	mov (%_ASM_SP), %_ASM_AX
>  
> +	/* jz .Lskip_clear_cpu_buffers below relies on this */
> +	test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
> +
>  	/* Check if vmlaunch or vmresume is needed */
>  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
>  
> @@ -160,6 +163,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Load guest RAX.  This kills the @regs pointer! */
>  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>  
> +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> +	jz .Lskip_clear_cpu_buffers

Hm, it's a bit weird that we have the "alternative" inside
VM_CLEAR_CPU_BUFFERS, but then we still keep the test+jz
unconditionally. 

If we really want to super-optimise the no-mitigations-needed case,
shouldn't we want to avoid the conditional in the asm if it never
actually leads to a flush?

On the other hand, if we don't mind a couple of extra instructions,
shouldn't we be fine with just having the whole asm code based solely
on VMX_RUN_CLEAR_CPU_BUFFERS and leaving the
X86_FEATURE_CLEAR_CPU_BUF_VM to the C code?

I guess the issue is that in the latter case we'd be back to having
unnecessary inconsistency with AMD code while in the former case... well
that would just be really annoying asm code - am I on the right
wavelength there? So I'm not necessarily asking for changes here, just
probing in case it prompts any interesting insights on your side.

(Also, maybe this test+jz has a similar cost to the nops that the
"alternative" would inject anyway...?)

