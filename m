Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B515127935A
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgIYVY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbgIYVXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:15 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC70CC0613CE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:15 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t201so3429141pfc.13
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=kk3ueGPq7p+gjFz0RIiwD9x1NXd/FGzFe2YuGg/svSQ=;
        b=p3PKaxwPe58qwJA1frrDUL5FTykZ3ePCYzl8HIzwpu10qvGAeZbS8HF3j1Dp/DQ8vY
         ctQ5wfy9DQcIEbGGesaY98CHjKsFosVz7nORkVEeA90QLw4hIwoANUG+/w2idD0CpXIm
         18IfwCuyVdm70xewH1IvjGePQdMRjmXyYAOP3fPmLVWsnSD+cXvSlznWPvvrnyrKAI4s
         OFqfrZdnrOZv6C8rB23iTapbKlTxj6IaWymWwpsrCte64I1pIPvKwHOXA/05mSAY44lx
         qDhvD7zfTNw9C1Jd4InJQYLFLP9fUdzHCdg76/Al9+aAMJ6Sc0w6SWw4L20FfpRHcROP
         3w/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kk3ueGPq7p+gjFz0RIiwD9x1NXd/FGzFe2YuGg/svSQ=;
        b=mjfHplTcm1tKMOt6oGHWdUIlX4N0YHMCyrWOYFWtZp0EDwmUqnOTsq5j1J9es7o43P
         U+B4+0IGGT0aX8LAtCrNhtd0jdpTFTU+T5ZJ/mkTYaa1RjBSdH9UldsSRMdE/cKAm9+7
         WFJlHWoZPTRavZLqlMBYqbihQnQjrFXCYfO8nADVxiKDAh4SEExQibRLkJ24c5URIOom
         gr3lm9kanLAJkY+wYWrEvuwF4Mdeo4cXGcbfazVp8u94mSxzpIuh8MTremezT1zNFfgZ
         KqUCzbkGC6ByBSm52T/WSfJeR31gL7rWX728w3p4PfB5Wr4/NM/SICm/Zs76c6XOk2WW
         FXfQ==
X-Gm-Message-State: AOAM532cGYLm+qzqoF5rR5269S27E/eXI2PmJ3b2+mYu/eScUVLLdrNp
        Ccor5NFEtv8VSLFTLWwDDKJHDfUbWhVZ
X-Google-Smtp-Source: ABdhPJwR9dvM8nVvdFvs01UJ1cEgLQklxvw7b6eLPvsCl4tWZ3srPZzLqrc4rXZdvjRACkxMwbXKZr5PMMvm
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:6bc7:b029:d2:6aa:e177 with SMTP id
 m7-20020a1709026bc7b02900d206aae177mr1291393plt.52.1601068995232; Fri, 25 Sep
 2020 14:23:15 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:44 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-5-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 04/22] kvm: mmu: Allocate and free TDP MMU roots
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

The TDP MMU must be able to allocate paging structure root pages and track
the usage of those pages. Implement a similar, but separate system for root
page allocation to that of the x86 shadow paging implementation. When
future patches add synchronization model changes to allow for parallel
page faults, these pages will need to be handled differently from the
x86 shadow paging based MMU's root pages.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/mmu/mmu.c          |  27 +++---
 arch/x86/kvm/mmu/mmu_internal.h |   9 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 157 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   5 +
 5 files changed, 188 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35107819f48ae..9ce6b35ecb33a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -972,6 +972,7 @@ struct kvm_arch {
 	 * operations.
 	 */
 	bool tdp_mmu_enabled;
+	struct list_head tdp_mmu_roots;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0cb0c26939dfc..0f871e36394da 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -170,11 +170,6 @@ module_param(dbg, bool, 0644);
 #define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
 			| shadow_x_mask | shadow_nx_mask | shadow_me_mask)
 
-#define ACC_EXEC_MASK    1
-#define ACC_WRITE_MASK   PT_WRITABLE_MASK
-#define ACC_USER_MASK    PT_USER_MASK
-#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
-
 /* The mask for the R/X bits in EPT PTEs */
 #define PT64_EPT_READABLE_MASK			0x1ull
 #define PT64_EPT_EXECUTABLE_MASK		0x4ull
@@ -232,7 +227,7 @@ struct kvm_shadow_walk_iterator {
 	     __shadow_walk_next(&(_walker), spte))
 
 static struct kmem_cache *pte_list_desc_cache;
-static struct kmem_cache *mmu_page_header_cache;
+struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
 static u64 __read_mostly shadow_nx_mask;
@@ -3597,10 +3592,14 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (!VALID_PAGE(*root_hpa))
 		return;
 
-	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
-	--sp->root_count;
-	if (!sp->root_count && sp->role.invalid)
-		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+	if (is_tdp_mmu_root(kvm, *root_hpa)) {
+		kvm_tdp_mmu_put_root_hpa(kvm, *root_hpa);
+	} else {
+		sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
+		--sp->root_count;
+		if (!sp->root_count && sp->role.invalid)
+			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+	}
 
 	*root_hpa = INVALID_PAGE;
 }
@@ -3691,7 +3690,13 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	unsigned i;
 
 	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
+		if (vcpu->kvm->arch.tdp_mmu_enabled) {
+			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
+		} else {
+			root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
+					      true);
+		}
+
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
 		vcpu->arch.mmu->root_hpa = root;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 65bb110847858..530b7d893c7b3 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -41,8 +41,12 @@ struct kvm_mmu_page {
 
 	/* Number of writes since the last time traversal visited this page.  */
 	atomic_t write_flooding_count;
+
+	bool tdp_mmu_page;
 };
 
+extern struct kmem_cache *mmu_page_header_cache;
+
 static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
 {
 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
@@ -69,6 +73,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
+#define ACC_EXEC_MASK    1
+#define ACC_WRITE_MASK   PT_WRITABLE_MASK
+#define ACC_USER_MASK    PT_USER_MASK
+#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
+
 /* Functions for interpreting SPTEs */
 kvm_pfn_t spte_to_pfn(u64 pte);
 bool is_mmio_spte(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8241e18c111e6..cdca829e42040 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1,5 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#include "mmu.h"
+#include "mmu_internal.h"
 #include "tdp_mmu.h"
 
 static bool __read_mostly tdp_mmu_enabled = true;
@@ -25,10 +27,165 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 
 	/* This should not be changed for the lifetime of the VM. */
 	kvm->arch.tdp_mmu_enabled = true;
+
+	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 }
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
 	if (!kvm->arch.tdp_mmu_enabled)
 		return;
+
+	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
+}
+
+#define for_each_tdp_mmu_root(_kvm, _root)			    \
+	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
+
+bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
+{
+	struct kvm_mmu_page *root;
+
+	if (!kvm->arch.tdp_mmu_enabled)
+		return false;
+
+	root = to_shadow_page(hpa);
+
+	if (WARN_ON(!root))
+		return false;
+
+	return root->tdp_mmu_page;
+}
+
+static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	WARN_ON(root->root_count);
+	WARN_ON(!root->tdp_mmu_page);
+
+	list_del(&root->link);
+
+	free_page((unsigned long)root->spt);
+	kmem_cache_free(mmu_page_header_cache, root);
+}
+
+static void put_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	root->root_count--;
+	if (!root->root_count)
+		free_tdp_mmu_root(kvm, root);
+}
+
+static void get_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+	WARN_ON(!root->root_count);
+
+	root->root_count++;
+}
+
+void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa)
+{
+	struct kvm_mmu_page *root;
+
+	root = to_shadow_page(root_hpa);
+
+	if (WARN_ON(!root))
+		return;
+
+	put_tdp_mmu_root(kvm, root);
+}
+
+static struct kvm_mmu_page *find_tdp_mmu_root_with_role(
+		struct kvm *kvm, union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *root;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	for_each_tdp_mmu_root(kvm, root) {
+		WARN_ON(!root->root_count);
+
+		if (root->role.word == role.word)
+			return root;
+	}
+
+	return NULL;
+}
+
+static struct kvm_mmu_page *alloc_tdp_mmu_root(struct kvm_vcpu *vcpu,
+					       union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *new_root;
+	struct kvm_mmu_page *root;
+
+	new_root = kvm_mmu_memory_cache_alloc(
+			&vcpu->arch.mmu_page_header_cache);
+	new_root->spt = kvm_mmu_memory_cache_alloc(
+			&vcpu->arch.mmu_shadow_page_cache);
+	set_page_private(virt_to_page(new_root->spt), (unsigned long)new_root);
+
+	new_root->role.word = role.word;
+	new_root->root_count = 1;
+	new_root->gfn = 0;
+	new_root->tdp_mmu_page = true;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+
+	/* Check that no matching root exists before adding this one. */
+	root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
+	if (root) {
+		get_tdp_mmu_root(vcpu->kvm, root);
+		spin_unlock(&vcpu->kvm->mmu_lock);
+		free_page((unsigned long)new_root->spt);
+		kmem_cache_free(mmu_page_header_cache, new_root);
+		return root;
+	}
+
+	list_add(&new_root->link, &vcpu->kvm->arch.tdp_mmu_roots);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	return new_root;
+}
+
+static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_page *root;
+	union kvm_mmu_page_role role;
+
+	role = vcpu->arch.mmu->mmu_role.base;
+	role.level = vcpu->arch.mmu->shadow_root_level;
+	role.direct = true;
+	role.gpte_is_8_bytes = true;
+	role.access = ACC_ALL;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+
+	/* Search for an already allocated root with the same role. */
+	root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
+	if (root) {
+		get_tdp_mmu_root(vcpu->kvm, root);
+		spin_unlock(&vcpu->kvm->mmu_lock);
+		return root;
+	}
+
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	/* If there is no appropriate root, allocate one. */
+	root = alloc_tdp_mmu_root(vcpu, role);
+
+	return root;
+}
+
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_page *root;
+
+	root = get_tdp_mmu_vcpu_root(vcpu);
+	if (!root)
+		return INVALID_PAGE;
+
+	return __pa(root->spt);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index dd3764f5a9aa3..9274debffeaa1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -7,4 +7,9 @@
 
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
+
+bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
+void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
+
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

