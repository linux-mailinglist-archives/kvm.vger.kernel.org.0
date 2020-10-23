Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368332973BC
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751509AbgJWQab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750702AbgJWQab (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pu5pTTwDQG7Y2LlVE/UD0j9Vgozx1GRFAEtYr8veM/0=;
        b=Xr7yPuHWva8hBXl5mlTSd7L4lOKHNlb75oa7WaMeH/kTT9qJTdNislYmjVotBn8pOqhPET
        NGXeoChcRv0O/CRswHDLBDPFZBu+gzyG2/0EXmUibOFCQQy/fZnUomX9hW+GRhVL2ggnjb
        qr342/01Gk1XOnknwgRYrkI3VFwFkTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-25jy23OHOsm_xqWT5wge5w-1; Fri, 23 Oct 2020 12:30:27 -0400
X-MC-Unique: 25jy23OHOsm_xqWT5wge5w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 866A21891E92;
        Fri, 23 Oct 2020 16:30:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 266EF5D9E2;
        Fri, 23 Oct 2020 16:30:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 03/22] KVM: mmu: Separate updating a PTE from kvm_set_pte_rmapp
Date:   Fri, 23 Oct 2020 12:30:05 -0400
Message-Id: <20201023163024.2765558-4-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDP MMU's own function for the changed-PTE notifier will need to be
update a PTE in the exact same way as the shadow MMU.  Rather than
re-implementing this logic, factor the SPTE creation out of kvm_set_pte_rmapp.

Extracted out of a patch by Ben Gardon. <bgardon@google.com>

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef4a63af8fce..3dec4744ab9c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1747,6 +1747,21 @@ static int kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return kvm_zap_rmapp(kvm, rmap_head);
 }
 
+static u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
+{
+	u64 new_spte;
+
+	new_spte = old_spte & ~PT64_BASE_ADDR_MASK;
+	new_spte |= (u64)new_pfn << PAGE_SHIFT;
+
+	new_spte &= ~PT_WRITABLE_MASK;
+	new_spte &= ~SPTE_HOST_WRITEABLE;
+
+	new_spte = mark_spte_for_access_track(new_spte);
+
+	return new_spte;
+}
+
 static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			     struct kvm_memory_slot *slot, gfn_t gfn, int level,
 			     unsigned long data)
@@ -1772,13 +1787,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			pte_list_remove(rmap_head, sptep);
 			goto restart;
 		} else {
-			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
-			new_spte |= (u64)new_pfn << PAGE_SHIFT;
-
-			new_spte &= ~PT_WRITABLE_MASK;
-			new_spte &= ~SPTE_HOST_WRITEABLE;
-
-			new_spte = mark_spte_for_access_track(new_spte);
+			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
+					*sptep, new_pfn);
 
 			mmu_spte_clear_track_bits(sptep);
 			mmu_spte_set(sptep, new_spte);
-- 
2.26.2


