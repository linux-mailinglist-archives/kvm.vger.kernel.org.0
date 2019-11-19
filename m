Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9872102D25
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 21:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfKSUBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 15:01:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:36821 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfKSUBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 15:01:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 12:01:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,219,1571727600"; 
   d="scan'208";a="237462225"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 19 Nov 2019 12:01:33 -0800
Date:   Tue, 19 Nov 2019 12:01:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Derek Yerger <derek@djy.llc>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
Message-ID: <20191119200133.GD25672@linux.intel.com>
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
 <20191016112857.293a197d@x1.home>
 <20191016174943.GG5866@linux.intel.com>
 <53f506b3-e864-b3ca-f18f-f8e9a1612072@djy.llc>
 <20191022202847.GO2343@linux.intel.com>
 <4af8cbac-39b1-1a20-8e26-54a37189fe32@djy.llc>
 <20191024173212.GC20633@linux.intel.com>
 <36be1503-f6f1-0ed0-b1fe-9c05d827f624@djy.llc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36be1503-f6f1-0ed0-b1fe-9c05d827f624@djy.llc>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 30, 2019 at 11:44:09PM -0400, Derek Yerger wrote:
> 
> On 10/24/19 1:32 PM, Sean Christopherson wrote:
> >On Thu, Oct 24, 2019 at 11:18:59AM -0400, Derek Yerger wrote:
> >>On 10/22/19 4:28 PM, Sean Christopherson wrote:
> >>>On Thu, Oct 17, 2019 at 07:57:35PM -0400, Derek Yerger wrote:
> >>>Heh, should've checked from the get go...  It's definitely not the memslot
> >>>issue, because the memslot bug is in 5.1.16 as well.  :-)
> >>I didn't pick up on that, nice catch. The memslot thread was the closest
> >>thing I could find to an educated guess.
> >>>>I'm stuck on 5.1.x for now, maybe I'll give up and get a dedicated windows
> >>>>machine /s
> >>>What hardware are you running on?  I was thinking this was AMD specific,
> >>>but then realized you said "AMD Radeon 540 GPU" and not "AMD CPU".
> >>Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz
> >>
> >>07:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI]
> >>Lexa PRO [Radeon 540/540X/550/550X / RX 540X/550/550X] (rev c7)
> >>         Subsystem: Gigabyte Technology Co., Ltd Device 22fe
> >>         Kernel driver in use: vfio-pci
> >>         Kernel modules: amdgpu
> >>(plus related audio device)
> >>
> >>I can't think of any other data points that would be helpful to solving
> >>system instability in a guest OS.
> >Can you bisect starting from v5.2?  Identifying which commit in the kernel
> >introduced the regression would help immensely.
> On the host, I have to install NVIDIA GPU drivers with each new kernel
> build. During the process I discovered that I can't reproduce the issue on
> any kernel if I skip the *host* GPU drivers and start libvirtd in single
> mode.
> 
> I noticed the following in the host kernel log around the time the guest
> encountered BSOD on 5.2.7:
> 
> [  337.841491] WARNING: CPU: 6 PID: 7548 at arch/x86/kvm/x86.c:7963
> kvm_arch_vcpu_ioctl_run+0x19b1/0x1b00 [kvm]

Rats, I overlooked this first time round.  In the future, if you get a
WARN splat, try to make it very obvious in the bug report, they're almost
always a smoking gun.

That WARN that fired is:

        /* The preempt notifier should have taken care of the FPU already.  */
        WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));

which was added part of a bug fix by commit:

	240c35a3783a ("kvm: x86: Use task structs fpu field for user")

the buggy commit that was fixed is

	5f409e20b794 ("x86/fpu: Defer FPU state load until return to userspace")

which was part of a FPU rewrite that went into 5.2[*].  So yep, big
smoking gun :-)

My understanding of the WARN is that it means the kernel's FPU state is
unexpectedly loaded when entry to the KVM guest is imminent.  As for *how*
the kernel's FPU state is getting loaded, no clue.  But, I think it'd be
pretty easy to find the the culprit by adding a debug flag into struct
thread_info that gets set in vcpu_load() and clearing it in vcpu_put(),
and then WARN in set_ti_thread_flag() if the debug flag is true when
TIF_NEED_FPU_LOAD is being set.  I'll put together a debugging patch later
today and send it your way.

[*] https://lkml.kernel.org/r/20190403164156.19645-1-bigeasy@linutronix.de
