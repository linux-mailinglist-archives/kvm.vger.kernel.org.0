Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3734E365660
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhDTKmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:34980 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231676AbhDTKmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:15 -0400
IronPort-SDR: TSVSRA43u1ky5eM30/77mR30WZhJVaambscMIBU/TYbNaUrpL1pHqltewNv2C9Rxcc/iPtgSNZ
 pM2iwsVZmvWw==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590753"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590753"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:44 -0700
IronPort-SDR: O6ZDerzSrXnynP9aZdQoiGklnGaYhDwGmlS6BzkYHvDo4trYaAUoAwZqXlUvM3AiBG3UV4alrm
 oCZ4u2TdoE5Q==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872768"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:44 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     isaku.yamahata@gmail.com, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [RFC PATCH 03/10] KVM: x86/mmu: make direct_page_fault() receive single argument
Date:   Tue, 20 Apr 2021 03:39:13 -0700
Message-Id: <a01b3306e68fd85a60ffa86db94f5c1d243f9bb2.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert direct_page_fault() to receive struct kvm_page_fault instead of
many arguments.

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h     | 10 ++++++++++
 arch/x86/kvm/mmu/mmu.c | 32 ++++++++++++++++++++------------
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 7fcd9c147e63..fa3b1df502e7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -112,6 +112,11 @@ struct kvm_page_fault {
 	gpa_t cr2_or_gpa;
 	u32 error_code;
 	bool prefault;
+
+	/* internal state */
+	gfn_t gfn;
+	bool is_tdp;
+	int max_level;
 };
 
 static inline void kvm_page_fault_init(
@@ -122,6 +127,11 @@ static inline void kvm_page_fault_init(
 	kpf->cr2_or_gpa = cr2_or_gpa;
 	kpf->error_code = error_code;
 	kpf->prefault = prefault;
+
+	/* default value */
+	kpf->is_tdp = false;
+	kpf->gfn = cr2_or_gpa >> PAGE_SHIFT;
+	kpf->max_level = PG_LEVEL_4K;
 }
 
 int kvm_tdp_page_fault(struct kvm_page_fault *kpf);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 46998cfabfd3..cb90148f90af 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3681,13 +3681,18 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 	return false;
 }
 
-static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			     bool prefault, int max_level, bool is_tdp)
-{
+static int direct_page_fault(struct kvm_page_fault *kpf)
+{
+	struct kvm_vcpu *vcpu = kpf->vcpu;
+	gpa_t gpa = kpf->cr2_or_gpa;
+	u32 error_code = kpf->error_code;
+	bool prefault = kpf->prefault;
+	int max_level = kpf->max_level;
+	bool is_tdp = kpf->is_tdp;
 	bool write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
-	gfn_t gfn = gpa >> PAGE_SHIFT;
+	gfn_t gfn = kpf->gfn;
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
 	hva_t hva;
@@ -3750,10 +3755,12 @@ static int nonpaging_page_fault(struct kvm_page_fault *kpf)
 	pgprintk("%s: gva %lx error %x\n", __func__,
 		 kpf->cr2_or_gpa, kpf->error_code);
 
+	kpf->cr2_or_gpa &= PAGE_MASK;
+	kpf->is_tdp = false;
+	kpf->max_level = PG_LEVEL_2M;
+
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
-	return direct_page_fault(kpf->vcpu, kpf->cr2_or_gpa & PAGE_MASK,
-				 kpf->error_code,
-				 kpf->prefault, PG_LEVEL_2M, false);
+	return direct_page_fault(kpf);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -3791,21 +3798,22 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
 int kvm_tdp_page_fault(struct kvm_page_fault *kpf)
 {
-	u32 gpa = kpf->cr2_or_gpa;
+	struct kvm_vcpu *vcpu = kpf->vcpu;
 	int max_level;
+	kpf->is_tdp = true;
 
 	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
 	     max_level > PG_LEVEL_4K;
 	     max_level--) {
 		int page_num = KVM_PAGES_PER_HPAGE(max_level);
-		gfn_t base = (gpa >> PAGE_SHIFT) & ~(page_num - 1);
+		gfn_t base = kpf->gfn & ~(page_num - 1);
 
-		if (kvm_mtrr_check_gfn_range_consistency(kpf->vcpu, base, page_num))
+		if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
 			break;
 	}
+	kpf->max_level = max_level;
 
-	return direct_page_fault(kpf->vcpu, gpa, kpf->error_code, kpf->prefault,
-				 max_level, true);
+	return direct_page_fault(kpf);
 }
 
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
-- 
2.25.1

