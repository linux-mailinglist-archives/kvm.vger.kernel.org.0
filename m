Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E354178B5
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347603AbhIXQeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347621AbhIXQdu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uKlMdj3BSFySTP+HPdwXzBv1uFuP75/+BZQPXc/8YM4=;
        b=NJrqObtWeNu2+zAAn0MYS5TQ1t6vjkfzFPk0uPEtUnVzDf53RJYhAEFSGRlsCrzqQXBFsX
        f8N3s18koEyaCUONIn6jkYA3nhz/2BBIEvGnvZUSUSBvGddFIvJyN2YJwN672Vl7KvSDed
        SqdEV4UspmcY4F2pycck5d3MR5wNqIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-8EowftFnP0quHWRdeWXYUQ-1; Fri, 24 Sep 2021 12:32:14 -0400
X-MC-Unique: 8EowftFnP0quHWRdeWXYUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCC77A40D8;
        Fri, 24 Sep 2021 16:32:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 672131A26A;
        Fri, 24 Sep 2021 16:32:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 31/31] KVM: MMU: make spte an in-out argument in make_spte
Date:   Fri, 24 Sep 2021 12:31:52 -0400
Message-Id: <20210924163152.289027-32-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the old SPTE in the same variable that receives the new SPTE.  This
reduces the number of arguments from 11 to 10.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 18 ++++++++----------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/spte.c        |  7 ++++---
 arch/x86/kvm/mmu/spte.h        |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c     |  9 +++++----
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 91292009780a..b363433bcd2c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2682,8 +2682,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	int was_rmapped = 0;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
+	u64 spte = *sptep;
 	bool wrprot;
-	u64 spte;
 
 	/* Prefetching always gets a writable pfn.  */
 	bool host_writable = !fault || fault->map_writable;
@@ -2691,35 +2691,33 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	bool write_fault = fault && fault->write;
 
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
-		 *sptep, write_fault, gfn);
+		 spte, write_fault, gfn);
 
 	if (unlikely(is_noslot_pfn(pfn))) {
 		mark_mmio_spte(vcpu, sptep, gfn, pte_access);
 		return RET_PF_EMULATE;
 	}
 
-	if (is_shadow_present_pte(*sptep)) {
+	if (is_shadow_present_pte(spte)) {
 		/*
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
 		 * the parent of the now unreachable PTE.
 		 */
-		if (level > PG_LEVEL_4K && !is_large_pte(*sptep)) {
+		if (level > PG_LEVEL_4K && !is_large_pte(spte)) {
 			struct kvm_mmu_page *child;
-			u64 pte = *sptep;
-
-			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
+			child = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, sptep);
 			flush = true;
-		} else if (pfn != spte_to_pfn(*sptep)) {
+		} else if (pfn != spte_to_pfn(spte)) {
 			pgprintk("hfn old %llx new %llx\n",
-				 spte_to_pfn(*sptep), pfn);
+				 spte_to_pfn(spte), pfn);
 			drop_spte(vcpu->kvm, sptep);
 			flush = true;
 		} else
 			was_rmapped = 1;
 	}
 
-	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, speculative,
+	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, speculative,
 			   true, host_writable, &spte);
 
 	if (*sptep == spte) {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index d8889e02c4b7..88551cfd06c6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1130,7 +1130,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		host_writable = spte & shadow_host_writable_mask;
 		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 		make_spte(vcpu, sp, slot, pte_access, gfn,
-			  spte_to_pfn(spte), spte, true, false,
+			  spte_to_pfn(spte), true, false,
 			  host_writable, &spte);
 
 		flush |= mmu_spte_update(sptep, spte);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 871f6114b0fa..91525388032e 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -92,10 +92,11 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-	       u64 old_spte, bool speculative, bool can_unsync,
-	       bool host_writable, u64 *new_spte)
+	       bool speculative, bool can_unsync,
+	       bool host_writable, u64 *sptep)
 {
 	int level = sp->role.level;
+	u64 old_spte = *sptep;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
 
@@ -187,7 +188,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
 
-	*new_spte = spte;
+	*sptep = spte;
 	return wrprot;
 }
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 7c0b09461349..231531c6015a 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -337,7 +337,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-	       u64 old_spte, bool speculative, bool can_unsync,
+	       bool speculative, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 953f24ded6bc..29b739c7bba4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -903,13 +903,14 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	bool wrprot = false;
 
 	WARN_ON(sp->role.level != fault->goal_level);
-	if (unlikely(!fault->slot))
+	if (unlikely(!fault->slot)) {
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-	else
+	} else {
+		new_spte = iter->old_spte;
 		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefault, true,
+					 fault->pfn, fault->prefault, true,
 					 fault->map_writable, &new_spte);
-
+	}
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
 	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
-- 
2.27.0

