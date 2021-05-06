Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D39375A58
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhEFSod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbhEFSoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:44:18 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD39C06138A
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:43:19 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l19-20020a0ce5130000b02901b6795e3304so4873456qvm.2
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iw/a8Ja/3KurYblK4L1VkCBkw/kvgNKeAvoJlP3V0N4=;
        b=sOcR6WopGmQeOsEVbql1czxjIYXtvwnQfRsQ9Tol6fmEo1JJ8bPTkrMBEsGvyG20Fa
         HDu8Sl1hcFB+B4vi4znrlOA9p0rvXQvFW99L6+Hqsnp6VrMpW6hZU0fE6ULYXoSTKUol
         0uCChy4AQZvw7i3NN/VoQ7FbcioWSHO8+g7kgJ1Kg4jIbLVcSRa8j8X9/zdijZc8t2xF
         DobXZ1IkwUfAP55V1Mcvg/mDvE26XnXcdyNo+Fo5cw403GV9LatgK2OYKM+VvsMiBgEm
         Tt4ZMoAj2ra7Uy97dhOTMAaeP1AW8iDZXD+1AWvO8J32Zl1XJHTyJqiWClVH5WUXvyv4
         cX5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iw/a8Ja/3KurYblK4L1VkCBkw/kvgNKeAvoJlP3V0N4=;
        b=e/Jcfshq0ppTx5WJclm9k+oBCNxKqk3ZMA0uoBCM+wufovK5eTtMrcr6tPsE3LRSQG
         z7NZmyEFAUkeXuUENHPooAdeSvNOQTm9afXTMh74mzzrRuBg8K5oulMjO6B9SX5/56ts
         6Z/BRwCWa1jkz6w+32PiQXckgF7/Blp+NEcwtxDCkdU5ZFseByhwQlNhV9D4ymJCxO3I
         yedCNx3GsKS2Ashb8PWBi0fq7fCvvo3q7V0R+nGMCfBMCphlmPi2jXQN+vZqIkJIfXVL
         Od8a7EkPi9UuY8lBL5OA1Dj1KyBhaMTwv9hirJdqiCDP8LAPYr3ROedMx9gGIa32mIen
         /Z1A==
X-Gm-Message-State: AOAM530L/jrjqtmxGIthtVnqm4xF3Mbl9v5oF/K6IDkSP480XjFeC77R
        jodFtf6tArDjfOpVqXjhZodTWgy4cnrM
X-Google-Smtp-Source: ABdhPJzLQCaK09iohpWRePuwJmaHeqNvzJRKQOMofUmstX0MustmnJ+kXp0rKMpS9TZj3mWEx8UpdIW3VlhS
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9258:9474:54ca:4500])
 (user=bgardon job=sendgmr) by 2002:a0c:ee23:: with SMTP id
 l3mr6174793qvs.55.1620326598310; Thu, 06 May 2021 11:43:18 -0700 (PDT)
Date:   Thu,  6 May 2021 11:42:40 -0700
In-Reply-To: <20210506184241.618958-1-bgardon@google.com>
Message-Id: <20210506184241.618958-8-bgardon@google.com>
Mime-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 7/8] KVM: x86/mmu: Protect rmaps independently with SRCU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for lazily allocating the rmaps when the TDP MMU is in
use, protect the rmaps with SRCU. Unfortunately, this requires
propagating a pointer to struct kvm around to several functions.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 57 +++++++++++++++++++++++++-----------------
 arch/x86/kvm/x86.c     |  6 ++---
 2 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 730ea84bf7e7..48067c572c02 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -927,13 +927,18 @@ static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
 	__pte_list_remove(sptep, rmap_head);
 }
 
-static struct kvm_rmap_head *__gfn_to_rmap(gfn_t gfn, int level,
+static struct kvm_rmap_head *__gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
+					   int level,
 					   struct kvm_memory_slot *slot)
 {
+	struct kvm_rmap_head *head;
 	unsigned long idx;
 
 	idx = gfn_to_index(gfn, slot->base_gfn, level);
-	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
+	head = srcu_dereference_check(slot->arch.rmap[level - PG_LEVEL_4K],
+				      &kvm->srcu,
+				      lockdep_is_held(&kvm->slots_arch_lock));
+	return &head[idx];
 }
 
 static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
@@ -944,7 +949,7 @@ static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
 
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 	slot = __gfn_to_memslot(slots, gfn);
-	return __gfn_to_rmap(gfn, sp->role.level, slot);
+	return __gfn_to_rmap(kvm, gfn, sp->role.level, slot);
 }
 
 static bool rmap_can_add(struct kvm_vcpu *vcpu)
@@ -1194,7 +1199,8 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 		return;
 
 	while (mask) {
-		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+		rmap_head = __gfn_to_rmap(kvm,
+					  slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
 		__rmap_write_protect(kvm, rmap_head, false);
 
@@ -1227,7 +1233,8 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		return;
 
 	while (mask) {
-		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+		rmap_head = __gfn_to_rmap(kvm,
+					  slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
 		__rmap_clear_dirty(kvm, rmap_head, slot);
 
@@ -1270,7 +1277,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 
 	if (kvm_memslots_have_rmaps(kvm)) {
 		for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
-			rmap_head = __gfn_to_rmap(gfn, i, slot);
+			rmap_head = __gfn_to_rmap(kvm, gfn, i, slot);
 			write_protected |= __rmap_write_protect(kvm, rmap_head,
 								true);
 		}
@@ -1373,17 +1380,19 @@ struct slot_rmap_walk_iterator {
 };
 
 static void
-rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
+rmap_walk_init_level(struct kvm *kvm, struct slot_rmap_walk_iterator *iterator,
+		     int level)
 {
 	iterator->level = level;
 	iterator->gfn = iterator->start_gfn;
-	iterator->rmap = __gfn_to_rmap(iterator->gfn, level, iterator->slot);
-	iterator->end_rmap = __gfn_to_rmap(iterator->end_gfn, level,
+	iterator->rmap = __gfn_to_rmap(kvm, iterator->gfn, level,
+				       iterator->slot);
+	iterator->end_rmap = __gfn_to_rmap(kvm, iterator->end_gfn, level,
 					   iterator->slot);
 }
 
 static void
-slot_rmap_walk_init(struct slot_rmap_walk_iterator *iterator,
+slot_rmap_walk_init(struct kvm *kvm, struct slot_rmap_walk_iterator *iterator,
 		    struct kvm_memory_slot *slot, int start_level,
 		    int end_level, gfn_t start_gfn, gfn_t end_gfn)
 {
@@ -1393,7 +1402,7 @@ slot_rmap_walk_init(struct slot_rmap_walk_iterator *iterator,
 	iterator->start_gfn = start_gfn;
 	iterator->end_gfn = end_gfn;
 
-	rmap_walk_init_level(iterator, iterator->start_level);
+	rmap_walk_init_level(kvm, iterator, iterator->start_level);
 }
 
 static bool slot_rmap_walk_okay(struct slot_rmap_walk_iterator *iterator)
@@ -1401,7 +1410,8 @@ static bool slot_rmap_walk_okay(struct slot_rmap_walk_iterator *iterator)
 	return !!iterator->rmap;
 }
 
-static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
+static void slot_rmap_walk_next(struct kvm *kvm,
+				struct slot_rmap_walk_iterator *iterator)
 {
 	if (++iterator->rmap <= iterator->end_rmap) {
 		iterator->gfn += (1UL << KVM_HPAGE_GFN_SHIFT(iterator->level));
@@ -1413,15 +1423,15 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 		return;
 	}
 
-	rmap_walk_init_level(iterator, iterator->level);
+	rmap_walk_init_level(kvm, iterator, iterator->level);
 }
 
-#define for_each_slot_rmap_range(_slot_, _start_level_, _end_level_,	\
-	   _start_gfn, _end_gfn, _iter_)				\
-	for (slot_rmap_walk_init(_iter_, _slot_, _start_level_,		\
-				 _end_level_, _start_gfn, _end_gfn);	\
-	     slot_rmap_walk_okay(_iter_);				\
-	     slot_rmap_walk_next(_iter_))
+#define for_each_slot_rmap_range(_kvm_, _slot_, _start_level_, _end_level_,	\
+				 _start_gfn, _end_gfn, _iter_)			\
+	for (slot_rmap_walk_init(_kvm_, _iter_, _slot_, _start_level_,		\
+				 _end_level_, _start_gfn, _end_gfn);		\
+	     slot_rmap_walk_okay(_iter_);					\
+	     slot_rmap_walk_next(_kvm_, _iter_))
 
 typedef bool (*rmap_handler_t)(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			       struct kvm_memory_slot *slot, gfn_t gfn,
@@ -1434,8 +1444,9 @@ static __always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
 	struct slot_rmap_walk_iterator iterator;
 	bool ret = false;
 
-	for_each_slot_rmap_range(range->slot, PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
-				 range->start, range->end - 1, &iterator)
+	for_each_slot_rmap_range(kvm, range->slot, PG_LEVEL_4K,
+				 KVM_MAX_HUGEPAGE_LEVEL, range->start,
+				 range->end - 1, &iterator)
 		ret |= handler(kvm, iterator.rmap, range->slot, iterator.gfn,
 			       iterator.level, range->pte);
 
@@ -5233,8 +5244,8 @@ slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 {
 	struct slot_rmap_walk_iterator iterator;
 
-	for_each_slot_rmap_range(memslot, start_level, end_level, start_gfn,
-			end_gfn, &iterator) {
+	for_each_slot_rmap_range(kvm, memslot, start_level, end_level,
+				 start_gfn, end_gfn, &iterator) {
 		if (iterator.rmap)
 			flush |= fn(kvm, iterator.rmap, memslot);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7a40ce342cc..1098ab73a704 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10854,9 +10854,9 @@ static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
 		lpages = gfn_to_index(slot->base_gfn + npages - 1,
 				      slot->base_gfn, level) + 1;
 
-		slot->arch.rmap[i] =
-			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
-				 GFP_KERNEL_ACCOUNT);
+		rcu_assign_pointer(slot->arch.rmap[i],
+				   kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
+					    GFP_KERNEL_ACCOUNT));
 		if (!slot->arch.rmap[i])
 			goto out_free;
 	}
-- 
2.31.1.607.g51e8a6a459-goog

