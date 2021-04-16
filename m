Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E61362436
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343964AbhDPPmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:4092 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343943AbhDPPmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:07 -0400
IronPort-SDR: UnfIaZTA1WTwaplTy6pGqT4QKIXSSwzVUf6K5A1MPONKw6BU73gyEc5XP1G6rrGUCsC+nJqgMS
 M69UNntXbv/A==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="195169144"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="195169144"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:41 -0700
IronPort-SDR: ar7dDxzt2Oi7GIhsG5qtuISAhRHVX9LRp+f1DQ8gtF04+3xB3T4x0fabS8zuRBBAEv60tGGXg6
 I/rj8v9izkvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="383087500"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 16 Apr 2021 08:41:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 1DDE82CF; Fri, 16 Apr 2021 18:41:50 +0300 (EEST)
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
Subject: [RFCv2 08/13] mm/gup: Add FOLL_ALLOW_POISONED
Date:   Fri, 16 Apr 2021 18:41:01 +0300
Message-Id: <20210416154106.23721-9-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new flag allows to bypass check if the page is poisoned and get
reference on it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h |  1 +
 mm/gup.c           | 29 ++++++++++++++++++-----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ecdf8a8cd6ae..378a94481fd1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2802,6 +2802,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
 #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
 #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
+#define FOLL_ALLOW_POISONED 0x100000 /* bypass poison check */
 
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
diff --git a/mm/gup.c b/mm/gup.c
index e4c224cd9661..dd3b79b03eb5 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -384,22 +384,29 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	pte = *ptep;
 	if (!pte_present(pte)) {
-		swp_entry_t entry;
+		swp_entry_t entry = pte_to_swp_entry(pte);
+
+		if (pte_none(pte))
+			goto no_page;
+
 		/*
 		 * KSM's break_ksm() relies upon recognizing a ksm page
 		 * even while it is being migrated, so for that case we
 		 * need migration_entry_wait().
 		 */
-		if (likely(!(flags & FOLL_MIGRATION)))
-			goto no_page;
-		if (pte_none(pte))
-			goto no_page;
-		entry = pte_to_swp_entry(pte);
-		if (!is_migration_entry(entry))
-			goto no_page;
-		pte_unmap_unlock(ptep, ptl);
-		migration_entry_wait(mm, pmd, address);
-		goto retry;
+		if (is_migration_entry(entry) && (flags & FOLL_MIGRATION)) {
+			pte_unmap_unlock(ptep, ptl);
+			migration_entry_wait(mm, pmd, address);
+			goto retry;
+		}
+
+		if (is_hwpoison_entry(entry) && (flags & FOLL_ALLOW_POISONED)) {
+			page = hwpoison_entry_to_page(entry);
+			get_page(page);
+			goto out;
+		}
+
+		goto no_page;
 	}
 	if ((flags & FOLL_NUMA) && pte_protnone(pte))
 		goto no_page;
-- 
2.26.3

