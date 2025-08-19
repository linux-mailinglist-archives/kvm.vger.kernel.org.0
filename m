Return-Path: <kvm+bounces-54995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1DDB2C7EB
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53DE918901E2
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 15:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E8C284B3F;
	Tue, 19 Aug 2025 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z4i4Z2Of"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CC6283FF1
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 15:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755615602; cv=none; b=s7sHs0uXJ4M8V+uEQ6L5nnob71ncxwrfl/7trwwQ8Q/EhJMQ6m8p69SXj/pS7Tg6hJAIhIOX85fuUP+ogs8myLayrd0zMfA0Y2VUV+YRpUCjMjCecFXUsGAY/6B83IdQovVHQB7tg8j0WE7+z9KUAVxBhGag2m1qIyWch6UkFIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755615602; c=relaxed/simple;
	bh=SnGgxXaySBVf0ouOWldkQtPF1ohNnFw8E0EzCWXBf2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hTuK8wg8mXOKfgKiH5tY5s6qaf6luGvZp7p2oDArrjwG1U2r0OWtkVsgsLnUUJVVOaZykvu/Wq3hsuhq3IIctGdCNfEya/NmwWcT9ZRg59FAJl9MaR6xaowKn6UyDWXYGvqHa0Fs/Ue5vnHn9vANIrv+6Oz9S5MTWkDOyUaIkZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z4i4Z2Of; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e8fc814so4936220b3a.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 08:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755615600; x=1756220400; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nOA3VWiRXTRFb3ikYxNLyhF0lHrdT51UXHnf+7+tL5M=;
        b=Z4i4Z2OfHxkVNsG3vgtvrLR+0NxmJv1tG4WJ1AFrPxG92NW0hhvfCUCeMjnHuyoxkw
         X1nNpRrPR4tzPKad0WlMUTxhTX0fUFb8aYlXymoH7eQ4Y4txVpzvOuoeN7NbCjo1xvPj
         HhOYYzBx36vwW0B7pWA3f2cxlmKCup6M6KJaT+O0EuMxWq0o81VJToVv5gzy6SJBFbEz
         kcc3msclKsjn8GeL/KC9Z+6B/o9qoPioWV2+EJEVHGaqGTcCb/ilS2cTdY+4RUDdIPPc
         0wDqIxA8W+/S1KG2wgimxLXJREHrv9SulBM7kvwsN8dE+MfBo95UZvOdm67R9NnMOCxM
         Vp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755615600; x=1756220400;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nOA3VWiRXTRFb3ikYxNLyhF0lHrdT51UXHnf+7+tL5M=;
        b=AEjP5u6dcdjzHPJ5ohKlZ6pJfABoZj3WpMtR5uzlTIvkLXDla+ym3jiadY5tiXZ8Mz
         wXIY3Qp2RRynwo00V2aur6U0AK3bogYnMH03aYh14Ui6RXlP6KeXRYQlFWUaT4zt9bXG
         G0/fAnkdaKRawR7ttYHP9Z8I9wYeI4K2a/iEWCj71XKn4KyKgvhMQv4sTw+R8p9LS9Sk
         6fkYKFncYJvi932k3Ej6MGjJ64+OK/54UCjt02GjWdu5I6gNCWMkGqT0VBoWOl4nrat4
         Sc0HCUVg6TGB26fsH5QQhDz1vINWE29nEI6Xho+svqry9qhvtswYiw2bfKUWpID+PtC7
         jvXQ==
X-Gm-Message-State: AOJu0YyU8DYItVf6IGRR6kDIVPXjWmC0rao1gSjP+swK9z+VGiEaEpx0
	s1uO/ONYFwAunpnLWPoui5KMkNrz8lz4Tbns0UFNF7+QrDxlXfspgzUx+hV5TNeqdue3WU9BT5/
	wuKffAw==
X-Google-Smtp-Source: AGHT+IHWgsW7BLU4yfKNFvNuFS6vQtLdIkoeAOMwUmuR/B56AIyXWIvzAftBMXYGfqkJrqaCeZANFCwLuLA=
X-Received: from pfnn21.prod.google.com ([2002:a05:6a00:2b95:b0:76e:2713:9ad0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1a8a:b0:76b:fd9d:853d
 with SMTP id d2e1a72fcca58-76e81121787mr3353528b3a.14.1755615600091; Tue, 19
 Aug 2025 08:00:00 -0700 (PDT)
Date: Tue, 19 Aug 2025 07:59:58 -0700
In-Reply-To: <20250807063733.6943-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807063733.6943-1-ubizjak@gmail.com>
Message-ID: <aKSRbjgtp7Nk8-sb@google.com>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize SPEC_CTRL handling in __vmx_vcpu_run()
From: Sean Christopherson <seanjc@google.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 07, 2025, Uros Bizjak wrote:
> Use memory operand in CMP instruction to avoid usage of a
> temporary register. Use %eax register to hold VMX_spec_ctrl
> and use it directly in the follow-up WRMSR.
> 
> The new code saves a few bytes by removing two MOV insns, from:
> 
>   2d:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
>   32:	8b bf 48 18 00 00    	mov    0x1848(%rdi),%edi
>   38:	65 8b 35 00 00 00 00 	mov    %gs:0x0(%rip),%esi
>   3f:	39 fe                	cmp    %edi,%esi
>   41:	74 0b                	je     4e <...>
>   43:	b9 48 00 00 00       	mov    $0x48,%ecx
>   48:	31 d2                	xor    %edx,%edx
>   4a:	89 f8                	mov    %edi,%eax
>   4c:	0f 30                	wrmsr
> 
> to:
> 
>   2d:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
>   32:	8b 87 48 18 00 00    	mov    0x1848(%rdi),%eax
>   38:	65 3b 05 00 00 00 00 	cmp    %gs:0x0(%rip),%eax
>   3f:	74 09                	je     4a <...>
>   41:	b9 48 00 00 00       	mov    $0x48,%ecx
>   46:	31 d2                	xor    %edx,%edx
>   48:	0f 30                	wrmsr
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 0a6cf5bff2aa..c65de5de92ab 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -118,13 +118,11 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	 * and vmentry.
>  	 */
>  	mov 2*WORD_SIZE(%_ASM_SP), %_ASM_DI
> -	movl VMX_spec_ctrl(%_ASM_DI), %edi
> -	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
> -	cmp %edi, %esi
> +	movl VMX_spec_ctrl(%_ASM_DI), %eax
> +	cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax

Huh.  There's a pre-existing bug lurking here, and in the SVM code.  SPEC_CTRL
is an MSR, i.e. a 64-bit value, but the assembly code assumes bits 63:32 are always
zero.

So, while this patch looks good, I'm leaning toward skipping it and going straight
to a fix.

>  	je .Lspec_ctrl_done
>  	mov $MSR_IA32_SPEC_CTRL, %ecx
>  	xor %edx, %edx
> -	mov %edi, %eax
>  	wrmsr
>  
>  .Lspec_ctrl_done:
> -- 
> 2.50.1
> 

