Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392EB45D2BA
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353470AbhKYCDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352916AbhKYCBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:01 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF95C0619DA
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:31 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x1-20020a17090a294100b001a6e7ba6b4eso2303525pjf.9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LOh1uZuqAUyICy/AZH3cBBwlyO37+jg51kVYbkgApRM=;
        b=S5wRiQ85+JEPqXiPLpCsTZWPX34w6N1DR2Y4juwF20MNYARPZrJZHsByZFW/P8qxKN
         JUrNPe8EDZmmkk8OkCIjbwaRZ4SGbHDO4L1bWjiUrpnFZ3mrhEyCom6FYOxJkQA5yclP
         07SFB5GlTKK9UvMQT5XgEAiURxflNutKhOLk0mCgDtoUkXlzHMWS6sDk6uVaHCr3/x6b
         m/va+E+xjXu7tzoFHD5JbxC0I52JnBzr6qivO99dFYeLrJPUnYB9F+lnNFWz0qnThO4E
         icfxG5Qw1UsDr6R4X+1+uXqDYq51l+BYlSs1diko2FH9M8gEeL2hOs2GJu/cp1mjLtDw
         jLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LOh1uZuqAUyICy/AZH3cBBwlyO37+jg51kVYbkgApRM=;
        b=IZkEi4Py+fwzDczLxrKtoXywfXF6gyNWkGrl0x0MTrqQOuDJUlVQ8qkanx6dRueYHG
         EiETTDdKTZ/+zgI7qQmr93chUWKX2sJHNbYS1tVQdna0lCA0N+ewfb3+riPwN30Xsynu
         koESX20u9pauK93sjOwfdjrQAtDuIgJNX/xzKJTSaLMZU2+Zq1zEFAy44XBzrkeqMCNJ
         qs8iZudZ3S6QaIdVI57Gb+M7yMJCX0bf1VN68oJe6CPJhb4dT1pu7jimvcS/OPqM2mbE
         HJcUb5GEsY124eXEIIJ7AByO0Ej4wcvTNyzcZykDmF2gd9pf45WM8IH/Wr95AKcL0vO3
         hAJQ==
X-Gm-Message-State: AOAM532uVCC78ea4zNYitkyd17Y34yftrWz8JLJoS5AzlI6vjuV66i7A
        sDIRvxw4TV334m+6ylOj+j6ztsqBweQ=
X-Google-Smtp-Source: ABdhPJwrbLSmL8z4NUei0UwBzocBBzUS8Zgaw+GBauu9owKgBroGjXokFOi7zkY/f11Vi4M2b/GlbHgdFQg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4212:: with SMTP id
 o18mr2146130pjg.154.1637803771474; Wed, 24 Nov 2021 17:29:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:37 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-20-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 19/39] x86/access: Remove PMD/PT target overrides
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the now-unused overrides from the PTE insertion helper.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 47 +++++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 956a450..b58ea3e 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -621,7 +621,7 @@ static pt_element_t ac_get_pt(ac_test_t *at, int i, pt_element_t *ptep)
 	return pte;
 }
 
-static void __ac_setup_specific_pages(ac_test_t *at, u64 pd_page, u64 pt_page)
+static void ac_test_setup_ptes(ac_test_t *at)
 {
 	unsigned long parent_pte = shadow_cr3;
 	int flags = at->flags;
@@ -641,21 +641,14 @@ static void __ac_setup_specific_pages(ac_test_t *at, u64 pd_page, u64 pt_page)
 			pte |= PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 			break;
 		case 3:
-			if (pd_page)
-				pte = pd_page;
-			else
-				pte = ac_get_pt(at, i, ptep);
-
+			pte = ac_get_pt(at, i, ptep);
 			pte |= PT_PRESENT_MASK | PT_USER_MASK;
 			if (!F(AC_PDPTE_NO_WRITABLE))
 				pte |= PT_WRITABLE_MASK;
 			break;
 		case 2:
 			if (!F(AC_PDE_PSE)) {
-				if (pt_page)
-					pte = pt_page;
-				else
-					pte = ac_get_pt(at, i, ptep);
+				pte = ac_get_pt(at, i, ptep);
 
 				/* The protection key is ignored on non-leaf entries.  */
 				if (F(AC_PKU_PKEY))
@@ -720,16 +713,6 @@ static void __ac_setup_specific_pages(ac_test_t *at, u64 pd_page, u64 pt_page)
 	ac_set_expected_status(at);
 }
 
-static void ac_test_setup_pte(ac_test_t *at)
-{
-	__ac_setup_specific_pages(at, 0, 0);
-}
-
-static void ac_setup_specific_pages(ac_test_t *at, u64 pd_page, u64 pt_page)
-{
-	return __ac_setup_specific_pages(at, pd_page, pt_page);
-}
-
 static void __dump_pte(pt_element_t *ptep, int level, unsigned long virt)
 {
 	printf("------L%d I%lu: %lx\n", level, PT_INDEX(virt, level), *ptep);
@@ -919,12 +902,12 @@ static int corrupt_hugepage_triger(ac_pt_env_t *pt_env)
 	__ac_test_init(&at2, 0xffffe66600000000ul, pt_env, &at1);
 
 	at2.flags = AC_CPU_CR0_WP_MASK | AC_PDE_PSE_MASK | AC_PDE_PRESENT_MASK;
-	ac_test_setup_pte(&at2);
+	ac_test_setup_ptes(&at2);
 	if (!ac_test_do_access(&at2))
 		goto err;
 
 	at1.flags = at2.flags | AC_PDE_WRITABLE_MASK;
-	ac_test_setup_pte(&at1);
+	ac_test_setup_ptes(&at1);
 	if (!ac_test_do_access(&at1))
 		goto err;
 
@@ -957,10 +940,10 @@ static int check_pfec_on_prefetch_pte(ac_pt_env_t *pt_env)
 	__ac_test_init(&at2, 0xffff923406003000ul, pt_env, &at1);
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK;
-	ac_setup_specific_pages(&at1, 0, 0);
+	ac_test_setup_ptes(&at1);
 
 	at2.flags = at1.flags | AC_PTE_NX_MASK;
-	ac_setup_specific_pages(&at2, 0, 0);
+	ac_test_setup_ptes(&at2);
 
 	if (!ac_test_do_access(&at1)) {
 		printf("%s: prepare fail\n", __FUNCTION__);
@@ -1002,14 +985,14 @@ static int check_large_pte_dirty_for_nowp(ac_pt_env_t *pt_env)
 	__ac_test_init(&at2, 0xffffe66606000000ul, pt_env, &at1);
 
 	at2.flags = AC_PDE_PRESENT_MASK | AC_PDE_PSE_MASK;
-	ac_test_setup_pte(&at2);
+	ac_test_setup_ptes(&at2);
 	if (!ac_test_do_access(&at2)) {
 		printf("%s: read on the first mapping fail.\n", __FUNCTION__);
 		goto err;
 	}
 
 	at1.flags = at2.flags | AC_ACCESS_WRITE_MASK;
-	ac_test_setup_pte(&at1);
+	ac_test_setup_ptes(&at1);
 	if (!ac_test_do_access(&at1)) {
 		printf("%s: write on the second mapping fail.\n", __FUNCTION__);
 		goto err;
@@ -1045,7 +1028,7 @@ static int check_smep_andnot_wp(ac_pt_env_t *pt_env)
 		    AC_CPU_CR4_SMEP_MASK |
 		    AC_CPU_CR0_WP_MASK |
 		    AC_ACCESS_WRITE_MASK;
-	ac_test_setup_pte(&at1);
+	ac_test_setup_ptes(&at1);
 
 	/*
 	 * Here we write the ro user page when
@@ -1103,23 +1086,23 @@ static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
 		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
 		    AC_PTE_WRITABLE_MASK | AC_ACCESS_USER_MASK;
-	__ac_setup_specific_pages(&at1, 0, 0);
+	ac_test_setup_ptes(&at1);
 
 	__ac_test_init(&at2, ptr2, pt_env, &at1);
 	at2.flags = at1.flags | AC_PDE_WRITABLE_MASK | AC_PTE_DIRTY_MASK | AC_ACCESS_WRITE_MASK;
-	__ac_setup_specific_pages(&at2, 0, 0);
+	ac_test_setup_ptes(&at2);
 
 	__ac_test_init(&at3, ptr3, pt_env, &at1);
 	/* Override the PMD (1-based index) to point at ptr1's PMD. */
 	at3.page_tables[3] = at1.page_tables[3];
 	at3.flags = AC_PDPTE_NO_WRITABLE_MASK | at1.flags;
-	__ac_setup_specific_pages(&at3, 0, 0);
+	ac_test_setup_ptes(&at3);
 
 	/* Alias ptr2, only the PMD will differ; manually override the PMD. */
 	__ac_test_init(&at4, ptr4, pt_env, &at2);
 	at4.page_tables[3] = at1.page_tables[3];
 	at4.flags = AC_PDPTE_NO_WRITABLE_MASK | at2.flags;
-	__ac_setup_specific_pages(&at4, 0, 0);
+	ac_test_setup_ptes(&at4);
 
 	err_read_at1 = ac_test_do_access(&at1);
 	if (!err_read_at1) {
@@ -1155,7 +1138,7 @@ static int ac_test_exec(ac_test_t *at, ac_pt_env_t *pt_env)
 	if (verbose) {
 		ac_test_show(at);
 	}
-	ac_test_setup_pte(at);
+	ac_test_setup_ptes(at);
 	r = ac_test_do_access(at);
 	return r;
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

