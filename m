Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A741159DB
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfLFX6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:58:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:55584 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbfLFX5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530361"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] KVM: x86/mmu: Move transparent_hugepage_adjust() above __direct_map()
Date:   Fri,  6 Dec 2019 15:57:25 -0800
Message-Id: <20191206235729.29263-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move thp_adjust() above __direct_map() in preparation of calling
thp_adjust() from  __direct_map() and FNAME(fetch).

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 76 +++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 929fca02b075..49e5d48e7327 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3324,6 +3324,44 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
+static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
+					gfn_t gfn, kvm_pfn_t *pfnp,
+					int *levelp)
+{
+	kvm_pfn_t pfn = *pfnp;
+	int level = *levelp;
+
+	/*
+	 * Check if it's a transparent hugepage. If this would be an
+	 * hugetlbfs page, level wouldn't be set to
+	 * PT_PAGE_TABLE_LEVEL and there would be no adjustment done
+	 * here.
+	 */
+	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
+	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
+	    PageTransCompoundMap(pfn_to_page(pfn))) {
+		unsigned long mask;
+		/*
+		 * mmu_notifier_retry was successful and we hold the
+		 * mmu_lock here, so the pmd can't become splitting
+		 * from under us, and in turn
+		 * __split_huge_page_refcount() can't run from under
+		 * us and we can safely transfer the refcount from
+		 * PG_tail to PG_head as we switch the pfn to tail to
+		 * head.
+		 */
+		*levelp = level = PT_DIRECTORY_LEVEL;
+		mask = KVM_PAGES_PER_HPAGE(level) - 1;
+		VM_BUG_ON((gfn & mask) != (pfn & mask));
+		if (pfn & mask) {
+			kvm_release_pfn_clean(pfn);
+			pfn &= ~mask;
+			kvm_get_pfn(pfn);
+			*pfnp = pfn;
+		}
+	}
+}
+
 static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
 				       gfn_t gfn, kvm_pfn_t *pfnp, int *levelp)
 {
@@ -3414,44 +3452,6 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 	return -EFAULT;
 }
 
-static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
-					gfn_t gfn, kvm_pfn_t *pfnp,
-					int *levelp)
-{
-	kvm_pfn_t pfn = *pfnp;
-	int level = *levelp;
-
-	/*
-	 * Check if it's a transparent hugepage. If this would be an
-	 * hugetlbfs page, level wouldn't be set to
-	 * PT_PAGE_TABLE_LEVEL and there would be no adjustment done
-	 * here.
-	 */
-	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
-	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
-	    PageTransCompoundMap(pfn_to_page(pfn))) {
-		unsigned long mask;
-		/*
-		 * mmu_notifier_retry was successful and we hold the
-		 * mmu_lock here, so the pmd can't become splitting
-		 * from under us, and in turn
-		 * __split_huge_page_refcount() can't run from under
-		 * us and we can safely transfer the refcount from
-		 * PG_tail to PG_head as we switch the pfn to tail to
-		 * head.
-		 */
-		*levelp = level = PT_DIRECTORY_LEVEL;
-		mask = KVM_PAGES_PER_HPAGE(level) - 1;
-		VM_BUG_ON((gfn & mask) != (pfn & mask));
-		if (pfn & mask) {
-			kvm_release_pfn_clean(pfn);
-			pfn &= ~mask;
-			kvm_get_pfn(pfn);
-			*pfnp = pfn;
-		}
-	}
-}
-
 static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 				kvm_pfn_t pfn, unsigned access, int *ret_val)
 {
-- 
2.24.0

