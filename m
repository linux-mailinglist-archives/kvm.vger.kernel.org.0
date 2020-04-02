Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEE719CCDA
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 00:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389777AbgDBW1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 18:27:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39135 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388218AbgDBW1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 18:27:39 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jK8Ig-0004KC-Mz; Fri, 03 Apr 2020 00:27:03 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 35C96103A01; Fri,  3 Apr 2020 00:27:02 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle split lock #AC in guest
In-Reply-To: <20200402205109.GM13879@linux.intel.com>
References: <20200402124205.334622628@linutronix.de> <20200402155554.27705-1-sean.j.christopherson@intel.com> <20200402155554.27705-4-sean.j.christopherson@intel.com> <87sghln6tr.fsf@nanos.tec.linutronix.de> <20200402174023.GI13879@linux.intel.com> <87h7y1mz2s.fsf@nanos.tec.linutronix.de> <20200402205109.GM13879@linux.intel.com>
Date:   Fri, 03 Apr 2020 00:27:02 +0200
Message-ID: <87zhbtle15.fsf@nanos.tec.linutronix.de>
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
> On Thu, Apr 02, 2020 at 10:07:07PM +0200, Thomas Gleixner wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> AFAICT, #AC is not really something which is performance relevant, but I
>> might obviously be uninformed on that.
>> 
>> Assumed it is not, then there is neither a hard requirement nor a real
>> incentive to give up on intercepting #AC even when future CPUs have a
>> fix for the above wreckage.
>
> Agreed that there's no hard requirement, but general speaking, the less KVM
> needs to poke into the guest the better.

Fair enough.

>> > some theoretical unknown #AC source would conditionally result in exits to
>> > userspace depending on whether or not KVM wanted to intercept #AC for
>> > other reasons.
>> 
>> I'd rather like to know when there is an unknown #AC source instead of
>> letting the guest silently swallow it.
>
> Trying to prevent the guest from squashing a spurious fault is a fools
> errand.   For example, with nested virtualization, the correct behavior
> from an architectural perspective is to forward exceptions from L2 (the
> nested VM) to L1 (the direct VM) that L1 wants to intercept.  E.g. if L1
> wants to intercept #AC faults that happen in L2, then KVM reflects all #AC
> faults into L1 as VM-Exits without ever reaching this code.

Which means L1 should have some handling for that case at least those L1
hypervisors which we can fix. If we want to go there.

> Anyways, this particular case isn't a sticking point, i.e. I'd be ok with
> exiting to userspace on a spurious #AC, I just don't see the value in doing
> so.  Returning KVM_EXIT_EXCEPTION doesn't necessarily equate to throwing up
> a red flag, e.g. from a kernel perspective you'd still be relying on the
> userspace VMM to report the error in a sane manner.  I think at one point
> Xiaoyao had a WARN_ON for a spurious #AC, but it was removed because the
> odds of a false positive due to some funky corner case seemed higher than
> detecting a CPU bug.

Agreed. Relying on the user space side to crash and burn the guest is
probably wishful thinking. So the right thing might be to just kill it
right at the spot.

But coming back to the above discussion:

    if (!cpu_has(SLD) || guest_wants_regular_ac()) {
    	kvm_queue_exception_e();
        return 1;
    }

vs.

    if (guest_wants_regular_ac()) {
    	kvm_queue_exception_e();
        return 1;
    }

The only situation where this makes a difference is when the CPU does
not support SLD. If it does the thing became ambiguous today.

With my previous attempt to bring sanity into this by not setting the
feature flag when SLD is disabled at the command line, the check is
consistent.

But the detection of unaware hypervisors with the module scan brings us
into a situation where we have sld_state == sld_off and the feature flag
being set because we can't undo it anymore.

So now you load VMWare which disables SLD, but the feature bit stays and
then when you unload it and load VMX afterwards then you have exactly
the same situation as with the feature check removed. Consistency gone.

So with that we might want to go back to the sld_state check instead of
the cpu feature check, but that does not make it more consistent:

  As I just verified, it's possible to load the vmware module parallel
  to the KVM/VMX one.

So either we deal with it in some way or just decide that SLD and HV
modules which do not have the MOD_INFO(sld_safe) magic cannot be loaded
when SLD is enabled on the host. I'm fine with the latter :)

What a mess.

Thanks,

        tglx

