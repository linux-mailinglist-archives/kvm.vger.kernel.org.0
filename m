Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD244178A5
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347707AbhIXQeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347449AbhIXQdf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aOkh/YDw6uKk05Fxu4AFHMf1zAj1AcDPF64k2N/TzyI=;
        b=ENq2WjrkVIo5EUM8HA7AfdCj3QUkNSXzg4ZqXo1nSZKI7nmOvlZ34PFuJiuYRVXdWOzX61
        SSlTIABq9iCgqz1fwNL0q6/LV4KIBKHtSBTJAVu5AhPKXpNSoSsCqkvwQ7HfGOHy9n1Zfj
        kd3cxxd+MOzT/dwRX9oRh8fkz/eAQNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-nKbmq4W2PQGYoENwfTIJ7w-1; Fri, 24 Sep 2021 12:32:00 -0400
X-MC-Unique: nKbmq4W2PQGYoENwfTIJ7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75EE5802921;
        Fri, 24 Sep 2021 16:31:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06F5160E1C;
        Fri, 24 Sep 2021 16:31:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 10/31] KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:31 -0400
Message-Id: <20210924163152.289027-11-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
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
index c84e978d76b0..b2020b481db2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3988,8 +3988,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		goto out_unlock;
 
 	if (is_tdp_mmu_fault)
-		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, fault->map_writable, fault->max_level,
-				    fault->pfn, fault->prefault);
+		r = kvm_tdp_mmu_map(vcpu, fault);
 	else
 		r = __direct_map(vcpu, fault);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7a5a24ca50e4..4a5bb0b5b639 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -985,35 +985,30 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
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
@@ -1069,8 +1064,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		return RET_PF_RETRY;
 	}
 
-	ret = tdp_mmu_map_handle_target_level(vcpu, write, map_writable, &iter,
-					      pfn, prefault);
+	ret = tdp_mmu_map_handle_target_level(vcpu, fault->write, fault->map_writable, &iter,
+					      fault->pfn, fault->prefault);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 358f447d4012..ceaf7ff3ca7c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -48,9 +48,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
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


