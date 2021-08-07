Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA253E35B8
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhHGNuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232479AbhHGNuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3SANztHmHD5Ekd4q9MW+Ip9tyBCnRMJjLy6f52pJEQs=;
        b=iw3pa6Xcc0CsadLGYEQnnuzeILIy6tNKbUHSnzBTROTn6xMK8mo9tQBxFgHzpmR1uit8us
        MEB0F6nCYuWdSokGPOQ9whqdcXJtOES7d6TTb3RgTLCoMTh9ThUqHiMEs7/TSxViy9YNoD
        vGcP8uLZT2/Wf8e9FwMtCBKzB5/XEsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-fS_T2y_4OHitV-lOoibHdQ-1; Sat, 07 Aug 2021 09:49:54 -0400
X-MC-Unique: fS_T2y_4OHitV-lOoibHdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0822D871803;
        Sat,  7 Aug 2021 13:49:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F4F960C13;
        Sat,  7 Aug 2021 13:49:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 11/16] KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:31 -0400
Message-Id: <20210807134936.3083984-12-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to kvm_tdp_mmu_map() instead of
extracting the arguments from the struct.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  3 +--
 arch/x86/kvm/mmu/tdp_mmu.c | 23 +++++++++--------------
 arch/x86/kvm/mmu/tdp_mmu.h |  4 +---
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 624277da4586..75635fc0720d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3916,8 +3916,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		goto out_unlock;
 
 	if (is_tdp_mmu_fault)
-		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, fault->map_writable, fault->max_level,
-				    fault->pfn, fault->prefault);
+		r = kvm_tdp_mmu_map(vcpu, fault);
 	else
 		r = __direct_map(vcpu, fault);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index dab6cb46cdb2..340ae8a34fe3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -994,35 +994,30 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
  */
-int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		    int map_writable, int max_level, kvm_pfn_t pfn,
-		    bool prefault)
+int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	bool write = error_code & PFERR_WRITE_MASK;
-	bool exec = error_code & PFERR_FETCH_MASK;
-	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
+	bool huge_page_disallowed = fault->exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	u64 *child_pt;
 	u64 new_spte;
 	int ret;
-	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int level;
 	int req_level;
 
-	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
+	level = kvm_mmu_hugepage_adjust(vcpu, fault->gfn, fault->max_level, &fault->pfn,
 					huge_page_disallowed, &req_level);
 
-	trace_kvm_mmu_spte_requested(gpa, level, pfn);
+	trace_kvm_mmu_spte_requested(fault->addr, level, fault->pfn);
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
 		if (nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(iter.old_spte, gfn,
-						   iter.level, &pfn, &level);
+			disallowed_hugepage_adjust(iter.old_spte, fault->gfn,
+						   iter.level, &fault->pfn, &level);
 
 		if (iter.level == level)
 			break;
@@ -1078,8 +1073,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		return RET_PF_RETRY;
 	}
 
-	ret = tdp_mmu_map_handle_target_level(vcpu, write, map_writable, &iter,
-					      pfn, prefault);
+	ret = tdp_mmu_map_handle_target_level(vcpu, fault->write, fault->map_writable, &iter,
+					      fault->pfn, fault->prefault);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index b224d126adf9..330d43d09e97 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -51,9 +51,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
 
-int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		    int map_writable, int max_level, kvm_pfn_t pfn,
-		    bool prefault);
+int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush);
-- 
2.27.0


