Return-Path: <kvm+bounces-63636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C1EF8C6C216
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:29:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6C150362A6C
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8411A1FAC4B;
	Wed, 19 Nov 2025 00:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wudd7gdT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3590B13D891
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 00:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763512159; cv=none; b=Zd9jQA/fZpKRMF29eo8vHIyKCS/Ch18QutBOdkIWTO5vCQPuLmWfK2io6EYzlkBH8S6+Mz14ufa/ujfQCi5qbfX5wnt1JP9RfQQq42J472tgfMK6QiYVdThFXBKAciDk/wUVoPY1Y8rI5T9B2WG9xyaN0JdNKjnunBNaqy09dDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763512159; c=relaxed/simple;
	bh=GOsmmpbQvkxvNzRsT4DRzt9eUxHuOJWYkO/ORtm6Md4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aZucijZWmqe4X15IgAOH4N6+wpeCDjp/ZcKRzFBJHJjvdXbwoc8lsGWGpSK0kH68IjSgiaOlyjD1HjqDyOASSXPVqEYzjt/KwycSAYRBLjuMxnLXqX1IqRs9RfLuRzpk9y+nUPLXHqnCLtpRuB82wsx19JlUmjuy69owHFB2YMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wudd7gdT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297fbfb4e53so109032745ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 16:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763512157; x=1764116957; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=90GyFqjdjkWG1RZ/h2NKaiAnVrem5rhVdwRm46kbgOo=;
        b=wudd7gdTr4EyR9OUZnmlhYw5BSFEI9Iaa9+W9pR/jKJGmUiduC/To/hb3tiVblNQGl
         KoxayoaHM/cNhmfT+tsXPnElNw1Kayyu4VA4l49ECQOsjlWdpAlhMtI6ttdYgW+wmwMX
         MtYbWIVoXn7+rTKgIhfntGPhbRbaQPCzFg0xIochwNJAPe7DXtGbQiVac0aUKTOKsWu/
         9tdIuvZQOo4g1U8eN+RACo44dgPpzDzdtrvD1yKT807S8dDCcUmrfPmp5dGwXoFRf3Xc
         /FBzeGu0tIVbdpT8linQd7/bi6pbQ6K25Q8zG7QcZiMBZbGyvish5cTITYghWUcn4D78
         OtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763512157; x=1764116957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=90GyFqjdjkWG1RZ/h2NKaiAnVrem5rhVdwRm46kbgOo=;
        b=u2LoJJNU1arA9hdxEpDlfrVRwXF7AMqVb/XNSkhfLLPOlK2knYkkTp2Vj6Qb1kvIw6
         H/4GWdCOhU1gatCwHoRsV1O0S5rspHvvGpoOQ2BS1J/3g3oHY/RhDbbHF0UivCNzltlj
         JNUoRFjCrQ1KoCZZY675XL5p4cx9AJjy3owADpSaZsFUGALiF6Qor3/Sz0/5kNulZ6Ho
         Zc+6Uy0jJY+a7vEbN3nDBnrPsGHsZ7WaajcYFXvHwjPNWecSuVOij/1/nVTkxRRrOV1U
         34zqPvYIqpJGmTTbgaoIuPDtKdm6XE2mu9gr0Xuj0gSADTIgNvRXDMUicjnl/Qg2T9gz
         lk+A==
X-Forwarded-Encrypted: i=1; AJvYcCW1SnXJJVO+cUkyBbC9uxeBjan8aioIckoeWX1EKrNnP6TfRgj4t6OTQe1aG3VMspGGxlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAVxdQgaPPGRtI4noGu6j/86fVQh2sk+AJn0eqtyHGiUHUQl4e
	a4pBtreuZR0xXkUnpms/V2E5STLUeeKPUudLiBoCSvJ5pdtRmHcox/wGyHq4qmWrXezlEH8xzy6
	pkFelgQ==
X-Google-Smtp-Source: AGHT+IFcdIYtSSkL2W7tbnvzMa526xpaJ/Ni9UoBXyUqC2yzm0zUicNrdv2dpHhb4isgp3pXcYnz0x3JO6M=
X-Received: from plbi1.prod.google.com ([2002:a17:903:20c1:b0:297:e887:3f69])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b50:b0:299:fc47:d7d7
 with SMTP id d9443c01a7336-299fc47d9a5mr46275695ad.3.1763512157494; Tue, 18
 Nov 2025 16:29:17 -0800 (PST)
Date: Tue, 18 Nov 2025 16:29:16 -0800
In-Reply-To: <6908a285-b7b7-457a-baaf-fd01c55fe571@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com> <20251113233746.1703361-2-seanjc@google.com>
 <6908a285-b7b7-457a-baaf-fd01c55fe571@gmail.com>
Message-ID: <aR0PXEyP_OKuiQOO@google.com>
Subject: Re: [PATCH v5 1/9] KVM: VMX: Use on-stack copy of @flags in __vmx_vcpu_run()
From: Sean Christopherson <seanjc@google.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 14, 2025, Uros Bizjak wrote:
> On 11/14/25 00:37, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 574159a84ee9..93cf2ca7919a 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -92,7 +92,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >   	/* Save @vmx for SPEC_CTRL handling */
> >   	push %_ASM_ARG1
> > -	/* Save @flags for SPEC_CTRL handling */
> > +	/* Save @flags (used for VMLAUNCH vs. VMRESUME and mitigations). */
> >   	push %_ASM_ARG3
> >   	/*
> > @@ -101,9 +101,6 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >   	 */
> >   	push %_ASM_ARG2
> > -	/* Copy @flags to EBX, _ASM_ARG3 is volatile. */
> > -	mov %_ASM_ARG3L, %ebx
> > -
> >   	lea (%_ASM_SP), %_ASM_ARG2
> >   	call vmx_update_host_rsp
> > @@ -147,9 +144,6 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >   	/* Load @regs to RAX. */
> >   	mov (%_ASM_SP), %_ASM_AX
> > -	/* Check if vmlaunch or vmresume is needed */
> > -	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
> > -
> >   	/* Load guest registers.  Don't clobber flags. */
> >   	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
> >   	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
> > @@ -173,8 +167,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >   	/* Clobbers EFLAGS.ZF */
> >   	CLEAR_CPU_BUFFERS
> > -	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
> > -	jnc .Lvmlaunch
> > +	/* Check @flags to see if vmlaunch or vmresume is needed. */
> > +	testl $VMX_RUN_VMRESUME, WORD_SIZE(%_ASM_SP)
> > +	jz .Lvmlaunch
> 
> 
> You could use TESTB instead of TESTL in the above code to save 3 bytes
> of code and some memory bandwidth.
> 
> Assembler will report unwanted truncation if VMX_RUN_VRESUME ever
> becomes larger than 255.

Unfortunately, the warning with gcc isn't escalated to an error with -Werror,
e.g. with KVM_WERROR=y.  And AFAICT clang's assembler doesn't warn at all and
happily generates garbage.  E.g. with VMX_RUN_VMRESUME relocated to bit 10, clang
generates this without a warning:

 33c:   f6 44 24 08 00          testb  $0x0,0x8(%rsp)
 341:   74 08                   je     34b <__vmx_vcpu_run+0x9b>
 343:   0f 01 c3                vmresume 

versus the expected:

 33c:   f7 44 24 08 00 04 00    testl  $0x400,0x8(%rsp)
 343:   00 
 344:   74 08                   je     34e <__vmx_vcpu_run+0x9e>
 346:   0f 01 c3                vmresume 

So for now at least, I'll stick with testl.

