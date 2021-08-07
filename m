Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0273E35AB
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhHGNuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232441AbhHGNuK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dSBAx1/KaIkWp7WGxSzkRZXEPtEP68RRRe9uePkEl/Y=;
        b=PoYBzRzRnuy2kzjxMQ8qb1SfwGWL7jwop15jEVnm7z00I2qxSeUb7onTPtTq8Nzh5s2pdK
        z60jU2M3KaZksYEpKpuTg9X0t6CXmp9P3RZ/xrKZ6nmDnct1GOQFmksVXmjug13ppjyqYo
        cRBoPpThv9ZjOmDuzsSDqtM7s50lS7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-Nq-4z8B9N1GgBD8s51wxTg-1; Sat, 07 Aug 2021 09:49:48 -0400
X-MC-Unique: Nq-4z8B9N1GgBD8s51wxTg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCDC01835AC5;
        Sat,  7 Aug 2021 13:49:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D1C61700F;
        Sat,  7 Aug 2021 13:49:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 09/16] KVM: MMU: change __direct_map() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:29 -0400
Message-Id: <20210807134936.3083984-10-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to __direct_map() instead of
extracting the arguments from the struct.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cec59ac2e1cd..624277da4586 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2946,34 +2946,29 @@ void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 	}
 }
 
-static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			int map_writable, int max_level, kvm_pfn_t pfn,
-			bool prefault, bool is_tdp)
+static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	bool write = error_code & PFERR_WRITE_MASK;
-	bool exec = error_code & PFERR_FETCH_MASK;
-	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
+	bool huge_page_disallowed = fault->exec && nx_huge_page_workaround_enabled;
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
 	int level, req_level, ret;
-	gfn_t gfn = gpa >> PAGE_SHIFT;
-	gfn_t base_gfn = gfn;
+	gfn_t base_gfn = fault->gfn;
 
-	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
+	level = kvm_mmu_hugepage_adjust(vcpu, fault->gfn, fault->max_level, &fault->pfn,
 					huge_page_disallowed, &req_level);
 
-	trace_kvm_mmu_spte_requested(gpa, level, pfn);
-	for_each_shadow_entry(vcpu, gpa, it) {
+	trace_kvm_mmu_spte_requested(fault->addr, level, fault->pfn);
+	for_each_shadow_entry(vcpu, fault->addr, it) {
 		/*
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
 		if (nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(*it.sptep, gfn, it.level,
-						   &pfn, &level);
+			disallowed_hugepage_adjust(*it.sptep, fault->gfn, it.level,
+						   &fault->pfn, &level);
 
-		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
 			break;
 
@@ -2985,14 +2980,14 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				      it.level - 1, true, ACC_ALL);
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (is_tdp && huge_page_disallowed &&
+		if (fault->is_tdp && huge_page_disallowed &&
 		    req_level >= it.level)
 			account_huge_nx_page(vcpu->kvm, sp);
 	}
 
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
-			   write, level, base_gfn, pfn, prefault,
-			   map_writable);
+			   fault->write, level, base_gfn, fault->pfn,
+			   fault->prefault, fault->map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
@@ -3924,8 +3919,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, fault->map_writable, fault->max_level,
 				    fault->pfn, fault->prefault);
 	else
-		r = __direct_map(vcpu, gpa, error_code, fault->map_writable, fault->max_level,
-		                 fault->pfn, fault->prefault, fault->is_tdp);
+		r = __direct_map(vcpu, fault);
 
 out_unlock:
 	if (is_tdp_mmu_fault)
-- 
2.27.0


