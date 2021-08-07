Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360213E35A8
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhHGNuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232408AbhHGNuI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jVGcFAzulOYWC1/vN+ITFpFYZSvJDdcnfWhluCdbHT4=;
        b=Om+UY2fNF7hS5bSdxMK+BCybqV/W0JN4uBZOtukI0Ynia3N+EXdZtvSoWfr7PaLY8Gt1zD
        K6IdjILRrhOP4ffYJwWDVuK13v3Ia1O8WJaclUd6G0V8EvZTBM6+G7FV/A1KKuqC2OWHsP
        1BtchDpRKpUW417a1xruymYQIP9+6Ps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-YfQrxdK_Mpazd9DjZSaEew-1; Sat, 07 Aug 2021 09:49:47 -0400
X-MC-Unique: YfQrxdK_Mpazd9DjZSaEew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5AEA760C1;
        Sat,  7 Aug 2021 13:49:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55A511700F;
        Sat,  7 Aug 2021 13:49:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 06/16] KVM: MMU: change page_fault_handle_page_track() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:26 -0400
Message-Id: <20210807134936.3083984-7-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add fields to struct kvm_page_fault corresponding to the arguments
of page_fault_handle_page_track().  The fields are initialized in the
callers, and page_fault_handle_page_track() receives a struct
kvm_page_fault instead of having to extract the arguments out of it.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h             |  3 +++
 arch/x86/kvm/mmu/mmu.c         | 18 +++++++++---------
 arch/x86/kvm/mmu/paging_tmpl.h |  7 ++++---
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 158263847bef..c3d404155ceb 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -132,6 +132,9 @@ struct kvm_page_fault {
 
 	/* Input to FNAME(fetch), __direct_map and kvm_tdp_mmu_map.  */
 	u8 max_level;
+
+	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
+	gfn_t gfn;
 };
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e93ee0ebe5ff..3af49678d4f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3788,20 +3788,19 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 }
 
 static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
-					 u32 error_code, gfn_t gfn)
+					 struct kvm_page_fault *fault)
 {
-	if (unlikely(error_code & PFERR_RSVD_MASK))
+	if (unlikely(fault->rsvd))
 		return false;
 
-	if (!(error_code & PFERR_PRESENT_MASK) ||
-	      !(error_code & PFERR_WRITE_MASK))
+	if (!fault->present || !fault->write)
 		return false;
 
 	/*
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_page_track_is_active(vcpu, fault->gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
 
 	return false;
@@ -3885,13 +3884,13 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	bool map_writable;
 
-	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
 	hva_t hva;
 	int r;
 
-	if (page_fault_handle_page_track(vcpu, error_code, gfn))
+	fault->gfn = gpa >> PAGE_SHIFT;
+	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
 	r = fast_page_fault(vcpu, gpa, error_code);
@@ -3905,11 +3904,12 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, fault->prefault, gfn, gpa, &pfn, &hva,
+	if (try_async_pf(vcpu, fault->prefault, fault->gfn, gpa, &pfn, &hva,
 			 fault->write, &map_writable))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, fault->is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, fault->is_tdp ? 0 : gpa,
+	                        fault->gfn, pfn, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5352323646b0..2ef219bf1745 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -858,7 +858,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return RET_PF_RETRY;
 	}
 
-	if (page_fault_handle_page_track(vcpu, error_code, walker.gfn)) {
+	fault->gfn = walker.gfn;
+	if (page_fault_handle_page_track(vcpu, fault)) {
 		shadow_page_table_clear_flood(vcpu, addr);
 		return RET_PF_EMULATE;
 	}
@@ -880,11 +881,11 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, fault->prefault, walker.gfn, addr, &pfn, &hva,
+	if (try_async_pf(vcpu, fault->prefault, fault->gfn, addr, &pfn, &hva,
 			 fault->write, &map_writable))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
+	if (handle_abnormal_pfn(vcpu, addr, fault->gfn, pfn, walker.pte_access, &r))
 		return r;
 
 	/*
-- 
2.27.0


