Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC24365662
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhDTKmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:34977 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231673AbhDTKmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:15 -0400
IronPort-SDR: WmtMsDdnQcW9PLisK/XFWrU0/Sw4c0K1LeKD7Upv/L7GYHQ3NyN8ER+mmKYqfEot8JWo++C6o6
 5xB9p4r1kU7A==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590750"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590750"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:43 -0700
IronPort-SDR: JzBBEeoVTFEeeF5P7MLchV5zSIx4r8Y6tDi57ehNB4oySwK4/QHxmj+F22OnduJ/WzfuLx6h6i
 7RF0Gzc/pOeg==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872765"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:43 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     isaku.yamahata@gmail.com, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [RFC PATCH 02/10] KVM: x86/mmu: make kvm_mmu:page_fault receive single argument
Date:   Tue, 20 Apr 2021 03:39:12 -0700
Message-Id: <ec19c2365e1136fbe230f808ae989cdfca8e37bd.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert kvm_mmu:page_fault callback to receive struct kvm_page_fault
instead of many arguments.
The following functions are converted by this patch.
kvm_tdp_page_fault(), nonpaging_page_fault() and, FNAME(page_fault).

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu.h              |  9 +++------
 arch/x86/kvm/mmu/mmu.c          | 19 ++++++++++---------
 arch/x86/kvm/mmu/paging_tmpl.h  |  7 +++++--
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3768819693e5..97e72076f358 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -351,6 +351,7 @@ struct kvm_mmu_root_info {
 #define KVM_HAVE_MMU_RWLOCK
 
 struct kvm_mmu_page;
+struct kvm_page_fault;
 
 /*
  * x86 supports 4 paging modes (5-level 64-bit, 4-level 64-bit, 3-level 32-bit,
@@ -360,8 +361,7 @@ struct kvm_mmu_page;
 struct kvm_mmu {
 	unsigned long (*get_guest_pgd)(struct kvm_vcpu *vcpu);
 	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
-	int (*page_fault)(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 err,
-			  bool prefault);
+	int (*page_fault)(struct kvm_page_fault *kpf);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  struct x86_exception *fault);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gpa_t gva_or_gpa,
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 245c5d7fd3dd..7fcd9c147e63 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -124,18 +124,15 @@ static inline void kvm_page_fault_init(
 	kpf->prefault = prefault;
 }
 
-int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		       bool prefault);
+int kvm_tdp_page_fault(struct kvm_page_fault *kpf);
 
 static inline int kvm_mmu_do_page_fault(struct kvm_page_fault *kpf)
 {
 #ifdef CONFIG_RETPOLINE
 	if (likely(kpf->vcpu->arch.mmu->page_fault == kvm_tdp_page_fault))
-		return kvm_tdp_page_fault(kpf->vcpu, kpf->cr2_or_gpa,
-					  kpf->error_code, kpf->prefault);
+		return kvm_tdp_page_fault(kpf);
 #endif
-	return kpf->vcpu->arch.mmu->page_fault(kpf->vcpu, kpf->cr2_or_gpa,
-					       kpf->error_code, kpf->prefault);
+	return kpf->vcpu->arch.mmu->page_fault(kpf);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8ea2afcb528c..46998cfabfd3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3745,14 +3745,15 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	return r;
 }
 
-static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
-				u32 error_code, bool prefault)
+static int nonpaging_page_fault(struct kvm_page_fault *kpf)
 {
-	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
+	pgprintk("%s: gva %lx error %x\n", __func__,
+		 kpf->cr2_or_gpa, kpf->error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
-	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
-				 PG_LEVEL_2M, false);
+	return direct_page_fault(kpf->vcpu, kpf->cr2_or_gpa & PAGE_MASK,
+				 kpf->error_code,
+				 kpf->prefault, PG_LEVEL_2M, false);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -3788,9 +3789,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
-int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		       bool prefault)
+int kvm_tdp_page_fault(struct kvm_page_fault *kpf)
 {
+	u32 gpa = kpf->cr2_or_gpa;
 	int max_level;
 
 	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
@@ -3799,11 +3800,11 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		int page_num = KVM_PAGES_PER_HPAGE(max_level);
 		gfn_t base = (gpa >> PAGE_SHIFT) & ~(page_num - 1);
 
-		if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
+		if (kvm_mtrr_check_gfn_range_consistency(kpf->vcpu, base, page_num))
 			break;
 	}
 
-	return direct_page_fault(vcpu, gpa, error_code, prefault,
+	return direct_page_fault(kpf->vcpu, gpa, kpf->error_code, kpf->prefault,
 				 max_level, true);
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 55d7b473ac44..dc814463a8df 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -789,9 +789,12 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
  *  Returns: 1 if we need to emulate the instruction, 0 otherwise, or
  *           a negative value on error.
  */
-static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
-			     bool prefault)
+static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 {
+	struct kvm_vcpu *vcpu = kpf->vcpu;
+	gpa_t addr = kpf->cr2_or_gpa;
+	u32 error_code = kpf->error_code;
+	bool prefault = kpf->prefault;
 	bool write_fault = error_code & PFERR_WRITE_MASK;
 	bool user_fault = error_code & PFERR_USER_MASK;
 	struct guest_walker walker;
-- 
2.25.1

