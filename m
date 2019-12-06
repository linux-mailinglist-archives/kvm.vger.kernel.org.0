Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8EFB1159EC
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfLFX5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:57:36 -0500
Received: from mga07.intel.com ([134.134.136.100]:55584 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbfLFX5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530319"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:34 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/16] KVM: x86: MMU page fault clean-up
Date:   Fri,  6 Dec 2019 15:57:13 -0800
Message-Id: <20191206235729.29263-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The original purpose of this series was to call thp_adjust() from
__direct_map() and FNAME(fetch) to eliminate a page refcounting quirk[*].
Before doing that, I wanted to clean up the large page handling so that
the map/fetch funtions weren't being passed multiple booleans that tracked
the same basic info.  While trying to decipher all the the interactions,
I stumbled across a handful of fun things:

  - 32-bit KVM w/ TDP is completely broken with respect to 64-bit GPAs due
    to the page fault handlers and all related flows dropping bits 63:32
    of the GPA.  As a result, KVM inserts the wrong GPA and the guest hangs
    because it generates EPT/NPT faults until it's killed.

  - The TDP and non-paging page fault flows are identical except for
    one-off constraints on guest page size.

  - The !VALID_PAGE(root_hpa) checks in the page fault flows are bogus.
    They were added a few years ago to "fix" a nVMX bug and are no longer
    needed now that nVMX is in much better shape.

Patch 1 fixes the 32-bit KVM w/ TDP issue.  More details below.

Patches 2-12 are 99% refactoring to merge TDP and non-paging page fault
handling, and to do the thp_adjust() move.  These are basically nops from
a functional perspective.  There are technically functional changes in a
few patches, but they are very superficial and in theory won't be
observable in normal usage.

Patches 13-16 add WARNs on the !VALID_PAGE(root_hpa) checks to make it
clear that root_hpa is expected to be valid when handling page faults,
e.g. for the longest time I thought KVM relied on the checks in map/fetch
to correctly handle kvm_mmu_zap_all().


32-bit KVM w/ TDP:

I marked this patch for stable because it's obviously a bug fix, but I'm
entirely not sure we want to backport the fix.  Obviously no userspace VMM
is actually exposing 64-bit GPAs to its guests, i.e. odds are this won't
actually fix any real world use cases.  And, the scope of the changes are
likely going to make backporting a pain.  But, on the other hand, if it's
not backported then future bug fixes in related code are likely to
conflict, and it does fix the case where a buggy guest kernel accesses a
non-existent 64-bit GPA (crashes instead of hanging indefinitely).

I'm also not confident I found all the cases where KVM is truncating the
GPA.  AFAIK, 32-bit Qemu simply doesn't support 64-bit GPAs.  To confirm
the bug and verify the fix, I hacked KVM and the guest kernel to generate
64-bit GPAs when remapping MMIO, which covers a tiny fragment of KVM.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa46fbed60013..49a59bcb32117 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5737,7 +5737,7 @@ static int emulator_read_write(struct x86_emulate_ctxt *ctxt,
        vcpu->run->mmio.len = min(8u, vcpu->mmio_fragments[0].len);
        vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
        vcpu->run->exit_reason = KVM_EXIT_MMIO;
-       vcpu->run->mmio.phys_addr = gpa;
+       vcpu->run->mmio.phys_addr = gpa & 0xffffffffull;
 
        return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
 }


diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index b9c78f3bcd673..e22f254987bea 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -184,7 +184,10 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
        if (kernel_map_sync_memtype(phys_addr, size, pcm))
                goto err_free_area;
 
-       if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot))
+       BUG_ON(!boot_cpu_data.x86_phys_bits);
+
+       if (ioremap_page_range(vaddr, vaddr + size,
+                              phys_addr | BIT_ULL(boot_cpu_data.x86_phys_bits - 1), prot))
                goto err_free_area;
 
        ret_addr = (void __iomem *) (vaddr + offset);

[*] https://lkml.kernel.org/r/20191126174603.GB22233@linux.intel.com

Sean Christopherson (16):
  KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM
  KVM: x86/mmu: Move definition of make_mmu_pages_available() up
  KVM: x86/mmu: Fold nonpaging_map() into nonpaging_page_fault()
  KVM: x86/mmu: Move nonpaging_page_fault() below try_async_pf()
  KVM: x86/mmu: Refactor handling of cache consistency with TDP
  KVM: x86/mmu: Refactor the per-slot level calculation in
    mapping_level()
  KVM: x86/mmu: Refactor handling of forced 4k pages in page faults
  KVM: x86/mmu: Incorporate guest's page level into max level for shadow
    MMU
  KVM: x86/mmu: Persist gfn_lpage_is_disallowed() to max_level
  KVM: x86/mmu: Rename lpage_disallowed to account_disallowed_nx_lpage
  KVM: x86/mmu: Consolidate tdp_page_fault() and nonpaging_page_fault()
  KVM: x86/mmu: Move transparent_hugepage_adjust() above __direct_map()
  KVM: x86/mmu: Move calls to thp_adjust() down a level
  KVM: x86/mmu: Move root_hpa validity checks to top of page fault
    handler
  KVM: x86/mmu: WARN on an invalid root_hpa
  KVM: x86/mmu: WARN if root_hpa is invalid when handling a page fault

 arch/x86/include/asm/kvm_host.h |   8 +-
 arch/x86/kvm/mmu/mmu.c          | 438 ++++++++++++++------------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  58 +++--
 arch/x86/kvm/mmutrace.h         |  12 +-
 arch/x86/kvm/x86.c              |  40 ++-
 arch/x86/kvm/x86.h              |   2 +-
 include/linux/kvm_host.h        |   6 +-
 virt/kvm/async_pf.c             |  10 +-
 8 files changed, 259 insertions(+), 315 deletions(-)

-- 
2.24.0

