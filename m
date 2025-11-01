Return-Path: <kvm+bounces-61746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B1FC276E4
	for <lists+kvm@lfdr.de>; Sat, 01 Nov 2025 04:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D9DA188BF9F
	for <lists+kvm@lfdr.de>; Sat,  1 Nov 2025 03:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6992326056E;
	Sat,  1 Nov 2025 03:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IqCPcve6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997FB23814D;
	Sat,  1 Nov 2025 03:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761968503; cv=none; b=F3HAL8hLV/jNRjehMrG+aIK9NEdlsz3NyAaatsWMVrwG7sPcCh9NA+H6K5IkLsI19e6MQvgpBJOUwFlUcfCRac2u6aIhv7P9Eni5bGxchrdCX+54rfwCtizSH+E1muYjC9hDkQQYHK77cP23B2HLl0GxFiXE8bQsOsCzfEQUBjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761968503; c=relaxed/simple;
	bh=NIZM2xMZSEv/ygTwlhilPDLU8FT6CBCjAXqYQYP2iHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fAOjIsAJYwJVyVF7GE3tg5s6aHfcO6gS33H20kwOsAme+oyeGDqIuwEa0XdZ4AG/DWIpC7Ua01fdxhAqOyp6X9/Ej9huhLZwnYh+GKnASAjxU29RJvf7yqmKHPJQ9tvCDgyRa9nuPktwe3ENj1c2baNItatvmxP1S0IFwHsFCMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IqCPcve6; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761968502; x=1793504502;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NIZM2xMZSEv/ygTwlhilPDLU8FT6CBCjAXqYQYP2iHg=;
  b=IqCPcve6QB3h/PxETR78MhNCTo2R1u+hXJC9wYlvoTpEnfdJPeqVbeyC
   rBloAI7uQWsJbEACXdyUgdWzaQngS7ciwmWTJEBhwDzt9afnCqZcQOC0R
   WKlQOXFPXQa6+eoJwi9kcXyFoO7fqp1li6W4KmMyrTQq2k5hNYK2dJmis
   EEjOAGeGBevJ63rQ55dyRBzpI9JJqAtMQ6rzXjvObzEdKW11cRgHVfmwe
   R65ZdBjBVt3UHs898ZOCZFeDToXb8L9IVq1mooZjACXdCqAPgqPGhrofw
   HItvhWKoSpqQTp+SrRVOfXmABxb84OS6JOI2AUZm8CTU0Hr+EK8aale9J
   w==;
X-CSE-ConnectionGUID: VwXRxHTvTxeVg7IhXT234g==
X-CSE-MsgGUID: nfuhDZOHTN60zo31XfQsjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="86757813"
X-IronPort-AV: E=Sophos;i="6.19,271,1754982000"; 
   d="scan'208";a="86757813"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 20:41:42 -0700
X-CSE-ConnectionGUID: 3qrPQcaQQrGTDXa3w5bu/Q==
X-CSE-MsgGUID: ExK4bYSeTASKKric6xfQsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,271,1754982000"; 
   d="scan'208";a="223628839"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.220.87])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 20:41:40 -0700
Date: Fri, 31 Oct 2025 20:41:32 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 4/8] KVM: VMX: Handle MMIO Stale Data in VM-Enter
 assembly via ALTERNATIVES_2
Message-ID: <20251101034132.2qi5b2ysld6fi2cq@desk>
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

On Fri, Oct 31, 2025 at 04:55:37PM -0700, Pawan Gupta wrote:
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

As far as execution is concerned, it basically boils down to 9 NOPs:

54:	48 8b 00             	mov    (%rax),%rax
				---
57:	90                   	nop
58:	90                   	nop
59:	90                   	nop
5a:	90                   	nop
5b:	90                   	nop
5c:	90                   	nop
5d:	90                   	nop
5e:	90                   	nop
5f:	90                   	nop
				---
60:	73 08                	jae

versus 1 near jump:

54:	48 8b 00             	mov    (%rax),%rax
				---
57:	eb 0b                	jmp    ffffffff81fa1064
59:	90                   	nop
5a:	90                   	nop
5b:	90                   	nop
5c:	90                   	nop
5d:	0f 00 2d dc ef 05 ff 	verw   -0xfa1024(%rip)
				---
64:	73 08                	jae

I can't tell which one is better.

