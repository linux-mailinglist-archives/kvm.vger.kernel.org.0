Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493562973C2
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751593AbgJWQao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751576AbgJWQam (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Emf4QJ3bhXaHVmzs09mmYMKc8xfp1s/70FDmcTsiE+U=;
        b=aD3g/YJ8c5cWilOpOpiegIO9+MDP/H2yJKXRG0xns0uIlJYQ+a/j/Y8peK9s9eCM8xGNen
        xYtOjcQqGjVmDs6a1Ruw95C+cr2yp3X/swqsqpMvEXQ46Z+HLCjYv7LD2ROuDfewXZUawg
        SwVo68YYwx4em4U28DlxNkmw3MKb9+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-JmtyH64bM-iJWS4dDMCruQ-1; Fri, 23 Oct 2020 12:30:39 -0400
X-MC-Unique: JmtyH64bM-iJWS4dDMCruQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B110805F15;
        Fri, 23 Oct 2020 16:30:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 025DC59;
        Fri, 23 Oct 2020 16:30:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 13/22] kvm: x86/mmu: Allocate struct kvm_mmu_pages for all pages in TDP MMU
Date:   Fri, 23 Oct 2020 12:30:15 -0400
Message-Id: <20201023163024.2765558-14-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Attach struct kvm_mmu_pages to every page in the TDP MMU to track
metadata, facilitate NX reclaim, and enable inproved parallelism of MMU
operations in future patches.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-12-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 13 ++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 082684ce2d1b..d44858b69353 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1004,7 +1004,11 @@ struct kvm_arch {
 	 * operations.
 	 */
 	bool tdp_mmu_enabled;
+
+	/* List of struct tdp_mmu_pages being used as roots */
 	struct list_head tdp_mmu_roots;
+	/* List of struct tdp_mmu_pages not being used as roots */
+	struct list_head tdp_mmu_pages;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ae8ac15b5623..f06802289c1f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -28,6 +28,7 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	kvm->arch.tdp_mmu_enabled = true;
 
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
+	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 }
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
@@ -169,6 +170,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
 	u64 *pt;
+	struct kvm_mmu_page *sp;
 	u64 old_child_spte;
 	int i;
 
@@ -234,6 +236,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
 		pt = spte_to_child_pt(old_spte, level);
+		sp = sptep_to_sp(pt);
+
+		list_del(&sp->link);
 
 		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 			old_child_spte = READ_ONCE(*(pt + i));
@@ -247,6 +252,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 						   KVM_PAGES_PER_HPAGE(level));
 
 		free_page((unsigned long)pt);
+		kmem_cache_free(mmu_page_header_cache, sp);
 	}
 }
 
@@ -424,8 +430,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
-	struct kvm_mmu_memory_cache *pf_pt_cache =
-			&vcpu->arch.mmu_shadow_page_cache;
+	struct kvm_mmu_page *sp;
 	u64 *child_pt;
 	u64 new_spte;
 	int ret;
@@ -471,7 +476,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
-			child_pt = kvm_mmu_memory_cache_alloc(pf_pt_cache);
+			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
+			list_add(&sp->link, &vcpu->kvm->arch.tdp_mmu_pages);
+			child_pt = sp->spt;
 			clear_page(child_pt);
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
-- 
2.26.2


