Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C9E42E1E1
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 21:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhJNTQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 15:16:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44346 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhJNTQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 15:16:31 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634238865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jUgAIjGXwdPpLxQF0XeeBC4nuM3hklP6Tn6BHQWTIqY=;
        b=wHsF7yKSxi82FqyGFPbUcKIhlNVCJPoHTB2dHGIQxQ+EAGim336ibXGZNMKu8ZiST+hKd0
        LrenWDqf+WDLP1FFpLv5faESYQs+tx+yEQUZUrrBTWEcKVQNZ37KzIFZ+rWWurv8Rc1yTF
        3obRZjYcrcIb6lqNIpsKNGUQ8Y8Z+0ExqFKbXVfqivXXr91MYHL+x35cDhobgNjK5KDenS
        NZTS6rWZf2xbheYQu4AWlLITfQsXwfyPwnFWHFr7omgCy7BdXPEgxwhTC0gp0np4yNBJpV
        6yLAy1/OaCpBPL7IafCtQaIn5MbieGeB8UGoTaB5DivESjzgbhZCuyMEAFV0ig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634238865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jUgAIjGXwdPpLxQF0XeeBC4nuM3hklP6Tn6BHQWTIqY=;
        b=PiYKFAOoCEyk3cBOYo3RnqUBwTaNKVXPhQWezrBeUcU+PNBPMuulMAbEc7qEUM/dg+URsN
        ze+cAE/y3RtfUTCg==
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
In-Reply-To: <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com> <87wnmf66m5.ffs@tglx>
 <3997787e-402d-4b2b-0f90-4a672c77703f@redhat.com>
Date:   Thu, 14 Oct 2021 21:14:24 +0200
Message-ID: <87lf2v5shb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Thu, Oct 14 2021 at 17:01, Paolo Bonzini wrote:
> On 14/10/21 16:09, Thomas Gleixner wrote:
>> On Thu, Oct 14 2021 at 11:01, Paolo Bonzini wrote:
>>> On 14/10/21 10:02, Liu, Jing2 wrote:
>>> Based on the input from Andy and Thomas, the new way would be like this:
>>>
>>> 1) host_fpu must always be checked for reallocation in
>>> kvm_load_guest_fpu (or in the FPU functions that it calls, that depends
>>> on the rest of Thomas's patches).  That's because arch_prctl can enable
>>> AMX for QEMU at any point after KVM_CREATE_VCPU.
>> 
>> No.
>> 
>>     1) QEMU starts
>>     2) QEMU requests permissions via prctl()
>>     3) QEMU creates vCPU threads
>> 
>> Doing it the other way around makes no sense at all and wont work.
>
> Sure, but KVM needs to do something that makes sense even for userspaces 
> that are not QEMU.
>
> For example, there could be a program that uses AMX *itself* and does 
> not expose it to the guest.  In that case, the arch_prctl can come at 
> the point AMX is needed, which can be after the program creates vCPU 
> threads.  That's for host_fpu.

That wont affect the vCPU threads unless they start to use AMX in user
space themself. Which means they have the default buffer and their vCPU
user/guest FPU's too.

The prctl() sets the permission nothing else.  As long as they don't use
AMX their XFD[18] stays set. Only when they start using AMX in user
space themself they trigger #NM which allocates a larger buffer for the
thread.

So then the point where it matters is fpu_swap_kvm_fpu() and that's
preemptible context so we can do allocations before fiddling with the
buffers. Not rocket science.

And that has nothing to do with the whole XCR0/XFD/XFD_ERR/#NM guest
mess.

> For the guest_fpu, I agree that the arch_prctl must come before creating 
> vCPUs.

Good :)

>> vcpu_create()
>> 
>>    fpu_init_fpstate_user(guest_fpu, supported_xcr0)
>> 
>> That will (it does not today) do:
>> 
>>       guest_fpu::__state_perm = supported_xcr0 & xstate_get_group_perm();
>> 
>> The you have the information you need right in the guest FPU.
>
> Good, I wasn't aware of the APIs that will be there.

Me neither, but that's a pretty obvious consequence of the work I'm
doing for AMX. So I made it up for you. :)

>> This unconditionally calls into that allocation for every XCR0/XFD
>> trap ?
>
> Calls into the function, but doesn't necessarily allocate anything.

Sure.

> What you wrote below looks correct to me, thanks.
>
> Paolo
>

Properly quoting mail is hard, right?

>> Also you really should not wait until _all_ dynamic states are cleared
>> in guest XFD.  Because a guest which has bit 18 and 19 available but only > uses one of them is going to trap on every other context switch due to
>> XFD writes.

Thanks,

        tglx
