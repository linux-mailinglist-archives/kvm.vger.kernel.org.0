Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AE145D2B5
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353205AbhKYCBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345688AbhKYB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:07 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E629C06137D
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:22 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gf12-20020a17090ac7cc00b001a968c11642so2316649pjb.4
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uZdcaS2Pag8/TUfVtIUM1OBQs0kETKj5FNGBK/gWi98=;
        b=sZ8dWXzMKLQhRDDuq/vtQLcIeJknWpmcDh4SwuH7YVBZEoiIP433t1isluDytukXJ7
         ng9MYhcYA0+Qcwdavbt739yjI7Ffii/Xtx6f00Xb3S1p3Lh8z479Xg77IDIEvP0GaEgj
         HbQ96eUq7fXsEGlgPiGQ/Bs8AoYyzcmvqyY8BBZeqzpW06BKgCKaJuzzNWv6TwZGF3Mt
         KbwKvZBBqzvVATvwEI73YZvr1SoM7H1sAshk/gosuqkvVuqAw9rxgW7ekQax+algbGhf
         zV6qucfgTMO0o0WhD1saKm8axf+6qhT0n9P7CA8jPWaaEfGhgrQCaYXNt2Nk5rPLgbVc
         k76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uZdcaS2Pag8/TUfVtIUM1OBQs0kETKj5FNGBK/gWi98=;
        b=iBiknqBlHfZgfzC8sToTQTe8ATj2ej6sAex7esBv33CL7TMxntpR2EUv+f7qYPR1n4
         QgmX2vzfFheLkLZ5S+KjvZfOc/1hk9qXbFV3il61wwgPFIkLCoe68rXX6DhdT1ia3pdH
         p38MLjbZvsd5xnbzg3vhD9vlURBCVc+XdBwIk2AAGU0P2oNpe2jYRrCnBgYRNCKZYNm7
         vP7hR4eXBqZJBJ0bIfIGFRkncsoT8CnPD42/CkW8dV+hdUf6r0jZxPhg4Ii29XdXVU1E
         eXJrnoypD4L9DuhuykLlMW/AIgER6twv3bMfMJu4AG3eOo/78M6MMyuNxyPF9563IoQm
         2fIQ==
X-Gm-Message-State: AOAM530Smwqnn0M9Pv4tn28TnLGrDPhUStbyjfXQBPTOH9BirRwVznWU
        dCBzggBf696lHyVwp2F5KmpVzZSrho4=
X-Google-Smtp-Source: ABdhPJxWqNzktaArmT8ZnAwsObVrvHaPcGRjS8v6UbjueEQoE/oIGK7j/8UNdXvMJNhv9jOLBJLQtW0QYp4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c407:b0:142:28fe:668e with SMTP id
 k7-20020a170902c40700b0014228fe668emr24737040plk.31.1637803761858; Wed, 24
 Nov 2021 17:29:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:31 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-14-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 13/39] x86/access: Pre-allocate all page tables
 at (sub)test init
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pre-allocate the page tables for each test instead of allocating page
tables on every. single. iteration.  In addition to being abysmally slow,
constantly allocating new page tables obliterates any hope of providing
meaningful test coverage for shadow paging, as using a new upper level
PTE for every iteration causes KVM to sync children, which prevents
exposing TLB flushing bugs in KVM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 169 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 101 insertions(+), 68 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 6c1e20e..abc6590 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -176,6 +176,9 @@ typedef struct {
 	int expected_fault;
 	unsigned expected_error;
 	int pt_levels;
+
+	/* 5-level paging, 1-based to avoid math. */
+	pt_element_t page_tables[6];
 } ac_test_t;
 
 typedef struct {
@@ -323,25 +326,25 @@ static pt_element_t ac_test_alloc_pt(ac_pt_env_t *pt_env)
 {
 	pt_element_t pt;
 
+	/*
+	 * Each test needs at most pt_levels-1 structures per virtual address,
+	 * and no existing scenario uses more than four addresses.
+	 */
+	assert(pt_env->pt_pool_current < (4 * (pt_env->pt_levels - 1)));
+
 	pt = pt_env->pt_pool_pa + (pt_env->pt_pool_current * PAGE_SIZE);
 	pt_env->pt_pool_current++;
 	memset(va(pt), 0, PAGE_SIZE);
 	return pt;
 }
 
-static _Bool ac_test_enough_room(ac_pt_env_t *pt_env)
+static void __ac_test_init(ac_test_t *at, unsigned long virt,
+			   ac_pt_env_t *pt_env, ac_test_t *buddy)
 {
-	/* '120' is completely arbitrary. */
-	return (pt_env->pt_pool_current + 5) < 120;
-}
+	unsigned long buddy_virt = buddy ? (unsigned long)buddy->virt : 0;
+	pt_element_t *root_pt = va(shadow_cr3 & PT_BASE_ADDR_MASK);
+	int i;
 
-static void ac_test_reset_pt_pool(ac_pt_env_t *pt_env)
-{
-	pt_env->pt_pool_current = 0;
-}
-
-static void ac_test_init(ac_test_t *at, unsigned long virt, ac_pt_env_t *pt_env)
-{
 	/*
 	 * The KUT infrastructure, e.g. this function, must use a different
 	 * top-level SPTE than the test, otherwise modifying SPTEs can affect
@@ -349,7 +352,7 @@ static void ac_test_init(ac_test_t *at, unsigned long virt, ac_pt_env_t *pt_env)
 	 * USER when CR4.SMEP=1.
 	 */
 	assert(PT_INDEX(virt, pt_env->pt_levels) !=
-	       PT_INDEX((unsigned long)ac_test_init, pt_env->pt_levels));
+	       PT_INDEX((unsigned long)__ac_test_init, pt_env->pt_levels));
 
 	set_efer_nx(1);
 	set_cr0_wp(1);
@@ -357,6 +360,33 @@ static void ac_test_init(ac_test_t *at, unsigned long virt, ac_pt_env_t *pt_env)
 	at->virt = (void *)virt;
 	at->phys = AT_CODE_DATA_PHYS;
 	at->pt_levels = pt_env->pt_levels;
+
+	at->page_tables[0] = -1ull;
+	at->page_tables[1] = -1ull;
+
+	/*
+	 * Zap the existing top-level PTE as it may be reused from a previous
+	 * sub-test.  This allows runtime PTE modification to assert that two
+	 * overlapping walks don't try to install different paging structures.
+	 */
+	root_pt[PT_INDEX(virt, pt_env->pt_levels)] = 0;
+
+	for (i = at->pt_levels; i > 1; i--) {
+		/*
+		 * Buddies can reuse any part of the walk that share the same
+		 * index.  This is weird, but intentional, as several tests
+		 * want different walks to merge at lower levels.
+		 */
+		if (buddy && PT_INDEX(virt, i) == PT_INDEX(buddy_virt, i))
+			at->page_tables[i] = buddy->page_tables[i];
+		else
+			at->page_tables[i] = ac_test_alloc_pt(pt_env);
+	}
+}
+
+static void ac_test_init(ac_test_t *at, unsigned long virt, ac_pt_env_t *pt_env)
+{
+	__ac_test_init(at, virt, pt_env, NULL);
 }
 
 static int ac_test_bump_one(ac_test_t *at)
@@ -372,6 +402,9 @@ static _Bool ac_test_legal(ac_test_t *at)
 	int flags = at->flags;
 	unsigned reserved;
 
+	if (F(AC_CPU_CR4_SMEP))
+		return false;
+
 	if (F(AC_ACCESS_FETCH) && F(AC_ACCESS_WRITE))
 		return false;
 
@@ -562,59 +595,60 @@ static void ac_set_expected_status(ac_test_t *at)
 	ac_emulate_access(at, at->flags);
 }
 
-static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool reuse,
-				      u64 pd_page, u64 pt_page)
+static pt_element_t ac_get_pt(ac_test_t *at, int i, pt_element_t *ptep)
+{
+	pt_element_t pte;
+
+	pte = *ptep;
+	if (pte && !(pte & PT_PAGE_SIZE_MASK) &&
+	    (pte & PT_BASE_ADDR_MASK) != at->page_tables[i]) {
+		printf("\nPT collision.  VA = 0x%lx, level = %d, index = %ld, found PT = 0x%lx, want PT = 0x%lx\n",
+			(unsigned long)at->virt, i,
+			PT_INDEX((unsigned long)at->virt, i),
+			pte, at->page_tables[i]);
+		abort();
+	}
+
+	pte = at->page_tables[i];
+	return pte;
+}
+
+static void __ac_setup_specific_pages(ac_test_t *at, u64 pd_page, u64 pt_page)
 {
 	unsigned long parent_pte = shadow_cr3;
 	int flags = at->flags;
-	bool skip = true;
-
-	if (!ac_test_enough_room(pt_env))
-		ac_test_reset_pt_pool(pt_env);
+	int i;
 
 	at->ptep = 0;
-	for (int i = at->pt_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
+	for (i = at->pt_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
 		pt_element_t *parent_pt = va(parent_pte & PT_BASE_ADDR_MASK);
 		unsigned index = PT_INDEX((unsigned long)at->virt, i);
 		pt_element_t *ptep = &parent_pt[index];
 		pt_element_t pte;
 
-		/*
-		 * Reuse existing page tables along the highest index, some
-		 * tests rely on sharing upper level paging structures between
-		 * two separate sub-tests.
-		 */
-		if (skip && i >= 2 && index == 511 && (*ptep & PT_PRESENT_MASK))
-			goto next;
-
-		skip = false;
-		if (reuse && *ptep) {
-			switch (i) {
-			case 2:
-				at->pdep = ptep;
-				break;
-			case 1:
-				at->ptep = ptep;
-				break;
-			}
-			goto next;
-		}
-
 		switch (i) {
 		case 5:
 		case 4:
-			pte = ac_test_alloc_pt(pt_env);
+			pte = ac_get_pt(at, i, ptep);
 			pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 			break;
 		case 3:
-			pte = pd_page ? pd_page : ac_test_alloc_pt(pt_env);
+			if (pd_page)
+				pte = pd_page;
+			else
+				pte = ac_get_pt(at, i, ptep);
+
 			pte |= PT_PRESENT_MASK | PT_USER_MASK;
 			if (!F(AC_PDPTE_NO_WRITABLE))
 				pte |= PT_WRITABLE_MASK;
 			break;
 		case 2:
 			if (!F(AC_PDE_PSE)) {
-				pte = pt_page ? pt_page : ac_test_alloc_pt(pt_env);
+				if (pt_page)
+					pte = pt_page;
+				else
+					pte = ac_get_pt(at, i, ptep);
+
 				/* The protection key is ignored on non-leaf entries.  */
 				if (F(AC_PKU_PKEY))
 					pte |= 2ull << 59;
@@ -671,21 +705,20 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool r
 		}
 
 		*ptep = pte;
- next:
-		parent_pte = *ptep;
+
+		parent_pte = pte;
 	}
 	ac_set_expected_status(at);
 }
 
-static void ac_test_setup_pte(ac_test_t *at, ac_pt_env_t *pt_env)
+static void ac_test_setup_pte(ac_test_t *at)
 {
-	__ac_setup_specific_pages(at, pt_env, false, 0, 0);
+	__ac_setup_specific_pages(at, 0, 0);
 }
 
-static void ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env,
-				    u64 pd_page, u64 pt_page)
+static void ac_setup_specific_pages(ac_test_t *at, u64 pd_page, u64 pt_page)
 {
-	return __ac_setup_specific_pages(at, pt_env, false, pd_page, pt_page);
+	return __ac_setup_specific_pages(at, pd_page, pt_page);
 }
 
 static void __dump_pte(pt_element_t *ptep, int level, unsigned long virt)
@@ -874,15 +907,15 @@ static int corrupt_hugepage_triger(ac_pt_env_t *pt_env)
 	ac_test_t at1, at2;
 
 	ac_test_init(&at1, 0xffff923400000000ul, pt_env);
-	ac_test_init(&at2, 0xffffe66600000000ul, pt_env);
+	__ac_test_init(&at2, 0xffffe66600000000ul, pt_env, &at1);
 
 	at2.flags = AC_CPU_CR0_WP_MASK | AC_PDE_PSE_MASK | AC_PDE_PRESENT_MASK;
-	ac_test_setup_pte(&at2, pt_env);
+	ac_test_setup_pte(&at2);
 	if (!ac_test_do_access(&at2))
 		goto err;
 
 	at1.flags = at2.flags | AC_PDE_WRITABLE_MASK;
-	ac_test_setup_pte(&at1, pt_env);
+	ac_test_setup_pte(&at1);
 	if (!ac_test_do_access(&at1))
 		goto err;
 
@@ -912,13 +945,13 @@ static int check_pfec_on_prefetch_pte(ac_pt_env_t *pt_env)
 	ac_test_t at1, at2;
 
 	ac_test_init(&at1, 0xffff923406001000ul, pt_env);
-	ac_test_init(&at2, 0xffff923406003000ul, pt_env);
+	__ac_test_init(&at2, 0xffff923406003000ul, pt_env, &at1);
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK;
-	ac_setup_specific_pages(&at1, pt_env, 30 * 1024 * 1024, 30 * 1024 * 1024);
+	ac_setup_specific_pages(&at1, 30 * 1024 * 1024, 30 * 1024 * 1024);
 
 	at2.flags = at1.flags | AC_PTE_NX_MASK;
-	ac_setup_specific_pages(&at2, pt_env, 30 * 1024 * 1024, 30 * 1024 * 1024);
+	ac_setup_specific_pages(&at2, 30 * 1024 * 1024, 30 * 1024 * 1024);
 
 	if (!ac_test_do_access(&at1)) {
 		printf("%s: prepare fail\n", __FUNCTION__);
@@ -957,17 +990,17 @@ static int check_large_pte_dirty_for_nowp(ac_pt_env_t *pt_env)
 	ac_test_t at1, at2;
 
 	ac_test_init(&at1, 0xffff923403000000ul, pt_env);
-	ac_test_init(&at2, 0xffffe66606000000ul, pt_env);
+	__ac_test_init(&at2, 0xffffe66606000000ul, pt_env, &at1);
 
 	at2.flags = AC_PDE_PRESENT_MASK | AC_PDE_PSE_MASK;
-	ac_test_setup_pte(&at2, pt_env);
+	ac_test_setup_pte(&at2);
 	if (!ac_test_do_access(&at2)) {
 		printf("%s: read on the first mapping fail.\n", __FUNCTION__);
 		goto err;
 	}
 
 	at1.flags = at2.flags | AC_ACCESS_WRITE_MASK;
-	ac_test_setup_pte(&at1, pt_env);
+	ac_test_setup_pte(&at1);
 	if (!ac_test_do_access(&at1)) {
 		printf("%s: write on the second mapping fail.\n", __FUNCTION__);
 		goto err;
@@ -1003,7 +1036,7 @@ static int check_smep_andnot_wp(ac_pt_env_t *pt_env)
 		    AC_CPU_CR4_SMEP_MASK |
 		    AC_CPU_CR0_WP_MASK |
 		    AC_ACCESS_WRITE_MASK;
-	ac_test_setup_pte(&at1, pt_env);
+	ac_test_setup_pte(&at1);
 
 	/*
 	 * Here we write the ro user page when
@@ -1062,19 +1095,19 @@ static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
 		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
 		    AC_PTE_WRITABLE_MASK | AC_ACCESS_USER_MASK;
-	__ac_setup_specific_pages(&at1, pt_env, false, pmd, 0);
+	__ac_setup_specific_pages(&at1, pmd, 0);
 
-	ac_test_init(&at2, ptr2, pt_env);
+	__ac_test_init(&at2, ptr2, pt_env, &at1);
 	at2.flags = at1.flags | AC_PDE_WRITABLE_MASK | AC_PTE_DIRTY_MASK | AC_ACCESS_WRITE_MASK;
-	__ac_setup_specific_pages(&at2, pt_env, true, pmd, 0);
+	__ac_setup_specific_pages(&at2, pmd, 0);
 
-	ac_test_init(&at3, ptr3, pt_env);
+	__ac_test_init(&at3, ptr3, pt_env, &at1);
 	at3.flags = AC_PDPTE_NO_WRITABLE_MASK | at1.flags;
-	__ac_setup_specific_pages(&at3, pt_env, true, pmd, 0);
+	__ac_setup_specific_pages(&at3, pmd, 0);
 
-	ac_test_init(&at4, ptr4, pt_env);
+	__ac_test_init(&at4, ptr4, pt_env, &at2);
 	at4.flags = AC_PDPTE_NO_WRITABLE_MASK | at2.flags;
-	__ac_setup_specific_pages(&at4, pt_env, true, pmd, 0);
+	__ac_setup_specific_pages(&at4, pmd, 0);
 
 	err_read_at1 = ac_test_do_access(&at1);
 	if (!err_read_at1) {
@@ -1110,7 +1143,7 @@ static int ac_test_exec(ac_test_t *at, ac_pt_env_t *pt_env)
 	if (verbose) {
 		ac_test_show(at);
 	}
-	ac_test_setup_pte(at, pt_env);
+	ac_test_setup_pte(at);
 	r = ac_test_do_access(at);
 	return r;
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

