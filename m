Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACE74178BC
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347585AbhIXQeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245746AbhIXQdv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCEj/7+h8fYscXtmmTmgpM0XvW941S8ihdw60aLn8xE=;
        b=G78G+RJuhK9IdpGdLz05/BbkCDN1n9Axg+LifAvEyo6vgpZ4dpReX/yLuPf8xlG9atdKwJ
        iBw82yMovvNoKIo9+QaZnwlwcpNOR3qlLzRJzyAzRD+q+EFC/G7hKJcnb0pI+YH+UWHGzg
        4CQE7CuF+WHb9i6MP2Hc70LuSeWo85s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-w7BCKGFoMm-lYfVMAAayHg-1; Fri, 24 Sep 2021 12:32:14 -0400
X-MC-Unique: w7BCKGFoMm-lYfVMAAayHg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B15CA10151E1;
        Fri, 24 Sep 2021 16:32:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF3A67A22B;
        Fri, 24 Sep 2021 16:32:09 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 29/31] KVM: x86/mmu: Avoid memslot lookup in rmap_add
Date:   Fri, 24 Sep 2021 12:31:50 -0400
Message-Id: <20210924163152.289027-30-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Avoid the memslot lookup in rmap_add, by passing it down from the fault
handling code to mmu_set_spte and then to rmap_add.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20210813203504.2742757-6-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 27 +++++++--------------------
 arch/x86/kvm/mmu/paging_tmpl.h | 12 +++++++++---
 2 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4b304f60cf44..7ff2c6c896a8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1625,16 +1625,15 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+		     u64 *spte, gfn_t gfn)
 {
-	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
 	int rmap_count;
 
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(vcpu, spte, rmap_head);
 
@@ -2674,8 +2673,8 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
 	return 0;
 }
 
-static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-			unsigned int pte_access, gfn_t gfn,
+static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+			u64 *sptep, unsigned int pte_access, gfn_t gfn,
 			kvm_pfn_t pfn, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
@@ -2744,24 +2743,12 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (!was_rmapped) {
 		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
 		kvm_update_page_stats(vcpu->kvm, level, 1);
-		rmap_add(vcpu, sptep, gfn);
+		rmap_add(vcpu, slot, sptep, gfn);
 	}
 
 	return ret;
 }
 
-static kvm_pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
-				     bool no_dirty_log)
-{
-	struct kvm_memory_slot *slot;
-
-	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
-	if (!slot)
-		return KVM_PFN_ERR_FAULT;
-
-	return gfn_to_pfn_memslot_atomic(slot, gfn);
-}
-
 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp,
 				    u64 *start, u64 *end)
@@ -2782,7 +2769,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		return -1;
 
 	for (i = 0; i < ret; i++, gfn++, start++) {
-		mmu_set_spte(vcpu, start, access, gfn,
+		mmu_set_spte(vcpu, slot, start, access, gfn,
 			     page_to_pfn(pages[i]), NULL);
 		put_page(pages[i]);
 	}
@@ -2984,7 +2971,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
 		return -EFAULT;
 
-	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
+	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
 			   base_gfn, fault->pfn, fault);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 8c07c42a4d73..44361f7e70c8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -561,6 +561,7 @@ static bool
 FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		     u64 *spte, pt_element_t gpte, bool no_dirty_log)
 {
+	struct kvm_memory_slot *slot;
 	unsigned pte_access;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
@@ -573,12 +574,17 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	gfn = gpte_to_gfn(gpte);
 	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
-	pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
+
+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn,
 			no_dirty_log && (pte_access & ACC_WRITE_MASK));
+	if (!slot)
+		return false;
+
+	pfn = gfn_to_pfn_memslot_atomic(slot, gfn);
 	if (is_error_pfn(pfn))
 		return false;
 
-	mmu_set_spte(vcpu, spte, pte_access, gfn, pfn, NULL);
+	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, pfn, NULL);
 	kvm_release_pfn_clean(pfn);
 	return true;
 }
@@ -757,7 +763,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
 		return -EFAULT;
 
-	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access,
+	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, gw->pte_access,
 			   base_gfn, fault->pfn, fault);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
-- 
2.27.0


