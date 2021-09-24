Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416404178A2
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347670AbhIXQd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45965 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347471AbhIXQdi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VMuVaBochSFOwf/ZbsumPEtyj8pbV/icadyDgmPszOI=;
        b=CTPLYUd/k84yG/LOHfcKcIjGwhuaYPPLoMW/BPkS6wHJGPc89Bms4TTzd3Sran9RwLJHNk
        Ofe6zuubrcWKKp5O5c0ATopfFRkrEZLgQPXwhQ4kWZ0/5PQvzujot3nFOXWm88/bNkCs/w
        OKRPB2hHPfWC+ebNyKeOilVxtR3pGkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-v81-rekTPTySIhk5Z9B8mw-1; Fri, 24 Sep 2021 12:32:02 -0400
X-MC-Unique: v81-rekTPTySIhk5Z9B8mw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8474E10168C0;
        Fri, 24 Sep 2021 16:32:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23D6160E1C;
        Fri, 24 Sep 2021 16:32:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 14/31] KVM: MMU: change disallowed_hugepage_adjust() arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:35 -0400
Message-Id: <20210924163152.289027-15-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to disallowed_hugepage_adjust() instead of
extracting the arguments from the struct.  Tweak a bit the conditions
to avoid long lines.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c          | 19 ++++++++-----------
 arch/x86/kvm/mmu/mmu_internal.h |  3 +--
 arch/x86/kvm/mmu/paging_tmpl.h  |  3 +--
 arch/x86/kvm/mmu/tdp_mmu.c      |  3 +--
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 877d0bda0f5e..7491dc685842 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2957,12 +2957,10 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	fault->pfn &= ~mask;
 }
 
-void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
-				kvm_pfn_t *pfnp, u8 *goal_levelp)
+void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level)
 {
-	int level = *goal_levelp;
-
-	if (cur_level == level && level > PG_LEVEL_4K &&
+	if (cur_level > PG_LEVEL_4K &&
+	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
 		/*
@@ -2972,10 +2970,10 @@ void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 		 * patching back for them into pfn the next 9 bits of
 		 * the address.
 		 */
-		u64 page_mask = KVM_PAGES_PER_HPAGE(level) -
-				KVM_PAGES_PER_HPAGE(level - 1);
-		*pfnp |= gfn & page_mask;
-		(*goal_levelp)--;
+		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
+				KVM_PAGES_PER_HPAGE(cur_level - 1);
+		fault->pfn |= fault->gfn & page_mask;
+		fault->goal_level--;
 	}
 }
 
@@ -2995,8 +2993,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * large page, as the leaf could be executable.
 		 */
 		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(*it.sptep, fault->gfn, it.level,
-						   &fault->pfn, &fault->goal_level);
+			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
 
 		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == fault->goal_level)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ae0c7bc3b19b..f0295ad51f69 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -159,8 +159,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
 			      kvm_pfn_t pfn, int max_level);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
-				kvm_pfn_t *pfnp, u8 *goal_levelp);
+void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 20f616963ff4..4a263f4511a5 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -740,8 +740,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * large page, as the leaf could be executable.
 		 */
 		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(*it.sptep, fault->gfn, it.level,
-						   &fault->pfn, &fault->goal_level);
+			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
 
 		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == fault->goal_level)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b48256b88930..737af596adaf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1001,8 +1001,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
 		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(iter.old_spte, fault->gfn,
-						   iter.level, &fault->pfn, &fault->goal_level);
+			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
 		if (iter.level == fault->goal_level)
 			break;
-- 
2.27.0


