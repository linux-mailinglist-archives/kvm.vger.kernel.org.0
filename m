Return-Path: <kvm+bounces-11941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 264E187D520
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 21:43:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BAC29B21E52
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 20:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CF71F95E;
	Fri, 15 Mar 2024 20:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jfY9PGHJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE6B17BA8;
	Fri, 15 Mar 2024 20:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710535378; cv=none; b=rnZbzJ7YBSIqKLRCdgKQa2pT7Q49rvKIq7IK6SfATaRN9rezdg86sOvE8f7l/qYDn6adKgGSbiKdAdIuLgE6bAUZvt6vZK9AcInzar5NBfY7o02QnqL4TZz8TjQEElrl2Y8r9pYXMTXYKYlp8lPL2Ez9uI/NPejO0yT376bR13U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710535378; c=relaxed/simple;
	bh=sIUywcrIGziaj+6fPipKbPdvjxmOEgFJSj2PoIaDXxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TlUsXsZzZWGLzfSgd4WB9PCKpVgzsx2W6G1A3kaObX8G8VvCPDUXI39efYeyV+AKjEmSDeg7QxKo27ugrMC+bYZEIZBNpoGpdpGcMGWRxJ7wOOu6gto6dtFHyO7mSPydT5QpJmOBEL9gWyKvDYAVRhGkj71s8Ao9YmoySbbGVM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jfY9PGHJ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710535374; x=1742071374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sIUywcrIGziaj+6fPipKbPdvjxmOEgFJSj2PoIaDXxM=;
  b=jfY9PGHJMZ6oKLSTe4KUE9yb2voKyh6PA1QfdeI5nU0WyG6Tyn1gXdWW
   XkJXXqtrJtF4ZlUhu7HDHve3uC7KA3NB9ojnCEyp4cUC684awMxUdhm6U
   vKvuwaYX/FP51KIfudakSKeMdPA1ewc8Z+dZ/HyJR68EoT7wrKsLHj+9l
   wPqrmPBOeYwF+ZKwQ/RcaCqxSkY/ngdArG+ay+SMiOAT5l0s7f/dCL2Dz
   PPvQS/qNywcQDOdrov4VVLobp/AyQdLIAF0H9zhOtLeiUpVCSihEucgmv
   5fy5+dQNBBEDfVHvEXVIJ5/orzjNKan5fBSz3OIYaIfy1knr3vM4qECl5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5281749"
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="5281749"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 13:42:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="12754169"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 13:42:53 -0700
Date: Fri, 15 Mar 2024 13:42:53 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
Message-ID: <20240315204253.GI1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
 <ZfSExlemFMKjBtZb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfSExlemFMKjBtZb@google.com>

On Fri, Mar 15, 2024 at 10:26:30AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index d822e790e3e5..81d301fbe638 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -27,6 +27,37 @@ struct kvm_tdx {
> >  	struct page *source_page;
> >  };
> >  
> > +union tdx_exit_reason {
> > +	struct {
> > +		/* 31:0 mirror the VMX Exit Reason format */
> 
> Then use "union vmx_exit_reason", having to maintain duplicate copies of the same
> union is not something I want to do.
> 
> I'm honestly not even convinced that "union tdx_exit_reason" needs to exist.  I
> added vmx_exit_reason because we kept having bugs where KVM would fail to strip
> bits 31:16, and because nested VMX needs to stuff failed_vmentry, but I don't
> see a similar need for TDX.
> 
> I would even go so far as to say the vcpu_tdx field shouldn't be exit_reason,
> and instead should be "return_code" or something.  E.g. if the TDX module refuses
> to run the vCPU, there's no VM-Enter and thus no VM-Exit (unless you count the
> SEAMCALL itself, har har).  Ditto for #GP or #UD on the SEAMCALL (or any other
> reason that generates TDX_SW_ERROR).
> 
> Ugh, I'm doubling down on that suggesting.  This:
> 
> 	WARN_ON_ONCE(!kvm_rebooting &&
> 		     (tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR);
> 
> 	if ((u16)tdx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
> 	    is_nmi(tdexit_intr_info(vcpu))) {
> 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
> 		vmx_do_nmi_irqoff();
> 		kvm_after_interrupt(vcpu);
> 	}
> 
> is heinous.  If there's an error that leaves bits 15:0 zero, KVM will synthesize
> a spurious NMI.  I don't know whether or not that can happen, but it's not
> something that should even be possible in KVM, i.e. the exit reason should be
> processed if and only if KVM *knows* there was a sane VM-Exit from non-root mode.
> 
> tdx_vcpu_run() has a similar issue, though it's probably benign.  If there's an
> error in bits 15:0 that happens to collide with EXIT_REASON_TDCALL, weird things
> will happen.
> 
> 	if (tdx->exit_reason.basic == EXIT_REASON_TDCALL)
> 		tdx->tdvmcall.rcx = vcpu->arch.regs[VCPU_REGS_RCX];
> 	else
> 		tdx->tdvmcall.rcx = 0;
> 
> I vote for something like the below, with much more robust checking of vp_enter_ret
> before it's converted to a VMX exit reason.
> 
> static __always_inline union vmx_exit_reason tdexit_exit_reason(struct kvm_vcpu *vcpu)
> {
> 	return (u32)vcpu->vp_enter_ret;
> }

Thank you for the concrete suggestion.  Let me explore what safe guard check
can be done to make exit path robust.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

