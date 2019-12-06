Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 482F01159ED
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLFX5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:57:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:55585 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbfLFX5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530326"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:35 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/16] KVM: x86/mmu: Move definition of make_mmu_pages_available() up
Date:   Fri,  6 Dec 2019 15:57:15 -0800
Message-Id: <20191206235729.29263-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move make_mmu_pages_available() above its first user to put it closer
to related code and eliminate a forward declaration.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3977c2b7e8e5..e2792305ce32 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2899,6 +2899,26 @@ static bool prepare_zap_oldest_mmu_page(struct kvm *kvm,
 	return kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 }
 
+static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
+{
+	LIST_HEAD(invalid_list);
+
+	if (likely(kvm_mmu_available_pages(vcpu->kvm) >= KVM_MIN_FREE_MMU_PAGES))
+		return 0;
+
+	while (kvm_mmu_available_pages(vcpu->kvm) < KVM_REFILL_PAGES) {
+		if (!prepare_zap_oldest_mmu_page(vcpu->kvm, &invalid_list))
+			break;
+
+		++vcpu->kvm->stat.mmu_recycled;
+	}
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+
+	if (!kvm_mmu_available_pages(vcpu->kvm))
+		return -ENOSPC;
+	return 0;
+}
+
 /*
  * Changing the number of mmu pages allocated to the vm
  * Note: if goal_nr_mmu_pages is too small, you will get dead lock
@@ -3636,7 +3656,6 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, int level,
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
 			 bool *writable);
-static int make_mmu_pages_available(struct kvm_vcpu *vcpu);
 
 static int nonpaging_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			 gfn_t gfn, bool prefault)
@@ -5507,26 +5526,6 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
 
-static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
-{
-	LIST_HEAD(invalid_list);
-
-	if (likely(kvm_mmu_available_pages(vcpu->kvm) >= KVM_MIN_FREE_MMU_PAGES))
-		return 0;
-
-	while (kvm_mmu_available_pages(vcpu->kvm) < KVM_REFILL_PAGES) {
-		if (!prepare_zap_oldest_mmu_page(vcpu->kvm, &invalid_list))
-			break;
-
-		++vcpu->kvm->stat.mmu_recycled;
-	}
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
-
-	if (!kvm_mmu_available_pages(vcpu->kvm))
-		return -ENOSPC;
-	return 0;
-}
-
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
-- 
2.24.0

