Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037A239CC85
	for <lists+kvm@lfdr.de>; Sun,  6 Jun 2021 05:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhFFDgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Jun 2021 23:36:53 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:38447 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhFFDgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Jun 2021 23:36:50 -0400
Received: by mail-pl1-f171.google.com with SMTP id 69so6762048plc.5
        for <kvm@vger.kernel.org>; Sat, 05 Jun 2021 20:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ir8CVDhx6en7seLrXpyk0K2usxyKmYYFZuUIwq7ig4Q=;
        b=kkgYus6I3PcqeLEFQ/IZOFkAtZLPXef9h9Z9XCIj6GmAGasIS4JW1v2Snq7B7/eexp
         K+vD4Q5Jm9a8nQMOlTQZ8ZbJQyMaFhDUhuc4lJKO9H6hv9XmkDxdeaU7sA1elbu1kIoo
         L5dEpb2arE0TYJUwlRLuPXIO8AuiV9jRXT0izwmZnovLtuVGRM7TDBEgNtXTcGzuIQjO
         FO6CH0vKVGVj3nbkxcnnf2ssNXQWkUqrmIDDKdc+FUJtyMivM2EljRbmCUbG1LN6gzNu
         lCGtEEnddtBUvLPgIDA+3VSwkCJ40DNAgACVdUsGh43S7WUC1ZieH9mHpoDR7p9F1gZy
         fIag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ir8CVDhx6en7seLrXpyk0K2usxyKmYYFZuUIwq7ig4Q=;
        b=B9pdF3/1aR6KaQCehIHWaGNKieAEYcxdV8cJ3idZmmUmy9UJc4fPjuxUe2a/NbO2v4
         TVJcycru6PtMCid5NZGJBYCj8c9/XTCeiuu5ls/ohSdYAtTe0hDP9MP3om6ZkqgW1fT7
         RuwGAjUBVp9EKdjeyjdTpuNmhK+WLb9bxnaBcdoLhetq6YQXjQc3pZKT+QJ7Ok2MKDt0
         DqLZ6h6/iD5aa+KGJDKcAAru63Udv9Mt+NPdsMWLIz6uLSCQELFHxrslb7Xm22YPVggy
         mF1eiocygkzEB4P3vu2ruBWDxisxwb9swbnyKqh70phy+7+lkZZHoss78ZwE6W06+zsc
         tYbQ==
X-Gm-Message-State: AOAM530cVd1mT06MEfGDEV+wqLWO5+dFLeDgp7D+zCtkdnJ3+ZTT/yG7
        Rlv2Hx3CRwxvGuk7Y83KakAuLm6p4F8=
X-Google-Smtp-Source: ABdhPJzRqcq3oKpmTiuNohNqjbNDbRJX1hGImUNvJPst9leQXG1QE+8z1ovaCFGyEOiHI08a1Oky/Q==
X-Received: by 2002:a17:90a:dc04:: with SMTP id i4mr13414955pjv.75.1622950441237;
        Sat, 05 Jun 2021 20:34:01 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id w10sm4944202pfg.196.2021.06.05.20.33.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Jun 2021 20:34:00 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [kvm-unit-tests PATCH V3] x86: Add a test to check effective permissions
Date:   Sun,  6 Jun 2021 01:49:01 +0800
Message-Id: <20210605174901.157556-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <6c87d221-8b6c-56a7-e8d1-31ad8a8379e3@linux.alibaba.com>
References: <6c87d221-8b6c-56a7-e8d1-31ad8a8379e3@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Add a test to verify that KVM correctly handles the case where two or
more non-leaf page table entries point at the same table gfn, but with
different parent access permissions.

For example, here is a shared pagetable:
   pgd[]   pud[]        pmd[]            virtual address pointers
                     /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
        /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
   pgd-|           (shared pmd[] as above)
        \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
                     \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
  pud1 and pud2 point to the same pmd table

The test is useful when TDP is not enabled.

Co-Developed-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 x86/access.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 100 insertions(+), 6 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 7dc9eb6..0ad677e 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -60,6 +60,12 @@ enum {
     AC_PDE_BIT36_BIT,
     AC_PDE_BIT13_BIT,
 
+    /*
+     *  special test case to DISABLE writable bit on page directory
+     *  pointer table entry.
+     */
+    AC_PDPTE_NO_WRITABLE_BIT,
+
     AC_PKU_AD_BIT,
     AC_PKU_WD_BIT,
     AC_PKU_PKEY_BIT,
@@ -97,6 +103,8 @@ enum {
 #define AC_PDE_BIT36_MASK     (1 << AC_PDE_BIT36_BIT)
 #define AC_PDE_BIT13_MASK     (1 << AC_PDE_BIT13_BIT)
 
+#define AC_PDPTE_NO_WRITABLE_MASK  (1 << AC_PDPTE_NO_WRITABLE_BIT)
+
 #define AC_PKU_AD_MASK        (1 << AC_PKU_AD_BIT)
 #define AC_PKU_WD_MASK        (1 << AC_PKU_WD_BIT)
 #define AC_PKU_PKEY_MASK      (1 << AC_PKU_PKEY_BIT)
@@ -130,6 +138,7 @@ const char *ac_names[] = {
     [AC_PDE_BIT51_BIT] = "pde.51",
     [AC_PDE_BIT36_BIT] = "pde.36",
     [AC_PDE_BIT13_BIT] = "pde.13",
+    [AC_PDPTE_NO_WRITABLE_BIT] = "pdpte.ro",
     [AC_PKU_AD_BIT] = "pkru.ad",
     [AC_PKU_WD_BIT] = "pkru.wd",
     [AC_PKU_PKEY_BIT] = "pkey=1",
@@ -326,6 +335,7 @@ static pt_element_t ac_test_alloc_pt(ac_pool_t *pool)
 {
     pt_element_t ret = pool->pt_pool + pool->pt_pool_current;
     pool->pt_pool_current += PAGE_SIZE;
+    memset(va(ret), 0, PAGE_SIZE);
     return ret;
 }
 
@@ -408,7 +418,7 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
 	goto fault;
     }
 
-    writable = F(AC_PDE_WRITABLE);
+    writable = !F(AC_PDPTE_NO_WRITABLE) && F(AC_PDE_WRITABLE);
     user = F(AC_PDE_USER);
     executable = !F(AC_PDE_NX);
 
@@ -471,7 +481,7 @@ static void ac_set_expected_status(ac_test_t *at)
     ac_emulate_access(at, at->flags);
 }
 
-static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
+static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse,
 				      u64 pd_page, u64 pt_page)
 
 {
@@ -496,13 +506,29 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
 	    goto next;
 	}
 	skip = false;
+	if (reuse && vroot[index]) {
+	    switch (i) {
+	    case 2:
+		at->pdep = &vroot[index];
+		break;
+	    case 1:
+		at->ptep = &vroot[index];
+		break;
+	    }
+	    goto next;
+	}
 
 	switch (i) {
 	case 5:
 	case 4:
+	    pte = ac_test_alloc_pt(pool);
+	    pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+	    break;
 	case 3:
 	    pte = pd_page ? pd_page : ac_test_alloc_pt(pool);
-	    pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+	    pte |= PT_PRESENT_MASK | PT_USER_MASK;
+	    if (!F(AC_PDPTE_NO_WRITABLE))
+		pte |= PT_WRITABLE_MASK;
 	    break;
 	case 2:
 	    if (!F(AC_PDE_PSE)) {
@@ -568,13 +594,13 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
 
 static void ac_test_setup_pte(ac_test_t *at, ac_pool_t *pool)
 {
-	__ac_setup_specific_pages(at, pool, 0, 0);
+	__ac_setup_specific_pages(at, pool, false, 0, 0);
 }
 
 static void ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
 				    u64 pd_page, u64 pt_page)
 {
-	return __ac_setup_specific_pages(at, pool, pd_page, pt_page);
+	return __ac_setup_specific_pages(at, pool, false, pd_page, pt_page);
 }
 
 static void dump_mapping(ac_test_t *at)
@@ -930,6 +956,73 @@ err:
 	return 0;
 }
 
+static int check_effective_sp_permissions(ac_pool_t *pool)
+{
+	unsigned long ptr1 = 0x123480000000;
+	unsigned long ptr2 = ptr1 + SZ_2M;
+	unsigned long ptr3 = ptr1 + SZ_1G;
+	unsigned long ptr4 = ptr3 + SZ_2M;
+	pt_element_t pmd = ac_test_alloc_pt(pool);
+	ac_test_t at1, at2, at3, at4;
+	int err_read_at1, err_write_at2;
+	int err_read_at3, err_write_at4;
+
+	/*
+	 * pgd[]   pud[]        pmd[]            virtual address pointers
+	 *                   /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
+	 *      /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
+	 * pgd-|           (shared pmd[] as above)
+	 *      \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
+	 *                   \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
+	 * pud1 and pud2 point to the same pmd page.
+	 */
+
+	ac_test_init(&at1, (void *)(ptr1));
+	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
+		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
+		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
+		    AC_PTE_WRITABLE_MASK | AC_ACCESS_USER_MASK;
+	__ac_setup_specific_pages(&at1, pool, false, pmd, 0);
+
+	ac_test_init(&at2, (void *)(ptr2));
+	at2.flags = at1.flags | AC_PDE_WRITABLE_MASK | AC_PTE_DIRTY_MASK | AC_ACCESS_WRITE_MASK;
+	__ac_setup_specific_pages(&at2, pool, true, pmd, 0);
+
+	ac_test_init(&at3, (void *)(ptr3));
+	at3.flags = AC_PDPTE_NO_WRITABLE_MASK | at1.flags;
+	__ac_setup_specific_pages(&at3, pool, true, pmd, 0);
+
+	ac_test_init(&at4, (void *)(ptr4));
+	at4.flags = AC_PDPTE_NO_WRITABLE_MASK | at2.flags;
+	__ac_setup_specific_pages(&at4, pool, true, pmd, 0);
+
+	err_read_at1 = ac_test_do_access(&at1);
+	if (!err_read_at1) {
+		printf("%s: read access at1 fail\n", __FUNCTION__);
+		return 0;
+	}
+
+	err_write_at2 = ac_test_do_access(&at2);
+	if (!err_write_at2) {
+		printf("%s: write access at2 fail\n", __FUNCTION__);
+		return 0;
+	}
+
+	err_read_at3 = ac_test_do_access(&at3);
+	if (!err_read_at3) {
+		printf("%s: read access at3 fail\n", __FUNCTION__);
+		return 0;
+	}
+
+	err_write_at4 = ac_test_do_access(&at4);
+	if (!err_write_at4) {
+		printf("%s: write access at4 should fail\n", __FUNCTION__);
+		return 0;
+	}
+
+	return 1;
+}
+
 static int ac_test_exec(ac_test_t *at, ac_pool_t *pool)
 {
     int r;
@@ -948,7 +1041,8 @@ const ac_test_fn ac_test_cases[] =
 	corrupt_hugepage_triger,
 	check_pfec_on_prefetch_pte,
 	check_large_pte_dirty_for_nowp,
-	check_smep_andnot_wp
+	check_smep_andnot_wp,
+	check_effective_sp_permissions,
 };
 
 static int ac_test_run(void)
-- 
2.19.1.6.gb485710b

