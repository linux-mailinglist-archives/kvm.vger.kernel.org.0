Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA121649EB
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 17:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBSQS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 11:18:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:22800 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726771AbgBSQS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 11:18:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 08:18:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,461,1574150400"; 
   d="scan'208";a="224547220"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 19 Feb 2020 08:18:27 -0800
Date:   Wed, 19 Feb 2020 08:18:27 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Erwan Velu <e.velu@criteo.com>
Cc:     Erwan Velu <erwanaliasr1@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: Print "disabled by bios" only once per host
Message-ID: <20200219161827.GD15888@linux.intel.com>
References: <20200214143035.607115-1-e.velu@criteo.com>
 <20200214170508.GB20690@linux.intel.com>
 <70b4d8fa-57c0-055b-8391-4952dec32a58@criteo.com>
 <20200218184802.GC28156@linux.intel.com>
 <91db305a-1d81-61a6-125b-3094e75b4b3e@criteo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91db305a-1d81-61a6-125b-3094e75b4b3e@criteo.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 12:19:01PM +0100, Erwan Velu wrote:
> On 18/02/2020 19:48, Sean Christopherson wrote:
> [...]
> >Fix userspace to only do the "add" on one CPU.
> >
> >Changing kvm_arch_init() to use pr_err_once() for the disabled_by_bios()
> >case "works", but it's effectively a hack to workaround a flawed userspace.
> 
> I'll see with the user space tool to sort this out.
> 
> I'm also considering how "wrong" is what they do: udevadm trigger is
> generating 3500  "uevent add" on my system and I only noticed kvm to print
> this noisy message.
> 
> So as the print once isn't that "wrong" neither, this simple patch would
> avoid polluting the kernel logs.
> 
> 
> So my proposal would be
> 
> - have this simple patch on the kernel side to avoid having userspace apps
> polluting logs
> 
> - contacting the udev people to see the rational & fix it too : I'll do that
> 
> 
> As you said, once probed, there is no need reprinting the same message again
> as the situation cannot have changed.

For this exact scenario, on Intel/VMX, this is mostly true.  But, the MSR
check for AMD/SVM has a disable bit that takes effect irrespective of the
MSR's locked bit, i.e. SVM could theoretically change state without any
super special behavior.

Even on Intel, the state can potentially change, especially on a system
with a misbehaving BIOS.  FEATURE_CONTROL is cleared on CPU RESET, e.g. VMX
enabling could change if BIOS "forgets" to reinitialize the MSR upon waking
from S3 (suspend).  Things get really weird if we consider the case where
BIOS leaves the MSR unlocked after S3, the user manually writes the MSR,
and then it gets cleared again on a different S3 transition.

SVM is even more sensitive because VM_CR is cleared on INIT, not just RESET.

> As we are on the preliminary return code path (to make a EOPNOTSUPP), I
> would vote for protecting the print against multiple calls/prints.
> 
> The kernel patch isn't impacting anyone (in a regular case) and just avoid
> pollution.
> 
> Would you agree on that ?

Sadly, no.  Don't get me wrong, I completely agree that, ideally, KVM would
not spam the log, even when presented with a misbehaving userspace.

My hesitation about changing the error message to pr_err_once() isn't so
much about right versus wrong as it is about creating misleading and
potentially confusing code in KVM, and setting a precedent that I don't
think we want to carry forward.

E.g. the _once() doesn't hold true if module kvm is unloaded and other
error messages such as basic CPU support would still be unlimited.  The
basic CPU support message definitely should *not* be _once() as that would
squash messages when loading the wrong vendor module.

As for setting a precedent, moving the error message to the vendor module
or making kvm a monolithic module would "break" the _once() behavior.

And, the current systemd behavior is actually quite dangerous, e.g. on a
misconfigured system where SVM is enabled on a subset of CPUs, probing KVM
on every CPU essentially guarantees that KVM will be loaded on a broken
system.  In that case, I think we actually want the spam.  Note, as of
kernel 5.6, this doesn't apply to VMX as kvm_intel will no longer load on a
misconfigured system since FEATURE_CONTROL configuration is incorporated
into the per-CPU checks.

All of that being said, what about converting all of the error messages to
pr_err_ratelimited()?  That would take the edge off this particular problem,
wouldn't create incosistencies between error messages, and won't completely
squash error messages in corner case scenarios on misconfigured systems.
