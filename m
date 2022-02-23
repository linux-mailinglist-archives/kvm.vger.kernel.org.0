Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91ADB4C0C01
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238187AbiBWF05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238227AbiBWF0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:04 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC6B6E2B3
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:53 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k7-20020a255607000000b00621afc793b8so26767959ybb.1
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mHknd275MnGb/PaPBY3xJHVlcaSr+gb2g5yi23zkCMQ=;
        b=L60sUeBO3icqMJb7NMSmlVXjmIABeVNLCCtZzlOUINB+XKCgvwoL14gcA1/NI1wk1X
         /ltNckj3/3p7zfm1t1rOui84yRyyoV+XIZUZcTPfV3dYES6ZKCv3iaEJAriiM57Y+pJ2
         8u/ZPuM69uvOpnXWpYYvEAAwrxzB6ihF2OY0/HqTUANIyhOPp6jmVN945B9gOsa+htR7
         ghj+eGPzbx50ZpS/8LrSXhCGcEICsrhvK12TqRAuRKoUTOubcXhnkqoaG145HMstky5e
         ZFHHetF4BUFaO5ULQYQ3U7cD5n4sgmCCalGk7gwPkRzwbBni9d6kLYQ28QmTUA8pH14D
         Kjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mHknd275MnGb/PaPBY3xJHVlcaSr+gb2g5yi23zkCMQ=;
        b=R85UP7e8f88+daYHd4S4ia67i8Jml/wcbTGXLlHozVExqzJwLo8nqZgaHNGQQoSHGo
         IWzSSnImlK98r+kYVv0JGHZ/Zm75eArY9kY/ch2y/Q3WfaVNbDflm8MBD8r+0o2+V8JQ
         u2vkyEKF2xijpIYf+a90XFQaGFTOu8zL3oaP7uiDk7jw4awgj2tWf5TXem8VlANAFpe4
         fV2hwoVfMidONLwiTa5fLXy1DxdLHJRDNxoI/+izhnyD/1FC9ey9gHM+3OoNiynSe4XM
         zKx8MC2UT9Vxtk8brrQEObInQLEaxqdrGimUU2HbzbBQGadwM9c0k6dOGfQ9RnRVqNkR
         OAlA==
X-Gm-Message-State: AOAM530/zoRL9Mehb8B9Di79NPOTqyajAt2mwrD6WvHZFtWhEtuCEwNh
        zjvVLE/Zcjtug1kbQlm2TVW4yzhYolUS
X-Google-Smtp-Source: ABdhPJw5GHEn07Q8rEslG5JDYumsMKlC/t9Gjkx79Rz/pi8IkAfQS2IAOFNhhCDkd7GvnzpI+G+qB+zNYrIt
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a81:8414:0:b0:2d0:fdd8:f7e2 with SMTP id
 u20-20020a818414000000b002d0fdd8f7e2mr27082928ywf.156.1645593883815; Tue, 22
 Feb 2022 21:24:43 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:02 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-27-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 26/47] mm: asi: Use separate PCIDs for restricted address spaces
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

Each restricted address space is assigned a separate PCID. Since
currently only one ASI instance per-class exists for a given process,
the PCID is just derived from the class index.

This commit only sets the appropriate PCID when switching CR3, but does
not set the NOFLUSH bit. That will be done by later patches.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/asi.h      |  3 ++-
 arch/x86/include/asm/tlbflush.h |  3 +++
 arch/x86/mm/asi.c               |  6 +++--
 arch/x86/mm/tlb.c               | 45 ++++++++++++++++++++++++++++++---
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 062ccac07fd9..aaa0d0bdbf59 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -40,7 +40,8 @@ struct asi {
 	pgd_t *pgd;
 	struct asi_class *class;
 	struct mm_struct *mm;
-        int64_t asi_ref_count;
+	u16 pcid_index;
+	int64_t asi_ref_count;
 };
 
 DECLARE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 3c43ad46c14a..f9ec5e67e361 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -260,6 +260,9 @@ static inline void arch_tlbbatch_add_mm(struct arch_tlbflush_unmap_batch *batch,
 extern void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
 unsigned long build_cr3(pgd_t *pgd, u16 asid);
+unsigned long build_cr3_pcid(pgd_t *pgd, u16 pcid, bool noflush);
+
+u16 asi_pcid(struct asi *asi, u16 asid);
 
 #endif /* !MODULE */
 
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 6b9a0f5ab391..dbfea3dc4bb1 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -335,6 +335,7 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 
 	asi->class = &asi_class[asi_index];
 	asi->mm = mm;
+	asi->pcid_index = asi_index;
 
 	if (asi->class->flags & ASI_MAP_STANDARD_NONSENSITIVE) {
 		uint i;
@@ -386,6 +387,7 @@ EXPORT_SYMBOL_GPL(asi_destroy);
 void __asi_enter(void)
 {
 	u64 asi_cr3;
+	u16 pcid;
 	struct asi *target = this_cpu_read(asi_cpu_state.target_asi);
 
 	VM_BUG_ON(preemptible());
@@ -399,8 +401,8 @@ void __asi_enter(void)
 
 	this_cpu_write(asi_cpu_state.curr_asi, target);
 
-	asi_cr3 = build_cr3(target->pgd,
-			    this_cpu_read(cpu_tlbstate.loaded_mm_asid));
+	pcid = asi_pcid(target, this_cpu_read(cpu_tlbstate.loaded_mm_asid));
+	asi_cr3 = build_cr3_pcid(target->pgd, pcid, false);
 	write_cr3(asi_cr3);
 
 	if (target->class->ops.post_asi_enter)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 628f1cd904ac..312b9c185a55 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -97,7 +97,12 @@
 # define PTI_CONSUMED_PCID_BITS	0
 #endif
 
-#define CR3_AVAIL_PCID_BITS (X86_CR3_PCID_BITS - PTI_CONSUMED_PCID_BITS)
+#define ASI_CONSUMED_PCID_BITS ASI_MAX_NUM_ORDER
+#define ASI_PCID_BITS_SHIFT CR3_AVAIL_PCID_BITS
+#define CR3_AVAIL_PCID_BITS (X86_CR3_PCID_BITS - PTI_CONSUMED_PCID_BITS - \
+			     ASI_CONSUMED_PCID_BITS)
+
+static_assert(TLB_NR_DYN_ASIDS < BIT(CR3_AVAIL_PCID_BITS));
 
 /*
  * ASIDs are zero-based: 0->MAX_AVAIL_ASID are valid.  -1 below to account
@@ -154,6 +159,34 @@ static inline u16 user_pcid(u16 asid)
 	return ret;
 }
 
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+u16 asi_pcid(struct asi *asi, u16 asid)
+{
+	return kern_pcid(asid) | (asi->pcid_index << ASI_PCID_BITS_SHIFT);
+}
+
+#else /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
+u16 asi_pcid(struct asi *asi, u16 asid)
+{
+	return kern_pcid(asid);
+}
+
+#endif /* CONFIG_ADDRESS_SPACE_ISOLATION */
+
+unsigned long build_cr3_pcid(pgd_t *pgd, u16 pcid, bool noflush)
+{
+	u64 noflush_bit = 0;
+
+	if (!static_cpu_has(X86_FEATURE_PCID))
+		pcid = 0;
+	else if (noflush)
+		noflush_bit = CR3_NOFLUSH;
+
+	return __sme_pa(pgd) | pcid | noflush_bit;
+}
+
 inline unsigned long build_cr3(pgd_t *pgd, u16 asid)
 {
 	if (static_cpu_has(X86_FEATURE_PCID)) {
@@ -1078,13 +1111,17 @@ unsigned long __get_current_cr3_fast(void)
 	pgd_t *pgd;
 	u16 asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
 	struct asi *asi = asi_get_current();
+	u16 pcid;
 
-	if (asi)
+	if (asi) {
 		pgd = asi_pgd(asi);
-	else
+		pcid = asi_pcid(asi, asid);
+	} else {
 		pgd = this_cpu_read(cpu_tlbstate.loaded_mm)->pgd;
+		pcid = kern_pcid(asid);
+	}
 
-	cr3 = build_cr3(pgd, asid);
+	cr3 = build_cr3_pcid(pgd, pcid, false);
 
 	/* For now, be very restrictive about when this can be called. */
 	VM_WARN_ON(in_nmi() || preemptible());
-- 
2.35.1.473.g83b2b277ed-goog

