Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EC92F383B
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406197AbhALSMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406172AbhALSM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:27 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB95C06138E
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:18 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id v1so2075659qvb.2
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=SGgrDMzxLeqfoVOYem4hd98mp4oJIORSvgUJGRQH1ZE=;
        b=f9+TNTq/KFjwV9/e7e8MypA8x6fCvXJxiQQW61/gG/fSzMORRDQrhxkbG+wQt9dAu2
         cj8zpvqAlonJwLe6325XkP7u7NiJvsNviz/apA2S6o+5NZvomA714EWu2Z6bEHzWA2V7
         vX/ZKT8culqfmftKZrymcsM0EphooQ+Lt2hsDRVyXDCCcbkubWneI//R6ew0qHyrzUbt
         B2CDL/G6ULMWI7yIiun7KhPivJFzVTmSg2C08cKN40jT8BiC2z3XGm/B10OV8rk0y4xD
         10M36WG5JOD+Yzv7iBOZgAa8J6UzOrFyqYkuTQzTzH5937p7tEliVwrs8GsnnrFzLdBH
         Fldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SGgrDMzxLeqfoVOYem4hd98mp4oJIORSvgUJGRQH1ZE=;
        b=uGozSG5TSh/ZLwzTVJNevaXCZP5gki1gOyO1eq78IPl/8+F5Br2uWkJmA3YdASzJxW
         8blqpiCtRPPs9fiEjE8aJGMHTQTa51Iq2cD0Gg9CNQxd7tiCMcLjSDdW6Ss1XiFLWJhO
         MgTFNXYDV9f16M6hHUYGme4aqc1duttrVZsRI7Bqx34yYEgVEjnKEHhCAKyBfm3KLiMj
         zIP7HfJlM8GYgjqa9HhL6lgb5U3kh16ts2yuoPnRvfSBe2L0GcsT+R1kJJv2IVMLt4YO
         M2STF+aJyrc5anEFOvv4+T2UV/Vli87MM9YVPCsiijjqOGv8AQ76GtAePb2I2DPoPX6n
         CisA==
X-Gm-Message-State: AOAM532XvOKsRuF4/nKVooReoAiWX/fdc8X4Nc0Cdct6IrZzvKQ/oCRy
        XPMGUMykGdbSeKBZVjue4WhHDJYBIM4H
X-Google-Smtp-Source: ABdhPJxTmjafxpsc+KviENVMk1UIaGSaTliWop17fvKgk5AxX9foEZKaMyDrKpGvsf/ASTe+SFh+S2qzxOJs
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a0c:c688:: with SMTP id
 d8mr261688qvj.8.1610475077748; Tue, 12 Jan 2021 10:11:17 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:35 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-19-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 18/24] kvm: x86/mmu: Use an rwlock for the x86 TDP MMU
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

Add a read / write lock to be used in place of the MMU spinlock when the
TDP MMU is enabled. The rwlock will enable the TDP MMU to handle page
faults in parallel in a future commit. In cases where the TDP MMU is not
in use, no operation would be acquiring the lock in read mode, so a
regular spin lock is still used as locking and unlocking a spin lock is
slightly faster.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  8 ++-
 arch/x86/kvm/mmu/mmu.c          | 89 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |  9 ++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 10 ++--
 arch/x86/kvm/x86.c              |  2 -
 virt/kvm/kvm_main.c             | 10 ++--
 6 files changed, 115 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3087de84fad3..92d5340842c8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -902,7 +902,13 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_X2APIC	5
 
 struct kvm_arch {
-	spinlock_t mmu_lock;
+	union {
+		/* Used if the TDP MMU is enabled. */
+		rwlock_t mmu_rwlock;
+
+		/* Used if the TDP MMU is not enabled. */
+		spinlock_t mmu_lock;
+	};
 
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba296ad051c3..280d7cd6f94b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5471,6 +5471,11 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	kvm_mmu_init_tdp_mmu(kvm);
 
+	if (kvm->arch.tdp_mmu_enabled)
+		rwlock_init(&kvm->arch.mmu_rwlock);
+	else
+		spin_lock_init(&kvm->arch.mmu_lock);
+
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
@@ -6074,3 +6079,87 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 	if (kvm->arch.nx_lpage_recovery_thread)
 		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
 }
+
+void kvm_mmu_lock_shared(struct kvm *kvm)
+{
+	WARN_ON(!kvm->arch.tdp_mmu_enabled);
+	read_lock(&kvm->arch.mmu_rwlock);
+}
+
+void kvm_mmu_unlock_shared(struct kvm *kvm)
+{
+	WARN_ON(!kvm->arch.tdp_mmu_enabled);
+	read_unlock(&kvm->arch.mmu_rwlock);
+}
+
+void kvm_mmu_lock_exclusive(struct kvm *kvm)
+{
+	WARN_ON(!kvm->arch.tdp_mmu_enabled);
+	write_lock(&kvm->arch.mmu_rwlock);
+}
+
+void kvm_mmu_unlock_exclusive(struct kvm *kvm)
+{
+	WARN_ON(!kvm->arch.tdp_mmu_enabled);
+	write_unlock(&kvm->arch.mmu_rwlock);
+}
+
+void kvm_mmu_lock(struct kvm *kvm)
+{
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_mmu_lock_exclusive(kvm);
+	else
+		spin_lock(&kvm->arch.mmu_lock);
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_lock);
+
+void kvm_mmu_unlock(struct kvm *kvm)
+{
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_mmu_unlock_exclusive(kvm);
+	else
+		spin_unlock(&kvm->arch.mmu_lock);
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_unlock);
+
+int kvm_mmu_lock_needbreak(struct kvm *kvm)
+{
+	if (kvm->arch.tdp_mmu_enabled)
+		return rwlock_needbreak(&kvm->arch.mmu_rwlock);
+	else
+		return spin_needbreak(&kvm->arch.mmu_lock);
+}
+
+int kvm_mmu_lock_cond_resched_exclusive(struct kvm *kvm)
+{
+	WARN_ON(!kvm->arch.tdp_mmu_enabled);
+	return cond_resched_rwlock_write(&kvm->arch.mmu_rwlock);
+}
+
+int kvm_mmu_lock_cond_resched(struct kvm *kvm)
+{
+	if (kvm->arch.tdp_mmu_enabled)
+		return kvm_mmu_lock_cond_resched_exclusive(kvm);
+	else
+		return cond_resched_lock(&kvm->arch.mmu_lock);
+}
+
+void kvm_mmu_lock_assert_held_shared(struct kvm *kvm)
+{
+	WARN_ON(!kvm->arch.tdp_mmu_enabled);
+	lockdep_assert_held_read(&kvm->arch.mmu_rwlock);
+}
+
+void kvm_mmu_lock_assert_held_exclusive(struct kvm *kvm)
+{
+	WARN_ON(!kvm->arch.tdp_mmu_enabled);
+	lockdep_assert_held_write(&kvm->arch.mmu_rwlock);
+}
+
+void kvm_mmu_lock_assert_held(struct kvm *kvm)
+{
+	if (kvm->arch.tdp_mmu_enabled)
+		lockdep_assert_held(&kvm->arch.mmu_rwlock);
+	else
+		lockdep_assert_held(&kvm->arch.mmu_lock);
+}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index cc8268cf28d2..53a789b8a820 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -149,4 +149,13 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+void kvm_mmu_lock_shared(struct kvm *kvm);
+void kvm_mmu_unlock_shared(struct kvm *kvm);
+void kvm_mmu_lock_exclusive(struct kvm *kvm);
+void kvm_mmu_unlock_exclusive(struct kvm *kvm);
+int kvm_mmu_lock_cond_resched_exclusive(struct kvm *kvm);
+void kvm_mmu_lock_assert_held_shared(struct kvm *kvm);
+void kvm_mmu_lock_assert_held_exclusive(struct kvm *kvm);
+void kvm_mmu_lock_assert_held(struct kvm *kvm);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1d7c01300495..8b61bdb391a0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -59,7 +59,7 @@ static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
 					   struct kvm_mmu_page *root)
 {
-	lockdep_assert_held(&kvm->mmu_lock);
+	kvm_mmu_lock_assert_held_exclusive(kvm);
 
 	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
 		return false;
@@ -117,7 +117,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 
-	kvm_mmu_lock_assert_held(kvm);
+	kvm_mmu_lock_assert_held_exclusive(kvm);
 
 	WARN_ON(root->root_count);
 	WARN_ON(!root->tdp_mmu_page);
@@ -425,7 +425,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
-	kvm_mmu_lock_assert_held(kvm);
+	kvm_mmu_lock_assert_held_exclusive(kvm);
 
 	WRITE_ONCE(*iter->sptep, new_spte);
 
@@ -1139,7 +1139,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 	int root_as_id;
 
-	kvm_mmu_lock_assert_held(kvm);
+	kvm_mmu_lock_assert_held_exclusive(kvm);
 	for_each_tdp_mmu_root(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
@@ -1324,7 +1324,7 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	int root_as_id;
 	bool spte_set = false;
 
-	kvm_mmu_lock_assert_held(kvm);
+	kvm_mmu_lock_assert_held_exclusive(kvm);
 	for_each_tdp_mmu_root(kvm, root) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6cc34e8ccad..302042af87ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10366,8 +10366,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		return -EINVAL;
 
-	spin_lock_init(&kvm->arch.mmu_lock);
-
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d168bd4517d4..dcbdb3beb084 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -432,27 +432,27 @@ void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_destroy);
 
-void kvm_mmu_lock(struct kvm *kvm)
+__weak void kvm_mmu_lock(struct kvm *kvm)
 {
 	spin_lock(&kvm->arch.mmu_lock);
 }
 
-void kvm_mmu_unlock(struct kvm *kvm)
+__weak void kvm_mmu_unlock(struct kvm *kvm)
 {
 	spin_unlock(&kvm->arch.mmu_lock);
 }
 
-int kvm_mmu_lock_needbreak(struct kvm *kvm)
+__weak int kvm_mmu_lock_needbreak(struct kvm *kvm)
 {
 	return spin_needbreak(&kvm->arch.mmu_lock);
 }
 
-int kvm_mmu_lock_cond_resched(struct kvm *kvm)
+__weak int kvm_mmu_lock_cond_resched(struct kvm *kvm)
 {
 	return cond_resched_lock(&kvm->arch.mmu_lock);
 }
 
-void kvm_mmu_lock_assert_held(struct kvm *kvm)
+__weak void kvm_mmu_lock_assert_held(struct kvm *kvm)
 {
 	lockdep_assert_held(&kvm->arch.mmu_lock);
 }
-- 
2.30.0.284.gd98b1dd5eaa7-goog

