Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0DF39A3B1
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 16:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhFCOxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 10:53:34 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:40571 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbhFCOxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 10:53:34 -0400
Received: by mail-pg1-f174.google.com with SMTP id j12so5315400pgh.7
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 07:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mmRR4bhbKA03IJ4A9luFejN0yJcZ05ES8EbjfloeqbY=;
        b=B5aCsNczIT/Scs/AAbN1XuSKs46B31w7cWcLa8/uyakfoMQAkkAw+mKBlDrBaNEsDP
         vukwjFH8yLldUotF6LDv41FGxLJrqY8TnQKyNN74zdnyf6orD8QG/TJWZ/WlC4oYCkV5
         fjG1Ol/A6Xk/1NLAuLDOVPuPKp0P1wKKY2h/1tCQdQ9b+ymdOhVdUlNXsyeEgGnqnd0s
         fPuUitNKrhz+PRSLiebZ7PTzdPspEBAxcoQbvnBONmyWXGWhqSqwhVTrCPO+7bMgVVjD
         7wA9njGauQ/exIu1Qyh5JP86tgQZhQqjlanqgYLvtgFi/aB8MveRHfUOcpn6+KJqC5u9
         z9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mmRR4bhbKA03IJ4A9luFejN0yJcZ05ES8EbjfloeqbY=;
        b=nYNR0XdeKzIocl9FjB1FYNv3DC+QHMGmSpqZTHG9XNHanDT/5ut9WqtLeAWgupoOe7
         gnIYkSjOLgwp8p/p7nHLb8azilwRHQu/t96Xm2/8cuuKf7/iIRyeB26p7hU52I7sprfe
         k+KFLMXNp2nd9Znqu5lkHXvzPu5J0PBBp+vX8+MKt7HPT2961Qe4/cy8GWvdxeiyNKRs
         IZHg1WkWZnXdmdFe7Nh97nSeSo/YLhE6ALCBhWHEVhYKLMdS8sEu1jnMotS4S+bJEuaa
         G+EO5U/BRA6bKRR7MBbfMHyegG6fhHXbFpQamhPLbLc3xUJxfHVvausd1WEl1FXPCA2S
         l63w==
X-Gm-Message-State: AOAM532DHOwUPFPiFAu77GxcUlGe14CM0yg8z8NOc1JXVSFZPdCsE2E+
        TvwXSHhBg2FnZqJliDUakRzve6gsPX4=
X-Google-Smtp-Source: ABdhPJyqzAFlcsr4c/T6kdOz4IiahznA7TuidiSa6FhrmNI9gg/njXeiJegDgPKm7pMsfBpySS3WZQ==
X-Received: by 2002:aa7:92da:0:b029:2e0:461f:2808 with SMTP id k26-20020aa792da0000b02902e0461f2808mr213283pfa.25.1622731833060;
        Thu, 03 Jun 2021 07:50:33 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id k20sm3067624pgl.72.2021.06.03.07.50.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Jun 2021 07:50:32 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [kvm-unit-tests PATCH] x86: test combined access
Date:   Thu,  3 Jun 2021 13:05:37 +0800
Message-Id: <20210603050537.19605-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Check combined access when guest shares pagetables.

For example, here is a shared pagetable:
   pgd[]   pud[]        pmd[]            virtual address pointers
                     /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
        /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
   pgd-|           (shared pmd[] as above)
        \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
                     \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
  pud1 and pud2 point to the same pmd table

The test is usefull when TDP is not enabled.

Co-Developed-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 x86/access.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 93 insertions(+), 6 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 7dc9eb6..6dbe6e5 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -60,6 +60,8 @@ enum {
     AC_PDE_BIT36_BIT,
     AC_PDE_BIT13_BIT,
 
+    AC_PUDE_NO_WRITABLE_BIT, // special test case to disable write bit on PUD entry
+
     AC_PKU_AD_BIT,
     AC_PKU_WD_BIT,
     AC_PKU_PKEY_BIT,
@@ -97,6 +99,8 @@ enum {
 #define AC_PDE_BIT36_MASK     (1 << AC_PDE_BIT36_BIT)
 #define AC_PDE_BIT13_MASK     (1 << AC_PDE_BIT13_BIT)
 
+#define AC_PUDE_NO_WRITABLE_MASK  (1 << AC_PUDE_NO_WRITABLE_BIT)
+
 #define AC_PKU_AD_MASK        (1 << AC_PKU_AD_BIT)
 #define AC_PKU_WD_MASK        (1 << AC_PKU_WD_BIT)
 #define AC_PKU_PKEY_MASK      (1 << AC_PKU_PKEY_BIT)
@@ -326,6 +330,7 @@ static pt_element_t ac_test_alloc_pt(ac_pool_t *pool)
 {
     pt_element_t ret = pool->pt_pool + pool->pt_pool_current;
     pool->pt_pool_current += PAGE_SIZE;
+    memset(va(ret), 0, PAGE_SIZE);
     return ret;
 }
 
@@ -408,7 +413,8 @@ static void ac_emulate_access(ac_test_t *at, unsigned flags)
 	goto fault;
     }
 
-    writable = F(AC_PDE_WRITABLE);
+    writable = !F(AC_PUDE_NO_WRITABLE);
+    writable &= F(AC_PDE_WRITABLE);
     user = F(AC_PDE_USER);
     executable = !F(AC_PDE_NX);
 
@@ -471,7 +477,7 @@ static void ac_set_expected_status(ac_test_t *at)
     ac_emulate_access(at, at->flags);
 }
 
-static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
+static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse,
 				      u64 pd_page, u64 pt_page)
 
 {
@@ -496,13 +502,26 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
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
 	case 3:
-	    pte = pd_page ? pd_page : ac_test_alloc_pt(pool);
+	    pte = (i==3 && pd_page) ? pd_page : ac_test_alloc_pt(pool);
 	    pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+	    if (F(AC_PUDE_NO_WRITABLE))
+		pte &= ~PT_WRITABLE_MASK;
 	    break;
 	case 2:
 	    if (!F(AC_PDE_PSE)) {
@@ -568,13 +587,13 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
 
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
@@ -930,6 +949,73 @@ err:
 	return 0;
 }
 
+static int check_combined_protection(ac_pool_t *pool)
+{
+	ac_test_t at1, at2, at3, at4;
+	int err_read_at1, err_write_at2;
+	int err_read_at3, err_write_at4;
+	pt_element_t pmd = ac_test_alloc_pt(pool);
+	unsigned long ptr1 = 0x123480000000;
+	unsigned long ptr2 = ptr1 + 2 * 1024 * 1024;
+	unsigned long ptr3 = ptr1 + 1 * 1024 * 1024 * 1024;
+	unsigned long ptr4 = ptr3 + 2 * 1024 * 1024;
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
+	at3.flags = AC_PUDE_NO_WRITABLE_MASK | at1.flags;
+	__ac_setup_specific_pages(&at3, pool, true, pmd, 0);
+
+	ac_test_init(&at4, (void *)(ptr4));
+	at4.flags = AC_PUDE_NO_WRITABLE_MASK | at2.flags;
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
@@ -948,7 +1034,8 @@ const ac_test_fn ac_test_cases[] =
 	corrupt_hugepage_triger,
 	check_pfec_on_prefetch_pte,
 	check_large_pte_dirty_for_nowp,
-	check_smep_andnot_wp
+	check_smep_andnot_wp,
+	check_combined_protection
 };
 
 static int ac_test_run(void)
-- 
2.19.1.6.gb485710b

