Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5389045D2BC
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353482AbhKYCDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352880AbhKYCBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:01 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2FEC0619D8
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:28 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id n6-20020a17090a670600b001a9647fd1aaso3885086pjj.1
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=fgu3iQ889yynQL1YWbIzF8XVtFyrCYcfKDVHygYALko=;
        b=BnASif4CjFTaTOvXA1LrTVNTP1vp2zShF52WPN/d+puic0e4svPS1o/HKPFl/UwETi
         101LM06iNpGOKo3WHsYLut4RM0FAC4elkZlYIyJBrIbCfD2oAU+65KNkwfPMQIs1cFyy
         taTVzch3QkdcNkjxVxr1IEtOffPty4jAnA0l1xzdVW7HTkr3NXyZA27nypr6RZfSBHxa
         yeIIgOi8NCiDrf44F4Hks8EVK37HQl9B7moinrhpXlRreKFtdYq1v2yLqditvrvyQtU1
         x2Vb3J3ggTcWUO2I6Nt63BNxSo8muEVuIJh49i8zgsX65GB14puGyg18nIhL9iHWftVw
         XIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=fgu3iQ889yynQL1YWbIzF8XVtFyrCYcfKDVHygYALko=;
        b=W79G+7mRolTH4WcqFHZNm8ypobPPbkXkHBEKypdaH0ZyGzWwjLzGoKc9gLCdbw18V6
         JX2XDbKr8ZcdP1MWUh5iZYsay2m+8Ns5lp4caVY3hSnGoH0fngxawjbxBCw1x8djrSWI
         kNrxRoJKCEFEhy3w41vXo1YeDu5dn/1oCDkYpQsI4EhI7pJmxXIKJq4x8e8Uj+a6hP2j
         42KRbwBsIUEFlkjPjWuS2i9pUB3IH1YYwQGDGc4WGSQsCspjDLIvmWu+M4thr9omSYk6
         aZALpMTWWVWHDzqGXEjQGq2MKe3jZMjD6iBWbazJYhTC98usuSTIwjmVrcySy2wBvojS
         IaFg==
X-Gm-Message-State: AOAM530NpksQJQORvzpCQX+wZHQ+VSJ3ispfxHW0S2nJBJaflttw6qEx
        QWmVoRD6327oPxGYYc/caymDThOIGsw=
X-Google-Smtp-Source: ABdhPJyY4Z7dL5z4Zo/q6LkApj95vqkX5zIGqggjqNxRPziPsd3h6BnYjXFWpBcuYu0r5EhPOqoBYg9g/SU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1185:: with SMTP id
 gk5mr2132900pjb.113.1637803768415; Wed, 24 Nov 2021 17:29:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:35 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-18-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 17/39] x86/access: Manually override PMD in
 effective permissions sub-test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Manually override the PMD in the effective permissions sub-test when
splicing two walks together, this will eventually allow dropping the
overrides from the main PTE insertion helper.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 24ddeec..3e1a684 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -1084,18 +1084,17 @@ static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 	unsigned long ptr2 = ptr1 + SZ_2M;
 	unsigned long ptr3 = ptr1 + SZ_1G;
 	unsigned long ptr4 = ptr3 + SZ_2M;
-	pt_element_t pmd = ac_test_alloc_pt(pt_env);
 	ac_test_t at1, at2, at3, at4;
 	int err_read_at1, err_write_at2;
 	int err_read_at3, err_write_at4;
 
 	/*
 	 * pgd[]   pud[]        pmd[]            virtual address pointers
-	 *                   /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
-	 *      /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
-	 * pgd-|           (shared pmd[] as above)
-	 *      \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
-	 *                   \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
+	 *                   /->pmd(u--)->pte1(uw-)->page1 <- ptr1 (u--)
+	 *      /->pud1(uw-)--->pmd(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
+	 * pgd-|
+	 *      \->pud2(u--)--->pmd(u--)->pte1(uw-)->page1 <- ptr3 (u--)
+	 *                   \->pmd(uw-)->pte2(uw-)->page2 <- ptr4 (u--)
 	 * pud1 and pud2 point to the same pmd page.
 	 */
 
@@ -1104,19 +1103,23 @@ static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
 		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
 		    AC_PTE_WRITABLE_MASK | AC_ACCESS_USER_MASK;
-	__ac_setup_specific_pages(&at1, pmd, 0);
+	__ac_setup_specific_pages(&at1, 0, 0);
 
 	__ac_test_init(&at2, ptr2, pt_env, &at1);
 	at2.flags = at1.flags | AC_PDE_WRITABLE_MASK | AC_PTE_DIRTY_MASK | AC_ACCESS_WRITE_MASK;
-	__ac_setup_specific_pages(&at2, pmd, 0);
+	__ac_setup_specific_pages(&at2, 0, 0);
 
 	__ac_test_init(&at3, ptr3, pt_env, &at1);
+	/* Override the PMD (1-based index) to point at ptr1's PMD. */
+	at3.page_tables[3] = at1.page_tables[3];
 	at3.flags = AC_PDPTE_NO_WRITABLE_MASK | at1.flags;
-	__ac_setup_specific_pages(&at3, pmd, 0);
+	__ac_setup_specific_pages(&at3, 0, 0);
 
+	/* Alias ptr2, only the PMD will differ; manually override the PMD. */
 	__ac_test_init(&at4, ptr4, pt_env, &at2);
+	at4.page_tables[3] = at1.page_tables[3];
 	at4.flags = AC_PDPTE_NO_WRITABLE_MASK | at2.flags;
-	__ac_setup_specific_pages(&at4, pmd, 0);
+	__ac_setup_specific_pages(&at4, 0, 0);
 
 	err_read_at1 = ac_test_do_access(&at1);
 	if (!err_read_at1) {
-- 
2.34.0.rc2.393.gf8c9666880-goog

