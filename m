Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A933E35B3
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhHGNu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232445AbhHGNuP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u96ed5XUQ+QmjxtUQVewX6dCxmvMLN/rCy5beBkLzbE=;
        b=Cc2hN2T5SjHpVatuRwvsxiEtyyozIXLO5i9PLARv+1chxTgE+ykuMtrrQI5gh7p1MhffGp
        cpcuGADMqgopztlGchuhgacnPjDbbBYu+iCIHSiGmTge7Hb/KaMLU3d9R20BZhMyhvMh58
        dQTrMz1ywGNnHFs24D0Fl2vLovrVFdo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-fijOuF62PzeNSXZuEbEwsw-1; Sat, 07 Aug 2021 09:49:54 -0400
X-MC-Unique: fijOuF62PzeNSXZuEbEwsw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F3321835AC3;
        Sat,  7 Aug 2021 13:49:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22C9860C13;
        Sat,  7 Aug 2021 13:49:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 12/16] KVM: MMU: change tdp_mmu_map_handle_target_level() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:32 -0400
Message-Id: <20210807134936.3083984-13-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
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
index 340ae8a34fe3..d8b1735739c0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -937,21 +937,20 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
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
@@ -965,7 +964,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	 * the vCPU would have the same fault again.
 	 */
 	if (make_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
-		if (write)
+		if (fault->write)
 			ret = RET_PF_EMULATE;
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 	}
@@ -1073,8 +1072,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return RET_PF_RETRY;
 	}
 
-	ret = tdp_mmu_map_handle_target_level(vcpu, fault->write, fault->map_writable, &iter,
-					      fault->pfn, fault->prefault);
+	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
 	rcu_read_unlock();
 
 	return ret;
-- 
2.27.0


