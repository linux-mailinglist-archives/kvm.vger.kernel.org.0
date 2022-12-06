Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F8A644A5C
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 18:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbiLFRgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 12:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbiLFRgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 12:36:10 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D08D37F93
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 09:36:09 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id q63-20020a632a42000000b0045724b1dfb9so12543742pgq.3
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 09:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=akd5rMPTncKvwlPwwGjqiEGLXYk8H+l4pcsG5gvu2EQ=;
        b=P3zoi6Oo6b7q+soGLki3tsCGlAU9dd9EOInpq1nWCzLQXQqk0hqowY4Hkq8RRNwYi6
         O/UBNmRBhKw2A1BU/fGaVbprZcSxapecuRH8bj0X94WYxwiQFZ0e5TqdxvXyApmA6Nfz
         t5JaVSrJVdjIYX+F6sAntOrzLzbsicP3kYMzZ6UugA24K+onBITM6wb3Db0Dtkp1heHx
         /1bFv58lqLKo0R59joc5Q/rGf0bzp/hDa9eIH2sRAt1ATPZrn1sxXPFjwd1gzFhDLEW3
         AWzzmxhdvQN+2ZBILDa3i/iPLkmZGA3zrWubVUq/F/L7sKGoicBwrrWfy5g3Lzl1Q63C
         9QUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=akd5rMPTncKvwlPwwGjqiEGLXYk8H+l4pcsG5gvu2EQ=;
        b=oU2HHIoP7p9d7e6TWwfr/JqRzJ8dULQ1Xaci1xg/zrcX/CIr9LG52bfhPSaPuIshtZ
         l40xEpl7wWuw4cTU4juw5zK7AeaJWNzhbvPnkpgpsv3esv8O0xdJUUMcz8t0QvTEImU+
         Z/GKTSVvFp2X7QzwmBVxMNzV1ST+Liz1xUdsyaYyGpolcM5sMWUP/P4qUWXuXixGHOyJ
         SZK0BLlDgeN2MXMm7LJvDnwdrz87ghtq54kbISpH6ZAt29LWqnCHME4akqJBP0k8DZjn
         GUxTm1h5JlyuEsBEdfL85l9N+VhT65JBzzbpUTyZRVXDHoKmuTLX+xWUVk0pkfs8hjHb
         74Yg==
X-Gm-Message-State: ANoB5pmaKup1qRZopjG0VP6uk0ZNFFCXw076RZkL0FkaEH8XA7v9EGkH
        bE62tDIbrP+CSkFIkdNISkXbf9OL03LU
X-Google-Smtp-Source: AA0mqf7m3FYBiYJRx6kc4LjbWv9jhqrSqbUCo0Kd5jklLnQdmTyeb6gzvI5DTS5hZQdVHl/r3uSYpdQ1+RCr
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a62:8683:0:b0:577:3624:2d49 with SMTP id
 x125-20020a628683000000b0057736242d49mr5185978pfd.64.1670348169136; Tue, 06
 Dec 2022 09:36:09 -0800 (PST)
Date:   Tue,  6 Dec 2022 17:35:56 +0000
In-Reply-To: <20221206173601.549281-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221206173601.549281-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206173601.549281-3-bgardon@google.com>
Subject: [PATCH 2/7] KVM: x86/MMU: Move rmap_iterator to rmap.h
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In continuing to factor the rmap out of mmu.c, move the rmap_iterator
and associated functions and macros into rmap.(c|h).

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 76 -----------------------------------------
 arch/x86/kvm/mmu/rmap.c | 61 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/rmap.h | 18 ++++++++++
 3 files changed, 79 insertions(+), 76 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 90b3735d6064..c3a7f443a213 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -932,82 +932,6 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	pte_list_remove(spte, rmap_head);
 }
 
-/*
- * Used by the following functions to iterate through the sptes linked by a
- * rmap.  All fields are private and not assumed to be used outside.
- */
-struct rmap_iterator {
-	/* private fields */
-	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
-	int pos;			/* index of the sptep */
-};
-
-/*
- * Iteration must be started by this function.  This should also be used after
- * removing/dropping sptes from the rmap link because in such cases the
- * information in the iterator may not be valid.
- *
- * Returns sptep if found, NULL otherwise.
- */
-static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
-			   struct rmap_iterator *iter)
-{
-	u64 *sptep;
-
-	if (!rmap_head->val)
-		return NULL;
-
-	if (!(rmap_head->val & 1)) {
-		iter->desc = NULL;
-		sptep = (u64 *)rmap_head->val;
-		goto out;
-	}
-
-	iter->desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-	iter->pos = 0;
-	sptep = iter->desc->sptes[iter->pos];
-out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
-	return sptep;
-}
-
-/*
- * Must be used with a valid iterator: e.g. after rmap_get_first().
- *
- * Returns sptep if found, NULL otherwise.
- */
-static u64 *rmap_get_next(struct rmap_iterator *iter)
-{
-	u64 *sptep;
-
-	if (iter->desc) {
-		if (iter->pos < PTE_LIST_EXT - 1) {
-			++iter->pos;
-			sptep = iter->desc->sptes[iter->pos];
-			if (sptep)
-				goto out;
-		}
-
-		iter->desc = iter->desc->more;
-
-		if (iter->desc) {
-			iter->pos = 0;
-			/* desc->sptes[0] cannot be NULL */
-			sptep = iter->desc->sptes[iter->pos];
-			goto out;
-		}
-	}
-
-	return NULL;
-out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
-	return sptep;
-}
-
-#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)			\
-	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
-	     _spte_; _spte_ = rmap_get_next(_iter_))
-
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
 	u64 old_spte = mmu_spte_clear_track_bits(kvm, sptep);
diff --git a/arch/x86/kvm/mmu/rmap.c b/arch/x86/kvm/mmu/rmap.c
index daa99dee0709..c3bad366b627 100644
--- a/arch/x86/kvm/mmu/rmap.c
+++ b/arch/x86/kvm/mmu/rmap.c
@@ -139,3 +139,64 @@ unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 	return count;
 }
 
+/*
+ * Iteration must be started by this function.  This should also be used after
+ * removing/dropping sptes from the rmap link because in such cases the
+ * information in the iterator may not be valid.
+ *
+ * Returns sptep if found, NULL otherwise.
+ */
+u64 *rmap_get_first(struct kvm_rmap_head *rmap_head, struct rmap_iterator *iter)
+{
+	u64 *sptep;
+
+	if (!rmap_head->val)
+		return NULL;
+
+	if (!(rmap_head->val & 1)) {
+		iter->desc = NULL;
+		sptep = (u64 *)rmap_head->val;
+		goto out;
+	}
+
+	iter->desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
+	iter->pos = 0;
+	sptep = iter->desc->sptes[iter->pos];
+out:
+	BUG_ON(!is_shadow_present_pte(*sptep));
+	return sptep;
+}
+
+/*
+ * Must be used with a valid iterator: e.g. after rmap_get_first().
+ *
+ * Returns sptep if found, NULL otherwise.
+ */
+u64 *rmap_get_next(struct rmap_iterator *iter)
+{
+	u64 *sptep;
+
+	if (iter->desc) {
+		if (iter->pos < PTE_LIST_EXT - 1) {
+			++iter->pos;
+			sptep = iter->desc->sptes[iter->pos];
+			if (sptep)
+				goto out;
+		}
+
+		iter->desc = iter->desc->more;
+
+		if (iter->desc) {
+			iter->pos = 0;
+			/* desc->sptes[0] cannot be NULL */
+			sptep = iter->desc->sptes[iter->pos];
+			goto out;
+		}
+	}
+
+	return NULL;
+out:
+	BUG_ON(!is_shadow_present_pte(*sptep));
+	return sptep;
+}
+
diff --git a/arch/x86/kvm/mmu/rmap.h b/arch/x86/kvm/mmu/rmap.h
index 059765b6e066..13b265f3a95e 100644
--- a/arch/x86/kvm/mmu/rmap.h
+++ b/arch/x86/kvm/mmu/rmap.h
@@ -31,4 +31,22 @@ void free_pte_list_desc(struct pte_list_desc *pte_list_desc);
 void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
+/*
+ * Used by the following functions to iterate through the sptes linked by a
+ * rmap.  All fields are private and not assumed to be used outside.
+ */
+struct rmap_iterator {
+	/* private fields */
+	struct pte_list_desc *desc;	/* holds the sptep if not NULL */
+	int pos;			/* index of the sptep */
+};
+
+u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
+		    struct rmap_iterator *iter);
+u64 *rmap_get_next(struct rmap_iterator *iter);
+
+#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)			\
+	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
+	     _spte_; _spte_ = rmap_get_next(_iter_))
+
 #endif /* __KVM_X86_MMU_RMAP_H */
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

