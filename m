Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042933E35B0
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhHGNuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232466AbhHGNuP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d634BjerRQ0prjk8gwF44k7ug5WEMmjQYlsELGRwJsI=;
        b=CEWa8hLz9gUPZS2wVoybY4Tsu5Fbb1k4lUIKrl1sUfZkJa5BepKz86cAvFjSf5oO7ESPLy
        jPjNPWnbpnAbdHUN5bky6fWa4jX72BujMty7/MfWqFo3FXkynQopUKVzJaMrEv46DM0y4N
        U/J45isRtCUlnWZcZSDFbCI/Rsp0RJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-wMMDwLYKPF6FXGPYrgabyw-1; Sat, 07 Aug 2021 09:49:56 -0400
X-MC-Unique: wMMDwLYKPF6FXGPYrgabyw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88D6C760C5;
        Sat,  7 Aug 2021 13:49:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BBC260C13;
        Sat,  7 Aug 2021 13:49:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 15/16] KVM: MMU: change disallowed_hugepage_adjust() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:35 -0400
Message-Id: <20210807134936.3083984-16-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
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
index 6df7da9d1d77..a41325f452f4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2921,12 +2921,10 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
@@ -2936,10 +2934,10 @@ void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
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
 
@@ -2959,8 +2957,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * large page, as the leaf could be executable.
 		 */
 		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(*it.sptep, fault->gfn, it.level,
-						   &fault->pfn, &fault->goal_level);
+			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
 
 		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == fault->goal_level)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index f84e0e90e442..c80d89242c45 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -155,8 +155,7 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
 			      kvm_pfn_t pfn, int max_level);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
-				kvm_pfn_t *pfnp, u8 *goal_levelp);
+void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index add1b41b0f1a..3f82f469abdf 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -729,8 +729,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * large page, as the leaf could be executable.
 		 */
 		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(*it.sptep, fault->gfn, it.level,
-						   &fault->pfn, &fault->goal_level);
+			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
 
 		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == fault->goal_level)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f0a9009dff96..803da0334933 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1010,8 +1010,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
 		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(iter.old_spte, fault->gfn,
-						   iter.level, &fault->pfn, &fault->goal_level);
+			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
 		if (iter.level == fault->goal_level)
 			break;
-- 
2.27.0


