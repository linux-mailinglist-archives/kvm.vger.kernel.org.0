Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD32A134D64
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgAHU13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:27:29 -0500
Received: from mga06.intel.com ([134.134.136.31]:45246 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbgAHU1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658387"
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
Subject: [PATCH 10/14] KVM: x86/mmu: Remove obsolete gfn restoration in FNAME(fetch)
Date:   Wed,  8 Jan 2020 12:24:44 -0800
Message-Id: <20200108202448.9669-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove logic to retrieve the original gfn now that HugeTLB mappings are
are identified in FNAME(fetch), i.e. FNAME(page_fault) no longer adjusts
the level or gfn.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 841506a55815..0560982eda8b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -621,7 +621,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	struct kvm_shadow_walk_iterator it;
 	unsigned direct_access, access = gw->pt_access;
 	int top_level, hlevel, ret;
-	gfn_t gfn, base_gfn;
+	gfn_t base_gfn = gw->gfn;
 
 	direct_access = gw->pte_access;
 
@@ -666,13 +666,6 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
-	/*
-	 * FNAME(page_fault) might have clobbered the bottom bits of
-	 * gw->gfn, restore them from the virtual address.
-	 */
-	gfn = gw->gfn | ((addr & PT_LVL_OFFSET_MASK(gw->level)) >> PAGE_SHIFT);
-	base_gfn = gfn;
-
 	hlevel = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn);
 
 	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
@@ -684,9 +677,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
-		disallowed_hugepage_adjust(it, gfn, &pfn, &hlevel);
+		disallowed_hugepage_adjust(it, gw->gfn, &pfn, &hlevel);
 
-		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == hlevel)
 			break;
 
-- 
2.24.1

