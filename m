Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DE83E35A3
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhHGNuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232378AbhHGNuE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HaFd1Cw1MlrRqDLSbgl+GwSbwit4ugEOhVNpiP9kVYI=;
        b=GKybV4x1d5OnDRvTiVe1w1nMzqmzAXHWHNd2nH6GFt0wnDYobsJ0Oyt9FyMSsIZPPbZVcb
        u7CMS/zcewQy8qD5pXEJzpOwL0mYc/kpcGf8CkWPb1GrEdaPDWWAkan6yW43rm808zE1wT
        Rkr74rNXoBOIjS4Lidic2Z34PnvlEi0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-RlDruON_OJePEwiqEJmkSQ-1; Sat, 07 Aug 2021 09:49:45 -0400
X-MC-Unique: RlDruON_OJePEwiqEJmkSQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F43087180C;
        Sat,  7 Aug 2021 13:49:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D10821700F;
        Sat,  7 Aug 2021 13:49:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 04/16] KVM: MMU: change mmu->page_fault() arguments to kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:24 -0400
Message-Id: <20210807134936.3083984-5-pbonzini@redhat.com>
In-Reply-To: <20210807134936.3083984-1-pbonzini@redhat.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass struct kvm_page_fault to mmu->page_fault() instead of
extracting the arguments from the struct.  FNAME(page_fault) can use
the precomputed bools from the error code.

Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu.h              |  7 +++----
 arch/x86/kvm/mmu/mmu.c          | 15 ++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h  | 22 +++++++++++-----------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6a73ff7db5f9..3399470a44a9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -401,6 +401,7 @@ struct kvm_mmu_root_info {
 #define KVM_HAVE_MMU_RWLOCK
 
 struct kvm_mmu_page;
+struct kvm_page_fault;
 
 /*
  * x86 supports 4 paging modes (5-level 64-bit, 4-level 64-bit, 3-level 32-bit,
@@ -410,8 +411,7 @@ struct kvm_mmu_page;
 struct kvm_mmu {
 	unsigned long (*get_guest_pgd)(struct kvm_vcpu *vcpu);
 	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
-	int (*page_fault)(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 err,
-			  bool prefault);
+	int (*page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  struct x86_exception *fault);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gpa_t gva_or_gpa,
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 5c06e059e483..bbe5fe57c2af 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -131,8 +131,7 @@ struct kvm_page_fault {
 	const bool is_tdp;
 };
 
-int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		       bool prefault);
+int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefault)
@@ -150,9 +149,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	};
 #ifdef CONFIG_RETPOLINE
 	if (fault.is_tdp)
-		return kvm_tdp_page_fault(vcpu, fault.addr, fault.error_code, fault.prefault);
+		return kvm_tdp_page_fault(vcpu, &fault);
 #endif
-	return vcpu->arch.mmu->page_fault(vcpu, fault.addr, fault.error_code, fault.prefault);
+	return vcpu->arch.mmu->page_fault(vcpu, &fault);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5d4de39fe5a9..bb3a2c2aa62e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3941,13 +3941,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	return r;
 }
 
-static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
-				u32 error_code, bool prefault)
+static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
+				struct kvm_page_fault *fault)
 {
 	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
-	return direct_page_fault(vcpu, gpa, error_code, prefault,
+	return direct_page_fault(vcpu, fault->addr,
+				 fault->error_code, fault->prefault,
 				 PG_LEVEL_2M, false);
 }
 
@@ -3984,10 +3985,10 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
-int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		       bool prefault)
+int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	int max_level;
+	gpa_t gpa = fault->addr;
 
 	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
 	     max_level > PG_LEVEL_4K;
@@ -3999,8 +4000,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			break;
 	}
 
-	return direct_page_fault(vcpu, gpa, error_code, prefault,
-				 max_level, true);
+	return direct_page_fault(vcpu, gpa, fault->error_code,
+				 fault->prefault, max_level, true);
 }
 
 static void nonpaging_init_context(struct kvm_mmu *context)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ee044d357b5f..916a8106d0f4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -822,11 +822,10 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
  *  Returns: 1 if we need to emulate the instruction, 0 otherwise, or
  *           a negative value on error.
  */
-static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
-			     bool prefault)
+static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	bool write_fault = error_code & PFERR_WRITE_MASK;
-	bool user_fault = error_code & PFERR_USER_MASK;
+	gpa_t addr = fault->addr;
+	u32 error_code = fault->error_code;
 	struct guest_walker walker;
 	int r;
 	kvm_pfn_t pfn;
@@ -836,6 +835,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	int max_level;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
+	WARN_ON_ONCE(fault->is_tdp);
 
 	/*
 	 * If PFEC.RSVD is set, this is a shadow page fault.
@@ -853,7 +853,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	 */
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __func__);
-		if (!prefault)
+		if (!fault->prefault)
 			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
 
 		return RET_PF_RETRY;
@@ -871,7 +871,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	vcpu->arch.write_fault_to_shadow_pgtable = false;
 
 	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
-	      &walker, user_fault, &vcpu->arch.write_fault_to_shadow_pgtable);
+	      &walker, fault->user, &vcpu->arch.write_fault_to_shadow_pgtable);
 
 	if (is_self_change_mapping)
 		max_level = PG_LEVEL_4K;
@@ -881,8 +881,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
-			 write_fault, &map_writable))
+	if (try_async_pf(vcpu, fault->prefault, walker.gfn, addr, &pfn, &hva,
+			 fault->write, &map_writable))
 		return RET_PF_RETRY;
 
 	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
@@ -892,8 +892,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	 * Do not change pte_access if the pfn is a mmio page, otherwise
 	 * we will cache the incorrect access into mmio spte.
 	 */
-	if (write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
-	    !is_cr0_wp(vcpu->arch.mmu) && !user_fault && !is_noslot_pfn(pfn)) {
+	if (fault->write && !(walker.pte_access & ACC_WRITE_MASK) &&
+	    !is_cr0_wp(vcpu->arch.mmu) && !fault->user && !is_noslot_pfn(pfn)) {
 		walker.pte_access |= ACC_WRITE_MASK;
 		walker.pte_access &= ~ACC_USER_MASK;
 
@@ -917,7 +917,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	if (r)
 		goto out_unlock;
 	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, pfn,
-			 map_writable, prefault);
+			 map_writable, fault->prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-- 
2.27.0


