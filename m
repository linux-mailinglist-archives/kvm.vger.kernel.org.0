Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3347CC443A
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 01:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbfJAXVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 19:21:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:19297 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbfJAXVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 19:21:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 16:21:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,572,1559545200"; 
   d="scan'208";a="194683575"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 01 Oct 2019 16:21:29 -0700
Date:   Tue, 1 Oct 2019 16:21:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>, vkuznets@redhat.com
Subject: Re: [PATCH kvm-unit-tests 0/8]: x86: vmx: Test INIT processing in
 various CPU VMX states
Message-ID: <20191001232129.GA6151@linux.intel.com>
References: <20190919125211.18152-1-liran.alon@oracle.com>
 <555E2BD4-3277-4261-BD54-D1924FBE9887@gmail.com>
 <5EB947BE-8494-46A7-927F-193822DD85E4@oracle.com>
 <E55E9CA1-34B1-4F9A-AAC3-AD5163A4B2D4@gmail.com>
 <B1A83F5E-3B15-4715-8AC8-D436A448D0CE@oracle.com>
 <86619DAE-C601-4162-9622-E3DE8CB1C295@gmail.com>
 <20191001184034.GC27090@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191001184034.GC27090@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 01, 2019 at 11:40:34AM -0700, Sean Christopherson wrote:
> On Mon, Sep 30, 2019 at 06:29:52PM -0700, Nadav Amit wrote:
> > > On Sep 30, 2019, at 6:23 PM, Liran Alon <liran.alon@oracle.com> wrote:

...

> > > I also remembered to verify this behaviour against some discussions made online:
> > > 1) https://software.intel.com/en-us/forums/virtualization-software-development/topic/355484
> > > * "When the 16-bit guest issues an INIT IPI to itself using the APIC, I run into an infinite VMExit situation that my hypervisor cannot seem to recover from.”
> > > * "In response to the VMExit with a reason of 3 (which is expected), the hypervisor resets the 16-bit guest's registers, limits, access rights, etc. to simulate starting execution from a known initialization point.  However, it seems that as soon as the hypervisor resumes guest execution, the VMExit occurs again, repeatedly.”
> > > 2) https://patchwork.kernel.org/patch/2244311/
> > > "I actually find it very useful. On INIT vmexit hypervisor may call vmxoff and do proper reset."
> > > 
> > > Anyway, Sean, can you assist verifying inside Intel what should be the expected behaviour?
> > 
> > It might always be (yet) another kvm-unit-tests bug that is only apparent on
> > bare-metal. But if Sean can confirm what the expected behavior is, it would
> > save time.
> > 
> > I do not have an ITP, so debugging on bare-metal is not fun at all...
> 
> My understanding of the architecture is that the INIT should be consumed
> on VM-Exit.  The only scenario where an event is not consumed/acknowledge
> is when a vanilla interrupt occurs without VM_EXIT_ACK_INTR_ON_EXIT set,
> in which case the VM-Exit is technically considered a "pending" interrupt.
> For all other cases (NMI, SMI, INIT, and INTR w/ ACK-ON-EXIT), the VM-Exit
> is the end result of delivering the event.
> 
> INITs are indeed blocked and not dropped in VMX root mode.  But entering
> non-root (guest) mode should unblock INITs and cause a VM-Exit, and thus
> clear the INIT that was pended while in VMX root mode.  This behavior does
> not conflict with the whitepaper[*] referenced by link (2) above, and in
> fact the whitepaper explicitly covers guest mode behavior in a footnote:
> 
>   When the processor is in VMX guest mode, delivery of INIT causes a
>   normal VMEXIT, of course.
> 
> The INIT attack described uses "VMX mode" to refer to VMX root mode, and
> other than the footnote, doesn't mention VMX guest mode.  My reading of it
> is that they're showing a proof of concept of based on getting the OS into
> VMX root mode but not actually running a guest, e.g. this can be done
> in KVM by creating a VM (KVM_CREATE_VM) but not running it (KVM_RUN).
> 
> Anyways, I'll double check that the INIT should indeed be consumed as part
> of the VM-Exit.

I couldn't help but run a few tests before reaching out to the architecture
folks...

I modified KVM to have the CPU send an INIT IPI to itself in vmx_vcpu_run(),
with a bit of delay to ensure the INIT is pending prior to VM-Enter.  On an
INIT VM-Exit, KVM immediately resumes the guest.  On Haswell client system,
the INIT does indeed appear to be consumed when it's handled by VM-Exit,
i.e. KVM doesn't get stuck in an infinite INIT VM-Exits loop.

One possible explanation for the infinite loop observed in (1) above, is
that the developer didn't properly reconfigure guest state when emulating
INIT and hit a VM-Fail.  Because vmcs.EXIT_REASON isn't written on VM-Fail,
if the VMM isn't checking for VM-Fail it will think it's getting endless
INIT VM-Exits.  I did exactly this when tweaking KVM to handle INIT (forgot
to mark the VMCS as launched redoing VM-Enter), so I even inadvertantly
confirmed that it's plausible :-)
