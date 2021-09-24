Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E01541789A
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347547AbhIXQdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240890AbhIXQdh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rz/Vf8tbLm/4wCgxOLN7tHvCDtkpYSCxy0LZsmFDSpE=;
        b=PaehmCcm2a9h8JovsZS9T+zqNq5FUCrxLvzFNIZebrB4iCtbPuzi2AJvVmPv0dl2Bd3LKj
        YrMS6JMoGxZyp9qW1BQ2/2+iBMBbi33bYs0d08g4XmCVk+fKB87hSK5Y7UXzmV2g9uHmuw
        Y3KmuyyTXNDs17odkDfJInJ9/HAtRqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-eDkFffTwPeqVhDRixTbJhg-1; Fri, 24 Sep 2021 12:31:59 -0400
X-MC-Unique: eDkFffTwPeqVhDRixTbJhg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93B13801E72;
        Fri, 24 Sep 2021 16:31:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 201D560E1C;
        Fri, 24 Sep 2021 16:31:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 09/31] KVM: MMU: change FNAME(fetch)() arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:30 -0400
Message-Id: <20210924163152.289027-10-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to FNAME(fetch)() instead of
extracting the arguments from the struct.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 52 ++++++++++++++--------------------
 1 file changed, 22 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0fa7a678b907..afd2ad8c5173 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -655,21 +655,18 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
  * If the guest tries to write a write-protected page, we need to
  * emulate this operation, return 1 to indicate this case.
  */
-static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
-			 struct guest_walker *gw, u32 error_code,
-			 int max_level, kvm_pfn_t pfn, bool map_writable,
-			 bool prefault)
+static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			 struct guest_walker *gw)
 {
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	bool write_fault = error_code & PFERR_WRITE_MASK;
-	bool exec = error_code & PFERR_FETCH_MASK;
-	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
+	bool huge_page_disallowed = fault->exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
 	unsigned int direct_access, access;
 	int top_level, level, req_level, ret;
-	gfn_t base_gfn = gw->gfn;
+	gfn_t base_gfn = fault->gfn;
 
+	WARN_ON_ONCE(gw->gfn != base_gfn);
 	direct_access = gw->pte_access;
 
 	top_level = vcpu->arch.mmu->root_level;
@@ -687,7 +684,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		goto out_gpte_changed;
 
-	for (shadow_walk_init(&it, vcpu, addr);
+	for (shadow_walk_init(&it, vcpu, fault->addr);
 	     shadow_walk_okay(&it) && it.level > gw->level;
 	     shadow_walk_next(&it)) {
 		gfn_t table_gfn;
@@ -699,7 +696,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
 			access = gw->pt_access[it.level - 2];
-			sp = kvm_mmu_get_page(vcpu, table_gfn, addr,
+			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
 					      it.level-1, false, access);
 			/*
 			 * We must synchronize the pagetable before linking it
@@ -733,10 +730,10 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
-	level = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn,
+	level = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, fault->max_level, &fault->pfn,
 					huge_page_disallowed, &req_level);
 
-	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
+	trace_kvm_mmu_spte_requested(fault->addr, gw->level, fault->pfn);
 
 	for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
 		clear_sp_write_flooding_count(it.sptep);
@@ -746,10 +743,10 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		 * large page, as the leaf could be executable.
 		 */
 		if (nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(*it.sptep, gw->gfn, it.level,
-						   &pfn, &level);
+			disallowed_hugepage_adjust(*it.sptep, fault->gfn, it.level,
+						   &fault->pfn, &level);
 
-		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
 			break;
 
@@ -758,7 +755,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		drop_large_spte(vcpu, it.sptep);
 
 		if (!is_shadow_present_pte(*it.sptep)) {
-			sp = kvm_mmu_get_page(vcpu, base_gfn, addr,
+			sp = kvm_mmu_get_page(vcpu, base_gfn, fault->addr,
 					      it.level - 1, true, direct_access);
 			link_shadow_page(vcpu, it.sptep, sp);
 			if (huge_page_disallowed && req_level >= it.level)
@@ -766,8 +763,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		}
 	}
 
-	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, write_fault,
-			   it.level, base_gfn, pfn, prefault, map_writable);
+	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, fault->write,
+			   it.level, base_gfn, fault->pfn, fault->prefault,
+			   fault->map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
@@ -835,26 +833,21 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
  */
 static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	gpa_t addr = fault->addr;
-	u32 error_code = fault->error_code;
 	struct guest_walker walker;
 	int r;
 	unsigned long mmu_seq;
 	bool is_self_change_mapping;
 
-	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
+	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
 	WARN_ON_ONCE(fault->is_tdp);
 
 	/*
+	 * Look up the guest pte for the faulting address.
 	 * If PFEC.RSVD is set, this is a shadow page fault.
 	 * The bit needs to be cleared before walking guest page tables.
 	 */
-	error_code &= ~PFERR_RSVD_MASK;
-
-	/*
-	 * Look up the guest pte for the faulting address.
-	 */
-	r = FNAME(walk_addr)(&walker, vcpu, addr, error_code);
+	r = FNAME(walk_addr)(&walker, vcpu, fault->addr,
+			     fault->error_code & ~PFERR_RSVD_MASK);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
@@ -869,7 +862,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	fault->gfn = walker.gfn;
 	if (page_fault_handle_page_track(vcpu, fault)) {
-		shadow_page_table_clear_flood(vcpu, addr);
+		shadow_page_table_clear_flood(vcpu, fault->addr);
 		return RET_PF_EMULATE;
 	}
 
@@ -924,8 +917,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = FNAME(fetch)(vcpu, addr, &walker, error_code, fault->max_level, fault->pfn,
-			 fault->map_writable, fault->prefault);
+	r = FNAME(fetch)(vcpu, fault, &walker);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-- 
2.27.0


