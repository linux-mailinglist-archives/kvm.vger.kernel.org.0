Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 166F919CC17
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 22:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389630AbgDBUvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 16:51:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:6017 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgDBUvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 16:51:10 -0400
IronPort-SDR: nnazKzwo7o4t2pBqjM51DSZmx/Vdm1AYDxoE2Q7gBpcGLGPcwqhG0ljKjimiO+WEo/uiqIt7X5
 bMZ4VzU+w+nw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2020 13:51:09 -0700
IronPort-SDR: xDndagnINHEsIccR1lmNLrp85M8OlP1m8autthF7KfNKOzl2PmQG29nHNaCPldzq8FHZbt+HgU
 7weqTDm8QGVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,336,1580803200"; 
   d="scan'208";a="243196843"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 02 Apr 2020 13:51:09 -0700
Date:   Thu, 2 Apr 2020 13:51:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
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
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle
 split lock #AC in guest
Message-ID: <20200402205109.GM13879@linux.intel.com>
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
 <20200402155554.27705-4-sean.j.christopherson@intel.com>
 <87sghln6tr.fsf@nanos.tec.linutronix.de>
 <20200402174023.GI13879@linux.intel.com>
 <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 10:07:07PM +0200, Thomas Gleixner wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > On Thu, Apr 02, 2020 at 07:19:44PM +0200, Thomas Gleixner wrote:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > That puts KVM in a weird spot if/when intercepting #AC is no longer
> > necessary, e.g. "if" future CPUs happen to gain a feature that traps into
> > the hypervisor (KVM) if a potential near-infinite ucode loop is detected.
> >
> > The only reason KVM intercepts #AC (before split-lock) is to prevent a
> > malicious guest from executing a DoS attack on the host by putting the #AC
> > handler in ring 3.  Current CPUs will get stuck in ucode vectoring #AC
> > faults more or less indefinitely, e.g. long enough to trigger watchdogs in
> > the host.
> 
> Which is thankfully well documented in the VMX code and the
> corresponding chapter in the SDM. 
> 
> > Injecting #AC if and only if KVM is 100% certain the guest wants the #AC
> > would lead to divergent behavior if KVM chose to not intercept #AC, e.g.
> 
> AFAICT, #AC is not really something which is performance relevant, but I
> might obviously be uninformed on that.
> 
> Assumed it is not, then there is neither a hard requirement nor a real
> incentive to give up on intercepting #AC even when future CPUs have a
> fix for the above wreckage.

Agreed that there's no hard requirement, but general speaking, the less KVM
needs to poke into the guest the better.

> > some theoretical unknown #AC source would conditionally result in exits to
> > userspace depending on whether or not KVM wanted to intercept #AC for
> > other reasons.
> 
> I'd rather like to know when there is an unknown #AC source instead of
> letting the guest silently swallow it.

Trying to prevent the guest from squashing a spurious fault is a fools
errand.   For example, with nested virtualization, the correct behavior
from an architectural perspective is to forward exceptions from L2 (the
nested VM) to L1 (the direct VM) that L1 wants to intercept.  E.g. if L1
wants to intercept #AC faults that happen in L2, then KVM reflects all #AC
faults into L1 as VM-Exits without ever reaching this code.

Nested virt aside, detecting spurious #AC and a few other exceptions is
mostly feasible, but for many exceptions it's flat out impossible.

Anyways, this particular case isn't a sticking point, i.e. I'd be ok with
exiting to userspace on a spurious #AC, I just don't see the value in doing
so.  Returning KVM_EXIT_EXCEPTION doesn't necessarily equate to throwing up
a red flag, e.g. from a kernel perspective you'd still be relying on the
userspace VMM to report the error in a sane manner.  I think at one point
Xiaoyao had a WARN_ON for a spurious #AC, but it was removed because the
odds of a false positive due to some funky corner case seemed higher than
detecting a CPU bug.

> TBH, the more I learn about this, the more I tend to just give up on
> this whole split lock stuff in its current form and wait until HW folks
> provide something which is actually usable:
> 
>    - Per thread
>    - Properly distinguishable from a regular #AC via error code
> 
> OTOH, that means I won't be able to use it before retirement. Oh well.
> 
> Thanks,
> 
>         tglx
