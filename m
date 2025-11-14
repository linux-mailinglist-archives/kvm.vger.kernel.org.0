Return-Path: <kvm+bounces-63253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 39822C5F449
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B81EE4E1D6D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53892EDD6F;
	Fri, 14 Nov 2025 20:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ebz7eEh6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D15A23A99E
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763152982; cv=none; b=Db/vKGbx3MAcb4YxafvTZLiMRTw8V2qLlP57XMqUkScqLnfOOAj6g2mBXJKW2SeKckp6KTZYbkzJrgeKdJmuzQZmDb1/inh835O35hnVQQkZEkIK/9F+pkzX1qxI81kwQZIhYXyUi1Xoaipf9eMK8k8wc6e2NYihEZG35uRfusA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763152982; c=relaxed/simple;
	bh=73YX+TJiXw3/64X8xc4wU+Tg0llg2CNYH3MCe6o6Wps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rnraPclQMnoTTYpgC6bm9RkorkUUyBFkQ2YuKxaCHmr9dbYtasUoHJoxaNzp76D+WaEwKwlA+sFycyuFMKsKsdnGLu+MOhSN4M4sj+fkMCPuG3b9wjcUcoLd/D0SYVr6T9XKBONZDbCXfGwgdIJOBUTulmDSjOqLp2MS11B1OQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ebz7eEh6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297fbfb4e53so43482395ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763152980; x=1763757780; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=avXR1haW3d+/eu84aEgpOYo3cvKspQpV4/WrHTrZdLw=;
        b=ebz7eEh6v1ONIiGwutz4ew3LcgdqBE5aH/ST9J3fkNEsVvm1MGORNWfs9fILkAg/1E
         4sXJqJPLcZWvrEc6h+ATJDXJpJuyV7k1YP1neTl+O8xRbx5MM3Hgg8a4FInF5hMhCr5P
         5w+goNTeWHoeDGSFxc1w7K0PAsgW9R9vutcP5nWAoIm5LKfTr2uYXYBPR8vfR5odjwbI
         muji7/uUFjxvLlH69T+ATWCed7Enl/ixURbIGlvyauqq1Co96FPEBuxK4cZrtcP+jTs1
         bnodSZWoAQm3m/gzs9OK1C5nccJ3B+gexJgQXDXVIepVpDPgX5/F9BnPfMy1QO42KPT5
         UZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763152980; x=1763757780;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avXR1haW3d+/eu84aEgpOYo3cvKspQpV4/WrHTrZdLw=;
        b=ZGWmuPe2RH+RnHmdO3EcfNVuy5665pGFMKWwZhWfcoW5XcPbEjrGLP5XVOO7iPYu8t
         IuYSHou6PfA4luvONL9lkWdaudlA57gdbjyzXveGO1pzIKcDjvl20GBcUYU1C2BRoooo
         nleiPl31bRFMAxJvxH94K8aZwJb6Xr3H2EWHWGnCFoJfzAjJERJZr9zqqNNtZ0wBNqwN
         vzGx2sVPSQRYTJ7CIuMYnCP+niiKleGt89y3tZBColQfyi6N2bBun8uROxYG1740TEXE
         XyKIk8CIASkS9WhsWDQurBkjCGe792cyS+4QklJugf76NhrEDEb1DaauYVF6eBANOpHh
         22mA==
X-Gm-Message-State: AOJu0Yyl8wHEm0fNSmABYFjJTw3qnmMyRsiRcHrzjRVhsO2pzoUie3OH
	PoPSQ2xMRwe31VoFStHK5JvoxEWmubsp6er6esykcBVTRCCwYrtMJCK2AKVy/M0hER4dfnnjeII
	nfSK4aA==
X-Google-Smtp-Source: AGHT+IGKebSgzEEYVyXSB1+4kntSmUxhzo1U1ldmbqSl4ToMg7D86LQ4AWFtkG9x0x+2bxGJZlodtCcUWNI=
X-Received: from plsr17.prod.google.com ([2002:a17:902:be11:b0:258:dc43:b015])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d60e:b0:297:f09a:51db
 with SMTP id d9443c01a7336-2986a6c9f6dmr50606755ad.15.1763152979853; Fri, 14
 Nov 2025 12:42:59 -0800 (PST)
Date: Fri, 14 Nov 2025 12:42:58 -0800
In-Reply-To: <fc886a22-49f3-4627-8ba6-933099e7640d@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com> <20251114001258.1717007-18-seanjc@google.com>
 <fc886a22-49f3-4627-8ba6-933099e7640d@grsecurity.net>
Message-ID: <aReUUkuMjnlYKzTR@google.com>
Subject: Re: [kvm-unit-tests PATCH v3 17/17] x86/cet: Add testcases to verify
 KVM rejects emulation of CET instructions
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 14, 2025, Mathias Krause wrote:
> On 14.11.25 01:12, Sean Christopherson wrote:
> > +#define SHSTK_TEST_UNSUPPORTED_INSTRUCTION(insn)			\
> > +do {									\
> > +	uint8_t vector = __CET_TEST_UNSUPPORTED_INSTRUCTION(insn);	\
> > +									\
> > +	report(vector == UD_VECTOR, "Wanted #UD on %s, got %s",		\
> > +	       insn, exception_mnemonic(vector));			\
> > +} while (0)
> > +
> > +/*
> > + * Treat IRET as unsupported with IBT even though the minimal interactions with
> > + * IBT _could_ be easily emulated by KVM, as KVM doesn't support emulating IRET
> > + * outside of Real Mode.
> > + */
> > +#define CET_TEST_UNSUPPORTED_INSTRUCTIONS(CET)				\
> > +do {									\
> > +	CET##_TEST_UNSUPPORTED_INSTRUCTION("callq *%%rax");		\
> > +	CET##_TEST_UNSUPPORTED_INSTRUCTION("lcall *%0");		\
> 
> Maybe spell out that this is a 32bit far call ("lcalll *%0"), as only
> these are supported on AMD *and* Intel? (Intel can do 64bit ones too.)
> 
> > +	CET##_TEST_UNSUPPORTED_INSTRUCTION("syscall");			\
> > +	CET##_TEST_UNSUPPORTED_INSTRUCTION("sysenter");			\
> > +	CET##_TEST_UNSUPPORTED_INSTRUCTION("iretq");			\
> 
> These, if emulated, would be rather disastrous to the test. :D
> - SYSCALL messes badly with the register state.
> - SYSENTER should #UD in long mode on AMD anyway but Intel allows it.
>   However, it'll likely #GP early, prior to messing with register state,
>   as IA32_SYSENTER_CS doesn't get initialized as the CPU expects it to
>   be.
> - The stack frame for IRETQ isn't properly set up (lacks CS, RFLAGS, SS,
>   RSP) but even if it'll #GP early for the non-canonical address, it'll
>   have modified RSP, making the recovery "pop %rax" pop an unrelated
>   stack word, likely making the code crash soon after.
> 
> So these instructions really *rely* on KVM to #UD on these early.
> Dunno, but it feels like the tests should be made more robust wrt.
> possible future emulation by KVM?

I don't necessarily disagree, but I'm not convinced it'd be worth the effort to
properly set everything up _and_ keep it functional.  Unless KVM is buggy, the
fallback will be completely untested.  I hate user-hostile tests as much as the
next person (probably more), but for this one my vote is to punt and cross our
fingers that KVM never screws up.

> > +} while (0)
> > +
> > +static uint64_t cet_shstk_emulation(void)
> > +{
> > +	CET_TEST_UNSUPPORTED_INSTRUCTIONS(SHSTK);
> > +
> > +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("call 1f");
> > +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("retq");
> > +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("retq $10");
> > +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("lretq");
> > +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("lretq $10");
> > +
> > +	/* Do a handful of JMPs to verify they aren't impacted by SHSTK. */
> > +	asm volatile(KVM_FEP "jmp 1f\n\t"
> > +		     "1:\n\t"
> > +		     KVM_FEP "lea 2f(%%rip), %%rax\n\t"
> > +		     KVM_FEP "jmp *%%rax\n\t"
>                               ^^^^^^^^^^
> Fortunately, this indirect branch runs only with shadow stack enabled,
> no IBT. If it would, than below misses an ENDBR64.

50/50 as to whether I noticed that or just got lucky :-)

>                      vvv
> > +		     "2:\n\t"> +		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
> > +		     KVM_FEP "lea 3f(%%rip), %%rax\n\t"
> > +		     KVM_FEP "push %%rax\n\t"
> > +		     /* Manually encode ljmpq, which gas doesn't recognize :-( */
> 
> LJMPQ is actually only supported on Intel systems. AMD doesn't support
> it and one has to emulate it via "push $cs; push $rip; lretq".

Well that explains why gas wasn't being very nice to me.  I'll tweak the comment.

> Dunno if it's a feature or bug of KVM to emulate LJMPQ fine on AMD -- if it
> does, that is!

Bug?  Sort of?  KVM won't emulate it on #UD, so it's only very limited emulation.
E.g. the guest would have to force emulation, put the jump source in emulated MMIO,
or play TLB games to get KVM to emulate

> > +		     KVM_FEP ".byte 0x48\n\t"
> > +		     "ljmpl *(%%rsp)\n\t"
> > +		     "3:\n\t"
> > +		     KVM_FEP "pop %%rax\n\t"
> > +		     KVM_FEP "pop %%rax\n\t"
> > +		     ::: "eax");
> > +
> > +	return 0;
> > +}
> > +
> 
> > +/*
> > + * Don't invoke printf() or report() in the IBT testcase, as it will likely
> > + * generate an indirect branch without an endbr64 annotation and thus #CP.
> 
> Uhm, x86/Makefile.x86_64 has this:
> 
> fcf_protection_full := $(call cc-option, -fcf-protection=full,)
> COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
> [...]
> ifneq ($(fcf_protection_full),)
> tests += $(TEST_DIR)/cet.$(exe)
> endif
> 
> So all code that needs it should have a leading ENDBR64 or the cet test
> wouldn't be part of the test suite.
> 
> However, I also notice it isn't working...
> 
> [digging in, hours later...]
> 
> After tweaking the exception handling to be able to tweak the IBT
> tracker state (which would be stuck at WAIT_FOR_ENDBRANCH for a missing
> ENDBR64), it still wouldn't work for me. Bummer! Further instrumentation
> showed, the code triggered within exception_mnemonic() which caused only
> more question marks -- it's just a simple switch, right? Though, looking
> at the disassembly made it crystal clear:
> 
> 000000000040707c <exception_mnemonic>:
>   40707c:       endbr64
>   407080:       cmp    $0x1e,%edi
>   407083:       ja     407117 <exception_mnemonic+0x9b>
>   407089:       mov    %edi,%edi
>   40708b:       notrack jmp *0x4107e0(,%rdi,8)
>     ::
>   4070b1:       mov    $0x411c7c,%eax	# <-- #CP(3) here
> 
> The switch block caused gcc to emit a jump table and an indirect jump
> for it (to 40708b). The jump is prefixed with 'notrack' to keep the size
> of the jump target stubs small, allowing for omitting the ENDBR64
> instruction. However, the IBT test code doesn't enable that in the MSR,
> leading the CPU to raising a #CP(3) for this indirect jump. D'oh!
> 
> So we can either disable the generation of jump tables in gcc
> (-fno-jump-tables) or just allow the 'notrack' handling. I guess the
> latter is easier.

And much more helpful for people like me, who know just enough about IBT to be
dangerous, but don't fully understand how everything works the end-to-end.
 
> Progress, but still something to fix, namely the "ljmp *%0" which is,
> apparently, successfully branching to address 0 and then triggering a
> #GP(0). But maybe that's just because I'm on an old version of the KVM
> CET series, haven't build v6.18-rcX yet.

I suspect it's your old version, it passes on my end.

> Anyhow, one less puzzle, so should be good?

Ya, I'll slot this in for the next version (instead of having it be a fixup).

