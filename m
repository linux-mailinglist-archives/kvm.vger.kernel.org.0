Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DA04C0BAA
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbiBWFYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237962AbiBWFY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:28 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0CB69CE6
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:59 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d726bd83a2so91076827b3.20
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PIzleJhvx1e4in5SU2cz59acEkt7I4gZXxP/VePrhcs=;
        b=UOhpXDHCnae+DRnauRxZtdjiTln+VoGZhoV1LC2HwZ0wE6hCMEDx6ZsM5m4zhmzU8C
         zHAJJxzPwGGULan8LLoI7C3OSmGzlkgZIkeoNkliXHKxR2zxRtRuDwE2nmiSS1c4BXRL
         MiuUyWSM6+TUYE5RqqQekigHUWwoMR7es7zfFE2KzZ5ooe/XoTE9TQgA48klkJO1uSey
         E656AcQf7rLEbAA6uzuZiKaqjksL8iwXpjTOMvdQBp3iyrK4xwvnjKTRQ5lhnl0vyEeu
         pioGnqi8o2SeqNRitqaZjawpEPOB4cWAR7yNk2BDoyC4/ldrIIsdHyj3n/nSEdlK5M0a
         gypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PIzleJhvx1e4in5SU2cz59acEkt7I4gZXxP/VePrhcs=;
        b=ID8nqAcYzMMYYKukHKcg9FBPRFKAZrcChpm+KV87rtbhCvofobfqmJQ8U78M4YNUJf
         WHarkUI9ij74/y3/h65AgDU7vNQBV3bO6XJ4Vbn+/EZqydjo2WmfAsNXrlrzt0+wwLng
         GNhkAeudWNSDYsZiA5Qni2g+wQC0cHuFu+W1U/TmH5ehKNmOzAqHr6ej4L1TwaxWBTXg
         MtO8KmW6hOGV0SrPs2gffvnrUPzLpvo/9HBWio+YgfSOkbwYZVilPFRYkCQy3ftkmSU8
         sPr68XryYB9QcIHsOLPVBNEse85y0iF0N59Fz9XQrFGn2Qr5l2TVPQOQUTVDBOrGxyxw
         CrVg==
X-Gm-Message-State: AOAM531ANnALm9LU9OdrAE/04RU0def1nV1CZC27qdpa2L3ScA6MfJwe
        03LBLdOppyJYlKiabDmehSGXkk4zBmJ0
X-Google-Smtp-Source: ABdhPJyZtnc6SgOpidUjkYpln4RLDN4W6lG8iW37Mn66M+p2QX3sw1OB0/Qqkeh8xQlAuLXN36L1X25C92Rt
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a0d:c607:0:b0:2ca:287c:6b6c with SMTP id
 i7-20020a0dc607000000b002ca287c6b6cmr28060793ywd.17.1645593839000; Tue, 22
 Feb 2022 21:23:59 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:42 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-7-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 06/47] mm: asi: ASI page table allocation and free functions
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds custom allocation and free functions for ASI page tables.

The alloc functions support allocating memory using different GFP
reclaim flags, in order to be able to support non-sensitive allocations
from both standard and atomic contexts. They also install the page
tables locklessly, which makes it slightly simpler to handle
non-sensitive allocations from interrupts/exceptions.

The free functions recursively free the page tables when the ASI
instance is being torn down.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/mm/asi.c       | 109 +++++++++++++++++++++++++++++++++++++++-
 include/linux/pgtable.h |   3 ++
 2 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 2453124f221d..40d772b2e2a8 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -60,6 +60,113 @@ void asi_unregister_class(int index)
 }
 EXPORT_SYMBOL_GPL(asi_unregister_class);
 
+#ifndef mm_inc_nr_p4ds
+#define mm_inc_nr_p4ds(mm)	do {} while (false)
+#endif
+
+#ifndef mm_dec_nr_p4ds
+#define mm_dec_nr_p4ds(mm)	do {} while (false)
+#endif
+
+#define pte_offset		pte_offset_kernel
+
+#define DEFINE_ASI_PGTBL_ALLOC(base, level)				\
+static level##_t * asi_##level##_alloc(struct asi *asi,			\
+				       base##_t *base, ulong addr,	\
+				       gfp_t flags)			\
+{									\
+	if (unlikely(base##_none(*base))) {				\
+		ulong pgtbl = get_zeroed_page(flags);			\
+		phys_addr_t pgtbl_pa;					\
+									\
+		if (pgtbl == 0)						\
+			return NULL;					\
+									\
+		pgtbl_pa = __pa(pgtbl);					\
+		paravirt_alloc_##level(asi->mm, PHYS_PFN(pgtbl_pa));	\
+									\
+		if (cmpxchg((ulong *)base, 0,				\
+			    pgtbl_pa | _PAGE_TABLE) == 0) {		\
+			mm_inc_nr_##level##s(asi->mm);			\
+		} else {						\
+			paravirt_release_##level(PHYS_PFN(pgtbl_pa));	\
+			free_page(pgtbl);				\
+		}							\
+									\
+		/* NOP on native. PV call on Xen. */			\
+		set_##base(base, *base);				\
+	}								\
+	VM_BUG_ON(base##_large(*base));					\
+	return level##_offset(base, addr);				\
+}
+
+DEFINE_ASI_PGTBL_ALLOC(pgd, p4d)
+DEFINE_ASI_PGTBL_ALLOC(p4d, pud)
+DEFINE_ASI_PGTBL_ALLOC(pud, pmd)
+DEFINE_ASI_PGTBL_ALLOC(pmd, pte)
+
+#define asi_free_dummy(asi, addr)
+#define __pmd_free(mm, pmd) free_page((ulong)(pmd))
+#define pud_page_vaddr(pud) ((ulong)pud_pgtable(pud))
+#define p4d_page_vaddr(p4d) ((ulong)p4d_pgtable(p4d))
+
+static inline unsigned long pte_page_vaddr(pte_t pte)
+{
+	return (unsigned long)__va(pte_val(pte) & PTE_PFN_MASK);
+}
+
+#define DEFINE_ASI_PGTBL_FREE(level, LEVEL, next, free)			\
+static void asi_free_##level(struct asi *asi, ulong pgtbl_addr)		\
+{									\
+	uint i;								\
+	level##_t *level = (level##_t *)pgtbl_addr;			\
+									\
+	for (i = 0; i < PTRS_PER_##LEVEL; i++) {			\
+		ulong vaddr;						\
+									\
+		if (level##_none(level[i]))				\
+			continue;					\
+									\
+		vaddr = level##_page_vaddr(level[i]);			\
+									\
+		if (!level##_leaf(level[i]))				\
+			asi_free_##next(asi, vaddr);			\
+		else							\
+			VM_WARN(true, "Lingering mapping in ASI %p at %lx",\
+				asi, vaddr);				\
+	}								\
+	paravirt_release_##level(PHYS_PFN(__pa(pgtbl_addr)));		\
+	free(asi->mm, level);						\
+	mm_dec_nr_##level##s(asi->mm);					\
+}
+
+DEFINE_ASI_PGTBL_FREE(pte, PTE, dummy, pte_free_kernel)
+DEFINE_ASI_PGTBL_FREE(pmd, PMD, pte, __pmd_free)
+DEFINE_ASI_PGTBL_FREE(pud, PUD, pmd, pud_free)
+DEFINE_ASI_PGTBL_FREE(p4d, P4D, pud, p4d_free)
+
+static void asi_free_pgd_range(struct asi *asi, uint start, uint end)
+{
+	uint i;
+
+	for (i = start; i < end; i++)
+		if (pgd_present(asi->pgd[i]))
+			asi_free_p4d(asi, (ulong)p4d_offset(asi->pgd + i, 0));
+}
+
+/*
+ * Free the page tables allocated for the given ASI instance.
+ * The caller must ensure that all the mappings have already been cleared
+ * and appropriate TLB flushes have been issued before calling this function.
+ */
+static void asi_free_pgd(struct asi *asi)
+{
+	VM_BUG_ON(asi->mm == &init_mm);
+
+	asi_free_pgd_range(asi, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD);
+	free_pages((ulong)asi->pgd, PGD_ALLOCATION_ORDER);
+}
+
 static int __init set_asi_param(char *str)
 {
 	if (strcmp(str, "on") == 0)
@@ -102,7 +209,7 @@ void asi_destroy(struct asi *asi)
 	if (!boot_cpu_has(X86_FEATURE_ASI))
 		return;
 
-	free_pages((ulong)asi->pgd, PGD_ALLOCATION_ORDER);
+	asi_free_pgd(asi);
 	memset(asi, 0, sizeof(struct asi));
 }
 EXPORT_SYMBOL_GPL(asi_destroy);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e24d2c992b11..2fff17a939f0 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1593,6 +1593,9 @@ typedef unsigned int pgtbl_mod_mask;
 #ifndef pmd_leaf
 #define pmd_leaf(x)	0
 #endif
+#ifndef pte_leaf
+#define pte_leaf(x)	1
+#endif
 
 #ifndef pgd_leaf_size
 #define pgd_leaf_size(x) (1ULL << PGDIR_SHIFT)
-- 
2.35.1.473.g83b2b277ed-goog

