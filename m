Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F2730CADB
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbhBBTCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239313AbhBBTAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:00:31 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32DBC061220
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:01 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id k27so14143933pfg.8
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=n8fhJr5V3N84UjdeiH+rWqHQKMtsaVAMI036LQjLnUY=;
        b=ijbEgJRV/Zt77PMExttUhXYB/VcaH+EEAn54a2as91X1nzovPhXC4+4pmqFCAWflWb
         pI2/lYkeJkQSIGNMdCk4dGY2z6gDWCJEMwz/Fh8ZJjWtNorwfkiEyCZzBMzS7LwBaW1p
         KjY7REOyWcdk26GftMco8oNfW1HLvNQzBzQJWsQpiXZ8EOdx4D/ArP5Sc3A0QGtL0xlu
         i9bnJJ+RkraYJmA+MvP2bBJHVQ1J/YvyWRoTYGoqManS3Vqbl4k1gtQ5yA7iUQjtBNBq
         1ajlNRBNFmnIrhAQeuURXGtrBPKdKjwYOyRJIsyowJV9u93s2rC5CEvQuCxdOQgEuigs
         71Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=n8fhJr5V3N84UjdeiH+rWqHQKMtsaVAMI036LQjLnUY=;
        b=NQJHJ4F3tCF74sOodxAEUIHALcl0S4VZgFyYMoBwKBN5TfAH8m0mQ7QMRyKB8VaTz3
         YRNVk+FHDl54SEkUepkynOLiOxxkeY9F8yi2uCANg3LaaPMolZqoAEKiADjGyTEULGjx
         1VpkLxCcxuZu09DXgakpijaHOMkqTxzUUIs/eAM8nVa7JtUi8D7IhbYNQpGsCuZfgzNg
         em9wuXkpelC7U+CWt72T5ryMsAnkh4O3B9KtsQ1JNQi2/2iGpOVY3cRh7YS0UP6/58zu
         H/TK1fC7Pa53h32k3xOs7FeepcfaaoByQ0uKRV7DWN0vgEclGEh1tp8I10AylBI6izJW
         JKFw==
X-Gm-Message-State: AOAM532MDXVXHbLuytda6F49WwcyLe3fBTJHl/QgEq7vcvPXdW+UMngX
        ZdItH1CXd8sUpK5sjJyzepCyWhKMO6cy
X-Google-Smtp-Source: ABdhPJwBU9rxvm3bj6kk46P+sxuaQA2kcB389w5ls0j2KxNqxATQ24vyhoBKehbvq+dVwSBGmSGgGM2Iozgp
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a65:4983:: with SMTP id
 r3mr23767928pgs.288.1612292281437; Tue, 02 Feb 2021 10:58:01 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:19 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-14-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 13/28] KVM: x86/mmu: Ensure forward progress when yielding
 in TDP MMU iter
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some functions the TDP iter risks not making forward progress if two
threads livelock yielding to one another. This is possible if two threads
are trying to execute wrprot_gfn_range. Each could write protect an entry
and then yield. This would reset the tdp_iter's walk over the paging
structure and the loop would end up repeating the same entry over and
over, preventing either thread from making forward progress.

Fix this issue by only yielding if the loop has made forward progress
since the last yield.

Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

---

v1 -> v2
- Moved forward progress check into tdp_mmu_iter_cond_resched
- Folded tdp_iter_refresh_walk into tdp_mmu_iter_cond_resched
- Split patch into three and renamed all

 arch/x86/kvm/mmu/tdp_iter.c | 18 +-----------------
 arch/x86/kvm/mmu/tdp_iter.h |  7 ++++++-
 arch/x86/kvm/mmu/tdp_mmu.c  | 21 ++++++++++++++++-----
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 9917c55b7d24..1a09d212186b 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -31,6 +31,7 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
 
 	iter->next_last_level_gfn = next_last_level_gfn;
+	iter->yielded_gfn = iter->next_last_level_gfn;
 	iter->root_level = root_level;
 	iter->min_level = min_level;
 	iter->level = root_level;
@@ -158,23 +159,6 @@ void tdp_iter_next(struct tdp_iter *iter)
 	iter->valid = false;
 }
 
-/*
- * Restart the walk over the paging structure from the root, starting from the
- * highest gfn the iterator had previously reached. Assumes that the entire
- * paging structure, except the root page, may have been completely torn down
- * and rebuilt.
- */
-void tdp_iter_refresh_walk(struct tdp_iter *iter)
-{
-	gfn_t next_last_level_gfn = iter->next_last_level_gfn;
-
-	if (iter->gfn > next_last_level_gfn)
-		next_last_level_gfn = iter->gfn;
-
-	tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
-		       iter->root_level, iter->min_level, next_last_level_gfn);
-}
-
 u64 *tdp_iter_root_pt(struct tdp_iter *iter)
 {
 	return iter->pt_path[iter->root_level - 1];
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index b2dd269c631f..d480c540ee27 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -16,6 +16,12 @@ struct tdp_iter {
 	 * for this GFN.
 	 */
 	gfn_t next_last_level_gfn;
+	/*
+	 * The next_last_level_gfn at the time when the thread last
+	 * yielded. Only yielding when the next_last_level_gfn !=
+	 * yielded_gfn helps ensure forward progress.
+	 */
+	gfn_t yielded_gfn;
 	/* Pointers to the page tables traversed to reach the current SPTE */
 	u64 *pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
@@ -54,7 +60,6 @@ u64 *spte_to_child_pt(u64 pte, int level);
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
-void tdp_iter_refresh_walk(struct tdp_iter *iter);
 u64 *tdp_iter_root_pt(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8f7b120597f3..7cfc0639b1ef 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -451,8 +451,9 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
  * TLB flush before yielding.
  *
  * If this function yields, it will also reset the tdp_iter's walk over the
- * paging structure and the calling function should allow the iterator to
- * continue its traversal from the paging structure root.
+ * paging structure and the calling function should skip to the next
+ * iteration to allow the iterator to continue its traversal from the
+ * paging structure root.
  *
  * Return true if this function yielded and the iterator's traversal was reset.
  * Return false if a yield was not needed.
@@ -460,12 +461,22 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 					     struct tdp_iter *iter, bool flush)
 {
+	/* Ensure forward progress has been made before yielding. */
+	if (iter->next_last_level_gfn == iter->yielded_gfn)
+		return false;
+
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 
 		cond_resched_lock(&kvm->mmu_lock);
-		tdp_iter_refresh_walk(iter);
+
+		WARN_ON(iter->gfn > iter->next_last_level_gfn);
+
+		tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
+			       iter->root_level, iter->min_level,
+			       iter->next_last_level_gfn);
+
 		return true;
 	}
 
@@ -505,8 +516,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		flush_needed = !can_yield ||
-			       !tdp_mmu_iter_cond_resched(kvm, &iter, true);
+		flush_needed = !(can_yield &&
+				 tdp_mmu_iter_cond_resched(kvm, &iter, true));
 	}
 	return flush_needed;
 }
-- 
2.30.0.365.g02bc693789-goog

