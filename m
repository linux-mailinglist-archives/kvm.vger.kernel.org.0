Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE3918DA36
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgCTV3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:29:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:37248 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727427AbgCTV27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:59 -0400
IronPort-SDR: hDBIBoP1LJco6d+MzlONIICOZ0/VteIcfLZespU6D6Uz3f+8MFtdvYuzPioWRJflTQTimi/pFr
 wKhUq/ZEqQaQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:58 -0700
IronPort-SDR: Ec55i9VaJapG7fqOHRFQiTO8nlU7Dwo4cdWU0gTLqzk5iDPoZjGG5QRwKnE30L1EeivcbsCwBB
 Z9dqUQyPR2jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224512"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 30/37] KVM: x86/mmu: Move fast_cr3_switch() side effects to __kvm_mmu_new_cr3()
Date:   Fri, 20 Mar 2020 14:28:26 -0700
Message-Id: <20200320212833.3507-31-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle the side effects of a fast CR3 (PGD) switch up a level in
__kvm_mmu_new_cr3(), which is the only caller of fast_cr3_switch().

This consolidates handling all side effects in __kvm_mmu_new_cr3()
(where freeing the current root when KVM can't do a fast switch is
already handled), and ameliorates the pain of adding a second boolean in
a future patch to provide a separate "skip" override for the MMU sync.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 69 +++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 97d906a42e81..b95933198f4c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4288,8 +4288,7 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 }
 
 static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
-			    union kvm_mmu_page_role new_role,
-			    bool skip_tlb_flush)
+			    union kvm_mmu_page_role new_role)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 
@@ -4299,39 +4298,9 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 	 * later if necessary.
 	 */
 	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
-	    mmu->root_level >= PT64_ROOT_4LEVEL) {
-		if (mmu_check_root(vcpu, new_cr3 >> PAGE_SHIFT))
-			return false;
-
-		if (cached_root_available(vcpu, new_cr3, new_role)) {
-			/*
-			 * It is possible that the cached previous root page is
-			 * obsolete because of a change in the MMU generation
-			 * number. However, changing the generation number is
-			 * accompanied by KVM_REQ_MMU_RELOAD, which will free
-			 * the root set here and allocate a new one.
-			 */
-			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
-			if (!skip_tlb_flush) {
-				kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-				kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-			}
-
-			/*
-			 * The last MMIO access's GVA and GPA are cached in the
-			 * VCPU. When switching to a new CR3, that GVA->GPA
-			 * mapping may no longer be valid. So clear any cached
-			 * MMIO info even when we don't need to sync the shadow
-			 * page tables.
-			 */
-			vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
-
-			__clear_sp_write_flooding_count(
-				page_header(mmu->root_hpa));
-
-			return true;
-		}
-	}
+	    mmu->root_level >= PT64_ROOT_4LEVEL)
+		return !mmu_check_root(vcpu, new_cr3 >> PAGE_SHIFT) &&
+		       cached_root_available(vcpu, new_cr3, new_role);
 
 	return false;
 }
@@ -4340,9 +4309,33 @@ static void __kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 			      union kvm_mmu_page_role new_role,
 			      bool skip_tlb_flush)
 {
-	if (!fast_cr3_switch(vcpu, new_cr3, new_role, skip_tlb_flush))
-		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu,
-				   KVM_MMU_ROOT_CURRENT);
+	if (!fast_cr3_switch(vcpu, new_cr3, new_role)) {
+		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
+		return;
+	}
+
+	/*
+	 * It's possible that the cached previous root page is obsolete because
+	 * of a change in the MMU generation number. However, changing the
+	 * generation number is accompanied by KVM_REQ_MMU_RELOAD, which will
+	 * free the root set here and allocate a new one.
+	 */
+	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
+
+	if (!skip_tlb_flush) {
+		kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+	}
+
+	/*
+	 * The last MMIO access's GVA and GPA are cached in the VCPU. When
+	 * switching to a new CR3, that GVA->GPA mapping may no longer be
+	 * valid. So clear any cached MMIO info even when we don't need to sync
+	 * the shadow page tables.
+	 */
+	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
+
+	__clear_sp_write_flooding_count(page_header(vcpu->arch.mmu->root_hpa));
 }
 
 void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush)
-- 
2.24.1

