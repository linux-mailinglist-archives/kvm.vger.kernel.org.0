Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282313479BE
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 14:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbhCXNij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 09:38:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:55550 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235394AbhCXNiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 09:38:23 -0400
IronPort-SDR: 9ZY2IKtrTGjM0IccjpCgM32sgnZwqUVpVfl4TU08bCHkggqDua0NAJ7E7eHUF7L0LE8uZqDuUt
 /MeqkScB75CQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="210811518"
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="210811518"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 06:38:23 -0700
IronPort-SDR: XMEvngJYeoZ5U0X8BS+n8DZzhN7FBdbcoV7p6zkA8p1qvi+3IBxTwZ1rrsSM2xuJNOnNGckoD+
 /Bi6DVBEI9wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="408848110"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.166])
  by fmsmga008.fm.intel.com with ESMTP; 24 Mar 2021 06:38:21 -0700
Date:   Wed, 24 Mar 2021 21:51:15 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <20210324135115.GA11269@local-michael-cet-test.sh.intel.com>
References: <20210315071841.7045-1-weijiang.yang@intel.com>
 <20210315071841.7045-2-weijiang.yang@intel.com>
 <YE+PF1zfkZTTgwxn@google.com>
 <20210316090347.GA13548@local-michael-cet-test.sh.intel.com>
 <20210323004305.GA3647@local-michael-cet-test.sh.intel.com>
 <YFoPro1bw07YEaXe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFoPro1bw07YEaXe@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 03:56:30PM +0000, Sean Christopherson wrote:
> On Tue, Mar 23, 2021, Yang Weijiang wrote:
> > On Tue, Mar 16, 2021 at 05:03:47PM +0800, Yang Weijiang wrote:
> > 
> > Hi, Sean,
> > Could you respond my below rely? I'm not sure how to proceed, thanks!
> > 
> > > On Mon, Mar 15, 2021 at 09:45:11AM -0700, Sean Christopherson wrote:
> > > > On Mon, Mar 15, 2021, Yang Weijiang wrote:
> 
> ...
> 
> > > > > @@ -2556,6 +2563,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> > > > >  	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
> > > > >  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
> > > > >  		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
> > > > > +
> > > > > +	if (kvm_cet_supported() && (!vmx->nested.nested_run_pending ||
> > > > > +	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))) {
> > > > 
> > > > Not your code per se, since this pattern comes from BNDCFGS and DEBUGCTL, but I
> > > > don't see how loading vmcs01 state in this combo is correct:
> > > > 
> > > >     a. kvm_xxx_supported()              == 1
> > > >     b. nested_run_pending               == false
> > > >     c. vm_entry_controls.load_xxx_state == true
> > > > 
> > > > nested_vmx_enter_non_root_mode() only snapshots vmcs01 if 
> > > > vm_entry_controls.load_xxx_state == false, which means the above combo is
> > > > loading stale values (or more likely, zeros).
> > > > 
> > > > I _think_ nested_vmx_enter_non_root_mode() just needs to snapshot vmcs01 if
> > > > nested_run_pending=false.  For migration, if userspace restores MSRs after
> > > > KVM_SET_NESTED_STATE, then what's done here is likely irrelevant.  If userspace
> > > > restores MSRs before nested state, then vmcs01 will hold the desired value since
> > > > setting MSRs would have written the value into vmcs01.
> > > 
> > > Then the code nested_vmx_enter_non_root_mode() would look like:
> > > 
> > > if (kvm_cet_supported() && !vmx->nested.nested_run_pending &&
> > >     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> > > 	...
> > >     }
> > > 
> > > I have another concern now, if vm_entry_controls.load_cet_state == false, and L1
> > > updated vmcs fields, so the latest states are in vmcs12, but they cannot
> > > be synced to vmcs02 because in prepare_vmcs02_rare():
> > > 
> > > if (kvm_cet_supported() && vmx->nested.nested_run_pending &&
> > >     (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> > > 	...
> > >     }
> > > 
> > > so L2 got stale status. IMO, L1 guest sets vm_entry_controls.load_cet_state == false
> > > should be rare case. We can even igore this case :-)
> 
> Yes, that's an L1 bug if it expects L2 state to come from vmcs12 in that case.
> Architecturally, the vcms12 value won't be visible to L2 until L1 enables the
> VM-Entry control, at which point KVM would detect the refreshed vmcs12 and sync
> the "rare" fields.

Thanks, Sean!
So I'll change code as below:

if (kvm_cet_supported() && !vmx->nested.nested_run_pending &&
    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
      ...
    }
>
> > > > I suspect no one has reported this issue because guests simply don't use MPX,
> > > > and up until the recent LBR stuff, KVM effectively zeroed out DEBUGCTL for the
> > > > guest.
> > > > 
> > > So for MPX and DEBUGCTL, is it worth some separate fix patch?
> 
> Yes, assuming my analysis is correct.  That doesn't necessarily need to be your
> responsibility, though patches are of course welcome :-)
> 
> Jim, Paolo, any thoughts?
> 
OK, let me wait for Jim and Paolo's comments on this...

> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index 45622e9c4449..4184ff601120 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -3298,10 +3298,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > > >         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
> > > >                 evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
> > > > 
> > > > -       if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> > > > +       if (!vmx->nested.nested_run_pending ||
> > > > +           !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> > > >                 vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
> > > > -       if (kvm_mpx_supported() &&
> > > > -               !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> > > > +       if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
> > > > +           !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
> > > >                 vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> > > > 
> > > >         /*
> > > > 
> > > > 
> > > > Side topic, all of this code is broken for SMM emulation.  SMI+RSM don't do a
> > > > full VM-Exit -> VM-Entry; the CPU forcefully exits non-root, but most state that
> > > > is loaded from the VMCS is left untouched.  It's the SMI handler's responsibility
> > > > to not enable features, e.g. to not set CR4.CET.  For sane use cases, this
> > > > probably doesn't matter as vmcs12 will be configured to context switch state,
> > > > but if L1 is doing anything out of the ordinary, SMI+RSM will corrupt state.
> > > > 
> > > > E.g. if L1 enables MPX in the guest, does not intercept L2 writes to BNDCFGS,
> > > > and does not load BNDCFGS on VM-Entry, then SMI+RSM would corrupt BNDCFGS since
> > > > the SMI "exit" would clear BNDCFGS, and the RSM "entry" would load zero.  This
> > > > is 100% contrived, and probably doesn't impact real world use cases, but it
> > > > still bugs me :-)
> > > 
> > > Exactly, should it be fixed by separate patch or leave it as is?
> 
> Definitely leave it for now, properly fixing the SMI+RSM code goes far beyond
> basic CET support.

Sure.

