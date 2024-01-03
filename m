Return-Path: <kvm+bounces-5508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C4B28228FA
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:26:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A43C1F23CC9
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 07:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A52718044;
	Wed,  3 Jan 2024 07:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P4zAoOrv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840BB18032;
	Wed,  3 Jan 2024 07:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704266777; x=1735802777;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iScjFm5+ojO0LeBbJOkrLVm23Bdjy3tv8Oe2Gdhzty8=;
  b=P4zAoOrvxXShaIY8dZcliIs5QTTLaoArTtkss0agNKioh2L1tdhomAgS
   KhsWxOgTZg7pDyblLRlTNkcnTXjq2jZf7T5LXCVGi1aFPzDMSX64WPJH6
   GHW2wsuACVpzcUoQp7aZJwr8+w5HhUih8jk+HHI+PbuTFB1G/JKb2CBiD
   DTSBwENe5NKBOEZjBVgiKzUzfIbTUD7HQbLLxDAr80USEkr0iR3k2rSxi
   d+totwDa/TyEJWzXKLwVhT2HJU8C5ja8xXfz63gzNJ7xrApicMVpHuyhH
   rcOG+wb9xOFh0Ym1kyWJNi6l8sOoS8stTmRjZv5Znl0G01wBHTZ7VOYIb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="483157021"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="483157021"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 23:26:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="773067201"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="773067201"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga007.jf.intel.com with ESMTP; 02 Jan 2024 23:26:11 -0800
Date: Wed, 3 Jan 2024 15:26:10 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Michal Wilczynski <michal.wilczynski@intel.com>, pbonzini@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhi.a.wang@intel.com, artem.bityutskiy@linux.intel.com,
	yuan.yao@intel.com, Zheyu Ma <zheyuma97@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v1] KVM: nVMX: Fix handling triple fault on RSM
 instruction
Message-ID: <20240103072610.q2nqhzfl2yoygaig@yy-desk-7060>
References: <20231222164543.918037-1-michal.wilczynski@intel.com>
 <ZZRqptOaukCb7rO_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZRqptOaukCb7rO_@google.com>
User-Agent: NeoMutt/20171215

On Tue, Jan 02, 2024 at 11:57:26AM -0800, Sean Christopherson wrote:
> +Maxim
>
> On Fri, Dec 22, 2023, Michal Wilczynski wrote:
> > Syzkaller found a warning triggered in nested_vmx_vmexit().
> > vmx->nested.nested_run_pending is non-zero, even though we're in
> > nested_vmx_vmexit(). Generally, trying  to cancel a pending entry is
> > considered a bug. However in this particular scenario, the kernel
> > behavior seems correct.
> >
> > Syzkaller scenario:
> > 1) Set up VCPU's
> > 2) Run some code with KVM_RUN in L2 as a nested guest
> > 3) Return from KVM_RUN
> > 4) Inject KVM_SMI into the VCPU
> > 5) Change the EFER register with KVM_SET_SREGS to value 0x2501
> > 6) Run some code on the VCPU using KVM_RUN
> > 7) Observe following behavior:
> >
> > kvm_smm_transition: vcpu 0: entering SMM, smbase 0x30000
> > kvm_entry: vcpu 0, rip 0x8000
> > kvm_entry: vcpu 0, rip 0x8000
> > kvm_entry: vcpu 0, rip 0x8002
> > kvm_smm_transition: vcpu 0: leaving SMM, smbase 0x30000
> > kvm_nested_vmenter: rip: 0x0000000000008002 vmcs: 0x0000000000007000
> >                     nested_rip: 0x0000000000000000 int_ctl: 0x00000000
> > 		    event_inj: 0x00000000 nested_ept=n guest
> > 		    cr3: 0x0000000000002000
> > kvm_nested_vmexit_inject: reason: TRIPLE_FAULT ext_inf1: 0x0000000000000000
> >                           ext_inf2: 0x0000000000000000 ext_int: 0x00000000
> > 			  ext_int_err: 0x00000000
> >
> > What happened here is an SMI was injected immediately and the handler was
> > called at address 0x8000; all is good. Later, an RSM instruction is
> > executed in an emulator to return to the nested VM. em_rsm() is called,
> > which leads to emulator_leave_smm(). A part of this function calls VMX/SVM
> > callback, in this case vmx_leave_smm(). It attempts to set up a pending
> > reentry to guest VM by calling nested_vmx_enter_non_root_mode() and sets
> > vmx->nested.nested_run_pending to one. Unfortunately, later in
> > emulator_leave_smm(), rsm_load_state_64() fails to write invalid EFER to
> > the MSR. This results in em_rsm() calling triple_fault callback. At this
> > point it's clear that the KVM should call the vmexit, but
> > vmx->nested.nested_run_pending is left set to 1. To fix this reset the
> > vmx->nested.nested_run_pending flag in triple_fault handler.
> >
> > TL;DR (courtesy of Yuan Yao)
> > Clear nested_run_pending in case of RSM failure on return from L2 SMM.
>
> KVM doesn't emulate SMM for L2.  On an injected SMI, KVM forces a syntethic nested
> VM-Exit to get from L2 to L1, and then emulates SMM in the context of L1.

Ah right!
I was thinking the L1 at that time... Anyway my fault here.

>
> > The pending VMENTRY to L2 should be cancelled due to such failure leads
> > to triple fault which should be injected to L1.
> >
> > Possible alternative approach:
> > While the proposed approach works, the concern is that it would be
> > simpler, and more readable to cancel the nested_run_pending in em_rsm().
> > This would, however, require introducing new callback e.g,
> > post_leave_smm(), that would cancel nested_run_pending in case of a
> > failure to resume from SMM.
> >
> > Additionally, while the proposed code fixes VMX specific issue, SVM also
> > might suffer from similar problem as it also uses it's own
> > nested_run_pending variable.
> >
> > Reported-by: Zheyu Ma <zheyuma97@gmail.com>
> > Closes: https://lore.kernel.org/all/CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com
>
> Fixes: 759cbd59674a ("KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a result of RSM")
>
> > Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index c5ec0ef51ff7..44432e19eea6 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4904,7 +4904,16 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
> >
> >  static void nested_vmx_triple_fault(struct kvm_vcpu *vcpu)
> >  {
> > +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +
> >  	kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > +
> > +	/* In case of a triple fault, cancel the nested reentry. This may occur
>
> 	/*
> 	 * Multi-line comments should look like this.  Blah blah blab blah blah
> 	 * blah blah blah blah.
> 	 */
>
> > +	 * when the RSM instruction fails while attempting to restore the state
> > +	 * from SMRAM.
> > +	 */
> > +	vmx->nested.nested_run_pending = 0;
>
> Argh.  KVM's handling of SMIs while L2 is active is complete garbage.  As explained
> by the comment in vmx_enter_smm(), the L2<->SMM transitions should have a completely
> custom flow and not piggyback/usurp nested VM-Exit/VM-Entry.
>
> 	/*
> 	 * TODO: Implement custom flows for forcing the vCPU out/in of L2 on
> 	 * SMI and RSM.  Using the common VM-Exit + VM-Enter routines is wrong
> 	 * SMI and RSM only modify state that is saved and restored via SMRAM.
> 	 * E.g. most MSRs are left untouched, but many are modified by VM-Exit
> 	 * and VM-Enter, and thus L2's values may be corrupted on SMI+RSM.
> 	 */
>
> The Fixes: commit above added a hack on top of the hack.  But it's not entirely
> clear from the changelog exactly what was being fixed.
>
>     While RSM induced VM entries are not full VM entries,
>     they still need to be followed by actual VM entry to complete it,
>     unlike setting the nested state.
>
>     This patch fixes boot of hyperv and SMM enabled
>     windows VM running nested on KVM, which fail due
>     to this issue combined with lack of dirty bit setting.
>
> My first guess would be event injection, but that shouldn't be relevant to RSM.
> Architecturally, events (SMIs, NMIs, IRQs, etc.) are recognized at instruction
> boundaries, but except for SMIs (see below), KVM naturally defers injection until
> an instruction boundary by virtue of delivering events via the VMCS/VMCB, i.e. by
> waiting to deliver events until successfully re-entering the guest.
>
> Nested VM-Enter is a special snowflake because KVM needs to finish injecting events
> from vmcs12 before injecting any synthetic events, i.e. nested_run_pending ensures
> that KVM wouldn't clobber/override an L2 event coming from L1.  In other words,
> nested_run_pending is much more specific than just needing to wait for an instruction
> boundary.
>
> So while the "wait until the CPU is at an instruction boundary" applies to RSM,
> it's not immediately obvious to me why setting nested_run_pending is necessary.
> And setting nested_run_pending *after* calling nested_vmx_enter_non_root_mode()
> is nasty.  nested_vmx_enter_non_root_mode() and its helpers use nested_run_pending
> to determine whether or not to enforce various consistency checks and other
> behaviors.  And a more minor issue is that stat.nested_run will be incorrectly
> incremented.
>
> As a stop gap, something like this patch is not awful, though I would strongly
> prefer to be more precise and not clear it on all triple faults.  We've had KVM
> bugs where KVM prematurely synthesizes triple fault on an actual nested VM-Enter,
> and those would be covered up by this fix.
>
> But due to nested_run_pending being (unnecessarily) buried in vendor structs, it
> might actually be easier to do a cleaner fix.  E.g. add yet another flag to track
> that a hardware VM-Enter needs to be completed in order to complete instruction
> emulation.
>
> And as alluded to above, there's another bug lurking.  Events that are *emulated*
> by KVM must not be emulated until KVM knows the vCPU is at an instruction boundary.
> Specifically, enter_smm() shouldn't be invoked while KVM is in the middle of
> instruction emulation (even if "emulation" is just setting registers and skipping
> the instruction).  Theoretically, that could be fixed by honoring the existing
> at_instruction_boundary flag for SMIs, but that'd be a rather large change and
> at_instruction_boundary is nowhere near accurate enough to use right now.
>
> Anyways, before we do anything, I'd like to get Maxim's input on what exactly was
> addressed by 759cbd59674a.
>

