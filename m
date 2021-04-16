Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FE136243D
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbhDPPmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:3339 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343961AbhDPPmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:10 -0400
IronPort-SDR: xXrc7HYIwZTDsgwF1KUCZWZZFNKqHukzxVxjwAPQjmDg2wph8cdNfwSUYaEVXnLXkEGI5a0rwG
 6kN1Wfxoa3zg==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="259013598"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="259013598"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:43 -0700
IronPort-SDR: smzvmzhAz7siSWzlCg7OhYyupxhl2DWlKLBDXV9vxp3jd807ASXENtwiD31DJV3hL/ZKXosc7a
 d9bJxAknmEZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="533495256"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 16 Apr 2021 08:41:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 2964030E; Fri, 16 Apr 2021 18:41:50 +0300 (EEST)
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
Subject: [RFCv2 09/13] shmem: Fail shmem_getpage_gfp() on poisoned pages
Date:   Fri, 16 Apr 2021 18:41:02 +0300
Message-Id: <20210416154106.23721-10-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Forbid access to poisoned pages.

TODO: Probably more fine-grained approach is needed. It shuld be a
allowed to fault-in these pages as hwpoison entries.

Not-Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/shmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 7c6b6d8f6c39..d29a0c9be19c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1832,6 +1832,13 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 
 	if (page)
 		hindex = page->index;
+
+	if (page && PageHWPoison(page)) {
+		unlock_page(page);
+		put_page(page);
+		return -EIO;
+	}
+
 	if (page && sgp == SGP_WRITE)
 		mark_page_accessed(page);
 
-- 
2.26.3

