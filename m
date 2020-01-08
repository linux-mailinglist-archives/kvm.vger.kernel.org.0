Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC465134D4D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgAHU1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:27:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:45246 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbgAHU1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658401"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:07 -0800
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
Subject: [PATCH 14/14] KVM: x86/mmu: Use huge pages for DAX-backed files
Date:   Wed,  8 Jan 2020 12:24:48 -0800
Message-Id: <20200108202448.9669-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Walk the host page tables to identify hugepage mappings for ZONE_DEVICE
pfns, i.e. DAX pages.  Explicitly query kvm_is_zone_device_pfn() when
deciding whether or not to bother walking the host page tables, as DAX
pages do not set up the head/tail infrastructure, i.e. will return false
for PageCompound() even when using huge pages.

Zap ZONE_DEVICE sptes when disabling dirty logging, e.g. if live
migration fails, to allow KVM to rebuild large pages for DAX-based
mappings.  Presumably DAX favors large pages, and worst case scenario is
a minor performance hit as KVM will need to re-fault all DAX-based
pages.

Suggested-by: Barret Rhoden <brho@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Zeng <jason.zeng@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e4e0ac169a7..324e1919722f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3250,7 +3250,7 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 		     PT_DIRECTORY_LEVEL != (int)PG_LEVEL_2M ||
 		     PT_PDPE_LEVEL != (int)PG_LEVEL_1G);
 
-	if (!PageCompound(pfn_to_page(pfn)))
+	if (!PageCompound(pfn_to_page(pfn)) && !kvm_is_zone_device_pfn(pfn))
 		return PT_PAGE_TABLE_LEVEL;
 
 	/*
@@ -3282,8 +3282,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
 		return PT_PAGE_TABLE_LEVEL;
 
-	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn) ||
-	    kvm_is_zone_device_pfn(pfn))
+	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn))
 		return PT_PAGE_TABLE_LEVEL;
 
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
@@ -5910,8 +5909,8 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * mapping if the indirect sp has level = 1.
 		 */
 		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
-		    !kvm_is_zone_device_pfn(pfn) &&
-		    PageCompound(pfn_to_page(pfn))) {
+		    (kvm_is_zone_device_pfn(pfn) ||
+		     PageCompound(pfn_to_page(pfn)))) {
 			pte_list_remove(rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
-- 
2.24.1

