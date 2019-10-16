Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48535D8C85
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 11:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732713AbfJPJ3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 05:29:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49396 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730336AbfJPJ3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 05:29:19 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKfc9-0001Vt-Q1; Wed, 16 Oct 2019 11:29:05 +0200
Date:   Wed, 16 Oct 2019 11:29:00 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
In-Reply-To: <20190925180931.GG31852@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1910161038210.2046@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de> <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de> <20190925180931.GG31852@linux.intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean,

On Wed, 25 Sep 2019, Sean Christopherson wrote:

sorry for the late reply. This got lost in travel/conferencing/vacation
induced backlog.

> On Wed, Jun 26, 2019 at 11:47:40PM +0200, Thomas Gleixner wrote:
> > So only one of the CPUs will win the cmpxchg race, set te variable to 1 and
> > warn, the other and any subsequent AC on any other CPU will not warn
> > either. So you don't need WARN_ONCE() at all. It's redundant and confusing
> > along with the atomic_set().
> > 
> > Whithout reading that link [1], what Ingo proposed was surely not the
> > trainwreck which you decided to put into that debugfs thing.
> 
> We're trying to sort out the trainwreck, but there's an additional wrinkle
> that I'd like your input on.
> 
> We overlooked the fact that MSR_TEST_CTRL is per-core, i.e. shared by
> sibling hyperthreads.

You must be kidding. It took 9 revisions of trainwreck engineering to
find that out.

> This is especially problematic for KVM, as loading MSR_TEST_CTRL during
> VM-Enter could cause spurious #AC faults in the kernel and bounce
> MSR_TEST_CTRL.split_lock.
>
> E.g. if CPU0 and CPU1 are siblings and CPU1 is running a KVM guest with
> MSR_TEST_CTRL.split_lock=1, hitting an #AC on CPU0 in the host kernel will
> lead to suprious #AC faults and constant toggling of of the MSR.
>
> My thought to handle this:
> 
>   - Remove the per-cpu cache.
>
>   - Rework the atomic variable to differentiate between "disabled globally"
>     and "disabled by kernel (on some CPUs)".

Under the assumption that the kernel should never trigger #AC anyway, that
should be good enough.

>   - Modify the #AC handler to test/set the same atomic variable as the
>     sysfs knob.  This is the "disabled by kernel" flow.

That's the #AC in kernel handler, right?
 
>   - Modify the debugfs/sysfs knob to only allow disabling split-lock
>     detection.  This is the "disabled globally" path, i.e. sends IPIs to
>     clear MSR_TEST_CTRL.split_lock on all online CPUs.

Why only disable? What's wrong with reenabling it? The shiny new driver you
are working on is triggering #AC. So in order to test the fix, you need to
reboot the machine instead of just unloading the module, reenabling #AC and
then loading the fixed one?

>   - Modify the resume/init flow to clear MSR_TEST_CTRL.split_lock if it's
>     been disabled on *any* CPU via #AC or via the knob.

Fine.

>   - Remove KVM loading of MSR_TEST_CTRL, i.e. KVM *never* writes the CPU's
>     actual MSR_TEST_CTRL.  KVM still emulates MSR_TEST_CTRL so that the
>     guest can do WRMSR and handle its own #AC faults, but KVM doesn't
>     change the value in hardware.
> 
>       * Allowing guest to enable split-lock detection can induce #AC on
>         the host after it has been explicitly turned off, e.g. the sibling
>         hyperthread hits an #AC in the host kernel, or worse, causes a
>         different process in the host to SIGBUS.
>
>       * Allowing guest to disable split-lock detection opens up the host
>         to DoS attacks.

Wasn't this discussed before and agreed on that if the host has AC enabled
that the guest should not be able to force disable it? I surely lost track
of this completely so my memory might trick me.

The real question is what you do when the host has #AC enabled and the
guest 'disabled' it and triggers #AC. Is that going to be silently ignored
or is the intention to kill the guest in the same way as we kill userspace?

The latter would be the right thing, but given the fact that the current
kernels easily trigger #AC today, that would cause a major wreckage in
hosting scenarios. So I fear we need to bite the bullet and have a knob
which defaults to 'handle silently' and allows to enable the kill mechanics
on purpose. 'Handle silently' needs some logging of course, at least a per
guest counter which can be queried and a tracepoint.

>   - KVM advertises split-lock detection to guest/userspace if and only if
>     split_lock_detect_disabled is zero.

Assuming that the host kernel is clean, fine. If the sysadmin disables it
after boot and after starting guests, it's his problem.

>   - Add a pr_warn_once() in KVM that triggers if split locks are disabled
>     after support has been advertised to a guest.

The pr_warn() is more or less redundant, but no strong opinion here.

> The question at the forefront of my mind is: why not have the #AC handler
> send a fire-and-forget IPI to online CPUs to disable split-lock detection
> on all CPUs?  Would the IPI be problematic?  Globally disabling split-lock
> on any #AC would (marginally) simplify the code and would eliminate the
> oddity of userspace process (and KVM guest) #AC behavior varying based on
> the physical CPU it's running on.

I'm fine with the IPI under the assumption that the kernel should never
trigger it at all in production.

Thanks,

	tglx
