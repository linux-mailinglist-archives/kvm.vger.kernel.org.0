Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D632646408C
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344278AbhK3VrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:47:05 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:55980 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344432AbhK3Vpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:45:49 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msAsm-0005wK-PF; Tue, 30 Nov 2021 22:41:48 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
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
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 00/29] KVM: Scalable memslots implementation
Date:   Tue, 30 Nov 2021 22:41:13 +0100
Message-Id: <cover.1638304315.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

This series contains the sixth iteration of the scalable memslots patch set.
It is based on Sean's version "5.5", but with integrated patches for issues
that arose during its review round.

In addition to that, the kvm_for_each_memslot_in_gfn_range() implementation
was reworked to return only strictly overlapping memslots and to use
iterators.

However, I've dropped a similar kvm_for_each_memslot_in_hva_range() rework
since the existing implementation was already returning only strictly
overlapping memslots and it was already based on interval tree iterators,
so wrapping them in another layer of iterators would only add unnecessary
complexity.
The code in this "for"-like macro is also self-contained and very simple,
so let's keep it this way.

The series was tested on x86 with KASAN on and booted various guests
successfully (including nested ones; with TDP MMU both enabled and disabled).

Sean's previous version (5.5) is available here:
[1]: https://lore.kernel.org/kvm/20211104002531.1176691-1-seanjc@google.com/


Changes from v5.5:
* Note open-coding of kvm_copy_memslots() in the commit message of patch 3,

* When changing kvm_arch_prepare_memory_region() signature change it also
  in the RISC-V implementation of this function in patch 5,

* Avoid overflowing "nr_mmu_pages" in patch 18,

* Add a comment to the "slot id to memslot" hash table declaration
  explaining its bucket count in patch 21,

* Don't check twice for "old" being != NULL in kvm_replace_memslot()
  in patch 21,

* Remove unnecessary "new" NULL check in kvm_replace_memslot() in patch 22,

* Split out changing kvm_invalidate_memslot() to call
  kvm_arch_flush_shadow_memslot() on an old slot from patch 24 to a separate
  patch 25,

* Make kvm_for_each_memslot_in_gfn_range() return only strictly overlapping
  memslots and rewrite its implementation to use iterators in patch 26.


Maciej S. Szmigiero (12):
  KVM: Resync only arch fields when slots_arch_lock gets reacquired
  KVM: x86: Don't call kvm_mmu_change_mmu_pages() if the count hasn't
    changed
  KVM: x86: Use nr_memslot_pages to avoid traversing the memslots array
  KVM: Integrate gfn_to_memslot_approx() into search_memslots()
  KVM: Move WARN on invalid memslot index to update_memslots()
  KVM: Resolve memslot ID via a hash table instead of via a static array
  KVM: Use interval tree to do fast hva lookup in memslots
  KVM: s390: Introduce kvm_s390_get_gfn_end()
  KVM: Keep memslots in tree-based structures instead of array-based
    ones
  KVM: Call kvm_arch_flush_shadow_memslot() on the old slot in
    kvm_invalidate_memslot()
  KVM: Optimize gfn lookup in kvm_zap_gfn_range()
  KVM: Optimize overlapping memslots check

Sean Christopherson (17):
  KVM: Require total number of memslot pages to fit in an unsigned long
  KVM: Open code kvm_delete_memslot() into its only caller
  KVM: Use "new" memslot's address space ID instead of dedicated param
  KVM: Let/force architectures to deal with arch specific memslot data
  KVM: arm64: Use "new" memslot instead of userspace memory region
  KVM: MIPS: Drop pr_debug from memslot commit to avoid using "mem"
  KVM: PPC: Avoid referencing userspace memory region in memslot updates
  KVM: s390: Use "new" memslot instead of userspace memory region
  KVM: x86: Use "new" memslot instead of userspace memory region
  KVM: RISC-V: Use "new" memslot instead of userspace memory region
  KVM: Stop passing kvm_userspace_memory_region to arch memslot hooks
  KVM: Use prepare/commit hooks to handle generic memslot metadata
    updates
  KVM: x86: Don't assume old/new memslots are non-NULL at memslot commit
  KVM: s390: Skip gfn/size sanity checks on memslot DELETE or FLAGS_ONLY
  KVM: Don't make a full copy of the old memslot in
    __kvm_set_memory_region()
  KVM: Wait 'til the bitter end to initialize the "new" memslot
  KVM: Dynamically allocate "new" memslots from the get-go

 arch/arm64/kvm/Kconfig              |   1 +
 arch/arm64/kvm/mmu.c                |  27 +-
 arch/mips/kvm/Kconfig               |   1 +
 arch/mips/kvm/mips.c                |   9 +-
 arch/powerpc/include/asm/kvm_ppc.h  |  14 +-
 arch/powerpc/kvm/Kconfig            |   1 +
 arch/powerpc/kvm/book3s.c           |  14 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   4 +-
 arch/powerpc/kvm/book3s_hv.c        |  28 +-
 arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
 arch/powerpc/kvm/book3s_pr.c        |   9 +-
 arch/powerpc/kvm/booke.c            |   7 +-
 arch/powerpc/kvm/powerpc.c          |   9 +-
 arch/riscv/kvm/mmu.c                |  31 +-
 arch/s390/kvm/Kconfig               |   1 +
 arch/s390/kvm/kvm-s390.c            |  98 ++--
 arch/s390/kvm/kvm-s390.h            |  14 +
 arch/s390/kvm/pv.c                  |   4 +-
 arch/x86/include/asm/kvm_host.h     |   3 +-
 arch/x86/kvm/Kconfig                |   1 +
 arch/x86/kvm/debugfs.c              |   6 +-
 arch/x86/kvm/mmu/mmu.c              |  38 +-
 arch/x86/kvm/x86.c                  |  41 +-
 include/linux/kvm_host.h            | 277 ++++++---
 virt/kvm/kvm_main.c                 | 835 ++++++++++++++++------------
 26 files changed, 854 insertions(+), 637 deletions(-)

