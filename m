Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8845C36243F
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhDPPmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:10803 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343993AbhDPPmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:11 -0400
IronPort-SDR: n94Lt51jOBkjwKnaxLRjWZf5zBWf0bQKIEMond6YyUHQWUshn8yykoqnre/dHhzze7+koInlWM
 gCrBE7ugeHVQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="175163937"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="175163937"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:43 -0700
IronPort-SDR: GV2YKh3YQQwBbOm00/MLd7uBYxj/MRkz8+eXvddmWNUVHa4PpCVjoCFf3t4suV3PJ2PGTLh9zq
 X73Pit5nhcWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="422038785"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 16 Apr 2021 08:41:38 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 35AC835A; Fri, 16 Apr 2021 18:41:50 +0300 (EEST)
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
Subject: [RFCv2 10/13] mm: Keep page reference for hwpoison entries
Date:   Fri, 16 Apr 2021 18:41:03 +0300
Message-Id: <20210416154106.23721-11-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On migration we drop referece to a page once PTE gets replaced with a
migration entry. Migration code keeps the last reference on the page
that gets dropped once migration is complete.

We do the same for hwpoison entries, but it doesn't work: nobody keeps
the reference once page is remapped with hwpoison entries.

Keep page referenced on setting up hwpoison entries, copy the reference
on fork() and return on zap().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/memory.c | 6 ++++++
 mm/rmap.c   | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index feff48e1465a..b15b0c582186 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -767,6 +767,9 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 				pte = pte_swp_mkuffd_wp(pte);
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
+	} else if (is_hwpoison_entry(entry)) {
+		page = hwpoison_entry_to_page(entry);
+		get_page(page);
 	}
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
@@ -1305,6 +1308,9 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 
 			page = migration_entry_to_page(entry);
 			rss[mm_counter(page)]--;
+
+		} else if (is_hwpoison_entry(entry)) {
+			put_page(hwpoison_entry_to_page(entry));
 		}
 		if (unlikely(!free_swap_and_cache(entry)))
 			print_bad_pte(vma, addr, ptent, NULL);
diff --git a/mm/rmap.c b/mm/rmap.c
index 08c56aaf72eb..f08d1fc28522 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1575,7 +1575,7 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 				dec_mm_counter(mm, mm_counter(page));
 				set_pte_at(mm, address, pvmw.pte, pteval);
 			}
-
+			get_page(page);
 		} else if (pte_unused(pteval) && !userfaultfd_armed(vma)) {
 			/*
 			 * The guest indicated that the page content is of no
-- 
2.26.3

