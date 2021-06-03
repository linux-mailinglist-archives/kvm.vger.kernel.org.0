Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E7D39B515
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 10:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhFDIpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 04:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhFDIpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 04:45:35 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6913C06174A
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 01:43:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 29so7286724pgu.11
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 01:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FigIGmRIu5SYFHKn/ZPvBuA0AvniqiVs7gd/RP2sOog=;
        b=Iq5t2MILAMIw8b8me94GQifcgT+ECntTBGCLZyHEylAOqmmBt+SycqWSyi4Vz0s+fE
         L8iy4GU82U56VWRWFxZfRPv4/sAZIvdFbaEDnpWUjnWCayHjg0DY42WxeZ9nhfuloegW
         y28Hnx/Qs8GAQ5WOumRRHkTzb/vNHDX75Rm/z245h0khyE29LV/EUX9k/IKgWJ35RCZz
         8zGIRdQDmldTnQFxyawmi6v5QWszJM5KW1fepuwGw7gNGrUoP09GfMyeNUiAAXhEsuCU
         gA0N+gLuUnLqdhIio2WAwXvCO1FMIHaC2Ip2FkfUNusefBvYCbQIJwGicVyvD0ausDmV
         uHBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FigIGmRIu5SYFHKn/ZPvBuA0AvniqiVs7gd/RP2sOog=;
        b=B6D8pTlGVB2GJbgm8jUeykNxbkFyVKAB/hedsjCBdj+NDuzKgWnWEErjoY8USSHVMn
         1gIghqM4kFYbQy2ZkLuLDjXFWCt9a2E3WrBmQiv9HQAJqh5LRpWT2Wprs780JYMPYGlf
         ZgNM+geDyxJaGjRR9sbRp4XD7ieHYQsThbJHVw0OVwevtswUyD1yLqBT5qbNDOEWOHgv
         XXim6k4gISoQk5fR7mtXx4YSolrd3Hqx9Fs3F66lBrNeRT3kbBX/g3M4nB017RHw6k0G
         9EurFMRyhmys+hyj4n7Y03tgAO7oCs99q2+zIsfOnqfujsXbTNAw7JIZ7U2QKRpJLsrt
         CjNQ==
X-Gm-Message-State: AOAM530FD7T4/eviebsc5XX4yXa50SdGqDqW8tTMioajX3k+qprrKZi8
        XTvg0TBdLhdIS0IkI9GXT0vvqlLixnU=
X-Google-Smtp-Source: ABdhPJyhKs2Bau/r3KMYNFiAm0MxyjIS1LT3PZt1obBV7dgBYZHqg2ZQcsBma6BGDdRC2HfKVQ+y9Q==
X-Received: by 2002:a65:4d03:: with SMTP id i3mr3851077pgt.422.1622796229253;
        Fri, 04 Jun 2021 01:43:49 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id cl2sm4080250pjb.31.2021.06.04.01.43.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jun 2021 01:43:48 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [kvm-unit-tests PATCH V2] x86: Add a test to check effective permissions
Date:   Fri,  4 Jun 2021 06:58:51 +0800
Message-Id: <20210603225851.26621-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <YLkh3bQ106M9nV3k@google.com>
References: <YLkh3bQ106M9nV3k@google.com>
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
index 7dc9eb6..98b8545 100644
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
+	unsigned long ptr2 = ptr1 + 2 * 1024 * 1024;
+	unsigned long ptr3 = ptr1 + 1 * 1024 * 1024 * 1024;
+	unsigned long ptr4 = ptr3 + 2 * 1024 * 1024;
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

