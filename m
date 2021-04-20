Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4620C365669
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhDTKmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:37 -0400
Received: from mga17.intel.com ([192.55.52.151]:34980 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231747AbhDTKmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:21 -0400
IronPort-SDR: VIcJQKolLqd+YWAjwiBTLtIPb5JhQ8YDkxrZoQuykTaLJ36V9PvySpY7kkIL08QjnH46zvQM0M
 uPRW0NxHC/Hg==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590772"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590772"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:46 -0700
IronPort-SDR: T5dLoxT08ZXLREZR3PcPvDYYgzdH6gasOYXzV9aNGt6NUHJiI51TiViyWogOpHVx0wDLXIu1zh
 hrlL/6bsOsGg==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872792"
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
Subject: [RFC PATCH 08/10] KVM: x86/mmu: make __direct_map() receive single argument
Date:   Tue, 20 Apr 2021 03:39:18 -0700
Message-Id: <602cb885d664a745d7b026e381779d8384ff3f7d.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert __direct_map() to receive single argument, struct kvm_page_fault
instead of many arguments.

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ce48416380c3..b58afb58430e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2856,27 +2856,26 @@ void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 	}
 }
 
-static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			int map_writable, int max_level, kvm_pfn_t pfn,
-			bool prefault, bool is_tdp)
+static int __direct_map(struct kvm_page_fault *kpf)
 {
+	struct kvm_vcpu *vcpu = kpf->vcpu;
 	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
-	bool write = error_code & PFERR_WRITE_MASK;
-	bool exec = error_code & PFERR_FETCH_MASK;
+	bool exec = kpf->error_code & PFERR_FETCH_MASK;
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
 	int level, req_level, ret;
-	gfn_t gfn = gpa >> PAGE_SHIFT;
+	gpa_t gpa = kpf->cr2_or_gpa;
+	gfn_t gfn = kpf->gfn;
 	gfn_t base_gfn = gfn;
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
 
-	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
+	level = kvm_mmu_hugepage_adjust(vcpu, gfn, kpf->max_level, &kpf->pfn,
 					huge_page_disallowed, &req_level);
 
-	trace_kvm_mmu_spte_requested(gpa, level, pfn);
+	trace_kvm_mmu_spte_requested(gpa, level, kpf->pfn);
 	for_each_shadow_entry(vcpu, gpa, it) {
 		/*
 		 * We cannot overwrite existing page tables with an NX
@@ -2884,7 +2883,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		 */
 		if (nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(*it.sptep, gfn, it.level,
-						   &pfn, &level);
+						   &kpf->pfn, &level);
 
 		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
@@ -2896,15 +2895,15 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 					      it.level - 1, true, ACC_ALL);
 
 			link_shadow_page(vcpu, it.sptep, sp);
-			if (is_tdp && huge_page_disallowed &&
+			if (kpf->is_tdp && huge_page_disallowed &&
 			    req_level >= it.level)
 				account_huge_nx_page(vcpu->kvm, sp);
 		}
 	}
 
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
-			   write, level, base_gfn, pfn, prefault,
-			   map_writable);
+			   kpf->write_fault, level, base_gfn, kpf->pfn, kpf->prefault,
+			   kpf->map_writable);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
 
@@ -3697,7 +3696,6 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 	u32 error_code = kpf->error_code;
 	bool prefault = kpf->prefault;
 	int max_level = kpf->max_level;
-	bool is_tdp = kpf->is_tdp;
 
 	unsigned long mmu_seq;
 	int r;
@@ -3742,8 +3740,7 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, kpf->map_writable,
 				    max_level, kpf->pfn, prefault);
 	else
-		r = __direct_map(vcpu, gpa, error_code, kpf->map_writable,
-				 max_level, kpf->pfn, prefault, is_tdp);
+		r = __direct_map(kpf);
 
 out_unlock:
 	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
-- 
2.25.1

