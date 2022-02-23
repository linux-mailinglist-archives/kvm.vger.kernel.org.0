Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CFE4C0BFA
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238310AbiBWF0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbiBWFZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:25:42 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723886D95A
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:49 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d6b6cf0cafso150372667b3.21
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=migmFG7UQDaW8MeCncNCopIOLc7/KCi4nAx8Y23Kqls=;
        b=ZIf827+EcfBkAYznkNAzIxjepuJOo5jGJUpKJJAWVlbJLp/v2xx9WndG0Zfv0Y30pp
         QVoiE4x5/isYQS6r529V5FuPTwvJXepA8/Ig/UwtVbwxtSPhO5eBWW/xZu7GdKR2hwRD
         noJsJ3Ur8bMBMS1eL71R7PXbr8K1C4T4AmgEfBVK5/+rkrUOvlO+o5qBs5UJm8vfEFH8
         iWvYMGLx9ZnbGLPu3ZtgRIXCqWDVhmvwLhi1ORJZdwX1PxFlhSsfJbPaCpw4raGaKYCV
         43iNhXkj/THFgjjQb9mrwbCVq0tdVwLBhSI29IV5lijsBJ9zHJayAmn0j12b9dgg/i30
         Q+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=migmFG7UQDaW8MeCncNCopIOLc7/KCi4nAx8Y23Kqls=;
        b=MtmvUQzKhCiQXqcZs/hUsPqCHuMddkIclhc7IfIrlEN4uaawNXnPzg0DOJ3BwHzaRI
         KE3Rn1B43k7JSku9TLo7sXif9v58l2gcjqlc/sMzO5dGuJCtVdtfnrDRSaHPjzsCTVXO
         wfyNxRAnVGrDg1XUmvWVZ4Hy5vbeDCe80vrl5rBoC/7S7DO+7U+o9GUOK3uvz9wWEq4A
         keC3xk1wpYy1kEw0lUpugF8Pa/npRp0eqNv5pDRfn4bSnMTg+C3wt1xHPyIWjqiRL9Ak
         BJuZjK3TXNhRri2zVnkX8HRPxAEhWy79yCwzxLDzSL22rxHONt0TQ+wNZlp1zR4AYHKD
         59hQ==
X-Gm-Message-State: AOAM531flawy7j1Bm/HliOjuFOsBWia97uyrlTIQLMtprf9OgM4GBqD2
        rM7mqbQNBnlbnGXIsKqZe13l5SWFUvZj
X-Google-Smtp-Source: ABdhPJzpSBL0VJdokvTlUTI5d1w3wFKyOwiaPENifHATjNeM+qviCG3MD0z5nH5EeDzE1oVe+ERWkd3RD0Jr
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:84d5:0:b0:2d1:e85:bf04 with SMTP id
 u204-20020a8184d5000000b002d10e85bf04mr27926930ywf.465.1645593877093; Tue, 22
 Feb 2022 21:24:37 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:59 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-24-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 23/47] mm: asi: Add support for mapping all userspace
 memory into ASI
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

This adds a new ASI class flag, ASI_MAP_ALL_USERSPACE, which if set,
would automatically map all userspace addresses into that ASI address
space. This is achieved by lazily cloning the userspace PGD entries
during page faults encountered while in that restricted address space.

When the userspace PGD entry is cleared (e.g. in munmap()), we go
through all restricted address spaces with the ASI_MAP_ALL_USERSPACE
flag and clear the corresponding entry in those address spaces as well.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h |  2 +
 arch/x86/mm/asi.c          | 81 ++++++++++++++++++++++++++++++++++++++
 include/asm-generic/asi.h  |  7 ++++
 mm/memory.c                |  2 +
 4 files changed, 92 insertions(+)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 2dc465f78bcc..062ccac07fd9 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -68,6 +68,8 @@ void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb);
 void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len);
 void asi_sync_mapping(struct asi *asi, void *addr, size_t len);
 void asi_do_lazy_map(struct asi *asi, size_t addr);
+void asi_clear_user_pgd(struct mm_struct *mm, size_t addr);
+void asi_clear_user_p4d(struct mm_struct *mm, size_t addr);
 
 static inline void asi_init_thread_state(struct thread_struct *thread)
 {
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index ac35323193a3..a3d96be76fa9 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -702,6 +702,41 @@ static bool is_addr_in_local_nonsensitive_range(size_t addr)
 	       addr < VMALLOC_GLOBAL_NONSENSITIVE_START;
 }
 
+static void asi_clone_user_pgd(struct asi *asi, size_t addr)
+{
+	pgd_t *src = pgd_offset_pgd(asi->mm->pgd, addr);
+	pgd_t *dst = pgd_offset_pgd(asi->pgd, addr);
+	pgdval_t old_src, curr_src;
+
+	if (pgd_val(*dst))
+		return;
+
+	VM_BUG_ON(!irqs_disabled());
+
+	/*
+	 * This synchronizes against the PGD entry getting cleared by
+	 * free_pgd_range(). That path has the following steps:
+	 * 1. pgd_clear
+	 * 2. asi_clear_user_pgd
+	 * 3. Remote TLB Flush
+	 * 4. Free page tables
+	 *
+	 * (3) will be blocked for the duration of this function because the
+	 * IPI will remain pending until interrupts are re-enabled.
+	 *
+	 * The following loop ensures that if we read the PGD value before
+	 * (1) and write it after (2), we will re-read the value and write
+	 * the new updated value.
+	 */
+	curr_src = pgd_val(*src);
+	do {
+		set_pgd(dst, __pgd(curr_src));
+		smp_mb();
+		old_src = curr_src;
+		curr_src = pgd_val(*src);
+	} while (old_src != curr_src);
+}
+
 void asi_do_lazy_map(struct asi *asi, size_t addr)
 {
 	if (!static_cpu_has(X86_FEATURE_ASI) || !asi)
@@ -710,6 +745,9 @@ void asi_do_lazy_map(struct asi *asi, size_t addr)
 	if ((asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE) &&
 	    is_addr_in_local_nonsensitive_range(addr))
 		asi_clone_pgd(asi->pgd, asi->mm->asi[0].pgd, addr);
+	else if ((asi->class->flags & ASI_MAP_ALL_USERSPACE) &&
+		 addr < TASK_SIZE_MAX)
+		asi_clone_user_pgd(asi, addr);
 }
 
 /*
@@ -766,3 +804,46 @@ void __init asi_vmalloc_init(void)
 	VM_BUG_ON(vmalloc_local_nonsensitive_end >= VMALLOC_END);
 	VM_BUG_ON(vmalloc_global_nonsensitive_start <= VMALLOC_START);
 }
+
+static void __asi_clear_user_pgd(struct mm_struct *mm, size_t addr)
+{
+	uint i;
+
+	if (!static_cpu_has(X86_FEATURE_ASI) || !mm_asi_enabled(mm))
+		return;
+
+	/*
+	 * This function is called right after pgd_clear/p4d_clear.
+	 * We need to be sure that the preceding pXd_clear is visible before
+	 * the ASI pgd clears below. Compare with asi_clone_user_pgd().
+	 */
+	smp_mb__before_atomic();
+
+	/*
+	 * We need to ensure that the ASI PGD tables do not get freed from
+	 * under us. We can potentially use RCU to avoid that, but since
+	 * this path is probably not going to be too performance sensitive,
+	 * so we just acquire the lock to block asi_destroy().
+	 */
+	mutex_lock(&mm->asi_init_lock);
+
+	for (i = 1; i < ASI_MAX_NUM; i++)
+		if (mm->asi[i].class &&
+		    (mm->asi[i].class->flags & ASI_MAP_ALL_USERSPACE))
+			set_pgd(pgd_offset_pgd(mm->asi[i].pgd, addr),
+				native_make_pgd(0));
+
+	mutex_unlock(&mm->asi_init_lock);
+}
+
+void asi_clear_user_pgd(struct mm_struct *mm, size_t addr)
+{
+	if (pgtable_l5_enabled())
+		__asi_clear_user_pgd(mm, addr);
+}
+
+void asi_clear_user_p4d(struct mm_struct *mm, size_t addr)
+{
+	if (!pgtable_l5_enabled())
+		__asi_clear_user_pgd(mm, addr);
+}
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index 7c50d8b64fa4..8513d0d7865a 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -6,6 +6,7 @@
 
 /* ASI class flags */
 #define ASI_MAP_STANDARD_NONSENSITIVE	1
+#define ASI_MAP_ALL_USERSPACE		2
 
 #ifndef CONFIG_ADDRESS_SPACE_ISOLATION
 
@@ -85,6 +86,12 @@ void asi_unmap(struct asi *asi, void *addr, size_t len, bool flush_tlb) { }
 static inline
 void asi_do_lazy_map(struct asi *asi, size_t addr) { }
 
+static inline
+void asi_clear_user_pgd(struct mm_struct *mm, size_t addr) { }
+
+static inline
+void asi_clear_user_p4d(struct mm_struct *mm, size_t addr) { }
+
 static inline
 void asi_flush_tlb_range(struct asi *asi, void *addr, size_t len) { }
 
diff --git a/mm/memory.c b/mm/memory.c
index 8f1de811a1dc..667ece86e051 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -296,6 +296,7 @@ static inline void free_pud_range(struct mmu_gather *tlb, p4d_t *p4d,
 
 	pud = pud_offset(p4d, start);
 	p4d_clear(p4d);
+	asi_clear_user_p4d(tlb->mm, start);
 	pud_free_tlb(tlb, pud, start);
 	mm_dec_nr_puds(tlb->mm);
 }
@@ -330,6 +331,7 @@ static inline void free_p4d_range(struct mmu_gather *tlb, pgd_t *pgd,
 
 	p4d = p4d_offset(pgd, start);
 	pgd_clear(pgd);
+	asi_clear_user_pgd(tlb->mm, start);
 	p4d_free_tlb(tlb, p4d, start);
 }
 
-- 
2.35.1.473.g83b2b277ed-goog

