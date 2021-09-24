Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FD0417894
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347499AbhIXQdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347415AbhIXQdd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tVA5bUriVv0RgBMpH+LkrjYNnaKbj2WQkb6+r9X+p58=;
        b=Gbou2YEkZ4EAAqjVyfAgBFP6wG+t/miKTuT39HZ0VYyVPG7xa3eg9NbhOWkAWPa6rFna2g
        h1PJlsPufFCAdRaoborinuhvJwDHnG9FzBDx+jajzGqrbE5RM1uujSMqgr7GItjwpGFy68
        YsSna3AeRuFm36sIiEsuIPKtEW9ac+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-xlM7AqYSNB2tnM7lN-FRCg-1; Fri, 24 Sep 2021 12:31:56 -0400
X-MC-Unique: xlM7AqYSNB2tnM7lN-FRCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53098802E3D;
        Fri, 24 Sep 2021 16:31:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA09960E1C;
        Fri, 24 Sep 2021 16:31:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 03/31] KVM: MMU: change mmu->page_fault() arguments to kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:24 -0400
Message-Id: <20210924163152.289027-4-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 0cb35ef26ab3..8e2e79e909e6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -407,6 +407,7 @@ struct kvm_mmu_root_info {
 #define KVM_HAVE_MMU_RWLOCK
 
 struct kvm_mmu_page;
+struct kvm_page_fault;
 
 /*
  * x86 supports 4 paging modes (5-level 64-bit, 4-level 64-bit, 3-level 32-bit,
@@ -416,8 +417,7 @@ struct kvm_mmu_page;
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
index 0553ef92946e..ee58177bc282 100644
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
index 376e90f4f413..3ca4b1c69e03 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4012,13 +4012,14 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
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
 
@@ -4055,10 +4056,10 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
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
@@ -4070,8 +4071,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			break;
 	}
 
-	return direct_page_fault(vcpu, gpa, error_code, prefault,
-				 max_level, true);
+	return direct_page_fault(vcpu, gpa, fault->error_code,
+				 fault->prefault, max_level, true);
 }
 
 static void nonpaging_init_context(struct kvm_mmu *context)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b908d2ff6d4c..8eee1200117a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -833,11 +833,10 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
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
@@ -847,6 +846,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	int max_level;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
+	WARN_ON_ONCE(fault->is_tdp);
 
 	/*
 	 * If PFEC.RSVD is set, this is a shadow page fault.
@@ -864,7 +864,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	 */
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __func__);
-		if (!prefault)
+		if (!fault->prefault)
 			kvm_inject_emulated_page_fault(vcpu, &walker.fault);
 
 		return RET_PF_RETRY;
@@ -882,7 +882,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	vcpu->arch.write_fault_to_shadow_pgtable = false;
 
 	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
-	      &walker, user_fault, &vcpu->arch.write_fault_to_shadow_pgtable);
+	      &walker, fault->user, &vcpu->arch.write_fault_to_shadow_pgtable);
 
 	if (is_self_change_mapping)
 		max_level = PG_LEVEL_4K;
@@ -892,8 +892,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (kvm_faultin_pfn(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
-			 write_fault, &map_writable, &r))
+	if (kvm_faultin_pfn(vcpu, fault->prefault, walker.gfn, addr, &pfn, &hva,
+			    fault->write, &map_writable, &r))
 		return r;
 
 	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
@@ -903,8 +903,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	 * Do not change pte_access if the pfn is a mmio page, otherwise
 	 * we will cache the incorrect access into mmio spte.
 	 */
-	if (write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
-	    !is_cr0_wp(vcpu->arch.mmu) && !user_fault && !is_noslot_pfn(pfn)) {
+	if (fault->write && !(walker.pte_access & ACC_WRITE_MASK) &&
+	    !is_cr0_wp(vcpu->arch.mmu) && !fault->user && !is_noslot_pfn(pfn)) {
 		walker.pte_access |= ACC_WRITE_MASK;
 		walker.pte_access &= ~ACC_USER_MASK;
 
@@ -928,7 +928,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	if (r)
 		goto out_unlock;
 	r = FNAME(fetch)(vcpu, addr, &walker, error_code, max_level, pfn,
-			 map_writable, prefault);
+			 map_writable, fault->prefault);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-- 
2.27.0


