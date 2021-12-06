Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8079D46A61C
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348826AbhLFT6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 14:58:51 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:49748 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234586AbhLFT6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 14:58:50 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK4P-0000kW-CR; Mon, 06 Dec 2021 20:54:41 +0100
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
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 00/29] KVM: Scalable memslots implementation
Date:   Mon,  6 Dec 2021 20:54:06 +0100
Message-Id: <cover.1638817637.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

This series is the seventh iteration of the scalable memslots patch set.
It contains a few minor changes that were pointed out during the review
of the previous version.

The series was tested on x86 with KASAN on and booted various guests
successfully (including nested ones; with TDP MMU both enabled and disabled).

The previous version (6) is available here:
https://lore.kernel.org/kvm/cover.1638304315.git.maciej.szmigiero@oracle.com/


Changes from v6:
* Add braces around a "for" loop in kvm_check_memslot_overlap(),

* Add a note to commit 25 that kvm_arch_flush_shadow_memslot() might now
  receive a memslot with stale data in the "arch" field,	       

* Keep "slot" in kvm_for_each_memslot_in_gfn_range() iterator and remove
  the "end" field there,

* Reorder my SoB on patches so it's always the last SoB on a patch,

* Convert some of Sean's SoBs to "Reviewed-by:",
  keeping his SoB on patches that are either from him or co-developed by
  him while removing this tag on the remaining ones.


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
 include/linux/kvm_host.h            | 272 ++++++---
 virt/kvm/kvm_main.c                 | 836 ++++++++++++++++------------
 26 files changed, 850 insertions(+), 637 deletions(-)

