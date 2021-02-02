Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39C830CB3E
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbhBBTRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239288AbhBBS74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:59:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2B4C06121C
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:57:58 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f127so24629397ybf.12
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=dElFoNeHiYfE+Clh2h/Ld01Wkmf8wMNyWJL/CRUJm2o=;
        b=nr6Agelw/nIeikKIswusjI6QHczTI7BP2L8ss6Ng/iwcx1l7Gvyqs/+0iJNeDaHI6b
         pppHxuVpNNpdmW0oAfDoruE5z9LaAoaN/5G0N7tYkeUVnzuCVdxNvGv9RuxfIZGpijNF
         Vg//mNSI6BSbh6kwBhFy8c13xNfd9F0NQqQhpPvTDOHKPbXV8qzxBNrf02EjStjIpfNb
         bjuVOHEolnnlgmAxJY7x9PXhcPt1Lk2fWucV+x2Q9UpYOo9rAV9uVnFMDXQ0N+Sti2S1
         0YxfQYxp8tUbNXbXqFEXzY1to/bJ3ugE4CCWUP3HGB1Ny9XhDKeMJEBmrmzRXJzGtbMY
         w9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dElFoNeHiYfE+Clh2h/Ld01Wkmf8wMNyWJL/CRUJm2o=;
        b=j6gEb2dSaigCeHeUlrJftj4r3+/xYk3hWFgc0lldJQk0Dc9sXz0EmlAQ8e3tXtqgPQ
         N89hbdtfm5OJr1kinB56WhUbX8IFvQCsCvwYgFMlF/8yqHsH6SopceCFU/88dcfAvAIl
         varqpSEb6uIMBfJFRXhJPoZAGwrdprL0VzHNXTa8mlSmvImzwksfiHtRbosFNb8ITtpP
         kC4Z07LiHl+eik+Rwj8DfyEvgzo+t45De7ny+pmgexTK9aFoL2dIK07ZWW4SrhcNjtvy
         n85MxBgh8RODgr4irKY+hmiYtMahj2KJRooKK75gO+nvaVbAKzCxuecj4D/gkHqdSvgE
         R/gA==
X-Gm-Message-State: AOAM531s+Bxa2+1v4hb3ZdgeQyv3lPj+jtfsEbirR90GxFAXZjuqmYnE
        VXDwuMiBBXOxF85gnh18/sMHX2FPM7sH
X-Google-Smtp-Source: ABdhPJy3lGkJJpTPbhJWSyiIyOghQNskwzb0YjuAuPVyrowqWyUiNgZ/nWZEXqmNn+hZuu+XFZUHt0fBpw1w
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a25:fc2:: with SMTP id 185mr36753132ybp.385.1612292278050;
 Tue, 02 Feb 2021 10:57:58 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:17 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-12-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 11/28] KVM: x86/mmu: Merge flush and non-flush tdp_mmu_iter_cond_resched
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

The flushing and non-flushing variants of tdp_mmu_iter_cond_resched have
almost identical implementations. Merge the two functions and add a
flush parameter.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 42 ++++++++++++--------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e3066d08c1dc..8f7b120597f3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -443,33 +443,13 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
 			 _mmu->shadow_root_level, _start, _end)
 
-/*
- * Flush the TLB and yield if the MMU lock is contended or this thread needs to
- * return control to the scheduler.
- *
- * If this function yields, it will also reset the tdp_iter's walk over the
- * paging structure and the calling function should allow the iterator to
- * continue its traversal from the paging structure root.
- *
- * Return true if this function yielded, the TLBs were flushed, and the
- * iterator's traversal was reset. Return false if a yield was not needed.
- */
-static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
-{
-	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
-		kvm_flush_remote_tlbs(kvm);
-		cond_resched_lock(&kvm->mmu_lock);
-		tdp_iter_refresh_walk(iter);
-		return true;
-	}
-
-	return false;
-}
-
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
  * to the scheduler.
  *
+ * If this function should yield and flush is set, it will perform a remote
+ * TLB flush before yielding.
+ *
  * If this function yields, it will also reset the tdp_iter's walk over the
  * paging structure and the calling function should allow the iterator to
  * continue its traversal from the paging structure root.
@@ -477,9 +457,13 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
  * Return true if this function yielded and the iterator's traversal was reset.
  * Return false if a yield was not needed.
  */
-static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
+					     struct tdp_iter *iter, bool flush)
 {
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (flush)
+			kvm_flush_remote_tlbs(kvm);
+
 		cond_resched_lock(&kvm->mmu_lock);
 		tdp_iter_refresh_walk(iter);
 		return true;
@@ -522,7 +506,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
 		flush_needed = !can_yield ||
-			       !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+			       !tdp_mmu_iter_cond_resched(kvm, &iter, true);
 	}
 	return flush_needed;
 }
@@ -894,7 +878,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
 
-		tdp_mmu_iter_cond_resched(kvm, &iter);
+		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -953,7 +937,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
 
-		tdp_mmu_iter_cond_resched(kvm, &iter);
+		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 	return spte_set;
 }
@@ -1069,7 +1053,7 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
 		spte_set = true;
 
-		tdp_mmu_iter_cond_resched(kvm, &iter);
+		tdp_mmu_iter_cond_resched(kvm, &iter, false);
 	}
 
 	return spte_set;
@@ -1121,7 +1105,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		spte_set = !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+		spte_set = !tdp_mmu_iter_cond_resched(kvm, &iter, true);
 	}
 
 	if (spte_set)
-- 
2.30.0.365.g02bc693789-goog

