Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A0E42C21C
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhJMOIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:08:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35042 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhJMOIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:08:51 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634134006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=xQN4atmrZ2amKkMdXRfONyAazMjs4Z44fmYDKeuNJXs=;
        b=kGkDVL2wxnu2M0tBkqVDDnyWZ6Vkz3yloC6hlsg4CNKYr4UQNVQ2w6oM3KchnUp8L9vM0J
        yu7Bqg6oeELaHhZgfmzvPEy7+XzSijdToWb1hs1QSX7vfpA11l3Wv3uC6jyCg0CzBCPvUT
        o0irwxcIN29WgkD4ghTF8awnhDtNHvnXs3b/lidu4XxGj453OqgBw8QFm3ioQZh76KkoJo
        UVReEUTdXGCFMuCfsuVVmIQnarCDIyQOme04yDndlO1nl7bb1kGt3B7fZeYvd6kPPXzkC3
        ptb9avjP9Qymo1iQQzyQ8TOe7Lu1sUgLKYCyVLEyIlrSsMbeELT/WtEVK42K6A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634134006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=xQN4atmrZ2amKkMdXRfONyAazMjs4Z44fmYDKeuNJXs=;
        b=pbW7o2hDnIce0RuFNRcj2dvxe8p0Z5oMYzDDJP63ePpMB6IhvVZsofRqgzcYwFlS5igU2x
        75T+lSrXI0AOJ3Dw==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
Date:   Wed, 13 Oct 2021 16:06:46 +0200
Message-ID: <871r4p9fyh.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Wed, Oct 13 2021 at 10:42, Paolo Bonzini wrote:
> On 13/10/21 09:46, Liu, Jing2 wrote:
>>> Yes, the host value of XFD (which is zero) has to be restored after vmexit.
>>> See how KVM already handles SPEC_CTRL.
>> 
>> I'm trying to understand why qemu's XFD is zero after kernel supports AMX.
>
> There are three copies of XFD:
>
> - the guest value stored in vcpu->arch.
>
> - the "QEMU" value attached to host_fpu.  This one only becomes zero if 
> QEMU requires AMX (which shouldn't happen).

I don't think that makes sense.

First of all, if QEMU wants to expose AMX to guests, then it has to ask
for permission to do so as any other user space process. We're not going
to make that special just because.

The guest configuration will have to have a 'needs AMX' flag set. So
QEMU knows that it is required upfront.

Which also means that a guest configuration which has it not set will
never get AMX passed through.

That tells me, that we should not bother at all with on demand buffer
reallocations for that case and just keep things simple.

The on demand buffer allocation from the general OS point of view makes
sense because there it really matters whether we allocate $N kilobytes
per thread or not.

But does it matter for the QEMU process and its vCPU threads when the
guest is allowed to use AMX? I don't think so. It's an academic exercise
IMO and just makes the handling of this way more complex than required.

So the logic should be:

   qemu()
     read_config()
     if (dynamic_features_passthrough())
     	request_permission(feature)

     create_vcpu_threads()
       ....

       vcpu_thread()
         kvm_ioctl(ENABLE_DYN_FEATURE, feature)
           reallocate_buffers()
             realloc(tsk->fpu.fpstate, feature)
             realloc(guest_fpu.fpstate, feature)
             realloc(host_fpu.fpstate, feature)

             All of them will have

             fpstate.xfd = default_xfd & ~feature

That makes also resume and migration simple because that's going to use
exactly the same mechanism.

Yes, it _allows_ QEMU user space to use AMX, but that's not the end of
the world, really and avoids a ton of special cases to worry about.

Also the extra memory consumption per vCPU thread is probably just noise
compared to the rest of the vCPU state.

With that the only thing you have to take care of is in vmx_vcpu_run():

   local_irq_disable();
   ...
   vmx_vcpu_run()
     wrmsrl(XFD, guest->xfd)
     vmenter()
     guest->xfd = rdmsrl(XFD)
     wrmsrl(XFD, host->xfd)

It does not matter when at some day there is a XFD controlled bit 19 and
you want to selectively allow access to guests because we have two
mechanisms here:

  1) XCR0

    XSETBV in the guest is intercepted and checked against the allowed
    bits. If it tries to set one which is not allowed, then this is
    not any different from what KVM is doing today.

    I.e. Guest1 is allowed to set bit 18, but not 19
         Guest2 is allowed to set bit 19, but not 18
         Guest3 is allowed to set both 18 and 19

  2) XFD

     Intercepting XFD is optional I think. It does not matter what the
     guest writes into it, because if XCRO[i] = 0 then the state of
     XFD[i] is irrelevant according to the ISE:

     "(IA32_XFD[i] does not affect processor operations if XCR0[i] = 0.)"

     The only thing different vs. bare metal is that when guest writes
     XFD[i]=1 it wont get #GP despite the fact that virtualized CPUID
     suggest that it should get one:
     
     "Bit i of either MSR can be set to 1 only if CPUID.(EAX=0DH,ECX=i):ECX[2]
      is enumerated as 1.  An execution of WRMSR that attempts to set an
      unsupported bit in either MSR causes a general-protection fault
      (#GP)."

     Does it matter?  Probably not, all it can figure out is that
     component[i] is supported in hardware, but it can't do anything
     with that information because the VMM will not allow it to set the
     corresponding XCR0 bit...

     Sure you can intercept XFD, check the write against the allowed
     guest bits and inject #GP if not.

     But keep in mind that the guest kernel will context switch it and
     that will not be any better than context switching XCR0 in the
     guest kernel...

The thing we need to think about is the case where guest has XCR0[i] =
XFD[i] = 1 and host has XFD[i] = 0, because setting XFD[i] = 1 does not
bring the component[i] into init state.

In that case we have the following situation after a vmexit:

     guest->xfd = rdmsrl(XFD)         [i] = 1
     wrmsrl(XFD, host->xfd)           [i] = 0

If the component[i] is _not_ in init state then the next XSAVES on the
host will save it and therefore have xsave.header.XSAVE_BV[i] = 1 in the
buffer. A subsequent XRSTORS of that buffer on the host will restore the
saved data into component[i].

But the subsequent vmenter() will restore the guest XFD which will just
bring the guest into the exactly same state as before the VMEXIT.

Ergo it does not matter at all.

That also makes #NM handling trivial. Any #NM generated in the guest is
completely uninteresting for the host with that scheme and it's the
guests problem to deal with it.

But that brings me to another issue: XFD_ERR.

Assume guest takes #NM and before the handler can run and read/clear
XFD_ERR a VMEXIT happens which means XFD_ERR will have the guest error
bit set and nothing will clear it. So XFD_ERR has to be handled properly
otherwise a subsequent #NM on the host will see a stale bit from the
guest.

   vmx_vcpu_run()
     wrmsrl(XFD, guest->xfd)
     wrmsrl(XFD_ERR, guest->xfd_err)
     vmenter()
     guest->xfd_err = rdmsrl(XFD_ERR)
     guest->xfd = rdmsrl(XFD)
     wrmsrl(XFD_ERR, 0)
     wrmsrl(XFD, host->xfd)

Of course that want's to be conditional on the guest configuration and
you probably want all of that to be in the auto-load/store area, but
you get the idea.

Anything else will just create more problems than it solves. Especially
#NM handling (think nested guest) and the XFD_ERR additive behaviour
will be a nasty playground and easy to get wrong.

Not having that at all makes life way simpler, right?

Thanks,

        tglx
