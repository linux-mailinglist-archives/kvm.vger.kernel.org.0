Return-Path: <kvm+bounces-61512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 65DE8C21B51
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 62B2D4F8849
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3D723B607;
	Thu, 30 Oct 2025 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="knQpMdJI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565C81548C;
	Thu, 30 Oct 2025 18:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761847590; cv=none; b=YKVp6MyygMHgRXyrzE0HlLGUJ0B3jNw/UcMhT99neNuZmkkr6otUtl83Mp5F2w3f5M8za17pEcmZITNQzCLaZELlsHmimVQ4ONtAybG3vpZsDwqj7sw88C+TI1r5BH4b1+BQbIVMV2xHjfrdkVqX5yeAvGrquXubc8mGP+RCna0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761847590; c=relaxed/simple;
	bh=R0oxsLJx4ixavniiS9gYg/wzhW0HB/vdjk4EsiPZ7i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AxbNDy3gVE0NqUN1wdXXgVOKKjB3dfCpswdgIsMEZS/bRyWqiofaOiRdg9atiNYVlub8I6mzscpwriiiC5TzAeFsv2WL0VHmzSyfocvx18BRLWnHxf9JNnv/CnmkxPELP6yzHg6NTRLh+l6Ee5DXDVCY+bwLsXQdQRa+goskNeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=knQpMdJI; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761847588; x=1793383588;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R0oxsLJx4ixavniiS9gYg/wzhW0HB/vdjk4EsiPZ7i0=;
  b=knQpMdJId/rhRBt4kRxy5ciEeQpQbVOqfYU8T3epJlIE3Rkj0HCioxJI
   O7illsiErfQ2OqZ2j8aDedxIbA17jniVnEZHeXpZgdKVSc3OXC8zcJB1O
   dVIYk+S3rH84uLA/qvWer+h1YmR9WDn+TqvP78ygarX51LRZKCt2Tlohc
   XCQMJjSRJJ9MgacKJFl3/OL+GUTsx6IA3MhqD6e2/G0c4WbjGcoqF7vVN
   h4qL8z4ROZCu9hEB2L8zlx6eyS4lsQZLYKwNXaF0YNIAfZDogr4xfBXh4
   8vh62pjLkC+4m9njsPZL1oz0eRN2BdAoCyoIkBRqf3jdI2t0rcgNJrNoA
   A==;
X-CSE-ConnectionGUID: qI6hgpREQ1uf2zB7QVK1QA==
X-CSE-MsgGUID: lPOxcmFDQ0SLAxgIl1ASmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="64041135"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="64041135"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 11:06:27 -0700
X-CSE-ConnectionGUID: O5F3iM/KTK68PhXAonJdGQ==
X-CSE-MsgGUID: ZsP3IUyNT8iaR8iDN348ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="190379074"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.223.240])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 11:06:27 -0700
Date: Thu, 30 Oct 2025 11:06:21 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
Message-ID: <20251030180621.c4jk3isi3pmzeolw@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
 <DDVO5U7JZF4F.1WXXE8IYML140@google.com>
 <aQONEWlBwFCXx3o6@google.com>
 <DDVSPNXCG4HY.1B7OBAPDZ97CX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDVSPNXCG4HY.1B7OBAPDZ97CX@google.com>

On Thu, Oct 30, 2025 at 04:26:10PM +0000, Brendan Jackman wrote:
> On Thu Oct 30, 2025 at 4:06 PM UTC, Sean Christopherson wrote:
> > On Thu, Oct 30, 2025, Brendan Jackman wrote:
> >> > @@ -160,6 +163,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >> >  	/* Load guest RAX.  This kills the @regs pointer! */
> >> >  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> >> >  
> >> > +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> >> > +	jz .Lskip_clear_cpu_buffers
> >> 
> >> Hm, it's a bit weird that we have the "alternative" inside
> >> VM_CLEAR_CPU_BUFFERS, but then we still keep the test+jz
> >> unconditionally. 
> >
> > Yeah, I had the same reaction, but couldn't come up with a clean-ish solution
> > and so ignored it :-)
> >
> >> If we really want to super-optimise the no-mitigations-needed case,
> >> shouldn't we want to avoid the conditional in the asm if it never
> >> actually leads to a flush?
> >> 
> >> On the other hand, if we don't mind a couple of extra instructions,
> >> shouldn't we be fine with just having the whole asm code based solely
> >> on VMX_RUN_CLEAR_CPU_BUFFERS and leaving the
> >> X86_FEATURE_CLEAR_CPU_BUF_VM to the C code?
> >> 
> >> I guess the issue is that in the latter case we'd be back to having
> >> unnecessary inconsistency with AMD code while in the former case... well
> >> that would just be really annoying asm code - am I on the right
> >> wavelength there? So I'm not necessarily asking for changes here, just
> >> probing in case it prompts any interesting insights on your side.
> >> 
> >> (Also, maybe this test+jz has a similar cost to the nops that the
> >> "alternative" would inject anyway...?)
> >
> > It's not at all expensive.  My bigger objection is that it's hard to follow what's
> > happening.
> >
> > Aha!  Idea.  IIUC, only the MMIO Stale Data is conditional based on the properties
> > of the vCPU, so we should track _that_ in a KVM_RUN flag.  And then if we add yet
> > another X86_FEATURE for MMIO Stale Data flushing (instead of a static branch),
> > this path can use ALTERNATIVE_2.  The use of ALTERNATIVE_2 isn't exactly pretty,
> > but IMO this is much more intuitive.
> >
> > diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> > index 004fe1ca89f0..b9651960e069 100644
> > --- a/arch/x86/kvm/vmx/run_flags.h
> > +++ b/arch/x86/kvm/vmx/run_flags.h
> > @@ -4,10 +4,10 @@
> >  
> >  #define VMX_RUN_VMRESUME_SHIFT                 0
> >  #define VMX_RUN_SAVE_SPEC_CTRL_SHIFT           1
> > -#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT                2
> > +#define VMX_RUN_CAN_ACCESS_HOST_MMIO_SHIT      2
> >  
> >  #define VMX_RUN_VMRESUME               BIT(VMX_RUN_VMRESUME_SHIFT)
> >  #define VMX_RUN_SAVE_SPEC_CTRL         BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> > -#define VMX_RUN_CLEAR_CPU_BUFFERS      BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
> > +#define VMX_RUN_CAN_ACCESS_HOST_MMIO   BIT(VMX_RUN_CAN_ACCESS_HOST_MMIO_SHIT)
> >  
> >  #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index ec91f4267eca..50a748b489b4 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -137,8 +137,10 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >         /* Load @regs to RAX. */
> >         mov (%_ASM_SP), %_ASM_AX
> >  
> > -       /* jz .Lskip_clear_cpu_buffers below relies on this */
> > -       test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
> > +       /* Check if jz .Lskip_clear_cpu_buffers below relies on this */
> > +       ALTERNATIVE_2 "",
> > +                     "", X86_FEATURE_CLEAR_CPU_BUF
> > +                     "test $VMX_RUN_CAN_ACCESS_HOST_MMIO, %ebx", X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO
> 
> Er, I don't understand the ALTERNATIVE_2 here, don't we just need this?
> 
> ALTERNATIVE "" "test $VMX_RUN_CAN_ACCESS_HOST_MMIO, %ebx", 
> 	    X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO

Yeah, right.

> >         /* Check if vmlaunch or vmresume is needed */
> >         bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
> > @@ -163,8 +165,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >         /* Load guest RAX.  This kills the @regs pointer! */
> >         mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> >  
> > -       /* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> > -       jz .Lskip_clear_cpu_buffers
> > +       ALTERNATIVE_2 "jmp .Lskip_clear_cpu_buffers",
> > +                     "", X86_FEATURE_CLEAR_CPU_BUF
> > +                     "jz .Lskip_clear_cpu_buffers", X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO
> 
> To fit with the rest of Pawan's code this would need
> s/X86_FEATURE_CLEAR_CPU_BUF/X86_FEATURE_CLEAR_CPU_BUF_VM/, right?

Yes.

> In case it reveals that I just don't understand ALTERNATIVE_2 at all,
> I'm reading this second one as saying:
> 
> if cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO)
>    "jz .Lskip_clear_cpu_buffers "
> else if !cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_VM)
>    "jmp .Lskip_clear_cpu_buffers"
>
> I.e. I'm understanding X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO as mutually
> exclusive with X86_FEATURE_CLEAR_CPU_BUF_VM, it means "you _only_ need
> to verw MMIO".

Yes, that's also my understanding.

> So basically we moved cpu_buf_vm_clear_mmio_only into a
> CPU feature to make it accessible from asm?

Essentially, yes.

> (Also let's use BUF instead of BUFFERS in the name, for consistency)

Agree.

