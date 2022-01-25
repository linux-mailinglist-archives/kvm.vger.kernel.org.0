Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DBF49B7E8
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 16:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582365AbiAYPrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 10:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349064AbiAYPpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 10:45:11 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06D6C061749
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 07:45:08 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id y4so38144303uad.1
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 07:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPIEe+st9cF5MAH0hHhZ+qq16py4m+I4ddilHRSbQ3w=;
        b=PEv4ClL5nM9Feh8S60aS+OCooCdVoq6QUZLmQ7RwtiBXCAl/aj47zwgY2qMKu7W/P8
         9BHPTd1QlFfM0ArL9Rxku463v1nrn85avkyQxgxIYtqdfKBUdI/r4cE5KoLJ0rUahi1a
         zqHRvVWmfWrDizSPNXGMJ2cJXxUbrEWjPHwghugfZf62+rB4rQchSND9Tzi7FVrEq4/h
         rzJWqUn1IjM0gAVImb8TdjlBWZq+2dgywux0UeKkWuc9uSJpuLOcud+Hkg0eAjZys3CE
         EoJ5g5zv1UHAB4uQl5VuHAcUyYpPp5BpfnOwjuAIfr2mnFrP+tq5VCcwhJv6qqIz/8Ir
         4SFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPIEe+st9cF5MAH0hHhZ+qq16py4m+I4ddilHRSbQ3w=;
        b=BndAMSAefF6UPf1qM/m1EKoh/njcPDRNqfdR3f7k46qLqv/svm3+B3EODh2jf3oRWX
         cWYo11+XkCKiyhM4fFgkLbvVd2zr73bpTFDNMZH4UiKy6Yenr/XScQxt6Bb9Tx751J1f
         Xu7LSZAViK3pfvRmE89T8ao089lrNC3pLa+8kTwO+3Q1JAEUsUlliwH0XQtdHNynKqIM
         9HaYbyVx8ynLDgtyZ++PqLzmYsVu1MgjgXc0fB2kikRjr1LHEIG2dni5hGqQ3LhmbrbJ
         AgVR8e6QHWBUiXW/CYJOFhIXndgcrjp7Pd5imFCaALJl4ylaY2y535WUmceAtfqHnqn4
         kHOQ==
X-Gm-Message-State: AOAM533+EcCVOLJKci3FB2yC+/IaVISilbU/AZQi3AAzciBvlEwKpXIN
        s3bf68XnxbCxkF/s79bKbJhHQ1ejmRzvbQYJkht9SQ==
X-Google-Smtp-Source: ABdhPJzswcvU0OHQ8LHteSUlTIJOXJDpk5/DIjq9oA64wiSgTSvRd+mAzuNnzBqcNxjjNg0uTXlmFn1A2Yo+43HUgYs=
X-Received: by 2002:ab0:7390:: with SMTP id l16mr7490109uap.73.1643125507698;
 Tue, 25 Jan 2022 07:45:07 -0800 (PST)
MIME-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com> <CA+EHjTwZsODk4pY9sYsUeyETUXQTLNDViPKjD_KbuaPF4sBu=A@mail.gmail.com>
In-Reply-To: <CA+EHjTwZsODk4pY9sYsUeyETUXQTLNDViPKjD_KbuaPF4sBu=A@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 25 Jan 2022 07:44:55 -0800
Message-ID: <CAAdAUthkri_fdMzrBwZP5ZfebpieD=rYqWY+reDuRhJsQ_ZrJA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ARM64: Guest performance improvement during dirty
To:     Fuad Tabba <tabba@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Fuad,

On Tue, Jan 25, 2022 at 5:22 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Jing,
>
> On Tue, Jan 18, 2022 at 1:57 AM Jing Zhang <jingzhangos@google.com> wrote:
> >
> > This patch is to reduce the performance degradation of guest workload during
> > dirty logging on ARM64. A fast path is added to handle permission relaxation
> > during dirty logging. The MMU lock is replaced with rwlock, by which all
> > permision relaxations on leaf pte can be performed under the read lock. This
> > greatly reduces the MMU lock contention during dirty logging. With this
> > solution, the source guest workload performance degradation can be improved
> > by more than 60%.
> >
> > Problem:
> >   * A Google internal live migration test shows that the source guest workload
> >   performance has >99% degradation for about 105 seconds, >50% degradation
> >   for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
> >   This shows that most of the time, the guest workload degradtion is above
> >   99%, which obviously needs some improvement compared to the test result
> >   on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
> >   * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB, PageSize: 4K
> >   * VM spec: #vCPU: 48, #Mem/vCPU: 4GB, PageSize: 4K, 2M hugepage backed
> >
> > Analysis:
> >   * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
> >     the number of contentions of MMU lock and the "dirty memory time" on
> >     various VM spec. The "dirty memory time" is the time vCPU threads spent
> >     in KVM after fault. Higher "dirty memory time" means higher degradation
> >     to guest workload.
> >     '-m 2' specifies the mode "PA-bits:48,  VA-bits:48,  4K pages".
> >     By using test command
> >     ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
> >     Below are the results:
> >     +-------+------------------------+-----------------------+
> >     | #vCPU | dirty memory time (ms) | number of contentions |
> >     +-------+------------------------+-----------------------+
> >     | 1     | 926                    | 0                     |
> >     +-------+------------------------+-----------------------+
> >     | 2     | 1189                   | 4732558               |
> >     +-------+------------------------+-----------------------+
> >     | 4     | 2503                   | 11527185              |
> >     +-------+------------------------+-----------------------+
> >     | 8     | 5069                   | 24881677              |
> >     +-------+------------------------+-----------------------+
> >     | 16    | 10340                  | 50347956              |
> >     +-------+------------------------+-----------------------+
> >     | 32    | 20351                  | 100605720             |
> >     +-------+------------------------+-----------------------+
> >     | 64    | 40994                  | 201442478             |
> >     +-------+------------------------+-----------------------+
> >
> >   * From the test results above, the "dirty memory time" and the number of
> >     MMU lock contention scale with the number of vCPUs. That means all the
> >     dirty memory operations from all vCPU threads have been serialized by
> >     the MMU lock. Further analysis also shows that the permission relaxation
> >     during dirty logging is where vCPU threads get serialized.
>
> I am curious about any changes to performance for this case (the base
> case) with the changes in patch 3.
>
> Thanks,
> /fuad
>
>
>
> >
> > Solution:
> >   * On ARM64, there is no mechanism as PML (Page Modification Logging) and
> >     the dirty-bit solution for dirty logging is much complicated compared to
> >     the write-protection solution. The straight way to reduce the guest
> >     performance degradation is to enhance the concurrency for the permission
> >     fault path during dirty logging.
> >   * In this patch, we only put leaf PTE permission relaxation for dirty
> >     logging under read lock, all others would go under write lock.
> >     Below are the results based on the fast path solution:
> >     +-------+------------------------+
> >     | #vCPU | dirty memory time (ms) |
> >     +-------+------------------------+
> >     | 1     | 965                    |
> >     +-------+------------------------+
> >     | 2     | 1006                   |
> >     +-------+------------------------+
> >     | 4     | 1128                   |
> >     +-------+------------------------+
> >     | 8     | 2005                   |
> >     +-------+------------------------+
> >     | 16    | 3903                   |
> >     +-------+------------------------+
> >     | 32    | 7595                   |
> >     +-------+------------------------+
> >     | 64    | 15783                  |
> >     +-------+------------------------+
> >
> >   * Furtuer analysis shows that there is another bottleneck caused by the
> >     setup of the test code itself. The 3rd commit is meant to fix that by
> >     setting up vgic in the test code. With the test code fix, below are
> >     the results which show better improvement.
> >     +-------+------------------------+
> >     | #vCPU | dirty memory time (ms) |
> >     +-------+------------------------+
> >     | 1     | 803                    |
> >     +-------+------------------------+
> >     | 2     | 843                    |
> >     +-------+------------------------+
> >     | 4     | 942                    |
> >     +-------+------------------------+
> >     | 8     | 1458                   |
> >     +-------+------------------------+
> >     | 16    | 2853                   |
> >     +-------+------------------------+
> >     | 32    | 5886                   |
> >     +-------+------------------------+
> >     | 64    | 12190                  |
> >     +-------+------------------------+
> >     All "dirty memory time" has been reduced by more than 60% when the
> >     number of vCPU grows.
> >   * Based on the solution, the test results from the Google internal live
> >     migration test also shows more than 60% improvement with >99% for 30s,
> >     >50% for 58s and >10% for 76s.
> >
> > ---
> >
> > * v1 -> v2
> >   - Renamed flag name from use_mmu_readlock to logging_perm_fault.
> >   - Removed unnecessary check for fault_granule to use readlock.
> > * RFC -> v1
> >   - Rebase to kvm/queue, commit fea31d169094
> >     (KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event)
> >   - Moved the fast path in user_mem_abort, as suggested by Marc.
> >   - Addressed other comments from Marc.
> >
> > [v1] https://lore.kernel.org/all/20220113221829.2785604-1-jingzhangos@google.com
> > [RFC] https://lore.kernel.org/all/20220110210441.2074798-1-jingzhangos@google.com
> >
> > ---
> >
> > Jing Zhang (3):
> >   KVM: arm64: Use read/write spin lock for MMU protection
> >   KVM: arm64: Add fast path to handle permission relaxation during dirty
> >     logging
> >   KVM: selftests: Add vgic initialization for dirty log perf test for
> >     ARM
> >
> >  arch/arm64/include/asm/kvm_host.h             |  2 +
> >  arch/arm64/kvm/mmu.c                          | 49 ++++++++++++-------
> >  .../selftests/kvm/dirty_log_perf_test.c       | 10 ++++
> >  3 files changed, 43 insertions(+), 18 deletions(-)
> >
> >
> > base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
> > --
> > 2.34.1.703.g22d0c6ccf7-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
Thanks for all your reviews and testing.

Jing
