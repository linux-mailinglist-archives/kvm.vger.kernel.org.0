Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8490A2760C9
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 21:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgIWTMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 15:12:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:12738 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgIWTMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 15:12:06 -0400
IronPort-SDR: bQpuDFpeaUtbVXtIzXjyomjU6HSf44kNzG2S6wf2pFY2qgS6cmLIj+EX9BkC4aheDQpG6UN24D
 8yrjCukqmibw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160281225"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160281225"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 12:12:06 -0700
IronPort-SDR: UclwOekwO5FlzgPqU/RilPEY6TTNa3q+D2KirpX+ICPG7WI0atvKS5bbr7dg+bupcbOIdH8JHr
 rK1Z9PYNgdcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="382788351"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga001.jf.intel.com with ESMTP; 23 Sep 2020 12:12:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Stash 'kvm' in a local variable in kvm_mmu_free_roots()
Date:   Wed, 23 Sep 2020 12:12:04 -0700
Message-Id: <20200923191204.8410-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make kvm_mmu_free_roots() a bit more readable, capture 'kvm' in a
local variable instead of doing vcpu->kvm over and over (and over).

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76c5826e29a2..cdc498093450 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3603,6 +3603,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			ulong roots_to_free)
 {
+	struct kvm *kvm = vcpu->kvm;
 	int i;
 	LIST_HEAD(invalid_list);
 	bool free_active_root = roots_to_free & KVM_MMU_ROOT_CURRENT;
@@ -3620,22 +3621,21 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			return;
 	}
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	spin_lock(&kvm->mmu_lock);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		if (roots_to_free & KVM_MMU_ROOT_PREVIOUS(i))
-			mmu_free_root_page(vcpu->kvm, &mmu->prev_roots[i].hpa,
+			mmu_free_root_page(kvm, &mmu->prev_roots[i].hpa,
 					   &invalid_list);
 
 	if (free_active_root) {
 		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
-			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
-					   &invalid_list);
+			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
 		} else {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
-					mmu_free_root_page(vcpu->kvm,
+					mmu_free_root_page(kvm,
 							   &mmu->pae_root[i],
 							   &invalid_list);
 			mmu->root_hpa = INVALID_PAGE;
@@ -3643,8 +3643,8 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		mmu->root_pgd = 0;
 	}
 
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	spin_unlock(&kvm->mmu_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
 
-- 
2.28.0

