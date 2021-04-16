Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8C936243E
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbhDPPmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:10800 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343992AbhDPPmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:11 -0400
IronPort-SDR: wfem44kkoBDDVcbXMsVSG37pJir2Mo55HGtqbltnwwhHGatu/HRpw7VeaD4HppdxlhYfhaxR0H
 4eVLQDpBwSHQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="175163938"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="175163938"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:43 -0700
IronPort-SDR: BiatwMA0y8qUcIW7/n3v5VFpxjtDSkQkoZb1k+sB1Z4cLkxVSZkRIORtiu9iZm6VdBUjhLkGV4
 eMT6uG8NXbTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="422038787"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 16 Apr 2021 08:41:38 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 41BE135E; Fri, 16 Apr 2021 18:41:50 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 11/13] mm: Replace hwpoison entry with present PTE if page got unpoisoned
Date:   Fri, 16 Apr 2021 18:41:04 +0300
Message-Id: <20210416154106.23721-12-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the page got unpoisoned we can replace hwpoison entry with a present
PTE on page fault instead of delivering SIGBUS.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/memory.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index b15b0c582186..56f93e8e98f9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3280,7 +3280,43 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			vmf->page = device_private_entry_to_page(entry);
 			ret = vmf->page->pgmap->ops->migrate_to_ram(vmf);
 		} else if (is_hwpoison_entry(entry)) {
-			ret = VM_FAULT_HWPOISON;
+			page = hwpoison_entry_to_page(entry);
+
+			locked = lock_page_or_retry(page, vma->vm_mm, vmf->flags);
+			if (!locked) {
+				ret = VM_FAULT_RETRY;
+				goto out;
+			}
+
+			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+						       vmf->address, &vmf->ptl);
+
+			if (unlikely(!pte_same(*vmf->pte, vmf->orig_pte))) {
+				ret = 0;
+			} else if (PageHWPoison(page)) {
+				ret = VM_FAULT_HWPOISON;
+			} else {
+				/*
+				 * The page is unpoisoned. Replace hwpoison
+				 * entry with a present PTE.
+				 */
+
+				inc_mm_counter(vma->vm_mm, mm_counter(page));
+				pte = mk_pte(page, vma->vm_page_prot);
+
+				if (PageAnon(page)) {
+					page_add_anon_rmap(page, vma,
+							   vmf->address, false);
+				} else {
+					page_add_file_rmap(page, false);
+				}
+
+				set_pte_at(vma->vm_mm, vmf->address,
+					   vmf->pte, pte);
+			}
+
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
+			unlock_page(page);
 		} else {
 			print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
 			ret = VM_FAULT_SIGBUS;
-- 
2.26.3

