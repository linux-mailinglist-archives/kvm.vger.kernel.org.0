Return-Path: <kvm+bounces-13621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F30A2899218
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 01:25:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E135B24AC6
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336DB13C677;
	Thu,  4 Apr 2024 23:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z888bGyG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9E4130A7F;
	Thu,  4 Apr 2024 23:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712273141; cv=none; b=Y9hBcaZzvcXysBOz8cOOmIyqdtQDx3gXY8zTFBp+B9v9IormlvaKEWpRSHxbVaiHM1pYKd8LimuPJAq4DDEiJqQk51aRMcME0D1moumdm6As8Nxa4S7RqN3XfoSxemVY93l08oxVYO6UcaslQfotrhtyX46dQO12D0DudHqaCWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712273141; c=relaxed/simple;
	bh=oqu+QXF9eyokJasNcXzyH/j0LzIhCwK4AHGP209pvQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZ/m9G88OqzXCeWu5/3a+TVQt2/B0A1+0RZ9AREcQ9wx0wrySCNgY8JExvwb0lucyLQvtQiDZb5VEz86Xup/2JXck0ga47d7UNcVqqYXn/gbD90k2KILtKjbmm9/QsXpNJVLXvKAKqBCG+WEHaVkWCsk86S0cTmF9jVVQL1dSx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z888bGyG; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712273139; x=1743809139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oqu+QXF9eyokJasNcXzyH/j0LzIhCwK4AHGP209pvQk=;
  b=Z888bGyGjDHuILuha5CegLoMaMPYlEyC60/1NgjNqkhvxWC+jtv/uaOD
   6pgNMmNgzy6X3B3WAh6GotEks14n/MhG8H32Y9UIqV1oDcskGeCb25cbV
   O3c6nOofoVR0G6nr0HUDA7VVLpWZjksJE4o1LvrL9hPbDrkDahdwRVyir
   785w8QMH9fL/v3z8+8gQCph6P71zyKCYXTSH9/+oU5yYKsswyQqN54FtQ
   FBXp4Ra7O0D4j4oYiBN/PboOwsM+8wv9afbOwLsI8Wz5Mf+PirYFmcRpA
   CCEYL1TBaYkShs6qb1KOf1EpFCAcUs6Pm00mNqXSRKDj6aulp4kCP0VCd
   g==;
X-CSE-ConnectionGUID: fJn2G0OTQuqdWgaSIZFtLA==
X-CSE-MsgGUID: JFCJiFSKTzSN+NlsCIw+6Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="7454409"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="7454409"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 16:25:38 -0700
X-CSE-ConnectionGUID: hn8kO/wLQi+KqfsnEwSeWg==
X-CSE-MsgGUID: UurbyzkfS92y0G733uwP4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="23435855"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 16:25:38 -0700
Date: Thu, 4 Apr 2024 16:25:37 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 108/130] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <20240404232537.GV2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c083430632ba9e80abd09bccd5609fb3cd9d9c63.1708933498.git.isaku.yamahata@intel.com>
 <ZgzMH3944ZaBx8B3@chao-email>
 <Zg1seIaTmM94IyR8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zg1seIaTmM94IyR8@google.com>

On Wed, Apr 03, 2024 at 07:49:28AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Apr 03, 2024, Chao Gao wrote:
> > On Mon, Feb 26, 2024 at 12:26:50AM -0800, isaku.yamahata@intel.com wrote:
> > >From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >
> > >Wire up TDX PV HLT hypercall to the KVM backend function.
> > >
> > >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > >---
> > >v19:
> > >- move tdvps_state_non_arch_check() to this patch
> > >
> > >v18:
> > >- drop buggy_hlt_workaround and use TDH.VP.RD(TD_VCPU_STATE_DETAILS)
> > >
> > >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > >---
> > > arch/x86/kvm/vmx/tdx.c | 26 +++++++++++++++++++++++++-
> > > arch/x86/kvm/vmx/tdx.h |  4 ++++
> > > 2 files changed, 29 insertions(+), 1 deletion(-)
> > >
> > >diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > >index eb68d6c148b6..a2caf2ae838c 100644
> > >--- a/arch/x86/kvm/vmx/tdx.c
> > >+++ b/arch/x86/kvm/vmx/tdx.c
> > >@@ -688,7 +688,18 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > > 
> > > bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
> > > {
> > >-	return pi_has_pending_interrupt(vcpu);
> > >+	bool ret = pi_has_pending_interrupt(vcpu);
> > 
> > Maybe
> > 	bool has_pending_interrupt = pi_has_pending_interrupt(vcpu);
> > 
> > "ret" isn't a good name. or even call pi_has_pending_interrupt() directly in
> > the if statement below.
> 
> Ya, or split the if-statement into multiple chucks, with comments explaining
> what each non-intuitive chunk is doing.  The pi_has_pending_interrupt(vcpu) check
> is self-explanatory, the halted thing, not so much.  They are terminal statements,
> there's zero reason to pre-check the PID.
> 
> E.g.
> 
> 	/*
> 	 * Comment explaining why KVM needs to assume a non-halted vCPU has a
> 	 * pending interrupt (KVM can't see RFLAGS.IF).
> 	 */
> 	if (vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
> 		return true;
> 
> 	if (pi_has_pending_interrupt(vcpu))
> 		return;
> 
> > >+	union tdx_vcpu_state_details details;
> > >+	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > >+
> > >+	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
> > >+		return true;
> > 
> > Question: why mp_state matters here?
> > >+
> > >+	if (tdx->interrupt_disabled_hlt)
> > >+		return false;
> > 
> > Shouldn't we move this into vt_interrupt_allowed()? VMX calls the function to
> > check if interrupt is disabled.

Chao, are you suggesting to implement tdx_interrupt_allowed() as
"EXIT_REASON_HLT && a0" instead of "return true"?
I don't think it makes sense because it's rare case and we can't avoid spurious
wakeup for TDX case.


> >KVM can clear tdx->interrupt_disabled_hlt on
> > every TD-enter and set it only on TD-exit due to the guest making a
> > TDVMCALL(hlt) w/ interrupt disabled.
> 
> I'm pretty sure interrupt_disabled_hlt shouldn't exist, should "a0", a.k.a. r12,
> be preserved at this point?
> 
> 	/* Another comment explaning magic code. */
> 	if (to_vmx(vcpu)->exit_reason.basic == EXIT_REASON_HLT &&
> 	    tdvmcall_a0_read(vcpu))
> 		return false;
> 
> 
> Actually, can't this all be:
> 
> 	if (to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_HLT)
> 		return true;
> 
> 	if (!tdvmcall_a0_read(vcpu))
> 		return false;
> 
> 	if (pi_has_pending_interrupt(vcpu))
> 		return true;
> 
> 	return tdx_has_pending_virtual_interrupt(vcpu);
> 

Thanks for the suggestion.  This is much cleaner.  Will update the function.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

