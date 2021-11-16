Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE834539A1
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 19:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbhKPS6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 13:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239624AbhKPS6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 13:58:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D058C061570;
        Tue, 16 Nov 2021 10:55:41 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637088939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xwfkk8Bsh/ggf2j5AZWfbUH4bToTqxnE38LBF+v1K3E=;
        b=v69t4Po+46uxaN0amHPEIb5lEFKdNFkA6U6dK2F+qIU1fd+K1WNCSPGcpPM7j+6ZMTfpsb
        q7u0KtEosf/PlmYK+Mdn9pyvpcerB2FfslVZEFX/j7o6iX1m3SbCGtPPnEVMkqZn9TUJQ0
        o10720gi+PwWk4aMLw/plmRWbyAvy4gjZVasGArXD4uNe/YY6o5k5EJC3WAhcTlsBPKIUs
        gMuZ6wx2jwphmbnYLBxhmLtiYnf4caE8tVx9YCgsjVkcAmEKDr6WYtbTzLhtS08JMJW2Hj
        kT2Xr6Es2GUWaF6NEgHviUwzbkPe9wkOnAAS4//85X3FGHljlZgWVhWmC/1OCw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637088939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xwfkk8Bsh/ggf2j5AZWfbUH4bToTqxnE38LBF+v1K3E=;
        b=D25FfPoOg5Y9KftKdW2poBslG6y0tLO1VNaQTMHeJULswzj6SD/1GXetUoPYkTK9PAFsE+
        4XMQ4es+N8YzIPCA==
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
In-Reply-To: <YZPWsICdDTZ02UDu@google.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <87k0h85m65.ffs@tglx> <YZPWsICdDTZ02UDu@google.com>
Date:   Tue, 16 Nov 2021 19:55:38 +0100
Message-ID: <87ee7g53rp.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,

On Tue, Nov 16 2021 at 16:05, Sean Christopherson wrote:
> On Tue, Nov 16, 2021, Thomas Gleixner wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 2686f2edb47c..9425fdbb4806 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9576,6 +9576,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>  	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
>>  	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>>  
>> +	kvm_update_guest_xfd_state();
>
> Is there a reason the XFD switch can't key off TIF_NEED_FPU_LOAD a la the other
> FPU stuff?  I.e. piggyback this snippet in vcpu_enter_guest():

TIF_NEED_FPU_LOAD is not set here.

> 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> 		switch_fpu_return();

Assume guest has control of XFD and XFD writes are not trapped. That
means on vmexit the XFD state of the guest is unknown.

vcpu_run()
        kvm_load_guest_fpu()
            wrmsrl(XFD, guest_fpstate->xfd);
            XRSTORS
          
        do {

           local_irq_disable();

           // Covers the case of softirq usage and preemption
           if (test_thread_flag(TIF_NEED_FPU_LOAD))
		switch_fpu_return()
                  wrmsrl(XFD, guest_fpstate->xfd);

           do {
                vmenter();              // Guest modifies XFD
           } while (reenter);

           local_irq_enable();     <- Problem starts here

           preempt_enable();	   <- Becomes wider here

        } while (!breakout);

        kvm_put_guest_fpu();            // Switch back to user FPU state

So we have the following cases:

guest_fpstate.xfd        XFD at vmexit

       0                      0         // consistent state
       1                      0         // inconsistent state
       0                      1         // inconsistent state
       1                      1         // consistent state

Now assume that after reenabling interrupts a interrupt/softirq happens
which uses FPU. It will save the correct state because XFD is still
guest state, but the subsequent restore will operate on the stale
guest_fpstate.xfd value.

Same problem vs schedule after reenabling preemption or if not preempted
in kvm_put_guest_fpu()

Now you could argue that the interrupt/softirq XSAVES should also read
the XFD MSR and save it in guest_fpstate.xfd. Same in schedule()
and kvm_put_guest_fpu(), i.e:

      XSAVES
      if (fpstate->is_guest) {
            rdmsrl(XFD, xfd);
            fpstate->xfd = xfd;
            __this_cpu_write(..., xfd);
      }

We can do that, but I'm unhappy about this conditional in schedule(). So
I was asking for doing a simple KVM only solution first:

vcpu_run()
        kvm_load_guest_fpu()
            wrmsrl(XFD, guest_fpstate->xfd);
            XRSTORS
          
        do {

           local_irq_disable();

           if (test_thread_flag(TIF_NEED_FPU_LOAD))
		switch_fpu_return()
                  wrmsrl(XFD, guest_fpstate->xfd);

           do {
                vmenter();              // Guest modifies XFD
           } while (reenter);

           update_xfd_state();          // Restore consistency

           local_irq_enable();

and check how bad that is for KVM in terms of overhead on AMX systems.

If it really matters we can look at the conditional in XSAVES path.

Thanks,

        tglx
