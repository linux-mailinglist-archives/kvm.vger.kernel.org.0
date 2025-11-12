Return-Path: <kvm+bounces-62949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E2538C54742
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 21:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B8390343A87
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 20:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4638C2D2381;
	Wed, 12 Nov 2025 20:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y6zEPjHL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F06299927
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 20:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762979440; cv=none; b=WjGfntWa9olqSTx+E0Vr2KC7UiTBL3ipwy2tFJrvoIza/nj4aTL4gxXtQtRwAkX1AJwEguVgOVQxvMOoEuGnMlVGlga3Nlot1NiQgBMjelPR/LNTVP1mCwXlgyMMSwvHTWWq6xW8S5/uIkF3H82Z4lYRwe86Nf6qCHpwBJgOJ5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762979440; c=relaxed/simple;
	bh=pP25ULvqx4PA1SCsXvq9hbO/tKY4zzuP1G83Y3q2i8k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RnN8IxpZ/AAE8EG5RaCEeMYH0/MSoOMOmJZOJybYjIjCWSa5SuNG5rtfyD790t3jkFBzzLw/fLTWY/zhF+c6W4D9zyAJZfMtfZ5jJZ60C1bB0DOr1mWqVa+h+P469EnSCJO8XbXa//s0R0zWmG5I+s6fUirKQO8j0DXaxxR8M5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y6zEPjHL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b609c0f6522so129879a12.3
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 12:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762979438; x=1763584238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L3dNSj7TiHzSrBzKacws1VRc8Up4SYRhBM3gT9JOJwI=;
        b=y6zEPjHL+zBXXVQsZ5BUO7efB1QOsJa08mAvWFEhu1znVuf8Hjfaj3oWk/Eh6x4akP
         umKUNVKZOafUZyJeVID2f7L28CLsOMhSpQqnhG6a3cXWH43JGlL+eVNi4XQBbbO0IaNh
         sKCMbXSLzHYUmykZNzG0dpC0JqFkylww2epBrE8D8JoCsPAkOdVOum8vaFTtM/w5DeR4
         axPqGYfQGyARFdpSJLejL5r99u4uegP/TI0hmXTJif/40LY93hLwD+FZ0ybqfolvNeYW
         p/MJ/nVX4nWtSCzjc7UoZJVeUCgEpy0jPRvQhe7emCG6JRlI9gxh4gIF7MbVkYv/QjdI
         TUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762979438; x=1763584238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L3dNSj7TiHzSrBzKacws1VRc8Up4SYRhBM3gT9JOJwI=;
        b=eMey6IcJ5Kr97Lgxus9UKajw2dT/HN7M8BykXbUdHJZczHxcp3/tcgtu8ieBGsgFte
         6BEDC8GlRicU4OUcNCDKDhHkd74ESEfcJ9cLGQ4CHyiEeWqSGbJ/4UdvYSNHCwtSk9Ag
         3WuK9k21Wo58IAES7h+MXm0GphNuxIGotkzmvgcsvNAy17nBi/mNHYWvVVeahhOodgJc
         A5xK5a3NmdfU7ra8jprYpxJaFWoM4sCXKCoOt4vLEnbsiuqcdAx+R5yVhnvgGPq/aMCH
         Dx/NMNmo4mLMiO/zSDPdSY23EoO4gaQkpO6P06TTjq6gEyC3fce2gnw0Ap/lGUBR3P44
         dW/A==
X-Forwarded-Encrypted: i=1; AJvYcCVQ9KkEL6lLw4NysTeYfd36zU513OP0R/dINnJmcFxoUEg00frg+zdhFizZeDFw2ZQBnlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1vJYcCgrNyuSVWhnJKx5IcSgNiqvw91wU9qEr5y+479Qxa9wZ
	rbTlBaH5ufQnmR9CBxVKluriGvU9VrPwJzgbFrj0QZ/eduNgJ4y7B9iTRJKDTMtR2hruQTyovMy
	GS9Ax4Q==
X-Google-Smtp-Source: AGHT+IFHpp7bNY375rv69dfJVKRP14JO7bDZ6Qzp4pJXKIQ9Tx1TN/S1z7ykvM7IVkTTEWv8EepdbXFLQ7U=
X-Received: from pgbcw3.prod.google.com ([2002:a05:6a02:4283:b0:bac:a20:5eec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d09:b0:346:331:97e4
 with SMTP id adf61e73a8af0-3590bd0b3e8mr5777964637.56.1762979438181; Wed, 12
 Nov 2025 12:30:38 -0800 (PST)
Date: Wed, 12 Nov 2025 12:30:36 -0800
In-Reply-To: <20251112183836.GBaRTULLaMWA5hkfT9@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-5-seanjc@google.com>
 <20251112164144.GAaRS4yKgF0gQrLSnR@fat_crate.local> <aRTAlEaq-bI5AMFA@google.com>
 <20251112183836.GBaRTULLaMWA5hkfT9@fat_crate.local>
Message-ID: <aRTubGCENf2oypeL@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 12, 2025, Borislav Petkov wrote:
> On Wed, Nov 12, 2025 at 09:15:00AM -0800, Sean Christopherson wrote:
> > On Wed, Nov 12, 2025, Borislav Petkov wrote:
> > > So this VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO bit gets set here:
> > > 
> > >         if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_MMIO) &&
> > >             kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> > >                 flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
> > > 
> > > So how static and/or dynamic is this?
> > 
> > kvm_vcpu_can_access_host_mmio() is very dynamic.  It can be different between
> > vCPUs in a VM, and can even change on back-to-back runs of the same vCPU.
> 
> Hmm, strange. Because looking at those things there:
> 
> root->has_mapped_host_mmio and vcpu->kvm->arch.has_mapped_host_mmio
> 
> they both read like something that a guest would set up once and that's it.
> But what do I know...

They're set based on what memory is mapped into the KVM-controlled page tables,
e.g. into the EPT/NPT tables, that will be used by the vCPU for that VM-Enter.
root->has_mapped_host_mmio is per page table.  vcpu->kvm->arch.has_mapped_host_mmio
exists because of nastiness related to shadow paging; for all intents and purposes,
I would just mentally ignore that one.

> > > IOW, can you stick this into a simple variable which is unconditionally
> > > updated and you can use it in X86_FEATURE_CLEAR_CPU_BUF_MMIO case and
> > > otherwise it simply remains unused?
> > 
> > Can you elaborate?  I don't think I follow what you're suggesting.
> 
> So I was thinking if you could set a per-guest variable in
> C - vmx_per_guest_clear_per_mmio or so and then test it in asm:
> 
> 		testb $1,vmx_per_guest_clear_per_mmio(%rip)
> 		jz .Lskip_clear_cpu_buffers;
> 		CLEAR_CPU_BUFFERS_SEQ;
> 
> .Lskip_clear_cpu_buffers:
> 
> gcc -O3 suggests also
> 
> 		cmpb   $0x0,vmx_per_guest_clear_per_mmio(%rip)
> 
> which is the same insn size...
> 
> The idea is to get rid of this first asm stashing things and it'll be a bit
> more robust, I'd say.

VMX "needs" to abuse RFLAGS no matter what, because RFLAGS is the only register
that's available at the time of VMLAUNCH/VMRESUME.  On Intel, only RSP and
RFLAGS are context switched via the VMCS, all other GPRs need to be context
switch by software.  Which is why I didn't balk at Pawan's idea to use RFLAGS.ZF
to track whether or not a VERW for MMIO is needed.

Hmm, actually, @flags is already on the stack because it's needed at VM-Exit.
Using EBX was a holdover from the conversion from inline asm to "proper" asm,
e.g. from commit 77df549559db ("KVM: VMX: Pass @launched to the vCPU-run asm via
standard ABI regs").

Oooh, and if we stop using bt+RFLAGS.CF, then we drop the annoying SHIFT definitions
in arch/x86/kvm/vmx/run_flags.h.

Very lightly tested at this point, but I think this can all be simplified to

	/*
	 * Note, ALTERNATIVE_2 works in reverse order.  If CLEAR_CPU_BUF_VM is
	 * enabled, do VERW unconditionally.  If CPU_BUF_VM_MMIO is enabled,
	 * check @flags to see if the vCPU has access to host MMIO, and do VERW
	 * if so.  Else, do nothing (no mitigations needed/enabled).
	 */
	ALTERNATIVE_2 "",									  \
		      __stringify(testl $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, WORD_SIZE(%_ASM_SP); \
				  jz .Lskip_clear_cpu_buffers;					  \
				  VERW;								  \
				  .Lskip_clear_cpu_buffers:),					  \
		      X86_FEATURE_CLEAR_CPU_BUF_VM_MMIO,					  \
		      __stringify(VERW), X86_FEATURE_CLEAR_CPU_BUF_VM

	/* Check if vmlaunch or vmresume is needed */
	testl $VMX_RUN_VMRESUME, WORD_SIZE(%_ASM_SP)
	jz .Lvmlaunch


> And you don't rely on registers...
> 
> and when I say that, I now realize this is 32-bit too and you don't want to
> touch regs - that's why you're stashing it - and there's no rip-relative on
> 32-bit...
> 
> I dunno - it might get hairy but I would still opt for a different solution
> instead of this fragile stashing in ZF. You could do a function which pushes
> and pops a scratch register where you put the value, i.e., you could do
> 
> 	push %reg
> 	mov var, %reg
> 	test or cmp ...
> 	...
> 	jz skip...
> skip:
> 	pop %reg
> 
> It is still all together in one place instead of spreading it around like
> that.

FWIW, all GPRs except RSP are off limits.  But as above, getting at @flags via
RSP is trivial.

