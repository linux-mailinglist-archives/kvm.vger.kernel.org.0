Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B088E36565F
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhDTKmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:17 -0400
Received: from mga17.intel.com ([192.55.52.151]:34977 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230408AbhDTKmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:15 -0400
IronPort-SDR: TUoqpsJHxP4vLmk11bgj4/ZvxnzMowg7iwMdfkS5NjpsZUz/FNG8rF7Hyr7IcnSv42gQzWwlUm
 zAXIANzrt0PQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590747"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590747"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:43 -0700
IronPort-SDR: PgcJyC6Spz86JsutWm9mJTNo0SjljbSXcmSx+1ZYxWRD9PgUHgaj7NQik0/pGcNlp8XlIL1qj4
 MzpwujgIilxg==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872760"
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
Subject: [RFC PATCH 01/10] KVM: x86/mmu: make kvm_mmu_do_page_fault() receive single argument
Date:   Tue, 20 Apr 2021 03:39:11 -0700
Message-Id: <0148ecd4045e672a28e32ba0e07a787d39ed1bbd.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce struct kvm_page_fault handler and its initialization function.
Make the caller of kvm page fault handler allocate/initialize
struct kvm_page_fault, and pass it to kvm_mmu_do_page_fault() instead
of many arguments.

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h     | 29 ++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/mmu.c |  6 ++++--
 arch/x86/kvm/x86.c     |  4 +++-
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index c68bfc3e2402..245c5d7fd3dd 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -106,17 +106,36 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 				 vcpu->arch.mmu->shadow_root_level);
 }
 
+struct kvm_page_fault {
+	/* arguments to kvm page fault handler */
+	struct kvm_vcpu *vcpu;
+	gpa_t cr2_or_gpa;
+	u32 error_code;
+	bool prefault;
+};
+
+static inline void kvm_page_fault_init(
+	struct kvm_page_fault *kpf, struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+	u32 error_code, bool prefault)
+{
+	kpf->vcpu = vcpu;
+	kpf->cr2_or_gpa = cr2_or_gpa;
+	kpf->error_code = error_code;
+	kpf->prefault = prefault;
+}
+
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault);
 
-static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefault)
+static inline int kvm_mmu_do_page_fault(struct kvm_page_fault *kpf)
 {
 #ifdef CONFIG_RETPOLINE
-	if (likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault))
-		return kvm_tdp_page_fault(vcpu, cr2_or_gpa, err, prefault);
+	if (likely(kpf->vcpu->arch.mmu->page_fault == kvm_tdp_page_fault))
+		return kvm_tdp_page_fault(kpf->vcpu, kpf->cr2_or_gpa,
+					  kpf->error_code, kpf->prefault);
 #endif
-	return vcpu->arch.mmu->page_fault(vcpu, cr2_or_gpa, err, prefault);
+	return kpf->vcpu->arch.mmu->page_fault(kpf->vcpu, kpf->cr2_or_gpa,
+					       kpf->error_code, kpf->prefault);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 951dae4e7175..8ea2afcb528c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5006,6 +5006,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 {
 	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->direct_map;
+	struct kvm_page_fault kpf;
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
@@ -5018,8 +5019,9 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false);
+		kvm_page_fault_init(&kpf, vcpu, cr2_or_gpa,
+				    lower_32_bits(error_code), false);
+		r = kvm_mmu_do_page_fault(&kpf);
 		if (WARN_ON_ONCE(r == RET_PF_INVALID))
 			return -EIO;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eca63625aee4..999ed561de64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11083,6 +11083,7 @@ EXPORT_SYMBOL_GPL(kvm_set_rflags);
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
+	struct kvm_page_fault kpf;
 
 	if ((vcpu->arch.mmu->direct_map != work->arch.direct_map) ||
 	      work->wakeup_all)
@@ -11096,7 +11097,8 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
 		return;
 
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
+	kvm_page_fault_init(&kpf, vcpu, work->cr2_or_gpa, 0, true);
+	kvm_mmu_do_page_fault(&kpf);
 }
 
 static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
-- 
2.25.1

