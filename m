Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A29A41789E
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347432AbhIXQdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347485AbhIXQdj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rmh4YsaPjXFJ2ELrTjnFVSxl2tlTnu7mmZrKo2rtHDk=;
        b=O7vvumSNNAEpEN18wL8MXrZkfWFQx48ZRqen4qArOUnHHNQkQu225mLlkEW2sl1MiqW6vG
        tKY7JzyIHq+a44gNMtNde4+kN67mjoEQeQq+KECxWePWpry0lvE2kmsZ5mQe8khZMEngx/
        MQOltVTVJ8yR5+Mqjg0O+nDYAkAE3f8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-qaPt0-9qMfuwOtlet9N5MA-1; Fri, 24 Sep 2021 12:32:04 -0400
X-MC-Unique: qaPt0-9qMfuwOtlet9N5MA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3678D10168C6;
        Fri, 24 Sep 2021 16:32:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C97EF60E1C;
        Fri, 24 Sep 2021 16:32:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 17/31] KVM: x86/mmu: Fold rmap_recycle into rmap_add
Date:   Fri, 24 Sep 2021 12:31:38 -0400
Message-Id: <20210924163152.289027-18-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Consolidate rmap_recycle and rmap_add into a single function since they
are only ever called together (and only from one place). This has a nice
side effect of eliminating an extra kvm_vcpu_gfn_to_memslot(). In
addition it makes mmu_set_spte(), which is a very long function, a
little shorter.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20210813203504.2742757-3-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2ddbabad5bd2..8b6dc276935f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1071,20 +1071,6 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	return kvm_mmu_memory_cache_nr_free_objects(mc);
 }
 
-static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
-{
-	struct kvm_memory_slot *slot;
-	struct kvm_mmu_page *sp;
-	struct kvm_rmap_head *rmap_head;
-
-	sp = sptep_to_sp(spte);
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	return pte_list_add(vcpu, spte, rmap_head);
-}
-
-
 static void rmap_remove(struct kvm *kvm, u64 *spte)
 {
 	struct kvm_memslots *slots;
@@ -1097,9 +1083,9 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 
 	/*
-	 * Unlike rmap_add and rmap_recycle, rmap_remove does not run in the
-	 * context of a vCPU so have to determine which memslots to use based
-	 * on context information in sp->role.
+	 * Unlike rmap_add, rmap_remove does not run in the context of a vCPU
+	 * so we have to determine which memslots to use based on context
+	 * information in sp->role.
 	 */
 	slots = kvm_memslots_for_spte_role(kvm, sp->role);
 
@@ -1639,19 +1625,24 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
-	struct kvm_rmap_head *rmap_head;
 	struct kvm_mmu_page *sp;
+	struct kvm_rmap_head *rmap_head;
+	int rmap_count;
 
 	sp = sptep_to_sp(spte);
+	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
+	rmap_count = pte_list_add(vcpu, spte, rmap_head);
 
-	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
-	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
-			KVM_PAGES_PER_HPAGE(sp->role.level));
+	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
+		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		kvm_flush_remote_tlbs_with_address(
+				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+	}
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -2713,7 +2704,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			bool host_writable)
 {
 	int was_rmapped = 0;
-	int rmap_count;
 	int set_spte_ret;
 	int ret = RET_PF_FIXED;
 	bool flush = false;
@@ -2772,9 +2762,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	if (!was_rmapped) {
 		kvm_update_page_stats(vcpu->kvm, level, 1);
-		rmap_count = rmap_add(vcpu, sptep, gfn);
-		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-			rmap_recycle(vcpu, sptep, gfn);
+		rmap_add(vcpu, sptep, gfn);
 	}
 
 	return ret;
-- 
2.27.0


