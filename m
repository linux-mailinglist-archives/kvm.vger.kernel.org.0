Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BDB3EBCEE
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhHMUBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:01:13 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50268 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233994AbhHMUBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:01:12 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mEcvr-00041M-TV; Fri, 13 Aug 2021 21:33:31 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/13] KVM: Scalable memslots implementation
Date:   Fri, 13 Aug 2021 21:33:13 +0200
Message-Id: <cover.1628871411.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

The current memslot code uses a (reverse) gfn-ordered memslot array
for keeping track of them.
This only allows quick binary search by gfn, quick lookup by hva is
not possible (the implementation has to do a linear scan of the whole
memslot array).

Because the memslot array that is currently in use cannot be modified
every memslot management operation (create, delete, move, change
flags) has to make a copy of the whole array so it has a scratch copy
to work on.

Strictly speaking, however, it is only necessary to make copy of the
memslot that is being modified, copying all the memslots currently
present is just a limitation of the array-based memslot implementation.

Two memslot sets, however, are still needed so the VM continues to run
on the currently active set while the requested operation is being
performed on the second, currently inactive one.

In order to have two memslot sets, but only one copy of the actual
memslots it is necessary to split out the memslot data from the
memslot sets.

The memslots themselves should be also kept independent of each other
so they can be individually added or deleted.

These two memslot sets should normally point to the same set of memslots.
They can, however, be desynchronized when performing a memslot management
operation by replacing the memslot to be modified by its copy.
After the operation is complete, both memslot sets once again point to
the same, common set of memslot data.

This series implements the aforementioned idea.

The new implementation uses two trees to perform quick lookups:
For tracking of gfn an ordinary rbtree is used since memslots cannot
overlap in the guest address space and so this data structure is
sufficient for ensuring that lookups are done quickly.

For tracking of hva, however, an interval tree is needed since they
can overlap between memslots.

ID to memslot mappings are kept in a hash table instead of using a
statically allocated "id_to_index" array.

The "last used slot" mini-caches (both per-slot set one and per-vCPU one),
that keep track of the last found-by-gfn memslot, are still present in the
new code.

There was also a desire to make the new structure operate on "pay as
you go" basis, that is, that the user only pays the price of the
memslot count that is actually used, not of the maximum count allowed.

The operation semantics were carefully matched to the original
implementation, the outside-visible behavior should not change.
Only the timing will be different.

Making lookup and memslot management operations O(log(n)) brings some
performance benefits (tested on a Xeon 8167M machine):
509 slots in use:
Test            Before          After           Improvement
Map             0.0232s         0.0223s          4%
Unmap           0.0724s         0.0315s         56%
Unmap 2M        0.00155s        0.000869s       44%
Move active     0.000101s       0.0000792s      22%
Move inactive   0.000108s       0.0000847s      21%
Slot setup      0.0135s         0.00803s        41%

100 slots in use:
Test            Before          After           Improvement
Map             0.0195s         0.0191s         None
Unmap           0.0374s         0.0312s         17%
Unmap 2M        0.000470s       0.000447s        5%
Move active     0.0000956s      0.0000800s      16%
Move inactive   0.000101s       0.0000840s      17%
Slot setup      0.00260s        0.00174s        33%

50 slots in use:
Test            Before          After           Improvement
Map             0.0192s         0.0190s         None
Unmap           0.0339s         0.0311s          8%
Unmap 2M        0.000399s       0.000395s       None
Move active     0.0000999s      0.0000854s      15%
Move inactive   0.0000992s      0.0000826s      17%
Slot setup      0.00141s        0.000990s       30%

30 slots in use:
Test            Before          After           Improvement
Map             0.0192s         0.0190s         None
Unmap           0.0325s         0.0310s          5%
Unmap 2M        0.000373s       0.000373s       None
Move active     0.000100s       0.0000865s      14%
Move inactive   0.000106s       0.0000918s      13%
Slot setup      0.000989s       0.000775s       22%

10 slots in use:
Test            Before          After           Improvement
Map             0.0192s         0.0186s          3%
Unmap           0.0313s         0.0310s         None
Unmap 2M        0.000348s       0.000351s       None
Move active     0.000110s       0.0000948s      14%
Move inactive   0.000111s       0.0000933s      16%
Slot setup      0.000342s       0.000283s       17%

32k slots in use:
Test            Before          After           Improvement
Map (8194)       0.200s         0.0541s         73%
Unmap            3.88s          0.0351s         99%
Unmap 2M         3.88s          0.0348s         99%
Move active      0.00142s       0.0000786s      94%
Move inactive    0.00148s       0.0000880s      94%
Slot setup      16.1s           0.59s           96%

Since the map test can be done with up to 8194 slots, the result above
for this test was obtained running it with that maximum number of
slots.

In both the old and new memslot code case the measurements were done
against the new KVM selftest framework, with TDP MMU disabled.

On x86-64 the code was well tested, passed KVM unit tests and KVM
selftests with KASAN on.
And, of course, booted various guests successfully (including nested
ones with TDP MMU enabled).
On other KVM platforms the code was compile-tested only.

Changes since v1:
* Drop the already merged HVA handler retpoline-friendliness patch,

* Split the scalable memslots patch into 8 smaller ones,

* Rebase onto the current kvm/queue,

* Make sure that ranges at both memslot's hva_nodes are always
initialized,

* Remove kvm_mmu_calculate_default_mmu_pages() prototype, too,
when removing this function,

* Redo benchmarks, measure 32k memslots on the old implementation, too.

Changes since v2:
* Rebase onto the current kvm/queue, taking into account the now-merged
MMU notifiers rewrite.
This reduces the diffstat by ~50 lines.

Changes since v3:
* Rebase onto the current (Aug 12) kvm/queue, taking into account the
introduction of slots_arch_lock (and lazy rmaps allocation) and per-vCPU
"last used slot" mini-cache,

* Change n_memslots_pages to u64 to avoid overflowing it on 32-bit KVM,

* Skip the kvm_mmu_change_mmu_pages() call for memslot operations that
don't change the total page count anyway,

* Move n_memslots_pages recalc to kvm_arch_prepare_memory_region() so
a proper error code can be returned in case we spot an underflow,

* Integrate the open-coded s390 gfn_to_memslot_approx() into the main KVM
code by adding "approx" parameter to the existing __gfn_to_memslot() while
renaming it to __gfn_to_memslot_approx() and introducing
__gfn_to_memslot() wrapper so existing call sites won't be affected,
since __gfn_to_memslot() now offers an extra functionality over
search_memslots().
This last fact wasn't the case at the time the previous version of this
series was posted,

* Split out the move of WARN that's triggered on invalid memslot index to
a separate patch,

* Rename the old slot variable in kvm_memslot_delete() to "oldslot",
add an additional comment why we delete a memslot from the hash table
in kvm_memslot_move_backward() in "KVM: Resolve memslot ID via a hash
table instead of via a static array" patch,

* Rename a patch from "Introduce memslots hva tree" to "Use interval tree
to do fast hva lookup in memslots",

* Document that the kvm_for_each_hva_range_memslot() range is inclusive,

* Rename kvm_for_each_hva_range_memslot to
kvm_for_each_memslot_in_hva_range, move this macro to kvm_main.c,

* Update the WARN in __kvm_handle_hva_range() and kvm_zap_gfn_range() to
also trigger on empty ranges,

* Use "bkt" instead of "ctr" for hash bucket index variables,

* Add a comment describing the idea behind the memslots dual set system
above struct kvm_memory_slot,

* Rename "memslots_all" to "__memslots" in struct kvm and add comments
there describing its two memslot members,

* Remove kvm_memslots_idx() helper and store the set index explicitly in
the particular memslots set instead,

* Open code kvm_init_memslots(),

* Rename swap_memslots() into kvm_swap_active_memslots() and make it
also swap pointers themselves to the provided two sets,

* Initialize "parent" outside of the for loop in kvm_memslot_gfn_insert(),

* Add kvm_memslot_gfn_erase() and kvm_memslot_gfn_replace() helpers,

* Fold kvm_init_memslot_hva_ranges() into kvm_copy_memslot(),

* Remove kvm_copy_replace_memslot() and introduce kvm_activate_memslot()
instead,

* Rename "slotsact" / "slotsina" into "active" / "inactive" in
kvm_set_memslot(), add a big comment what are the semantics of
"slotact" / "slotina" variables to this function,

* Move WARN about a missing old slot to kvm_set_memslot() and return -EIO
in this case,

* Set KVM_MEMSLOT_INVALID flag on a temporary slot before (rather than
after) replacing it in the inactive set in kvm_set_memslot() as it is a bit
more intuitive way to do it,

* Move handling of an error from kvm_arch_prepare_memory_region() directly
below a call to this function in kvm_set_memslot() from the end of this
function,

* Rework some of the comments in kvm_set_memslot(),

* Rename "oldslot" / "nslot" into "old" / "new" here and there in
"Keep memslots in tree-based structures instead of array-based ones"
patch,

* Add Sean's "Co-developed-by:" to the aforementioned patch since many of
its above changes are coming from his proposed patch (and he did a lot
of good work reviewing both this patch and the whole series),

* Introduce kvm_for_each_memslot_in_gfn_range() and use it in the last two
patches,

* Unfold long lines here and there,

* Retest the patch series.

 arch/arm64/kvm/Kconfig              |   1 +
 arch/arm64/kvm/mmu.c                |  15 +-
 arch/mips/kvm/Kconfig               |   1 +
 arch/mips/kvm/mips.c                |   3 +-
 arch/powerpc/kvm/Kconfig            |   1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   4 +-
 arch/powerpc/kvm/book3s_hv.c        |   3 +-
 arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
 arch/powerpc/kvm/powerpc.c          |   5 +-
 arch/s390/kvm/Kconfig               |   1 +
 arch/s390/kvm/kvm-s390.c            |  66 +--
 arch/s390/kvm/kvm-s390.h            |  14 +
 arch/s390/kvm/pv.c                  |   4 +-
 arch/x86/include/asm/kvm_host.h     |   2 +-
 arch/x86/kvm/Kconfig                |   1 +
 arch/x86/kvm/debugfs.c              |   6 +-
 arch/x86/kvm/mmu/mmu.c              |  35 +-
 arch/x86/kvm/x86.c                  |  40 +-
 include/linux/kvm_host.h            | 224 +++++++---
 virt/kvm/kvm_main.c                 | 651 +++++++++++++++-------------
 21 files changed, 622 insertions(+), 473 deletions(-)
