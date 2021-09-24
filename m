Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFBA4178CA
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347457AbhIXQfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:35:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347523AbhIXQdm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hw+46V2kp7V9u3BUcpOCTGAvfZpCc2Plm2dlZMhbjLw=;
        b=J8NF7o6fVxBvM4DZENy7it8Qhjh+B9mvO9xtS4Fvjz3fV4GuVv4GFo6OAEvB11ZkSDImuM
        LbZw7qxT95XD5seM0avZCVkWYvNHNvFZsYg9fqNZwHkGX7qpr8gYAbUpGsjOxUntaB7rB4
        Dhf96R1W4nYsbJp0eZWuZybazFHKPVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-hNoy6Ag1MjKNUKE75M5QsA-1; Fri, 24 Sep 2021 12:32:05 -0400
X-MC-Unique: hNoy6Ag1MjKNUKE75M5QsA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35329802921;
        Fri, 24 Sep 2021 16:32:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8DD660E1C;
        Fri, 24 Sep 2021 16:32:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 19/31] KVM: MMU: unify tdp_mmu_map_set_spte_atomic and tdp_mmu_set_spte_atomic_no_dirty_log
Date:   Fri, 24 Sep 2021 12:31:40 -0400
Message-Id: <20210924163152.289027-20-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tdp_mmu_map_set_spte_atomic is not taking care of dirty logging anymore,
the only difference that remains is that it takes a vCPU instead of
the struct kvm.  Merge the two functions.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 40 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b41b6f5ea82b..2d92a5b54ded 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -489,8 +489,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 }
 
 /*
- * tdp_mmu_set_spte_atomic_no_dirty_log - Set a TDP MMU SPTE atomically
- * and handle the associated bookkeeping, but do not mark the page dirty
+ * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically
+ * and handle the associated bookkeeping.  Do not mark the page dirty
  * in KVM's dirty bitmaps.
  *
  * @kvm: kvm instance
@@ -499,9 +499,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  * Returns: true if the SPTE was set, false if it was not. If false is returned,
  *	    this function will have no side-effects.
  */
-static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
-							struct tdp_iter *iter,
-							u64 new_spte)
+static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					   struct tdp_iter *iter,
+					   u64 new_spte)
 {
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
@@ -527,24 +527,6 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
 	return true;
 }
 
-/*
- * tdp_mmu_map_set_spte_atomic - Set a leaf TDP MMU SPTE atomically to resolve a
- * TDP page fault.
- *
- * @vcpu: The vcpu instance that took the TDP page fault.
- * @iter: a tdp_iter instance currently on the SPTE that should be set
- * @new_spte: The value the SPTE should be set to
- *
- * Returns: true if the SPTE was set, false if it was not. If false is returned,
- *	    this function will have no side-effects.
- */
-static inline bool tdp_mmu_map_set_spte_atomic(struct kvm_vcpu *vcpu,
-					       struct tdp_iter *iter,
-					       u64 new_spte)
-{
-	return tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, iter, new_spte);
-}
-
 static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter)
 {
@@ -554,7 +536,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * immediately installing a present entry in its place
 	 * before the TLBs are flushed.
 	 */
-	if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, iter, REMOVED_SPTE))
+	if (!tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE))
 		return false;
 
 	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
@@ -928,7 +910,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-	else if (!tdp_mmu_map_set_spte_atomic(vcpu, iter, new_spte))
+	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
 		return RET_PF_RETRY;
 
 	/*
@@ -1020,7 +1002,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			new_spte = make_nonleaf_spte(child_pt,
 						     !shadow_accessed_mask);
 
-			if (tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, &iter, new_spte)) {
+			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
 				tdp_mmu_link_page(vcpu->kvm, sp,
 						  fault->huge_page_disallowed &&
 						  fault->req_level >= iter.level);
@@ -1208,8 +1190,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
 
-		if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, &iter,
-							  new_spte)) {
+		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
 			/*
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
@@ -1277,8 +1258,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 				continue;
 		}
 
-		if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, &iter,
-							  new_spte)) {
+		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
 			/*
 			 * The iter must explicitly re-read the SPTE because
 			 * the atomic cmpxchg failed.
-- 
2.27.0


