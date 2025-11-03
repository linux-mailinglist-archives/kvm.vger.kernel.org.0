Return-Path: <kvm+bounces-61815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EE252C2B281
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 11:53:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 543EA4EF9CB
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 10:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11722FFF9B;
	Mon,  3 Nov 2025 10:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xzUAAwde"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24239189F43
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 10:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762167109; cv=none; b=riTEV0h3tCbutmdm0oa5KhKCUf3TOZeaR45TONJAXZuj+15a7QEYZY4ZAB6tTjCucL31qpibwV7g5qTak5arBi5jOndnCEjfmj5HKRy0gM1lvz6BffdZf7mlXVktbGfMLFnF3HLF4kYxC8I2FeMNTRsVbSo12u/QGO2pnyfDwYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762167109; c=relaxed/simple;
	bh=YKUPKJACp9MBEQLTEhMxkc0Zxpn6YWjSxFnJb81yljw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eE6OHJ3gD6nFE/6JqjZ7e85u72pzSvCYw7dYldIFQYZhmXKiBbHO8Wsgbgmg4ZFKWA+VcdYsz5aDJmhOVJgVUpWrA32Yn7c9XQjjnk/meUiYKb7P9nMVlxwocEBxy1B5chhs5doRXKObLLT4wmIv/Orka7E5LIXiRhfxrI39SV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xzUAAwde; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4770c37331fso30891285e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 02:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762167105; x=1762771905; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7g/6qEaP3lVvaAUqgLfdxkWNvLvmTkjz5emWRXoiAI=;
        b=xzUAAwdeWgCalm9sgHjaY8aMZj5f1CVB75tOyYHaeB4Gbtpq3BpYIBtd+XP8zfNS0s
         iEFZPJV4H48/Lhgc6jgu5heQ4WYW+PVLYutUIQng9lSqjDVYD5jpJdBeypUzloUIxkwV
         ZKPLFoJt7e5m/jX99AFnktsii8EHxiG5kvnZkFRBpN5qe62L7vjuc2X2xxTVLPL8cud/
         Sqp+J85Wt8rJqrEvDVgW5nlrhaCPyXm+iZ22enWEqEJ0WkZXAcaaHo0D8w0Trnk5SGHz
         jIEof1P7v5b1sIxZVpyoG8/hgTj1X0gh7NkOPxfRtc1XVwh9KvI95wJcoRLUW2zY+MDQ
         PYbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762167105; x=1762771905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7g/6qEaP3lVvaAUqgLfdxkWNvLvmTkjz5emWRXoiAI=;
        b=ZWeWzPJbDpcB8in+NNGuEhssLtZMbXCKtMm7K+VptWKYSBt/v8Vbty5F2CDAPMG0Vw
         pOyHxm423rBV7d73va07kg732aPZMtSrj1PPWNwsUkKQevRbG9hm3tvKFB9DGFI2pFzH
         3J048EVjiVs+N4mUHc/5VHkQ2UnJPsaezwhTmTshDS0NgZNZNX9TWonHrLrj5025iK8O
         AemGME0qO9G4bvMPj6GM0AW5Dy9oMpsXMk3m6LPHETw4veA/FWlgnZpY6OS/pjBw4uJl
         vJgQVTxsNHc3+MNsFfo3qDAQwj3LdLAyCvRp1pj6o5Vr6MqDomk1GH7sdwa6fVgS5gVe
         7pRg==
X-Forwarded-Encrypted: i=1; AJvYcCUANXU7hiGeoFopp+NRt1Ek5owpl6OlSWzPjnBt4TeS6YSc5fqkUs228UNnWoFZXriHqvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YziCbkggFkzm1Uopow6fWeYoWEjCw5IDA4s1QVZluvjg0suQn2W
	3qTX1hmkGDIRsL2gjJpitg6KkhyTM5kw54nn0FjDmB3agIcK0EKZqgk9T204B7euGxoXC5ba4Pb
	R55On54ZDQxEXaA==
X-Google-Smtp-Source: AGHT+IEw5fnIKwkSUZmAUqO9mhNp8ygq/NsEP3OfpwX7swAOb/CiCgrOmNFr4ws8XArtH5CoBtZ78Zworjy3jA==
X-Received: from wrbeb17.prod.google.com ([2002:a05:6000:2011:b0:429:c7ee:6aac])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2601:b0:429:d41b:9fe5 with SMTP id ffacd0b85a97d-429d41ba1f5mr1861037f8f.24.1762167105379;
 Mon, 03 Nov 2025 02:51:45 -0800 (PST)
Date: Mon, 03 Nov 2025 10:51:44 +0000
In-Reply-To: <aQUtwsfxEsUi4us0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com> <20251031003040.3491385-5-seanjc@google.com>
 <DDWIDCO0UKMD.2C46H6XQO1NXK@google.com> <aQUtwsfxEsUi4us0@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDZ03S9DS8TP.174VN17SHX6NH@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri Oct 31, 2025 at 9:44 PM UTC, Sean Christopherson wrote:
> On Fri, Oct 31, 2025, Brendan Jackman wrote:
>> On Fri Oct 31, 2025 at 12:30 AM UTC, Sean Christopherson wrote:
>> > Rework the handling of the MMIO Stale Data mitigation to clear CPU buffers
>> > immediately prior to VM-Enter, i.e. in the same location that KVM emits a
>> > VERW for unconditional (at runtime) clearing.  Co-locating the code and
>> > using a single ALTERNATIVES_2 makes it more obvious how VMX mitigates the
>> > various vulnerabilities.
>> >
>> > Deliberately order the alternatives as:
>> >
>> >  0. Do nothing
>> >  1. Clear if vCPU can access MMIO
>> >  2. Clear always
>> >
>> > since the last alternative wins in ALTERNATIVES_2(), i.e. so that KVM will
>> > honor the strictest mitigation (always clear CPU buffers) if multiple
>> > mitigations are selected.  E.g. even if the kernel chooses to mitigate
>> > MMIO Stale Data via X86_FEATURE_CLEAR_CPU_BUF_MMIO, some other mitigation
>> > may enable X86_FEATURE_CLEAR_CPU_BUF_VM, and that other thing needs to win.
>> >
>> > Note, decoupling the MMIO mitigation from the L1TF mitigation also fixes
>> > a mostly-benign flaw where KVM wouldn't do any clearing/flushing if the
>> > L1TF mitigation is configured to conditionally flush the L1D, and the MMIO
>> > mitigation but not any other "clear CPU buffers" mitigation is enabled.
>> > For that specific scenario, KVM would skip clearing CPU buffers for the
>> > MMIO mitigation even though the kernel requested a clear on every VM-Enter.
>> >
>> > Note #2, the flaw goes back to the introduction of the MDS mitigation.  The
>> > MDS mitigation was inadvertently fixed by commit 43fb862de8f6 ("KVM/VMX:
>> > Move VERW closer to VMentry for MDS mitigation"), but previous kernels
>> > that flush CPU buffers in vmx_vcpu_enter_exit() are affected (though it's
>> > unlikely the flaw is meaningfully exploitable even older kernels).
>> >
>> > Fixes: 650b68a0622f ("x86/kvm/vmx: Add MDS protection when L1D Flush is not active")
>> > Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>> > ---
>> >  arch/x86/kvm/vmx/vmenter.S | 14 +++++++++++++-
>> >  arch/x86/kvm/vmx/vmx.c     | 13 -------------
>> >  2 files changed, 13 insertions(+), 14 deletions(-)
>> >
>> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
>> > index 1f99a98a16a2..61a809790a58 100644
>> > --- a/arch/x86/kvm/vmx/vmenter.S
>> > +++ b/arch/x86/kvm/vmx/vmenter.S
>> > @@ -71,6 +71,7 @@
>> >   * @regs:	unsigned long * (to guest registers)
>> >   * @flags:	VMX_RUN_VMRESUME:	use VMRESUME instead of VMLAUNCH
>> >   *		VMX_RUN_SAVE_SPEC_CTRL: save guest SPEC_CTRL into vmx->spec_ctrl
>> > + *		VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO: vCPU can access host MMIO
>> >   *
>> >   * Returns:
>> >   *	0 on VM-Exit, 1 on VM-Fail
>> > @@ -137,6 +138,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>> >  	/* Load @regs to RAX. */
>> >  	mov (%_ASM_SP), %_ASM_AX
>> >  
>> > +	/* Stash "clear for MMIO" in EFLAGS.ZF (used below). */
>> > +	ALTERNATIVE_2 "",								\
>> > +		      __stringify(test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx), 	\
>> > +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,					\
>> > +		      "", X86_FEATURE_CLEAR_CPU_BUF_VM
>> 
>> Ah, so this ALTERNATIVE_2 (instead of just an ALTERNATIVE that checks
>> CLEAR_CPU_BUF_MMIO) is really about avoiding the flags needing to be
>> mutually exclusive?
>
> Yeah, more or less.  More specifically, I want to keep the X vs. Y logic in one
> place (well, two if you count both ALTERNATIVE_2 flows), so that in generaly,
> from KVM's perspective, the mitigations are handled as independent things.  E.g.
> even if CLEAR_CPU_BUF_VM and CLEAR_CPU_BUF_MMIO are mutually exclusive within
> the kernel (and it's not clear to me that that's 100% guaranteed), I want to
> limit how much of KVM assumes they are exclusive.  Partly to avoid "oops, we
> forgot to mitigate that thing you care about", partly so that reading code like
> the setting of VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO doesn't require understanding
> the relationship between CLEAR_CPU_BUF_VM and CLEAR_CPU_BUF_MMIO.

Yeah, this makes sense, if we can avoid creating any unnecessary
and awkward-to-enforce invariants that seems like a win.

>> if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_MMIO) && 
>>     !cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_VM))
>> 	test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx
>> 
>> ... right? This is a good idea but I think it warrants a comment to
>> capture the intent, without having the commit message in short-term
>> memory I'd have struggled with this code, I think.
>> 
>> >  	/* Check if vmlaunch or vmresume is needed */
>> >  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
>> >  
>> > @@ -161,7 +168,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
>> >  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>> >  
>> >  	/* Clobbers EFLAGS.ZF */
>> > -	VM_CLEAR_CPU_BUFFERS
>> > +	ALTERNATIVE_2 "",							\
>> > +		      __stringify(jz .Lskip_clear_cpu_buffers;			\
>> 
>> Maybe I'm just an asm noob 
>
> Nah, all of this is definitely playing on hard mode.  I'm just thankful we don't
> have to deal with the horrors of KVM doing all of this in inline asm.  :-D
>
>> I was very impressed by this trick of using CF and ZF together like this!)
>> but I think it's helpful to have the comment like the jnc has below, and
>> Pawan had in his version, to really make the test->jz dependency obvious,
>> since the two instructions are quite far apart.
>> 
>> 
>> > +				  CLEAR_CPU_BUFFERS_SEQ;			\
>> > +				  .Lskip_clear_cpu_buffers:),			\
>> > +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,				\
>> > +		      __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
>> 
>> Sorry I'm really nitpicking but I think it's justified for asm
>> readability...
>> 
>> It's a bit unfortunate that one branch says
>> CLEAR_CPU_BUFFERS_SEQ and the other says __CLEAR_CPU_BUFFERS. With the
>> current code I think it would be more readable to jut have
>> __stringify(CLEAR_CPU_BUFFERS_SEQ) in the CLEAR_CPU_BUF_VM case, then
>> you don't have to mentally expand the macro to see how the two branches
>> actually differ.
>
> No preference here (assuming I understand what you're asking).
>
> Is this better?
>
> 	/*
> 	 * Note, this sequence consumes *and* clobbers EFLAGS.ZF.  The MMIO
> 	 * mitigations uses ZF to track whether or not the vCPU has access to
> 	 * host MMIO (see above), and VERW (the instruction microcode hijacks
> 	 * to clear CPU buffers) writes ZF.
> 	 */
> 	ALTERNATIVE_2 "",							\
> 		      __stringify(jz .Lskip_clear_cpu_buffers;			\
> 				  CLEAR_CPU_BUFFERS_SEQ;			\
> 				  .Lskip_clear_cpu_buffers:),			\
> 		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,				\
> 		      __stringify(CLEAR_CPU_BUFFERS_SEQ), X86_FEATURE_CLEAR_CPU_BUF_VM

Yep that looks good to me.

