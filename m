Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904592973C4
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751600AbgJWQap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751547AbgJWQah (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bvBa2lKKk81VHS9Ew+tuuP4bWoHVeVZHGHp/bxf4ZPI=;
        b=GHQGaClpoVBJ5TEQFPowxPY+iMS0LmSfzP2RfbfoGn1T/1pMHuCLLFwJAfWNS7IogY2cdh
        iLcD/RqQaxDNnMeC32E03mHYnMhhZgrFDRs1w2y+TGlTE0ttfLWaBlGrrhJ8j3jAQqPARb
        unL+69iIlxynA7asPG+9QqBfw6iE23U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-5ouCjrRtPfqk-bqDqFIQoQ-1; Fri, 23 Oct 2020 12:30:29 -0400
X-MC-Unique: 5ouCjrRtPfqk-bqDqFIQoQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B70B886ABDE;
        Fri, 23 Oct 2020 16:30:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 576F25D9E2;
        Fri, 23 Oct 2020 16:30:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 07/22] kvm: x86/mmu: Allocate and free TDP MMU roots
Date:   Fri, 23 Oct 2020 12:30:09 -0400
Message-Id: <20201023163024.2765558-8-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/mmu/mmu.c          |  24 ++++++--
 arch/x86/kvm/mmu/mmu_internal.h |  20 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 102 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   5 ++
 5 files changed, 146 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f6d47ac74a52..082684ce2d1b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1004,6 +1004,7 @@ struct kvm_arch {
 	 * operations.
 	 */
 	bool tdp_mmu_enabled;
+	struct list_head tdp_mmu_roots;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2afaf17284bb..017d37b19cf3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -185,7 +185,7 @@ struct kvm_shadow_walk_iterator {
 	     __shadow_walk_next(&(_walker), spte))
 
 static struct kmem_cache *pte_list_desc_cache;
-static struct kmem_cache *mmu_page_header_cache;
+struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
@@ -3132,9 +3132,13 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 		return;
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
-	--sp->root_count;
-	if (!sp->root_count && sp->role.invalid)
-		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+
+	if (kvm_mmu_put_root(kvm, sp)) {
+		if (sp->tdp_mmu_page)
+			kvm_tdp_mmu_free_root(kvm, sp);
+		else if (sp->role.invalid)
+			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
+	}
 
 	*root_hpa = INVALID_PAGE;
 }
@@ -3224,8 +3228,16 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	hpa_t root;
 	unsigned i;
 
-	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
+	if (vcpu->kvm->arch.tdp_mmu_enabled) {
+		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
+
+		if (!VALID_PAGE(root))
+			return -ENOSPC;
+		vcpu->arch.mmu->root_hpa = root;
+	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
+		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
+				      true);
+
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
 		vcpu->arch.mmu->root_hpa = root;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index fc72f199eaa6..6665b10288ce 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -55,8 +55,12 @@ struct kvm_mmu_page {
 
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
@@ -89,4 +93,20 @@ void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
 
+static inline void kvm_mmu_get_root(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	BUG_ON(!sp->root_count);
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	++sp->root_count;
+}
+
+static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+	--sp->root_count;
+
+	return !sp->root_count;
+}
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e567e8aa61a1..76ebb5898dd7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1,6 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include "mmu.h"
+#include "mmu_internal.h"
 #include "tdp_mmu.h"
+#include "spte.h"
 
 static bool __read_mostly tdp_mmu_enabled = false;
 
@@ -21,10 +24,109 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 
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
+	struct kvm_mmu_page *sp;
+
+	sp = to_shadow_page(hpa);
+
+	return sp->tdp_mmu_page && sp->root_count;
+}
+
+void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
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
+static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
+						   int level)
+{
+	union kvm_mmu_page_role role;
+
+	role = vcpu->arch.mmu->mmu_role.base;
+	role.level = level;
+	role.direct = true;
+	role.gpte_is_8_bytes = true;
+	role.access = ACC_ALL;
+
+	return role;
+}
+
+static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					       int level)
+{
+	struct kvm_mmu_page *sp;
+
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
+	sp->role.word = page_role_for_level(vcpu, level).word;
+	sp->gfn = gfn;
+	sp->tdp_mmu_page = true;
+
+	return sp;
+}
+
+static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
+{
+	union kvm_mmu_page_role role;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page *root;
+
+	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
+
+	spin_lock(&kvm->mmu_lock);
+
+	/* Check for an existing root before allocating a new one. */
+	for_each_tdp_mmu_root(kvm, root) {
+		if (root->role.word == role.word) {
+			kvm_mmu_get_root(kvm, root);
+			spin_unlock(&kvm->mmu_lock);
+			return root;
+		}
+	}
+
+	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
+	root->root_count = 1;
+
+	list_add(&root->link, &kvm->arch.tdp_mmu_roots);
+
+	spin_unlock(&kvm->mmu_lock);
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
index cd4a562a70e9..ac0ef9129442 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -7,4 +7,9 @@
 
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
+
+bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
+void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
+
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


