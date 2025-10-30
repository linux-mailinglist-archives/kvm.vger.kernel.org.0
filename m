Return-Path: <kvm+bounces-61457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E4984C1E763
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 06:53:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AD5BA345EB1
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 05:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527722E62B9;
	Thu, 30 Oct 2025 05:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="o7EuA5PW"
X-Original-To: kvm@vger.kernel.org
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A928F246333;
	Thu, 30 Oct 2025 05:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761803572; cv=none; b=tZHziNDlaKUEu/XFwunmoC83NLTwISkkvwBci1KpwKKNMCNlO7kvtB/U+PstOOj2Y+l9OQuH89TBRZrA5IJO4pPPDtR7nSrOjTPxKHmy9RJmH+A9lu31r1zJipv0z5ZGABGToVVGaRx5IAhKfHPSRWFHvuEtAByK6zMG5Cq1+lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761803572; c=relaxed/simple;
	bh=7vD8qLCkJC5WlKwzaKKQHY6iR0vXELPmA6r5MI6faOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ri1XH+oKS8l5oUsQzSx3Li4lGXkuFD8suTZGr+fDIOgwfr8Pq5dzbrGne3rOa9aK2wRDGF8nILmIA5vOVdg9UIDXU+JB4/4JWFSwZThVKyLq5xPUxX7FOs3aDCSoIVa5hkYSrseu4GgipOHi0zoacpOAT6vx+DXUVBlYMvxr+Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=o7EuA5PW; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761803561; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=QbJW1oSoPB+S3wvl8vKFqXtFlLfT8YYkUewku8ErJqo=;
	b=o7EuA5PWcvYpbzP0XSJoirBcNGoa7E0dHztJHl45PhrW8DtyUt+oF+A8dN+4cCdw7AnC3/kE32pOjXmsKNMp6bR1Bj47nGTfe2ZE3a3qS9J/G5NbZBDUzfwbgVdbf7iw1I+LsHm2OhaB9xa5Hi/oR4lFnWIjoqHCQbuJ3tj84lc=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WrIxGBP_1761803559 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Oct 2025 13:52:40 +0800
Date: Thu, 30 Oct 2025 13:52:39 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>, 
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
Message-ID: <rntzk5ujevvnowhvr5ok2mqr6o3j3uwgei4523h7qiadjk6fq6@4mtnpe3hdixn>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
 <20251030003346.5kmj5urppoex7gyd@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030003346.5kmj5urppoex7gyd@desk>

On Wed, Oct 29, 2025 at 05:33:46PM +0800, Pawan Gupta wrote:
> On Wed, Oct 29, 2025 at 02:27:00PM -0700, Pawan Gupta wrote:
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
> >
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  arch/x86/kvm/vmx/run_flags.h | 12 ++++++------
> >  arch/x86/kvm/vmx/vmenter.S   |  5 +++++
> >  arch/x86/kvm/vmx/vmx.c       | 26 ++++++++++----------------
> >  3 files changed, 21 insertions(+), 22 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> > index 2f20fb170def8b10c8c0c46f7ba751f845c19e2c..004fe1ca89f05524bf3986540056de2caf0abbad 100644
> > --- a/arch/x86/kvm/vmx/run_flags.h
> > +++ b/arch/x86/kvm/vmx/run_flags.h
> > @@ -2,12 +2,12 @@
> >  #ifndef __KVM_X86_VMX_RUN_FLAGS_H
> >  #define __KVM_X86_VMX_RUN_FLAGS_H
> >
> > -#define VMX_RUN_VMRESUME_SHIFT				0
> > -#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
> > -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
> > +#define VMX_RUN_VMRESUME_SHIFT			0
> > +#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT		1
> > +#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT		2
> >
> > -#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
> > -#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> > -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
> > +#define VMX_RUN_VMRESUME		BIT(VMX_RUN_VMRESUME_SHIFT)
> > +#define VMX_RUN_SAVE_SPEC_CTRL		BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> > +#define VMX_RUN_CLEAR_CPU_BUFFERS	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
> >
> >  #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 0dd23beae207795484150698d1674dc4044cc520..ec91f4267eca319ffa8e6079887e8dfecc7f96d8 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -137,6 +137,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >  	/* Load @regs to RAX. */
> >  	mov (%_ASM_SP), %_ASM_AX
> >
> > +	/* jz .Lskip_clear_cpu_buffers below relies on this */
> > +	test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
> > +
> >  	/* Check if vmlaunch or vmresume is needed */
> >  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
> >
> > @@ -160,6 +163,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >  	/* Load guest RAX.  This kills the @regs pointer! */
> >  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> >
> > +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> > +	jz .Lskip_clear_cpu_buffers
> >  	/* Clobbers EFLAGS.ZF */
> >  	VM_CLEAR_CPU_BUFFERS
> >  .Lskip_clear_cpu_buffers:
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
> Setting the flag here is harmless but not necessary when the CPU is not
> affected by any of the data sampling attacks. VM_CLEAR_CPU_BUFFERS would be
> a NOP in the case.
>
> However, me looking at this code in a year or two would be confused why the
> flag is always set on unaffected CPUs. Below change to conditionally set
> the flag would make it clearer.
>
> ---
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 303935882a9f..0eab59ab2698 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -910,7 +910,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
>  	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only)) {
>  		if (kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
>  			flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> -	} else {
> +	} else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF_VM)) {
>  		flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
>  	}
>

Oh, even no need a or two year later, I just feel confusion
when look at this part first time. But this change anyway
makes it more clear to me.

