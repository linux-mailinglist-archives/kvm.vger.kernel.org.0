Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4682CAC79
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 20:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392383AbgLATgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 14:36:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57504 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387432AbgLATgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 14:36:31 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606851348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QoHglNiFqttLAMD1LnFOWcb3m1VkGTd8+DTKZfhRou4=;
        b=Is4eUNZJildV/CJ7l16sguVDyRab5B0iwcWHirrqKmHtJ6ceKhon/evkdbqvcVDlXihlap
        rGVrlk4daTkHDcNWSG70CcvUc7v+AIY54FGZX2fW213nNnzvvmPpColVINF0B0r2IRkC5t
        hLvjnXwC2ihlnEoAZjiIsViD+ZLdxLi0q7X9d8qkY1f6YYnKeMX/4nf/COP17Q/b2MR32K
        CoZ5ke5mfb5RhDlgGFLFI9z60mZy/nTIwVxm8CN9tASQEEng/uV9G/rnxWoJeU+lajSB13
        KGwlLOHewqR8przTSMm3RSzPwWsGHW2kV1iV02QJ2pxR18mgM+wteu36seAeEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606851348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QoHglNiFqttLAMD1LnFOWcb3m1VkGTd8+DTKZfhRou4=;
        b=dONq+lQABPzBv+OJYQCxDUQXqDV+Gf6gt31FFJ5enKhUz2/I1cqlvOP4vw3wiIRPIH7CLD
        OKxpTvpUdIRcJqAA==
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
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
        "open list\:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer\:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration
In-Reply-To: <20201130133559.233242-1-mlevitsk@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
Date:   Tue, 01 Dec 2020 20:35:48 +0100
Message-ID: <87lfehfhez.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 30 2020 at 15:35, Maxim Levitsky wrote:
> The idea of masterclock is that when the host TSC is synchronized
> (or as kernel call it, stable), and the guest TSC is synchronized as well,
> then we can base the kvmclock, on the same pair of
> (host time in nsec, host tsc value), for all vCPUs.

That's correct. All guest CPUs should see exactly the same TSC value,
i.e.

        hostTSC + vcpu_offset

> This makes the random error in calculation of this value invariant
> across vCPUS, and allows the guest to do kvmclock calculation in userspace
> (vDSO) since kvmclock parameters are vCPU invariant.

That's not the case today? OMG!

> To ensure that the guest tsc is synchronized we currently track host/guest tsc
> writes, and enable the master clock only when roughly the same guest's TSC value
> was written across all vCPUs.

The Linux kernel never writes the TSC. We've tried that ~15 years ago
and it was a total disaster.

> Recently this was disabled by Paulo and I agree with this, because I think
> that we indeed should only make the guest TSC synchronized by default
> (including new hotplugged vCPUs) and not do any tsc synchronization beyond that.
> (Trying to guess when the guest syncs the TSC can cause more harm that good).
>
> Besides, Linux guests don't sync the TSC via IA32_TSC write,
> but rather use IA32_TSC_ADJUST which currently doesn't participate
> in the tsc sync heruistics.

The kernel only writes TSC_ADJUST when it is advertised in CPUID and:

    1) when the boot CPU detects a non-zero TSC_ADJUST value it writes
       it to 0, except when running on SGI-UV

    2) when a starting CPU has a different TSC_ADJUST value than the
       first CPU which came up on the same socket.

    3) When the first CPU of a different socket is starting and the TSC
       synchronization check fails against a CPU on an already checked
       socket then the kernel tries to adjust TSC_ADJUST to the point
       that the synchronization check does not fail anymore.

> And as far as I know, Linux guest is the primary (only?) user of the kvmclock.
>
> I *do think* however that we should redefine KVM_CLOCK_TSC_STABLE
> in the documentation to state that it only guarantees invariance if the guest
> doesn't mess with its own TSC.
>
> Also I think we should consider enabling the X86_FEATURE_TSC_RELIABLE
> in the guest kernel, when kvm is detected to avoid the guest even from trying
> to sync TSC on newly hotplugged vCPUs.
>
> (The guest doesn't end up touching TSC_ADJUST usually, but it still might
> in some cases due to scheduling of guest vCPUs)

The only cases it would try to write are #3 above or because the
hypervisor or BIOS messed it up (#1, #2).

> (X86_FEATURE_TSC_RELIABLE short circuits tsc synchronization on CPU hotplug,
> and TSC clocksource watchdog, and the later we might want to keep).

Depends. If the host TSC is stable and synchronized, then you don't need
the TSC watchdog. We are slowly starting to trust the TSC to some extent
and phase out the watchdog for newer parts (hopefully).

If the host TSC really falls apart then it still can invalidate
KVM_CLOCK and force the guest to reevaluate the situation.

> Few more random notes:
>
> I have a weird feeling about using 'nsec since 1 January 1970'.
> Common sense is telling me that a 64 bit value can hold about 580
> years,

which is plenty.

> but still I see that it is more common to use timespec which is a
> (sec,nsec) pair.

timespecs are horrible.

Thanks,

        tglx
