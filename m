Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3C24178AB
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347771AbhIXQeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347566AbhIXQdp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GTogtUZapQH1IOFeY6BrBepqa21A5XNaqz5dVvZ4Lo0=;
        b=BvooGQb+D9Qx+EMhwArr5xTHJw88PN+QJkp+VSn01+V7dAWUU3yKRkkQCWtgy0tOHfYOJu
        rLo5CofYpESSYlD03voTXaDYHVVBvihaR+W+2x/10CE5waB2CqqrlYUtGMQbHXDzWRSwxI
        sn8tOsPTBAqugmCNYPE3o6r6jgvjRGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-9Bwbwqb_M-6SREC2P4MDCg-1; Fri, 24 Sep 2021 12:32:06 -0400
X-MC-Unique: 9Bwbwqb_M-6SREC2P4MDCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF19E10168E7;
        Fri, 24 Sep 2021 16:32:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F4EF60E1C;
        Fri, 24 Sep 2021 16:32:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 18/31] KVM: MMU: mark page dirty in make_spte
Date:   Fri, 24 Sep 2021 12:31:39 -0400
Message-Id: <20210924163152.289027-19-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This simplifies set_spte, which we want to remove, and unifies code
between the shadow MMU and the TDP MMU.  The warning will be added
back later to make_spte as well.

There is a small disadvantage in the TDP MMU; it may unnecessarily mark
a page as dirty twice if two vCPUs end up mapping the same page twice.
However, this is a very small cost for a case that is already rare.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  3 ---
 arch/x86/kvm/mmu/spte.c    |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c | 21 +--------------------
 3 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8b6dc276935f..5a757953b98b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2688,9 +2688,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	ret = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
 			can_unsync, host_writable, sp_ad_disabled(sp), &spte);
 
-	if (spte & PT_WRITABLE_MASK)
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-
 	if (*sptep == spte)
 		ret |= SET_SPTE_SPURIOUS;
 	else if (mmu_spte_update(sptep, spte))
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index a33c581aabd6..66be9452ded1 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -179,6 +179,9 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
 
+	if (spte & PT_WRITABLE_MASK)
+		kvm_vcpu_mark_page_dirty(vcpu, gfn);
+
 	*new_spte = spte;
 	return ret;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3bf85a8c7d15..b41b6f5ea82b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -542,26 +542,7 @@ static inline bool tdp_mmu_map_set_spte_atomic(struct kvm_vcpu *vcpu,
 					       struct tdp_iter *iter,
 					       u64 new_spte)
 {
-	struct kvm *kvm = vcpu->kvm;
-
-	if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, iter, new_spte))
-		return false;
-
-	/*
-	 * Use kvm_vcpu_gfn_to_memslot() instead of going through
-	 * handle_changed_spte_dirty_log() to leverage vcpu->last_used_slot.
-	 */
-	if (is_writable_pte(new_spte)) {
-		struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, iter->gfn);
-
-		if (slot && kvm_slot_dirty_track_enabled(slot)) {
-			/* Enforced by kvm_mmu_hugepage_adjust. */
-			WARN_ON_ONCE(iter->level > PG_LEVEL_4K);
-			mark_page_dirty_in_slot(kvm, slot, iter->gfn);
-		}
-	}
-
-	return true;
+	return tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, iter, new_spte);
 }
 
 static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
-- 
2.27.0


