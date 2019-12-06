Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7BAF1159E8
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLFX6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:58:39 -0500
Received: from mga07.intel.com ([134.134.136.100]:55586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfLFX5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530337"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] KVM: x86/mmu: Refactor handling of cache consistency with TDP
Date:   Fri,  6 Dec 2019 15:57:18 -0800
Message-Id: <20191206235729.29263-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pre-calculate the max level for a TDP page with respect to MTRR cache
consistency in preparation of replacing force_pt_level with max_level,
and eventually combining the bulk of nonpaging_page_fault() and
tdp_page_fault() into a common helper.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef1b7663f6ea..e4a96236aa14 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4267,16 +4267,6 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
-static bool
-check_hugepage_cache_consistency(struct kvm_vcpu *vcpu, gfn_t gfn, int level)
-{
-	int page_num = KVM_PAGES_PER_HPAGE(level);
-
-	gfn &= ~(page_num - 1);
-
-	return kvm_mtrr_check_gfn_range_consistency(vcpu, gfn, page_num);
-}
-
 static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			  bool prefault)
 {
@@ -4290,6 +4280,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	bool map_writable;
 	bool lpage_disallowed = (error_code & PFERR_FETCH_MASK) &&
 				is_nx_huge_page_enabled();
+	int max_level;
 
 	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
 
@@ -4300,14 +4291,21 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (r)
 		return r;
 
-	force_pt_level =
-		lpage_disallowed ||
-		!check_hugepage_cache_consistency(vcpu, gfn, PT_DIRECTORY_LEVEL);
+	for (max_level = PT_MAX_HUGEPAGE_LEVEL;
+	     max_level > PT_PAGE_TABLE_LEVEL;
+	     max_level--) {
+		int page_num = KVM_PAGES_PER_HPAGE(max_level);
+		gfn_t base = gfn & ~(page_num - 1);
+
+		if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
+			break;
+	}
+
+	force_pt_level = lpage_disallowed || max_level == PT_PAGE_TABLE_LEVEL;
 	level = mapping_level(vcpu, gfn, &force_pt_level);
 	if (likely(!force_pt_level)) {
-		if (level > PT_DIRECTORY_LEVEL &&
-		    !check_hugepage_cache_consistency(vcpu, gfn, level))
-			level = PT_DIRECTORY_LEVEL;
+		if (level > max_level)
+			level = max_level;
 		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}
 
-- 
2.24.0

