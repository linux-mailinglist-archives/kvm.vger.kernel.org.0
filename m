Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5679E2CD5ED
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 13:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgLCMtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 07:49:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730459AbgLCMtc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 07:49:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606999685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jaqQCXmjfEcg2hzfVWiBAXfpRwQrLZM2x3fGQCZ1SLM=;
        b=jMCwH7JgnJ3n6Q07lU319XD99IxU5djsCBf2WaFlKG4n/zLu9hZ5rweu5ASJQMKFkFruS9
        uxU8/q4kSn/WYgVR1jkyQVhxRbPzaQiCmsEf99FkpCeE/s0BHcEhZlUmKJcv4Cgdmq6Akj
        9XP8QmZnUsnlYI0OfvFAgJWuY5No3+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-PkV3GKOJNBi8LM_DGUNDMA-1; Thu, 03 Dec 2020 07:48:03 -0500
X-MC-Unique: PkV3GKOJNBi8LM_DGUNDMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0DC256C33;
        Thu,  3 Dec 2020 12:48:01 +0000 (UTC)
Received: from starship (unknown [10.35.206.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0788100164C;
        Thu,  3 Dec 2020 12:47:55 +0000 (UTC)
Message-ID: <2c5b2064e7b185d11544033b0bf797db76cf66d8.camel@redhat.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Thu, 03 Dec 2020 14:47:54 +0200
In-Reply-To: <87lfehfhez.fsf@nanos.tec.linutronix.de>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
         <87lfehfhez.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-12-01 at 20:35 +0100, Thomas Gleixner wrote:
> On Mon, Nov 30 2020 at 15:35, Maxim Levitsky wrote:
> > The idea of masterclock is that when the host TSC is synchronized
> > (or as kernel call it, stable), and the guest TSC is synchronized as well,
> > then we can base the kvmclock, on the same pair of
> > (host time in nsec, host tsc value), for all vCPUs.
> 
> That's correct. All guest CPUs should see exactly the same TSC value,
> i.e.
> 
>         hostTSC + vcpu_offset

This is roughly the case today, unless the guest messes up
its own TSC, which it is allowed to do so.
 
And that brings me an idea: Why do we allow the guest
to mess up with its TSC in the first place?

Can't we just stop exposing the TSC_ADJUST to the guest,
since it is an optional x86 feature?
 
In addition to that I also had read somewhere 
that TSC writes aren't even guaranteed to work on some x86 systems
(e.g that msr can be readonly, and that's why TSC_ADJUST was created)
so I'll say we can go even further and just ignore
writes to TSC from the guest as well.

Or if this is too much, we can just ignore this 
since Linux doesn't touch the TSC anyway.
 
Best feature is no feature, you know.


> 
> > This makes the random error in calculation of this value invariant
> > across vCPUS, and allows the guest to do kvmclock calculation in userspace
> > (vDSO) since kvmclock parameters are vCPU invariant.
> 
> That's not the case today? OMG!

We have the masterclock to avoid this, whose existence we trickle
down to the guest via KVM_CLOCK_TSC_STABLE bit.
 
When master clock is not enabled (due to one of the reasons
I mentioned in the RFC mail), this bit is not set,
and the guest fails back to do system calls.

> 
> > To ensure that the guest tsc is synchronized we currently track host/guest tsc
> > writes, and enable the master clock only when roughly the same guest's TSC value
> > was written across all vCPUs.
> 
> The Linux kernel never writes the TSC. We've tried that ~15 years ago
> and it was a total disaster.
I can imagine this.

> 
> > Recently this was disabled by Paulo and I agree with this, because I think
> > that we indeed should only make the guest TSC synchronized by default
> > (including new hotplugged vCPUs) and not do any tsc synchronization beyond that.
> > (Trying to guess when the guest syncs the TSC can cause more harm that good).
> > 
> > Besides, Linux guests don't sync the TSC via IA32_TSC write,
> > but rather use IA32_TSC_ADJUST which currently doesn't participate
> > in the tsc sync heruistics.
> 
> The kernel only writes TSC_ADJUST when it is advertised in CPUID and:
> 
>     1) when the boot CPU detects a non-zero TSC_ADJUST value it writes
>        it to 0, except when running on SGI-UV
> 
>     2) when a starting CPU has a different TSC_ADJUST value than the
>        first CPU which came up on the same socket.
> 
>     3) When the first CPU of a different socket is starting and the TSC
>        synchronization check fails against a CPU on an already checked
>        socket then the kernel tries to adjust TSC_ADJUST to the point
>        that the synchronization check does not fail anymore.
Since we do allow multi socket guests, I guess (3) can still fail
due to scheduling noise and make the guest write TSC_ADJUST.

> 
> > And as far as I know, Linux guest is the primary (only?) user of the kvmclock.
> > 
> > I *do think* however that we should redefine KVM_CLOCK_TSC_STABLE
> > in the documentation to state that it only guarantees invariance if the guest
> > doesn't mess with its own TSC.
> > 
> > Also I think we should consider enabling the X86_FEATURE_TSC_RELIABLE
> > in the guest kernel, when kvm is detected to avoid the guest even from trying
> > to sync TSC on newly hotplugged vCPUs.
> > 
> > (The guest doesn't end up touching TSC_ADJUST usually, but it still might
> > in some cases due to scheduling of guest vCPUs)
> 
> The only cases it would try to write are #3 above or because the
> hypervisor or BIOS messed it up (#1, #2).
> 
> > (X86_FEATURE_TSC_RELIABLE short circuits tsc synchronization on CPU hotplug,
> > and TSC clocksource watchdog, and the later we might want to keep).
> 
> Depends. If the host TSC is stable and synchronized, then you don't need
> the TSC watchdog. We are slowly starting to trust the TSC to some extent
> and phase out the watchdog for newer parts (hopefully).
> 
> If the host TSC really falls apart then it still can invalidate
> KVM_CLOCK and force the guest to reevaluate the situation.
> 
> > Few more random notes:
> > 
> > I have a weird feeling about using 'nsec since 1 January 1970'.
> > Common sense is telling me that a 64 bit value can hold about 580
> > years,
> 
> which is plenty.
I also think so, just wanted to hear your opinion on that.
> 
> > but still I see that it is more common to use timespec which is a
> > (sec,nsec) pair.
> 
> timespecs are horrible.

Best regards,
	Maxim Levitsky

> 
> Thanks,
> 
>         tglx
> 


