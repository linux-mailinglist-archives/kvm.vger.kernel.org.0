Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054CF154ECA
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgBFWOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:14:36 -0500
Received: from mga18.intel.com ([134.134.136.126]:33157 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbgBFWOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:14:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 14:14:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="226291753"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 06 Feb 2020 14:14:35 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Avoid retpoline on ->page_fault() with TDP
Date:   Thu,  6 Feb 2020 14:14:34 -0800
Message-Id: <20200206221434.23790-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap calls to ->page_fault() with a small shim to directly invoke the
TDP fault handler when the kernel is using retpolines and TDP is being
used.  Denote the TDP fault handler by nullifying mmu->page_fault, and
annotate the TDP path as likely to coerce the compiler into preferring
the TDP path.

Rename tdp_page_fault() to kvm_tdp_page_fault() as it's exposed outside
of mmu.c to allow inlining the shim.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Haven't done any performance testing, this popped into my head when mucking
with the 5-level page table crud as an easy way to shave cycles in the
happy path.

 arch/x86/kvm/mmu.h     | 13 +++++++++++++
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++++------
 arch/x86/kvm/x86.c     |  2 +-
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index d55674f44a18..9277ee8a54a5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -102,6 +102,19 @@ static inline void kvm_mmu_load_cr3(struct kvm_vcpu *vcpu)
 					      kvm_get_active_pcid(vcpu));
 }
 
+int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
+		       bool prefault);
+
+static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+					u32 err, bool prefault)
+{
+#ifdef CONFIG_RETPOLINE
+	if (likely(!vcpu->arch.mmu->page_fault))
+		return kvm_tdp_page_fault(vcpu, cr2_or_gpa, err, prefault);
+#endif
+	return vcpu->arch.mmu->page_fault(vcpu, cr2_or_gpa, err, prefault);
+}
+
 /*
  * Currently, we have two sorts of write-protection, a) the first one
  * write-protects guest page to sync the guest modification, b) another one is
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7011a4e54866..5267f1440677 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4219,8 +4219,8 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
-static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			  bool prefault)
+int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
+		       bool prefault)
 {
 	int max_level;
 
@@ -4925,7 +4925,12 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		return;
 
 	context->mmu_role.as_u64 = new_role.as_u64;
-	context->page_fault = tdp_page_fault;
+#ifdef CONFIG_RETPOLINE
+	/* Nullify ->page_fault() to use direct kvm_tdp_page_fault() call. */
+	context->page_fault = NULL;
+#else
+	context->page_fault = kvm_tdp_page_fault;
+#endif
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
 	context->update_pte = nonpaging_update_pte;
@@ -5436,9 +5441,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = vcpu->arch.mmu->page_fault(vcpu, cr2_or_gpa,
-					       lower_32_bits(error_code),
-					       false);
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
+					  lower_32_bits(error_code), false);
 		WARN_ON(r == RET_PF_INVALID);
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbabb2f06273..39251ecafd2b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10182,7 +10182,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != vcpu->arch.mmu->get_cr3(vcpu))
 		return;
 
-	vcpu->arch.mmu->page_fault(vcpu, work->cr2_or_gpa, 0, true);
+	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
 }
 
 static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
-- 
2.24.1

