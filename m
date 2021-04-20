Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FD636566E
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhDTKmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:34977 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231765AbhDTKmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:22 -0400
IronPort-SDR: VMV5kyk7uWRrUZK6vuM/+sdtc8lYFADYBcE0gcKix7asIcRgm77DnZyuMaLMRlauizKOLK7jbB
 o8VZc9D8opxA==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590776"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590776"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:46 -0700
IronPort-SDR: j5U+V5/kapIJr62N+gp8FhCqOnXY+8ac8ORscTlbKBsGqC0Jyx0M8CEJrrPYopgNZ0RMni/zjK
 2G/uwbRC8uIg==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872795"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:46 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     isaku.yamahata@gmail.com, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [RFC PATCH 09/10] KVM: x86/mmu: make kvm_tdp_mmu_map() receive single argument
Date:   Tue, 20 Apr 2021 03:39:19 -0700
Message-Id: <81803a82264b3b942a74f88ecb6fb3033b407fcc.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert kvm_tdp_mmu_map() to receive single argument, struct kvm_page_fault
instead of many arguments.

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     |  8 +-------
 arch/x86/kvm/mmu/tdp_mmu.c | 21 +++++++++++----------
 arch/x86/kvm/mmu/tdp_mmu.h |  4 +---
 3 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b58afb58430e..ebac766839a9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3692,11 +3692,6 @@ static bool try_async_pf(struct kvm_page_fault *kpf)
 static int direct_page_fault(struct kvm_page_fault *kpf)
 {
 	struct kvm_vcpu *vcpu = kpf->vcpu;
-	gpa_t gpa = kpf->cr2_or_gpa;
-	u32 error_code = kpf->error_code;
-	bool prefault = kpf->prefault;
-	int max_level = kpf->max_level;
-
 	unsigned long mmu_seq;
 	int r;
 
@@ -3737,8 +3732,7 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 		goto out_unlock;
 
 	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
-		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, kpf->map_writable,
-				    max_level, kpf->pfn, prefault);
+		r = kvm_tdp_mmu_map(kpf);
 	else
 		r = __direct_map(kpf);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 018d82e73e31..13ae4735fc25 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -793,12 +793,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
  */
-int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		    int map_writable, int max_level, kvm_pfn_t pfn,
-		    bool prefault)
+int kvm_tdp_mmu_map(struct kvm_page_fault *kpf)
 {
+	struct kvm_vcpu *vcpu = kpf->vcpu;
+	u32 error_code = kpf->error_code;
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	bool write = error_code & PFERR_WRITE_MASK;
 	bool exec = error_code & PFERR_FETCH_MASK;
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -807,7 +806,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	u64 *child_pt;
 	u64 new_spte;
 	int ret;
-	gfn_t gfn = gpa >> PAGE_SHIFT;
+	gpa_t gpa = kpf->cr2_or_gpa;
+	gfn_t gfn = kpf->gfn;
 	int level;
 	int req_level;
 
@@ -816,17 +816,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
 
-	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
+	level = kvm_mmu_hugepage_adjust(vcpu, gfn, kpf->max_level, &kpf->pfn,
 					huge_page_disallowed, &req_level);
 
-	trace_kvm_mmu_spte_requested(gpa, level, pfn);
+	trace_kvm_mmu_spte_requested(gpa, level, kpf->pfn);
 
 	rcu_read_lock();
 
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		if (nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(iter.old_spte, gfn,
-						   iter.level, &pfn, &level);
+						   iter.level, &kpf->pfn, &level);
 
 		if (iter.level == level)
 			break;
@@ -875,8 +875,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		return RET_PF_RETRY;
 	}
 
-	ret = tdp_mmu_map_handle_target_level(vcpu, write, map_writable, &iter,
-					      pfn, prefault);
+	ret = tdp_mmu_map_handle_target_level(
+		vcpu, kpf->write_fault, kpf->map_writable, &iter, kpf->pfn,
+		kpf->prefault);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 31096ece9b14..cbf63791603d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -33,9 +33,7 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
-int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-		    int map_writable, int max_level, kvm_pfn_t pfn,
-		    bool prefault);
+int kvm_tdp_mmu_map(struct kvm_page_fault *kpf);
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
 			      unsigned long end);
-- 
2.25.1

