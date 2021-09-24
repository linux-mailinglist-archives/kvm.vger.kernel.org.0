Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588394178C5
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347543AbhIXQez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347548AbhIXQdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NpwC6c5NDCljwZYCew7GNN1KVUMlsp4jxSAuaDjFF1g=;
        b=RGGAVikNbn450U80MzQAddcYVKwjLd7U6c1KXBmB46ittZ84pz2+Rrq5tblJOlxt1stWux
        RQQbnke30qSXJ9TBXAm7Hi2u7K1yQfI8T7VqmpFYRCbZsP15gKJXmb3tYUlHZ/YDNQsMZ0
        e4nhju3YvdDim3wF9ozXQ/KInjuLQGM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-L0QToi1XNkGdv1lxgYm8tQ-1; Fri, 24 Sep 2021 12:32:08 -0400
X-MC-Unique: L0QToi1XNkGdv1lxgYm8tQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 489949F955;
        Fri, 24 Sep 2021 16:32:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 769C97B6F3;
        Fri, 24 Sep 2021 16:32:06 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 23/31] KVM: MMU: inline set_spte in FNAME(sync_page)
Date:   Fri, 24 Sep 2021 12:31:44 -0400
Message-Id: <20210924163152.289027-24-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the two callers of set_spte do different things with the results,
inlining it actually makes the code simpler to reason about.  For example,
FNAME(sync_page) already has a struct kvm_mmu_page *, but set_spte had to
fish it back out of sptep's private page data.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         | 21 ---------------------
 arch/x86/kvm/mmu/paging_tmpl.h | 21 ++++++++++++---------
 2 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6ba7c60bd4f8..19c2fd2189a3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2674,27 +2674,6 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
 	return 0;
 }
 
-static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-		    unsigned int pte_access, int level,
-		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
-		    bool can_unsync, bool host_writable)
-{
-	u64 spte;
-	struct kvm_mmu_page *sp;
-	int ret;
-
-	sp = sptep_to_sp(sptep);
-
-	ret = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
-			can_unsync, host_writable, sp_ad_disabled(sp), &spte);
-
-	if (*sptep == spte)
-		ret |= SET_SPTE_SPURIOUS;
-	else if (mmu_spte_update(sptep, spte))
-		ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
-	return ret;
-}
-
 static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			unsigned int pte_access, bool write_fault, int level,
 			gfn_t gfn, kvm_pfn_t pfn, bool speculative,
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e4c7bf3deac8..500962dceda0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1061,7 +1061,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	int i;
 	bool host_writable;
 	gpa_t first_pte_gpa;
-	int set_spte_ret = 0;
+	bool flush = false;
 
 	/*
 	 * Ignore various flags when verifying that it's safe to sync a shadow
@@ -1091,6 +1091,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+		u64 *sptep, spte;
 		unsigned pte_access;
 		pt_element_t gpte;
 		gpa_t pte_gpa;
@@ -1106,7 +1107,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			return -1;
 
 		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
-			set_spte_ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
+			flush = true;
 			continue;
 		}
 
@@ -1120,19 +1121,21 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 		if (gfn != sp->gfns[i]) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
-			set_spte_ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
+			flush = true;
 			continue;
 		}
 
-		host_writable = sp->spt[i] & shadow_host_writable_mask;
+		sptep = &sp->spt[i];
+		spte = *sptep;
+		host_writable = spte & shadow_host_writable_mask;
+		make_spte(vcpu, pte_access, PG_LEVEL_4K, gfn,
+			  spte_to_pfn(spte), spte, true, false,
+			  host_writable, sp_ad_disabled(sp), &spte);
 
-		set_spte_ret |= set_spte(vcpu, &sp->spt[i],
-					 pte_access, PG_LEVEL_4K,
-					 gfn, spte_to_pfn(sp->spt[i]),
-					 true, false, host_writable);
+		flush |= mmu_spte_update(sptep, spte);
 	}
 
-	return set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH;
+	return flush;
 }
 
 #undef pt_element_t
-- 
2.27.0


