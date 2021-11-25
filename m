Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC32A45D2B4
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353186AbhKYCBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244464AbhKYB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:07 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92035C06137B
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:19 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id u14-20020a05622a198e00b002b2f35a6dcfso4222820qtc.21
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0Y0yVSBpH1+JDMSrlfvRkqB/I2VQt941haedmb2PeKE=;
        b=WuCSjRW34IrPxl/5zHFfr9oWQCQ0FbessdMSD/3Xd3Wniy2ot4HMeo3dvvpbhB7i+d
         n19AB2/5623CiPy+VG48ETZw1D114EiR18ayRCJKqjp7hcSLV8XqV3xuyuDmx2hinF4F
         AT8iTFySQ16W083XVa2Wi93iFtuS9KKPlOMfdkbvfZlPvmma7Rj6GqUvOow6gSR54JH3
         BdoUAjdjX2kdO5bQyhet0f+d3PZiruMpQBdH5t3yeGQM4WzqkacH3G1jx3vY4RY748Vz
         w0S4iqdcp+KJLdO+MFHFYdWjbUL3AgEqMevV3Dgt8KnGDYSH+muR97ggeXF2RRQEYsne
         N9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0Y0yVSBpH1+JDMSrlfvRkqB/I2VQt941haedmb2PeKE=;
        b=Q+WE8mcU79aanxCrRWvNrYihmTn8f3x+0EMQmUxryZAqaUP+WtKdqoWwzMeo8Q6n3I
         xYg7LW9nSNNDnjZDt7G2QLEsLUkZOsNb2M4SqipmNIMPEYyniAFJdP8JU0o+gEsUj+HT
         x3oF67tnD82ZpGD/AMRhLnulHHSEBdo4fdVhWgdlg8ZmxQyTAqkVOO6W8XkUlvVjNJFh
         2CmRIU5IWgMrJeVC9KnunYIRNlSJnDAD+faDP2wmSMgj47cccYMEJzBQ5XC5+fyQ++om
         /lTGOtMBd08qJXX6RYvW9/fxBv6b8LM4z3f2/xMFJ1FV7URfGdjwNfECqGX5b4D30aJT
         /SPw==
X-Gm-Message-State: AOAM533oA0z5lIAm7mDQFiPuiBZrwugjK1QzRLba1kDUsMCJbCpD7PXW
        k9DYVMSUchNPCBwO/siY7TRfPMjTNnc=
X-Google-Smtp-Source: ABdhPJzcma5laeMY73WODY35RVihcKAA8ODFD53HobHQPKQTir60ZyPko7AdmaIwuor4Tvjlsxo/nXv6hCI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:77d4:: with SMTP id s203mr2117115ybc.224.1637803758717;
 Wed, 24 Nov 2021 17:29:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:29 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-12-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 11/39] x86/access: Use upper half of virtual
 address space
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the upper half of the virtual address space so that 5-level paging
doesn't collide with the core infrastucture in the top-level PTE, which
hides bugs, e.g. SMEP + 5-level, and is generally a nightmare to debug.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 50 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 5bd446c..6ccdb76 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -34,7 +34,7 @@ static int invalid_mask;
 #define EFER_NX_MASK            (1ull << 11)
 
 #define PT_INDEX(address, level)       \
-	  ((address) >> (12 + ((level)-1) * 9)) & 511
+	  (((address) >> (12 + ((level)-1) * 9)) & 511)
 
 /*
  * page table access check tests
@@ -340,12 +340,21 @@ static void ac_test_reset_pt_pool(ac_pt_env_t *pt_env)
 	pt_env->pt_pool_current = 0;
 }
 
-static void ac_test_init(ac_test_t *at, void *virt, ac_pt_env_t *pt_env)
+static void ac_test_init(ac_test_t *at, unsigned long virt, ac_pt_env_t *pt_env)
 {
+	/*
+	 * The KUT infrastructure, e.g. this function, must use a different
+	 * top-level SPTE than the test, otherwise modifying SPTEs can affect
+	 * normal behavior, e.g. crash the test due to marking code SPTEs
+	 * USER when CR4.SMEP=1.
+	 */
+	assert(PT_INDEX(virt, pt_env->pt_levels) !=
+	       PT_INDEX((unsigned long)ac_test_init, pt_env->pt_levels));
+
 	set_efer_nx(1);
 	set_cr0_wp(1);
 	at->flags = 0;
-	at->virt = virt;
+	at->virt = (void *)virt;
 	at->phys = AT_CODE_DATA_PHYS;
 	at->pt_levels = pt_env->pt_levels;
 }
@@ -571,12 +580,13 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env, bool r
 		pt_element_t pte;
 
 		/*
-		 * Reuse existing page tables along the path to the test code and data
-		 * (which is in the bottom 2MB).
+		 * Reuse existing page tables along the highest index, some
+		 * tests rely on sharing upper level paging structures between
+		 * two separate sub-tests.
 		 */
-		if (skip && i >= 2 && index == 0) {
+		if (skip && i >= 2 && index == 511 && (*ptep & PT_PRESENT_MASK))
 			goto next;
-		}
+
 		skip = false;
 		if (reuse && *ptep) {
 			switch (i) {
@@ -863,8 +873,8 @@ static int corrupt_hugepage_triger(ac_pt_env_t *pt_env)
 {
 	ac_test_t at1, at2;
 
-	ac_test_init(&at1, (void *)(0x123400000000), pt_env);
-	ac_test_init(&at2, (void *)(0x666600000000), pt_env);
+	ac_test_init(&at1, 0xffff923400000000ul, pt_env);
+	ac_test_init(&at2, 0xffffe66600000000ul, pt_env);
 
 	at2.flags = AC_CPU_CR0_WP_MASK | AC_PDE_PSE_MASK | AC_PDE_PRESENT_MASK;
 	ac_test_setup_pte(&at2, pt_env);
@@ -901,8 +911,8 @@ static int check_pfec_on_prefetch_pte(ac_pt_env_t *pt_env)
 {
 	ac_test_t at1, at2;
 
-	ac_test_init(&at1, (void *)(0x123406001000), pt_env);
-	ac_test_init(&at2, (void *)(0x123406003000), pt_env);
+	ac_test_init(&at1, 0xffff923406001000ul, pt_env);
+	ac_test_init(&at2, 0xffff923406003000ul, pt_env);
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK;
 	ac_setup_specific_pages(&at1, pt_env, 30 * 1024 * 1024, 30 * 1024 * 1024);
@@ -946,8 +956,8 @@ static int check_large_pte_dirty_for_nowp(ac_pt_env_t *pt_env)
 {
 	ac_test_t at1, at2;
 
-	ac_test_init(&at1, (void *)(0x123403000000), pt_env);
-	ac_test_init(&at2, (void *)(0x666606000000), pt_env);
+	ac_test_init(&at1, 0xffff923403000000ul, pt_env);
+	ac_test_init(&at2, 0xffffe66606000000ul, pt_env);
 
 	at2.flags = AC_PDE_PRESENT_MASK | AC_PDE_PSE_MASK;
 	ac_test_setup_pte(&at2, pt_env);
@@ -985,7 +995,7 @@ static int check_smep_andnot_wp(ac_pt_env_t *pt_env)
 		return 1;
 	}
 
-	ac_test_init(&at1, (void *)(0x123406001000), pt_env);
+	ac_test_init(&at1, 0xffff923406001000ul, pt_env);
 
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
 		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
@@ -1028,7 +1038,7 @@ err:
 
 static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 {
-	unsigned long ptr1 = 0x123480000000;
+	unsigned long ptr1 = 0xffff923480000000;
 	unsigned long ptr2 = ptr1 + SZ_2M;
 	unsigned long ptr3 = ptr1 + SZ_1G;
 	unsigned long ptr4 = ptr3 + SZ_2M;
@@ -1047,22 +1057,22 @@ static int check_effective_sp_permissions(ac_pt_env_t *pt_env)
 	 * pud1 and pud2 point to the same pmd page.
 	 */
 
-	ac_test_init(&at1, (void *)(ptr1), pt_env);
+	ac_test_init(&at1, ptr1, pt_env);
 	at1.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
 		    AC_PDE_USER_MASK | AC_PTE_USER_MASK |
 		    AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
 		    AC_PTE_WRITABLE_MASK | AC_ACCESS_USER_MASK;
 	__ac_setup_specific_pages(&at1, pt_env, false, pmd, 0);
 
-	ac_test_init(&at2, (void *)(ptr2), pt_env);
+	ac_test_init(&at2, ptr2, pt_env);
 	at2.flags = at1.flags | AC_PDE_WRITABLE_MASK | AC_PTE_DIRTY_MASK | AC_ACCESS_WRITE_MASK;
 	__ac_setup_specific_pages(&at2, pt_env, true, pmd, 0);
 
-	ac_test_init(&at3, (void *)(ptr3), pt_env);
+	ac_test_init(&at3, ptr3, pt_env);
 	at3.flags = AC_PDPTE_NO_WRITABLE_MASK | at1.flags;
 	__ac_setup_specific_pages(&at3, pt_env, true, pmd, 0);
 
-	ac_test_init(&at4, (void *)(ptr4), pt_env);
+	ac_test_init(&at4, ptr4, pt_env);
 	at4.flags = AC_PDPTE_NO_WRITABLE_MASK | at2.flags;
 	__ac_setup_specific_pages(&at4, pt_env, true, pmd, 0);
 
@@ -1139,7 +1149,7 @@ int ac_test_run(int pt_levels)
 	}
 
 	ac_env_int(&pt_env, pt_levels);
-	ac_test_init(&at, (void *)(0x123400000000), &pt_env);
+	ac_test_init(&at, 0xffff923400000000ul, &pt_env);
 
 	if (this_cpu_has(X86_FEATURE_PKU)) {
 		set_cr4_pke(1);
-- 
2.34.0.rc2.393.gf8c9666880-goog

