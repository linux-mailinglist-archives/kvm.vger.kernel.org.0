Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7263134D67
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgAHU1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:27:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:45246 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbgAHU1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658377"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:06 -0800
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
Subject: [PATCH 07/14] KVM: x86/mmu: Walk host page tables to find THP mappings
Date:   Wed,  8 Jan 2020 12:24:41 -0800
Message-Id: <20200108202448.9669-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly walk the host page tables to identify THP mappings instead
of relying solely on the metadata in struct page.  This sets the stage
for using a common method of identifying huge mappings regardless of the
underlying implementation (HugeTLB vs THB vs DAX), and hopefully avoids
the pitfalls of relying on metadata to identify THP mappings, e.g. see
commit 169226f7e0d2 ("mm: thp: handle page cache THP correctly in
PageTransCompoundMap") and the need for KVM to explicitly check for a
THP compound page.  KVM will also naturally work with 1gb THP pages, if
they are ever supported.

Walking the tables for THP mappings is likely marginally slower than
querying metadata, but a future patch will reuse the walk to identify
HugeTLB mappings, at which point eliminating the existing VMA lookup for
HugeTLB will make this a net positive.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Barret Rhoden <brho@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 30836899be73..4bd7f745b56d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3329,6 +3329,41 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
+static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
+				  kvm_pfn_t pfn)
+{
+	struct kvm_memory_slot *slot;
+	unsigned long hva;
+	pte_t *pte;
+	int level;
+
+	BUILD_BUG_ON(PT_PAGE_TABLE_LEVEL != (int)PG_LEVEL_4K ||
+		     PT_DIRECTORY_LEVEL != (int)PG_LEVEL_2M ||
+		     PT_PDPE_LEVEL != (int)PG_LEVEL_1G);
+
+	if (!PageCompound(pfn_to_page(pfn)))
+		return PT_PAGE_TABLE_LEVEL;
+
+	/*
+	 * Manually do the equivalent of kvm_vcpu_gfn_to_hva() to avoid the
+	 * "writable" check in __gfn_to_hva_many(), which will always fail on
+	 * read-only memslots due to gfn_to_hva() assuming writes.  Earlier
+	 * page fault steps have already verified the guest isn't writing a
+	 * read-only memslot.
+	 */
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	if (!memslot_valid_for_gpte(slot, true))
+		return PT_PAGE_TABLE_LEVEL;
+
+	hva = __gfn_to_hva_memslot(slot, gfn);
+
+	pte = lookup_address_in_mm(vcpu->kvm->mm, hva, &level);
+	if (unlikely(!pte))
+		return PT_PAGE_TABLE_LEVEL;
+
+	return level;
+}
+
 static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 					int max_level, kvm_pfn_t *pfnp,
 					int *levelp)
@@ -3344,10 +3379,11 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	    kvm_is_zone_device_pfn(pfn))
 		return;
 
-	if (!kvm_is_transparent_hugepage(pfn))
+	level = host_pfn_mapping_level(vcpu, gfn, pfn);
+	if (level == PT_PAGE_TABLE_LEVEL)
 		return;
 
-	level = PT_DIRECTORY_LEVEL;
+	level = min(level, max_level);
 
 	/*
 	 * mmu_notifier_retry() was successful and mmu_lock is held, so
-- 
2.24.1

