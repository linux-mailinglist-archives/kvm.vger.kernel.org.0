Return-Path: <kvm+bounces-61447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B22D5C1DEB3
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 01:34:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66C813B40C9
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 00:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513B71E7C34;
	Thu, 30 Oct 2025 00:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yw6hhT7j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0B83A1C9;
	Thu, 30 Oct 2025 00:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761784436; cv=none; b=jJZnf8TYr2ddwq8WEm+9NQPp/IjCisMMCgvaC9xvP8gcdXaPfcEIbNPPp4to33l0LEEl+91gtCqXI7jTXEky8+2AtafTIlLojuEsvTNUE6BWF6zOhUAB1HonwKvCuEhISqSJvZaUJzJ12WUN1HIJOYkuz9jJziuVQ8DoOYJyB9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761784436; c=relaxed/simple;
	bh=/Mw6DJ7dUyguG741SkMIia9BetoId2OhuQrpqJdrHME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbZhStsWoY5H4ZfDM2sm3AMCStiAitHABHTH2rSujtD7fCflHb0tkIyPfCDd03hU86m8jlpMoR70TcjpOj5vwwwnLZhM41BALyC8n+LHrUA792e2S5e5KNZQzOPy8UlfRa9+8syuO974PbfmUsjH+K8ulYodVW97YmokTokN6co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yw6hhT7j; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761784433; x=1793320433;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/Mw6DJ7dUyguG741SkMIia9BetoId2OhuQrpqJdrHME=;
  b=Yw6hhT7j0F80cmsZ1rys88FRDdl4PzeJ9SHUXV9UdOW0FMxylJ6CRbGW
   en3fMEZwQNZTB/jJ5/DubF0ctcOSM4Z0iOpv2oxthJ8wwvwzQw1JGGaf7
   +SGVKbmeubuJRGoG4xcsAAM3RJFTmUMCcBt9Nhvx2cH2A6VtgtfWt8+P0
   hJHjkqyJlLsjGmayAeZ5AqOxyKnlL+sH63qqU3Iw6Gyozhkd7XGOAXRsq
   WTgGKyzRL7UEJmTgG3tdJKtFat5UR58Rwa4+MaITbNL2I30rgxwdJLZQO
   r39AGyEnhHE4cgyuWNuKy7M6CQQfd+kSGBLKbfbN2wMaRCXEjl3Fl4XZw
   Q==;
X-CSE-ConnectionGUID: +muxPlWVT6OLaGeamD0BCw==
X-CSE-MsgGUID: YFnGI1nIQzykuNB69fitgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="75266029"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="75266029"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 17:33:52 -0700
X-CSE-ConnectionGUID: 6264uiJ5TU2VeEvARPURCQ==
X-CSE-MsgGUID: MN2WdDgZThGnZ6OF/Ef9oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="223031473"
Received: from vverma7-desk1.amr.corp.intel.com (HELO desk) ([10.124.223.151])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 17:33:53 -0700
Date: Wed, 29 Oct 2025 17:33:46 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
Message-ID: <20251030003346.5kmj5urppoex7gyd@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>

On Wed, Oct 29, 2025 at 02:27:00PM -0700, Pawan Gupta wrote:
> When a system is only affected by MMIO Stale Data, VERW mitigation is
> currently handled differently than other data sampling attacks like
> MDS/TAA/RFDS, that do the VERW in asm. This is because for MMIO Stale Data,
> VERW is needed only when the guest can access host MMIO, this was tricky to
> check in asm.
> 
> Refactoring done by:
> 
>   83ebe7157483 ("KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps
>   MMIO into the guest")
> 
> now makes it easier to execute VERW conditionally in asm based on
> VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO.
> 
> Unify MMIO Stale Data mitigation with other VERW-based mitigations and only
> have single VERW callsite in __vmx_vcpu_run(). Remove the now unnecessary
> call to x86_clear_cpu_buffer() in vmx_vcpu_enter_exit().
> 
> This also untangles L1D Flush and MMIO Stale Data mitigation. Earlier, an
> L1D Flush would skip the VERW for MMIO Stale Data. Now, both the
> mitigations are independent of each other. Although, this has little
> practical implication since there are no CPUs that are affected by L1TF and
> are *only* affected by MMIO Stale Data (i.e. not affected by MDS/TAA/RFDS).
> But, this makes the code cleaner and easier to maintain.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/run_flags.h | 12 ++++++------
>  arch/x86/kvm/vmx/vmenter.S   |  5 +++++
>  arch/x86/kvm/vmx/vmx.c       | 26 ++++++++++----------------
>  3 files changed, 21 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> index 2f20fb170def8b10c8c0c46f7ba751f845c19e2c..004fe1ca89f05524bf3986540056de2caf0abbad 100644
> --- a/arch/x86/kvm/vmx/run_flags.h
> +++ b/arch/x86/kvm/vmx/run_flags.h
> @@ -2,12 +2,12 @@
>  #ifndef __KVM_X86_VMX_RUN_FLAGS_H
>  #define __KVM_X86_VMX_RUN_FLAGS_H
>  
> -#define VMX_RUN_VMRESUME_SHIFT				0
> -#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
> -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
> +#define VMX_RUN_VMRESUME_SHIFT			0
> +#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT		1
> +#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT		2
>  
> -#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
> -#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> -#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
> +#define VMX_RUN_VMRESUME		BIT(VMX_RUN_VMRESUME_SHIFT)
> +#define VMX_RUN_SAVE_SPEC_CTRL		BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> +#define VMX_RUN_CLEAR_CPU_BUFFERS	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
>  
>  #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 0dd23beae207795484150698d1674dc4044cc520..ec91f4267eca319ffa8e6079887e8dfecc7f96d8 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -137,6 +137,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Load @regs to RAX. */
>  	mov (%_ASM_SP), %_ASM_AX
>  
> +	/* jz .Lskip_clear_cpu_buffers below relies on this */
> +	test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
> +
>  	/* Check if vmlaunch or vmresume is needed */
>  	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
>  
> @@ -160,6 +163,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Load guest RAX.  This kills the @regs pointer! */
>  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>  
> +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> +	jz .Lskip_clear_cpu_buffers
>  	/* Clobbers EFLAGS.ZF */
>  	VM_CLEAR_CPU_BUFFERS
>  .Lskip_clear_cpu_buffers:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 451be757b3d1b2fec6b2b79157f26dd43bc368b8..303935882a9f8d1d8f81a499cdce1fdc8dad62f0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -903,9 +903,16 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
>  	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
>  		flags |= VMX_RUN_SAVE_SPEC_CTRL;
>  
> -	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
> -	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> -		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
> +	/*
> +	 * When affected by MMIO Stale Data only (and not other data sampling
> +	 * attacks) only clear for MMIO-capable guests.
> +	 */
> +	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only)) {
> +		if (kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> +			flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> +	} else {
> +		flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
> +	}

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
 

