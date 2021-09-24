Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33742417892
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347448AbhIXQdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347411AbhIXQdb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0sy1HmNffqaIredYQLMrviqsuhRucf5p/gzeqqSA+w4=;
        b=GssGRONHH57uw15VoNuUVlIHuoLNEliWgrSF7hZ5d5mxSHP3oCV1CWN8GmfnSfCkSMtRsA
        4qDFLfxgajJWqkcj4V0Y7tx1bS9IQkifLEfL5X/biaSW/3rpNi/3TbGA5yx+AcZ+PDVh4+
        aMDbQl9+3IRPs08JhWJvsFBe04Y7ATM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-XjvogAvrO5iUzZ6IOlwxZA-1; Fri, 24 Sep 2021 12:31:56 -0400
X-MC-Unique: XjvogAvrO5iUzZ6IOlwxZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C086091272;
        Fri, 24 Sep 2021 16:31:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FFFF6715F;
        Fri, 24 Sep 2021 16:31:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 04/31] KVM: MMU: change direct_page_fault() arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:25 -0400
Message-Id: <20210924163152.289027-5-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add fields to struct kvm_page_fault corresponding to
the arguments of direct_page_fault().  The fields are
initialized in the callers, and direct_page_fault()
receives a struct kvm_page_fault instead of having to
extract the arguments out of it.

Also adjust FNAME(page_fault) to store the max_level in
struct kvm_page_fault, to keep it similar to the direct
map path.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h             |  5 ++++
 arch/x86/kvm/mmu/mmu.c         | 43 +++++++++++++++-------------------
 arch/x86/kvm/mmu/paging_tmpl.h |  7 +++---
 3 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ee58177bc282..8d001b56f7b5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -129,6 +129,9 @@ struct kvm_page_fault {
 
 	/* Derived from mmu.  */
 	const bool is_tdp;
+
+	/* Input to FNAME(fetch), __direct_map and kvm_tdp_mmu_map.  */
+	u8 max_level;
 };
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
@@ -146,6 +149,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.user = err & PFERR_USER_MASK,
 		.prefault = prefault,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+
+		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 	};
 #ifdef CONFIG_RETPOLINE
 	if (fault.is_tdp)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3ca4b1c69e03..7685b4270d8c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3949,11 +3949,11 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	return true;
 }
 
-static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			     bool prefault, int max_level, bool is_tdp)
+static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	gpa_t gpa = fault->addr;
+	u32 error_code = fault->error_code;
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
-	bool write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
 	gfn_t gfn = gpa >> PAGE_SHIFT;
@@ -3976,11 +3976,11 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (kvm_faultin_pfn(vcpu, prefault, gfn, gpa, &pfn, &hva,
-			 write, &map_writable, &r))
+	if (kvm_faultin_pfn(vcpu, fault->prefault, gfn, gpa, &pfn, &hva,
+			    fault->write, &map_writable, &r))
 		return r;
 
-	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, fault->is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
@@ -3997,11 +3997,11 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		goto out_unlock;
 
 	if (is_tdp_mmu_fault)
-		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
-				    pfn, prefault);
+		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, fault->max_level,
+				    pfn, fault->prefault);
 	else
-		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
-				 prefault, is_tdp);
+		r = __direct_map(vcpu, gpa, error_code, map_writable, fault->max_level, pfn,
+				 fault->prefault, fault->is_tdp);
 
 out_unlock:
 	if (is_tdp_mmu_fault)
@@ -4015,12 +4015,11 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault)
 {
-	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
+	pgprintk("%s: gva %lx error %x\n", __func__, fault->addr, fault->error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
-	return direct_page_fault(vcpu, fault->addr,
-				 fault->error_code, fault->prefault,
-				 PG_LEVEL_2M, false);
+	fault->max_level = PG_LEVEL_2M;
+	return direct_page_fault(vcpu, fault);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -4058,21 +4057,17 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	int max_level;
-	gpa_t gpa = fault->addr;
-
-	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
-	     max_level > PG_LEVEL_4K;
-	     max_level--) {
-		int page_num = KVM_PAGES_PER_HPAGE(max_level);
-		gfn_t base = (gpa >> PAGE_SHIFT) & ~(page_num - 1);
+	while (fault->max_level > PG_LEVEL_4K) {
+		int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
+		gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
 
 		if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
 			break;
+
+		--fault->max_level;
 	}
 
-	return direct_page_fault(vcpu, gpa, fault->error_code,
-				 fault->prefault, max_level, true);
+	return direct_page_fault(vcpu, fault);
 }
 
 static void nonpaging_init_context(struct kvm_mmu *context)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 8eee1200117a..a39881a8ba78 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -843,7 +843,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	hva_t hva;
 	unsigned long mmu_seq;
 	bool map_writable, is_self_change_mapping;
-	int max_level;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 	WARN_ON_ONCE(fault->is_tdp);
@@ -885,9 +884,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	      &walker, fault->user, &vcpu->arch.write_fault_to_shadow_pgtable);
 
 	if (is_self_change_mapping)
-		max_level = PG_LEVEL_4K;
+		fault->max_level = PG_LEVEL_4K;
 	else
-		max_level = walker.level;
+		fault->max_level = walker.level;
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
@@ -927,7 +926,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, pfn,
+	r = FNAME(fetch)(vcpu, addr, &walker, error_code, fault->max_level, pfn,
 			 map_writable, fault->prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
-- 
2.27.0


