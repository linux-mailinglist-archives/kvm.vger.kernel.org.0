Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B1134D82
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgAHU1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:27:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:57134 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgAHU1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658348"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barret Rhoden <brho@google.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: [PATCH 00/14] KVM: x86/mmu: Huge page fixes, cleanup, and DAX
Date:   Wed,  8 Jan 2020 12:24:34 -0800
Message-Id: <20200108202448.9669-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is a mix of bug fixes, cleanup and new support in KVM's
handling of huge pages.  The series initially stemmed from a syzkaller
bug report[1], which is fixed by patch 02, "mm: thp: KVM: Explicitly
check for THP when populating secondary MMU".

While investigating options for fixing the syzkaller bug, I realized KVM
could reuse the approach from Barret's series to enable huge pages for DAX
mappings in KVM[2] for all types of huge mappings, i.e. walk the host page
tables instead of querying metadata (patches 05 - 09).

Walking the host page tables sidesteps the issues with refcounting and
identifying THP mappings (in theory), and using a common method for
identifying huge mappings should improve (haven't actually measured) KVM's
overall page fault latency by eliminating the vma lookup that is currently
used to identify HugeTLB mappings.  Eliminating the HugeTLB specific code
also allows for additional cleanup (patches 10 - 13).

Testing the page walk approach revealed several pre-existing bugs that
are included here (patches 01, 03 and 04) because the changes interact
with the rest of the series, e.g. without the read-only memslots fix,
walking the host page tables without explicitly filtering out HugeTLB
mappings would pick up read-only memslots and introduce a completely
unintended functional change.

Lastly, with the page walk infrastructure in place, supporting DAX-based
huge mappings becomes a trivial change (patch 14).

Based on kvm/queue, commit e41a90be9659 ("KVM: x86/mmu: WARN if root_hpa
is invalid when handling a page fault")

Paolo, assuming I understand your workflow, patch 01 can be squashed with
the buggy commit as it's still sitting in kvm/queue.

[1] https://lkml.kernel.org/r/0000000000003cffc30599d3d1a0@google.com
[2] https://lkml.kernel.org/r/20191212182238.46535-1-brho@google.com

Sean Christopherson (14):
  KVM: x86/mmu: Enforce max_level on HugeTLB mappings
  mm: thp: KVM: Explicitly check for THP when populating secondary MMU
  KVM: Use vcpu-specific gva->hva translation when querying host page
    size
  KVM: Play nice with read-only memslots when querying host page size
  x86/mm: Introduce lookup_address_in_mm()
  KVM: x86/mmu: Refactor THP adjust to prep for changing query
  KVM: x86/mmu: Walk host page tables to find THP mappings
  KVM: x86/mmu: Drop level optimization from fast_page_fault()
  KVM: x86/mmu: Rely on host page tables to find HugeTLB mappings
  KVM: x86/mmu: Remove obsolete gfn restoration in FNAME(fetch)
  KVM: x86/mmu: Zap any compound page when collapsing sptes
  KVM: x86/mmu: Fold max_mapping_level() into kvm_mmu_hugepage_adjust()
  KVM: x86/mmu: Remove lpage_is_disallowed() check from set_spte()
  KVM: x86/mmu: Use huge pages for DAX-backed files

 arch/powerpc/kvm/book3s_xive_native.c |   2 +-
 arch/x86/include/asm/pgtable_types.h  |   4 +
 arch/x86/kvm/mmu/mmu.c                | 208 ++++++++++----------------
 arch/x86/kvm/mmu/paging_tmpl.h        |  29 +---
 arch/x86/mm/pageattr.c                |  11 ++
 include/linux/huge_mm.h               |   6 +
 include/linux/kvm_host.h              |   3 +-
 mm/huge_memory.c                      |  11 ++
 virt/kvm/arm/mmu.c                    |   8 +-
 virt/kvm/kvm_main.c                   |  24 ++-
 10 files changed, 145 insertions(+), 161 deletions(-)

-- 
2.24.1

