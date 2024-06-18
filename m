Return-Path: <kvm+bounces-19837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 435DE90C277
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 05:28:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 493E6B20F7B
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 03:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A77C19B58D;
	Tue, 18 Jun 2024 03:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GpXIrxhL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0812A33DF;
	Tue, 18 Jun 2024 03:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718681320; cv=none; b=rgWDYoQytJaSWRDl3GeVnbLdHDdMXMZ5Lz6nYqaAvNjVyRSlucpQcJpBLdNvxYxQm0N2z/voWjZ4AwayLFv2Rfs24H5Lq6mer6LRQf5+sVZQoayTB1wcbd9XEO4xPCgyJzLpB0ESlU+r9S5aeJqp8Me+0R3jYpPRVmevwWawCbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718681320; c=relaxed/simple;
	bh=ynM9ShbfFif8uOoK2k0aPFZ9XtuYmV3vn2cQ+gF8Jek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxuw/XZ02f89eGt6uQXlgKPJMui5hL6UGWCvQ96MZOejIZIUqj9pn8Eq3uVCFpkJN1aBoVyTU37212bTxcTD0qYTNg2v9oWULd/GDT+hETrpM1EObiv7PihCl9luUDL/sGYfvnYeRNyJrGmR9cRr6x8zRzSZgZfD623eha0n+sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GpXIrxhL; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718681319; x=1750217319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ynM9ShbfFif8uOoK2k0aPFZ9XtuYmV3vn2cQ+gF8Jek=;
  b=GpXIrxhLEKC6B3z0uKiqJR+yFsCj1n7gl4WzfzyGA91Zosg8rzGKxWU6
   7ZIihLtMYuBVnh7VzrpPCK/tlB1WwrPzL7dSPjW9ozBtg8qM9vKODpIkp
   wmGbqJgtSR2cxWIaiq8t1WDYtYdVszqqUECo4IR1qxyEJ5rUoIwJ+1KP4
   i3+xB6nC0haBAbuiSj/wkbiyelYzZG2/jJ+PqmlV51JluUzaA26pVN+Lc
   QyxLiXLg8kuWOiogsLA1ENqrOo03/RNrl21c+jsOUdrFGVdT3wqPIgOG6
   foGOBbXOTrp789IjwhsNMJfgvDp9fj37mnfnJnk7nBhMblXHFo4Rx/6Bt
   A==;
X-CSE-ConnectionGUID: VeIHqVFFTyWbYtlmTFxd+Q==
X-CSE-MsgGUID: AbP5IA8hQSWJabby4S3aUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="15367658"
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="15367658"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 20:28:38 -0700
X-CSE-ConnectionGUID: 2QDsvqbKRDu8wtzBPw988Q==
X-CSE-MsgGUID: NIXYOHcjQhaHFY5INH5WOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="41268516"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa007.fm.intel.com with ESMTP; 17 Jun 2024 20:28:35 -0700
Date: Tue, 18 Jun 2024 11:28:34 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v19 085/130] KVM: TDX: Complete interrupts after tdexit
Message-ID: <20240618032834.a6tuv353vk6vqybw@yy-desk-7060>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
 <20240617080729.j5nottky5bjmgdmf@yy-desk-7060>
 <c1426d14-3c00-4956-89a3-c06336905330@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1426d14-3c00-4956-89a3-c06336905330@linux.intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jun 17, 2024 at 05:07:56PM +0800, Binbin Wu wrote:
>
>
> On 6/17/2024 4:07 PM, Yuan Yao wrote:
> > On Mon, Feb 26, 2024 at 12:26:27AM -0800, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >
> > > This corresponds to VMX __vmx_complete_interrupts().  Because TDX
> > > virtualize vAPIC, KVM only needs to care NMI injection.
> > >
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> > > ---
> > > v19:
> > > - move tdvps_management_check() to this patch
> > > - typo: complete -> Complete in short log
> > > ---
> > >   arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
> > >   arch/x86/kvm/vmx/tdx.h |  4 ++++
> > >   2 files changed, 14 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 83dcaf5b6fbd..b8b168f74dfe 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -535,6 +535,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > >   	 */
> > >   }
> > >
> > > +static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
> > > +{
> > > +	/* Avoid costly SEAMCALL if no nmi was injected */
> > > +	if (vcpu->arch.nmi_injected)
> > > +		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
> > > +							      TD_VCPU_PEND_NMI);
> > > +}
> > Looks this leads to NMI injection delay or even won't be
> > reinjected if KVM_REQ_EVENT is not set on the target cpu
> > when more than 1 NMIs are pending there.
> >
> > On normal VM, KVM uses NMI window vmexit for injection
> > successful case to rasie the KVM_REQ_EVENT again for remain
> > pending NMIs, see handle_nmi_window(). KVM also checks
> > vectoring info after VMEXIT for case that the NMI is not
> > injected successfully in this vmentry vmexit round, and
> > raise KVM_REQ_EVENT to try again, see __vmx_complete_interrupts().
> >
> > In TDX, consider there's no way to get vectoring info or
> > handle nmi window vmexit, below checking should cover both
> > scenarios for NMI injection:
> >
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index e9c9a185bb7b..9edf446acd3b 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -835,9 +835,12 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >   static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
> >   {
> >          /* Avoid costly SEAMCALL if no nmi was injected */
> > -       if (vcpu->arch.nmi_injected)
> > +       if (vcpu->arch.nmi_injected) {
> >                  vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
> >                                                                TD_VCPU_PEND_NMI);
> > +               if (vcpu->arch.nmi_injected || vcpu->arch.nmi_pending)
> > +                       kvm_make_request(KVM_REQ_EVENT, vcpu);
>
> For nmi_injected, it should be OK because TD_VCPU_PEND_NMI is still set.
> But for nmi_pending, it should be checked and raise event.

Right, I just forgot the tdx module can do more than "hardware":

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e9c9a185bb7b..3530a4882efc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -835,9 +835,16 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
 {
        /* Avoid costly SEAMCALL if no nmi was injected */
-       if (vcpu->arch.nmi_injected)
+       if (vcpu->arch.nmi_injected) {
                vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
                                                              TD_VCPU_PEND_NMI);
+               /*
+                  tdx module will retry injection in case of TD_VCPU_PEND_NMI,
+                  so don't need to set KVM_REQ_EVENT for it again.
+                */
+               if (!vcpu->arch.nmi_injected && vcpu->arch.nmi_pending)
+                       kvm_make_request(KVM_REQ_EVENT, vcpu);
+       }
 }

>
> I remember there was a discussion in the following link:
> https://lore.kernel.org/kvm/20240402065254.GY2444378@ls.amr.corp.intel.com/
> It said  tdx_vcpu_run() will ignore force_immediate_exit.
> If force_immediate_exit is igored for TDX, then the nmi_pending handling
> could still be delayed if the previous NMI was injected successfully.

Yes, not sure the possibility of meeting this in real use
case, I know it happens in some testing, e.g. the kvm
unit test's multiple NMI tesing.

>
>
> > +       }
> >   }
> >
> > > +
> > >   struct tdx_uret_msr {
> > >   	u32 msr;
> > >   	unsigned int slot;
> > > @@ -663,6 +671,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> > >   	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> > >   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
> > >
> > > +	tdx_complete_interrupts(vcpu);
> > > +
> > >   	return EXIT_FASTPATH_NONE;
> > >   }
> > >
> > > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > > index 44eab734e702..0d8a98feb58e 100644
> > > --- a/arch/x86/kvm/vmx/tdx.h
> > > +++ b/arch/x86/kvm/vmx/tdx.h
> > > @@ -142,6 +142,8 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> > >   			 "Invalid TD VMCS access for 16-bit field");
> > >   }
> > >
> > > +static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
> > > +
> > >   #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
> > >   static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
> > >   							u32 field)		\
> > > @@ -200,6 +202,8 @@ TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
> > >   TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
> > >   TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
> > >
> > > +TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
> > > +
> > >   static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
> > >   {
> > >   	struct tdx_module_args out;
> > > --
> > > 2.25.1
> > >
> > >
>

