Return-Path: <kvm+bounces-62923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8747BC53FC2
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:49:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F3F33AF5F4
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9658134D901;
	Wed, 12 Nov 2025 18:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bpK7oEWo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA1F34B402;
	Wed, 12 Nov 2025 18:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972742; cv=none; b=E6NiaB3Qle9XVeXswR+WcXzLypTTTWUD8O0RRQZp3W1F7xy+NvURTKTR39dCYJtXs3ZGO8AciE2O53hiy0XWydqPFRwxNnBEMlCaS9Y5PW5EptHXBE9Lm4ilSkJ5o0Opwg2b81GNusV7HCUv/Hf9KzJgC9vfCfucvavvlzxN00k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972742; c=relaxed/simple;
	bh=POv7NkoF44sU+mFkRsPUnoPJGmeAATZEDnKOAGTsCOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aFEbjrHFaGtMGUtkrTUsmZlJC/gGr1EJVJv99CRh9lu8EJINmnAb1XT6TNQrvV7kGp+2gVgKTYHkWIdZZ0GGpyqV82b9MlitwT0Uc/VvSHeh+51YekqHvcofmZkencVA7CQvF5eufbhckp/DRM9K7qoTizAqCjg5Iau1uLjeRq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bpK7oEWo; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3F00440E01CD;
	Wed, 12 Nov 2025 18:38:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id e05PRrtV6K6R; Wed, 12 Nov 2025 18:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762972731; bh=0aGt+4sMYIhh0E/2xYmyk01i4uKCzPvyHNRoOm86K+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bpK7oEWoXCfaEHu+FD7jo28m0ekyWR9OOpd7z9cY6lLs5uKhm7JWeWb10WUL0A/sj
	 RXBSMeCaZxHUyrgfTUfMUrDuScNwqBfe1RshpnxrmpUaIPNhcrYjt4dAK0yVnFJ3gA
	 7eFkWE8nlYg5rX0Y2og5+hEDG9H/sdKzOxkFJXcRnlHFqfzgnqWrMKDNAdPMAmyVOa
	 mSAtNk+V2BIEFqSAthAoUkANmulRtWNb2w1Z1iV3CwWamlalU/OwwYfEfy1VDGpf9Y
	 nHvWLdM3PIOyUZKk1wMbaPRYzx0CN0SIG6r60f4DhW1EeHEbh0KghKDqRLSaauGw8Q
	 RzRtwusNWPoiMF13u8l39hC7CE9tz5U8PWnJs+O9Qjd4jZIy7MlscahUsqOMuZ0AwI
	 sjzVVHxRH3oKM+LaoPTF7LZIbVBJxeXwOsPmbBqCKK3q2qWcVWCAudWnTx7Aswt8RR
	 FJKfmNFgM7NNlkpw6a2RYqcmW0mgRTE6SDORpA3I/LCczNSrqAKGysW9eWzMRkwTpU
	 sjt446jcbqRMwbF3ofHFxzlDaLwqWGAc3Jx8ocUBRlBp95kriXALKiGLWP8HN79lvL
	 ifK4phPmkuzePgi3Y5lOeGmWXtUtcR6epu9w0499t3nFkY4+XKkgAHqM5T42PqYF4B
	 +fr1kmtKeAz9nw2Qzc7ufxuw=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 917FD40E0191;
	Wed, 12 Nov 2025 18:38:42 +0000 (UTC)
Date: Wed, 12 Nov 2025 19:38:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
Message-ID: <20251112183836.GBaRTULLaMWA5hkfT9@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-5-seanjc@google.com>
 <20251112164144.GAaRS4yKgF0gQrLSnR@fat_crate.local>
 <aRTAlEaq-bI5AMFA@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aRTAlEaq-bI5AMFA@google.com>

On Wed, Nov 12, 2025 at 09:15:00AM -0800, Sean Christopherson wrote:
> On Wed, Nov 12, 2025, Borislav Petkov wrote:
> > On Thu, Oct 30, 2025 at 05:30:36PM -0700, Sean Christopherson wrote:
> > > @@ -137,6 +138,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
> > >  	/* Load @regs to RAX. */
> > >  	mov (%_ASM_SP), %_ASM_AX
> > >  
> > > +	/* Stash "clear for MMIO" in EFLAGS.ZF (used below). */
> > 
> > Oh wow. Alternatives interdependence. What can go wrong. :)
> 
> Nothing, it's perfect. :-D

Yeah. :-P

> 
> > > +	ALTERNATIVE_2 "",								\
> > > +		      __stringify(test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx), 	\
> > 
> > So this VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO bit gets set here:
> > 
> >         if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_MMIO) &&
> >             kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> >                 flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
> > 
> > So how static and/or dynamic is this?
> 
> kvm_vcpu_can_access_host_mmio() is very dynamic.  It can be different between
> vCPUs in a VM, and can even change on back-to-back runs of the same vCPU.

Hmm, strange. Because looking at those things there:

root->has_mapped_host_mmio and vcpu->kvm->arch.has_mapped_host_mmio

they both read like something that a guest would set up once and that's it.
But what do I know...

> > IOW, can you stick this into a simple variable which is unconditionally
> > updated and you can use it in X86_FEATURE_CLEAR_CPU_BUF_MMIO case and
> > otherwise it simply remains unused?
> 
> Can you elaborate?  I don't think I follow what you're suggesting.

So I was thinking if you could set a per-guest variable in
C - vmx_per_guest_clear_per_mmio or so and then test it in asm:

		testb $1,vmx_per_guest_clear_per_mmio(%rip)
		jz .Lskip_clear_cpu_buffers;
		CLEAR_CPU_BUFFERS_SEQ;

.Lskip_clear_cpu_buffers:

gcc -O3 suggests also

		cmpb   $0x0,vmx_per_guest_clear_per_mmio(%rip)

which is the same insn size...

The idea is to get rid of this first asm stashing things and it'll be a bit
more robust, I'd say.

And you don't rely on registers...

and when I say that, I now realize this is 32-bit too and you don't want to
touch regs - that's why you're stashing it - and there's no rip-relative on
32-bit...

I dunno - it might get hairy but I would still opt for a different solution
instead of this fragile stashing in ZF. You could do a function which pushes
and pops a scratch register where you put the value, i.e., you could do

	push %reg
	mov var, %reg
	test or cmp ...
	...
	jz skip...
skip:
	pop %reg

It is still all together in one place instead of spreading it around like
that.

Oh well.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

