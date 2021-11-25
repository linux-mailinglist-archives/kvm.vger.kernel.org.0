Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624A445D2B2
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353159AbhKYCBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350473AbhKYB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:07 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ABAC06137A
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:17 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id e7-20020aa798c7000000b004a254db7946so2525584pfm.17
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jFjHucARc51O0IW4svKGmCBxQCGPfCPgql7+nkXL06s=;
        b=PfJzok6nSrhoE/Cbn2eEza9aUx791tBNatyaNXHWIsNxT/DlXPz/NBp1BXXqlanWNU
         eKgXKnaWccchsQWEpJIk1wA1maEkszW00jJjQ7Tbslig+rymK4gupIN8SsMGJGKHo4dZ
         GcfAuJ33olAsCoMVigf6uE2Bgw6MnAmoi80rh5zevarhwXED2vrh/SywHwMwYbmq0S+T
         doF40ym3RjUp5HMiIJ/PteMsK50WK0wfnukdZAC7BY0vG4/MhJPFyL5M61g5Sy7WM6NQ
         WlslBKV33qBberGumJ962v9BAe3tb6cvTrq/rDiIW/MsdS6ogrHSv5W/tuOm9WzQ6fID
         FZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jFjHucARc51O0IW4svKGmCBxQCGPfCPgql7+nkXL06s=;
        b=JGxgu7fik0EcJ1NQpVF63XcKmSs5HkcTYI45ySup1iLeV2V6HUmjfVjyHJ9CIj/Hjx
         QRW4LjPzRFTJCgUtUaRjiVUW7ro+jpZPTUR0xv7HJq215MsuudmjtsjM17kqHWKPXhfZ
         Iz5b/bMa39x3P8/R8inyvUBdPK2h/WrAJpScKEfNnYkypQb9zLR+vuZFoHwQwpQC5aal
         ZDygCgz+7jfCUDKibo5rzP2D9G7jh4l6ObGrWZMla60lMzDG6op9rf6kLoG5To/IWjga
         jfoGhnH1JUwtuk/XRMCl7G9FpVQzvVVcUzAMGLLjWg130j2y60BiFtjDveDNn7czSjW9
         vrKg==
X-Gm-Message-State: AOAM533C0nb1XxyGg2T4irePsv5g7l5J7VIsPllVcDkVWReS7j09yztc
        /B2B6MqUde4cr0fdvtA0I3/zIuhxx90=
X-Google-Smtp-Source: ABdhPJz+luibmDbd5nNS5guJWM6HBgZ6HlORf5XlpnBpYJLV/0T/FJVnne8xhSOyPAdM3Isz6emX+aaxNDc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c403:: with SMTP id
 i3mr2153215pjt.203.1637803756864; Wed, 24 Nov 2021 17:29:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:28 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-11-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 10/39] x86/access: Make SMEP place nice with
 5-level paging
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the walker to clear the USER bit on the test's text region when
enabling SMEP.  The KUT library assumes 4-level paging (see PAGE_LEVEL),
and completely botches 5-level paging.  Through sheer dumb luck, the test
works with 5-level paging, likely because of an unintentional collision
with the test's own PTEs.

Punt on the library for the time being as the access test is obviously
more than capable of walking page tables, and fixing the library properly
will involve poking many more tests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 86 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 61 insertions(+), 25 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 06a2420..5bd446c 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -191,6 +191,43 @@ static unsigned long shadow_cr3;
 static unsigned long shadow_cr4;
 static unsigned long long shadow_efer;
 
+typedef void (*walk_fn)(pt_element_t *ptep, int level, unsigned long virt);
+
+/* Returns the size of the range covered by the last processed entry. */
+static unsigned long walk_va(ac_test_t *at, int min_level, unsigned long virt,
+			     walk_fn callback, bool leaf_only)
+{
+	unsigned long parent_pte = shadow_cr3;
+	int i;
+
+	for (i = at->pt_levels; i >= min_level; --i) {
+		pt_element_t *parent_pt = va(parent_pte & PT_BASE_ADDR_MASK);
+		unsigned int index = PT_INDEX(virt, i);
+		pt_element_t *ptep = &parent_pt[index];
+
+		assert(!leaf_only || (*ptep & PT_PRESENT_MASK));
+
+		if (!leaf_only || i == 1 || (*ptep & PT_PAGE_SIZE_MASK))
+			callback(ptep, i, virt);
+
+		if (i == 1 || *ptep & PT_PAGE_SIZE_MASK)
+			break;
+
+		parent_pte = *ptep;
+	}
+
+	return 1ul << PGDIR_BITS(i);
+}
+
+static void walk_ptes(ac_test_t *at, unsigned long virt, unsigned long end,
+		      walk_fn callback)
+{
+	unsigned long page_size;
+
+	for ( ; virt < end; virt = ALIGN_DOWN(virt + page_size, page_size))
+		page_size = walk_va(at, 1, virt, callback, true);
+}
+
 static void set_cr0_wp(int wp)
 {
 	unsigned long cr0 = shadow_cr0;
@@ -204,23 +241,24 @@ static void set_cr0_wp(int wp)
 	}
 }
 
-static void clear_user_mask(struct pte_search search, void *va)
+static void clear_user_mask(pt_element_t *ptep, int level, unsigned long virt)
 {
-	*search.pte &= ~PT_USER_MASK;
+	*ptep &= ~PT_USER_MASK;
 }
 
-static void set_user_mask(struct pte_search search, void *va)
+static void set_user_mask(pt_element_t *ptep, int level, unsigned long virt)
 {
-	*search.pte |= PT_USER_MASK;
+	*ptep |= PT_USER_MASK;
 
 	/* Flush to avoid spurious #PF */
-	invlpg(va);
+	invlpg((void*)virt);
 }
 
-static unsigned set_cr4_smep(int smep)
+static unsigned set_cr4_smep(ac_test_t *at, int smep)
 {
 	extern char stext, etext;
-	size_t len = (size_t)&etext - (size_t)&stext;
+	unsigned long code_start = (unsigned long)&stext;
+	unsigned long code_end = (unsigned long)&etext;
 	unsigned long cr4 = shadow_cr4;
 	unsigned r;
 
@@ -231,10 +269,10 @@ static unsigned set_cr4_smep(int smep)
 		return 0;
 
 	if (smep)
-		walk_pte(&stext, len, clear_user_mask);
+		walk_ptes(at, code_start, code_end, clear_user_mask);
 	r = write_cr4_checking(cr4);
 	if (r || !smep)
-		walk_pte(&stext, len, set_user_mask);
+		walk_ptes(at, code_start, code_end, set_user_mask);
 	if (!r)
 		shadow_cr4 = cr4;
 	return r;
@@ -640,21 +678,18 @@ static void ac_setup_specific_pages(ac_test_t *at, ac_pt_env_t *pt_env,
 	return __ac_setup_specific_pages(at, pt_env, false, pd_page, pt_page);
 }
 
+static void __dump_pte(pt_element_t *ptep, int level, unsigned long virt)
+{
+	printf("------L%d: %lx\n", level, *ptep);
+}
+
 static void dump_mapping(ac_test_t *at)
 {
-	unsigned long parent_pte = shadow_cr3;
+	unsigned long virt = (unsigned long)at->virt;
 	int flags = at->flags;
-	int i;
 
 	printf("Dump mapping: address: %p\n", at->virt);
-	for (i = at->pt_levels; i >= 1 && (i >= 2 || !F(AC_PDE_PSE)); --i) {
-		pt_element_t *parent_pt = va(parent_pte & PT_BASE_ADDR_MASK);
-		unsigned index = PT_INDEX((unsigned long)at->virt, i);
-		pt_element_t pte = parent_pt[index];
-
-		printf("------L%d: %lx\n", i, pte);
-		parent_pte = pte;
-	}
+	walk_va(at, F(AC_PDE_PSE) ? 2 : 1, virt, __dump_pte, false);
 }
 
 static void ac_test_check(ac_test_t *at, _Bool *success_ret, _Bool cond,
@@ -719,7 +754,7 @@ static int ac_test_do_access(ac_test_t *at)
 			   (F(AC_PKU_AD) ? 4 : 0));
 	}
 
-	set_cr4_smep(F(AC_CPU_CR4_SMEP));
+	set_cr4_smep(at, F(AC_CPU_CR4_SMEP));
 
 	if (F(AC_ACCESS_TWICE)) {
 		asm volatile ("mov $fixed2, %%rsi \n\t"
@@ -977,7 +1012,7 @@ static int check_smep_andnot_wp(ac_pt_env_t *pt_env)
 	err_smep_andnot_wp = ac_test_do_access(&at1);
 
 clean_up:
-	set_cr4_smep(0);
+	set_cr4_smep(&at1, 0);
 
 	if (!err_prepare_andnot_wp)
 		goto err;
@@ -1103,6 +1138,9 @@ int ac_test_run(int pt_levels)
 		invalid_mask |= AC_PTE_BIT36_MASK;
 	}
 
+	ac_env_int(&pt_env, pt_levels);
+	ac_test_init(&at, (void *)(0x123400000000), &pt_env);
+
 	if (this_cpu_has(X86_FEATURE_PKU)) {
 		set_cr4_pke(1);
 		set_cr4_pke(0);
@@ -1124,13 +1162,13 @@ int ac_test_run(int pt_levels)
 
 	if (!this_cpu_has(X86_FEATURE_SMEP)) {
 		tests++;
-		if (set_cr4_smep(1) == GP_VECTOR) {
+		if (set_cr4_smep(&at, 1) == GP_VECTOR) {
 			successes++;
 			invalid_mask |= AC_CPU_CR4_SMEP_MASK;
 			printf("CR4.SMEP not available, disabling SMEP tests\n");
 		} else {
 			printf("Set SMEP in CR4 - expect #GP: FAIL!\n");
-			set_cr4_smep(0);
+			set_cr4_smep(&at, 0);
 		}
 	}
 
@@ -1146,8 +1184,6 @@ int ac_test_run(int pt_levels)
 			successes++;
 	}
 
-	ac_env_int(&pt_env, pt_levels);
-	ac_test_init(&at, (void *)(0x123400000000), &pt_env);
 	do {
 		++tests;
 		successes += ac_test_exec(&at, &pt_env);
-- 
2.34.0.rc2.393.gf8c9666880-goog

