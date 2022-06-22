Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A270F555466
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 21:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358702AbiFVT1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 15:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357800AbiFVT12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 15:27:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E28A3EF38
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655926042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Icd2bHm9cV8SV5qyT0h7qP6LKpzoOygbXj7B8SllL4s=;
        b=hjfEuy6tXvTQMh2LcKRs4JnytSjVsuZWo5sZcCuXcN99YdM/ygsgA/VB9IxjYDYeGB8eR5
        oPyhBVkc2yxIcQ/AcBWtDDyGMUDFO0NoUlo1VqgnGavk595bzcMDKU+cFqivHrAP0OYGtK
        JU62/Yv8YFZY/2g2NGLOIXLFVZhjCx0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-vlLOGiXmNVenQCgvNxbWJA-1; Wed, 22 Jun 2022 15:27:19 -0400
X-MC-Unique: vlLOGiXmNVenQCgvNxbWJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 533E33810784;
        Wed, 22 Jun 2022 19:27:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1B18141510C;
        Wed, 22 Jun 2022 19:27:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     maz@kernel.org, anup@brainfault.org, seanjc@google.com,
        bgardon@google.com, peterx@redhat.com, maciej.szmigiero@oracle.com,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, pfeiner@google.com,
        jiangshanlai@gmail.com, dmatlack@google.com
Subject: [PATCH v7 18/23] KVM: x86/mmu: Extend make_huge_page_split_spte() for the shadow MMU
Date:   Wed, 22 Jun 2022 15:27:05 -0400
Message-Id: <20220622192710.2547152-19-pbonzini@redhat.com>
In-Reply-To: <20220622192710.2547152-1-pbonzini@redhat.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Currently make_huge_page_split_spte() assumes execute permissions can be
granted to any 4K SPTE when splitting huge pages. This is true for the
TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
shadowing a non-executable huge page.

To fix this, pass in the role of the child shadow page where the huge
page will be split and derive the execution permission from that.  This
is correct because huge pages are always split with direct shadow page
and thus the shadow page role contains the correct access permissions.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220516232138.1783324-19-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/spte.c    | 15 +++++++--------
 arch/x86/kvm/mmu/spte.h    |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index db294c1beea2..fb1f17504138 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -246,11 +246,10 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
+u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, union kvm_mmu_page_role role,
 			      int index)
 {
 	u64 child_spte;
-	int child_level;
 
 	if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
 		return 0;
@@ -259,23 +258,23 @@ u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
 		return 0;
 
 	child_spte = huge_spte;
-	child_level = huge_level - 1;
 
 	/*
 	 * The child_spte already has the base address of the huge page being
 	 * split. So we just have to OR in the offset to the page at the next
 	 * lower level for the given index.
 	 */
-	child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
+	child_spte |= (index * KVM_PAGES_PER_HPAGE(role.level)) << PAGE_SHIFT;
 
-	if (child_level == PG_LEVEL_4K) {
+	if (role.level == PG_LEVEL_4K) {
 		child_spte &= ~PT_PAGE_SIZE_MASK;
 
 		/*
-		 * When splitting to a 4K page, mark the page executable as the
-		 * NX hugepage mitigation no longer applies.
+		 * When splitting to a 4K page where execution is allowed, mark
+		 * the page executable as the NX hugepage mitigation no longer
+		 * applies.
 		 */
-		if (is_nx_huge_page_enabled(kvm))
+		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm))
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 256f90587e8d..b5c855f5514f 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -421,8 +421,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
-			      int index);
+u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
+		      	      union kvm_mmu_page_role role, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 522e2532343b..f3a430d64975 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1478,7 +1478,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte, sp->role, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.31.1


