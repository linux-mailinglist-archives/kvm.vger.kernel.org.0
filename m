Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86C42EDCA
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbhJOJie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:38:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48800 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236690AbhJOJic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 05:38:32 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634290585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qMD82jDLRghwt3jUSaceVpHhA/FFqOYNqRPnvzBrsR0=;
        b=kdiS5uUNNb8ErRkx2YhowReaY5Jp8AFcpGiQnPNF8HccAObqB7VCQE6/lFH+0Egnhn4cVJ
        3KuuY+YGtm7LURfj6QEVDA2prln1fjXD6Wqs6T6/roFhR9ipLXqbUjR4nxrYBIB72RRBCU
        GL7uTzEa1vWgaOmPqsvqXw0wEnTMUqYYxh1EoV2hbOjy7s7hTTPYGmjWkhRezP0kbmbSms
        JzVWmATTUc1TcLssZIGwkoYg5K9eEX8UQClQn6RhgxOLat5Mq3KjRPsnQFMqtB+ubcqXzE
        GQRjEDbPAYKA8jk1b3CQDJfnS9+BWW2hXrMbAjOeN65puzY9PIS6kTCF9NTa5Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634290585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qMD82jDLRghwt3jUSaceVpHhA/FFqOYNqRPnvzBrsR0=;
        b=jiZNgPmBgqXDEeIgVyWjulnz0GG8uTrrHzpws/Cp0A+R+UbmdoMtf/pkEEGC3bRfOvLnh0
        FKAGiFL1KEGM+2Bg==
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
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <87lf2v5shb.ffs@tglx>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
 <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com> <87lf2v5shb.ffs@tglx>
Date:   Fri, 15 Oct 2021 11:36:25 +0200
Message-ID: <87a6ja6352.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Thu, Oct 14 2021 at 21:14, Thomas Gleixner wrote:
> On Thu, Oct 14 2021 at 17:01, Paolo Bonzini wrote:
>>> vcpu_create()
>>> 
>>>    fpu_init_fpstate_user(guest_fpu, supported_xcr0)
>>> 
>>> That will (it does not today) do:
>>> 
>>>       guest_fpu::__state_perm = supported_xcr0 & xstate_get_group_perm();
>>> 
>>> The you have the information you need right in the guest FPU.
>>
>> Good, I wasn't aware of the APIs that will be there.
>
> Me neither, but that's a pretty obvious consequence of the work I'm
> doing for AMX. So I made it up for you. :)

let me make some more up for you!

If you carefully look at part 2 of the rework, then you might notice
that there is a fundamental change which allows to do a real
simplification for KVM FPU handling:

   current->thread.fpu.fpstate

is now a pointer. So you can spare one FPU allocation because we can now
do:

fpu_attach_guest_fpu(supported_xcr0)
{
        guest_fpstate = alloc_fpstate(supported_xcr0);
        fpu_init_fpstate_user(guest_fpstate, supported_xcr0);
        current->thread.fpu.guest_fpstate = guest_fpstate;
}

fpu_swap_kvm_fpu() becomes in the first step:

fpu_swap_kvm_fpu(bool enter_guest)
{
        safe_fpregs_to_fpstate(current->thread.fpu.fpstate);

        swap(current->thread.fpu.fpstate, current->thread.fpu.guest_fpstate);

        restore_fpregs_from_fpstate(current->thread.fpu.fpstate);
}

@enter guest will allow to do some sanity checks

In a second step:

fpu_swap_kvm_fpu(bool enter_guest, u64 guest_needs_features)
{
        possibly_reallocate(enter_guest, guest_needs_features);
        safe_fpregs_to_fpstate(current->thread.fpu.fpstate);

        swap(current->thread.fpu.fpstate, current->thread.fpu.guest_fpstate);

        restore_fpregs_from_fpstate(current->thread.fpu.fpstate);
        possibly_reallocate(enter_guest, guest_needs_features);
}

@guest_needs_features is the information which you gather via guest XCR0
and guest XFD.

So fpu_swap_kvm_fpu() is going to be the place where reallocation happens
and that's good enough for both cases:

vcpu_run()

     fpu_swap_kvm_fpu(); <- 1

     while (...)
           vmenter();

     fpu_swap_kvm_fpu(); <- 2

#1 QEMU user space used feature and has already large fpstate

#2 Guest requires feature but has not used it yet (XCR0/XFD trapping)

See?

It's not only correct, it's also simple and truly beautiful.

Thanks,

        tglx
