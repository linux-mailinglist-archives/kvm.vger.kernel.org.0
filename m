Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1CD3508E4
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhCaVJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhCaVJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:16 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D429C061574
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:16 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z1so1735288plg.14
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PBC6qMg1yp7zSgTfCYeKU3t37KueZdRSKyb3wsQglII=;
        b=UyDqiSiOfuU7dROlMImswHWa8sAmJwgjp4h9gBc7H7JdTsYYUcf5lJORWi3yz90FMa
         QzMCIQJJRsxCwKGylVZlHvc6uZhUODoWpq4y88BsF/Rt3hz7+cB/nRVbjSpPA1Q38ElT
         iTeIjJxe03YjKCY603aFnf+6vOpW1B4IPwncrSY7mi8/w7uYj+0/1ileCS9vVu2MGZCx
         6PYdMZtXPkteBEJvCFHMSpUgIeto0Lj3r241WZkYMjAUDahPYgK3C/ODuHvAP2y6U+Cg
         WqetLc2fNObcIa0uUAuME6PjT0O8yGEESezvtddatepPlLEtE5O7bgM7KVngzToEya6l
         s2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PBC6qMg1yp7zSgTfCYeKU3t37KueZdRSKyb3wsQglII=;
        b=JR05BQpLjPq7S8KScCSxBUm22K3bbHF1qcbR2b2o7JgeIQpmlXzn3e8A8RNMGbvnsr
         02ZdSE7i49U1KVI5WovVhIzzu/xRatopGllPp/cn/p6jJ4Joen59Tzkl9kSv4dJzRuTv
         OKcchewBNSfgTHrZD9gD8Q4eosp89FYvDujxc8Pge1c8RwIRr4wizTGHkSKHxP74x65Y
         +l3ry+sPwp6jURSFXduVrHR26QPbAv+UidhAb+gVIlRo36g+DF+ZaJ187/0o1t1d9ypo
         dNDbvNiKK1vVZUQTuhR2O3zdEm651tygFnJwbWza+jwb0glP+8EBwBGjK+1P9xhDaWDQ
         9bxA==
X-Gm-Message-State: AOAM533tlQP2SPEhfAHi9oAnQ5r2wF3ywGbRhHN9VRy1jzsF/+EQKpSc
        W5lhxXGFuYkQhPm6Zumve8TZamoUZel7
X-Google-Smtp-Source: ABdhPJyPIMGsEjIi6OVPcEjcHY5de9X+R0pwVamcqyVisnMq5J2A6sncL8zyB5j4kezCMsTCLoDLsUYGZs5g
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:b86:b029:205:c773:5c69 with SMTP
 id g6-20020a056a000b86b0290205c7735c69mr4681713pfj.60.1617224956174; Wed, 31
 Mar 2021 14:09:16 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:34 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-7-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 06/13] KVM: x86/mmu: Refactor yield safe root iterator
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

Refactor the yield safe TDP MMU root iterator to be more amenable to
changes in future commits which will allow it to be used under the MMU
lock in read mode. Currently the iterator requires a complicated dance
between the helper functions and different parts of the for loop which
makes it hard to reason about. Moving all the logic into a single function
simplifies the iterator substantially.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 43 ++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 365fa9f2f856..ab1d26b40164 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -68,26 +68,34 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	tdp_mmu_free_sp(root);
 }
 
-static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
-					   struct kvm_mmu_page *root)
+/*
+ * Finds the next valid root after root (or the first valid root if root
+ * is NULL), takes a reference on it, and returns that next root. If root
+ * is not NULL, this thread should have already taken a reference on it, and
+ * that reference will be dropped. If no valid root is found, this
+ * function will return NULL.
+ */
+static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
+					      struct kvm_mmu_page *prev_root)
 {
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	struct kvm_mmu_page *next_root;
 
-	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
-		return false;
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	kvm_tdp_mmu_get_root(kvm, root);
-	return true;
+	if (prev_root)
+		next_root = list_next_entry(prev_root, link);
+	else
+		next_root = list_first_entry(&kvm->arch.tdp_mmu_roots,
+					     typeof(*next_root), link);
 
-}
+	if (list_entry_is_head(next_root, &kvm->arch.tdp_mmu_roots, link))
+		next_root = NULL;
+	else
+		kvm_tdp_mmu_get_root(kvm, next_root);
 
-static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
-						     struct kvm_mmu_page *root)
-{
-	struct kvm_mmu_page *next_root;
+	if (prev_root)
+		kvm_tdp_mmu_put_root(kvm, prev_root);
 
-	next_root = list_next_entry(root, link);
-	kvm_tdp_mmu_put_root(kvm, root);
 	return next_root;
 }
 
@@ -97,10 +105,9 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * if exiting the loop early, the caller must drop the reference to the most
  * recent root. (Unless keeping a live reference is desirable.)
  */
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)				\
-	for (_root = list_first_entry(&_kvm->arch.tdp_mmu_roots,	\
-				      typeof(*_root), link);		\
-	     tdp_mmu_next_root_valid(_kvm, _root);			\
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)	\
+	for (_root = tdp_mmu_next_root(_kvm, NULL);	\
+	     _root;					\
 	     _root = tdp_mmu_next_root(_kvm, _root))
 
 /* Only safe under the MMU lock in write mode, without yielding. */
-- 
2.31.0.291.g576ba9dcdaf-goog

