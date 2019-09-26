Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4999EBFBC3
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfIZXSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:31 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:52408 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbfIZXSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:31 -0400
Received: by mail-pl1-f201.google.com with SMTP id y2so456770plk.19
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=t7Qt950TRZxO8hcF88t41Gxjv7277P8c4yNTYDyTTfw=;
        b=iK5ZQwe6aAlfkn9KlKF4naxnPDw2LX20dxlPPWhqFCKV7rY+zMlsUJzVESvKIp4sCm
         F3PVqwmCykHANsIZf2iVVK9kYNh/aUYuYHiHJGYzONM+rCP0x5CuIibpx3gL+UMHwhrM
         r9WvaR1IXSC0k/pKM3heAiDIE6IppZmmdf0YcIuDqL2nFD3zSuTlW9wpo/q6tGDoD5TN
         4T8cw0p/6f+DaIoGdYhZozbuv6WlrsIOpwJFVtf9vuFEBuwhmV55nakyLaD/No3A5Wi7
         HC4eqRgIuomEqnBQ37GT5l5MVxJNmKEMGrFe4r0vf8g50OagopysNRnQAo2e5Xo6E2F/
         eyrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=t7Qt950TRZxO8hcF88t41Gxjv7277P8c4yNTYDyTTfw=;
        b=TzhM8/yqJMNVG7G1RctSlJ/Mdr9VDKzxpBxd6GqmemKt0Mdt3WaWeVDmP20p4UyvR0
         dqPZBOuGac9+roqPumImTyt8H0YRbvouJIyZCwUI9nWos5gdtsvMQ4BFOvLTpf9tlKn7
         PovW400QFQFgtNIKzi55voJp1Q/yKF1pLAdYkwL3Y68HJrcVZoz3Pk09Df4S4CuU1UBs
         0L6buvYeFr9d5SEqAugNYjo/jJpjsVx9/5ZT6pXlPrOrwEInqQJqWFUsSuWOt2/H0S08
         pk4QusyvlwrA4VD/iNv++IfIsv0CEdFiVquaCYWA43QHVCyxd+qNrVFRvmFuPNC5aASl
         C4YQ==
X-Gm-Message-State: APjAAAX4iHuz/MPVOrRK9UlUyHPk1Havcz2bK1P5XksKrizeiCysq7Vp
        D73RS8RtIBrYb0ZtTmDk6Pgqqu1kYQoYkMrzBxTW1jRjzgi3kxcaRz0Lgzjnv26VIaUfM+Qugzs
        rg2gjdvHFgLJOoQquNPh4w0ymYo9xf2+6Cq+0jQLyBcUTmNup+oN8P3XOJ3UG
X-Google-Smtp-Source: APXvYqwuASrT6kbsK/QvlT6wwXkh4azwu12fC+IgjJFLAK3cPlSRRINpVwR4UdTNTjdSiwl+uvOuRs2OnbQs
X-Received: by 2002:a63:4a47:: with SMTP id j7mr5827429pgl.399.1569539908163;
 Thu, 26 Sep 2019 16:18:28 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:17:56 -0700
Message-Id: <20190926231824.149014-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 00/28] kvm: mmu: Rework the x86 TDP direct mapped case
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Over the years, the needs for KVM's x86 MMU have grown from running small
guests to live migrating multi-terabyte VMs with hundreds of vCPUs. Where
we previously depended upon shadow paging to run all guests, we now have
the use of two dimensional paging (TDP). This RFC proposes and
demonstrates two major changes to the MMU. First, an iterator abstraction 
that simplifies traversal of TDP paging structures when running an L1
guest. This abstraction takes advantage of the relative simplicity of TDP
to simplify the implementation of MMU functions. Second, this RFC changes
the synchronization model to enable more parallelism than the monolithic
MMU lock. This "direct mode" MMU is currently in use at Google and has
given us the performance necessary to live migrate our 416 vCPU, 12TiB
m2-ultramem-416 VMs.

The primary motivation for this work was to handle page faults in
parallel. When VMs have hundreds of vCPUs and terabytes of memory, KVM's
MMU lock suffers from extreme contention, resulting in soft-lockups and
jitter in the guest. To demonstrate this I also written, and will submit
a demand paging test to KVM selftests. The test creates N vCPUs, which
each touch disjoint regions of memory. Page faults are picked up by N
user fault FD handlers, one for each vCPU. Over a 1 second profile of
the demand paging test, with 416 vCPUs and 4G per vCPU, 98% of the
execution time was spent waiting for the MMU lock! With this patch
series the total execution time for the test was reduced by 89% and the
execution was dominated by get_user_pages and the user fault FD ioctl.
As a secondary benefit, the iterator-based implementation does not use
the rmap or struct kvm_mmu_pages, saving ~0.2% of guest memory in KVM
overheads.

The goal of this  RFC is to demonstrate and gather feedback on the
iterator pattern, the memory savings it enables for the "direct case"
and the changes to the synchronization model. Though they are interwoven
in this series, I will separate the iterator from the synchronization
changes in a future series. I recognize that some feature work will be
needed to make this patch set ready for merging. That work is detailed
at the end of this cover letter.

The overall purpose of the KVM MMU is to program paging structures
(CR3/EPT/NPT) to encode the mapping of guest addresses to host physical
addresses (HPA), and to provide utilities for other KVM features, for
example dirty logging. The definition of the L1 guest physical address
(GPA) to HPA mapping comes in two parts: KVM's memslots map GPA to HVA,
and the kernel MM/x86 host page tables map HVA -> HPA. Without TDP, the
MMU must program the x86 page tables to encode the full translation of
guest virtual addresses (GVA) to HPA. This requires "shadowing" the
guest's page tables to create a composite x86 paging structure. This
solution is complicated, requires separate paging structures for each
guest CR3, and requires emulating guest page table changes. The TDP case
is much simpler. In this case, KVM lets the guest control CR3 and
programs the EPT/NPT paging structures with the GPA -> HPA mapping. The
guest has no way to change this mapping and only one version of the
paging structure is needed per L1 address space (normal execution or
system management mode, on x86).

This RFC implements a "direct MMU" through alternative implementations
of MMU functions for running L1 guests with TDP. The direct MMU gets its
name from the direct role bit in struct kvm_mmu_page in the existing MMU
implementation, which indicates that the PTEs in a page table (and their
children) map a linear range of L1 GPAs. Though the direct MMU does not
currently use struct kvm_mmu_page, all of its pages would implicitly
have that bit set. The direct MMU falls back to the existing shadow
paging implementation when TDP is not available, and interoperates with
the existing shadow paging implementation for nesting. 

In order to handle page faults in parallel, the MMU needs to allow a
variety of changes to PTEs concurrently. The first step in this series
is to replace the MMU lock with a read/write lock to enable multiple
threads to perform operations at the same time and interoperate with
functions that still need the monolithic lock. With threads handling
page faults in parallel, the functions operating on the page table
need to: a) ensure PTE modifications are atomic, and  b) ensure that page
table memory is freed and accessed safely Conveniently, the iterator
pattern introduced in this series handles both concerns.

The direct walk iterator implements a pre-order traversal of the TDP
paging structures. Threads are able to read and write page table memory
safely in this traversal through the use of RCU and page table memory is
freed in RCU callbacks, as part of a three step process. (More on that
below.) To ensure that PTEs are updated atomically, the iterator
provides a function for updating the current pte. If the update
succeeds, the iterator handles bookkeeping based on the current and
previous value of the PTE. If it fails, some other thread will have
succeeded, and the iterator repeats that PTE on the next iteration,
transparently retrying the operation. The iterator also handles yielding
and reacquiring the appropriate MMU lock, and flushing the TLB or
queuing work to be done on the next flush.

In order to minimize TLB flushes, we expand the tlbs_dirty count to
track unflushed changes made through the iterator, so that other threads
know that the in-memory page tables they traverse might not be what the
guest is using to access memory. Page table pages that have been
disconnected from the paging structure root are freed in a three step
process. First the pages are filled with special, nonpresent PTEs so
that guest accesses to them, through the paging structure caches result
in TDP page faults. Second, the pages are added to a disconnected list,
a snapshot of which is transferred to a free list, after each TLB flush.
The TLB flush clears the paging structure caches, so the guest will no
longer use the disconnected pages. Lastly, the free list is processed
asynchronously to queue RCU callbacks which free the memory. The RCU
grace period ensures no kernel threads are using the disconnected pages.
This allows the MMU to leave the guest in an inconsistent, but safe,
state with respect to the in-memory paging structure. When functions
need to guarantee that the guest will use the in-memory state after a
traversal, they can either flush the TLBs unconditionally or, if using
the MMU lock in write mode, flush the TLBs under the lock only if the
tlbs_dirty count is elevated.

The use of the direct MMU can be controlled by a module parameter which
is snapshotted on VM creation and follows the life of the VM. This
snapshot is used in many functions to decide whether or not to use
direct MMU handlers for a given operation. This is a maintenance burden
and in future versions of this series I will address that and remove
some of the code the direct MMU replaces. I am especially interested in
feedback from the community as to how this series can best be merged. I
see two broad approaches: replacement and integration or modularization.

Replacement and integration would require amending the existing shadow
paging implementation to use a similar iterator pattern. This would mean
expanding the iterator to work with an rmap to support shadow paging and
reconciling the synchronization changes made to the direct case with the
complexities of shadow paging and nesting.

The modularization approach would require factoring out the "direct MMU"
or "TDP MMU" and "shadow MMU(s)." The function pointers in the MMU
struct would need to be expanded to fully encompass the interface of the
MMU and multiple, simpler, implementations of those functions would be
needed. As it is, use of the module parameter snapshot gives us a rough
outline of the previously undocumented shape of the MMU interface, which
could facilitate modularization. Modularization could allow for the
separation of the shadow paging implementations for running guests
without TDP, and running nested guests with TDP, and the breakup of
paging_tmpl.h.

In addition to the integration question, below are some of the work
items I plan to address before sending the series out again:

Disentangle the iterator pattern from the synchronization changes
	Currently the direct_walk_iterator is very closely tied to the use
	of atomic operations, RCU, and a rwlock for MMU operations. This
	does not need to be the case: instead I would like to see those
	synchronization changes built on top of this iterator pattern.

Support 5 level paging and PAE
	Currently the direct walk iterator only supports 4 level, 64bit
	architectures.

Support MMU memory reclaim
	Currently this patch series does not respect memory limits applied
	through kvm_vm_ioctl_set_nr_mmu_pages.

Support nonpaging guests
	Guests that are not using virtual addresses can be direct mapped,
	even without TDP.

Implement fast invalidation of all PTEs
	This series was prepared between when the fast invalidate_all
	mechanism was removed and when it was re-added. Currently, there
	is no fast path for invalidating all direct MMU PTEs.

Move more operations to execute concurrently
	In this patch series, only page faults are able to execute
	concurrently, however several other functions can also execute
	concurrently, simply by changing the write lock acquisition to a
	read lock.

This series can also be viewed in Gerrit here:
https://linux-review.googlesource.com/c/virt/kvm/kvm/+/1416 (Thanks to
Dmitry Vyukov <dvyukov@google.com> for setting up the Gerrit instance)

Ben Gardon (28):
  kvm: mmu: Separate generating and setting mmio ptes
  kvm: mmu: Separate pte generation from set_spte
  kvm: mmu: Zero page cache memory at allocation time
  kvm: mmu: Update the lpages stat atomically
  sched: Add cond_resched_rwlock
  kvm: mmu: Replace mmu_lock with a read/write lock
  kvm: mmu: Add functions for handling changed PTEs
  kvm: mmu: Init / Uninit the direct MMU
  kvm: mmu: Free direct MMU page table memory in an RCU callback
  kvm: mmu: Flush TLBs before freeing direct MMU page table memory
  kvm: mmu: Optimize for freeing direct MMU PTs on teardown
  kvm: mmu: Set tlbs_dirty atomically
  kvm: mmu: Add an iterator for concurrent paging structure walks
  kvm: mmu: Batch updates to the direct mmu disconnected list
  kvm: mmu: Support invalidate_zap_all_pages
  kvm: mmu: Add direct MMU page fault handler
  kvm: mmu: Add direct MMU fast page fault handler
  kvm: mmu: Add an hva range iterator for memslot GFNs
  kvm: mmu: Make address space ID a property of memslots
  kvm: mmu: Implement the invalidation MMU notifiers for the direct MMU
  kvm: mmu: Integrate the direct mmu with the changed pte notifier
  kvm: mmu: Implement access tracking for the direct MMU
  kvm: mmu: Make mark_page_dirty_in_slot usable from outside kvm_main
  kvm: mmu: Support dirty logging in the direct MMU
  kvm: mmu: Support kvm_zap_gfn_range in the direct MMU
  kvm: mmu: Integrate direct MMU with nesting
  kvm: mmu: Lazily allocate rmap when direct MMU is enabled
  kvm: mmu: Support MMIO in the direct MMU

 arch/x86/include/asm/kvm_host.h |   66 +-
 arch/x86/kvm/Kconfig            |    1 +
 arch/x86/kvm/mmu.c              | 2578 ++++++++++++++++++++++++++-----
 arch/x86/kvm/mmu.h              |    2 +
 arch/x86/kvm/mmutrace.h         |   50 +
 arch/x86/kvm/page_track.c       |    8 +-
 arch/x86/kvm/paging_tmpl.h      |   37 +-
 arch/x86/kvm/vmx/vmx.c          |   10 +-
 arch/x86/kvm/x86.c              |   96 +-
 arch/x86/kvm/x86.h              |    2 +
 include/linux/kvm_host.h        |    6 +-
 include/linux/sched.h           |   11 +
 kernel/sched/core.c             |   23 +
 virt/kvm/kvm_main.c             |   57 +-
 14 files changed, 2503 insertions(+), 444 deletions(-)

-- 
2.23.0.444.g18eeb5a265-goog

