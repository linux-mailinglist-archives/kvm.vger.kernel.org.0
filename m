Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9486696FD
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 13:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbjAMM3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 07:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241665AbjAMM3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 07:29:08 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91179167D7;
        Fri, 13 Jan 2023 04:27:51 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso24257972pjf.1;
        Fri, 13 Jan 2023 04:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eW5T5YPDWz2scVPj5ewyPAEA8d0QvXFW6aERqKteFzM=;
        b=hdnP4s+MPgeemfmJgGhQ2XkPsiziWn4o0/ZpO6bLXuqBztuGCXESJJY4iEnmidEAiI
         WllXwkfToJUXI2p3w8NAmxmJT8NUEgA1jELNcZe9W/LeWz9msYT51pUSbpui26PXwLP6
         iYfJo0aAWLBDWM1K4Y0ilVq72wswZo7iggC7lH98IAU9chHYHZQ5ATor+ng/P747tigD
         FPaDhlGfsf1eRwYRU4ABaJG8Uu+d5jqQ6r0v8A8var6soBgYIkr8K0pyvcQX1mPZU1PW
         H1eP1gw03sFB9ZBkYczdbnLyqY0uWjgBD+uE5Vl3xkumQ2PdFt1WsSqxPCnFcj7kb+5a
         t1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eW5T5YPDWz2scVPj5ewyPAEA8d0QvXFW6aERqKteFzM=;
        b=QUn/MmR5GMeIax/q7DAJ5YL4P+sYkyurMjzE70ikhuZkhaRxhBQC8dPqyKSuoIwYLN
         I7cOYnYJBPtpNuP4CUWVOkSNDuPM+B+bYZmWE/blIcVXJ9fBHMDyUVQxBD6K31v/Y+KL
         Sam/7GIu3SKQrCtrcqDNxGuRlPgOVgwNM8EcUb/gYlnSof0ZT9phYJRJDgbCQBo4XPgk
         51c1djXblxF0vafwCM3MLZCg9+dMDxwAjoyqASohhkaQst11Ks8790MswVeJc1o6R3ML
         NBf5v3kJeEgX3F5TVWCI0ahUjZ6HVVX1D3TXSwzhMeBffYAeaNGKJ/3odUlqoS4B5UQg
         zHoQ==
X-Gm-Message-State: AFqh2kqbQjBaMA8ZAnKGAUv6X+Dv18nOvCs4/pH3a+K57kS5Nl45SEkB
        53QnEiRwng3dobS+dz4GT7RB0Nim3As=
X-Google-Smtp-Source: AMrXdXt3ed0cf2ZJlvfkuHhGg2KJz2VSHHAY4GGUGo8lAoH5LAJPGppQ3cbtOPS9v3vQ1bR7u7QewQ==
X-Received: by 2002:a05:6a20:a011:b0:b5:c7ed:3de1 with SMTP id p17-20020a056a20a01100b000b5c7ed3de1mr24768485pzj.0.1673612870324;
        Fri, 13 Jan 2023 04:27:50 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id b193-20020a621bca000000b005810c4286d6sm13653167pfb.0.2023.01.13.04.27.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Jan 2023 04:27:49 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH] kvm: x86/mmu: Simplify pte_list_{add|remove}
Date:   Fri, 13 Jan 2023 20:29:10 +0800
Message-Id: <20230113122910.672417-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Simplify pte_list_{add|remove} by ensuring all the non-head pte_list_desc
to be full and addition/removal actions being performed on the head.

To make pte_list_add() return a count as before, @tail_count is also
added to the struct pte_list_desc.

No visible performace is changed in tests.  But pte_list_add() is no longer
shown in the perf result for the COWed pages even the guest forks millions
of tasks.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 77 +++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 55c9fcd6ed4f..fc64f5f0822f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -131,10 +131,16 @@ module_param(dbg, bool, 0644);
 struct pte_list_desc {
 	struct pte_list_desc *more;
 	/*
-	 * Stores number of entries stored in the pte_list_desc.  No need to be
-	 * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
+	 * @spte_count: Stores number of entries stored in the pte_list_desc.
+	 * When PTE_LIST_EXT, means full.  All the non-head pte_list_desc must
+	 * be full.
+	 *
+	 * @tail_count: Stores number of entries stored in its tail descriptions.
+	 *
+	 * No need to be u32 but just for easier alignment.
 	 */
-	u64 spte_count;
+	u32 spte_count;
+	u32 tail_count;
 	u64 *sptes[PTE_LIST_EXT];
 };
 
@@ -917,22 +923,25 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		desc->spte_count = 2;
+		desc->tail_count = 0;
 		rmap_head->val = (unsigned long)desc | 1;
 		++count;
 	} else {
 		rmap_printk("%p %llx many->many\n", spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-		while (desc->spte_count == PTE_LIST_EXT) {
-			count += PTE_LIST_EXT;
-			if (!desc->more) {
-				desc->more = kvm_mmu_memory_cache_alloc(cache);
-				desc = desc->more;
-				desc->spte_count = 0;
-				break;
-			}
-			desc = desc->more;
+		count = desc->tail_count + desc->spte_count;
+		/*
+		 * When the head pte_list_desc is full, the whole list must
+		 * be full since all the non-head pte_list_desc are full.
+		 * So just allocate a new head.
+		 */
+		if (desc->spte_count == PTE_LIST_EXT) {
+			desc = kvm_mmu_memory_cache_alloc(cache);
+			desc->more = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+			desc->spte_count = 0;
+			desc->tail_count = count;
+			rmap_head->val = (unsigned long)desc | 1;
 		}
-		count += desc->spte_count;
 		desc->sptes[desc->spte_count++] = spte;
 	}
 	return count;
@@ -940,30 +949,30 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 
 static void
 pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
-			   struct pte_list_desc *desc, int i,
-			   struct pte_list_desc *prev_desc)
+			   struct pte_list_desc *desc, int i)
 {
-	int j = desc->spte_count - 1;
+	struct pte_list_desc *head_desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+	int j = head_desc->spte_count - 1;
 
-	desc->sptes[i] = desc->sptes[j];
-	desc->sptes[j] = NULL;
-	desc->spte_count--;
-	if (desc->spte_count)
+	/*
+	 * Grab an entry from the head pte_list_desc to ensure that
+	 * the non-head pte_list_desc are full.
+	 */
+	desc->sptes[i] = head_desc->sptes[j];
+	head_desc->sptes[j] = NULL;
+	head_desc->spte_count--;
+	if (head_desc->spte_count)
 		return;
-	if (!prev_desc && !desc->more)
+	if (!head_desc->more)
 		rmap_head->val = 0;
 	else
-		if (prev_desc)
-			prev_desc->more = desc->more;
-		else
-			rmap_head->val = (unsigned long)desc->more | 1;
-	mmu_free_pte_list_desc(desc);
+		rmap_head->val = (unsigned long)head_desc->more | 1;
+	mmu_free_pte_list_desc(head_desc);
 }
 
 static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
-	struct pte_list_desc *prev_desc;
 	int i;
 
 	if (!rmap_head->val) {
@@ -979,16 +988,13 @@ static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 	} else {
 		rmap_printk("%p many->many\n", spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-		prev_desc = NULL;
 		while (desc) {
 			for (i = 0; i < desc->spte_count; ++i) {
 				if (desc->sptes[i] == spte) {
-					pte_list_desc_remove_entry(rmap_head,
-							desc, i, prev_desc);
+					pte_list_desc_remove_entry(rmap_head, desc, i);
 					return;
 				}
 			}
-			prev_desc = desc;
 			desc = desc->more;
 		}
 		pr_err("%s: %p many->many\n", __func__, spte);
@@ -1035,7 +1041,6 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
-	unsigned int count = 0;
 
 	if (!rmap_head->val)
 		return 0;
@@ -1043,13 +1048,7 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 		return 1;
 
 	desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-
-	while (desc) {
-		count += desc->spte_count;
-		desc = desc->more;
-	}
-
-	return count;
+	return desc->tail_count + desc->spte_count;
 }
 
 static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
-- 
2.19.1.6.gb485710b

