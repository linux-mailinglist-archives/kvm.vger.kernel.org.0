Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0233A18C4
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhFIPOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:14:40 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:33617 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhFIPOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 11:14:39 -0400
Received: by mail-lj1-f182.google.com with SMTP id r16so370590ljc.0
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 08:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JGUUCTtXTTeYEECuVevk8FQeH2xp0FWF48S+xEf+80E=;
        b=PQfwLDjbofmW9Ahl4Xw3X8MHKyFvvBaielxhyyLoexE2kFNa6Wa68I+LFzVD4TqY4H
         XB0LXx6c0FctXFKycXQaRobS67G+J2comWM2i9a0QGG/6yIL15t5Cqemv6PTgsha8DQV
         MKeAOYjwG/vlh3FWLlM/BtNQmPyLswJdWBBt4SNWjRyZ++g69wPpT6+N0pq5vd0t1lYH
         fX40q7Z8HX1htlFk9kx/4ZaXSheQwAgvQL2FAwVsyBckwqZWEUDPRaXDYwzzA8LTAHpM
         fb/pozSB4V3WPgvEiynEomCs56kveGZgSrMcrlyw0XbqkTd6ok81cTDlLqS2x1p7NGRj
         IBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JGUUCTtXTTeYEECuVevk8FQeH2xp0FWF48S+xEf+80E=;
        b=iHoiM/8P4q+2fSR4U7eI1x7WxF6d69lcbsyX+7c5Rdx/Od0xe8uvo5W+Hctlo9hfEg
         lb0ALUtFcl7oHChLjSZKXNpzTodVSkX/8tV2WugyJwNc6XMG2jteMDBG1BUk74+ZCAd4
         6+Oi3Pp2/euz9VewDxD1Oj1A4bBQUWDG8LvO/DiNP+xqm7W3QwDG3Wa3WibdYJYPmpgm
         Nbn2qjdsYTKV1lNcjph7EDW1qae+i0N6gUzmlKIKgcyfr/UkmnRAP3H8yp1lZHt5NnCa
         B+12y2RymgsfoptJ2goed0+4rX6r9JqLe3g1nKLj0RVkt+hhKS8xaDAt++3EpHDZy6N9
         tUuA==
X-Gm-Message-State: AOAM531WWCJs03a/d9IeVFOLo+ZT6bou1tgeKxwJBl5reomysaP07TV6
        xDwDbHncLswXaNXkAiEvvIpnacIaf5rNx/8/5wGnnQ==
X-Google-Smtp-Source: ABdhPJzDC3/C1q9lhv5RzcnKGHEbvuFjt2/BpMm446NEtxECFSiu0Y2oJ55X7bPQrCWKUf1iQTYNh7DBrzWXrkDfPFA=
X-Received: by 2002:a05:651c:a0a:: with SMTP id k10mr357832ljq.22.1623251503619;
 Wed, 09 Jun 2021 08:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com> <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
In-Reply-To: <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 9 Jun 2021 10:11:32 -0500
Message-ID: <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 9, 2021 at 8:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 08/06/21 23:47, Oliver Upton wrote:
> > KVM's current means of saving/restoring system counters is plagued with
> > temporal issues. At least on ARM64 and x86, we migrate the guest's
> > system counter by-value through the respective guest system register
> > values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
> > brittle as the state is not idempotent: the host system counter is still
> > oscillating between the attempted save and restore. Furthermore, VMMs
> > may wish to transparently live migrate guest VMs, meaning that they
> > include the elapsed time due to live migration blackout in the guest
> > system counter view. The VMM thread could be preempted for any number of
> > reasons (scheduler, L0 hypervisor under nested) between the time that
> > it calculates the desired guest counter value and when KVM actually sets
> > this counter state.
> >
> > Despite the value-based interface that we present to userspace, KVM
> > actually has idempotent guest controls by way of system counter offsets.
> > We can avoid all of the issues associated with a value-based interface
> > by abstracting these offset controls in new ioctls. This series
> > introduces KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls, meant to provide
> > userspace with idempotent controls of the guest system counter.
>
> Hi Oliver,
>
> I wonder how this compares to the idea of initializing the TSC via a
> synchronized (nanoseconds, TSC) pair.
> (https://lore.kernel.org/r/20201130133559.233242-2-mlevitsk@redhat.com),
> and whether it makes sense to apply that idea to ARM as well.  If so, it
> certainly is a good idea to use the same capability and ioctl, even
> though the details of the struct would be architecture-dependent.

Hey Paolo,

Yeah, great question, I had actually alluded to this on [02/10] in
talking to Marc about this.

Really the issue we want to avoid is sampling the host counter twice,
which at least based on the existing means of counter migration is
impossible as the VMM must account for elapsed time. Maxim's patches
appear to address that very issue as well.

Perhaps this will clarify the motivation for my approach: what if the
kernel wasn't the authoritative source for wall time in a system?
Furthermore, VMMs may wish to define their own heuristics for counter
migration (e.g. we only allow the counter to 'jump' by X seconds
during migration blackout). If a VMM tried to assert its whims on the
TSC state before handing it down to the kernel, we would inadvertently
be sampling the host counter twice again. And, anything can happen
between the time we assert elapsed time is within SLO and KVM
computing the TSC offset (scheduling, L0 hypervisor preemption).

So, Maxim's changes would address my concerns in the general case, but
maybe not as much in edge cases where an operator may make decisions
about how much time can elapse while the guest hasn't had CPU time.

--
Thanks,
Oliver

> In your patches there isn't much architecture dependency in struct
> kvm_system_counter_state.  However,  Maxim's also added an
> MSR_IA32_TSC_ADJUST value to the struct, thus ensuring that the host
> could write not just an arbitrary TSC value, but also tie it to an
> arbitrary MSR_IA32_TSC_ADJUST value.  Specifying both in the same ioctl
> simplifies the userspace API.
>
> Paolo
>
> > Patch 1 defines the ioctls, and was separated from the two provided
> > implementations for the sake of review. If it is more intuitive, this
> > patch can be squashed into the implementation commit.
> >
> > Patch 2 realizes initial support for ARM64, migrating only the state
> > associated with the guest's virtual counter-timer. Patch 3 introduces a
> > KVM selftest to assert that userspace manipulation via the
> > aforementioned ioctls produces the expected system counter values within
> > the guest.
> >
> > Patch 4 extends upon the ARM64 implementation by adding support for
> > physical counter-timer offsetting. This is currently backed by a
> > trap-and-emulate implementation, but can also be virtualized in hardware
> > that fully implements ARMv8.6-ECV. ECV support has been elided from this
> > series out of convenience for the author :) Patch 5 adds some test cases
> > to the newly-minted kvm selftest to validate expectations of physical
> > counter-timer emulation.
> >
> > Patch 6 introduces yet another KVM selftest for aarch64, intended to
> > measure the effects of physical counter-timer emulation. Data for this
> > test can be found below, but basically there is some tradeoff of
> > overhead for the sake of correctness, but it isn't too bad.
> >
> > Patches 7-8 add support for the ioctls to x86 by shoehorning the
> > controls into the pre-existing synchronization heuristics. Patch 7
> > provides necessary helper methods for the implementation to play nice
> > with those heuristics, and patch 8 actually implements the ioctls.
> >
> > Patch 9 adds x86 test cases to the system counter KVM selftest. Lastly,
> > patch 10 documents the ioctls for both x86 and arm64.
> >
> > All patches apply cleanly to kvm/next at the following commit:
> >
> > a4345a7cecfb ("Merge tag 'kvmarm-fixes-5.13-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")
> >
> > Physical counter benchmark
> > --------------------------
> >
> > The following data was collected by running 10000 iterations of the
> > benchmark test from Patch 6 on an Ampere Mt. Jade reference server, A 2S
> > machine with 2 80-core Ampere Altra SoCs. Measurements were collected
> > for both VHE and nVHE operation using the `kvm-arm.mode=` command-line
> > parameter.
> >
> > nVHE
> > ----
> >
> > +--------------------+--------+---------+
> > |       Metric       | Native | Trapped |
> > +--------------------+--------+---------+
> > | Average            | 54ns   | 148ns   |
> > | Standard Deviation | 124ns  | 122ns   |
> > | 95th Percentile    | 258ns  | 348ns   |
> > +--------------------+--------+---------+
> >
> > VHE
> > ---
> >
> > +--------------------+--------+---------+
> > |       Metric       | Native | Trapped |
> > +--------------------+--------+---------+
> > | Average            | 53ns   | 152ns   |
> > | Standard Deviation | 92ns   | 94ns    |
> > | 95th Percentile    | 204ns  | 307ns   |
> > +--------------------+--------+---------+
> >
> > Oliver Upton (10):
> >    KVM: Introduce KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
> >    KVM: arm64: Implement initial support for KVM_CAP_SYSTEM_COUNTER_STATE
> >    selftests: KVM: Introduce system_counter_state_test
> >    KVM: arm64: Add userspace control of the guest's physical counter
> >    selftests: KVM: Add test cases for physical counter offsetting
> >    selftests: KVM: Add counter emulation benchmark
> >    KVM: x86: Refactor tsc synchronization code
> >    KVM: x86: Implement KVM_CAP_SYSTEM_COUNTER_STATE
> >    selftests: KVM: Add support for x86 to system_counter_state_test
> >    Documentation: KVM: Document KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
> >
> >   Documentation/virt/kvm/api.rst                |  98 +++++++
> >   Documentation/virt/kvm/locking.rst            |  11 +
> >   arch/arm64/include/asm/kvm_host.h             |   6 +
> >   arch/arm64/include/asm/sysreg.h               |   1 +
> >   arch/arm64/include/uapi/asm/kvm.h             |  17 ++
> >   arch/arm64/kvm/arch_timer.c                   |  84 +++++-
> >   arch/arm64/kvm/arm.c                          |  25 ++
> >   arch/arm64/kvm/hyp/include/hyp/switch.h       |  31 +++
> >   arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  16 +-
> >   arch/x86/include/asm/kvm_host.h               |   1 +
> >   arch/x86/include/uapi/asm/kvm.h               |   8 +
> >   arch/x86/kvm/x86.c                            | 176 +++++++++---
> >   include/uapi/linux/kvm.h                      |   5 +
> >   tools/testing/selftests/kvm/.gitignore        |   2 +
> >   tools/testing/selftests/kvm/Makefile          |   3 +
> >   .../kvm/aarch64/counter_emulation_benchmark.c | 209 ++++++++++++++
> >   .../selftests/kvm/include/aarch64/processor.h |  24 ++
> >   .../selftests/kvm/system_counter_state_test.c | 256 ++++++++++++++++++
> >   18 files changed, 926 insertions(+), 47 deletions(-)
> >   create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> >   create mode 100644 tools/testing/selftests/kvm/system_counter_state_test.c
> >
>
