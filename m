Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD012A330F
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 19:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgKBSeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 13:34:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:4765 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgKBSeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 13:34:01 -0500
IronPort-SDR: bnuwXQ9emSVxR9tvMh23EZ8WQ+yCg3ifX4e/9buE8mrdGqGtDcTjX6nf25ZMYPMsqzoLfySa6r
 O0Pjk347mfGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="148786621"
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="148786621"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 10:34:01 -0800
IronPort-SDR: pahTddyjF32YwYnd6OFeQd2/itlS/oc6hyqu8YMbqEDKrlmEYpuwwcjgam8jheQPbPFunfza8+
 l8aDQFZSPGuA==
X-IronPort-AV: E=Sophos;i="5.77,445,1596524400"; 
   d="scan'208";a="470475711"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 10:34:00 -0800
Date:   Mon, 2 Nov 2020 10:33:59 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Tao Xu <tao3.xu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
Message-ID: <20201102183359.GE21563@linux.intel.com>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
 <20201102173130.GC21563@linux.intel.com>
 <CALCETrV0ZsTcQKVCPPSKHnuVgERMC0x86G5y_6E5Rhf=h5JzsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV0ZsTcQKVCPPSKHnuVgERMC0x86G5y_6E5Rhf=h5JzsA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 10:01:16AM -0800, Andy Lutomirski wrote:
> On Mon, Nov 2, 2020 at 9:31 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Mon, Nov 02, 2020 at 08:43:30AM -0800, Andy Lutomirski wrote:
> > > On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
> > > > 2. Another patch to disable interception of #DB and #AC when notify
> > > > VM-Exiting is enabled.
> > >
> > > Whoa there.
> > >
> > > A VM control that says "hey, CPU, if you messed up and livelocked for
> > > a long time, please break out of the loop" is not a substitute for
> > > fixing the livelocks.  So I don't think you get do disable
> > > interception of #DB and #AC.
> >
> > I think that can be incorporated into a module param, i.e. let the platform
> > owner decide which tool(s) they want to use to mitigate the legacy architecture
> > flaws.
> 
> What's the point?  Surely the kernel should reliably mitigate the
> flaw, and the kernel should decide how to do so.

IMO, setting a reasonably low threshold _is_ mitigating such flaws.  E.g. it's
entirely possible, if not likely, that we can push the threshold below various
ENCLS instruction latencies.  Now I'm curious as to how exactly the accounting
is done under the hood, e.g. I assume retiring uops of a massive instruction is
enough to reset the timer, but I haven't actually read the specs in detail.

If userspace is truly malicious, it can easily spawn new VMs/processes to carry
out its attack, e.g. exiting to userspace on these VM-Exits effectively
throttles userspace as much as straight killing the process.

> >
> > > I also think you should print a loud warning
> >
> > I'm not so sure on this one, e.g. userspace could just spin up a new instance
> > if its malicious guest and spam the kernel log.
> 
> pr_warn_once()?

Or ratelimited.  My point was that a straight WARN would be less than ideal.

> If this triggers, it's a *bug*, right?  Kernel or CPU.

Sort of?  Many (all?) of the known of the scenarios that can trigger this exit
are unlikely to ever be fixed in silicon.  I'm not saying they shouldn't be
fixed, just that practically speaking they are highly unlikely to be fixed
anytime soon.  The infinite #DB/#AC recursion flaws are inarguably dumb CPU
behavior, but there are other scenarious that are less cut and dried, i.e. may
not be fixable without non-trivial tradeoffs.

> > > and have some intelligent handling when this new exit triggers.
> >
> > We discussed something similar in the context of the new bus lock VM-Exit.  I
> > don't know that it makes sense to try and add intelligence into the kernel.
> > In many use cases, e.g. clouds, the userspace VMM is trusted (inasmuch as
> > userspace can be trusted), while the guest is completely untrusted.  Reporting
> > the error to userspace and letting the userspace stack take action is likely
> > preferable to doing something fancy in the kernel.
> >
> >
> > Tao, this patch should probably be tagged RFC, at least until we can experiment
> > with the threshold on real silicon.  KVM and kernel behavior may depend on the
> > accuracy of detecting actual attacks, e.g. if we can set a threshold that has
> > zero false negatives and near-zero false postives, then it probably makes sense
> > to be more assertive in how such VM-Exits are reported and logged.
> 
> If you can actually find a threshold that reliably mitigates the bug
> and does not allow a guest to cause undesirably large latency in the
> host, then fine.  1/10 if a tick is way too long, I think.

Yes, this was my internal review feedback as well.  Either that got lost along
the way or I wasn't clear enough in stating what should be used as a placeholder
until we have silicon in hand.
