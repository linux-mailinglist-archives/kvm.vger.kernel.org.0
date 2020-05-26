Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6814B1BB40B
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 04:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgD1ChR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 22:37:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:33262 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbgD1ChR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 22:37:17 -0400
IronPort-SDR: tGAIC0enJoA0wxwuf4kui24US322IphnHaTeNbmpn+D4SwOZt4XDCNUsr6kmL3/6QPzuCF5qo/
 WTg2MfzPTFOQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 19:37:16 -0700
IronPort-SDR: MHLSgb9QfWHzePzjt1owK0AshxqFJh558djI8oFxWgEm2rDWlGg9X+DZsSzzQC0bKNUwjk1aNN
 cssbVFYB644w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,326,1583222400"; 
   d="scan'208";a="281991138"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 27 Apr 2020 19:37:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Add a helper to consolidate root sp allocation
Date:   Mon, 27 Apr 2020 19:37:14 -0700
Message-Id: <20200428023714.31923-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper, mmu_alloc_root(), to consolidate the allocation of a root
shadow page, which has the same basic mechanics for all flavors of TDP
and shadow paging.

Note, __pa(sp->spt) doesn't need to be protected by mmu_lock, sp->spt
points at a kernel page.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 88 +++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e618472c572b..80205aea296e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3685,37 +3685,43 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 	return ret;
 }
 
+static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
+			    u8 level, bool direct)
+{
+	struct kvm_mmu_page *sp;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+
+	if (make_mmu_pages_available(vcpu)) {
+		spin_unlock(&vcpu->kvm->mmu_lock);
+		return INVALID_PAGE;
+	}
+	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
+	++sp->root_count;
+
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	return __pa(sp->spt);
+}
+
 static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *sp;
+	u8 shadow_root_level = vcpu->arch.mmu->shadow_root_level;
+	hpa_t root;
 	unsigned i;
 
-	if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
-		spin_lock(&vcpu->kvm->mmu_lock);
-		if(make_mmu_pages_available(vcpu) < 0) {
-			spin_unlock(&vcpu->kvm->mmu_lock);
+	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
+		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
+		if (!VALID_PAGE(root))
 			return -ENOSPC;
-		}
-		sp = kvm_mmu_get_page(vcpu, 0, 0,
-				vcpu->arch.mmu->shadow_root_level, 1, ACC_ALL);
-		++sp->root_count;
-		spin_unlock(&vcpu->kvm->mmu_lock);
-		vcpu->arch.mmu->root_hpa = __pa(sp->spt);
-	} else if (vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL) {
+		vcpu->arch.mmu->root_hpa = root;
+	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
-			hpa_t root = vcpu->arch.mmu->pae_root[i];
+			MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
 
-			MMU_WARN_ON(VALID_PAGE(root));
-			spin_lock(&vcpu->kvm->mmu_lock);
-			if (make_mmu_pages_available(vcpu) < 0) {
-				spin_unlock(&vcpu->kvm->mmu_lock);
+			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
+					      i << 30, PT32_ROOT_LEVEL, true);
+			if (!VALID_PAGE(root))
 				return -ENOSPC;
-			}
-			sp = kvm_mmu_get_page(vcpu, i << (30 - PAGE_SHIFT),
-					i << 30, PT32_ROOT_LEVEL, 1, ACC_ALL);
-			root = __pa(sp->spt);
-			++sp->root_count;
-			spin_unlock(&vcpu->kvm->mmu_lock);
 			vcpu->arch.mmu->pae_root[i] = root | PT_PRESENT_MASK;
 		}
 		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
@@ -3730,9 +3736,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *sp;
 	u64 pdptr, pm_mask;
 	gfn_t root_gfn, root_pgd;
+	hpa_t root;
 	int i;
 
 	root_pgd = vcpu->arch.mmu->get_guest_pgd(vcpu);
@@ -3746,20 +3752,12 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * write-protect the guests page table root.
 	 */
 	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
-		hpa_t root = vcpu->arch.mmu->root_hpa;
+		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->root_hpa));
 
-		MMU_WARN_ON(VALID_PAGE(root));
-
-		spin_lock(&vcpu->kvm->mmu_lock);
-		if (make_mmu_pages_available(vcpu) < 0) {
-			spin_unlock(&vcpu->kvm->mmu_lock);
+		root = mmu_alloc_root(vcpu, root_gfn, 0,
+				      vcpu->arch.mmu->shadow_root_level, false);
+		if (!VALID_PAGE(root))
 			return -ENOSPC;
-		}
-		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
-				vcpu->arch.mmu->shadow_root_level, 0, ACC_ALL);
-		root = __pa(sp->spt);
-		++sp->root_count;
-		spin_unlock(&vcpu->kvm->mmu_lock);
 		vcpu->arch.mmu->root_hpa = root;
 		goto set_root_pgd;
 	}
@@ -3774,9 +3772,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
 	for (i = 0; i < 4; ++i) {
-		hpa_t root = vcpu->arch.mmu->pae_root[i];
-
-		MMU_WARN_ON(VALID_PAGE(root));
+		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
 		if (vcpu->arch.mmu->root_level == PT32E_ROOT_LEVEL) {
 			pdptr = vcpu->arch.mmu->get_pdptr(vcpu, i);
 			if (!(pdptr & PT_PRESENT_MASK)) {
@@ -3787,17 +3783,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			if (mmu_check_root(vcpu, root_gfn))
 				return 1;
 		}
-		spin_lock(&vcpu->kvm->mmu_lock);
-		if (make_mmu_pages_available(vcpu) < 0) {
-			spin_unlock(&vcpu->kvm->mmu_lock);
-			return -ENOSPC;
-		}
-		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30, PT32_ROOT_LEVEL,
-				      0, ACC_ALL);
-		root = __pa(sp->spt);
-		++sp->root_count;
-		spin_unlock(&vcpu->kvm->mmu_lock);
 
+		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
+				      PT32_ROOT_LEVEL, false);
+		if (!VALID_PAGE(root))
+			return -ENOSPC;
 		vcpu->arch.mmu->pae_root[i] = root | pm_mask;
 	}
 	vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
-- 
2.26.0

