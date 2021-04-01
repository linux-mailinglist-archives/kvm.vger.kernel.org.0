Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B3B352413
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbhDAXiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbhDAXiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:18 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A00C0617AA
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r18so498556pjz.1
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9LiiZ+R6FHph0vhNGb1UlKotPM6pJwcV6i/jHosG5m0=;
        b=DU59UcmTFNPuVP34JMvNCJve87G+GsbCNrmZCEG7UZrO4lQd1A4lrmgQj0gsHuprgd
         GBjQudOBnJkDu/k/tu/vOwrBlt5OyQ7RyhWgQG39rzxFbhlPQBjte8Uy29WglnHMuGKg
         HxmKfAw1RSPrEur/5KipwzdY8I4mv8fiDuhgOifxrSZriiiEzgKbhpS8sInNa2gWS066
         3dwsR0qhkxVT1XqwQkV3GOe4EZF/eDVXJydJFqYDXGUe91khdF8Dps+vnIwOOUsYcS/1
         R5KIOyjxxf4P1sj0RdeXkbZTHmF3ni7jz3OQ0yTelCD/d9YL87Pkha/tPPsezk2KF6Jo
         HQ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9LiiZ+R6FHph0vhNGb1UlKotPM6pJwcV6i/jHosG5m0=;
        b=I+JmEdU4BDcHmLzlW11yTrh+SXyLA9eHRPNNuENZ2hvs628KcOuhW3pAS4ZODt0/eJ
         tWouYMJvBekw5/GceHEJJaxKmasaQaNiQZEfC1SzqpEo2O5ZLJvgpc8APT3VxmEad1LA
         aQaqtQsyYk61IOudQi8XEqHcaBPrvTBqJKmVNVxptiQYfDFcZnJmpnKLhVfsqYYS4yUz
         ZMakQockQYJzHkN4NMQPCNZZQ10kq0zDI9pzvB+yUHyeB5o5ZL6Kc7JQBh3MrYIyCKlr
         SfGV0/wgbPlGhS1z4h5CKy6uXU55fNZC6vLxVdhc5xmBpnVuTiRznzL1zzc8yp+F7eO2
         U9LA==
X-Gm-Message-State: AOAM533Qft4Gta8ILpo/tnxMrHIjTVtgjOklAtf7739xVQ1zIq1MDkOI
        8+GsDol41kTBWr8sw1hdnNX6uyAn/Uw0
X-Google-Smtp-Source: ABdhPJyiMXWmNtDm3v8sqTEtjVj1MRFJ3PeHcEh4AZ6yuQoJLJL93qNI7B7cmyrZUS4EIxxgTTB37eW0zJTk
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1595:b029:217:49e9:2429 with SMTP
 id u21-20020a056a001595b029021749e92429mr9570060pfk.80.1617320293764; Thu, 01
 Apr 2021 16:38:13 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:31 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-9-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 08/13] KVM: x86/mmu: Protect the tdp_mmu_roots list with RCU
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

Changelog
v2:
--	add lockdep condition for tdp_mmu_pages_lock to for_each_tdp_mmu_root
--	fix problem with unexported lockdep function
--	updated comments in kvm_host.h

 arch/x86/include/asm/kvm_host.h | 21 +++++++---
 arch/x86/kvm/mmu/tdp_mmu.c      | 69 +++++++++++++++++++--------------
 2 files changed, 55 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 99778ac51243..e02e8b8a875b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1050,25 +1050,36 @@ struct kvm_arch {
 	bool tdp_mmu_enabled;
 
 	/*
-	 * List of struct kvmp_mmu_pages being used as roots.
+	 * List of struct kvm_mmu_pages being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
 	 * tdp_mmu_page set.
-	 * All struct kvm_mmu_pages in the list should have a positive
-	 * root_count except when a thread holds the MMU lock and is removing
-	 * an entry from the list.
+	 *
+	 * For reads, this list is protected by:
+	 *	the MMU lock in read mode + RCU or
+	 *	the MMU lock in write mode
+	 *
+	 * For writes, this list is protected by:
+	 *	the MMU lock in read mode + the tdp_mmu_pages_lock or
+	 *	the MMU lock in write mode
+	 *
+	 * Roots will remain in the list until their tdp_mmu_root_count
+	 * drops to zero, at which point the thread that decremented the
+	 * count to zero should removed the root from the list and clean
+	 * it up, freeing the root after an RCU grace period.
 	 */
 	struct list_head tdp_mmu_roots;
 
 	/*
 	 * List of struct kvmp_mmu_pages not being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
-	 * tdp_mmu_page set and a root_count of 0.
+	 * tdp_mmu_page set and a tdp_mmu_root_count of 0.
 	 */
 	struct list_head tdp_mmu_pages;
 
 	/*
 	 * Protects accesses to the following fields when the MMU lock
 	 * is held in read mode:
+	 *  - tdp_mmu_roots (above)
 	 *  - tdp_mmu_pages (above)
 	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
 	 *  - lpage_disallowed_mmu_pages
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 886bc170f2a5..c1d7f6b86870 100644
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
 
 	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
 
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
@@ -107,15 +128,17 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * if exiting the loop early, the caller must drop the reference to the most
  * recent root. (Unless keeping a live reference is desirable.)
  */
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)		\
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)	\
 	for (_root = tdp_mmu_next_root(_kvm, NULL);		\
 	     _root;						\
 	     _root = tdp_mmu_next_root(_kvm, _root))		\
 		if (kvm_mmu_page_as_id(_root) != _as_id) {	\
 		} else
 
-#define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
-	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)	\
+#define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
+	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,		\
+				lockdep_is_held_type(&kvm->mmu_lock, 0) ||	\
+				lockdep_is_help(&kvm->arch.tdp_mmu_pages_lock))	\
 		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
@@ -171,28 +194,14 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
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
2.31.0.208.g409f899ff0-goog

