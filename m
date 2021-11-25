Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF7545D2AE
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353064AbhKYCBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348997AbhKYB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:07 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA663C061376
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:10 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id u11-20020a17090a4bcb00b001a6e77f7312so2312800pjl.5
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XaCH3th8Pjs/RMlsNqwzubCf+cqGx2jS8r5aIwid9EM=;
        b=Oa7Uc7oIzkzFi+Uz2fxcxK/i3MfgtsTIMFHfApAqnvuo9rVmCsn5VArKyvlXCqRxOe
         Mx5AUdLAtlEj6t9c0UFFoeqgjYtAOgqRlkSwBp7yLYiaAHNr/zjhpzzTqg+Unig72rVl
         0/BiWd5ysMcSn4HhCExY8kF2auJsJhHvXAWTU5wq7NS6ID0SCq3mu28ee3vp32hWdSMN
         yt7ExNPTS9sn/eAAadI4wINquc7CAGYxcbkgsR7HGXXcGoywfsTZayMoxQZEUcd02YQa
         R1rYNZtPBXbgJ4Qh44IcLgW/N21RatlcOPCJVQ5ncKvWZSTlIPSP0+eF27NVc5tyV2k4
         Db5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XaCH3th8Pjs/RMlsNqwzubCf+cqGx2jS8r5aIwid9EM=;
        b=pxVdztVYO9hZA7G4cXQlXt6mPrFJliB9erEf9gLQwnrcEbOaqJAHslitNjgP7Knrjr
         sXv7mOZ3oQ/SQrkWO3HQL+S3kWG0udsS+Qy1tvIF+8c+9yYfHxrNlFyPQlmmhnClo1ro
         tsBl6NdUVIsLrcmBavKr+oupkUagDgRhi3q+uvUFyEVc9mysTuDNL3y8rSi6RtnMlR1Z
         wtnIdSbo7kjl5gJIRkObecaTClNXJpYCK2/IJYLt36LY2gJoo6RQV/hf3vNTuVqYED7B
         L+7qgLeXGTo3nQWmMqHqC8VNE3IQ4h6V9vJWipZ904t2jYAsfq9FMbHB3yfKfjXrhm+4
         bsiA==
X-Gm-Message-State: AOAM5302ZbSNKRFFDyF1XWNIFmyx69WLd/2aNmNgHjcGtL8eg5GW1Yno
        MLy7DdK7quzIMeB3PNTYdWjrzKsgPPE=
X-Google-Smtp-Source: ABdhPJyr5cepBD84+H1G/uiG2ZnyEgAFLtESft5evqYHBOMbac7YfeTpSqFLazrxlBK48dRC/4aIRxFxgc8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:be12:b0:142:431f:3d1c with SMTP id
 r18-20020a170902be1200b00142431f3d1cmr24819606pls.32.1637803750449; Wed, 24
 Nov 2021 17:29:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:24 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-7-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 06/39] x86/access: Stash root page table level
 in test environment
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the root page table level in the test environment, a future commit
will use it to guage whether or not the number of page tables being
allocated is reasonable.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 132 ++++++++++++++++++++++++++-------------------------
 1 file changed, 68 insertions(+), 64 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 47b3d00..ba20359 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -160,8 +160,9 @@ static inline void *va(pt_element_t phys)
 
 typedef struct {
 	pt_element_t pt_pool_pa;
-	unsigned pt_pool_current;
-} ac_pool_t;
+	unsigned int pt_pool_current;
+	int pt_levels;
+} ac_pt_env_t;
 
 typedef struct {
 	unsigned flags;
@@ -174,7 +175,7 @@ typedef struct {
 	pt_element_t ignore_pde;
 	int expected_fault;
 	unsigned expected_error;
-	int page_table_levels;
+	int pt_levels;
 } ac_test_t;
 
 typedef struct {
@@ -269,24 +270,25 @@ static void set_efer_nx(int nx)
 	}
 }
 
-static void ac_env_int(ac_pool_t *pool)
+static void ac_env_int(ac_pt_env_t *pt_env, int page_table_levels)
 {
 	extern char page_fault, kernel_entry;
 	set_idt_entry(14, &page_fault, 0);
 	set_idt_entry(0x20, &kernel_entry, 3);
 
-	pool->pt_pool_pa = AT_PAGING_STRUCTURES_PHYS;
-	pool->pt_pool_current = 0;
+	pt_env->pt_pool_pa = AT_PAGING_STRUCTURES_PHYS;
+	pt_env->pt_pool_current = 0;
+	pt_env->pt_levels = page_table_levels;
 }
 
-static void ac_test_init(ac_test_t *at, void *virt, int page_table_levels)
+static void ac_test_init(ac_test_t *at, void *virt, ac_pt_env_t *pt_env)
 {
 	set_efer_nx(1);
 	set_cr0_wp(1);
 	at->flags = 0;
 	at->virt = virt;
 	at->phys = AT_CODE_DATA_PHYS;
-	at->page_table_levels = page_table_levels;
+	at->pt_levels = pt_env->pt_levels;
 }
 
 static int ac_test_bump_one(ac_test_t *at)
@@ -358,25 +360,25 @@ static int ac_test_bump(ac_test_t *at)
 	return ret;
 }
 
-static pt_element_t ac_test_alloc_pt(ac_pool_t *pool)
+static pt_element_t ac_test_alloc_pt(ac_pt_env_t *pt_env)
 {
 	pt_element_t pt;
 
-	pt = pool->pt_pool_pa + (pool->pt_pool_current * PAGE_SIZE);
-	pool->pt_pool_current++;
+	pt = pt_env->pt_pool_pa + (pt_env->pt_pool_current * PAGE_SIZE);
+	pt_env->pt_pool_current++;
 	memset(va(pt), 0, PAGE_SIZE);
 	return pt;
 }
 
-static _Bool ac_test_enough_room(ac_pool_t *pool)
+static _Bool ac_test_enough_room(ac_pt_env_t *pt_env)
 {
 	/* '120' is completely arbitrary. */
-	return (pool->pt_pool_current + 5) < 120;
+	return (pt_env->pt_pool_current + 5) < 120;
 }
 
-static void ac_test_reset_pt_pool(ac_pool_t *pool)
+static void ac_test_reset_pt_pool(ac_pt_env_t *pt_env)
 {
-	pool->pt_pool_current = 0;
+	pt_env->pt_pool_current = 0;
 }
 
 static pt_element_t ac_test_permissions(ac_test_t *at, unsigned flags,
@@ -513,18 +515,18 @@ static void ac_set_expected_status(ac_test_t *at)
 	ac_emulate_access(at, at->flags);
 }
 
-static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse,
+static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool reuse,
 				      u64 pd_page, u64 pt_page)
 {
 	unsigned long root = shadow_cr3;
 	int flags = at->flags;
 	bool skip = true;
 
-	if (!ac_test_enough_room(pool))
-		ac_test_reset_pt_pool(pool);
+	if (!ac_test_enough_room(pt_env))
+		ac_test_reset_pt_pool(pt_env);
 
 	at->ptep = 0;
-	for (int i = at->page_table_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
+	for (int i = at->pt_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
 		pt_element_t *vroot = va(root & PT_BASE_ADDR_MASK);
 		unsigned index = PT_INDEX((unsigned long)at->virt, i);
 		pt_element_t pte = 0;
@@ -552,18 +554,18 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse
 		switch (i) {
 		case 5:
 		case 4:
-			pte = ac_test_alloc_pt(pool);
+			pte = ac_test_alloc_pt(pt_env);
 			pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 			break;
 		case 3:
-			pte = pd_page ? pd_page : ac_test_alloc_pt(pool);
+			pte = pd_page ? pd_page : ac_test_alloc_pt(pt_env);
 			pte |= PT_PRESENT_MASK | PT_USER_MASK;
 			if (!F(AC_PDPTE_NO_WRITABLE))
 				pte |= PT_WRITABLE_MASK;
 			break;
 		case 2:
 			if (!F(AC_PDE_PSE)) {
-				pte = pt_page ? pt_page : ac_test_alloc_pt(pool);
+				pte = pt_page ? pt_page : ac_test_alloc_pt(pt_env);
 				/* The protection key is ignored on non-leaf entries.  */
 				if (F(AC_PKU_PKEY))
 					pte |= 2ull << 59;
@@ -623,15 +625,15 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool, bool reuse
 	ac_set_expected_status(at);
 }
 
-static void ac_test_setup_pte(ac_test_t *at, ac_pool_t *pool)
+static void ac_test_setup_pte(ac_test_t *at, ac_pt_env_t *pt_env)
 {
-	__ac_setup_specific_pages(at, pool, false, 0, 0);
+	__ac_setup_specific_pages(at, pt_env, false, 0, 0);
 }
 
-static void ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
+static void ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env,
 				    u64 pd_page, u64 pt_page)
 {
-	return __ac_setup_specific_pages(at, pool, false, pd_page, pt_page);
+	return __ac_setup_specific_pages(at, pt_env, false, pd_page, pt_page);
 }
 
 static void dump_mapping(ac_test_t *at)
@@ -641,7 +643,7 @@ static void dump_mapping(ac_test_t *at)
 	int i;
 
 	printf("Dump mapping: address: %p\n", at->virt);
-	for (i = at->page_table_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
+	for (i = at->pt_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
 		pt_element_t *vroot = va(root & PT_BASE_ADDR_MASK);
 		unsigned index = PT_INDEX((unsigned long)at->virt, i);
 		pt_element_t pte = vroot[index];
@@ -818,20 +820,20 @@ static void ac_test_show(ac_test_t *at)
  * This test case is used to triger the bug which is fixed by
  * commit e09e90a5 in the kvm tree
  */
-static int corrupt_hugepage_triger(ac_pool_t *pool, int page_table_levels)
+static int corrupt_hugepage_triger(ac_pt_env_t *pt_env)
 {
 	ac_test_t at1, at2;
 
-	ac_test_init(&at1, (void *)(0x123400000000), page_table_levels);
-	ac_test_init(&at2, (void *)(0x666600000000), page_table_levels);
+	ac_test_init(&at1, (void *)(0x123400000000), pt_env);
+	ac_test_init(&at2, (void *)(0x666600000000), pt_env);
 
 	at2.flags = AC_CPU_CR0_WP_MASK | AC_PDE_PSE_MASK | AC_PDE_PRESENT_MASK;
-	ac_test_setup_pte(&at2, pool);
+	ac_test_setup_pte(&at2, pt_env);
 	if (!ac_test_do_access(&at2))
 		goto err;
 
 	at1.flags = at2.flags | AC_PDE_WRITABLE_MASK;
-	ac_test_setup_pte(&at1, pool);
+	ac_test_setup_pte(&at1, pt_env);
 	if (!ac_test_do_access(&at1))
 		goto err;
 
@@ -856,18 +858,18 @@ err:
  * This test case is used to triger the bug which is fixed by
  * commit 3ddf6c06e13e in the kvm tree
  */
-static int check_pfec_on_prefetch_pte(ac_pool_t *pool, int page_table_levels)
+static int check_pfec_on_prefetch_pte(ac_pt_env_t *pt_env)
 {
 	ac_test_t at1, at2;
 
-	ac_test_init(&at1, (void *)(0x123406001000), page_table_levels);
-	ac_test_init(&at2, (void *)(0x123406003000), page_table_levels);
+	ac_test_init(&at1, (void *)(0x123406001000), pt_env);
+	ac_test_init(&at2, (void *)(0x123406003000), pt_env);
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK;
-	ac_setup_specific_pages(&at1, pool, 30 * 1024 * 1024, 30 * 1024 * 1024);
+	ac_setup_specific_pages(&at1, pt_env, 30 * 1024 * 1024, 30 * 1024 * 1024);
 
 	at2.flags = at1.flags | AC_PTE_NX_MASK;
-	ac_setup_specific_pages(&at2, pool, 30 * 1024 * 1024, 30 * 1024 * 1024);
+	ac_setup_specific_pages(&at2, pt_env, 30 * 1024 * 1024, 30 * 1024 * 1024);
 
 	if (!ac_test_do_access(&at1)) {
 		printf("%s: prepare fail\n", __FUNCTION__);
@@ -901,22 +903,22 @@ err:
  *
  * Note: to trigger this bug, hugepage should be disabled on host.
  */
-static int check_large_pte_dirty_for_nowp(ac_pool_t *pool, int page_table_levels)
+static int check_large_pte_dirty_for_nowp(ac_pt_env_t *pt_env)
 {
 	ac_test_t at1, at2;
 
-	ac_test_init(&at1, (void *)(0x123403000000), page_table_levels);
-	ac_test_init(&at2, (void *)(0x666606000000), page_table_levels);
+	ac_test_init(&at1, (void *)(0x123403000000), pt_env);
+	ac_test_init(&at2, (void *)(0x666606000000), pt_env);
 
 	at2.flags = AC_PDE_PRESENT_MASK | AC_PDE_PSE_MASK;
-	ac_test_setup_pte(&at2, pool);
+	ac_test_setup_pte(&at2, pt_env);
 	if (!ac_test_do_access(&at2)) {
 		printf("%s: read on the first mapping fail.\n", __FUNCTION__);
 		goto err;
 	}
 
 	at1.flags = at2.flags | AC_ACCESS_WRITE_MASK;
-	ac_test_setup_pte(&at1, pool);
+	ac_test_setup_pte(&at1, pt_env);
 	if (!ac_test_do_access(&at1)) {
 		printf("%s: write on the second mapping fail.\n", __FUNCTION__);
 		goto err;
@@ -935,7 +937,7 @@ err:
 	return 0;
 }
 
-static int check_smep_andnot_wp(ac_pool_t *pool, int page_table_levels)
+static int check_smep_andnot_wp(ac_pt_env_t *pt_env)
 {
 	ac_test_t at1;
 	int err_prepare_andnot_wp, err_smep_andnot_wp;
@@ -944,7 +946,7 @@ static int check_smep_andnot_wp(ac_pool_t *pool, int page_table_levels)
 		return 1;
 	}
 
-	ac_test_init(&at1, (void *)(0x123406001000), page_table_levels);
+	ac_test_init(&at1, (void *)(0x123406001000), pt_env);
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
 		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
@@ -952,7 +954,7 @@ static int check_smep_andnot_wp(ac_pool_t *pool, int page_table_levels)
 		    AC_CPU_CR4_SMEP_MASK |
 		    AC_CPU_CR0_WP_MASK |
 		    AC_ACCESS_WRITE_MASK;
-	ac_test_setup_pte(&at1, pool);
+	ac_test_setup_pte(&at1, pt_env);
 
 	/*
 	 * Here we write the ro user page when
@@ -985,13 +987,13 @@ err:
 	return 0;
 }
 
-static int check_effective_sp_permissions(ac_pool_t *pool, int page_table_levels)
+static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 {
 	unsigned long ptr1 = 0x123480000000;
 	unsigned long ptr2 = ptr1 + SZ_2M;
 	unsigned long ptr3 = ptr1 + SZ_1G;
 	unsigned long ptr4 = ptr3 + SZ_2M;
-	pt_element_t pmd = ac_test_alloc_pt(pool);
+	pt_element_t pmd = ac_test_alloc_pt(pt_env);
 	ac_test_t at1, at2, at3, at4;
 	int err_read_at1, err_write_at2;
 	int err_read_at3, err_write_at4;
@@ -1006,24 +1008,24 @@ static int check_effective_sp_permissions(ac_pool_t *pool, int page_table_levels
 	 * pud1 and pud2 point to the same pmd page.
 	 */
 
-	ac_test_init(&at1, (void *)(ptr1), page_table_levels);
+	ac_test_init(&at1, (void *)(ptr1), pt_env);
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
 		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
 		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
 		    AC_PTE_WRITABLE_MASK | AC_ACCESS_USER_MASK;
-	__ac_setup_specific_pages(&at1, pool, false, pmd, 0);
+	__ac_setup_specific_pages(&at1, pt_env, false, pmd, 0);
 
-	ac_test_init(&at2, (void *)(ptr2), page_table_levels);
+	ac_test_init(&at2, (void *)(ptr2), pt_env);
 	at2.flags = at1.flags | AC_PDE_WRITABLE_MASK | AC_PTE_DIRTY_MASK | AC_ACCESS_WRITE_MASK;
-	__ac_setup_specific_pages(&at2, pool, true, pmd, 0);
+	__ac_setup_specific_pages(&at2, pt_env, true, pmd, 0);
 
-	ac_test_init(&at3, (void *)(ptr3), page_table_levels);
+	ac_test_init(&at3, (void *)(ptr3), pt_env);
 	at3.flags = AC_PDPTE_NO_WRITABLE_MASK | at1.flags;
-	__ac_setup_specific_pages(&at3, pool, true, pmd, 0);
+	__ac_setup_specific_pages(&at3, pt_env, true, pmd, 0);
 
-	ac_test_init(&at4, (void *)(ptr4), page_table_levels);
+	ac_test_init(&at4, (void *)(ptr4), pt_env);
 	at4.flags = AC_PDPTE_NO_WRITABLE_MASK | at2.flags;
-	__ac_setup_specific_pages(&at4, pool, true, pmd, 0);
+	__ac_setup_specific_pages(&at4, pt_env, true, pmd, 0);
 
 	err_read_at1 = ac_test_do_access(&at1);
 	if (!err_read_at1) {
@@ -1052,19 +1054,19 @@ static int check_effective_sp_permissions(ac_pool_t *pool, int page_table_levels
 	return 1;
 }
 
-static int ac_test_exec(ac_test_t *at, ac_pool_t *pool)
+static int ac_test_exec(ac_test_t *at, ac_pt_env_t *pt_env)
 {
 	int r;
 
 	if (verbose) {
 		ac_test_show(at);
 	}
-	ac_test_setup_pte(at, pool);
+	ac_test_setup_pte(at, pt_env);
 	r = ac_test_do_access(at);
 	return r;
 }
 
-typedef int (*ac_test_fn)(ac_pool_t *pool, int page_table_levels);
+typedef int (*ac_test_fn)(ac_pt_env_t *pt_env);
 const ac_test_fn ac_test_cases[] =
 {
 	corrupt_hugepage_triger,
@@ -1074,10 +1076,10 @@ const ac_test_fn ac_test_cases[] =
 	check_effective_sp_permissions,
 };
 
-int ac_test_run(int page_table_levels)
+int ac_test_run(int pt_levels)
 {
 	ac_test_t at;
-	ac_pool_t pool;
+	ac_pt_env_t pt_env;
 	int i, tests, successes;
 
 	printf("run\n");
@@ -1140,16 +1142,18 @@ int ac_test_run(int page_table_levels)
 			successes++;
 	}
 
-	ac_env_int(&pool);
-	ac_test_init(&at, (void *)(0x123400000000), page_table_levels);
+	ac_env_int(&pt_env, pt_levels);
+	ac_test_init(&at, (void *)(0x123400000000), &pt_env);
 	do {
 		++tests;
-		successes += ac_test_exec(&at, &pool);
+		successes += ac_test_exec(&at, &pt_env);
 	} while (ac_test_bump(&at));
 
 	for (i = 0; i < ARRAY_SIZE(ac_test_cases); i++) {
+		ac_env_int(&pt_env, pt_levels);
+
 		++tests;
-		successes += ac_test_cases[i](&pool, page_table_levels);
+		successes += ac_test_cases[i](&pt_env);
 	}
 
 	printf("\n%d tests, %d failures\n", tests, tests - successes);
-- 
2.34.0.rc2.393.gf8c9666880-goog

