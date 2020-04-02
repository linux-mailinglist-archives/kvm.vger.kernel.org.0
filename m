Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D98B219CAC1
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 22:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388706AbgDBUHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 16:07:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38949 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgDBUHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 16:07:41 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jK67H-0002M1-Rh; Thu, 02 Apr 2020 22:07:08 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 48894100D52; Thu,  2 Apr 2020 22:07:07 +0200 (CEST)
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
In-Reply-To: <20200402174023.GI13879@linux.intel.com>
References: <20200402124205.334622628@linutronix.de> <20200402155554.27705-1-sean.j.christopherson@intel.com> <20200402155554.27705-4-sean.j.christopherson@intel.com> <87sghln6tr.fsf@nanos.tec.linutronix.de> <20200402174023.GI13879@linux.intel.com>
Date:   Thu, 02 Apr 2020 22:07:07 +0200
Message-ID: <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
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
> On Thu, Apr 02, 2020 at 07:19:44PM +0200, Thomas Gleixner wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> > +	case AC_VECTOR:
>> > +		/*
>> > +		 * Reflect #AC to the guest if it's expecting the #AC, i.e. has
>> > +		 * legacy alignment check enabled.  Pre-check host split lock
>> > +		 * turned on to avoid the VMREADs needed to check legacy #AC,
>> > +		 * i.e. reflect the #AC if the only possible source is legacy
>> > +		 * alignment checks.
>> > +		 */
>> > +		if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) ||
>> 
>> I think the right thing to do here is to make this really independent of
>> that feature, i.e. inject the exception if
>> 
>>  (CPL==3 && CR0.AM && EFLAGS.AC) || (FUTURE && (GUEST_TEST_CTRL & SLD))
>> 
>> iow. when its really clear that the guest asked for it. If there is an
>> actual #AC with SLD disabled and !(CPL==3 && CR0.AM && EFLAGS.AC) then
>> something is badly wrong and the thing should just die. That's why I
>> separated handle_guest_split_lock() and tell about that case.
>
> That puts KVM in a weird spot if/when intercepting #AC is no longer
> necessary, e.g. "if" future CPUs happen to gain a feature that traps into
> the hypervisor (KVM) if a potential near-infinite ucode loop is detected.
>
> The only reason KVM intercepts #AC (before split-lock) is to prevent a
> malicious guest from executing a DoS attack on the host by putting the #AC
> handler in ring 3.  Current CPUs will get stuck in ucode vectoring #AC
> faults more or less indefinitely, e.g. long enough to trigger watchdogs in
> the host.

Which is thankfully well documented in the VMX code and the
corresponding chapter in the SDM. 

> Injecting #AC if and only if KVM is 100% certain the guest wants the #AC
> would lead to divergent behavior if KVM chose to not intercept #AC, e.g.

AFAICT, #AC is not really something which is performance relevant, but I
might obviously be uninformed on that.

Assumed it is not, then there is neither a hard requirement nor a real
incentive to give up on intercepting #AC even when future CPUs have a
fix for the above wreckage.

> some theoretical unknown #AC source would conditionally result in exits to
> userspace depending on whether or not KVM wanted to intercept #AC for
> other reasons.

I'd rather like to know when there is an unknown #AC source instead of
letting the guest silently swallow it.

TBH, the more I learn about this, the more I tend to just give up on
this whole split lock stuff in its current form and wait until HW folks
provide something which is actually usable:

   - Per thread
   - Properly distinguishable from a regular #AC via error code

OTOH, that means I won't be able to use it before retirement. Oh well.

Thanks,

        tglx
