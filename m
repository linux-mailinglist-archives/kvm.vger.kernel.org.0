Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F642B4F85
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388573AbgKPSa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:30:27 -0500
Received: from mga06.intel.com ([134.134.136.31]:20648 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388248AbgKPS2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:13 -0500
IronPort-SDR: IFc14gUO2Z21yk1tOapc5cJMFA4y1hLL5SXcpeOQWMhDpfcFFWbJyqwryajO4U+H/+7NMVOU91
 lDbJ2k2zBY7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410060"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410060"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:12 -0800
IronPort-SDR: AGHO0QW4ocQG/biBs+I4G+pVYmbyPqPWn2A7phsCgJeVBECckmj1ZtRt5wvYmJ6g9ba3aXxdjU
 +BgY8hssPPfA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528182"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:11 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 42/67] KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
Date:   Mon, 16 Nov 2020 10:26:27 -0800
Message-Id: <bb0705a54354544f525e683509ce8275dedcf5b9.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

When adding pages prior to boot, TDX will need the resulting host pfn so
that it can be passed to TDADDPAGE (TDX-SEAM always works with physical
addresses as it has its own page tables).  Start plumbing pfn back up
the page fault stack.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e4e0c883b52d..474173bceb54 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3916,14 +3916,14 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			     bool prefault, int max_level, bool is_tdp)
+			     bool prefault, int max_level, bool is_tdp,
+			     kvm_pfn_t *pfn)
 {
 	bool write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
 	gfn_t gfn = vcpu_gpa_to_gfn_unalias(vcpu, gpa);
 	unsigned long mmu_seq;
-	kvm_pfn_t pfn;
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
@@ -3942,10 +3942,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, gpa, pfn, write, &map_writable))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, *pfn, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
@@ -3958,25 +3958,27 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
-				    pfn, prefault);
+				    *pfn, prefault);
 	else
-		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
-				 prefault, is_tdp);
+		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level,
+				 *pfn, prefault, is_tdp);
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
+	kvm_release_pfn_clean(*pfn);
 	return r;
 }
 
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 				u32 error_code, bool prefault)
 {
+	kvm_pfn_t pfn;
+
 	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
-				 PG_LEVEL_2M, false);
+				 PG_LEVEL_2M, false, &pfn);
 }
 
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
@@ -4015,6 +4017,7 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault)
 {
+	kvm_pfn_t pfn;
 	int max_level;
 
 	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
@@ -4028,7 +4031,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	}
 
 	return direct_page_fault(vcpu, gpa, error_code, prefault,
-				 max_level, true);
+				 max_level, true, &pfn);
 }
 
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
-- 
2.17.1

