Return-Path: <kvm+bounces-61460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F057C1E83D
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 07:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 828AD18924A9
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 06:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC10F32572E;
	Thu, 30 Oct 2025 06:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mkgTH2yq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E628E272E45;
	Thu, 30 Oct 2025 06:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761804728; cv=none; b=RF7/El7ba8xpshMSXXEKvofzv7BmQGfjl3NscE86HkPo1FQiL5KoRa6RwKbQt+evN2Ep+2/EMNDt70h10nIL5gURB+LJ+tASGDZMcKjHT5a+FNM7jyWIkx5w6YJW4fIn/ijnAVezoOqMk5megRn4FmqFew2+NNWAJNdNMxx+ao4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761804728; c=relaxed/simple;
	bh=dJhfa6YLnRZl0M5BbAbdBVW/xbsE1/BirraX7BLXA7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INTjo+OaN7Up98qlLV9HozMAJJuTKjBYypFhpflt/2SX/p+ERM/Fy31TZTEUcp+UffmqazZlZCB0OwjwoDyNGjWJIdTMd0z/atvOy7IoaX4mQeGG5CBBpbqHjLWPEtym6wMaEBCbe4dH9UVJ3r2q9TwSSF8I75k8H8+Hv/qhUBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mkgTH2yq; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761804726; x=1793340726;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dJhfa6YLnRZl0M5BbAbdBVW/xbsE1/BirraX7BLXA7c=;
  b=mkgTH2yqJRmVsh09byYIRE9AnIwI8B35S4cbszkAUpX6JOl/QkoMN4tK
   MOy8euSCQ/1743i7g1uWQtPe8JlNrtHhkSdYCEjSXBpOxLS70D7cqT+Or
   CjSjOTTEjZMlOxAYnM/N7yw+yP0c/vhwxnAFYl4YcXImEbyJdEGKR4lwA
   +P3Sg3iMQqGeKDTZhJdCmR7TYQSj6iQomZ6KzrLUIWarsduQitp/vCFXa
   tRKd2ymZPWKeZfGPXQvJBiImM/epKYJlGdfUHCYwt0DNu8NBNfVXGDGtz
   3VjDw5TuQw3yaB5brZHhRxmQyE/6E4cKBxv0ClGzI/Qpz5sVcqQ+TFDvB
   g==;
X-CSE-ConnectionGUID: wSvcbmhiSmmCXcwR8ZjoZg==
X-CSE-MsgGUID: YbriIRPLTyiNEx8u4TyIEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="63142913"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="63142913"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 23:12:05 -0700
X-CSE-ConnectionGUID: Rzr7SW12Qmu1Kd8bdPyBGA==
X-CSE-MsgGUID: uZKC00H2RTG8r5ESjWmyPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="216720502"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.223.240])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 23:12:04 -0700
Date: Wed, 29 Oct 2025 23:11:50 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
Message-ID: <20251030061012.hkt2wsbxo5vh55ub@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
 <aQKw-a73mo1nLiJw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQKw-a73mo1nLiJw@google.com>

On Wed, Oct 29, 2025 at 05:27:37PM -0700, Sean Christopherson wrote:
> On Wed, Oct 29, 2025, Pawan Gupta wrote:
> > When a system is only affected by MMIO Stale Data, VERW mitigation is
> > currently handled differently than other data sampling attacks like
> > MDS/TAA/RFDS, that do the VERW in asm. This is because for MMIO Stale Data,
> > VERW is needed only when the guest can access host MMIO, this was tricky to
> > check in asm.
> > 
> > Refactoring done by:
> > 
> >   83ebe7157483 ("KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps
> >   MMIO into the guest")
> > 
> > now makes it easier to execute VERW conditionally in asm based on
> > VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO.
> > 
> > Unify MMIO Stale Data mitigation with other VERW-based mitigations and only
> > have single VERW callsite in __vmx_vcpu_run(). Remove the now unnecessary
> > call to x86_clear_cpu_buffer() in vmx_vcpu_enter_exit().
> > 
> > This also untangles L1D Flush and MMIO Stale Data mitigation. Earlier, an
> > L1D Flush would skip the VERW for MMIO Stale Data. Now, both the
> > mitigations are independent of each other. Although, this has little
> > practical implication since there are no CPUs that are affected by L1TF and
> > are *only* affected by MMIO Stale Data (i.e. not affected by MDS/TAA/RFDS).
> > But, this makes the code cleaner and easier to maintain.
> 
> Heh, and largely makes our discussion on the L1TF cleanup moot :-)

Well, this series is largely a result of that discussion :-)

> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> 
> ...
> 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 451be757b3d1b2fec6b2b79157f26dd43bc368b8..303935882a9f8d1d8f81a499cdce1fdc8dad62f0 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -903,9 +903,16 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
> >  	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
> >  		flags |= VMX_RUN_SAVE_SPEC_CTRL;
> >  
> > -	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
> > -	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> > -		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
> > +	/*
> > +	 * When affected by MMIO Stale Data only (and not other data sampling
> > +	 * attacks) only clear for MMIO-capable guests.
> > +	 */
> > +	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only)) {
> > +		if (kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> > +			flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> > +	} else {
> > +		flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> > +	}
> 
> This is quire confusing and subtle.

I realized that and sent the below follow-up almost at the same time:

	Setting the flag here is harmless but not necessary when the CPU is not
	affected by any of the data sampling attacks. VM_CLEAR_CPU_BUFFERS would be
	a NOP in the case.

	However, me looking at this code in a year or two would be confused why the
	flag is always set on unaffected CPUs. Below change to conditionally set
	the flag would make it clearer.

	---
	diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
	index 303935882a9f..0eab59ab2698 100644
	--- a/arch/x86/kvm/vmx/vmx.c
	+++ b/arch/x86/kvm/vmx/vmx.c
	@@ -910,7 +910,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
		if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only)) {
			if (kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
				flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
	-	} else {
	+	} else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_VM)) {
			flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
		}


> E.g. it requires the reader to know that cpu_buf_vm_clear_mmio_only is
> mutually exlusive with X86_FEATURE_CLEAR_CPU_BUF, and that
> VMX_RUN_CLEAR_CPU_BUFFERS is ignored if X86_FEATURE_CLEAR_CPU_BUF=n.
> 
> At least, I think that's how it works :-)

That is right, only thing is instead of X86_FEATURE_CLEAR_CPU_BUF,
VM_CLEAR_CPU_BUFFERS depends on KVM specific X86_FEATURE_CLEAR_CPU_BUF_VM.

> Isn't the above equivalent to this when all is said and done?
> 
> 	if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) ||

For the above reason, it might be better to to use
X86_FEATURE_CLEAR_CPU_BUF_VM (as in the diff I pasted above).

> 	    (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
> 	     kvm_vcpu_can_access_host_mmio(&vmx->vcpu)))
> 		flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> 

