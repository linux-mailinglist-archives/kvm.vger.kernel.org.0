Return-Path: <kvm+bounces-15357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B228AB4D4
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C121E281E7C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6CAA13C909;
	Fri, 19 Apr 2024 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dvOFEz1D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D49013C3F9;
	Fri, 19 Apr 2024 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713550315; cv=none; b=rOJ4zSBpZW+NYi//xNPDWv1zsjYSK16jPgplddriqG6Vgd+cWJYHDQGqNCjRv9pUfdYFM97Obsvwbfj3e1+dyLmvFCTq7Vbzb9sQtTQLtO6JkBGcWCY7vBgQlicpv6bgHxPiqHR2k+nqpQos3HcDfuMGok9uNRD+WIa6s6qBgpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713550315; c=relaxed/simple;
	bh=3mxrOnmBvzmj0ZYSR/MunZ79FD1UTN8MfV9B9pSDJ8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pvtwCDOhe80vifJXqcrmwlu/lltXfNj3spbwXNU8vp6or3X7vfnZo8+lIMSbBEIaO7+5lNvHzkSBobM9GZ/5kAjO+EG1gtx4U3Rz6xGyQLDdO6MAGUYrAilZ3+6wK+Xaeu0D+4spRjhM2f7hDmtGjwNhaT0EWYCkxjXkMu8OTHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dvOFEz1D; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713550313; x=1745086313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3mxrOnmBvzmj0ZYSR/MunZ79FD1UTN8MfV9B9pSDJ8o=;
  b=dvOFEz1D7I+d7vjcwEKwrjpKU2S6EtXLKUu2OtZ0L/q0itwUtxsArV5k
   1leyHJzMUMnU8nqyHtNWuvb8bXCCyK+zX0iERT/GMnWndE7nXKZillVew
   7zOooxuFxSN+SNiVbTChvzgwbtCC/FoqCIJgRg/+rKiS7Xp4olvqe1Nh5
   lep/em2W2Eax1Zid4SSZ+wRVWs1zKFcf/q5kpiCFNIBkYogzi4sHqLV81
   uxg0f7x4SoAnzf+AkCph8I7hkQixOK9TYEzMrztNxz+0PQmlZJSnCg4x8
   e0Ef9H2sa1nwilWPV+y23O+qJ9y/6zWO3734zOnxDBHwLhMH1PA66CF7b
   Q==;
X-CSE-ConnectionGUID: nhcGRRI8RMmHDnDAITM79A==
X-CSE-MsgGUID: 2Jha/jR5T/uQ3LHTeZDQyQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="9287939"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="9287939"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:11:52 -0700
X-CSE-ConnectionGUID: po3BlA2/R82Z9iSdF23eGA==
X-CSE-MsgGUID: V6xWtUSLQTyr66bSW8UXoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="23473257"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:11:52 -0700
Date: Fri, 19 Apr 2024 11:11:51 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 116/130] KVM: TDX: Silently discard SMI request
Message-ID: <20240419181151.GG3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9c4547ea234a2ba09ebe05219f180f08ac6fc2e3.1708933498.git.isaku.yamahata@intel.com>
 <ZiJ3Krs_HoqdfyWN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZiJ3Krs_HoqdfyWN@google.com>

On Fri, Apr 19, 2024 at 06:52:42AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX doesn't support system-management mode (SMM) and system-management
> > interrupt (SMI) in guest TDs.  Because guest state (vcpu state, memory
> > state) is protected, it must go through the TDX module APIs to change guest
> > state, injecting SMI and changing vcpu mode into SMM.  The TDX module
> > doesn't provide a way for VMM to inject SMI into guest TD and a way for VMM
> > to switch guest vcpu mode into SMM.
> > 
> > We have two options in KVM when handling SMM or SMI in the guest TD or the
> > device model (e.g. QEMU): 1) silently ignore the request or 2) return a
> > meaningful error.
> > 
> > For simplicity, we implemented the option 1).
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/smm.h         |  7 +++++-
> >  arch/x86/kvm/vmx/main.c    | 45 ++++++++++++++++++++++++++++++++++----
> >  arch/x86/kvm/vmx/tdx.c     | 29 ++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/x86_ops.h | 12 ++++++++++
> >  4 files changed, 88 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> > index a1cf2ac5bd78..bc77902f5c18 100644
> > --- a/arch/x86/kvm/smm.h
> > +++ b/arch/x86/kvm/smm.h
> > @@ -142,7 +142,12 @@ union kvm_smram {
> >  
> >  static inline int kvm_inject_smi(struct kvm_vcpu *vcpu)
> >  {
> > -	kvm_make_request(KVM_REQ_SMI, vcpu);
> > +	/*
> > +	 * If SMM isn't supported (e.g. TDX), silently discard SMI request.
> > +	 * Assume that SMM supported = MSR_IA32_SMBASE supported.
> > +	 */
> > +	if (static_call(kvm_x86_has_emulated_msr)(vcpu->kvm, MSR_IA32_SMBASE))
> > +		kvm_make_request(KVM_REQ_SMI, vcpu);
> >  	return 0;
> 
> No, just do what KVM already does for CONFIG_KVM_SMM=n, and return -ENOTTY.  The
> *entire* point of have a return code is to handle setups that don't support SMM.
> 
> 	if (!static_call(kvm_x86_has_emulated_msr)(vcpu->kvm, MSR_IA32_SMBASE)))
> 		return -ENOTTY;
> 
> And with that, I would drop the comment, it's pretty darn clear what "assumption"
> is being made.  In quotes because it's not an assumption, it's literally KVM's
> implementation.
> 
> And then the changelog can say "do what KVM does for CONFIG_KVM_SMM=n" without
> having to explain why we decided to do something completely arbitrary for TDX.

Ok.

> >  }
> >  
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index ed46e7e57c18..4f3b872cd401 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -283,6 +283,43 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
> >  	vmx_msr_filter_changed(vcpu);
> >  }
> >  
> > +#ifdef CONFIG_KVM_SMM
> > +static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return tdx_smi_allowed(vcpu, for_injection);
> 
> Adding stubs for something that TDX will never support is silly.  Bug the VM and
> return an error.
> 
> 	if (KVM_BUG_ON(is_td_vcpu(vcpu)))
> 		return -EIO;
> 
> And I wouldn't even bother with vt_* wrappers, just put that right in vmx_*().
> Same thing for everything below.

Will drop them.  Those are traces to support guest debug.  It's future topic
and we have arch.guest_state_protected check now.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

