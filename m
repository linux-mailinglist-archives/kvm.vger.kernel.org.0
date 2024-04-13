Return-Path: <kvm+bounces-14584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 517358A3912
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 02:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2F901F22894
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 00:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 352ED17C8;
	Sat, 13 Apr 2024 00:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lKTorjlP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0D5173;
	Sat, 13 Apr 2024 00:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712967630; cv=none; b=eo/czndv0kzintZmfwLrPtxYvg5xor4o8TehY1fwaZvlrzddwBok/hVA6rlmd7rELBoufJbjyX4VE9uQwBPWVXCDEQLXtGXjiAilbbmRLQRxruKZVSEFdvo20wRVDjANOKLLHGiBTNEahe3BiX/M8VVFSSAhRV9EyLjRk/X5Np0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712967630; c=relaxed/simple;
	bh=18zdulWfNXqxnZk+DxpyaW+RxzbmWkSojubS4Cu+eC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTj4nT95QWxmOi/9Is9jziYRSwWodbpU1JVkK+A7b60z/urNZMOW86xHlmlUfRkj/aix5dw2PXKcc/+G6SaM3BRht+j4qB1Nu8vr7dD+xz/BUOUPj+HJVr8GzYt1+RWeAETRb5NUkCbaso9WvQhqirr3cUqBVvCOXvzZhDE54lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lKTorjlP; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712967629; x=1744503629;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=18zdulWfNXqxnZk+DxpyaW+RxzbmWkSojubS4Cu+eC0=;
  b=lKTorjlPauTec4qIk6t9qSqfODtyJA/Czb3ieyZGGvkqe+K+TxtBmy5Q
   zDoQGQ8CwG9TyIXjq/AaWH6zYNg48zKdrFyjZG5QjshzEjHCHj7kPsS3d
   9MRTGxZsCQkecwhTDxVBdcOST9MH8fY6PY6sMsz8C8XcALTNP397AvZCx
   k20clX0RUWOUisW7Ms/24++nffvFFnEhM9z/4xdvWVxOIsWT4pMwivhtt
   RlPK3/lGQJC+pEWTqvMtebrry/XifXWYR37KKYr0yx2pxOd/NVI/ahvqy
   B03AQ8mD3aVURrTHsQCCUsozheynnfOw1v4Zmp5i1LVHxFam6FwA7PkFl
   Q==;
X-CSE-ConnectionGUID: UFh8Iu6/Q8GdTDQshDOt/Q==
X-CSE-MsgGUID: xVGpPWb2RIO/bXI1tb2bXg==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="19835101"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="19835101"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 17:20:28 -0700
X-CSE-ConnectionGUID: 8njdxwpMSz28Atsn66Oz5Q==
X-CSE-MsgGUID: +LQ08F12RPmjdxp9sE/6cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="26071131"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 17:20:28 -0700
Date: Fri, 12 Apr 2024 17:20:26 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Chao Gao <chao.gao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 088/130] KVM: x86: Add a switch_db_regs flag to
 handle TDX's auto-switched behavior
Message-ID: <20240413002026.GP3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ca5d0399cdbbaa6c7c6528ad85b3560cec0f0752.1708933498.git.isaku.yamahata@intel.com>
 <aaa69c7d-7f33-44a3-b23c-82447a8452ce@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaa69c7d-7f33-44a3-b23c-82447a8452ce@linux.intel.com>

On Sun, Apr 07, 2024 at 06:52:44PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add a flag, KVM_DEBUGREG_AUTO_SWITCHED_GUEST, to skip saving/restoring DRs
> > irrespective of any other flags.
> 
> Here "irrespective of any other flags" sounds like other flags will be
> ignored if KVM_DEBUGREG_AUTO_SWITCHED_GUEST is set.
> But the code below doesn't align with it.

Sure, let's update the commit message.


> >    TDX-SEAM unconditionally saves and
> > restores guest DRs and reset to architectural INIT state on TD exit.
> > So, KVM needs to save host DRs before TD enter without restoring guest DRs
> > and restore host DRs after TD exit.
> > 
> > Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().
> > 
> > Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h | 10 ++++++++--
> >   arch/x86/kvm/vmx/tdx.c          |  1 +
> >   arch/x86/kvm/x86.c              | 11 ++++++++---
> >   3 files changed, 17 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 3ab85c3d86ee..a9df898c6fbd 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -610,8 +610,14 @@ struct kvm_pmu {
> >   struct kvm_pmu_ops;
> >   enum {
> > -	KVM_DEBUGREG_BP_ENABLED = 1,
> > -	KVM_DEBUGREG_WONT_EXIT = 2,
> > +	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
> > +	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
> > +	/*
> > +	 * Guest debug registers (DR0-3 and DR6) are saved/restored by hardware
> > +	 * on exit from or enter to guest. KVM needn't switch them. Because DR7
> > +	 * is cleared on exit from guest, DR7 need to be saved/restored.
> > +	 */
> > +	KVM_DEBUGREG_AUTO_SWITCH	= BIT(2),
> >   };
> >   struct kvm_mtrr_range {
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 7aa9188f384d..ab7403a19c5d 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -586,6 +586,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >   	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> > +	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
> >   	vcpu->arch.cr0_guest_owned_bits = -1ul;
> >   	vcpu->arch.cr4_guest_owned_bits = -1ul;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1b189e86a1f1..fb7597c22f31 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11013,7 +11013,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >   	if (vcpu->arch.guest_fpu.xfd_err)
> >   		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> > -	if (unlikely(vcpu->arch.switch_db_regs)) {
> > +	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
> >   		set_debugreg(0, 7);
> >   		set_debugreg(vcpu->arch.eff_db[0], 0);
> >   		set_debugreg(vcpu->arch.eff_db[1], 1);
> > @@ -11059,6 +11059,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >   	 */
> >   	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
> >   		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
> > +		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH);
> >   		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
> >   		kvm_update_dr0123(vcpu);
> >   		kvm_update_dr7(vcpu);
> > @@ -11071,8 +11072,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >   	 * care about the messed up debug address registers. But if
> >   	 * we have some of them active, restore the old state.
> >   	 */
> > -	if (hw_breakpoint_active())
> > -		hw_breakpoint_restore();
> > +	if (hw_breakpoint_active()) {
> > +		if (!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))
> > +			hw_breakpoint_restore();
> > +		else
> > +			set_debugreg(__this_cpu_read(cpu_dr7), 7);
> 
> According to TDX module 1.5 ABI spec:
> DR0-3, DR6 and DR7 are set to their architectural INIT value, why is only
> DR7 restored?

This hunk should be dropped. Thank you for finding this.

I checked the base SPEC, the ABI spec, and the TDX module code.  It seems the
documentation bug of the TDX module 1.5 base architecture specification.


The TDX module code:
- restores guest DR<N> on TD Entry to guest.
- saves guest DR<N> on TD Exit from guest TD
- initializes DR<N> on TD Exit to host VMM

TDX module 1.5 base architecture specification:
15.1.2.1 Context Switch
By design, the Intel TDX module context-switches all debug/tracing state that
the guest TD is allowed to use.
        DR0-3, DR6 and IA32_DS_AREA MSR are context-switched in TDH.VP.ENTER and
        TD exit flows
        RFLAGS, IA32_DEBUGCTL MSR and DR7 are saved and cleared on VM exits from
        the guest TD and restored on VM entry to the guest TD.

TDX module 1.5 ABI specification:
5.3.65. TDH.VP.ENTER Leaf
CPU State Preservation Following a Successful TD Entry and a TD Exit
Following a successful TD entry and a TD exit, some CPU state is modified:
        Registers DR0, DR1, DR2, DR3, DR6 and DR7 are set to their architectural
        INIT value.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

