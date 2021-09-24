Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8574178B9
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347575AbhIXQe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40135 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245724AbhIXQdv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qh1B2i1Rhu568JvyL1IfKN6z2KqhpSoBFJjMW5wzoUw=;
        b=fP05YCAQRANgA8n8R1kZvJa49fJpHkTQiK2P7x6FqG3sNFzmjBUvL3lSlAdsnzu+vhyEN8
        FsF2gAEZzpsHwsGHDcWnrxgstN9uDfiHRtTCTOTxn+iw8VHVJkEgrBfKqbfwEC8Ikqpzn9
        GVZT+VJHiYYGfSNZ0KqjWGjY7RCUcRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-wIOoZpZWNre5As5B8tSnqQ-1; Fri, 24 Sep 2021 12:32:14 -0400
X-MC-Unique: wIOoZpZWNre5As5B8tSnqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FE23101520E;
        Fri, 24 Sep 2021 16:32:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9857426FD4;
        Fri, 24 Sep 2021 16:32:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 30/31] KVM: x86/mmu: Avoid memslot lookup in make_spte and mmu_try_to_unsync_pages
Date:   Fri, 24 Sep 2021 12:31:51 -0400
Message-Id: <20210924163152.289027-31-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

mmu_try_to_unsync_pages checks if page tracking is active for the given
gfn, which requires knowing the memslot. We can pass down the memslot
via make_spte to avoid this lookup.

The memslot is also handy for make_spte's marking of the gfn as dirty:
we can test whether dirty page tracking is enabled, and if so ensure that
pages are mapped as writable with 4K granularity.  Apart from the warning,
no functional change is intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20210813203504.2742757-7-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_page_track.h |  2 --
 arch/x86/kvm/mmu/mmu.c                |  8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h       |  4 ++--
 arch/x86/kvm/mmu/page_track.c         | 14 +++-----------
 arch/x86/kvm/mmu/paging_tmpl.h        |  4 +++-
 arch/x86/kvm/mmu/spte.c               | 10 +++++++---
 arch/x86/kvm/mmu/spte.h               |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c            |  2 +-
 8 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 9cd9230e5cc8..5c12f97ce934 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -59,8 +59,6 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
 				     enum kvm_page_track_mode mode);
-bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
-			      enum kvm_page_track_mode mode);
 bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
 				   enum kvm_page_track_mode mode);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7ff2c6c896a8..91292009780a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2572,8 +2572,8 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
  * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
  * be write-protected.
  */
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
-			    bool speculative)
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+			    gfn_t gfn, bool can_unsync, bool speculative)
 {
 	struct kvm_mmu_page *sp;
 	bool locked = false;
@@ -2583,7 +2583,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(slot, gfn, KVM_PAGE_TRACK_WRITE))
 		return -EPERM;
 
 	/*
@@ -2719,7 +2719,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			was_rmapped = 1;
 	}
 
-	wrprot = make_spte(vcpu, sp, pte_access, gfn, pfn, *sptep, speculative,
+	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, speculative,
 			   true, host_writable, &spte);
 
 	if (*sptep == spte) {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 94f4e754facb..585146a712d2 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -118,8 +118,8 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	       kvm_x86_ops.cpu_dirty_log_size;
 }
 
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
-			    bool speculative);
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+			    gfn_t gfn, bool can_unsync, bool speculative);
 
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 859800f7bb95..16e7176c97a5 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -136,6 +136,9 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
 
+/*
+ * check if the corresponding access on the specified guest page is tracked.
+ */
 bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
 				   enum kvm_page_track_mode mode)
 {
@@ -151,17 +154,6 @@ bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
 	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
 }
 
-/*
- * check if the corresponding access on the specified guest page is tracked.
- */
-bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
-			      enum kvm_page_track_mode mode)
-{
-	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-
-	return kvm_slot_page_track_is_active(slot, gfn, mode);
-}
-
 void kvm_page_track_cleanup(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_head *head;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 44361f7e70c8..d8889e02c4b7 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1091,6 +1091,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
 		u64 *sptep, spte;
+		struct kvm_memory_slot *slot;
 		unsigned pte_access;
 		pt_element_t gpte;
 		gpa_t pte_gpa;
@@ -1127,7 +1128,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		sptep = &sp->spt[i];
 		spte = *sptep;
 		host_writable = spte & shadow_host_writable_mask;
-		make_spte(vcpu, sp, pte_access, gfn,
+		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+		make_spte(vcpu, sp, slot, pte_access, gfn,
 			  spte_to_pfn(spte), spte, true, false,
 			  host_writable, &spte);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 2c5c14fbfbe9..871f6114b0fa 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -90,6 +90,7 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 }
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+	       struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool speculative, bool can_unsync,
 	       bool host_writable, u64 *new_spte)
@@ -160,7 +161,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync, speculative)) {
+		if (mmu_try_to_unsync_pages(vcpu, slot, gfn, can_unsync, speculative)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			wrprot = true;
@@ -180,8 +181,11 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
 
-	if (spte & PT_WRITABLE_MASK)
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
+	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
+		/* Enforced by kvm_mmu_hugepage_adjust. */
+		WARN_ON(level > PG_LEVEL_4K);
+		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
+	}
 
 	*new_spte = spte;
 	return wrprot;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index cbb02a961ac2..7c0b09461349 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -335,6 +335,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 }
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+	       struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool speculative, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6dbf28924bc2..953f24ded6bc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -906,7 +906,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
-		wrprot = make_spte(vcpu, sp, ACC_ALL, iter->gfn,
+		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
 					 fault->pfn, iter->old_spte, fault->prefault, true,
 					 fault->map_writable, &new_spte);
 
-- 
2.27.0


