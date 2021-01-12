Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7E72F383D
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406398AbhALSO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406135AbhALSMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:25 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24931C06138A
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:15 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id m8so2085829qvk.1
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=lYSk7MOddYKWjNX3MxEIYz0vLNaYEHnCnR3+/yAINXw=;
        b=NKHnnTd7jpdNfSK6bP6++NsuIw0k1dByDPu7R62QtqGk9cZov5lC1ZdIKgrHYqkdCq
         O+2dgK9s8JHUTSGLSBK1za1HRCgZPrMOgbdIcJy/9el/kMdhoQ1sG666QH9DWiGcbJqK
         SsANBDgOzW+6iREdYcJhDBBTxN5TgtJEdFd4BOJ3xg6Ascaz1j5400bsKZ74pyyZvT8D
         rsOpa4bVKxZE8qW2zCPRCpEvvJwe6wA/6j/8QYIUFZnx5X0IHqtZexLxW5AiPG+Bf3cv
         qGBYy9P3zlhf/Tl6W+O0mihrfRTW/R+eKV/cBCTpDyVCAnI8xQ3BpkyfaPGdKG/eauBc
         HZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lYSk7MOddYKWjNX3MxEIYz0vLNaYEHnCnR3+/yAINXw=;
        b=HWbvzl4Z8OPA10m+S2dSpZIcVie/EeZ4SgFN6WlwBSDk09FWQAKXAoWBHkTQLoeept
         4mvamHvERDJgQha+Ry88NQShVsplTzYI3n2I2BB0k6LHszP7F0IYq8eUJ9DdsqmrJv++
         LJrJYmuVN2FPxx7OWMpFy4fXg/uT1LzeQw8BmoccTJ9a+xZFqVaCh9fxXF+89UXxUxgB
         IS2hyrDZDrLLDkeaBPQ2ygTFxKoBS9Ho8GPWQZSekZt90PziAbUAxhJY1zZKp6FKJ+q+
         TrxdFQnhBN+uBCmzCOi4FQMLyaENYHicejV205x0AH35U/adxWRxqXSDpAOUwIueVspQ
         EZJA==
X-Gm-Message-State: AOAM530X0Re6bGZfyx3rC0nLNv83Dca/fRUOrC3yJt5e+L1J41Bv0Xag
        veclrM/P0gEbYy43kHXj6IlymwRNYblZ
X-Google-Smtp-Source: ABdhPJwYwzAWMtBQK6mILE8NEYAUYZdTPRPkm/F7Ns0Y++eItf45aU6HhfxEeu4QJg7N1rYh67ntpkm7bfn+
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a05:6214:14ee:: with SMTP id
 k14mr670741qvw.36.1610475074199; Tue, 12 Jan 2021 10:11:14 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:33 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-17-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 16/24] kvm: mmu: Wrap mmu_lock assertions
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

Wrap assertions and warnings checking the MMU lock state in a function
which uses lockdep_assert_held. While the existing checks use a few
different functions to check the lock state, they are all better off
using lockdep_assert_held. This will support a refactoring to move the
mmu_lock to struct kvm_arch so that it can be replaced with an rwlock for
x86.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/arm64/kvm/mmu.c                     | 2 +-
 arch/powerpc/include/asm/kvm_book3s_64.h | 7 +++----
 arch/powerpc/kvm/book3s_hv_nested.c      | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h          | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c               | 8 ++++----
 include/linux/kvm_host.h                 | 1 +
 virt/kvm/kvm_main.c                      | 5 +++++
 7 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 57ef1ec23b56..8b54eb58bf47 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -130,7 +130,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 	struct kvm *kvm = mmu->kvm;
 	phys_addr_t end = start + size;
 
-	assert_spin_locked(&kvm->mmu_lock);
+	kvm_mmu_lock_assert_held(kvm);
 	WARN_ON(size & ~PAGE_MASK);
 	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
 				   may_block));
diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 9bb9bb370b53..db2e437cd97c 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -650,8 +650,8 @@ static inline pte_t *find_kvm_secondary_pte(struct kvm *kvm, unsigned long ea,
 {
 	pte_t *pte;
 
-	VM_WARN(!spin_is_locked(&kvm->mmu_lock),
-		"%s called with kvm mmu_lock not held \n", __func__);
+	kvm_mmu_lock_assert_held(kvm);
+
 	pte = __find_linux_pte(kvm->arch.pgtable, ea, NULL, hshift);
 
 	return pte;
@@ -662,8 +662,7 @@ static inline pte_t *find_kvm_host_pte(struct kvm *kvm, unsigned long mmu_seq,
 {
 	pte_t *pte;
 
-	VM_WARN(!spin_is_locked(&kvm->mmu_lock),
-		"%s called with kvm mmu_lock not held \n", __func__);
+	kvm_mmu_lock_assert_held(kvm);
 
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		return NULL;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 18890dca9476..6d5987d1eee7 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -767,8 +767,7 @@ pte_t *find_kvm_nested_guest_pte(struct kvm *kvm, unsigned long lpid,
 	if (!gp)
 		return NULL;
 
-	VM_WARN(!spin_is_locked(&kvm->mmu_lock),
-		"%s called with kvm mmu_lock not held \n", __func__);
+	kvm_mmu_lock_assert_held(kvm);
 	pte = __find_linux_pte(gp->shadow_pgtable, ea, NULL, hshift);
 
 	return pte;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 7f599cc64178..cc8268cf28d2 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -101,14 +101,14 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 static inline void kvm_mmu_get_root(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	BUG_ON(!sp->root_count);
-	lockdep_assert_held(&kvm->mmu_lock);
+	kvm_mmu_lock_assert_held(kvm);
 
 	++sp->root_count;
 }
 
 static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	lockdep_assert_held(&kvm->mmu_lock);
+	kvm_mmu_lock_assert_held(kvm);
 	--sp->root_count;
 
 	return !sp->root_count;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index fb911ca428b2..1d7c01300495 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -117,7 +117,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 
-	lockdep_assert_held(&kvm->mmu_lock);
+	kvm_mmu_lock_assert_held(kvm);
 
 	WARN_ON(root->root_count);
 	WARN_ON(!root->tdp_mmu_page);
@@ -425,7 +425,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
-	lockdep_assert_held(&kvm->mmu_lock);
+	kvm_mmu_lock_assert_held(kvm);
 
 	WRITE_ONCE(*iter->sptep, new_spte);
 
@@ -1139,7 +1139,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 	int root_as_id;
 
-	lockdep_assert_held(&kvm->mmu_lock);
+	kvm_mmu_lock_assert_held(kvm);
 	for_each_tdp_mmu_root(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
@@ -1324,7 +1324,7 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	int root_as_id;
 	bool spte_set = false;
 
-	lockdep_assert_held(&kvm->mmu_lock);
+	kvm_mmu_lock_assert_held(kvm);
 	for_each_tdp_mmu_root(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6e2773fc406c..022e3522788f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1499,5 +1499,6 @@ void kvm_mmu_lock(struct kvm *kvm);
 void kvm_mmu_unlock(struct kvm *kvm);
 int kvm_mmu_lock_needbreak(struct kvm *kvm);
 int kvm_mmu_lock_cond_resched(struct kvm *kvm);
+void kvm_mmu_lock_assert_held(struct kvm *kvm);
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b4c49a7e0556..c504f876176b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -452,6 +452,11 @@ int kvm_mmu_lock_cond_resched(struct kvm *kvm)
 	return cond_resched_lock(&kvm->mmu_lock);
 }
 
+void kvm_mmu_lock_assert_held(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+}
+
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 {
-- 
2.30.0.284.gd98b1dd5eaa7-goog

