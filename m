Return-Path: <kvm+bounces-61800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D4495C2AB42
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 10:19:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 14DB94EFB45
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 09:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C94F2E88B6;
	Mon,  3 Nov 2025 09:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BSPwC5kG"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E810E2E7BCE;
	Mon,  3 Nov 2025 09:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762161483; cv=none; b=rbRI0JztsOYMU5nFPtepAU4XDKyvZh2Xi+THzVRzJESoKzhgtQ562pN3r80VtjM/kfccJKy4TQEEJuT7Zw90UhZVbivplT2stsaCdwO4NhMO5XfDbwxwTrovIhw2PaqV62OyvYmXtkXDrQ9PrZdAv//2UOEWTKoeLn4hUBNBy4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762161483; c=relaxed/simple;
	bh=uDw7dUcSPLDcLjn4FHKbeawyT4pKbSlyz6Q50G7OEfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/CyM91IXKy0DVtKyuS12REHXVo17jRwUgYxiCDb2du8yGy83lehZ46OyYrX+3jpPYM8+gZghGtNxNh7Ohz9ZAkiym9O0K3u8y+4rhu8gIHh9XWdT+M6L+Z423RDdoJN6188puAVBbyimBySBoSVskBfeJtJbTAyXuLgsBlcAOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BSPwC5kG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZGAHTQeKhhaTDSVnfwPbs9ecAwvUD0Gp75ur/DeNVyY=; b=BSPwC5kGlJJHZs1RBLRxslg68M
	XezaODI0jdADd65PbZls4qvrFJBC1OLGhS/PJsOR5y5q6hBkN6jriV+lwwETRij9YX+yPl2/Mj55j
	xYu+pcOlVg73WVP2cWxwlrGw7kqXaGCNlyfQlv33ZbP2c2iGB+cdg0uZqWPufREe2ZQl99uwdQgYU
	cP77FsvyGBg8ufHXHLok+/lZ8SlLawP5sYXBJXCoTkFxBcKGwxZq5MwoC9D/BJGdcHk9VzTApCBa6
	pXlM+foM17+OLHh+s5UDiuaYdqVkHDIvzpHaXcIzIbPJMCBVfztLPGiW8YPlT7tPNJcKLO2F0yUib
	iTisLoQA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFqhC-00000001mNs-2ET0;
	Mon, 03 Nov 2025 09:17:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E6DB030023C; Mon, 03 Nov 2025 10:17:49 +0100 (CET)
Date: Mon, 3 Nov 2025 10:17:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
Message-ID: <20251103091749.GW3245006@noisy.programming.kicks-ass.net>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-5-seanjc@google.com>
 <20251031235524.cuwrx4qys46xnpjr@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031235524.cuwrx4qys46xnpjr@desk>

On Fri, Oct 31, 2025 at 04:55:24PM -0700, Pawan Gupta wrote:
> On Thu, Oct 30, 2025 at 05:30:36PM -0700, Sean Christopherson wrote:
> ...
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 1f99a98a16a2..61a809790a58 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -71,6 +71,7 @@
> >   * @regs:	unsigned long * (to guest registers)
> >   * @flags:	VMX_RUN_VMRESUME:	use VMRESUME instead of VMLAUNCH
> >   *		VMX_RUN_SAVE_SPEC_CTRL: save guest SPEC_CTRL into vmx->spec_ctrl
> > + *		VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO: vCPU can access host MMIO
> >   *
> >   * Returns:
> >   *	0 on VM-Exit, 1 on VM-Fail
> > @@ -137,6 +138,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >  	/* Load @regs to RAX. */
> >  	mov (%_ASM_SP), %_ASM_AX
> >  
> > +	/* Stash "clear for MMIO" in EFLAGS.ZF (used below). */
> > +	ALTERNATIVE_2 "",								\
> > +		      __stringify(test $VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO, %ebx), 	\
> > +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,					\
> > +		      "", X86_FEATURE_CLEAR_CPU_BUF_VM
> > +
> >  	/* Check if vmlaunch or vmresume is needed */
> >  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
> >  
> > @@ -161,7 +168,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> >  
> >  	/* Clobbers EFLAGS.ZF */
> > -	VM_CLEAR_CPU_BUFFERS
> > +	ALTERNATIVE_2 "",							\
> > +		      __stringify(jz .Lskip_clear_cpu_buffers;			\
> > +				  CLEAR_CPU_BUFFERS_SEQ;			\
> > +				  .Lskip_clear_cpu_buffers:),			\
> > +		      X86_FEATURE_CLEAR_CPU_BUF_MMIO,				\
> > +		      __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
> 
> Another way to write this could be:
> 
> 	ALTERNATIVE_2 "jmp .Lskip_clear_cpu_buffers",					\
> 		      "jz  .Lskip_clear_cpu_buffers", X86_FEATURE_CLEAR_CPU_BUF_MMIO,	\
> 		      "",			      X86_FEATURE_CLEAR_CPU_BUF_VM
> 
> 	CLEAR_CPU_BUFFERS_SEQ
> .Lskip_clear_cpu_buffers:
> 
> With this jmp;verw; would show up in the disassembly on unaffected CPUs, I
> don't know how big a problem is that. OTOH, I find this easier to understand.

Generating larger code just to keep disassembly 'simple' seems wrong.
Also, see this:

  https://lkml.kernel.org/r/194ad779-f41f-46a5-9973-e886f483b60a@oracle.com

