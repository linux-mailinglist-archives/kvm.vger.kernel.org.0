Return-Path: <kvm+bounces-5904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 355A3828B5A
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 18:36:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34A951C23613
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 17:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214073B796;
	Tue,  9 Jan 2024 17:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hBECdHRS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380E21428A;
	Tue,  9 Jan 2024 17:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704821789; x=1736357789;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=s4vL+G1cOK7kjS65R4pAqPPH01qRu/3MqWj3+dh4ipw=;
  b=hBECdHRSO183jMP9rFoApbuIDWn8f5muzGykskxv3Nc69FJ1CZ01ABy+
   rHNbMDI8MdyyUkaD9PUumHG41yJuy0hrLgMVxPla/QPq9/0JDAzNF/lqD
   xFI7NLwybAH2RAsUtbZEUisXODRG1Xf4EGfsQDLWaLhAwOd0h+vjauHZY
   UKAmLQ5aRjdA2V37FOQd6ufVp61F6UiIZ1h1VlflxoV+bcVxdAzpJFHoq
   IyaG3AJFybJ2avuZKU1Z7x5rNdN8H0yn76mmnNKQq0aZ2CZYezsLhBqrm
   du5o7Ymb20EhnJhlDNRCPCcfo0iuyg6HXCFue8DiW4HD5Sqj1l3wGhyZC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="429451536"
X-IronPort-AV: E=Sophos;i="6.04,183,1695711600"; 
   d="scan'208";a="429451536"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 09:36:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="872311498"
X-IronPort-AV: E=Sophos;i="6.04,183,1695711600"; 
   d="scan'208";a="872311498"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2024 09:36:28 -0800
Date: Tue, 9 Jan 2024 09:36:27 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Chao Gao <chao.gao@intel.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v17 092/116] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <20240109173627.GC2639779@ls.amr.corp.intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <7ca4b7af33646e3f5693472b4394ba0179b550e1.1699368322.git.isaku.yamahata@intel.com>
 <ZZiLKKobVcmvrPmb@google.com>
 <ZZuDp+Pl0BHKEfPt@chao-email>
 <ZZ1yeYyXiYlB_7-N@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZZ1yeYyXiYlB_7-N@google.com>

On Tue, Jan 09, 2024 at 08:21:13AM -0800,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Jan 08, 2024, Chao Gao wrote:
> > On Fri, Jan 05, 2024 at 03:05:12PM -0800, Sean Christopherson wrote:
> > >On Tue, Nov 07, 2023, isaku.yamahata@intel.com wrote:
> > >> From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >> 
> > >> Wire up TDX PV HLT hypercall to the KVM backend function.
> > >> 
> > >> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > >> ---
> > >>  arch/x86/kvm/vmx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++++++-
> > >>  arch/x86/kvm/vmx/tdx.h |  3 +++
> > >>  2 files changed, 44 insertions(+), 1 deletion(-)
> > >> 
> > >> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > >> index 3a1fe74b95c3..4e48989d364f 100644
> > >> --- a/arch/x86/kvm/vmx/tdx.c
> > >> +++ b/arch/x86/kvm/vmx/tdx.c
> > >> @@ -662,7 +662,32 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> > >>  
> > >>  bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
> > >>  {
> > >> -	return pi_has_pending_interrupt(vcpu);
> > >> +	bool ret = pi_has_pending_interrupt(vcpu);
> > >> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > >> +
> > >> +	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
> > >> +		return true;
> > >> +
> > >> +	if (tdx->interrupt_disabled_hlt)
> > >> +		return false;
> > >> +
> > >> +	/*
> > >> +	 * This is for the case where the virtual interrupt is recognized,
> > >> +	 * i.e. set in vmcs.RVI, between the STI and "HLT".  KVM doesn't have
> > >> +	 * access to RVI and the interrupt is no longer in the PID (because it
> > >> +	 * was "recognized".  It doesn't get delivered in the guest because the
> > >> +	 * TDCALL completes before interrupts are enabled.
> > >> +	 *
> > >> +	 * TDX modules sets RVI while in an STI interrupt shadow.
> > >> +	 * - TDExit(typically TDG.VP.VMCALL<HLT>) from the guest to TDX module.
> > >> +	 *   The interrupt shadow at this point is gone.
> > >> +	 * - It knows that there is an interrupt that can be delivered
> > >> +	 *   (RVI > PPR && EFLAGS.IF=1, the other conditions of 29.2.2 don't
> > >> +	 *    matter)
> > >> +	 * - It forwards the TDExit nevertheless, to a clueless hypervisor that
> > >> +	 *   has no way to glean either RVI or PPR.
> > >
> > >WTF.  Seriously, what in the absolute hell is going on.  I reported this internally
> > >four ***YEARS*** ago.  This is not some obscure theoretical edge case, this is core
> > >functionality and it's completely broken garbage.
> > >
> > >NAK.  Hard NAK.  Fix the TDX module, full stop.
> > >
> > >Even worse, TDX 1.5 apparently _already_ has the necessary logic for dealing with
> > >interrupts that are pending in RVI when handling NESTED VM-Enter.  Really!?!?!
> > >Y'all went and added nested virtualization support of some kind, but can't find
> > >the time to get the basics right?
> > 
> > We actually fixed the TDX module. See 11.9.5. Pending Virtual Interrupt
> > Delivery Indication in TDX module 1.5 spec [1]
> > 
> >   The host VMM can detect whether a virtual interrupt is pending delivery to a
> >   VCPU in the Virtual APIC page, using TDH.VP.RD to read the VCPU_STATE_DETAILS
> >   TDVPS field.
> >   
> >   The typical use case is when the guest TD VCPU indicates to the host VMM, using
> >   TDG.VP.VMCALL, that it has no work to do and can be halted. The guest TD is
> >   expected to pass an “interrupt blocked” flag. The guest TD is expected to set
> >   this flag to 0 if and only if RFLAGS.IF is 1 or the TDCALL instruction that
> >   invokes TDG.VP.VMCALL immediately follows an STI instruction. If the “interrupt
> >   blocked” flag is 0, the host VMM can determine whether to re-schedule the guest
> >   TD VCPU based on VCPU_STATE_DETAILS.
> > 
> > Isaku, this patch didn't read VCPU_STATE_DETAILS. Maybe you missed something
> > during rebase? Regarding buggy_hlt_workaround, do you aim to avoid reading
> > VCPU_STATE_DETAILS as much as possible (because reading it via SEAMCALL is
> > costly, ~3-4K cycles)? 
> 
> *sigh*  Why only earth doesn't the TDX module simply compute VMXIP on TDVMCALL?
> It's literally one bit and one extra VMREAD.  There are plenty of register bits
> available, and I highly doubt ~20 cycles in the TDVMCALL path will be noticeable,
> let alone problematic.  Such functionality could even be added on top in a TDX
> module update, and Intel could even bill it as a performance optimization.
> 
> Eating 4k cycles in the HLT path isn't the end of the world, but it's far from
> optimal and it's just so incredibly wasteful.  I wouldn't be surprised if the
> latency is measurable for certain workloads, which will lead to guests using
> idle=poll and/or other games being played in the guest.
> 
> And AFAICT, the TDX module doesn't support HLT passthrough, so fully dedicated
> CPUs can't even mitigate the pain that way.
> 
> Anyways, regarding the "workaround", my NAK stands.  It has bad tradeoffs of its
> own, e.g. will result in spurious wakeups, and can't possibly work for VMs with
> passthrough devices.  Not to mention that the implementation has several races
> and false positives.

I'll drop the last part and use TDH.VP.RD(VCPU_STATE_DETAILS) with TDX 1.5.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>>

