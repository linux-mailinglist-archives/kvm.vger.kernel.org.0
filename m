Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC191AB176
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 21:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506460AbgDOTSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 15:18:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:7923 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438103AbgDOTSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 15:18:04 -0400
IronPort-SDR: a1P065WqdNqs/eX3NiZKAqqULT0LqoQt35JQxDTV/kBhZysAiO6ImUpvhqvmznwIytwbxaR7B+
 xhWJiJEHLSzg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 12:18:03 -0700
IronPort-SDR: SEHqItrkjZXOQP0jipLmEroMtPCrnvseS05ClLvhsLuO2XMAAd+N4nafCDISRgbQ9E0V6Qq+0P
 yQHvJHunYdgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="455009326"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 15 Apr 2020 12:18:02 -0700
Date:   Wed, 15 Apr 2020 12:18:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
Message-ID: <20200415191802.GE30627@linux.intel.com>
References: <20200414063129.133630-5-xiaoyao.li@intel.com>
 <871rooodad.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rooodad.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 15, 2020 at 07:43:22PM +0200, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> > +/*
> > + * Note: for guest, feature split lock detection can only be enumerated through
> > + * MSR_IA32_CORE_CAPABILITIES bit. The FMS enumeration is unsupported.
> 
> That comment is confusing at best.
> 
> > + */
> > +static inline bool guest_cpu_has_feature_sld(struct kvm_vcpu *vcpu)
> > +{
> > +	return vcpu->arch.core_capabilities &
> > +	       MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT;
> > +}
> > +
> > +static inline bool guest_cpu_sld_on(struct vcpu_vmx *vmx)
> > +{
> > +	return vmx->msr_test_ctrl & MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
> > +}
> > +
> > +static inline void vmx_update_sld(struct kvm_vcpu *vcpu, bool on)
> > +{
> > +	/*
> > +	 * Toggle SLD if the guest wants it enabled but its been disabled for
> > +	 * the userspace VMM, and vice versa.  Note, TIF_SLD is true if SLD has
> > +	 * been turned off.  Yes, it's a terrible name.
> 
> Instead of writing that useless blurb you could have written a patch
> which changes TIF_SLD to TIF_SLD_OFF to make it clear.

Hah, that's my comment, though I must admit I didn't fully intend for the
editorial at the end to get submitted upstream.

Anyways, I _did_ point out that TIF_SLD is a terrible name[1][2], and my
feedback got ignored/overlooked.  I'd be more than happy to write a patch,
I didn't do so because I assumed that people wanted TIF_SLD as the name for
whatever reason.

[1] https://lkml.kernel.org/r/20191122184457.GA31235@linux.intel.com
[2] https://lkml.kernel.org/r/20200115225724.GA18268@linux.intel.com

> > +	 */
> > +	if (sld_state == sld_warn && guest_cpu_has_feature_sld(vcpu) &&
> > +	    on == test_thread_flag(TIF_SLD)) {
> > +		    sld_update_msr(on);
> > +		    update_thread_flag(TIF_SLD, !on);
> 
> Of course you completely fail to explain why TIF_SLD needs to be fiddled
> with.

Ya, that comment should be something like:

	* Toggle SLD if the guest wants it enabled but its been disabled for
	* the userspace VMM, and vice versa, so that the flag and MSR state
	* are consistent, i.e. its handling during task switches naturally does
	* the right thing if KVM is preempted with guest state loaded.

> > @@ -1188,6 +1217,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> >  #endif
> >
> > 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
> > +
> > +	vmx->host_sld_on = !test_thread_flag(TIF_SLD);
> 
> This inverted storage is non-intuitive. What's wrong with simply
> reflecting the TIF_SLD state?

So that the guest/host tracking use the same polairy, and IMO it makes
the restoration code more intuitive, e.g.:

	vmx_update_sld(&vmx->vcpu, vmx->host_sld_on);
vs
	vmx_update_sld(&vmx->vcpu, !vmx->host_tif_sld);

I.e. the inversion needs to happen somewhere.

> > +	vmx_update_sld(vcpu, guest_cpu_sld_on(vmx));
> > +
> >	vmx->guest_state_loaded = true;
> > }
> >
> > @@ -1226,6 +1259,9 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
> > 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
> >  #endif
> > 	load_fixmap_gdt(raw_smp_processor_id());
> > +
> > +	vmx_update_sld(&vmx->vcpu, vmx->host_sld_on);
> > +
> 
> vmx_prepare_switch_to_guest() is called via:
> 
> kvm_arch_vcpu_ioctl_run()
>   vcpu_run()
>     vcpu_enter_guest()
>       preempt_disable();
>       kvm_x86_ops.prepare_guest_switch(vcpu);
> 
> but vmx_prepare_switch_to_host() is invoked at the very end of:
> 
> kvm_arch_vcpu_ioctl_run()
>   .....
>   vcpu_run()
>   .....
>   vcpu_put()
>     vmx_vcpu_put()
>       vmx_prepare_switch_to_host();
> 
> That asymmetry does not make any sense without an explanation.

Deferring the "switch to host" until the vCPU is put allows KVM to keep
certain guest state loaded when staying in the vCPU run loop, e.g.
MSR_KERNEL_GS_BASE can be exposed to the guest without having to save and
restore it on every VM-Enter/VM-Exit.

I agree that all of KVM's state save/load trickerly lacks documentation,
I'll put that on my todo list.
 
> What's even worse is that vmx_prepare_switch_to_host() is invoked with
> preemption enabled, so MSR state and TIF_SLD state can get out of sync
> on preemption/migration.

It shouldn't be (called with preempation enabled):

void vcpu_put(struct kvm_vcpu *vcpu)
{
	preempt_disable();
	kvm_arch_vcpu_put(vcpu); <-- leads to vmx_prepare_switch_to_host()
	preempt_notifier_unregister(&vcpu->preempt_notifier);
	__this_cpu_write(kvm_running_vcpu, NULL);
	preempt_enable();
}

> > @@ -1946,9 +1992,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > 
> > 	switch (msr_index) {
> > 	case MSR_TEST_CTRL:
> > -		if (data)
> > +		if (data & ~vmx_msr_test_ctrl_valid_bits(vcpu))
> > 			return 1;
> > 
> > +		vmx->msr_test_ctrl = data;
> > +
> > +		preempt_disable();
> 
> This preempt_disable/enable() lacks explanation as well.

Is an explanation still needed if it's made clear (somewhere) that
interacting with guest_state_loaded needs to be done with preemption
disabled?
 
> > +		if (vmx->guest_state_loaded)
> > +			vmx_update_sld(vcpu, guest_cpu_sld_on(vmx));
> > +		preempt_enable();
> 
> How is updating msr_test_ctrl valid if this is invoked from the IOCTL,
> i.e. host_initiated == true?

Not sure I understand the underlying question.  The host is always allowed
to manipulate guest state, including MSRs.

I'm pretty sure guest_state_loaded should always be false if host_initiated
is true, e.g. we could technically do a WARN on guest_state_loaded and
host_initiated, but the ioctl() is obviously not a hot path and nothing
will break if the assumption doesn't hold.

> That said, I also hate the fact that you export both the low level MSR
> function _and_ the state variable. Having all these details including the
> TIF mangling in the VMX code is just wrong.

I'm not a fan of exporting the low level state either, but IIRC trying to
hide the low level details while achieving the same resulting functionality
was even messier.

I don't see any way to avoid having KVM differentiate between sld_warn and
sld_fatal.  Even if KVM is able to virtualize SLD in sld_fatal mode, e.g.
by telling the guest it must not try to disable SLD, KVM would still need
to know the kernel is sld_fatal so that it can forward that information to
the guest.

It'd be possible to avoid mucking with TIF or exporting the MSR helper, but
that would require KVM to manually save/restore the MSR when KVM is
preempted with guest state loaded.  That probably wouldn't actually affect
performance for most use cases, but IMO it's not worth the extra headache
just to avoid exporting a helper.
