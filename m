Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF9B4178BF
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348026AbhIXQej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347601AbhIXQds (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M3SRFHSZb7PZ5ZlEifZ22IVcTBZ08AU5lJNJjbIr8Ww=;
        b=VY95SIMgMtmapdkFLdltbamYS7CLKCaE5+vhtpgpRXsBcTlszoxJ4SHa2xwQQ6UD9/yUpj
        bUWlxKU2fYxxzAYDmcKroZ8PzMfXF6XWsANW34hF9UnYyunS0/5K6wdVSyEtHbDhfMjcDG
        4R7kgmpGcZOQ7Zvpave1ia+0IdUD7o0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-437JMN2_NQO2sKzGMH3O8Q-1; Fri, 24 Sep 2021 12:32:13 -0400
X-MC-Unique: 437JMN2_NQO2sKzGMH3O8Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBCF1802936;
        Fri, 24 Sep 2021 16:32:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9311A5F707;
        Fri, 24 Sep 2021 16:32:08 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 27/31] KVM: MMU: pass kvm_mmu_page struct to make_spte
Date:   Fri, 24 Sep 2021 12:31:48 -0400
Message-Id: <20210924163152.289027-28-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The level and A/D bit support of the new SPTE can be found in the role,
which is stored in the kvm_mmu_page struct.  This merges two arguments
into one.

For the TDP MMU, the kvm_mmu_page was not used (kvm_tdp_mmu_map does
not use it if the SPTE is already present) so we fetch it just before
calling make_spte.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c         |  4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
 arch/x86/kvm/mmu/spte.c        | 11 ++++++-----
 arch/x86/kvm/mmu/spte.h        |  8 ++++----
 arch/x86/kvm/mmu/tdp_mmu.c     |  7 ++++---
 5 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 91303006faaf..c208f001c302 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2716,8 +2716,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			was_rmapped = 1;
 	}
 
-	wrprot = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
-			   true, host_writable, sp_ad_disabled(sp), &spte);
+	wrprot = make_spte(vcpu, sp, pte_access, gfn, pfn, *sptep, speculative,
+			   true, host_writable, &spte);
 
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7f2c6eeed04f..fbbaa3f5fb4e 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1128,9 +1128,9 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		sptep = &sp->spt[i];
 		spte = *sptep;
 		host_writable = spte & shadow_host_writable_mask;
-		make_spte(vcpu, pte_access, PG_LEVEL_4K, gfn,
+		make_spte(vcpu, sp, pte_access, gfn,
 			  spte_to_pfn(spte), spte, true, false,
-			  host_writable, sp_ad_disabled(sp), &spte);
+			  host_writable, &spte);
 
 		flush |= mmu_spte_update(sptep, spte);
 	}
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 29ea996201b4..2c5c14fbfbe9 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -89,15 +89,16 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
-bool make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
-		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
-		     bool can_unsync, bool host_writable, bool ad_disabled,
-		     u64 *new_spte)
+bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
+	       u64 old_spte, bool speculative, bool can_unsync,
+	       bool host_writable, u64 *new_spte)
 {
+	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
 
-	if (ad_disabled)
+	if (sp->role.ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
 	else if (kvm_vcpu_ad_need_write_protect(vcpu))
 		spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1998ec559196..cbb02a961ac2 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -334,10 +334,10 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-bool make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
-		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
-		     bool can_unsync, bool host_writable, bool ad_disabled,
-		     u64 *new_spte);
+bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
+	       u64 old_spte, bool speculative, bool can_unsync,
+	       bool host_writable, u64 *new_spte);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1cdb5618bb76..6dbf28924bc2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -897,17 +897,18 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 					  struct kvm_page_fault *fault,
 					  struct tdp_iter *iter)
 {
+	struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
 	u64 new_spte;
 	int ret = RET_PF_FIXED;
 	bool wrprot = false;
 
+	WARN_ON(sp->role.level != fault->goal_level);
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
-		wrprot = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
+		wrprot = make_spte(vcpu, sp, ACC_ALL, iter->gfn,
 					 fault->pfn, iter->old_spte, fault->prefault, true,
-					 fault->map_writable, !shadow_accessed_mask,
-					 &new_spte);
+					 fault->map_writable, &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-- 
2.27.0


