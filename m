Return-Path: <kvm+bounces-63486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ACAD3C67933
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 990B12A002
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 05:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF2629BD81;
	Tue, 18 Nov 2025 05:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZJsoMXyg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB3221885A;
	Tue, 18 Nov 2025 05:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763443994; cv=none; b=UO2F/EfCqTSJPtUeU/V42N7BBOMlHVZVLCPDkacE3rrgt7STJCyMXXagDcr14IiAhNGOBrTUOj4R0iw1XcNmnAIZvu2f+PvGuHWvmQ9/58S6d/Vq7XsYb75uWdTZl0S68+GFtuUF2qx2yN6IYmc+r0f+2nbhnU4Cr2jlMCgVCBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763443994; c=relaxed/simple;
	bh=NYk4UbO7NtpXwm/Uzkm0rKI+MrgW0TyDUFv/z0gt/io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8LX3msdxwoRlyivVmf0jycPkrdDoBdpBoDNb8W3QXCSeofi2SmEt2Dr3M5IPTuKzz8uC7MTuFJa6FgacsAsCtK0sGVWJo2V7p4E4E2NecSXo5kVIJCPAh5fozsaHv+OLw7JFqqbPtb3yQw88CYM+RuoankuKgAMZO2MxdPDLyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZJsoMXyg; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763443993; x=1794979993;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NYk4UbO7NtpXwm/Uzkm0rKI+MrgW0TyDUFv/z0gt/io=;
  b=ZJsoMXygusAMHLjPHhuuBuJbTxr+FPmPT058Um+E0wcYyU4WyNVg4W8g
   KMosnmWELJwraYzyUdzjTF+xEuJ+h3Pf0lSICe4NYSA8D7mPXc+2j5FcG
   VuUL9LGYpXbudyQ5xlEQ4gj8qyzue5B+DrEC6dybSNN6hwrDH/7p7qM5X
   GE3OZynfZ10Un8i2TBiLFskGvueXlsOfSGoI0aoUAP9Lbah8gAGXJgWs0
   wkbTx15HsXWjH8yGm7WvshR9eottd80Oj+inu39jH0BBwe7iAo1cdhGD2
   np2NNJibuKdVVy4zKWpE91O8B0bYSfx/vzhqYWRkJOznHJCcW36JnYTqw
   w==;
X-CSE-ConnectionGUID: uwNnf29aRs6s0EGUSsFAYg==
X-CSE-MsgGUID: BQnF14yxSdKVXZExFZk6YA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="76133580"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="76133580"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 21:33:10 -0800
X-CSE-ConnectionGUID: gY3qdlRdSKCoZwEPOowpJw==
X-CSE-MsgGUID: CL9KXuLMQWea2BDtjB3irg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="195791541"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.101])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 21:33:07 -0800
Date: Tue, 18 Nov 2025 07:33:04 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jon Kohler <jon@nutanix.com>
Subject: Re: [PATCH 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside
 of the fastpath
Message-ID: <aRwFEAAfvdgP6O6d@tlindgre-MOBL1>
References: <20251030224246.3456492-1-seanjc@google.com>
 <20251030224246.3456492-3-seanjc@google.com>
 <aRsXVvDHsdCjEgPM@tlindgre-MOBL1>
 <aRtDpQ9DTonYw9Bi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRtDpQ9DTonYw9Bi@google.com>

On Mon, Nov 17, 2025 at 07:47:49AM -0800, Sean Christopherson wrote:
> On Mon, Nov 17, 2025, Tony Lindgren wrote:
> > Hi,
> > 
> > On Thu, Oct 30, 2025 at 03:42:44PM -0700, Sean Christopherson wrote:
> > > --- a/arch/x86/kvm/vmx/main.c
> > > +++ b/arch/x86/kvm/vmx/main.c
> > > @@ -608,6 +608,17 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> > >  	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
> > >  }
> > >  
> > > +static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> > > +{
> > > +	if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
> > > +		kvm_machine_check();
> > > +
> > > +	if (is_td_vcpu(vcpu))
> > > +		return;
> > > +
> > > +	return vmx_handle_exit_irqoff(vcpu);
> > > +}
> > 
> > I bisected kvm-x86/next down to this change for a TDX guest not booting
> > and host producing errors like:
> > 
> > watchdog: CPU118: Watchdog detected hard LOCKUP on cpu 118
> > 
> > Dropping the is_td_vcpu(vcpu) check above fixes the issue. Earlier the
> > call for vmx_handle_exit_irqoff() was unconditional.
> 
> Ugh, once you see it, it's obvious.  Sorry :-(
> 
> I'll drop the entire series and send a v2.  There's only one other patch that I
> already sent the "thank you" for, so I think it's worth unwinding to avoid
> breaking bisection for TDX (and because the diff can be very different).

OK thanks.
 
> Lightly tested, but I think this patch can instead be:
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 163f854a39f2..6d41d2fc8043 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1063,9 +1063,6 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>         if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
>                 return EXIT_FASTPATH_NONE;
>  
> -       if (unlikely(vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
> -               kvm_machine_check();
> -
>         trace_kvm_exit(vcpu, KVM_ISA_VMX);
>  
>         if (unlikely(tdx_failed_vmentry(vcpu)))
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d98107a7bdaa..d1117da5463f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7035,10 +7035,19 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>         if (to_vt(vcpu)->emulation_required)
>                 return;
>  
> -       if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXTERNAL_INTERRUPT)
> +       switch (vmx_get_exit_reason(vcpu).basic) {
> +       case EXIT_REASON_EXTERNAL_INTERRUPT:
>                 handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
> -       else if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXCEPTION_NMI)
> +               break;
> +       case EXIT_REASON_EXCEPTION_NMI:
>                 handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
> +               break;
> +       case EXIT_REASON_MCE_DURING_VMENTRY:
> +               kvm_machine_check();
> +               break;
> +       default:
> +               break;
> +       }
>  }
>  
>  /*
> @@ -7501,9 +7510,6 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>         if (unlikely(vmx->fail))
>                 return EXIT_FASTPATH_NONE;
>  
> -       if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
> -               kvm_machine_check();
> -
>         trace_kvm_exit(vcpu, KVM_ISA_VMX);
>  
>         if (unlikely(vmx_get_exit_reason(vcpu).failed_vmentry))

Looks good to me.

Regards,

Tony

