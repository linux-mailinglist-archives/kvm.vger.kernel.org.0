Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B232C8DD8
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 20:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgK3TSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 14:18:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727209AbgK3TSi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 14:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606763830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CfLmqkWBWEXsXi8mF8WiPMoexLzcqFMvnE5H0chb+ec=;
        b=CyE+YbeDYwGcjBtU9EZngGs4hi0piFSfoWFjKAMl3pGcp5hdXfaCrg5KgtflIhDrcJ1g7S
        5zKEUy4iGUqlsdbMAJyc6o25Nvh35nuSQHtERoxUPJehy823/7BamX3E6iVtgC1PC7mcvz
        M0mOYNXtJBMGWqd3zvTzcSjhlmhhOO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-NfV-EYBsPvGuf63yox1L3g-1; Mon, 30 Nov 2020 14:17:07 -0500
X-MC-Unique: NfV-EYBsPvGuf63yox1L3g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C79B11006C86;
        Mon, 30 Nov 2020 19:17:05 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-6.gru2.redhat.com [10.97.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2E8E60C71;
        Mon, 30 Nov 2020 19:17:04 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 5D76A416D87C; Mon, 30 Nov 2020 16:16:43 -0300 (-03)
Date:   Mon, 30 Nov 2020 16:16:43 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration
Message-ID: <20201130191643.GA18861@fuller.cnet>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130133559.233242-1-mlevitsk@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On Mon, Nov 30, 2020 at 03:35:57PM +0200, Maxim Levitsky wrote:
> Hi!
> 
> This is the first version of the work to make TSC migration more accurate,
> as was defined by Paulo at:
> https://www.spinics.net/lists/kvm/msg225525.html

Description from Oliver's patch:

"To date, VMMs have typically restored the guest's TSCs by value using
the KVM_SET_MSRS ioctl for each vCPU. However, restoring the TSCs by
value introduces some challenges with synchronization as the TSCs
continue to tick throughout the restoration process. As such, KVM has
some heuristics around TSC writes to infer whether or not the guest or
host is attempting to synchronize the TSCs."

Not really. The synchronization logic tries to sync TSCs during
BIOS boot (and CPU hotplug), because the TSC values are loaded
sequentially, say:

CPU		realtime	TSC val
vcpu0		0 usec		0
vcpu1		100 usec	0
vcpu2		200 usec	0
...

And we'd like to see all vcpus to read the same value at all times.

Other than that, comment makes sense. The problem with live migration
is as follows:

We'd like the TSC value to be written, ideally, just before the first
VM-entry a vCPU (because at the moment the TSC_OFFSET has been written, 
the vcpus tsc is ticking, which will cause a visible forward jump
in vcpus tsc time).

Before the first VM-entry is the farthest point in time before guest
entry that one could do that.

The window (or forward jump) between KVM_SET_TSC and VM-entry was about
100ms last time i checked (which results in a 100ms time jump forward), 
See QEMU's 6053a86fe7bd3d5b07b49dae6c05f2cd0d44e687.

Have we measured any improvement with this patchset?

Then Paolo mentions (with >), i am replying as usual.

> Ok, after looking more at the code with Maxim I can confidently say that
> it's a total mess.  And a lot of the synchronization code is dead
> because 1) as far as we could see no guest synchronizes the TSC using
> MSR_IA32_TSC; 

Well, recent BIOS'es take care of synchronizing the TSC. So when Linux
boots, it does not have to synchronize TSC in software. 

However, upon migration (and initialization), the KVM_SET_TSC's do 
not happen at exactly the same time (the MSRs for each vCPU are loaded
in sequence). The synchronization code in kvm_set_tsc() is for those cases.

> and 2) writing to MSR_IA32_TSC_ADJUST does not trigger the
> synchronization code in kvm_write_tsc.

Not familiar how guests are using MSR_IA32_TSC_ADJUST (or Linux)...
Lets see:


/*
 * Freshly booted CPUs call into this:
 */
void check_tsc_sync_target(void)
{
        struct tsc_adjust *cur = this_cpu_ptr(&tsc_adjust);
        unsigned int cpu = smp_processor_id();
        cycles_t cur_max_warp, gbl_max_warp;
        int cpus = 2;

        /* Also aborts if there is no TSC. */
        if (unsynchronized_tsc())
                return;

        /*
         * Store, verify and sanitize the TSC adjust register. If
         * successful skip the test.
         *
         * The test is also skipped when the TSC is marked reliable. This
         * is true for SoCs which have no fallback clocksource. On these
         * SoCs the TSC is frequency synchronized, but still the TSC ADJUST
         * register might have been wreckaged by the BIOS..
         */
        if (tsc_store_and_check_tsc_adjust(false) || tsc_clocksource_reliable) {
                atomic_inc(&skip_test);
                return;
        }

retry:

I'd force that synchronization path to be taken as a test-case.


> I have a few thoughts about the kvm masterclock synchronization,
> which relate to the Paulo's proposal that I implemented.
> 
> The idea of masterclock is that when the host TSC is synchronized
> (or as kernel call it, stable), and the guest TSC is synchronized as well,
> then we can base the kvmclock, on the same pair of
> (host time in nsec, host tsc value), for all vCPUs.

We _have_ to base. See the comment which starts with

"Assuming a stable TSC across physical CPUS, and a stable TSC"

at x86.c.

> 
> This makes the random error in calculation of this value invariant
> across vCPUS, and allows the guest to do kvmclock calculation in userspace
> (vDSO) since kvmclock parameters are vCPU invariant.

Actually, without synchronized host TSCs (and the masterclock scheme,
with a single base read from a vCPU), kvmclock in kernel is buggy as
well:

u64 pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
{
        unsigned version;
        u64 ret;
        u64 last;
        u8 flags;

        do {
                version = pvclock_read_begin(src);
                ret = __pvclock_read_cycles(src, rdtsc_ordered());
                flags = src->flags;
        } while (pvclock_read_retry(src, version));

        if (unlikely((flags & PVCLOCK_GUEST_STOPPED) != 0)) {
                src->flags &= ~PVCLOCK_GUEST_STOPPED;
                pvclock_touch_watchdogs();
        }

        if ((valid_flags & PVCLOCK_TSC_STABLE_BIT) &&
                (flags & PVCLOCK_TSC_STABLE_BIT))
                return ret;

The code that follows this (including cmpxchg) is a workaround for that 
bug.

Workaround would require each vCPU to write to a "global clock", on
every clock read.

> To ensure that the guest tsc is synchronized we currently track host/guest tsc
> writes, and enable the master clock only when roughly the same guest's TSC value
> was written across all vCPUs.

Yes, because then you can do:

vcpu0				vcpu1

A = read TSC
		... elapsed time ...

				B = read TSC

				delta = B - A

> Recently this was disabled by Paulo

What was disabled exactly?

> and I agree with this, because I think
> that we indeed should only make the guest TSC synchronized by default
> (including new hotplugged vCPUs) and not do any tsc synchronization beyond that.
> (Trying to guess when the guest syncs the TSC can cause more harm that good).
> 
> Besides, Linux guests don't sync the TSC via IA32_TSC write,
> but rather use IA32_TSC_ADJUST which currently doesn't participate
> in the tsc sync heruistics.

Linux should not try to sync the TSC with IA32_TSC_ADJUST. It expects
the BIOS to boot with synced TSCs.

So i wonder what is making it attempt TSC sync in the first place?

(one might also want to have Linux's synchronization via IA32_TSC_ADJUST 
working, but it should not need to happen in the first place, as long as 
QEMU and KVM are behaving properly).

> And as far as I know, Linux guest is the primary (only?) user of the kvmclock.

Only AFAIK.

> I *do think* however that we should redefine KVM_CLOCK_TSC_STABLE
> in the documentation to state that it only guarantees invariance if the guest
> doesn't mess with its own TSC.
> 
> Also I think we should consider enabling the X86_FEATURE_TSC_RELIABLE
> in the guest kernel, when kvm is detected to avoid the guest even from trying
> to sync TSC on newly hotplugged vCPUs.

See 7539b174aef405d9d57db48c58390ba360c91312. 

Was hoping to make that (-cpu xxx,+invtsc) the default in QEMU once invariant TSC code
becomes stable. Should be tested enough by now?

> (The guest doesn't end up touching TSC_ADJUST usually, but it still might
> in some cases due to scheduling of guest vCPUs)
> 
> (X86_FEATURE_TSC_RELIABLE short circuits tsc synchronization on CPU hotplug,
> and TSC clocksource watchdog, and the later we might want to keep).

The latter we want to keep.

> For host TSC writes, just as Paulo proposed we can still do the tsc sync,
> unless the new code that I implemented is in use.

So Paolo's proposal is to

"- for live migration, userspace is expected to use the new
KVM_GET/SET_TSC_PRECISE (or whatever the name will be) to get/set a
(nanosecond, TSC, TSC_ADJUST) tuple."

Makes sense, so that no time between KVM_SET_TSC and
MSR_WRITE(TSC_ADJUST) elapses, which would cause the TSC to go out
of what is desired by the user.

Since you are proposing this new ioctl, perhaps its useful to also
reduce the 100ms jump? 

"- for live migration, userspace is expected to use the new
KVM_GET/SET_TSC_PRECISE (or whatever the name will be) to get/set a
(nanosecond, TSC, TSC_ADJUST) tuple. This value will be written
to the guest before the first VM-entry"

Sounds like a good idea (to integrate the values in a tuple).

> Few more random notes:
> 
> I have a weird feeling about using 'nsec since 1 January 1970'.
> Common sense is telling me that a 64 bit value can hold about 580 years,
> but still I see that it is more common to use timespec which is a (sec,nsec) pair.

           struct timespec {
               time_t   tv_sec;        /* seconds */
               long     tv_nsec;       /* nanoseconds */
           };

> I feel that 'kvm_get_walltime' that I added is a bit of a hack.
> Some refactoring might improve things here.

Haven't read the patchset yet...

> For example making kvm_get_walltime_and_clockread work in non tsc case as well
> might make the code cleaner.
> 
> Patches to enable this feature in qemu are in process of being sent to
> qemu-devel mailing list.
> 
> Best regards,
>        Maxim Levitsky
> 
> Maxim Levitsky (2):
>   KVM: x86: implement KVM_SET_TSC_PRECISE/KVM_GET_TSC_PRECISE
>   KVM: x86: introduce KVM_X86_QUIRK_TSC_HOST_ACCESS
> 
>  Documentation/virt/kvm/api.rst  | 56 +++++++++++++++++++++
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/x86.c              | 88 +++++++++++++++++++++++++++++++--
>  include/uapi/linux/kvm.h        | 14 ++++++
>  4 files changed, 154 insertions(+), 5 deletions(-)
> 
> -- 
> 2.26.2
> 

