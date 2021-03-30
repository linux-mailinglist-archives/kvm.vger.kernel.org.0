Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283DF34F10C
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 20:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbhC3SdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 14:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbhC3Scf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 14:32:35 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C97C061762
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 11:32:34 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id z136so17437566iof.10
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 11:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ry6+wSaahnTAtySVVADqpebYg77xvyK52stUUFNcEOE=;
        b=LdVURA+kcNmnzr/OmxvAldswhg5Hv5K+yZBcwCjQoMugQeFaMm3UMyYuNoBFuURK7x
         wW9jUPDk/lN2NWOWWx0C+HM8fHbdwPVXOoGeR3GF2krU9rJukM386cGHQW8I5mKRlRhl
         FK944SqBcaNxe9bg0srb4MmcOByctpvvrYF/uEDGOooXDy9x7lW0dq8OJxF2/6wG6mh8
         QUtdaXz6D2omEiXIzbRACVWnf7gARf2rCWDNFLpUCSjV3bjZ6TrZFZVX7zDhTaQ1xch3
         f/yGaKwbqEli9Uvqsxq31Y2h/cqT4iY2RLC+2faOt9pr4StzcjyvoFLtPEvayIi0J9vr
         40BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ry6+wSaahnTAtySVVADqpebYg77xvyK52stUUFNcEOE=;
        b=JgZar59gAf2Ais8XzhVGRpA1VyPgwUGVgjT0Amokk7xBjPshEJOlkJaWDBm+NzgRM2
         Y0ssaQF1OK4bX0UQ7X7vI9lEVMcygFhTKU1MlwkCiLcu2HztSl+0fVgyz47fodyjQoEW
         EnYIEhvur5joWl1ekL4Hl672SRBkXj88mVwzRYDjlV8qA7R3gnZWZmGvLkJOlfZ7MEh3
         DpZDJ5aw0NwUE4CcFwNd3HN+e3zecGck/Y2dmiYbKqv7zF+so8aV9pA7gpJSBT1aVIbO
         ssYVE0Jhq7T7ZwV9tWe6QAzMreTp2ihj7trilt/ZvqlhoMJMe7CfxCJgShLyXxqanxph
         Fhzw==
X-Gm-Message-State: AOAM532uLH/kUISd7iYmi6AmQ7JQnh4FMV7Vutc8G8sA2yDFQ/GNFzsu
        nLWr8ybqypfyq4wSgD3Xv8FHtVz/vdz6tnGxQP3LIw==
X-Google-Smtp-Source: ABdhPJydba/r9kFe0x64VHG21TaCqRbVPKRpUh3kGFyYZT4VeQOXcqv0jV6nWOmc06Khu/5vhjH/mZsKNTnmLddBUEQ=
X-Received: by 2002:a5d:9959:: with SMTP id v25mr26278546ios.189.1617129153795;
 Tue, 30 Mar 2021 11:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 30 Mar 2021 11:32:22 -0700
Message-ID: <CANgfPd_gpWsa4F3VdcpoBYqPR4dSBWNYCW1YdeOnu1wQdUz+0A@mail.gmail.com>
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        kvm-ppc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 7:20 PM Sean Christopherson <seanjc@google.com> wrote:
>
> The end goal of this series is to optimize the MMU notifiers to take
> mmu_lock if and only if the notification is relevant to KVM, i.e. the hva
> range overlaps a memslot.   Large VMs (hundreds of vCPUs) are very
> sensitive to mmu_lock being taken for write at inopportune times, and
> such VMs also tend to be "static", e.g. backed by HugeTLB with minimal
> page shenanigans.  The vast majority of notifications for these VMs will
> be spurious (for KVM), and eliding mmu_lock for spurious notifications
> avoids an otherwise unacceptable disruption to the guest.
>
> To get there without potentially degrading performance, e.g. due to
> multiple memslot lookups, especially on non-x86 where the use cases are
> largely unknown (from my perspective), first consolidate the MMU notifier
> logic by moving the hva->gfn lookups into common KVM.
>
> Applies on my TDP MMU TLB flushing bug fixes[*], which conflict horribly
> with the TDP MMU changes in this series.  That code applies on kvm/queue
> (commit 4a98623d5d90, "KVM: x86/mmu: Mark the PAE roots as decrypted for
> shadow paging").
>
> Speaking of conflicts, Ben will soon be posting a series to convert a
> bunch of TDP MMU flows to take mmu_lock only for read.  Presumably there
> will be an absurd number of conflicts; Ben and I will sort out the
> conflicts in whichever series loses the race.
>
> Well tested on Intel and AMD.  Compile tested for arm64, MIPS, PPC,
> PPC e500, and s390.  Absolutely needs to be tested for real on non-x86,
> I give it even odds that I introduced an off-by-one bug somewhere.
>
> [*] https://lkml.kernel.org/r/20210325200119.1359384-1-seanjc@google.com
>
>
> Patches 1-7 are x86 specific prep patches to play nice with moving
> the hva->gfn memslot lookups into common code.  There ended up being waaay
> more of these than I expected/wanted, but I had a hell of a time getting
> the flushing logic right when shuffling the memslot and address space
> loops.  In the end, I was more confident I got things correct by batching
> the flushes.
>
> Patch 8 moves the existing API prototypes into common code.  It could
> technically be dropped since the old APIs are gone in the end, but I
> thought the switch to the new APIs would suck a bit less this way.

Patches 1-8 look good to me. Feel free to add my Reviewed-by tag to those.
I appreciate the care you took to make all those changes tiny and reviewable.

>
> Patch 9 moves arm64's MMU notifier tracepoints into common code so that
> they are not lost when arm64 is converted to the new APIs, and so that all
> architectures can benefit.
>
> Patch 10 moves x86's memslot walkers into common KVM.  I chose x86 purely
> because I could actually test it.  All architectures use nearly identical
> code, so I don't think it actually matters in the end.

I'm still reviewing 10 and 14-18. 10 is a huge change and the diff is
pretty hard to parse.

>
> Patches 11-13 move arm64, MIPS, and PPC to the new APIs.
>
> Patch 14 yanks out the old APIs.
>
> Patch 15 adds the mmu_lock elision, but only for unpaired notifications.

Reading through all this code and considering the changes I'm
preparing for the TDP MMU have me wondering if it might help to have a
more general purpose MMU lock context struct which could be embedded
in the structs added in this patch. I'm thinking something like:
enum kvm_mmu_lock_mode {
    KVM_MMU_LOCK_NONE,
    KVM_MMU_LOCK_READ,
    KVM_MMU_LOCK_WRITE,
};

struct kvm_mmu_lock_context {
    enum kvm_mmu_lock_mode lock_mode;
    bool can_block;
    bool can_yield;
    bool flush;
};

This could yield some grossly long lines, but it would also have
potential to unify a bunch of ad-hoc handling.
The above struct could also fit into a single byte, so it'd be pretty
easy to pass it around.

>
> Patch 16 adds mmu_lock elision for paired .invalidate_range_{start,end}().
> This is quite nasty and no small part of me thinks the patch should be
> burned with fire (I won't spoil it any further), but it's also the most
> problematic scenario for our particular use case.  :-/
>
> Patches 17-18 are additional x86 cleanups.
>
> Sean Christopherson (18):
>   KVM: x86/mmu: Coalesce TDP MMU TLB flushes when zapping collapsible
>     SPTEs
>   KVM: x86/mmu: Move flushing for "slot" handlers to caller for legacy
>     MMU
>   KVM: x86/mmu: Coalesce TLB flushes when zapping collapsible SPTEs
>   KVM: x86/mmu: Coalesce TLB flushes across address spaces for gfn range
>     zap
>   KVM: x86/mmu: Pass address space ID to __kvm_tdp_mmu_zap_gfn_range()
>   KVM: x86/mmu: Pass address space ID to TDP MMU root walkers
>   KVM: x86/mmu: Use leaf-only loop for walking TDP SPTEs when changing
>     SPTE
>   KVM: Move prototypes for MMU notifier callbacks to generic code
>   KVM: Move arm64's MMU notifier trace events to generic code
>   KVM: Move x86's MMU notifier memslot walkers to generic code
>   KVM: arm64: Convert to the gfn-based MMU notifier callbacks
>   KVM: MIPS/MMU: Convert to the gfn-based MMU notifier callbacks
>   KVM: PPC: Convert to the gfn-based MMU notifier callbacks
>   KVM: Kill off the old hva-based MMU notifier callbacks
>   KVM: Take mmu_lock when handling MMU notifier iff the hva hits a
>     memslot
>   KVM: Don't take mmu_lock for range invalidation unless necessary
>   KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if
>     possible
>   KVM: x86/mmu: Drop trace_kvm_age_page() tracepoint
>
>  arch/arm64/include/asm/kvm_host.h             |   5 -
>  arch/arm64/kvm/mmu.c                          | 118 ++----
>  arch/arm64/kvm/trace_arm.h                    |  66 ----
>  arch/mips/include/asm/kvm_host.h              |   5 -
>  arch/mips/kvm/mmu.c                           |  97 +----
>  arch/powerpc/include/asm/kvm_book3s.h         |  12 +-
>  arch/powerpc/include/asm/kvm_host.h           |   7 -
>  arch/powerpc/include/asm/kvm_ppc.h            |   9 +-
>  arch/powerpc/kvm/book3s.c                     |  18 +-
>  arch/powerpc/kvm/book3s.h                     |  10 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c           |  98 ++---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c        |  25 +-
>  arch/powerpc/kvm/book3s_hv.c                  |  12 +-
>  arch/powerpc/kvm/book3s_pr.c                  |  56 +--
>  arch/powerpc/kvm/e500_mmu_host.c              |  29 +-
>  arch/powerpc/kvm/trace_booke.h                |  15 -
>  arch/x86/include/asm/kvm_host.h               |   6 +-
>  arch/x86/kvm/mmu/mmu.c                        | 180 ++++-----
>  arch/x86/kvm/mmu/mmu_internal.h               |  10 +
>  arch/x86/kvm/mmu/tdp_mmu.c                    | 344 +++++++-----------
>  arch/x86/kvm/mmu/tdp_mmu.h                    |  31 +-
>  include/linux/kvm_host.h                      |  22 +-
>  include/trace/events/kvm.h                    |  90 +++--
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   4 -
>  .../selftests/kvm/lib/x86_64/processor.c      |   2 +
>  virt/kvm/kvm_main.c                           | 312 ++++++++++++----
>  26 files changed, 697 insertions(+), 886 deletions(-)
>
> --
> 2.31.0.291.g576ba9dcdaf-goog
>
