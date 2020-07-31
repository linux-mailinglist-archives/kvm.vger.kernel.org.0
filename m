Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6922A234CE8
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgGaVXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:23:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:50227 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgGaVX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:23:29 -0400
IronPort-SDR: 6U13IaOWIutveJZigExAcIaX+/xN9fxwDw2b9eZyQD0mwUtcTqVENFG4APuxcKr3Es883OV1zB
 0C8Xzx/56SsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="151075132"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="151075132"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 14:23:27 -0700
IronPort-SDR: 0dxITT+mw/DBoc2cD0a1KPHakQR7T57+QAoK254zJ3Nu/6obst6UuBtT9jiCX5LntxjXmx4SjO
 70KVutgnY2sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="331191311"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2020 14:23:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 6/8] KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
Date:   Fri, 31 Jul 2020 14:23:21 -0700
Message-Id: <20200731212323.21746-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When adding pages prior to boot, SEV needs to pin the resulting host pfn
so that the pages that are consumed by sev_launch_update_data() are not
moved after the memory is encrypted, which would corrupt the guest data.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cab3b2f2f49c3..92b133d7b1713 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4156,7 +4156,8 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 }
 
 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-			     bool prefault, int max_level, bool is_tdp)
+			     bool prefault, int max_level, bool is_tdp,
+			     kvm_pfn_t *pfn)
 {
 	bool write = error_code & PFERR_WRITE_MASK;
 	bool exec = error_code & PFERR_FETCH_MASK;
@@ -4165,7 +4166,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
-	kvm_pfn_t pfn;
 	int r;
 
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
@@ -4184,10 +4184,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
+	if (try_async_pf(vcpu, prefault, gfn, gpa, pfn, write, &map_writable))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, *pfn, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
@@ -4197,23 +4197,25 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
+	r = __direct_map(vcpu, gpa, write, map_writable, max_level, *pfn,
 			 prefault, is_tdp && lpage_disallowed);
 
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
@@ -4252,6 +4254,7 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault)
 {
+	kvm_pfn_t pfn;
 	int max_level;
 
 	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
@@ -4265,7 +4268,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	}
 
 	return direct_page_fault(vcpu, gpa, error_code, prefault,
-				 max_level, true);
+				 max_level, true, &pfn);
 }
 
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
-- 
2.28.0

