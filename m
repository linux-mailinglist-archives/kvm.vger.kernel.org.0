Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BE04C0C14
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbiBWF1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238388AbiBWF0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:51 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7506D3BB
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:14 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b18-20020a25fa12000000b0062412a8200eso20209728ybe.22
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z2A7zhGCAXM89Mm8qf+swCLr5Dn/epWs5SXVvIpUsek=;
        b=tRhCbGDitng8H5bHVni9LeLhw+OutL5exoDLV2q/On1vnMgXPuEEjcg+LbKI1cVqrD
         Vyo7V47FL7/0MDpSopFI7nReIbg7le3SY0oaOVkKdiMGKdDx7pdDSJXZaaKKRg410xu2
         t4RPD/m0Rz3825891oGpbAo2zhoskX0LmYLk/s6S6UydDxkiw0PDjI+nunjVplgqDwrA
         +5Jz1StT9q9LpFCspfDpRycEYKD4vtMQDfcSS06Robo3QGT5pJP4suYnnRPaHrjD0ty7
         l5qUqZO6zEun+3vP4Gykt/1OOPF+J93aOR22CevdnVkqI4Do06KPWQJ6jdbyHleq2VP2
         sP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z2A7zhGCAXM89Mm8qf+swCLr5Dn/epWs5SXVvIpUsek=;
        b=og0g6AyF5+s+ZEcYHKoNF192o1P9dr0p2KSaJiy1dWFO4krd8XmVbGljf9RaggOpde
         EWePHC8fAyC8jZvayNMHAH69B8eeS7g373AsVQt4GbacDKNPikHiC7yiTlsHpMRie2u7
         lEydjmb4PPAu5sSkLwjtwbtngNAjSYr6HfPth606wGJQ1np10ZtV/JHwzfZCc26dH2jY
         O5a1zRQI5X5SJy8V6nfFGBNWel6ein81zRAhXk6q+xErSqaI4RWvqwsOmqC/+Lu20NH4
         7gbyVFNgUBC7j4z1B9tzHcUIokRzFcTkbnRoBYvcvUhUUdwI7uPVGVE1NA3GWfruS7WI
         9UAQ==
X-Gm-Message-State: AOAM533q5nkPVXhxhnigzBKgxAW0aSp4YJXo8wPjy/c4dgcZzyh8EkKw
        urAD+QeG1nySnDqCOpZNdeYuFRUatvnq
X-Google-Smtp-Source: ABdhPJxQh2hzOmUCmk3wlhtqctWGzojDMn80W5x6yZGJyfVoEE9kdvLHRV4rxoztBsJ+fy5+R2LvtwTwKQ0F
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a0d:eb09:0:b0:2d1:e0df:5104 with SMTP id
 u9-20020a0deb09000000b002d1e0df5104mr27669944ywe.250.1645593903681; Tue, 22
 Feb 2022 21:25:03 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:11 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-36-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 35/47] mm: asi: asi_exit() on PF, skip handling if address
 is accessible
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ofir Weisse <oweisse@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com, pjt@google.com,
        alexandre.chartre@oracle.com, rppt@linux.ibm.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, luto@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ofir Weisse <oweisse@google.com>

On a page-fault - do asi_exit(). Then check if now after the exit the
address is accessible. We do this by refactoring spurious_kernel_fault()
into two parts:

1. Verify that the error code value is something that could arise from a
lazy TLB update.
2. Walk the page table and verify permissions, which is now called
is_address_accessible_now(). We also define PTE_PRESENT() and
PMD_PRESENT() which are suitable for checking userspace pages. For the
sake of spurious faualts,  pte_present() and pmd_present() are only
good for kernelspace pages. This is because these macros might return
true even if the present bit is 0 (only relevant for userspace).

Signed-off-by: Ofir Weisse <oweisse@google.com>


---
 arch/x86/mm/fault.c      | 60 ++++++++++++++++++++++++++++++++++------
 include/linux/mm_types.h |  3 ++
 2 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8692eb50f4a5..d08021ba380b 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -982,6 +982,8 @@ static int spurious_kernel_fault_check(unsigned long error_code, pte_t *pte)
 	return 1;
 }
 
+static int is_address_accessible_now(unsigned long error_code, unsigned long address,
+                              pgd_t *pgd);
 /*
  * Handle a spurious fault caused by a stale TLB entry.
  *
@@ -1003,15 +1005,13 @@ static int spurious_kernel_fault_check(unsigned long error_code, pte_t *pte)
  * See Intel Developer's Manual Vol 3 Section 4.10.4.3, bullet 3
  * (Optional Invalidation).
  */
+/* A spurious fault is also possible when Address Space Isolation (ASI) is in
+ * use. Specifically, code running withing an ASI domain touched memory outside
+ * the domain. This access causes a page-fault --> asi_exit() */
 static noinline int
 spurious_kernel_fault(unsigned long error_code, unsigned long address)
 {
 	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	int ret;
 
 	/*
 	 * Only writes to RO or instruction fetches from NX may cause
@@ -1027,6 +1027,37 @@ spurious_kernel_fault(unsigned long error_code, unsigned long address)
 		return 0;
 
 	pgd = init_mm.pgd + pgd_index(address);
+        return is_address_accessible_now(error_code, address, pgd);
+}
+NOKPROBE_SYMBOL(spurious_kernel_fault);
+
+
+/* Check if an address (kernel or userspace) would cause a page fault if
+ * accessed now.
+ *
+ * For kernel addresses, pte_present and pmd_present are sufficioent. For
+ * userspace, we must use PTE_PRESENT and PMD_PRESENT, which will only check the
+ * present bits.
+ * The existing pmd_present() in arch/x86/include/asm/pgtable.h is misleading.
+ * The PMD page might be in the middle of split_huge_page with present bit
+ * clear, but pmd_present will still return true. We are inteerested in knowing
+ * if the page is accessible to hardware - that is - the present bit is 1. */
+#define PMD_PRESENT(pmd) (pmd_flags(pmd) & _PAGE_PRESENT)
+
+/* pte_present will return true is _PAGE_PROTNONE is 1. We care if the hardware
+ * can actually access the page right now. */
+#define PTE_PRESENT(pte) (pte_flags(pte) & _PAGE_PRESENT)
+
+static noinline int
+is_address_accessible_now(unsigned long error_code, unsigned long address,
+                          pgd_t *pgd)
+{
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+        int ret;
+
 	if (!pgd_present(*pgd))
 		return 0;
 
@@ -1045,14 +1076,14 @@ spurious_kernel_fault(unsigned long error_code, unsigned long address)
 		return spurious_kernel_fault_check(error_code, (pte_t *) pud);
 
 	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
+	if (!PMD_PRESENT(*pmd))
 		return 0;
 
 	if (pmd_large(*pmd))
 		return spurious_kernel_fault_check(error_code, (pte_t *) pmd);
 
 	pte = pte_offset_kernel(pmd, address);
-	if (!pte_present(*pte))
+	if (!PTE_PRESENT(*pte))
 		return 0;
 
 	ret = spurious_kernel_fault_check(error_code, pte);
@@ -1068,7 +1099,6 @@ spurious_kernel_fault(unsigned long error_code, unsigned long address)
 
 	return ret;
 }
-NOKPROBE_SYMBOL(spurious_kernel_fault);
 
 int show_unhandled_signals = 1;
 
@@ -1504,6 +1534,20 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 	 * the fixup on the next page fault.
 	 */
 	struct asi *asi = asi_get_current();
+        if (asi)
+                asi_exit();
+
+        /* handle_page_fault() might call BUG() if we run it for a kernel
+         * address. This might be the case if we got here due to an ASI fault.
+         * We avoid this case by checking whether the address is now, after a
+         * potential asi_exit(), accessible by hardware. If it is - there's
+         * nothing to do.
+         */
+        if (current && mm_asi_enabled(current->mm)) {
+                pgd_t *pgd = (pgd_t*)__va(read_cr3_pa()) + pgd_index(address);
+                if (is_address_accessible_now(error_code, address, pgd))
+                        return;
+        }
 
 	prefetchw(&current->mm->mmap_lock);
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index c3f209720a84..560909e80841 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -707,6 +707,9 @@ extern struct mm_struct init_mm;
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 static inline bool mm_asi_enabled(struct mm_struct *mm)
 {
+        if (!mm)
+                return false;
+
         return mm->asi_enabled;
 }
 #else
-- 
2.35.1.473.g83b2b277ed-goog

