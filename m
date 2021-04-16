Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBE2362439
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344033AbhDPPmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:10800 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343970AbhDPPmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:08 -0400
IronPort-SDR: uWHD7F5t2HzlTcto9mPtvJcDEq9sES5hTS581oUnaruuGCDkBRGkG43VurwDmUL8y3VJxymj3J
 1XinxyK2Ceyw==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="175163936"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="175163936"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:43 -0700
IronPort-SDR: lGuaSt9Jbppuno2GL+IX51ChFHPEI5DU+6ronyLCHnvyol9GOMLKa/g0sci/4syDwSpPwbuOAE
 o2DRvdX+WXuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="422038783"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 16 Apr 2021 08:41:38 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 144FD2BE; Fri, 16 Apr 2021 18:41:50 +0300 (EEST)
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
Subject: [RFCv2 07/13] mm: Add hwpoison_entry_to_pfn() and hwpoison_entry_to_page()
Date:   Fri, 16 Apr 2021 18:41:00 +0300
Message-Id: <20210416154106.23721-8-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to convert hwpoison swap entry to pfn and page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/swapops.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index d9b7c9132c2f..520589b12fb3 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -323,6 +323,16 @@ static inline int is_hwpoison_entry(swp_entry_t entry)
 	return swp_type(entry) == SWP_HWPOISON;
 }
 
+static inline unsigned long hwpoison_entry_to_pfn(swp_entry_t entry)
+{
+	return swp_offset(entry);
+}
+
+static inline struct page *hwpoison_entry_to_page(swp_entry_t entry)
+{
+	return pfn_to_page(hwpoison_entry_to_pfn(entry));
+}
+
 static inline void num_poisoned_pages_inc(void)
 {
 	atomic_long_inc(&num_poisoned_pages);
@@ -345,6 +355,16 @@ static inline int is_hwpoison_entry(swp_entry_t swp)
 	return 0;
 }
 
+static inline unsigned long hwpoison_entry_to_pfn(swp_entry_t entry)
+{
+	return 0;
+}
+
+static inline struct page *hwpoison_entry_to_page(swp_entry_t entry)
+{
+	return NULL;
+}
+
 static inline void num_poisoned_pages_inc(void)
 {
 }
-- 
2.26.3

