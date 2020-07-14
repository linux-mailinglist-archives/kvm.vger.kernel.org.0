Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407DA21E6C7
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 06:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgGNEUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 00:20:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:36617 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgGNEUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 00:20:47 -0400
IronPort-SDR: WC5FvcJyh5a9a1jbh+hU61p8BZ1Yq0h84DoGKuQeWRhSFCOybTkAOhgajO/5E5yk18TQo7fHd9
 WIvR8nU8pMaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="147933846"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="147933846"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 21:20:47 -0700
IronPort-SDR: f+TaMNHxkuirtQ3ImzLoVq2T847Pq4JhWcbXOci3WFLPT2F30cG6/92BgYp6hDNrZ1mMiZjys+
 hN+kWk7bVVOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="268545172"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2020 21:20:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] lib/alloc_page: Revert to 'unsigned long' for @size params
Date:   Mon, 13 Jul 2020 21:20:46 -0700
Message-Id: <20200714042046.13419-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert to using 'unsigned long' instead of 'size_t' for free_pages() and
get_order().  The recent change to size_t for free_pages() breaks i386
with -Werror as the assert_msg() formats expect unsigned longs, whereas
size_t is an 'unsigned int' on i386 (though both longs and ints are 4
bytes).

Message formatting aside, unsigned long is the correct choice given the
current code base as alloc_pages() and free_pages_by_order() explicitly
expect, work on, and/or assert on the size being an unsigned long.

Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 lib/alloc_page.c | 2 +-
 lib/alloc_page.h | 2 +-
 lib/bitops.h     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index fa3c527..aa98981 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -21,7 +21,7 @@ bool page_alloc_initialized(void)
 	return freelist != 0;
 }
 
-void free_pages(void *mem, size_t size)
+void free_pages(void *mem, unsigned long size)
 {
 	void *old_freelist;
 	void *end;
diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 88540d1..80eded7 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -13,7 +13,7 @@ void page_alloc_ops_enable(void);
 void *alloc_page(void);
 void *alloc_pages(unsigned int order);
 void free_page(void *page);
-void free_pages(void *mem, size_t size);
+void free_pages(void *mem, unsigned long size);
 void free_pages_by_order(void *mem, unsigned int order);
 
 #endif
diff --git a/lib/bitops.h b/lib/bitops.h
index 308aa86..dd015e8 100644
--- a/lib/bitops.h
+++ b/lib/bitops.h
@@ -79,7 +79,7 @@ static inline bool is_power_of_2(unsigned long n)
 	return n && !(n & (n - 1));
 }
 
-static inline unsigned int get_order(size_t size)
+static inline unsigned int get_order(unsigned long size)
 {
 	return size ? fls(size) + !is_power_of_2(size) : 0;
 }
-- 
2.26.0

