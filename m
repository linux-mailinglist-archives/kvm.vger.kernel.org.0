Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E684178A6
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347694AbhIXQeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347451AbhIXQdf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J0oBXEA2ewwfwa5QNevePAfo75fkcq/4Rn3rSv4/dRA=;
        b=MUWNX46LS5TC2QG88bMq+CQHv/JeMA0ilWoExzSCnuspujwCB5B1Nhw6JKMAzMfLhZBKbW
        a/vCbvXHxD+AE7C1pkVLr5fcs4QTIYmJCwV0zMxJW5mL4mrXaqZaiU8vzuiVtqMa9lyjZe
        vu0uRbSt4N6FUFxorkdeHKVPPHkCWg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-5tjOYHzzOm-Aba6ZfTE8kg-1; Fri, 24 Sep 2021 12:32:01 -0400
X-MC-Unique: 5tjOYHzzOm-Aba6ZfTE8kg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF2D010168D3;
        Fri, 24 Sep 2021 16:31:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F4595FCAE;
        Fri, 24 Sep 2021 16:31:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 11/31] KVM: MMU: change tdp_mmu_map_handle_target_level() arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:32 -0400
Message-Id: <20210924163152.289027-12-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to tdp_mmu_map_handle_target_level() instead of
extracting the arguments from the struct.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4a5bb0b5b639..6cfba8c28ea2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -929,21 +929,20 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
  * Installs a last-level SPTE to handle a TDP page fault.
  * (NPT/EPT violation/misconfiguration)
  */
-static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
-					  int map_writable,
-					  struct tdp_iter *iter,
-					  kvm_pfn_t pfn, bool prefault)
+static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
+					  struct kvm_page_fault *fault,
+					  struct tdp_iter *iter)
 {
 	u64 new_spte;
 	int ret = RET_PF_FIXED;
 	int make_spte_ret = 0;
 
-	if (unlikely(is_noslot_pfn(pfn)))
+	if (unlikely(is_noslot_pfn(fault->pfn)))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
 		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
-					 pfn, iter->old_spte, prefault, true,
-					 map_writable, !shadow_accessed_mask,
+					 fault->pfn, iter->old_spte, fault->prefault, true,
+					 fault->map_writable, !shadow_accessed_mask,
 					 &new_spte);
 
 	if (new_spte == iter->old_spte)
@@ -957,7 +956,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	 * the vCPU would have the same fault again.
 	 */
 	if (make_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
-		if (write)
+		if (fault->write)
 			ret = RET_PF_EMULATE;
 	}
 
@@ -1064,8 +1063,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return RET_PF_RETRY;
 	}
 
-	ret = tdp_mmu_map_handle_target_level(vcpu, fault->write, fault->map_writable, &iter,
-					      fault->pfn, fault->prefault);
+	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
 	rcu_read_unlock();
 
 	return ret;
-- 
2.27.0


