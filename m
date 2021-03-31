Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643453508EE
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhCaVJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhCaVJZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA66C061574
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g9so3579447ybc.19
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4Z5DPHIxBqQOKHjRX3419cZx487AhFXogwK482e92RI=;
        b=pnFNnXTzneAQwsP6VjZ8gYN4fkn7BBGwK3c0UQMOOg/06CR3IRNpdXcbAKffpMwDkW
         ef3PoN6slLj5Y6cOC1SxLy0PbllvEQk8i55k/cLjSU7H1v/69HFIJsmMlvTHAX411m7W
         lptY4GkLRRpfP/QQpXm5MyZXm8hxirUOp4ojMl0j5ot8mm7PRFXlQ+8FUnnOz8B6JV7o
         wrYPCCb7MAf/aBBh+qCPyV8c5yk7jPl5L32mcaYvogBjRlKX8vZVdjHfZ9rr+VwBCyr0
         SH6Q5+jLAN6JtY61UCxQJ24hWhxUUWMvQ3S1YbW3+jFnM/dOn5x3wE9aeIRwV4Y7n1M+
         J2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4Z5DPHIxBqQOKHjRX3419cZx487AhFXogwK482e92RI=;
        b=A1Geg61Vw0IyQdaTeYFRkXOA9lG0RLWOJAAmEQBCiivqctofCG04aljPd/CBbY3+JF
         u/jrbbpDHk/6hZD8ei2K0MFeqiwaU5jEwrDio1hDW7an4B/Fql0vNo5dsGiuR+PfSgdo
         xBwi+swGY2MDK/GaIeWKCWvV0lzTwvCME7Yap6mFnadMGI/v5NxH8vl1E1ZSEKqTKMix
         ACIwzkk3l4nEAYIwxlYmtmNQpPffsuLLm01/rZHYpVSBdiGGecdDNM3HMR8Gwr8TfrO/
         wkIxYKkIjnOxXQ1FLBLVsmxoHRduVUUl1k7vtPbnYzcFtsN6So/FTNOLR1uyGaGFj8jx
         hFDw==
X-Gm-Message-State: AOAM532410hT4zJOKCSc0vBm1rYY/Cjl7Ovn9+O/6KPP34eCcBwo56gj
        P9nkDjNhgH/huuo2yjqSX9KPn0qIOFU3
X-Google-Smtp-Source: ABdhPJzlscKP3kxFyALQEMllJNjDwdOXzrBgvM2BNGOuvLo//Akt+s9hBoFhVGguxvMwQheSeD50kb+gxV6c
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:a25:3346:: with SMTP id
 z67mr7191828ybz.443.1617224962800; Wed, 31 Mar 2021 14:09:22 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:36 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-9-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 08/13] KVM: x86/mmu: Protect the tdp_mmu_roots list with RCU
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

Protect the contents of the TDP MMU roots list with RCU in preparation
for a future patch which will allow the iterator macro to be used under
the MMU lock in read mode.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 64 +++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1f0b2d6124a2..d255125059c4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -50,6 +50,22 @@ static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
+/*
+ * This is called through call_rcu in order to free TDP page table memory
+ * safely with respect to other kernel threads that may be operating on
+ * the memory.
+ * By only accessing TDP MMU page table memory in an RCU read critical
+ * section, and freeing it after a grace period, lockless access to that
+ * memory won't use it after it is freed.
+ */
+static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
+{
+	struct kvm_mmu_page *sp = container_of(head, struct kvm_mmu_page,
+					       rcu_head);
+
+	tdp_mmu_free_sp(sp);
+}
+
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
@@ -61,11 +77,13 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	WARN_ON(!root->tdp_mmu_page);
 
-	list_del(&root->link);
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	list_del_rcu(&root->link);
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 	zap_gfn_range(kvm, root, 0, max_gfn, false);
 
-	tdp_mmu_free_sp(root);
+	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
 /*
@@ -82,18 +100,21 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	rcu_read_lock();
+
 	if (prev_root)
-		next_root = list_next_entry(prev_root, link);
+		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
+						  &prev_root->link,
+						  typeof(*prev_root), link);
 	else
-		next_root = list_first_entry(&kvm->arch.tdp_mmu_roots,
-					     typeof(*next_root), link);
+		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
+						   typeof(*next_root), link);
 
-	while (!list_entry_is_head(next_root, &kvm->arch.tdp_mmu_roots, link) &&
-	       !kvm_tdp_mmu_get_root(kvm, next_root))
-		next_root = list_next_entry(next_root, link);
+	while (next_root && !kvm_tdp_mmu_get_root(kvm, next_root))
+		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
+				&next_root->link, typeof(*next_root), link);
 
-	if (list_entry_is_head(next_root, &kvm->arch.tdp_mmu_roots, link))
-		next_root = NULL;
+	rcu_read_unlock();
 
 	if (prev_root)
 		kvm_tdp_mmu_put_root(kvm, prev_root);
@@ -114,7 +135,8 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 
 /* Only safe under the MMU lock in write mode, without yielding. */
 #define for_each_tdp_mmu_root(_kvm, _root)				\
-	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
+	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,	\
+				lockdep_is_held_write(&kvm->mmu_lock))
 
 static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 						   int level)
@@ -168,28 +190,14 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
-	list_add(&root->link, &kvm->arch.tdp_mmu_roots);
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 out:
 	return __pa(root->spt);
 }
 
-/*
- * This is called through call_rcu in order to free TDP page table memory
- * safely with respect to other kernel threads that may be operating on
- * the memory.
- * By only accessing TDP MMU page table memory in an RCU read critical
- * section, and freeing it after a grace period, lockless access to that
- * memory won't use it after it is freed.
- */
-static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
-{
-	struct kvm_mmu_page *sp = container_of(head, struct kvm_mmu_page,
-					       rcu_head);
-
-	tdp_mmu_free_sp(sp);
-}
-
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
 				bool shared);
-- 
2.31.0.291.g576ba9dcdaf-goog

