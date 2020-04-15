Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B210C1AB34A
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 23:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438907AbgDOVW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 17:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438867AbgDOVW0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 17:22:26 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C87AC061A0C;
        Wed, 15 Apr 2020 14:22:26 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jOpU4-0002H8-2s; Wed, 15 Apr 2020 23:22:12 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7123B100C47; Wed, 15 Apr 2020 23:22:11 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
In-Reply-To: <20200415191802.GE30627@linux.intel.com>
References: <20200414063129.133630-5-xiaoyao.li@intel.com> <871rooodad.fsf@nanos.tec.linutronix.de> <20200415191802.GE30627@linux.intel.com>
Date:   Wed, 15 Apr 2020 23:22:11 +0200
Message-ID: <87tv1kmol8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,

Sean Christopherson <sean.j.christopherson@intel.com> writes:
> On Wed, Apr 15, 2020 at 07:43:22PM +0200, Thomas Gleixner wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> > +static inline void vmx_update_sld(struct kvm_vcpu *vcpu, bool on)
>> > +{
>> > +	/*
>> > +	 * Toggle SLD if the guest wants it enabled but its been disabled for
>> > +	 * the userspace VMM, and vice versa.  Note, TIF_SLD is true if SLD has
>> > +	 * been turned off.  Yes, it's a terrible name.
>> 
>> Instead of writing that useless blurb you could have written a patch
>> which changes TIF_SLD to TIF_SLD_OFF to make it clear.
>
> Hah, that's my comment, though I must admit I didn't fully intend for the
> editorial at the end to get submitted upstream.
>
> Anyways, I _did_ point out that TIF_SLD is a terrible name[1][2], and my
> feedback got ignored/overlooked.  I'd be more than happy to write a
> patch, I didn't do so because I assumed that people wanted TIF_SLD as the name for
> whatever reason.

I somehow missed that in the maze of mails regarding this stuff. I've
already written a patch to rename it to TIF_SLD_DISABLED which is pretty
self explaining. But see below.

>> > +	 */
>> > +	if (sld_state == sld_warn && guest_cpu_has_feature_sld(vcpu) &&
>> > +	    on == test_thread_flag(TIF_SLD)) {
>> > +		    sld_update_msr(on);
>> > +		    update_thread_flag(TIF_SLD, !on);
>> 
>> Of course you completely fail to explain why TIF_SLD needs to be fiddled
>> with.
>
> Ya, that comment should be something like:
>
> 	* Toggle SLD if the guest wants it enabled but its been disabled for
> 	* the userspace VMM, and vice versa, so that the flag and MSR state
> 	* are consistent, i.e. its handling during task switches naturally does
> 	* the right thing if KVM is preempted with guest state loaded.

Something to that effect.

>> > @@ -1188,6 +1217,10 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>> >  #endif
>> >
>> > 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
>> > +
>> > +	vmx->host_sld_on = !test_thread_flag(TIF_SLD);
>> 
>> This inverted storage is non-intuitive. What's wrong with simply
>> reflecting the TIF_SLD state?
>
> So that the guest/host tracking use the same polairy, and IMO it makes
> the restoration code more intuitive, e.g.:
>
> 	vmx_update_sld(&vmx->vcpu, vmx->host_sld_on);
> vs
> 	vmx_update_sld(&vmx->vcpu, !vmx->host_tif_sld);
>
> I.e. the inversion needs to happen somewhere.

Correct, but we can make it consistently use the 'disabled' convention.

I briefly thought about renaming the flag to TIF_SLD_ENABLED, set it by
default and update the 5 places where it is used. But that's
inconsistent as well simply because it does not make any sense to set
that flag when detection is not available or disabled on the command
line.

>> > @@ -1226,6 +1259,9 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
>> > 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
>> >  #endif
>> > 	load_fixmap_gdt(raw_smp_processor_id());
>> > +
>> > +	vmx_update_sld(&vmx->vcpu, vmx->host_sld_on);
>> > +
>> 
>> vmx_prepare_switch_to_guest() is called via:
>> 
>> kvm_arch_vcpu_ioctl_run()
>>   vcpu_run()
>>     vcpu_enter_guest()
>>       preempt_disable();
>>       kvm_x86_ops.prepare_guest_switch(vcpu);
>> 
>> but vmx_prepare_switch_to_host() is invoked at the very end of:
>> 
>> kvm_arch_vcpu_ioctl_run()
>>   .....
>>   vcpu_run()
>>   .....
>>   vcpu_put()
>>     vmx_vcpu_put()
>>       vmx_prepare_switch_to_host();
>> 
>> That asymmetry does not make any sense without an explanation.
>
> Deferring the "switch to host" until the vCPU is put allows KVM to keep
> certain guest state loaded when staying in the vCPU run loop, e.g.
> MSR_KERNEL_GS_BASE can be exposed to the guest without having to save and
> restore it on every VM-Enter/VM-Exit.

I know why this is done (after staring at the callchains for a while),
but 5 lines of explanation at least in the changelog would have saved my
time.

>> What's even worse is that vmx_prepare_switch_to_host() is invoked with
>> preemption enabled, so MSR state and TIF_SLD state can get out of sync
>> on preemption/migration.
>
> It shouldn't be (called with preempation enabled):
>
> void vcpu_put(struct kvm_vcpu *vcpu)
> {
> 	preempt_disable();
> 	kvm_arch_vcpu_put(vcpu); <-- leads to vmx_prepare_switch_to_host()
> 	preempt_notifier_unregister(&vcpu->preempt_notifier);
> 	__this_cpu_write(kvm_running_vcpu, NULL);
> 	preempt_enable();
> }

Ooops. How did I miss that?

>> > @@ -1946,9 +1992,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> > 
>> > 	switch (msr_index) {
>> > 	case MSR_TEST_CTRL:
>> > -		if (data)
>> > +		if (data & ~vmx_msr_test_ctrl_valid_bits(vcpu))
>> > 			return 1;
>> > 
>> > +		vmx->msr_test_ctrl = data;
>> > +
>> > +		preempt_disable();
>> 
>> This preempt_disable/enable() lacks explanation as well.
>
> Is an explanation still needed if it's made clear (somewhere) that
> interacting with guest_state_loaded needs to be done with preemption
> disabled?

Well, the thing is that finding that explanation somewhere is not always
trivial. Aside of that this really is the wrong place to do that. That
wants to be inside a function which is invoked from here and that
function should have the appropriate commentry
  
>> > +		if (vmx->guest_state_loaded)
>> > +			vmx_update_sld(vcpu, guest_cpu_sld_on(vmx));
>> > +		preempt_enable();
>> 
>> How is updating msr_test_ctrl valid if this is invoked from the IOCTL,
>> i.e. host_initiated == true?
>
> Not sure I understand the underlying question.  The host is always allowed
> to manipulate guest state, including MSRs.

Fair enough.

> I'm pretty sure guest_state_loaded should always be false if host_initiated
> is true, e.g. we could technically do a WARN on guest_state_loaded and
> host_initiated, but the ioctl() is obviously not a hot path and nothing
> will break if the assumption doesn't hold.

You'd create inconsistent state because the guest internal state cache
is not updated, but if you can updated it with !loaded then you can do
that anyway. Shrug.

>> That said, I also hate the fact that you export both the low level MSR
>> function _and_ the state variable. Having all these details including the
>> TIF mangling in the VMX code is just wrong.
>
> I'm not a fan of exporting the low level state either, but IIRC trying to
> hide the low level details while achieving the same resulting functionality
> was even messier.
>
> I don't see any way to avoid having KVM differentiate between sld_warn and
> sld_fatal.  Even if KVM is able to virtualize SLD in sld_fatal mode, e.g.
> by telling the guest it must not try to disable SLD, KVM would still need
> to know the kernel is sld_fatal so that it can forward that information to
> the guest.

Huch? There is absolutely zero code like that. The only place where
sld_state is used is:

+ static inline void vmx_update_sld(struct kvm_vcpu *vcpu, bool on)
+ {
+	if (sld_state == sld_warn && guest_cpu_has_feature_sld(vcpu) &&
+	    on == test_thread_flag(TIF_SLD)) {
+		    sld_update_msr(on);
+		    update_thread_flag(TIF_SLD, !on);
+	}

You might have some faint memories from the previous trainwrecks :)

The fatal mode emulation which is used in this patch set is simply that
the guest can 'write' to the MSR but it's not propagated to the real
MSR. It's just stored in the guest state. There is no way that you can
tell the guest that the MSR is there but fake.

The alternative solution is to prevent the exposure of SLD to the guest
in fatal mode. But that does not buy anything.

The detection is anyway incomplete. If the SLD #AC is raised in guest's
user mode and the guest has user #AC enabled then the exception is
injected into the guest unconditionally and independent of the host's
and guest's SLD state. That's entirely correct because a SLD #AC in user
mode is also a user mode alignment violation; it's not distinguishable.

You could of course analyse the offending instruction and check for a
lock prefix and a cache line overlap, but that still does not prevent
false positives. When the guest is non-malicious and has proper user #AC
handling in place then it would be wrong or at least very surprising to
kill it just because the detection code decided that it is a dangerous
split lock attempt.

So we can go with the proposed mode of allowing the write but not
propagating it. If the resulting split lock #AC originates from CPL != 3
then the guest will be killed with SIGBUS. If it originates from CPL ==
3 and the guest has user #AC disabled then it will be killed as well.

Thanks,

        tglx


