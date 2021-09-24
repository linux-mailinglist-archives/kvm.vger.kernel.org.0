Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA82A417893
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347420AbhIXQdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347425AbhIXQdd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n6wkc0SXfkAKMw4R5kL6AnRYBA6S/N+dqhAaJ5l+1NA=;
        b=b1nhI9DrvK3rhWp+f8vHAOQ8VVqRGQrHBMenygaRT8lOlf1YDelDH4b0Gqse8f5EmHT0qA
        mHeMieXtln1PatDRoMEnlscIFalDaBcLXQekmidmZXKS0uv26gQN6WtlWiegW/1PjVLt9g
        FSQ4jrEXeP6NHB28b8isRSiOVY+rtjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-1mkgh-qdOZ6wtcETenr7hw-1; Fri, 24 Sep 2021 12:31:58 -0400
X-MC-Unique: 1mkgh-qdOZ6wtcETenr7hw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 532C4802C98;
        Fri, 24 Sep 2021 16:31:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D947260E1C;
        Fri, 24 Sep 2021 16:31:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 05/31] KVM: MMU: change page_fault_handle_page_track() arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:26 -0400
Message-Id: <20210924163152.289027-6-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 8d001b56f7b5..a5c2d4069964 100644
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
index 7685b4270d8c..41dc6796b80b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3846,20 +3846,19 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
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
@@ -3956,13 +3955,13 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
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
@@ -3976,11 +3975,12 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (kvm_faultin_pfn(vcpu, fault->prefault, gfn, gpa, &pfn, &hva,
+	if (kvm_faultin_pfn(vcpu, fault->prefault, fault->gfn, gpa, &pfn, &hva,
 			    fault->write, &map_writable, &r))
 		return r;
 
-	if (handle_abnormal_pfn(vcpu, fault->is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, fault->is_tdp ? 0 : gpa,
+				fault->gfn, pfn, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index a39881a8ba78..44a19dde5e70 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -869,7 +869,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return RET_PF_RETRY;
 	}
 
-	if (page_fault_handle_page_track(vcpu, error_code, walker.gfn)) {
+	fault->gfn = walker.gfn;
+	if (page_fault_handle_page_track(vcpu, fault)) {
 		shadow_page_table_clear_flood(vcpu, addr);
 		return RET_PF_EMULATE;
 	}
@@ -891,11 +892,11 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (kvm_faultin_pfn(vcpu, fault->prefault, walker.gfn, addr, &pfn, &hva,
+	if (kvm_faultin_pfn(vcpu, fault->prefault, fault->gfn, addr, &pfn, &hva,
 			    fault->write, &map_writable, &r))
 		return r;
 
-	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
+	if (handle_abnormal_pfn(vcpu, addr, fault->gfn, pfn, walker.pte_access, &r))
 		return r;
 
 	/*
-- 
2.27.0


