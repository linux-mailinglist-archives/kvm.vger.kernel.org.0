Return-Path: <kvm+bounces-11615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA77878CB5
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 03:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AF18B219C3
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 247BFAD24;
	Tue, 12 Mar 2024 02:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R6FdAWUk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20298F40;
	Tue, 12 Mar 2024 02:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710209000; cv=none; b=u1lq6XS+0FLUlyXYHEtHQS6PU6Ifnb+opHn93gKu4FsFc7wsM0pw2AtHlHtDUT+Kh7ZHsVAjCImjKOM2CYcKO5EukOKrRh27Od1rqRK5+4XSLCOXFw49LwHZNfGQroaarkzLtM3kY/7qK8QeEdxgqhgXPrQf3QoHJSE+SlKO8KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710209000; c=relaxed/simple;
	bh=F1UWRYBFJdCW+74ZqeqL7g6SBFDCsG5OQ97xi6+pv1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzpfEIbF6kk11ElRKpvdrbhC3SMz64o5hZTWPGulnFzqdG9+zgGo0tgvVyicr5t9GeHWMU/TTZUMHIOKaubsxBnKynnSz5X3qm8sHrefywD5N3mDccI+F8CCGt83XBL/RXeR7ouD1qiz+pw2k1Yekb2HgUo2yH2JMJcG96Nwdo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R6FdAWUk; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710208998; x=1741744998;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F1UWRYBFJdCW+74ZqeqL7g6SBFDCsG5OQ97xi6+pv1Q=;
  b=R6FdAWUkbmYMqODVqPipF1wFuyCGIHE/HW8hP930mu9x2niIq0T/Ui96
   adSBHM6WWgP/Dl4hhQjtIXIyDL/dwR8SvSp786AK+PO72s+WUK63Cmq8X
   ySAYujxsHnwBG521yB9OSuY5PbbFXhn9Bjjhi/ISYm92BnaTQK9AT1Z0L
   myDw0P2Mm6RquxImJIXMs1pYwZ+0uU9fNo7QL2q+nabyM/KXAZOpcQSeV
   U575GsoXrS/hJqvRHiyuUd4GfYodIfR2okmRNCy7HBkuq4Mdk+wSnLI75
   g80guP23sv374s7OhtNb47wCPQdcPNrCx31LM+0nshPZltmjVV6n9dC8U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5506654"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="5506654"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:03:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="16062904"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:03:16 -0700
Date: Mon, 11 Mar 2024 19:03:15 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chen Yu <yu.c.chen@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 080/130] KVM: TDX: restore host xsave state when exit
 from the guest TD
Message-ID: <20240312020315.GF935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <2894ed10014279f4b8caab582e3b7e7061b5dad3.1708933498.git.isaku.yamahata@intel.com>
 <Zel7kFS31SSVsSaJ@chenyu5-mobl2>
 <20240308205838.GA713729@ls.amr.corp.intel.com>
 <ZeyOR/YaubFwyiOC@chenyu5-mobl2>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZeyOR/YaubFwyiOC@chenyu5-mobl2>

On Sun, Mar 10, 2024 at 12:28:55AM +0800,
Chen Yu <yu.c.chen@intel.com> wrote:

> On 2024-03-08 at 12:58:38 -0800, Isaku Yamahata wrote:
> > On Thu, Mar 07, 2024 at 04:32:16PM +0800,
> > Chen Yu <yu.c.chen@intel.com> wrote:
> > 
> > > On 2024-02-26 at 00:26:22 -0800, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > > On exiting from the guest TD, xsave state is clobbered.  Restore xsave
> > > > state on TD exit.
> > > > 
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > ---
> > > > v19:
> > > > - Add EXPORT_SYMBOL_GPL(host_xcr0)
> > > > 
> > > > v15 -> v16:
> > > > - Added CET flag mask
> > > > 
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
> > > >  arch/x86/kvm/x86.c     |  1 +
> > > >  2 files changed, 20 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index 9616b1aab6ce..199226c6cf55 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -2,6 +2,7 @@
> > > >  #include <linux/cpu.h>
> > > >  #include <linux/mmu_context.h>
> > > >  
> > > > +#include <asm/fpu/xcr.h>
> > > >  #include <asm/tdx.h>
> > > >  
> > > >  #include "capabilities.h"
> > > > @@ -534,6 +535,23 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > > >  	 */
> > > >  }
> > > >  
> > > > +static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > > > +
> > > > +	if (static_cpu_has(X86_FEATURE_XSAVE) &&
> > > > +	    host_xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
> > > > +		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
> > > > +	if (static_cpu_has(X86_FEATURE_XSAVES) &&
> > > > +	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
> > > > +	    host_xss != (kvm_tdx->xfam &
> > > > +			 (kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET)))
> > > > +		wrmsrl(MSR_IA32_XSS, host_xss);
> > > > +	if (static_cpu_has(X86_FEATURE_PKU) &&
> > > > +	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
> > > > +		write_pkru(vcpu->arch.host_pkru);
> > > > +}
> > > 
> > > Maybe one minor question regarding the pkru restore. In the non-TDX version
> > > kvm_load_host_xsave_state(), it first tries to read the current setting
> > > vcpu->arch.pkru = rdpkru(); if this setting does not equal to host_pkru,
> > > it trigger the write_pkru on host. Does it mean we can also leverage that mechanism
> > > in TDX to avoid 1 pkru write(I guess pkru write is costly than a read pkru)?
> > 
> > Yes, that's the intention.  When we set the PKRU feature for the guest, TDX
> > module unconditionally initialize pkru.
> 
> I see, thanks for the information. Please correct me if I'm wrong, and I'm not sure
> if wrpkru instruction would trigger the TD exit. The TDX module spec[1] mentioned PKS
> (protected key for supervisor pages), but does not metion PKU for user pages. PKS
> is controlled by MSR IA32_PKRS. The TDX module will passthrough the MSR IA32_PKRS
> write in TD, because TDX module clears the PKS bitmap in VMCS:
> https://github.com/intel/tdx-module/blob/tdx_1.5/src/common/helpers/helpers.c#L1723
> so neither write to MSR IA32_PKRS nor wrpkru triggers TD exit.

wrpkru instruction in TDX guest doesn't cause exit to TDX module.  TDX module
runs with CR4.PKE=0.  The value of pkru doesn't matter to the TDX module.
When exiting from TDX module to the host VMM, PKRU is initialized to zero with
xrestr.  So it doesn't matter.

We need to refer to NP-SEAMLDR for the register value for TDX module on
SEAMCALL. It sets up the register values for TDX module on SEAMCALL.


> However, after a second thought, I found that after commit 72a6c08c44e4, the current
> code should not be a problem, because write_pkru() would first read the current pkru
> settings and decide whether to update to the pkru register.
> 
> > Do you have use case that wrpkru()
> > (without rdpkru()) is better?
> 
> I don't have use case yet. But with/without rdpkru() in tdx_restore_host_xsave_state(),
> there is no much difference because write_pkru() has taken care of it if I understand
> correctly.

The code in this hunk is TDX version of kvm_load_guest_xsave_state().  We case 
follow the VMX case at the moment.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

