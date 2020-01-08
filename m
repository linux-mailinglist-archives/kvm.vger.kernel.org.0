Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E0B134D73
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 21:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgAHU1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 15:27:46 -0500
Received: from mga06.intel.com ([134.134.136.31]:45241 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727302AbgAHU1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 15:27:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:27:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211658370"
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
Subject: [PATCH 05/14] x86/mm: Introduce lookup_address_in_mm()
Date:   Wed,  8 Jan 2020 12:24:39 -0800
Message-Id: <20200108202448.9669-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper, lookup_address_in_mm(), to traverse the page tables of a
given mm struct.  KVM will use the helper to retrieve the host mapping
level, e.g. 4k vs. 2mb vs. 1gb, of a compound (or DAX-backed) page
without having to resort to implementation specific metadata.  E.g. KVM
currently uses different logic for HugeTLB vs. THP, and would add a
third variant for DAX-backed files.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/pgtable_types.h |  4 ++++
 arch/x86/mm/pageattr.c               | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b5e49e6bac63..400ac8da75e8 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -561,6 +561,10 @@ static inline void update_page_count(int level, unsigned long pages) { }
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
 				    unsigned int *level);
+
+struct mm_struct;
+pte_t *lookup_address_in_mm(struct mm_struct *mm, unsigned long address,
+			    unsigned int *level);
 extern pmd_t *lookup_pmd_address(unsigned long address);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int __init kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn,
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 0d09cc5aad61..8787fec876e4 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -618,6 +618,17 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
 }
 EXPORT_SYMBOL_GPL(lookup_address);
 
+/*
+ * Lookup the page table entry for a virtual address in a given mm. Return a
+ * pointer to the entry and the level of the mapping.
+ */
+pte_t *lookup_address_in_mm(struct mm_struct *mm, unsigned long address,
+			    unsigned int *level)
+{
+	return lookup_address_in_pgd(pgd_offset(mm, address), address, level);
+}
+EXPORT_SYMBOL_GPL(lookup_address_in_mm);
+
 static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
 				  unsigned int *level)
 {
-- 
2.24.1

